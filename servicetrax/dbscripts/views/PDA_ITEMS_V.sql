CREATE VIEW dbo.PDA_ITEMS_V
AS
SELECT     dbo.ITEMS.ITEM_ID, dbo.ITEMS.NAME, LOOKUPS_1.CODE AS item_code, PALM_USER.USER_ID AS ims_user_id
FROM         dbo.RESOURCES PALM_RESOURCE INNER JOIN
                      dbo.USERS PALM_USER ON PALM_RESOURCE.USER_ID = PALM_USER.USER_ID INNER JOIN
                      dbo.ITEMS INNER JOIN
                      dbo.LOOKUPS status ON dbo.ITEMS.ITEM_STATUS_TYPE_ID = status.LOOKUP_ID INNER JOIN
                      dbo.LOOKUPS LOOKUPS_1 ON dbo.ITEMS.ITEM_TYPE_ID = LOOKUPS_1.LOOKUP_ID ON 
                      PALM_RESOURCE.ORGANIZATION_ID = dbo.ITEMS.ORGANIZATION_ID
WHERE     (status.CODE = 'active')

