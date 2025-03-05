use Internship_projects;
select* from stocks;
alter table stocks rename column `Adj Close` to Adj_Close;
-- Stock Market Data Analysis Using SQL

-- Step 1: Data Cleaning
-- Remove duplicate records
DELETE FROM stocks
WHERE (Ticker, Date) NOT IN (
    SELECT Ticker, Date FROM (
        SELECT Ticker, Date, MIN(Open) AS Open, MIN(High) AS High, MIN(Low) AS Low, 
               MIN(Close) AS Close, MIN(Adj_Close) AS Adj_Close, MIN(Volume) AS Volume
        FROM stocks
        GROUP BY Ticker, Date
    ) AS subquery
);

-- Step 2: Exploratory Data Analysis (EDA)

-- 1. Total Trading Volume by Company
SELECT Ticker, SUM(Volume) AS total_volume
FROM stocks
GROUP BY Ticker
ORDER BY total_volume DESC;

-- 2. Average Closing Price by Company
SELECT Ticker, AVG(Close) AS avg_closing_price
FROM stocks
GROUP BY Ticker
ORDER BY avg_closing_price DESC;

-- 3. Daily Price Change Percentage
SELECT Ticker, Date, 
       ((Close - Open) / Open) * 100 AS daily_price_change
FROM stocks
ORDER BY Date, Ticker;

-- 4. Moving Average (7-Day) Calculation
SELECT Ticker, Date, Close,
       AVG(Close) OVER (PARTITION BY Ticker ORDER BY Date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS moving_avg_7d
FROM stocks;

-- 5. Stock Price Volatility (Standard Deviation Over 7 Days)
SELECT Ticker, Date, Close,
       STDDEV(Close) OVER (PARTITION BY Ticker ORDER BY Date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS volatility_7d
FROM stocks;

-- 6. Highest Closing Price by Company
SELECT Ticker, MAX(Close) AS highest_closing_price
FROM stocks
GROUP BY Ticker
ORDER BY highest_closing_price DESC;

-- 7. Lowest Closing Price by Company
SELECT Ticker, MIN(Close) AS lowest_closing_price
FROM stocks
GROUP BY Ticker
ORDER BY lowest_closing_price ASC;

-- 8. Correlation Between Stock Prices
SELECT s1.Ticker AS Stock1, s2.Ticker AS Stock2,
       (SUM((s1.Close - avg1) * (s2.Close - avg2)) / 
       (SQRT(SUM(POWER(s1.Close - avg1, 2))) * SQRT(SUM(POWER(s2.Close - avg2, 2))))) AS price_correlation
FROM stocks s1
JOIN stocks s2 ON s1.Date = s2.Date AND s1.Ticker < s2.Ticker
JOIN (SELECT Ticker, AVG(Close) AS avg1 FROM stocks GROUP BY Ticker) AS avg_s1 ON s1.Ticker = avg_s1.Ticker
JOIN (SELECT Ticker, AVG(Close) AS avg2 FROM stocks GROUP BY Ticker) AS avg_s2 ON s2.Ticker = avg_s2.Ticker
GROUP BY s1.Ticker, s2.Ticker;


-- 9. Identify Days with Highest Trading Volume
SELECT Date, Ticker, Volume
FROM stocks
ORDER BY Volume DESC
LIMIT 10;

-- 10. Predicting Most Volatile Stock for Next Period
SELECT Ticker, AVG(volatility_7d) AS avg_volatility
FROM (
    SELECT Ticker, Date, 
           STDDEV(Close) OVER (PARTITION BY Ticker ORDER BY Date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS volatility_7d
    FROM stocks
) AS volatility_data
GROUP BY Ticker
ORDER BY avg_volatility DESC
LIMIT 1;


