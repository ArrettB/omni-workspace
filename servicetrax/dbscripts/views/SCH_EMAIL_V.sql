CREATE VIEW dbo.SCH_EMAIL_V
AS
SELECT     TOP 100 PERCENT today.ORGANIZATION_ID, today.RESOURCE_ID, today.resource_name, today.sch_foreman_flag, dbo.CONTACTS.EMAIL, 
                      today.JOB_ID, TODAYS_JOBS.JOB_NO, TODAYS_JOBS.JOB_NAME, TODAYS_JOBS.CUSTOMER_NAME, CONVERT(VARCHAR(12), 
                      today.RES_START_DATE, 101) AS res_start_date, ISNULL(CONVERT(VARCHAR(12), today.RES_END_DATE, 101), CONVERT(VARCHAR(12), GETDATE(), 
                      101)) AS res_end_date, tomorrow.JOB_ID AS new_job_id, TOMORROWS_JOBS.JOB_NO AS new_job_no, 
                      TOMORROWS_JOBS.JOB_NAME AS new_job_name, TOMORROWS_JOBS.CUSTOMER_NAME AS new_customer_name, 
                      TOMORROWS_JOBS.foreman_resource_name AS new_foreman_resource_name, dbo.SERVICES.SERVICE_ID AS new_service_id, 
                      tomorrow.SERVICE_NO AS new_service_no, tomorrow.report_to_name AS report_to_type_name, CONVERT(VARCHAR(12), tomorrow.RES_START_DATE, 
                      101) AS new_res_start_date, ISNULL(CONVERT(VARCHAR(12), tomorrow.RES_END_DATE, 101), CONVERT(VARCHAR(12), DATEADD(day, 1, GETDATE()), 
                      101)) AS new_res_end_date, tomorrow.RES_START_TIME AS new_res_start_time, dbo.JOB_LOCATIONS.JOB_LOCATION_NAME, 
                      dbo.JOB_LOCATIONS.STREET1, dbo.JOB_LOCATIONS.STREET2, dbo.JOB_LOCATIONS.STREET3, dbo.JOB_LOCATIONS.CITY, 
                      dbo.JOB_LOCATIONS.STATE, dbo.JOB_LOCATIONS.ZIP
FROM         dbo.CONTACTS RIGHT OUTER JOIN
                      dbo.JOB_LOCATIONS RIGHT OUTER JOIN
                      dbo.SERVICES ON dbo.JOB_LOCATIONS.JOB_LOCATION_ID = dbo.SERVICES.JOB_LOCATION_ID RIGHT OUTER JOIN
                      dbo.SCH_RESOURCES_V tomorrow RIGHT OUTER JOIN
                      dbo.SCH_RESOURCES_V today ON tomorrow.JOB_ID <> today.JOB_ID AND tomorrow.RESOURCE_ID = today.RESOURCE_ID LEFT OUTER JOIN
                      dbo.JOBS_V TOMORROWS_JOBS ON tomorrow.JOB_ID = TOMORROWS_JOBS.JOB_ID ON 
                      dbo.SERVICES.SERVICE_ID = tomorrow.actual_service_id ON dbo.CONTACTS.CONTACT_ID = today.user_contact_id LEFT OUTER JOIN
                      dbo.JOBS_V TODAYS_JOBS ON today.JOB_ID = TODAYS_JOBS.JOB_ID
WHERE     (CONVERT(VARCHAR(12), today.RES_START_DATE, 101) <= CAST(CONVERT(VARCHAR(12), GETDATE(), 101) AS DATETIME)) AND 
                      (ISNULL(CONVERT(VARCHAR(12), today.RES_END_DATE, 101), CONVERT(VARCHAR(12), GETDATE(), 101)) >= CAST(CONVERT(VARCHAR(12), GETDATE(),
                       101) AS DATETIME)) AND (CONVERT(VARCHAR(12), tomorrow.RES_START_DATE, 101) <= CAST(CONVERT(VARCHAR(12), DATEADD(day, 1, GETDATE()), 
                      101) AS DATETIME)) AND (ISNULL(CONVERT(VARCHAR(12), tomorrow.RES_END_DATE, 101), CONVERT(VARCHAR(12), DATEADD(day, 1, GETDATE()), 
                      101)) >= CAST(CONVERT(VARCHAR(12), DATEADD(day, 1, GETDATE()), 101) AS DATETIME)) AND (today.JOB_ID IS NOT NULL) OR
                      (CONVERT(VARCHAR(12), today.RES_START_DATE, 101) <= CAST(CONVERT(VARCHAR(12), GETDATE(), 101) AS DATETIME)) AND 
                      (ISNULL(CONVERT(VARCHAR(12), today.RES_END_DATE, 101), CONVERT(VARCHAR(12), GETDATE(), 101)) >= CAST(CONVERT(VARCHAR(12), GETDATE(),
                       101) AS DATETIME)) AND (ISNULL(CONVERT(VARCHAR(12), tomorrow.RES_END_DATE, 101), CONVERT(VARCHAR(12), DATEADD(day, 1, GETDATE()), 
                      101)) >= CAST(CONVERT(VARCHAR(12), DATEADD(day, 1, GETDATE()), 101) AS DATETIME)) AND (today.JOB_ID IS NOT NULL) AND 
                      (tomorrow.RES_START_DATE IS NULL)
