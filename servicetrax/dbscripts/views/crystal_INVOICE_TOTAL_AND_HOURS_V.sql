CREATE VIEW dbo.crystal_INVOICE_TOTAL_AND_HOURS_V
AS
SELECT     CAST(dbo.JOBS_V.JOB_NO AS VARCHAR) AS job_no_varchar, dbo.TIME_CAPTURE_V.ORGANIZATION_ID, dbo.TIME_CAPTURE_V.TC_JOB_NO, 
                      dbo.TIME_CAPTURE_V.TC_SERVICE_NO, dbo.TIME_CAPTURE_V.TC_SERVICE_LINE_NO, dbo.TIME_CAPTURE_V.ITEM_NAME, 
                      dbo.TIME_CAPTURE_V.TC_JOB_ID, dbo.TIME_CAPTURE_V.TC_SERVICE_ID, dbo.TIME_CAPTURE_V.PH_SERVICE_ID, 
                      dbo.TIME_CAPTURE_V.SERVICE_LINE_ID, dbo.TIME_CAPTURE_V.SERVICE_LINE_DATE, dbo.TIME_CAPTURE_V.STATUS_ID, 
                      dbo.TIME_CAPTURE_V.status_name, dbo.TIME_CAPTURE_V.RESOURCE_ID, dbo.TIME_CAPTURE_V.ITEM_ID, dbo.TIME_CAPTURE_V.TC_QTY, 
                      dbo.TIME_CAPTURE_V.TC_RATE, dbo.TIME_CAPTURE_V.TC_TOTAL, dbo.TIME_CAPTURE_V.PAYROLL_QTY, dbo.TIME_CAPTURE_V.EXT_PAY_CODE, 
                      dbo.RESOURCES_V.EXT_EMPLOYEE_ID, dbo.JOBS_V.CUSTOMER_ID, dbo.JOBS_V.CUSTOMER_NAME, dbo.JOBS_V.JOB_NAME, 
                      dbo.RESOURCES_V.resource_name, dbo.RESOURCES_V.RESOURCE_TYPE_ID, dbo.INVOICE_TOTALS_V.INVOICE_ID, 
                      dbo.INVOICE_TOTALS_V.extended_price, dbo.INVOICE_TOTALS_V.custom_total, dbo.RESOURCES_V.resource_type_name, 
                      dbo.INVOICES_V.DATE_CREATED, dbo.INVOICES_V.CREATED_BY, dbo.INVOICES_V.assigned_to_name
FROM         dbo.INVOICE_TOTALS_V INNER JOIN
                      dbo.INVOICES_V ON dbo.INVOICE_TOTALS_V.INVOICE_ID = dbo.INVOICES_V.INVOICE_ID AND 
                      dbo.INVOICE_TOTALS_V.JOB_ID = dbo.INVOICES_V.JOB_ID RIGHT OUTER JOIN
                      dbo.TIME_CAPTURE_V ON dbo.INVOICES_V.JOB_ID = dbo.TIME_CAPTURE_V.TC_JOB_ID AND 
                      dbo.INVOICES_V.ORGANIZATION_ID = dbo.TIME_CAPTURE_V.ORGANIZATION_ID FULL OUTER JOIN
                      dbo.JOBS_V ON dbo.TIME_CAPTURE_V.TC_JOB_ID = dbo.JOBS_V.JOB_ID LEFT OUTER JOIN
                      dbo.RESOURCES_V ON dbo.TIME_CAPTURE_V.RESOURCE_ID = dbo.RESOURCES_V.RESOURCE_ID
