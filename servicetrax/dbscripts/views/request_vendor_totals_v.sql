
CREATE VIEW request_vendor_totals_v
AS
SELECT TOP 100 PERCENT 
       cust.organization_id,
       r.project_id, 
       r.request_id,
       p.project_no,
       r.request_no,
       CONVERT(VARCHAR, p.project_no) + '-' + CONVERT(VARCHAR, r.request_no) AS workorder_no, 
       p.project_status_type_id,
       project_status.code AS project_status_type_code, 
       project_status.name AS project_status_type_name, 
       r.request_status_type_id,
       request_status_type.code AS request_status_type_code, 
       request_status_type.name AS request_status_type_name, 
       dbo.lookups_v.sequence_no AS approved_seq_no,
       request_status_type.sequence_no AS request_seq_no, 
       r.request_type_id,
       request_type.code AS request_type_code,
       request_type.name AS request_type_name,       
       CASE WHEN customer_type.code = 'dealer' THEN ISNULL(cust.ext_customer_id, cust.ext_dealer_id) ELSE cust.ext_dealer_id END ext_dealer_id, 
       CASE WHEN customer_type.code = 'end_user' THEN cust.end_user_parent_id ELSE cust.customer_id END customer_id,
       CASE WHEN customer_type.code = 'end_user' THEN (SELECT customer_name FROM customers WHERE customer_id=cust.end_user_parent_id) ELSE cust.customer_name END customer_name,
       CASE WHEN customer_type.code = 'end_user' THEN cust.customer_id ELSE eu.customer_id END end_user_id,
       CASE WHEN customer_type.code = 'end_user' THEN cust.customer_name ELSE eu.customer_name END end_user_name, 
       cust.dealer_name, 
       cust.parent_customer_id, 
       p.job_name,
       r.dealer_po_no, 
       r.customer_po_no, 
       priorities.name AS priority,
       SUM(rv.estimated_cost) AS sum_estimated_cost, 
       SUM(rv.total_cost) AS sum_total_cost,
       SUM(rv.visit_count) 
       AS sum_visit_count, 
       r.date_created,
       r.created_by,
       users_1.full_name AS created_by_name, 
       r.date_modified, 
       r.modified_by, 
       users_2.full_name AS modified_by_name,
       COUNT(rv.request_vendor_id) AS vendor_count,
       MIN(rv.act_start_date) AS min_act_start_date, 
       MIN(rv.sch_start_date) AS min_sch_start_date,
       MIN(r.est_start_date) AS min_est_start_date,
       MAX(rv.act_end_date) AS max_act_end_date, 
       MAX(rv.sch_end_date) AS max_sch_end_date,
       MAX(r.est_end_date) AS max_est_end_date,
       MIN(rv.invoice_date) AS min_invoice_date, 
       r.description, 
       (CASE WHEN COUNT(dbo.punchlists.punchlist_id) > 0 THEN 'y' ELSE 'n' END) AS punchlist_flag, 
       SUM((CASE WHEN rv.complete_flag = 'y' THEN 1 ELSE 0 END)) vendor_complete_count,
       SUM((CASE WHEN rv.invoiced_flag = 'y' THEN 1 ELSE 0 END)) invoiced_complete_count
  FROM dbo.requests r INNER JOIN
       dbo.lookups request_type ON r.request_type_id = request_type.lookup_id INNER JOIN
       dbo.lookups request_status_type ON r.request_status_type_id = request_status_type.lookup_id INNER JOIN
       dbo.users users_1 on r.created_by = users_1.user_id INNER JOIN
       dbo.projects p ON r.project_id = p.project_id INNER JOIN
       dbo.lookups project_status ON p.project_status_type_id = project_status.lookup_id INNER JOIN
       dbo.customers cust ON p.customer_id = cust.customer_id LEFT OUTER JOIN 
       dbo.customers eu ON p.customer_id = eu.customer_id LEFT OUTER JOIN 
       dbo.lookups customer_type ON cust.customer_type_id = customer_type.lookup_id LEFT OUTER JOIN 
       dbo.users users_2 ON r.modified_by = users_2.user_id LEFT OUTER JOIN 
       dbo.lookups priorities ON r.priority_type_id = priorities.lookup_id LEFT OUTER JOIN 
       dbo.punchlists ON r.request_id = dbo.punchlists.request_id LEFT OUTER JOIN 
       dbo.request_vendors rv ON r.request_id = rv.request_id LEFT OUTER JOIN 
       dbo.contacts c ON rv.vendor_contact_id = c.contact_id LEFT OUTER JOIN
       dbo.users u ON rv.vendor_contact_id = u.vendor_contact_id CROSS JOIN
       dbo.lookups_v
 WHERE (dbo.look
