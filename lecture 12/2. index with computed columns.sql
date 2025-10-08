SELECT    
    first_name, last_name, email
FROM    
    sales.customers
WHERE 
    -- substring(string, start, length)
    SUBSTRING(email, 0, CHARINDEX('@', email, 0)) = 'garry.espinoza';

ALTER TABLE sales.customers 
	ADD email_alias AS 
		SUBSTRING(email, 0, CHARINDEX('@', email, 0) );

CREATE INDEX ix_email_alias
ON sales.customers(email_alias);

exec sp_helpindex 'sales.customers';

SELECT  first_name, last_name, email
FROM    sales.customers
WHERE   email_alias = 'garry.espinoza';