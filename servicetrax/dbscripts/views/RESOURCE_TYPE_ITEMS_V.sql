CREATE VIEW dbo.RESOURCE_TYPE_ITEMS_V
AS
SELECT     dbo.ITEMS_V.ORGANIZATION_ID, dbo.RESOURCE_TYPE_ITEMS.RES_TYPE_ITEM_ID, dbo.RESOURCE_TYPES.RESOURCE_TYPE_ID, 
                      dbo.RESOURCE_TYPES.NAME AS resource_type_name, dbo.RESOURCE_TYPE_ITEMS.ITEM_ID, 
                      dbo.RESOURCE_TYPE_ITEMS.DEFAULT_ITEM_FLAG, dbo.ITEMS_V.NAME AS item_name, dbo.ITEMS_V.DESCRIPTION AS item_desc, 
                      dbo.ITEMS_V.EXT_ITEM_ID, dbo.ITEMS_V.ITEM_TYPE_ID, dbo.ITEMS_V.item_type_name, dbo.ITEMS_V.item_type_code, 
                      dbo.ITEMS_V.ITEM_STATUS_TYPE_ID, dbo.ITEMS_V.item_status_type_code, dbo.ITEMS_V.item_status_type_name, dbo.ITEMS_V.BILLABLE_FLAG, 
                      dbo.RESOURCE_TYPE_ITEMS.DATE_CREATED, dbo.RESOURCE_TYPE_ITEMS.CREATED_BY, 
                      USERS_1.FIRST_NAME + ' ' + USERS_1.LAST_NAME AS created_by_name, dbo.RESOURCE_TYPE_ITEMS.DATE_MODIFIED, 
                      dbo.RESOURCE_TYPE_ITEMS.MODIFIED_BY, USERS_2.FIRST_NAME + ' ' + USERS_2.LAST_NAME AS modified_by_name
FROM         dbo.ITEMS_V RIGHT OUTER JOIN
                      dbo.USERS USERS_2 RIGHT OUTER JOIN
                      dbo.RESOURCE_TYPE_ITEMS RIGHT OUTER JOIN
                      dbo.RESOURCE_TYPES ON dbo.RESOURCE_TYPE_ITEMS.RESOURCE_TYPE_ID = dbo.RESOURCE_TYPES.RESOURCE_TYPE_ID ON 
                      USERS_2.USER_ID = dbo.RESOURCE_TYPE_ITEMS.MODIFIED_BY LEFT OUTER JOIN
                      dbo.USERS USERS_1 ON dbo.RESOURCE_TYPE_ITEMS.CREATED_BY = USERS_1.USER_ID ON 
                      dbo.ITEMS_V.ITEM_ID = dbo.RESOURCE_TYPE_ITEMS.ITEM_ID


