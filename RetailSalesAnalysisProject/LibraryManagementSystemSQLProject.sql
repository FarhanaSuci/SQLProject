-- Database: LibraryManagementSystem

-- DROP DATABASE IF EXISTS "LibraryManagementSystem";

CREATE DATABASE "LibraryManagementSystem"
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'English_United States.1252'
    LC_CTYPE = 'English_United States.1252'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

--Creating Branch Table
DROP TABLE IF EXISTS branch;
CREATE TABLE branch
   (
      branch_id	      VARCHAR(10) PRIMARY KEY,
	  manager_id	  VARCHAR(10),
	  branch_address  VARCHAR(55),
	  contact_no      VARCHAR(10) 

   );

ALTER TABLE branch
ALTER COLUMN contact_no TYPE VARCHAR(20);

--Creating Employees Table
DROP TABLE IF EXISTS employees ;
CREATE TABLE employees(
emp_id VARCHAR(10) PRIMARY KEY,
emp_name VARCHAR(25),
position VARCHAR(15),
salary INT ,
branch_id VARCHAR(25)

);

--Creating Book Table
DROP TABLE IF EXISTS books;
CREATE TABLE books(
isbn VARCHAR(20) PRIMARY KEY,
book_title VARCHAR(75),
category  VARCHAR(25),	
rental_price FLOAT,
status    VARCHAR(15),
author  VARCHAR(35),
publisher VARCHAR(55)


);

ALTER TABLE books
ALTER COLUMN category TYPE VARCHAR(20);

--Creating Members Table
DROP TABLE IF EXISTS members;
CREATE TABLE members(
member_id VARCHAR(10) PRIMARY KEY,
member_name VARCHAR(25),
member_address  VARCHAR(75),
reg_date  DATE
);

--Creating issued_status Table
DROP TABLE IF EXISTS issued_status;
CREATE TABLE issued_status(
issued_id  VARCHAR(10) PRIMARY KEY,
issued_member_id  VARCHAR(10),
issued_book_name  VARCHAR(75),
issued_date	 DATE,
issued_book_isbn  VARCHAR(25),
issued_emp_id VARCHAR(10)

);

DROP TABLE IF EXISTS return_status;
CREATE TABLE return_status(
return_id VARCHAR(10) PRIMARY KEY,
issued_id VARCHAR(10),
return_book_name VARCHAR(75),
return_date DATE,
return_book_isbn VARCHAR(20)

);



ALTER TABLE issued_status
ADD CONSTRAINT fk_members
FOREIGN KEY (issued_member_id)
REFERENCES members(member_id;





ALTER TABLE issued_status
ADD CONSTRAINT fk_books
FOREIGN KEY (issued_book_isbn)
REFERENCES books(isbn);




ALTER TABLE issued_status
ADD CONSTRAINT fk_employees
FOREIGN KEY (issued_emp_id)
REFERENCES employees(emp_id);




ALTER TABLE employees
ADD CONSTRAINT fk_branch
FOREIGN KEY (branch_id)
REFERENCES branch(branch_id);



ALTER TABLE return_status
ADD CONSTRAINT fk_issued_status
FOREIGN KEY (issued_id)
REFERENCES issued_status(issued_id);

SELECT * FROM issued_status;
DELETE FROM issued_status;
--Just show the tables
SELECT * FROM issued_status;
SELECT * FROM return_status;
SELECT * FROM books;
SELECT * FROM branch;
SELECT * FROM employees;

--Project Task

---CRUD Operations
---Task 1. Create a New Book Record 
-- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 
--'J.B. Lippincott & Co.')"
INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher)
VALUES('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');

SELECT * FROM books;

--Task 2: Update an Existing Member's Address
UPDATE members
SET member_address = '125 Oak St'
WHERE member_id = 'C103';

SELECT * FROM members;

--Task 3: Delete a Record from the Issued Status Table --
--Delete the record with issued_id = 'IS121' from the issued_status table.
DELETE FROM issued_status
WHERE issued_id = 'IS121';

SELECT * FROM issued_status
WHERE issued_id = 'IS121';

---Task 4: Retrieve All Books Issued by a Specific Employee 
-- Select all books issued by the employee with emp_id = 'E101'.
SELECT issued_book_name  FROM issued_status
WHERE issued_emp_id = 'E101';

--Task 5: List Members Who Have Issued More Than One Book 
--  Use GROUP BY to find members who have issued more than one book.
SELECT issued_emp_id, COUNT(issued_id) as Total_book_issued FROM issued_status
GROUP BY (issued_emp_id)
Having COUNT(issued_id) >1 ;

--Task 6: Create 
--Summary Tables: Used CTAS to generate new tables based on query results -
--each book and total book_issued_cnt**
SELECT * FROM issued_status

CREATE TABLE issued_book_counts
AS
SELECT b.isbn,b.book_title,COUNT(issued_book_isbn) as No_of_issues FROM books as b
JOIN issued_status as ist
ON ist.issued_book_isbn = b.isbn 
GROUP BY 1,2;


--Check it

SELECT * FROM issued_book_counts;

---Task 7. Retrieve All Books in a Specific Category:
SELECT * FROM books
WHERE  category = 'Horror';

--Find Total Rental Income by Category:
SELECT * FROM books
SELECT * FROM issued_status

SELECT category,SUM(rental_price) AS Total_Rental_Price,COUNT(*)AS no_of_times_issued  FROM books
JOIN issued_status
ON issued_status.issued_book_isbn = books.isbn
GROUP BY category;

--Task-9. List Members Who Registered in the Last 180 Days:
SELECT * FROM members
WHERE
CURRENT_DATE-reg_date <= 180 ;

INSERT INTO members(member_id,member_name,member_address,reg_date)
VALUES
('F102','Farhana Akter Suci','Noakhali','2025-08-15'),
('F103','Sharmin Sumi','Noakhali','2025-08-18'),
('F104','Arman Islam Ajmir','Noakhali','2025-08-20');

SELECT * FROM members;


--Task 10: List Employees with Their Branch Manager's Name and their branch details:
SELECT * FROM branch ;
SElECT * FROM employees;

SELECT branch.manager_id,employees.emp_name,branch.branch_id,branch.branch_address
FROM branch
JOIN
employees
ON
branch.branch_id=employees.branch_id
GROUP BY (branch.manager_id,employees.emp_name,branch.branch_id,branch.branch_address);

SELECT e2.emp_name AS manager_name, e1.emp_name,branch.branch_id,branch.branch_address
FROM branch
JOIN
employees as e1
ON
branch.branch_id=e1.branch_id
JOIN
employees as e2
ON
branch.manager_id=e2.emp_id

SELECT * FROM manager_employee_information;

Task 11. Create a Table of Books with Rental Price Above a Certain Threshold:

