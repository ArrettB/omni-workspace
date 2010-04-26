CREATE VIEW dbo.JOBS_OVERVIEW_V
AS
SELECT     dbo.JOBS_V.ORGANIZATION_ID, dbo.JOBS_V.JOB_ID, dbo.JOBS_V.job_type_name, dbo.JOBS_V.JOB_NO, dbo.JOBS_V.DEALER_NAME, 
                      dbo.JOBS_V.CUSTOMER_NAME, dbo.JOBS_V.JOB_NAME, dbo.SERVICES.SERVICE_ID, dbo.SERVICES.SERVICE_NO, 
                      dbo.SERVICES.EST_START_DATE, ISNULL(dbo.SERVICES.LOC_VAL_FLAG, 'N') AS loc_val_flag, ISNULL(dbo.SERVICES.PROD_VAL_FLAG, 'N') 
                      AS prod_val_flag, ISNULL(dbo.SERVICES.SCH_VAL_FLAG, 'N') AS sch_val_flag, ISNULL(dbo.SERVICES.TASK_VAL_FLAG, 'N') AS task_val_flag, 
                      ISNULL(dbo.SERVICES.BILL_VAL_FLAG, 'N') AS bill_val_flag, dbo.JOBS_V.JOB_STATUS_TYPE_ID, dbo.JOBS_V.job_status_type_code, 
                      dbo.JOBS_V.job_status_type_name, dbo.SERVICES.SERV_STATUS_TYPE_ID, dbo.LOOKUPS.CODE AS serv_status_type_code, 
                      dbo.LOOKUPS.NAME AS serv_status_type_name, dbo.SERVICES.HEAD_VAL_FLAG, dbo.SERVICES.LOC_VAL_FLAG AS Expr1, 
                      dbo.SERVICES.PROD_VAL_FLAG AS Expr2, dbo.SERVICES.SCH_VAL_FLAG AS Expr3, dbo.SERVICES.RES_VAL_FLAG, 
                      dbo.SERVICES.TASK_VAL_FLAG AS Expr4, dbo.SERVICES.CUST_VAL_FLAG, dbo.SERVICES.PO_NO
FROM         dbo.LOOKUPS RIGHT OUTER JOIN
                      dbo.SERVICES ON dbo.LOOKUPS.LOOKUP_ID = dbo.SERVICES.SERV_STATUS_TYPE_ID RIGHT OUTER JOIN
                      dbo.JOBS_V ON dbo.SERVICES.JOB_ID = dbo.JOBS_V.JOB_ID


