/* $Id: 3_jobs_v.sql 1655 2009-08-05 21:24:48Z bvonhaden $ */

ALTER VIEW [dbo].[jobs_v]
AS
SELECT j.job_id, 
       j.project_id, 
       j.job_no, 
       j.job_name, 
       CAST(j.job_no AS varchar) + ' - ' + ISNULL(c.customer_name, '') + ' - ' + ISNULL(j.job_name, '') AS job_no_name, 
       j.job_type_id, 
       job_type.code AS job_type_code, 
       job_type.name AS job_type_name, 
       j.job_status_type_id, 
       job_status_type.code AS job_status_type_code, 
       job_status_type.name AS job_status_type_name, 
       job_status_type.sequence_no AS job_status_seq_no, 
       c.organization_id, 
       CASE WHEN customer_type.code = 'dealer' THEN c.customer_name ELSE c.dealer_name END dealer_name,
       CASE WHEN customer_type.code = 'dealer' THEN c.ext_customer_id ELSE c.ext_dealer_id END ext_dealer_id, 
       c.ext_customer_id, 
       j.ext_price_level_id, 
       j.foreman_resource_id, 
       r.name AS foreman_resource_name, 
       r.user_id AS foreman_user_id, 
       foreman_user.first_name + ' ' + foreman_user.last_name AS foreman_user_name, 
       j.billing_user_id, 
       j.a_m_sales_contact_id,
       j.watch_flag, 
       u_billing.first_name + ' ' + u_billing.last_name AS billing_user_name, 
       j.created_by, 
       created_by.first_name + ' ' + created_by.last_name AS created_by_name, 
       j.date_created, 
       j.modified_by, 
       modified_by.first_name + ' ' + modified_by.last_name AS modified_by_name, 
       j.date_modified,
       CASE WHEN customer_type.code = 'end_user' THEN c.end_user_parent_id ELSE c.customer_id END customer_id,
       CASE WHEN customer_type.code = 'end_user' THEN (SELECT customer_name FROM customers WHERE customer_id = c.end_user_parent_id) ELSE c.customer_name END customer_name,
       CASE WHEN customer_type.code = 'end_user' THEN c.customer_id ELSE eu.customer_id END end_user_id,
       CASE WHEN customer_type.code = 'end_user' THEN c.customer_name ELSE eu.customer_name END end_user_name,
       p.is_new
  FROM dbo.jobs j INNER JOIN
       dbo.customers c ON j.customer_id = c.customer_id INNER JOIN
       dbo.lookups customer_type ON c.customer_type_id = customer_type.lookup_id INNER JOIN
       dbo.lookups job_type ON j.job_type_id = job_type.lookup_id INNER JOIN 
       dbo.lookups job_status_type ON j.job_status_type_id = job_status_type.lookup_id INNER JOIN
       dbo.users created_by ON j.created_by = created_by.user_id LEFT OUTER JOIN
       dbo.users u_billing ON j.billing_user_id = u_billing.user_id LEFT OUTER JOIN
       dbo.users modified_by ON j.modified_by = modified_by.user_id LEFT OUTER JOIN
       dbo.resources r ON j.foreman_resource_id = r.resource_id LEFT OUTER JOIN
       dbo.users foreman_user ON r.user_id = foreman_user.user_id LEFT OUTER JOIN
       dbo.projects p ON j.project_id = p.project_id LEFT OUTER JOIN
       dbo.customers eu ON p.end_user_id = eu.customer_id
