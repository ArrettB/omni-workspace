
CREATE VIEW request_mail_v2
AS
SELECT p.project_id, 
       r.request_id, 
       p.project_no, 
       r.request_no, 
       l.code request_type_code, 
       r.a_m_contact_id, 
       r.a_m_sales_contact_id, 
       r.customer_contact_id,
       r.customer_contact2_id,
       r.customer_contact3_id,
       r.customer_contact4_id,
       ISNULL(am.contact_name, 'N/A') AS am_name,
       ISNULL(am_sales.contact_name, 'N/A') AS am_sales_name,
       ISNULL(cc.contact_name, 'N/A') AS customer_contact_name,
       ISNULL(cc2.contact_name, 'N/A') AS customer_contact2_name,
       ISNULL(cc3.contact_name, 'N/A') AS customer_contact3_name,
       ISNULL(cc4.contact_name, 'N/A') AS customer_contact4_name
  FROM requests r INNER JOIN 
       projects p ON r.project_id = p.project_id INNER JOIN
       lookups l ON r.request_type_id = l.lookup_id LEFT OUTER JOIN
       dbo.contacts am ON r.a_m_contact_id = am.contact_id LEFT OUTER JOIN
       dbo.contacts am_sales ON r.a_m_sales_contact_id = am_sales.contact_id LEFT OUTER JOIN
       dbo.contacts cc ON r.customer_contact_id = cc.contact_id LEFT OUTER JOIN
       dbo.contacts cc2 ON r.customer_contact2_id = cc2.contact_id LEFT OUTER JOIN
       dbo.contacts cc3 ON r.customer_contact3_id = cc3.contact_id LEFT OUTER JOIN
       dbo.contacts cc4 ON r.customer_contact4_id = cc4.contact_id 

