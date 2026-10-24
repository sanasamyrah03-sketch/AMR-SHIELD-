# AMR-SHIELD: WHO Antimicrobial Resistance Trend Explorer

A beginner-friendly SQL portfolio project using MySQL to explore selected published antimicrobial resistance (AMR) trend estimates reported by the World Health Organization (WHO).

## Project goal

Use relational tables and SQL queries to explore estimated annual changes, identify trends marked statistically significant in the source figure, and summarize the records by pathogen.

## Dataset and source

- **Source:** World Health Organization (WHO), *Global antibiotic resistance surveillance report 2025: Summary* (2025), Figure 3, page 11.
- **DOI:** https://doi.org/10.2471/B09585
- **Period shown:** 2018–2023.
- **Records included:** 10 published pathogen–antibiotic trend estimates covering 8 pathogens.
- **Important:** These are selected published aggregate estimates transcribed from the report figure. They are not raw patient-level records or a complete surveillance dataset.
- The source figure uses an asterisk to mark statistically meaningful trends; that marking was used to populate `statistically_significant`.

The report identifies a CC BY-NC-SA 3.0 IGO licence. Reuse should follow the licence terms, include attribution, and remain non-commercial unless separate permission applies. Do not use the WHO logo.

## Database schema

### `pathogens`
- `pathogen_id` — primary key
- `pathogen_name` — pathogen name

### `amr_trends`
- `trend_id` — primary key
- `pathogen_id` — foreign key to `pathogens`
- `antibiotic`
- `annual_change_pct`
- `ci_lower`, `ci_upper` — reported confidence interval bounds
- `statistically_significant`
- `period`

## SQL concepts practised

- `CREATE DATABASE`, `CREATE TABLE`, `INSERT`
- Primary and foreign keys
- `SELECT` and column aliases
- `JOIN` and `ON`
- `WHERE`
- `ORDER BY` and `LIMIT`
- `COUNT()` and `GROUP BY`
- `HAVING`

## How to run

1. Install MySQL Server and MySQL Workbench.
2. Open `amr_shield.sql` in MySQL Workbench.
3. Review the script. **It drops and recreates the two project tables** (`amr_trends` and `pathogens`) before inserting the sample data. Do not run it in a database where you need to preserve tables with those names.
4. Execute the script. It creates/uses the `amrshield` database, creates the tables, inserts the records, and runs the example queries.
5. Expected validation counts: **10 trend records** and **8 pathogens**.

## Questions explored

1. What are the published annual change estimates by pathogen and antibiotic?
2. Which records are marked statistically significant in the source figure?
3. Which estimates are positive or negative?
4. Which record has the largest estimated annual increase?
5. How many records are significant versus non-significant?
6. How many trend records are associated with each pathogen?

## Interpretation and limitations

- `annual_change_pct` represents the reported estimated annual change, **not the percentage of samples resistant**.
- A positive estimate does not automatically mean a statistically significant increase.
- A negative estimate does not mean resistance is absent.
- Confidence intervals and the source's significance marking should be considered when interpreting the estimates.
- This small educational dataset is selected from one figure in a summary report. It is not suitable for clinical decisions or for estimating resistance in a particular hospital, region, or patient population.

## Citation

World Health Organization. *Global antibiotic resistance surveillance report 2025: Summary*. Geneva: World Health Organization; 2025. https://doi.org/10.2471/B09585

## Licence note

The source report states CC BY-NC-SA 3.0 IGO. Review the original licence and attribution requirements before redistributing adapted data or materials, especially for commercial use.
