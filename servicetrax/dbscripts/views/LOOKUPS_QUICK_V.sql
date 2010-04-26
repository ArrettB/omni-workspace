CREATE VIEW dbo.LOOKUPS_QUICK_V
AS
SELECT     TOP 100 PERCENT LOOKUP_TYPE_ID, type_name, SEQUENCE_NO, lookup_name, lookup_code, LOOKUP_ID
FROM         dbo.LOOKUPS_V
WHERE     (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
ORDER BY type_name, SEQUENCE_NO

