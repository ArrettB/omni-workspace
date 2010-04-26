CREATE VIEW dbo.SERVICE_ACCOUNT_REPORT_TEST_V
AS
SELECT     JOB_ID, JOB_NO, JOB_NAME, JOB_NO_NAME, DESCRIPTION, req_po_no, JOB_TYPE_ID, job_type_code, job_type_name, JOB_STATUS_TYPE_ID, 
                      job_status_type_code, job_status_type_name, job_status_seq_no, CUSTOMER_ID, ORGANIZATION_ID, DEALER_NAME, EXT_DEALER_ID, 
                      CUSTOMER_NAME, job_location_name, EXT_CUSTOMER_ID, INVOICE_ID, Invoice_Desc, PO_NO, EST_START_DATE, SCH_START_DATE, 
                      SERVICE_LINE_DATE, invoice_status_id, invoice_status_code, invoice_status_name, SERVICE_ID, SERVICE_NO, TC_SERVICE_LINE_NO, 
                      RESOURCE_TYPE_ID, resource_type_code, resource_type_name, res_cat_type_id, res_cat_type_code, res_cat_type_name, ITEM_ID, item_name, 
                      ITEM_TYPE_ID, item_type_name, item_type_code, BILLABLE_FLAG, taxable_flag, bill_total, EXT_PAY_CODE, SL_BILLABLE_FLAG, hourly_rate, 
                      expense_rate, BILL_QTY, col1, col1_enabled, CUST_COL_1, col2, col2_enabled, CUST_COL_2, col3, col3_enabled, CUST_COL_3, col4, col4_enabled, 
                      CUST_COL_4, col5, col5_enabled, CUST_COL_5, col6, col6_enabled, CUST_COL_6, col7, col7_enabled, CUST_COL_7, col8, col8_enabled, 
                      CUST_COL_8, col9, col9_enabled, CUST_COL_9, col10, col10_enabled, CUST_COL_10, SUM(other_rate) AS other_rate, SUM(other_qty) AS other_qty, 
                      SUM(other_total) AS other_total, SUM(baggies_rate) AS baggies_rate, SUM(baggies_qty) AS baggies_qty, SUM(baggies_total) AS baggies_total, 
                      SUM(boxes_rate) AS boxes_rate, SUM(boxes_qty) AS boxes_qty, SUM(boxes_total) AS boxes_total, SUM(EquipRental_rate) AS EquipRental_rate, 
                      SUM(EquipRental_qty) AS EquipRental_qty, SUM(EquipRental_total) AS EquipRental_total, SUM(fasteners_rate) AS fasteners_rate, SUM(fasteners_qty) 
                      AS fasteners_qty, SUM(fasteners_total) AS fasteners_total, SUM(Freight_rate) AS freight_rate, SUM(Freight_qty) AS freight_qty, SUM(Freight_total) 
                      AS freight_total, SUM(keys_rate) AS keys_rate, SUM(keys_qty) AS keys_qty, SUM(keys_total) AS keys_total, SUM(labels_rate) AS labels_rate, 
                      SUM(labels_qty) AS labels_qty, SUM(labels_total) AS labels_total, SUM(MileageInTown_rate) AS MileageInTown_rate, SUM(MileageInTown_qty) 
                      AS MileageInTown_qty, SUM(MileageInTown_total) AS MileageInTown_total, SUM(MileageOutTown_rate) AS MileageOutTown_rate, 
                      SUM(MileageOutTown_qty) AS MileageOutTown_qty, SUM(MileageOutTown_total) AS MileageOutTown_total, SUM(MiscHardware_rate) 
                      AS MiscHardware_rate, SUM(MiscHardware_qty) AS MiscHardware_qty, SUM(MiscHardware_total) AS MiscHardware_total, SUM(PieceCountIn_rate) 
                      AS PieceCountIn_rate, SUM(PieceCountIn_qty) AS PieceCountIn_qty, SUM(PieceCountIn_total) AS PieceCountIn_total, SUM(PieceCountOut_rate) 
                      AS PieceCountOut_rate, SUM(PieceCountOut_qty) AS PieceCountOut_qty, SUM(PieceCountOut_total) AS PieceCountOut_total, SUM(supplies_rate) 
                      AS supplies_rate, SUM(supplies_qty) AS supplies_qty, SUM(supplies_total) AS supplies_total, SUM(tape_rate) AS tape_rate, SUM(tape_qty) 
                      AS tape_qty, SUM(tape_total) AS tape_total, SUM(trash_rate) AS trash_rate, SUM(trash_qty) AS trash_qty, SUM(trash_total) AS trash_total, 
                      SUM(dollies_rate) AS dollies_rate, SUM(dollies_qty) AS dollies_qty, SUM(dollies_total) AS dollies_total, SUM(bookcarts_rate) AS bookcarts_rate, 
                      SUM(bookcarts_qty) AS bookcarts_qty, SUM(bookcarts_total) AS bookcarts_total, SUM(truck_rate) AS truck_rate, SUM(truck_qty) AS truck_qty, 
                      SUM(truck_total) AS truck_total, SUM(van_rate) AS van_rate, SUM(van_qty) AS van_qty, SUM(van_total) AS van_total, SUM(perdiem) AS perdiem, 
                      
