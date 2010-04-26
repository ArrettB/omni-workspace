CREATE VIEW dbo.PDA_PDS_V
AS
SELECT     dbo.PDA_JOBS_V.ims_user_id, dbo.JOBS.JOB_ID, dbo.JOBS.JOB_NO, dbo.SERVICES.SERVICE_ID, dbo.SERVICES.SERVICE_NO, 
                      substring(ISNULL(dbo.REQUESTS.DESCRIPTION, dbo.SERVICES.DESCRIPTION),1,500) AS [desc], dbo.JOB_LOCATIONS.JOB_LOCATION_NAME AS job_locat, 
                      CONVERT(varchar, dbo.REQUESTS.DEALER_PO_NO) + '-' + CONVERT(varchar, dbo.REQUESTS.DEALER_PO_LINE_NO) AS d_po_no, 
                      dealer_sales_rep.CONTACT_NAME AS dsr_name, dealer_sales_rep.PHONE_WORK AS dsr_phone, customer.CONTACT_NAME AS c_name, 
                      customer.PHONE_WORK AS c_phone, a_m.CONTACT_NAME AS am_name, a_m.PHONE_WORK AS am_phone, 
                      dealer_sales_sup.CONTACT_NAME AS dss_name, dealer_sales_sup.PHONE_WORK AS dss_phone, deliv.NAME AS deliv_by, 
                      furn_plan.NAME AS [plan], dbo.REQUESTS.ELEVATOR_AVAIL_TIME AS elev, dbo.REQUESTS.DOCK_AVAILABLE_TIME AS dock, 
                      dbo.REQUESTS.WHO_CAN_APPROVE_NAME AS a_name, dbo.REQUESTS.WHO_CAN_APPROVE_PHONE AS a_phone, 
                      dbo.REQUESTS.PLAN_LOCATION AS plan_locat, dbo.REQUESTS.WAREHOUSE_LOC AS location, dbo.SERVICES.EST_START_DATE AS ins_date, 
                      dbo.SERVICES.EST_START_TIME AS ins_time, dbo.SERVICES.EST_END_DATE AS target, Wall.NAME AS wall, 
                      dbo.CUSTOMERS.CUSTOMER_NAME AS customer, address = CASE WHEN dbo.JOB_LOCATIONS.street2 IS NULL AND 
                      dbo.JOB_LOCATIONS.street3 IS NULL THEN ISNULL(dbo.JOB_LOCATIONS.street1, '') + char(10) + ISNULL(dbo.JOB_LOCATIONS.city, '') 
                      + ', ' + ISNULL(dbo.JOB_LOCATIONS.state, '') + ' ' + ISNULL(dbo.JOB_LOCATIONS.zip, '') WHEN dbo.JOB_LOCATIONS.street3 IS NULL 
                      THEN dbo.JOB_LOCATIONS.street1 + char(10) + dbo.JOB_LOCATIONS.street2 + char(10) + ISNULL(dbo.JOB_LOCATIONS.city, '') 
                      + ', ' + ISNULL(dbo.JOB_LOCATIONS.state, '') + ' ' + ISNULL(dbo.JOB_LOCATIONS.zip, '') ELSE dbo.JOB_LOCATIONS.street1 + char(10) 
                      + dbo.JOB_LOCATIONS.street2 + char(10) + dbo.JOB_LOCATIONS.street3 + char(10) + ISNULL(dbo.JOB_LOCATIONS.city, '') 
                      + ', ' + ISNULL(dbo.JOB_LOCATIONS.state, '') + '' + ISNULL(dbo.JOB_LOCATIONS.zip, '') END
FROM         dbo.CONTACTS dealer_sales_sup RIGHT OUTER JOIN
                      dbo.JOB_LOCATIONS RIGHT OUTER JOIN
                      dbo.JOBS INNER JOIN
                      dbo.PDA_JOBS_V ON dbo.JOBS.JOB_ID = dbo.PDA_JOBS_V.JOB_ID INNER JOIN
                      dbo.SERVICES ON dbo.JOBS.JOB_ID = dbo.SERVICES.JOB_ID INNER JOIN
                      dbo.LOOKUPS Service_statuses ON dbo.SERVICES.SERV_STATUS_TYPE_ID = Service_statuses.LOOKUP_ID ON 
                      dbo.JOB_LOCATIONS.JOB_LOCATION_ID = dbo.SERVICES.JOB_LOCATION_ID LEFT OUTER JOIN
                      dbo.CONTACTS dealer_sales_rep ON dbo.SERVICES.SUPPORT_CONTACT_ID = dealer_sales_rep.CONTACT_ID ON 
                      dealer_sales_sup.CONTACT_ID = dbo.SERVICES.SUPPORT_CONTACT_ID LEFT OUTER JOIN
                      dbo.CONTACTS customer ON dbo.SERVICES.IDM_CONTACT_ID = customer.CONTACT_ID LEFT OUTER JOIN
                      dbo.CONTACTS a_m ON dbo.SERVICES.IDM_CONTACT_ID = a_m.CONTACT_ID LEFT OUTER JOIN
                      dbo.CUSTOMERS ON dbo.JOBS.CUSTOMER_ID = dbo.CUSTOMERS.CUSTOMER_ID LEFT OUTER JOIN
                      dbo.LOOKUPS Wall RIGHT OUTER JOIN
                      dbo.REQUESTS ON Wall.LOOKUP_ID = dbo.REQUESTS.WALL_MOUNT_TYPE_ID LEFT OUTER JOIN
                      dbo.LOOKUPS deliv ON dbo.REQUESTS.DELIVERY_TYPE_ID = deliv.LOOKUP_ID LEFT OUTER JOIN
                      dbo.LOOKUPS furn_plan ON dbo.REQUESTS.FURN_PLAN_TYPE_ID = furn_plan.LOOKUP_ID ON 
                      dbo.SERVICES.REQUEST_ID = dbo.REQUESTS.REQUEST_ID
WHERE     (Service_statuses.CODE <> 'closed')


