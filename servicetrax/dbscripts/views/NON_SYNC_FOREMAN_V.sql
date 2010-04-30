CREATE VIEW dbo.NON_SYNC_FOREMAN_V
AS
SELECT     TOP 100 PERCENT dbo.JOBS_V.ORGANIZATION_ID, dbo.JOBS_V.JOB_NO, dbo.USERS.FULL_NAME AS employee_name, 
                      dbo.USERS.EXT_EMPLOYEE_ID, dbo.SCH_RESOURCE_DATES_V.exploded_date, dbo.USERS.LAST_SYNCH_DATE, GETDATE() AS todays_date
FROM         dbo.RESOURCES LEFT OUTER JOIN
                      dbo.USERS ON dbo.RESOURCES.USER_ID = dbo.USERS.USER_ID RIGHT OUTER JOIN
                      dbo.SCH_RESOURCES ON dbo.RESOURCES.RESOURCE_ID = dbo.SCH_RESOURCES.RESOURCE_ID AND 
                      dbo.RESOURCES.RESOURCE_ID = dbo.SCH_RESOURCES.RESOURCE_ID RIGHT OUTER JOIN
                      dbo.SCH_RESOURCE_DATES_V LEFT OUTER JOIN
                      dbo.JOBS_V ON dbo.SCH_RESOURCE_DATES_V.JOB_ID = dbo.JOBS_V.JOB_ID ON 
                      dbo.SCH_RESOURCES.SCH_RESOURCE_ID = dbo.SCH_RESOURCE_DATES_V.SCH_RESOURCE_ID
WHERE     (CONVERT(varchar(12), GETDATE(), 101) = dbo.SCH_RESOURCE_DATES_V.exploded_date) AND (CONVERT(varchar(12), 
                      dbo.USERS.LAST_SYNCH_DATE, 101) <> CONVERT(varchar(12), GETDATE(), 101))
