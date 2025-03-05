Create Database Internship_Projects;
DESCRIBE coffee_sales;
SELECT * FROM internship_projects.coffee_sales;
CREATE TABLE Internship_projects.coffee_sales AS 
SELECT * FROM battery_vehicle_2.coffee_sales;
SELECT TABLE_SCHEMA 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_NAME = 'coffee_sales';
select* from coffee_sales;


-- 1. Data Cleaning: Handling Missing Values and Converting Data Types
UPDATE coffee_sales
SET card = COALESCE(card, 'Unknown');

ALTER TABLE coffee_sales 
MODIFY COLUMN date DATE, 
MODIFY COLUMN datetime DATETIME;

-- 2. Exploratory Data Analysis (EDA)
-- Monthly Sales Trend
SELECT DATE_FORMAT(date, '%Y-%m') AS month, SUM(money) AS total_sales
FROM coffee_sales
GROUP BY month
ORDER BY month;

-- Total Sales by Coffee Type
SELECT coffee_name, SUM(money) AS total_sales
FROM coffee_sales
GROUP BY coffee_name
ORDER BY total_sales DESC;

-- Sales Distribution by Day of the Week
SELECT DAYNAME(date) AS day_of_week, SUM(money) AS total_sales
FROM coffee_sales
GROUP BY day_of_week
ORDER BY FIELD(day_of_week, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');

-- 3. Time Series Analysis: Next Day/Week/Month Sales Prediction
-- Create lag columns for past sales trends
SELECT date, money AS current_sales,
       LAG(money, 1) OVER (ORDER BY date) AS prev_day_sales,
       LAG(money, 7) OVER (ORDER BY date) AS prev_week_sales,
       LAG(money, 30) OVER (ORDER BY date) AS prev_month_sales
FROM (SELECT date, SUM(money) AS money FROM coffee_sales GROUP BY date) AS daily_sales;

-- 4. Identifying Specific Customer Purchases
-- Count of transactions by payment type
SELECT cash_type, COUNT(*) AS transaction_count
FROM coffee_sales
GROUP BY cash_type;

-- Top 10 highest-spending customers (excluding 'Unknown' entries)
SELECT card, SUM(money) AS total_spent
FROM coffee_sales
WHERE card <> 'Unknown'
GROUP BY card
ORDER BY total_spent DESC
LIMIT 10;
