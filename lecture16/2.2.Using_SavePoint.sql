USE AdventureWorks2022
GO
---Create a simple table to illustrate:
If Exists(Select 1 from Sysobjects where name ='MYTABLE1')
Drop Table DBO.MYTABLE1
GO
CREATE TABLE DBO.MYTABLE1
(
    ID INT IDENTITY(1, 1),
    EMPLOYEE VARCHAR(30),
    DATE DATETIME
)


--Then we use BEGIN TRANSACTION to open three transactions (TRAN1, TRAN2 and TRAN3) and 
--execute some operations to insert and update. Finally, we made transaction rollback on TRAN1.

BEGIN TRANSACTION TRAN1
 
	INSERT INTO DBO.MYTABLE1 VALUES ('Jon Skeet', GETDATE())
 
BEGIN TRANSACTION TRAN2
 
		INSERT INTO DBO.MYTABLE1 VALUES ('Ed Price', GETDATE())
 
BEGIN TRANSACTION TRAN3
 
		UPDATE DBO.MYTABLE1 SET EMPLOYEE = 'Bob Ward', DATE = GETDATE() WHERE EMPLOYEE = 'Ed Price'
 
ROLLBACK TRANSACTION TRAN1

--Run Following command to see if there is any open transaction i.e no active should be listed as 
--ROLLBACK TRANSACTION TRAN1 has role back everything, all the way to ist statement where TRAN1 was started 


SELECT  
Case
	WHEN transaction_isolation_level= 0 THEN  'Unspecified'
	WHEN transaction_isolation_level= 1 THEN 'ReadUncommitted'
	WHEN transaction_isolation_level= 2 THEN 'ReadCommitted'
	WHEN transaction_isolation_level=3 THEN 'RepeatableRead'
	WHEN transaction_isolation_level=4 THEN 'Serializable'
	WHEN transaction_isolation_level=5  THEN 'Snapshot'
ENd IsolationLevel, S.*
FROM sys.dm_exec_sessions AS s  where open_transaction_count>0

--SQL Server prints three rows affected. We expect the employee inserted into tran1 be discarded and that 
--the employee informed in TRAN3 has overridden the employee in TRAN2. But conducting a search in the table 
--realized that nothing was entered despite the SQL Server has not triggered any error in the execution of the t-sql.
-----Display Result
SELECT * FROM DBO.MYTABLE1

--This shows that the rollback has affected the three transactions even specifying TRAN1. 

----------------------------------------------------------------------------------------------------
--To circumvent this type of obstacle you can use savepoints in transactions.
--Alter the t-sql to:
-----------------------What should be result of below Statement----------------------------------------------------------------------
BEGIN TRANSACTION
 
		INSERT INTO DBO.MYTABLE1 VALUES ('Jon Skeet', GETDATE())
 
	SAVE TRANSACTION SAVEPOINT1
 
		INSERT INTO DBO.MYTABLE1 VALUES ('Ed Price', GETDATE())
 
	ROLLBACK TRANSACTION SAVEPOINT1
 
			UPDATE DBO.MYTABLE1 SET EMPLOYEE = 'Bob Ward', DATE = GETDATE() WHERE EMPLOYEE = 'Ed Price'
 
COMMIT TRANSACTION
--Performing SELECT * FROM MYTABLE gets only Jon Skeet that is the correct.
-- Because of the savepoint SAVEPOINT1 we have rolled back only a defined part of the transaction.
---hence following update staement on Ed Price didn't updates any thing as there is no record with 'Ed price' made to database
SELECT * FROM DBO.MYTABLE1
--CleanUp
Drop Table DBO.MYTABLE1