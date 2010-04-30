/****** Object:  Table [dbo].[QUOTE_STANDARD_CONDITIONS]    Script Date: 03/06/2009 09:52:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[QUOTE_STANDARD_CONDITIONS](
	[QUOTE_STANDARD_CONDITION_ID] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[QUOTE_ID] [numeric](18, 0) NOT NULL,
	[STANDARD_CONDITION_ID] [numeric](18, 0) NOT NULL,
	[DATE_CREATED] [datetime] NOT NULL,
	[CREATED_BY] [numeric](18, 0) NOT NULL,
	[DATE_MODIFIED] [datetime] NULL,
	[MODIFIED_BY] [numeric](18, 0) NULL,
 CONSTRAINT [PK_QUOTE_STANDARD_CONDITIONS] PRIMARY KEY CLUSTERED 
(
	[QUOTE_STANDARD_CONDITION_ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[QUOTE_STANDARD_CONDITIONS]  WITH NOCHECK ADD  CONSTRAINT [FK_QSC_STANDARD_CONDITIONS] FOREIGN KEY([STANDARD_CONDITION_ID])
REFERENCES [dbo].[STANDARD_CONDITIONS] ([STANDARD_CONDITION_ID])
GO
ALTER TABLE [dbo].[QUOTE_STANDARD_CONDITIONS] CHECK CONSTRAINT [FK_QSC_STANDARD_CONDITIONS]
GO
ALTER TABLE [dbo].[QUOTE_STANDARD_CONDITIONS]  WITH NOCHECK ADD  CONSTRAINT [FK_QSC_USERS_C] FOREIGN KEY([CREATED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[QUOTE_STANDARD_CONDITIONS] CHECK CONSTRAINT [FK_QSC_USERS_C]
GO
ALTER TABLE [dbo].[QUOTE_STANDARD_CONDITIONS]  WITH NOCHECK ADD  CONSTRAINT [FK_QSC_USERS_M] FOREIGN KEY([MODIFIED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[QUOTE_STANDARD_CONDITIONS] CHECK CONSTRAINT [FK_QSC_USERS_M]
GO

ALTER TABLE [dbo].[QUOTE_STANDARD_CONDITIONS]  WITH NOCHECK ADD  CONSTRAINT [FK_QSC_QUOTES] FOREIGN KEY([QUOTE_ID])
REFERENCES [dbo].[QUOTES] ([QUOTE_ID])
GO
ALTER TABLE [dbo].[QUOTE_STANDARD_CONDITIONS] CHECK CONSTRAINT [FK_QSC_QUOTES]
GO


INSERT INTO quote_standard_conditions (quote_id, standard_condition_id, date_created, created_by)
(
select q.quote_id, sc.standard_condition_id, getDate(), 1 from quotes q INNER JOIN requests r ON q.request_id = r.request_id
INNER JOIN projects p ON p.project_id = r.project_id
CROSS JOIN standard_conditions sc
where p.end_user_id IS NOT NULL)
GO