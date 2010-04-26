/*
   ANM-71 role to control editting the job type.
   $Id: anm-71.sql 1476 2009-01-09 17:27:43Z bvonhaden $
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
       'Edit Job Type',
       'job/job_type',
       'Allow the user to edit the job type',
       null,
       'N',
       'N',
       getdate(),
       1
  FROM function_groups fg
 WHERE fg.code='job'
GO

 