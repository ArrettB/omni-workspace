CREATE VIEW dbo.SCH_VACATIONS_ALL_V
AS
SELECT     dbo.RESOURCES_V.ORGANIZATION_ID, CAST(dbo.RESOURCES_V.RESOURCE_ID AS varchar(30)) 
                      + ':' + ISNULL(CAST(dbo.SCH_VACATION_V.SCH_RESOURCE_ID AS varchar(30)), '') AS res_sch_id, dbo.RESOURCES_V.RESOURCE_ID, 
                      dbo.RESOURCES_V.NAME AS resource_name, dbo.RESOURCES_V.RES_CATEGORY_TYPE_ID, dbo.RESOURCES_V.res_cat_type_code, 
                      dbo.RESOURCES_V.res_cat_type_name, dbo.RESOURCES_V.RESOURCE_TYPE_ID, dbo.RESOURCES_V.resource_type_code, 
                      dbo.RESOURCES_V.resource_type_name, dbo.RESOURCES_V.UNIQUE_FLAG, dbo.RESOURCES_V.USER_ID, dbo.RESOURCES_V.user_full_name, 
                      dbo.RESOURCES_V.user_contact_id, dbo.RESOURCES_V.user_contact_name, dbo.RESOURCES_V.EMPLOYMENT_TYPE_ID, 
                      dbo.RESOURCES_V.employment_type_code, dbo.RESOURCES_V.employment_type_name, dbo.RESOURCES_V.EXT_VENDOR_ID, 
                      dbo.RESOURCES_V.ACTIVE_FLAG, dbo.RESOURCES_V.FOREMAN_FLAG, dbo.RESOURCES_V.PIN, dbo.RESOURCES_V.NOTES, 
                      dbo.RESOURCES_V.DATE_CREATED, dbo.RESOURCES_V.CREATED_BY, dbo.RESOURCES_V.modified_by_name, dbo.RESOURCES_V.MODIFIED_BY, 
                      dbo.RESOURCES_V.DATE_MODIFIED, dbo.RESOURCES_V.created_by_name, dbo.SCH_VACATION_V.SCH_RESOURCE_ID, 
                      dbo.SCH_VACATION_V.JOB_ID, dbo.SCH_VACATION_V.JOB_NO, dbo.SCH_VACATION_V.SERVICE_ID, dbo.SCH_VACATION_V.SERVICE_NO, 
                      dbo.SCH_VACATION_V.HIDDEN_SERVICE_ID, dbo.SCH_VACATION_V.RES_STATUS_TYPE_ID, dbo.SCH_VACATION_V.res_status_type_code, 
                      dbo.SCH_VACATION_V.res_status_type_name, dbo.SCH_VACATION_V.REASON_TYPE_ID, dbo.SCH_VACATION_V.reason_type_code, 
                      dbo.SCH_VACATION_V.reason_type_name, dbo.SCH_VACATION_V.RES_START_DATE, dbo.SCH_VACATION_V.RES_START_TIME, 
                      dbo.SCH_VACATION_V.RES_END_DATE, dbo.SCH_VACATION_V.sch_date_created, dbo.SCH_VACATION_V.sch_created_by, 
                      dbo.SCH_VACATION_V.sch_created_by_name, dbo.SCH_VACATION_V.sch_date_modified, dbo.SCH_VACATION_V.sch_modified_by, 
                      dbo.SCH_VACATION_V.sch_modified_by_name
FROM         dbo.RESOURCES_V LEFT OUTER JOIN
                      dbo.SCH_VACATION_V ON dbo.RESOURCES_V.RESOURCE_ID = dbo.SCH_VACATION_V.RESOURCE_ID

