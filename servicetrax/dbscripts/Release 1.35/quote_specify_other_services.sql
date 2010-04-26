CREATE TABLE dbo.QUOTE_SPECIFY_OTHER_SERVICES (
QUOTE_SPECIFY_OTHER_SERVICE_ID NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
QUOTE_ID [NUMERIC](18, 0) NOT NULL,
SET_NUMBER NUMERIC(18,0) NOT NULL,
	[SPECIFY_SERVICE] [VARCHAR](30) NOT NULL,
	[BILL] [VARCHAR](20) NULL,
	[DATE_CREATED] [DATETIME] NOT NULL,
	[CREATED_BY] [NUMERIC](18, 0) NOT NULL,
	[DATE_MODIFIED] [DATETIME] NULL,
	[MODIFIED_BY] [NUMERIC](18, 0) NULL,
	 CONSTRAINT PK_QUOTE_SPECIFY_OTHER_SERVICES PRIMARY KEY CLUSTERED 
	(
		[QUOTE_SPECIFY_OTHER_SERVICE_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)
)
GO

ALTER TABLE [dbo].[QUOTE_SPECIFY_OTHER_SERVICES]  WITH NOCHECK ADD  CONSTRAINT [FK_QSOS_QUOTES] FOREIGN KEY([QUOTE_ID])
REFERENCES [dbo].[QUOTES] ([QUOTE_ID])
GO

ALTER TABLE [dbo].[QUOTE_SPECIFY_OTHER_SERVICES] CHECK CONSTRAINT [FK_QSOS_QUOTES]
GO

ALTER TABLE [dbo].[QUOTE_SPECIFY_OTHER_SERVICES]  WITH NOCHECK ADD  CONSTRAINT [FK_QSOS_USERS_C] FOREIGN KEY([CREATED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[QUOTE_SPECIFY_OTHER_SERVICES] CHECK CONSTRAINT [FK_QSOS_USERS_C]
GO
ALTER TABLE [dbo].[QUOTE_SPECIFY_OTHER_SERVICES]  WITH NOCHECK ADD  CONSTRAINT [FK_QSOS_USERS_M] FOREIGN KEY([MODIFIED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[QUOTE_SPECIFY_OTHER_SERVICES] CHECK CONSTRAINT [FK_QSOS_USERS_M]
GO



INSERT INTO [QUOTE_SPECIFY_OTHER_SERVICES]
           ([QUOTE_ID]
           ,[SET_NUMBER]
           ,[SPECIFY_SERVICE]
           ,[BILL]
           ,[DATE_CREATED]
           ,[CREATED_BY]
           ,[DATE_MODIFIED]
           ,[MODIFIED_BY])
           (SELECT [quote_id]
           , 1
      ,[SPECIFY_SERVICES_1]
      ,[SPECIFY_SERVICES_BILL_1]
      ,[date_created]
      ,[created_by]
      ,[date_modified]
      ,[modified_by]
  FROM [ims_new].[dbo].[QUOTES]
  where SPECIFY_SERVICES_1 is not null and LEN(SPECIFY_SERVICES_1) > 0)
GO



INSERT INTO [QUOTE_SPECIFY_OTHER_SERVICES]
           ([QUOTE_ID]
           ,[SET_NUMBER]
           ,[SPECIFY_SERVICE]
           ,[BILL]
           ,[DATE_CREATED]
           ,[CREATED_BY]
           ,[DATE_MODIFIED]
           ,[MODIFIED_BY])
           (SELECT [quote_id]
           , 2
      ,[SPECIFY_SERVICES_2]
      ,[SPECIFY_SERVICES_BILL_2]
      ,[date_created]
      ,[created_by]
      ,[date_modified]
      ,[modified_by]
  FROM [ims_new].[dbo].[QUOTES]
  where SPECIFY_SERVICES_2 is not null and LEN(SPECIFY_SERVICES_2) > 0)
GO


INSERT INTO [QUOTE_SPECIFY_OTHER_SERVICES]
           ([QUOTE_ID]
           ,[SET_NUMBER]
           ,[SPECIFY_SERVICE]
           ,[BILL]
           ,[DATE_CREATED]
           ,[CREATED_BY]
           ,[DATE_MODIFIED]
           ,[MODIFIED_BY])
           (SELECT [quote_id]
           , 3
      ,[SPECIFY_SERVICES_3]
      ,[SPECIFY_SERVICES_BILL_3]
      ,[date_created]
      ,[created_by]
      ,[date_modified]
      ,[modified_by]
  FROM [ims_new].[dbo].[QUOTES]
  where SPECIFY_SERVICES_3 is not null and LEN(SPECIFY_SERVICES_3) > 0)
GO



INSERT INTO [QUOTE_SPECIFY_OTHER_SERVICES]
           ([QUOTE_ID]
           ,[SET_NUMBER]
           ,[SPECIFY_SERVICE]
           ,[BILL]
           ,[DATE_CREATED]
           ,[CREATED_BY]
           ,[DATE_MODIFIED]
           ,[MODIFIED_BY])
           (SELECT [quote_id]
           , 4
      ,[SPECIFY_SERVICES_4]
      ,[SPECIFY_SERVICES_BILL_4]
      ,[date_created]
      ,[created_by]
      ,[date_modified]
      ,[modified_by]
  FROM [ims_new].[dbo].[QUOTES]
  where SPECIFY_SERVICES_4 is not null and LEN(SPECIFY_SERVICES_4) > 0)
GO


INSERT INTO [QUOTE_SPECIFY_OTHER_SERVICES]
           ([QUOTE_ID]
           ,[SET_NUMBER]
           ,[SPECIFY_SERVICE]
           ,[BILL]
           ,[DATE_CREATED]
           ,[CREATED_BY]
           ,[DATE_MODIFIED]
           ,[MODIFIED_BY])
           (SELECT [quote_id]
           , 5
      ,[SPECIFY_SERVICES_5]
      ,[SPECIFY_SERVICES_BILL_5]
      ,[date_created]
      ,[created_by]
      ,[date_modified]
      ,[modified_by]
  FROM [ims_new].[dbo].[QUOTES]
  where SPECIFY_SERVICES_5 is not null and LEN(SPECIFY_SERVICES_5) > 0)
GO




INSERT INTO [QUOTE_SPECIFY_OTHER_SERVICES]
           ([QUOTE_ID]
           ,[SET_NUMBER]
           ,[SPECIFY_SERVICE]
           ,[BILL]
           ,[DATE_CREATED]
           ,[CREATED_BY]
           ,[DATE_MODIFIED]
           ,[MODIFIED_BY])
           (SELECT [quote_id]
           , 6
      ,[SPECIFY_SERVICES_6]
      ,[SPECIFY_SERVICES_BILL_6]
      ,[date_created]
      ,[created_by]
      ,[date_modified]
      ,[modified_by]
  FROM [ims_new].[dbo].[QUOTES]
  where SPECIFY_SERVICES_6 is not null and LEN(SPECIFY_SERVICES_6) > 0)
GO


INSERT INTO [QUOTE_SPECIFY_OTHER_SERVICES]
           ([QUOTE_ID]
           ,[SET_NUMBER]
           ,[SPECIFY_SERVICE]
           ,[BILL]
           ,[DATE_CREATED]
           ,[CREATED_BY]
           ,[DATE_MODIFIED]
           ,[MODIFIED_BY])
           (SELECT [quote_id]
           , 7
      ,[SPECIFY_SERVICES_7]
      ,[SPECIFY_SERVICES_BILL_7]
      ,[date_created]
      ,[created_by]
      ,[date_modified]
      ,[modified_by]
  FROM [ims_new].[dbo].[QUOTES]
  where SPECIFY_SERVICES_7 is not null and LEN(SPECIFY_SERVICES_7) > 0)
GO



INSERT INTO [QUOTE_SPECIFY_OTHER_SERVICES]
           ([QUOTE_ID]
           ,[SET_NUMBER]
           ,[SPECIFY_SERVICE]
           ,[BILL]
           ,[DATE_CREATED]
           ,[CREATED_BY]
           ,[DATE_MODIFIED]
           ,[MODIFIED_BY])
           (SELECT [quote_id]
           , 8
      ,[SPECIFY_SERVICES_8]
      ,[SPECIFY_SERVICES_BILL_8]
      ,[date_created]
      ,[created_by]
      ,[date_modified]
      ,[modified_by]
  FROM [ims_new].[dbo].[QUOTES]
  where SPECIFY_SERVICES_8 is not null and LEN(SPECIFY_SERVICES_8) > 0)
GO



INSERT INTO [QUOTE_SPECIFY_OTHER_SERVICES]
           ([QUOTE_ID]
           ,[SET_NUMBER]
           ,[SPECIFY_SERVICE]
           ,[BILL]
           ,[DATE_CREATED]
           ,[CREATED_BY]
           ,[DATE_MODIFIED]
           ,[MODIFIED_BY])
           (SELECT [quote_id]
           , 9
      ,[SPECIFY_SERVICES_9]
      ,[SPECIFY_SERVICES_BILL_9]
      ,[date_created]
      ,[created_by]
      ,[date_modified]
      ,[modified_by]
  FROM [ims_new].[dbo].[QUOTES]
  where SPECIFY_SERVICES_9 is not null and LEN(SPECIFY_SERVICES_9) > 0)
GO



INSERT INTO [QUOTE_SPECIFY_OTHER_SERVICES]
           ([QUOTE_ID]
           ,[SET_NUMBER]
           ,[SPECIFY_SERVICE]
           ,[BILL]
           ,[DATE_CREATED]
           ,[CREATED_BY]
           ,[DATE_MODIFIED]
           ,[MODIFIED_BY])
           (SELECT [quote_id]
           , 10
      ,[SPECIFY_SERVICES_10]
      ,[SPECIFY_SERVICES_BILL_10]
      ,[date_created]
      ,[created_by]
      ,[date_modified]
      ,[modified_by]
  FROM [ims_new].[dbo].[QUOTES]
  where SPECIFY_SERVICES_10 is not null and LEN(SPECIFY_SERVICES_10) > 0)
GO


ALTER TABLE dbo.QUOTES
	DROP COLUMN specify_services_1, specify_services_2, specify_services_3, specify_services_4, specify_services_5, specify_services_6, specify_services_7, specify_services_8, specify_services_9, specify_services_10, specify_services_bill_1, specify_services_bill_2, specify_services_bill_3, specify_services_bill_4, specify_services_bill_5, specify_services_bill_6, specify_services_bill_7, specify_services_bill_8, specify_services_bill_9, specify_services_bill_10
GO
