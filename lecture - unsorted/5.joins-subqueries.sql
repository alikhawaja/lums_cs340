SELECT SalesOrderID, ProductID, OrderQty
FROM Sales.SalesOrderDetail
WHERE SalesOrderID = 
    (SELECT MAX(SalesOrderID)
    FROM Sales.SalesOrderHeader);

SELECT CustomerID, SalesOrderID
FROM Sales.SalesOrderHeader
WHERE CustomerID IN (
        SELECT CustomerID
        FROM Sales.Customer
        WHERE TerritoryID IN (
            SELECT TerritoryID
            FROM Sales.SalesTerritory
            WHERE CountryRegionCode = 'CA'));
GO

SELECT SalesOrderID, CustomerID, OrderDate
FROM Sales.SalesOrderHeader AS o1
WHERE SalesOrderID =
    (SELECT MAX(SalesOrderID)
    FROM Sales.SalesOrderHeader AS o2
    WHERE o2.CustomerID = o1.CustomerID)
    ORDER BY CustomerID, OrderDate;
