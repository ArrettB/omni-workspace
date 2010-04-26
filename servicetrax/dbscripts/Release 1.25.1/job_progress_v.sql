DROP  VIEW job_progress_v
GO

CREATE VIEW job_progress_v
AS
SELECT organization_id, 
       project_id, 
       project_no, 
       customer_id, 
       customer_name, 
       end_user_id,
       end_user_name,
       ext_dealer_id,
       job_name, 
       install_foreman, 
       job_status_type_id, 
       job_status_type_code, 
       job_status_type_name, 
       min_start_date, 
       CONVERT(VARCHAR(12), min_start_date, 101) AS min_start_date_varchar, 
       cur_date, 
       max_end_date, 
       CONVERT(VARCHAR(12), max_end_date, 101) AS max_end_date_varchar, 
       duration, 
       cur_duration_left, 
       percent_complete, 
       (CASE duration WHEN 0 THEN 0 ELSE round((duration - cur_duration_left) / duration, 2) END) AS act_percent_complete, 
       (CASE CAST(punchlist_count AS varchar) WHEN '0' THEN 'N' ELSE 'Y' END) AS punchlist, 
       project_status_type_code
  FROM (SELECT organization_id, 
	       project_id, 
	       project_no, 
	       customer_id, 
	       customer_name,
	       end_user_id,
	       end_user_name,
	       ext_dealer_id,
	       job_name, 
	       install_foreman, 
	       job_status_type_id, 
	       job_status_type_code, 
	       job_status_type_name, 
	       min_start_date, 
	       max_end_date, 
	       CAST(DATEDIFF([HOUR], min_start_date, max_end_date + 1) AS numeric) AS duration, 
	       GETDATE() AS cur_date, 
	       CAST(DATEDIFF([HOUR], GETDATE(), max_end_date + 1) AS numeric) AS cur_duration_left, 
	       percent_complete, 
	       punchlist_count, 
	       project_status_type_code
	  FROM (SELECT p.project_id, 
		       p.project_no, 
		       p.job_name, 
		       p.percent_complete, 
		       CASE WHEN customer_type.code = 'end_user' THEN c.end_user_parent_id ELSE c.customer_id END customer_id, 
		       CASE WHEN customer_type.code = 'end_user' THEN (SELECT customer_name FROM customers WHERE customer_id = c.end_user_parent_id) ELSE c.customer_name END customer_name,
		       CASE WHEN customer_type.code = 'end_user' THEN c.customer_id ELSE eu.customer_id END end_user_id, 
		       CASE WHEN customer_type.code = 'end_user' THEN c.customer_name ELSE eu.customer_name END end_user_name, 
		       CASE WHEN customer_type.code = 'dealer' THEN ISNULL(c.ext_customer_id, c.ext_dealer_id) ELSE c.ext_dealer_id END ext_dealer_id, 
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
			 c.ext_dealer_id,
                         c.ext_customer_id,
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
		       ) v1
	       ) v2
GO