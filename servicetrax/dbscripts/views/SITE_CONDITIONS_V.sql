CREATE VIEW dbo.SITE_CONDITIONS_V
AS
SELECT     dbo.REQUESTS.REQUEST_ID, dbo.REQUESTS.PROJECT_ID, dbo.REQUESTS.REQUEST_NO, dbo.LOOKUPS.NAME AS LOAD_DOCK_AVAIL, 
                      dbo.JOB_LOCATIONS.DOCK_AVAILABLE_TIME, LOOKUPS_1.NAME AS DOCK_RESERV_REQ, LOOKUPS_2.NAME AS SEMI_ACCESS, 
                      dbo.JOB_LOCATIONS.DOCK_HEIGHT, LOOKUPS_3.NAME AS ELEVATOR_AVAIL, LOOKUPS_4.NAME AS ELEVATOR_RESERV_REQ, 
                      LOOKUPS_5.NAME AS SECURITY, LOOKUPS_6.NAME AS MULTI_LEVEL, LOOKUPS_7.NAME AS STAIR_CARRY, 
                      dbo.JOB_LOCATIONS.STAIR_CARRY_FLIGHTS, dbo.JOB_LOCATIONS.STAIR_CARRY_STAIRS, dbo.JOB_LOCATIONS.SMALLEST_DOOR_ELEV_WIDTH, 
                      LOOKUPS_8.NAME AS FLOOR_PROTECT, LOOKUPS_9.NAME AS WALL_PROTECT, LOOKUPS_10.NAME AS DOORWAY_PROTECT
FROM         dbo.REQUESTS INNER JOIN
                      dbo.JOB_LOCATIONS ON dbo.REQUESTS.JOB_LOCATION_ID = dbo.JOB_LOCATIONS.JOB_LOCATION_ID LEFT OUTER JOIN
                      dbo.LOOKUPS LOOKUPS_10 ON dbo.JOB_LOCATIONS.DOORWAY_PROT_TYPE_ID = LOOKUPS_10.LOOKUP_ID LEFT OUTER JOIN
                      dbo.LOOKUPS LOOKUPS_9 ON dbo.JOB_LOCATIONS.WALL_PROTECTION_TYPE_ID = LOOKUPS_9.LOOKUP_ID LEFT OUTER JOIN
                      dbo.LOOKUPS LOOKUPS_8 ON dbo.JOB_LOCATIONS.FLOOR_PROTECTION_TYPE_ID = LOOKUPS_8.LOOKUP_ID LEFT OUTER JOIN
                      dbo.LOOKUPS LOOKUPS_7 ON dbo.JOB_LOCATIONS.STAIR_CARRY_TYPE_ID = LOOKUPS_7.LOOKUP_ID LEFT OUTER JOIN
                      dbo.LOOKUPS LOOKUPS_6 ON dbo.JOB_LOCATIONS.MULTI_LEVEL_TYPE_ID = LOOKUPS_6.LOOKUP_ID LEFT OUTER JOIN
                      dbo.LOOKUPS LOOKUPS_5 ON dbo.JOB_LOCATIONS.SECURITY_TYPE_ID = LOOKUPS_5.LOOKUP_ID LEFT OUTER JOIN
                      dbo.LOOKUPS LOOKUPS_4 ON dbo.JOB_LOCATIONS.ELEVATOR_RESERV_REQ_TYPE_ID = LOOKUPS_4.LOOKUP_ID LEFT OUTER JOIN
                      dbo.LOOKUPS LOOKUPS_3 ON dbo.JOB_LOCATIONS.ELEVATOR_AVAIL_TYPE_ID = LOOKUPS_3.LOOKUP_ID LEFT OUTER JOIN
                      dbo.LOOKUPS LOOKUPS_2 ON dbo.JOB_LOCATIONS.SEMI_ACCESS_TYPE_ID = LOOKUPS_2.LOOKUP_ID LEFT OUTER JOIN
                      dbo.LOOKUPS LOOKUPS_1 ON dbo.JOB_LOCATIONS.DOCK_RESERV_REQ_TYPE_ID = LOOKUPS_1.LOOKUP_ID LEFT OUTER JOIN
                      dbo.LOOKUPS ON dbo.JOB_LOCATIONS.LOADING_DOCK_TYPE_ID = dbo.LOOKUPS.LOOKUP_ID
