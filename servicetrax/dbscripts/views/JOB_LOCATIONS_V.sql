CREATE VIEW dbo.JOB_LOCATIONS_V
AS
SELECT     dbo.CUSTOMERS.ORGANIZATION_ID, dbo.JOB_LOCATIONS.JOB_LOCATION_ID, dbo.JOB_LOCATIONS.CUSTOMER_ID, 
                      dbo.JOB_LOCATIONS.JOB_LOCATION_NAME, dbo.JOB_LOCATIONS.LOCATION_TYPE_ID, LOOKUPS_1.CODE AS location_type_code, 
                      LOOKUPS_1.NAME AS location_type_name, dbo.JOB_LOCATIONS.EXT_ADDRESS_ID, dbo.JOB_LOCATIONS.STREET1, dbo.JOB_LOCATIONS.STREET2, 
                      dbo.JOB_LOCATIONS.STREET3, dbo.JOB_LOCATIONS.CITY, dbo.JOB_LOCATIONS.STATE, dbo.JOB_LOCATIONS.ZIP, dbo.JOB_LOCATIONS.COUNTRY, 
                      dbo.JOB_LOCATIONS.DIRECTIONS, dbo.JOB_LOCATIONS.JOB_LOC_CONTACT_ID, dbo.JOB_LOCATIONS.BLDG_MGMT_CONTACT_ID, 
                      dbo.JOB_LOCATIONS.MULTI_LEVEL_TYPE_ID, LOOKUPS_3.CODE AS multi_level_type_code, LOOKUPS_3.NAME AS multi_level_type_name, 
                      dbo.JOB_LOCATIONS.FLOOR_PROTECTION_TYPE_ID AS floor_prot_type_id, LOOKUPS_4.CODE AS floor_prot_type_code, 
                      LOOKUPS_4.NAME AS floor_prot_type_name, dbo.JOB_LOCATIONS.LOADING_DOCK_TYPE_ID, LOOKUPS_5.CODE AS loading_dock_type_code, 
                      LOOKUPS_5.NAME AS loading_dock_type_name, dbo.JOB_LOCATIONS.SECURITY_TYPE_ID, LOOKUPS_6.CODE AS security_type_code, 
                      LOOKUPS_6.NAME AS security_type_name, dbo.JOB_LOCATIONS.DATE_CREATED, dbo.JOB_LOCATIONS.CREATED_BY, 
                      USERS_1.FIRST_NAME + ' ' + USERS_1.LAST_NAME AS created_by_name, dbo.JOB_LOCATIONS.DATE_MODIFIED, 
                      dbo.JOB_LOCATIONS.MODIFIED_BY, USERS_2.FIRST_NAME + ' ' + USERS_2.LAST_NAME AS modified_by_name, 
                      dbo.JOB_LOCATIONS.DOCK_AVAILABLE_TIME, dbo.JOB_LOCATIONS.DOCK_RESERV_REQ_TYPE_ID, dbo.JOB_LOCATIONS.SEMI_ACCESS_TYPE_ID, 
                      dbo.JOB_LOCATIONS.DOCK_HEIGHT, dbo.JOB_LOCATIONS.ELEVATOR_AVAIL_TYPE_ID, dbo.JOB_LOCATIONS.ELEVATOR_RESERV_REQ_TYPE_ID, 
                      dbo.JOB_LOCATIONS.FLOOR_PROTECTION_TYPE_ID, dbo.JOB_LOCATIONS.WALL_PROTECTION_TYPE_ID, 
                      dbo.JOB_LOCATIONS.DOORWAY_PROT_TYPE_ID, dbo.JOB_LOCATIONS.STAIR_CARRY_TYPE_ID, dbo.JOB_LOCATIONS.STAIR_CARRY_FLIGHTS, 
                      dbo.JOB_LOCATIONS.STAIR_CARRY_STAIRS, dbo.JOB_LOCATIONS.SMALLEST_DOOR_ELEV_WIDTH
FROM         dbo.USERS USERS_1 RIGHT OUTER JOIN
                      dbo.USERS USERS_2 RIGHT OUTER JOIN
                      dbo.CUSTOMERS RIGHT OUTER JOIN
                      dbo.JOB_LOCATIONS ON dbo.CUSTOMERS.CUSTOMER_ID = dbo.JOB_LOCATIONS.CUSTOMER_ID LEFT OUTER JOIN
                      dbo.LOOKUPS LOOKUPS_2 ON dbo.JOB_LOCATIONS.MULTI_LEVEL_TYPE_ID = LOOKUPS_2.LOOKUP_ID ON 
                      USERS_2.USER_ID = dbo.JOB_LOCATIONS.MODIFIED_BY ON USERS_1.USER_ID = dbo.JOB_LOCATIONS.CREATED_BY LEFT OUTER JOIN
                      dbo.LOOKUPS LOOKUPS_6 ON dbo.JOB_LOCATIONS.SECURITY_TYPE_ID = LOOKUPS_6.LOOKUP_ID LEFT OUTER JOIN
                      dbo.LOOKUPS LOOKUPS_5 ON dbo.JOB_LOCATIONS.LOADING_DOCK_TYPE_ID = LOOKUPS_5.LOOKUP_ID LEFT OUTER JOIN
                      dbo.LOOKUPS LOOKUPS_4 ON dbo.JOB_LOCATIONS.FLOOR_PROTECTION_TYPE_ID = LOOKUPS_4.LOOKUP_ID LEFT OUTER JOIN
                      dbo.LOOKUPS LOOKUPS_3 ON dbo.JOB_LOCATIONS.MULTI_LEVEL_TYPE_ID = LOOKUPS_3.LOOKUP_ID LEFT OUTER JOIN
                      dbo.LOOKUPS LOOKUPS_1 ON dbo.JOB_LOCATIONS.LOCATION_TYPE_ID = LOOKUPS_1.LOOKUP_ID

