DROP VIEW bill_jobs_v
GO

CREATE VIEW bill_jobs_v
AS
SELECT j.billing_user_id, 
       sl.bill_job_no, 
       sl.bill_job_id, 
       CASE WHEN customer_type.code = 'end_user' THEN eu_parent.customer_name ELSE c.customer_name END customer_name,
       CASE WHEN customer_type.code = 'end_user' THEN c.customer_name ELSE eu.customer_name END end_user_name,
       c.ext_dealer_id, 
       u.first_name + ' ' + u.last_name AS billing_user_name, 
       jl.name AS job_status_type_name, 
       j.job_name, 
       sl.organization_id, 
       CONVERT(varchar, MAX(s.est_end_date), 1) AS max_est_end_date_varchar,	
       SUM(CASE WHEN sl.billable_flag = 'Y'THEN sl.bill_total ELSE 0 END) billable_total, 
       SUM(CASE WHEN sl.billable_flag = 'N' THEN sl.bill_total ELSE 0 END) non_billable_total,
       (SELECT ISNULL(SUM(il.extended_price),0) 
	      FROM invoices i inner join invoice_lines il ON i.invoice_id = il.invoice_id
	     WHERE i.job_id = sl.bill_job_id) AS  invoiced_total,
       (SELECT COUNT(po.po_id) FROM purchase_orders po INNER JOIN 
                                    requests r ON po.request_id=r.request_id
         WHERE r.project_id=j.project_id) po_count,
       (SELECT COUNT(po.po_id) FROM purchase_orders po INNER JOIN 
                                    requests r ON po.request_id=r.request_id INNER JOIN
                                    lookups l ON po.po_status_id=l.lookup_id
         WHERE r.project_id=j.project_id AND l.code = 'received') received_po_count
  FROM dbo.service_lines sl INNER JOIN
       dbo.services s ON sl.bill_service_id = s.service_id INNER JOIN 
       dbo.jobs j ON sl.bill_job_id = j.job_id INNER JOIN 
       dbo.customers c ON j.customer_id = c.customer_id INNER JOIN 
       dbo.lookups jl ON j.job_status_type_id = jl.lookup_id INNER JOIN
       dbo.lookups customer_type ON c.customer_type_id = customer_type.lookup_id LEFT OUTER JOIN
       dbo.customers eu ON j.end_user_id = eu.customer_id LEFT OUTER JOIN 
       dbo.invoices i ON sl.invoice_id = i.invoice_id LEFT OUTER JOIN 
       dbo.users u ON j.billing_user_id = u.user_id LEFT OUTER JOIN 
       dbo.customers eu_parent ON c.end_user_parent_id = eu_parent.customer_id
 WHERE sl.status_id = 4
   AND sl.internal_req_flag = 'N'
   AND (i.status_id = 1 OR i.status_id IS NULL) 
GROUP BY j.billing_user_id, 
         sl.bill_job_no, 
         sl.bill_job_id, 
         CASE WHEN customer_type.code = 'end_user' THEN eu_parent.customer_name ELSE c.customer_name END,
         CASE WHEN customer_type.code = 'end_user' THEN c.customer_name ELSE eu.customer_name END,
         u.first_name, 
         u.last_name, 
         jl.name, 
         j.job_name, 
         sl.organization_id, 
         c.ext_dealer_id,
         j.project_id
GO