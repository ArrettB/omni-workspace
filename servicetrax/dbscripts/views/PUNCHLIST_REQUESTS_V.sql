CREATE VIEW dbo.PUNCHLIST_REQUESTS_V
AS
SELECT     dbo.PUNCHLISTS.PUNCHLIST_ID, dbo.PROJECTS.PROJECT_ID, dbo.REQUESTS.REQUEST_ID, CONVERT(varchar, dbo.PROJECTS.PROJECT_NO) 
                      + '-' + CONVERT(varchar, dbo.REQUESTS.REQUEST_NO) AS project_request_no, dbo.PROJECTS.PROJECT_NO, dbo.REQUESTS.REQUEST_NO, 
                      dbo.REQUESTS.DESCRIPTION, dbo.REQUESTS.D_SALES_REP_CONTACT_ID, sales_rep.CONTACT_NAME AS d_sales_rep_contact_name, 
                      dbo.REQUESTS.D_SALES_SUP_CONTACT_ID, sales_support.CONTACT_NAME AS d_sales_sup_contact_name, 
                      dbo.REQUESTS.CUSTOMER_CONTACT_ID, customer.CONTACT_NAME AS customer_contact_name, dbo.REQUESTS.A_M_CONTACT_ID, 
                      am_contact.CONTACT_NAME AS a_m_contact_name, dbo.LOOKUPS.CODE
FROM         dbo.PUNCHLISTS RIGHT OUTER JOIN
                      dbo.REQUESTS ON dbo.PUNCHLISTS.REQUEST_ID = dbo.REQUESTS.REQUEST_ID LEFT OUTER JOIN
                      dbo.PROJECTS ON dbo.REQUESTS.PROJECT_ID = dbo.PROJECTS.PROJECT_ID LEFT OUTER JOIN
                      dbo.LOOKUPS ON dbo.REQUESTS.REQUEST_TYPE_ID = dbo.LOOKUPS.LOOKUP_ID LEFT OUTER JOIN
                      dbo.CONTACTS customer ON dbo.REQUESTS.CUSTOMER_CONTACT_ID = customer.CONTACT_ID LEFT OUTER JOIN
                      dbo.CONTACTS sales_rep ON dbo.REQUESTS.D_SALES_REP_CONTACT_ID = sales_rep.CONTACT_ID LEFT OUTER JOIN
                      dbo.CONTACTS sales_support ON dbo.REQUESTS.D_SALES_SUP_CONTACT_ID = sales_support.CONTACT_ID LEFT OUTER JOIN
                      dbo.CONTACTS am_contact ON dbo.REQUESTS.A_M_CONTACT_ID = am_contact.CONTACT_ID
WHERE     (dbo.LOOKUPS.CODE = 'service_request') OR
                      (dbo.LOOKUPS.CODE = 'workorder')


