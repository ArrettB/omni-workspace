CREATE VIEW dbo.PAYROLL_VERIFICATION_V
AS
SELECT     pay.ORGANIZATION_ID, sl.RESOURCE_ID, pay.TC_JOB_ID AS JOB_ID, pay.TC_JOB_NO AS JOB_NO, pay.TC_SERVICE_ID AS SERVICE_ID, 
                      pay.TC_SERVICE_NO AS SERVICE_NO, pay.resource_name, dbo.RESOURCES_V.RES_CATEGORY_TYPE_ID, dbo.RESOURCES_V.res_cat_type_code, 
                      dbo.RESOURCES_V.res_cat_type_name, dbo.jobs_v.ext_customer_id, dbo.jobs_v.dealer_name, dbo.jobs_v.ext_dealer_id, sl.VERIFIED_DATE, 
                      sl.VERIFIED_BY, sl.PAYROLL_QTY AS hours_qty, sl.BILL_HOURLY_QTY AS hours_bill_qty, sl.BILL_HOURLY_RATE AS hours_bill_rate, 
                      pay.EXT_EMPLOYEE_ID, pay.employee_name, CONVERT(varchar(12), DATEADD(day, - 6, sl.SERVICE_LINE_WEEK), 101) AS begin_date, 
                      CONVERT(varchar(12), sl.SERVICE_LINE_WEEK, 101) AS end_date, pay.SERVICE_LINE_DATE, pay.ITEM_ID, pay.ITEM_NAME, pay.EXT_PAY_CODE, 
                      pay.ITEM_TYPE_CODE, dbo.ITEMS_V.item_type_name, sl.bill_hourly_total AS hours_bill_price, dbo.jobs_v.job_no_name, sl.ENTERED_DATE, 
                      sl.EXT_PAY_CODE AS EXT_PAYCODE, dbo.GP_MPLS_PAY_CODE_V.PAYRCORD, dbo.GP_MPLS_PAY_CODE_V.DSCRIPTN, sl.ENTERED_BY, 
                      sl.entered_by_name, dbo.USERS.USER_ID, dbo.USERS.FIRST_NAME, dbo.USERS.LAST_NAME, dbo.USERS.EXT_EMPLOYEE_ID AS EMP_ID, 
                      sl.verified_by_name, sl.ENTRY_METHOD, sl.TC_QTY, sl.TC_RATE, sl.tc_total, dbo.jobs_v.foreman_resource_name
FROM         dbo.USERS RIGHT OUTER JOIN
                      dbo.ITEMS_V RIGHT OUTER JOIN
                      dbo.PAYROLL_V AS pay ON dbo.ITEMS_V.ITEM_ID = pay.ITEM_ID LEFT OUTER JOIN
                      dbo.jobs_v ON pay.TC_JOB_ID = dbo.jobs_v.job_id LEFT OUTER JOIN
                      dbo.RESOURCES_V RIGHT OUTER JOIN
                      dbo.TIME_CAPTURE_V AS sl ON dbo.RESOURCES_V.RESOURCE_ID = sl.RESOURCE_ID ON pay.SERVICE_LINE_ID = sl.SERVICE_LINE_ID ON 
                      dbo.USERS.USER_ID = sl.ENTERED_BY LEFT OUTER JOIN
                      dbo.GP_MPLS_PAY_CODE_V ON sl.EXT_PAY_CODE = dbo.GP_MPLS_PAY_CODE_V.PAYRCORD
WHERE     (pay.PAYROLL_EXPORTED_FLAG = 'N') OR
                      (pay.PAYROLL_EXPORTED_FLAG = 'N')

