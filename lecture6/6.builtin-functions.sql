use AdventureWorks2022;
SELECT UPPER(Name) AS Product,
       ROUND(ListPrice, 0) AS ApproxPrice,
       YEAR(SellStartDate) AS SoldSince
FROM Production.Product;

use AdventureWorksLT2022;
SELECT AddressType,
       IIF(AddressType = 'Main Office', 'Billing', 'Mailing') AS UseFor
FROM SalesLT.CustomerAddress;

use AdventureWorksLT2022;
SELECT SalesOrderID, Status,
    CHOOSE(Status, 'Ordered', 'Shipped', 'Delivered', 'Cancelled', 'Returned')	AS OrderStatus
FROM SalesLT.SalesOrderHeader;

use AdventureWorks2022;
SELECT TOP(5) ProductID, Name, ListPrice,
	    RANK() OVER(ORDER BY ListPrice DESC) AS RankByPrice
FROM Production.Product
ORDER BY RankByPrice;
