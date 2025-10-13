-- Select all records from the Production.Product table
use AdventureWorks2022;
SELECT * FROM Production.Product;
GO

-- List all databases on the SQL Server instance
select * from sys.databases

-- List system database information
SELECT name AS DatabaseName, physical_name AS FileLocation, type_desc AS FileType
FROM sys.master_files
WHERE database_id > 4

--- Details for a specific database (e.g., database_id = 5)
SELECT name AS DatabaseName, physical_name AS FileLocation, type_desc AS FileType
FROM sys.master_files
WHERE database_id = 5;

--- List all SQL Server logins
SELECT name, type_desc, create_date, [type]
FROM sys.server_principals
WHERE type IN ('S', 'U'); -- SQL and Windows logins

--- Switch to the 'model' database and list all tables
USE model;
SELECT name, object_id
FROM sys.tables;

-- Switch back to the 'AdventureWorks2022' database
use AdventureWorks2022;
select name as product, ListPrice * 0.9 as SalePrice
from production.product