CREATE VIEW dbo.PAYROLL_VERIFICATION_V_PATTY
AS
SELECT     pay.ORGANIZATION_ID, sl.RESOURCE_ID, pay.TC_JOB_ID AS JOB_ID, pay.TC_JOB_NO AS JOB_NO, pay.TC_SERVICE_ID AS SERVICE_ID, 
                      pay.TC_SERVICE_NO AS SERVICE_NO, pay.resource_name, dbo.RESOURCES_V.RES_CATEGORY_TYPE_ID, dbo.RESOURCES_V.res_cat_type_code, 
                      dbo.RESOURCES_V.res_cat_type_name, dbo.JOBS_V.EXT_CUSTOMER_ID, dbo.JOBS_V.DEALER_NAME, dbo.JOBS_V.EXT_DEALER_ID, 
                      sl.VERIFIED_DATE, sl.VERIFIED_BY, sl.PAYROLL_QTY AS hours_qty, sl.BILL_HOURLY_QTY AS hours_bill_qty, 
                      sl.BILL_HOURLY_RATE AS hours_bill_rate, pay.EXT_EMPLOYEE_ID, pay.employee_name, CONVERT(varchar(12), DATEADD(day, - 6, 
                      sl.SERVICE_LINE_WEEK), 101) AS begin_date, CONVERT(varchar(12), sl.SERVICE_LINE_WEEK, 101) AS end_date, pay.SERVICE_LINE_DATE, 
                      pay.ITEM_ID, pay.ITEM_NAME, pay.EXT_PAY_CODE, pay.ITEM_TYPE_CODE, dbo.ITEMS_V.item_type_name, 
                      sl.BILL_HOURLY_TOTAL AS hours_bill_price, dbo.JOBS_V.JOB_NO_NAME, sl.ENTERED_DATE, sl.EXT_PAY_CODE AS EXT_PAYCODE, 
                      dbo.GP_MPLS_PAY_CODE_V.PAYRCORD, dbo.GP_MPLS_PAY_CODE_V.DSCRIPTN, sl.ENTERED_BY, sl.entered_by_name, dbo.USERS.USER_ID, 
                      dbo.USERS.FIRST_NAME, dbo.USERS.LAST_NAME, dbo.USERS.EXT_EMPLOYEE_ID AS EMP_ID, sl.verified_by_name, sl.ENTRY_METHOD, 
                      sl.TC_QTY, sl.TC_RATE, sl.TC_TOTAL
FROM         dbo.USERS RIGHT OUTER JOIN
                      dbo.ITEMS_V RIGHT OUTER JOIN
                      dbo.PAYROLL_V pay ON dbo.ITEMS_V.ITEM_ID = pay.ITEM_ID LEFT OUTER JOIN
                      dbo.JOBS_V ON pay.TC_JOB_ID = dbo.JOBS_V.JOB_ID LEFT OUTER JOIN
                      dbo.RESOURCES_V RIGHT OUTER JOIN
                      dbo.TIME_CAPTURE_V sl ON dbo.RESOURCES_V.RESOURCE_ID = sl.RESOURCE_ID ON pay.SERVICE_LINE_ID = sl.SERVICE_LINE_ID ON 
                      dbo.USERS.USER_ID = sl.ENTERED_BY LEFT OUTER JOIN
                      dbo.GP_MPLS_PAY_CODE_V ON sl.EXT_PAY_CODE = dbo.GP_MPLS_PAY_CODE_V.PAYRCORD
WHERE     (sl.VERIFIED_BY IS NOT NULL) OR
                      (sl.OVERRIDE_BY IS NOT NULL)

