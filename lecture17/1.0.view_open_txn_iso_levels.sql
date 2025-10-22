-- Show open transactions and their isolation levels
if(exists (select * from sys.objects where object_id = object_id('dbo.ViewOpenTransactionsAndIsolationLevels') and type = 'P')
)
    drop PROCEDURE dbo.ViewOpenTransactionsAndIsolationLevels
GO

create PROCEDURE dbo.ViewOpenTransactionsAndIsolationLevels
AS
SELECT  
    s.session_id,
    s.login_name,
    s.host_name,
    s.program_name,
    s.login_time,
    s.last_request_start_time,
    s.last_request_end_time,
    s.open_transaction_count,
    CASE
        WHEN s.transaction_isolation_level = 0 THEN 'Unspecified'
        WHEN s.transaction_isolation_level = 1 THEN 'ReadUncommitted'
        WHEN s.transaction_isolation_level = 2 THEN 'ReadCommitted'
        WHEN s.transaction_isolation_level = 3 THEN 'RepeatableRead'
        WHEN s.transaction_isolation_level = 4 THEN 'Serializable'
        WHEN s.transaction_isolation_level = 5 THEN 'Snapshot'
        ELSE 'Unknown'
    END AS IsolationLevel,
    s.status,
    s.cpu_time,
    s.memory_usage,
    s.reads,
    s.writes,
    s.logical_reads
FROM sys.dm_exec_sessions AS s  
WHERE s.open_transaction_count > 0
    AND s.is_user_process = 1  -- Exclude system processes
ORDER BY s.open_transaction_count DESC, s.last_request_start_time;
