/**
 * Add the columns to service_lines for timekeeping
 * and the column to requests for the plan_location_id
 */
/*
 * Alter the requests table and add the foreign key
 */
ALTER TABLE [dbo].[REQUESTS]
   ADD [PLAN_LOCATION_TYPE_ID]  [NUMERIC](18,0)
GO

ALTER TABLE [REQUESTS] ADD CONSTRAINT [FK_REQUESTS_LOOKUPS_PLAN_LOCATION_TYPE] 
    FOREIGN KEY ([PLAN_LOCATION_TYPE_ID]) REFERENCES [LOOKUPS] ([LOOKUP_ID])
GO


/*
 * Alter the requests table and add the foreign key
 */
ALTER TABLE [dbo].[SERVICE_LINES]
   ADD [START_TIME]  [INTEGER]
GO
ALTER TABLE [dbo].[SERVICE_LINES]
   ADD [END_TIME]  [INTEGER]
GO
ALTER TABLE [dbo].[SERVICE_LINES]
   ADD [BREAK_TIME_MINUTES]  [INTEGER]
GO
