-- AMR-SHIELD: WHO Antimicrobial Resistance Trend Explorer
-- Source: WHO, Global antibiotic resistance surveillance report 2025: Summary,
-- Figure 3, page 11. DOI: https://doi.org/10.2471/B09585
-- These are published aggregate estimates, not raw patient-level records.
-- Annual change values are percentages of annual change, NOT resistance prevalence.

CREATE DATABASE IF NOT EXISTS amrshield;
USE amrshield;

-- Drop tables in dependency order so this script can be rerun from a clean setup.
DROP TABLE IF EXISTS amr_trends;
DROP TABLE IF EXISTS pathogens;

CREATE TABLE pathogens (
    pathogen_id INT PRIMARY KEY,
    pathogen_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE amr_trends (
    trend_id INT PRIMARY KEY,
    pathogen_id INT NOT NULL,
    antibiotic VARCHAR(100) NOT NULL,
    annual_change_pct DECIMAL(5,1) NOT NULL,
    ci_lower DECIMAL(5,1) NOT NULL,
    ci_upper DECIMAL(5,1) NOT NULL,
    statistically_significant BOOLEAN NOT NULL,
    period VARCHAR(20) NOT NULL,
    CONSTRAINT fk_amr_trends_pathogens
        FOREIGN KEY (pathogen_id) REFERENCES pathogens(pathogen_id)
);

INSERT INTO pathogens (pathogen_id, pathogen_name) VALUES
(1, 'Shigella spp.'),
(2, 'Klebsiella pneumoniae'),
(3, 'Salmonella spp.'),
(4, 'Escherichia coli'),
(5, 'Acinetobacter spp.'),
(6, 'Staphylococcus aureus'),
(7, 'Neisseria gonorrhoeae'),
(8, 'Streptococcus pneumoniae');

INSERT INTO amr_trends
(trend_id, pathogen_id, antibiotic, annual_change_pct, ci_lower, ci_upper, statistically_significant, period)
VALUES
(1, 1, 'Ciprofloxacin', 27.2, -2.1, 66.1, FALSE, '2018-2023'),
(2, 2, 'Imipenem', 15.3, 12.7, 18.1, TRUE, '2018-2023'),
(3, 3, 'Ciprofloxacin', 14.0, 6.5, 22.1, TRUE, '2018-2023'),
(4, 4, 'Imipenem', 12.5, 9.4, 15.8, TRUE, '2018-2023'),
(5, 5, 'Imipenem', 5.3, 2.7, 8.3, TRUE, '2018-2023'),
(6, 4, 'Third-generation cephalosporins', 1.3, -0.1, 2.8, FALSE, '2018-2023'),
(7, 2, 'Cefotaxime', -0.3, -2.5, 1.9, FALSE, '2018-2023'),
(8, 6, 'Methicillin', -2.5, -4.5, -0.5, TRUE, '2018-2023'),
(9, 7, 'Ceftriaxone', -3.2, -33.9, 39.2, FALSE, '2018-2023'),
(10, 8, 'Penicillin G', -11.0, -26.8, 7.1, FALSE, '2018-2023');

-- QUERY 1: View all trends with pathogen names.
SELECT p.pathogen_name, a.antibiotic, a.annual_change_pct,
       a.ci_lower, a.ci_upper, a.statistically_significant, a.period
FROM amr_trends AS a
JOIN pathogens AS p ON a.pathogen_id = p.pathogen_id
ORDER BY a.annual_change_pct DESC;

-- QUERY 2: Show only statistically significant trends.
SELECT p.pathogen_name, a.antibiotic, a.annual_change_pct
FROM amr_trends AS a
JOIN pathogens AS p ON a.pathogen_id = p.pathogen_id
WHERE a.statistically_significant = TRUE
ORDER BY a.annual_change_pct DESC;

-- QUERY 3: Positive annual changes (not necessarily statistically significant).
SELECT p.pathogen_name, a.antibiotic, a.annual_change_pct,
       a.statistically_significant
FROM amr_trends AS a
JOIN pathogens AS p ON a.pathogen_id = p.pathogen_id
WHERE a.annual_change_pct > 0
ORDER BY a.annual_change_pct DESC;

-- QUERY 4: Negative annual changes.
SELECT p.pathogen_name, a.antibiotic, a.annual_change_pct,
       a.statistically_significant
FROM amr_trends AS a
JOIN pathogens AS p ON a.pathogen_id = p.pathogen_id
WHERE a.annual_change_pct < 0
ORDER BY a.annual_change_pct ASC;

-- QUERY 5: Largest estimated annual increase.
SELECT p.pathogen_name, a.antibiotic, a.annual_change_pct,
       a.ci_lower, a.ci_upper, a.statistically_significant
FROM amr_trends AS a
JOIN pathogens AS p ON a.pathogen_id = p.pathogen_id
ORDER BY a.annual_change_pct DESC
LIMIT 1;

-- QUERY 6: Count significant and non-significant records.
SELECT statistically_significant, COUNT(*) AS total
FROM amr_trends
GROUP BY statistically_significant;

-- QUERY 7: Count trend records per pathogen.
SELECT p.pathogen_name, COUNT(a.trend_id) AS total_trends
FROM pathogens AS p
JOIN amr_trends AS a ON p.pathogen_id = a.pathogen_id
GROUP BY p.pathogen_id, p.pathogen_name
ORDER BY total_trends DESC, p.pathogen_name;

-- QUERY 8: Pathogens with more than one trend record.
SELECT p.pathogen_name, COUNT(a.trend_id) AS total_trends
FROM pathogens AS p
JOIN amr_trends AS a ON p.pathogen_id = a.pathogen_id
GROUP BY p.pathogen_id, p.pathogen_name
HAVING COUNT(a.trend_id) > 1;

-- VALIDATION: expected 10 trend records and 8 pathogens.
SELECT COUNT(*) AS total_records FROM amr_trends;
SELECT COUNT(*) AS total_pathogens FROM pathogens;
