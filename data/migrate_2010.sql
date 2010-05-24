/**
 * Add the columns to service_lines for timekeeping
 * and the column to requests for the plan_location_id
 */
/*
 * Alter the requests table and add the foreign key
 */
ALTER TABLE [dbo].[REQUESTS]
   ADD [PLAN_LOCATION_TYPE_ID]  [NUMERIC](18,0)
GO

ALTER TABLE [REQUESTS] ADD CONSTRAINT [FK_REQUESTS_LOOKUPS_PLAN_LOCATION_TYPE] 
    FOREIGN KEY ([PLAN_LOCATION_TYPE_ID]) REFERENCES [LOOKUPS] ([LOOKUP_ID])
GO


/*
 * Alter the requests table and add the foreign key
 */
ALTER TABLE [dbo].[SERVICE_LINES]
   ADD [START_TIME]  [INTEGER]
GO
ALTER TABLE [dbo].[SERVICE_LINES]
   ADD [END_TIME]  [INTEGER]
GO
ALTER TABLE [dbo].[SERVICE_LINES]
   ADD [BREAK_TIME_MINUTES]  [INTEGER]
GO

/* 
 * Recreate this view to have the start time, end time, and break time information.
 */
DROP VIEW [dbo].[TIME_CAPTURE_V]
GO

CREATE VIEW [dbo].[TIME_CAPTURE_V]
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
       dbo.SERVICES.service_no,
       ( CASE WHEN dbo.SERVICE_LINES.START_TIME >= 1200 THEN
                ((dbo.SERVICE_LINES.START_TIME - 1200 ) / 100 )
            ELSE (dbo.SERVICE_LINES.START_TIME / 100 ) END )as start_time_hour,
       ( dbo.SERVICE_LINES.START_TIME % 100 ) as start_time_minutes,
       ( CASE WHEN dbo.SERVICE_LINES.START_TIME >= 1200 THEN 'PM' ELSE 'AM' END ) as start_time_AMPM,
       ( CASE WHEN dbo.SERVICE_LINES.END_TIME >= 1200 THEN
           ((dbo.SERVICE_LINES.END_TIME - 1200 ) / 100 )
            ELSE (dbo.SERVICE_LINES.END_TIME / 100 ) END ) as end_time_hour,
       ( dbo.SERVICE_LINES.END_TIME % 100 ) as end_time_minutes,
       ( CASE WHEN dbo.SERVICE_LINES.END_TIME >= 1200 THEN 'PM' ELSE 'AM' END ) as end_time_AMPM,
       ( dbo.SERVICE_LINES.BREAK_TIME_MINUTES / 60 ) AS lunch_dinner_hours,
       ( dbo.SERVICE_LINES.BREAK_TIME_MINUTES % 60 ) as lunch_dinner_minutes
  FROM dbo.LOOKUPS SERV_STATUS_TYPES RIGHT OUTER JOIN
       dbo.JOBS_V RIGHT OUTER JOIN
       dbo.SERVICES ON dbo.JOBS_V.JOB_ID = dbo.SERVICES.JOB_ID ON SERV_STATUS_TYPES.LOOKUP_ID = dbo.SERVICES.SERV_STATUS_TYPE_ID RIGHT OUTER JOIN
       dbo.SERVICE_LINE_STATUSES RIGHT OUTER JOIN
       dbo.USERS USERS_4 RIGHT OUTER JOIN
       dbo.USERS USERS_5 RIGHT OUTER JOIN
       dbo.USERS USERS_1 RIGHT OUTER JOIN
       dbo.SERVICE_LINES ON USERS_1.USER_ID = dbo.SERVICE_LINES.OVERRIDE_BY ON USERS_5.USER_ID = dbo.SERVICE_LINES.ENTERED_BY LEFT OUTER JOIN
       dbo.USERS USERS_2 ON dbo.SERVICE_LINES.VERIFIED_BY = USERS_2.USER_ID ON USERS_4.USER_ID = dbo.SERVICE_LINES.MODIFIED_BY LEFT OUTER JOIN
       dbo.USERS USERS_3 ON dbo.SERVICE_LINES.CREATED_BY = USERS_3.USER_ID ON dbo.SERVICE_LINE_STATUSES.STATUS_ID = dbo.SERVICE_LINES.STATUS_ID ON dbo.SERVICES.SERVICE_ID = dbo.SERVICE_LINES.TC_SERVICE_ID
GO
