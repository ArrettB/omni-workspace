

CREATE VIEW dbo.PKT_JOB_RESOURCES_V
AS
SELECT     dbo.JOBS.JOB_ID, dbo.RESOURCES.RESOURCE_ID, dbo.RESOURCES.NAME AS resource_name
FROM         dbo.RESOURCES INNER JOIN
                      dbo.PKT_JOB_USER_RES_V INNER JOIN
                      dbo.JOBS INNER JOIN
                      dbo.LOOKUPS ON dbo.JOBS.JOB_STATUS_TYPE_ID = dbo.LOOKUPS.LOOKUP_ID ON dbo.PKT_JOB_USER_RES_V.JOB_ID = dbo.JOBS.JOB_ID ON 
                      dbo.RESOURCES.RESOURCE_ID = dbo.PKT_JOB_USER_RES_V.RESOURCE_ID
WHERE     (dbo.LOOKUPS.CODE <> 'install_complete') AND (dbo.LOOKUPS.CODE <> 'invoiced') AND (dbo.LOOKUPS.CODE <> 'closed')



