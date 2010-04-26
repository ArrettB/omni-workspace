DROP VIEW [dbo].[invoice_post_total_v]
GO

CREATE VIEW [dbo].[invoice_post_total_v]
AS
SELECT i.invoice_id, 
       CAST(i.invoice_id AS varchar) + cit_v.contains_tracking AS invoice_id_trk, 
       i.description invoice_description, 
       i.status_id invoice_status_id, 
       i.ext_batch_id, 
       i.job_id, 
       i.date_created invoice_date_created, 
       i.batch_status_id,
       i.batch_error_message,
       i.po_no, 
       CONVERT(VARCHAR(12), i.date_sent, 101) date_sent, 
       j.job_no, 
       j.billing_user_id, 
       c.organization_id,
       c.ext_dealer_id, 
       c.dealer_name,
       c.customer_name,
       eu.customer_name end_user_name,
       invoice_type.name AS invoice_type_name, 
       invoice_type.code AS invoice_type_code, 
       assigned_to.first_name + ' ' + assigned_to.last_name AS assigned_to_name, 
       billing_type.name AS billing_type_name,   
       invoice_format_type.name AS invoice_format_type_name,    
       CASE i.batch_status_id WHEN - 1 THEN 'false' ELSE 'true' END AS readonly, 
       job_type.name job_type_name, 
       job_type.code job_type_code,             
       CASE invoice_line_type.code WHEN 'custom' THEN il.unit_price * il.qty ELSE 0 END AS custom_line_total, 
       CASE invoice_line_type.code WHEN 'system' THEN CASE item_type.code WHEN 'hours' THEN il.unit_price * il.qty ELSE 0 END END AS bill_hourly_total,
       CASE invoice_line_type.code WHEN 'system' THEN CASE item_type.code WHEN 'expense' THEN il.unit_price * il.qty ELSE 0 END END AS bill_exp_total, 
       CASE invoice_line_type.code WHEN 'system' THEN il.unit_price * il.qty ELSE 0 END AS bill_total, 
       ibs.code batch_status_code,
       ibs.name batch_status_name,
       NULL AS bill_service_id
  FROM dbo.invoices i INNER JOIN
       dbo.lookups invoice_type ON i.invoice_type_id = invoice_type.lookup_id INNER JOIN
       dbo.jobs j ON i.job_id = j.job_id INNER JOIN
       dbo.lookups job_type ON j.job_type_id = job_type.lookup_id INNER JOIN 
       dbo.customers c ON j.customer_id = c.customer_id INNER JOIN
       dbo.lookups customer_type ON c.customer_type_id = customer_type.lookup_id LEFT OUTER JOIN
       dbo.customers eu ON j.end_user_id = eu.customer_id LEFT OUTER JOIN     
       dbo.invoice_batch_statuses ibs ON i.batch_status_id = ibs.status_id LEFT OUTER JOIN
       dbo.users assigned_to ON i.assigned_to_user_id = assigned_to.user_id LEFT OUTER JOIN
       dbo.contains_invoice_tracking_v cit_v ON i.invoice_id = cit_v.invoice_id LEFT OUTER JOIN
       dbo.lookups invoice_format_type ON i.invoice_format_type_id = invoice_format_type.lookup_id LEFT OUTER JOIN
       dbo.lookups billing_type ON i.billing_type_id = billing_type.lookup_id LEFT OUTER JOIN
       dbo.invoice_lines il ON i.invoice_id = il.invoice_id LEFT OUTER JOIN
       dbo.lookups invoice_line_type ON il.invoice_line_type_id = invoice_line_type.lookup_id LEFT OUTER JOIN
       dbo.items item ON il.item_id = item.item_id LEFT OUTER JOIN
       dbo.lookups item_type ON item.item_type_id = item_type.lookup_id
GO