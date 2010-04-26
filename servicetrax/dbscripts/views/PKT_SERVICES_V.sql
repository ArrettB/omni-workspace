
CREATE VIEW dbo.PKT_SERVICES_V

AS

SELECT     dbo.SERVICES.JOB_ID, dbo.JOBS.JOB_NO, dbo.JOBS.JOB_NAME, dbo.CUSTOMERS.CUSTOMER_NAME, dbo.SERVICES.SERVICE_ID, 

                      dbo.SERVICES.SERVICE_NO, dbo.SERVICES.DESCRIPTION AS service_description, dbo.REQUESTS.OTHER_CONDITIONS, 

                      dbo.JOB_LOCATIONS.JOB_LOCATION_NAME, CONVERT(varchar, dbo.JOBS.JOB_NO) + ' - ' + CONVERT(varchar, dbo.SERVICES.SERVICE_NO) 

                      AS job_service_no, dbo.REQUESTS.DEALER_PO_NO, priority.NAME AS priority, [LEVEL].NAME AS [level], dbo.REQUESTS.REQUEST_ID, 

                      dbo.JOB_LOCATIONS.STREET1, dbo.JOB_LOCATIONS.STREET2, dbo.JOB_LOCATIONS.STREET3, dbo.JOB_LOCATIONS.CITY, 

                      dbo.JOB_LOCATIONS.STATE, dbo.JOB_LOCATIONS.ZIP, dbo.SERVICES.SCH_START_DATE, dbo.REQUESTS.DOCK_AVAILABLE_TIME AS dock_time, 

                      dbo.REQUESTS.ELEVATOR_AVAIL_TIME AS elev_time, wall_mount.NAME AS wall_mount, PLAN_L.NAME AS plan_name, deliv.NAME AS delivery_by, 

                      dbo.REQUESTS.QUOTE_REQUEST_ID, change_order.NAME AS change_order

FROM         dbo.LOOKUPS PLAN_L RIGHT OUTER JOIN

                      dbo.LOOKUPS deliv INNER JOIN

                      dbo.REQUESTS ON deliv.LOOKUP_ID = dbo.REQUESTS.DELIVERY_TYPE_ID LEFT OUTER JOIN

                      dbo.LOOKUPS wall_mount ON dbo.REQUESTS.WALL_MOUNT_TYPE_ID = wall_mount.LOOKUP_ID ON 

                      PLAN_L.LOOKUP_ID = dbo.REQUESTS.FURN_PLAN_TYPE_ID LEFT OUTER JOIN

                      dbo.LOOKUPS [LEVEL] ON dbo.REQUESTS.LEVEL_TYPE_ID = [LEVEL].LOOKUP_ID LEFT OUTER JOIN

                      dbo.LOOKUPS priority ON dbo.REQUESTS.PRIORITY_TYPE_ID = priority.LOOKUP_ID RIGHT OUTER JOIN

                      dbo.SERVICES INNER JOIN

                      dbo.JOBS ON dbo.SERVICES.JOB_ID = dbo.JOBS.JOB_ID INNER JOIN

                      dbo.CUSTOMERS ON dbo.JOBS.CUSTOMER_ID = dbo.CUSTOMERS.CUSTOMER_ID ON 

                      dbo.REQUESTS.REQUEST_ID = dbo.SERVICES.REQUEST_ID LEFT OUTER JOIN

                      dbo.JOB_LOCATIONS ON ISNULL(dbo.REQUESTS.JOB_LOCATION_ID, dbo.SERVICES.JOB_LOCATION_ID) 

                      = dbo.JOB_LOCATIONS.JOB_LOCATION_ID INNER JOIN

                      dbo.LOOKUPS service_status ON dbo.SERVICES.SERV_STATUS_TYPE_ID = service_status.LOOKUP_ID LEFT OUTER JOIN

                      dbo.LOOKUPS change_order ON dbo.REQUESTS.APPROVAL_REQ_TYPE_ID = change_order.LOOKUP_ID

WHERE     (service_status.CODE <> 'closed')





