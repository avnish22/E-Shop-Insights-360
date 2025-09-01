-- CREATE DATABASE-------
-------------------

create database retail_analytics;
use retail_analytics;


-- CREATE TABLES
--1) Product Table
create table Products (
   ProductID int primary key,
   ProductName varchar(100),
   Category varchar(50),
   SubCategory varchar(50),
   Price decimal(10,2),
   Cost decimal(10,2)
   );

-- 2. Customer Table
create table Customers (
    CustomerID int primary key,
	FirstName varchar(50),
	LastName varchar(50),
	Email varchar(100),
	Country varchar(50)
	);

-- 3.Orders Table
create table Orders (
    OrderID int primary key,
	CustomerID int foreign key references Customers(CustomerID),
	OrderDate DATE,
	TotalAmount decimal(10,2)
	);

-- 4. OrderDetails Table
create table OrderDetails(
    OrderDetailID int primary key,
	OrderID int foreign key references Orders(OrderID),
	ProductID int foreign key references Products(ProductID),
	Quantity int,
	UnitPrice decimal(10,2)
	);

--5. Returns Table
CREATE TABLE Returns (
    ReturnID INT PRIMARY KEY,
    OrderDetailID INT FOREIGN KEY REFERENCES OrderDetails(OrderDetailID),
    ReturnDate DATE,
    Reason VARCHAR(100)
);




-----------------------------------------------------------------------------
INSERT INTO Products VALUES
(1,'iPhone 14','Electronics','Mobile',999,750),
(2,'Samsung Galaxy S23','Electronics','Mobile',899,650),
(3,'OnePlus 11','Electronics','Mobile',699,500),
(4,'Dell Inspiron 15','Electronics','Laptop',1200,900),
(5,'HP Pavilion 14','Electronics','Laptop',950,700),
(6,'MacBook Pro 16','Electronics','Laptop',2200,1700),
(7,'Sony WH-1000XM5','Electronics','Headphones',350,220),
(8,'JBL Flip 6','Electronics','Speaker',150,90),
(9,'iPad Pro 12.9','Electronics','Tablet',1300,950),
(10,'Amazon Kindle Paperwhite','Electronics','Tablet',200,120),
(11,'Nike Air Zoom','Fashion','Shoes',120,60),
(12,'Adidas Ultraboost','Fashion','Shoes',180,100),
(13,'Levi’s Jeans','Fashion','Clothing',60,30),
(14,'Zara T-Shirt','Fashion','Clothing',25,10),
(15,'Ray-Ban Sunglasses','Fashion','Accessories',150,80),
(16,'Omega Wrist Watch','Fashion','Accessories',2500,1500),
(17,'BlenderX Pro','Home Appliances','Kitchen',120,70),
(18,'Philips Air Fryer','Home Appliances','Kitchen',250,180),
(19,'LG Microwave','Home Appliances','Kitchen',300,220),
(20,'Samsung Refrigerator','Home Appliances','Kitchen',1200,900),
(21,'Dyson V11 Vacuum','Home Appliances','Cleaning',600,450),
(22,'Bosch Dishwasher','Home Appliances','Kitchen',800,600),
(23,'Wooden Dining Table','Furniture','Living Room',700,400),
(24,'Sofa Set 3-Seater','Furniture','Living Room',1200,800),
(25,'Office Chair','Furniture','Office',250,150),
(26,'King Size Bed','Furniture','Bedroom',1500,1000),
(27,'Study Desk','Furniture','Office',350,200),
(28,'LG 55” OLED TV','Electronics','TV',1400,1000),
(29,'Samsung 65” QLED TV','Electronics','TV',1600,1150),
(30,'Canon DSLR Camera','Electronics','Camera',900,650),
(31,'GoPro Hero 11','Electronics','Camera',450,300),
(32,'Sony PlayStation 5','Electronics','Gaming',500,350),
(33,'Xbox Series X','Electronics','Gaming',500,350),
(34,'Nintendo Switch','Electronics','Gaming',350,220),
(35,'Logitech Gaming Mouse','Electronics','Accessories',70,40),
(36,'Mechanical Keyboard','Electronics','Accessories',120,80),
(37,'Gaming Headset','Electronics','Accessories',150,100),
(38,'Apple Watch','Electronics','Wearables',399,250),
(39,'Fitbit Charge 5','Electronics','Wearables',180,120),
(40,'Samsung Galaxy Watch','Electronics','Wearables',250,170),
(41,'Instant Coffee Maker','Home Appliances','Kitchen',90,50),
(42,'Electric Kettle','Home Appliances','Kitchen',50,30),
(43,'Smart Bulb','Electronics','Smart Home',25,10),
(44,'Smart Thermostat','Electronics','Smart Home',200,150),
(45,'Smart Door Lock','Electronics','Smart Home',300,200),
(46,'Children Toy Car','Toys','Kids',60,30),
(47,'LEGO Classic Set','Toys','Kids',80,40),
(48,'Barbie Doll','Toys','Kids',40,15),
(49,'Board Game – Monopoly','Toys','Games',35,15),
(50,'Cricket Bat','Sports','Outdoor',120,70);


IF OBJECT_ID('tempdb..#FirstNames') IS NOT NULL DROP TABLE #FirstNames;
IF OBJECT_ID('tempdb..#LastNames') IS NOT NULL DROP TABLE #LastNames;

CREATE TABLE #FirstNames (Name VARCHAR(50));
INSERT INTO #FirstNames VALUES 
('John'),('David'),('Michael'),('Chris'),('Daniel'),
('Emma'),('Sophia'),('Olivia'),('Isabella'),('Mia'),
('James'),('Robert'),('William'),('Mary'),('Linda'),
('Aarav'),('Vihaan'),('Krishna'),('Arjun'),('Ishaan'),
('Wei'),('Chen'),('Li'),('Mei'),('Xiang');

CREATE TABLE #LastNames (Name VARCHAR(50));
INSERT INTO #LastNames VALUES 
('Smith'),('Johnson'),('Brown'),('Taylor'),('Anderson'),
('Lee'),('Martinez'),('Garcia'),('Khan'),('Singh'),
('Patel'),('Sharma'),('Gupta'),('Das'),('Roy'),
('Lopez'),('Rodriguez'),('Gonzalez'),('Perez'),('Kim');


-- =======================================
-- Step 3: Generate 1000 Customers
-- =======================================
DECLARE @i INT = 1;
WHILE @i <= 1000
BEGIN
    DECLARE @fname VARCHAR(50) = (SELECT TOP 1 Name FROM #FirstNames ORDER BY NEWID());
    DECLARE @lname VARCHAR(50) = (SELECT TOP 1 Name FROM #LastNames ORDER BY NEWID());
    DECLARE @email VARCHAR(100) = LOWER(CONCAT(@fname,'.',@lname,@i,'@example.com'));

    INSERT INTO Customers (CustomerID, FirstName, LastName, Email, Country)
    VALUES (
        @i,
        @fname,
        @lname,
        @email,
        CASE WHEN @i % 6 = 0 THEN 'USA'
             WHEN @i % 6 = 1 THEN 'UK'
             WHEN @i % 6 = 2 THEN 'India'
             WHEN @i % 6 = 3 THEN 'Spain'
             WHEN @i % 6 = 4 THEN 'China'
             ELSE 'Germany' END
    );

    SET @i = @i + 1;
END;



-- Generate 5000 Orders
-- =======================================

DECLARE @i INT = 1;  

WHILE @i <= 5000
BEGIN
    DECLARE @cust INT = FLOOR(RAND() * 1000) + 1;
    DECLARE @amt DECIMAL(10,2) = FLOOR(RAND() * 2000) + 50;

    INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount)
    VALUES (
        @i,
        @cust,
        DATEADD(DAY, -FLOOR(RAND() * 730), GETDATE()), -- last 2 years ke random date
        @amt
    );

    SET @i = @i + 1;
END;


-- =======================================
-- Generate 10000 OrderDetails
-- =======================================

DECLARE @i INT = 1;

WHILE @i <= 10000
BEGIN
    DECLARE @orderID INT = (SELECT TOP 1 OrderID  FROM Orders   ORDER BY NEWID());
    DECLARE @prodID  INT = (SELECT TOP 1 ProductID FROM Products ORDER BY NEWID());

    DECLARE @qty INT = 1 + ABS(CHECKSUM(NEWID())) % 5;  -- 1..5
    DECLARE @unitPrice DECIMAL(10,2) = (
        SELECT Price FROM Products WHERE ProductID = @prodID
    );

    INSERT INTO OrderDetails (OrderDetailID, OrderID, ProductID, Quantity, UnitPrice)
    VALUES (@i, @orderID, @prodID, @qty, @unitPrice);

    SET @i = @i + 1;
END;

-- =======================================
-- Generate 500 Returns
-- =======================================
DECLARE @i INT = 1;   -- 👈 yaha declare karna zaroori hai

WHILE @i <= 500
BEGIN
    DECLARE @orderDetailID INT = (SELECT TOP 1 OrderDetailID FROM OrderDetails ORDER BY NEWID());

    INSERT INTO Returns (ReturnID, OrderDetailID, ReturnDate, Reason)
    VALUES (
        @i,
        @orderDetailID,
        DATEADD(DAY, FLOOR(RAND() * 180), GETDATE()),  -- last 6 months ke andar random date
        CASE WHEN @i % 3 = 0 THEN 'Defective'
             WHEN @i % 3 = 1 THEN 'Wrong Item'
             ELSE 'Not Needed' END
    );

    SET @i = @i + 1;
END;


select * from Products;
select * from Customers;
select * from Orders;--
select * from OrderDetails;
select * from Returns;

















