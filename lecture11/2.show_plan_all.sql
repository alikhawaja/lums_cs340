USE AdventureWorks2022;  
GO 

set STATISTICS io off;  
GO
SET SHOWPLAN_TEXT ON;  
GO  

SELECT *  
FROM Production.Product   
WHERE ProductID = 905;  
GO  
use tempdb;
SELECT *
FROM Employees
WHERE DATEDIFF(DAY, HireDate, GETDATE()) = 1000;
GO

SELECT *
FROM Employees
WHERE HireDate = CAST(DATEADD(DAY, -1000, GETDATE()) AS DATE);

SET SHOWPLAN_TEXT OFF;  
GO