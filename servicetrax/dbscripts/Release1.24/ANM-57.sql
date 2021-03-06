DROP VIEW dbo.TIME_CAPTURE_V;

CREATE VIEW dbo.TIME_CAPTURE_V
AS
SELECT dbo.SERVICE_LINES.ORGANIZATION_ID, 
       dbo.SERVICE_LINES.TC_JOB_NO, 
       dbo.SERVICE_LINES.TC_SERVICE_NO, 
       dbo.SERVICE_LINES.TC_SERVICE_LINE_NO, 
       dbo.SERVICE_LINES.BILL_JOB_NO, 
       dbo.SERVICE_LINES.BILL_SERVICE_NO, 
       dbo.SERVICE_LINES.BILL_SERVICE_LINE_NO, 
       dbo.JOBS_V.JOB_NAME, 
       dbo.SERVICE_LINES.RESOURCE_NAME, 
       dbo.SERVICE_LINES.ITEM_NAME, 
       dbo.JOBS_V.billing_user_name, 
       dbo.JOBS_V.foreman_resource_name, 
       dbo.SERVICE_LINES.TC_JOB_ID, 
       dbo.SERVICE_LINES.TC_SERVICE_ID, 
       dbo.SERVICE_LINES.BILL_JOB_ID, 
       dbo.SERVICE_LINES.BILL_SERVICE_ID, 
       dbo.SERVICE_LINES.PH_SERVICE_ID, 
       dbo.SERVICE_LINES.SERVICE_LINE_ID, 
       CAST(dbo.SERVICES.JOB_ID AS varchar) + '-' + CAST(dbo.SERVICE_LINES.ITEM_ID AS varchar) + '-' + CAST(dbo.SERVICE_LINES.STATUS_ID AS varchar) AS job_item_status_id, 
       CAST(dbo.SERVICE_LINES.TC_SERVICE_ID AS varchar) + '-' + CAST(dbo.SERVICE_LINES.STATUS_ID AS varchar) AS service_status_id, 
       CAST(dbo.SERVICES.SERVICE_ID AS varchar) + '-' + CAST(dbo.SERVICE_LINES.ITEM_ID AS varchar) + '-' + CAST(dbo.SERVICE_LINES.STATUS_ID AS varchar) AS service_item_status_id, 
       dbo.JOBS_V.BILLING_USER_ID, 
       dbo.JOBS_V.foreman_user_id, 
       dbo.SERVICE_LINES.SERVICE_LINE_DATE, 
       dbo.SERVICE_LINES.SERVICE_LINE_DATE_VARCHAR, 
       dbo.SERVICE_LINES.SERVICE_LINE_WEEK, 
       dbo.SERVICE_LINES.SERVICE_LINE_WEEK_VARCHAR, 
       dbo.JOBS_V.job_status_type_code, 
       dbo.JOBS_V.job_status_type_name, 
       SERV_STATUS_TYPES.CODE AS serv_status_type_code, 
       SERV_STATUS_TYPES.NAME AS serv_status_type_name, 
       dbo.SERVICE_LINES.STATUS_ID, 
       dbo.SERVICE_LINE_STATUSES.NAME AS status_name, 
       dbo.SERVICE_LINE_STATUSES.CODE AS status_code, 
       dbo.SERVICE_LINES.EXPORTED_FLAG, 
       dbo.SERVICE_LINES.BILLED_FLAG, 
       dbo.SERVICE_LINES.POSTED_FLAG, 
       dbo.SERVICE_LINES.POOLED_FLAG, 
       dbo.SERVICE_LINES.RESOURCE_ID, 
       dbo.SERVICE_LINES.ITEM_ID, 
       dbo.SERVICE_LINES.ITEM_TYPE_CODE, 
       dbo.SERVICE_LINES.BILLABLE_FLAG, 
       dbo.SERVICE_LINES.TC_QTY, 
       dbo.SERVICE_LINES.TC_RATE, 
       dbo.SERVICE_LINES.tc_total, 
       dbo.SERVICE_LINES.PAYROLL_QTY, 
       dbo.SERVICE_LINES.PAYROLL_RATE, 
       dbo.SERVICE_LINES.payroll_total, 
       dbo.SERVICE_LINES.EXT_PAY_CODE, 
       dbo.SERVICE_LINES.EXPENSE_QTY, 
       dbo.SERVICE_LINES.EXPENSE_RATE, 
       dbo.SERVICE_LINES.expense_total, 
       dbo.SERVICE_LINES.BILL_QTY, 
       dbo.SERVICE_LINES.BILL_RATE, 
       dbo.SERVICE_LINES.bill_total, 
       dbo.SERVICE_LINES.BILL_EXP_QTY, 
       dbo.SERVICE_LINES.BILL_EXP_RATE, 
       dbo.SERVICE_LINES.bill_exp_total, 
       dbo.SERVICE_LINES.BILL_HOURLY_QTY, 
       dbo.SERVICE_LINES.BILL_HOURLY_RATE, 
       dbo.SERVICE_LINES.bill_hourly_total, 
       dbo.SERVICE_LINES.ALLOCATED_QTY, 
       dbo.SERVICE_LINES.INTERNAL_REQ_FLAG, 
       dbo.SERVICE_LINES.PARTIALLY_ALLOCATED_FLAG, 
       dbo.SERVICE_LINES.FULLY_ALLOCATED_FLAG, 
       dbo.SERVICE_LINES.PALM_REP_ID, 
       dbo.SERVICE_LINES.ENTERED_DATE, 
       dbo.SERVICE_LINES.ENTERED_BY, 
       USERS_1.FULL_NAME AS entered_by_name, 
       dbo.SERVICE_LINES.ENTRY_METHOD, 
       dbo.SERVICE_LINES.OVERRIDE_DATE, 
       dbo.SERVICE_LINES.OVERRIDE_BY, 
       USERS_1.FULL_NAME AS override_by_name, 
       dbo.SERVICE_LINES.OVERRIDE_REASON, 
       dbo.SERVICE_LINES.VERIFIED_DATE, 
       dbo.SERVICE_LINES.VERIFIED_BY, 
       USERS_2.FULL_NAME AS verified_by_name, 
       dbo.SERVICES.DESCRIPTION AS service_description, 
       dbo.SERVICE_LINES.DATE_CREATED, 
       dbo.SERVICE_LINES.CREATED_BY, 
       USERS_3.FULL_NAME AS created_by_name, 
       dbo.SERVICE_LINES.DATE_MODIFIED, 
       dbo.SERVICE_LINES.MODIFIED_BY, 
       USERS_4.FULL_NAME AS modified_by_name,
       dbo.SERVICES.service_no
  FROM dbo.LOOKUPS SERV_STATUS_TYPES RIGHT OUTER JOIN
       dbo.JOBS_V RIGHT OUTER JOIN
       dbo.SERVICES ON dbo.JOBS_V.JOB_ID = dbo.SERVICES.JOB_ID ON SERV_STATUS_TYPES.LOOKUP_ID = dbo.SERVICES.SERV_STATUS_TYPE_ID RIGHT OUTER JOIN
       dbo.SERVICE_LINE_STATUSES RIGHT OUTER JOIN
       dbo.USERS USERS_4 RIGHT OUTER JOIN
       dbo.USERS USERS_5 RIGHT OUTER JOIN
       dbo.USERS USERS_1 RIGHT OUTER JOIN
       dbo.SERVICE_LINES ON USERS_1.USER_ID = dbo.SERVICE_LINES.OVERRIDE_BY ON USERS_5.USER_ID = dbo.SERVICE_LINES.ENTERED_BY LEFT OUTER JOIN
       dbo.USERS USERS_2 ON dbo.SERVICE_LINES.VERIFIED_BY = USERS_2.USER_ID ON USERS_4.USER_ID = dbo.SERVICE_LINES.MODIFIED_BY LEFT OUTER JOIN
       dbo.USERS USERS_3 ON dbo.SERVICE_LINES.CREATED_BY = USERS_3.USER_ID ON dbo.SERVICE_LINE_STATUSES.STATUS_ID = dbo.SERVICE_LINES.STATUS_ID ON dbo.SERVICES.SERVICE_ID = dbo.SERVICE_LINES.TC_SERVICE_ID;
       
DROP VIEW JOB_TIME_BY_EMP_V;

CREATE VIEW JOB_TIME_BY_EMP_V
AS
SELECT dbo.TIME_CAPTURE_V.ORGANIZATION_ID, 
       dbo.TIME_CAPTURE_V.TC_JOB_NO, 
       dbo.TIME_CAPTURE_V.TC_SERVICE_NO, 
       dbo.TIME_CAPTURE_V.TC_SERVICE_LINE_NO, 
       dbo.TIME_CAPTURE_V.TC_JOB_ID, 
       dbo.TIME_CAPTURE_V.TC_SERVICE_ID, 
       dbo.TIME_CAPTURE_V.SERVICE_LINE_ID, 
       dbo.JOBS_V.JOB_NAME, 
       dbo.JOBS_V.FOREMAN_RESOURCE_ID, 
       dbo.JOBS_V.foreman_resource_name, 
       dbo.TIME_CAPTURE_V.SERVICE_LINE_DATE, 
       dbo.TIME_CAPTURE_V.STATUS_ID, 
       dbo.TIME_CAPTURE_V.status_name, 
       dbo.TIME_CAPTURE_V.RESOURCE_ID, 
       dbo.RESOURCES_V.USER_ID, 
       dbo.RESOURCES_V.resource_name, 
       dbo.RESOURCES_V.user_full_name AS employee_name, 
       dbo.RESOURCES_V.EXT_EMPLOYEE_ID, 
       dbo.TIME_CAPTURE_V.ITEM_NAME, 
       dbo.TIME_CAPTURE_V.PAYROLL_QTY, 
       dbo.TIME_CAPTURE_V.PAYROLL_RATE, 
       dbo.TIME_CAPTURE_V.PAYROLL_TOTAL, 
       dbo.TIME_CAPTURE_V.EXPENSE_QTY, 
       dbo.TIME_CAPTURE_V.EXPENSE_RATE, 
       dbo.TIME_CAPTURE_V.EXPENSE_TOTAL, 
       dbo.TIME_CAPTURE_V.TC_QTY, 
       dbo.TIME_CAPTURE_V.TC_RATE, 
       dbo.TIME_CAPTURE_V.TC_TOTAL, 
       dbo.TIME_CAPTURE_V.BILL_HOURLY_QTY, 
       dbo.TIME_CAPTURE_V.BILL_HOURLY_RATE, 
       dbo.TIME_CAPTURE_V.BILL_HOURLY_TOTAL, 
       dbo.TIME_CAPTURE_V.BILL_EXP_QTY, 
       dbo.TIME_CAPTURE_V.BILL_EXP_RATE, 
       dbo.TIME_CAPTURE_V.BILL_EXP_TOTAL, 
       dbo.TIME_CAPTURE_V.BILL_QTY,  
       dbo.TIME_CAPTURE_V.BILL_RATE, 
       dbo.TIME_CAPTURE_V.BILL_TOTAL, 
       dbo.TIME_CAPTURE_V.PH_SERVICE_ID, 
       dbo.TIME_CAPTURE_V.EXT_PAY_CODE, 
       dbo.TIME_CAPTURE_V.service_no,
       ISNULL(dbo.TIME_CAPTURE_V.PAYROLL_QTY, 0) - ISNULL(dbo.TIME_CAPTURE_V.BILL_HOURLY_QTY, 0) AS hours_difference, 
       MAX((CASE WHEN SERVICE_LINES_SCHD_V.SERVICE_LINE_ID IS NULL THEN 'N' ELSE 'Y' END)) scheduled_flag
  FROM dbo.SERVICE_LINES_SCHD_V RIGHT OUTER JOIN
       dbo.TIME_CAPTURE_V ON dbo.SERVICE_LINES_SCHD_V.SERVICE_LINE_ID = dbo.TIME_CAPTURE_V.SERVICE_LINE_ID LEFT OUTER JOIN
       dbo.RESOURCES_V ON dbo.TIME_CAPTURE_V.RESOURCE_ID = dbo.RESOURCES_V.RESOURCE_ID LEFT OUTER JOIN
       dbo.JOBS_V ON dbo.TIME_CAPTURE_V.TC_JOB_ID = dbo.JOBS_V.JOB_ID
GROUP BY dbo.TIME_CAPTURE_V.ORGANIZATION_ID, dbo.TIME_CAPTURE_V.TC_JOB_NO, dbo.TIME_CAPTURE_V.TC_SERVICE_NO, 
         dbo.TIME_CAPTURE_V.TC_SERVICE_LINE_NO, dbo.TIME_CAPTURE_V.TC_JOB_ID, dbo.TIME_CAPTURE_V.TC_SERVICE_ID, 
         dbo.TIME_CAPTURE_V.SERVICE_LINE_ID, dbo.JOBS_V.JOB_NAME, dbo.JOBS_V.FOREMAN_RESOURCE_ID, dbo.JOBS_V.foreman_resource_name, 
         dbo.TIME_CAPTURE_V.SERVICE_LINE_DATE, dbo.TIME_CAPTURE_V.STATUS_ID, dbo.TIME_CAPTURE_V.status_name, 
         dbo.TIME_CAPTURE_V.RESOURCE_ID, dbo.RESOURCES_V.USER_ID, dbo.RESOURCES_V.resource_name, dbo.RESOURCES_V.user_full_name, 
         dbo.RESOURCES_V.EXT_EMPLOYEE_ID,
         dbo.TIME_CAPTURE_V.ITEM_NAME, dbo.TIME_CAPTURE_V.PAYROLL_QTY, 
         dbo.TIME_CAPTURE_V.PAYROLL_RATE, dbo.TIME_CAPTURE_V.PAYROLL_TOTAL, dbo.TIME_CAPTURE_V.EXPENSE_QTY, 
         dbo.TIME_CAPTURE_V.EXPENSE_RATE, dbo.TIME_CAPTURE_V.EXPENSE_TOTAL, dbo.TIME_CAPTURE_V.TC_QTY, dbo.TIME_CAPTURE_V.TC_RATE, 
         dbo.TIME_CAPTURE_V.TC_TOTAL, dbo.TIME_CAPTURE_V.BILL_HOURLY_QTY, dbo.TIME_CAPTURE_V.BILL_HOURLY_RATE, 
         dbo.TIME_CAPTURE_V.BILL_HOURLY_TOTAL, dbo.TIME_CAPTURE_V.BILL_EXP_QTY, dbo.TIME_CAPTURE_V.BILL_EXP_RATE, 
         dbo.TIME_CAPTURE_V.BILL_EXP_TOTAL, dbo.TIME_CAPTURE_V.BILL_QTY,dbo.TIME_CAPTURE_V.BILL_RATE, dbo.TIME_CAPTURE_V.BILL_TOTAL, 
         dbo.TIME_CAPTURE_V.PH_SERVICE_ID, dbo.TIME_CAPTURE_V.EXT_PAY_CODE,
         dbo.TIME_CAPTURE_V.service_no, ISNULL(dbo.TIME_CAPTURE_V.PAYROLL_QTY, 0) - ISNULL(dbo.TIME_CAPTURE_V.BILL_HOURLY_QTY, 0)
HAVING   (NOT (dbo.TIME_CAPTURE_V.PAYROLL_QTY IS NULL));
