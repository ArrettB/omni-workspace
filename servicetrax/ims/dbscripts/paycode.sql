ALTER  VIEW dbo.GP_MPLS_PAY_CODE_V
AS
SELECT     *
FROM         AMBIM.dbo.UPR40600
WHERE     (PAYRCORD IN ('1', '2', '3', '4', '8', '16')) AND (INACTIVE = 0)
go

ALTER  VIEW dbo.GP_MAD_PAY_CODE_V
AS
SELECT     *
FROM         AMMAD.dbo.UPR40600
WHERE     (PAYRCORD IN ('1', '2', '3', '4', '8', '16')) AND (INACTIVE = 0)
go

ALTER  VIEW dbo.GP_AIA_PAY_CODE_V
AS
SELECT     *
FROM         AIA.dbo.UPR40600
WHERE     (PAYRCORD IN ('1', '2', '3', '4', '8', '16')) AND (INACTIVE = 0)
go

ALTER  VIEW dbo.GP_CIINC_PAY_CODE_V
AS
SELECT     *
FROM         CIINC.dbo.UPR40600
WHERE     (PAYRCORD IN ('1', '2', '3', '4', '8', '16')) AND (INACTIVE = 0)
go

ALTER  VIEW dbo.GP_CILLC_PAY_CODE_V
AS
SELECT     *
FROM         CILLC.dbo.UPR40600
WHERE     (PAYRCORD IN ('1', '2', '3', '4', '8', '16')) AND (INACTIVE = 0)
go

ALTER  VIEW dbo.GP_ICS_PAY_CODE_V
AS
SELECT     *
FROM         ICS.dbo.UPR40600
WHERE     (PAYRCORD IN ('1', '2', '3', '4', '8', '16')) AND (INACTIVE = 0)
go

CREATE  VIEW dbo.GP_IT_PAY_CODE_V
AS
SELECT     *
FROM         IT.dbo.UPR40600
WHERE     (PAYRCORD IN ('1', '2', '3', '4', '8', '16')) AND (INACTIVE = 0)
go


CREATE VIEW dbo.GP_IT_ITEM_PAYCODES_V
AS
SELECT     ITEM_ID, item_name, pay_code, defaulted
FROM         (SELECT     GP_PAYCODES.PAYRCORD AS pay_code, dbo.ITEMS.NAME AS item_name, dbo.ITEMS.ITEM_ID, 'f' AS defaulted
                       FROM          dbo.LOOKUPS ITEM_TYPES INNER JOIN
                                              dbo.ITEMS ON ITEM_TYPES.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID INNER JOIN
                                              dbo.GP_IT_PAY_CODE_V GP_PAYCODES ON RIGHT(dbo.ITEMS.NAME, CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) - 1) 
                                              = RIGHT(GP_PAYCODES.DSCRIPTN, CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) - 1)
                       WHERE      (CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) > 0) AND (CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) > 0) AND 
                                              (ITEM_TYPES.CODE = 'hours')
                       UNION
                       SELECT     '1' AS pay_code, dbo.ITEMS.NAME AS item_name, dbo.ITEMS.ITEM_ID, 't' AS defaulted
                       FROM         dbo.ITEMS INNER JOIN
                                             dbo.LOOKUPS item_types ON dbo.ITEMS.ITEM_TYPE_ID = item_types.LOOKUP_ID
                       WHERE     (item_types.CODE = 'hours') AND (dbo.ITEMS.ITEM_ID NOT IN
                                                 (SELECT     dbo.ITEMS.ITEM_ID
                                                   FROM          dbo.LOOKUPS ITEM_TYPES INNER JOIN
                                                                          dbo.ITEMS ON ITEM_TYPES.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID INNER JOIN
                                                                          dbo.GP_IT_PAY_CODE_V GP_PAYCODES ON RIGHT(dbo.ITEMS.NAME, CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) - 1) 
                                                                          = RIGHT(GP_PAYCODES.DSCRIPTN, CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) - 1)
                                                   WHERE      (CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) > 0) AND (CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) > 0) AND 
                                                                          (ITEM_TYPES.CODE = 'hours')))) DERIVEDTBL

GO
