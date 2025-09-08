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
--sold is more than 4  in the month of  Nov-2022
SELECT 
  category,
  SUM(quantiy)
FROM retail_sales
WHERE category = 'Clothing'
GROUP BY 1;


SELECT 
  category,
  SUM(quantiy)
FROM retail_sales
WHERE category = 'Clothing'
GROUP BY 1;
    
SELECT * 
FROM retail_sales
WHERE category = 'Clothing'
AND 
TO_CHAR(sale_date,'YYYY-MM') = '2022-11'
AND
quantiy >= 4; 

--Q3. Write a SQL Query to calculate the total sales (total_sale) for each category
SELECT category, SUM(total_sale) as Net_sale , COUNT(*) AS TotalOrders
FROM retail_sales
GROUP BY 1;

--Q4. Write a SQL Query to find the average age of customers who purchased items from the Beauty Category 

SELECT ROUND(AVG(age),2) AS  AvrageAge
FROM retail_sales
WHERE category = 'Beauty';

--Q5. Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * FROM retail_sales
WHERE total_sale >  1000;

--Q6. Write a SQL query to find the total number of transactions (transaction-id) made by each gender
--in each category
SELECT category, gender , COUNT(*) as total_transactions
FROM retail_sales
GROUP BY
category,gender;

---Order it BY category
SELECT category, gender , COUNT(*) as total_transactions
FROM retail_sales
GROUP BY
category,gender
ORDER BY 1;

--Q7. Write a SQL query to calculate the average sale for each month . Find out best selling month 
--in each year 
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
	EXTRACT(MONTH FROM sale_date) as month,
	AVG(total_sale) AS avg_sale
	FROM retail_sales
	GROUP BY 1,2
	ORDER BY 1,2;

SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
	EXTRACT(MONTH FROM sale_date) as month,
	AVG(total_sale) AS avg_sale
	FROM retail_sales
	GROUP BY 1,2
	ORDER BY 1,3 DESC;

SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
	EXTRACT(MONTH FROM sale_date) as month,
	AVG(total_sale) AS avg_sale,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC )
	FROM retail_sales
	GROUP BY 1,2;

--Create another table

SELECT * FROM
    (
	SELECT
    EXTRACT(YEAR FROM sale_date) as year,
	EXTRACT(MONTH FROM sale_date) as month,
	AVG(total_sale) AS avg_sale,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC )
	FROM retail_sales
	GROUP BY 1,2) as t1
	WHERE rank=1;

SELECT year,month,avg_sale FROM
    (
	SELECT
    EXTRACT(YEAR FROM sale_date) as year,
	EXTRACT(MONTH FROM sale_date) as month,
	AVG(total_sale) AS avg_sale,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC )
	FROM retail_sales
	GROUP BY 1,2) as t1
	WHERE rank=1;
	
--Question 8. Write a SQL query to find the top 5 customers based on the highest total sales

SELECT customer_id,
SUM(total_sale) AS TotalSales
FROM retail_sales
GROUP BY customer_id
ORDER BY SUM(total_sale) DESC
LIMIT 5;

--Question 9. Write a SQL query to find the number of unique customers who purchased  items from
--each category 

SELECT category, 
COUNT(DISTINCT(customer_id)) 
AS Unique_Customers
FROM retail_sales
GROUP BY category;


--Q.10. Write a SQL query to create each shift and number of orders 
--(Example Morning <= 12, Afternoon Between 12 & 17 ),.Evening > 17

SELECT EXTRACT(HOUR FROM CURRENT_TIME);--Extract our from my system

SELECT * FROM retail_sales;

WITH Hourly_sale 
AS
(
SELECT *,
    CASE 
	  WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
	  WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
	  ELSE 'Evening'
	  END AS shift
FROM retail_sales
)
SELECT 
shift,
COUNT(*) AS Total_orders
FROM Hourly_sale
GROUP BY shift;

---End OF Project
	  





