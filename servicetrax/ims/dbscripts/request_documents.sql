CREATE TABLE [REQUEST_DOCUMENTS] (
	[request_document_id] [numeric](18, 0) IDENTITY (1, 1) NOT NULL ,
	[request_id] [numeric](18, 0) NOT NULL ,
	[name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[created_by] [numeric](18, 0) NOT NULL ,
	[date_created] [datetime] NOT NULL ,
	[modified_by] [numeric](18, 0) NULL ,
	[date_modified] [datetime] NULL ,
	CONSTRAINT [PK_REQUEST_DOCUMENTS] PRIMARY KEY  CLUSTERED 
	(
		[request_document_id]
	)  ON [PRIMARY] ,
	CONSTRAINT [IX_REQUEST_DOCUMENTS] UNIQUE  NONCLUSTERED 
	(
		[request_id],
		[name]
	)  ON [PRIMARY] ,
	CONSTRAINT [FK_REQUEST_DOCUMENTS_CREATED_BY] FOREIGN KEY 
	(
		[created_by]
	) REFERENCES [USERS] (
		[USER_ID]
	),
	CONSTRAINT [FK_REQUEST_DOCUMENTS_MODIFIED_BY] FOREIGN KEY 
	(
		[modified_by]
	) REFERENCES [USERS] (
		[USER_ID]
	),
	CONSTRAINT [FK_REQUEST_DOCUMENTS_REQUESTS] FOREIGN KEY 
	(
		[request_id]
	) REFERENCES [REQUESTS] (
		[REQUEST_ID]
	)
) ON [PRIMARY]
GO


