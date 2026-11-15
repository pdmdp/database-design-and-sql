# Database design and SQL

Three coursework assignments on a political-membership database: relational design, SQL queries and a funding data warehouse.

| Assignment | Work | Files |
| :--- | :--- | :--- |
| Relational design | E/R model and 15-table schema | [Report](01-relational-design/report.pdf) · [DDL](01-relational-design/schema.sql) |
| SQL | Eight queries using joins, aggregates, CTEs and anti-joins | [Queries](02-queries/queries.sql) |
| Data warehouse | Attribute trees, dimensional fact model and two additive measures | [Report](03-data-warehouse/report.pdf) · [Measures](03-data-warehouse/measures.sql) |

![Submitted entity–relationship diagram](01-relational-design/er-diagram.png)

The query exercises cover ties in rankings, date boundaries, empty groups and universal conditions. For example, finding voters whose memberships all belong to coalition parties must also return voters with no memberships. The funding measures aggregate amounts and counts by funding day, election date, coalition and party.

## Run the checks

```bash
git clone https://github.com/pdmdp/database-design-and-sql.git
cd database-design-and-sql
python -m pip install -r requirements.txt
python -m unittest discover -s tests -v
```

The November 2026 tests use a small synthetic fixture with fictional identifiers. They check all eight submitted queries, ranking ties, zero memberships, missing funding, the date cutoff and warehouse totals. Query semantics are tested with DuckDB 1.5.1; the transcribed DDL has a separate SQLite creation and cascade check. The course used PostgreSQL, which has not been integration-tested here.

## Reading the submission

These are three related assignments, not a single migration chain. The query and warehouse exercises use the instructor's supplied schema; its names differ from my first design. The test fixture models only the columns needed by those queries.

The original SQL and reports are preserved. Two limitations are worth keeping explicit: the first design does not enforce the exclusive and exhaustive official/candidate subtype constraint in SQL, and query 8 ranks only parties represented in `memberships`. Zero-member parties are omitted, even when zero would be the second distinct count.

**Matteo Pietro Di Pilato** · Data and Knowledge Bases, BSc in Artificial Intelligence, 2025/26. [Source checksums](source-manifest.json) identify the submitted files; the test fixture and checks were added for this repository.
