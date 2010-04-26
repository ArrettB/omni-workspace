CREATE VIEW dbo.GP_PHX_ITEM_PAYCODES_V
AS
SELECT     ITEM_ID, item_name, pay_code, defaulted
FROM         (SELECT     GP_PAYCODES.PAYRCORD AS pay_code, dbo.ITEMS.NAME AS item_name, dbo.ITEMS.ITEM_ID, 'f' AS defaulted
                       FROM          dbo.LOOKUPS AS ITEM_TYPES INNER JOIN
                                              dbo.ITEMS ON ITEM_TYPES.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID INNER JOIN
                                              dbo.GP_PHX_PAY_CODE_V AS GP_PAYCODES ON RIGHT(dbo.ITEMS.NAME, CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) - 1) 
                                              = RIGHT(GP_PAYCODES.DSCRIPTN, CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) - 1)
                       WHERE      (CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) > 0) AND (CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) > 0) AND 
                                              (ITEM_TYPES.CODE = 'hours') AND (dbo.ITEMS.ORGANIZATION_ID = 20)
                       UNION
                       SELECT     '1' AS pay_code, ITEMS_2.NAME AS item_name, ITEMS_2.ITEM_ID, 't' AS defaulted
                       FROM         dbo.ITEMS AS ITEMS_2 INNER JOIN
                                             dbo.LOOKUPS AS item_types ON ITEMS_2.ITEM_TYPE_ID = item_types.LOOKUP_ID
                       WHERE     (item_types.CODE = 'hours') AND (ITEMS_2.ITEM_ID NOT IN
                                                 (SELECT     ITEMS_1.ITEM_ID
                                                   FROM          dbo.LOOKUPS AS ITEM_TYPES INNER JOIN
                                                                          dbo.ITEMS AS ITEMS_1 ON ITEM_TYPES.LOOKUP_ID = ITEMS_1.ITEM_TYPE_ID INNER JOIN
                                                                          dbo.GP_PHX_PAY_CODE_V AS GP_PAYCODES ON RIGHT(ITEMS_1.NAME, CHARINDEX('-', REVERSE(ITEMS_1.NAME)) - 1) 
                                                                          = RIGHT(GP_PAYCODES.DSCRIPTN, CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) - 1)
                                                   WHERE      (CHARINDEX('-', REVERSE(ITEMS_1.NAME)) > 0) AND (CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) > 0) AND 
                                                                          (ITEM_TYPES.CODE = 'hours') AND (ITEMS_1.ORGANIZATION_ID = 20)))) AS DERIVEDTBL

