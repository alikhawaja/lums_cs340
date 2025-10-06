/* 
Set up partitioning on a table. 
Implement data rotation through truncating or switching - "sliding windows". 
*/ 
USE master
GO

IF DB_ID('PartitionDB') IS NOT NULL
BEGIN
ALTER DATABASE PartitionDB
SET SINGLE_USER WITH ROLLBACK IMMEDIATE
DROP DATABASE PartitionDB
END
GO

CREATE DATABASE PartitionDB
GO
ALTER DATABASE PartitionDB
SET RECOVERY SIMPLE
GO

/* Create 13 filegroups - one for each month, plus a "leading" partition. */ 
-- C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA
-- C:\Program Files\Microsoft SQL Server\MSSQL15.INS3\MSSQL\DATA
ALTER DATABASE PartitionDB ADD FILEGROUP FG_Before01012018
ALTER DATABASE PartitionDB ADD FILE (Name = FG_Before01012018, FileName = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\PartitionDB_FG_Before01012018.ndf') TO FILEGROUP FG_Before01012018

ALTER DATABASE PartitionDB ADD FILEGROUP FG_012018
ALTER DATABASE PartitionDB ADD FILE (Name = FG_012018, FileName = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\PartitionDB_012018.ndf') TO FILEGROUP FG_012018

ALTER DATABASE PartitionDB ADD FILEGROUP FG_022018
ALTER DATABASE PartitionDB ADD FILE (Name = FG_022018, FileName = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\PartitionDB_022018.ndf') TO FILEGROUP FG_022018
ALTER DATABASE PartitionDB ADD FILEGROUP FG_032018
ALTER DATABASE PartitionDB ADD FILE (Name = FG_032018, FileName = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\PartitionDB_032018.ndf') TO FILEGROUP FG_032018
ALTER DATABASE PartitionDB ADD FILEGROUP FG_042018
ALTER DATABASE PartitionDB ADD FILE (Name = FG_042018, FileName = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\PartitionDB_042018.ndf') TO FILEGROUP FG_042018
ALTER DATABASE PartitionDB ADD FILEGROUP FG_052018
ALTER DATABASE PartitionDB ADD FILE (Name = FG_052018, FileName = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\PartitionDB_052018.ndf') TO FILEGROUP FG_052018
ALTER DATABASE PartitionDB ADD FILEGROUP FG_062018
ALTER DATABASE PartitionDB ADD FILE (Name = FG_062018, FileName = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\PartitionDB_062018.ndf') TO FILEGROUP FG_062018
ALTER DATABASE PartitionDB ADD FILEGROUP FG_072018
ALTER DATABASE PartitionDB ADD FILE (Name = FG_072018, FileName = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\PartitionDB_072018.ndf') TO FILEGROUP FG_072018
ALTER DATABASE PartitionDB ADD FILEGROUP FG_082018
ALTER DATABASE PartitionDB ADD FILE (Name = FG_082018, FileName = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\PartitionDB_082018.ndf') TO FILEGROUP FG_082018
ALTER DATABASE PartitionDB ADD FILEGROUP FG_092018
ALTER DATABASE PartitionDB ADD FILE (Name = FG_092018, FileName = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\PartitionDB_092018.ndf') TO FILEGROUP FG_092018
ALTER DATABASE PartitionDB ADD FILEGROUP FG_102018
ALTER DATABASE PartitionDB ADD FILE (Name = FG_102018, FileName = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\PartitionDB_102018.ndf') TO FILEGROUP FG_102018
ALTER DATABASE PartitionDB ADD FILEGROUP FG_112018
ALTER DATABASE PartitionDB ADD FILE (Name = FG_112018, FileName = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\PartitionDB_112018.ndf') TO FILEGROUP FG_112018
ALTER DATABASE PartitionDB ADD FILEGROUP FG_122018
ALTER DATABASE PartitionDB ADD FILE (Name = FG_122018, FileName = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\PartitionDB_122018.ndf') TO FILEGROUP FG_122018
GO


USE PartitionDB
GO

--Create partition function 
CREATE PARTITION FUNCTION MonthlyPF (DATETIME)
AS RANGE RIGHT FOR VALUES
('01/01/2018','02/01/2018','03/01/2018','04/01/2018','05/01/2018','06/01/2018','07/01/2018','08/01/2018','09/01/2018','10/01/2018','11/01/2018','12/01/2018')
GO

--Create partition scheme 
CREATE PARTITION SCHEME MonthlyPS
AS PARTITION MonthlyPF
TO 
(FG_Before01012018, FG_012018, FG_022018, FG_032018,FG_042018,FG_052018,FG_062018,FG_072018,FG_082018,FG_092018,FG_102018,FG_112018,FG_122018)
GO

--Create table on scheme using partition column 
CREATE TABLE dbo.OrderDetails
(
SalesOrderID int NOT NULL,
SalesOrderDetailID int NOT NULL IDENTITY (1, 1),
CarrierTrackingNumber nvarchar(25) NULL,
OrderQty smallint NOT NULL,
ProductID int NOT NULL,
SpecialOfferID int NOT NULL,
UnitPrice money NOT NULL,
UnitPriceDiscount money NOT NULL,
ModifiedDate datetime NOT NULL
) 
ON MonthlyPS(ModifiedDate)
GO

--Load some data 
DECLARE @DaysBetween INT
DECLARE @StartDay DATE, @EndDay DATE
SELECT @StartDay = '1/1/2018', @EndDay = '10/15/2018'

SET @DaysBetween = DATEDIFF(DAY, @StartDay, @EndDay)
INSERT INTO dbo.OrderDetails 
(
      SalesOrderID, CarrierTrackingNumber, OrderQty, ProductID, 
      SpecialOfferID, UnitPrice, UnitPriceDiscount, 
      ModifiedDate
)
SELECT 
      SalesOrderID, CarrierTrackingNumber, OrderQty, ProductID, 
      SpecialOfferID, UnitPrice, UnitPriceDiscount, 
      DATEADD(DAY, ABS(BINARY_CHECKSUM(NEWID()))% @DaysBetween, @StartDay) 
FROM AdventureWorks2019.Sales.SalesOrderDetail
GO 20

--Views of information 
SELECT *
FROM sys.partition_functions; 
SELECT * 
FROM sys.partition_range_values; 
SELECT * 
FROM sys.partition_parameters; 
SELECT *
FROM sys.partition_schemes; 

--Create this view in all databases that use partitioning for easy access to partition information! 
CREATE OR ALTER VIEW dbo.vwFGDetail
AS
SELECT  
     FunctionName = pf.name,
     SchemeName = ps.name,
     p.partition_number,
     FileGroupName = ds.name,
     ObjectName = OBJECT_NAME(si.object_id),
     RangeBoundary = rv.value,
     RowCnt = SUM(CASE WHEN si.index_id <= 1 THEN p.rows ELSE 0 END), 
	 [Compression] = p.data_compression_desc 
FROM    
     sys.destination_data_spaces AS dds
     JOIN sys.indexes AS si ON dds.partition_scheme_id = si.data_space_id
     JOIN sys.partitions AS p ON si.object_id = p.object_id AND 
           si.index_id = p.index_id AND 
           dds.destination_id = p.partition_number
     JOIN sys.data_spaces AS ds ON dds.data_space_id = ds.data_space_id
     JOIN sys.partition_schemes AS ps ON dds.partition_scheme_id = ps.data_space_id
     JOIN sys.partition_functions AS pf ON ps.function_id = pf.function_id
     LEFT JOIN sys.partition_range_values AS rv ON pf.function_id = rv.function_id
           AND dds.destination_id = CASE pf.boundary_value_on_right
           WHEN 0 THEN rv.boundary_id
           ELSE rv.boundary_id + 1
           END
GROUP BY 
     ds.name, p.partition_number, pf.name, pf.type_desc, pf.fanout,
     pf.boundary_value_on_right, ps.name, si.object_id, rv.value, p.data_compression_desc
GO

SELECT *
FROM vwFGDetail
ORDER BY RangeBoundary ASC
GO


--Create a staging table - this will be a month of orders to switch in. 
DROP TABLE IF EXISTS November2018Orders 
GO
CREATE TABLE dbo.November2018Orders
(
SalesOrderID int NOT NULL,
SalesOrderDetailID int NOT NULL,
CarrierTrackingNumber nvarchar(25) NULL,
OrderQty smallint NOT NULL,
ProductID int NOT NULL,
SpecialOfferID int NOT NULL,
UnitPrice money NOT NULL,
UnitPriceDiscount money NOT NULL,
ModifiedDate datetime NOT NULL
) 
ON FG_112018
GO

--Load data into staging table. 
INSERT INTO dbo.November2018Orders 
(
      SalesOrderID, SalesOrderDetailID, CarrierTrackingNumber, OrderQty, ProductID, 
      SpecialOfferID, UnitPrice, UnitPriceDiscount, 
      ModifiedDate
)
SELECT
      SalesOrderID, SalesOrderDetailID, CarrierTrackingNumber, OrderQty, ProductID, 
      SpecialOfferID, UnitPrice, UnitPriceDiscount, 
      '11/15/2018'
FROM AdventureWorks2019.Sales.SalesOrderDetail
GO 10


--The staging table must have a constraint to make sure only valid data is entered. 
ALTER TABLE November2018Orders
ADD CONSTRAINT chk_November2018Orders CHECK (ModifiedDate >= '11/1/2018' AND ModifiedDate < '12/1/2018')
GO 

SELECT COUNT(SalesOrderID)
FROM November2018Orders; 
--1,213,170 rows 


--This will switch data from the staging table into an empty partition in the OrderDetails table. 
ALTER TABLE November2018Orders
SWITCH TO OrderDetails PARTITION 12; 

--Check number of rows in OrderDetails, partition 12. 
SELECT *
FROM vwFGDetail
ORDER BY RangeBoundary ASC; 
GO 

SELECT COUNT(SalesOrderID)
FROM November2018Orders; 
--0 rows 

--Now, let's delete out the oldest month of data (Jan 2018) in prep for a new year beginning. 

SELECT *
FROM vwFGDetail
ORDER BY RangeBoundary ASC

--Using TRUNCATE to remove data and MERGE to remove partition. 
TRUNCATE TABLE OrderDetails 
WITH (PARTITIONS(2))

SELECT *
FROM vwFGDetail
ORDER BY RangeBoundary ASC
--Partition 2 has 0 rows. 

--Remove the partition. You don't drop a partition, you MERGE boundaries together. 
ALTER PARTITION FUNCTION MonthlyPF ()  
MERGE RANGE ('2018-01-01 00:00:00.000');  

SELECT *
FROM vwFGDetail
ORDER BY RangeBoundary ASC
--Now we have 12 partitions. 



--Using SPLIT, SWITCH, and MERGE to move data to a staging table, then remove the partition. 
ALTER DATABASE PartitionDB ADD FILEGROUP FG_012019 
ALTER DATABASE PartitionDB ADD FILE (Name = FG_012019, FileName = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\PartitionDB_012019.ndf') TO FILEGROUP FG_012019
GO

--This tells the scheme the file group that should be used when a new boundary is added to the function. 
ALTER PARTITION SCHEME MonthlyPS 
NEXT USED FG_012019 


--Add another boundary to the function using SPLIT 
ALTER PARTITION FUNCTION MonthlyPF ()  
SPLIT RANGE ('2019-01-01 00:00:00.000');  

SELECT *
FROM vwFGDetail
ORDER BY RangeBoundary ASC
--Notice where this new partition is added 

--Create table to take old orders 
DROP TABLE IF EXISTS February2018Orders 
GO
CREATE TABLE dbo.February2018Orders
(
SalesOrderID int NOT NULL,
SalesOrderDetailID int NOT NULL,
CarrierTrackingNumber nvarchar(25) NULL,
OrderQty smallint NOT NULL,
ProductID int NOT NULL,
SpecialOfferID int NOT NULL,
UnitPrice money NOT NULL,
UnitPriceDiscount money NOT NULL,
ModifiedDate datetime NOT NULL
) 
ON FG_022018
GO

SELECT *
FROM vwFGDetail
ORDER BY RangeBoundary ASC

ALTER TABLE OrderDetails 
SWITCH PARTITION 2 TO February2018Orders

--Check rows of partition 2 
SELECT *
FROM vwFGDetail
ORDER BY RangeBoundary ASC
GO

SELECT COUNT(*)
FROM February2018Orders


ALTER PARTITION FUNCTION MonthlyPF ()  
MERGE RANGE ('2018-02-01 00:00:00.000');  


/* How partitioning works with maintenance operations */ 

-- Compression 
SELECT *
FROM vwFGDetail
ORDER BY RangeBoundary ASC; 
GO 

ALTER TABLE OrderDetails REBUILD PARTITION = 3 WITH (DATA_COMPRESSION = ROW); 

SELECT *
FROM vwFGDetail
ORDER BY RangeBoundary ASC; 
GO 

-- Backups 
BACKUP DATABASE PartitionDB  
	TO DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\PartitionDB.bak' 
WITH COMPRESSION; 
--3 seconds 

BACKUP DATABASE PartitionDB  
	FILEGROUP = 'FG_012019' 
	TO DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\PartitionDB_FG_012019.bak' 
WITH COMPRESSION; 



-- CHECKDB 
DBCC CHECKFILEGROUP (FG_042018) 
-- Can use NO_INFOMSGS, PHYSICAL_ONLY, MAXDOP, etc. 

--Could set active partitions on read-write filegroups and inactive on read-only filegroups. 
--Write code to back up or check only read-write filegroups. 
 
-- Indexes 
CREATE NONCLUSTERED INDEX IX_OrderDetails_ProductID ON dbo.OrderDetails(ProductID); 
GO 

ALTER INDEX IX_OrderDetails_ProductID ON OrderDetails 
REORGANIZE PARTITION = 2;  

ALTER INDEX IX_OrderDetails_ProductID ON OrderDetails 
REBUILD PARTITION = 2;  

ALTER INDEX IX_OrderDetails_ProductID ON OrderDetails 
REBUILD PARTITION = 2 
WITH (ONLINE = ON); 
 
-- Statistics 
UPDATE STATISTICS OrderDetails 
IX_OrderDetails_ProductID 
WITH RESAMPLE ON PARTITIONS(12); 










-- Incremental statistics 
ALTER INDEX IX_OrderDetails_ProductID ON OrderDetails 
REBUILD 
WITH (STATISTICS_INCREMENTAL = ON); 

UPDATE STATISTICS OrderDetails 
IX_OrderDetails_ProductID 
WITH RESAMPLE ON PARTITIONS(2); 



DBCC SHOW_STATISTICS (OrderDetails, 'IX_OrderDetails_ProductID')



/* Partition elimination 

Turn on Include Actual Execution plans 
 - Query Menu >> Include Actual Execution plans. Or, Ctrl+M.
 - Execute the 3 queries together.
 - Once complete, open the Execution Plans tab.
 - Hover over each table scan and look at the Actual Partition Count value.
 - Alternatively, right-click the table scan >> Properties >> Actual Partition Count. 
 - Query #2, should show 3. Partition elimination!. The other should show 12.
*/

SET STATISTICS IO ON 

SELECT *
FROM OrderDetails; 

SELECT *
FROM OrderDetails
WHERE ModifiedDate >='4/1/2018' AND ModifiedDate < '7/1/2018'; 
-- Hover over the table scan in the plan and look at "Actual Partition Count" to see the partition eliminations.

SELECT SalesOrderID, UnitPrice 
FROM OrderDetails 
WHERE UnitPrice > '10.00'; 