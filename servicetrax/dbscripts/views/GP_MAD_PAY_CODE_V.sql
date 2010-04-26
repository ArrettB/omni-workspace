
CREATE  VIEW dbo.GP_MAD_PAY_CODE_V
AS
SELECT     *
FROM         AMMAD.dbo.UPR40600
WHERE     (PAYRCORD IN ('1', '2', '3', '4', '8', '16')) AND (INACTIVE = 0)

