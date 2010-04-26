CREATE VIEW dbo.crystal_Job_time_by_job_v
AS
SELECT     ISNULL(dbo.TIME_CAPTURE_V.PAYROLL_QTY, 0) - ISNULL(dbo.TIME_CAPTURE_V.BILL_HOURLY_QTY, 0) AS hours_difference, 
                      CAST(dbo.jobs_v.job_no AS VARCHAR) AS job_no_varchar, dbo.jobs_v.job_id, dbo.jobs_v.project_id, dbo.TIME_CAPTURE_V.ORGANIZATION_ID, 
                      dbo.TIME_CAPTURE_V.TC_JOB_NO, dbo.TIME_CAPTURE_V.TC_SERVICE_NO, dbo.TIME_CAPTURE_V.TC_SERVICE_LINE_NO, 
                      dbo.TIME_CAPTURE_V.TC_JOB_ID, dbo.TIME_CAPTURE_V.TC_SERVICE_ID, dbo.TIME_CAPTURE_V.PH_SERVICE_ID, 
                      dbo.TIME_CAPTURE_V.SERVICE_LINE_ID, dbo.TIME_CAPTURE_V.SERVICE_LINE_DATE, dbo.TIME_CAPTURE_V.STATUS_ID, 
                      dbo.TIME_CAPTURE_V.status_name, dbo.TIME_CAPTURE_V.RESOURCE_ID, dbo.TIME_CAPTURE_V.ITEM_ID, dbo.TIME_CAPTURE_V.TC_QTY, 
                      dbo.TIME_CAPTURE_V.TC_RATE, dbo.TIME_CAPTURE_V.tc_total, dbo.TIME_CAPTURE_V.EXT_PAY_CODE, dbo.jobs_v.customer_name, 
                      dbo.jobs_v.job_name, dbo.jobs_v.end_user_name
FROM         dbo.jobs_v RIGHT OUTER JOIN
                      dbo.TIME_CAPTURE_V ON dbo.jobs_v.job_id = dbo.TIME_CAPTURE_V.TC_JOB_ID

