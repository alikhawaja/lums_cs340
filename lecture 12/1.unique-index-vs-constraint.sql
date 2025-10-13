
create schema L13;
GO

CREATE TABLE L13.LumsUsers (
    id INT PRIMARY KEY,
    email VARCHAR(255) UNIQUE
);

exec sp_helpindex 'L12.LumsUsers';
GO

CREATE TABLE L13.LumsUsers4 (
    id INT PRIMARY KEY,
    email VARCHAR(255) UNIQUE
);

exec sp_helpindex 'L13.LumsUsers2';
GO

CREATE UNIQUE INDEX UQ_LumsUsers2_email ON L13.LumsUsers2(email);
GO

exec sp_helpindex 'L13.LumsUsers4';
GO


alter table L13.LumsUsers2
    add COLUMN email3 VARCHAR(255)
    add constraint UQ_LumsUsers3_email_constraint unique (email);
GO

DROP INDEX UQ_LumsUsers2_email ON L12.LumsUsers2;
GO

exec sp_helpindex 'L12.LumsUsers2';
GO