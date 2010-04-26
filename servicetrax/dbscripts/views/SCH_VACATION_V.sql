
CREATE VIEW dbo.SCH_VACATION_V
AS
SELECT     res_sch_id, RESOURCE_ID, SCH_RESOURCE_ID, WEEKEND_SCH_RESOURCE_ID, resource_name, JOB_ID, JOB_NO, SERVICE_ID, 
                      HIDDEN_SERVICE_ID, actual_service_id, SERVICE_NO, FOREMAN_RESOURCE_ID, FOREMAN_USER_ID, RES_STATUS_TYPE_ID, 
                      res_status_type_code, res_status_type_name, REASON_TYPE_ID, reason_type_code, reason_type_name, RES_CATEGORY_TYPE_ID, 
                      res_cat_type_code, res_cat_type_name, RESOURCE_TYPE_ID, resource_type_code, resource_type_name, UNIQUE_FLAG, NOTES, PIN, 
                      FOREMAN_FLAG, ACTIVE_FLAG, EXT_VENDOR_ID, employment_type_name, employment_type_code, EMPLOYMENT_TYPE_ID, USER_ID, 
                      user_full_name, user_contact_id, user_contact_name, res_modified_by_name, res_modified_by, res_date_modified, res_created_by_name, 
                      res_created_by, res_date_created, sch_foreman_flag, RES_START_DATE, RES_START_TIME, RES_END_DATE, DATE_CONFIRMED, RESOURCE_QTY, 
                      SCH_NOTES, WEEKEND_FLAG, sch_date_created, sch_created_by, sch_created_by_name, sch_date_modified, sch_modified_by, 
                      sch_modified_by_name, unconfirmed_flag
FROM         dbo.SCH_RESOURCES_V
WHERE     (reason_type_code = 'vacation')


