CREATE VIEW dbo.REQUEST_VENDORS_V
AS
SELECT     TOP 100 PERCENT c.ORGANIZATION_ID, r.PROJECT_ID, rv.REQUEST_ID, p.CUSTOMER_ID, c.PARENT_CUSTOMER_ID, rv.REQUEST_VENDOR_ID, 
                      rv.VENDOR_CONTACT_ID, p.PROJECT_NO, r.REQUEST_NO, CONVERT(varchar, p.PROJECT_NO) + '-' + CONVERT(varchar, r.REQUEST_NO) 
                      AS workorder_no, dbo.CONTACTS.CONTACT_NAME AS vendor_contact_name, c.DEALER_NAME, c.EXT_DEALER_ID, c.CUSTOMER_NAME, 
                      r.DEALER_PO_NO, r.CUSTOMER_PO_NO, r.EST_START_DATE, rv.EMAILED_DATE, priorities.NAME AS priority, rv.SCH_START_DATE, 
                      rv.SCH_START_TIME, rv.SCH_END_DATE, rv.ACT_START_DATE, rv.ACT_START_TIME, rv.ACT_END_DATE, rv.ESTIMATED_COST, rv.TOTAL_COST, 
                      rv.INVOICE_DATE, rv.INVOICE_NUMBERS, rv.VISIT_COUNT, rv.COMPLETE_FLAG, rv.INVOICED_FLAG, rv.VENDOR_NOTES, rv.DATE_CREATED, 
                      rv.CREATED_BY, USERS_1.FULL_NAME AS created_by_name, rv.DATE_MODIFIED, rv.MODIFIED_BY, USERS_2.FULL_NAME AS modified_by_name, 
                      request_types.CODE AS request_type_code, dbo.LOOKUPS_V.SEQUENCE_NO AS approved_seq_no, status.SEQUENCE_NO AS status_seq_no, 
                      status.CODE AS request_status_type_code, status.NAME AS request_status_type_name, CONVERT(VARCHAR(12), r.EST_START_DATE, 101) 
                      AS est_start_date_varchar, CONVERT(VARCHAR(12), r.EST_END_DATE, 101) AS est_end_date_varchar, CONVERT(VARCHAR(12), rv.SCH_START_DATE, 
                      101) AS sch_start_date_varchar, CONVERT(VARCHAR(12), rv.SCH_END_DATE, 101) AS sch_end_date_varchar, CONVERT(VARCHAR(12), 
                      rv.INVOICE_DATE, 101) AS invoice_date_varchar
FROM         dbo.CUSTOMERS c RIGHT OUTER JOIN
                      dbo.USERS USERS_1 RIGHT OUTER JOIN
                      dbo.LOOKUPS priorities RIGHT OUTER JOIN
                      dbo.LOOKUPS request_types RIGHT OUTER JOIN
                      dbo.CONTACTS RIGHT OUTER JOIN
                      dbo.VERSIONS_MAX_NO_V INNER JOIN
                      dbo.PROJECTS p ON dbo.VERSIONS_MAX_NO_V.PROJECT_ID = p.PROJECT_ID INNER JOIN
                      dbo.REQUESTS r ON dbo.VERSIONS_MAX_NO_V.PROJECT_ID = r.PROJECT_ID AND dbo.VERSIONS_MAX_NO_V.REQUEST_NO = r.REQUEST_NO AND 
                      dbo.VERSIONS_MAX_NO_V.max_version_no = r.VERSION_NO AND p.PROJECT_ID = r.PROJECT_ID RIGHT OUTER JOIN
                      dbo.REQUEST_VENDORS rv ON r.REQUEST_ID = rv.REQUEST_ID ON dbo.CONTACTS.CONTACT_ID = rv.VENDOR_CONTACT_ID LEFT OUTER JOIN
                      dbo.USERS USERS_2 ON rv.MODIFIED_BY = USERS_2.USER_ID ON request_types.LOOKUP_ID = r.REQUEST_TYPE_ID LEFT OUTER JOIN
                      dbo.LOOKUPS status ON r.REQUEST_STATUS_TYPE_ID = status.LOOKUP_ID ON priorities.LOOKUP_ID = r.PRIORITY_TYPE_ID ON 
                      USERS_1.USER_ID = rv.CREATED_BY ON c.CUSTOMER_ID = p.CUSTOMER_ID CROSS JOIN
                      dbo.LOOKUPS_V
WHERE     (dbo.LOOKUPS_V.type_code = 'workorder_status_type') AND (dbo.LOOKUPS_V.lookup_code = 'approved')
ORDER BY rv.SCH_START_DATE

