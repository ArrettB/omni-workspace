if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tcn_resource_items_v]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[tcn_resource_items_v]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tcn_resources_v]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[tcn_resources_v]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.tcn_resource_items_v
AS
SELECT     dbo.ITEMS.NAME AS item_name, dbo.LOOKUPS.CODE AS item_type_code, dbo.RESOURCE_ITEMS.RESOURCE_ID, dbo.ITEMS.ITEM_ID, 
                      dbo.ITEMS.ORGANIZATION_ID, job_type.CODE, dbo.JOBS.JOB_TYPE_ID, dbo.JOBS.JOB_ID
FROM         dbo.RESOURCE_ITEMS INNER JOIN
                      dbo.ITEMS ON dbo.RESOURCE_ITEMS.ITEM_ID = dbo.ITEMS.ITEM_ID INNER JOIN
                      dbo.LOOKUPS ON dbo.ITEMS.ITEM_TYPE_ID = dbo.LOOKUPS.LOOKUP_ID INNER JOIN
                      dbo.JOBS ON dbo.ITEMS.JOB_TYPE_ID = dbo.JOBS.JOB_TYPE_ID INNER JOIN
                      dbo.LOOKUPS job_type ON dbo.JOBS.JOB_TYPE_ID = job_type.LOOKUP_ID

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.tcn_resources_v
AS
SELECT     dbo.USERS.EXT_EMPLOYEE_ID AS employee_no, dbo.RESOURCES.NAME AS resource_name, dbo.RESOURCES.RESOURCE_ID, 
                      dbo.RESOURCES.ORGANIZATION_ID
FROM         dbo.USERS INNER JOIN
                      dbo.RESOURCES ON dbo.USERS.USER_ID = dbo.RESOURCES.USER_ID
WHERE     (dbo.RESOURCES.ACTIVE_FLAG = 'Y')

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

