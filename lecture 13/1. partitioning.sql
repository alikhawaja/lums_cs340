/* --------------------------------------------------
-- Create helper function GetNums by Itzik Ben-Gan
-- https://www.itprotoday.com/sql-server/virtual-auxiliary-table-numbers
-- GetNums is used to insert test data
-- https://www.cathrinewilhelmsen.net/table-partitioning-in-sql-server/
-------------------------------------------------- */

-- Drop helper function if it already exists
IF OBJECT_ID('GetNums') IS NOT NULL
    DROP FUNCTION GetNums;
GO

SELECT 1 AS c UNION ALL SELECT 1
GO
-- Create helper function
CREATE FUNCTION GetNums(@n AS BIGINT) RETURNS TABLE AS RETURN
  WITH
  L0   AS(SELECT 1 AS c UNION ALL SELECT 1),
  L1   AS(SELECT 1 AS c FROM L0 AS A CROSS JOIN L0 AS B),
  L2   AS(SELECT 1 AS c FROM L1 AS A CROSS JOIN L1 AS B),
  L3   AS(SELECT 1 AS c FROM L2 AS A CROSS JOIN L2 AS B),
  L4   AS(SELECT 1 AS c FROM L3 AS A CROSS JOIN L3 AS B),
  L5   AS(SELECT 1 AS c FROM L4 AS A CROSS JOIN L4 AS B),
  Nums AS(SELECT ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS n FROM L5)
  SELECT TOP (@n) n FROM Nums ORDER BY n;
GO

/* ------------------------------------------------------------
-- Create example Partitioned Table (Heap)
-- The Partition Column is a DATE column
-- The Partition Function is RANGE RIGHT
-- The Partition Scheme maps all partitions to [PRIMARY]
------------------------------------------------------------ */

-- Drop objects if they already exist
IF EXISTS (SELECT * FROM sys.tables WHERE name = N'Sales')
    DROP TABLE Sales;
IF EXISTS (SELECT * FROM sys.partition_schemes WHERE name = N'psSales')
    DROP PARTITION SCHEME psSales;
IF EXISTS (SELECT * FROM sys.partition_functions WHERE name = N'pfSales')
    DROP PARTITION FUNCTION pfSales;

-- Create the Partition Function 
CREATE PARTITION FUNCTION pfSales (DATE)
AS RANGE RIGHT FOR VALUES 
('2022-01-01', '2023-01-01', '2024-01-01');

-- Create the Partition Scheme
CREATE PARTITION SCHEME psSales
AS PARTITION pfSales 
ALL TO ([Primary]);

-- Create the Partitioned Table (Heap) on the Partition Scheme with SalesDate as the Partition Column
CREATE TABLE Sales (
    SalesDate DATE,
    Quantity INT
) ON psSales(SalesDate);


-- Insert test data
INSERT INTO Sales(SalesDate, Quantity)
SELECT DATEADD(DAY,dates.n-1,'2021-01-01') AS SalesDate, qty.n AS Quantity
FROM GetNums(DATEDIFF(DD,'2021-01-01','2026-01-01')) dates
CROSS JOIN GetNums(1000) AS qty;

exec cs340.sp_ViewPartitionedTableInfo 'Sales';
