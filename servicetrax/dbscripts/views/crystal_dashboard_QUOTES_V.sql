CREATE VIEW dbo.crystal_dashboard_QUOTES_V
AS
SELECT     dbo.CUSTOMERS.ORGANIZATION_ID, dbo.QUOTES.QUOTE_ID, dbo.QUOTES.QUOTE_NO, CAST(dbo.PROJECTS.PROJECT_NO AS VARCHAR) 
                      + '-' + CAST(dbo.QUOTES.QUOTE_NO AS VARCHAR) AS project_quote_no, dbo.REQUESTS.PROJECT_ID, dbo.PROJECTS.PROJECT_NO, 
                      dbo.QUOTES.REQUEST_ID, dbo.QUOTES.REQUEST_TYPE_ID, REQUEST_TYPE.CODE AS request_type_code, 
                      REQUEST_TYPE.NAME AS request_type_name, dbo.CUSTOMERS.EXT_DEALER_ID, dbo.CUSTOMERS.CUSTOMER_NAME, dbo.PROJECTS.JOB_NAME,
                       dbo.QUOTES.IS_SENT, dbo.QUOTES.QUOTE_TYPE_ID, QUOTE_TYPE.CODE AS quote_type_code, QUOTE_TYPE.NAME AS quote_type_name, 
                      dbo.QUOTES.QUOTE_STATUS_TYPE_ID, QUOTE_STATUS_TYPE.CODE AS quote_status_type_code, 
                      QUOTE_STATUS_TYPE.NAME AS quote_status_type_name, dbo.QUOTES.QUOTED_BY_USER_ID, dbo.QUOTES.DATE_QUOTED, 
                      QUOTED_BY.FIRST_NAME + ' ' + QUOTED_BY.LAST_NAME AS quoted_by_user_name, dbo.QUOTES.DESCRIPTION, dbo.QUOTES.QUOTE_TOTAL, 
                      dbo.QUOTES.EXTRA_CONDITIONS, dbo.QUOTES.DATE_CREATED, dbo.QUOTES.CREATED_BY, dbo.QUOTES.DATE_MODIFIED, 
                      dbo.QUOTES.MODIFIED_BY, Quoted_by_contact.PHONE_WORK AS quoted_by_phone, Quoted_by_contact.CONTACT_NAME AS quoted_by_name, 
                      DEALER_SALES_REP_CONTACT.CONTACT_NAME AS sales_rep_contact_name, time_uom.NAME AS duration_name, dbo.REQUESTS.DURATION_QTY, 
                      dbo.QUOTES.WAREHOUSE_FEE_FLAG, REQUEST_TYPE.SEQUENCE_NO AS REQUEST_TYPE_SEQUENCE_NO, 
                      dbo.ORGANIZATIONS.EXT_DIRECT_DEALER_ID, dbo.QUOTES.TAXABLE_FLAG, dbo.QUOTES.TAXABLE_AMOUNT, 
                      dbo.ORGANIZATIONS.CODE AS ORG_CODE, dbo.ORGANIZATIONS.NAME AS ORG_NAME, dbo.CUSTOMERS.DEALER_NAME, 
                      dbo.REQUESTS.IS_QUOTED, dbo.REQUESTS.QUOTE_NEEDED_BY, dbo.REQUESTS.QUOTE_REQUEST_ID, 
                      dbo.REQUESTS.DATE_CREATED AS Request_Created_Date, dbo.REQUESTS.REQUEST_NO
FROM         dbo.CONTACTS Quoted_by_contact RIGHT OUTER JOIN
                      dbo.USERS QUOTED_BY ON Quoted_by_contact.CONTACT_ID = QUOTED_BY.CONTACT_ID RIGHT OUTER JOIN
                      dbo.LOOKUPS QUOTE_TYPE RIGHT OUTER JOIN
                      dbo.LOOKUPS QUOTE_STATUS_TYPE RIGHT OUTER JOIN
                      dbo.QUOTES LEFT OUTER JOIN
                      dbo.LOOKUPS REQUEST_TYPE ON dbo.QUOTES.REQUEST_TYPE_ID = REQUEST_TYPE.LOOKUP_ID ON 
                      QUOTE_STATUS_TYPE.LOOKUP_ID = dbo.QUOTES.QUOTE_STATUS_TYPE_ID ON QUOTE_TYPE.LOOKUP_ID = dbo.QUOTES.QUOTE_TYPE_ID ON 
                      QUOTED_BY.USER_ID = dbo.QUOTES.QUOTED_BY_USER_ID FULL OUTER JOIN
                      dbo.CUSTOMERS LEFT OUTER JOIN
                      dbo.ORGANIZATIONS ON dbo.CUSTOMERS.ORGANIZATION_ID = dbo.ORGANIZATIONS.ORGANIZATION_ID RIGHT OUTER JOIN
                      dbo.PROJECTS RIGHT OUTER JOIN
                      dbo.LOOKUPS time_uom RIGHT OUTER JOIN
                      dbo.CONTACTS DEALER_SALES_REP_CONTACT RIGHT OUTER JOIN
                      dbo.REQUESTS ON DEALER_SALES_REP_CONTACT.CONTACT_ID = dbo.REQUESTS.D_SALES_REP_CONTACT_ID ON 
                      time_uom.LOOKUP_ID = dbo.REQUESTS.DURATION_TIME_UOM_TYPE_ID ON dbo.PROJECTS.PROJECT_ID = dbo.REQUESTS.PROJECT_ID ON 
                      dbo.CUSTOMERS.CUSTOMER_ID = dbo.PROJECTS.CUSTOMER_ID ON dbo.QUOTES.REQUEST_ID = dbo.REQUESTS.REQUEST_ID

