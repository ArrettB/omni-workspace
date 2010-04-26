CREATE VIEW dbo.PUNCHLISTS_V
AS
SELECT     dbo.PUNCHLISTS.PUNCHLIST_ID, dbo.PUNCHLISTS.PROJECT_ID, dbo.PUNCHLISTS.request_id, CONVERT(varchar, dbo.PROJECTS.PROJECT_NO) 
                      + '-' + CONVERT(varchar, dbo.REQUESTS.REQUEST_NO) AS punchlist_no, dbo.REQUESTS.DESCRIPTION, 
                      dbo.REQUESTS.D_SALES_REP_CONTACT_ID, sales_rep.CONTACT_NAME AS d_sales_rep_contact_name, 
                      dbo.REQUESTS.D_SALES_SUP_CONTACT_ID, sales_support.CONTACT_NAME AS d_sales_sup_contact_name, 
                      dbo.REQUESTS.CUSTOMER_CONTACT_ID, customer.CONTACT_NAME AS customer_contact_name, dbo.REQUESTS.A_M_CONTACT_ID, 
                      am_contact.CONTACT_NAME AS a_m_contact_name, dbo.PUNCHLISTS.WALKTHROUGH_DATE, dbo.PUNCHLISTS.PRINT_LOCATION, 
                      dbo.PUNCHLISTS.CREATED_BY, dbo.PUNCHLISTS.DATE_CREATED, dbo.PUNCHLISTS.MODIFIED_BY, dbo.PUNCHLISTS.DATE_MODIFIED
FROM         dbo.PUNCHLISTS LEFT OUTER JOIN
                      dbo.REQUESTS INNER JOIN
                      dbo.PROJECTS ON dbo.REQUESTS.PROJECT_ID = dbo.PROJECTS.PROJECT_ID ON 
                      dbo.PUNCHLISTS.request_id = dbo.REQUESTS.REQUEST_ID LEFT OUTER JOIN
                      dbo.CONTACTS customer ON dbo.REQUESTS.CUSTOMER_CONTACT_ID = customer.CONTACT_ID LEFT OUTER JOIN
                      dbo.CONTACTS sales_rep ON dbo.REQUESTS.D_SALES_REP_CONTACT_ID = sales_rep.CONTACT_ID LEFT OUTER JOIN
                      dbo.CONTACTS sales_support ON dbo.REQUESTS.D_SALES_SUP_CONTACT_ID = sales_support.CONTACT_ID LEFT OUTER JOIN
                      dbo.CONTACTS am_contact ON dbo.REQUESTS.A_M_CONTACT_ID = am_contact.CONTACT_ID

