CREATE VIEW dbo.SYSCOLUMNS_V
AS
SELECT     TOP 100 PERCENT dbo.sysobjects.name AS table_name, dbo.sysobjects.id AS table_id, dbo.syscolumns.name AS column_name, 
                      dbo.sysobjects.xtype
FROM         dbo.sysobjects LEFT OUTER JOIN
                      dbo.syscolumns ON dbo.sysobjects.id = dbo.syscolumns.id
WHERE     (dbo.sysobjects.xtype = 'U') OR
                      (dbo.sysobjects.xtype = 'V')
ORDER BY table_name, column_name

