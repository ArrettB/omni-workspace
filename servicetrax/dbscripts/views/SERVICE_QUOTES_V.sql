CREATE VIEW dbo.SERVICE_QUOTES_V
AS
SELECT     dbo.PROJECTS_V.PROJECT_ID, QUOTE_REQUESTS.REQUEST_ID AS quote_request_id, SERVICE_REQUESTS.REQUEST_ID AS service_request_id, 
                      dbo.QUOTES_V.QUOTE_ID, dbo.SERVICES.JOB_ID, dbo.SERVICES.SERVICE_ID, dbo.PROJECTS_V.PROJECT_NO, dbo.QUOTES_V.QUOTE_NO, 
                      dbo.QUOTES_V.project_quote_no, dbo.QUOTES_V.QUOTE_TOTAL
FROM         dbo.REQUESTS QUOTE_REQUESTS INNER JOIN
                      dbo.REQUESTS SERVICE_REQUESTS INNER JOIN
                      dbo.SERVICES ON SERVICE_REQUESTS.REQUEST_ID = dbo.SERVICES.REQUEST_ID ON 
                      QUOTE_REQUESTS.REQUEST_ID = SERVICE_REQUESTS.QUOTE_REQUEST_ID INNER JOIN
                      dbo.QUOTES_V ON QUOTE_REQUESTS.REQUEST_ID = dbo.QUOTES_V.REQUEST_ID INNER JOIN
                      dbo.PROJECTS_V ON QUOTE_REQUESTS.PROJECT_ID = dbo.PROJECTS_V.PROJECT_ID


