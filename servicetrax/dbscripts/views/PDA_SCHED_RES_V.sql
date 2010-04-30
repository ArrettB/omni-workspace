CREATE VIEW dbo.PDA_SCHED_RES_V AS SELECT dbo.SCH_RESOURCES_V.SCH_RESOURCE_ID AS sched_resource_id, dbo.SCH_RESOURCES_V.JOB_ID, dbo.SCH_RESOURCES_V.RESOURCE_ID, dbo.SCH_RESOURCES_V.resource_name AS name, dbo.PDA_JOBS_V.ims_user_id FROM dbo.SCH_RESOURCES_V INNER JOIN dbo.PDA_JOBS_V ON dbo.SCH_RESOURCES_V.JOB_ID = dbo.PDA_JOBS_V.JOB_ID WHERE (CONVERT(datetime, CONVERT(varchar, dbo.SCH_RESOURCES_V.RES_START_DATE, 101)) <= CONVERT(datetime, CONVERT(varchar, GETDATE(), 101))) AND (ISNULL(CONVERT(datetime, CONVERT(varchar, dbo.SCH_RESOURCES_V.RES_END_DATE, 101)), DATEADD(day, 1, CONVERT(datetime, CONVERT(varchar, GETDATE(), 101)))) >= CONVERT(datetime, CONVERT(varchar, GETDATE(), 101))) AND (dbo.PDA_JOBS_V.ims_user_id IS NOT NULL)