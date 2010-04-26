
CREATE VIEW dbo.USERS_V
AS
SELECT     main.USER_ID, main.EXT_EMPLOYEE_ID, main.FIRST_NAME, main.LAST_NAME, main.CONTACT_ID, main.EMPLOYMENT_TYPE_ID, 
                      employement_types.CODE AS employment_type_code, employement_types.NAME AS employment_type_name, main.USER_TYPE_ID, 
                      user_types.CODE AS user_type_code, user_types.NAME AS user_type_name, main.EXT_DEALER_ID, main.DEALER_NAME, 
                      main.FIRST_NAME + ' ' + main.LAST_NAME AS full_name, main.LAST_LOGIN, main.LOGIN, main.PASSWORD, main.ACTIVE_FLAG, 
                      main.DATE_CREATED, main.DATE_MODIFIED, main.CREATED_BY, main.MODIFIED_BY, 
                      created_by.FIRST_NAME + ' ' + created_by.LAST_NAME AS created_by_name, 
                      modified_by.FIRST_NAME + ' ' + modified_by.LAST_NAME AS modified_by_name, main.PIN, main.IMOBILE_LOGIN, main.LAST_SYNCH_DATE, 
                      vendor_contact.EMAIL, main.VENDOR_CONTACT_ID, vendor_contact.CONTACT_NAME AS vendor_contact_name
FROM         dbo.CONTACTS CONTACTS_1 RIGHT OUTER JOIN
                      dbo.LOOKUPS employement_types RIGHT OUTER JOIN
                      dbo.CONTACTS vendor_contact RIGHT OUTER JOIN
                      dbo.LOOKUPS user_types RIGHT OUTER JOIN
                      dbo.USERS created_by RIGHT OUTER JOIN
                      dbo.USERS main LEFT OUTER JOIN
                      dbo.USERS modified_by ON main.MODIFIED_BY = modified_by.USER_ID ON created_by.USER_ID = main.CREATED_BY ON 
                      user_types.LOOKUP_ID = main.USER_TYPE_ID ON vendor_contact.CONTACT_ID = main.VENDOR_CONTACT_ID ON 
                      employement_types.LOOKUP_ID = main.EMPLOYMENT_TYPE_ID ON CONTACTS_1.CONTACT_ID = main.CONTACT_ID
WHERE     (main.ACTIVE_FLAG = 'Y')


