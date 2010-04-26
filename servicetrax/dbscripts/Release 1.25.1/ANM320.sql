ALTER TABLE services ADD customer_contact2_id NUMERIC(18,0)
GO

ALTER TABLE services ADD customer_contact3_id NUMERIC(18,0)
GO

ALTER TABLE services ADD customer_contact4_id NUMERIC(18,0)
GO

ALTER TABLE services ADD job_location_contact_id NUMERIC(18,0)
GO

ALTER TABLE services ADD CONSTRAINT fk_service_customer_contact2 FOREIGN KEY (customer_contact2_id) REFERENCES contacts (contact_id)
GO

ALTER TABLE services ADD CONSTRAINT fk_service_customer_contact3 FOREIGN KEY (customer_contact3_id) REFERENCES contacts (contact_id)
GO

ALTER TABLE services ADD CONSTRAINT fk_service_customer_contact4 FOREIGN KEY (customer_contact4_id) REFERENCES contacts (contact_id)
GO

ALTER TABLE services ADD CONSTRAINT fk_service_job_loc_contact FOREIGN KEY (job_location_contact_id) REFERENCES contacts (contact_id)
GO

UPDATE services SET customer_contact2_id = r.customer_contact2_id,
                    customer_contact3_id = r.customer_contact3_id,
                    customer_contact4_id = r.customer_contact4_id,
                    job_location_contact_id = r.job_location_contact_id,
                    modified_by = 0,
                    date_modified = getdate()
  FROM requests r 
 WHERE r.request_id = services.request_id 
   AND (r.job_location_contact_id IS NOT NULL)
GO






DROP VIEW jobs_v
GO

CREATE VIEW jobs_v
AS
SELECT j.job_id, 
       j.project_id, 
       j.job_no, 
       j.job_name, 
       CAST(j.job_no AS varchar) + ' - ' + ISNULL(c.customer_name, '') + ' - ' + ISNULL(j.job_name, '') AS job_no_name, 
       j.job_type_id, 
       job_type.code AS job_type_code, 
       job_type.name AS job_type_name, 
       j.job_status_type_id, 
       job_status_type.code AS job_status_type_code, 
       job_status_type.name AS job_status_type_name, 
       job_status_type.sequence_no AS job_status_seq_no, 
       c.organization_id, 
       CASE WHEN customer_type.code = 'dealer' THEN c.customer_name ELSE c.dealer_name END dealer_name,
       CASE WHEN customer_type.code = 'dealer' THEN c.ext_customer_id ELSE c.ext_dealer_id END ext_dealer_id, 
       c.ext_customer_id, 
       j.ext_price_level_id, 
       j.foreman_resource_id, 
       r.name AS foreman_resource_name, 
       r.user_id AS foreman_user_id, 
       foreman_user.first_name + ' ' + foreman_user.last_name AS foreman_user_name, 
       j.billing_user_id, 
       j.a_m_sales_contact_id,
       j.watch_flag, 
       u_billing.first_name + ' ' + u_billing.last_name AS billing_user_name, 
       j.created_by, 
       created_by.first_name + ' ' + created_by.last_name AS created_by_name, 
       j.date_created, 
       j.modified_by, 
       modified_by.first_name + ' ' + modified_by.last_name AS modified_by_name, 
       j.date_modified,
       CASE WHEN customer_type.code = 'end_user' THEN c.end_user_parent_id ELSE c.customer_id END customer_id,
       CASE WHEN customer_type.code = 'end_user' THEN (SELECT customer_name FROM customers WHERE customer_id = c.end_user_parent_id) ELSE c.customer_name END customer_name,
       CASE WHEN customer_type.code = 'end_user' THEN c.customer_id ELSE eu.customer_id END end_user_id,
       CASE WHEN customer_type.code = 'end_user' THEN c.customer_name ELSE eu.customer_name END end_user_name,
       CASE WHEN p.end_user_id IS NULL THEN 'N' ELSE 'Y' END is_new
  FROM dbo.jobs j INNER JOIN
       dbo.customers c ON j.customer_id = c.customer_id INNER JOIN
       dbo.lookups customer_type ON c.customer_type_id = customer_type.lookup_id INNER JOIN
       dbo.lookups job_type ON j.job_type_id = job_type.lookup_id INNER JOIN 
       dbo.lookups job_status_type ON j.job_status_type_id = job_status_type.lookup_id INNER JOIN
       dbo.users created_by ON j.created_by = created_by.user_id LEFT OUTER JOIN
       dbo.users u_billing ON j.billing_user_id = u_billing.user_id LEFT OUTER JOIN
       dbo.users modified_by ON j.modified_by = modified_by.user_id LEFT OUTER JOIN
       dbo.resources r ON j.foreman_resource_id = r.resource_id LEFT OUTER JOIN
       dbo.users foreman_user ON r.user_id = foreman_user.user_id LEFT OUTER JOIN
       dbo.projects p ON j.project_id = p.project_id LEFT OUTER JOIN
       dbo.customers eu ON p.end_user_id = eu.customer_id
GO