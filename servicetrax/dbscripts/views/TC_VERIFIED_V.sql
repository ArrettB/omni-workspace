CREATE VIEW dbo.TC_VERIFIED_V
AS
SELECT     ORGANIZATION_ID, SERVICE_LINE_ID, TC_JOB_NO, TC_SERVICE_NO, TC_SERVICE_LINE_NO, SERVICE_LINE_DATE, STATUS_ID, TC_JOB_ID, 
                      TC_SERVICE_ID, RESOURCE_ID, RESOURCE_NAME, ITEM_ID, ITEM_NAME, TC_QTY, TC_RATE, TC_TOTAL, PALM_REP_ID, ENTERED_DATE, 
                      ENTERED_BY, ENTRY_METHOD, VERIFIED_DATE, VERIFIED_BY, DATE_CREATED, CREATED_BY, DATE_MODIFIED, MODIFIED_BY
FROM         dbo.SERVICE_LINES
WHERE     (VERIFIED_BY IS NULL) AND (DATE_CREATED > CONVERT(DATETIME, '2004-01-01 00:00:00', 102))

