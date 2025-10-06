SELECT    
    first_name,
    last_name,
    email
FROM    
    sales.customers
WHERE 
    -- substring(string, start, length)
    SUBSTRING(email, 0, CHARINDEX('@', email, 0)) = 'garry.espinoza';