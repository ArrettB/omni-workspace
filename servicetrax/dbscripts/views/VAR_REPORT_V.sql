
CREATE VIEW dbo.VAR_REPORT_V
AS
SELECT     dbo.JOBS_V.JOB_ID, dbo.JOBS_V.JOB_NO, dbo.JOBS_V.JOB_NAME, dbo.JOBS_V.job_type_code, dbo.JOBS_V.job_status_type_name, 
                      dbo.JOBS_V.EXT_DEALER_ID, dbo.JOBS_V.DEALER_NAME, dbo.JOBS_V.CUSTOMER_ID, dbo.JOBS_V.CUSTOMER_NAME, 
                      dbo.JOBS_V.ORGANIZATION_ID, dbo.JOBS_V.BILLING_USER_ID, dbo.JOBS_V.foreman_user_id, ISNULL(dbo.VAR_JOB_TIME_EXP_V.sum_time_exp, 
                      0) AS sum_time_exp, ISNULL(dbo.VAR_JOB_TIME_EXP_V.sum_time, 0) AS sum_time, ISNULL(dbo.VAR_JOB_TIME_EXP_V.sum_exp, 0) AS sum_exp, 
                      ISNULL(dbo.VAR_JOB_QUOTED_V.sum_quote, 0) AS sum_quote, ISNULL(dbo.VAR_JOB_ACT_HOURS_V.sum_payroll_qty, 0) AS sum_payroll_qty, 
                      ISNULL(dbo.VAR_JOB_ACT_HOURS_V.sum_expense_qty, 0) AS sum_expense_qty, ISNULL(dbo.VAR_JOB_EST_HOURS_V.sum_estimated_hours, 0) 
                      AS sum_estimated_hours
FROM         dbo.JOBS_V LEFT OUTER JOIN
                      dbo.VAR_JOB_TIME_EXP_V ON dbo.JOBS_V.JOB_ID = dbo.VAR_JOB_TIME_EXP_V.job_id LEFT OUTER JOIN
                      dbo.VAR_JOB_QUOTED_V ON dbo.JOBS_V.JOB_ID = dbo.VAR_JOB_QUOTED_V.JOB_ID LEFT OUTER JOIN
                      dbo.VAR_JOB_ACT_HOURS_V ON dbo.JOBS_V.JOB_ID = dbo.VAR_JOB_ACT_HOURS_V.JOB_ID LEFT OUTER JOIN
                      dbo.VAR_JOB_EST_HOURS_V ON dbo.JOBS_V.JOB_ID = dbo.VAR_JOB_EST_HOURS_V.JOB_ID


