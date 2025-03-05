
use internship_projects;
select* from `summer-olympic-medals-1976-to-2008`;
alter table  `summer-olympic-medals-1976-to-2008` rename to olympic;
select* from olympic;

-- Olympics Data Analysis Using SQL

-- Step 1: Load Data 

-- Step 2: Data Cleaning
-- Remove duplicate records
WITH duplicate_records AS (
    SELECT year, sport, discipline, event_name, athlete, gender, country, medal,
           ROW_NUMBER() OVER (PARTITION BY year, sport, discipline, event_name, athlete, gender, country, medal 
                              ORDER BY year) AS row_num
    FROM olympic
)
DELETE FROM olympic 
WHERE (year, sport, discipline, event_name, athlete, gender, country, medal) IN 
      (SELECT year, sport, discipline, event_name, athlete, gender, country, medal 
       FROM duplicate_records WHERE row_num > 1);


-- Step 3: Exploratory Data Analysis (EDA)

-- 1. Total Medals by Country
SELECT country, COUNT(medal) AS total_medals
FROM olympic
GROUP BY country
ORDER BY total_medals DESC
LIMIT 10;

-- 2. Medals Won Over the Years
SELECT year, COUNT(medal) AS total_medals
FROM olympic
GROUP BY year
ORDER BY year;

-- 3. Gender Distribution in Events
SELECT gender, COUNT(*) AS total_participation
FROM olympic
GROUP BY gender;

-- 4. Top Athletes with Most Medals
SELECT athlete, COUNT(medal) AS total_medals
FROM olympic
GROUP BY athlete
ORDER BY total_medals DESC
LIMIT 10;

-- 5. Which City Hosted the Most Olympics
SELECT city, COUNT(DISTINCT year) AS total_olympics
FROM olympic
GROUP BY city
ORDER BY total_olympics DESC
LIMIT 1;

-- 6. Which Country Won the Most Medals in Each Year
SELECT year, country, COUNT(medal) AS total_medals
FROM olympic
GROUP BY year, country
ORDER BY year, total_medals DESC;

-- 7. Most Popular Sports by Number of Events
SELECT sport, COUNT(DISTINCT event_name) AS total_event_names
FROM olympic
GROUP BY sport
ORDER BY total_event_names DESC
LIMIT 10;

-- 8. Gender Ratio in Medal-Winning Events
SELECT gender, COUNT(*) AS total_medals
FROM olympic
GROUP BY gender;

-- 9. Which Country Dominated Each Sport
SELECT sport, country, COUNT(medal) AS total_medals
FROM olympic
GROUP BY sport, country
ORDER BY sport, total_medals DESC;

-- 10. Which Athletes Won Medals in Multiple Sports
SELECT athlete, GROUP_CONCAT(DISTINCT sport ORDER BY sport SEPARATOR ', ') AS sports_played, COUNT(medal) AS total_medals
FROM olympic
GROUP BY athlete
HAVING COUNT(DISTINCT sport) > 1
ORDER BY total_medals DESC;


-- 11. Predicting the Most Successful Country for the Next Event
SELECT country, COUNT(medal) AS total_medals
FROM olympic
WHERE year = (SELECT MAX(year) FROM olympic)
GROUP BY country
ORDER BY total_medals DESC
LIMIT 1;


