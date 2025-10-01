USE AdventureWorks2022;
DBCC SHOWFILESTATS
GO

SELECT 
    i.name AS IndexName,
    i.type_desc AS IndexType
FROM 
    sys.indexes i
WHERE i.OBJECT_ID = OBJECT_ID('Person.Address')

-- Create a non-clustered index on the City column of the Person.Address table
CREATE NONCLUSTERED INDEX IX_City_2
ON Person.Address (City);

SELECT 
    i.name AS IndexName,
    i.type_desc AS IndexType,
    ps.used_page_count as UsedPageCount,
    ps.[used_page_count] * 8 AS IndexSizeKB,
    ps.[row_count] AS NumberOfRecords
FROM 
    sys.indexes i
JOIN 
    sys.dm_db_partition_stats ps
ON 
    i.[object_id] = ps.[object_id] AND i.[index_id] = ps.[index_id]
WHERE 
    i.[object_id] = OBJECT_ID('Person.Address');
