
CREATE VIEW dbo.DOCUMENTS_V
AS
SELECT     dbo.FORMATS.NAME AS format_name, dbo.DOCUMENTS.NAME AS document_name, dbo.VERSIONS.VERSION_ID, 
                      dbo.VERSIONS.COMMENTS AS version_comments, dbo.VERSIONS.CODE AS version_code, 
                      V_C_USER.FIRST_NAME + ' ' + V_C_USER.LAST_NAME AS version_created_by_name, dbo.VERSIONS.DATE_CREATED AS version_date_created, 
                      CONVERT(varchar, dbo.VERSIONS.DATE_CREATED) AS version_date_created_str, 
                      D_L_USER.FIRST_NAME + ' ' + D_L_USER.LAST_NAME AS locked_by_name, dbo.DOCUMENTS.LOCKED_BY, dbo.DOCUMENTS.CODE, 
                      dbo.DOCUMENTS.FORMAT_ID, dbo.VERSIONS.CREATED_BY, dbo.VERSIONS.NUM_DOWNLOADS, dbo.DOCUMENTS.DOCUMENT_ID, 
                      dbo.DOCUMENTS.PROJECT_ID, dbo.DOCUMENTS.DATE_LOCKED, dbo.FORMATS.EXTENSION
FROM         dbo.DOCUMENTS INNER JOIN
                      dbo.VERSIONS ON dbo.DOCUMENTS.DOCUMENT_ID = dbo.VERSIONS.DOCUMENT_ID INNER JOIN
                      dbo.FORMATS ON dbo.DOCUMENTS.FORMAT_ID = dbo.FORMATS.FORMAT_ID INNER JOIN
                      dbo.USERS V_C_USER ON dbo.VERSIONS.CREATED_BY = V_C_USER.USER_ID LEFT OUTER JOIN
                      dbo.USERS D_L_USER ON dbo.DOCUMENTS.LOCKED_BY = D_L_USER.USER_ID


