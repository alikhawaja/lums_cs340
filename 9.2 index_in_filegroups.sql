-- Check the location of data files for the database
SELECT 
    name AS LogicalName,
    physical_name AS PhysicalLocation
FROM 
    sys.master_files
WHERE 
    database_id = DB_ID('AdventureWorks2022');

-- Add a new file group to the database
USE AdventureWorks2022;
GO

IF NOT EXISTS (SELECT * FROM sys.filegroups WHERE name = 'AdventureWorks2022_FG')
    BEGIN
        PRINT 'Filegroup does not exist. Creating filegroup...';
        ALTER DATABASE AdventureWorks2022
        ADD FILEGROUP AdventureWorks2022_FG;
    END
ELSE
BEGIN
    PRINT 'Filegroup already exists.';
END

-- Add a new file to the new file group if it does not already exist
IF NOT EXISTS (
    SELECT * 
    FROM sys.database_files 
    WHERE name = N'AdventureWorks2022_Data4'
)
BEGIN
    PRINT 'File does not exist. Adding file to filegroup...';
    ALTER DATABASE AdventureWorks2022
    ADD FILE (
        NAME = N'AdventureWorks2022_Data4',
        FILENAME = N'/var/opt/mssql/data/AdventureWorks2022_Data4.ndf',
        SIZE = 25MB,
        MAXSIZE = 100MB,
        FILEGROWTH = 25MB
    ) TO FILEGROUP AdventureWorks2022_FG;
END
ELSE
BEGIN
    PRINT 'File already exists in the filegroup.';
END


USE AdventureWorks2022;
GO

-- Check if the table already exists, drop it if it does
IF OBJECT_ID('cs340.NewAddress', 'U') IS NOT NULL
BEGIN
    PRINT 'Table cs340.NewAddress already exists. Dropping table...';
    DROP TABLE cs340.NewAddress;
END
ELSE
BEGIN
    PRINT 'Table cs340.NewAddress does not exist.';
END
-- Create a new table with a clustered index in the new file

CREATE TABLE cs340.NewAddress (
    AddressID INT NOT NULL,
    AddressLine1 NVARCHAR(60) NOT NULL,
    City NVARCHAR(30) NOT NULL,
    StateProvinceID INT NOT NULL,
    PostalCode NVARCHAR(15) NOT NULL,
    ModifiedDate DATETIME NOT NULL,
    CONSTRAINT PK_NewAddress PRIMARY KEY CLUSTERED (AddressID)
) ON [AdventureWorks2022_FG];

USE AdventureWorks2022;
GO

TRUNCATE TABLE cs340.NewAddress;
EXEC dbo.GetIndexStatsForTable 'cs340.NewAddress';
EXEC dbo.InsertNewAddressData 1;
EXEC dbo.GetIndexStatsForTable 'cs340.NewAddress';
EXEC dbo.InsertNewAddressData 10001;
EXEC dbo.InsertNewAddressData 20001;
EXEC dbo.GetIndexStatsForTable 'cs340.NewAddress';
TRUNCATE TABLE cs340.NewAddress;
EXEC dbo.GetIndexStatsForTable 'cs340.NewAddress';


----------------------------------------------------------