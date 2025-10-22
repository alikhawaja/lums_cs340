CREATE TABLE NewTable (Id INT PRIMARY KEY, Info CHAR(3));
GO
INSERT INTO NewTable VALUES (1, 'aaa');
INSERT INTO NewTable VALUES (2, 'bbb');
INSERT INTO NewTable VALUSE (3, 'ccc');  -- Syntax error.
GO
SELECT * FROM NewTable;  -- Returns no rows.
GO