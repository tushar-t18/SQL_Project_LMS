# Library Management System Project using SQL

## Introduction
This project is a Library Management System (LMS) developed using SQL. The system provides a structured and efficient way to manage books, branches, employees, members, and the status of book issuance and returns. It is ideal for understanding how relational databases are used in real-world applications.

![image alt](https://github.com/tushar-t18/SQL_Project_LMS/blob/cc0c0e92943da8be1878ac5295f22ace111d3162/Library.jpg)

## Objectives
- **Build and manage a database for library operations and Implement relationships between entities using foreign keys.**
- **Perform CRUD operations for managing books, members, employees, and transactions.**
- **Develop complex SQL queries for data analysis and reporting.**

## ER Diagram

![image alt](https://github.com/tushar-t18/SQL_Project_LMS/blob/8e18eae956bbd5e4c344e30323ef6a22533e8bec/ER%20Diagram.png)

## Database and Table Creation

~~~sql 
CREATE DATABASE project_lms;

USE project_lms;

-- Creating branch table

	DROP TABLE IF EXISTS branch;
    CREATE TABLE branch (
		branch_id VARCHAR (25) PRIMARY KEY,
        manager_id VARCHAR (25),
        branch_address VARCHAR(100),
        contact_no VARCHAR (25)
    );
    
-- Creating employees table

	DROP TABLE IF EXISTS employees;
    CREATE TABLE employees (
		emp_id VARCHAR (10) PRIMARY KEY,	
        emp_name VARCHAR (25),	
        position VARCHAR (25),	
        salary INT,
		branch_id VARCHAR (25) -- FK
    );    

-- Creating books table

	DROP TABLE IF EXISTS books;
    CREATE TABLE books (
		isbn VARCHAR (25) PRIMARY KEY, 	
        book_title VARCHAR (25),	
        category VARCHAR (25),	
        rental_price FLOAT,	
        status VARCHAR (25),	
        author VARCHAR (25),	
        publisher VARCHAR (50)
	);
    
-- Creating members table

	DROP TABLE IF EXISTS members;
    CREATE TABLE members (
		member_id VARCHAR (25) PRIMARY KEY,	
        member_name	VARCHAR (25),
        member_address VARCHAR (25),	
        reg_date DATE
    );
    
   
-- Creating issued_status table

	DROP TABLE IF EXISTS issued_status;
    CREATE TABLE issued_status (
		issued_id VARCHAR (25) PRIMARY KEY,	
        issued_member_id VARCHAR (25),	-- FK
        issued_book_name VARCHAR (100),
        issued_date DATE,	
        issued_book_isbn VARCHAR (25),	-- FK
        issued_emp_id VARCHAR (25) -- FK
	);    

-- Creating return_status table

	DROP TABLE IF EXISTS return_status;
    CREATE TABLE return_status (
		return_id VARCHAR (25) PRIMARY KEY,	
        issued_id VARCHAR (25),	
        return_book_name VARCHAR (100),	
        return_date DATE,	
        return_book_isbn VARCHAR (25),
        book_quality VARCHAR (10)
        );    
                
-- Creating Foreign Keys

  	ALTER TABLE issued_status
    ADD CONSTRAINT fk_members
    FOREIGN KEY (issued_member_id)
    REFERENCES members (member_id);
        
    ALTER TABLE issued_status
    ADD CONSTRAINT fk_books
    FOREIGN KEY (issued_book_isbn)
    REFERENCES books (isbn);
    
  	ALTER TABLE issued_status
    ADD CONSTRAINT fk_employees
    FOREIGN KEY (issued_emp_id)
    REFERENCES employees (emp_id);
    
    ALTER TABLE employees
    ADD CONSTRAINT fk_branch
    FOREIGN KEY (branch_id)
    REFERENCES branch (branch_id);
    
    ALTER TABLE return_status
    ADD CONSTRAINT fk_issued_status
    FOREIGN KEY (issued_id)
    REFERENCES issued_status (issued_id);
~~~
## CRUD Operations
### Easy to Intermediate Tasks

Task 1. Write a query to create a New Book Record -- ('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"
~~~sql 
 INSERT INTO books
 VALUES ('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
SELECT 
    *
FROM
    books;
 ~~~

Task 2. Write a query to update an Existing Member's Address
~~~sql
UPDATE members 
SET 
    member_address = '123 middle St'
WHERE
    member_id = 'C101';
SELECT 
    *
FROM
    members;
 ~~~

Task 3. Write a query to delete a Record from the Issued Status Table -- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.
~~~sql 
DELETE FROM issued_status 
WHERE
    issued_id = 'IS121';
SELECT 
    *
FROM
    issued_status;
 ~~~

Task 4. Write a query to retrieve all books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.
~~~sql 
SELECT 
    *
FROM
    issued_status
WHERE
    issued_emp_id = 'E101';
 ~~~
 Task 5. Write a query to list members who have issued more than one book -- Objective: Use GROUP BY to find members who have issued more than one book.
 ~~~sql
SELECT 
    issued_emp_id, COUNT(*)
FROM
    issued_status
GROUP BY 1
HAVING COUNT(*) > 1;
~~~

Task 6. Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt.
~~~sql
CREATE TABLE book_issued_cnt AS SELECT b.isbn, b.book_title, COUNT(ist.issued_id) AS issue_count FROM
    issued_status AS ist
        JOIN
    books AS b ON ist.issued_book_isbn = b.isbn
GROUP BY b.isbn , b.book_title;

-- MEDIUM

SELECT 
    b.category, SUM(b.rental_price), COUNT(*)
FROM
    issued_status AS ist
        JOIN
    books AS b ON b.isbn = ist.issued_book_isbn
GROUP BY 1;
~~~

Task 8. Write a query to list employees with their branch manager's name and their branch details.
~~~sql
SELECT 
    e1.emp_id,
    e1.emp_name,
    e1.position,
    e1.salary,
    b.*,
    e2.emp_name AS manager
FROM
    employees AS e1
        JOIN
    branch AS b ON e1.branch_id = b.branch_id
        JOIN
    employees AS e2 ON e2.emp_id = b.manager_id;

~~~

Task 9. Write a query to retrieve the list of books not yet returned.
~~~sql
SELECT 
    *
FROM
    issued_status AS ist
        LEFT JOIN
    return_status AS rs ON rs.issued_id = ist.issued_id
WHERE
    rs.return_id IS NULL;
~~~

Task 10. Write a query to create a table of books with rental price above a certain threshold.
~~~sql
CREATE TABLE expensive_books AS SELECT * FROM
    books
WHERE
    rental_price > 7.00;
~~~

## Advanced Operations
### Advanced Tasks

Task 11. Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's_id, member's name, book title, issue date, and days overdue.
~~~sql
SELECT 
    ist.issued_member_id,
    m.member_name,
    bk.book_title,
    ist.issued_date,
    CURRENT_DATE - ist.issued_date AS over_dues_days
FROM
    issued_status AS ist
        JOIN
    members AS m ON m.member_id = ist.issued_member_id
        JOIN
    books AS bk ON bk.isbn = ist.issued_book_isbn
        LEFT JOIN
    return_status AS rs ON rs.issued_id = ist.issued_id
WHERE
    rs.return_date IS NULL
        AND (CURRENT_DATE - ist.issued_date) > 30
ORDER BY 1;
~~~

Task 12. Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table).
~~~sql
DELIMITER $$

CREATE PROCEDURE add_return_records(
    IN p_return_id VARCHAR(10), 
    IN p_issued_id VARCHAR(10), 
    IN p_book_quality VARCHAR(10)
)
BEGIN
    DECLARE v_isbn VARCHAR(50);
    DECLARE v_book_name VARCHAR(80);

    INSERT INTO return_status (return_id, issued_id, return_date, book_quality)
    VALUES (p_return_id, p_issued_id, CURDATE(), p_book_quality);

    SELECT issued_book_isbn, issued_book_name
    INTO v_isbn, v_book_name
    FROM issued_status
    WHERE issued_id = p_issued_id;

    UPDATE books
    SET status = 'yes'
    WHERE isbn = v_isbn;

    SELECT CONCAT('Thank you for returning the book: ', v_book_name) AS Message;
END$$

DELIMITER ;

-- Call Functions
CALL add_return_records('RS140', 'IS135', 'Good');

CALL add_return_records('RS150', 'IS140', 'Damaged');
~~~

Task 13. Write a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.
~~~sql
CREATE TABLE branch_reports AS SELECT b.branch_id,
    b.manager_id,
    COUNT(ist.issued_id) AS number_book_issued,
    COUNT(rs.return_id) AS number_of_book_return,
    SUM(bk.rental_price) AS total_revenue FROM
    issued_status AS ist
        JOIN
    employees AS e ON e.emp_id = ist.issued_emp_id
        JOIN
    branch AS b ON e.branch_id = b.branch_id
        LEFT JOIN
    return_status AS rs ON rs.issued_id = ist.issued_id
        JOIN
    books AS bk ON ist.issued_book_isbn = bk.isbn
GROUP BY 1 , 2;

SELECT 
    *
FROM
    branch_reports;
~~~
    
Task 14. Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.
~~~sql
SELECT 
    e.emp_name, b.*, COUNT(ist.issued_id) AS no_book_issued
FROM
    issued_status AS ist
        JOIN
    employees AS e ON e.emp_id = ist.issued_emp_id
        JOIN
    branch AS b ON e.branch_id = b.branch_id
GROUP BY 1 , 2;
~~~

Task 15. Write a stored procedure that updates the status of a book in the library based on its issuance. The procedure should function as follows: The stored procedure should take the book_id as an input parameter. The procedure should first check if the book is available (status = 'yes'). If the book is available, it should be issued, and the status in the books table should be updated to 'no'. If the book is not available (status = 'no'), the procedure should return an error message indicating that the book is currently not available.
~~~sql
DELIMITER $$

CREATE PROCEDURE issue_book(
    IN p_issued_id VARCHAR(10), 
    IN p_issued_member_id VARCHAR(30), 
    IN p_issued_book_isbn VARCHAR(30), 
    IN p_issued_emp_id VARCHAR(10)
)
BEGIN
    DECLARE v_status VARCHAR(10);

    SELECT status 
    INTO v_status
    FROM books
    WHERE isbn = p_issued_book_isbn;

    IF v_status = 'yes' THEN
        -- Insert into issued_status table
        INSERT INTO issued_status(issued_id, issued_member_id, issued_date, issued_book_isbn, issued_emp_id)
        VALUES (p_issued_id, p_issued_member_id, CURDATE(), p_issued_book_isbn, p_issued_emp_id);

        UPDATE books
        SET status = 'no'
        WHERE isbn = p_issued_book_isbn;

        SELECT CONCAT('Book records added successfully for book ISBN: ', p_issued_book_isbn) AS message;

    ELSE

        SELECT CONCAT('Sorry to inform you the book you have requested is unavailable. Book ISBN: ', p_issued_book_isbn) AS message;
    END IF;
END$$

DELIMITER ;

-- Call Functions
CALL issue_book('IS155', 'C108', '978-0-553-29698-2', 'E104');
CALL issue_book('IS156', 'C108', '978-0-375-41398-8', 'E104');
~~~

## Reports
- **Database Schema:** Detailed table structures and relationships.
- **Data Analysis:** Insights into book categories, employee salaries, member registration trends, and issued books.
- **Summary Reports:** Aggregated data on high-demand books and employee performance.

## Conclusion
This project demonstrates the application of SQL skills in creating and managing a library management system. It includes database setup, data manipulation, and advanced querying, providing a solid foundation for data management and analysis.

## Contact
- **Email:** [Gmail](mailto:tushardutta8447@gmail.com)
- **Linkedin:** [Linkedin](www.linkedin.com/in/tusharkumar18) 
- **Github:** [Github](https://github.com/tushar-t18)

### Thank you for your interest in this project!
