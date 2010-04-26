CREATE VIEW dbo.SCH_RESOURCE_ESTIMATES_V
AS
SELECT     dbo.JOBS_V.ORGANIZATION_ID, dbo.JOBS_V.JOB_ID, dbo.JOBS_V.JOB_NO, dbo.JOBS_V.JOB_NAME, dbo.JOBS_V.JOB_TYPE_ID, 
                      dbo.JOBS_V.job_type_code, dbo.JOBS_V.job_type_name, dbo.JOBS_V.JOB_STATUS_TYPE_ID, dbo.JOBS_V.job_status_type_code, 
                      dbo.JOBS_V.job_status_type_name, dbo.RESOURCE_ESTIMATES_V.RESOURCE_EST_ID, dbo.RESOURCE_ESTIMATES_V.SERVICE_ID, 
                      dbo.RESOURCE_ESTIMATES_V.SERVICE_NO, dbo.RESOURCE_ESTIMATES_V.JOB_ITEM_RATE_ID, dbo.RESOURCE_ESTIMATES_V.ITEM_ID, 
                      dbo.RESOURCE_ESTIMATES_V.item_name, dbo.RESOURCE_ESTIMATES_V.item_desc, dbo.RESOURCE_ESTIMATES_V.ITEM_TYPE_ID, 
                      dbo.RESOURCE_ESTIMATES_V.item_type_code, dbo.RESOURCE_ESTIMATES_V.item_type_name, 
                      dbo.RESOURCE_ESTIMATES_V.ITEM_STATUS_TYPE_ID, dbo.RESOURCE_ESTIMATES_V.RATE, dbo.RESOURCE_ESTIMATES_V.RESOURCE_TYPE_ID, 
                      dbo.RESOURCE_ESTIMATES_V.UNIT_QTY, dbo.RESOURCE_ESTIMATES_V.TIME_UOM_TYPE_ID, 
                      dbo.RESOURCE_ESTIMATES_V.time_uom_type_code, dbo.RESOURCE_ESTIMATES_V.time_uom_type_name, 
                      dbo.RESOURCE_ESTIMATES_V.multiplier, dbo.RESOURCE_ESTIMATES_V.TIME_QTY, dbo.RESOURCE_ESTIMATES_V.resource_type_code, 
                      dbo.RESOURCE_ESTIMATES_V.resource_type_name, dbo.RESOURCE_ESTIMATES_V.TOTAL_HOURS, dbo.RESOURCE_ESTIMATES_V.total_dollars, 
                      dbo.RESOURCE_ESTIMATES_V.START_DATE, dbo.RESOURCE_ESTIMATES_V.DATE_CREATED, dbo.RESOURCE_ESTIMATES_V.CREATED_BY, 
                      dbo.RESOURCE_ESTIMATES_V.created_by_name, dbo.RESOURCE_ESTIMATES_V.DATE_MODIFIED, dbo.RESOURCE_ESTIMATES_V.MODIFIED_BY, 
                      dbo.RESOURCE_ESTIMATES_V.modified_by_name
FROM         dbo.JOBS_V LEFT OUTER JOIN
                      dbo.RESOURCE_ESTIMATES_V ON dbo.JOBS_V.JOB_ID = dbo.RESOURCE_ESTIMATES_V.JOB_ID


