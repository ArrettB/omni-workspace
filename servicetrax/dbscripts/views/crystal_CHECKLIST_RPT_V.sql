CREATE VIEW dbo.CHECKLIST_RPT_V
AS
SELECT     dbo.CHECKLIST_DATA.CHECKLIST_DATA_ID, dbo.CHECKLIST_DATA.CHECKLIST_ID, dbo.CHECKLIST_DATA.DATA_NAME, 
                      dbo.CHECKLIST_DATA.DATA_VALUE, dbo.CHECKLIST_DATA.NUM_STATIONS, dbo.CHECKLISTS.DATE_CREATED, dbo.REQUESTS.REQUEST_NO, 
                      dbo.PROJECTS.PROJECT_NO, dbo.CHECKLISTS.NUM_STATIONS AS STATIONS, dbo.CUSTOMERS.EXT_DEALER_ID, 
                      dbo.CUSTOMERS.DEALER_NAME
FROM         dbo.CHECKLIST_DATA INNER JOIN
                      dbo.CHECKLISTS ON dbo.CHECKLIST_DATA.CHECKLIST_ID = dbo.CHECKLISTS.CHECKLIST_ID INNER JOIN
                      dbo.REQUESTS ON dbo.CHECKLISTS.REQUEST_ID = dbo.REQUESTS.REQUEST_ID INNER JOIN
                      dbo.PROJECTS ON dbo.REQUESTS.PROJECT_ID = dbo.PROJECTS.PROJECT_ID INNER JOIN
                      dbo.CUSTOMERS ON dbo.PROJECTS.CUSTOMER_ID = dbo.CUSTOMERS.CUSTOMER_ID
WHERE     (dbo.CUSTOMERS.EXT_DEALER_ID = '3017') OR
                      (dbo.CUSTOMERS.EXT_DEALER_ID = '1002') OR
                      (dbo.CUSTOMERS.EXT_DEALER_ID = '1000') OR
                      (dbo.CUSTOMERS.EXT_DEALER_ID = '1001')

