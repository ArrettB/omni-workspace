CREATE VIEW dbo.crystal_UNBILLED_OPS_V2
AS
SELECT     TOP 100 PERCENT billing_user_id, bill_job_no, bill_job_id, non_billable_total, billable_total, dealer_name, customer_name, 
                      max_est_end_date_varchar, billing_user_name, job_status_type_name, job_name, organization_id
FROM         dbo.BILL_JOBS_V
WHERE     (organization_id = 2) AND (job_status_type_name = 'invoiced')

