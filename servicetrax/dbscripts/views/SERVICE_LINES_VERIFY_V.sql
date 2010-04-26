CREATE VIEW dbo.SERVICE_LINES_VERIFY_V
AS
SELECT     dbo.SERVICE_LINES.SERVICE_LINE_ID, dbo.SERVICE_LINES.TC_SERVICE_LINE_NO, SUP_RES.NAME AS supervisor_resource_name, 
                      SUP_USER.PIN AS supervisor_pin, RESOURCES_1.NAME AS resource_name, USERS_1.PIN AS resource_pin, 
                      USERS_1.USER_ID AS resource_user_id, SUP_USER.USER_ID AS supervisor_user_id, dbo.SERVICE_LINES.STATUS_ID, 
                      dbo.SERVICE_LINES.VERIFIED_DATE, dbo.SERVICE_LINES.VERIFIED_BY, dbo.SERVICE_LINES.OVERRIDE_REASON, 
                      dbo.SERVICE_LINES.DATE_MODIFIED, dbo.SERVICE_LINES.MODIFIED_BY, dbo.SERVICE_LINES.TC_SERVICE_ID, dbo.SERVICES.SERVICE_NO, 
                      dbo.SERVICE_LINES.CREATED_BY, dbo.SERVICE_LINES.DATE_CREATED, USERS_3.PIN AS created_by_pin, 
                      OWNER_USER.USER_ID AS billing_user_id, OWNER_USER.PIN AS billing_user_pin, dbo.SERVICE_LINES.INVOICE_ID, 
                      dbo.SERVICE_LINES.OVERRIDE_DATE, dbo.SERVICE_LINES.OVERRIDE_BY
FROM         dbo.RESOURCES RESOURCES_1 INNER JOIN
                      dbo.SERVICE_LINES INNER JOIN
                      dbo.SERVICES ON dbo.SERVICE_LINES.TC_SERVICE_ID = dbo.SERVICES.SERVICE_ID ON 
                      RESOURCES_1.RESOURCE_ID = dbo.SERVICE_LINES.RESOURCE_ID INNER JOIN
                      dbo.JOBS ON dbo.SERVICES.JOB_ID = dbo.JOBS.JOB_ID INNER JOIN
                      dbo.USERS USERS_3 ON dbo.SERVICE_LINES.CREATED_BY = USERS_3.USER_ID LEFT OUTER JOIN
                      dbo.USERS SUP_USER INNER JOIN
                      dbo.RESOURCES SUP_RES ON SUP_USER.USER_ID = SUP_RES.USER_ID ON 
                      dbo.JOBS.FOREMAN_RESOURCE_ID = SUP_RES.RESOURCE_ID LEFT OUTER JOIN
                      dbo.USERS OWNER_USER ON dbo.JOBS.BILLING_USER_ID = OWNER_USER.USER_ID LEFT OUTER JOIN
                      dbo.USERS USERS_1 ON RESOURCES_1.USER_ID = USERS_1.USER_ID

