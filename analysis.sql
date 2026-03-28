CREATE DATABASE STORE_ANALYSIS;
USE STORE_ANALYSIS;

# Data overview
SELECT*FROM stores
ORDER BY Daily_Customer_Count desc
LIMIT 10;

# Shape of this dataset

SELECT COUNT(*) AS total_rows FROM stores;      # 896 rows

SELECT COUNT(*) AS total_columns
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='stores';                      # 5 columns

# Name of the columns

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='stores';   

# Info
DESCRIBE stores;
SHOW COLUMNS FROM stores;
 
# Changing 'ï»¿Store ID' column name
ALTER TABLE stores
CHANGE COLUMN `ï»¿Store ID` Store_ID INT NOT NULL;

# Checking null values

SELECT 
SUM(CASE WHEN Store_ID IS NULL THEN 1 ELSE 0 END) AS null_store_ids,
SUM(CASE WHEN Store_Area IS NULL THEN 1 ELSE 0 END) AS null_store_area,
SUM(CASE WHEN Items_Available IS NULL THEN 1 ELSE 0 END) AS null_avail_items,
SUM(CASE WHEN Daily_Customer_Count IS NULL THEN 1 ELSE 0 END) AS null_counts,
SUM(CASE WHEN Store_Sales IS NULL THEN 1 ELSE 0 END) AS null_store_sales
FROM stores;               # ZERO null values

# unique values

SELECT DISTINCT Store_ID FROM stores;
SELECT count(DISTINCT Store_ID) FROM stores;    # 896 different stores information is available
SELECT DISTINCT Store_Area FROM stores;
SELECT count(DISTINCT Store_Area) FROM stores;  # 583 different store areas

# Feature Engineering
ALTER TABLE stores
ADD COLUMN Daily_Customer_Level VARCHAR(10);
ALTER TABLE stores
ADD COLUMN Sales_Level VARCHAR(10);
ALTER TABLE stores
ADD COLUMN Area_Level VARCHAR(10);

SET SQL_SAFE_UPDATES=0;

UPDATE stores
SET Daily_Customer_Level=CASE
WHEN Daily_Customer_Count<800 THEN 'Low'
WHEN Daily_Customer_Count>=800 THEN 'High'
END;

UPDATE stores
SET Sales_Level=CASE
WHEN Store_Sales<60000 THEN 'Low'
WHEN Store_Sales>=60000 THEN 'High'
END;

UPDATE stores
SET Area_Level=CASE
WHEN Store_Area<1600 THEN 'Low'
WHEN Store_Area>=1600 THEN 'High'
END;


### ANALYSIS 

# average sales
SELECT AVG(Store_Sales) AS Average_Store_Sales
FROM stores;
# average area
SELECT AVG(Store_Area) AS Average_Store_Area
FROM stores;
# average daily customer
SELECT AVG(Daily_Customer_Count) AS Average_Daily_Customer
FROM stores;

# areas with most sales
SELECT Store_Area, SUM(Store_Sales) AS TOTAL_AREA_SALES
FROM stores
GROUP BY Store_Area
ORDER BY TOTAL_AREA_SALES DESC
LIMIT 10;     

# Stores with most sales
SELECT Store_ID, Store_Sales 
FROM stores
ORDER BY Store_Sales DESC
LIMIT 10;

# Store with highest available items
SELECT Store_ID, Store_Area, Items_Available,Store_Sales
FROM stores
ORDER BY Items_Available DESC
LIMIT 10;                      

# areas with most sales on average

SELECT Store_Area, COUNT(*) AS STORES_PER_AREA, AVG(Store_Sales) AS AVG_AREA_SALES
FROM stores
GROUP BY Store_Area
HAVING STORES_PER_AREA>1
ORDER BY AVG_AREA_SALES DESC;
-- ORDER BY STORES_PER_AREA DESC;    


# Areas of stores with most customer count 
SELECT Store_Area, COUNT(*) AS STORES_PER_AREA, AVG(Store_Sales) AS AVG_AREA_SALES, AVG(Daily_Customer_Count) AS AVG_CUST_COUNT
FROM stores
GROUP BY Store_Area
-- ORDER BY AVG_CUST_COUNT DESC;
ORDER BY STORES_PER_AREA DESC;    

# TOTAL STORES BY Daily Customer Level 

SELECT Daily_Customer_Level, COUNT(Store_ID) AS Total_Stores
FROM stores
GROUP BY Daily_Customer_Level
ORDER BY Total_Stores DESC;           # Low Ranked Daily Customer Level Stores are the most

# TOTAL STORES BY Sales Level 

SELECT Sales_Level, COUNT(Store_ID) AS Total_Stores
FROM stores
GROUP BY Sales_Level
ORDER BY Total_Stores DESC;           # Low Ranked Sales Level Stores are the most

# Low Daily Customer Level but High Sales Level
SELECT*FROM stores
WHERE Daily_Customer_Level='Low' AND Sales_Level='High';
SELECT COUNT(*) AS Store_Count FROM stores
WHERE Daily_Customer_Level='Low' AND Sales_Level='High';     # 224 stores have low daily customer level BUT HIGH SALES LEVEL
SELECT Area_Level,COUNT(Store_ID) AS Store_Count FROM stores
WHERE Daily_Customer_Level='Low' AND Sales_Level='High'
GROUP BY Area_Level;     # 139 low area level stores with low customers made high sales & 85 high area level stores made high sales with low customers
    
# High Daily Customer Level but Low Sales Level
SELECT*FROM stores
WHERE Daily_Customer_Level='High' AND Sales_Level='Low';
SELECT COUNT(*) AS Store_Count FROM stores 
WHERE Daily_Customer_Level='High' AND Sales_Level='Low';    # 228 stores have HIGH DAILY CUSTOMER LEVEL but low sales level
SELECT Area_Level,COUNT(Store_ID) FROM stores 
WHERE Daily_Customer_Level='High' AND Sales_Level='Low'
GROUP BY Area_Level;   # 165 low area level store with high customer level made low sale &  63 high area level stores made low sales with high customers

-- Only 1 High Area Level Store have low sales with high customers & 4 High Area Level Store have high sales with low customer

SELECT 
AVG(Store_Area) AS Avg_Store_Area,
AVG(Items_Available) AS Avg_Items_Available
FROM stores
WHERE Daily_Customer_Level='Low' AND Sales_Level='High';

SELECT 
AVG(Store_Area) AS Avg_Store_Area,
AVG(Items_Available) AS Avg_Items_Available
FROM stores
WHERE Daily_Customer_Level='High' AND Sales_Level='Low';    

# sales per customer
SELECT Store_ID, Store_Sales, Store_Sales/Daily_Customer_Count AS Sales_Per_Customer
FROM stores;
# sales per area
SELECT Store_ID, Store_Area, Store_Sales/Store_Area AS Sales_Per_Area
FROM stores;
# customer per item
SELECT Store_ID, Items_Available, Daily_Customer_Count, Items_Available/Daily_Customer_Count AS Items_Available_Per_Customer
FROM stores
ORDER BY Items_Available DESC;

### Correlations

# Sales and Area
SELECT
(
COUNT(*)*SUM(Store_Sales*Store_Area)-(SUM(Store_Sales)*SUM(Store_Area))
)/
SQRT(
(COUNT(*)*SUM(Store_Sales*Store_Sales)-POW(SUM(Store_Sales),2))
*
(COUNT(*)*SUM(Store_Area*Store_Area)-POW(SUM(Store_Area),2))
) AS Correlation_Sales_Area
FROM stores;                  
--  0.097473 ~ 0, no linear relation. Sales doesnt have any linear correlation with Store Area

# Sales and Items Available
SELECT
(
COUNT(*)*SUM(Store_Sales*Items_Available)-(SUM(Store_Sales)*SUM(Items_Available))
)/
SQRT(
(COUNT(*)*SUM(Store_Sales*Store_Sales)-POW(SUM(Store_Sales),2))
*
(COUNT(*)*SUM(Items_Available*Items_Available)-POW(SUM(Items_Available),2))
) AS Correlation_Sales_Items
FROM stores;                 
-- 0.0988 ~ 0, no linear relation. Sales doesnt have any linear correlation with Available items

# Sales and Daily Customer Count
SELECT
(
COUNT(*)*SUM(Store_Sales*Daily_Customer_Count)-(SUM(Store_Sales)*SUM(Daily_Customer_Count))
)/
SQRT(
(COUNT(*)*SUM(Store_Sales*Store_Sales)-POW(SUM(Store_Sales),2))
*
(COUNT(*)*SUM(Daily_Customer_Count*Daily_Customer_Count)-POW(SUM(Daily_Customer_Count),2))
) AS Correlation_Sales_Customers
FROM stores;
-- 0.0086 ~ 0, again no linear correlation

# Items Available and Daily Customer Count

SELECT
(
COUNT(*)*SUM(Items_Available*Daily_Customer_Count)-(SUM(Items_Available)*SUM(Daily_Customer_Count))
)/
SQRT(
(COUNT(*)*SUM(Items_Available*Items_Available)-POW(SUM(Items_Available),2))
*
(COUNT(*)*SUM(Daily_Customer_Count*Daily_Customer_Count)-POW(SUM(Daily_Customer_Count),2))
) AS Correlation_Items_Customers
FROM stores;
-- -0.0409 ~ 0 
