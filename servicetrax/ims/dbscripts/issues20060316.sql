ALTER TABLE dbo.requests
ADD [IS_SENT_DATE] [datetime] NULL
go



ALTER  VIEW dbo.crystal_csc_pkf_WORK_ORDER_MASTER_V
AS
SELECT     TOP 100 PERCENT dbo.REQUESTS.PROJECT_ID, dbo.PROJECTS.PROJECT_NO, dbo.REQUESTS.REQUEST_NO, dbo.REQUESTS.PRIORITY_TYPE_ID, 
                      priority_lookup.NAME AS PRIORITY, dbo.REQUESTS.LEVEL_TYPE_ID, CONTACTS_1.CONTACT_NAME AS Customer_Contact, 
                      dbo.REQUEST_VENDORS.VENDOR_CONTACT_ID, VENDOR_CONTACT.CONTACT_NAME AS VENDOR_NAME, dbo.REQUESTS.EST_START_DATE, 
                      dbo.REQUESTS.EST_START_TIME, dbo.REQUESTS.EST_END_DATE, dbo.REQUEST_VENDORS.DATE_CREATED,
                      dbo.REQUESTS.IS_SENT_DATE,
                      dbo.REQUEST_VENDORS.SCH_START_DATE, dbo.REQUEST_VENDORS.SCH_START_TIME, dbo.REQUEST_VENDORS.SCH_END_DATE, 
                      dbo.REQUEST_VENDORS.ACT_START_DATE, dbo.REQUEST_VENDORS.ACT_START_TIME, dbo.REQUEST_VENDORS.ACT_END_DATE, 
                      dbo.REQUEST_VENDORS.ESTIMATED_COST, dbo.REQUEST_VENDORS.TOTAL_COST, dbo.REQUEST_VENDORS.INVOICE_DATE, 
                      dbo.REQUEST_VENDORS.INVOICE_NUMBERS, dbo.REQUEST_VENDORS.VISIT_COUNT, dbo.REQUEST_VENDORS.COMPLETE_FLAG, 
                      dbo.REQUEST_VENDORS.INVOICED_FLAG, dbo.PROJECTS.JOB_NAME, activiy_lookup.NAME AS ACTIVITY, dbo.REQUESTS.QTY1, 
                      category_lookup.NAME AS CATEGORY, dbo.REQUESTS.DESCRIPTION, dbo.REQUESTS.REQUEST_STATUS_TYPE_ID, 
                      dbo.JOB_LOCATIONS_V.JOB_LOCATION_NAME, dbo.REQUESTS.CUSTOMER_PO_NO, dbo.CUSTOMERS.CUSTOMER_NAME, 
                      dbo.REQUESTS.CUST_COL_1, dbo.REQUESTS.CUST_COL_2, dbo.REQUESTS.CUST_COL_3, dbo.REQUESTS.CUST_COL_4, 
                      dbo.REQUESTS.CUST_COL_5, dbo.REQUESTS.CUST_COL_6, dbo.REQUESTS.CUST_COL_7, dbo.REQUESTS.CUST_COL_8, 
                      dbo.REQUESTS.CUST_COL_9, dbo.REQUESTS.CUST_COL_10, dbo.REQUEST_VENDORS.VENDOR_NOTES, dbo.JOB_LOCATIONS_V.STREET1, 
                      dbo.JOB_LOCATIONS_V.CITY, dbo.JOB_LOCATIONS_V.STATE, dbo.JOB_LOCATIONS_V.ZIP
FROM         dbo.REQUEST_VENDORS INNER JOIN
                      dbo.CONTACTS VENDOR_CONTACT ON dbo.REQUEST_VENDORS.VENDOR_CONTACT_ID = VENDOR_CONTACT.CONTACT_ID RIGHT OUTER JOIN
                      dbo.LOOKUPS activiy_lookup RIGHT OUTER JOIN
                      dbo.LOOKUPS priority_lookup RIGHT OUTER JOIN
                      dbo.PROJECTS INNER JOIN
                      dbo.REQUESTS ON dbo.PROJECTS.PROJECT_ID = dbo.REQUESTS.PROJECT_ID LEFT OUTER JOIN
                      dbo.CUSTOMERS LEFT OUTER JOIN
                      dbo.CONTACTS CONTACTS_1 ON dbo.CUSTOMERS.CUSTOMER_ID = CONTACTS_1.CUSTOMER_ID ON 
                      dbo.REQUESTS.CUSTOMER_CONTACT_ID = CONTACTS_1.CONTACT_ID AND dbo.PROJECTS.CUSTOMER_ID = dbo.CUSTOMERS.CUSTOMER_ID ON 
                      priority_lookup.LOOKUP_ID = dbo.REQUESTS.PRIORITY_TYPE_ID ON 
                      activiy_lookup.LOOKUP_ID = dbo.REQUESTS.ACTIVITY_TYPE_ID1 LEFT OUTER JOIN
                      dbo.LOOKUPS category_lookup ON dbo.REQUESTS.ACTIVITY_CAT_TYPE_ID1 = category_lookup.LOOKUP_ID ON 
                      dbo.REQUEST_VENDORS.REQUEST_ID = dbo.REQUESTS.REQUEST_ID FULL OUTER JOIN
                      dbo.JOB_LOCATIONS_V ON dbo.REQUESTS.JOB_LOCATION_ID = dbo.JOB_LOCATIONS_V.JOB_LOCATION_ID
ORDER BY dbo.REQUESTS.REQUEST_NO

GO

ALTER  VIEW dbo.VERSIONS_COPY_V    
AS    
SELECT    PROJECT_ID, REQUEST_NO, REQUEST_TYPE_ID, REQUEST_STATUS_TYPE_ID, IS_SENT, IS_QUOTED, QUOTE_REQUEST_ID,     
                      DEALER_CUST_ID, CUSTOMER_PO_NO, DEALER_PO_NO, DEALER_PO_LINE_NO, DEALER_PROJECT_NO, DESIGN_PROJECT_NO,     
                      PROJECT_VOLUME, ACCOUNT_TYPE_ID, QUOTE_TYPE_ID, QUOTE_NEEDED_BY, JOB_LOCATION_ID, CUSTOMER_CONTACT_ID,     
                      ALT_CUSTOMER_CONTACT_ID, D_SALES_REP_CONTACT_ID, D_SALES_SUP_CONTACT_ID, D_PROJ_MGR_CONTACT_ID,     
                      D_DESIGNER_CONTACT_ID, A_M_CONTACT_ID, A_M_INSTALL_SUP_CONTACT_ID, A_D_DESIGNER_CONTACT_ID, GEN_CONTRACTOR_CONTACT_ID,     
                      ELECTRICIAN_CONTACT_ID, DATA_PHONE_CONTACT_ID, CARPET_LAYER_CONTACT_ID, BLDG_MGR_CONTACT_ID, SECURITY_CONTACT_ID,     
                      MOVER_CONTACT_ID, OTHER_CONTACT_ID, PRI_FURN_TYPE_ID, PRI_FURN_LINE_TYPE_ID, SEC_FURN_TYPE_ID, SEC_FURN_LINE_TYPE_ID,     
                      CASE_FURN_TYPE_ID, CASE_FURN_LINE_TYPE_ID, WOOD_PRODUCT_TYPE_ID, DELIVERY_TYPE_ID, WAREHOUSE_LOC, FURN_PLAN_TYPE_ID,     
                      PLAN_LOCATION, FURN_SPEC_TYPE_ID, WORKSTATION_TYPICAL_TYPE_ID, POWER_TYPE, PUNCHLIST_ITEM_TYPE_ID, PUNCHLIST_LINE,     
                      WALL_MOUNT_TYPE_ID, INIT_PROJ_TEAM_MTG_DATE, DESIGN_PRESENTATION_DATE, DESIGN_COMPLETION_DATE, SPEC_CHECK_CMPL_DATE,     
                      DEALER_ORDER_PLACED_DATE, INT_PRE_INSTALL_MTG_DATE, EXT_PRE_INSTALL_MTG_DATE, DEALER_INSTALL_PLAN_DATE, MFG_SHIP_DATE,     
                      PROD_DEL_TO_WH_DATE, TRUCK_ARRIVAL_TIME, CONSTRUCT_COMPLETE_DATE, ELECTRICAL_COMPLETE_DATE, CABLE_COMPLETE_DATE,     
                      CARPET_COMPLETE_DATE, SITE_VISIT_REQ_TYPE_ID, SITE_VISIT_DATE, PRODUCT_DEL_TO_SITE_DATE, SCHEDULE_TYPE_ID, EST_START_DATE,     
                      EST_START_TIME, EST_END_DATE, MOVE_IN_DATE, PUNCHLIST_COMPLETE_DATE, COORD_PHONE_DATA_TYPE_ID,     
                      COORD_WALL_COVR_TYPE_ID, COORD_FLOOR_COVR_TYPE_ID, COORD_ELECTRICAL_TYPE_ID, COORD_MOVER_TYPE_ID, ACTIVITY_TYPE_ID1,     
                      QTY1, ACTIVITY_CAT_TYPE_ID1, ACTIVITY_TYPE_ID2, QTY2, ACTIVITY_CAT_TYPE_ID2, ACTIVITY_TYPE_ID3, QTY3, ACTIVITY_CAT_TYPE_ID3,     
                      ACTIVITY_TYPE_ID4, QTY4, ACTIVITY_CAT_TYPE_ID4, ACTIVITY_TYPE_ID5, QTY5, ACTIVITY_CAT_TYPE_ID5, ACTIVITY_TYPE_ID6, QTY6,     
                      ACTIVITY_CAT_TYPE_ID6, ACTIVITY_TYPE_ID7, QTY7, ACTIVITY_CAT_TYPE_ID7, ACTIVITY_TYPE_ID8, QTY8, ACTIVITY_CAT_TYPE_ID8,     
                      ACTIVITY_TYPE_ID9, QTY9, ACTIVITY_CAT_TYPE_ID9, ACTIVITY_TYPE_ID10, QTY10, ACTIVITY_CAT_TYPE_ID10, DESCRIPTION,     
                      APPROVAL_REQ_TYPE_ID, WHO_CAN_APPROVE_NAME, WHO_CAN_APPROVE_PHONE, REGULAR_HOURS_TYPE_ID, EVENING_HOURS_TYPE_ID,     
                      WEEKEND_HOURS_TYPE_ID, UNION_LABOR_REQ_TYPE_ID, COST_TO_CUST_TYPE_ID, COST_TO_VEND_TYPE_ID, COST_TO_JOB_TYPE_ID,     
                      WAREHOUSE_FEE_TYPE_ID, TAXABLE_FLAG, DURATION_TIME_UOM_TYPE_ID, DURATION_QTY, PHASED_INSTALL_TYPE_ID,     
                      LOADING_DOCK_TYPE_ID, DOCK_AVAILABLE_TIME, DOCK_RESERV_REQ_TYPE_ID, SEMI_ACCESS_TYPE_ID, DOCK_HEIGHT,     
                      ELEVATOR_AVAIL_TYPE_ID, ELEVATOR_AVAIL_TIME, ELEVATOR_RESERV_REQ_TYPE_ID, STAIR_CARRY_TYPE_ID, STAIR_CARRY_FLIGHTS,     
                      STAIR_CARRY_STAIRS, SMALLEST_DOOR_ELEV_WIDTH, FLOOR_PROTECTION_TYPE_ID, WALL_PROTECTION_TYPE_ID,     
                      DOORWAY_PROT_TYPE_ID, WALKBOARD_TYPE_ID, STAGING_AREA_TYPE_ID, DUMPSTER_TYPE_ID, NEW_SITE_TYPE_ID,     
                      OCCUPIED_SITE_TYPE_ID, OTHER_CONDITIONS, DATE_CREATED, CREATED_BY, DATE_MODIFIED, MODIFIED_BY, VERSION_NO,     
                      P_CARD_NUMBER, FURNITURE1_CONTACT_ID, FURNITURE2_CONTACT_ID, APPROVER_CONTACT_ID, PHONE_CONTACT_ID,     
                      FLOOR_NUMBER_TYPE_ID, PRIORITY_TYPE_ID, LEVEL_TYPE_ID, FURN_REQ_TYPE_ID, CUST_CONTACT_MOD_DATE, JOB_LOCATION_MOD_DATE,     
                      CUST_COL_1, CUST_COL_2, CUST_COL_3, CUST_COL_4, CUST_COL_5, CUST_COL_6, CUST_COL_7, CUST_COL_8, CUST_COL_9, CUST_COL_10,     
                      IS_COPY, IS_SURVEYED, FURNITURE_TYPE, FURNITURE_QTY, PROD_DISP_FLAG, PROD_DISP_ID, A_M_SALES_CONTACT_ID,
                      WORK_ORDER_RECEIVED_DATE, IS_SENT_DATE
FROM         dbo.REQUESTS    
go
