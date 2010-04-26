CREATE VIEW dbo.crystal_workorder_detail_pkf_V
AS
SELECT     dbo.PROJECTS_V.ORGANIZATION_ID, dbo.REQUESTS.PROJECT_ID, dbo.REQUESTS.REQUEST_ID, dbo.PROJECTS_V.EXT_DEALER_ID, 
                      dbo.PROJECTS_V.CUSTOMER_ID, dbo.PROJECTS_V.PARENT_CUSTOMER_ID, dbo.PROJECTS_V.PROJECT_NO, dbo.REQUESTS.REQUEST_NO, 
                      CONVERT(varchar, dbo.PROJECTS_V.PROJECT_NO) + '-' + CONVERT(varchar, dbo.REQUESTS.REQUEST_NO) AS workorder_no, 
                      dbo.PROJECTS_V.DEALER_NAME, dbo.PROJECTS_V.CUSTOMER_NAME, dbo.JOB_LOCATIONS.JOB_LOCATION_NAME, 
                      request_types.CODE AS request_type_code, request_status_types.CODE AS request_status_type_code, 
                      request_types.SEQUENCE_NO AS request_seq_no, dbo.PROJECTS_V.project_status_type_code, dbo.REQUESTS.DESCRIPTION, 
                      dbo.REQUESTS.CUSTOMER_PO_NO, dbo.REQUESTS.DEALER_PO_NO
FROM         dbo.LOOKUPS request_status_types RIGHT OUTER JOIN
                      dbo.REQUESTS ON request_status_types.LOOKUP_ID = dbo.REQUESTS.REQUEST_STATUS_TYPE_ID LEFT OUTER JOIN
                      dbo.JOB_LOCATIONS ON dbo.REQUESTS.JOB_LOCATION_ID = dbo.JOB_LOCATIONS.JOB_LOCATION_ID LEFT OUTER JOIN
                      dbo.PROJECTS_V ON dbo.REQUESTS.PROJECT_ID = dbo.PROJECTS_V.PROJECT_ID CROSS JOIN
                      dbo.LOOKUPS request_types

