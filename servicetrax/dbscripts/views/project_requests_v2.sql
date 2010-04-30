
CREATE VIEW project_requests_v2
AS
SELECT p_v.project_id, 
       p_v.project_no, 
       p_v.project_type_id, 
       p_v.project_type_code, 
       p_v.project_type_name, 
       p_v.project_status_type_id, 
       p_v.project_status_type_code, 
       p_v.project_status_type_name, 
       p_v.customer_id, 
       p_v.end_user_id,
       p_v.parent_customer_id, 
       p_v.organization_id, 
       p_v.ext_dealer_id, 
       p_v.dealer_name, 
       p_v.ext_customer_id, 
       p_v.customer_name, 
       p_v.end_user_name,
       p_v.job_name, 
       p_v.date_created, 
       p_v.created_by, 
       p_v.created_by_name,
       r.request_id, 
       r.request_no, 
       r.version_no, 
       r.request_type_id, 
       request_type.code AS request_type_code, 
       request_type.name AS request_type_name, 
       r.request_status_type_id, 
       request_status_type.code AS request_status_type_code, 
       request_status_type.name AS request_status_type_name, 
       CONVERT(VARCHAR(12), r.est_start_date, 101) AS est_start_date_varchar, 
       r.quote_request_id, 
       r.is_quoted, 
       r.csc_wo_field_flag,
       r.a_d_designer_contact_id,
       r.gen_contractor_contact_id, 
       r.electrician_contact_id,
       r.data_phone_contact_id,
       r.carpet_layer_contact_id, 
       r.bldg_mgr_contact_id,
       r.security_contact_id,
       r.mover_contact_id, 
       r.other_contact_id,
       r.furniture1_contact_id,
       r.furniture2_contact_id
  FROM dbo.projects_v2 p_v INNER JOIN
       dbo.requests r ON p_v.project_id = r.project_id INNER JOIN
       dbo.lookups request_type ON r.request_type_id = request_type.lookup_id INNER JOIN
       dbo.lookups request_status_type ON r.request_status_type_id = request_status_type.lookup_id
