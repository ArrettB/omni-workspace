CREATE VIEW dbo.JOB_PROGRESS_2_V
AS
SELECT     ORGANIZATION_ID, PROJECT_ID, PROJECT_NO, CUSTOMER_ID, PARENT_CUSTOMER_ID, CUSTOMER_NAME, JOB_NAME, install_foreman, 
                      JOB_STATUS_TYPE_ID, job_status_type_code, job_status_type_name, min_start_date, max_end_date, CAST(DATEDIFF([hour], min_start_date, 
                      max_end_date + 1) AS numeric) AS duration, GETDATE() AS cur_date, CAST(DATEDIFF([hour], GETDATE(), max_end_date + 1) AS numeric) 
                      AS cur_duration_left, PERCENT_COMPLETE, punchlist_count, EXT_DEALER_ID, DEALER_NAME, project_status_type_code
FROM         dbo.JOB_PROGRESS_1_V

