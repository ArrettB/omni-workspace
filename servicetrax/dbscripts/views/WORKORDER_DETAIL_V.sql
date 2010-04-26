CREATE VIEW dbo.WORKORDER_DETAIL_V
AS
SELECT     dbo.PROJECTS_V.ORGANIZATION_ID, dbo.REQUESTS.PROJECT_ID, dbo.REQUESTS.REQUEST_ID, dbo.PROJECTS_V.EXT_DEALER_ID, 
                      dbo.PROJECTS_V.CUSTOMER_ID, dbo.PROJECTS_V.PARENT_CUSTOMER_ID, dbo.PROJECTS_V.PROJECT_NO, dbo.REQUESTS.REQUEST_NO, 
                      CONVERT(varchar, dbo.PROJECTS_V.PROJECT_NO) + '-' + CONVERT(varchar, dbo.REQUESTS.REQUEST_NO) AS workorder_no, 
                      dbo.PROJECTS_V.DEALER_NAME, dbo.PROJECTS_V.CUSTOMER_NAME, dbo.JOB_LOCATIONS.JOB_LOCATION_NAME, 
                      floor_numbers.NAME AS floor_number, request_types.CODE AS request_type_code, request_status_types.CODE AS request_status_type_code, 
                      request_types.SEQUENCE_NO AS request_seq_no, dbo.PROJECTS_V.project_status_type_code, dbo.REQUESTS.CUST_COL_1, 
                      dbo.REQUESTS.CUST_COL_2, dbo.REQUESTS.CUST_COL_3, dbo.REQUESTS.CUST_COL_4, dbo.REQUESTS.CUST_COL_5, 
                      dbo.REQUESTS.CUST_COL_6, dbo.REQUESTS.CUST_COL_7, dbo.REQUESTS.CUST_COL_8, dbo.REQUESTS.CUST_COL_9, 
                      dbo.REQUESTS.CUST_COL_10, dbo.CONTACTS.CONTACT_NAME AS customer_contact_name, dbo.REQUESTS.DESCRIPTION
FROM         dbo.LOOKUPS request_status_types RIGHT OUTER JOIN
                      dbo.REQUESTS INNER JOIN
                      dbo.VERSIONS_MAX_NO_V ON dbo.REQUESTS.PROJECT_ID = dbo.VERSIONS_MAX_NO_V.PROJECT_ID AND 
                      dbo.REQUESTS.REQUEST_NO = dbo.VERSIONS_MAX_NO_V.REQUEST_NO AND 
                      dbo.REQUESTS.VERSION_NO = dbo.VERSIONS_MAX_NO_V.max_version_no LEFT OUTER JOIN
                      dbo.CONTACTS ON dbo.REQUESTS.CUSTOMER_CONTACT_ID = dbo.CONTACTS.CONTACT_ID ON 
                      request_status_types.LOOKUP_ID = dbo.REQUESTS.REQUEST_STATUS_TYPE_ID LEFT OUTER JOIN
                      dbo.LOOKUPS floor_numbers ON dbo.REQUESTS.FLOOR_NUMBER_TYPE_ID = floor_numbers.LOOKUP_ID LEFT OUTER JOIN
                      dbo.JOB_LOCATIONS ON dbo.REQUESTS.JOB_LOCATION_ID = dbo.JOB_LOCATIONS.JOB_LOCATION_ID LEFT OUTER JOIN
                      dbo.LOOKUPS request_types ON dbo.REQUESTS.REQUEST_TYPE_ID = request_types.LOOKUP_ID LEFT OUTER JOIN
                      dbo.PROJECTS_V ON dbo.REQUESTS.PROJECT_ID = dbo.PROJECTS_V.PROJECT_ID

