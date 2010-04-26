CREATE VIEW dbo.JOB_ITEM_RATES_V
AS
SELECT     dbo.ITEMS_V.ORGANIZATION_ID, dbo.JOB_ITEM_RATES.JOB_ITEM_RATE_ID, dbo.JOB_ITEM_RATES.JOB_ID, dbo.JOB_ITEM_RATES.ITEM_ID, 
                      dbo.ITEMS_V.NAME AS item_name, dbo.ITEMS_V.ITEM_TYPE_ID, dbo.ITEMS_V.item_type_code, dbo.ITEMS_V.item_type_name, 
                      dbo.ITEMS_V.ITEM_STATUS_TYPE_ID, dbo.ITEMS_V.item_status_type_code, dbo.JOB_ITEM_RATES.RATE, dbo.JOB_ITEM_RATES.EXT_RATE_ID, 
                      dbo.JOB_ITEM_RATES.UOM_TYPE_ID, dbo.LOOKUPS.CODE AS uom_type_code, dbo.LOOKUPS.NAME AS uom_type_name, 
                      dbo.JOB_ITEM_RATES.EXT_UOM_NAME, dbo.ITEMS_V.BILLABLE_FLAG, dbo.ITEMS_V.EXPENSE_EXPORT_CODE, 
                      dbo.JOB_ITEM_RATES.DATE_CREATED, dbo.JOB_ITEM_RATES.CREATED_BY, 
                      CREATED_BY.FIRST_NAME + ' ' + CREATED_BY.LAST_NAME AS created_by_name, dbo.JOB_ITEM_RATES.DATE_MODIFIED, 
                      dbo.JOB_ITEM_RATES.MODIFIED_BY, MODIFIED_BY.FIRST_NAME + ' ' + MODIFIED_BY.LAST_NAME AS modified_by_name
FROM         dbo.ITEMS_V RIGHT OUTER JOIN
                      dbo.USERS CREATED_BY RIGHT OUTER JOIN
                      dbo.JOB_ITEM_RATES LEFT OUTER JOIN
                      dbo.USERS MODIFIED_BY ON dbo.JOB_ITEM_RATES.DATE_MODIFIED = MODIFIED_BY.USER_ID ON 
                      CREATED_BY.USER_ID = dbo.JOB_ITEM_RATES.DATE_CREATED LEFT OUTER JOIN
                      dbo.LOOKUPS ON dbo.JOB_ITEM_RATES.UOM_TYPE_ID = dbo.LOOKUPS.LOOKUP_ID ON dbo.ITEMS_V.ITEM_ID = dbo.JOB_ITEM_RATES.ITEM_ID


