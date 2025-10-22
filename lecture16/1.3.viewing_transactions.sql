-- Viewing open transactions by database 
-- You can view open transactions by using the sys.dm_tran_database_transactions DMV. 
-- This DMV returns the following information about currently running transactions 
-- at the database level: 

SELECT Database_transaction_type,* FROM sys.dm_tran_database_transactions;

/*
-- Check under column database_transaction_type 
1 = Read/write transaction 
2 = Read-only transaction 
3 = System transaction 
*/
/* 
-- Check under column database_transaction_state 
1 = The transaction has not been initialized. 
3 = The transaction has been initialized but has not generated any log records. 
4 = The transaction has generated log records. 
5 = The transaction has been prepared. 
10 = The transaction has been committed. 
11 = The transaction has been rolled back. 
12 = The transaction is being committed. In this state, the log record is being generated, but it has not been materialized or persisted. 
*/

-- Now, let's create an open transaction:

USE master
GO

-- First we set the database into SNAPSHOT ISOLATION level
ALTER DATABASE AdventureWorks2022 SET ALLOW_SNAPSHOT_ISOLATION ON
GO

USE AdventureWorks2022;
SET TRANSACTION ISOLATION LEVEL SNAPSHOT;

IF EXISTS (select 1 from sys.objects where object_id = object_id('dbo.table_a') and type = 'U')
	DROP TABLE dbo.table_a
GO	

BEGIN TRANSACTION
CREATE TABLE dbo.table_a
(
          col_1 INT
);

INSERT  INTO table_a (col_1)
VALUES              (1);

	-- now re-run the DMV to check the open transaction 
SELECT DB_NAME(database_id) DbName, * 
FROM sys.dm_tran_database_transactions;
-- Database_ID 32767 is reserved Resource Database

-- The following returns the oldest transaction for a database AdventureWorks2022: 
SELECT * 
FROM SYS.DM_TRAN_DATABASE_TRANSACTIONS 
WHERE DATABASE_ID=DB_ID (N'AdventureWorks2022') order by database_transaction_begin_time ;
-----------------------------------------------------------
-- Viewing open transactions by session 
-----------------------------------------------------------
-- You can view information about transactions at the session level 
-- by using the sys.dm_tran_session_transactions DMV. 
-- The query below generates a list of sessions with the oldest transaction: 
SELECT a.*, last_request_start_time 
FROM sys.dm_tran_session_transactions a 
     join sys.dm_exec_sessions b on a.session_id = b.session_id 
ORDER BY last_request_start_time 

-- The sys.dm_tran_active_transactions DMV returns a list of transactions. 
select * from sys.dm_tran_active_transactions

-- Viewing transactions by using row versioning 
-- The sys.dm_tran_active_snapshot_database_transactions DMV returns rows 
-- for all active transactions in all snapshot-enabled databases. 
-- The query below returns the 10 longest transactions that are using the version store: 

SELECT TOP 10 * -- transaction_id 
FROM sys.dm_tran_active_snapshot_database_transactions 
ORDER BY elapsed_time_seconds 

-- The sys.dm_tran_current_snapshot DMV returns a list of transactions 
-- that are active when each snapshot transaction starts. 
-- The sys.dm_tran_version_store DMV displays all version records in 
-- the version store. Querying this DMV is inefficient to run because it 
-- queries the entire version store, which can be very large. 

-- CLEAN UP

ROLLBACK TRANSACTION

USE master

ALTER DATABASE AdventureWorks2022 SET ALLOW_SNAPSHOT_ISOLATION OFF
GO
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

USE AdventureWorks2022;
GO

IF EXISTS (select 1 from sys.objects where object_id = object_id('dbo.table_a') and type = 'U')
	DROP TABLE dbo.table_a
GO	
