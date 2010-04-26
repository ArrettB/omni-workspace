CREATE VIEW dbo.crystal_UNBILLED_OPS_AIA_V
AS
SELECT     ORGANIZATION_ID, BILL_JOB_NO, BILL_JOB_ID, job_status_type_name, job_name, BILLING_USER_ID, EXT_DEALER_ID, DEALER_NAME, 
                      CUSTOMER_NAME, job_owner, max_est_end_date, max_est_end_date_varchar, billable_total, non_billable_total, PO_NO
FROM         dbo.crystal_UNBILLED_OPS_V
WHERE     (ORGANIZATION_ID = 8)

