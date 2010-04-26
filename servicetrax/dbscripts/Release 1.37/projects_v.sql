/* $Id: projects_v.sql 1655 2009-08-05 21:24:48Z bvonhaden $ */

ALTER VIEW [dbo].[projects_v]
AS
SELECT top 100 percent p.project_id, 
       p.project_no, 
       p.project_type_id, 
       project_type.code AS project_type_code, 
       project_type.name AS project_type_name, 
       p.project_status_type_id, 
       project_status_type.code AS project_status_type_code, 
       project_status_type.name AS project_status_type_name, 
       c.organization_id, 
       p.customer_id, 
       c.parent_customer_id, 
       c.ext_dealer_id, 
       c.dealer_name, 
       c.ext_customer_id, 
       c.customer_name, 
       p.job_name, 
       p.percent_complete, 
       p.date_created, 
       p.created_by, 
       p.date_modified, 
       p.modified_by, 
       u.first_name + ' ' + u.last_name AS created_by_name,
       p.end_user_id,
       eu.customer_name end_user_name,
       eu.ext_customer_id ext_end_user_id,
       p.is_new
  FROM dbo.projects p INNER JOIN
       dbo.lookups project_type ON p.project_type_id  = project_type.lookup_id INNER JOIN
       dbo.lookups project_status_type ON p.project_status_type_id = project_status_type.lookup_id INNER JOIN
       dbo.customers c ON p.customer_id = c.customer_id INNER JOIN
       dbo.users u ON p.created_by = u.user_id LEFT OUTER JOIN
       dbo.customers eu ON p.end_user_id = eu.customer_id 
ORDER BY p.project_id
