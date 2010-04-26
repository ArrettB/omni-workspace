-- See http://jira.apexit.com/jira/browse/ANM-32

ALTER TABLE ITEMS ADD allow_expense_entry varchar(1) null;
GO

UPDATE ITEMS SET allow_expense_entry = 'N';
GO

UPDATE ITEMS SET allow_expense_entry = 'Y' WHERE name = 'Supplies' OR name = 'Other' OR name = 'Payables';
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
                      MOD_USER.FIRST_NAME + ' ' + MOD_USER.LAST_NAME AS modified_by_name, dbo.ITEMS.allow_expense_entry
FROM         dbo.LOOKUPS ITEM_TYPE RIGHT OUTER JOIN
                      dbo.LOOKUPS STATUS_TYPE RIGHT OUTER JOIN
                      dbo.ITEMS LEFT OUTER JOIN
                      dbo.USERS MOD_USER ON dbo.ITEMS.MODIFIED_BY = MOD_USER.USER_ID LEFT OUTER JOIN
                      dbo.USERS CREATE_USER ON dbo.ITEMS.CREATED_BY = CREATE_USER.USER_ID ON 
                      STATUS_TYPE.LOOKUP_ID = dbo.ITEMS.ITEM_STATUS_TYPE_ID ON ITEM_TYPE.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID


