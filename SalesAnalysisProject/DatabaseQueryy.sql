use sales_data;
CREATE TABLE Fact_InternetSales (
    ProductKey INT,
    OrderDateKey DATE,
    DueDateKey DATE,
    ShipDateKey DATE,
    CustomerKey INT,
    SalesOrderNumber VARCHAR(20),
    SalesAmount DECIMAL(10, 4)
);
LOAD DATA INFILE "C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\FACT_InternetSales.csv"
INTO TABLE Fact_InternetSales
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(ProductKey, @OrderDate, @DueDate, @ShipDate, CustomerKey, SalesOrderNumber, SalesAmount)
SET 
    OrderDateKey = STR_TO_DATE(@OrderDate, '%Y%m%d'),
    DueDateKey = STR_TO_DATE(@DueDate, '%Y%m%d'),
    ShipDateKey = STR_TO_DATE(@ShipDate, '%Y%m%d');
SET GLOBAL local_infile = 1;
   
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/FACT_InternetSales.csv'
INTO TABLE Fact_InternetSales
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(ProductKey, @OrderDate, @DueDate, @ShipDate, CustomerKey, SalesOrderNumber, SalesAmount)
SET 
    OrderDateKey = STR_TO_DATE(@OrderDate, '%Y%m%d'),
    DueDateKey = STR_TO_DATE(@DueDate, '%Y%m%d'),
    ShipDateKey = STR_TO_DATE(@ShipDate, '%Y%m%d');
    
CREATE TABLE Dim_Calendar (
    DateKey INT PRIMARY KEY,
    DateValue DATE,
    DayName VARCHAR(10),
    MonthName VARCHAR(20),
    MonthShort VARCHAR(5),
    MonthNo INT,
    Quarter INT,
    Year INT
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Dim_Calendar.csv'
INTO TABLE Dim_Calendar
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(DateKey, @DateVal, DayName, MonthName, MonthShort, MonthNo, Quarter, Year)
SET 
    DateValue = STR_TO_DATE(@DateVal, '%Y-%m-%d');

CREATE TABLE Dim_Customers (
    CustomerKey INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    FullName VARCHAR(100),
    Gender ENUM('Male', 'Female'),
    DateFirstPurchase DATE,
    CustomerCity VARCHAR(100)
);


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Dim_Customers.csv'
INTO TABLE Dim_Customers
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(CustomerKey, FirstName, LastName, FullName, Gender, @DateFirstPurchase, CustomerCity)
SET 
    DateFirstPurchase = STR_TO_DATE(@DateFirstPurchase, '%c/%e/%Y');


CREATE TABLE Dim_Products (
    ProductKey INT PRIMARY KEY,
    ProductItemCode VARCHAR(20),
    ProductName VARCHAR(100),
    SubCategory VARCHAR(100),
    ProductCategory VARCHAR(100),
    ProductColor VARCHAR(50),
    ProductSize VARCHAR(50),
    ProductLine VARCHAR(50),
    ProductModelName VARCHAR(100),
    ProductDescription TEXT,
    ProductStatus VARCHAR(50)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Dim_Products.csv'
INTO TABLE Dim_Products
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(ProductKey, ProductItemCode, ProductName, SubCategory, ProductCategory, ProductColor, ProductSize, ProductLine, ProductModelName, ProductDescription, ProductStatus);

CREATE OR REPLACE VIEW SalesByProduct AS
SELECT 
    p.ProductKey,
    p.ProductName,
    p.ProductCategory,
    SUM(f.SalesAmount) AS TotalSales,
    COUNT(DISTINCT f.SalesOrderNumber) AS TotalOrders
FROM Fact_InternetSales f
JOIN Dim_Products p ON f.ProductKey = p.ProductKey
GROUP BY p.ProductKey, p.ProductName, p.ProductCategory
ORDER BY TotalSales DESC;

CREATE OR REPLACE VIEW SalesByYearMonth AS
SELECT 
    d.Year,
    d.MonthNo,
    d.MonthName,
    SUM(f.SalesAmount) AS TotalSales,
    COUNT(DISTINCT f.SalesOrderNumber) AS TotalOrders
FROM Fact_InternetSales f
JOIN Dim_Calendar d ON f.OrderDateKey = d.DateKey
GROUP BY d.Year, d.MonthNo, d.MonthName
ORDER BY d.Year, d.MonthNo;

CREATE OR REPLACE VIEW SalesByCustomerCityGender AS
SELECT
    c.CustomerCity,
    c.Gender,
    SUM(f.SalesAmount) AS TotalSales,
    COUNT(DISTINCT f.SalesOrderNumber) AS TotalOrders,
    COUNT(DISTINCT f.CustomerKey) AS UniqueCustomers
FROM Fact_InternetSales f
JOIN Dim_Customers c ON f.CustomerKey = c.CustomerKey
GROUP BY c.CustomerCity, c.Gender
ORDER BY c.CustomerCity, c.Gender;


CREATE OR REPLACE VIEW TopCustomersBySell AS
SELECT 
    c.CustomerKey,
    c.FullName,
    c.CustomerCity,
    SUM(f.SalesAmount) AS TotalSales,
    COUNT(DISTINCT f.SalesOrderNumber) AS TotalOrders,
    MIN(d.DateValue) AS FirstPurchaseDate,
    MAX(d.DateValue) AS LastPurchaseDate
FROM Fact_InternetSales f
JOIN Dim_Customers c ON f.CustomerKey = c.CustomerKey
JOIN Dim_Calendar d ON f.OrderDateKey = d.DateKey
GROUP BY c.CustomerKey, c.FullName, c.CustomerCity
ORDER BY TotalSales DESC
LIMIT 20;


CREATE OR REPLACE VIEW ProductStatusSales AS
SELECT
    p.ProductStatus,
    COUNT(DISTINCT p.ProductKey) AS ProductCount,
    SUM(f.SalesAmount) AS TotalSales
FROM Dim_Products p
LEFT JOIN Fact_InternetSales f ON p.ProductKey = f.ProductKey
GROUP BY p.ProductStatus;


CREATE OR REPLACE VIEW SalesByCategorySubcategory AS
SELECT 
    COALESCE(p.ProductCategory, 'Unknown') AS ProductCategory,
    COALESCE(p.SubCategory, 'Unknown') AS SubCategory,
    COUNT(DISTINCT f.SalesOrderNumber) AS TotalOrders,
    COUNT(DISTINCT f.ProductKey) AS UniqueProducts,
    SUM(f.SalesAmount) AS TotalSales
FROM Fact_InternetSales f
JOIN Dim_Products p ON f.ProductKey = p.ProductKey
GROUP BY p.ProductCategory, p.SubCategory
ORDER BY TotalSales DESC;


CREATE OR REPLACE VIEW DailySalesTrend AS
SELECT 
    d.DateValue,
    SUM(f.SalesAmount) AS DailySales,
    COUNT(DISTINCT f.SalesOrderNumber) AS Orders
FROM Fact_InternetSales f
JOIN Dim_Calendar d ON f.OrderDateKey = d.DateKey
GROUP BY d.DateValue
ORDER BY d.DateValue;


CREATE OR REPLACE VIEW SalesByCity AS
SELECT 
    c.CustomerCity,
    COUNT(DISTINCT f.CustomerKey) AS UniqueCustomers,
    COUNT(f.SalesOrderNumber) AS TotalOrders,
    SUM(f.SalesAmount) AS TotalSales
FROM Fact_InternetSales f
JOIN Dim_Customers c ON f.CustomerKey = c.CustomerKey
GROUP BY c.CustomerCity
ORDER BY TotalSales DESC;


CREATE OR REPLACE VIEW AOV_ByMonth AS
SELECT 
    d.Year,
    d.MonthName,
    d.MonthNo,
    ROUND(SUM(f.SalesAmount) / NULLIF(COUNT(DISTINCT f.SalesOrderNumber), 0), 2) AS AvgOrderValue
FROM Fact_InternetSales f
JOIN Dim_Calendar d ON f.OrderDateKey = d.DateKey
GROUP BY d.Year, d.MonthName, d.MonthNo
ORDER BY d.Year, d.MonthNo;


CREATE OR REPLACE VIEW YoYSales AS
SELECT 
    d.Year,
    SUM(f.SalesAmount) AS TotalSales
FROM Fact_InternetSales f
JOIN Dim_Calendar d ON f.OrderDateKey = d.DateKey
GROUP BY d.Year
ORDER BY d.Year;

-- Make sure Dim_Calendar.DateKey is also INT
-- or convert during join
-- Check OrderDateKey data type and values
SELECT OrderDateKey, DATE_FORMAT(OrderDateKey, '%Y-%m-%d') AS FormattedKey, 
       DATE(OrderDateKey) AS DateCast
FROM Fact_InternetSales
LIMIT 5;

-- Check DateValue data type and values
SELECT DateValue, DATE_FORMAT(DateValue, '%Y-%m-%d') AS FormattedVal, 
       DATE(DateValue) AS DateCast
FROM Dim_Calendar
LIMIT 5;

SELECT DISTINCT f.OrderDateKey
FROM Fact_InternetSales f
WHERE NOT EXISTS (
    SELECT 1 FROM Dim_Calendar d
    WHERE d.DateValue = f.OrderDateKey
);










