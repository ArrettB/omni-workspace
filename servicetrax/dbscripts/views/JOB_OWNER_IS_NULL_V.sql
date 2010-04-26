CREATE VIEW dbo.JOB_OWNER_IS_NULL_V
AS
SELECT     JOB_ID, PROJECT_ID, JOB_NO, JOB_NAME, JOB_NO_NAME, JOB_TYPE_ID, JOB_STATUS_TYPE_ID, job_status_type_code, job_status_type_name, 
                      CUSTOMER_ID, ORGANIZATION_ID, DEALER_NAME, EXT_DEALER_ID, CUSTOMER_NAME, EXT_CUSTOMER_ID, foreman_resource_name, 
                      foreman_user_name, BILLING_USER_ID, billing_user_name, DATE_CREATED, DATE_MODIFIED
FROM         dbo.JOBS_V
WHERE     (BILLING_USER_ID IS NULL)

