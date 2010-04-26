ALTER VIEW dbo.REQUEST_SCHEDULE_DIFF_V
AS
SELECT     requests_a.REQUEST_ID, requests_b.REQUEST_ID AS REQUEST_ID_B, ISNULL(requests_a.SCHEDULE_TYPE_ID, - 1) AS SCHEDULE_TYPE_ID, 
		ISNULL(requests_b.SCHEDULE_TYPE_ID, - 1) AS SCHEDULE_TYPE_ID_B, ISNULL(schedule_types.NAME, 'None') AS schedule_type_name, 
		ISNULL(schedule_types_b.NAME, 'None') AS schedule_type_name_b, ISNULL(CONVERT(VARCHAR(12), requests_a.EST_START_DATE, 101), - 1) 
		AS EST_START_DATE, ISNULL(CONVERT(VARCHAR(12), requests_b.EST_START_DATE, 101), - 1) AS EST_START_DATE_B, 
		ISNULL(CONVERT(VARCHAR(17), requests_a.EST_START_TIME, 113), - 1) AS EST_START_TIME, ISNULL(CONVERT(VARCHAR(17), 
		requests_b.EST_START_TIME, 113), - 1) AS EST_START_TIME_B, ISNULL(CONVERT(VARCHAR(12), requests_a.EST_END_DATE, 101), - 1) 
		AS EST_END_DATE, ISNULL(CONVERT(VARCHAR(12), requests_b.EST_END_DATE, 101), - 1) AS EST_END_DATE_B, ISNULL(requests_a.DESCRIPTION,
		'None') AS DESCRIPTION, ISNULL(requests_b.DESCRIPTION, 'None') AS DESCRIPTION_B, ISNULL(requests_a.OTHER_CONDITIONS, 'None') 
		AS OTHER_CONDITIONS, ISNULL(requests_b.OTHER_CONDITIONS, 'None') AS OTHER_CONDITIONS_B, 
		ISNULL(requests_a.CUST_CONTACT_MOD_DATE, - 1) AS CUST_CONTACT_MOD_DATE, ISNULL(requests_b.CUST_CONTACT_MOD_DATE, - 1) 
		AS CUST_CONTACT_MOD_DATE_B, ISNULL(requests_a.JOB_LOCATION_MOD_DATE, - 1) AS JOB_LOCATION_MOD_DATE, 
		ISNULL(requests_b.JOB_LOCATION_MOD_DATE, - 1) AS JOB_LOCATION_MOD_DATE_B, ISNULL(job_locations_b.JOB_LOCATION_NAME, 'None') 
		AS JOB_LOCATION_NAME_B, ISNULL(job_locations_b.STREET1, 'None') AS STREET1_B, ISNULL(job_locations_b.STREET2, 'None') AS STREET2_B, 
		ISNULL(job_locations_b.STREET3, 'None') AS STREET3_B, ISNULL(job_locations_b.CITY, 'None') AS CITY_B, ISNULL(job_locations_b.STATE, 'None') 
		AS STATE_B, ISNULL(job_locations_b.ZIP, 'None') AS ZIP_B, ISNULL(contacts_b.CONTACT_NAME, 'None') AS CONTACT_NAME_B, 
		ISNULL(contacts_b.PHONE_WORK, 'None') AS PHONE_WORK_B, ISNULL(contacts_b.PHONE_CELL, 'None') AS PHONE_CELL_B, 
		LOOKUPS_1.CODE AS request_type_code
FROM         dbo.LOOKUPS schedule_types INNER JOIN dbo.PROJECTS
		RIGHT OUTER JOIN dbo.REQUESTS requests_a
		INNER JOIN dbo.REQUESTS requests_b
		ON requests_a.PROJECT_ID = requests_b.PROJECT_ID
		AND requests_a.REQUEST_NO = requests_b.REQUEST_NO
		INNER JOIN dbo.LOOKUPS LOOKUPS_1
		ON requests_b.REQUEST_TYPE_ID = LOOKUPS_1.LOOKUP_ID
		ON dbo.PROJECTS.PROJECT_ID = requests_b.PROJECT_ID
		LEFT OUTER JOIN dbo.LOOKUPS schedule_types_b
		ON requests_b.SCHEDULE_TYPE_ID = schedule_types_b.LOOKUP_ID
		ON schedule_types.LOOKUP_ID = requests_a.SCHEDULE_TYPE_ID
		LEFT OUTER JOIN dbo.CONTACTS contacts_b
		ON requests_b.CUSTOMER_CONTACT_ID = contacts_b.CONTACT_ID
		LEFT OUTER JOIN dbo.JOB_LOCATIONS job_locations_b
		ON requests_b.JOB_LOCATION_ID = job_locations_b.JOB_LOCATION_ID
WHERE      (LOOKUPS_1.CODE = 'workorder')
		OR (LOOKUPS_1.CODE = 'service_request')

