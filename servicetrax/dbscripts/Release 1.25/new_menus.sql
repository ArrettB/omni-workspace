INSERT INTO functions (function_group_id,
                       name,
                       code,
                       description,
                       sequence_no,
                       is_nav_function,
                       is_menu_function,
                       date_created,
                       created_by)
SELECT function_group_id,
       'Quote Request',
       'enet/req/quote_request',
       'Quote Request Detail',
       111,
       is_nav_function,
       is_menu_function,
       getdate(),
       created_by
  FROM functions 
 WHERE code='enet/req/qr_edit'
GO

INSERT INTO function_right_types (function_id,
                                  right_type_id,
                                  updatable_flag)
SELECT f2.function_id,
       right_type_id,
       updatable_flag 
  FROM function_right_types frt INNER JOIN 
       functions f ON frt.function_id=f.function_id,
       functions f2 
WHERE f.code='enet/req/qr_edit'
  AND f2.code='enet/req/quote_request'
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
 WHERE f.code='enet/req/qr_edit'
  AND f2.code='enet/req/quote_request'
GO

INSERT INTO templates (template_name) VALUES ('enet/req/quote_request.html')
GO

INSERT INTO template_locations (location,
                                level_1_tab,
                                level_1_template)
SELECT 'quote_request',
       tl.level_1_tab,
       t2.template_id
  FROM template_locations tl INNER JOIN
       templates t ON tl.level_1_template=t.template_id,
       templates t2
 WHERE t.template_name='enet/req/qr_edit.html'
   AND t2.template_name='enet/req/quote_request.html'
GO

UPDATE functions 
   SET template_id=(SELECT template_id FROM functions WHERE code='enet/req/qr_edit'), 
       template_location_id=(SELECT template_location_id FROM template_locations WHERE location='quote_request') 
 WHERE code='enet/req/quote_request'
GO

INSERT INTO functions (function_group_id,
                       name,
                       code,
                       description,
                       sequence_no,
                       is_nav_function,
                       is_menu_function,
                       date_created,
                       created_by)
SELECT function_group_id,
       'Service Request',
       'enet/req/service_request',
       'Service Request Detail',
       112,
       is_nav_function,
       is_menu_function,
       getdate(),
       created_by
  FROM functions 
 WHERE code='enet/req/sr_edit'
GO

INSERT INTO function_right_types (function_id,
                                  right_type_id,
                                  updatable_flag)
SELECT f2.function_id,right_type_id,updatable_flag 
  FROM function_right_types frt INNER JOIN 
       functions f ON frt.function_id=f.function_id,
       functions f2 
 WHERE f.code='enet/req/sr_edit'
   AND f2.code='enet/req/service_request'
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
 WHERE f.code='enet/req/sr_edit'
   AND f2.code='enet/req/service_request'
GO

INSERT INTO templates (template_name) values ('enet/req/service_request.html')
GO

INSERT INTO template_locations (location,
                                level_1_tab,
                                level_1_template)
SELECT 'service_request', 
       tl.level_1_tab, 
       t2.template_id
  FROM template_locations tl INNER JOIN 
       templates t ON tl.level_1_template=t.template_id,
       templates t2
 WHERE t.template_name='enet/req/sr_edit.html'
   AND t2.template_name='enet/req/service_request.html'
GO

UPDATE functions 
   SET template_id=(SELECT template_id FROM functions WHERE code='enet/req/sr_edit'), 
       template_location_id=(SELECT template_location_id FROM template_locations WHERE location='service_request')
 WHERE code='enet/req/service_request'
GO

