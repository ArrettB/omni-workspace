-- See http://jira.apexit.com/jira/browse/ANM-31

ALTER TABLE [dbo].[ITEMS] ADD item_category_type_id NUMERIC(18,0) NULL
GO

ALTER TABLE [dbo].[ITEMS] ADD 
	CONSTRAINT [fk_items_category_lookups] FOREIGN KEY 
	(
		[item_category_type_id]
	) REFERENCES [dbo].[LOOKUPS] (
		[LOOKUP_ID]
	)
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ITEMS_V]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[ITEMS_V]
GO


CREATE VIEW dbo.ITEMS_V
AS
SELECT     dbo.ITEMS.ORGANIZATION_ID, dbo.ITEMS.ITEM_ID, dbo.ITEMS.NAME, dbo.ITEMS.DESCRIPTION, dbo.ITEMS.EXT_ITEM_ID, 
                      dbo.ITEMS.ITEM_TYPE_ID, ITEM_TYPE.CODE AS item_type_code, ITEM_TYPE.NAME AS item_type_name, dbo.ITEMS.ITEM_STATUS_TYPE_ID, 
                      STATUS_TYPE.CODE AS item_status_type_code, STATUS_TYPE.NAME AS item_status_type_name, dbo.ITEMS.CODE, dbo.ITEMS.BILLABLE_FLAG, 
                      dbo.ITEMS.SEQUENCE_NO, dbo.ITEMS.EXPENSE_EXPORT_CODE, dbo.ITEMS.JOB_TYPE_ID, dbo.ITEMS.COST_PER_UOM, 
                      dbo.ITEMS.PERCENT_MARGIN, dbo.ITEMS.CREATED_BY, dbo.ITEMS.DATE_CREATED, 
                      CREATE_USER.FIRST_NAME + ' ' + CREATE_USER.LAST_NAME AS created_by_name, dbo.ITEMS.DATE_MODIFIED, dbo.ITEMS.MODIFIED_BY, 
                      MOD_USER.FIRST_NAME + ' ' + MOD_USER.LAST_NAME AS modified_by_name, dbo.ITEMS.allow_expense_entry, dbo.ITEMS.item_category_type_id, 
                      item_category.CODE AS item_category_type_code, item_category.NAME AS item_category_type_name
FROM         dbo.LOOKUPS ITEM_TYPE RIGHT OUTER JOIN
                      dbo.LOOKUPS STATUS_TYPE RIGHT OUTER JOIN
                      dbo.ITEMS LEFT OUTER JOIN
                      dbo.USERS MOD_USER ON dbo.ITEMS.MODIFIED_BY = MOD_USER.USER_ID LEFT OUTER JOIN
                      dbo.USERS CREATE_USER ON dbo.ITEMS.CREATED_BY = CREATE_USER.USER_ID ON 
                      STATUS_TYPE.LOOKUP_ID = dbo.ITEMS.ITEM_STATUS_TYPE_ID ON ITEM_TYPE.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID LEFT OUTER JOIN
                      dbo.LOOKUPS item_category ON dbo.ITEMS.item_category_type_id = item_category.LOOKUP_ID

GO


INSERT INTO lookup_types (code, name, active_flag, updatable_flag, date_created, created_by)
VALUES ('item_category_type', 'Item Categories', 'Y', 'Y', getdate(), 1)
GO

INSERT INTO lookups (lookup_type_id, code, name, sequence_no, active_flag, updatable_flag, date_created, created_by)
SELECT lookup_type_id, 'labor' , 'Labor', 1, 'Y', 'Y', getDate(), 1
FROM lookup_types
WHERE code = 'item_category_type'
GO

INSERT INTO lookups (lookup_type_id, code, name, sequence_no, active_flag, updatable_flag, date_created, created_by)
SELECT lookup_type_id, 'truck' , 'Truck', 2, 'Y', 'Y', getDate(), 1
FROM lookup_types
WHERE code = 'item_category_type'
GO

INSERT INTO lookups (lookup_type_id, code, name, sequence_no, active_flag, updatable_flag, date_created, created_by)
SELECT lookup_type_id, 'warehouse' , 'Warehouse', 3, 'Y', 'Y', getDate(), 1
FROM lookup_types
WHERE code = 'item_category_type'
GO

INSERT INTO lookups (lookup_type_id, code, name, sequence_no, active_flag, updatable_flag, date_created, created_by)
SELECT lookup_type_id, 'subcontractor' , 'Subcontractor', 4, 'Y', 'Y', getDate(), 1
FROM lookup_types
WHERE code = 'item_category_type'
GO
