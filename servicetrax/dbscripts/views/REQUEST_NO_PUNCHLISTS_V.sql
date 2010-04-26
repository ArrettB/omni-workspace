CREATE VIEW dbo.REQUEST_NO_PUNCHLISTS_V
AS
SELECT     dbo.PROJECTS_V.ORGANIZATION_ID, dbo.PROJECTS_V.PROJECT_ID, dbo.REQUESTS.REQUEST_ID, dbo.PROJECTS_V.PROJECT_NO, 
                      dbo.REQUESTS.REQUEST_NO, CONVERT(varchar, dbo.PROJECTS_V.PROJECT_NO) + '-' + CONVERT(varchar, dbo.REQUESTS.REQUEST_NO) 
                      AS project_request_no, dbo.PROJECTS_V.project_status_type_code, dbo.PROJECTS_V.CUSTOMER_ID, dbo.PROJECTS_V.PARENT_CUSTOMER_ID, 
                      dbo.PROJECTS_V.EXT_DEALER_ID, dbo.PROJECTS_V.DEALER_NAME, dbo.PROJECTS_V.EXT_CUSTOMER_ID, dbo.PROJECTS_V.CUSTOMER_NAME, 
                      dbo.PROJECTS_V.JOB_NAME, request_types.CODE AS request_type_code, request_status_types.CODE AS request_status_type_code, 
                      request_status_types.NAME AS request_status_type_name, dbo.REQUESTS.DATE_CREATED
FROM         dbo.PROJECTS_V INNER JOIN
                      dbo.REQUESTS INNER JOIN
                      dbo.VERSIONS_MAX_NO_V ON dbo.REQUESTS.PROJECT_ID = dbo.VERSIONS_MAX_NO_V.PROJECT_ID AND 
                      dbo.REQUESTS.REQUEST_NO = dbo.VERSIONS_MAX_NO_V.REQUEST_NO AND 
                      dbo.REQUESTS.VERSION_NO = dbo.VERSIONS_MAX_NO_V.max_version_no ON 
                      dbo.PROJECTS_V.PROJECT_ID = dbo.REQUESTS.PROJECT_ID LEFT OUTER JOIN
                      dbo.LOOKUPS request_status_types ON dbo.REQUESTS.REQUEST_STATUS_TYPE_ID = request_status_types.LOOKUP_ID LEFT OUTER JOIN
                      dbo.LOOKUPS request_types ON dbo.REQUESTS.REQUEST_TYPE_ID = request_types.LOOKUP_ID
WHERE     (NOT EXISTS
                          (SELECT     request_id
                            FROM          punchlists p
                            WHERE      p.request_id = dbo.REQUESTS.REQUEST_ID))

