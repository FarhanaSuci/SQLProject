--Create table city 
DROP TABLE 
IF 
EXISTS
city;
CREATE TABLE city
(
	city_id	INT PRIMARY KEY,
	city_name VARCHAR(15),	
	population	BIGINT,
	estimated_rent	FLOAT,
	city_rank INT
);

--Create table customers 
DROP TABLE 
IF EXISTS
customers;

CREATE TABLE customers
(
	customer_id INT PRIMARY KEY,	
	customer_name VARCHAR(25),	
	city_id INT,
	CONSTRAINT fk_city FOREIGN KEY (city_id) REFERENCES city(city_id)
);

DROP TABLE products;

CREATE TABLE products
(
	product_id	INT PRIMARY KEY,
	product_name VARCHAR(35),	
	Price float
);
--Create table sales
DROP TABLE  IF EXISTS sales;

CREATE TABLE sales
(
	sale_id	INT PRIMARY KEY,
	sale_date	date,
	product_id	INT,
	customer_id	INT,
	total FLOAT,
	rating INT,
	CONSTRAINT fk_products FOREIGN KEY (product_id) REFERENCES products(product_id),
	CONSTRAINT fk_customers FOREIGN KEY (customer_id) REFERENCES customers(customer_id) 
);

--End of Schema

--After importing , check 
SELECT * FROM city ;
SELECT * FROM products;
SELECT * FROM customers;
SELECT * FROM sales;

--Reports & Data Analysis
-- Q.1 Coffee Consumers Count
-- How many people in each city are estimated to consume coffee, given that 25% of the population does?
SELECT 
   city_name,
   ROUND((population * 0.25)/1000000,2) AS coffe_consumers_in_millions
FROM city
ORDER BY 2 DESC;

-- -- Q.2
-- Total Revenue from Coffee Sales
-- What is the total revenue generated from coffee sales across all cities in the last quarter of 2023?


SELECT * FROM  sales;


SELECT * , EXTRACT(YEAR FROM sale_date) AS year, EXTRACT(quarter FROM sale_date) AS quarter
FROM sales
WHERE 
EXTRACT(YEAR FROM sale_date) = 2023
AND 
	EXTRACT(quarter FROM sale_date) = 4;





SELECT ct.city_name ,SUM(total) AS Total_revenue
FROM sales AS s
JOIN 
customers AS c
ON s.customer_id = c.customer_id
JOIN city AS ct
ON ct.city_id = c.city_id
WHERE 
EXTRACT(YEAR FROM sale_date) = 2023
AND 
	EXTRACT(quarter FROM sale_date) = 4
GROUP BY ct.city_name
ORDER BY 2 DESC;

-- Q.3
-- Sales Count for Each Product
-- How many units of each coffee product have been sold?

SELECT * FROM products;
SELECT * FROM sales;

SELECT p.product_name,COUNT(s.sale_id) AS total_unit FROM
products as p
JOIN
sales AS  s
ON p.product_id = s.product_id
GROUP BY p.product_id
ORDER BY 2 DESC;


-- Q.4
-- Average Sales Amount per City
-- What is the average sales amount per customer in each city?



--city , total sales , 
-- No. of customers each types of city 

SELECT c.city_name,SUM(s.total)AS total_sales,

    ROUND(
        SUM(s.total)::numeric/
		   COUNT(DISTINCT s.customer_id)::numeric
		   ,2) AS Averge_Sales_Per_Customer

,COUNT(DISTINCT cu.customer_id) AS total_customers FROM
city AS c
JOIN customers AS cu
ON c.city_id = cu.city_id
JOIN 
sales AS s
ON s.customer_id = cu.customer_id
GROUP BY c.city_name 
ORDER BY 3 DESC;



-- -- Q.5
-- City Population and Coffee Consumers (25%)
-- Provide a list of cities along with their populations and estimated coffee consumers.
-- return city_name, total current customes, estimated coffee consumers (25%)




SELECT * FROM city ;
SELECT * FROM products;
SELECT * FROM customers;
SELECT * FROM sales;

SELECT city_name,ROUND((population/1000000),2) AS Population_millions,ROUND((population*0.25)/1000000,2) AS Consumers  FROM 
city;


SELECT ci.city_name,ROUND((ci.population/1000000),2) As Population_millions,COUNT(DISTINCT cu.customer_id) AS current_customers, ROUND((ci.population*0.25)/1000000,2) AS 
Consumers_millions FROM 
city as ci 
JOIN customers as cu
ON ci.city_id = cu.city_id
GROUP BY(ci.city_name,ci.population)


