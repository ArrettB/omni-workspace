CREATE VIEW dbo.crystal_dashboard_REQUESTS_V
AS
SELECT     dbo.REQUESTS.REQUEST_ID, dbo.REQUESTS.REQUEST_NO, dbo.REQUESTS.VERSION_NO, dbo.VERSIONS_MAX_NO_V.max_version_no, 
                      dbo.REQUESTS.REQUEST_TYPE_ID, REQUEST_TYPE.CODE AS request_type_code, REQUEST_TYPE.NAME AS request_type_name, 
                      dbo.REQUESTS.REQUEST_STATUS_TYPE_ID, REQUEST_STATUS_TYPE.CODE AS request_status_type_code, 
                      REQUEST_STATUS_TYPE.NAME AS request_status_type_name, dbo.REQUESTS.PROJECT_ID, dbo.SERVICES.SERVICE_ID, 
                      dbo.SERVICES.SERV_STATUS_TYPE_ID, SERV_STATUS_TYPE.CODE AS serv_status_type_code, 
                      SERV_STATUS_TYPE.NAME AS serv_status_type_name, dbo.REQUESTS.DEALER_CUST_ID, dbo.REQUESTS.ACCOUNT_TYPE_ID, 
                      ACCOUNT_TYPE.CODE AS account_type_code, ACCOUNT_TYPE.NAME AS account_type_name, dbo.REQUESTS.QUOTE_TYPE_ID, 
                      QUOTE_TYPE.CODE AS quote_type_code, QUOTE_TYPE.NAME AS quote_type_name, dbo.REQUESTS.QUOTE_NEEDED_BY, 
                      dbo.REQUESTS.EST_START_DATE, CONVERT(varchar(12), dbo.REQUESTS.EST_START_DATE, 101) AS est_start_date_varchar, 
                      dbo.REQUESTS.EST_START_TIME, dbo.REQUESTS.DATE_CREATED, dbo.REQUESTS.CREATED_BY, dbo.REQUESTS.DATE_MODIFIED, 
                      dbo.REQUESTS.MODIFIED_BY, dbo.PROJECTS_V.PROJECT_NO, CONVERT(varchar, dbo.PROJECTS_V.PROJECT_NO) + '-' + CONVERT(varchar, 
                      dbo.REQUESTS.REQUEST_NO) AS project_request_no, dbo.PROJECTS_V.CUSTOMER_ID, CUSTOMERS_1.PARENT_CUSTOMER_ID, 
                      CUSTOMERS_1.EXT_DEALER_ID, CUSTOMERS_1.DEALER_NAME, CUSTOMERS_1.EXT_CUSTOMER_ID, CUSTOMERS_1.CUSTOMER_NAME, 
                      dbo.PROJECTS_V.JOB_NAME, dbo.REQUESTS.IS_SENT, dbo.REQUESTS.IS_QUOTED, dbo.REQUESTS.QUOTE_REQUEST_ID, 
                      dbo.REQUESTS.REQUEST_NO AS record_seq_no, USERS_1.FIRST_NAME + ' ' + USERS_1.LAST_NAME AS created_by_name, 
                      USERS_2.FIRST_NAME + ' ' + USERS_2.LAST_NAME AS modified_by_name, A_M_CONTACT.CONTACT_NAME AS a_m_contact_name, 
                      dbo.PROJECTS_V.PROJECT_STATUS_TYPE_ID, dbo.PROJECTS_V.project_status_type_code, dbo.PROJECTS_V.project_status_type_name, 
                      CONVERT(varchar(12), dbo.REQUESTS.DATE_CREATED, 101) AS date_created_varchar, dbo.ORGANIZATIONS.NAME AS Org_name, 
                      dbo.ORGANIZATIONS.CODE AS Org_code, dbo.PROJECTS_V.ORGANIZATION_ID
FROM         dbo.LOOKUPS REQUEST_TYPE RIGHT OUTER JOIN
                      dbo.LOOKUPS ACCOUNT_TYPE RIGHT OUTER JOIN
                      dbo.REQUESTS ON ACCOUNT_TYPE.LOOKUP_ID = dbo.REQUESTS.ACCOUNT_TYPE_ID LEFT OUTER JOIN
                      dbo.LOOKUPS QUOTE_TYPE ON dbo.REQUESTS.QUOTE_TYPE_ID = QUOTE_TYPE.LOOKUP_ID FULL OUTER JOIN
                      dbo.PROJECTS_V FULL OUTER JOIN
                      dbo.CONTACTS A_M_CONTACT INNER JOIN
                      dbo.USERS USERS_2 INNER JOIN
                      dbo.USERS USERS_1 INNER JOIN
                      dbo.ORGANIZATIONS ON USERS_1.USER_ID = dbo.ORGANIZATIONS.CREATED_BY AND USERS_1.USER_ID = dbo.ORGANIZATIONS.MODIFIED_BY ON
                       USERS_2.USER_ID = dbo.ORGANIZATIONS.CREATED_BY AND USERS_2.USER_ID = dbo.ORGANIZATIONS.MODIFIED_BY INNER JOIN
                      dbo.CUSTOMERS CUSTOMERS_1 ON dbo.ORGANIZATIONS.ORGANIZATION_ID = CUSTOMERS_1.ORGANIZATION_ID ON 
                      A_M_CONTACT.ORGANIZATION_ID = dbo.ORGANIZATIONS.ORGANIZATION_ID ON 
                      dbo.PROJECTS_V.ORGANIZATION_ID = dbo.ORGANIZATIONS.ORGANIZATION_ID AND 
                      dbo.PROJECTS_V.CUSTOMER_ID = CUSTOMERS_1.CUSTOMER_ID ON dbo.REQUESTS.MODIFIED_BY = USERS_2.USER_ID AND 
                      dbo.REQUESTS.CREATED_BY = USERS_1.USER_ID AND dbo.REQUESTS.A_M_CONTACT_ID = A_M_CONTACT.CONTACT_ID AND 
                      dbo.REQUESTS.PROJECT_ID = dbo.PROJECTS_V.PROJECT_ID LEFT OUTER JOIN
               
