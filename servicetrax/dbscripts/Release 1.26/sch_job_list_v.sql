DROP VIEW sch_job_list_v
GO

CREATE VIEW sch_job_list_v 
AS
SELECT CAST(j.job_id AS varchar(30)) + ':' + ISNULL(CAST(s.service_id AS varchar(30)), '') AS job_service_id,
       j.job_id,
       j.job_no,
       j.job_name,
       s.service_id,
       s.service_no, 
       s.request_id,
       c.organization_id,     
       c.ext_dealer_id,
       c.dealer_name,
       j.customer_id,
       c.customer_name,
       j.job_type_id,
       job_type.code job_type_code,
       substring(job_type.name,1,1) job_type_name, 
       j.job_status_type_id,
       job_status_type.code job_status_type_code,
       substring(job_status_type.name,1,8) job_status_type_name,
       s.serv_status_type_id,
       serv_status_type.code serv_status_type_code, 
       serv_status_type.name serv_status_type_name,
       s.schedule_type_id,
       schedule_type.code schedule_type_code,
       schedule_type.name schedule_type_name, 
       s.service_type_id,
       service_type.code service_type_code,
       service_type.name service_type_name,
       s.est_start_date,
       s.est_start_time,
       s.est_end_date,
       s.watch_flag,
       CASE s.weekend_flag WHEN 'Y' THEN 'Yes' WHEN 'N' THEN 'No' ELSE 'N/A' END AS weekend_flag_name,
       s.po_no,
       res.user_id foreman_user_id,
       foreman.first_name + ' ' + foreman.last_name AS foreman_user_name,
       eu.customer_name end_user_name,
       jl.job_location_name,
       (SELECT TOP 1 contact_name + ' - ' + dbo.sp_contact_phone(contact_id) FROM contacts WHERE contact_id=r.customer_contact_id) customer_contact,
       (SELECT TOP 1 contact_name + ' - ' + dbo.sp_contact_phone(contact_id) FROM contacts WHERE contact_id =r.job_location_contact_id) job_location_contact,
       ISNULL(r.schedule_with_client_flag,'N') schedule_with,
       q.[roc_omni_discounted_hours-total] est_hours
  FROM jobs j INNER JOIN
       lookups job_type ON j.job_type_id = job_type.lookup_id INNER JOIN
       lookups job_status_type ON j.job_status_type_id = job_status_type.lookup_id INNER JOIN
       customers c ON j.customer_id = c.customer_id LEFT OUTER JOIN
       users billing_user ON j.billing_user_id = billing_user.user_ID LEFT OUTER JOIN
       resources res ON j.foreman_resource_id = res.resource_id LEFT OUTER JOIN
       users foreman ON res.user_id = foreman.user_id LEFT OUTER JOIN
       services s ON j.job_id = s.job_id LEFT OUTER JOIN
       lookups serv_status_type ON s.serv_status_type_id = serv_status_type.lookup_id LEFT OUTER JOIN
       lookups schedule_type ON s.schedule_type_id = schedule_type.lookup_id LEFT OUTER JOIN
       lookups service_type ON s.service_type_id = service_type.lookup_id LEFT OUTER JOIN
       job_locations jl ON s.job_location_id = jl.job_location_id LEFT OUTER JOIN
       requests r ON s.request_id=r.request_id LEFT OUTER JOIN 
       projects p ON j.project_id = p.project_id LEFT OUTER JOIN
       customers eu ON p.end_user_id = eu.customer_id LEFT OUTER JOIN
       quotes q ON s.quote_id = q.quote_id
GO