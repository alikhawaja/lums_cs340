create database LUMS;
GO
use LUMS;
GO
create schema cs340
go
CREATE TABLE cs340.Students (
    EmployeeID INT NOT NULL PRIMARY KEY, -- This will implicitly create a CLUSTERED index
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    DateOfBirth DATE
);
GO
-- Check the indexes on the table
EXEC sp_helpindex 'cs340.Students';

CREATE TABLE cs340.StudentAddress (
    StudentID INT NOT NULL,
    AddressLine1 NVARCHAR(100),
    AddressLine2 NVARCHAR(100),
    City NVARCHAR(50),
    PostalCode NVARCHAR(20),
    CONSTRAINT PK_StudentAddress PRIMARY KEY NONCLUSTERED (StudentID)
);
GO

EXEC sp_helpindex 'cs340.StudentAddress';



-- 1. Create a New Filegroup
ALTER DATABASE LUMS
ADD FILEGROUP SecondaryFG;
GO

-- 2. Add a Secondary Data File (.ndf) to the New Filegroup
ALTER DATABASE LUMS
ADD FILE (
    NAME = SecondaryDataFile,
    FILENAME = '/var/opt/mssql/data/SecondaryDataFile.ndf', 
    SIZE = 5MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 5MB
)TO FILEGROUP SecondaryFG;
GO

CREATE UNIQUE CLUSTERED INDEX IX_StudentAddress_PostalCode_Clustered
ON cs340.StudentAddress(PostalCode)
ON SecondaryFG; 
GO
-- Check the indexes on the table again
EXEC sp_helpindex 'cs340.StudentAddress';

-- Check the indexes and their filegroups
SELECT
    t.name AS TableName,
    i.name AS IndexName,
    i.type_desc AS IndexType,
    f.name AS FileGroupName
FROM
    sys.indexes AS i
INNER JOIN
    sys.tables AS t ON i.object_id = t.object_id
INNER JOIN
    sys.filegroups AS f ON i.data_space_id = f.data_space_id
WHERE
    t.name = 'StudentAddress'
    AND i.index_id > 0;

