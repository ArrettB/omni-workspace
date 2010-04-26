CREATE VIEW dbo.JOB_SEARCH_V
AS
SELECT     jobs_1.ORGANIZATION_ID, jobs_1.JOB_NO, jobs_1.JOB_ID, jobs_1.JOB_NAME, s.SERVICE_ID, s.SERVICE_NO, jobs_1.CUSTOMER_NAME, 
                      jobs_1.CUSTOMER_ID, jl.JOB_LOCATION_NAME, jobs_1.JOB_STATUS_TYPE_ID, jobs_1.JOB_TYPE_ID, jobs_1.DATE_CREATED, s.service_no_desc, 
                      s.serv_status_type_name
FROM         dbo.JOBS_V jobs_1 LEFT OUTER JOIN
                      dbo.SERVICES_V s ON jobs_1.JOB_ID = s.JOB_ID LEFT OUTER JOIN
                      dbo.JOB_LOCATIONS jl ON s.JOB_LOCATION_ID = jl.JOB_LOCATION_ID


