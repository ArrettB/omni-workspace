CREATE VIEW dbo.crystal_JOBS_COMPLETED_V
AS
SELECT     dbo.PROJECTS_V.ORGANIZATION_ID, dbo.PROJECTS_V.PROJECT_ID, dbo.PROJECTS_V.PROJECT_NO, dbo.PROJECTS_V.CUSTOMER_NAME, 
                      dbo.PROJECTS_V.JOB_NAME, dbo.PROJECTS_V.project_status_type_name, dbo.PROJECTS_V.project_status_type_code, 
                      dbo.JOBS.JOB_STATUS_TYPE_ID, JOB_STATUS_TYPE.CODE AS job_status_type_code, JOB_STATUS_TYPE.NAME AS job_status_type_name, 
                      MIN(dbo.SERVICES.EST_START_DATE) AS min_start_date, MAX(dbo.SERVICES.EST_END_DATE) AS max_end_date, 
                      dbo.PROJECTS_V.PERCENT_COMPLETE, COUNT(dbo.PUNCHLISTS.PUNCHLIST_ID) AS punchlist_count, dbo.PROJECTS_V.EXT_DEALER_ID, 
                      dbo.PROJECTS_V.DEALER_NAME, dbo.REQUESTS.CUSTOMER_CONTACT_ID, dbo.CONTACTS.CONTACT_ID, dbo.CONTACTS.CONTACT_NAME, 
                      dbo.CONTACTS.PHONE_WORK, dbo.REQUESTS.DEALER_PO_NO
FROM         dbo.REQUESTS INNER JOIN
                      dbo.CONTACTS ON dbo.REQUESTS.CUSTOMER_CONTACT_ID = dbo.CONTACTS.CONTACT_ID FULL OUTER JOIN
                      dbo.SERVICES ON dbo.REQUESTS.REQUEST_ID = dbo.SERVICES.REQUEST_ID FULL OUTER JOIN
                      dbo.PUNCHLISTS RIGHT OUTER JOIN
                      dbo.PROJECTS_V ON dbo.PUNCHLISTS.PROJECT_ID = dbo.PROJECTS_V.PROJECT_ID LEFT OUTER JOIN
                      dbo.JOBS LEFT OUTER JOIN
                      dbo.LOOKUPS JOB_STATUS_TYPE ON dbo.JOBS.JOB_STATUS_TYPE_ID = JOB_STATUS_TYPE.LOOKUP_ID ON 
                      dbo.PROJECTS_V.PROJECT_ID = dbo.JOBS.PROJECT_ID ON dbo.SERVICES.JOB_ID = dbo.JOBS.JOB_ID
GROUP BY dbo.PROJECTS_V.PROJECT_ID, dbo.JOBS.JOB_STATUS_TYPE_ID, dbo.PROJECTS_V.PROJECT_NO, dbo.PROJECTS_V.CUSTOMER_NAME, 
                      dbo.PROJECTS_V.JOB_NAME, dbo.PROJECTS_V.project_status_type_name, dbo.PROJECTS_V.project_status_type_code, JOB_STATUS_TYPE.CODE, 
                      JOB_STATUS_TYPE.NAME, dbo.PROJECTS_V.PERCENT_COMPLETE, dbo.PROJECTS_V.ORGANIZATION_ID, dbo.PROJECTS_V.EXT_DEALER_ID, 
                      dbo.PROJECTS_V.DEALER_NAME, dbo.REQUESTS.CUSTOMER_CONTACT_ID, dbo.CONTACTS.CONTACT_ID, dbo.CONTACTS.CONTACT_NAME, 
                      dbo.CONTACTS.PHONE_WORK, dbo.REQUESTS.DEALER_PO_NO
HAVING      (dbo.PROJECTS_V.ORGANIZATION_ID = 4) AND (dbo.JOBS.JOB_STATUS_TYPE_ID = 113) OR
                      (dbo.JOBS.JOB_STATUS_TYPE_ID = 120)
