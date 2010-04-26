
CREATE VIEW invoice_pre_total_v 
AS
SELECT i_v.organization_id, 
       i_v.job_id, 
       j_v.job_no, 
       b_v.bill_service_id AS service_id, 
       i_v.invoice_id, 
       i_v.invoice_id_trk, 
       i_v.description AS invoice_description, 
       i_v.status_id AS invoice_status_id, 
       i_v.ext_batch_id, 
       i_v.date_sent, 
       i_v.invoice_type_name, 
       i_v.invoice_type_code, 
       i_v.batch_status_id, 
       0 AS custom_line_total, 
       ISNULL(b_v.bill_hourly_total, 0) AS bill_hourly_total, 
       ISNULL(b_v.bill_exp_total, 0) AS bill_exp_total, 
       ISNULL(b_v.bill_total, 0) AS bill_total, 
       i_v.assigned_to_name, 
       j_v.billing_user_id, 
       j_v.billing_user_name, 
       i_v.billing_type_name, 
       i_v.invoice_format_type_name, 
       i_v.po_no, 
       j_v.dealer_name, 
       j_v.ext_dealer_id,
       j_v.customer_name,
       j_v.end_user_name,
       i_v.date_created AS invoice_date_created,
       j_v.job_type_name, 
       j_v.job_type_code
  FROM dbo.invoices_v i_v LEFT OUTER JOIN
       dbo.jobs_v j_v ON i_v.job_id = j_v.job_id LEFT OUTER JOIN
       dbo.billing_v b_v ON i_v.invoice_id = b_v.invoice_id
UNION ALL
SELECT j_v.organization_id, 
       i_v.job_id, 
       j_v.job_no, 
       NULL, 
       i_v.invoice_id, 
       i_v.invoice_id_trk, 
       i_v.description,
       i_v.status_id,
       i_v.ext_batch_id,
       i_v.date_sent, 
       i_v.invoice_type_name,
       i_v.invoice_type_code, 
       i_v.batch_status_id,
       (il_v.unit_price * il_v.qty) custom_line_total, 
       0,
       0, 
       0,
       i_v.assigned_to_name, 
       j_v.billing_user_id, 
       j_v.billing_user_name,
       i_v.billing_type_name,
       i_v.invoice_format_type_name,
       i_v.po_no,
       j_v.dealer_name,
       j_v.ext_dealer_id, 
       j_v.customer_name,
       j_v.end_user_name,
       i_v.date_created invoice_date_created,
       j_v.job_type_name, 
       j_v.job_type_code
  FROM dbo.jobs_v j_v RIGHT OUTER JOIN
       dbo.invoice_lines_v il_v on j_v.job_id = il_v.job_id RIGHT OUTER JOIN
       dbo.invoices_v i_v ON il_v.invoice_id = i_v.invoice_id
 WHERE i_v.invoice_id = il_v.invoice_id 
   AND il_v.job_id = j_v.job_id 
   AND il_v.invoice_line_type_code = 'custom'

