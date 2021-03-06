CREATE VIEW dbo.crystal_TC_VERIFIED_V
AS
SELECT     dbo.SERVICE_LINES.ORGANIZATION_ID, dbo.SERVICE_LINES.SERVICE_LINE_ID, dbo.SERVICE_LINES.TC_JOB_NO, 
                      dbo.SERVICE_LINES.TC_SERVICE_NO, dbo.SERVICE_LINES.TC_SERVICE_LINE_NO, dbo.SERVICE_LINES.SERVICE_LINE_DATE, 
                      dbo.SERVICE_LINES.STATUS_ID, dbo.SERVICE_LINES.TC_JOB_ID, dbo.SERVICE_LINES.TC_SERVICE_ID, dbo.SERVICE_LINES.RESOURCE_ID, 
                      dbo.SERVICE_LINES.RESOURCE_NAME, dbo.SERVICE_LINES.ITEM_ID, dbo.SERVICE_LINES.ITEM_NAME, dbo.SERVICE_LINES.TC_QTY, 
                      dbo.SERVICE_LINES.TC_RATE, dbo.SERVICE_LINES.TC_TOTAL, dbo.SERVICE_LINES.PALM_REP_ID, dbo.SERVICE_LINES.ENTERED_DATE, 
                      dbo.SERVICE_LINES.ENTERED_BY, dbo.SERVICE_LINES.VERIFIED_DATE, dbo.SERVICE_LINES.VERIFIED_BY, dbo.SERVICE_LINES.DATE_CREATED, 
                      dbo.SERVICE_LINES.CREATED_BY, dbo.SERVICE_LINES.DATE_MODIFIED, dbo.SERVICE_LINES.MODIFIED_BY, dbo.SERVICES_V.DESCRIPTION
FROM         dbo.SERVICE_LINES INNER JOIN
                      dbo.SERVICES_V ON dbo.SERVICE_LINES.TC_JOB_NO = dbo.SERVICES_V.JOB_NO AND 
                      dbo.SERVICE_LINES.TC_SERVICE_NO = dbo.SERVICES_V.SERVICE_NO

