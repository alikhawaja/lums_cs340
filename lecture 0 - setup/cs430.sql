restore filelistonly FROM DISK = '/var/opt/mssql/data/AdventureWorks2022.bak';
GO
restore filelistonly FROM DISK = '/var/opt/mssql/data/AdventureWorksLT2022.bak';
GO

RESTORE DATABASE AdventureWorks2022 FROM DISK = '/var/opt/mssql/data/AdventureWorks2022.bak'
WITH MOVE 'AdventureWorks2022' TO '/var/opt/mssql/data/AdventureWorks2022_data.mdf',
MOVE 'AdventureWorks2022_log' TO '/var/opt/mssql/logs/AdventureWorks2022_log.ldf';
GO

RESTORE DATABASE AdventureWorksLT2022 FROM DISK = '/var/opt/mssql/data/AdventureWorkslt2022.bak'
WITH MOVE 'AdventureWorksLT2022_Data' TO '/var/opt/mssql/data/AdventureWorkslt2022_data.mdf',
MOVE 'AdventureWorksLT2022_log' TO '/var/opt/mssql/logs/AdventureWorkslt2022_log.ldf';
GO
------------------------------------
SELECT name FROM sys.schemas;
drop database AdventureWorks2022

