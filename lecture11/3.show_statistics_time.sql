USE AdventureWorks2022;  
GO         

SET STATISTICS TIME ON;  
GO  

SELECT ProductID, StartDate, EndDate, StandardCost   
FROM Production.ProductCostHistory  
WHERE StandardCost < 500.00;  
GO  

SET STATISTICS TIME OFF;  
GO  