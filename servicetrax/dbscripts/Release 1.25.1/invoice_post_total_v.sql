DROP VIEW invoice_post_total_v
GO

CREATE VIEW invoice_post_total_v
AS
SELECT iv.invoice_id, 
       iv.invoice_id_trk, 
       iv.description invoice_description, 
       iv.status_id invoice_status_id, 
       iv.ext_batch_id, 
       iv.job_id, 
       j.job_no, 
       CONVERT(VARCHAR(12), iv.date_sent, 101) date_sent, 
       iv.date_created invoice_date_created, 
       iv.invoice_type_name,
       iv.invoice_type_code, 
       iv.batch_status_id, 
       CASE iv.batch_status_id WHEN - 1 THEN 'false' ELSE 'true' END AS readonly, 
       CASE ilv.invoice_line_type_code WHEN 'custom' THEN ilv.unit_price * ilv.qty ELSE 0 END AS custom_line_total, 
       CASE ilv.invoice_line_type_code WHEN 'system' THEN CASE ilv.item_type_code WHEN 'hours' THEN ilv.unit_price * ilv.qty ELSE 0 END end AS bill_hourly_total,
       CASE ilv.invoice_line_type_code WHEN 'system' THEN CASE ilv.item_type_code WHEN 'expense' THEN ilv.unit_price * ilv.qty ELSE 0 END end as
       bill_exp_total, 
       CASE ilv.invoice_line_type_code WHEN 'system' THEN ilv.unit_price * ilv.qty ELSE 0 END AS bill_total, 
       NULL AS bill_service_id, 
       j.ext_dealer_id, 
       j.dealer_name,
       j.customer_name,
       j.end_user_name,
       j.organization_id,
       iv.assigned_to_name,
       iv.billing_type_name,
       j.billing_user_id, 
       iv.invoice_format_type_name, 
       iv.po_no, 
       j.job_type_name, 
       j.job_type_code
  FROM dbo.invoices_v iv LEFT OUTER JOIN
       dbo.invoice_lines_v ilv on iv.invoice_id = ilv.invoice_id LEFT OUTER JOIN
       dbo.jobs_v j ON ilv.job_id = j.job_id
GO