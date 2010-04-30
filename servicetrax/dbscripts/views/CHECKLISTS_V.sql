CREATE VIEW dbo.CHECKLISTS_V
AS
SELECT     dbo.PROJECTS_ALL_REQUESTS_V.ORGANIZATION_ID, dbo.CHECKLISTS.CHECKLIST_ID, dbo.PROJECTS_ALL_REQUESTS_V.PROJECT_ID, 
                      dbo.CHECKLISTS.REQUEST_ID, dbo.PROJECTS_ALL_REQUESTS_V.record_no, dbo.CHECKLISTS.NUM_STATIONS, dbo.CHECKLISTS.DATE_CREATED, 
                      dbo.CHECKLISTS.CREATED_BY, CREATED_BY.FIRST_NAME + ' ' + CREATED_BY.LAST_NAME AS created_by_name, 
                      dbo.CHECKLISTS.DATE_MODIFIED, UPDATED_BY.FIRST_NAME + ' ' + UPDATED_BY.LAST_NAME AS modified_by_name
FROM         dbo.CHECKLISTS INNER JOIN
                      dbo.PROJECTS_ALL_REQUESTS_V ON dbo.CHECKLISTS.REQUEST_ID = dbo.PROJECTS_ALL_REQUESTS_V.record_id LEFT OUTER JOIN
                      dbo.USERS CREATED_BY ON dbo.CHECKLISTS.CREATED_BY = CREATED_BY.USER_ID LEFT OUTER JOIN
                      dbo.USERS UPDATED_BY ON dbo.CHECKLISTS.MODIFIED_BY = UPDATED_BY.USER_ID
WHERE     (dbo.PROJECTS_ALL_REQUESTS_V.record_type_code = 'service_request')
