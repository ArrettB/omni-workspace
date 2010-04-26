CREATE VIEW dbo.invoices_arch
AS
SELECT     INVOICE_ID, ORGANIZATION_ID, PO_NO, INVOICE_TYPE_ID, BILLING_TYPE_ID, EXT_BATCH_ID, BATCH_STATUS_ID, ASSIGNED_TO_USER_ID, 
                      INVOICE_FORMAT_TYPE_ID, EXT_INVOICE_ID, STATUS_ID, JOB_ID, DESCRIPTION, GP_DESCRIPTION, COST_CODES, START_DATE, END_DATE, 
                      BILL_CUSTOMER_ID, EXT_BILL_CUST_ID, SALES_REPS, DATE_SENT, DATE_CREATED, CREATED_BY, DATE_MODIFIED, MODIFIED_BY
FROM         dbo.INVOICES
WHERE     (BATCH_STATUS_ID = 3) AND (DATE_MODIFIED < CONVERT(DATETIME, '2002-09-01 00:00:00', 102))

