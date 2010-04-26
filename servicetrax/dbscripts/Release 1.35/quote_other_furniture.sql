CREATE TABLE dbo.QUOTE_OTHER_FURNITURE (
QUOTE_OTHER_FURNITURE_ID NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
QUOTE_ID [NUMERIC](18, 0) NOT NULL,
SET_NUMBER NUMERIC(18,0) NOT NULL,
	[DESCRIPTION] [VARCHAR](100) NOT NULL,
	[QTY] [VARCHAR](20) NULL,
	[DATE_CREATED] [DATETIME] NOT NULL,
	[CREATED_BY] [NUMERIC](18, 0) NOT NULL,
	[DATE_MODIFIED] [DATETIME] NULL,
	[MODIFIED_BY] [NUMERIC](18, 0) NULL,
	 CONSTRAINT PK_QUOTE_OTHER_FURNITURE PRIMARY KEY CLUSTERED 
	(
		[QUOTE_OTHER_FURNITURE_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)
)
GO

ALTER TABLE [dbo].[QUOTE_OTHER_FURNITURE]  WITH NOCHECK ADD  CONSTRAINT [FK_QOF_QUOTES] FOREIGN KEY([QUOTE_ID])
REFERENCES [dbo].[QUOTES] ([QUOTE_ID])
GO

ALTER TABLE [dbo].[QUOTE_OTHER_FURNITURE] CHECK CONSTRAINT [FK_QOF_QUOTES]
GO

ALTER TABLE [dbo].[QUOTE_OTHER_FURNITURE]  WITH NOCHECK ADD  CONSTRAINT [FK_QOF_USERS_C] FOREIGN KEY([CREATED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[QUOTE_OTHER_FURNITURE] CHECK CONSTRAINT [FK_QOF_USERS_C]
GO
ALTER TABLE [dbo].[QUOTE_OTHER_FURNITURE]  WITH NOCHECK ADD  CONSTRAINT [FK_QOF_USERS_M] FOREIGN KEY([MODIFIED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[QUOTE_OTHER_FURNITURE] CHECK CONSTRAINT [FK_QOF_USERS_M]
GO



INSERT INTO [QUOTE_OTHER_FURNITURE]
           ([QUOTE_ID]
           ,[SET_NUMBER]
           ,[DESCRIPTION]
           ,[QTY]
           ,[DATE_CREATED]
           ,[CREATED_BY]
           ,[DATE_MODIFIED]
           ,[MODIFIED_BY])
           (SELECT [quote_id]
           , 1
      ,[OTHER_FURNITURE_1]
      ,[OTHER_FURNITURE_COUNT_1]
      ,[date_created]
      ,[created_by]
      ,[date_modified]
      ,[modified_by]
  FROM [ims_new].[dbo].[QUOTES]
  where OTHER_FURNITURE_1 is not null and LEN(OTHER_FURNITURE_1) > 0)
GO

INSERT INTO [QUOTE_OTHER_FURNITURE]
           ([QUOTE_ID]
           ,[SET_NUMBER]
           ,[DESCRIPTION]
           ,[QTY]
           ,[DATE_CREATED]
           ,[CREATED_BY]
           ,[DATE_MODIFIED]
           ,[MODIFIED_BY])
           (SELECT [quote_id]
           , 2
      ,[OTHER_FURNITURE_2]
      ,[OTHER_FURNITURE_COUNT_2]
      ,[date_created]
      ,[created_by]
      ,[date_modified]
      ,[modified_by]
  FROM [ims_new].[dbo].[QUOTES]
  where OTHER_FURNITURE_2 is not null and LEN(OTHER_FURNITURE_2) > 0)
GO


INSERT INTO [QUOTE_OTHER_FURNITURE]
           ([QUOTE_ID]
           ,[SET_NUMBER]
           ,[DESCRIPTION]
           ,[QTY]
           ,[DATE_CREATED]
           ,[CREATED_BY]
           ,[DATE_MODIFIED]
           ,[MODIFIED_BY])
           (SELECT [quote_id]
           , 3
      ,[OTHER_FURNITURE_3]
      ,[OTHER_FURNITURE_COUNT_3]
      ,[date_created]
      ,[created_by]
      ,[date_modified]
      ,[modified_by]
  FROM [ims_new].[dbo].[QUOTES]
  where OTHER_FURNITURE_3 is not null and LEN(OTHER_FURNITURE_3) > 0)
GO



INSERT INTO [QUOTE_OTHER_FURNITURE]
           ([QUOTE_ID]
           ,[SET_NUMBER]
           ,[DESCRIPTION]
           ,[QTY]
           ,[DATE_CREATED]
           ,[CREATED_BY]
           ,[DATE_MODIFIED]
           ,[MODIFIED_BY])
           (SELECT [quote_id]
           , 4
      ,[OTHER_FURNITURE_4]
      ,[OTHER_FURNITURE_COUNT_4]
      ,[date_created]
      ,[created_by]
      ,[date_modified]
      ,[modified_by]
  FROM [ims_new].[dbo].[QUOTES]
  where OTHER_FURNITURE_4 is not null and LEN(OTHER_FURNITURE_4) > 0)
GO



INSERT INTO [QUOTE_OTHER_FURNITURE]
           ([QUOTE_ID]
           ,[SET_NUMBER]
           ,[DESCRIPTION]
           ,[QTY]
           ,[DATE_CREATED]
           ,[CREATED_BY]
           ,[DATE_MODIFIED]
           ,[MODIFIED_BY])
           (SELECT [quote_id]
           , 5
      ,[OTHER_FURNITURE_5]
      ,[OTHER_FURNITURE_COUNT_5]
      ,[date_created]
      ,[created_by]
      ,[date_modified]
      ,[modified_by]
  FROM [ims_new].[dbo].[QUOTES]
  where OTHER_FURNITURE_5 is not null and LEN(OTHER_FURNITURE_5) > 0)
GO


INSERT INTO [QUOTE_OTHER_FURNITURE]
           ([QUOTE_ID]
           ,[SET_NUMBER]
           ,[DESCRIPTION]
           ,[QTY]
           ,[DATE_CREATED]
           ,[CREATED_BY]
           ,[DATE_MODIFIED]
           ,[MODIFIED_BY])
           (SELECT [quote_id]
           , 6
      ,[OTHER_FURNITURE_6]
      ,[OTHER_FURNITURE_COUNT_6]
      ,[date_created]
      ,[created_by]
      ,[date_modified]
      ,[modified_by]
  FROM [ims_new].[dbo].[QUOTES]
  where OTHER_FURNITURE_6 is not null and LEN(OTHER_FURNITURE_6) > 0)
GO



INSERT INTO [QUOTE_OTHER_FURNITURE]
           ([QUOTE_ID]
           ,[SET_NUMBER]
           ,[DESCRIPTION]
           ,[QTY]
           ,[DATE_CREATED]
           ,[CREATED_BY]
           ,[DATE_MODIFIED]
           ,[MODIFIED_BY])
           (SELECT [quote_id]
           , 7
      ,[OTHER_FURNITURE_7]
      ,[OTHER_FURNITURE_COUNT_7]
      ,[date_created]
      ,[created_by]
      ,[date_modified]
      ,[modified_by]
  FROM [ims_new].[dbo].[QUOTES]
  where OTHER_FURNITURE_7 is not null and LEN(OTHER_FURNITURE_7) > 0)
GO



INSERT INTO [QUOTE_OTHER_FURNITURE]
           ([QUOTE_ID]
           ,[SET_NUMBER]
           ,[DESCRIPTION]
           ,[QTY]
           ,[DATE_CREATED]
           ,[CREATED_BY]
           ,[DATE_MODIFIED]
           ,[MODIFIED_BY])
           (SELECT [quote_id]
           , 8
      ,[OTHER_FURNITURE_8]
      ,[OTHER_FURNITURE_COUNT_8]
      ,[date_created]
      ,[created_by]
      ,[date_modified]
      ,[modified_by]
  FROM [ims_new].[dbo].[QUOTES]
  where OTHER_FURNITURE_8 is not null and LEN(OTHER_FURNITURE_8) > 0)
GO




INSERT INTO [QUOTE_OTHER_FURNITURE]
           ([QUOTE_ID]
           ,[SET_NUMBER]
           ,[DESCRIPTION]
           ,[QTY]
           ,[DATE_CREATED]
           ,[CREATED_BY]
           ,[DATE_MODIFIED]
           ,[MODIFIED_BY])
           (SELECT [quote_id]
           , 9
      ,[OTHER_FURNITURE_9]
      ,[OTHER_FURNITURE_COUNT_9]
      ,[date_created]
      ,[created_by]
      ,[date_modified]
      ,[modified_by]
  FROM [ims_new].[dbo].[QUOTES]
  where OTHER_FURNITURE_9 is not null and LEN(OTHER_FURNITURE_9) > 0)
GO




INSERT INTO [QUOTE_OTHER_FURNITURE]
           ([QUOTE_ID]
           ,[SET_NUMBER]
           ,[DESCRIPTION]
           ,[QTY]
           ,[DATE_CREATED]
           ,[CREATED_BY]
           ,[DATE_MODIFIED]
           ,[MODIFIED_BY])
           (SELECT [quote_id]
           , 10
      ,[OTHER_FURNITURE_10]
      ,[OTHER_FURNITURE_COUNT_10]
      ,[date_created]
      ,[created_by]
      ,[date_modified]
      ,[modified_by]
  FROM [ims_new].[dbo].[QUOTES]
  where OTHER_FURNITURE_10 is not null and LEN(OTHER_FURNITURE_10) > 0)
GO

ALTER TABLE dbo.QUOTES
	DROP COLUMN other_furniture_1, other_furniture_count_1, other_furniture_2, other_furniture_count_2, other_furniture_3, other_furniture_count_3, other_furniture_4, other_furniture_count_4, other_furniture_5, other_furniture_count_5, other_furniture_6, other_furniture_count_6, other_furniture_7, other_furniture_count_7, other_furniture_8, other_furniture_count_8, other_furniture_9, other_furniture_count_9, other_furniture_10, other_furniture_count_10
GO

