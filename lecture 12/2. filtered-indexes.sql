SELECT 
    SUM(CASE
            WHEN phone IS NULL
            THEN 1
            ELSE 0
        	END) AS [Has Phone], 
    SUM(CASE
            WHEN phone IS NULL
            THEN 0
            ELSE 1
        	END) AS [No Phone]
FROM 
    sales.customers;


CREATE INDEX ix_cust_phone
	ON sales.customers(phone)
WHERE 
	phone IS NOT NULL;

exec sp_helpindex 'sales.customers';

SELECT    
    first_name,
    last_name, 
    phone
FROM    
    sales.customers
WHERE phone is null;

exec sp_helpindex 'sales.customers';