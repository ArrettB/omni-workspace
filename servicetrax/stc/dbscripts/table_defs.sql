if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AUTHENTICATION_KEYS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[authentication_keys]
GO

CREATE TABLE [dbo].[AUTHENTICATION_KEYS] (
	[authentication_key_id] [numeric](18, 0) IDENTITY (1, 1) NOT NULL ,
	[auth] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[user_id] [numeric](18, 0) NOT NULL ,
	[organization_id] [numeric](18, 0) NOT NULL ,
	[expire_date] [datetime] NOT NULL 
) ON [PRIMARY]
GO

