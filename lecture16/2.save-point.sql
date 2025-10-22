if(OBJECT_ID('TestTable') IS NOT NULL)
    DROP TABLE TestTable;

CREATE TABLE TestTable
(
   ID INT NOT NULL,
   Value INT NOT NULL,
   PRIMARY KEY (ID)
)
GO

BEGIN TRANSACTION 
 
   INSERT INTO TestTable( ID, Value )
   VALUES  ( 1, N'10')
   -- this will create a savepoint after the first INSERT
   SAVE TRANSACTION FirstInsert

   INSERT INTO TestTable( ID, Value )
   VALUES  ( 2, N'20')
 
   -- this will rollback to the savepoint right after the first INSERT was done
   ROLLBACK TRANSACTION FirstInsert
   
-- this will commit the transaction leaving just the first INSERT 
COMMIT
 
SELECT * FROM TestTable