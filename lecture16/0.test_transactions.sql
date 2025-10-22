-- Show open transactions and their isolation levels
SELECT  
Case
	WHEN transaction_isolation_level= 0 THEN  'Unspecified'
	WHEN transaction_isolation_level= 1 THEN 'ReadUncommitted'
	WHEN transaction_isolation_level= 2 THEN 'ReadCommitted'
	WHEN transaction_isolation_level=3 THEN 'RepeatableRead'
	WHEN transaction_isolation_level=4 THEN 'Serializable'
	WHEN transaction_isolation_level=5  THEN 'Snapshot'
END IsolationLevel, S.*
FROM sys.dm_exec_sessions AS s  where open_transaction_count>0

select * from [PRODUCTION].[PRODUCT] where ProductID=1