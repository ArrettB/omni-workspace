CREATE VIEW dbo.MISSING_EMP_HRS_V
AS
SELECT     dbo.JOBS_V.ORGANIZATION_ID, dbo.RESOURCES.USER_ID, dbo.USERS.EXT_EMPLOYEE_ID, dbo.USERS.FULL_NAME AS employee_name, 
                      dbo.JOBS_V.FOREMAN_RESOURCE_ID, dbo.JOBS_V.foreman_resource_name, dbo.SCH_RESOURCE_DATES_V.JOB_ID, dbo.JOBS_V.JOB_NO, 
                      dbo.JOBS_V.JOB_NAME, dbo.SCH_RESOURCE_DATES_V.RES_START_DATE, dbo.SCH_RESOURCE_DATES_V.RES_END_DATE, 
                      dbo.SCH_RESOURCE_DATES_V.exploded_date
FROM         dbo.SCH_RESOURCE_DATES_V LEFT OUTER JOIN
                      dbo.JOBS_V ON dbo.SCH_RESOURCE_DATES_V.JOB_ID = dbo.JOBS_V.JOB_ID LEFT OUTER JOIN
                      dbo.RESOURCES ON dbo.SCH_RESOURCE_DATES_V.RESOURCE_ID = dbo.RESOURCES.RESOURCE_ID LEFT OUTER JOIN
                      dbo.USERS ON dbo.RESOURCES.USER_ID = dbo.USERS.USER_ID
WHERE     (NOT EXISTS
                          (SELECT     1
                            FROM          SERVICE_LINES
                            WHERE      SCH_RESOURCE_DATES_V.JOB_ID = tc_JOB_ID AND 
                                                   dbo.SCH_RESOURCE_DATES_V.exploded_date = dbo.SERVICE_LINES.SERVICE_LINE_DATE_varchar))



