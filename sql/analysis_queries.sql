/*=========================================================
 Retail Sales & Inventory Analysis
 Module : Database Exploration
 Database : retail_sales_analysis
 MySQL Version : 8.0+
=========================================================*/

-- USE retail_sales_analysis;

---------------------------------------------------------
-- Total Products
---------------------------------------------------------

SELECT
COUNT(*) AS Total_Products
FROM Products;

---------------------------------------------------------
-- Total Customers
---------------------------------------------------------

SELECT
COUNT(*) AS Total_Customers
FROM Customers;

---------------------------------------------------------
-- Total Stores
---------------------------------------------------------

SELECT
COUNT(*) AS Total_Stores
FROM Stores;

---------------------------------------------------------
-- Total Inventory Records
---------------------------------------------------------

SELECT
COUNT(*) AS Total_Inventory
FROM Inventory;

---------------------------------------------------------
-- Total Sales Records
---------------------------------------------------------

SELECT
COUNT(*) AS Total_Sales
FROM Sales;

---------------------------------------------------------
-- Total Transactions
---------------------------------------------------------

SELECT
COUNT(*) AS Total_Transactions
FROM Sales;

---------------------------------------------------------
-- Total Revenue
---------------------------------------------------------

SELECT
ROUND(SUM(Sales),2) AS Total_Revenue
FROM Sales;

---------------------------------------------------------
-- Average Order Value
---------------------------------------------------------

SELECT
ROUND(AVG(Sales),2) AS Average_Order_Value
FROM Sales;

---------------------------------------------------------
-- Total Quantity Sold
---------------------------------------------------------

SELECT
SUM(Quantity) AS Total_Items_Sold
FROM Sales;

---------------------------------------------------------
-- Date Range
---------------------------------------------------------

SELECT
MIN(Date) AS First_Sale_Date,
MAX(Date) AS Last_Sale_Date
FROM Sales;

---------------------------------------------------------
-- Total Profit
---------------------------------------------------------

SELECT
ROUND(SUM(Profit),2) AS Total_Profit
FROM Sales;

---------------------------------------------------------
-- Average Profit
---------------------------------------------------------

SELECT
ROUND(AVG(Profit),2) AS Average_Profit
FROM Sales;

---------------------------------------------------------
-- Total Discount
---------------------------------------------------------

SELECT
ROUND(SUM(Discount),2) AS Total_Discount
FROM Sales;

---------------------------------------------------------
-- Average Discount
---------------------------------------------------------

SELECT
ROUND(AVG(Discount),2) AS Average_Discount
FROM Sales;

---------------------------------------------------------
-- Distinct Products Sold
---------------------------------------------------------

SELECT
COUNT(DISTINCT Product_ID) AS Products_Sold
FROM Sales;

---------------------------------------------------------
-- Distinct Customers
---------------------------------------------------------

SELECT
COUNT(DISTINCT Customer_ID) AS Active_Customers
FROM Sales;

---------------------------------------------------------
-- Distinct Stores
---------------------------------------------------------

SELECT
COUNT(DISTINCT Store_ID) AS Active_Stores
FROM Sales;



/*=========================================================
 Retail Sales & Inventory Analysis
 Module : Sales Analysis
 Database : retail_sales_analysis
 MySQL Version : 8.0+
=========================================================*/

-- USE retail_sales_analysis;

---------------------------------------------------------
-- Monthly Revenue
---------------------------------------------------------

SELECT
    YEAR(`Date`) AS Year,
    MONTH(`Date`) AS Month,
    ROUND(SUM(Sales), 2) AS Revenue
FROM Sales
GROUP BY YEAR(`Date`), MONTH(`Date`)
HAVING SUM(Sales) > 0
ORDER BY YEAR(`Date`), MONTH(`Date`);
---------------------------------------------------------
-- Monthly Profit
---------------------------------------------------------

SELECT
    YEAR(`Date`) AS Year,
    MONTH(`Date`) AS Month,
    ROUND(SUM(Profit),2) AS Profit
FROM Sales
GROUP BY YEAR(`Date`), MONTH(`Date`)
ORDER BY YEAR(`Date`), MONTH(`Date`);

---------------------------------------------------------
-- Quarterly Revenue
---------------------------------------------------------

SELECT
    EXTRACT(YEAR FROM `Date`) AS Year,
    EXTRACT(QUARTER FROM `Date`) AS Quarter,
    ROUND(SUM(Sales),2) AS Revenue
FROM Sales
GROUP BY EXTRACT(YEAR FROM `Date`), EXTRACT(QUARTER FROM `Date`)
ORDER BY EXTRACT(YEAR FROM `Date`), EXTRACT(QUARTER FROM `Date`);

---------------------------------------------------------
-- Quarterly Profit
---------------------------------------------------------

SELECT
    EXTRACT(YEAR FROM `Date`) AS Year,
    EXTRACT(QUARTER FROM `Date`) AS Quarter,
    ROUND(SUM(Profit),2) AS Profit
FROM Sales
GROUP BY EXTRACT(YEAR FROM `Date`), EXTRACT(QUARTER FROM `Date`)
ORDER BY EXTRACT(YEAR FROM `Date`), EXTRACT(QUARTER FROM `Date`);

---------------------------------------------------------
-- Revenue by Month Name
---------------------------------------------------------

SELECT
    DATE_FORMAT(`Date`, '%M') AS Month_Name,
    EXTRACT(MONTH FROM `Date`) AS Month_Number,
    ROUND(SUM(Sales),2) AS Revenue
FROM Sales
GROUP BY EXTRACT(MONTH FROM `Date`), DATE_FORMAT(`Date`, '%M')
ORDER BY EXTRACT(MONTH FROM `Date`);

---------------------------------------------------------
-- Revenue by Weekday
---------------------------------------------------------

SELECT
    DATE_FORMAT(`Date`, '%W') AS Weekday,
    ROUND(SUM(Sales),2) AS Revenue
FROM Sales
GROUP BY DAYOFWEEK(`Date`), DATE_FORMAT(`Date`, '%W')
ORDER BY DAYOFWEEK(`Date`);

---------------------------------------------------------
-- Revenue by Weekend vs Weekday
---------------------------------------------------------

SELECT
    CASE
        WHEN DAYOFWEEK(`Date`) IN (1,7) THEN 'Weekend'
        ELSE 'Weekday'
    END AS Day_Type,
    ROUND(SUM(Sales),2) AS Revenue
FROM Sales
GROUP BY Day_Type;

---------------------------------------------------------
-- Daily Revenue
---------------------------------------------------------

SELECT
    `Date`,
    ROUND(SUM(Sales),2) AS Revenue
FROM Sales
GROUP BY `Date`
ORDER BY `Date`;

---------------------------------------------------------
-- Daily Profit
---------------------------------------------------------

SELECT
    `Date`,
    ROUND(SUM(Profit),2) AS Profit
FROM Sales
GROUP BY `Date`
ORDER BY `Date`;

---------------------------------------------------------
-- Top 10 Sales Days
---------------------------------------------------------

SELECT
    `Date`,
    ROUND(SUM(Sales),2) AS Revenue
FROM Sales
GROUP BY `Date`
ORDER BY Revenue DESC
LIMIT 10;

---------------------------------------------------------
-- Lowest 10 Sales Days
---------------------------------------------------------

SELECT
    `Date`,
    ROUND(SUM(Sales),2) AS Revenue
FROM Sales
GROUP BY `Date`
ORDER BY Revenue
LIMIT 10;

---------------------------------------------------------
-- Monthly Transaction Count
---------------------------------------------------------

SELECT
    YEAR(`Date`) AS Year,
    MONTH(`Date`) AS Month,
    COUNT(*) AS Transactions
FROM Sales
GROUP BY YEAR(`Date`), MONTH(`Date`)
ORDER BY YEAR(`Date`), MONTH(`Date`);

---------------------------------------------------------
-- Average Transaction Value by Month
---------------------------------------------------------

SELECT
    YEAR(`Date`) AS Year,
    MONTH(`Date`) AS Month,
    ROUND(AVG(Sales),2) AS Avg_Order_Value
FROM Sales
GROUP BY YEAR(`Date`), MONTH(`Date`)
ORDER BY YEAR(`Date`), MONTH(`Date`);

---------------------------------------------------------
-- Monthly Quantity Sold
---------------------------------------------------------

SELECT
    YEAR(`Date`) AS Year,
    MONTH(`Date`) AS Month,
    SUM(Quantity) AS Quantity_Sold
FROM Sales
GROUP BY YEAR(`Date`), MONTH(`Date`)
ORDER BY YEAR(`Date`), MONTH(`Date`);

---------------------------------------------------------
-- Highest Revenue Month
---------------------------------------------------------

SELECT
    YEAR(`Date`) AS Year,
    MONTHNAME(`Date`) AS Month,
    ROUND(SUM(Sales),2) AS Revenue
FROM Sales
GROUP BY YEAR(`Date`), MONTH(`Date`), MONTHNAME(`Date`)
ORDER BY Revenue DESC
LIMIT 1;

---------------------------------------------------------
-- Highest Profit Month
---------------------------------------------------------

SELECT
    YEAR(`Date`) AS Year,
    MONTHNAME(`Date`) AS Month,
    ROUND(SUM(Profit),2) AS Profit
FROM Sales
GROUP BY YEAR(`Date`), MONTH(`Date`), MONTHNAME(`Date`)
ORDER BY Profit DESC
LIMIT 1;

---------------------------------------------------------
-- Sales Distribution by Quarter
---------------------------------------------------------

SELECT
    QUARTER(`Date`) AS Quarter,
    COUNT(*) AS Orders,
    ROUND(SUM(Sales),2) AS Revenue
FROM Sales
GROUP BY QUARTER(`Date`)
ORDER BY Quarter;

---------------------------------------------------------
-- Average Daily Revenue
---------------------------------------------------------

SELECT
    ROUND(AVG(Daily_Revenue),2) AS Average_Daily_Revenue
FROM
(
    SELECT
        `Date`,
        SUM(Sales) AS Daily_Revenue
    FROM Sales
    GROUP BY `Date`
) t;

---------------------------------------------------------
-- Revenue Per Transaction
---------------------------------------------------------

SELECT
    Transaction_ID,
    ROUND(Sales,2) AS Revenue
FROM Sales
ORDER BY Revenue DESC;

---------------------------------------------------------
-- Monthly Revenue Trend
---------------------------------------------------------

SELECT
    DATE_FORMAT(`Date`, '%Y-%m') AS Month,
    ROUND(SUM(Sales),2) AS Revenue
FROM Sales
GROUP BY DATE_FORMAT(`Date`, '%Y-%m')
ORDER BY Month;


/*=========================================================
 Retail Sales & Inventory Analysis
 Module : Product Analysis
 Database : retail_sales_analysis
 MySQL Version : 8.0+
=========================================================*/

USE retail_sales_analysis;

---------------------------------------------------------
-- Top 10 Best Selling Products
---------------------------------------------------------

SELECT
    p.Product_ID,
    p.Product_Name,
    SUM(s.Quantity) AS Units_Sold
FROM Sales s
JOIN Products p
    ON s.Product_ID = p.Product_ID
GROUP BY
    p.Product_ID,
    p.Product_Name
ORDER BY Units_Sold DESC
LIMIT 10;

---------------------------------------------------------
-- Top 10 Revenue Generating Products
---------------------------------------------------------

SELECT
    p.Product_ID,
    p.Product_Name,
    ROUND(SUM(s.Sales),2) AS Revenue
FROM Sales s
JOIN Products p
    ON s.Product_ID = p.Product_ID
GROUP BY
    p.Product_ID,
    p.Product_Name
ORDER BY Revenue DESC
LIMIT 10;

---------------------------------------------------------
-- Top 10 Most Profitable Products
---------------------------------------------------------

SELECT
    p.Product_ID,
    p.Product_Name,
    ROUND(SUM(s.Profit),2) AS Profit
FROM Sales s
JOIN Products p
    ON s.Product_ID = p.Product_ID
GROUP BY
    p.Product_ID,
    p.Product_Name
ORDER BY Profit DESC
LIMIT 10;

---------------------------------------------------------
-- Lowest Selling Products
---------------------------------------------------------

SELECT
    p.Product_ID,
    p.Product_Name,
    SUM(s.Quantity) AS Units_Sold
FROM Sales s
JOIN Products p
    ON s.Product_ID = p.Product_ID
GROUP BY
    p.Product_ID,
    p.Product_Name
ORDER BY Units_Sold
LIMIT 10;

---------------------------------------------------------
-- Category-wise Revenue
---------------------------------------------------------

SELECT
    p.Category,
    ROUND(SUM(s.Sales),2) AS Revenue
FROM Sales s
JOIN Products p
    ON s.Product_ID = p.Product_ID
GROUP BY p.Category
ORDER BY Revenue DESC;

---------------------------------------------------------
-- Category-wise Profit
---------------------------------------------------------

SELECT
    p.Category,
    ROUND(SUM(s.Profit),2) AS Profit
FROM Sales s
JOIN Products p
    ON s.Product_ID = p.Product_ID
GROUP BY p.Category
ORDER BY Profit DESC;

---------------------------------------------------------
-- Category-wise Quantity Sold
---------------------------------------------------------

SELECT
    p.Category,
    SUM(s.Quantity) AS Units_Sold
FROM Sales s
JOIN Products p
    ON s.Product_ID = p.Product_ID
GROUP BY p.Category
ORDER BY Units_Sold DESC;

---------------------------------------------------------
-- Brand Performance by Revenue
---------------------------------------------------------

SELECT
    p.Brand,
    ROUND(SUM(s.Sales),2) AS Revenue
FROM Sales s
JOIN Products p
    ON s.Product_ID = p.Product_ID
GROUP BY p.Brand
ORDER BY Revenue DESC;

---------------------------------------------------------
-- Brand Performance by Profit
---------------------------------------------------------

SELECT
    p.Brand,
    ROUND(SUM(s.Profit),2) AS Profit
FROM Sales s
JOIN Products p
    ON s.Product_ID = p.Product_ID
GROUP BY p.Brand
ORDER BY Profit DESC;

---------------------------------------------------------
-- Average Selling Price by Category
---------------------------------------------------------

SELECT
    Category,
    ROUND(AVG(Price),2) AS Average_Price
FROM Products
GROUP BY Category
ORDER BY Average_Price DESC;

---------------------------------------------------------
-- Average Product Cost by Category
---------------------------------------------------------

SELECT
    Category,
    ROUND(AVG(Cost),2) AS Average_Cost
FROM Products
GROUP BY Category
ORDER BY Average_Cost DESC;

---------------------------------------------------------
-- Average Profit per Product
---------------------------------------------------------

SELECT
    p.Product_ID,
    p.Product_Name,
    ROUND(AVG(s.Profit),2) AS Average_Profit
FROM Sales s
JOIN Products p
    ON s.Product_ID = p.Product_ID
GROUP BY
    p.Product_ID,
    p.Product_Name
ORDER BY Average_Profit DESC;

---------------------------------------------------------
-- Average Revenue per Product
---------------------------------------------------------

SELECT
    p.Product_ID,
    p.Product_Name,
    ROUND(AVG(s.Sales),2) AS Average_Revenue
FROM Sales s
JOIN Products p
    ON s.Product_ID = p.Product_ID
GROUP BY
    p.Product_ID,
    p.Product_Name
ORDER BY Average_Revenue DESC;

---------------------------------------------------------
-- Total Orders per Product
---------------------------------------------------------

SELECT
    p.Product_ID,
    p.Product_Name,
    COUNT(s.Transaction_ID) AS Orders
FROM Sales s
JOIN Products p
    ON s.Product_ID = p.Product_ID
GROUP BY
    p.Product_ID,
    p.Product_Name
ORDER BY Orders DESC;

---------------------------------------------------------
-- Discount Given by Category
---------------------------------------------------------

SELECT
    p.Category,
    ROUND(AVG(s.Discount),2) AS Average_Discount
FROM Sales s
JOIN Products p
    ON s.Product_ID = p.Product_ID
GROUP BY p.Category
ORDER BY Average_Discount DESC;

---------------------------------------------------------
-- Revenue Contribution by Category
---------------------------------------------------------

SELECT
    p.Category,
    ROUND(SUM(s.Sales),2) AS Revenue,
    ROUND(
        SUM(s.Sales) * 100 /
        (SELECT SUM(Sales) FROM Sales),
        2
    ) AS Revenue_Percentage
FROM Sales s
JOIN Products p
    ON s.Product_ID = p.Product_ID
GROUP BY p.Category
ORDER BY Revenue DESC;

---------------------------------------------------------
-- Profit Margin by Product
---------------------------------------------------------

SELECT
    p.Product_ID,
    p.Product_Name,
    ROUND(SUM(s.Profit),2) AS Profit,
    ROUND(SUM(s.Sales),2) AS Revenue,
    ROUND(
        (SUM(s.Profit) /
        NULLIF(SUM(s.Sales),0)) * 100,
        2
    ) AS Profit_Margin_Percentage
FROM Sales s
JOIN Products p
    ON s.Product_ID = p.Product_ID
GROUP BY
    p.Product_ID,
    p.Product_Name
ORDER BY Profit_Margin_Percentage DESC;

---------------------------------------------------------
-- Top Product in Each Category
---------------------------------------------------------

WITH ProductRanking AS
(
SELECT
    p.Category,
    p.Product_Name,
    SUM(s.Sales) AS Revenue,
    ROW_NUMBER() OVER
    (
        PARTITION BY p.Category
        ORDER BY SUM(s.Sales) DESC
    ) AS Rank_No
FROM Sales s
JOIN Products p
    ON s.Product_ID = p.Product_ID
GROUP BY
    p.Category,
    p.Product_Name
)

SELECT *
FROM ProductRanking
WHERE Rank_No = 1;

---------------------------------------------------------
-- Top 3 Products in Each Category
---------------------------------------------------------

WITH RankedProducts AS
(
SELECT
    p.Category,
    p.Product_Name,
    SUM(s.Sales) AS Revenue,
    ROW_NUMBER() OVER
    (
        PARTITION BY p.Category
        ORDER BY SUM(s.Sales) DESC
    ) AS Rank_No
FROM Sales s
JOIN Products p
    ON s.Product_ID = p.Product_ID
GROUP BY
    p.Category,
    p.Product_Name
)

SELECT *
FROM RankedProducts
WHERE Rank_No <= 3
ORDER BY Category, Rank_No;

---------------------------------------------------------
-- Product Revenue Ranking
---------------------------------------------------------

SELECT
    p.Product_Name,
    ROUND(SUM(s.Sales),2) AS Revenue,
    RANK() OVER
    (
        ORDER BY SUM(s.Sales) DESC
    ) AS Revenue_Rank
FROM Sales s
JOIN Products p
    ON s.Product_ID = p.Product_ID
GROUP BY p.Product_Name
ORDER BY Revenue_Rank;


/*=========================================================
 Retail Sales & Inventory Analysis
 Module : Customer Analysis
 Database : retail_sales_analysis
 MySQL Version : 8.0+
=========================================================*/

USE retail_sales_analysis;

---------------------------------------------------------
-- Total Customers
---------------------------------------------------------

SELECT
    COUNT(*) AS Total_Customers
FROM Customers;

---------------------------------------------------------
-- Active Customers
---------------------------------------------------------

SELECT
    COUNT(DISTINCT Customer_ID) AS Active_Customers
FROM Sales;

---------------------------------------------------------
-- Top 10 Customers by Revenue
---------------------------------------------------------

SELECT
    c.Customer_ID,
    ROUND(SUM(s.Sales),2) AS Revenue
FROM Customers c
JOIN Sales s
    ON c.Customer_ID = s.Customer_ID
GROUP BY c.Customer_ID
ORDER BY Revenue DESC
LIMIT 10;

---------------------------------------------------------
-- Top 10 Customers by Profit
---------------------------------------------------------

SELECT
    c.Customer_ID,
    ROUND(SUM(s.Profit),2) AS Profit
FROM Customers c
JOIN Sales s
    ON c.Customer_ID = s.Customer_ID
GROUP BY c.Customer_ID
ORDER BY Profit DESC
LIMIT 10;

---------------------------------------------------------
-- Customer Lifetime Value (CLV)
---------------------------------------------------------

SELECT
    c.Customer_ID,
    ROUND(SUM(s.Sales),2) AS Customer_Lifetime_Value
FROM Customers c
JOIN Sales s
    ON c.Customer_ID = s.Customer_ID
GROUP BY c.Customer_ID
ORDER BY Customer_Lifetime_Value DESC;

---------------------------------------------------------
-- Average Spend per Customer
---------------------------------------------------------

SELECT
    c.Customer_ID,
    ROUND(AVG(s.Sales),2) AS Average_Spend
FROM Customers c
JOIN Sales s
    ON c.Customer_ID = s.Customer_ID
GROUP BY c.Customer_ID
ORDER BY Average_Spend DESC;

---------------------------------------------------------
-- Number of Orders per Customer
---------------------------------------------------------

SELECT
    Customer_ID,
    COUNT(Transaction_ID) AS Orders
FROM Sales
GROUP BY Customer_ID
ORDER BY Orders DESC;

---------------------------------------------------------
-- Repeat Customers
---------------------------------------------------------

SELECT
    Customer_ID,
    COUNT(Transaction_ID) AS Orders
FROM Sales
GROUP BY Customer_ID
HAVING COUNT(Transaction_ID) > 1
ORDER BY Orders DESC;

---------------------------------------------------------
-- Revenue by Customer Segment
---------------------------------------------------------

SELECT
    c.Segment,
    ROUND(SUM(s.Sales),2) AS Revenue
FROM Customers c
JOIN Sales s
    ON c.Customer_ID = s.Customer_ID
GROUP BY c.Segment
ORDER BY Revenue DESC;

---------------------------------------------------------
-- Profit by Customer Segment
---------------------------------------------------------

SELECT
    c.Segment,
    ROUND(SUM(s.Profit),2) AS Profit
FROM Customers c
JOIN Sales s
    ON c.Customer_ID = s.Customer_ID
GROUP BY c.Segment
ORDER BY Profit DESC;

---------------------------------------------------------
-- Revenue by Gender
---------------------------------------------------------

SELECT
    c.Gender,
    ROUND(SUM(s.Sales),2) AS Revenue
FROM Customers c
JOIN Sales s
    ON c.Customer_ID = s.Customer_ID
GROUP BY c.Gender
ORDER BY Revenue DESC;

---------------------------------------------------------
-- Profit by Gender
---------------------------------------------------------

SELECT
    c.Gender,
    ROUND(SUM(s.Profit),2) AS Profit
FROM Customers c
JOIN Sales s
    ON c.Customer_ID = s.Customer_ID
GROUP BY c.Gender
ORDER BY Profit DESC;

---------------------------------------------------------
-- Revenue by City
---------------------------------------------------------

SELECT
    c.City,
    ROUND(SUM(s.Sales),2) AS Revenue
FROM Customers c
JOIN Sales s
    ON c.Customer_ID = s.Customer_ID
GROUP BY c.City
ORDER BY Revenue DESC;

---------------------------------------------------------
-- Top 10 Cities by Revenue
---------------------------------------------------------

SELECT
    c.City,
    ROUND(SUM(s.Sales),2) AS Revenue
FROM Customers c
JOIN Sales s
    ON c.Customer_ID = s.Customer_ID
GROUP BY c.City
ORDER BY Revenue DESC
LIMIT 10;

---------------------------------------------------------
-- Customer Age Groups
---------------------------------------------------------

SELECT
CASE
    WHEN Age BETWEEN 18 AND 25 THEN '18-25'
    WHEN Age BETWEEN 26 AND 35 THEN '26-35'
    WHEN Age BETWEEN 36 AND 45 THEN '36-45'
    WHEN Age BETWEEN 46 AND 60 THEN '46-60'
    ELSE '60+'
END AS Age_Group,
COUNT(*) AS Total_Customers
FROM Customers
GROUP BY Age_Group
ORDER BY Age_Group;

---------------------------------------------------------
-- Revenue by Age Group
---------------------------------------------------------

SELECT
CASE
    WHEN c.Age BETWEEN 18 AND 25 THEN '18-25'
    WHEN c.Age BETWEEN 26 AND 35 THEN '26-35'
    WHEN c.Age BETWEEN 36 AND 45 THEN '36-45'
    WHEN c.Age BETWEEN 46 AND 60 THEN '46-60'
    ELSE '60+'
END AS Age_Group,
ROUND(SUM(s.Sales),2) AS Revenue
FROM Customers c
JOIN Sales s
ON c.Customer_ID = s.Customer_ID
GROUP BY Age_Group
ORDER BY Revenue DESC;

---------------------------------------------------------
-- Profit by Age Group
---------------------------------------------------------

SELECT
CASE
    WHEN c.Age BETWEEN 18 AND 25 THEN '18-25'
    WHEN c.Age BETWEEN 26 AND 35 THEN '26-35'
    WHEN c.Age BETWEEN 36 AND 45 THEN '36-45'
    WHEN c.Age BETWEEN 46 AND 60 THEN '46-60'
    ELSE '60+'
END AS Age_Group,
ROUND(SUM(s.Profit),2) AS Profit
FROM Customers c
JOIN Sales s
ON c.Customer_ID = s.Customer_ID
GROUP BY Age_Group
ORDER BY Profit DESC;

---------------------------------------------------------
-- Average Order Value by Customer
---------------------------------------------------------

SELECT
    Customer_ID,
    ROUND(AVG(Sales),2) AS Average_Order_Value
FROM Sales
GROUP BY Customer_ID
ORDER BY Average_Order_Value DESC;

---------------------------------------------------------
-- Customer Revenue Ranking
---------------------------------------------------------

SELECT
    Customer_ID,
    ROUND(SUM(Sales),2) AS Revenue,
    RANK() OVER(
        ORDER BY SUM(Sales) DESC
    ) AS Revenue_Rank
FROM Sales
GROUP BY Customer_ID
ORDER BY Revenue_Rank;

---------------------------------------------------------
-- Top Customer in Each Segment
---------------------------------------------------------

WITH CustomerRanking AS
(
SELECT
    c.Segment,
    c.Customer_ID,
    SUM(s.Sales) AS Revenue,
    ROW_NUMBER() OVER(
        PARTITION BY c.Segment
        ORDER BY SUM(s.Sales) DESC
    ) AS Rank_No
FROM Customers c
JOIN Sales s
ON c.Customer_ID = s.Customer_ID
GROUP BY
    c.Segment,
    c.Customer_ID
)

SELECT *
FROM CustomerRanking
WHERE Rank_No = 1;



/*=========================================================
 Retail Sales & Inventory Analysis
 Module : Store Analysis
 Database : retail_sales_analysis
 MySQL Version : 8.0+
=========================================================*/

USE retail_sales_analysis;

---------------------------------------------------------
-- Total Stores
---------------------------------------------------------

SELECT
    COUNT(*) AS Total_Stores
FROM Stores;

---------------------------------------------------------
-- Active Stores
---------------------------------------------------------

SELECT
    COUNT(DISTINCT Store_ID) AS Active_Stores
FROM Sales;

---------------------------------------------------------
-- Revenue by Store
---------------------------------------------------------

SELECT
    st.Store_ID,
    ROUND(SUM(s.Sales),2) AS Revenue
FROM Stores st
JOIN Sales s
ON st.Store_ID = s.Store_ID
GROUP BY st.Store_ID
ORDER BY Revenue DESC;

---------------------------------------------------------
-- Profit by Store
---------------------------------------------------------

SELECT
    st.Store_ID,
    ROUND(SUM(s.Profit),2) AS Profit
FROM Stores st
JOIN Sales s
ON st.Store_ID = s.Store_ID
GROUP BY st.Store_ID
ORDER BY Profit DESC;

---------------------------------------------------------
-- Quantity Sold by Store
---------------------------------------------------------

SELECT
    st.Store_ID,
    SUM(s.Quantity) AS Units_Sold
FROM Stores st
JOIN Sales s
ON st.Store_ID = s.Store_ID
GROUP BY st.Store_ID
ORDER BY Units_Sold DESC;

---------------------------------------------------------
-- Transactions by Store
---------------------------------------------------------

SELECT
    st.Store_ID,
    COUNT(s.Transaction_ID) AS Transactions
FROM Stores st
JOIN Sales s
ON st.Store_ID = s.Store_ID
GROUP BY st.Store_ID
ORDER BY Transactions DESC;

---------------------------------------------------------
-- Average Order Value by Store
---------------------------------------------------------

SELECT
    st.Store_ID,
    ROUND(AVG(s.Sales),2) AS Average_Order_Value
FROM Stores st
JOIN Sales s
ON st.Store_ID = s.Store_ID
GROUP BY st.Store_ID
ORDER BY Average_Order_Value DESC;

---------------------------------------------------------
-- Revenue by Region
---------------------------------------------------------

SELECT
    st.Region,
    ROUND(SUM(s.Sales),2) AS Revenue
FROM Stores st
JOIN Sales s
ON st.Store_ID = s.Store_ID
GROUP BY st.Region
ORDER BY Revenue DESC;

---------------------------------------------------------
-- Profit by Region
---------------------------------------------------------

SELECT
    st.Region,
    ROUND(SUM(s.Profit),2) AS Profit
FROM Stores st
JOIN Sales s
ON st.Store_ID = s.Store_ID
GROUP BY st.Region
ORDER BY Profit DESC;

---------------------------------------------------------
-- Quantity Sold by Region
---------------------------------------------------------

SELECT
    st.Region,
    SUM(s.Quantity) AS Units_Sold
FROM Stores st
JOIN Sales s
ON st.Store_ID = s.Store_ID
GROUP BY st.Region
ORDER BY Units_Sold DESC;

---------------------------------------------------------
-- Transactions by Region
---------------------------------------------------------

SELECT
    st.Region,
    COUNT(s.Transaction_ID) AS Transactions
FROM Stores st
JOIN Sales s
ON st.Store_ID = s.Store_ID
GROUP BY st.Region
ORDER BY Transactions DESC;

---------------------------------------------------------
-- Best Performing Region
---------------------------------------------------------

SELECT
    st.Region,
    ROUND(SUM(s.Sales),2) AS Revenue
FROM Stores st
JOIN Sales s
ON st.Store_ID = s.Store_ID
GROUP BY st.Region
ORDER BY Revenue DESC
LIMIT 1;

---------------------------------------------------------
-- Best Performing Store
---------------------------------------------------------

SELECT
    st.Store_ID,
    ROUND(SUM(s.Sales),2) AS Revenue
FROM Stores st
JOIN Sales s
ON st.Store_ID = s.Store_ID
GROUP BY st.Store_ID
ORDER BY Revenue DESC
LIMIT 1;

---------------------------------------------------------
-- Revenue by Store Size
---------------------------------------------------------

SELECT
    st.Store_Size,
    ROUND(SUM(s.Sales),2) AS Revenue
FROM Stores st
JOIN Sales s
ON st.Store_ID = s.Store_ID
GROUP BY st.Store_Size
ORDER BY Revenue DESC;

---------------------------------------------------------
-- Profit by Store Size
---------------------------------------------------------

SELECT
    st.Store_Size,
    ROUND(SUM(s.Profit),2) AS Profit
FROM Stores st
JOIN Sales s
ON st.Store_ID = s.Store_ID
GROUP BY st.Store_Size
ORDER BY Profit DESC;

---------------------------------------------------------
-- Manager Performance
---------------------------------------------------------

SELECT
    st.Manager,
    ROUND(SUM(s.Sales),2) AS Revenue
FROM Stores st
JOIN Sales s
ON st.Store_ID = s.Store_ID
GROUP BY st.Manager
ORDER BY Revenue DESC;

---------------------------------------------------------
-- Store Revenue Ranking
---------------------------------------------------------

SELECT
    Store_ID,
    ROUND(SUM(Sales),2) AS Revenue,
    RANK() OVER(
        ORDER BY SUM(Sales) DESC
    ) AS Store_Rank
FROM Sales
GROUP BY Store_ID
ORDER BY Store_Rank;

---------------------------------------------------------
-- Dense Store Ranking
---------------------------------------------------------

SELECT
    Store_ID,
    ROUND(SUM(Sales),2) AS Revenue,
    DENSE_RANK() OVER(
        ORDER BY SUM(Sales) DESC
    ) AS Dense_Rank
FROM Sales
GROUP BY Store_ID
ORDER BY Dense_Rank;

---------------------------------------------------------
-- Top Store in Each Region
---------------------------------------------------------

WITH RankedStores AS
(
SELECT
    st.Region,
    st.Store_ID,
    SUM(s.Sales) AS Revenue,
    ROW_NUMBER() OVER(
        PARTITION BY st.Region
        ORDER BY SUM(s.Sales) DESC
    ) AS Rank_No
FROM Stores st
JOIN Sales s
ON st.Store_ID = s.Store_ID
GROUP BY
    st.Region,
    st.Store_ID
)

SELECT *
FROM RankedStores
WHERE Rank_No = 1;

---------------------------------------------------------
-- Revenue Contribution by Region
---------------------------------------------------------

SELECT
    st.Region,
    ROUND(SUM(s.Sales),2) AS Revenue,
    ROUND(
        SUM(s.Sales) * 100 /
        (SELECT SUM(Sales) FROM Sales),
        2
    ) AS Revenue_Percentage
FROM Stores st
JOIN Sales s
ON st.Store_ID = s.Store_ID
GROUP BY st.Region
ORDER BY Revenue DESC;


/*=========================================================
 Retail Sales & Inventory Analysis
 Module : Inventory Analysis
 Database : retail_sales_analysis
 MySQL Version : 8.0+
=========================================================*/

USE retail_sales_analysis;

---------------------------------------------------------
-- Total Inventory Records
---------------------------------------------------------

SELECT
    COUNT(*) AS Total_Inventory_Records
FROM Inventory;

---------------------------------------------------------
-- Total Stock Available
---------------------------------------------------------

SELECT
    SUM(Stock) AS Total_Stock
FROM Inventory;

---------------------------------------------------------
-- Average Stock per Store
---------------------------------------------------------

SELECT
    Store_ID,
    ROUND(AVG(Stock),2) AS Average_Stock
FROM Inventory
GROUP BY Store_ID
ORDER BY Average_Stock DESC;

---------------------------------------------------------
-- Average Stock per Product
---------------------------------------------------------

SELECT
    Product_ID,
    ROUND(AVG(Stock),2) AS Average_Stock
FROM Inventory
GROUP BY Product_ID
ORDER BY Average_Stock DESC;

---------------------------------------------------------
-- Low Stock Products
---------------------------------------------------------

SELECT
    Product_ID,
    Store_ID,
    Stock,
    Reorder_Level
FROM Inventory
WHERE Stock < Reorder_Level
ORDER BY Stock;

---------------------------------------------------------
-- Products Needing Reorder
---------------------------------------------------------

SELECT
    Product_ID,
    Store_ID,
    Stock,
    Reorder_Level
FROM Inventory
WHERE Stock <= Reorder_Level
ORDER BY Stock;

---------------------------------------------------------
-- Out of Stock Products
---------------------------------------------------------

SELECT
    Product_ID,
    Store_ID,
    Stock
FROM Inventory
WHERE Stock = 0;

---------------------------------------------------------
-- Top 10 Highest Stock Products
---------------------------------------------------------

SELECT
    Product_ID,
    SUM(Stock) AS Total_Stock
FROM Inventory
GROUP BY Product_ID
ORDER BY Total_Stock DESC
LIMIT 10;

---------------------------------------------------------
-- Bottom 10 Stock Products
---------------------------------------------------------

SELECT
    Product_ID,
    SUM(Stock) AS Total_Stock
FROM Inventory
GROUP BY Product_ID
ORDER BY Total_Stock
LIMIT 10;

---------------------------------------------------------
-- Supplier-wise Inventory
---------------------------------------------------------

SELECT
    Supplier,
    SUM(Stock) AS Total_Stock
FROM Inventory
GROUP BY Supplier
ORDER BY Total_Stock DESC;

---------------------------------------------------------
-- Supplier-wise Product Count
---------------------------------------------------------

SELECT
    Supplier,
    COUNT(DISTINCT Product_ID) AS Products
FROM Inventory
GROUP BY Supplier
ORDER BY Products DESC;

---------------------------------------------------------
-- Store-wise Inventory
---------------------------------------------------------

SELECT
    Store_ID,
    SUM(Stock) AS Total_Stock
FROM Inventory
GROUP BY Store_ID
ORDER BY Total_Stock DESC;

---------------------------------------------------------
-- Products Available in Each Store
---------------------------------------------------------

SELECT
    Store_ID,
    COUNT(DISTINCT Product_ID) AS Products_Available
FROM Inventory
GROUP BY Store_ID
ORDER BY Products_Available DESC;

---------------------------------------------------------
-- Inventory Status
---------------------------------------------------------

SELECT
    Product_ID,
    Store_ID,
    Stock,
    CASE
        WHEN Stock = 0 THEN 'Out of Stock'
        WHEN Stock <= Reorder_Level THEN 'Reorder Required'
        WHEN Stock <= Reorder_Level * 1.5 THEN 'Low Stock'
        ELSE 'Healthy Stock'
    END AS Inventory_Status
FROM Inventory
ORDER BY Stock;

---------------------------------------------------------
-- Stock Coverage by Supplier
---------------------------------------------------------

SELECT
    Supplier,
    ROUND(AVG(Stock),2) AS Average_Stock
FROM Inventory
GROUP BY Supplier
ORDER BY Average_Stock DESC;

---------------------------------------------------------
-- Total Reorder Items
---------------------------------------------------------

SELECT
    COUNT(*) AS Products_To_Reorder
FROM Inventory
WHERE Stock <= Reorder_Level;

---------------------------------------------------------
-- Inventory Value
---------------------------------------------------------

SELECT
    p.Product_ID,
    p.Product_Name,
    SUM(i.Stock) AS Stock,
    p.Cost,
    ROUND(SUM(i.Stock) * p.Cost,2) AS Inventory_Value
FROM Inventory i
JOIN Products p
ON i.Product_ID = p.Product_ID
GROUP BY
    p.Product_ID,
    p.Product_Name,
    p.Cost
ORDER BY Inventory_Value DESC;

---------------------------------------------------------
-- Top 10 Inventory Value Products
---------------------------------------------------------

SELECT
    p.Product_Name,
    ROUND(SUM(i.Stock * p.Cost),2) AS Inventory_Value
FROM Inventory i
JOIN Products p
ON i.Product_ID = p.Product_ID
GROUP BY p.Product_Name
ORDER BY Inventory_Value DESC
LIMIT 10;

---------------------------------------------------------
-- Inventory Turnover Ratio
---------------------------------------------------------

SELECT
    p.Product_Name,
    SUM(s.Quantity) AS Quantity_Sold,
    AVG(i.Stock) AS Average_Stock,
    ROUND(
        SUM(s.Quantity) /
        NULLIF(AVG(i.Stock),0),
        2
    ) AS Inventory_Turnover
FROM Products p
JOIN Sales s
ON p.Product_ID = s.Product_ID
JOIN Inventory i
ON p.Product_ID = i.Product_ID
GROUP BY
    p.Product_Name
ORDER BY Inventory_Turnover DESC;

---------------------------------------------------------
-- Stock Ranking
---------------------------------------------------------

SELECT
    Product_ID,
    SUM(Stock) AS Total_Stock,
    RANK() OVER(
        ORDER BY SUM(Stock) DESC
    ) AS Stock_Rank
FROM Inventory
GROUP BY Product_ID
ORDER BY Stock_Rank;


/*=========================================================
 Retail Sales & Inventory Analysis
 Module : Advanced SQL Analysis
 Database : retail_sales_analysis
 MySQL Version : 8.0+
=========================================================*/

USE retail_sales_analysis;

---------------------------------------------------------
-- Product Revenue Ranking
---------------------------------------------------------

SELECT
    p.Product_ID,
    p.Product_Name,
    ROUND(SUM(s.Sales),2) AS Revenue,
    RANK() OVER(
        ORDER BY SUM(s.Sales) DESC
    ) AS Revenue_Rank
FROM Sales s
JOIN Products p
ON s.Product_ID = p.Product_ID
GROUP BY
    p.Product_ID,
    p.Product_Name
ORDER BY Revenue_Rank;

---------------------------------------------------------
-- Dense Revenue Ranking
---------------------------------------------------------

SELECT
    p.Product_ID,
    p.Product_Name,
    ROUND(SUM(s.Sales),2) AS Revenue,
    DENSE_RANK() OVER(
        ORDER BY SUM(s.Sales) DESC
    ) AS Dense_Rank
FROM Sales s
JOIN Products p
ON s.Product_ID = p.Product_ID
GROUP BY
    p.Product_ID,
    p.Product_Name
ORDER BY Dense_Rank;

---------------------------------------------------------
-- Store Revenue Ranking
---------------------------------------------------------

SELECT
    Store_ID,
    ROUND(SUM(Sales),2) AS Revenue,
    RANK() OVER(
        ORDER BY SUM(Sales) DESC
    ) AS Store_Rank
FROM Sales
GROUP BY Store_ID
ORDER BY Store_Rank;

---------------------------------------------------------
-- Customer Revenue Ranking
---------------------------------------------------------

SELECT
    Customer_ID,
    ROUND(SUM(Sales),2) AS Revenue,
    RANK() OVER(
        ORDER BY SUM(Sales) DESC
    ) AS Customer_Rank
FROM Sales
GROUP BY Customer_ID
ORDER BY Customer_Rank;

---------------------------------------------------------
-- Running Total Revenue
---------------------------------------------------------

SELECT
    `Date`,
    SUM(Sales) AS Daily_Revenue,
    SUM(SUM(Sales)) OVER(
        ORDER BY `Date`
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND CURRENT ROW
    ) AS Running_Total
FROM Sales
GROUP BY `Date`
ORDER BY `Date`;

---------------------------------------------------------
-- Monthly Revenue
---------------------------------------------------------

WITH MonthlySales AS
(
SELECT
    YEAR(`Date`) AS Year,
    MONTH(`Date`) AS Month,
    SUM(Sales) AS Revenue
FROM Sales
GROUP BY
    YEAR(`Date`),
    MONTH(`Date`)
)

SELECT *
FROM MonthlySales
ORDER BY Year, Month;

---------------------------------------------------------
-- Previous Month Revenue
---------------------------------------------------------

WITH MonthlySales AS
(
SELECT
    YEAR(`Date`) AS Year,
    MONTH(`Date`) AS Month,
    SUM(Sales) AS Revenue
FROM Sales
GROUP BY
    YEAR(`Date`),
    MONTH(`Date`)
)

SELECT
    Year,
    Month,
    Revenue,
    LAG(Revenue)
    OVER(
        ORDER BY Year, Month
    ) AS Previous_Revenue
FROM MonthlySales;

---------------------------------------------------------
-- Month-over-Month Growth
---------------------------------------------------------

WITH MonthlySales AS
(
SELECT
    YEAR(`Date`) AS Year,
    MONTH(`Date`) AS Month,
    SUM(Sales) AS Revenue
FROM Sales
GROUP BY
    YEAR(`Date`),
    MONTH(`Date`)
)

SELECT
    Year,
    Month,
    Revenue,
    LAG(Revenue)
    OVER(
        ORDER BY Year, Month
    ) AS Previous_Revenue,
    ROUND(
        (
            Revenue -
            LAG(Revenue)
            OVER(
                ORDER BY Year, Month
            )
        ) /
        NULLIF(
            LAG(Revenue)
            OVER(
                ORDER BY Year, Month
            ),
            0
        ) * 100,
        2
    ) AS Growth_Percentage
FROM MonthlySales;

---------------------------------------------------------
-- Top 3 Products in Each Category
---------------------------------------------------------

WITH RankedProducts AS
(
SELECT
    p.Category,
    p.Product_Name,
    SUM(s.Sales) AS Revenue,
    ROW_NUMBER() OVER(
        PARTITION BY p.Category
        ORDER BY SUM(s.Sales) DESC
    ) AS Rank_No
FROM Sales s
JOIN Products p
ON s.Product_ID = p.Product_ID
GROUP BY
    p.Category,
    p.Product_Name
)

SELECT *
FROM RankedProducts
WHERE Rank_No <= 3
ORDER BY Category, Rank_No;

---------------------------------------------------------
-- Top Product in Each Region
---------------------------------------------------------

WITH RegionalSales AS
(
SELECT
    st.Region,
    p.Product_Name,
    SUM(s.Sales) AS Revenue,
    ROW_NUMBER() OVER(
        PARTITION BY st.Region
        ORDER BY SUM(s.Sales) DESC
    ) AS Rank_No
FROM Sales s
JOIN Products p
ON s.Product_ID = p.Product_ID
JOIN Stores st
ON s.Store_ID = st.Store_ID
GROUP BY
    st.Region,
    p.Product_Name
)

SELECT *
FROM RegionalSales
WHERE Rank_No = 1;

---------------------------------------------------------
-- Customer Lifetime Value
---------------------------------------------------------

SELECT
    Customer_ID,
    ROUND(SUM(Sales),2) AS Lifetime_Value
FROM Sales
GROUP BY Customer_ID
ORDER BY Lifetime_Value DESC;

---------------------------------------------------------
-- Running Total by Customer
---------------------------------------------------------

SELECT
    Customer_ID,
    `Date`,
    Sales,
    SUM(Sales) OVER(
        PARTITION BY Customer_ID
        ORDER BY `Date`
    ) AS Running_Total
FROM Sales;

---------------------------------------------------------
-- Running Total by Store
---------------------------------------------------------

SELECT
    Store_ID,
    `Date`,
    Sales,
    SUM(Sales) OVER(
        PARTITION BY Store_ID
        ORDER BY `Date`
    ) AS Running_Total
FROM Sales;

---------------------------------------------------------
-- Daily Revenue with Previous Day
---------------------------------------------------------

WITH DailySales AS
(
SELECT
    `Date`,
    SUM(Sales) AS Revenue
FROM Sales
GROUP BY `Date`
)

SELECT
    `Date`,
    Revenue,
    LAG(Revenue)
    OVER(
        ORDER BY `Date`
    ) AS Previous_Day_Revenue
FROM DailySales;

---------------------------------------------------------
-- 7-Day Rolling Revenue
---------------------------------------------------------

WITH DailySales AS
(
SELECT
    `Date`,
    SUM(Sales) AS Revenue
FROM Sales
GROUP BY `Date`
)

SELECT
    `Date`,
    Revenue,
    ROUND(
        AVG(Revenue)
        OVER(
            ORDER BY `Date`
            ROWS BETWEEN 6 PRECEDING
            AND CURRENT ROW
        ),
        2
    ) AS Rolling_7_Day_Average
FROM DailySales;

---------------------------------------------------------
-- Revenue Contribution by Product
---------------------------------------------------------

SELECT
    p.Product_Name,
    ROUND(SUM(s.Sales),2) AS Revenue,
    ROUND(
        SUM(s.Sales) /
        (SELECT SUM(Sales) FROM Sales)
        *100,
        2
    ) AS Revenue_Percentage
FROM Sales s
JOIN Products p
ON s.Product_ID = p.Product_ID
GROUP BY p.Product_Name
ORDER BY Revenue DESC;

---------------------------------------------------------
-- Cumulative Revenue Percentage (Pareto)
---------------------------------------------------------

WITH ProductRevenue AS
(
SELECT
    p.Product_Name,
    SUM(s.Sales) AS Revenue
FROM Sales s
JOIN Products p
ON s.Product_ID = p.Product_ID
GROUP BY p.Product_Name
)

SELECT
    Product_Name,
    Revenue,
    ROUND(
        SUM(Revenue)
        OVER(
            ORDER BY Revenue DESC
        ) /
        SUM(Revenue)
        OVER()
        *100,
        2
    ) AS Cumulative_Percentage
FROM ProductRevenue;

---------------------------------------------------------
-- Highest Revenue Transaction
---------------------------------------------------------

SELECT *
FROM Sales
ORDER BY Sales DESC
LIMIT 1;

---------------------------------------------------------
-- Lowest Revenue Transaction
---------------------------------------------------------

SELECT *
FROM Sales
ORDER BY Sales
LIMIT 1;

---------------------------------------------------------
-- Revenue Percentile by Customer
---------------------------------------------------------

SELECT
    Customer_ID,
    ROUND(SUM(Sales),2) AS Revenue,
    NTILE(4) OVER(
        ORDER BY SUM(Sales) DESC
    ) AS Revenue_Quartile
FROM Sales
GROUP BY Customer_ID
ORDER BY Revenue DESC;

/*=========================================================
 Retail Sales & Inventory Analysis
 Module : Data Validation & Quality Checks
 Database : retail_sales_analysis
 MySQL Version : 8.0+
=========================================================*/

USE retail_sales_analysis;

---------------------------------------------------------
-- 1. Check NULL Primary Keys
---------------------------------------------------------

SELECT *
FROM Products
WHERE Product_ID IS NULL;

SELECT *
FROM Customers
WHERE Customer_ID IS NULL;

SELECT *
FROM Stores
WHERE Store_ID IS NULL;

SELECT *
FROM Inventory
WHERE Product_ID IS NULL
   OR Store_ID IS NULL;

SELECT *
FROM Sales
WHERE Transaction_ID IS NULL;

---------------------------------------------------------
-- 2. Duplicate Primary Keys
---------------------------------------------------------

SELECT
    Product_ID,
    COUNT(*) AS Duplicate_Count
FROM Products
GROUP BY Product_ID
HAVING COUNT(*) > 1;

SELECT
    Customer_ID,
    COUNT(*) AS Duplicate_Count
FROM Customers
GROUP BY Customer_ID
HAVING COUNT(*) > 1;

SELECT
    Store_ID,
    COUNT(*) AS Duplicate_Count
FROM Stores
GROUP BY Store_ID
HAVING COUNT(*) > 1;

SELECT
    Transaction_ID,
    COUNT(*) AS Duplicate_Count
FROM Sales
GROUP BY Transaction_ID
HAVING COUNT(*) > 1;

---------------------------------------------------------
-- 3. Duplicate Inventory Records
---------------------------------------------------------

SELECT
    Product_ID,
    Store_ID,
    COUNT(*) AS Duplicate_Count
FROM Inventory
GROUP BY
    Product_ID,
    Store_ID
HAVING COUNT(*) > 1;

---------------------------------------------------------
-- 4. NULL Values in Products
---------------------------------------------------------

SELECT *
FROM Products
WHERE Product_Name IS NULL
   OR Category IS NULL
   OR Brand IS NULL
   OR Cost IS NULL
   OR Price IS NULL;

---------------------------------------------------------
-- 5. NULL Values in Customers
---------------------------------------------------------

SELECT *
FROM Customers
WHERE Gender IS NULL
   OR Age IS NULL
   OR City IS NULL
   OR Segment IS NULL;

---------------------------------------------------------
-- 6. NULL Values in Stores
---------------------------------------------------------

SELECT *
FROM Stores
WHERE Region IS NULL
   OR Manager IS NULL
   OR Store_Size IS NULL;

---------------------------------------------------------
-- 7. NULL Values in Inventory
---------------------------------------------------------

SELECT *
FROM Inventory
WHERE Stock IS NULL
   OR Reorder_Level IS NULL
   OR Supplier IS NULL;

---------------------------------------------------------
-- 8. NULL Values in Sales
---------------------------------------------------------

SELECT *
FROM Sales
WHERE Customer_ID IS NULL
   OR Product_ID IS NULL
   OR Store_ID IS NULL
   OR `Date` IS NULL
   OR Quantity IS NULL
   OR Sales IS NULL
   OR Profit IS NULL
   OR Discount IS NULL;

---------------------------------------------------------
-- 9. Invalid Product References
---------------------------------------------------------

SELECT s.*
FROM Sales s
LEFT JOIN Products p
ON s.Product_ID = p.Product_ID
WHERE p.Product_ID IS NULL;

---------------------------------------------------------
-- 10. Invalid Customer References
---------------------------------------------------------

SELECT s.*
FROM Sales s
LEFT JOIN Customers c
ON s.Customer_ID = c.Customer_ID
WHERE c.Customer_ID IS NULL;

---------------------------------------------------------
-- 11. Invalid Store References
---------------------------------------------------------

SELECT s.*
FROM Sales s
LEFT JOIN Stores st
ON s.Store_ID = st.Store_ID
WHERE st.Store_ID IS NULL;

---------------------------------------------------------
-- 12. Invalid Inventory Product References
---------------------------------------------------------

SELECT i.*
FROM Inventory i
LEFT JOIN Products p
ON i.Product_ID = p.Product_ID
WHERE p.Product_ID IS NULL;

---------------------------------------------------------
-- 13. Invalid Inventory Store References
---------------------------------------------------------

SELECT i.*
FROM Inventory i
LEFT JOIN Stores st
ON i.Store_ID = st.Store_ID
WHERE st.Store_ID IS NULL;

---------------------------------------------------------
-- 14. Negative Sales Values
---------------------------------------------------------

SELECT *
FROM Sales
WHERE Sales < 0;

---------------------------------------------------------
-- 15. Negative Profit Values
---------------------------------------------------------

SELECT *
FROM Sales
WHERE Profit < 0;

---------------------------------------------------------
-- 16. Negative Quantity
---------------------------------------------------------

SELECT *
FROM Sales
WHERE Quantity <= 0;

---------------------------------------------------------
-- 17. Negative Stock
---------------------------------------------------------

SELECT *
FROM Inventory
WHERE Stock < 0;

---------------------------------------------------------
-- 18. Products with Cost Greater Than Price
---------------------------------------------------------

SELECT *
FROM Products
WHERE Cost > Price;

---------------------------------------------------------
-- 19. Duplicate Transactions
---------------------------------------------------------

SELECT
    Customer_ID,
    Product_ID,
    Store_ID,
    `Date`,
    Quantity,
    COUNT(*) AS Duplicate_Count
FROM Sales
GROUP BY
    Customer_ID,
    Product_ID,
    Store_ID,
    `Date`,
    Quantity
HAVING COUNT(*) > 1;

---------------------------------------------------------
-- 20. Overall Data Quality Summary
---------------------------------------------------------

SELECT
    (SELECT COUNT(*) FROM Products) AS Total_Products,
    (SELECT COUNT(*) FROM Customers) AS Total_Customers,
    (SELECT COUNT(*) FROM Stores) AS Total_Stores,
    (SELECT COUNT(*) FROM Inventory) AS Total_Inventory_Records,
    (SELECT COUNT(*) FROM Sales) AS Total_Sales_Records,
    (SELECT COUNT(DISTINCT Product_ID) FROM Sales) AS Products_Sold,
    (SELECT COUNT(DISTINCT Customer_ID) FROM Sales) AS Active_Customers,
    (SELECT COUNT(DISTINCT Store_ID) FROM Sales) AS Active_Stores;