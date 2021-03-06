CREATE VIEW dbo.ACTIVE_USERS_COUNT_V
AS
SELECT     USER_ID, CONTACT_ID, EMPLOYMENT_TYPE_ID, EXT_DEALER_ID, DEALER_NAME, CUSTOMER_ID, USER_TYPE_ID, FIRST_NAME, LAST_NAME, 
                      LOGIN, LAST_LOGIN, ACTIVE_FLAG, FULL_NAME
FROM         dbo.USERS
WHERE     (ACTIVE_FLAG = 'y') AND (LAST_LOGIN > CONVERT(DATETIME, '2004-01-01 00:00:00', 102))

