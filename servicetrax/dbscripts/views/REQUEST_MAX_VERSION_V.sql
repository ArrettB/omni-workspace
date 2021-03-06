CREATE VIEW dbo.REQUEST_MAX_VERSION_V
AS
SELECT     dbo.VERSIONS_MAX_NO_V.PROJECT_ID, dbo.VERSIONS_MAX_NO_V.PROJECT_NO, dbo.REQUESTS.REQUEST_ID, 
                      dbo.VERSIONS_MAX_NO_V.REQUEST_NO, dbo.REQUESTS.VERSION_NO, dbo.VERSIONS_MAX_NO_V.max_version_no
FROM         dbo.REQUESTS INNER JOIN
                      dbo.VERSIONS_MAX_NO_V ON dbo.REQUESTS.PROJECT_ID = dbo.VERSIONS_MAX_NO_V.PROJECT_ID AND 
                      dbo.REQUESTS.REQUEST_NO = dbo.VERSIONS_MAX_NO_V.REQUEST_NO AND 
                      dbo.REQUESTS.VERSION_NO = dbo.VERSIONS_MAX_NO_V.max_version_no

