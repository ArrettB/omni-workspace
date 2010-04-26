CREATE VIEW dbo.INTERNAL_REQ_V
AS
SELECT     TOP 100 PERCENT dbo.JOBS.JOB_NO, dbo.SERVICES.SERVICE_ID, dbo.SERVICES.SERVICE_NO, CAST(dbo.SERVICES.SERVICE_NO AS varchar) 
                      + ' - ' + ISNULL(dbo.SERVICES.DESCRIPTION, '') AS service_no_desc, dbo.CUSTOMERS.CUSTOMER_NAME, dbo.CUSTOMERS.DEALER_NAME, 
                      dbo.JOBS.JOB_NAME, dbo.SERVICES.WATCH_FLAG, dbo.SERVICES.SERVICE_TYPE_ID, SERVICE_TYPES.CODE AS service_type_code, 
                      SERVICE_TYPES.NAME AS service_type_name, dbo.SERVICES.INTERNAL_REQ_FLAG, dbo.SERVICES.REPORT_TO_LOC_ID, 
                      REPORT_TO_LOC_TYPES.CODE AS report_to_loc_code, REPORT_TO_LOC_TYPES.NAME AS report_to_loc_name, dbo.SERVICES.DESCRIPTION, 
                      dbo.SERVICES.SERV_STATUS_TYPE_ID, SERVICE_STATUS_TYPES.CODE AS serv_status_type_code, 
                      SERVICE_STATUS_TYPES.NAME AS serv_status_type_name, SERVICE_STATUS_TYPES.SEQUENCE_NO AS serv_status_type_seq_no, 
                      dbo.RESOURCES.NAME AS resource_name, dbo.JOBS.FOREMAN_RESOURCE_ID, dbo.JOBS.JOB_TYPE_ID, JOB_TYPES_1.CODE AS job_type_code, 
                      JOB_TYPES_1.NAME AS job_type_name, dbo.JOBS.JOB_STATUS_TYPE_ID, JOB_STATUS_TYPE.CODE AS job_status_type_code, 
                      JOB_STATUS_TYPE.NAME AS job_status_type_name, dbo.JOBS.CUSTOMER_ID, dbo.JOBS.EXT_PRICE_LEVEL_ID, 
                      dbo.CUSTOMERS.EXT_DEALER_ID, dbo.CUSTOMERS.ORGANIZATION_ID, dbo.JOBS.DATE_CREATED AS job_date_created, 
                      dbo.SERVICES.JOB_LOCATION_ID, dbo.JOB_LOCATIONS.JOB_LOCATION_NAME, dbo.SERVICES.CUSTOMER_REF_NO, dbo.SERVICES.PO_NO, 
                      dbo.SERVICES.BILLING_TYPE_ID, dbo.SERVICES.IDM_CONTACT_ID, dbo.SERVICES.CUSTOMER_CONTACT_ID, 
                      dbo.CONTACTS.CONTACT_NAME AS idm_contact_name, dbo.SERVICES.SALES_CONTACT_ID, dbo.SERVICES.SUPPORT_CONTACT_ID, 
                      dbo.SERVICES.DESIGNER_CONTACT_ID, dbo.SERVICES.PROJECT_MGR_CONTACT_ID, dbo.SERVICES.PRODUCT_SETUP_DESC, 
                      dbo.SERVICES.DELIVERY_TYPE_ID, dbo.SERVICES.WAREHOUSE_LOC, dbo.SERVICES.PRI_FURN_TYPE_ID, 
                      dbo.SERVICES.PRI_FURN_LINE_TYPE_ID, dbo.SERVICES.SEC_FURN_TYPE_ID, dbo.SERVICES.SEC_FURN_LINE_TYPE_ID, 
                      dbo.SERVICES.NUM_STATIONS, dbo.SERVICES.PRODUCT_QTY, ISNULL(dbo.SERVICES.WOOD_PRODUCT_TYPE_ID, 142) AS wood_product_type_id, 
                      dbo.SERVICES.PUNCHLIST_TYPE_ID, PUNCH_LIST_TYPES.CODE AS punchlist_type_code, PUNCH_LIST_TYPES.NAME AS punchlist_type_name, 
                      dbo.SERVICES.BLUEPRINT_LOCATION, dbo.SERVICES.SCHEDULE_TYPE_ID, SCHEDULE_TYPES.CODE AS schedule_type_code, 
                      SCHEDULE_TYPES.NAME AS schedule_type_name, dbo.SERVICES.ORDERED_BY, dbo.SERVICES.ORDERED_DATE, 
                      dbo.SERVICES.EST_START_DATE, dbo.SERVICES.EST_START_TIME, dbo.SERVICES.EST_END_DATE, dbo.SERVICES.TRUCK_SHIP_DATE, 
                      dbo.SERVICES.TRUCK_ARRIVAL_DATE, dbo.SERVICES.HEAD_VAL_FLAG, dbo.SERVICES.LOC_VAL_FLAG, dbo.SERVICES.PROD_VAL_FLAG, 
                      dbo.SERVICES.SCH_VAL_FLAG, dbo.SERVICES.TASK_VAL_FLAG, dbo.SERVICES.RES_VAL_FLAG, dbo.SERVICES.CUST_VAL_FLAG, 
                      dbo.SERVICES.BILL_VAL_FLAG, dbo.SERVICES.DATE_CREATED, dbo.SERVICES.CREATED_BY, 
                      CREATE_USER.FIRST_NAME + ' ' + CREATE_USER.LAST_NAME AS created_by_name, dbo.SERVICES.DATE_MODIFIED, dbo.SERVICES.MODIFIED_BY, 
                      MOD_USER.FIRST_NAME + ' ' + MOD_USER.LAST_NAME AS modified_by_name, dbo.SERVICES.CUST_COL_1, dbo.SERVICES.CUST_COL_2, 
                      dbo.SERVICES.CUST_COL_3, dbo.SERVICES.CUST_COL_4, dbo.SERVICES.CUST_COL_5, dbo.SERVICES.CUST_COL_6, dbo.SERVICES.CUST_COL_7, 
                      dbo.SERVICES.CUST_COL_8, dbo.SERVICES.CUST_COL_9, dbo.SERVICES.CUST_COL_10, dbo.SERVICES.WEEKEND_FLAG, 
                      dbo.SERVICES.QUOTE_TOTAL, dbo.SERVICES.MISC
FROM         dbo.LOOKUPS PUN
