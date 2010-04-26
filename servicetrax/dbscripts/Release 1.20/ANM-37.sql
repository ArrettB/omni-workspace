-- See http://jira.apexit.com/jira/browse/ANM-37
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[INVOICE_PRE_TOTAL_V]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[INVOICE_PRE_TOTAL_V]
GO


CREATE view INVOICE_PRE_TOTAL_V as
SELECT     iv.ORGANIZATION_ID, iv.JOB_ID, dbo.JOBS_V.JOB_NO, sblv.BILL_SERVICE_ID AS service_id, iv.INVOICE_ID, iv.invoice_id_trk, 
                      iv.DESCRIPTION AS invoice_description, iv.STATUS_ID AS invoice_status_id, iv.EXT_BATCH_ID, iv.DATE_SENT, iv.invoice_type_name, 
                      iv.invoice_type_code, iv.BATCH_STATUS_ID, 0 AS custom_line_total, ISNULL(sblv.BILL_HOURLY_TOTAL, 0) AS bill_hourly_total, 
                      ISNULL(sblv.BILL_EXP_TOTAL, 0) AS bill_exp_total, ISNULL(sblv.BILL_TOTAL, 0) AS bill_total, iv.assigned_to_name, dbo.JOBS_V.BILLING_USER_ID, 
                      dbo.JOBS_V.billing_user_name, iv.billing_type_name, iv.invoice_format_type_name, iv.PO_NO, dbo.JOBS_V.DEALER_NAME, 
                      dbo.JOBS_V.EXT_DEALER_ID, dbo.JOBS_V.CUSTOMER_NAME, iv.DATE_CREATED AS invoice_date_created, dbo.JOBS_V.job_type_name, 
                      dbo.jobs_v.job_type_code
FROM         dbo.INVOICES_V iv LEFT OUTER JOIN
                      dbo.JOBS_V ON iv.JOB_ID = dbo.JOBS_V.JOB_ID LEFT OUTER JOIN
                      dbo.BILLING_V sblv ON iv.INVOICE_ID = sblv.INVOICE_ID
UNION ALL
SELECT     j.ORGANIZATION_ID, iv.JOB_ID, j.job_no, NULL, iv.INVOICE_ID, iv.invoice_id_trk, iv.DESCRIPTION, iv.STATUS_ID, iv.EXT_BATCH_ID, iv.DATE_SENT, 
                      iv.invoice_type_name, iv.invoice_type_code, iv.batch_status_id, (ilv.unit_price * ilv.qty) custom_line_total, 0, 0, 0, iv.assigned_to_name, 
                      j.billing_user_id, j.billing_user_name, iv.billing_type_name, iv.invoice_format_type_name, iv.po_no, j.dealer_name, j.ext_dealer_id, 
                      j.CUSTOMER_NAME, iv.date_created invoice_date_created, j.job_type_name, j.job_type_code
FROM         dbo.JOBS_V j RIGHT OUTER JOIN
                      dbo.INVOICE_LINES_V ilv ON j.JOB_ID = ilv.JOB_ID RIGHT OUTER JOIN
                      dbo.INVOICES_V iv ON ilv.INVOICE_ID = iv.INVOICE_ID
WHERE     iv.invoice_id = ilv.invoice_id AND ilv.job_id = j.job_id AND ilv.invoice_line_type_code = 'custom'


GO



if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[INVOICE_POST_TOTAL_V]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[INVOICE_POST_TOTAL_V]
GO

CREATE VIEW dbo.INVOICE_POST_TOTAL_V
AS
SELECT     iv.INVOICE_ID, iv.invoice_id_trk, iv.DESCRIPTION invoice_description, iv.STATUS_ID invoice_status_id, iv.EXT_BATCH_ID, iv.JOB_ID, j.JOB_NO, 
                      CONVERT(varchar(12), iv.date_sent, 101) date_sent, iv.date_created invoice_date_created, iv.invoice_type_name, iv.invoice_type_code, 
                      iv.BATCH_STATUS_ID, CASE iv.batch_status_id WHEN - 1 THEN 'false' ELSE 'true' END AS readonly, 
                      CASE ilv.invoice_line_type_code WHEN 'custom' THEN ilv.UNIT_PRICE * ilv.QTY ELSE 0 END AS custom_line_total, 
                      CASE ilv.invoice_line_type_code WHEN 'system' THEN CASE ilv.item_type_code WHEN 'hours' THEN ilv.UNIT_PRICE * ilv.QTY ELSE 0 END END AS bill_hourly_total,
                       CASE ilv.invoice_line_type_code WHEN 'system' THEN CASE ilv.item_type_code WHEN 'expense' THEN ilv.UNIT_PRICE * ilv.QTY ELSE 0 END END AS
                       bill_exp_total, CASE ilv.invoice_line_type_code WHEN 'system' THEN ilv.UNIT_PRICE * ilv.QTY ELSE 0 END AS bill_total, NULL AS bill_service_id, 
                      j.ext_dealer_id, j.dealer_name, j.CUSTOMER_NAME, j.ORGANIZATION_ID, iv.assigned_to_name, iv.billing_type_name, j.BILLING_USER_ID, 
                      iv.invoice_format_type_name, iv.PO_NO, j.job_type_name, j.job_type_code
FROM         dbo.INVOICES_V iv LEFT OUTER JOIN
                      dbo.INVOICE_LINES_V ilv ON iv.INVOICE_ID = ilv.INVOICE_ID LEFT OUTER JOIN
                      dbo.JOBS_V j ON ilv.JOB_ID = j.JOB_ID




