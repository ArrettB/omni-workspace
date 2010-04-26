CREATE VIEW dbo.SERVICE_LINE_PAYROLL_V
AS
SELECT     dbo.CUSTOMERS.ORGANIZATION_ID, dbo.RESOURCES.RESOURCE_ID, dbo.SERVICES.JOB_ID, dbo.JOBS.JOB_NO, 
                      dbo.SERVICE_LINES.SERVICE_ID, dbo.SERVICES.SERVICE_NO, dbo.RESOURCES.NAME AS resource_name, 
                      dbo.RESOURCES.RES_CATEGORY_TYPE_ID, LOOKUPS_4.CODE AS res_cat_type_code, LOOKUPS_4.NAME AS res_cat_type_name, 
                      dbo.RESOURCES.RESOURCE_TYPE_ID, dbo.RESOURCES.USER_ID, dbo.RESOURCES.ACTIVE_FLAG, dbo.SERVICE_LINES.STATUS_ID, 
                      dbo.SERVICE_LINES.ITEM_ID, dbo.ITEMS.NAME AS item_name, dbo.SERVICE_LINES.EXT_PAY_CODE, LOOKUPS_3.CODE AS item_type_code, 
                      LOOKUPS_3.NAME AS item_type_name, dbo.RESOURCE_TYPES.CODE AS resource_type_code, 
                      dbo.RESOURCE_TYPES.NAME AS resource_type_name, dbo.SERVICE_LINES.QTY AS hours_qty, dbo.SERVICE_LINES.SERVICE_LINE_DATE, 
                      dbo.USERS.EXT_EMPLOYEE_ID, dbo.USERS.FIRST_NAME + ' ' + dbo.USERS.LAST_NAME AS employee_name, 
                      dbo.SERVICE_LINES.SERVICE_LINE_ID, dbo.SERVICE_LINES.SERVICE_LINE_NO, dbo.SERVICE_LINES.SERVICE_LINE_WEEK, 
                      dbo.PAYROLL_BATCHES.STATUS_ID AS batch_status_id, dbo.PAYROLL_BATCHES.INT_BATCH_ID, dbo.PAYROLL_BATCHES.EXT_BATCH_ID, 
                      dbo.PAYROLL_BATCHES.BEGIN_DATE, dbo.PAYROLL_BATCHES.END_DATE, dbo.PAYROLL_BATCH_STATUSES.CODE AS batch_status_code, 
                      dbo.PAYROLL_BATCH_STATUSES.NAME AS batch_status_name, dbo.JOBS.CUSTOMER_ID, dbo.ITEMS.EXT_ITEM_ID, CONVERT(varchar(12), 
                      dbo.PAYROLL_BATCHES.BEGIN_DATE, 101) AS begin_date_varchar, CONVERT(varchar(12), dbo.PAYROLL_BATCHES.END_DATE, 101) 
                      AS end_date_varchar, CONVERT(varchar(12), dbo.SERVICE_LINES.SERVICE_LINE_DATE, 101) AS service_line_date_varchar
FROM         dbo.SERVICES LEFT OUTER JOIN
                      dbo.CUSTOMERS RIGHT OUTER JOIN
                      dbo.JOBS ON dbo.CUSTOMERS.CUSTOMER_ID = dbo.JOBS.CUSTOMER_ID ON dbo.SERVICES.JOB_ID = dbo.JOBS.JOB_ID RIGHT OUTER JOIN
                      dbo.RESOURCES LEFT OUTER JOIN
                      dbo.USERS ON dbo.RESOURCES.USER_ID = dbo.USERS.USER_ID LEFT OUTER JOIN
                      dbo.SERVICE_LINES LEFT OUTER JOIN
                      dbo.PAYROLL_BATCH_LINES LEFT OUTER JOIN
                      dbo.PAYROLL_BATCH_STATUSES RIGHT OUTER JOIN
                      dbo.PAYROLL_BATCHES ON dbo.PAYROLL_BATCH_STATUSES.STATUS_ID = dbo.PAYROLL_BATCHES.STATUS_ID ON 
                      dbo.PAYROLL_BATCH_LINES.INT_BATCH_ID = dbo.PAYROLL_BATCHES.INT_BATCH_ID ON 
                      dbo.SERVICE_LINES.SERVICE_LINE_ID = dbo.PAYROLL_BATCH_LINES.SERVICE_LINE_ID ON 
                      dbo.RESOURCES.RESOURCE_ID = dbo.SERVICE_LINES.RESOURCE_ID LEFT OUTER JOIN
                      dbo.RESOURCE_TYPES ON dbo.RESOURCES.RESOURCE_TYPE_ID = dbo.RESOURCE_TYPES.RESOURCE_TYPE_ID LEFT OUTER JOIN
                      dbo.LOOKUPS LOOKUPS_4 ON dbo.RESOURCES.RES_CATEGORY_TYPE_ID = LOOKUPS_4.LOOKUP_ID ON 
                      dbo.SERVICES.SERVICE_ID = dbo.SERVICE_LINES.SERVICE_ID LEFT OUTER JOIN
                      dbo.ITEMS ON dbo.SERVICE_LINES.ITEM_ID = dbo.ITEMS.ITEM_ID LEFT OUTER JOIN
                      dbo.LOOKUPS LOOKUPS_3 ON dbo.ITEMS.ITEM_TYPE_ID = LOOKUPS_3.LOOKUP_ID
WHERE     (dbo.SERVICE_LINES.STATUS_ID > 1 OR
                      dbo.SERVICE_LINES.STATUS_ID IS NULL) AND (LOOKUPS_4.CODE = 'employee') AND (dbo.RESOURCES.ACTIVE_FLAG = 'Y') AND 
                      (LOOKUPS_3.CODE = 'hours' OR
                      LOOKUPS_3.CODE IS NULL)

