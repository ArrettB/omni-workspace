CREATE VIEW dbo.crystal_VAR_REPORT_SUMMARY_V
AS
SELECT     
	dbo.JOBS_V.ORGANIZATION_ID,
	dbo.JOBS_V.JOB_ID,
	dbo.JOBS_V.EXT_DEALER_ID,
	dbo.JOBS_V.CUSTOMER_ID,
	dbo.JOBS_V.CUSTOMER_NAME,
	dbo.JOBS_V.JOB_NO,
	dbo.JOBS_V.DEALER_NAME,
	dbo.JOBS_V.JOB_NAME,
	cast(dbo.JOBS_V.billing_user_name as varchar) as JOB_OWNER, 
	dbo.JOBS_V.JOB_TYPE_CODE,
	dbo.JOBS_V.FOREMAN_RESOURCE_ID,
	dbo.JOBS_V.BILLING_USER_ID, 
	cast (dbo.VAR_JOB_INVOICED_V.min_date_sent as smalldatetime (8)) as start_date,
	cast (dbo.VAR_JOB_INVOICED_V.max_date_sent as smalldatetime (8)) as end_date,
	dbo.VAR_JOB_INVOICED_V.sum_inv, 
	dbo.VAR_JOB_TIME_EXP_V.sum_time_exp, 
	dbo.VAR_JOB_TIME_EXP_V.sum_time, 
	dbo.VAR_JOB_TIME_EXP_V.sum_exp, 
	dbo.VAR_JOB_QUOTED_V.sum_quote, 
	dbo.VAR_JOB_ACT_HOURS_V.sum_payroll_qty, 
	dbo.VAR_JOB_EST_HOURS_V.sum_estimated_hours, 

	(CAST(ISNULL(dbo.VAR_JOB_INVOICED_V.sum_inv,0) AS money) - CAST(ISNULL(dbo.VAR_JOB_TIME_EXP_V.sum_time_exp,0) AS money)) AS sum_inv_var,
	(CASE ISNULL(dbo.VAR_JOB_INVOICED_V.sum_inv,0) WHEN 0 THEN 0 ELSE 
		(CAST(ISNULL(dbo.VAR_JOB_INVOICED_V.sum_inv,0) AS money) - CAST(ISNULL(dbo.VAR_JOB_TIME_EXP_V.sum_time_exp,0) AS money))
		/ CAST(dbo.VAR_JOB_INVOICED_V.sum_inv AS MONEY) END) AS sum_inv_var_percent, 

	(CAST(dbo.VAR_JOB_QUOTED_V.sum_quote AS MONEY) - CAST(dbo.VAR_JOB_TIME_EXP_V.sum_time_exp AS MONEY)) AS sum_q_te_var,
	(CASE ISNULL(dbo.VAR_JOB_TIME_EXP_V.sum_time_exp,0) WHEN 0 THEN 0 ELSE 
		(CAST(dbo.VAR_JOB_QUOTED_V.sum_quote AS money) - CAST(dbo.VAR_JOB_TIME_EXP_V.sum_time_exp AS MONEY))
		/ CAST(dbo.VAR_JOB_TIME_EXP_V.sum_time_exp AS MONEY) END) AS sum_q_te_var_percent, 

	(CAST(dbo.VAR_JOB_INVOICED_V.sum_inv AS MONEY) - CAST(dbo.VAR_JOB_QUOTED_V.sum_quote AS MONEY))  AS sum_inv_q_var,
	(CASE ISNULL(dbo.VAR_JOB_INVOICED_V.sum_inv,0) WHEN 0 THEN 0 ELSE 
		(CAST(dbo.VAR_JOB_INVOICED_V.sum_inv AS MONEY) - CAST(dbo.VAR_JOB_QUOTED_V.sum_quote AS MONEY)) 
		/ CAST(dbo.VAR_JOB_INVOICED_V.sum_inv AS MONEY) END) AS sum_inv_q_var_percent, 

	CAST((CAST(ISNULL(dbo.VAR_JOB_EST_HOURS_V.sum_estimated_hours,0) as DECIMAL) - CAST(ISNULL(dbo.VAR_JOB_ACT_HOURS_V.sum_payroll_qty,0) AS DECIMAL)) as numeric(18,2)) AS sum_est_act_hours_var,
	(CASE ISNULL(dbo.VAR_JOB_ACT_HOURS_V.sum_payroll_qty,0) WHEN 0 THEN 0 ELSE 
		(CAST(ISNULL(dbo.VAR_JOB_EST_HOURS_V.sum_estimated_hours,0) AS DECIMAL)  - CAST(ISNULL(dbo.VAR_JOB_ACT_HOURS_V.sum_payroll_qty,0) AS DECIMAL))
		/ CAST(dbo.VAR_JOB_ACT_HOURS_V.sum_payroll_qty AS DECIMAL) END) AS sum_est_act_hours_var_percent
		
FROM         dbo.VAR_JOB_QUOTED_V RIGHT OUTER JOIN
                      dbo.JOBS_V INNER JOIN
                      dbo.VAR_JOB_INVOICED_V ON dbo.JOBS_V.JOB_ID = dbo.VAR_JOB_INVOICED_V.JOB_ID LEFT OUTER JOIN
                      dbo.VAR_JOB_TIME_EXP_V ON dbo.JOBS_V.JOB_ID = dbo.VAR_JOB_TIME_EXP_V.JOB_ID ON 
                      dbo.VAR_JOB_QUOTED_V.JOB_ID = dbo.JOBS_V.JOB_ID LEFT OUTER JOIN
                      dbo.VAR_JOB_ACT_HOURS_V ON dbo.JOBS_V.JOB_ID = dbo.VAR_JOB_ACT_HOURS_V.JOB_ID LEFT OUTER JOIN
                      dbo.VAR_JOB_EST_HOURS_V ON dbo.JOBS_V.JOB_ID = dbo.VAR_JOB_EST_HOURS_V.JOB_ID












