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





