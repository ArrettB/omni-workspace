
CREATE VIEW dbo.YES_NO_TYPE_V
AS
SELECT     dbo.LOOKUPS.LOOKUP_ID, dbo.LOOKUPS.CODE AS yes_no_type_code, dbo.LOOKUPS.NAME, dbo.LOOKUP_TYPES.CODE AS Lookup_type_code, 
                      dbo.LOOKUPS.SEQUENCE_NO, dbo.LOOKUPS.ACTIVE_FLAG, dbo.LOOKUP_TYPES.ACTIVE_FLAG AS TYPE_ACTIVE_FLAG
FROM         dbo.LOOKUP_TYPES INNER JOIN
                      dbo.LOOKUPS ON dbo.LOOKUP_TYPES.LOOKUP_TYPE_ID = dbo.LOOKUPS.LOOKUP_TYPE_ID
WHERE     (dbo.LOOKUP_TYPES.CODE = 'yes_no_type') AND (dbo.LOOKUPS.ACTIVE_FLAG = 'Y') AND (dbo.LOOKUP_TYPES.ACTIVE_FLAG = 'Y')


