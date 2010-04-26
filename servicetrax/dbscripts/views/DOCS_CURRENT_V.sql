
CREATE VIEW dbo.DOCS_CURRENT_V
AS
SELECT     *
FROM         dbo.DOCUMENTS_V dv
WHERE     (VERSION_ID =
                          (SELECT     version_id
                            FROM          versions
                            WHERE      document_id = dv.document_id AND date_created =
                                                       (SELECT     MAX(date_created)
                                                         FROM          versions
                                                         WHERE      document_id = dv.document_id)))


