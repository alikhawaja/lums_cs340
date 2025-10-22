USE master;
CREATE DATABASE LUMS;
GO
USE LUMS; 
GO
CREATE SCHEMA cs340;
GO
CREATE TABLE cs340.students (
    student_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE,
    major VARCHAR(50)
);
GO
INSERT INTO cs340.students (student_id, first_name, last_name, date_of_birth, major) VALUES
(1001, 'Ali', 'Khan', '2003-05-10', 'CS'),
(1002, 'Sara', 'Ahmed', '2004-11-20', 'EE'),
(1003, 'Zain', 'Malik', '2003-01-15', 'CS'),
(1004, 'Aisha', 'Raza', '2005-07-25', 'BBA'),
(1005, 'Omar', 'Butt', '2002-12-01', 'CS'),
(1006, 'Fatima', 'Siddiqui', '2004-03-30', 'HSS'),
(1007, 'Kamran', 'Sheikh', '2003-09-05', 'EE'),
(1008, 'Hina', 'Tariq', '2005-02-18', 'CS'),
(1009, 'Junaid', 'Ali', '2004-06-12', 'BBA'),
(1010, 'Saba', 'Iqbal', '2003-04-22', 'HSS'),
(1011, 'Usman', 'Farooq', '2004-10-14', 'CS'),
(1012, 'Nida', 'Javed', '2002-08-08', 'EE'),
(1013, 'Rehan', 'Shah', '2005-01-28', 'CS'),
(1014, 'Maha', 'Aslam', '2003-03-17', 'BBA'),
(1015, 'Taimoor', 'Zahid', '2004-09-01', 'CS');
GO
CREATE TABLE cs340.addresses (
    address_id INT PRIMARY KEY,
    student_id INT UNIQUE,
    street VARCHAR(100),
    city VARCHAR(50),
    postal_code VARCHAR(10),
    FOREIGN KEY (student_id) REFERENCES cs340.students(student_id)
);
GO
INSERT INTO cs340.addresses (address_id, student_id, street, city, postal_code) VALUES
(1, 1001, '12A Model Town', 'Lahore', '54000'),
(2, 1002, 'B-4 Gulberg', 'Lahore', '54660'),
(3, 1003, '34 Defense Rd', 'Karachi', '75500'),
(4, 1004, '5 Block 10', 'Islamabad', '44000'),
(5, 1005, '10-C DHA Phase 5', 'Lahore', '54792'),
(6, 1006, '7 Railway Colony', 'Multan', '60000'),
(7, 1007, '45 Clifton Block 9', 'Karachi', '75600'),
(8, 1008, '9 Abbott Rd', 'Lahore', '54000'),
(9, 1009, '20 Blue Area', 'Islamabad', '44000'),
(10, 1010, '1 Industrial Area', 'Faisalabad', '38000'),
(11, 1011, '11-B Tech Society', 'Lahore', '54000'),
(12, 1012, '3 Sector F-7/3', 'Islamabad', '44000'),
(13, 1013, '8 Sunset Blvd', 'Karachi', '75600'),
(14, 1014, '15 Mall Road', 'Lahore', '54000'),
(15, 1015, '6 Garden Town', 'Rawalpindi', '46000');
GO
CREATE TABLE cs340.course_registrations (
    registration_id INT PRIMARY KEY,
    student_id INT,
    course_code VARCHAR(10) NOT NULL,
    semester VARCHAR(10) NOT NULL,
    grade VARCHAR(2),
    FOREIGN KEY (student_id) REFERENCES cs340.students(student_id)
);
GO
-- Insert 15 rows of data
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
-- Create the View
CREATE VIEW cs340.CS340_Students_Details AS
SELECT
    s.student_id,
    s.first_name + ' ' + s.last_name AS full_name, -- Use CONCAT(first_name, ' ', last_name) in MySQL/SQL Server
    s.major,
    r.course_code,
    r.semester,
    r.grade
FROM
    cs340.students s
JOIN
    cs340.course_registrations r ON s.student_id = r.student_id
WHERE
    r.course_code = 'CS340';
GO
SELECT * FROM cs340.CS340_Students_Details;
GO
-- Create an Updatable View
CREATE VIEW cs340.Student_Majors AS
SELECT
    student_id,
    first_name,
    major
FROM
    cs340.students
WHERE
    major IN ('CS', 'EE'); -- Filtered subset, still updatable
GO
UPDATE cs340.Student_Majors
SET major = 'DS'
WHERE student_id = 1001;
GO
SELECT major FROM cs340.students WHERE student_id = 1001; -- Output should be 'DS'
GO
-- Create a Non-Updateable View (using aggregation)
CREATE VIEW cs340.Major_Enrollment AS
SELECT
    major,
    COUNT(student_id) AS total_students
FROM
    cs340.students
GROUP BY
    major;
GO

UPDATE cs340.Major_Enrollment
SET total_students = 10
WHERE major = 'CS';
GO

CREATE PROCEDURE cs340.Update_Grade (
    @p_student_id INT,
    @p_course_code VARCHAR(10),
    @p_semester VARCHAR(10),
    @p_new_grade VARCHAR(2)
)
AS
BEGIN
    -- Update the grade in the course_registrations table
    UPDATE cs340.course_registrations
    SET grade = @p_new_grade
    WHERE
        student_id = @p_student_id
        AND course_code = @p_course_code
        AND semester = @p_semester;

    -- Return the number of rows affected 
    SELECT @@ROWCOUNT; 
END;
GO

EXEC cs340.Update_Grade 1001, 'CS340', 'Fall2023', 'A+';


SELECT grade FROM cs340.course_registrations WHERE student_id = 1001 AND course_code = 'CS340'; -- Should show 'A+'
GO

-- Stored Procedure with an OUTPUT Parameter 
CREATE PROCEDURE cs340.Get_Registration_Count (
    @p_student_id INT,
    @p_count INT OUTPUT  -- Define the output parameter
)
AS
BEGIN
    SELECT @p_count = COUNT(*)
    FROM cs340.course_registrations
    WHERE student_id = @p_student_id;
END;
GO

-- Calling the Stored Procedure and retrieving the value

-- 1. Declare a variable to hold the output
DECLARE @RegCount INT;

-- 2. Execute the procedure, passing the variable with the OUTPUT keyword
EXEC cs340.Get_Registration_Count 1001, @RegCount OUTPUT;

-- 3. Display the result
SELECT @RegCount AS Total_Registrations; -- Should return 2 (SS101, CS340)
GO

CREATE TABLE cs340.Major_Audit (
    audit_id INT PRIMARY KEY IDENTITY(1,1), -- Auto-incrementing key
    student_id INT,
    old_major VARCHAR(50),
    new_major VARCHAR(50),
    change_date DATETIME DEFAULT GETDATE() -- Use NOW() or current_timestamp in other systems
);
GO

-- Create the AFTER UPDATE Trigger (SQL Server/T-SQL style)
CREATE TRIGGER cs340.trg_After_Major_Update
ON cs340.students
AFTER UPDATE
AS
BEGIN
    -- Check if the 'major' column was actually updated
    IF UPDATE(major)
    BEGIN
        INSERT INTO cs340.Major_Audit (student_id, old_major, new_major)
        SELECT
            d.student_id, -- 'deleted' pseudo-table holds the pre-update state
            d.major AS old_major,
            i.major AS new_major  -- 'inserted' pseudo-table holds the post-update state
        FROM
            DELETED d
        JOIN
            INSERTED i ON d.student_id = i.student_id
        WHERE
            d.major <> i.major; -- Only log if the major has changed
    END
END;
GO

-- Update a major
UPDATE cs340.students
SET major = 'CS'
WHERE student_id = 1001; -- Changed from 'DS' back to 'CS'
GO

-- Check the Audit Table
SELECT * FROM cs340.Major_Audit WHERE student_id = 1001;
GO

-- Create the INSTEAD OF INSERT Trigger 
CREATE TRIGGER cs340.trg_InsteadOf_Insert_CS340_Details
ON cs340.CS340_Students_Details
INSTEAD OF INSERT
AS
BEGIN
    -- 1. Insert into the students table (only if student_id is new)
    INSERT INTO cs340.students (student_id, first_name, last_name, major)
    SELECT
        i.student_id,
        SUBSTRING(i.full_name, 1, CHARINDEX(' ', i.full_name) - 1) AS first_name,
        SUBSTRING(i.full_name, CHARINDEX(' ', i.full_name) + 1, LEN(i.full_name)) AS last_name,
        i.major
    FROM
        INSERTED i
    LEFT JOIN
        cs340.students s ON i.student_id = s.student_id
    WHERE
        s.student_id IS NULL; -- Only insert if the student doesn't exist

    -- 2. Insert into the course_registrations table
    INSERT INTO cs340.course_registrations (student_id, course_code, semester, grade)
    SELECT
        student_id,
        course_code,
        semester,
        grade
    FROM
        INSERTED;
END;
GO

-- Insert a new student AND registration through the View
-- (Note: This assumes the view allows inserting into full_name, and the code extracts first/last name)
INSERT INTO cs340.CS_Students_Details (student_id, full_name, major, course_code, grade)
VALUES (1016, 'Hamza Jamil', 'CS', 'CS340', 'A+');
GO
