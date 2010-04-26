DROP VIEW project_requests_v2
GO

CREATE VIEW project_requests_v2
AS
SELECT p.project_id, 
       p.project_no, 
       p.project_type_id, 
       project_types.code project_type_code, 
       project_types.name project_type_name, 
       p.project_status_type_id, 
       project_status_type.code project_status_type_code, 
       project_status_type.name project_status_type_name, 
       c.parent_customer_id, 
       c.organization_id, 
       c.dealer_name, 
       c.ext_customer_id, 
       p.job_name, 
       p.date_created, 
       p.created_by, 
       u.first_name + ' ' + u.last_name created_by_name,
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
       r.furniture2_contact_id,
       CASE WHEN customer_type.code = 'dealer' THEN ISNULL(c.ext_customer_id, c.ext_dealer_id) ELSE c.ext_dealer_id END ext_dealer_id,
       CASE WHEN customer_type.code = 'end_user' THEN c.end_user_parent_id ELSE p.customer_id END customer_id,
       CASE WHEN customer_type.code = 'end_user' THEN (SELECT customer_name FROM customers WHERE customer_id = c.end_user_parent_id) ELSE c.customer_name END customer_name,
       CASE WHEN customer_type.code = 'end_user' THEN c.customer_id ELSE p.end_user_id END end_user_id,
       CASE WHEN customer_type.code = 'end_user' THEN c.customer_name ELSE eu.customer_name END end_user_name,
       CASE WHEN p.end_user_id IS NULL THEN 'N' ELSE 'Y' END is_new
  FROM dbo.projects p INNER JOIN
       dbo.lookups project_types ON p.project_type_id = project_types.lookup_id INNER JOIN 
       dbo.lookups project_status_type ON p.project_status_type_id = project_status_type.lookup_id INNER JOIN 
       dbo.users u ON p.created_by = u.user_id INNER JOIN
       dbo.customers c ON p.customer_id = c.customer_id INNER JOIN
       dbo.lookups customer_type ON c.customer_type_id = customer_type.lookup_id LEFT OUTER JOIN
       dbo.customers eu ON p.end_user_id = eu.customer_id INNER JOIN
       dbo.requests r ON p.project_id = r.project_id INNER JOIN
       dbo.lookups request_type ON r.request_type_id = request_type.lookup_id INNER JOIN
       dbo.lookups request_status_type ON r.request_status_type_id = request_status_type.lookup_id
GO