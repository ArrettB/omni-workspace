
CREATE VIEW dbo.tcn_resources_v
AS
SELECT     dbo.USERS.EXT_EMPLOYEE_ID AS employee_no, dbo.RESOURCES.NAME AS resource_name, dbo.RESOURCES.RESOURCE_ID, 
                      dbo.RESOURCES.ORGANIZATION_ID
FROM         dbo.USERS INNER JOIN
                      dbo.RESOURCES ON dbo.USERS.USER_ID = dbo.RESOURCES.USER_ID
WHERE     (dbo.RESOURCES.ACTIVE_FLAG = 'Y')


