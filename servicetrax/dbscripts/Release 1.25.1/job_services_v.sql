DROP VIEW job_services_v
GO

CREATE VIEW job_services_v
AS
SELECT CAST(j.job_id AS VARCHAR(30)) + ':' + ISNULL(CAST(s.service_id AS VARCHAR(30)), '') AS job_service_id, 
       c.organization_id, 
       j.job_id, 
       j.project_id, 
       j.job_no, 
       j.job_name, 
       j.job_type_id, 
       job_type.code job_type_code, 
       job_type.name job_type_name, 
       j.job_status_type_id, 
       job_status_type.code job_status_type_code, 
       job_status_type.name job_status_type_name, 
       job_status_type.sequence_no job_status_seq_no, 
       CASE WHEN customer_type.code = 'end_user' THEN c.end_user_parent_id ELSE c.customer_id END customer_id,
       CASE WHEN customer_type.code = 'end_user' THEN (SELECT customer_name FROM customers WHERE customer_id = c.end_user_parent_id) ELSE c.customer_name END customer_name,
       CASE WHEN customer_type.code = 'end_user' THEN c.customer_name ELSE eu.customer_name END end_user_name, 
       c.dealer_name, 
       CASE WHEN customer_type.code = 'dealer' THEN ISNULL(c.ext_customer_id, c.ext_dealer_id) ELSE c.ext_dealer_id END ext_dealer_id, 
       c.ext_customer_id, 
       j.foreman_resource_id, 
       r.name AS foreman_resource_name, 
       r.user_id AS foreman_user_id,
       foreman_user.first_name + ' ' + foreman_user.last_name AS foreman_user_name,  
       j.billing_user_id, 
       u_billing.first_name + ' ' + u_billing.last_name AS billing_user_name,  
       j.created_by AS job_created_by, 
       j_created_by.first_name + ' ' + j_created_by.last_name  AS job_created_by_name, 
       j.date_created AS job_date_created, 
       j.modified_by AS job_modified_by, 
       j_modified_by.first_name + ' ' + j_modified_by.last_name AS job_modified_by_name, 
       j.date_modified AS job_date_modified,   
       s.request_id, 
       s.service_id, 
       s.service_no, 
       CAST(s.service_no AS varchar) + ' - ' + ISNULL(s.description, '') AS service_no_desc, 
       s.service_type_id, 
       service_type.code AS service_type_code, 
       service_type.name AS service_type_name, 
       s.serv_status_type_id, serv_status_type.code AS serv_status_type_code, 
       serv_status_type.name AS serv_status_type_name, 
       s.internal_req_flag, s.description, 
       s.job_location_id, 
       jl.job_location_name, 
       s.report_to_loc_id, 
       report_to_loc_type.code AS report_to_loc_code, 
       report_to_loc_type.name AS report_to_loc_name, 
       s.customer_ref_no, 
       s.po_no AS po_no, 
       s.billing_type_id, 
       s.customer_contact_id, 
       s.idm_contact_id, 
       s.sales_contact_id, 
       s.support_contact_id, 
       s.designer_contact_id, 
       s.project_mgr_contact_id, 
       s.product_setup_desc, 
       s.delivery_type_id, 
       delivery_types.code AS delivery_type_code, 
       delivery_types.name AS delivery_type_name, 
       s.warehouse_loc, 
       s.pri_furn_type_id, 
       s.pri_furn_line_type_id, 
       pri_furn_line_types.name AS pri_furn_line_type_name, 
       s.sec_furn_type_id, 
       s.sec_furn_line_type_id, 
       sec_furn_line_types.name AS sec_furn_line_type_name, 
       s.num_stations, 
       s.product_qty, 
       s.wood_product_type_id, 
       s.punchlist_type_id, 
       punchlist_type.code AS punchlist_type_code, 
       punchlist_type.name AS punchlist_type_name, 
       s.blueprint_location, 
       s.schedule_type_id, 
       schedule_type.code AS schedule_type_code, 
       schedule_type.name AS schedule_type_name, 
       schedule_type.sequence_no AS sch_type_seq_no, 
       s.ordered_by, 
       s.ordered_date, 
       s.est_start_date, 
       s.est_start_time, 
       s.est_end_date, 
       s.truck_ship_date, 
       s.truck_arrival_date, 
       s.head_val_flag, 
       s.loc_val_flag, 
       s.prod_val_flag, 
       s.sch_val_flag, 
       s.task_val_flag, 
       s.res_val_flag, 
       s.cust_val_flag, 
       s.bill_val_flag, 
       s.cust_col_1, 
       s.cust_col_2, 
       s.cust_col_3, 
       s.cust_col_4, 
       s.cust_col_5, 
       s.cust_col_6, 
       s.cust_col_7, 
       s.cust_col_8, 
       s.cust_col_9, 
       s.cust_col_10, 
       s.date_created AS serv_date_created, 
       s.created_by AS serv_created_by, 
       s_created_by.first_name + ' ' + s_created_by.last_name AS serv_created_by_name, 
       s.date_modified AS serv_date_modified, 
       s.modified_by AS serv_modified_by, 
       s_modified_by.first_name + ' ' + s_modified_by.last_name AS serv_modified_by_name, 
       CONVERT(VARCHAR, s.est_start_time, 8) AS est_start_time_only, 
       serv_status_type.sequence_no AS serv_status_seq_no, 
       (CASE s.watch_flag WHEN 'Y' THEN s.watch_flag ELSE j.watch_flag END) AS watch_flag, 
       (CASE s.weekend_flag WHEN 'Y' THEN 'Yes' WHEN 'N' THEN 'No' ELSE 'N/A' END) AS weekend_flag_name
  FROM dbo.jobs j INNER JOIN
       dbo.lookups job_type ON j.job_type_id = job_type.lookup_id INNER JOIN 
       dbo.lookups job_status_type ON j.job_status_type_id = job_status_type.lookup_id INNER JOIN
       dbo.customers c ON j.customer_id = c.customer_id INNER JOIN
       dbo.lookups customer_type ON c.customer_type_id = customer_type.lookup_id INNER JOIN
       dbo.users j_created_by ON j.created_by = j_created_by.user_id LEFT OUTER JOIN
       dbo.users j_modified_by ON j.modified_by = j_modified_by.user_id LEFT OUTER JOIN
       dbo.users u_billing ON j.billing_user_id = u_billing.user_id LEFT OUTER JOIN
       dbo.resources r ON j.foreman_resource_id = r.resource_id LEFT OUTER JOIN
       dbo.users foreman_user ON r.user_id = foreman_user.user_id LEFT OUTER JOIN
       dbo.services s ON j.job_id = s.job_id LEFT OUTER JOIN     
       dbo.job_locations jl ON s.job_location_id = jl.job_location_id LEFT OUTER JOIN
       dbo.lookups delivery_types ON s.delivery_type_id = delivery_types.lookup_id LEFT OUTER JOIN
       dbo.lookups pri_furn_line_types ON s.pri_furn_line_type_id = pri_furn_line_types.lookup_id LEFT OUTER JOIN
       dbo.lookups punchlist_type ON s.punchlist_type_id = punchlist_type.lookup_id  LEFT OUTER JOIN
       dbo.lookups report_to_loc_type ON s.report_to_loc_id = report_to_loc_type.lookup_id LEFT OUTER JOIN
       dbo.lookups schedule_type ON s.schedule_type_id = schedule_type.lookup_id LEFT OUTER JOIN
       dbo.lookups sec_furn_line_types ON s.sec_furn_line_type_id = sec_furn_line_types.lookup_id LEFT OUTER JOIN
       dbo.lookups service_type ON s.service_type_id = service_type.lookup_id LEFT OUTER JOIN
       dbo.lookups serv_status_type ON s.serv_status_type_id = serv_status_type.lookup_id LEFT OUTER JOIN
       dbo.users s_modified_by ON s.modified_by = s_modified_by.user_id LEFT OUTER JOIN
       dbo.users s_created_by ON s.created_by = s_created_by.user_id LEFT OUTER JOIN
       dbo.customers eu ON j.end_user_id = eu.customer_id
GO