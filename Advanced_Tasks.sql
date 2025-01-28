-- Task 11: Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's_id, member's name, book title, issue date, and days overdue.

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

-- Task 12: Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table).

DELIMITER $$

CREATE PROCEDURE add_return_records(
    IN p_return_id VARCHAR(10), 
    IN p_issued_id VARCHAR(10), 
    IN p_book_quality VARCHAR(10)
)
BEGIN
    DECLARE v_isbn VARCHAR(50);
    DECLARE v_book_name VARCHAR(80);

    -- Insert into return_status based on user input
    INSERT INTO return_status (return_id, issued_id, return_date, book_quality)
    VALUES (p_return_id, p_issued_id, CURDATE(), p_book_quality);

    -- Select the issued book details into variables
    SELECT issued_book_isbn, issued_book_name
    INTO v_isbn, v_book_name
    FROM issued_status
    WHERE issued_id = p_issued_id;

    -- Update the book status
    UPDATE books
    SET status = 'yes'
    WHERE isbn = v_isbn;

    -- Output a message
    SELECT CONCAT('Thank you for returning the book: ', v_book_name) AS Message;
END$$

DELIMITER ;

-- Testing FUNCTION add_return_records

SELECT 
    *
FROM
    books
WHERE
    isbn = '978-0-307-58837-1';

SELECT 
    *
FROM
    issued_status
WHERE
    issued_book_isbn = '978-0-307-58837-1';

SELECT 
    *
FROM
    return_status
WHERE
    issued_id = 'IS135';

-- Call Functions
CALL add_return_records('RS140', 'IS135', 'Good');

CALL add_return_records('RS150', 'IS140', 'Damaged');

-- Task 13: Write a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.

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
    
-- Task 14: Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.

SELECT 
    e.emp_name, b.*, COUNT(ist.issued_id) AS no_book_issued
FROM
    issued_status AS ist
        JOIN
    employees AS e ON e.emp_id = ist.issued_emp_id
        JOIN
    branch AS b ON e.branch_id = b.branch_id
GROUP BY 1 , 2;

-- Task 15: Write a stored procedure that updates the status of a book in the library based on its issuance. The procedure should function as follows: The stored procedure should take the book_id as an input parameter. The procedure should first check if the book is available (status = 'yes'). If the book is available, it should be issued, and the status in the books table should be updated to 'no'. If the book is not available (status = 'no'), the procedure should return an error message indicating that the book is currently not available.

DELIMITER $$

CREATE PROCEDURE issue_book(
    IN p_issued_id VARCHAR(10), 
    IN p_issued_member_id VARCHAR(30), 
    IN p_issued_book_isbn VARCHAR(30), 
    IN p_issued_emp_id VARCHAR(10)
)
BEGIN
    DECLARE v_status VARCHAR(10);

    -- Checking if the book is available ('yes')
    SELECT status 
    INTO v_status
    FROM books
    WHERE isbn = p_issued_book_isbn;

    IF v_status = 'yes' THEN
        -- Insert into issued_status table
        INSERT INTO issued_status(issued_id, issued_member_id, issued_date, issued_book_isbn, issued_emp_id)
        VALUES (p_issued_id, p_issued_member_id, CURDATE(), p_issued_book_isbn, p_issued_emp_id);

        -- Update the books table to set the book status to 'no'
        UPDATE books
        SET status = 'no'
        WHERE isbn = p_issued_book_isbn;

        -- Output message (MySQL doesn’t have RAISE NOTICE, so we use SELECT instead)
        SELECT CONCAT('Book records added successfully for book ISBN: ', p_issued_book_isbn) AS message;

    ELSE
        -- Output message for unavailable book
        SELECT CONCAT('Sorry to inform you the book you have requested is unavailable. Book ISBN: ', p_issued_book_isbn) AS message;
    END IF;
END$$

DELIMITER ;

-- Testing The function issue_book


-- Call Functions
CALL issue_book('IS155', 'C108', '978-0-553-29698-2', 'E104');
CALL issue_book('IS156', 'C108', '978-0-375-41398-8', 'E104');
 