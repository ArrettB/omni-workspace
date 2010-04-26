DROP VIEW versions_copy_v
GO

CREATE VIEW versions_copy_v
AS    
SELECT project_id,
       request_no,
       request_type_id,
       request_status_type_id,
       is_sent,  
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
       delivery_type_id,
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
       date_created,  
       created_by,
       date_modified,
       modified_by,
       version_no,
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
       is_sent_date,
       other_delivery_type_id,
       customer_costing_type_id,
       customer_contact2_id,
       customer_contact3_id,
       customer_contact4_id,
       job_location_contact_id,
       system_furniture_line_type_id,
       other_furniture_type_id,
       schedule_with_client_flag,
       order_type_id,
       is_stair_carry_required,
       days_to_complete
  FROM requests r
GO