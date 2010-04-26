CREATE VIEW dbo.crystal_routing_ticket
AS
SELECT     dbo.SCH_RESOURCES.RES_START_DATE AS scheduled_date, dbo.SERVICES.CUST_COL_6 AS Delivery_Ticket, dbo.SERVICES.PO_NO AS Target_PO, 
                      CAST(dbo.JOBS.JOB_NO AS varchar) + '-' + CAST(dbo.SERVICES.SERVICE_NO AS varchar) AS job_number_and_req, 
                      dbo.SERVICES.CUST_COL_1 AS Customer, dbo.RESOURCES.NAME AS Driver
FROM         dbo.RESOURCES INNER JOIN
                      dbo.SCH_RESOURCES INNER JOIN
                      dbo.JOBS INNER JOIN
                      dbo.SERVICES ON dbo.JOBS.JOB_ID = dbo.SERVICES.JOB_ID INNER JOIN
                      dbo.CUSTOMERS ON dbo.JOBS.CUSTOMER_ID = dbo.CUSTOMERS.CUSTOMER_ID ON ISNULL(dbo.SCH_RESOURCES.SERVICE_ID, 
                      dbo.SCH_RESOURCES.HIDDEN_SERVICE_ID) = dbo.SERVICES.SERVICE_ID ON 
                      dbo.RESOURCES.RESOURCE_ID = dbo.SCH_RESOURCES.RESOURCE_ID
WHERE     (dbo.CUSTOMERS.CUSTOMER_NAME = 'TARGET COMMERICAL INTERIORS')

