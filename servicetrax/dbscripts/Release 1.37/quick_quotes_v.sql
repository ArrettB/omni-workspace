/* $Id: quick_quotes_v.sql 1655 2009-08-05 21:24:48Z bvonhaden $ */

ALTER VIEW [dbo].[quick_quotes_v]
AS
SELECT CONVERT(VARCHAR, p.project_no) + '-' + CONVERT(VARCHAR, r.request_no) + '.' + ISNULL(CONVERT(VARCHAR, q.version),' ') AS project_request_version_no,  
       r.request_id,  
       r.request_no, 
       p.project_id, 
       p.project_no, 
       c.organization_id, 
       p.job_name, 
       r.customer_po_no, 
       r.dealer_po_no, 
       r.dealer_project_no, 
       r.est_start_date, 
       r.description, 
       r.is_quoted, 
       r.date_created AS record_created, 
       r.date_modified AS record_last_modified,             
       c.parent_customer_id, 
       CASE WHEN customer_type.code = 'dealer' THEN ISNULL(c.ext_customer_id, c.ext_dealer_id) ELSE c.ext_dealer_id END ext_dealer_id,
       c.dealer_name, 
       CASE WHEN customer_type.code = 'end_user' THEN c.end_user_parent_id ELSE c.customer_id END customer_id,
       CASE WHEN customer_type.code = 'end_user' THEN (SELECT customer_name FROM customers WHERE customer_id=c.end_user_parent_id) ELSE c.customer_name END customer_name,
       CASE WHEN customer_type.code = 'end_user' THEN c.customer_id ELSE eu.customer_id END end_user_id,
       CASE WHEN customer_type.code = 'end_user' THEN c.customer_name ELSE eu.customer_name END end_user_name,
       request_status.code AS record_status_code, 
       request_status.name AS record_status_name, 
       request_type.code AS record_type_code, 
       request_type.name AS record_type_name, 
       request_type.sequence_no AS record_type_seq_no, 
       r.a_m_contact_id, 
       r.customer_contact_id, 
       r.alt_customer_contact_id, 
       r.d_sales_rep_contact_id, 
       r.d_sales_sup_contact_id, 
       r.d_proj_mgr_contact_id, 
       r.d_designer_contact_id, 
       quoted_by.first_name + '  ' + quoted_by.last_name AS quoted_by_name, 
       q.quote_id, 
       q.version,
       q.quote_total, 
       q.date_quoted, 
       quote_type.code AS quote_type_code, 
       quote_type.name AS quote_type_name,
       p.is_new
  FROM dbo.requests r INNER JOIN
       dbo.projects p ON r.project_id = p.project_id INNER JOIN
       dbo.customers c ON p.customer_id = c.customer_id INNER JOIN
       dbo.quotes q ON r.request_id = q.request_id INNER JOIN
       dbo.users quoted_by ON ISNULL(q.quoted_by_user_id,q.created_by) = quoted_by.user_id INNER JOIN
       dbo.lookups quote_type ON q.quote_type_id = quote_type.lookup_id INNER JOIN
       dbo.lookups request_type ON q.request_type_id = request_type.lookup_id INNER JOIN
       dbo.lookups request_status ON q.quote_status_type_id = request_status.lookup_id INNER JOIN
       dbo.lookups customer_type ON c.customer_type_id = customer_type.lookup_id LEFT OUTER JOIN
       dbo.customers eu ON p.end_user_id = eu.customer_id
 WHERE request_type.code = 'quote' 
   AND request_status.code = 'sent'
