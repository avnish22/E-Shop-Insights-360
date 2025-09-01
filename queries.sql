---Data I have----
select top 1 * from Products;
select top 1 * from Customers;
select top 1 * from Orders;
select top 1 * from OrderDetails;
select top 1 * from Returns;

-- =========================================
-- 1. SALES ANALYSIS
-- =========================================

-- a) What is total sales per month/year + cumalative sales?

SELECT 
    FORMAT(OrderDate,'yyyy-MM') AS Month,
    SUM(TotalAmount) AS MonthlyRevenue,
    SUM(SUM(TotalAmount)) OVER (ORDER BY MIN(OrderDate) ROWS UNBOUNDED PRECEDING) AS CumulativeRevenue
FROM Orders
GROUP BY FORMAT(OrderDate,'yyyy-MM')
ORDER BY Month;


-- b) What are the top 10 products by revenue?

SELECT TOP 10
    p.ProductName,
    SUM(od.Quantity * od.UnitPrice) AS Revenue,
    SUM(od.Quantity) AS UnitsSold
FROM OrderDetails od
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY Revenue DESC;


-- c) What are the Category Wise Sales-Contribution?

SELECT 
    p.Category,
    SUM(od.Quantity * od.UnitPrice) AS Revenue,
    SUM(od.Quantity * od.UnitPrice) * 100 / SUM(SUM(od.Quantity * od.UnitPrice)) OVER () AS RevenuePercentage
FROM OrderDetails od
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY p.Category
ORDER BY Revenue DESC;


-- d) Sales by Country

select c.Country,
SUM(TotalAmount) as Revenue,
COUNT(o.OrderID) AS OrdersCount
from Orders as o
left join Customers as c on o.CustomerID = c.CustomerID
group by c.Country
order by Revenue desc;


-- e) Orders per Month ++++++

select Month(OrderDate) as Month,
count(OrderID) as OrdersCount
from Orders
group by Month(OrderDate)
order by Month;


-- =========================================
-- 2️. Customer Analysis
-- =========================================

-- a) What are the top customers by purchase amount?

select Top 10 
c.FirstName + ' ' + c.LastName as CustomerName,
Sum(TotalAmount) as TotalSpent
--Count(OrderID) as TotalOrder
from Customers as c
left join Orders as o on c.CustomerID = o.CustomerID
GROUP BY c.FirstName, c.LastName
ORDER BY TotalSpent DESC;


-- b) write the name of customer who purchase repeately/ customer retention. / OR MAX ORDERS.

SELECT 
    c.CustomerID,
    c.FirstName + ' ' + c.LastName AS CustomerName,
    COUNT(DISTINCT o.OrderID) AS OrdersCount
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName
HAVING COUNT(DISTINCT o.OrderID) > 1
ORDER BY OrdersCount DESC;


-- c) What is the Customer Segmentation by Revenue

WITH CustomerRevenue AS (
    SELECT 
        c.CustomerID,
        SUM(o.TotalAmount) AS TotalRevenue
    FROM Orders o
    JOIN Customers c ON o.CustomerID = c.CustomerID
    GROUP BY c.CustomerID
)
SELECT
    CASE 
        WHEN TotalRevenue > 8000 THEN 'High-value'
        WHEN TotalRevenue BETWEEN 3500 AND 8000 THEN 'Medium-value'
        ELSE 'Low-value'
    END AS CustomerSegments,
    COUNT(*) AS NumOfCustomer
FROM CustomerRevenue
GROUP BY
    CASE 
        WHEN TotalRevenue > 8000 THEN 'High-value'
        WHEN TotalRevenue BETWEEN 3500 AND 8000 THEN 'Medium-value'
        ELSE 'Low-value'
    END;


-- =========================================
-- 3️ Product Analytics
-- =========================================


--a) what is profit per product?

select p.ProductName,
sum((p.Price - p.Cost) * o.Quantity) as TotalProfit
from Products as p
left join OrderDetails as o on p.ProductID = o.ProductID
group by p.ProductName
order by TotalProfit desc;



-- b) High-Value Products (Revenue + Profit)
SELECT TOP 10
    p.ProductName,
    SUM(od.Quantity * od.UnitPrice) AS Revenue,
    SUM(od.Quantity * (od.UnitPrice - p.Cost)) AS Profit
FROM OrderDetails od
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY Profit DESC, Revenue DESC;


--c) what are the products with high returns?
select p.ProductName,
count(r.ReturnID) as ReturnsCount,
sum(od.Quantity) as UnitsSold,
round(count(r.ReturnID) * 100 / sum(od.Quantity),2) as ReturnPercentage
from Returns as r
left join OrderDetails as od on r.OrderDetailID = od.OrderDetailID
left join Products as p on p.ProductID = od.ProductID
group by p.ProductName
order by ReturnPercentage desc;


---d) what are the low selling products?
select TOP 10 
p.ProductName,
SUM(od.Quantity) AS UnitsSold
from Products as p
left join OrderDetails as od on p.ProductID = od.ProductID
group by p.ProductName
order by UnitsSold;


-- =========================================
-- 4️ Trends & Seasonality
-- =========================================


-- a) Monthly Sales Growth %


WITH MonthlyRevenue AS (
    SELECT 
        FORMAT(OrderDate,'yyyy-MM') AS Month,
        SUM(TotalAmount) AS Revenue
    FROM Orders
    GROUP BY FORMAT(OrderDate,'yyyy-MM')
)
SELECT 
    Month,
    Revenue,
    LAG(Revenue) OVER (ORDER BY Month) AS PrevMonthRevenue,
    CASE 
        WHEN LAG(Revenue) OVER (ORDER BY Month) IS NULL THEN NULL
        ELSE ROUND((Revenue - LAG(Revenue) OVER (ORDER BY Month))*100.0 / LAG(Revenue) OVER (ORDER BY Month),2)
    END AS GrowthPercentage
FROM MonthlyRevenue
ORDER BY Month;
















