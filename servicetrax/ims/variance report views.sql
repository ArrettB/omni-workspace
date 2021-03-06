if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[VAR_INV_DATE_V]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[VAR_INV_DATE_V]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[VAR_JOB_ACT_HOURS_V]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[VAR_JOB_ACT_HOURS_V]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[VAR_JOB_EST_HOURS_V]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[VAR_JOB_EST_HOURS_V]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[VAR_JOB_TIME_EXP_V]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[VAR_JOB_TIME_EXP_V]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[VAR_REPORT_TEMP_V]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[VAR_REPORT_TEMP_V]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[VAR_REPORT_V]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[VAR_REPORT_V]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[VAR_JOB_INVOICED_V]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[VAR_JOB_INVOICED_V]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[VAR_JOB_QUOTED_V]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[VAR_JOB_QUOTED_V]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.VAR_JOB_INVOICED_V
AS
SELECT     TOP 100 PERCENT dbo.JOBS.JOB_ID, SUM(ISNULL(dbo.INVOICE_LINES.UNIT_PRICE, 0) * ISNULL(dbo.INVOICE_LINES.QTY, 0)) AS sum_inv, 
                      MIN(dbo.INVOICES.DATE_SENT) AS min_date_sent, MAX(dbo.INVOICES.DATE_SENT) AS max_date_sent
FROM         dbo.JOBS RIGHT OUTER JOIN
                      dbo.INVOICE_LINES RIGHT OUTER JOIN
                      dbo.INVOICES ON dbo.INVOICE_LINES.INVOICE_ID = dbo.INVOICES.INVOICE_ID ON dbo.JOBS.JOB_ID = dbo.INVOICES.JOB_ID
WHERE     (dbo.INVOICES.STATUS_ID > 3)
GROUP BY dbo.JOBS.JOB_ID
HAVING      (SUM(ISNULL(dbo.INVOICE_LINES.UNIT_PRICE, 0) * ISNULL(dbo.INVOICE_LINES.QTY, 0)) > 0)
ORDER BY dbo.JOBS.JOB_ID

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.VAR_JOB_QUOTED_V
AS
SELECT     dbo.JOBS.JOB_ID, SUM(ISNULL(dbo.SERVICES.QUOTE_TOTAL, 0)) AS sum_quote
FROM         dbo.JOBS INNER JOIN
                      dbo.SERVICES ON dbo.JOBS.JOB_ID = dbo.SERVICES.JOB_ID
GROUP BY dbo.JOBS.JOB_ID



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.VAR_INV_DATE_V
AS
SELECT     TOP 100 PERCENT dbo.JOBS.JOB_ID, SUM(ISNULL(dbo.INVOICE_LINES.UNIT_PRICE, 0) * ISNULL(dbo.INVOICE_LINES.QTY, 0)) AS sum_inv, 
                      dbo.INVOICES.DATE_SENT AS date_sent
FROM         dbo.JOBS RIGHT OUTER JOIN
                      dbo.INVOICE_LINES RIGHT OUTER JOIN
                      dbo.INVOICES ON dbo.INVOICE_LINES.INVOICE_ID = dbo.INVOICES.INVOICE_ID ON dbo.JOBS.JOB_ID = dbo.INVOICES.JOB_ID
WHERE     (dbo.INVOICES.STATUS_ID > 3)
GROUP BY dbo.JOBS.JOB_ID, dbo.INVOICES.DATE_SENT
HAVING      (SUM(ISNULL(dbo.INVOICE_LINES.UNIT_PRICE, 0) * ISNULL(dbo.INVOICE_LINES.QTY, 0)) > 0)
ORDER BY dbo.JOBS.JOB_ID

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.VAR_JOB_ACT_HOURS_V
AS
SELECT     dbo.JOBS.JOB_ID, SUM(ISNULL(dbo.SERVICE_LINES.PAYROLL_QTY, 0)) AS sum_payroll_qty, SUM(ISNULL(dbo.SERVICE_LINES.EXPENSE_QTY, 0)) 
                      AS sum_expense_qty
FROM         dbo.SERVICES LEFT OUTER JOIN
                      dbo.JOBS ON dbo.SERVICES.JOB_ID = dbo.JOBS.JOB_ID LEFT OUTER JOIN
                      dbo.SERVICE_LINES ON dbo.SERVICES.SERVICE_ID = dbo.SERVICE_LINES.TC_SERVICE_ID
GROUP BY dbo.JOBS.JOB_ID



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.VAR_JOB_EST_HOURS_V
AS
SELECT     dbo.JOBS.JOB_ID, SUM(cast(ISNULL(dbo.RESOURCE_ESTIMATES.TOTAL_HOURS,0.0) as decimal)) AS sum_estimated_hours
FROM         dbo.JOBS LEFT OUTER JOIN
                      dbo.RESOURCE_ESTIMATES ON dbo.JOBS.JOB_ID = dbo.RESOURCE_ESTIMATES.JOB_ID LEFT OUTER JOIN
                      dbo.ITEMS ITEMS_2 LEFT OUTER JOIN
                      dbo.LOOKUPS ITEM_TYPE ON ITEMS_2.ITEM_TYPE_ID = ITEM_TYPE.LOOKUP_ID RIGHT OUTER JOIN
                      dbo.JOB_ITEM_RATES ON ITEMS_2.ITEM_ID = dbo.JOB_ITEM_RATES.ITEM_ID ON 
                      dbo.RESOURCE_ESTIMATES.JOB_ITEM_RATE_ID = dbo.JOB_ITEM_RATES.JOB_ITEM_RATE_ID
GROUP BY dbo.JOBS.JOB_ID






GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.VAR_JOB_TIME_EXP_V
AS
SELECT     TOP 100 PERCENT TC_JOB_ID AS job_id, SUM(ISNULL(TC_QTY * TC_RATE, 0)) AS sum_time_exp, SUM(ISNULL(PAYROLL_QTY * TC_RATE, 0)) 
                      AS sum_time, SUM(ISNULL(EXPENSE_QTY * TC_RATE, 0)) AS sum_exp
FROM         dbo.TIME_CAPTURE_V
GROUP BY TC_JOB_ID, PH_SERVICE_ID
HAVING      (PH_SERVICE_ID IS NULL)
ORDER BY TC_JOB_ID




GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.VAR_REPORT_TEMP_V
AS
SELECT     dbo.JOBS_V.ORGANIZATION_ID, dbo.JOBS_V.JOB_ID, dbo.JOBS_V.JOB_NO, dbo.JOBS_V.job_status_type_name, dbo.JOBS_V.CUSTOMER_ID, 
                      dbo.JOBS_V.CUSTOMER_NAME, dbo.JOBS_V.EXT_DEALER_ID, dbo.JOBS_V.DEALER_NAME, dbo.JOBS_V.JOB_NAME, dbo.JOBS_V.job_type_code, 
                      dbo.JOBS_V.FOREMAN_RESOURCE_ID, dbo.JOBS_V.BILLING_USER_ID, dbo.VAR_JOB_INVOICED_V.min_date_sent, 
                      dbo.VAR_JOB_INVOICED_V.max_date_sent, ISNULL(dbo.VAR_JOB_INVOICED_V.sum_inv, 0) AS sum_inv, 
                      ISNULL(dbo.VAR_JOB_TIME_EXP_V.sum_time_exp, 0) AS sum_time_exp, ISNULL(dbo.VAR_JOB_TIME_EXP_V.sum_time, 0) AS sum_time, 
                      ISNULL(dbo.VAR_JOB_TIME_EXP_V.sum_exp, 0) AS sum_exp, ISNULL(dbo.VAR_JOB_QUOTED_V.sum_quote, 0) AS sum_quote, 
                      ISNULL(dbo.VAR_JOB_ACT_HOURS_V.sum_payroll_qty, 0) AS sum_payroll_qty
FROM         dbo.VAR_JOB_QUOTED_V RIGHT OUTER JOIN
                      dbo.JOBS_V INNER JOIN
                      dbo.VAR_JOB_INVOICED_V ON dbo.JOBS_V.JOB_ID = dbo.VAR_JOB_INVOICED_V.JOB_ID LEFT OUTER JOIN
                      dbo.VAR_JOB_TIME_EXP_V ON dbo.JOBS_V.JOB_ID = dbo.VAR_JOB_TIME_EXP_V.job_id ON 
                      dbo.VAR_JOB_QUOTED_V.JOB_ID = dbo.JOBS_V.JOB_ID LEFT OUTER JOIN
                      dbo.VAR_JOB_ACT_HOURS_V ON dbo.JOBS_V.JOB_ID = dbo.VAR_JOB_ACT_HOURS_V.JOB_ID LEFT OUTER JOIN
                      dbo.VAR_JOB_EST_HOURS_V ON dbo.JOBS_V.JOB_ID = dbo.VAR_JOB_EST_HOURS_V.JOB_ID

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.VAR_REPORT_V
AS
SELECT     
	dbo.JOBS_V.ORGANIZATION_ID,
	dbo.JOBS_V.JOB_ID,
	dbo.JOBS_V.JOB_NO,
	dbo.JOBS_V.JOB_STATUS_TYPE_NAME,
	dbo.JOBS_V.CUSTOMER_ID,
	dbo.JOBS_V.CUSTOMER_NAME,
	dbo.JOBS_V.EXT_DEALER_ID,
	dbo.JOBS_V.DEALER_NAME,
	dbo.JOBS_V.JOB_NAME,
	dbo.JOBS_V.JOB_TYPE_CODE,
	dbo.JOBS_V.FOREMAN_RESOURCE_ID,
	dbo.JOBS_V.BILLING_USER_ID, 
	dbo.VAR_JOB_INVOICED_V.min_date_sent,
	dbo.VAR_JOB_INVOICED_V.max_date_sent,
	ISNULL(dbo.VAR_JOB_INVOICED_V.sum_inv,0) sum_inv,
	ISNULL(dbo.VAR_JOB_TIME_EXP_V.sum_time_exp,0) sum_time_exp, 
	ISNULL(dbo.VAR_JOB_TIME_EXP_V.sum_time,0) sum_time, 
	ISNULL(dbo.VAR_JOB_TIME_EXP_V.sum_exp,0) sum_exp, 
	ISNULL(dbo.VAR_JOB_QUOTED_V.sum_quote,0) sum_quote, 
	ISNULL(dbo.VAR_JOB_ACT_HOURS_V.sum_payroll_qty,0) sum_payroll_qty, 
	ISNULL(dbo.VAR_JOB_EST_HOURS_V.sum_estimated_hours,0) sum_estimated_hours,

	(CAST(ISNULL(dbo.VAR_JOB_INVOICED_V.sum_inv,0) AS money) - CAST(ISNULL(dbo.VAR_JOB_TIME_EXP_V.sum_time_exp,0) AS money)) AS sum_inv_var,
	(CASE ISNULL(dbo.VAR_JOB_INVOICED_V.sum_inv,0) WHEN 0 THEN 0 ELSE 
		(CAST(ISNULL(dbo.VAR_JOB_INVOICED_V.sum_inv,0) AS money) - CAST(ISNULL(dbo.VAR_JOB_TIME_EXP_V.sum_time_exp,0) AS money))
		/ CAST(dbo.VAR_JOB_INVOICED_V.sum_inv AS MONEY) END) AS sum_inv_var_percent, 

	(CAST(dbo.VAR_JOB_QUOTED_V.sum_quote AS MONEY) - CAST(ISNULL(dbo.VAR_JOB_TIME_EXP_V.sum_time_exp,0) AS MONEY)) AS sum_q_te_var,
	(CASE ISNULL(dbo.VAR_JOB_TIME_EXP_V.sum_time_exp,0) WHEN 0 THEN 0 ELSE 
		(CAST(dbo.VAR_JOB_QUOTED_V.sum_quote AS money) - CAST(ISNULL(dbo.VAR_JOB_TIME_EXP_V.sum_time_exp,0) AS MONEY))
		/ CAST(ISNULL(dbo.VAR_JOB_TIME_EXP_V.sum_time_exp,0) AS MONEY) END) AS sum_q_te_var_percent, 

	(CAST(dbo.VAR_JOB_INVOICED_V.sum_inv AS MONEY) - CAST(dbo.VAR_JOB_QUOTED_V.sum_quote AS MONEY))  AS sum_inv_q_var,
	(CASE ISNULL(dbo.VAR_JOB_INVOICED_V.sum_inv,0) WHEN 0 THEN 0 ELSE 
		(CAST(dbo.VAR_JOB_INVOICED_V.sum_inv AS MONEY) - CAST(dbo.VAR_JOB_QUOTED_V.sum_quote AS MONEY)) 
		/ CAST(dbo.VAR_JOB_INVOICED_V.sum_inv AS MONEY) END) AS sum_inv_q_var_percent, 

	CAST((CAST(ISNULL(dbo.VAR_JOB_EST_HOURS_V.sum_estimated_hours,0) as DECIMAL) - CAST(ISNULL(dbo.VAR_JOB_ACT_HOURS_V.sum_payroll_qty,0) AS DECIMAL)) as numeric(18,2)) AS sum_est_act_hours_var,
	(CASE ISNULL(dbo.VAR_JOB_ACT_HOURS_V.sum_payroll_qty,0) WHEN 0 THEN 0 ELSE 
		(CAST(ISNULL(dbo.VAR_JOB_EST_HOURS_V.sum_estimated_hours,0) AS NUMERIC(18,2))  - CAST(ISNULL(dbo.VAR_JOB_ACT_HOURS_V.sum_payroll_qty,0) AS NUMERIC(18,2)))
		/ CAST(ISNULL(dbo.VAR_JOB_ACT_HOURS_V.sum_payroll_qty,0) AS NUMERIC(18,2)) END) AS sum_est_act_hours_var_percent
		
FROM         dbo.VAR_JOB_QUOTED_V RIGHT OUTER JOIN
                      dbo.JOBS_V INNER JOIN
                      dbo.VAR_JOB_INVOICED_V ON dbo.JOBS_V.JOB_ID = dbo.VAR_JOB_INVOICED_V.JOB_ID LEFT OUTER JOIN
                      dbo.VAR_JOB_TIME_EXP_V ON dbo.JOBS_V.JOB_ID = dbo.VAR_JOB_TIME_EXP_V.JOB_ID ON 
                      dbo.VAR_JOB_QUOTED_V.JOB_ID = dbo.JOBS_V.JOB_ID LEFT OUTER JOIN
                      dbo.VAR_JOB_ACT_HOURS_V ON dbo.JOBS_V.JOB_ID = dbo.VAR_JOB_ACT_HOURS_V.JOB_ID LEFT OUTER JOIN
                      dbo.VAR_JOB_EST_HOURS_V ON dbo.JOBS_V.JOB_ID = dbo.VAR_JOB_EST_HOURS_V.JOB_ID















GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

