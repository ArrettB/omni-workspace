CREATE VIEW dbo.SYS_FOREIGN_KEYS_V
AS
SELECT     [key].name AS foreign_key_name, [table].table_name AS foreign_table_name, foreign_col.name AS foreign_column_name, 
                      related_table.name AS related_table_name, related_col.name AS related_column_name, 
                      'Create Index ' + [key].name + '_idx On ' + [table].table_name + ' (' + foreign_col.name + ');' AS create_index_sql, 
                      'Alter Table ' + [table].table_name + ' NOCHECK CONSTRAINT ' + [key].name + ';
                      ' AS disable_fk_sql, 
                      'Alter Table ' + [table].table_name + ' CHECK CONSTRAINT ' + [key].name + ';' AS enable_fk_sql
FROM         dbo.sysobjects [key] INNER JOIN
                      dbo.SYS_TABLES_V [table] ON [key].parent_obj = [table].table_id INNER JOIN
                      dbo.sysforeignkeys ON [key].id = dbo.sysforeignkeys.constid INNER JOIN
                      dbo.sysobjects related_table ON dbo.sysforeignkeys.rkeyid = related_table.id INNER JOIN
                      dbo.syscolumns related_col ON related_table.id = related_col.id AND dbo.sysforeignkeys.rkey = related_col.colid INNER JOIN
                      dbo.syscolumns foreign_col ON dbo.sysforeignkeys.fkeyid = foreign_col.id AND dbo.sysforeignkeys.fkey = foreign_col.colid


