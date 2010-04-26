CREATE VIEW dbo.TRACKING_V
AS
SELECT     dbo.TRACKING.TRACKING_ID, dbo.TRACKING.JOB_ID, dbo.JOBS.JOB_NO, dbo.TRACKING.SERVICE_ID, dbo.SERVICES.SERVICE_NO, 
                      dbo.TRACKING.TRACKING_TYPE_ID, LOOKUPS_3.CODE AS tracking_type_code, LOOKUPS_3.NAME AS tracking_type_name, 
                      dbo.TRACKING.TO_CONTACT_ID, dbo.CONTACTS.CONTACT_NAME AS to_contact_name, dbo.CONTACTS.EMAIL, dbo.TRACKING.FROM_USER_ID, 
                      USERS_3.FIRST_NAME + ' ' + USERS_3.LAST_NAME AS from_user_name, dbo.SERVICES.SERV_STATUS_TYPE_ID AS cur_status_type_id, 
                      dbo.TRACKING.NEW_STATUS_ID, LOOKUPS_1.CODE AS new_status_type_code, LOOKUPS_1.NAME AS new_status_type_name, 
                      dbo.TRACKING.OLD_STATUS_ID, LOOKUPS_1.CODE AS old_status_type_code, LOOKUPS_1.NAME AS old_status_type_name, dbo.TRACKING.NOTES, 
                      dbo.TRACKING.DATE_CREATED, dbo.TRACKING.CREATED_BY, USERS_2.FIRST_NAME + ' ' + USERS_2.LAST_NAME AS created_by_name, 
                      dbo.TRACKING.DATE_MODIFIED, dbo.TRACKING.MODIFIED_BY, USERS_1.FIRST_NAME + ' ' + USERS_1.LAST_NAME AS modified_by_name, 
                      dbo.TRACKING.EMAIL_SENT_FLAG
FROM         dbo.LOOKUPS LOOKUPS_1 RIGHT OUTER JOIN
                      dbo.LOOKUPS LOOKUPS_2 RIGHT OUTER JOIN
                      dbo.USERS USERS_2 RIGHT OUTER JOIN
                      dbo.USERS USERS_3 RIGHT OUTER JOIN
                      dbo.CONTACTS RIGHT OUTER JOIN
                      dbo.SERVICES RIGHT OUTER JOIN
                      dbo.USERS USERS_1 RIGHT OUTER JOIN
                      dbo.JOBS RIGHT OUTER JOIN
                      dbo.TRACKING ON dbo.JOBS.JOB_ID = dbo.TRACKING.JOB_ID LEFT OUTER JOIN
                      dbo.LOOKUPS LOOKUPS_3 ON dbo.TRACKING.TRACKING_TYPE_ID = LOOKUPS_3.LOOKUP_ID ON 
                      USERS_1.USER_ID = dbo.TRACKING.MODIFIED_BY ON dbo.SERVICES.SERVICE_ID = dbo.TRACKING.SERVICE_ID ON 
                      dbo.CONTACTS.CONTACT_ID = dbo.TRACKING.TO_CONTACT_ID ON USERS_3.USER_ID = dbo.TRACKING.FROM_USER_ID ON 
                      USERS_2.USER_ID = dbo.TRACKING.CREATED_BY ON LOOKUPS_2.LOOKUP_ID = dbo.TRACKING.OLD_STATUS_ID ON 
                      LOOKUPS_1.LOOKUP_ID = dbo.TRACKING.NEW_STATUS_ID


