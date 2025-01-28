-- Task 1. Write a query to create a New Book Record -- ('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"
 
 INSERT INTO books
 VALUES ('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
SELECT 
    *
FROM
    books;
 
 -- Task 2. Write a query to update an Existing Member's Address
UPDATE members 
SET 
    member_address = '123 middle St'
WHERE
    member_id = 'C101';
SELECT 
    *
FROM
    members;
 
 -- Task 3. Write a query to delete a Record from the Issued Status Table -- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.
 
DELETE FROM issued_status 
WHERE
    issued_id = 'IS121';
SELECT 
    *
FROM
    issued_status;
 
 -- Task 4. Write a query to retrieve all books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.
 
SELECT 
    *
FROM
    issued_status
WHERE
    issued_emp_id = 'E101';
 
 -- Task 5. Write a query to list members who have issued more than one book -- Objective: Use GROUP BY to find members who have issued more than one book.
 
SELECT 
    issued_emp_id, COUNT(*)
FROM
    issued_status
GROUP BY 1
HAVING COUNT(*) > 1;

-- Task 6. Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt.

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

-- Task 8. Write a query to list employees with their branch manager's name and their branch details.

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

-- Task 9. Write a query to retrieve the list of books not yet returned.

SELECT 
    *
FROM
    issued_status AS ist
        LEFT JOIN
    return_status AS rs ON rs.issued_id = ist.issued_id
WHERE
    rs.return_id IS NULL;

-- Task 10. Write a query to create a table of books with rental price above a certain threshold.

CREATE TABLE expensive_books AS SELECT * FROM
    books
WHERE
    rental_price > 7.00;
