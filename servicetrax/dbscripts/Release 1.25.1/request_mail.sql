IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS
      WHERE TABLE_NAME = 'REQUEST_MAIL_V')
   DROP VIEW REQUEST_MAIL_V
GO

CREATE VIEW dbo.REQUEST_MAIL_V
AS
SELECT dbo.PROJECTS_ALL_REQUESTS_V.record_id
, dbo.PROJECTS_ALL_REQUESTS_V.record_type_code
, ISNULL(sales.CONTACT_NAME, 'N/A') AS sales_name
, ISNULL(sales_sup.CONTACT_NAME, 'N/A') AS sales_sup_name
, ISNULL(designer.CONTACT_NAME, 'N/A') AS designer_name
, ISNULL(proj_mgr.CONTACT_NAME, 'N/A') AS proj_mgr_name
, ISNULL(am.CONTACT_NAME, 'N/A') AS am_name
FROM  dbo.CONTACTS proj_mgr RIGHT OUTER JOIN  
                      dbo.PROJECTS_ALL_REQUESTS_V LEFT OUTER JOIN  
                      dbo.CONTACTS am ON dbo.PROJECTS_ALL_REQUESTS_V.a_m_contact_id = am.CONTACT_ID LEFT OUTER JOIN  
                      dbo.CONTACTS designer ON dbo.PROJECTS_ALL_REQUESTS_V.d_designer_contact_id = designer.CONTACT_ID ON   
                      proj_mgr.CONTACT_ID = dbo.PROJECTS_ALL_REQUESTS_V.d_proj_mgr_contact_id LEFT OUTER JOIN  
                      dbo.CONTACTS sales_sup ON dbo.PROJECTS_ALL_REQUESTS_V.d_sales_sup_contact_id = sales_sup.CONTACT_ID
                      LEFT OUTER JOIN dbo.CONTACTS sales ON dbo.PROJECTS_ALL_REQUESTS_V.d_sales_rep_contact_id = sales.CONTACT_ID  
go
