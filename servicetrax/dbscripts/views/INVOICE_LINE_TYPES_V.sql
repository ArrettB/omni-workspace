CREATE VIEW dbo.INVOICE_LINE_TYPES_V
AS
SELECT     dbo.LOOKUPS.LOOKUP_ID, dbo.LOOKUPS.CODE AS invoice_type_code, dbo.LOOKUPS.NAME, dbo.LOOKUP_TYPES.CODE AS Lookup_type_code, 
                      dbo.LOOKUPS.SEQUENCE_NO
FROM         dbo.LOOKUP_TYPES INNER JOIN
                      dbo.LOOKUPS ON dbo.LOOKUP_TYPES.LOOKUP_TYPE_ID = dbo.LOOKUPS.LOOKUP_TYPE_ID
WHERE     (dbo.LOOKUP_TYPES.CODE = 'invoice_line_type') AND (dbo.LOOKUPS.ACTIVE_FLAG <> 'N') AND (dbo.LOOKUP_TYPES.ACTIVE_FLAG <> 'N')

