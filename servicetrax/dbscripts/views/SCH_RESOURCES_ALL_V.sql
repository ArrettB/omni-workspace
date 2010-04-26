
CREATE VIEW dbo.SCH_RESOURCES_ALL_V
AS
SELECT     CAST(dbo.RESOURCES_V.RESOURCE_ID AS varchar(30)) + ':' + ISNULL(CAST(dbo.SCH_RESOURCES.SCH_RESOURCE_ID AS varchar(30)), '') 
                      AS res_sch_id, dbo.RESOURCES_V.RESOURCE_ID, dbo.SCH_RESOURCES.SCH_RESOURCE_ID, 
                      dbo.SCH_RESOURCES.WEEKEND_SCH_RESOURCE_ID, dbo.SCH_RESOURCES.JOB_ID, dbo.JOBS.JOB_NO, dbo.SCH_RESOURCES.SERVICE_ID, 
                      dbo.SERVICES.SERVICE_NO, dbo.SCH_RESOURCES.HIDDEN_SERVICE_ID, dbo.JOBS.JOB_TYPE_ID, JOB_TYPES.CODE AS job_type_code, 
                      JOB_TYPES.NAME AS job_type_name, dbo.SCH_RESOURCES.RES_STATUS_TYPE_ID, RES_STATUS_TYPE.CODE AS res_status_type_code, 
                      ISNULL(RES_STATUS_TYPE.NAME, 'Available') AS res_status_type_name, dbo.SCH_RESOURCES.REASON_TYPE_ID, 
                      REASON_TYPE.CODE AS reason_type_code, REASON_TYPE.NAME AS reason_type_name, ISNULL(dbo.SCH_RESOURCES.FOREMAN_FLAG, 'N') 
                      AS sch_foreman_flag, dbo.SCH_RESOURCES.send_to_pda_flag, dbo.SCH_RESOURCES.RES_START_DATE, dbo.SCH_RESOURCES.RES_START_TIME, dbo.SCH_RESOURCES.RES_END_DATE, 
                      dbo.SCH_RESOURCES.DATE_CONFIRMED, dbo.SCH_RESOURCES.RESOURCE_QTY, dbo.SCH_RESOURCES.SCH_NOTES, 
                      ISNULL(dbo.SCH_RESOURCES.WEEKEND_FLAG, 'N') AS weekend_flag, dbo.SCH_RESOURCES.DATE_CREATED AS sch_date_created, 
                      dbo.SCH_RESOURCES.CREATED_BY AS sch_created_by, CREATED_BY.FIRST_NAME + ' ' + CREATED_BY.LAST_NAME AS sch_created_by_name, 
                      dbo.SCH_RESOURCES.DATE_MODIFIED AS sch_date_modified, dbo.SCH_RESOURCES.MODIFIED_BY AS sch_modified_by, 
                      MODIFIED_BY.FIRST_NAME + ' ' + MODIFIED_BY.LAST_NAME AS sch_modified_by_name, dbo.RESOURCES_V.NAME AS resource_name, 
                      dbo.RESOURCES_V.RES_CATEGORY_TYPE_ID, dbo.RESOURCES_V.res_cat_type_code, dbo.RESOURCES_V.res_cat_type_name, 
                      dbo.RESOURCES_V.RESOURCE_TYPE_ID, dbo.RESOURCES_V.resource_type_code, dbo.RESOURCES_V.resource_type_name, 
                      dbo.RESOURCES_V.UNIQUE_FLAG, dbo.RESOURCES_V.NOTES, dbo.RESOURCES_V.PIN, dbo.RESOURCES_V.FOREMAN_FLAG, 
                      dbo.RESOURCES_V.ACTIVE_FLAG, dbo.RESOURCES_V.EXT_VENDOR_ID, dbo.RESOURCES_V.employment_type_name, 
                      dbo.RESOURCES_V.employment_type_code, dbo.RESOURCES_V.EMPLOYMENT_TYPE_ID, dbo.RESOURCES_V.USER_ID, 
                      dbo.JOBS.FOREMAN_RESOURCE_ID, FOREMAN_USER.USER_ID AS FOREMAN_USER_ID, dbo.RESOURCES_V.user_full_name, 
                      dbo.RESOURCES_V.user_contact_id, dbo.RESOURCES_V.user_contact_name, dbo.RESOURCES_V.modified_by_name AS res_modified_by_name, 
                      dbo.RESOURCES_V.MODIFIED_BY AS res_modified_by, dbo.RESOURCES_V.DATE_MODIFIED AS res_date_modified, 
                      dbo.RESOURCES_V.created_by_name AS res_created_by_name, dbo.RESOURCES_V.CREATED_BY AS res_created_by, 
                      dbo.RESOURCES_V.DATE_CREATED AS res_date_created, CONVERT(varchar, dbo.SCH_RESOURCES.RES_START_TIME, 8) AS res_start_time_only, 
                      CONVERT(varchar, dbo.SCH_RESOURCES.RES_END_TIME, 8) AS res_end_time, (CASE reason_type.code WHEN 'unconfirmed' THEN 'Y' ELSE 'N' END)
                       AS unconfirmed_flag
FROM         dbo.USERS FOREMAN_USER RIGHT OUTER JOIN
                      dbo.LOOKUPS JOB_TYPES RIGHT OUTER JOIN
                      dbo.JOBS ON JOB_TYPES.LOOKUP_ID = dbo.JOBS.JOB_TYPE_ID LEFT OUTER JOIN
                      dbo.RESOURCES ON dbo.JOBS.FOREMAN_RESOURCE_ID = dbo.RESOURCES.RESOURCE_ID RIGHT OUTER JOIN
                      dbo.LOOKUPS RES_STATUS_TYPE RIGHT OUTER JOIN
                      dbo.USERS CREATED_BY RIGHT OUTER JOIN
                      dbo.USERS MODIFIED_BY RIGHT OUTER JOIN
                      dbo.SCH_RESOURCES ON MODIFIED_BY.USER_ID = dbo.SCH_RESOURCES.MODIFIED_BY ON 
                      CREATED_BY.USER_ID = d
