
CREATE  VIEW dbo.GP_ICS_PAY_CODE_V
AS
SELECT     *
FROM         ICS.dbo.UPR40600
WHERE     (PAYRCORD IN ('1', '2', '3', '4', '8', '16')) AND (INACTIVE = 0)

