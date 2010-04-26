/*
   Add new function to restrict access to View New Reports.
   $Id: view_new_reports.sql 1437 2008-11-10 18:39:43Z bvonhaden $
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
       'New Reports',
       'rep/other_reports_new',
       'Link to the view new reports',
       null,
       'N',
       'N',
       getdate(),
       1
  FROM function_groups fg
 WHERE fg.code='rep'
GO
