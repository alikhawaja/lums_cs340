
create schema L12;
GO

CREATE TABLE L12.LumsUsers (
    id INT PRIMARY KEY,
    email VARCHAR(255) UNIQUE
);

exec sp_helpindex 'L12.LumsUsers';
GO

CREATE TABLE L12.LumsUsers2 (
    id INT PRIMARY KEY,
    email VARCHAR(255) 
);

exec sp_helpindex 'L12.LumsUsers2';
GO

CREATE UNIQUE INDEX UQ_LumsUsers2_email ON L12.LumsUsers2(email);
GO

exec sp_helpindex 'L12.LumsUsers2';
GO