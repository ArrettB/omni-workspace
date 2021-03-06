CREATE TABLE dbo.QUOTE_OTHER_FURNITURE_AD_HOC (
QUOTE_OTHER_FURNITURE_AD_HOC_ID NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
QUOTE_ID [NUMERIC](18, 0) NOT NULL,
SET_NUMBER NUMERIC(18,0) NOT NULL,
	[DESCRIPTION] [VARCHAR](150) NOT NULL,
	[BILL] [VARCHAR](20) NULL,
	[DATE_CREATED] [DATETIME] NOT NULL,
	[CREATED_BY] [NUMERIC](18, 0) NOT NULL,
	[DATE_MODIFIED] [DATETIME] NULL,
	[MODIFIED_BY] [NUMERIC](18, 0) NULL,
	 CONSTRAINT PK_QUOTE_OTHER_FURNITURE_AD_HOC PRIMARY KEY CLUSTERED 
	(
		[QUOTE_OTHER_FURNITURE_AD_HOC_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)
)
GO

ALTER TABLE [dbo].[QUOTE_OTHER_FURNITURE_AD_HOC]  WITH NOCHECK ADD  CONSTRAINT [FK_QOFAH_QUOTES] FOREIGN KEY([QUOTE_ID])
REFERENCES [dbo].[QUOTES] ([QUOTE_ID])
GO

ALTER TABLE [dbo].[QUOTE_OTHER_FURNITURE_AD_HOC] CHECK CONSTRAINT [FK_QOFAH_QUOTES]
GO

ALTER TABLE [dbo].[QUOTE_OTHER_FURNITURE_AD_HOC]  WITH NOCHECK ADD  CONSTRAINT [FK_QOFAH_USERS_C] FOREIGN KEY([CREATED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[QUOTE_OTHER_FURNITURE_AD_HOC] CHECK CONSTRAINT [FK_QOFAH_USERS_C]
GO
ALTER TABLE [dbo].[QUOTE_OTHER_FURNITURE_AD_HOC]  WITH NOCHECK ADD  CONSTRAINT [FK_QOFAH_USERS_M] FOREIGN KEY([MODIFIED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[QUOTE_OTHER_FURNITURE_AD_HOC] CHECK CONSTRAINT [FK_QOFAH_USERS_M]
GO
