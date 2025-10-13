USe AdventureWorks2022;
GO

-- Add a computed column and create an index on it
ALTER TABLE cs340.NewAddress
ADD FullAddress AS (AddressLine1 + ', ' + City + ', ' + CAST(StateProvinceID AS NVARCHAR(10)) + ', ' + PostalCode);

CREATE NONCLUSTERED INDEX IX_FullAddress
ON cs340.NewAddress (FullAddress);
GO

EXEC dbo.GetIndexStatsForTable 'cs340.NewAddress';