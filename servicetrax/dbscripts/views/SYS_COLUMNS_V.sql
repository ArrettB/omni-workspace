
CREATE VIEW dbo.SYS_COLUMNS_V
AS
SELECT     TOP 100 PERCENT dbo.SYS_TABLES_V.table_name, dbo.syscolumns.name AS column_name, dbo.systypes.name AS column_type, 
                      dbo.syscolumns.length, dbo.SYS_TABLES_V.table_id, dbo.syscolumns.id AS column_id
FROM         dbo.SYS_TABLES_V INNER JOIN
                      dbo.syscolumns ON dbo.SYS_TABLES_V.table_id = dbo.syscolumns.id INNER JOIN
                      dbo.systypes ON dbo.syscolumns.xtype = dbo.systypes.xtype
ORDER BY dbo.SYS_TABLES_V.table_name, dbo.syscolumns.colid


