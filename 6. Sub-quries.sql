SELECT SalesOrderID, ProductID, OrderQty
FROM Sales.SalesOrderDetail
WHERE SalesOrderID = 
    (SELECT MAX(SalesOrderID)
    FROM Sales.SalesOrderHeader);


