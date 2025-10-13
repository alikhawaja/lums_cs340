USE tempdb;
GO
 
DROP TABLE IF EXISTS Employees;
 
CREATE TABLE Employees (
EmployeeID INT IDENTITY PRIMARY KEY,
FirstName NVARCHAR(50),
LastName NVARCHAR(50),
HireDate DATE
);
 

-- WITH: Common Table Expression (CTE) to generate a sequence of numbers
-- This CTE generates numbers from 1 to 100,000 by using the ROW_NUMBER() function
-- and cross joining the master.dbo.spt_values table to create a large enough set of rows.

-- Insert sample data from master.dbo.spt_values.
-- The master.dbo.spt_values table in SQL Server is a system table located in the master database, 
-- spt_values stands for "SQL Performance Tuning values".
-- It contains predefined values used by SQL Server for internal operations, such as:
-- This table is undocumented and unsupported for direct use in production code.

WITH Numbers AS (
    SELECT TOP 100000 
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM master.dbo.spt_values a 
        CROSS JOIN master.dbo.spt_values b
)
INSERT INTO Employees (FirstName, LastName, HireDate)
    SELECT
    'First' + CAST(n AS NVARCHAR(10)),
    'Last' + CAST(n AS NVARCHAR(10)),
    DATEADD(DAY, -n % 3650, GETDATE())
FROM Numbers;
 
-- Create index on HireDate
CREATE NONCLUSTERED INDEX idx_HireDate ON Employees(HireDate);

SET SHOWPLAN_TEXT ON 
GO
SET STATISTICS IO ON;
GO

EXEC SP_helpindex 'Employees';
GO

use tempdb;
SELECT *
FROM Employees
WHERE DATEDIFF(DAY, HireDate, GETDATE()) = 1000;
GO

SELECT *
FROM Employees
WHERE HireDate = CAST(DATEADD(DAY, -1000, GETDATE()) AS DATE);