
CREATE VIEW quick_request_vendors_v
AS
SELECT CONVERT(VARCHAR, p.project_no) + '-' + CONVERT(VARCHAR, r.request_no) AS project_request_no,
       r.request_id, 
       r.request_no, 
       p.project_id, 
       p.project_no, 
       c.organization_id, 
       p.job_name, 
       helper.min_sch_start_date, 
       helper.min_act_start_date, 
       helper.max_sch_start_date, 
       helper.max_act_end_date, 
       ISNULL(helper.vendor_count, 0) AS vendor_count, 
       ISNULL(helper.vendor_complete_count, 0) AS vendor_complete_count, 
       ISNULL(helper.vendor_invoiced_count, 0) AS vendor_invoiced_count, 
       r.customer_po_no, 
       r.dealer_po_no, 
       r.dealer_project_no, 
       r.est_start_date, 
       r.description, 
       r.is_quoted, 
       r.date_created AS record_created,  
       r.date_modified AS record_last_modified,     
       r.d_designer_contact_id, 
       r.d_proj_mgr_contact_id, 
       r.d_sales_sup_contact_id, 
       r.d_sales_rep_contact_id, 
       r.alt_customer_contact_id, 
       r.customer_contact_id, 
       r.a_m_contact_id,  
       CASE WHEN customer_type.code = 'end_user' THEN c.end_user_parent_id ELSE c.customer_id END customer_id,
       CASE WHEN customer_type.code = 'end_user' THEN (SELECT customer_name FROM customers WHERE customer_id=c.end_user_parent_id) ELSE c.customer_name END customer_name,
       CASE WHEN customer_type.code = 'end_user' THEN c.customer_id ELSE eu.customer_id END end_user_id,
       CASE WHEN customer_type.code = 'end_user' THEN c.customer_name ELSE eu.customer_name END end_user_name,
       c.parent_customer_id, 
       CASE WHEN customer_type.code = 'dealer' THEN ISNULL(c.ext_customer_id, c.ext_dealer_id) ELSE c.ext_dealer_id END ext_dealer_id, 
       c.dealer_name, 
       request_type.code AS record_type_code, 
       request_type.name AS record_type_name, 
       request_type.sequence_no AS record_type_seq_no, 
       request_status.code AS record_status_code, 
       request_status.name AS record_status_name, 
       request_status.sequence_no AS record_status_seq_no, 
       project_status.code AS project_status_code, 
       project_status.name AS project_status_name
  FROM dbo.requests r INNER JOIN
       dbo.lookups request_status ON r.request_status_type_id = request_status.lookup_id INNER JOIN
       dbo.lookups request_type ON r.request_type_id = request_type.lookup_id INNER JOIN
       dbo.projects p ON r.project_id = p.project_id INNER JOIN
       dbo.lookups project_status ON p.project_status_type_id = project_status.lookup_id INNER JOIN
       dbo.customers c ON p.customer_id = c.customer_id INNER JOIN
       dbo.lookups customer_type ON c.customer_type_id = customer_type.lookup_id LEFT OUTER JOIN
       dbo.customers eu ON p.end_user_id = eu.customer_id LEFT OUTER JOIN
       dbo.QUICK_REQUEST_VENDORS_HELPER_V helper ON r.request_id = helper.request_id
 WHERE request_type.code='workorder' 
   AND request_status.code <> 'closed'

