IF OBJECT_ID('dbo.GetIndexStatsForTable', 'P') IS NOT NULL
    DROP PROCEDURE dbo.GetIndexStatsForTable;
GO
CREATE PROCEDURE dbo.GetIndexStatsForTable
    @TableName NVARCHAR(128)
AS
BEGIN
    SELECT 
        i.name AS IndexName,
        i.type_desc AS IndexType,
        ps.used_page_count AS UsedPageCount,
        ps.[used_page_count] * 8 AS IndexSizeKB,
        ps.[row_count] AS NumberOfRecords
    FROM 
        sys.indexes i
    JOIN 
        sys.dm_db_partition_stats ps
    ON 
        i.[object_id] = ps.[object_id] AND i.[index_id] = ps.[index_id]
    WHERE 
        i.[object_id] = OBJECT_ID(@TableName);
END;
GO

IF OBJECT_ID('dbo.InsertNewAddressData', 'P') IS NOT NULL
    DROP PROCEDURE dbo.InsertNewAddressData;
GO
CREATE PROCEDURE InsertNewAddressData
    @StartIndex INT
AS
BEGIN
    DECLARE @i INT = @StartIndex;
    WHILE @i < @StartIndex + 10000
    BEGIN
        INSERT INTO cs340.NewAddress (AddressID, AddressLine1, City, StateProvinceID, PostalCode, ModifiedDate)
        VALUES (
            @i,
            CONCAT('Address Line 1:', @i),
            CONCAT('City:', @i),
            @i % 50 + 1,
            CONCAT('ZipCode:', @i),
            GETDATE()
        );
        SET @i = @i + 1;
    END;
END;