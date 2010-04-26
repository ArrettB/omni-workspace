/* $Id: sch_job_req_info_v.sql 1667 2009-08-17 21:49:29Z bvonhaden $ */

ALTER VIEW [dbo].[sch_job_req_info_v]
AS
SELECT CAST(j.job_id AS VARCHAR(30)) + ':' + ISNULL(CAST(s.service_id AS VARCHAR(30)), '') AS job_service_id,
       j.job_id,
       j.project_id,
       s.service_id,
       r.request_id,
       c.organization_id, 
       j.job_no,
       s.service_no,
       s.po_no,
       j.job_type_id,
       job_type.name job_type,
       CASE WHEN customer_type.code = 'end_user' THEN (SELECT customer_name FROM customers WHERE customer_id = c.end_user_parent_id) 
            ELSE c.customer_name END customer_name,
       CASE WHEN customer_type.code = 'end_user' THEN c.customer_name 
            ELSE (SELECT customer_name 
                    FROM customers c1 INNER JOIN
                         projects p ON c1.customer_id=p.end_user_id 
                   WHERE p.project_id=j.project_id) END end_user_name,
       jl.job_location_name,
       jl.street1,
       jl.street2,
       jl.city,
       jl.state,
       jl.zip,
       (SELECT contact_name + ' - ' + dbo.sp_contact_phone(contact_id) FROM contacts WHERE contact_id=r.customer_contact_id) customer_contact,
       CASE WHEN r.customer_contact2_id IS NULL THEN NULL ELSE (SELECT contact_name + ' - ' + dbo.sp_contact_phone(contact_id) FROM contacts WHERE contact_id=r.customer_contact2_id) END customer_contact2,
       CASE WHEN r.customer_contact3_id IS NULL THEN NULL ELSE (SELECT contact_name + ' - ' + dbo.sp_contact_phone(contact_id) FROM contacts WHERE contact_id=r.customer_contact3_id) END customer_contact3,
       CASE WHEN r.customer_contact4_id IS NULL THEN NULL ELSE (SELECT contact_name + ' - ' + dbo.sp_contact_phone(contact_id) FROM contacts WHERE contact_id=r.customer_contact4_id) END customer_contact4,
       (SELECT contact_name FROM contacts WHERE contact_id=r.a_m_contact_id) omni_proj_mgr,
       s.description,
       s.est_start_date, 
       s.est_start_time, 
       s.est_end_date, 
       billing_type.name billing_type,
       product_disposition_type.name product_disposition,
       wall_mount_type.name wall_mount_type,
       system_furniture_type.name system_furniture,
       delivery_type.name delivery_type,
       other_furniture_type.name other_furniture_type, 
       other_delivery_type.name other_delivery_type,
       elevator_available_type.name elevator_available_type,
       dbo.sp_varchar20_to_number(q.[ROC_OMNI_DISCOUNTED_HOURS-RECEIVE]) + dbo.sp_varchar20_to_number(q.[ROC_OMNI_DISCOUNTED_HOURS-RELOAD]) est_warehouse_hours,
       dbo.sp_varchar20_to_number(q.[ROC_OMNI_DISCOUNTED_HOURS-TRUCK]) +  dbo.sp_varchar20_to_number(q.[ROC_OMNI_DISCOUNTED_HOURS-DRIVER]) est_delivery_hours, 
       dbo.sp_varchar20_to_number(q.[ROC_OMNI_DISCOUNTED_HOURS-UNLOAD]) + dbo.sp_varchar20_to_number(q.[ROC_OMNI_DISCOUNTED_HOURS-MOVE_STAGE]) + dbo.sp_varchar20_to_number(q.[ROC_OMNI_DISCOUNTED_HOURS-INSTALL]) + dbo.sp_varchar20_to_number(q.[ROC_OMNI_DISCOUNTED_HOURS-ELECTRICAL]) est_install_hours,
       (SELECT SUM(ISNULL(tc_qty,0)) FROM service_lines WHERE bill_service_id=s.service_id AND item_name IN ('AM-W-OT','AM-W-Reg','AssetHdlr-F-OT','AssetHdlr-F-Reg','AssetHdlr-S-OT','AssetHdlr-S-Reg','AssetHdlr-W-OT','AssetHdlr-W-Reg','Custom-W-OT','Custom-W-Reg','Cyc Cnt-F-OT','Cyc Cnt-F-Reg','Cyc Cnt-OH-OT','Cyc Cnt-OH-Reg','Cyc Cnt-S-OT','Cyc Cnt-S-Reg','Cyc Cnt-W-OT','Cyc Cnt-W-Reg','Delivery-W-OT','Delivery-W-Reg','Driver-W-OT','Driver-W-Reg','Gen Labor-W-OT','Gen Labor-W-Reg','Installer-W-OT','Installer-W-Reg','Lead-W-OT','Lead-W-Reg','MAC-W-OT','MAC-W-Reg','MOVER-W-OT','MOVER-W-REG','OH Whse-OT','OH Whse-Reg','Proj Mgr-W-OT','Proj Mgr-W-Reg','PS-W-OT','PS-W-Reg','Snaptrack-F-OT','Snaptrack-F-Reg','Snaptrack-S-OT','Snaptrack-S-Reg','Snaptrack-W-OT','Snaptrack-W-Reg','Snaptracker-OT','Snaptracker-Reg','Truck-W-Reg','VAN-W','Whse Mgr-OH-OT','Whse Mgr-OH-Reg','Whse Mgr-OT','Whse Mgr-Reg','Whse Proj - OT','Whse Proj - Reg','Whse Rent','Whse Sup-F-OT','Whse Sup-F-Reg',' Whse Sup-OT','Whse Sup-Reg','Whse Sup-S-OT','Whse Sup-S-Reg',' Whse Sup-W-OT','Whse Sup-W-Reg',' Whse-F-OT','Whse-F-Reg','Whse-OH-OT','Whse-OH-Reg','Whse-OT','Whse-Reg','Whse-S-OT','Whse-S-Reg','Whse-W-OT','Whse-W-Reg')) warehouse_hours_to_date,
       (SELECT SUM(ISNULL(tc_qty,0)) FROM service_lines WHERE bill_service_id=s.service_id AND item_name IN ('Delivery-F-OT','Delivery-F-Reg','Delivery-OT','Delivery-Reg','Delivery-S-OT','Delivery-S-Reg','Driver-F-OT','Driver-F-Reg','Driver-S-OT','Driver-S-Reg','Truck','Truck Rental','Truck Rental-F','Truck Rental-OH','Truck Rental-S','Truck Rental-W','Truck-Emp','Truck-Emp-F','Truck-Emp-OH','Truck-Emp-S','Truck-Emp-W','Truck-F-Reg','Truck-OH-Reg','Truck-S-Reg','Van','VAN-F','VAN-OH','VAN-S')) delivery_hours_to_date,
       (SELECT SUM(ISNULL(tc_qty,0)) FROM service_lines WHERE bill_service_id=s.service_id AND item_name IN ('AC-F-OT','AC-F-Reg','AC-OT','AC-Reg','AC-S-OT','AC-S-Reg','AC-W-OT','AC-W-Reg','AM Spec-F-OT','AM Spec-F-Reg','AM Spec-S-OT','AM Spec-S-Reg','AM Spec-W-OT','AM Spec-W-Reg','AM Spec.-OT','AM Spec.-Reg','AM-F-OT','AM-F-Reg','AM-OT','AM-Reg','AM-S-OT','AM-S-Reg','CampFuMgr-S-OT','CampFuMgr-S-Reg','CampFurnMgr-OT','CampFurnMgr-Reg','Custom-F-OT','Custom-F-Reg','Custom-OT','Custom-Reg','Custom-S-OT','Custom-S-Reg','Foreman-F-OT','Foreman-F-Reg','Foreman-S-OT','Foreman-S-Reg','Foreman-W-OT','Foreman-W-Reg','Gen Labor-F-OT','Gen Labor-F-Reg','Gen Labor-S-OT','Gen Labor-S-Reg','Install-OH-OT','Install-OH-Reg','Installer-F-OT','Installer-F-Reg','Installer-OT','Installer-Reg','Installer-S-OT','Installer-S-Reg','Lead-F-OT','Lead-F-Reg','Lead-OT','Lead-Reg','Lead-S-OT','Lead-S-Reg','MAC-F-OT','MAC-F-Reg','MAC-OT','MAC-Reg','MAC-S-OT','MAC-S-Reg','Mover','MOVER-F-OT','MOVER-F-REG','MOVER-OT HRS','MOVER-REG HRS','MOVER-S-OT','MOVER-S-REG','MPS-OT','MPS-Reg','MPS-S-OT','MPS-S-REG','OH Bid-OT','OH Bid-Reg','OH Install-OT','OH Install-Reg','OH Mgmt-OT','OH Mgmt-Reg','OH Train-OT','OH Train-Reg','PC Coord-OT','PC Coord-Reg','PC Coord-S-OT','PC Coord-S-Reg','PC Mover-OT','PC Mover-Reg','PC Mover-S-OT','PC Mover-S-Reg','PC/Fab-F-OT','PC/Fab-F-Reg','PC/Fab-OT','PC/Fab-Reg','PC/Fab-S-OT','PC/Fab-S-Reg','PC/Fab-W-OT','PC/Fab-W-Reg','Proj Mgr-F-OT','Proj Mgr-F-Reg','Proj Mgr-S-OT','Proj Mgr-S-Reg','PS-F-OT','PS-F-Reg','PS-OT','PS-OT-CA','PS-Reg','PS-Reg-CA','PS-Reg-F','PS-Reg-S','PS-S-OT','PS-S-Reg','RegProjMgr-OT','RegProjMgr-Reg','RegProjMgr-S-OT','RegProMgr-S-Reg')) installer_hours_to_date,
       ISNULL(p.is_new, 'N') is_new
  FROM jobs j INNER JOIN
       services s ON j.job_id = s.job_id INNER JOIN
       customers c ON j.customer_id = c.customer_id INNER JOIN 
       dbo.lookups customer_type ON c.customer_type_id = customer_type.lookup_id INNER JOIN
       dbo.lookups job_type ON j.job_type_id = job_type.lookup_id LEFT OUTER JOIN 
       dbo.job_locations jl ON s.job_location_id = jl.job_location_id LEFT OUTER JOIN
       dbo.lookups billing_type ON s.billing_type_id = billing_type.lookup_id LEFT OUTER JOIN 
       requests r ON s.request_id = r.request_id LEFT OUTER JOIN 
       dbo.lookups product_disposition_type ON r.prod_disp_id = product_disposition_type.lookup_id LEFT OUTER JOIN 
       dbo.lookups wall_mount_type ON r.wall_mount_type_id = wall_mount_type.lookup_id LEFT OUTER JOIN 
       dbo.lookups system_furniture_type ON r.system_furniture_line_type_id = system_furniture_type.lookup_id LEFT OUTER JOIN
       dbo.lookups delivery_type ON r.delivery_type_id = delivery_type.lookup_id LEFT OUTER JOIN 
       dbo.lookups other_furniture_type ON r.other_furniture_type_id = other_furniture_type.lookup_id LEFT OUTER JOIN 
       dbo.lookups other_delivery_type ON r.other_delivery_type_id = other_delivery_type.lookup_id LEFT OUTER JOIN 
       dbo.lookups elevator_available_type ON r.elevator_avail_type_id = elevator_available_type.lookup_id LEFT OUTER JOIN
       quotes q ON s.quote_id=q.quote_id  LEFT OUTER JOIN
       dbo.projects p ON j.project_id = p.project_id
