CREATE VIEW dbo.LOADING_DOCK_TYPES_V
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'loading_dock_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')

