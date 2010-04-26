CREATE VIEW dbo.SERVICE_ACCOUNT_REPORT_V
AS
SELECT     job_id, job_no, job_name, job_no_name, DESCRIPTION, req_po_no, job_type_id, job_type_code, job_type_name, job_status_type_id, 
                      job_status_type_code, job_status_type_name, job_status_seq_no, customer_id, organization_id, dealer_name, ext_dealer_id, customer_name, 
                      JOB_LOCATION_NAME, ext_customer_id, INVOICE_ID, Invoice_Desc, PO_NO, EST_START_DATE, SCH_START_DATE, SERVICE_LINE_DATE, 
                      invoice_status_id, invoice_status_code, invoice_status_name, SERVICE_ID, SERVICE_NO, TC_SERVICE_LINE_NO, RESOURCE_TYPE_ID, 
                      resource_type_code, resource_type_name, res_cat_type_id, res_cat_type_code, res_cat_type_name, ITEM_ID, item_name, ITEM_TYPE_ID, 
                      item_type_name, item_type_code, BILLABLE_FLAG, TAXABLE_FLAG, bill_total, EXT_PAY_CODE, SL_BILLABLE_FLAG, hourly_rate, expense_rate, 
                      BILL_QTY, CUST_COL_1, CUST_COL_2, CUST_COL_3, CUST_COL_4, CUST_COL_5, CUST_COL_6, CUST_COL_7, CUST_COL_8, CUST_COL_9, 
                      CUST_COL_10, SUM(other_rate) AS other_rate, SUM(other_qty) AS other_qty, SUM(other_total) AS other_total, SUM(baggies_rate) AS baggies_rate, 
                      SUM(baggies_qty) AS baggies_qty, SUM(baggies_total) AS baggies_total, SUM(boxes_rate) AS boxes_rate, SUM(boxes_qty) AS boxes_qty, 
                      SUM(boxes_total) AS boxes_total, SUM(labels_rate) AS labels_rate, SUM(labels_qty) AS labels_qty, SUM(labels_total) AS labels_total, SUM(tape_rate) 
                      AS tape_rate, SUM(tape_qty) AS tape_qty, SUM(tape_total) AS tape_total, SUM(supplies_rate) AS supplies_rate, SUM(supplies_qty) AS supplies_qty, 
                      SUM(supplies_total) AS supplies_total, SUM(trash_rate) AS trash_rate, SUM(trash_qty) AS trash_qty, SUM(trash_total) AS trash_total, 
                      SUM(EquipRental_rate) AS EquipRental_rate, SUM(EquipRental_qty) AS EquipRental_qty, SUM(EquipRental_total) AS EquipRental_total, 
                      SUM(keys_rate) AS keys_rate, SUM(keys_qty) AS keys_qty, SUM(keys_total) AS keys_total, SUM(custom_reg_rate) AS custom_reg_rate, 
                      SUM(custom_reg_qty) AS custom_reg_qty, SUM(custom_reg_total) AS custom_reg_total, SUM(custom_ot_rate) AS custom_ot_rate, 
                      SUM(custom_ot_qty) AS custom_ot_qty, SUM(custom_ot_total) AS custom_ot_total, SUM(delivery_reg_rate) AS delivery_reg_rate, 
                      SUM(delivery_reg_qty) AS delivery_reg_qty, SUM(delivery_reg_total) AS delivery_reg_total, SUM(delivery_ot_rate) AS delivery_ot_rate, 
                      SUM(delivery_ot_qty) AS delivery_ot_qty, SUM(delivery_ot_total) AS delivery_ot_total, SUM(driver_reg_rate) AS Driver_reg_rate, SUM(driver_reg_qty) 
                      AS Driver_reg_qty, SUM(driver_reg_total) AS Driver_reg_total, SUM(driver_ot_rate) AS Driver_ot_rate, SUM(driver_ot_qty) AS Driver_ot_qty, 
                      SUM(driver_ot_total) AS Driver_ot_total, SUM(truck_rate) AS truck_rate, SUM(truck_qty) AS truck_qty, SUM(truck_total) AS truck_total, SUM(van_rate) 
                      AS van_rate, SUM(van_qty) AS van_qty, SUM(van_total) AS van_total, SUM(MileageInTown_rate) AS MileageInTown_rate, SUM(MileageInTown_qty) 
                      AS MileageInTown_qty, SUM(MileageInTown_total) AS MileageInTown_total, SUM(MileageOutTown_rate) AS MileageOutTown_rate, 
                      SUM(MileageOutTown_qty) AS MileageOutTown_qty, SUM(MileageOutTown_total) AS MileageOutTown_total, SUM(installer_reg_rate) 
                      AS installer_reg_rate, SUM(installer_reg_qty) AS installer_reg_qty, SUM(installer_reg_total) AS installer_reg_total, SUM(installer_ot_rate) 
                      AS installer_ot_rate, SUM(installer_ot_qty) AS installer_ot_qty, SUM(installer_ot_total) AS installer_ot_total, SUM(sub_reg_rate) AS sub_reg_rate, 
                      SUM(sub_reg_qty) AS sub_reg_qty,
