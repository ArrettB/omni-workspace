CREATE VIEW dbo.BILLING_CUSTOM_COLS_V
AS
SELECT     dbo.SERVICE_LINES.ORGANIZATION_ID, dbo.SERVICE_LINES.SERVICE_LINE_ID, CAST(dbo.SERVICE_LINES.BILL_JOB_ID AS varchar) 
                      + '-' + CAST(dbo.SERVICE_LINES.ITEM_ID AS varchar) + '-' + CAST(dbo.SERVICE_LINES.STATUS_ID AS varchar) AS job_item_status_id, 
                      CAST(dbo.SERVICE_LINES.BILL_SERVICE_ID AS varchar) + '-' + CAST(dbo.SERVICE_LINES.ITEM_ID AS varchar) 
                      + '-' + CAST(dbo.SERVICE_LINES.STATUS_ID AS varchar) AS service_item_status_id, CAST(dbo.SERVICE_LINES.BILL_SERVICE_ID AS varchar) 
                      + '-' + CAST(dbo.SERVICE_LINES.STATUS_ID AS varchar) AS bill_service_status_id, dbo.SERVICE_LINES.BILL_JOB_NO, 
                      dbo.SERVICE_LINES.BILL_SERVICE_NO, dbo.SERVICE_LINES.BILL_SERVICE_LINE_NO, dbo.JOBS_V.job_status_type_name, 
                      dbo.SERVICE_LINES.SERVICE_LINE_DATE, dbo.SERVICE_LINES.SERVICE_LINE_DATE_VARCHAR, dbo.SERVICE_LINES.SERVICE_LINE_WEEK, 
                      dbo.SERVICE_LINES.SERVICE_LINE_WEEK_VARCHAR, dbo.SERVICE_LINES.STATUS_ID, dbo.SERVICE_LINE_STATUSES.NAME AS status_name, 
                      dbo.SERVICE_LINES.EXPORTED_FLAG, dbo.SERVICE_LINES.BILLED_FLAG, dbo.SERVICE_LINES.POSTED_FLAG, 
                      dbo.SERVICE_LINES.POOLED_FLAG, dbo.SERVICE_LINES.INTERNAL_REQ_FLAG, dbo.SERVICE_LINES.BILL_JOB_ID, 
                      dbo.SERVICE_LINES.BILL_SERVICE_ID, dbo.SERVICE_LINES.PH_SERVICE_ID, dbo.SERVICE_LINES.RESOURCE_ID, 
                      dbo.SERVICE_LINES.RESOURCE_NAME, dbo.SERVICE_LINES.ITEM_ID, dbo.SERVICE_LINES.ITEM_NAME, dbo.SERVICE_LINES.ITEM_TYPE_CODE, 
                      dbo.SERVICE_LINES.INVOICE_ID, dbo.INVOICES.DESCRIPTION AS invoice_description, dbo.SERVICE_LINES.POSTED_FROM_INVOICE_ID, 
                      dbo.INVOICE_STATUSES.STATUS_ID AS invoice_status_id, dbo.INVOICE_STATUSES.NAME AS invoice_status_name, 
                      dbo.SERVICE_LINES.BILLABLE_FLAG, dbo.SERVICES.TAXABLE_FLAG AS service_taxable_flag, dbo.SERVICE_LINES.TAXABLE_FLAG, 
                      dbo.SERVICE_LINES.EXT_PAY_CODE, dbo.SERVICE_LINES.TC_QTY, dbo.SERVICE_LINES.PAYROLL_QTY, dbo.SERVICE_LINES.BILL_QTY, 
                      dbo.SERVICE_LINES.BILL_RATE, dbo.SERVICE_LINES.BILL_TOTAL, dbo.SERVICE_LINES.BILL_EXP_QTY, dbo.SERVICE_LINES.BILL_EXP_RATE, 
                      dbo.SERVICE_LINES.BILL_EXP_TOTAL, dbo.SERVICE_LINES.BILL_HOURLY_QTY, dbo.SERVICE_LINES.BILL_HOURLY_RATE, 
                      dbo.SERVICE_LINES.BILL_HOURLY_TOTAL, dbo.SERVICES.QUOTE_TOTAL, dbo.SERVICES.QUOTE_ID, dbo.JOBS_V.JOB_NAME, 
                      dbo.JOBS_V.billing_user_name, dbo.JOBS_V.DEALER_NAME, dbo.JOBS_V.EXT_DEALER_ID, dbo.JOBS_V.CUSTOMER_NAME, 
                      dbo.JOBS_V.EXT_CUSTOMER_ID, dbo.JOBS_V.BILLING_USER_ID, dbo.JOBS_V.foreman_resource_name AS supervisor_name, 
                      dbo.JOBS_V.foreman_user_id AS sup_user_id, dbo.SERVICES.BILLING_TYPE_ID, BILLING_TYPES.CODE AS billing_type_code, 
                      BILLING_TYPES.NAME AS billing_type_name, dbo.SERVICES.PO_NO, dbo.SERVICES.CUST_COL_1, dbo.SERVICES.CUST_COL_2, 
                      dbo.SERVICES.CUST_COL_3, dbo.SERVICES.CUST_COL_4, dbo.SERVICES.CUST_COL_5, dbo.SERVICES.CUST_COL_6, dbo.SERVICES.CUST_COL_7, 
                      dbo.SERVICES.CUST_COL_8, dbo.SERVICES.CUST_COL_9, dbo.SERVICES.CUST_COL_10, dbo.SERVICES.EST_START_DATE, 
                      dbo.SERVICES.EST_END_DATE, dbo.SERVICE_LINES.PALM_REP_ID, dbo.SERVICES.DESCRIPTION AS SERVICE_DESCRIPTION, 
                      CAST(dbo.JOBS_V.JOB_NO AS varchar) + ' - ' + ISNULL(dbo.JOBS_V.JOB_NAME, '') AS job_no_name2, CAST(dbo.SERVICES.SERVICE_NO AS varchar) 
                      + ' - ' + ISNULL(dbo.SERVICES.DESCRIPTION, '') AS service_no_description2, dbo.SERVICE_LINES.ENTERED_DATE, 
                      dbo.SERVICE_LINES.ENTERED_BY, dbo.SERVICE_LINES.ENTRY_METHOD, dbo.SERVICE_LINES.OVERRIDE_DATE, 
             
