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

