
CREATE VIEW dbo.crystal_JOB_TIME_BY_JOB_WITH_GP_ACCTNUM_V
AS
SELECT   'AMBIM' as COMPANYID,ISNULL(dbo.TIME_CAPTURE_V.PAYROLL_QTY, 0) - ISNULL(dbo.TIME_CAPTURE_V.BILL_HOURLY_QTY, 0) AS hours_difference, 
                      CAST(dbo.JOBS_V.JOB_NO AS VARCHAR) AS job_no_varchar, dbo.TIME_CAPTURE_V.ORGANIZATION_ID, dbo.TIME_CAPTURE_V.TC_JOB_NO, 
                      dbo.TIME_CAPTURE_V.TC_SERVICE_NO, dbo.TIME_CAPTURE_V.TC_SERVICE_LINE_NO, dbo.TIME_CAPTURE_V.ITEM_NAME, 
                      dbo.TIME_CAPTURE_V.TC_JOB_ID, dbo.TIME_CAPTURE_V.TC_SERVICE_ID, dbo.TIME_CAPTURE_V.PH_SERVICE_ID, 
                      dbo.TIME_CAPTURE_V.SERVICE_LINE_ID, dbo.TIME_CAPTURE_V.SERVICE_LINE_DATE, dbo.TIME_CAPTURE_V.STATUS_ID, 
                      dbo.TIME_CAPTURE_V.status_name, dbo.TIME_CAPTURE_V.RESOURCE_ID, dbo.TIME_CAPTURE_V.ITEM_ID, dbo.TIME_CAPTURE_V.TC_QTY, 
                      dbo.TIME_CAPTURE_V.TC_RATE, dbo.TIME_CAPTURE_V.TC_TOTAL, dbo.TIME_CAPTURE_V.PAYROLL_QTY, dbo.TIME_CAPTURE_V.EXT_PAY_CODE, 
                      dbo.RESOURCES_V.EXT_EMPLOYEE_ID, dbo.RESOURCES_V.USER_ID, dbo.JOBS_V.CUSTOMER_ID, dbo.JOBS_V.CUSTOMER_NAME, 
                      dbo.JOBS_V.FOREMAN_RESOURCE_ID, dbo.JOBS_V.foreman_resource_name, dbo.JOBS_V.JOB_NAME, dbo.RESOURCES_V.resource_name, 
                      dbo.RESOURCES_V.resource_type_name, dbo.RESOURCES_V.RESOURCE_TYPE_ID, dbo.JOBS_V.billing_user_name, left(isnull(rtrim(AMBIM..GL00100.ACTNUMBR_1),'') + '-' +isnull(rtrim(AMBIM..GL00100.ACTNUMBR_2),'') + 
	'-' + isnull(rtrim(AMBIM..GL00100.ACTNUMBR_3),'') + '-' + isnull(rtrim(AMBIM..GL00100.ACTNUMBR_4), '') + 
	'-' + isnull(rtrim(AMBIM..GL00100.ACTNUMBR_5),''),13) as ACTNUM
FROM         dbo.RESOURCES_V RIGHT OUTER JOIN
                      dbo.TIME_CAPTURE_V ON dbo.RESOURCES_V.RESOURCE_ID = dbo.TIME_CAPTURE_V.RESOURCE_ID LEFT OUTER JOIN
                      dbo.JOBS_V ON dbo.TIME_CAPTURE_V.TC_JOB_ID = dbo.JOBS_V.JOB_ID
inner join AMBIM..IV00101 on ITEM_NAME=AMBIM..IV00101.ITMSHNAM
inner join AMBIM..GL00100 on AMBIM..IV00101.IVSLSIDX = AMBIM..GL00100.ACTINDX
union all
SELECT   'AIA' as COMPANYID,ISNULL(dbo.TIME_CAPTURE_V.PAYROLL_QTY, 0) - ISNULL(dbo.TIME_CAPTURE_V.BILL_HOURLY_QTY, 0) AS hours_difference, 
                      CAST(dbo.JOBS_V.JOB_NO AS VARCHAR) AS job_no_varchar, dbo.TIME_CAPTURE_V.ORGANIZATION_ID, dbo.TIME_CAPTURE_V.TC_JOB_NO, 
                      dbo.TIME_CAPTURE_V.TC_SERVICE_NO, dbo.TIME_CAPTURE_V.TC_SERVICE_LINE_NO, dbo.TIME_CAPTURE_V.ITEM_NAME, 
                      dbo.TIME_CAPTURE_V.TC_JOB_ID, dbo.TIME_CAPTURE_V.TC_SERVICE_ID, dbo.TIME_CAPTURE_V.PH_SERVICE_ID, 
                      dbo.TIME_CAPTURE_V.SERVICE_LINE_ID, dbo.TIME_CAPTURE_V.SERVICE_LINE_DATE, dbo.TIME_CAPTURE_V.STATUS_ID, 
                      dbo.TIME_CAPTURE_V.status_name, dbo.TIME_CAPTURE_V.RESOURCE_ID, dbo.TIME_CAPTURE_V.ITEM_ID, dbo.TIME_CAPTURE_V.TC_QTY, 
                      dbo.TIME_CAPTURE_V.TC_RATE, dbo.TIME_CAPTURE_V.TC_TOTAL, dbo.TIME_CAPTURE_V.PAYROLL_QTY, dbo.TIME_CAPTURE_V.EXT_PAY_CODE, 
                      dbo.RESOURCES_V.EXT_EMPLOYEE_ID, dbo.RESOURCES_V.USER_ID, dbo.JOBS_V.CUSTOMER_ID, dbo.JOBS_V.CUSTOMER_NAME, 
                      dbo.JOBS_V.FOREMAN_RESOURCE_ID, dbo.JOBS_V.foreman_resource_name, dbo.JOBS_V.JOB_NAME, dbo.RESOURCES_V.resource_name, 
                      dbo.RESOURCES_V.resource_type_name, dbo.RESOURCES_V.RESOURCE_TYPE_ID, dbo.JOBS_V.billing_user_name, left(isnull(rtrim(AIA..GL00100.ACTNUMBR_1),'') + '-' +isnull(rtrim(AIA..GL00100.ACTNUMBR_2),'') + 
	'-' + isnull(rtrim(AIA..GL00100.ACTNUMBR_3),'') + '-' + isnull(rtrim(AIA..GL00100.ACTNUMBR_4), '') + 
	'-' + isnull(rtrim(AIA..GL00100.ACTNUMBR_5),''),13) as ACTNUM
FROM         dbo.RESOURCES_V RIGHT OUTER JOIN
                      dbo.TIME_CAPTURE_V ON dbo.RESOURCES_V.RESOURCE_ID = dbo.TIME_CAPTURE_V.RESOURCE_ID LEFT OUTER JOIN
                      dbo.JOBS_V ON dbo.TIME_CAPTURE_V.TC_JOB_ID = dbo.JOBS_V.JOB_ID
inner join AIA..IV00101 on ITE
