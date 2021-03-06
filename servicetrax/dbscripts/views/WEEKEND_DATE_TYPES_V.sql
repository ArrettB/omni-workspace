CREATE VIEW dbo.WEEKEND_DATE_TYPES_V
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name, 
                      ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'date_type') AND (lookup_code = 'this_weekend' OR
                      lookup_code = 'this_friday' OR
                      lookup_code = 'this_saturday' OR
                      lookup_code = 'this_sunday') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')

