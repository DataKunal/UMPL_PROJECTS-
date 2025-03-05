use Internship_projects;
select* from accident;
alter table accident rename column `Million Plus Cities` to City;
ALTER TABLE accident  
RENAME COLUMN `Cause category` TO CauseCategory,  
RENAME COLUMN `Cause Subcategory` TO CauseSubcategory,  
RENAME COLUMN `Outcome of Incident` TO Outcome;


-- Road Accident Data Analysis Using SQL

-- Step 1: Data Cleaning
-- Remove duplicate records
CREATE TEMPORARY TABLE temp_accidents AS 
SELECT * FROM (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY City, CauseCategory, CauseSubcategory, Outcome ORDER BY City) AS row_num
    FROM accident
) AS subquery
WHERE row_num > 1;

DELETE FROM accident 
WHERE (City, CauseCategory, CauseSubcategory, Outcome) IN 
    (SELECT City, CauseCategory, CauseSubcategory, Outcome FROM temp_accidents);


-- Step 2: Exploratory Data Analysis (EDA)

-- 1. Total Accidents by City
SELECT City, SUM(count) AS total_accidents
FROM accident
GROUP BY City
ORDER BY total_accidents DESC
LIMIT 10;

-- 2. Distribution of Accidents by Cause Category
SELECT CauseCategory, SUM(count) AS total_accidents
FROM accident
GROUP BY CauseCategory
ORDER BY total_accidents DESC;

-- 3. Distribution of Accidents by Cause Subcategory
SELECT CauseSubcategory, SUM(count) AS total_accidents
FROM accident
GROUP BY CauseSubcategory
ORDER BY total_accidents DESC
LIMIT 10;

-- 4. Outcomes of Incidents
SELECT Outcome, SUM(count) AS total_cases
FROM accident
GROUP BY Outcome
ORDER BY total_cases DESC;

-- 5. Most Dangerous Cities (Highest Fatal Accidents)
SELECT City, SUM(count) AS fatal_accidents
FROM accident
WHERE Outcome = 'Persons Killed'
GROUP BY City
ORDER BY fatal_accidents DESC
LIMIT 10;

-- 6. Cause Categories Leading to Most Fatalities
SELECT CauseCategory, SUM(count) AS fatal_count
FROM accident
WHERE Outcome = 'Persons Killed'
GROUP BY CauseCategory
ORDER BY fatal_count DESC;

-- 7. Most Common Accidents per City
SELECT City, CauseCategory, SUM(count) AS total_accidents
FROM accident
GROUP BY City, CauseCategory
ORDER BY total_accidents DESC;

-- 8. Cities with the Most Injuries
SELECT City, SUM(count) AS total_injuries
FROM accident
WHERE Outcome IN ('Greviously Injured', 'Minor Injury', 'Total Injured')
GROUP BY City
ORDER BY total_injuries DESC
LIMIT 10;

-- 9. Relationship Between Cause Category and Outcomes
SELECT CauseCategory, Outcome, SUM(count) AS total_cases
FROM accident
GROUP BY CauseCategory, Outcome
ORDER BY total_cases DESC;

-- 10. Predicting the City with the Most Accidents in the Next Year
SELECT City, SUM(count) AS predicted_accidents
FROM accident
WHERE City IN (
    SELECT City FROM accident WHERE Outcome = 'Total number of Accidents'
)
GROUP BY City
ORDER BY predicted_accidents DESC
LIMIT 1;

