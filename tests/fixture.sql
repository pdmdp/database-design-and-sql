-- Small synthetic fixture for query semantics, added November 2026.
-- Only columns needed by the submitted queries are modeled here.
CREATE TABLE voters(voter_tax_code VARCHAR PRIMARY KEY, voter_name VARCHAR);
CREATE TABLE political_parties(party_name VARCHAR PRIMARY KEY);
CREATE TABLE officials(official_id INTEGER PRIMARY KEY);
CREATE TABLE memberships(memb_voter VARCHAR, memb_party VARCHAR, memb_join_date DATE, memb_mentor INTEGER, PRIMARY KEY(memb_voter,memb_party));
CREATE TABLE committee_members(committee_id INTEGER PRIMARY KEY, committee_party VARCHAR);
CREATE TABLE coalitions(coalition_id INTEGER PRIMARY KEY);
CREATE TABLE wings_organizations(party VARCHAR, wing VARCHAR);
CREATE TABLE parties_in_coalitions(party_name VARCHAR, coalition_id INTEGER);
CREATE TABLE elections(election_id INTEGER PRIMARY KEY, election_date DATE);
CREATE TABLE fundings(funder_coalition INTEGER, funded_committee INTEGER, funding_amount INTEGER, funding_date DATE, election_id INTEGER);
INSERT INTO voters VALUES ('V01','Ada'),('V02','Bruno'),('V03','Chiara'),('V04','Diego'),('V05','Elena'),('V06','Fabio');
INSERT INTO political_parties VALUES ('P1'),('P2'),('P3'),('P4'),('P5');
INSERT INTO officials VALUES (101),(102);
INSERT INTO memberships VALUES
('V01','P1','2020-01-01',101),('V02','P1','2020-01-01',101),
('V03','P1','2023-03-01',102),('V04','P2','2023-02-28',101),
('V01','P2','2023-04-01',102),('V02','P3','2024-01-01',101),
('V05','P4','2025-01-01',102),('V03','P3','2023-02-01',102);
INSERT INTO committee_members VALUES (201,'P1'),(202,'P1'),(203,'P2'),(204,'P2'),(205,'P3');
INSERT INTO coalitions VALUES (1),(2),(3);
INSERT INTO wings_organizations VALUES ('P1','Wing42'),('P2','Wing10');
INSERT INTO parties_in_coalitions VALUES ('P1',1),('P2',2),('P4',1);
INSERT INTO elections VALUES (1,'2024-06-01'),(2,'2025-06-01');
INSERT INTO fundings VALUES
(1,201,100,'2024-05-01',1),(1,201,100,'2025-05-01',2),
(1,202,150,'2024-05-01',1),(2,203,200,'2024-05-01',1),(2,204,5,'2024-05-01',1);
