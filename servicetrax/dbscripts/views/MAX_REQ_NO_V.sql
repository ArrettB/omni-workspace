CREATE VIEW dbo.MAX_REQ_NO_V
AS
SELECT     TOP 100 PERCENT dbo.PROJECTS.PROJECT_ID, dbo.PROJECTS.PROJECT_NO, MAX(ISNULL(dbo.REQUESTS.REQUEST_NO, 0)) AS max_request_no, 
                      dbo.JOBS.JOB_ID, dbo.JOBS.JOB_NO, MAX(ISNULL(dbo.SERVICES.SERVICE_NO, 0)) AS max_service_no
FROM         dbo.REQUESTS RIGHT OUTER JOIN
                      dbo.PROJECTS ON dbo.REQUESTS.PROJECT_ID = dbo.PROJECTS.PROJECT_ID FULL OUTER JOIN
                      dbo.JOBS LEFT OUTER JOIN
                      dbo.SERVICES ON dbo.JOBS.JOB_ID = dbo.SERVICES.JOB_ID ON dbo.PROJECTS.PROJECT_ID = dbo.JOBS.PROJECT_ID
GROUP BY dbo.PROJECTS.PROJECT_ID, dbo.JOBS.JOB_ID, dbo.JOBS.JOB_NO, dbo.PROJECTS.PROJECT_NO
ORDER BY dbo.JOBS.JOB_ID
