-- Create schema
CREATE SCHEMA cs340;
GO
-- Create table
CREATE TABLE cs340.students (
    studentid INT PRIMARY KEY,
    firstname NVARCHAR(50) NOT NULL,
    lastname NVARCHAR(50) NOT NULL,
    year_of_graduation INT NOT NULL
);
GO
-- Create a view to list all students
CREATE VIEW cs340.vw_all_students AS
SELECT studentid, firstname, lastname, year_of_graduation
FROM cs340.students;
GO

-- Create a instead of trigger to prevent updates on the view
CREATE TRIGGER cs340.trg_instead_of_update_vw_all_students
ON cs340.vw_all_students
INSTEAD OF UPDATE
AS
BEGIN
    PRINT 'Updates are not allowed on the vw_all_students view.';
END;
GO
-- Create a stored procedure to add a new student
CREATE PROCEDURE cs340.AddStudent
    @studentid INT,
    @firstname NVARCHAR(50),
    @lastname NVARCHAR(50),
    @year_of_graduation INT
AS
BEGIN
    INSERT INTO cs340.students (studentid, firstname, lastname, year_of_graduation)
    VALUES (@studentid, @firstname, @lastname, @year_of_graduation);
END;
GO
-- Create a stored procedure to update a student's year of graduation
CREATE PROCEDURE cs340.UpdateGraduationYear
    @studentid INT,
    @year_of_graduation INT
AS
BEGIN
    UPDATE cs340.students
    SET year_of_graduation = @year_of_graduation
    WHERE studentid = @studentid;
END;
GO
-- Create an AFTER INSERT trigger to log new students
CREATE TABLE cs340.student_log (
    logid INT IDENTITY(1,1) PRIMARY KEY,
    studentid INT,
    log_date DATETIME DEFAULT GETDATE()
);
GO

CREATE TRIGGER cs340.trg_after_insert_students
ON cs340.students
AFTER INSERT
AS
BEGIN
    INSERT INTO cs340.student_log (studentid)
    SELECT studentid FROM inserted;
END;
GO

-- Create an INSTEAD OF DELETE trigger to prevent deletion
CREATE TRIGGER cs340.trg_instead_of_delete_students
ON cs340.students
INSTEAD OF DELETE
AS
BEGIN
    PRINT 'Deletion is not allowed on the students table.';
END;
GO
-- Test the triggers
INSERT INTO cs340.students (studentid, firstname, lastname, year_of_graduation)
VALUES (3, 'John3', 'Doe3', 2024);
GO
-- Attempt to delete a student (this will be blocked by the trigger)
DELETE FROM cs340.students WHERE studentid = 1;

-- test the view update trigger
UPDATE cs340.vw_all_students
SET firstname = 'Jane'
WHERE studentid = 1; 