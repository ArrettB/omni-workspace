
CREATE VIEW dbo.REQUEST_VENDORS_V2
AS
SELECT     TOP 100 PERCENT cust.ORGANIZATION_ID, r.PROJECT_ID, r.REQUEST_ID, cust.CUSTOMER_ID, cust.PARENT_CUSTOMER_ID, 
                      rv.REQUEST_VENDOR_ID, rv.VENDOR_CONTACT_ID, p.PROJECT_NO, r.REQUEST_NO, CONVERT(varchar, p.PROJECT_NO) + '-' + CONVERT(varchar, 
                      r.REQUEST_NO) AS workorder_no, dbo.CONTACTS.CONTACT_NAME AS vendor_contact_name, cust.DEALER_NAME, cust.EXT_DEALER_ID, 
                      cust.CUSTOMER_NAME, r.DEALER_PO_NO, r.CUSTOMER_PO_NO, r.EST_START_DATE, rv.EMAILED_DATE, priorities.NAME AS priority, 
                      rv.SCH_START_DATE, rv.SCH_START_TIME, rv.SCH_END_DATE, rv.ACT_START_DATE, rv.ACT_START_TIME, rv.ACT_END_DATE, 
                      rv.ESTIMATED_COST, rv.TOTAL_COST, rv.INVOICE_DATE, rv.INVOICE_NUMBERS, rv.VISIT_COUNT, rv.COMPLETE_FLAG, rv.INVOICED_FLAG, 
                      rv.VENDOR_NOTES, rv.DATE_CREATED, rv.CREATED_BY, Created.FULL_NAME AS created_by_name, rv.DATE_MODIFIED, rv.MODIFIED_BY, 
                      Modified.FULL_NAME AS modified_by_name, request_types.CODE AS request_type_code, status.SEQUENCE_NO AS status_seq_no, 
                      status.CODE AS request_status_type_code, status.NAME AS request_status_type_name, CONVERT(VARCHAR(12), r.EST_START_DATE, 101) 
                      AS est_start_date_varchar, CONVERT(VARCHAR(12), r.EST_END_DATE, 101) AS est_end_date_varchar, CONVERT(VARCHAR(12), rv.SCH_START_DATE, 
                      101) AS sch_start_date_varchar, CONVERT(VARCHAR(12), rv.SCH_END_DATE, 101) AS sch_end_date_varchar, CONVERT(VARCHAR(12), 
                      rv.INVOICE_DATE, 101) AS invoice_date_varchar, r.FURNITURE1_CONTACT_ID, r.FURNITURE2_CONTACT_ID
FROM         dbo.CUSTOMERS cust RIGHT OUTER JOIN
                      dbo.USERS Created RIGHT OUTER JOIN
                      dbo.LOOKUPS priorities RIGHT OUTER JOIN
                      dbo.LOOKUPS request_types RIGHT OUTER JOIN
                      dbo.CONTACTS RIGHT OUTER JOIN
                      dbo.PROJECTS p INNER JOIN
                      dbo.REQUESTS r ON p.PROJECT_ID = r.PROJECT_ID RIGHT OUTER JOIN
                      dbo.REQUEST_VENDORS rv ON r.REQUEST_ID = rv.REQUEST_ID ON dbo.CONTACTS.CONTACT_ID = rv.VENDOR_CONTACT_ID LEFT OUTER JOIN
                      dbo.USERS Modified ON rv.MODIFIED_BY = Modified.USER_ID ON request_types.LOOKUP_ID = r.REQUEST_TYPE_ID LEFT OUTER JOIN
                      dbo.LOOKUPS status ON r.REQUEST_STATUS_TYPE_ID = status.LOOKUP_ID ON priorities.LOOKUP_ID = r.PRIORITY_TYPE_ID ON 
                      Created.USER_ID = rv.CREATED_BY ON cust.CUSTOMER_ID = p.CUSTOMER_ID
WHERE     (r.VERSION_NO =
                          (SELECT     MAX(r2.version_no)
                            FROM          requests r2
                            WHERE      r2.project_id = r.project_id AND r2.request_no = r.request_no))
ORDER BY rv.SCH_START_DATE


