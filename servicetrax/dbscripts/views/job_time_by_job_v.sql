
CREATE VIEW job_time_by_job_v
AS
SELECT j.job_name,
       CAST(j.job_no AS VARCHAR) AS job_no_varchar, 
       j.foreman_resource_id,
       foreman_r.name foreman_resource_name,
       billing_user.first_name + ' ' + billing_user.last_name AS billing_user_name,
       CASE WHEN customer_type.code = 'end_user' THEN c.end_user_parent_id ELSE c.customer_id END customer_id, 
       CASE WHEN customer_type.code = 'end_user' THEN (SELECT customer_name FROM customers WHERE customer_id = c.end_user_parent_id) ELSE c.customer_name END customer_name, 
       CASE WHEN customer_type.code = 'end_user' THEN c.customer_id ELSE eu.customer_id END end_user_id, 
       CASE WHEN customer_type.code = 'end_user' THEN c.customer_name ELSE eu.customer_name END end_user_name, 
       sl.organization_id, 
       sl.tc_job_no,       
       sl.tc_service_no,    
       sl.tc_service_line_no, 
       sl.item_name, 
       sl.tc_job_id, 
       sl.tc_service_id, 
       sl.ph_service_id, 
       sl.service_line_id, 
       sl.service_line_date, 
       sl.status_id, 
       sls.name status_name, 
       sl.resource_id,  
       sl.item_id, 
       sl.tc_qty, 
       sl.tc_rate, 
       sl.tc_total,
       sl.payroll_qty,
       sl.ext_pay_code, 
       ISNULL(sl.payroll_qty, 0) - ISNULL(sl.bill_hourly_qty, 0) AS hours_difference, 
       r.name resource_name, 
       rt.name resource_type_name,
       r.user_id,
       r.resource_type_id,
       resource_user.ext_employee_id      
  FROM dbo.service_lines sl LEFT OUTER JOIN
       dbo.service_line_statuses sls ON sl.status_id=sls.status_id LEFT OUTER JOIN
       dbo.jobs j ON sl.tc_job_id = j.job_id LEFT OUTER JOIN
       dbo.customers c ON j.customer_id=c.customer_id LEFT OUTER JOIN
       dbo.lookups customer_type ON c.customer_type_id=customer_type.lookup_id LEFT OUTER JOIN
       dbo.customers eu ON j.end_user_id = eu.customer_id LEFT OUTER JOIN
       dbo.users billing_user ON  j.billing_user_id = billing_user.user_id LEFT OUTER JOIN
       dbo.resources foreman_r ON j.foreman_resource_id = foreman_r.resource_id LEFT OUTER JOIN
       dbo.resources r ON sl.resource_id = r.resource_id LEFT OUTER JOIN
       dbo.resource_types rt ON r.resource_type_id = rt.resource_type_id LEFT OUTER JOIN
       dbo.users resource_user ON r.user_id = resource_user.user_id
       

