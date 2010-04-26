/*
   Add new function to restrict access to .
   $Id: organization_selection.sql 1432 2008-11-07 20:10:56Z bvonhaden $
*/


INSERT INTO functions (function_group_id,
                       template_id,
                       name,
                       code,
                       description,
                       sequence_no,
                       is_nav_function,
                       is_menu_function,
                       date_created,
                       created_by)
SELECT fg.function_group_id,
       null,
       'Assign all Locations',
       'mnt/assign_all_locations',
       'Allow the user to assign all the locations',
       null,
       'N',
       'N',
       getdate(),
       1
  FROM function_groups fg
 WHERE fg.code='MAINT'
GO
