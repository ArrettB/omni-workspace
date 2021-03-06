CREATE VIEW dbo.QUOTE_CONDITIONS_V
AS
SELECT     dbo.QUOTE_CONDITIONS.QUOTE_CONDITION_ID, dbo.QUOTE_CONDITIONS.QUOTE_ID, dbo.QUOTE_CONDITIONS.CONDITION_ID, 
                      dbo.CONDITIONS.NAME, dbo.QUOTE_CONDITIONS.USE_FLAG, dbo.QUOTE_CONDITIONS.DATE_CREATED, dbo.QUOTE_CONDITIONS.CREATED_BY, 
                      USERS_1.FIRST_NAME + ' ' + USERS_1.LAST_NAME AS created_by_name, dbo.QUOTE_CONDITIONS.DATE_MODIFIED, 
                      dbo.QUOTE_CONDITIONS.MODIFIED_BY, USERS_2.FIRST_NAME + ' ' + USERS_2.LAST_NAME AS modified_by_name, 
                      dbo.CONDITIONS.SEQUENCE_NO
FROM         dbo.CONDITIONS INNER JOIN
                      dbo.QUOTE_CONDITIONS ON dbo.CONDITIONS.CONDITION_ID = dbo.QUOTE_CONDITIONS.CONDITION_ID LEFT OUTER JOIN
                      dbo.USERS USERS_2 ON dbo.QUOTE_CONDITIONS.MODIFIED_BY = USERS_2.USER_ID LEFT OUTER JOIN
                      dbo.USERS USERS_1 ON dbo.QUOTE_CONDITIONS.CREATED_BY = USERS_1.USER_ID

