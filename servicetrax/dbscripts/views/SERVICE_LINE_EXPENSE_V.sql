CREATE VIEW dbo.SERVICE_LINE_EXPENSE_V
AS
SELECT     dbo.RESOURCES.RESOURCE_ID, dbo.SERVICES.JOB_ID, dbo.JOBS.JOB_NO, dbo.SERVICE_LINES.SERVICE_ID, dbo.SERVICES.SERVICE_NO, 
                      dbo.RESOURCES.NAME AS resource_name, dbo.RESOURCES.RES_CATEGORY_TYPE_ID, LOOKUPS_4.CODE AS res_cat_type_code, 
                      LOOKUPS_4.NAME AS res_cat_type_name, dbo.RESOURCES.RESOURCE_TYPE_ID, dbo.RESOURCES.USER_ID, 
                      dbo.USERS.FIRST_NAME + ' ' + dbo.USERS.LAST_NAME AS user_name, dbo.RESOURCES.ACTIVE_FLAG, dbo.SERVICE_LINES.STATUS_ID, 
                      dbo.SERVICE_LINES.ITEM_ID, dbo.ITEMS.NAME AS item_name, dbo.SERVICE_LINES.EXT_PAY_CODE, ITEM_TYPE.CODE AS item_type_code, 
                      ITEM_TYPE.NAME AS item_type_name, dbo.RESOURCE_TYPES.CODE AS resource_type_code, 
                      dbo.RESOURCE_TYPES.NAME AS resource_type_name, dbo.SERVICE_LINES.QTY, dbo.SERVICE_LINES.SERVICE_LINE_DATE, DATEADD(day, 
                      7 - DATEPART(dw, dbo.SERVICE_LINES.SERVICE_LINE_DATE), dbo.SERVICE_LINES.SERVICE_LINE_DATE) AS service_line_week, 
                      dbo.USERS.FIRST_NAME + ' ' + dbo.USERS.LAST_NAME AS employee_name, dbo.SERVICE_LINES.RATE, dbo.CUSTOMERS.CUSTOMER_NAME, 
                      dbo.SERVICE_LINES.EXPENSES_EXPORTED_FLAG, dbo.USERS.EXT_EMPLOYEE_ID, dbo.SERVICE_LINES.RATE * dbo.SERVICE_LINES.QTY AS total, 
                      dbo.SERVICE_LINES.SERVICE_LINE_NO, dbo.SERVICE_LINES.SERVICE_LINE_ID, dbo.JOBS.JOB_NAME, dbo.JOBS.CUSTOMER_ID, 
                      dbo.CUSTOMERS.ORGANIZATION_ID, dbo.ORGANIZATIONS.CODE AS organization_code, ITEM_STATUS_TYPE.CODE AS item_status_type_code, 
                      ITEM_STATUS_TYPE.NAME AS item_status_type_name
FROM         dbo.LOOKUPS ITEM_STATUS_TYPE RIGHT OUTER JOIN
                      dbo.LOOKUPS ITEM_TYPE INNER JOIN
                      dbo.ITEMS INNER JOIN
                      dbo.JOBS INNER JOIN
                      dbo.SERVICES INNER JOIN
                      dbo.SERVICE_LINES ON dbo.SERVICES.SERVICE_ID = dbo.SERVICE_LINES.SERVICE_ID ON dbo.JOBS.JOB_ID = dbo.SERVICES.JOB_ID ON 
                      dbo.ITEMS.ITEM_ID = dbo.SERVICE_LINES.ITEM_ID ON ITEM_TYPE.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID ON 
                      ITEM_STATUS_TYPE.LOOKUP_ID = dbo.ITEMS.ITEM_STATUS_TYPE_ID RIGHT OUTER JOIN
                      dbo.USERS INNER JOIN
                      dbo.RESOURCE_TYPES INNER JOIN
                      dbo.RESOURCES ON dbo.RESOURCE_TYPES.RESOURCE_TYPE_ID = dbo.RESOURCES.RESOURCE_TYPE_ID INNER JOIN
                      dbo.LOOKUPS LOOKUPS_4 ON dbo.RESOURCES.RES_CATEGORY_TYPE_ID = LOOKUPS_4.LOOKUP_ID ON 
                      dbo.USERS.USER_ID = dbo.RESOURCES.USER_ID ON dbo.SERVICE_LINES.RESOURCE_ID = dbo.RESOURCES.RESOURCE_ID LEFT OUTER JOIN
                      dbo.CUSTOMERS ON dbo.JOBS.CUSTOMER_ID = dbo.CUSTOMERS.CUSTOMER_ID LEFT OUTER JOIN
                      dbo.ORGANIZATIONS ON dbo.CUSTOMERS.ORGANIZATION_ID = dbo.ORGANIZATIONS.ORGANIZATION_ID
WHERE     (dbo.SERVICE_LINES.STATUS_ID > 1 OR
                      dbo.SERVICE_LINES.STATUS_ID IS NULL) AND (dbo.RESOURCES.ACTIVE_FLAG = 'Y') AND (ITEM_TYPE.CODE = 'expense') AND 
                      (LOOKUPS_4.CODE = 'employee')

