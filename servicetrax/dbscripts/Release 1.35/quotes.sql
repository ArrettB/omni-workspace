/*
   Thursday, April 02, 200910:26:59 AM
   User: ims
   Server: LEXUS\LEXUS32DEV
   Database: ims_new
   Application: 
*/

/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.QUOTES
	DROP CONSTRAINT FK_QUOTE_USERS
GO
ALTER TABLE dbo.QUOTES
	DROP CONSTRAINT FK_QUOTE_USERS_C
GO
ALTER TABLE dbo.QUOTES
	DROP CONSTRAINT FK_QUOTE_USERS_M
GO
COMMIT
select Has_Perms_By_Name(N'dbo.USERS', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.USERS', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.USERS', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.QUOTES
	DROP CONSTRAINT FK_QUOTE_REQUEST_TYPES
GO
ALTER TABLE dbo.QUOTES
	DROP CONSTRAINT FK_QUOTE_TYPES
GO
ALTER TABLE dbo.QUOTES
	DROP CONSTRAINT FK_QUOTE_STATUSES
GO
COMMIT
select Has_Perms_By_Name(N'dbo.LOOKUPS', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.LOOKUPS', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.LOOKUPS', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.QUOTES
	DROP CONSTRAINT FK_QUOTE_REQUESTS
GO
COMMIT
select Has_Perms_By_Name(N'dbo.REQUESTS', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.REQUESTS', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.REQUESTS', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.QUOTES
	DROP CONSTRAINT DF_QUOTES_TAXABLE_FLAG
GO
CREATE TABLE dbo.Tmp_QUOTES
	(
	quote_id numeric(18, 0) NOT NULL IDENTITY (1, 1),
	request_id numeric(18, 0) NOT NULL,
	version int NULL,
	sub_version int NULL,
	is_sent varchar(1) NOT NULL,
	request_type_id numeric(18, 0) NOT NULL,
	quote_no numeric(18, 0) NOT NULL,
	quote_type_id numeric(18, 0) NOT NULL,
	quote_status_type_id numeric(18, 0) NOT NULL,
	quoted_by_user_id numeric(18, 0) NULL,
	quoters_title varchar(100) NULL,
	estimator_comments varchar(250) NULL,
	description varchar(2000) NULL,
	extra_conditions varchar(1000) NULL,
	quote_total numeric(18, 2) NULL,
	taxable_flag varchar(1) NULL,
	taxable_amount numeric(18, 2) NULL,
	warehouse_fee_flag varchar(1) NULL,
	date_quoted datetime NULL,
	date_printed datetime NULL,
	systems_shipping_method varchar(50) NULL,
	casegoods_shipping_method varchar(50) NULL,
	[select_job_site_move-stage_environment] varchar(50) NULL,
	omni_bill_std_hours_discounted_bill_rate varchar(50) NULL,
	net_effective_billing_rate_per_hour varchar(50) NULL,
	[roc_omni_discounted_hours-receive] varchar(20) NULL,
	[roc_omni_discounted_hours-reload] varchar(20) NULL,
	[roc_omni_discounted_hours-truck] varchar(20) NULL,
	[roc_omni_discounted_hours-driver] varchar(20) NULL,
	[roc_omni_discounted_hours-unload] varchar(20) NULL,
	[roc_omni_discounted_hours-move_stage] varchar(20) NULL,
	[roc_omni_discounted_hours-install] varchar(20) NULL,
	[roc_omni_discounted_hours-electrical] varchar(20) NULL,
	[roc_omni_discounted_hours-total] varchar(20) NULL,
	[roc_industry_std_bill-receive] varchar(20) NULL,
	[roc_industry_std_bill-reload] varchar(20) NULL,
	[roc_industry_std_bill-truck] varchar(20) NULL,
	[roc_industry_std_bill-driver] varchar(20) NULL,
	[roc_industry_std_bill-unload] varchar(20) NULL,
	[roc_industry_std_bill-move_stage] varchar(20) NULL,
	[roc_industry_std_bill-install] varchar(20) NULL,
	[roc_industry_std_bill-electrical] varchar(20) NULL,
	[roc_industry_std_bill-total] varchar(20) NULL,
	[roc_omni_direct_cost-receive] varchar(20) NULL,
	[roc_omni_direct_cost-reload] varchar(20) NULL,
	[roc_omni_direct_cost-truck] varchar(20) NULL,
	[roc_omni_direct_cost-driver] varchar(20) NULL,
	[roc_omni_direct_cost-unload] varchar(20) NULL,
	[roc_omni_direct_cost-move-stage] varchar(20) NULL,
	[roc_omni_direct_cost-install] varchar(20) NULL,
	[roc_omni_direct_cost-electrical] varchar(20) NULL,
	[roc_omni_direct_cost-total] varchar(20) NULL,
	[ind_industry_std_hours-receive] varchar(20) NULL,
	[ind_industry_std_hours-reload] varchar(20) NULL,
	[ind_industry_std_hours-truck] varchar(20) NULL,
	[ind_industry_std_hours-driver] varchar(20) NULL,
	[ind_industry_std_hours-unload] varchar(20) NULL,
	[ind_industry_std_hours-move_stage] varchar(20) NULL,
	[ind_industry_std_hours-install] varchar(20) NULL,
	[ind_industry_std_hours-electrical] varchar(20) NULL,
	[ind_industry_std_hours-total] varchar(20) NULL,
	[ind_omni_discounted_hours-receive] varchar(20) NULL,
	[ind_omni_discounted_hours-reload] varchar(20) NULL,
	[ind_omni_discounted_hours-truck] varchar(20) NULL,
	[ind_omni_discounted_hours-driver] varchar(20) NULL,
	[ind_omni_discounted_hours-unload] varchar(20) NULL,
	[ind_omni_discounted_hours-move_stage] varchar(20) NULL,
	[ind_omni_discounted_hours-install] varchar(20) NULL,
	[ind_omni_discounted_hours-electrical] varchar(20) NULL,
	[ind_omni_discounted_hours-total] varchar(20) NULL,
	[ind_industry_std_bill-receive] varchar(20) NULL,
	[ind_industry_std_bill-reload] varchar(20) NULL,
	[ind_industry_std_bill-truck] varchar(20) NULL,
	[ind_industry_std_bill-driver] varchar(20) NULL,
	[ind_industry_std_bill-unload] varchar(20) NULL,
	[ind_industry_std_bill-move_stage] varchar(20) NULL,
	[ind_industry_std_bill-install] varchar(20) NULL,
	[ind_industry_std_bill-electrical] varchar(20) NULL,
	[ind_industry_std_bill-total] varchar(20) NULL,
	[ind_omni_discounted_bill-receive] varchar(20) NULL,
	[ind_omni_discounted_bill-reload] varchar(20) NULL,
	[ind_omni_discounted_bill-truck] varchar(20) NULL,
	[ind_omni_discounted_bill-driver] varchar(20) NULL,
	[ind_omni_discounted_bill-unload] varchar(20) NULL,
	[ind_omni_discounted_bill-move_stage] varchar(20) NULL,
	[ind_omni_discounted_bill-install] varchar(20) NULL,
	[ind_omni_discounted_bill-electrical] varchar(20) NULL,
	[ind_omni_discounted_bill-total] varchar(20) NULL,
	[ind_omni_direct_cost-receive] varchar(20) NULL,
	[ind_omni_direct_cost-reload] varchar(20) NULL,
	[ind_omni_direct_cost-truck] varchar(20) NULL,
	[ind_omni_direct_cost-driver] varchar(20) NULL,
	[ind_omni_direct_cost-unload] varchar(20) NULL,
	[ind_omni_direct_cost-move_stage] varchar(20) NULL,
	[ind_omni_direct_cost-install] varchar(20) NULL,
	[ind_omni_direct_cost-electrical] varchar(20) NULL,
	[ind_omni_direct_cost-total] varchar(20) NULL,
	[total-panels_non-powered] varchar(10) NULL,
	[total-panels_powered] varchar(10) NULL,
	[total-beltline_power] varchar(10) NULL,
	[total-tiles] varchar(10) NULL,
	[total-stack_fabric] varchar(10) NULL,
	[total-stack_glass] varchar(10) NULL,
	[total-worksurfaces] varchar(10) NULL,
	[total-overheads] varchar(10) NULL,
	[total-pedestals] varchar(10) NULL,
	[total-tasklights] varchar(10) NULL,
	[total-keyboard_trays] varchar(10) NULL,
	[total-walltracks] varchar(10) NULL,
	[total-doors] varchar(10) NULL,
	[total-accessories] varchar(10) NULL,
	date_created datetime NOT NULL,
	created_by numeric(18, 0) NOT NULL,
	date_modified datetime NULL,
	modified_by numeric(18, 0) NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_QUOTES ADD CONSTRAINT
	DF_QUOTES_TAXABLE_FLAG DEFAULT ('N') FOR taxable_flag
GO
SET IDENTITY_INSERT dbo.Tmp_QUOTES ON
GO
IF EXISTS(SELECT * FROM dbo.QUOTES)
	 EXEC('INSERT INTO dbo.Tmp_QUOTES (quote_id, request_id, version, sub_version, is_sent, request_type_id, quote_no, quote_type_id, quote_status_type_id, quoted_by_user_id, quoters_title, description, extra_conditions, quote_total, taxable_flag, taxable_amount, warehouse_fee_flag, date_quoted, date_printed, systems_shipping_method, casegoods_shipping_method, [select_job_site_move-stage_environment], omni_bill_std_hours_discounted_bill_rate, net_effective_billing_rate_per_hour, [roc_omni_discounted_hours-receive], [roc_omni_discounted_hours-reload], [roc_omni_discounted_hours-truck], [roc_omni_discounted_hours-driver], [roc_omni_discounted_hours-unload], [roc_omni_discounted_hours-move_stage], [roc_omni_discounted_hours-install], [roc_omni_discounted_hours-electrical], [roc_omni_discounted_hours-total], [roc_industry_std_bill-receive], [roc_industry_std_bill-reload], [roc_industry_std_bill-truck], [roc_industry_std_bill-driver], [roc_industry_std_bill-unload], [roc_industry_std_bill-move_stage], [roc_industry_std_bill-install], [roc_industry_std_bill-electrical], [roc_industry_std_bill-total], [roc_omni_direct_cost-receive], [roc_omni_direct_cost-reload], [roc_omni_direct_cost-truck], [roc_omni_direct_cost-driver], [roc_omni_direct_cost-unload], [roc_omni_direct_cost-move-stage], [roc_omni_direct_cost-install], [roc_omni_direct_cost-electrical], [roc_omni_direct_cost-total], [ind_industry_std_hours-receive], [ind_industry_std_hours-reload], [ind_industry_std_hours-truck], [ind_industry_std_hours-driver], [ind_industry_std_hours-unload], [ind_industry_std_hours-move_stage], [ind_industry_std_hours-install], [ind_industry_std_hours-electrical], [ind_industry_std_hours-total], [ind_omni_discounted_hours-receive], [ind_omni_discounted_hours-reload], [ind_omni_discounted_hours-truck], [ind_omni_discounted_hours-driver], [ind_omni_discounted_hours-unload], [ind_omni_discounted_hours-move_stage], [ind_omni_discounted_hours-install], [ind_omni_discounted_hours-electrical], [ind_omni_discounted_hours-total], [ind_industry_std_bill-receive], [ind_industry_std_bill-reload], [ind_industry_std_bill-truck], [ind_industry_std_bill-driver], [ind_industry_std_bill-unload], [ind_industry_std_bill-move_stage], [ind_industry_std_bill-install], [ind_industry_std_bill-electrical], [ind_industry_std_bill-total], [ind_omni_discounted_bill-receive], [ind_omni_discounted_bill-reload], [ind_omni_discounted_bill-truck], [ind_omni_discounted_bill-driver], [ind_omni_discounted_bill-unload], [ind_omni_discounted_bill-move_stage], [ind_omni_discounted_bill-install], [ind_omni_discounted_bill-electrical], [ind_omni_discounted_bill-total], [ind_omni_direct_cost-receive], [ind_omni_direct_cost-reload], [ind_omni_direct_cost-truck], [ind_omni_direct_cost-driver], [ind_omni_direct_cost-unload], [ind_omni_direct_cost-move_stage], [ind_omni_direct_cost-install], [ind_omni_direct_cost-electrical], [ind_omni_direct_cost-total], [total-panels_non-powered], [total-panels_powered], [total-beltline_power], [total-tiles], [total-stack_fabric], [total-stack_glass], [total-worksurfaces], [total-overheads], [total-pedestals], [total-tasklights], [total-keyboard_trays], [total-walltracks], [total-doors], [total-accessories], date_created, created_by, date_modified, modified_by)
		SELECT quote_id, request_id, version, sub_version, is_sent, request_type_id, quote_no, quote_type_id, quote_status_type_id, quoted_by_user_id, quoters_title, description, extra_conditions, quote_total, taxable_flag, taxable_amount, warehouse_fee_flag, date_quoted, date_printed, systems_shipping_method, casegoods_shipping_method, [select_job_site_move-stage_environment], omni_bill_std_hours_discounted_bill_rate, net_effective_billing_rate_per_hour, [roc_omni_discounted_hours-receive], [roc_omni_discounted_hours-reload], [roc_omni_discounted_hours-truck], [roc_omni_discounted_hours-driver], [roc_omni_discounted_hours-unload], [roc_omni_discounted_hours-move_stage], [roc_omni_discounted_hours-install], [roc_omni_discounted_hours-electrical], [roc_omni_discounted_hours-total], [roc_industry_std_bill-receive], [roc_industry_std_bill-reload], [roc_industry_std_bill-truck], [roc_industry_std_bill-driver], [roc_industry_std_bill-unload], [roc_industry_std_bill-move_stage], [roc_industry_std_bill-install], [roc_industry_std_bill-electrical], [roc_industry_std_bill-total], [roc_omni_direct_cost-receive], [roc_omni_direct_cost-reload], [roc_omni_direct_cost-truck], [roc_omni_direct_cost-driver], [roc_omni_direct_cost-unload], [roc_omni_direct_cost-move-stage], [roc_omni_direct_cost-install], [roc_omni_direct_cost-electrical], [roc_omni_direct_cost-total], [ind_industry_std_hours-receive], [ind_industry_std_hours-reload], [ind_industry_std_hours-truck], [ind_industry_std_hours-driver], [ind_industry_std_hours-unload], [ind_industry_std_hours-move_stage], [ind_industry_std_hours-install], [ind_industry_std_hours-electrical], [ind_industry_std_hours-total], [ind_omni_discounted_hours-receive], [ind_omni_discounted_hours-reload], [ind_omni_discounted_hours-truck], [ind_omni_discounted_hours-driver], [ind_omni_discounted_hours-unload], [ind_omni_discounted_hours-move_stage], [ind_omni_discounted_hours-install], [ind_omni_discounted_hours-electrical], [ind_omni_discounted_hours-total], [ind_industry_std_bill-receive], [ind_industry_std_bill-reload], [ind_industry_std_bill-truck], [ind_industry_std_bill-driver], [ind_industry_std_bill-unload], [ind_industry_std_bill-move_stage], [ind_industry_std_bill-install], [ind_industry_std_bill-electrical], [ind_industry_std_bill-total], [ind_omni_discounted_bill-receive], [ind_omni_discounted_bill-reload], [ind_omni_discounted_bill-truck], [ind_omni_discounted_bill-driver], [ind_omni_discounted_bill-unload], [ind_omni_discounted_bill-move_stage], [ind_omni_discounted_bill-install], [ind_omni_discounted_bill-electrical], [ind_omni_discounted_bill-total], [ind_omni_direct_cost-receive], [ind_omni_direct_cost-reload], [ind_omni_direct_cost-truck], [ind_omni_direct_cost-driver], [ind_omni_direct_cost-unload], [ind_omni_direct_cost-move_stage], [ind_omni_direct_cost-install], [ind_omni_direct_cost-electrical], [ind_omni_direct_cost-total], [total-panels_non-powered], [total-panels_powered], [total-beltline_power], [total-tiles], [total-stack_fabric], [total-stack_glass], [total-worksurfaces], [total-overheads], [total-pedestals], [total-tasklights], [total-keyboard_trays], [total-walltracks], [total-doors], [total-accessories], date_created, created_by, date_modified, modified_by FROM dbo.QUOTES WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_QUOTES OFF
GO
ALTER TABLE dbo.QUOTE_SPECIFY_OTHER_SERVICES
	DROP CONSTRAINT FK_QSOS_QUOTES
GO
ALTER TABLE dbo.QUOTE_OTHER_FURNITURE
	DROP CONSTRAINT FK_QOF_QUOTES
GO
ALTER TABLE dbo.QUOTE_OTHER_FURNITURE_AD_HOC
	DROP CONSTRAINT FK_QOFAH_QUOTES
GO
ALTER TABLE dbo.QUOTE_STANDARD_CONDITIONS
	DROP CONSTRAINT FK_QSC_QUOTES
GO
ALTER TABLE dbo.QUOTE_WORKSTATION_CONFIGURATIONS
	DROP CONSTRAINT FK_QWC_QUOTES
GO
DROP TABLE dbo.QUOTES
GO
EXECUTE sp_rename N'dbo.Tmp_QUOTES', N'QUOTES', 'OBJECT' 
GO
ALTER TABLE dbo.QUOTES ADD CONSTRAINT
	PK_QUOTES PRIMARY KEY CLUSTERED 
	(
	quote_id
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.QUOTES WITH NOCHECK ADD CONSTRAINT
	FK_QUOTE_REQUESTS FOREIGN KEY
	(
	request_id
	) REFERENCES dbo.REQUESTS
	(
	REQUEST_ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.QUOTES WITH NOCHECK ADD CONSTRAINT
	FK_QUOTE_REQUEST_TYPES FOREIGN KEY
	(
	request_type_id
	) REFERENCES dbo.LOOKUPS
	(
	LOOKUP_ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.QUOTES WITH NOCHECK ADD CONSTRAINT
	FK_QUOTE_TYPES FOREIGN KEY
	(
	quote_type_id
	) REFERENCES dbo.LOOKUPS
	(
	LOOKUP_ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.QUOTES WITH NOCHECK ADD CONSTRAINT
	FK_QUOTE_STATUSES FOREIGN KEY
	(
	quote_status_type_id
	) REFERENCES dbo.LOOKUPS
	(
	LOOKUP_ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.QUOTES WITH NOCHECK ADD CONSTRAINT
	FK_QUOTE_USERS FOREIGN KEY
	(
	quoted_by_user_id
	) REFERENCES dbo.USERS
	(
	USER_ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.QUOTES WITH NOCHECK ADD CONSTRAINT
	FK_QUOTE_USERS_C FOREIGN KEY
	(
	created_by
	) REFERENCES dbo.USERS
	(
	USER_ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.QUOTES WITH NOCHECK ADD CONSTRAINT
	FK_QUOTE_USERS_M FOREIGN KEY
	(
	modified_by
	) REFERENCES dbo.USERS
	(
	USER_ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
select Has_Perms_By_Name(N'dbo.QUOTES', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.QUOTES', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.QUOTES', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.QUOTE_WORKSTATION_CONFIGURATIONS WITH NOCHECK ADD CONSTRAINT
	FK_QWC_QUOTES FOREIGN KEY
	(
	QUOTE_ID
	) REFERENCES dbo.QUOTES
	(
	quote_id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
select Has_Perms_By_Name(N'dbo.QUOTE_WORKSTATION_CONFIGURATIONS', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.QUOTE_WORKSTATION_CONFIGURATIONS', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.QUOTE_WORKSTATION_CONFIGURATIONS', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.QUOTE_STANDARD_CONDITIONS WITH NOCHECK ADD CONSTRAINT
	FK_QSC_QUOTES FOREIGN KEY
	(
	QUOTE_ID
	) REFERENCES dbo.QUOTES
	(
	quote_id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
select Has_Perms_By_Name(N'dbo.QUOTE_STANDARD_CONDITIONS', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.QUOTE_STANDARD_CONDITIONS', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.QUOTE_STANDARD_CONDITIONS', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.QUOTE_OTHER_FURNITURE_AD_HOC WITH NOCHECK ADD CONSTRAINT
	FK_QOFAH_QUOTES FOREIGN KEY
	(
	QUOTE_ID
	) REFERENCES dbo.QUOTES
	(
	quote_id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
select Has_Perms_By_Name(N'dbo.QUOTE_OTHER_FURNITURE_AD_HOC', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.QUOTE_OTHER_FURNITURE_AD_HOC', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.QUOTE_OTHER_FURNITURE_AD_HOC', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.QUOTE_OTHER_FURNITURE WITH NOCHECK ADD CONSTRAINT
	FK_QOF_QUOTES FOREIGN KEY
	(
	QUOTE_ID
	) REFERENCES dbo.QUOTES
	(
	quote_id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
select Has_Perms_By_Name(N'dbo.QUOTE_OTHER_FURNITURE', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.QUOTE_OTHER_FURNITURE', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.QUOTE_OTHER_FURNITURE', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.QUOTE_SPECIFY_OTHER_SERVICES WITH NOCHECK ADD CONSTRAINT
	FK_QSOS_QUOTES FOREIGN KEY
	(
	QUOTE_ID
	) REFERENCES dbo.QUOTES
	(
	quote_id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
select Has_Perms_By_Name(N'dbo.QUOTE_SPECIFY_OTHER_SERVICES', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.QUOTE_SPECIFY_OTHER_SERVICES', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.QUOTE_SPECIFY_OTHER_SERVICES', 'Object', 'CONTROL') as Contr_Per 