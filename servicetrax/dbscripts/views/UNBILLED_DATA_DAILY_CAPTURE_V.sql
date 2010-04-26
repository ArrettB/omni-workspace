CREATE VIEW dbo.UNBILLED_DATA_DAILY_CAPTURE_V
AS
SELECT     RECORDID, ORGANIZATION_ID, BILL_JOB_NO, job_status_type_name, job_name, BILLING_USER_ID, EXT_DEALER_ID, DEALER_NAME, 
                      CUSTOMER_NAME, job_owner, max_est_end_date, max_est_end_date_varchar, billable_total, non_billable_total, PO_NO, PooledTotal, 
                      UnbilledOpsInvoicesTotal, NAME, DATEREPORTRUN
FROM         dbo.UNBILLED_REPORT_DAILYDATACAPTURE
WHERE     (ORGANIZATION_ID = 11) AND (DATEREPORTRUN > CONVERT(DATETIME, '2007-12-01 00:00:00', 102))

