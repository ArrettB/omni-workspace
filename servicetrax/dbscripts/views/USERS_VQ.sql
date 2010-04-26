CREATE VIEW dbo.USERS_VQ
AS
SELECT     main.USER_ID, main.EXT_EMPLOYEE_ID, main.FIRST_NAME, main.LAST_NAME, main.CONTACT_ID, main.EMPLOYMENT_TYPE_ID, 
                      main.USER_TYPE_ID, 
                       main.EXT_DEALER_ID, main.DEALER_NAME, 
                      main.FIRST_NAME + ' ' + main.LAST_NAME AS full_name, main.LAST_LOGIN, main.LOGIN, main.PASSWORD, main.ACTIVE_FLAG, 
                      main.DATE_CREATED, main.DATE_MODIFIED, main.CREATED_BY, main.MODIFIED_BY, 
                      main.PIN, main.IMOBILE_LOGIN, main.LAST_SYNCH_DATE, 
                      main.VENDOR_CONTACT_ID
FROM                  dbo.USERS main
WHERE     (main.ACTIVE_FLAG = 'Y')


