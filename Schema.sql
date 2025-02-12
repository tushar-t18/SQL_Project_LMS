-- Creating Database

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
    
    