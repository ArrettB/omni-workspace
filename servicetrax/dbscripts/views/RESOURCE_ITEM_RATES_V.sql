
CREATE VIEW dbo.RESOURCE_ITEM_RATES_V  
AS  
SELECT     dbo.RESOURCE_ITEMS_V.ORGANIZATION_ID, dbo.RESOURCE_ITEMS_V.item_name, dbo.RESOURCE_ITEMS_V.RESOURCE_ITEM_ID,   
                      dbo.RESOURCE_ITEMS_V.ITEM_ID, dbo.RESOURCE_ITEMS_V.item_type_code, dbo.RESOURCE_ITEMS_V.item_status_type_code,
                      dbo.RESOURCE_ITEMS_V.RESOURCE_ID,   
                      dbo.RESOURCE_ITEMS_V.resource_name, dbo.RESOURCE_ITEMS_V.resource_type_code, dbo.JOB_ITEM_RATES.JOB_ID,   
                      dbo.JOB_ITEM_RATES.RATE, dbo.JOBS.JOB_NO  
FROM
dbo.JOBS INNER JOIN dbo.JOB_ITEM_RATES
 ON dbo.JOBS.JOB_ID = dbo.JOB_ITEM_RATES.JOB_ID
RIGHT OUTER JOIN dbo.RESOURCE_ITEMS_V
 ON dbo.JOB_ITEM_RATES.ITEM_ID = dbo.RESOURCE_ITEMS_V.ITEM_ID  

