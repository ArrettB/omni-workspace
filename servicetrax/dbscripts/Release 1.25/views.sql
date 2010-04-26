DROP VIEW quick_project_v
GO

CREATE VIEW quick_project_v
AS
SELECT p.project_id, 
       p.project_no, 
       p.job_name, 
       c.organization_id, 
       c.customer_id, 
       c.parent_customer_id, 
       c.customer_name, 
       CASE WHEN customer_type.code = 'dealer' THEN ISNULL(c.ext_customer_id, c.ext_dealer_id) ELSE c.ext_dealer_id END ext_dealer_id, 
       c.dealer_name, 
       project_status.
       code AS project_status_code, 
       project_status.name AS project_status_name, 
       p.date_created, 
       p.created_by
  FROM dbo.projects p INNER JOIN
       dbo.lookups project_status ON p.project_status_type_id = project_status.lookup_id INNER JOIN
       dbo.customers c ON p.customer_id = c.customer_id INNER JOIN
       dbo.lookups customer_type ON c.customer_type_id = customer_type.lookup_id
GO

DROP VIEW jobs_v
GO

CREATE VIEW jobs_v
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
       CASE WHEN p.end_user_id IS NULL THEN 'N' ELSE 'Y' END is_new
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
GO

DROP VIEW billing_v
GO

CREATE VIEW billing_v
AS
SELECT sl.organization_id, 
       sl.service_line_id, 
       CAST(sl.bill_job_id AS VARCHAR) + '-' + CAST(sl.item_id AS VARCHAR) + '-' + CAST(sl.status_id AS VARCHAR) AS job_item_status_id, 
       CAST(sl.bill_service_id AS VARCHAR) + '-' + CAST(sl.item_id AS VARCHAR) + '-' + CAST(sl.status_id AS VARCHAR) AS service_item_status_id, 
       CAST(sl.bill_service_id AS VARCHAR) + '-' + CAST(sl.status_id AS VARCHAR) AS bill_service_status_id,
       sl.bill_job_no, 
       sl.bill_service_no, 
       sl.bill_service_line_no, 
       j_v.job_status_type_name, 
       sl.service_line_date, 
       sl.service_line_date_VARCHAR, 
       sl.service_line_week, 
       sl.service_line_week_VARCHAR, 
       sl.status_id, 
       sls.name AS status_name, 
       sl.exported_flag, 
       sl.billed_flag, 
       sl.posted_flag, 
       sl.pooled_flag, 
       sl.internal_req_flag,
       sl.bill_job_id, 
       sl.bill_service_id,
       sl.ph_service_id,
       sl.resource_id, 
       sl.resource_name,
       sl.item_id,
       sl.item_name,
       sl.item_type_code, 
       sl.invoice_id,
       i.description AS invoice_description, 
       sl.posted_from_invoice_id, 
       ist.status_id AS invoice_status_id,
       ist.name AS invoice_status_name, 
       sl.billable_flag, 
       s.taxable_flag AS service_taxable_flag,
       sl.taxable_flag, 
       sl.ext_pay_code,
       sl.tc_qty,
       sl.payroll_qty,
       sl.bill_qty, 
       sl.bill_rate, 
       sl.bill_total, 
       sl.bill_exp_qty, 
       sl.bill_exp_rate, 
       sl.bill_exp_total,
       sl.bill_hourly_qty,
       sl.bill_hourly_rate, 
       sl.bill_hourly_total,
       s.quote_total,
       s.quote_id,
       j_v.job_name, 
       j_v.billing_user_name,
       j_v.dealer_name,
       j_v.ext_dealer_id,
       j_v.customer_name, 
       j_v.ext_customer_id,
       j_v.billing_user_id,
       j_v.foreman_resource_name AS supervisor_name, 
       j_v.foreman_user_id AS sup_user_id,
       s.billing_type_id,
       billing_types.code AS billing_type_code, 
       billing_types.name AS billing_type_name,
       s.po_no,
       s.cust_col_1,
       s.cust_col_2, 
       s.cust_col_3,
       s.cust_col_4,
       s.cust_col_5,
       s.cust_col_6, 
       s.cust_col_7, 
       s.cust_col_8,
       s.cust_col_9,
       s.cust_col_10, 
       s.est_start_date, 
       s.est_end_date,
       sl.palm_rep_id, 
       s.description AS service_description, 
       CAST(j_v.job_no AS VARCHAR) + ' - ' + ISNULL(j_v.job_name, '') AS job_no_name2, 
       CAST(s.service_no AS VARCHAR) + ' - ' + ISNULL(s.description, '') AS service_no_description2, 
       sl.entered_date, 
       sl.entered_by, 
       sl.entry_method, 
       sl.override_date, 
       sl.override_by, 
       sl.override_reason, 
       sl.verified_date, 
       sl.verified_by, 
       sl.date_created, 
       sl.created_by, 
       sl.date_modified, 
       sl.modified_by, 
       ISNULL(sl.invoice_post_date, i.date_sent) AS invoiced_date, 
       sl.invoice_post_date,
       ISNULL(q.quote_total, 0) quoted_total,
       CASE WHEN p.end_user_id IS NULL THEN 'N' ELSE 'Y' END is_new
  FROM dbo.service_lines sl LEFT OUTER JOIN 
       dbo.services s ON sl.bill_service_id = s.service_id LEFT OUTER JOIN
       dbo.jobs_v j_v ON sl.bill_job_id = j_v.job_id LEFT OUTER JOIN
       dbo.invoices i ON sl.invoice_id = i.invoice_id LEFT OUTER JOIN
       dbo.invoice_statuses ist ON i.status_id = ist.status_id LEFT OUTER JOIN
       dbo.lookups billing_types on s.billing_type_id = billing_types.lookup_id LEFT OUTER JOIN
       dbo.service_line_statuses sls ON sl.status_id = sls.status_id LEFT OUTER JOIN
       dbo.quotes q ON s.quote_id = q.quote_id LEFT OUTER JOIN
       dbo.projects p ON j_v.project_id = p.project_id
 WHERE sl.status_id > 3
   AND sl.internal_req_flag = 'N'
GO
   
DROP VIEW quotes_v
GO

CREATE VIEW quotes_v
AS
SELECT c.organization_id, 
       q.quote_id,
       q.quote_no, 
       CAST(p.project_no AS VARCHAR) + '-' + CAST(q.quote_no AS VARCHAR) AS project_quote_no, 
       r.project_id, 
       p.project_no, 
       q.request_id, 
       q.request_type_id, 
       request_type.code AS request_type_code, 
       request_type.name AS request_type_name, 
       c.ext_dealer_id, 
       c.customer_name, 
       p.job_name,
       q.is_sent, 
       q.quote_type_id, 
       quote_type.code AS quote_type_code, 
       quote_type.name AS quote_type_name, 
       q.quote_status_type_id, 
       quote_status_type.code AS quote_status_type_code, 
       quote_status_type.name AS quote_status_type_name, 
       q.quoted_by_user_id, 
       q.date_quoted, 
       quoted_by.first_name + ' ' + quoted_by.last_name AS quoted_by_user_name, 
       q.description, 
       q.quote_total, 
       q.extra_conditions, 
       q.date_created, 
       q.created_by, 
       q.date_modified, 
       q.modified_by, 
       quoted_by_contact.phone_work AS quoted_by_phone, 
       quoted_by_contact.contact_name AS quoted_by_name, 
       dealer_sales_rep_contact.contact_name AS sales_rep_contact_name, 
       time_uom.name AS duration_name, 
       r.duration_qty, 
       q.warehouse_fee_flag, 
       request_type.sequence_no AS request_type_sequence_no, 
       o.ext_direct_dealer_id, 
       q.taxable_flag, 
       q.taxable_amount,
       q.version
  FROM dbo.customers c LEFT OUTER JOIN
       dbo.organizations o ON c.organization_id = o.organization_id RIGHT OUTER JOIN
       dbo.projects p RIGHT OUTER JOIN
       dbo.contacts quoted_by_contact RIGHT OUTER JOIN
       dbo.users quoted_by ON quoted_by_contact.contact_id = quoted_by.contact_id RIGHT OUTER JOIN
       dbo.lookups quote_type RIGHT OUTER JOIN
       dbo.lookups quote_status_type RIGHT OUTER JOIN
       dbo.quotes q LEFT OUTER JOIN
       dbo.lookups request_type ON q.request_type_id = request_type.lookup_id 
                                ON quote_status_type.lookup_id = q.quote_status_type_id 
                                ON quote_type.lookup_id = q.quote_type_id 
                                ON quoted_by.user_id = q.quoted_by_user_id LEFT OUTER JOIN
       dbo.lookups time_uom RIGHT OUTER JOIN
       dbo.contacts dealer_sales_rep_contact RIGHT OUTER JOIN
       dbo.requests r ON dealer_sales_rep_contact.contact_id = r.d_sales_rep_contact_id 
		      ON time_uom.lookup_id = r.duration_time_uom_type_id 
		      ON q.request_id = r.request_id 
		      ON p.project_id = r.project_id 
		      ON c.customer_id = p.customer_id
GO

DROP VIEW projects_v
GO

CREATE VIEW projects_v
AS
SELECT top 100 percent p.project_id, 
       p.project_no, 
       p.project_type_id, 
       project_type.code AS project_type_code, 
       project_type.name AS project_type_name, 
       p.project_status_type_id, 
       project_status_type.code AS project_status_type_code, 
       project_status_type.name AS project_status_type_name, 
       c.organization_id, 
       p.customer_id, 
       c.parent_customer_id, 
       c.ext_dealer_id, 
       c.dealer_name, 
       c.ext_customer_id, 
       c.customer_name, 
       p.job_name, 
       p.percent_complete, 
       p.date_created, 
       p.created_by, 
       p.date_modified, 
       p.modified_by, 
       u.first_name + ' ' + u.last_name AS created_by_name,
       p.end_user_id,
       eu.customer_name end_user_name,
       eu.ext_customer_id ext_end_user_id,
       CASE WHEN p.end_user_id IS NULL THEN 'N' ELSE 'Y' END is_new
  FROM dbo.projects p INNER JOIN
       dbo.lookups project_type ON p.project_type_id  = project_type.lookup_id INNER JOIN
       dbo.lookups project_status_type ON p.project_status_type_id = project_status_type.lookup_id INNER JOIN
       dbo.customers c ON p.customer_id = c.customer_id INNER JOIN
       dbo.users u ON p.created_by = u.user_id LEFT OUTER JOIN
       dbo.customers eu ON p.end_user_id = eu.customer_id 
ORDER BY p.project_id
GO

CREATE VIEW projects_v2
AS
SELECT TOP 100 PERCENT 
        p.project_id, 
        p.project_no, 
        p.project_type_id, 
        project_types.code AS project_type_code, 
        project_types.name AS project_type_name, 
        p.project_status_type_id, 
        project_status_type.code AS project_status_type_code, 
        project_status_type.name AS project_status_type_name, 
        p.job_name, 
        p.percent_complete, 
        p.date_created, 
        p.created_by, 
        p.date_modified, 
        p.modified_by, 
        u.first_name + ' ' + u.last_name AS created_by_name,
        c.organization_id,  
        c.parent_customer_id, 
        CASE WHEN customer_type.code = 'dealer' THEN ISNULL(c.ext_customer_id, c.ext_dealer_id) ELSE c.ext_dealer_id END ext_dealer_id, 
        c.dealer_name, 
        c.ext_customer_id, 
        CASE WHEN customer_type.code = 'end_user' THEN c.end_user_parent_id ELSE p.customer_id END customer_id,
        CASE WHEN customer_type.code = 'end_user' THEN (SELECT customer_name FROM customers WHERE customer_id = c.end_user_parent_id) ELSE c.customer_name END customer_name,
        CASE WHEN customer_type.code = 'end_user' THEN c.customer_id ELSE p.end_user_id END end_user_id,
        CASE WHEN customer_type.code = 'end_user' THEN c.customer_name ELSE eu.customer_name END end_user_name,
        CASE WHEN p.end_user_id IS NULL THEN 'N' ELSE 'Y' END is_new,
        c.refusal_email_info, 
        c.survey_location
   FROM dbo.projects p INNER JOIN
        dbo.lookups project_types ON p.project_type_id = project_types.lookup_id INNER JOIN 
        dbo.lookups project_status_type ON p.project_status_type_id = project_status_type.lookup_id INNER JOIN 
        dbo.users u ON p.created_by = u.user_id INNER JOIN
        dbo.customers c ON p.customer_id = c.customer_id INNER JOIN
        dbo.lookups customer_type ON c.customer_type_id = customer_type.lookup_id LEFT OUTER JOIN
        dbo.customers eu ON p.end_user_id = eu.customer_id 
ORDER BY p.project_id
GO

CREATE VIEW quick_quote_requests_v2
AS
SELECT CONVERT(VARCHAR, p.project_no) + '-' + CONVERT(VARCHAR, r.request_no) + '.' + CONVERT(VARCHAR, r.version_no) AS project_request_version_no, 
       r.request_id, 
       r.request_no, 
       p.project_id, 
       p.project_no, 
       cust.organization_id, 
       cust.customer_id,
       p.job_name,
       r.dealer_po_no,        
       r.date_created AS record_created, 
       r.date_modified AS record_last_modified,        
       CASE WHEN customer_type.code = 'dealer' THEN ISNULL(cust.ext_customer_id, cust.ext_dealer_id) ELSE cust.ext_dealer_id END ext_dealer_id,  
       CASE WHEN customer_type.code = 'end_user' THEN (SELECT customer_name FROM customers WHERE customer_id=cust.end_user_parent_id) ELSE cust.customer_name END customer_name,
       CASE WHEN customer_type.code = 'end_user' THEN cust.customer_name ELSE eu.customer_name END end_user_name,
       request_status.code AS record_status_code, 
       request_status.name AS record_status_name, 
       request_type.code AS record_type_code, 
       request_type.name AS record_type_name, 
       request_type.sequence_no AS record_type_seq_no, 
       c.contact_name AS a_m_contact_name, 
       r.is_quoted, 
       CASE WHEN EXISTS (SELECT request_id
                           FROM requests
                          WHERE quote_request_id = r.request_id) THEN 'Y' ELSE 'N' END AS has_service_request,
       CASE WHEN p.end_user_id IS NULL THEN 'N' ELSE 'Y' END is_new
  FROM dbo.requests r INNER JOIN
       dbo.lookups request_status ON r.request_status_type_id = request_status.lookup_id INNER JOIN
       dbo.lookups request_type ON r.request_type_id = request_type.lookup_id INNER JOIN
       dbo.projects p ON r.project_id = p.project_id INNER JOIN
       dbo.customers cust ON p.customer_id = cust.customer_id INNER JOIN
       dbo.lookups customer_type ON cust.customer_type_id = customer_type.lookup_id LEFT OUTER JOIN
       dbo.customers eu ON p.end_user_id = eu.customer_id LEFT OUTER JOIN
       dbo.contacts c ON r.a_m_contact_id = c.contact_id
 WHERE request_type.code='quote_request' 
   AND request_status.code <> 'closed'
GO

DROP VIEW quick_quotes_v
GO

CREATE VIEW quick_quotes_v
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
       c.customer_id, 
       c.parent_customer_id, 
       CASE WHEN customer_type.code = 'dealer' THEN ISNULL(c.ext_customer_id, c.ext_dealer_id) ELSE c.ext_dealer_id END ext_dealer_id,
       CASE WHEN customer_type.code = 'end_user' THEN (SELECT customer_name FROM customers WHERE customer_id=c.end_user_parent_id) ELSE c.customer_name END customer_name, 
       c.dealer_name, 
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
       CASE WHEN customer_type.code = 'end_user' THEN c.customer_name ELSE eu.customer_name END end_user_name,
       CASE WHEN p.end_user_id IS NULL THEN 'N' ELSE 'Y' END is_new
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
 WHERE request_type.code='quote' 
   AND request_status.code <> 'closed'
GO

DROP VIEW quick_request_vendors_v
GO

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
       c.customer_id, 
       c.customer_name, 
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
       dbo.QUICK_REQUEST_VENDORS_HELPER_V helper ON r.request_id = helper.request_id
 WHERE request_type.code='workorder' 
   AND request_status.code <> 'closed'
GO

CREATE VIEW quick_requests_v2
AS
SELECT CONVERT(VARCHAR, p.project_no) + '-' + CONVERT(VARCHAR, r.request_no) + '.' + CONVERT(VARCHAR, r.version_no) AS project_request_version_no, 
       r.request_id, 
       r.request_no,
       p.project_id, 
       p.project_no, 
       c.organization_id,
       p.job_name,        
       r.dealer_po_no, 
       r.est_start_date, 
       r.description, 
       CASE WHEN customer_type.code = 'dealer' THEN ISNULL(c.ext_customer_id, c.ext_dealer_id) ELSE c.ext_dealer_id END ext_dealer_id, 
       CASE WHEN customer_type.code = 'end_user' THEN c.end_user_parent_id ELSE p.customer_id END customer_id,
       CASE WHEN customer_type.code = 'end_user' THEN (SELECT customer_name FROM customers WHERE customer_id=c.end_user_parent_id) ELSE c.customer_name END customer_name,
       CASE WHEN customer_type.code = 'end_user' THEN p.customer_id ELSE p.end_user_id END end_user_id,
       CASE WHEN customer_type.code = 'end_user' THEN c.customer_name ELSE eu.customer_name END end_user_name, 
       request_status.code AS record_status_code, 
       request_status.name AS record_status_name, 
       request_type.code AS record_type_code, 
       request_type.name AS record_type_name, 
       project_status.code AS project_status_code, 
       project_status.name AS project_status_name,
       r.is_quoted, 
       CASE WHEN p.end_user_id IS NULL THEN 'N' ELSE 'Y' END is_new
  FROM dbo.requests r INNER JOIN
       dbo.lookups request_status ON r.request_status_type_id = request_status.lookup_id INNER JOIN
       dbo.lookups request_type ON r.request_type_id = request_type.lookup_id INNER JOIN
       dbo.projects p ON r.project_id = p.project_id INNER JOIN
       dbo.customers c ON p.customer_id = c.customer_id INNER JOIN
       dbo.lookups project_status ON p.project_status_type_id = project_status.lookup_id INNER JOIN
       dbo.lookups customer_type ON c.customer_type_id = customer_type.lookup_id LEFT OUTER JOIN
       dbo.customers eu ON p.end_user_id = eu.customer_id 
 WHERE request_type.code = 'service_request'
   AND request_status.code <> 'closed'
GO

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
GO

CREATE VIEW sch_job_list_v 
AS
SELECT CAST(j.job_id AS varchar(30)) + ':' + ISNULL(CAST(s.service_id AS varchar(30)), '') AS job_service_id,
       j.job_id,
       j.job_no,
       j.job_name,
       s.service_id,
       s.service_no, 
       c.organization_id,     
       c.ext_dealer_id,
       c.dealer_name,
       j.customer_id,
       c.customer_name,
       j.job_type_id,
       job_type.code job_type_code,
       substring(job_type.name,1,1) job_type_name, 
       j.job_status_type_id,
       job_status_type.code job_status_type_code,
       substring(job_status_type.name,1,8) job_status_type_name,
       s.serv_status_type_id,
       serv_status_type.code serv_status_type_code, 
       serv_status_type.name serv_status_type_name,
       s.schedule_type_id,
       schedule_type.code schedule_type_code,
       schedule_type.name schedule_type_name, 
       s.service_type_id,
       service_type.code service_type_code,
       service_type.name service_type_name,
       s.est_start_date,
       s.est_start_time,
       s.est_end_date,
       s.watch_flag,
       CASE s.weekend_flag WHEN 'Y' THEN 'Yes' WHEN 'N' THEN 'No' ELSE 'N/A' END AS weekend_flag_name,
       s.po_no,
       res.user_id foreman_user_id,
       foreman.first_name + ' ' + foreman.last_name AS foreman_user_name,
       eu.customer_name end_user_name,
       jl.job_location_name,
       (SELECT TOP 1 contact_name + ' - ' + dbo.sp_contact_phone(contact_id) FROM contacts WHERE contact_id=r.customer_contact_id) customer_contact,
       (SELECT TOP 1 contact_name + ' - ' + dbo.sp_contact_phone(contact_id) FROM contacts WHERE contact_id =r.job_location_contact_id) job_location_contact,
       ISNULL(r.schedule_with_client_flag,'N') schedule_with,
       q.[roc_omni_discounted_hours-total] est_hours
  FROM jobs j INNER JOIN
       lookups job_type ON j.job_type_id = job_type.lookup_id INNER JOIN
       lookups job_status_type ON j.job_status_type_id = job_status_type.lookup_id INNER JOIN
       customers c ON j.customer_id = c.customer_id LEFT OUTER JOIN
       users billing_user ON j.billing_user_id = billing_user.user_ID LEFT OUTER JOIN
       resources res ON j.foreman_resource_id = res.resource_id LEFT OUTER JOIN
       users foreman ON res.user_id = foreman.user_id LEFT OUTER JOIN
       services s ON j.job_id = s.job_id LEFT OUTER JOIN
       lookups serv_status_type ON s.serv_status_type_id = serv_status_type.lookup_id LEFT OUTER JOIN
       lookups schedule_type ON s.schedule_type_id = schedule_type.lookup_id LEFT OUTER JOIN
       lookups service_type ON s.service_type_id = service_type.lookup_id LEFT OUTER JOIN
       job_locations jl ON s.job_location_id = jl.job_location_id LEFT OUTER JOIN
       requests r ON s.request_id=r.request_id LEFT OUTER JOIN 
       projects p ON j.project_id = p.project_id LEFT OUTER JOIN
       customers eu ON p.end_user_id = eu.customer_id LEFT OUTER JOIN
       quotes q ON s.quote_id = q.quote_id
GO

CREATE VIEW sch_job_req_info_v
AS
SELECT CAST(j.job_id AS VARCHAR(30)) + ':' + ISNULL(CAST(s.service_id AS VARCHAR(30)), '') AS job_service_id,
       j.job_id,
       j.project_id,
       s.service_id,
       r.request_id,
       c.organization_id, 
       j.job_no,
       s.service_no,
       s.po_no,
       j.job_type_id,
       job_type.name job_type,
       CASE WHEN customer_type.code = 'end_user' THEN (SELECT customer_name FROM customers WHERE customer_id = c.end_user_parent_id) 
            ELSE c.customer_name END customer_name,
       CASE WHEN customer_type.code = 'end_user' THEN c.customer_name 
            ELSE (SELECT customer_name 
                    FROM customers c1 INNER JOIN
                         projects p ON c1.customer_id=p.end_user_id 
                   WHERE p.project_id=j.project_id) END end_user_name,
       jl.job_location_name,
       jl.street1,
       jl.street2,
       jl.city,
       jl.state,
       jl.zip,
       (SELECT contact_name + ' - ' + dbo.sp_contact_phone(contact_id) FROM contacts WHERE contact_id=r.customer_contact_id) customer_contact,
       CASE WHEN r.customer_contact2_id IS NULL THEN NULL ELSE (SELECT contact_name + ' - ' + dbo.sp_contact_phone(contact_id) FROM contacts WHERE contact_id=r.customer_contact2_id) END customer_contact2,
       CASE WHEN r.customer_contact3_id IS NULL THEN NULL ELSE (SELECT contact_name + ' - ' + dbo.sp_contact_phone(contact_id) FROM contacts WHERE contact_id=r.customer_contact3_id) END customer_contact3,
       CASE WHEN r.customer_contact4_id IS NULL THEN NULL ELSE (SELECT contact_name + ' - ' + dbo.sp_contact_phone(contact_id) FROM contacts WHERE contact_id=r.customer_contact4_id) END customer_contact4,
       (SELECT contact_name FROM contacts WHERE contact_id=r.a_m_contact_id) omni_proj_mgr,
       s.description,
       s.est_start_date, 
       s.est_start_time, 
       s.est_end_date, 
       billing_type.name billing_type,
       product_disposition_type.name product_disposition,
       wall_mount_type.name wall_mount_type,
       system_furniture_type.name system_furniture,
       delivery_type.name delivery_type,
       other_furniture_type.name other_furniture_type, 
       other_delivery_type.name other_delivery_type,
       elevator_available_type.name elevator_available_type,
       dbo.sp_varchar20_to_number(q.[ROC_OMNI_DISCOUNTED_HOURS-RECEIVE]) + dbo.sp_varchar20_to_number(q.[ROC_OMNI_DISCOUNTED_HOURS-RELOAD]) est_warehouse_hours,
       dbo.sp_varchar20_to_number(q.[ROC_OMNI_DISCOUNTED_HOURS-TRUCK]) +  dbo.sp_varchar20_to_number(q.[ROC_OMNI_DISCOUNTED_HOURS-DRIVER]) est_delivery_hours, 
       dbo.sp_varchar20_to_number(q.[ROC_OMNI_DISCOUNTED_HOURS-UNLOAD]) + dbo.sp_varchar20_to_number(q.[ROC_OMNI_DISCOUNTED_HOURS-MOVE_STAGE]) + dbo.sp_varchar20_to_number(q.[ROC_OMNI_DISCOUNTED_HOURS-INSTALL]) + dbo.sp_varchar20_to_number(q.[ROC_OMNI_DISCOUNTED_HOURS-ELECTRICAL]) est_install_hours,
       (SELECT SUM(ISNULL(tc_qty,0)) FROM service_lines WHERE bill_service_id=s.service_id AND item_name IN ('AM-W-OT','AM-W-Reg','AssetHdlr-F-OT','AssetHdlr-F-Reg','AssetHdlr-S-OT','AssetHdlr-S-Reg','AssetHdlr-W-OT','AssetHdlr-W-Reg','Custom-W-OT','Custom-W-Reg','Cyc Cnt-F-OT','Cyc Cnt-F-Reg','Cyc Cnt-OH-OT','Cyc Cnt-OH-Reg','Cyc Cnt-S-OT','Cyc Cnt-S-Reg','Cyc Cnt-W-OT','Cyc Cnt-W-Reg','Delivery-W-OT','Delivery-W-Reg','Driver-W-OT','Driver-W-Reg','Gen Labor-W-OT','Gen Labor-W-Reg','Installer-W-OT','Installer-W-Reg','Lead-W-OT','Lead-W-Reg','MAC-W-OT','MAC-W-Reg','MOVER-W-OT','MOVER-W-REG','OH Whse-OT','OH Whse-Reg','Proj Mgr-W-OT','Proj Mgr-W-Reg','PS-W-OT','PS-W-Reg','Snaptrack-F-OT','Snaptrack-F-Reg','Snaptrack-S-OT','Snaptrack-S-Reg','Snaptrack-W-OT','Snaptrack-W-Reg','Snaptracker-OT','Snaptracker-Reg','Truck-W-Reg','VAN-W','Whse Mgr-OH-OT','Whse Mgr-OH-Reg','Whse Mgr-OT','Whse Mgr-Reg','Whse Proj - OT','Whse Proj - Reg','Whse Rent','Whse Sup-F-OT','Whse Sup-F-Reg',' Whse Sup-OT','Whse Sup-Reg','Whse Sup-S-OT','Whse Sup-S-Reg',' Whse Sup-W-OT','Whse Sup-W-Reg',' Whse-F-OT','Whse-F-Reg','Whse-OH-OT','Whse-OH-Reg','Whse-OT','Whse-Reg','Whse-S-OT','Whse-S-Reg','Whse-W-OT','Whse-W-Reg')) warehouse_hours_to_date,
       (SELECT SUM(ISNULL(tc_qty,0)) FROM service_lines WHERE bill_service_id=s.service_id AND item_name IN ('Delivery-F-OT','Delivery-F-Reg','Delivery-OT','Delivery-Reg','Delivery-S-OT','Delivery-S-Reg','Driver-F-OT','Driver-F-Reg','Driver-S-OT','Driver-S-Reg','Truck','Truck Rental','Truck Rental-F','Truck Rental-OH','Truck Rental-S','Truck Rental-W','Truck-Emp','Truck-Emp-F','Truck-Emp-OH','Truck-Emp-S','Truck-Emp-W','Truck-F-Reg','Truck-OH-Reg','Truck-S-Reg','Van','VAN-F','VAN-OH','VAN-S')) delivery_hours_to_date,
       (SELECT SUM(ISNULL(tc_qty,0)) FROM service_lines WHERE bill_service_id=s.service_id AND item_name IN ('AC-F-OT','AC-F-Reg','AC-OT','AC-Reg','AC-S-OT','AC-S-Reg','AC-W-OT','AC-W-Reg','AM Spec-F-OT','AM Spec-F-Reg','AM Spec-S-OT','AM Spec-S-Reg','AM Spec-W-OT','AM Spec-W-Reg','AM Spec.-OT','AM Spec.-Reg','AM-F-OT','AM-F-Reg','AM-OT','AM-Reg','AM-S-OT','AM-S-Reg','CampFuMgr-S-OT','CampFuMgr-S-Reg','CampFurnMgr-OT','CampFurnMgr-Reg','Custom-F-OT','Custom-F-Reg','Custom-OT','Custom-Reg','Custom-S-OT','Custom-S-Reg','Foreman-F-OT','Foreman-F-Reg','Foreman-S-OT','Foreman-S-Reg','Foreman-W-OT','Foreman-W-Reg','Gen Labor-F-OT','Gen Labor-F-Reg','Gen Labor-S-OT','Gen Labor-S-Reg','Install-OH-OT','Install-OH-Reg','Installer-F-OT','Installer-F-Reg','Installer-OT','Installer-Reg','Installer-S-OT','Installer-S-Reg','Lead-F-OT','Lead-F-Reg','Lead-OT','Lead-Reg','Lead-S-OT','Lead-S-Reg','MAC-F-OT','MAC-F-Reg','MAC-OT','MAC-Reg','MAC-S-OT','MAC-S-Reg','Mover','MOVER-F-OT','MOVER-F-REG','MOVER-OT HRS','MOVER-REG HRS','MOVER-S-OT','MOVER-S-REG','MPS-OT','MPS-Reg','MPS-S-OT','MPS-S-REG','OH Bid-OT','OH Bid-Reg','OH Install-OT','OH Install-Reg','OH Mgmt-OT','OH Mgmt-Reg','OH Train-OT','OH Train-Reg','PC Coord-OT','PC Coord-Reg','PC Coord-S-OT','PC Coord-S-Reg','PC Mover-OT','PC Mover-Reg','PC Mover-S-OT','PC Mover-S-Reg','PC/Fab-F-OT','PC/Fab-F-Reg','PC/Fab-OT','PC/Fab-Reg','PC/Fab-S-OT','PC/Fab-S-Reg','PC/Fab-W-OT','PC/Fab-W-Reg','Proj Mgr-F-OT','Proj Mgr-F-Reg','Proj Mgr-S-OT','Proj Mgr-S-Reg','PS-F-OT','PS-F-Reg','PS-OT','PS-OT-CA','PS-Reg','PS-Reg-CA','PS-Reg-F','PS-Reg-S','PS-S-OT','PS-S-Reg','RegProjMgr-OT','RegProjMgr-Reg','RegProjMgr-S-OT','RegProMgr-S-Reg')) installer_hours_to_date,
       CASE WHEN p.end_user_id IS NULL THEN 'N' ELSE 'Y' END is_new
  FROM jobs j INNER JOIN
       services s ON j.job_id = s.job_id INNER JOIN
       customers c ON j.customer_id = c.customer_id INNER JOIN 
       dbo.lookups customer_type ON c.customer_type_id = customer_type.lookup_id INNER JOIN
       dbo.lookups job_type ON j.job_type_id = job_type.lookup_id LEFT OUTER JOIN 
       dbo.job_locations jl ON s.job_location_id = jl.job_location_id LEFT OUTER JOIN
       dbo.lookups billing_type ON s.billing_type_id = billing_type.lookup_id LEFT OUTER JOIN 
       requests r ON s.request_id = r.request_id LEFT OUTER JOIN 
       dbo.lookups product_disposition_type ON r.prod_disp_id = product_disposition_type.lookup_id LEFT OUTER JOIN 
       dbo.lookups wall_mount_type ON r.wall_mount_type_id = wall_mount_type.lookup_id LEFT OUTER JOIN 
       dbo.lookups system_furniture_type ON r.system_furniture_line_type_id = system_furniture_type.lookup_id LEFT OUTER JOIN
       dbo.lookups delivery_type ON r.delivery_type_id = delivery_type.lookup_id LEFT OUTER JOIN 
       dbo.lookups other_furniture_type ON r.other_furniture_type_id = other_furniture_type.lookup_id LEFT OUTER JOIN 
       dbo.lookups other_delivery_type ON r.other_delivery_type_id = other_delivery_type.lookup_id LEFT OUTER JOIN 
       dbo.lookups elevator_available_type ON r.elevator_avail_type_id = elevator_available_type.lookup_id LEFT OUTER JOIN
       quotes q ON s.quote_id=q.quote_id  LEFT OUTER JOIN
       dbo.projects p ON j.project_id = p.project_id
GO

DROP VIEW versions_copy_v
GO

CREATE VIEW versions_copy_v
AS    
SELECT project_id,
       request_no,
       request_type_id,
       request_status_type_id,
       is_sent,  
       is_quoted,
       quote_request_id,
       dealer_cust_id,
       customer_po_no,
       dealer_po_no,
       dealer_po_line_no,
       dealer_project_no,
       design_project_no,
       project_volume,
       account_type_id,
       quote_type_id,
       quote_needed_by,
       job_location_id,
       customer_contact_id,
       alt_customer_contact_id,
       d_sales_rep_contact_id,
       d_sales_sup_contact_id,
       d_proj_mgr_contact_id,
       d_designer_contact_id,
       a_m_contact_id,
       a_m_install_sup_contact_id,
       a_d_designer_contact_id,
       gen_contractor_contact_id,
       electrician_contact_id,
       data_phone_contact_id,
       carpet_layer_contact_id,
       bldg_mgr_contact_id,
       security_contact_id,
       mover_contact_id,
       other_contact_id,
       pri_furn_type_id,
       pri_furn_line_type_id,
       sec_furn_type_id,
       sec_furn_line_type_id,
       case_furn_type_id,
       case_furn_line_type_id,
       wood_product_type_id,
       delivery_type_id,
       warehouse_loc,
       furn_plan_type_id,
       plan_location,
       furn_spec_type_id,
       workstation_typical_type_id,
       power_type,
       punchlist_item_type_id,
       punchlist_line,
       wall_mount_type_id,
       init_proj_team_mtg_date,
       design_presentation_date,
       design_completion_date,
       spec_check_cmpl_date,
       dealer_order_placed_date,
       int_pre_install_mtg_date,
       ext_pre_install_mtg_date,
       dealer_install_plan_date,
       mfg_ship_date,
       prod_del_to_wh_date,
       truck_arrival_time,
       construct_complete_date,
       electrical_complete_date,
       cable_complete_date,
       carpet_complete_date,
       site_visit_req_type_id,
       site_visit_date,
       product_del_to_site_date,
       schedule_type_id,
       est_start_date,
       est_start_time,
       est_end_date,
       move_in_date,
       punchlist_complete_date,
       coord_phone_data_type_id,
       coord_wall_covr_type_id,
       coord_floor_covr_type_id,
       coord_electrical_type_id,
       coord_mover_type_id,
       activity_type_id1,
       qty1,
       activity_cat_type_id1,
       activity_type_id2,
       qty2,
       activity_cat_type_id2,
       activity_type_id3,
       qty3,
       activity_cat_type_id3,
       activity_type_id4,
       qty4,
       activity_cat_type_id4,
       activity_type_id5,
       qty5,
       activity_cat_type_id5,
       activity_type_id6,
       qty6,
       activity_cat_type_id6,
       activity_type_id7,
       qty7,
       activity_cat_type_id7,
       activity_type_id8,
       qty8,
       activity_cat_type_id8,
       activity_type_id9,
       qty9,
       activity_cat_type_id9,
       activity_type_id10,
       qty10,
       activity_cat_type_id10,
       description,
       approval_req_type_id,
       who_can_approve_name,
       who_can_approve_phone,
       regular_hours_type_id,
       evening_hours_type_id,
       weekend_hours_type_id,
       union_labor_req_type_id,
       cost_to_cust_type_id,
       cost_to_vend_type_id,
       cost_to_job_type_id,
       warehouse_fee_type_id,
       taxable_flag,
       duration_time_uom_type_id,
       duration_qty,
       phased_install_type_id,
       loading_dock_type_id,
       dock_available_time,
       dock_reserv_req_type_id,
       semi_access_type_id,
       dock_height,
       elevator_avail_type_id,
       elevator_avail_time,
       elevator_reserv_req_type_id,
       stair_carry_type_id,
       stair_carry_flights,
       stair_carry_stairs,
       smallest_door_elev_width,
       floor_protection_type_id,
       wall_protection_type_id,
       doorway_prot_type_id,
       walkboard_type_id,
       staging_area_type_id,
       dumpster_type_id,
       new_site_type_id,
       occupied_site_type_id,
       other_conditions,
       date_created,  
       created_by,
       date_modified,
       modified_by,
       (SELECT MAX(version_no)+1 FROM requests WHERE project_id=r.project_id AND request_no=r.request_no) version_no,
       p_card_number,
       furniture1_contact_id,
       furniture2_contact_id,
       approver_contact_id,
       phone_contact_id,
       floor_number_type_id,
       priority_type_id,
       level_type_id,
       furn_req_type_id,
       cust_contact_mod_date,
       job_location_mod_date,
       cust_col_1,
       cust_col_2,
       cust_col_3,
       cust_col_4,
       cust_col_5,
       cust_col_6,
       cust_col_7,
       cust_col_8,
       cust_col_9,
       cust_col_10,
       is_copy,
       is_surveyed,
       furniture_type,
       furniture_qty,
       prod_disp_flag,
       prod_disp_id,
       a_m_sales_contact_id,
       work_order_received_date,
       csc_wo_field_flag,
       is_sent_date,
       other_delivery_type_id,
       customer_costing_type_id,
       customer_contact2_id,
       customer_contact3_id,
       customer_contact4_id,
       system_furniture_line_type_id,
       other_furniture_type_id,
       schedule_with_client_flag,
       job_location_contact_id,
       order_type_id,
       days_to_complete,
       is_stair_carry_required
  FROM requests r
GO

DROP VIEW projects_all_requests_v
GO

CREATE VIEW projects_all_requests_v
AS
SELECT p_v.project_id, 
       p_v.project_no,
       r.request_id, 
       r.request_no, 
       q_v.quote_id, 
       q_v.quote_no,
       CONVERT(VARCHAR, p_v.project_no) + '-' + CONVERT(VARCHAR, r.request_no) + '.' + CONVERT(VARCHAR, r.version_no) AS record_no, 
       r.request_id AS record_id, 
       r.request_no AS record_seq_no, 
       r.version_no, 
       dbo.versions_max_no_v.max_version_no, 
       r.request_type_id AS record_type_id, 
       request_type.code AS record_type_code, 
       request_type.name AS record_type_name, 
       request_type.sequence_no AS record_type_seq_no, 
       r.request_status_type_id AS record_status_type_id, 
       request_status_type.code AS record_status_type_code, 
       request_status_type.name AS record_status_type_name, 
       r.is_sent AS record_is_sent, 
       ISNULL(r.date_modified, r.date_created) AS record_last_modified, 
       r.date_created AS record_created, 
       r.date_modified AS record_modified, 
       p_v.project_status_type_id, 
       p_v.project_status_type_code, 
       p_v.project_status_type_name, 
       p_v.customer_id, 
       p_v.parent_customer_id, 
       p_v.organization_id, 
       p_v.ext_dealer_id, 
       p_v.dealer_name, 
       p_v.ext_customer_id, 
       p_v.customer_name,  
       p_v.end_user_name,
       p_v.refusal_email_info, 
       p_v.survey_location,      
       p_v.job_name, 
       r.quote_request_id, 
       r.request_type_id, 
       request_type.code AS request_type_code, 
       request_type.name AS request_type_name, 
       r.request_status_type_id, 
       request_status_type.code AS request_status_type_code, 
       request_status_type.name AS request_status_type_name, 
       r.is_sent AS request_is_sent, 
       r.dealer_po_no, 
       r.customer_po_no, 
       r.dealer_project_no, 
       r.design_project_no, 
       r.est_start_date, 
       CONVERT(VARCHAR(12), r.est_start_date, 101) AS est_start_date_varchar, 
       r.a_m_contact_id, 
       r.a_m_sales_contact_id, 
       r.customer_contact_id,
       r.customer_contact2_id,
       r.customer_contact3_id,
       r.customer_contact4_id,
       r.d_sales_rep_contact_id, 
       r.d_sales_sup_contact_id, 
       r.d_designer_contact_id, 
       r.d_proj_mgr_contact_id, 
       r.a_m_install_sup_contact_id, 
       r.a_d_designer_contact_id, 
       r.gen_contractor_contact_id, 
       r.electrician_contact_id, 
       r.data_phone_contact_id, 
       r.phone_contact_id, 
       r.carpet_layer_contact_id, 
       r.bldg_mgr_contact_id, 
       r.security_contact_id, 
       r.mover_contact_id, 
       r.other_contact_id, 
       r.furniture1_contact_id, 
       r.furniture2_contact_id, 
       r.is_quoted, 
       r.description, 
       r.approver_contact_id, 
       r.alt_customer_contact_id,   
       q_v.is_sent AS quote_is_sent, 
       q_v.quote_type_id, 
       q_v.quote_type_code, 
       q_v.quote_type_name, 
       q_v.quote_status_type_id, 
       q_v.quote_status_type_code, 
       q_v.quote_status_type_name, 
       q_v.date_quoted, 
       q_v.quote_total, 
       q_v.quoted_by_user_id,        
       q_v.quoted_by_user_name,
       p_v.is_new
  FROM dbo.projects_v2 p_v LEFT OUTER JOIN
       dbo.requests r ON p_v.project_id = r.project_id LEFT OUTER JOIN
       dbo.lookups request_type ON r.request_type_id = request_type.lookup_id LEFT OUTER JOIN
       dbo.lookups request_status_type ON r.request_status_type_id = request_status_type.lookup_id LEFT OUTER JOIN
       dbo.quotes_v q_v ON r.request_id = q_v.request_id  LEFT OUTER JOIN
       dbo.versions_max_no_v ON r.request_no = dbo.versions_max_no_v.request_no AND r.project_id = dbo.versions_max_no_v.project_id
UNION
SELECT p_v.project_id, 
       p_v.project_no,
       r.request_id, 
       r.request_no, 
       q_v.quote_id, 
       q_v.quote_no, 
       CONVERT(VARCHAR, p_v.project_no) + '-' + CONVERT(VARCHAR, q_v.quote_no) + '.' + ISNULL(CONVERT(VARCHAR, q_v.version),' ') AS record_no, 
       q_v.quote_id record_id, 
       q_v.quote_no AS record_seq_no, 
       1 version_no, 
       1 max_version_no, 
       q_v.request_type_id AS record_type_id, 
       q_v.request_type_code AS record_type_code, 
       q_v.request_type_name AS record_type_name, 
       q_v.request_type_sequence_no AS record_type_seq_no, 
       q_v.quote_status_type_id record_status_type_id, 
       q_v.quote_status_type_code AS record_status_type_code, 
       q_v.quote_status_type_name AS record_status_type_name, 
       q_v.is_sent AS record_is_sent, 
       ISNULL(q_v.date_modified, q_v.date_created) AS record_date, 
       q_v.date_created AS record_created, 
       q_v.date_modified AS record_modified, 
       p_v.project_status_type_id,  
       p_v.project_status_type_code, 
       p_v.project_status_type_name,
       p_v.customer_id, 
       p_v.parent_customer_id, 
       p_v.organization_id, 
       p_v.ext_dealer_id, 
       p_v.dealer_name, 
       p_v.ext_customer_id, 
       p_v.customer_name,
       p_v.end_user_name,
       p_v.refusal_email_info, 
       p_v.survey_location, 
       p_v.job_name,        
       r.quote_request_id,       
       r.request_type_id, 
       request_type.code AS request_type_code, 
       request_type.name AS request_type_name, 
       r.request_status_type_id, 
       request_status_type.code AS request_status_type_code, 
       request_status_type.name AS request_status_type_name, 
       r.is_sent AS request_is_sent, 
       r.dealer_po_no, 
       r.customer_po_no, 
       r.dealer_project_no, 
       r.design_project_no, 
       r.est_start_date, 
       CONVERT(VARCHAR(12), r.est_start_date, 101) AS est_start_date_varchar,
       r.a_m_contact_id, 
       r.a_m_sales_contact_id, 
       r.customer_contact_id, 
       r.customer_contact2_id,
       r.customer_contact3_id,
       r.customer_contact4_id,
       r.d_sales_rep_contact_id, 
       r.d_sales_sup_contact_id, 
       r.d_designer_contact_id, 
       r.d_proj_mgr_contact_id, 
       r.a_m_install_sup_contact_id, 
       r.a_d_designer_contact_id,  
       r.gen_contractor_contact_id,  
       r.electrician_contact_id, 
       r.data_phone_contact_id, 
       r.phone_contact_id, 
       r.carpet_layer_contact_id, 
       r.bldg_mgr_contact_id, 
       r.security_contact_id, 
       r.mover_contact_id, 
       r.other_contact_id, 
       r.furniture1_contact_id, 
       r.furniture2_contact_id,
       r.is_quoted, 
       r.description, 
       r.approver_contact_id, 
       r.alt_customer_contact_id,
       q_v.is_sent AS quote_is_sent, 
       q_v.quote_type_id, 
       q_v.quote_type_code, 
       q_v.quote_type_name, 
       q_v.quote_status_type_id, 
       q_v.quote_status_type_code, 
       q_v.quote_status_type_name, 
       q_v.date_quoted, 
       q_v.quote_total, 
       q_v.quoted_by_user_id, 
       q_v.quoted_by_user_name,
       p_v.is_new
  FROM dbo.projects_v2 p_v INNER JOIN
       dbo.requests r ON p_v.project_id = r.project_id INNER JOIN
       dbo.lookups request_type ON r.request_type_id = request_type.lookup_id INNER JOIN  
       dbo.lookups request_status_type ON r.request_status_type_id = request_status_type.lookup_id INNER JOIN
       dbo.quotes_v q_v  ON r.request_id = q_v.request_id 
 WHERE quote_id IS NOT NULL
GO

DROP VIEW extranet_email_v
GO

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
GO

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
GO

DROP VIEW pkt_job_user_res_v
GO

CREATE VIEW pkt_job_user_res_v
AS
SELECT job_id, 
       user_id, 
       resource_id
  FROM (SELECT j.job_id, 
               jd.user_id, 
               r.resource_id
          FROM dbo.jobs j INNER JOIN
               dbo.job_distributions jd ON j.job_id = jd.job_id INNER JOIN
               dbo.resources r ON jd.user_id = r.user_id
         WHERE (r.active_flag = 'Y')
       UNION
        SELECT sr.job_id, 
               r.user_id, 
               r.resource_id
          FROM dbo.sch_resources sr INNER JOIN
               dbo.RESOURCES r ON sr.resource_id = r.resource_id
         WHERE CONVERT(DATETIME, CONVERT(VARCHAR, sr.res_start_date, 101)) <= CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(), 101))
           AND ISNULL(CONVERT(DATETIME, CONVERT(VARCHAR, sr.res_end_date, 101)), DATEADD(DAY, 1, CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(), 101)))) >= CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(), 101)) 
           AND r.ACTIVE_FLAG = 'Y'
       UNION
        SELECT prc.job_id, 
               r.user_id, 
               prc.resource_id
          FROM dbo.pda_roster_changes prc INNER JOIN
               dbo.resources r ON prc.resource_id = r.resource_id
         WHERE r.active_flag = 'Y') tmp
GO

DROP VIEW pkt_sch_jobs_v
GO

CREATE VIEW pkt_sch_jobs_v
AS
SELECT j.job_id, 
       j.job_no, 
       j.job_name, 
       c.customer_name AS customer, 
       ISNULL(CASE WHEN customer_type.code='dealer' THEN eu.customer_name ELSE c.customer_name END, '') end_user_name,
       c.dealer_name AS dealer, 
       pjur_v.user_id
  FROM dbo.jobs j INNER JOIN
       dbo.customers c ON j.customer_id = c.customer_id INNER JOIN
       dbo.lookups job_status_type ON j.job_status_type_id = job_status_type.lookup_id INNER JOIN
       dbo.pkt_job_user_res_v pjur_v ON j.job_id = pjur_v.job_id INNER JOIN
       dbo.lookups customer_type ON c.customer_type_id = customer_type.lookup_id LEFT OUTER JOIN
       dbo.projects p ON j.project_id = p.project_id LEFT OUTER JOIN
       dbo.customers eu ON p.end_user_id = eu.customer_id
 WHERE job_status_type.code <> 'install_complete' 
   AND job_status_type.code <> 'invoiced' 
   AND job_status_type.code <> 'closed'
GO

CREATE VIEW extranet_email_v2
AS
SELECT CONVERT(VARCHAR(20), GETDATE(), 113) AS todays_date, 
       cust.customer_name, 
       p.job_name, 
       p.project_no, 
       CONVERT(VARCHAR, p.project_no) + '-' + CONVERT(VARCHAR, r.request_no) + '.' + CONVERT(VARCHAR, r.version_no) AS record_no, 
       r.request_id AS record_id,
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
       r.d_designer_contact_id, 
       r.d_proj_mgr_contact_id, 
       r.a_m_install_sup_contact_id, 
       r.a_d_designer_contact_id, 
       r.gen_contractor_contact_id, 
       r.electrician_contact_id, 
       r.data_phone_contact_id, 
       r.phone_contact_id, 
       r.carpet_layer_contact_id, 
       r.bldg_mgr_contact_id, 
       r.security_contact_id, 
       r.mover_contact_id, 
       r.other_contact_id, 
       r.furniture1_contact_id, 
       r.furniture2_contact_id, 
       r.description,        
       r.approver_contact_id, 
       r.alt_customer_contact_id,
       cust.refusal_email_info, 
       cust.survey_location,
       o.scheduler_contact_id,
       customer_contact.contact_name AS customer_contact_name, 
       approver_contact.contact_name AS approver_contact_name, 
       phone_contact.contact_name AS phone_contact_name
  FROM dbo.requests r INNER JOIN
       dbo.projects p ON r.project_id = p.project_id INNER JOIN
       dbo.lookups request_type ON r.request_type_id = request_type.lookup_id INNER JOIN
       dbo.lookups request_status_type ON r.request_status_type_id = request_status_type.lookup_id INNER JOIN
       dbo.customers cust ON p.customer_id = cust.customer_id INNER JOIN
       dbo.organizations o ON cust.organization_id = o.organization_id LEFT OUTER JOIN
       dbo.contacts approver_contact ON r.approver_contact_id = approver_contact.contact_id  LEFT OUTER JOIN
       dbo.contacts customer_contact ON r.customer_contact_id = customer_contact.contact_id LEFT OUTER JOIN
       dbo.contacts phone_contact ON r.phone_contact_id = phone_contact.contact_id
 WHERE request_type.code IN ('quote_request','service_request')
GO



   

  

                    

                  

