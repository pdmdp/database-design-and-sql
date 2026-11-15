"""Run submitted SQL against a small, independent synthetic fixture."""
from pathlib import Path
import sqlite3
import unittest
import duckdb

ROOT=Path(__file__).resolve().parents[1]
QUERIES=[q.strip() for q in (ROOT/'02-queries/queries.sql').read_text().split(';') if q.strip()]
MEASURES=[q.strip() for q in (ROOT/'03-data-warehouse/measures.sql').read_text().split(';') if q.strip()]

class QuerySemantics(unittest.TestCase):
    def setUp(self):
        self.db=duckdb.connect(':memory:')
        self.db.execute((ROOT/'tests/fixture.sql').read_text())
    def tearDown(self):
        self.db.close()
    def rows(self, number):
        return self.db.execute(QUERIES[number-1]).fetchall()
    def test_eight_queries(self):
        self.assertEqual(len(QUERIES),8)
        expected=[{('Ada',),('Bruno',)}, {(101,),(102,)}, {(201,),(203,)},
                  {(2,),(3,)}, {('V01',1),('V02',1),('V03',1),('V04',0),('V05',1),('V06',0)},
                  {('V01',)}, {('V01',),('V04',),('V05',),('V06',)}, {('P1',),('P2',),('P3',)}]
        for n,want in enumerate(expected,1):
            with self.subTest(query=n):self.assertEqual(set(self.rows(n)),want)
        self.assertEqual(self.rows(8)[0],('P1',))
    def test_no_funding(self):
        self.db.execute('DELETE FROM fundings')
        self.assertEqual(self.rows(3),[])
        self.assertEqual(set(self.rows(4)),{(1,),(2,),(3,)})
    def test_no_memberships(self):
        self.db.execute('DELETE FROM memberships')
        for n in (1,2,6,8):
            with self.subTest(query=n):self.assertEqual(self.rows(n),[])
        self.assertEqual(set(self.rows(5)),{(f'V{i:02}',0) for i in range(1,7)})
        self.assertEqual(set(self.rows(7)),{(f'V{i:02}',) for i in range(1,7)})
    def test_no_eligible_party(self):
        self.db.execute('DELETE FROM committee_members WHERE committee_id IN (202,204)')
        self.assertEqual(self.rows(6),[])
    def test_top_rank_ties(self):
        self.db.execute("INSERT INTO memberships VALUES ('V06','P2','2025-02-01',101)")
        rows=self.rows(8)
        self.assertEqual(set(rows[:2]),{('P1',),('P2',)})
        self.assertEqual(rows[2:], [('P3',)])
    def test_zero_member_parties_are_absent_from_submitted_query(self):
        self.db.execute("DELETE FROM memberships WHERE memb_party <> 'P1'")
        self.assertEqual(self.rows(8), [('P1',)])
    def test_warehouse_measures(self):
        self.assertEqual(len(MEASURES),2)
        got=[]
        for sql in MEASURES:
            got.append({(str(a),str(b),c,d):v for a,b,c,d,v in self.db.execute(sql).fetchall()})
        self.assertEqual(got[0],{('2024-05-01','2024-06-01',1,'P1'):250,
                                 ('2025-05-01','2025-06-01',1,'P1'):100,
                                 ('2024-05-01','2024-06-01',2,'P2'):205})
        self.assertEqual(got[1],{('2024-05-01','2024-06-01',1,'P1'):2,
                                 ('2025-05-01','2025-06-01',1,'P1'):1,
                                 ('2024-05-01','2024-06-01',2,'P2'):2})

class SubmittedSchema(unittest.TestCase):
    def test_ddl_and_cascading_subtype(self):
        # A SQLite smoke check of the transcribed DDL, not PostgreSQL integration.
        with sqlite3.connect(':memory:') as db:
            db.execute('PRAGMA foreign_keys=ON')
            db.executescript((ROOT/'01-relational-design/schema.sql').read_text())
            self.assertEqual(db.execute("SELECT count(*) FROM sqlite_master WHERE type='table'").fetchone()[0],15)
            db.execute("INSERT INTO political_parties VALUES ('P1',2000)")
            db.execute("INSERT INTO committe_members VALUES ('C1','2024-01-01','P1')")
            db.execute("INSERT INTO officials VALUES ('C1')")
            db.execute("DELETE FROM committe_members WHERE member_id='C1'")
            self.assertEqual(db.execute('SELECT * FROM officials').fetchall(),[])

if __name__=='__main__':unittest.main()
