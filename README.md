# 📊 Store Sales Analysis

## 📌 Overview
This project focuses on analyzing store performance using SQL and Python. The goal was to understand which factors influence store sales and to 
test common assumptions about retail business performance.

## 🎯 Objectives
- Analyze store sales distribution
- Identify top-performing stores
- Explore relationships between:
  - Store Area
  - Items Available
  - Daily Customer Count
- Detect patterns and outliers in sales data

## 🛠️ Tools & Technologies
- **SQL (MySQL)** – Data extraction and aggregation  
- **Python**  
  - Pandas – Data handling  
  - Matplotlib & Seaborn – Data visualization  

## 📂 Dataset Features
- `Store_ID`
- `Store_Sales`
- `Store_Area`
- `Items_Available`
- `Daily_Customer_Count`
- `Sales_Level`

## 📊 Analysis Performed

### 1. Top Performing Stores
- Identified top 10 stores based on sales
- Compared stores with highest item availability

### 2. Sales Level Distribution
- Counted number of stores across different sales categories

### 3. Correlation Analysis
- Generated correlation matrix to identify relationships between variables

### 4. Relationship Analysis
- Used regression plots to explore:
  - Sales vs Store Area  
  - Area vs Customer Count  

### 5. Distribution Analysis
- Histogram of:
  - Store Sales  
  - Items Available  

### 6. Outlier Detection
- Boxplot used to detect extreme values in store sales

## 🔍 Key Insights

- Store Area has **little to no strong correlation** with sales  
- Items Available does **not significantly influence** customer count  
- Daily Customer Count shows **weak relationship** with sales  
- Most stores generate sales in the range of **45,000 – 75,000**  
- A few stores significantly outperform others (outliers)  
- Sales performance is likely influenced by **external factors not present in dataset**

## 📈 Conclusion
This analysis shows that common assumptions like *“bigger store = more sales”* or *“more items = more customers”* do not always hold true.

Instead, store success may depend on hidden factors such as:
- Location  
- Customer experience  
- Marketing strategies

## 📬 Author
**Emon Sen**  
B.Sc. in CSE | Aspiring Data Scientist  
