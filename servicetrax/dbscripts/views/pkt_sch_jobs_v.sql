
CREATE VIEW pkt_sch_jobs_v
AS
SELECT j.job_id, 
       j.job_no, 
       j.job_name, 
       c.customer_name AS customer, 
       ISNULL(CASE WHEN customer_type.code='dealer' THEN eu.customer_name ELSE c.customer_name END, '') end_user_name,
       c.dealer_name AS dealer, 
       pjur_v.user_id
  FROM dbo.jobs j INNER JOIN
       dbo.customers c ON j.customer_id = c.customer_id INNER JOIN
       dbo.lookups job_status_type ON j.job_status_type_id = job_status_type.lookup_id INNER JOIN
       dbo.pkt_job_user_res_v pjur_v ON j.job_id = pjur_v.job_id INNER JOIN
       dbo.lookups customer_type ON c.customer_type_id = customer_type.lookup_id LEFT OUTER JOIN
       dbo.projects p ON j.project_id = p.project_id LEFT OUTER JOIN
       dbo.customers eu ON p.end_user_id = eu.customer_id
 WHERE job_status_type.code <> 'install_complete' 
   AND job_status_type.code <> 'invoiced' 
   AND job_status_type.code <> 'closed'

