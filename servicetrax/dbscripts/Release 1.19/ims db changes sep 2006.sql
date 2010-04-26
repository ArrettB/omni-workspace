if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[VAR_JOB_INVOICED_V]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[VAR_JOB_INVOICED_V]
GO

CREATE  INDEX [IX_SL_TCJOBID_PHSID] ON [dbo].[SERVICE_LINES]([TC_JOB_ID], [PH_SERVICE_ID]) ON [PRIMARY]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[VAR_INV_DATE_V]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[VAR_INV_DATE_V]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[VAR_JOB_TIME_EXP_V]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[VAR_JOB_TIME_EXP_V]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[VAR_REPORT_V]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[VAR_REPORT_V]
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

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.VAR_JOB_TIME_EXP_V
AS
SELECT     TC_JOB_ID AS job_id, ISNULL(SUM(TC_QTY * TC_RATE), 0) AS sum_time_exp, ISNULL(SUM(PAYROLL_QTY * TC_RATE), 0) AS sum_time, 
                      ISNULL(SUM(EXPENSE_QTY * TC_RATE), 0) AS sum_exp
FROM         dbo.SERVICE_LINES
WHERE     (PH_SERVICE_ID IS NULL)
GROUP BY TC_JOB_ID

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.VAR_REPORT_V
AS
SELECT     dbo.JOBS_V.JOB_ID, dbo.JOBS_V.JOB_NO, dbo.JOBS_V.JOB_NAME, dbo.JOBS_V.job_type_code, dbo.JOBS_V.job_status_type_name, 
                      dbo.JOBS_V.EXT_DEALER_ID, dbo.JOBS_V.DEALER_NAME, dbo.JOBS_V.CUSTOMER_ID, dbo.JOBS_V.CUSTOMER_NAME, 
                      dbo.JOBS_V.ORGANIZATION_ID, dbo.JOBS_V.BILLING_USER_ID, dbo.JOBS_V.foreman_user_id, ISNULL(dbo.VAR_JOB_TIME_EXP_V.sum_time_exp, 
                      0) AS sum_time_exp, ISNULL(dbo.VAR_JOB_TIME_EXP_V.sum_time, 0) AS sum_time, ISNULL(dbo.VAR_JOB_TIME_EXP_V.sum_exp, 0) AS sum_exp, 
                      ISNULL(dbo.VAR_JOB_QUOTED_V.sum_quote, 0) AS sum_quote, ISNULL(dbo.VAR_JOB_ACT_HOURS_V.sum_payroll_qty, 0) AS sum_payroll_qty, 
                      ISNULL(dbo.VAR_JOB_ACT_HOURS_V.sum_expense_qty, 0) AS sum_expense_qty, ISNULL(dbo.VAR_JOB_EST_HOURS_V.sum_estimated_hours, 0) 
                      AS sum_estimated_hours
FROM         dbo.JOBS_V LEFT OUTER JOIN
                      dbo.VAR_JOB_TIME_EXP_V ON dbo.JOBS_V.JOB_ID = dbo.VAR_JOB_TIME_EXP_V.job_id LEFT OUTER JOIN
                      dbo.VAR_JOB_QUOTED_V ON dbo.JOBS_V.JOB_ID = dbo.VAR_JOB_QUOTED_V.JOB_ID LEFT OUTER JOIN
                      dbo.VAR_JOB_ACT_HOURS_V ON dbo.JOBS_V.JOB_ID = dbo.VAR_JOB_ACT_HOURS_V.JOB_ID LEFT OUTER JOIN
                      dbo.VAR_JOB_EST_HOURS_V ON dbo.JOBS_V.JOB_ID = dbo.VAR_JOB_EST_HOURS_V.JOB_ID

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[BILL_JOBS_V]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[BILL_JOBS_V]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.BILL_JOBS_V
AS
SELECT     j.BILLING_USER_ID, sl.BILL_JOB_NO, sl.BILL_JOB_ID, c.DEALER_NAME, c.CUSTOMER_NAME, c.EXT_DEALER_ID, CONVERT(varchar, 
                      MAX(s.EST_END_DATE), 1) AS max_est_end_date_varchar, u.FIRST_NAME + ' ' + u.LAST_NAME AS billing_user_name, 
                      jl.NAME AS job_status_type_name, j.JOB_NAME, sl.ORGANIZATION_ID, ISNULL(SUM(dbo.INVOICE_LINES.EXTENDED_PRICE), 0) AS invoiced_total, 
                      SUM(CASE sl.billable_flag WHEN 'N' THEN sl.bill_total ELSE 0 END) non_billable_total, 
                      SUM(CASE sl.billable_flag WHEN 'Y' THEN sl.bill_total ELSE 0 END) billable_total
FROM         dbo.SERVICE_LINES sl INNER JOIN
                      dbo.SERVICES s ON sl.BILL_SERVICE_ID = s.SERVICE_ID INNER JOIN
                      dbo.JOBS j INNER JOIN
                      dbo.CUSTOMERS c ON j.CUSTOMER_ID = c.CUSTOMER_ID INNER JOIN
                      dbo.LOOKUPS jl ON j.JOB_STATUS_TYPE_ID = jl.LOOKUP_ID ON sl.BILL_JOB_ID = j.JOB_ID LEFT OUTER JOIN
                      dbo.INVOICES i RIGHT OUTER JOIN
                      dbo.INVOICE_LINES ON i.INVOICE_ID = dbo.INVOICE_LINES.INVOICE_ID ON sl.INVOICE_ID = i.INVOICE_ID LEFT OUTER JOIN
                      dbo.USERS u ON j.BILLING_USER_ID = u.USER_ID
WHERE     (sl.STATUS_ID = 4) AND (i.STATUS_ID = 1 OR
                      i.STATUS_ID IS NULL) AND (sl.INTERNAL_REQ_FLAG = 'N')
GROUP BY j.BILLING_USER_ID, sl.BILL_JOB_NO, sl.BILL_JOB_ID, c.DEALER_NAME, c.CUSTOMER_NAME, u.FIRST_NAME, u.LAST_NAME, jl.NAME, 
                      j.JOB_NAME, sl.ORGANIZATION_ID, c.EXT_DEALER_ID

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO



if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[USER_CUSTOMERS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[USER_CUSTOMERS]
GO

CREATE TABLE [dbo].[USER_CUSTOMERS] (
	[user_customer_id] [numeric](18, 0) IDENTITY (1, 1) NOT NULL ,
	[user_id] [numeric](18, 0) NOT NULL ,
	[customer_id] [numeric](18, 0) NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[USER_CUSTOMERS] WITH NOCHECK ADD 
	CONSTRAINT [PK_USER_CUSTOMERS] PRIMARY KEY  CLUSTERED 
	(
		[user_customer_id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[USER_CUSTOMERS] ADD 
	CONSTRAINT [IX_USER_CUSTOMERS] UNIQUE  NONCLUSTERED 
	(
		[user_id],
		[customer_id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[USER_CUSTOMERS] ADD 
	CONSTRAINT [FK_USER_CUSTOMERS_CUSTOMERS] FOREIGN KEY 
	(
		[customer_id]
	) REFERENCES [dbo].[CUSTOMERS] (
		[CUSTOMER_ID]
	),
	CONSTRAINT [FK_USER_CUSTOMERS_USERS] FOREIGN KEY 
	(
		[user_id]
	) REFERENCES [dbo].[USERS] (
		[USER_ID]
	)
GO



INSERT INTO user_customers(user_id, customer_id)
SELECT user_id, customer_id from users
WHERE customer_id is not null
GO

ALTER TABLE users DROP CONSTRAINT fk_user_customer
GO

ALTER TABLE users DROP COLUMN customer_id
GO




if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[USERS_V]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[USERS_V]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.USERS_V
AS
SELECT     main.USER_ID, main.EXT_EMPLOYEE_ID, main.FIRST_NAME, main.LAST_NAME, main.CONTACT_ID, main.EMPLOYMENT_TYPE_ID, 
                      employement_types.CODE AS employment_type_code, employement_types.NAME AS employment_type_name, main.USER_TYPE_ID, 
                      user_types.CODE AS user_type_code, user_types.NAME AS user_type_name, main.EXT_DEALER_ID, main.DEALER_NAME, 
                      main.FIRST_NAME + ' ' + main.LAST_NAME AS full_name, main.LAST_LOGIN, main.LOGIN, main.PASSWORD, main.ACTIVE_FLAG, 
                      main.DATE_CREATED, main.DATE_MODIFIED, main.CREATED_BY, main.MODIFIED_BY, 
                      created_by.FIRST_NAME + ' ' + created_by.LAST_NAME AS created_by_name, 
                      modified_by.FIRST_NAME + ' ' + modified_by.LAST_NAME AS modified_by_name, main.PIN, main.IMOBILE_LOGIN, main.LAST_SYNCH_DATE, 
                      vendor_contact.EMAIL, main.VENDOR_CONTACT_ID, vendor_contact.CONTACT_NAME AS vendor_contact_name
FROM         dbo.CONTACTS CONTACTS_1 RIGHT OUTER JOIN
                      dbo.LOOKUPS employement_types RIGHT OUTER JOIN
                      dbo.CONTACTS vendor_contact RIGHT OUTER JOIN
                      dbo.LOOKUPS user_types RIGHT OUTER JOIN
                      dbo.USERS created_by RIGHT OUTER JOIN
                      dbo.USERS main LEFT OUTER JOIN
                      dbo.USERS modified_by ON main.MODIFIED_BY = modified_by.USER_ID ON created_by.USER_ID = main.CREATED_BY ON 
                      user_types.LOOKUP_ID = main.USER_TYPE_ID ON vendor_contact.CONTACT_ID = main.VENDOR_CONTACT_ID ON 
                      employement_types.LOOKUP_ID = main.EMPLOYMENT_TYPE_ID ON CONTACTS_1.CONTACT_ID = main.CONTACT_ID
WHERE     (main.ACTIVE_FLAG = 'Y')

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[USER_CUSTOMERS_V]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[USER_CUSTOMERS_V]
GO



SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.USER_CUSTOMERS_V
AS
SELECT     dbo.USER_CUSTOMERS.user_id, dbo.CUSTOMERS.CUSTOMER_ID
FROM         dbo.CUSTOMERS INNER JOIN
                      dbo.USER_CUSTOMERS ON dbo.CUSTOMERS.PARENT_CUSTOMER_ID = dbo.USER_CUSTOMERS.customer_id
UNION
SELECT     dbo.USER_CUSTOMERS.user_id, dbo.USER_CUSTOMERS.customer_id
FROM         dbo.USER_CUSTOMERS

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

