/*
   Thursday, February 12, 200910:22:13 AM
   User: ims
   Server: LEXUS\LEXUS32DEV
   Database: ims_new
   Application: 
*/

/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.QUOTES ADD CONSTRAINT
	PK_QUOTES PRIMARY KEY CLUSTERED 
	(
	quote_id
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
COMMIT
select Has_Perms_By_Name(N'dbo.QUOTES', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.QUOTES', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.QUOTES', 'Object', 'CONTROL') as Contr_Per 