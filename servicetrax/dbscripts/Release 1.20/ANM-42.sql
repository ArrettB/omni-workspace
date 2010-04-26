-- See http://jira.apexit.com/jira/browse/ANM-42


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[BILL_JOBS_V]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[BILL_JOBS_V]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.BILL_JOBS_V
AS
SELECT     j.BILLING_USER_ID, sl.BILL_JOB_NO, sl.BILL_JOB_ID, c.DEALER_NAME, c.CUSTOMER_NAME, c.EXT_DEALER_ID, u.FIRST_NAME + ' ' + u.LAST_NAME AS billing_user_name, 
            jl.NAME AS job_status_type_name, j.JOB_NAME, sl.ORGANIZATION_ID, 
CONVERT(varchar, MAX(s.EST_END_DATE), 1) AS max_est_end_date_varchar,	
SUM(CASE WHEN sl.billable_flag = 'Y'THEN sl.bill_total ELSE 0 END) billable_total, 
SUM(CASE WHEN sl.billable_flag = 'N' THEN sl.bill_total ELSE 0 END) non_billable_total,
(
	SELECT ISNULL(SUM(il.extended_price),0) 
	FROM invoices i inner join invoice_lines il
	ON i.invoice_id = il.invoice_id
	WHERE i.job_id = sl.bill_job_id
) AS  invoiced_total

FROM dbo.SERVICE_LINES sl 
INNER JOIN dbo.SERVICES s ON sl.BILL_SERVICE_ID = s.SERVICE_ID 
INNER JOIN dbo.JOBS j ON sl.BILL_JOB_ID = j.JOB_ID
INNER JOIN dbo.CUSTOMERS c ON j.CUSTOMER_ID = c.CUSTOMER_ID 
INNER JOIN dbo.LOOKUPS jl ON j.JOB_STATUS_TYPE_ID = jl.LOOKUP_ID 
LEFT OUTER JOIN dbo.INVOICES i ON sl.INVOICE_ID = i.INVOICE_ID
LEFT OUTER JOIN dbo.USERS u ON j.BILLING_USER_ID = u.USER_ID
WHERE sl.STATUS_ID = 4
AND sl.INTERNAL_REQ_FLAG = 'N'
AND (i.STATUS_ID = 1 OR i.STATUS_ID IS NULL) 
GROUP BY j.BILLING_USER_ID, sl.BILL_JOB_NO, sl.BILL_JOB_ID, c.DEALER_NAME, c.CUSTOMER_NAME, u.FIRST_NAME, u.LAST_NAME, jl.NAME, 
j.JOB_NAME, sl.ORGANIZATION_ID, c.EXT_DEALER_ID