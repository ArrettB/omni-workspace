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

ALTER VIEW [dbo].[versions_copy_v]
AS
SELECT project_id,
request_no,
version_no,
request_type_id,
request_status_type_id,
is_sent,
is_sent_date,
is_quoted,
quote_request_id,
dealer_cust_id,
customer_po_no,
dealer_po_no,
dealer_po_line_no,
dealer_project_no,
design_project_no,
project_volume,
account_type_id,
quote_type_id,
quote_needed_by,
job_location_id,
customer_contact_id,
alt_customer_contact_id,
d_sales_rep_contact_id,
d_sales_sup_contact_id,
d_proj_mgr_contact_id,
d_designer_contact_id,
a_m_contact_id,
a_m_install_sup_contact_id,
a_d_designer_contact_id,
gen_contractor_contact_id,
electrician_contact_id,
data_phone_contact_id,
carpet_layer_contact_id,
bldg_mgr_contact_id,
security_contact_id,
mover_contact_id,
other_contact_id,
pri_furn_type_id,
pri_furn_line_type_id,
sec_furn_type_id,
sec_furn_line_type_id,
case_furn_type_id,
case_furn_line_type_id,
wood_product_type_id,
warehouse_loc,
furn_plan_type_id,
plan_location,
furn_spec_type_id,
workstation_typical_type_id,
power_type,
punchlist_item_type_id,
punchlist_line,
wall_mount_type_id,
init_proj_team_mtg_date,
design_presentation_date,
design_completion_date,
spec_check_cmpl_date,
dealer_order_placed_date,
int_pre_install_mtg_date,
ext_pre_install_mtg_date,
dealer_install_plan_date,
mfg_ship_date,
prod_del_to_wh_date,
truck_arrival_time,
construct_complete_date,
electrical_complete_date,
cable_complete_date,
carpet_complete_date,
site_visit_req_type_id,
site_visit_date,
product_del_to_site_date,
schedule_type_id,
est_start_date,
est_start_time,
est_end_date,
days_to_complete,
move_in_date,
punchlist_complete_date,
coord_phone_data_type_id,
coord_wall_covr_type_id,
coord_floor_covr_type_id,
coord_electrical_type_id,
coord_mover_type_id,
activity_type_id1,
qty1,
activity_cat_type_id1,
activity_type_id2,
qty2,
activity_cat_type_id2,
activity_type_id3,
qty3,
activity_cat_type_id3,
activity_type_id4,
qty4,
activity_cat_type_id4,
activity_type_id5,
qty5,
activity_cat_type_id5,
activity_type_id6,
qty6,
activity_cat_type_id6,
activity_type_id7,
qty7,
activity_cat_type_id7,
activity_type_id8,
qty8,
activity_cat_type_id8,
activity_type_id9,
qty9,
activity_cat_type_id9,
activity_type_id10,
qty10,
activity_cat_type_id10,
description,
approval_req_type_id,
who_can_approve_name,
who_can_approve_phone,
regular_hours_type_id,
evening_hours_type_id,
weekend_hours_type_id,
union_labor_req_type_id,
cost_to_cust_type_id,
cost_to_vend_type_id,
cost_to_job_type_id,
warehouse_fee_type_id,
taxable_flag,
duration_time_uom_type_id,
duration_qty,
phased_install_type_id,
loading_dock_type_id,
dock_available_time,
dock_reserv_req_type_id,
semi_access_type_id,
dock_height,
elevator_avail_type_id,
elevator_avail_time,
elevator_reserv_req_type_id,
stair_carry_type_id,
stair_carry_flights,
stair_carry_stairs,
smallest_door_elev_width,
floor_protection_type_id,
wall_protection_type_id,
doorway_prot_type_id,
walkboard_type_id,
staging_area_type_id,
dumpster_type_id,
new_site_type_id,
occupied_site_type_id,
other_conditions,
p_card_number,
furniture1_contact_id,
furniture2_contact_id,
approver_contact_id,
phone_contact_id,
floor_number_type_id,
priority_type_id,
level_type_id,
furn_req_type_id,
cust_contact_mod_date,
job_location_mod_date,
cust_col_1,
cust_col_2,
cust_col_3,
cust_col_4,
cust_col_5,
cust_col_6,
cust_col_7,
cust_col_8,
cust_col_9,
cust_col_10,
is_copy,
is_surveyed,
furniture_type,
furniture_qty,
prod_disp_flag,
prod_disp_id,
a_m_sales_contact_id,
work_order_received_date,
csc_wo_field_flag,
customer_costing_type_id,
customer_contact2_id,
customer_contact3_id,
customer_contact4_id,
job_location_contact_id,
system_furniture_line_type_id,
delivery_type_id,
other_furniture_type_id,
other_delivery_type_id,
other_furniture_desc,
schedule_with_client_flag,
order_type_id,
is_stair_carry_required,
date_created,
created_by,
date_modified,
modified_by,
plan_location_type_id
  FROM requests r
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
 * Alter the invoices table - add the fuel surchage column
 */

ALTER TABLE [dbo].[INVOICES]
   ADD [FUEL_SURCHARGE] [varchar](1)
GO

