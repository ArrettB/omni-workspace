DROP VIEW dbo.JOB_PROGRESS_1_V
go
CREATE VIEW dbo.JOB_PROGRESS_1_V
AS
SELECT     dbo.PROJECTS_V.ORGANIZATION_ID, dbo.PROJECTS_V.PROJECT_ID, dbo.PROJECTS_V.PROJECT_NO, dbo.PROJECTS_V.CUSTOMER_ID, 
                      dbo.PROJECTS_V.PARENT_CUSTOMER_ID, dbo.PROJECTS_V.CUSTOMER_NAME, dbo.PROJECTS_V.JOB_NAME, dbo.JOBS.JOB_STATUS_TYPE_ID, 
                      JOB_STATUS_TYPE.CODE AS job_status_type_code, JOB_STATUS_TYPE.NAME AS job_status_type_name, MIN(dbo.SERVICES.EST_START_DATE) 
                      AS min_start_date, MAX(dbo.SERVICES.EST_END_DATE) AS max_end_date, dbo.PROJECTS_V.PERCENT_COMPLETE, 
                      COUNT(dbo.PUNCHLISTS.PUNCHLIST_ID) AS punchlist_count, dbo.PROJECTS_V.EXT_DEALER_ID, dbo.PROJECTS_V.DEALER_NAME, 
                      dbo.RESOURCES_V.user_full_name AS install_foreman, dbo.PROJECTS_V.project_status_type_code
FROM         dbo.REQUESTS RIGHT OUTER JOIN
                      dbo.SERVICES ON dbo.REQUESTS.REQUEST_ID = dbo.SERVICES.REQUEST_ID RIGHT OUTER JOIN
                      dbo.LOOKUPS JOB_STATUS_TYPE RIGHT OUTER JOIN
                      dbo.JOBS LEFT OUTER JOIN
                      dbo.RESOURCES_V ON dbo.JOBS.FOREMAN_RESOURCE_ID = dbo.RESOURCES_V.RESOURCE_ID ON 
                      JOB_STATUS_TYPE.LOOKUP_ID = dbo.JOBS.JOB_STATUS_TYPE_ID ON dbo.SERVICES.JOB_ID = dbo.JOBS.JOB_ID RIGHT OUTER JOIN
                      dbo.PUNCHLISTS RIGHT OUTER JOIN
                      dbo.PROJECTS_V ON dbo.PUNCHLISTS.PROJECT_ID = dbo.PROJECTS_V.PROJECT_ID ON 
                      dbo.JOBS.PROJECT_ID = dbo.PROJECTS_V.PROJECT_ID
GROUP BY dbo.PROJECTS_V.PROJECT_ID, dbo.JOBS.JOB_STATUS_TYPE_ID, dbo.PROJECTS_V.PROJECT_NO, dbo.PROJECTS_V.CUSTOMER_ID, 
                      dbo.PROJECTS_V.PARENT_CUSTOMER_ID, dbo.PROJECTS_V.CUSTOMER_NAME, dbo.PROJECTS_V.JOB_NAME, JOB_STATUS_TYPE.CODE, 
                      JOB_STATUS_TYPE.NAME, dbo.PROJECTS_V.PERCENT_COMPLETE, dbo.PROJECTS_V.ORGANIZATION_ID, dbo.PROJECTS_V.EXT_DEALER_ID, 
                      dbo.PROJECTS_V.DEALER_NAME, dbo.RESOURCES_V.user_full_name, dbo.PROJECTS_V.project_status_type_code
go

DROP VIEW dbo.JOB_PROGRESS_2_V
go
CREATE VIEW dbo.JOB_PROGRESS_2_V
AS
SELECT     ORGANIZATION_ID, PROJECT_ID, PROJECT_NO, CUSTOMER_ID, PARENT_CUSTOMER_ID, CUSTOMER_NAME, JOB_NAME, install_foreman, 
                      JOB_STATUS_TYPE_ID, job_status_type_code, job_status_type_name, min_start_date, max_end_date, CAST(DATEDIFF([hour], min_start_date, 
                      max_end_date + 1) AS numeric) AS duration, GETDATE() AS cur_date, CAST(DATEDIFF([hour], GETDATE(), max_end_date + 1) AS numeric) 
                      AS cur_duration_left, PERCENT_COMPLETE, punchlist_count, EXT_DEALER_ID, DEALER_NAME, project_status_type_code
FROM         dbo.JOB_PROGRESS_1_V
go


DROP VIEW dbo.JOB_PROGRESS_V
go
CREATE VIEW dbo.JOB_PROGRESS_V
AS
SELECT     ORGANIZATION_ID, PROJECT_ID, PROJECT_NO, EXT_DEALER_ID, DEALER_NAME, PARENT_CUSTOMER_ID, CUSTOMER_ID, CUSTOMER_NAME, 
                      JOB_NAME, install_foreman, JOB_STATUS_TYPE_ID, job_status_type_code, job_status_type_name, min_start_date, CONVERT(varchar(12), 
                      min_start_date, 101) AS min_start_date_varchar, cur_date, max_end_date, CONVERT(varchar(12), max_end_date, 101) AS max_end_date_varchar, 
                      duration, cur_duration_left, PERCENT_COMPLETE, (CASE duration WHEN 0 THEN 0 ELSE round((duration - cur_duration_left) / duration, 2) END) 
                      AS act_percent_complete, (CASE CAST(punchlist_count AS varchar) WHEN '0' THEN 'N' ELSE 'Y' END) AS punchlist, project_status_type_code
FROM         dbo.JOB_PROGRESS_2_V
go