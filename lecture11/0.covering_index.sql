SELECT SalesOrderID, OrderDate, TotalDue
FROM Sales.SalesOrderHeader
WHERE CustomerID = 11000;

CREATE NONCLUSTERED INDEX IX_cs340_SalesOrderHeader_CustomerID
ON Sales.SalesOrderHeader (CustomerID)
INCLUDE (SalesOrderID, OrderDate, TotalDue);

SELECT Name, ListPrice, Color
FROM Production.Product
WHERE ProductSubcategoryID = 15;

CREATE NONCLUSTERED INDEX IX_cs340_Product_SubcategoryID
ON Production.Product (ProductSubcategoryID)
INCLUDE (Name, ListPrice, Color);

SELECT BusinessEntityID, JobTitle, HireDate
FROM HumanResources.Employee
WHERE Gender = 'M';


CREATE NONCLUSTERED INDEX IX_cs340_Employee_Gender
ON HumanResources.Employee (Gender)
INCLUDE (BusinessEntityID, JobTitle, HireDate);
