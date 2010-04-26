CREATE VIEW dbo.pda_services_v
AS
SELECT     TOP 100 PERCENT dbo.PDA_JOBS_V.ims_user_id, dbo.SERVICES.SERVICE_ID, dbo.SERVICES.SERVICE_NO, dbo.SERVICES.JOB_ID, 
                      ISNULL(dbo.CONTACTS.CONTACT_NAME, 'N/A') AS contact, ISNULL(dbo.CONTACTS.PHONE_WORK, 'N/A') AS phone, 
                      substring(ISNULL(dbo.SERVICES.DESCRIPTION, 'N/A'),1,500) AS [desc], dbo.JOB_LOCATIONS.JOB_LOCATION_NAME AS job_loc, REPORT_TO.NAME AS report_to, 
                      dbo.SERVICES.EST_START_DATE AS start_date, LTRIM(SUBSTRING(CONVERT(varchar, dbo.SERVICES.EST_START_DATE, 100), 13, 7)) AS start_time, 
                      address = CASE WHEN dbo.JOB_LOCATIONS.street2 IS NULL AND dbo.JOB_LOCATIONS.street3 IS NULL THEN ISNULL(dbo.JOB_LOCATIONS.street1, 
                      '') + char(10) + ISNULL(dbo.JOB_LOCATIONS.city, '') + ', ' + ISNULL(dbo.JOB_LOCATIONS.state, '') + ' ' + ISNULL(dbo.JOB_LOCATIONS.zip, '') 
                      WHEN dbo.JOB_LOCATIONS.street3 IS NULL THEN dbo.JOB_LOCATIONS.street1 + char(10) + dbo.JOB_LOCATIONS.street2 + char(10) 
                      + ISNULL(dbo.JOB_LOCATIONS.city, '') + ', ' + ISNULL(dbo.JOB_LOCATIONS.state, '') + ' ' + ISNULL(dbo.JOB_LOCATIONS.zip, '') 
                      ELSE dbo.JOB_LOCATIONS.street1 + char(10) + dbo.JOB_LOCATIONS.street2 + char(10) + dbo.JOB_LOCATIONS.street3 + char(10) 
                      + ISNULL(dbo.JOB_LOCATIONS.city, '') + ', ' + ISNULL(dbo.JOB_LOCATIONS.state, '') + '' + ISNULL(dbo.JOB_LOCATIONS.zip, '') END
FROM         dbo.JOBS INNER JOIN
                      dbo.SERVICES ON dbo.JOBS.JOB_ID = dbo.SERVICES.JOB_ID INNER JOIN
                      dbo.PDA_JOBS_V ON dbo.JOBS.JOB_ID = dbo.PDA_JOBS_V.JOB_ID LEFT OUTER JOIN
                      dbo.LOOKUPS REPORT_TO ON dbo.SERVICES.REPORT_TO_LOC_ID = REPORT_TO.LOOKUP_ID LEFT OUTER JOIN
                      dbo.JOB_LOCATIONS LEFT OUTER JOIN
                      dbo.CONTACTS ON dbo.JOB_LOCATIONS.JOB_LOC_CONTACT_ID = dbo.CONTACTS.CONTACT_ID ON 
                      dbo.SERVICES.JOB_LOCATION_ID = dbo.JOB_LOCATIONS.JOB_LOCATION_ID LEFT OUTER JOIN
                      dbo.LOOKUPS Service_Status ON dbo.SERVICES.SERV_STATUS_TYPE_ID = Service_Status.LOOKUP_ID
WHERE     (Service_Status.CODE <> 'closed')


