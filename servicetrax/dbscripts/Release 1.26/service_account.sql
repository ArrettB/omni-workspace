INSERT INTO templates (template_name) values ('enet/proj/service_account.html')
GO

INSERT INTO template_locations (location,
                                level_1_tab,
                                level_1_template)
SELECT 'service_account', 
       tl.level_1_tab, 
       t2.template_id
  FROM template_locations tl INNER JOIN 
       templates t ON tl.level_1_template=t.template_id,
       templates t2
 WHERE t.template_name='enet/proj/pf_edit.html'
   AND t2.template_name='enet/proj/service_account.html'
GO

INSERT INTO functions (function_group_id,
                       template_id,
                       name,
                       code,
                       description,
                       template_location_id,
                       sequence_no,
                       is_nav_function,
                       is_menu_function,
                       date_created,
                       created_by)
SELECT f.function_group_id,
       f.template_id,
       'Create Service Account',
       'enet/proj/service_account',
       'Service Account Detail',
       tl.template_location_id,
       145,
       f.is_nav_function,
       f.is_menu_function,
       getdate(),
       f.created_by
  FROM functions f,
       template_locations tl
 WHERE f.code='enet/proj/pf_edit'
   AND tl.location='service_account'
GO

INSERT INTO function_right_types (function_id,
                                  right_type_id,
                                  updatable_flag)
SELECT f2.function_id,right_type_id,updatable_flag 
  FROM function_right_types frt INNER JOIN 
       functions f ON frt.function_id=f.function_id,
       functions f2 
 WHERE f.code='enet/proj/pf_edit'
   AND f2.code='enet/proj/service_account'
GO
 
INSERT INTO role_function_rights (role_id,
                                  function_id,
                                  right_type_id,
                                  date_created,
                                  created_by)
SELECT rfr.role_id, 
       f2.function_id, 
       rfr.right_type_id, 
       getdate(), 
       rfr.created_by 
  FROM role_function_rights rfr INNER JOIN 
       functions f ON rfr.function_id=f.function_id,
       functions f2 
 WHERE f.code='enet/proj/pf_edit'
   AND f2.code='enet/proj/service_account'
GO
