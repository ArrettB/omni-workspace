CREATE VIEW dbo.crystal_UNBILLED_OPS_V
AS
SELECT     dbo.BILLING_V.ORGANIZATION_ID, dbo.BILLING_V.BILL_JOB_NO, dbo.BILLING_V.BILL_JOB_ID, dbo.BILLING_V.job_status_type_name, dbo.BILLING_V.job_name,
                      dbo.BILLING_V.BILLING_USER_ID, dbo.BILLING_V.EXT_DEALER_ID, dbo.BILLING_V.DEALER_NAME, dbo.BILLING_V.CUSTOMER_NAME, 
                      cast(dbo.BILLING_V.billing_user_name as varchar) as job_owner, MAX(dbo.SERVICES.EST_END_DATE) AS max_est_end_date, convert(varchar(12), MAX(dbo.SERVICES.EST_END_DATE), 101) max_est_end_date_varchar,
                      SUM(CASE billable_flag WHEN 'Y' THEN bill_total ELSE 0 END) billable_total, SUM(CASE billable_flag WHEN 'N' THEN bill_total ELSE 0 END) 
                      non_billable_total, dbo.SERVICES.PO_NO
FROM         dbo.BILLING_V INNER JOIN
                      dbo.SERVICES ON dbo.BILLING_V.BILL_SERVICE_ID = dbo.SERVICES.SERVICE_ID
WHERE     (dbo.BILLING_V.invoice_status_id = 1 OR
                      dbo.BILLING_V.invoice_status_id IS NULL)  and status_id = 4
GROUP BY dbo.BILLING_V.ORGANIZATION_ID, dbo.BILLING_V.BILL_JOB_ID, dbo.BILLING_V.BILL_JOB_NO, dbo.BILLING_V.BILLING_USER_ID, 
                      dbo.BILLING_V.DEALER_NAME, dbo.BILLING_V.EXT_DEALER_ID, dbo.BILLING_V.CUSTOMER_NAME, dbo.BILLING_V.billing_user_name, 
                      dbo.BILLING_V.job_status_type_name, dbo.BILLING_V.job_name, dbo.SERVICES.PO_NO



