use Internship_projects;
rename table supply_chain_data to supply_chain;
select* from supply_chain;
ALTER TABLE supply_chain  
RENAME COLUMN `Product type` TO Product_Type,  
RENAME COLUMN `Number of products sold` TO Number_of_Products_Sold,  
RENAME COLUMN `Revenue generated` TO Revenue_Generated,  
RENAME COLUMN `Customer demographics` TO Customer_Demographics,  
RENAME COLUMN `Stock levels` TO Stock_Levels,  
RENAME COLUMN `Lead times` TO Lead_Times,  
RENAME COLUMN `Order quantities` TO Order_Quantities,  
RENAME COLUMN `Shipping times` TO Shipping_Times,  
RENAME COLUMN `Supplier name` TO Supplier_Name,  
RENAME COLUMN `Lead time` TO Lead_Time,  
RENAME COLUMN `Production volumes` TO Production_Volumes,  
RENAME COLUMN `Manufacturing lead time` TO Manufacturing_Lead_Time,  
RENAME COLUMN `Inspection results` TO Inspection_Results,  
RENAME COLUMN `Defect rates` TO Defect_Rates,  
RENAME COLUMN `Transportation modes` TO Transportation_Modes;
ALTER TABLE supply_chain  
RENAME COLUMN `Shipping carriers` TO Shipping_Carriers,  
RENAME COLUMN `Shipping costs` TO Shipping_Costs,  
RENAME COLUMN `Production_Volumes` TO Production_Volumes,  
RENAME COLUMN `Manufacturing costs` TO Manufacturing_Costs;
  
-- Supply Chain Data Analysis Using SQL

-- Step 1: Data Cleaning
-- Remove duplicate records
DELETE FROM supply_chain
WHERE (SKU, Product_Type) NOT IN (
    SELECT SKU, Product_Type FROM (
        SELECT SKU, Product_Type, MIN(Price) AS Price, MIN(Availability) AS Availability, 
               MIN(Number_of_Products_Sold) AS Number_of_Products_Sold, MIN(Revenue_Generated) AS Revenue_Generated, 
               MIN(Stock_Levels) AS Stock_Levels, MIN(Lead_Times) AS Lead_Times, 
               MIN(Order_Quantities) AS Order_Quantities, MIN(Shipping_Times) AS Shipping_Times, 
               MIN(Shipping_Carriers) AS Shipping_Carriers, MIN(Shipping_Costs) AS Shipping_Costs, 
               MIN(Supplier_Name) AS Supplier_Name, MIN(Location) AS Location, 
               MIN(Manufacturing_Costs) AS Manufacturing_Costs, 
               MIN(Production_Volumes) AS Production_Volumes
        FROM supply_chain
        GROUP BY SKU, Product_Type
    ) AS subquery
);

-- Step 2: Exploratory Data Analysis (EDA)

-- 1. Total Revenue by Product Type
SELECT Product_Type, SUM(Revenue_Generated) AS total_revenue
FROM supply_chain
GROUP BY Product_Type
ORDER BY total_revenue DESC;

-- 2. Top-Selling Products
SELECT SKU, Product_Type, SUM(Number_of_Products_Sold) AS total_sold
FROM supply_chain
GROUP BY SKU, Product_Type
ORDER BY total_sold DESC
LIMIT 10;

-- 3. Average Lead Time by Supplier
SELECT Supplier_Name, AVG(Lead_Times) AS avg_lead_time
FROM supply_chain
GROUP BY Supplier_Name
ORDER BY avg_lead_time ASC;

-- 4. Stock Levels by Product Type
SELECT Product_Type, AVG(Stock_Levels) AS avg_stock
FROM supply_chain
GROUP BY Product_Type
ORDER BY avg_stock DESC;

-- 5. Average Order Quantity per Product
SELECT SKU, Product_Type, AVG(Order_Quantities) AS avg_order_quantity
FROM supply_chain
GROUP BY SKU, Product_Type
ORDER BY avg_order_quantity DESC;

-- 6. Shipping Costs by Carrier
SELECT Shipping_Carriers, AVG(Shipping_Costs) AS avg_shipping_cost
FROM supply_chain
GROUP BY Shipping_Carriers
ORDER BY avg_shipping_cost DESC;

-- 7. Fastest Shipping Carriers
SELECT Shipping_Carriers, AVG(Shipping_Times) AS avg_shipping_time
FROM supply_chain
GROUP BY Shipping_Carriers
ORDER BY avg_shipping_time ASC;

-- 8. Manufacturing Cost Analysis
SELECT Product_Type, AVG(Manufacturing_Costs) AS avg_mfg_cost
FROM supply_chain
GROUP BY Product_Type
ORDER BY avg_mfg_cost DESC;

-- 9. Relationship Between Stock Levels and Order Quantities
SELECT Product_Type, Stock_Levels, Order_Quantities
FROM supply_chain
ORDER BY Stock_Levels DESC, Order_Quantities DESC;

-- 10. Predicting Most Profitable Product Category
SELECT Product_Type, SUM(Revenue_Generated) - SUM(Manufacturing_Costs) AS total_profit
FROM supply_chain
GROUP BY Product_Type
ORDER BY total_profit DESC
LIMIT 1;

