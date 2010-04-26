


CREATE VIEW dbo.PKT_ROSTER_V
AS
SELECT     JOB_ID, RESOURCE_ID
FROM         (SELECT     JOB_ID, RESOURCE_ID
                       FROM          dbo.SCH_RESOURCES
                       WHERE      (CONVERT(datetime, CONVERT(varchar, RES_START_DATE, 101)) <= CONVERT(datetime, CONVERT(varchar, GETDATE(), 101))) AND 
                                              (ISNULL(CONVERT(datetime, CONVERT(varchar, RES_END_DATE, 101)), DATEADD(day, 1, CONVERT(datetime, CONVERT(varchar, 
                                              GETDATE(), 101)))) >= CONVERT(datetime, CONVERT(varchar, GETDATE(), 101)))
                       UNION
                       SELECT     dbo.PDA_ROSTER_CHANGES.JOB_ID, dbo.PDA_ROSTER_CHANGES.RESOURCE_ID
                       FROM         dbo.PDA_ROSTER_CHANGES INNER JOIN
                                             dbo.RESOURCES ON dbo.PDA_ROSTER_CHANGES.RESOURCE_ID = dbo.RESOURCES.RESOURCE_ID
                       WHERE     (dbo.RESOURCES.ACTIVE_FLAG = 'Y')) tempTable



