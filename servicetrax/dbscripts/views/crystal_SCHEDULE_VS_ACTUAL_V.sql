CREATE VIEW dbo.crystal_SCHEDULE_VS_ACTUAL_V
AS
SELECT     dbo.crystal_SCH_ACT_1_V.RESOURCE_ID, dbo.crystal_SCH_ACT_1_V.resource_name, dbo.crystal_SCH_ACT_1_V.JOB_ID, 
                      dbo.crystal_SCH_ACT_1_V.JOB_NO, dbo.crystal_SCH_ACT_1_V.exploded_date, dbo.crystal_SCH_ACT_2_V.SERVICE_LINE_ID, 
                      dbo.crystal_SCH_ACT_2_V.SERVICE_LINE_DATE, dbo.crystal_SCH_ACT_2_V.ITEM_NAME, dbo.crystal_SCH_ACT_2_V.TC_QTY, 
                      dbo.crystal_SCH_ACT_2_V.OVERRIDE_DATE, dbo.crystal_SCH_ACT_2_V.VERIFIED_DATE, dbo.crystal_SCH_ACT_2_V.VERIFIED_BY
FROM         dbo.crystal_SCH_ACT_1_V LEFT OUTER JOIN
                      dbo.crystal_SCH_ACT_2_V ON dbo.crystal_SCH_ACT_1_V.RESOURCE_ID = dbo.crystal_SCH_ACT_2_V.RESOURCE_ID AND 
                      dbo.crystal_SCH_ACT_1_V.exploded_date = dbo.crystal_SCH_ACT_2_V.SERVICE_LINE_DATE AND 
                      dbo.crystal_SCH_ACT_1_V.JOB_NO = dbo.crystal_SCH_ACT_2_V.TC_JOB_NO

