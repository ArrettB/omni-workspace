CREATE VIEW job_progress_1_v
AS
SELECT p.project_id, 
       p.project_no, 
       p.job_name, 
       p.percent_complete, 
       CASE WHEN customer_type.code = 'end_user' THEN c.end_user_parent_id ELSE c.customer_id END customer_id, 
       CASE WHEN customer_type.code = 'end_user' THEN (SELECT customer_name FROM customers WHERE customer_id = c.end_user_parent_id) ELSE c.customer_name END customer_name,
       CASE WHEN customer_type.code = 'end_user' THEN c.customer_id ELSE eu.customer_id END end_user_id, 
       CASE WHEN customer_type.code = 'end_user' THEN c.customer_name ELSE eu.customer_name END end_user_name, 
       c.organization_id, 
       project_status_type.code project_status_type_code,  
       j.job_status_type_id,   
       job_status_type.code AS job_status_type_code, 
       job_status_type.name AS job_status_type_name, 
       MIN(s.est_start_date) AS min_start_date, 
       MAX(s.est_end_date) AS max_end_date, 
       COUNT(pu.punchlist_id) as punchlist_count, 
       resource_user.first_name + ' ' + resource_user.last_name AS install_foreman    
  FROM dbo.projects p INNER JOIN
       dbo.lookups project_status_type ON p.project_status_type_id = project_status_type.lookup_id INNER JOIN
       dbo.customers c ON p.customer_id = c.customer_id INNER JOIN
       dbo.lookups customer_type ON c.customer_type_id = customer_type.lookup_id LEFT OUTER JOIN
       dbo.customers eu ON p.end_user_id = eu.customer_id LEFT OUTER JOIN
       dbo.jobs j ON p.project_id = j.project_id LEFT OUTER JOIN
       dbo.lookups job_status_type ON j.job_status_type_id = job_status_type.lookup_id LEFT OUTER JOIN
       dbo.services s ON j.job_id = s.job_id LEFT OUTER JOIN
       dbo.punchlists pu ON p.project_id = pu.project_id LEFT OUTER JOIN
       dbo.resources r ON j.foreman_resource_id = r.resource_id LEFT OUTER JOIN
       dbo.users resource_user on r.user_id = resource_user.user_id
GROUP BY p.project_id, 
         j.job_status_type_id, 
         p.project_no, 
         c.customer_id, 
         c.customer_name, 
         p.job_name, 
         job_status_type.code, 
         job_status_type.name, 
         p.percent_complete, 
         c.organization_id, 
         resource_user.first_name + ' ' + resource_user.last_name,
         project_status_type.code,
         customer_type.code,
         c.end_user_parent_id,
         eu.customer_id,
         eu.customer_name