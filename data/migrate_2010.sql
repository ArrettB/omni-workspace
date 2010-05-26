/**
 * Add the columns to service_lines for timekeeping
 * and the column to requests for the plan_location_id
 */
/*
 * Alter the requests table and add the foreign key
 */
ALTER TABLE [dbo].[REQUESTS]
   ADD [PLAN_LOCATION_TYPE_ID]  [NUMERIC](18,0)
GO

ALTER TABLE [REQUESTS] ADD CONSTRAINT [FK_REQUESTS_LOOKUPS_PLAN_LOCATION_TYPE] 
    FOREIGN KEY ([PLAN_LOCATION_TYPE_ID]) REFERENCES [LOOKUPS] ([LOOKUP_ID])
GO


/*
 * Alter the requests table and add the foreign key
 */
ALTER TABLE [dbo].[SERVICE_LINES]
   ADD [START_TIME]  [INTEGER]
GO
ALTER TABLE [dbo].[SERVICE_LINES]
   ADD [END_TIME]  [INTEGER]
GO
ALTER TABLE [dbo].[SERVICE_LINES]
   ADD [BREAK_TIME_MINUTES]  [INTEGER]
GO

/*
 * make the hotsheet a request type
 */
INSERT INTO dbo.LOOKUPS (    
    LOOKUP_TYPE_ID,             
    CODE,                                  
    NAME,                                           
    SEQUENCE_NO,                                        
    ACTIVE_FLAG,                                                    
    UPDATABLE_FLAG,                                                         
    PARENT_LOOKUP_ID,                                                           
    EXT_ID,                                                                             
    ATTRIBUTE1,
    ATTRIBUTE2,
    ATTRIBUTE3,
    DATE_CREATED,  
    CREATED_BY,            
    DATE_MODIFIED,                 
    MODIFIED_BY                            
) VALUES (                                             
    68,
    'hot_sheet',
    'Hot Sheet',                                                                           
    6,
    'Y',
    'Y',
    null,  -- parent_lookup_id
    null,  -- ext_id
    null,  -- attribute1
    null,  -- attribute2
    null,  -- attribute3
    current_timestamp,
    2,    
    current_timestamp,
    2
)   
GO

/* 
 * Recreate this view to have the start time, end time, and break time information.
 */
DROP VIEW [dbo].[TIME_CAPTURE_V]
GO

CREATE VIEW [dbo].[TIME_CAPTURE_V]
AS
SELECT dbo.SERVICE_LINES.ORGANIZATION_ID, 
       dbo.SERVICE_LINES.TC_JOB_NO, 
       dbo.SERVICE_LINES.TC_SERVICE_NO, 
       dbo.SERVICE_LINES.TC_SERVICE_LINE_NO, 
       dbo.SERVICE_LINES.BILL_JOB_NO, 
       dbo.SERVICE_LINES.BILL_SERVICE_NO, 
       dbo.SERVICE_LINES.BILL_SERVICE_LINE_NO, 
       dbo.JOBS_V.JOB_NAME, 
       dbo.SERVICE_LINES.RESOURCE_NAME, 
       dbo.SERVICE_LINES.ITEM_NAME, 
       dbo.JOBS_V.billing_user_name, 
       dbo.JOBS_V.foreman_resource_name, 
       dbo.SERVICE_LINES.TC_JOB_ID, 
       dbo.SERVICE_LINES.TC_SERVICE_ID, 
       dbo.SERVICE_LINES.BILL_JOB_ID, 
       dbo.SERVICE_LINES.BILL_SERVICE_ID, 
       dbo.SERVICE_LINES.PH_SERVICE_ID, 
       dbo.SERVICE_LINES.SERVICE_LINE_ID, 
       CAST(dbo.SERVICES.JOB_ID AS varchar) + '-' + CAST(dbo.SERVICE_LINES.ITEM_ID AS varchar) + '-' + CAST(dbo.SERVICE_LINES.STATUS_ID AS varchar) AS job_item_status_id, 
       CAST(dbo.SERVICE_LINES.TC_SERVICE_ID AS varchar) + '-' + CAST(dbo.SERVICE_LINES.STATUS_ID AS varchar) AS service_status_id, 
       CAST(dbo.SERVICES.SERVICE_ID AS varchar) + '-' + CAST(dbo.SERVICE_LINES.ITEM_ID AS varchar) + '-' + CAST(dbo.SERVICE_LINES.STATUS_ID AS varchar) AS service_item_status_id, 
       dbo.JOBS_V.BILLING_USER_ID, 
       dbo.JOBS_V.foreman_user_id, 
       dbo.SERVICE_LINES.SERVICE_LINE_DATE, 
       dbo.SERVICE_LINES.SERVICE_LINE_DATE_VARCHAR, 
       dbo.SERVICE_LINES.SERVICE_LINE_WEEK, 
       dbo.SERVICE_LINES.SERVICE_LINE_WEEK_VARCHAR, 
       dbo.JOBS_V.job_status_type_code, 
       dbo.JOBS_V.job_status_type_name, 
       SERV_STATUS_TYPES.CODE AS serv_status_type_code, 
       SERV_STATUS_TYPES.NAME AS serv_status_type_name, 
       dbo.SERVICE_LINES.STATUS_ID, 
       dbo.SERVICE_LINE_STATUSES.NAME AS status_name, 
       dbo.SERVICE_LINE_STATUSES.CODE AS status_code, 
       dbo.SERVICE_LINES.EXPORTED_FLAG, 
       dbo.SERVICE_LINES.BILLED_FLAG, 
       dbo.SERVICE_LINES.POSTED_FLAG, 
       dbo.SERVICE_LINES.POOLED_FLAG, 
       dbo.SERVICE_LINES.RESOURCE_ID, 
       dbo.SERVICE_LINES.ITEM_ID, 
       dbo.SERVICE_LINES.ITEM_TYPE_CODE, 
       dbo.SERVICE_LINES.BILLABLE_FLAG, 
       dbo.SERVICE_LINES.TC_QTY, 
       dbo.SERVICE_LINES.TC_RATE, 
       dbo.SERVICE_LINES.tc_total, 
       dbo.SERVICE_LINES.PAYROLL_QTY, 
       dbo.SERVICE_LINES.PAYROLL_RATE, 
       dbo.SERVICE_LINES.payroll_total, 
       dbo.SERVICE_LINES.EXT_PAY_CODE, 
       dbo.SERVICE_LINES.EXPENSE_QTY, 
       dbo.SERVICE_LINES.EXPENSE_RATE, 
       dbo.SERVICE_LINES.expense_total, 
       dbo.SERVICE_LINES.BILL_QTY, 
       dbo.SERVICE_LINES.BILL_RATE, 
       dbo.SERVICE_LINES.bill_total, 
       dbo.SERVICE_LINES.BILL_EXP_QTY, 
       dbo.SERVICE_LINES.BILL_EXP_RATE, 
       dbo.SERVICE_LINES.bill_exp_total, 
       dbo.SERVICE_LINES.BILL_HOURLY_QTY, 
       dbo.SERVICE_LINES.BILL_HOURLY_RATE, 
       dbo.SERVICE_LINES.bill_hourly_total, 
       dbo.SERVICE_LINES.ALLOCATED_QTY, 
       dbo.SERVICE_LINES.INTERNAL_REQ_FLAG, 
       dbo.SERVICE_LINES.PARTIALLY_ALLOCATED_FLAG, 
       dbo.SERVICE_LINES.FULLY_ALLOCATED_FLAG, 
       dbo.SERVICE_LINES.PALM_REP_ID, 
       dbo.SERVICE_LINES.ENTERED_DATE, 
       dbo.SERVICE_LINES.ENTERED_BY, 
       USERS_1.FULL_NAME AS entered_by_name, 
       dbo.SERVICE_LINES.ENTRY_METHOD, 
       dbo.SERVICE_LINES.OVERRIDE_DATE, 
       dbo.SERVICE_LINES.OVERRIDE_BY, 
       USERS_1.FULL_NAME AS override_by_name, 
       dbo.SERVICE_LINES.OVERRIDE_REASON, 
       dbo.SERVICE_LINES.VERIFIED_DATE, 
       dbo.SERVICE_LINES.VERIFIED_BY, 
       USERS_2.FULL_NAME AS verified_by_name, 
       dbo.SERVICES.DESCRIPTION AS service_description, 
       dbo.SERVICE_LINES.DATE_CREATED, 
       dbo.SERVICE_LINES.CREATED_BY, 
       USERS_3.FULL_NAME AS created_by_name, 
       dbo.SERVICE_LINES.DATE_MODIFIED, 
       dbo.SERVICE_LINES.MODIFIED_BY, 
       USERS_4.FULL_NAME AS modified_by_name,
       dbo.SERVICES.service_no,
       ( CASE WHEN dbo.SERVICE_LINES.START_TIME >= 1200 THEN
                ((dbo.SERVICE_LINES.START_TIME - 1200 ) / 100 )
            ELSE (dbo.SERVICE_LINES.START_TIME / 100 ) END )as start_time_hour,
       ( dbo.SERVICE_LINES.START_TIME % 100 ) as start_time_minutes,
       ( CASE WHEN dbo.SERVICE_LINES.START_TIME >= 1200 THEN 'PM' ELSE 'AM' END ) as start_time_AMPM,
       ( CASE WHEN dbo.SERVICE_LINES.END_TIME >= 1200 THEN
           ((dbo.SERVICE_LINES.END_TIME - 1200 ) / 100 )
            ELSE (dbo.SERVICE_LINES.END_TIME / 100 ) END ) as end_time_hour,
       ( dbo.SERVICE_LINES.END_TIME % 100 ) as end_time_minutes,
       ( CASE WHEN dbo.SERVICE_LINES.END_TIME >= 1200 THEN 'PM' ELSE 'AM' END ) as end_time_AMPM,
       ( dbo.SERVICE_LINES.BREAK_TIME_MINUTES / 60 ) AS lunch_dinner_hours,
       ( dbo.SERVICE_LINES.BREAK_TIME_MINUTES % 60 ) as lunch_dinner_minutes
  FROM dbo.LOOKUPS SERV_STATUS_TYPES RIGHT OUTER JOIN
       dbo.JOBS_V RIGHT OUTER JOIN
       dbo.SERVICES ON dbo.JOBS_V.JOB_ID = dbo.SERVICES.JOB_ID ON SERV_STATUS_TYPES.LOOKUP_ID = dbo.SERVICES.SERV_STATUS_TYPE_ID RIGHT OUTER JOIN
       dbo.SERVICE_LINE_STATUSES RIGHT OUTER JOIN
       dbo.USERS USERS_4 RIGHT OUTER JOIN
       dbo.USERS USERS_5 RIGHT OUTER JOIN
       dbo.USERS USERS_1 RIGHT OUTER JOIN
       dbo.SERVICE_LINES ON USERS_1.USER_ID = dbo.SERVICE_LINES.OVERRIDE_BY ON USERS_5.USER_ID = dbo.SERVICE_LINES.ENTERED_BY LEFT OUTER JOIN
       dbo.USERS USERS_2 ON dbo.SERVICE_LINES.VERIFIED_BY = USERS_2.USER_ID ON USERS_4.USER_ID = dbo.SERVICE_LINES.MODIFIED_BY LEFT OUTER JOIN
       dbo.USERS USERS_3 ON dbo.SERVICE_LINES.CREATED_BY = USERS_3.USER_ID ON dbo.SERVICE_LINE_STATUSES.STATUS_ID = dbo.SERVICE_LINES.STATUS_ID ON dbo.SERVICES.SERVICE_ID = dbo.SERVICE_LINES.TC_SERVICE_ID
GO

/* 
 * Recreate this view to have the hot sheets information.
 */
DROP VIEW [dbo].[projects_all_requests_v]
GO

CREATE VIEW [dbo].[projects_all_requests_v]
AS
SELECT p_v.project_id,
       p_v.project_no,
       r.request_id,
       r.request_no,
       q_v.quote_id,
       q_v.quote_no,
       CONVERT(VARCHAR, p_v.project_no) + '-' + CONVERT(VARCHAR, r.request_no) + '.' + CONVERT(VARCHAR, r.version_no) AS record_no,
       r.request_id AS record_id,
       r.request_no AS record_seq_no,
       r.version_no,
       dbo.versions_max_no_v.max_version_no,
       r.request_type_id AS record_type_id,
       request_type.code AS record_type_code,
       request_type.name AS record_type_name,
       request_type.sequence_no AS record_type_seq_no,
       r.request_status_type_id AS record_status_type_id,
       request_status_type.code AS record_status_type_code,
       request_status_type.name AS record_status_type_name,
       r.is_sent AS record_is_sent,
       ISNULL(r.date_modified, r.date_created) AS record_last_modified,
       r.date_created AS record_created,
       r.date_modified AS record_modified,
       p_v.project_status_type_id,
       p_v.project_status_type_code,
       p_v.project_status_type_name,
       p_v.parent_customer_id,
       p_v.organization_id,
       p_v.ext_dealer_id,
       p_v.dealer_name,
       p_v.ext_customer_id,
       p_v.customer_id,
       p_v.customer_name,
       p_v.end_user_id,
       p_v.end_user_name,
       p_v.refusal_email_info,
       p_v.survey_location,
       p_v.job_name,
       r.quote_request_id,
       r.request_type_id,
       request_type.code AS request_type_code,
       request_type.name AS request_type_name,
       r.request_status_type_id,
       request_status_type.code AS request_status_type_code,
       request_status_type.name AS request_status_type_name,
       r.is_sent AS request_is_sent,
       r.dealer_po_no,
       r.customer_po_no,
       r.dealer_project_no,
       r.design_project_no,
       r.est_start_date,
       CONVERT(VARCHAR(12), r.est_start_date, 101) AS est_start_date_varchar,
       r.a_m_contact_id,
       r.a_m_sales_contact_id,
       r.customer_contact_id,
       r.customer_contact2_id,
       r.customer_contact3_id,
       r.customer_contact4_id,
       r.d_sales_rep_contact_id,
       r.d_sales_sup_contact_id,
       r.d_designer_contact_id,
       r.d_proj_mgr_contact_id,
       r.a_m_install_sup_contact_id,
       r.a_d_designer_contact_id,
       r.gen_contractor_contact_id,
       r.electrician_contact_id,
       r.data_phone_contact_id,
       r.phone_contact_id,
       r.carpet_layer_contact_id,
       r.bldg_mgr_contact_id,
       r.security_contact_id,
       r.mover_contact_id,
       r.other_contact_id,
       r.furniture1_contact_id,
       r.furniture2_contact_id,
       r.is_quoted,
       r.description,
       r.approver_contact_id,
       r.alt_customer_contact_id,
       q_v.is_sent AS quote_is_sent,
       q_v.quote_type_id,
       q_v.quote_type_code,
       q_v.quote_type_name,
       q_v.quote_status_type_id,
       q_v.quote_status_type_code,
       q_v.quote_status_type_name,
       q_v.date_quoted,
       q_v.quote_total,
       q_v.quoted_by_user_id,
       q_v.quoted_by_user_name,
       p_v.is_new
  FROM dbo.projects_v2 p_v LEFT OUTER JOIN
       dbo.requests r ON p_v.project_id = r.project_id LEFT OUTER JOIN
       dbo.lookups request_type ON r.request_type_id = request_type.lookup_id LEFT OUTER JOIN
       dbo.lookups request_status_type ON r.request_status_type_id = request_status_type.lookup_id LEFT OUTER JOIN
       dbo.quotes_v q_v ON r.request_id = q_v.request_id  LEFT OUTER JOIN
       dbo.versions_max_no_v ON r.request_no = dbo.versions_max_no_v.request_no AND r.project_id = dbo.versions_max_no_v.project_id
UNION
SELECT p_v.project_id,
       p_v.project_no,
       r.request_id,
       r.request_no,
       q_v.quote_id,
       q_v.quote_no,
       CONVERT(VARCHAR, p_v.project_no) + '-' + CONVERT(VARCHAR, q_v.quote_no) + '.' + ISNULL(CONVERT(VARCHAR, q_v.version),' ') AS record_no,
       q_v.quote_id record_id,
       q_v.quote_no AS record_seq_no,
       1 version_no,
       1 max_version_no,
       q_v.request_type_id AS record_type_id,
       q_v.request_type_code AS record_type_code,
       q_v.request_type_name AS record_type_name,
       q_v.request_type_sequence_no AS record_type_seq_no,
       q_v.quote_status_type_id record_status_type_id,
       q_v.quote_status_type_code AS record_status_type_code,
       q_v.quote_status_type_name AS record_status_type_name,
       q_v.is_sent AS record_is_sent,
       ISNULL(q_v.date_modified, q_v.date_created) AS record_date,
       q_v.date_created AS record_created,
       q_v.date_modified AS record_modified,
       p_v.project_status_type_id,
       p_v.project_status_type_code,
       p_v.project_status_type_name,
       p_v.parent_customer_id,
       p_v.organization_id,
       p_v.ext_dealer_id,
       p_v.dealer_name,
       p_v.ext_customer_id,
       p_v.customer_id,
       p_v.customer_name,
       p_v.end_user_id,
       p_v.end_user_name,
       p_v.refusal_email_info,
       p_v.survey_location,
       p_v.job_name,
       r.quote_request_id,
       r.request_type_id,
       request_type.code AS request_type_code,
       request_type.name AS request_type_name,
       r.request_status_type_id,
       request_status_type.code AS request_status_type_code,
       request_status_type.name AS request_status_type_name,
       r.is_sent AS request_is_sent,
       r.dealer_po_no,
       r.customer_po_no,
       r.dealer_project_no,
       r.design_project_no,
       r.est_start_date,
       CONVERT(VARCHAR(12), r.est_start_date, 101) AS est_start_date_varchar,
       r.a_m_contact_id,
       r.a_m_sales_contact_id,
       r.customer_contact_id,
       r.customer_contact2_id,
       r.customer_contact3_id,
       r.customer_contact4_id,
       r.d_sales_rep_contact_id,
       r.d_sales_sup_contact_id,
       r.d_designer_contact_id,
       r.d_proj_mgr_contact_id,
       r.a_m_install_sup_contact_id,
       r.a_d_designer_contact_id,
       r.gen_contractor_contact_id,
       r.electrician_contact_id,
       r.data_phone_contact_id,
       r.phone_contact_id,
       r.carpet_layer_contact_id,
       r.bldg_mgr_contact_id,
       r.security_contact_id,
       r.mover_contact_id,
       r.other_contact_id,
       r.furniture1_contact_id,
       r.furniture2_contact_id,
       r.is_quoted,
       r.description,
       r.approver_contact_id,
       r.alt_customer_contact_id,
       q_v.is_sent AS quote_is_sent,
       q_v.quote_type_id,
       q_v.quote_type_code,
       q_v.quote_type_name,
       q_v.quote_status_type_id,
       q_v.quote_status_type_code,
       q_v.quote_status_type_name,
       q_v.date_quoted,
       q_v.quote_total,
       q_v.quoted_by_user_id,
       q_v.quoted_by_user_name,
       p_v.is_new
  FROM dbo.projects_v2 p_v INNER JOIN
       dbo.requests r ON p_v.project_id = r.project_id INNER JOIN
       dbo.lookups request_type ON r.request_type_id = request_type.lookup_id INNER JOIN
       dbo.lookups request_status_type ON r.request_status_type_id = request_status_type.lookup_id INNER JOIN
       dbo.quotes_v q_v  ON r.request_id = q_v.request_id
 WHERE quote_id IS NOT NULL
UNION
SELECT p_v.project_id,
       p_v.project_no,
       r.request_id,
       r.request_no,
       q_v.quote_id,
       q_v.quote_no,
       CONVERT(VARCHAR, p_v.project_no) + '-' + CONVERT(VARCHAR, r.request_no) + '.' + CONVERT(VARCHAR, r.version_no) + 'HS' + CONVERT(VARCHAR, h.hotsheet_no) AS record_no,
       r.request_id AS record_id,
       r.request_no AS record_seq_no,
       r.version_no,
       dbo.versions_max_no_v.max_version_no,
       h.request_type_id AS record_type_id,
       request_type.code AS record_type_code,
       request_type.name AS record_type_name,
       request_type.sequence_no AS record_type_seq_no,
       r.request_status_type_id AS record_status_type_id,
       request_status_type.code AS record_status_type_code,
       request_status_type.name AS record_status_type_name,
       r.is_sent AS record_is_sent,
       ISNULL(h.date_modified, h.date_created) AS record_last_modified,
       h.date_created AS record_created,
       h.date_modified AS record_modified,
       p_v.project_status_type_id,
       p_v.project_status_type_code,
       p_v.project_status_type_name,
       p_v.parent_customer_id,
       p_v.organization_id,
       p_v.ext_dealer_id,
       p_v.dealer_name,
       p_v.ext_customer_id,
       p_v.customer_id,
       p_v.customer_name,
       p_v.end_user_id,
       p_v.end_user_name,
       p_v.refusal_email_info,
       p_v.survey_location,
       p_v.job_name,
       r.quote_request_id,
       r.request_type_id,
       request_type.code AS request_type_code,
       request_type.name AS request_type_name,
       r.request_status_type_id,
       request_status_type.code AS request_status_type_code,
       request_status_type.name AS request_status_type_name,
       r.is_sent AS request_is_sent,
       r.dealer_po_no,
       r.customer_po_no,
       r.dealer_project_no,
       r.design_project_no,
       r.est_start_date,
       CONVERT(VARCHAR(12), r.est_start_date, 101) AS est_start_date_varchar,
       r.a_m_contact_id,
       r.a_m_sales_contact_id,
       r.customer_contact_id,
       r.customer_contact2_id,
       r.customer_contact3_id,
       r.customer_contact4_id,
       r.d_sales_rep_contact_id,
       r.d_sales_sup_contact_id,
       r.d_designer_contact_id,
       r.d_proj_mgr_contact_id,
       r.a_m_install_sup_contact_id,
       r.a_d_designer_contact_id,
       r.gen_contractor_contact_id,
       r.electrician_contact_id,
       r.data_phone_contact_id,
       r.phone_contact_id,
       r.carpet_layer_contact_id,
       r.bldg_mgr_contact_id,
       r.security_contact_id,
       r.mover_contact_id,
       r.other_contact_id,
       r.furniture1_contact_id,
       r.furniture2_contact_id,
       r.is_quoted,
       r.description,
       r.approver_contact_id,
       r.alt_customer_contact_id,
       q_v.is_sent AS quote_is_sent,
       q_v.quote_type_id,
       q_v.quote_type_code,
       q_v.quote_type_name,
       q_v.quote_status_type_id,
       q_v.quote_status_type_code,
       q_v.quote_status_type_name,
       q_v.date_quoted,
       q_v.quote_total,
       q_v.quoted_by_user_id,
       q_v.quoted_by_user_name,
       p_v.is_new
FROM dbo.projects_v2 p_v LEFT OUTER JOIN
       dbo.hotsheets h ON p_v.project_id = h.project_id LEFT OUTER JOIN
       dbo.requests r ON p_v.project_id = r.project_id LEFT OUTER JOIN
       dbo.lookups request_type ON h.request_type_id = request_type.lookup_id LEFT OUTER JOIN
       dbo.lookups request_status_type ON r.request_status_type_id = request_status_type.lookup_id LEFT OUTER JOIN
       dbo.quotes_v q_v ON r.request_id = q_v.request_id  LEFT OUTER JOIN
       dbo.versions_max_no_v ON r.request_no = dbo.versions_max_no_v.request_no AND r.project_id = dbo.versions_max_no_v.project_id
GO

