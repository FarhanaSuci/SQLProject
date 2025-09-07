-- Database: RetailSalesAnalysisProject

-- DROP DATABASE IF EXISTS "RetailSalesAnalysisProject";

CREATE DATABASE "RetailSalesAnalysisProject"
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'English_United States.1252'
    LC_CTYPE = 'English_United States.1252'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

--Create Table
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
(
   transactions_id INT PRIMARY KEY,
   sale_date DATE,
   sale_time TIME,
   customer_id INT,
   gender  VARCHAR(15),
   age	INT,
   category  VARCHAR(15),
   quantiy   INT,
   price_per_unit FLOAT,
   cogs           FLOAT,
   total_sale  FLOAT

);

--Show 1st 10 records
SELECT * FROM retail_sales
LIMIT 10;

--Total records
SELECT
  COUNT(*)
FROM retail_sales;

--Check null value of a field
SELECT * FROM retail_sales 
WHERE transactions_id IS NULL;

SELECT * FROM retail_sales 
WHERE sale_date IS NULL;

SELECT * FROM retail_sales 
WHERE sale_time IS NULL;

SELECT * FROM retail_sales
WHERE customer_id  IS NULL;

SELECT * FROM retail_sales
WHERE gender  IS NULL;

SELECT * FROM retail_sales
WHERE age  IS NULL;
--Data Cleaning 
--ALL  In ONE 
SELECT * FROM retail_sales 
WHERE 
    transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	customer_id  IS NULL
	OR
	gender  IS NULL
	OR
	age  IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR 
	cogs IS NULL
	OR total_sale IS NULL;
	
---Deleting Null Values
DELETE FROM retail_sales
WHERE 
    transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	customer_id  IS NULL
	OR
	gender  IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR 
	cogs IS NULL
	OR total_sale IS NULL;

--- Data Exploration 
--- How many sales we have right?
SELECT 
   COUNT(*) AS totalSale
   FROM retail_sales;

---How many customers we have ?
SELECT
  COUNT(customer_id) AS totalCustomer 
  FROM retail_sales;

---How many unique customers we have ?
SELECT
  COUNT(DISTINCT(customer_id)) AS totalCustomer 
  FROM retail_sales;

---How many unique Categries we have ?
SELECT
  COUNT(DISTINCT(customer_id)) AS totalCustomer 
  FROM retail_sales;

---Data Analysis & Business Key Problems & Answers


--1.Write a SQL Query to retrieve all customers for sales made on "2022-11-05"

SELECT *
FROM retail_sales 
WHERE sale_date ='2022-11-05';

--2.Write a SQL Query to retrieve all transactions where the Category is Clothing and the Quantity 
--sold is more than 10  in the month of  Nov-2022

	

