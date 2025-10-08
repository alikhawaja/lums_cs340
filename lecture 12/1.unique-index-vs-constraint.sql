
create schema L12;
GO

CREATE TABLE L12.LumsUsers (
    id INT PRIMARY KEY,
    name varchar(255),
    email VARCHAR(255) UNIQUE,
    email2 varchar(255)
) 
GO

-- insert 10 rows in LumsUsers table
INSERT INTO L12.LumsUsers (id, name, email, email2)
VALUES 
(1, 'abc', 'abc@lums.edu.pk', 'abc2@lums.edu.pk'),
(2, 'def', 'def@lums.edu.pk', 'def2@lums.edu.pk'),
(3, 'ghi', 'ghi@lums.edu.pk', 'ghi2@lums.edu.pk'),
(4, 'jkl', 'jkl@lums.edu.pk', 'jkl2@lums.edu.pk'),
(5, 'mno', 'mno@lums.edu.pk', 'mno2@lums.edu.pk'), 
(6, 'pqr', 'pqr@lums.edu.pk', 'pqr2@lums.edu.pk')

exec sp_helpindex 'L12.LumsUsers';
GO

CREATE UNIQUE INDEX UQ_LumsUsers_email2
    ON L12.LumsUsers(email2)
    INCLUDE (name);
GO

select name, email from l12.LumsUsers
where email = 'abc@lums.edu.pk'

select name, email2 from l12.LumsUsers
where email2 = 'abc2@lums.edu.pk'