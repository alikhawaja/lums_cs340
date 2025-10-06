-- Restore AdventureWorks2022 database in a SQL Server container
RESTORE DATABASE AdventureWorksLT2022
FROM DISK = '/var/opt/mssql/data/AdventureWorksLT2022.bak'
WITH 
    MOVE 'AdventureWorksLT2022_Data' TO '/var/opt/mssql/data/AdventureWorksLT2022.mdf',
    MOVE 'AdventureWorksLT2022_Log' TO '/var/opt/mssql/log/AdventureWorksLT2022.ldf',
    REPLACE;
GO

RESTORE FILELISTONLY
FROM DISK = '/var/opt/mssql/data/AdventureWorks2022.bak'
GO
RESTORE FILELISTONLY
FROM DISK = '/var/opt/mssql/data/AdventureWorksLT2022.bak'
GO