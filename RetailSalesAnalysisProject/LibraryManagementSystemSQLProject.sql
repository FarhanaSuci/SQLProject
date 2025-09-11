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

--Task 11. Create a Table of Books with Rental Price Above a Certain Threshold ( Here I supposed 8)

SELECT * FROM books
WHERE rental_price >= 8;

--Task 12: Retrieve the List of Books Not Yet Returned
SELECT * FROM return_status;
SELECT * FROM issued_status;
SELECT * FROM books;


SELECT ist.issued_book_name AS Book_title FROM issued_status as ist
LEFT JOIN return_status as rs
ON rs.issued_id = ist.issued_id
WHERE rs.return_id IS NULL


--Advanced Queries
SELECT * FROM books;
SELECT * FROM branch;
SELECT * FROM employees;
SELECT * FROM members;
SELECT * FROM issued_status;
SELECT * FROM return_status;

/*
Task 13: Identify Members with Overdue Books
Write a query to identify members who have overdue books (assume a 30-day return period). 
Display the member's_id, member's name, book title, issue date, and days overdue.
*/

--issued status = members = books == return status
--Filter books which is return 
--- overdue > 30

--(return_date - issued_date) AS Overdue_in_Days
SELECT m.member_id,m.member_name,b.book_title,ist.issued_date,
(CURRENT_DATE - issued_date) AS Overdue_in_Days
FROM 
issued_status AS ist
JOIN
members  AS m
ON ist.issued_member_id = m.member_id
JOIN books as b
ON ist.issued_book_isbn =b.isbn 
LEFT JOIN return_status as r
ON r.issued_id = ist.issued_id
WHERE  r.return_date IS NULL
AND (CURRENT_DATE - issued_date) >30
ORDER BY 1;

/*
Task 14: Branch Performance Report
Create a query that generates a performance report for each branch, showing the number of books issued,
the number of books returned, and the total revenue generated from book rentals.
*/
SELECT * FROM branch;
SELECT * FROM books;
SELECT * FROM issued_status;
select * FROM employees;
SELECT * FROM return_status;

CREATE TABLE 
branch_report
AS
SELECT b.branch_id, COUNT(ist.issued_id) AS number_of_books_issued, COUNT(rs.return_id) 
AS number_of_books_returned ,SUM(bo.rental_price) AS total_revenue
FROM 
branch as b
JOIN 
employees as e
ON b.branch_id = e.branch_id
JOIN
issued_status 
AS ist
ON
ist.issued_emp_id = e.emp_id
LEFT JOIN 
return_status AS rs
ON 
ist.issued_id = rs.issued_id
JOIN 
books as bo
ON
ist.issued_book_isbn=bo.isbn
GROUP BY 1
ORDER BY SUM(bo.rental_price) DESC
;
SELECT * FROM branch_report;

/*
Task 15: Find Employees with the Most Book Issues Processed
Write a query to find the top 3 employees who have processed the most book issues.
Display the employee name, number of books processed, and their branch.*/

SELECT * FROM branch;
SELECT * FROM books;
SELECT * FROM issued_status;
select * FROM employees;
SELECT * FROM return_status;



SELECT 
    e.emp_name,
    COUNT(ist.issued_id) AS No_of_books,
    b.branch_id
FROM branch AS b
JOIN employees AS e
    ON b.branch_id = e.branch_id
JOIN issued_status AS ist
    ON ist.issued_emp_id = e.emp_id
GROUP BY e.emp_name, b.branch_id
ORDER BY COUNT(ist.issued_id) DESC
LIMIT 3;

/*
Task 14: Update Book Status on Return
Write a query to update the status of books in the books table to "Yes"
when they are returned (based on entries in the return_status table).
*/
CREATE OR REPLACE PROCEDURE add_return_records(p_return_id VARCHAR(10), p_issued_id VARCHAR(10), p_book_quality VARCHAR(10))
LANGUAGE plpgsql
AS $$

DECLARE
    v_isbn VARCHAR(50);
    v_book_name VARCHAR(80);
    
BEGIN
    -- all your logic and code
    -- inserting into returns based on users input
    INSERT INTO return_status(return_id, issued_id, return_date, book_quality)
    VALUES
    (p_return_id, p_issued_id, CURRENT_DATE, p_book_quality);

    SELECT 
        issued_book_isbn,
        issued_book_name
        INTO
        v_isbn,
        v_book_name
    FROM issued_status
    WHERE issued_id = p_issued_id;

    UPDATE books
    SET status = 'yes'
    WHERE isbn = v_isbn;

    RAISE NOTICE 'Thank you for returning the book: %', v_book_name;
    
END;
$$


-- Testing FUNCTION add_return_records

issued_id = IS135
ISBN = WHERE isbn = '978-0-307-58837-1'

SELECT * FROM books
WHERE isbn = '978-0-307-58837-1';

SELECT * FROM issued_status
WHERE issued_book_isbn = '978-0-307-58837-1';

SELECT * FROM return_status
WHERE issued_id = 'IS135';

-- calling function 
CALL add_return_records('RS138', 'IS135', 'Good');

-- calling function 
CALL add_return_records('RS148', 'IS140', 'Good');

ALTER TABLE return_status
ADD COLUMN book_quality VARCHAR(10);
