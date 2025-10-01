create database cs340
GO

use cs340
GO
create schema hr
GO

CREATE TABLE hr.students (
    studentId INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100),
    dept NVARCHAR(100)
);

insert hr.students values ('Syed Babar Ali', 'Computer Science');
insert hr.students values ('John Doe', 'Law School');


SET IDENTITY_INSERT hr.students ON;
    insert hr.students (studentId, Name, dept) values (1001, 'Jane Doe', 'Business');
SET IDENTITY_INSERT hr.students OFF;

insert hr.students values ('Ahmed', 'Engineering');
insert hr.students values ('Ayesha', 'Engineering');

use cs340;
dbcc checkident('hr.students');
dbcc checkident('hr.students', RESEED, 0);

insert hr.students values ('Julie', 'Economics  and Finance');

dbcc checkident('hr.students');
dbcc checkident('hr.students', RESEED, 2000);

insert hr.students values ('Julie', 'Economics  and Finance');


CREATE TABLE sales.promotions (
    promotion_id INT PRIMARY KEY IDENTITY (1, 1),
    promotion_name VARCHAR (255) NOT NULL,
    discount NUMERIC (3, 2) DEFAULT 0,
    start_date DATE NOT NULL,
    expired_date DATE NOT NULL
); 

SELECT * FROM Sales.SalesOrderHeader
WHERE 1 = 0;

INSERT INTO sales.promotions ( promotion_name, discount, start_date, expired_date )
VALUES ( '2018 Summer Promotion', 0.15, '20180601', '20180831' );

use AdventureWorks2022
GO
UPDATE HumanResources.Employee
SET VacationHours = VacationHours + 8
OUTPUT 
    inserted.BusinessEntityID,
    inserted.LoginID,
    deleted.VacationHours AS OldVacationHours,
    inserted.VacationHours AS NewVacationHours
WHERE JobTitle = 'Production Technician - WC60';

select * from HumanResources.Employee
where 0 = 1