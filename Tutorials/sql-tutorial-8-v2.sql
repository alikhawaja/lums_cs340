-- 1. Create the Database
USE MASTER;
GO
IF DB_ID('LUMS') IS NOT NULL
    DROP DATABASE LUMS;
CREATE DATABASE LUMS;
GO


-- Create the View
CREATE VIEW cs340.CS_Students_Details AS
SELECT
    s.student_id,
    s.first_name + ' ' + s.last_name AS full_name,
    s.major,
    a.city,
    r.course_code,
    r.grade
FROM
    cs340.students s
JOIN
    cs340.addresses a ON s.student_id = a.student_id
LEFT JOIN
    cs340.course_registrations r ON s.student_id = r.student_id
WHERE
    s.major = 'CS';
GO
SELECT * FROM cs340.CS_Students_Details WHERE city = 'Lahore';
GO
-- Create an Updatable View (Single Table)
CREATE VIEW cs340.Lahore_Addresses AS
SELECT
    student_id,
    street,
    city,
    postal_code
FROM
    cs340.addresses
WHERE
    city = 'Lahore';
GO
-- Update Data through the View
-- Change student 1001's address (Ali Khan)
UPDATE cs340.Lahore_Addresses
SET street = '25-B New Model Town', postal_code = '54001'
WHERE student_id = 1001;
GO
SELECT student_id, street, postal_code FROM cs340.addresses WHERE student_id = 1001;
GO
-- Create a Non-Updateable View (using aggregation/GROUP BY)
CREATE VIEW cs340.Major_Performance_Summary AS
SELECT
    major,
    COUNT(s.student_id) AS total_students,
    AVG(CASE WHEN r.grade = 'A' THEN 4.0
            WHEN r.grade = 'A-' THEN 3.7
            WHEN r.grade = 'B+' THEN 3.3
            WHEN r.grade = 'B' THEN 3.0
            WHEN r.grade = 'B-' THEN 2.7
            WHEN r.grade = 'C+' THEN 2.3
            WHEN r.grade = 'C' THEN 2.0
            WHEN r.grade = 'C-' THEN 1.7
            WHEN r.grade = 'D+' THEN 1.3
            WHEN r.grade = 'D' THEN 1.0
            WHEN r.grade = 'F' THEN 0.0
            ELSE 2.0 END) AS average_gpa
FROM
    cs340.students s
JOIN
    cs340.course_registrations r ON s.student_id = r.student_id
GROUP BY
    major;
GO
UPDATE cs340.Major_Performance_Summary
SET total_students = 10
WHERE major = 'CS';
GO

-- Create the Stored Procedure
-- Create the Stored Procedure
CREATE PROCEDURE cs340.sp_Update_Student_Major
    @p_student_id INT,
    @p_new_major VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON; -- Prevents returning the count of rows affected

    -- Check if the student exists
    IF NOT EXISTS (SELECT 1 FROM cs340.students WHERE student_id = @p_student_id)
    BEGIN
        -- Use RAISERROR for custom error handling
        RAISERROR('Student ID %d not found.', 16, 1, @p_student_id);
        RETURN 1; -- Return value for error
    END

    -- Update the major
    UPDATE cs340.students
    SET major = @p_new_major
    WHERE student_id = @p_student_id;

    RETURN 0; -- Return value for success
END;
GO

EXEC cs340.sp_Update_Student_Major @p_student_id = 1003, @p_new_major = 'DS';
GO
SELECT student_id, major FROM cs340.students WHERE student_id = 1003;
GO

-- 1. Declare a variable to capture the return status
DECLARE @Status INT;

-- 2. Execute the procedure, assigning the return value to the variable
EXEC @Status = cs340.sp_Update_Student_Major @p_student_id = 1005, @p_new_major = 'DS';

-- 3. Check and display the status
IF @Status = 0
    PRINT 'Procedure executed successfully (Status: ' + CAST(@Status AS VARCHAR) + ')';
ELSE
    PRINT 'Procedure encountered an error (Status: ' + CAST(@Status AS VARCHAR) + ')';
GO
-- Demonstrate error return (using a non-existent ID)
DECLARE @ErrorStatus INT;
EXEC @ErrorStatus = cs340.sp_Update_Student_Major @p_student_id = 9999, @p_new_major = 'Invalid';

-- The RAISERROR will print a message, and the variable will capture the non-zero return value (1).
PRINT 'Error Status Captured: ' + CAST(@ErrorStatus AS VARCHAR);

CREATE TABLE cs340.Address_Audit (
    audit_id INT PRIMARY KEY IDENTITY(1,1),
    student_id INT,
    old_city VARCHAR(50),
    new_city VARCHAR(50),
    change_date DATETIME DEFAULT GETDATE(),
    operation_type VARCHAR(10)
);
GO
CREATE TRIGGER cs340.trg_After_Address_Update
ON cs340.addresses
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if the 'city' column was modified
    IF UPDATE(city)
    BEGIN
        -- Insert the old and new values into the audit table
        INSERT INTO cs340.Address_Audit (student_id, old_city, new_city, operation_type)
        SELECT
            d.student_id,
            d.city AS old_city,
            i.city AS new_city,
            'UPDATE'
        FROM
            DELETED d -- 'DELETED' holds the state *before* the update
        INNER JOIN
            INSERTED i ON d.student_id = i.student_id -- 'INSERTED' holds the state *after* the update
        WHERE
            d.city <> i.city; -- Only log if the city actually changed
    END
END;
GO

-- Update an address
UPDATE cs340.addresses
SET city = 'Lahore Cantt'
WHERE student_id = 1003; -- Zain Malik's city changes from Karachi
GO

SELECT * FROM cs340.Address_Audit WHERE student_id = 1003;
GO

CREATE TRIGGER cs340.trg_InsteadOf_Insert_CS_Details
ON cs340.CS_Students_Details
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Temp variable to store split name parts
    DECLARE @FirstName VARCHAR(50), @LastName VARCHAR(50);
    
    -- 1. Insert into the students table
    -- Since full_name is one column, we have to parse it.
    INSERT INTO cs340.students (student_id, first_name, last_name, major)
    SELECT
        i.student_id,
        LEFT(i.full_name, CHARINDEX(' ', i.full_name) - 1), -- Extract first name
        SUBSTRING(i.full_name, CHARINDEX(' ', i.full_name) + 1, 50), -- Extract last name
        i.major
    FROM
        INSERTED i
    WHERE
        NOT EXISTS (SELECT 1 FROM cs340.students s WHERE s.student_id = i.student_id); -- Only insert if student is new

    -- 2. Insert into the course_registrations table
    INSERT INTO cs340.course_registrations (student_id, course_code, semester, grade)
    SELECT
        student_id,
        course_code,
        'Fall2024', -- Default semester, since the view doesn't contain it in our INSERT statement
        grade
    FROM
        INSERTED
    WHERE course_code IS NOT NULL; -- Ensure a course is provided
END;
GO

-- Insert a new student AND their course registration via the View
INSERT INTO cs340.CS_Students_Details (student_id, full_name, major, course_code, grade)
VALUES (1016, 'Hamza Jamil', 'CS', 'CS340', 'A+');
GO

USE LUMS;
SET IDENTITY_INSERT cs340.course_registrations OFF;
GO
INSERT INTO cs340.course_registrations (registration_id, student_id, course_code, semester, grade) VALUES
(1, 1001, 'CS340', 'Fall2023', 'A'),
(2, 1003, 'CS340', 'Fall2023', 'B+'),
(3, 1005, 'CS340', 'Fall2023', 'A-'),
(4, 1008, 'CS340', 'Fall2023', 'B'),
(5, 1011, 'CS340', 'Fall2023', 'A'),
(6, 1013, 'CS340', 'Fall2023', 'C+'),
(7, 1002, 'EE210', 'Fall2023', 'A'),
(8, 1007, 'EE210', 'Fall2023', 'B'),
(9, 1012, 'EE210', 'Fall2023', 'A-'),
(10, 1004, 'MGMT101', 'Fall2023', 'B+'),
(11, 1009, 'MGMT101', 'Fall2023', 'A'),
(12, 1014, 'MGMT101', 'Fall2023', 'B'),
(13, 1001, 'SS101', 'Spring2023', 'A-'),
(14, 1006, 'SS101', 'Spring2023', 'A'),
(15, 1010, 'SS101', 'Spring2023', 'B+');
GO
SET IDENTITY_INSERT OFF;    

