
-- Create a new database named SchoolDB
CREATE DATABASE SchoolDB;
GO
-- Switch to the new database
USE SchoolDB;
GO
-- Create a new schema named Academic
CREATE SCHEMA Academic AUTHORIZATION dbo;
GO

--Create a table named Students in the Academic schema
CREATE TABLE Academic.Students (
    StudentID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    DateOfBirth DATE
);
