DROP  VIEW extranet_email_none_quote_v
GO

CREATE VIEW extranet_email_none_quote_v
AS
SELECT CONVERT(VARCHAR(20), GETDATE(), 113) AS todays_date, 
       cust.customer_name,
       p.job_name, 
       p.project_no, 
       CONVERT(VARCHAR, p.project_no) + '-' + CONVERT(VARCHAR, r.request_no) + '.' + CONVERT(VARCHAR, r.version_no) AS record_no, 
       r.request_id record_id, 
       request_type.code AS record_type_code, 
       request_type.name AS record_type_name,
       request_status_type.code AS record_status_type_code,      
       r.a_m_contact_id,  
       r.a_m_sales_contact_id, 
       r.customer_contact_id, 
       r.customer_contact2_id, 
       r.customer_contact3_id, 
       r.customer_contact4_id, 
       r.d_sales_rep_contact_id, 
       r.d_sales_sup_contact_id, 
       r.d_proj_mgr_contact_id, 
       r.d_designer_contact_id, 
       r.a_m_install_sup_contact_id,
       r.description, 
       r.furniture1_contact_id, 
       r.furniture2_contact_id, 
       r.approver_contact_id, 
       r.alt_customer_contact_id,
       r.a_d_designer_contact_id, 
       r.gen_contractor_contact_id, 
       r.electrician_contact_id, 
       r.data_phone_contact_id, 
       r.carpet_layer_contact_id, 
       r.bldg_mgr_contact_id, 
       r.security_contact_id, 
       r.mover_contact_id, 
       r.phone_contact_id, 
       r.other_contact_id,
       cust.refusal_email_info, 
       cust.survey_location,
       o.scheduler_contact_id,
       customer_contact.contact_name AS customer_contact_name, 
       approver_contact.contact_name AS approver_contact_name, 
       phone_contact.contact_name AS phone_contact_name,
       CASE WHEN p.end_user_id IS NULL THEN 'N' ELSE 'Y' END is_new
  FROM dbo.requests r INNER JOIN 
       dbo.lookups request_type ON r.request_type_id = request_type.lookup_id INNER JOIN
       dbo.lookups request_status_type ON r.request_status_type_id = request_status_type.lookup_id INNER JOIN
       dbo.projects p ON r.project_id = p.project_id INNER JOIN
       dbo.customers cust ON p.customer_id = cust.customer_id INNER JOIN
       dbo.organizations o ON cust.organization_id = o.organization_id LEFT OUTER JOIN
       dbo.contacts approver_contact ON r.approver_contact_id = approver_contact.contact_id  LEFT OUTER JOIN
       dbo.contacts customer_contact ON r.customer_contact_id = customer_contact.contact_id LEFT OUTER JOIN
       dbo.contacts phone_contact ON r.phone_contact_id = phone_contact.contact_id
GO