
CREATE VIEW extranet_email_v
AS
SELECT CONVERT(VARCHAR(20), GETDATE(), 113) AS todays_date, 
       par_v.customer_name, 
       par_v.job_name, 
       par_v.project_no, 
       par_v.record_no, 
       par_v.record_id, 
       par_v.record_type_code, 
       par_v.record_type_name, 
       par_v.record_status_type_code,       
       par_v.a_m_contact_id,  
       par_v.a_m_sales_contact_id, 
       par_v.customer_contact_id, 
       par_v.customer_contact2_id, 
       par_v.customer_contact3_id, 
       par_v.customer_contact4_id, 
       par_v.d_sales_rep_contact_id, 
       par_v.d_sales_sup_contact_id, 
       par_v.d_proj_mgr_contact_id, 
       par_v.d_designer_contact_id, 
       par_v.a_m_install_sup_contact_id,
       par_v.description, 
       par_v.furniture1_contact_id, 
       par_v.furniture2_contact_id, 
       par_v.approver_contact_id, 
       par_v.alt_customer_contact_id,
       par_v.a_d_designer_contact_id, 
       par_v.gen_contractor_contact_id, 
       par_v.electrician_contact_id, 
       par_v.data_phone_contact_id, 
       par_v.carpet_layer_contact_id, 
       par_v.bldg_mgr_contact_id, 
       par_v.security_contact_id, 
       par_v.mover_contact_id, 
       par_v.phone_contact_id, 
       par_v.other_contact_id,
       par_v.refusal_email_info, 
       par_v.survey_location,
       o.scheduler_contact_id,
       customer_contact.contact_name AS customer_contact_name, 
       approver_contact.contact_name AS approver_contact_name, 
       phone_contact.contact_name AS phone_contact_name
  FROM dbo.projects_all_requests_v par_v LEFT OUTER JOIN
       dbo.organizations o ON par_v.organization_id = o.organization_id LEFT OUTER JOIN
       dbo.contacts approver_contact ON par_v.approver_contact_id = approver_contact.contact_id  LEFT OUTER JOIN
       dbo.contacts customer_contact ON par_v.customer_contact_id = customer_contact.contact_id LEFT OUTER JOIN
       dbo.contacts phone_contact ON par_v.phone_contact_id = phone_contact.contact_id

