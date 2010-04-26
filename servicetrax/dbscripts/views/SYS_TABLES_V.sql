

CREATE VIEW dbo.SYS_TABLES_V
AS
SELECT     id AS table_id, name AS table_name
FROM         dbo.sysobjects [Table]
WHERE     (xtype = 'U')



