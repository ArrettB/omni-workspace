CREATE VIEW dbo.crystal_csc_pkf_WORK_ORDER_MASTER_V
AS
SELECT     TOP 100 PERCENT dbo.REQUESTS.PROJECT_ID, dbo.PROJECTS.PROJECT_NO, dbo.REQUESTS.REQUEST_NO, dbo.REQUESTS.PRIORITY_TYPE_ID, 
                      priority_lookup.NAME AS PRIORITY, dbo.REQUESTS.LEVEL_TYPE_ID, CONTACTS_1.CONTACT_NAME AS Customer_Contact, 
                      dbo.REQUEST_VENDORS.VENDOR_CONTACT_ID, VENDOR_CONTACT.CONTACT_NAME AS VENDOR_NAME, dbo.REQUESTS.EST_START_DATE, 
                      dbo.REQUESTS.EST_START_TIME, dbo.REQUESTS.EST_END_DATE, dbo.REQUEST_VENDORS.DATE_CREATED, dbo.REQUESTS.IS_SENT_DATE, 
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
                      dbo.JOB_LOCATIONS_V.CITY, dbo.JOB_LOCATIONS_V.STATE, dbo.JOB_LOCATIONS_V.ZIP, dbo.REQUESTS.WORK_ORDER_RECEIVED_DATE
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

