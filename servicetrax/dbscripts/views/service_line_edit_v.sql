CREATE VIEW dbo.service_line_edit_v
AS
SELECT     ORGANIZATION_ID, SERVICE_LINE_ID, TC_JOB_NO, TC_SERVICE_NO, TC_SERVICE_LINE_NO, SERVICE_LINE_DATE, STATUS_ID, EXPORTED_FLAG, 
                      BILLED_FLAG, POSTED_FLAG, POOLED_FLAG, RESOURCE_ID, RESOURCE_NAME, ITEM_ID, ITEM_NAME, ITEM_TYPE_CODE, INVOICE_ID, 
                      POSTED_FROM_INVOICE_ID, TC_QTY, TC_RATE, TC_TOTAL, PAYROLL_QTY, PAYROLL_RATE, PAYROLL_TOTAL, EXT_PAY_CODE, 
                      PAYROLL_EXPORTED_FLAG, ALLOCATED_QTY, INTERNAL_REQ_FLAG, PARTIALLY_ALLOCATED_FLAG, FULLY_ALLOCATED_FLAG, ENTERED_DATE, 
                      ENTERED_BY, ENTRY_METHOD, OVERRIDE_DATE, OVERRIDE_BY, OVERRIDE_REASON, VERIFIED_DATE, VERIFIED_BY, DATE_CREATED, 
                      CREATED_BY, DATE_MODIFIED, MODIFIED_BY
FROM         dbo.SERVICE_LINES
WHERE     (TC_JOB_NO = 391200) AND (TC_SERVICE_LINE_NO = 764)

