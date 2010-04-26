CREATE VIEW dbo.PDA_JOBS_V
AS
SELECT     dbo.JOBS.JOB_ID, dbo.JOBS.JOB_NO AS ref_no, dbo.JOBS.JOB_NAME,
dbo.RESOURCES.USER_ID AS ims_user_id, 
                      dbo.CUSTOMERS.CUSTOMER_NAME AS customer,
dbo.CUSTOMERS.DEALER_NAME AS dealer
FROM         dbo.JOBS INNER JOIN
                      dbo.RESOURCES ON dbo.JOBS.FOREMAN_RESOURCE_ID =
dbo.RESOURCES.RESOURCE_ID INNER JOIN
                      dbo.CUSTOMERS ON dbo.JOBS.CUSTOMER_ID =
dbo.CUSTOMERS.CUSTOMER_ID INNER JOIN
                      dbo.LOOKUPS ON dbo.JOBS.JOB_STATUS_TYPE_ID =
dbo.LOOKUPS.LOOKUP_ID
WHERE     (dbo.LOOKUPS.CODE <> 'install_complete') AND (dbo.LOOKUPS.CODE <>
'invoiced') AND (dbo.LOOKUPS.CODE <> 'closed')
UNION
SELECT     dbo.JOBS.JOB_ID, dbo.JOBS.JOB_NO AS ref_no, dbo.JOBS.JOB_NAME,
dbo.JOB_DISTRIBUTIONS.USER_ID AS ims_user_id, 
                      dbo.CUSTOMERS.CUSTOMER_NAME AS customer,
dbo.CUSTOMERS.DEALER_NAME AS dealer
FROM         dbo.JOBS INNER JOIN
                      dbo.CUSTOMERS ON dbo.JOBS.CUSTOMER_ID =
dbo.CUSTOMERS.CUSTOMER_ID INNER JOIN
                      dbo.JOB_DISTRIBUTIONS ON dbo.JOBS.JOB_ID =
dbo.JOB_DISTRIBUTIONS.JOB_ID INNER JOIN
                      dbo.LOOKUPS ON dbo.JOBS.JOB_STATUS_TYPE_ID =
dbo.LOOKUPS.LOOKUP_ID
WHERE     (dbo.LOOKUPS.CODE <> 'install_complete') AND (dbo.LOOKUPS.CODE <>
'invoiced') AND (dbo.LOOKUPS.CODE <> 'closed')


