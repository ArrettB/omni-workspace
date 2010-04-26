CREATE VIEW dbo.SCH_RESOURCES_ALL_JOBS_V
AS
SELECT     dbo.SCH_RESOURCES_V.res_sch_id, dbo.SCH_RESOURCES_V.ORGANIZATION_ID, dbo.JOBS.JOB_ID, dbo.JOBS.JOB_NO, 
                      dbo.SCH_RESOURCES_V.SERVICE_ID, dbo.SCH_RESOURCES_V.SERVICE_NO, dbo.SCH_RESOURCES_V.HIDDEN_SERVICE_ID, 
                      dbo.SCH_RESOURCES_V.SCH_RESOURCE_ID, dbo.SCH_RESOURCES_V.RESOURCE_ID, dbo.SCH_RESOURCES_V.resource_name, 
                      dbo.SCH_RESOURCES_V.RES_STATUS_TYPE_ID, dbo.SCH_RESOURCES_V.res_status_type_code, dbo.SCH_RESOURCES_V.res_status_type_name, 
                      dbo.SCH_RESOURCES_V.REASON_TYPE_ID, dbo.SCH_RESOURCES_V.reason_type_code, dbo.SCH_RESOURCES_V.reason_type_name, 
                      dbo.SCH_RESOURCES_V.RES_CATEGORY_TYPE_ID, dbo.SCH_RESOURCES_V.res_cat_type_code, dbo.SCH_RESOURCES_V.res_cat_type_name, 
                      dbo.SCH_RESOURCES_V.RESOURCE_TYPE_ID, dbo.SCH_RESOURCES_V.resource_type_code, dbo.SCH_RESOURCES_V.resource_type_name, 
                      dbo.SCH_RESOURCES_V.UNIQUE_FLAG, dbo.SCH_RESOURCES_V.NOTES, dbo.SCH_RESOURCES_V.PIN, dbo.SCH_RESOURCES_V.FOREMAN_FLAG, 
                      dbo.SCH_RESOURCES_V.ACTIVE_FLAG, dbo.SCH_RESOURCES_V.EXT_VENDOR_ID, dbo.SCH_RESOURCES_V.employment_type_name, 
                      dbo.SCH_RESOURCES_V.employment_type_code, dbo.SCH_RESOURCES_V.EMPLOYMENT_TYPE_ID, dbo.SCH_RESOURCES_V.USER_ID, 
                      dbo.SCH_RESOURCES_V.user_full_name, dbo.SCH_RESOURCES_V.user_contact_id, dbo.SCH_RESOURCES_V.user_contact_name, 
                      dbo.SCH_RESOURCES_V.res_modified_by_name, dbo.SCH_RESOURCES_V.res_modified_by, dbo.SCH_RESOURCES_V.res_date_modified, 
                      dbo.SCH_RESOURCES_V.res_created_by_name, dbo.SCH_RESOURCES_V.res_created_by, dbo.SCH_RESOURCES_V.res_date_created, 
                      dbo.SCH_RESOURCES_V.sch_foreman_flag, dbo.SCH_RESOURCES_V.RES_START_DATE, dbo.SCH_RESOURCES_V.RES_START_TIME, 
                      dbo.SCH_RESOURCES_V.RES_END_DATE, dbo.SCH_RESOURCES_V.DATE_CONFIRMED, dbo.SCH_RESOURCES_V.RESOURCE_QTY, 
                      dbo.SCH_RESOURCES_V.SCH_NOTES, dbo.SCH_RESOURCES_V.sch_date_created, dbo.SCH_RESOURCES_V.sch_created_by, 
                      dbo.SCH_RESOURCES_V.sch_created_by_name, dbo.SCH_RESOURCES_V.sch_date_modified, dbo.SCH_RESOURCES_V.sch_modified_by, 
                      dbo.SCH_RESOURCES_V.sch_modified_by_name, dbo.SCH_RESOURCES_V.RES_END_TIME, dbo.SCH_RESOURCES_V.WEEKEND_FLAG, 
                      dbo.SCH_RESOURCES_V.report_to_name, dbo.SCH_RESOURCES_V.unconfirmed_flag, dbo.SCH_RESOURCES_V.FOREMAN_RESOURCE_ID, 
                      dbo.SCH_RESOURCES_V.actual_service_id, dbo.SCH_RESOURCES_V.WEEKEND_SCH_RESOURCE_ID, dbo.SCH_RESOURCES_V.JOB_TYPE_ID, 
                      dbo.SCH_RESOURCES_V.job_type_code, dbo.SCH_RESOURCES_V.job_type_name, dbo.SCH_RESOURCES_V.foreman_resource_name, 
                      dbo.SCH_RESOURCES_V.foreman_user_id, dbo.SCH_RESOURCES_V.DATE_TYPE_ID, dbo.SCH_RESOURCES_V.SERV_STATUS_TYPE_ID, 
                      dbo.SCH_RESOURCES_V.serv_status_type_code, dbo.SCH_RESOURCES_V.serv_status_type_name, 
                      dbo.SCH_RESOURCES_V.serv_status_type_seq_no, dbo.SCH_RESOURCES_V.SEND_TO_PDA_FLAG
FROM         dbo.JOBS LEFT OUTER JOIN
                      dbo.SCH_RESOURCES_V ON dbo.JOBS.JOB_ID = dbo.SCH_RESOURCES_V.JOB_ID



