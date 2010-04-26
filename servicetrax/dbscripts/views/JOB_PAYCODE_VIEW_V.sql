CREATE VIEW dbo.JOB_PAYCODE_VIEW_V AS SELECT dbo.JOBS.JOB_ID, dbo.ORG_GP_TABLES.VIEW_NAME AS PAYCODE_VIEW_NAME 
FROM dbo.CUSTOMERS INNER JOIN dbo.JOBS ON dbo.CUSTOMERS.CUSTOMER_ID = dbo.JOBS.CUSTOMER_ID 
INNER JOIN dbo.ORGANIZATIONS ON dbo.CUSTOMERS.ORGANIZATION_ID = dbo.ORGANIZATIONS.Organization_ID 
INNER JOIN dbo.ORG_GP_TABLES ON dbo.ORGANIZATIONS.Organization_ID = dbo.ORG_GP_TABLES.ORG_ID 
INNER JOIN dbo.GREAT_PLAINS_TABLES ON dbo.ORG_GP_TABLES.TABLE_ID = dbo.GREAT_PLAINS_TABLES.TABLE_ID 
WHERE (dbo.GREAT_PLAINS_TABLES.TABLE_NAME = 'item_pay_codes_view') 

