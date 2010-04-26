DROP VIEW quick_project_v
GO

CREATE VIEW quick_project_v
AS
SELECT p.project_id, 
       p.project_no, 
       p.job_name, 
       c.organization_id, 
       CASE WHEN customer_type.code = 'end_user' THEN c.end_user_parent_id ELSE c.customer_id END customer_id,
       CASE WHEN customer_type.code = 'end_user' THEN (SELECT customer_name FROM customers WHERE customer_id=c.end_user_parent_id) ELSE c.customer_name END customer_name,
       CASE WHEN customer_type.code = 'end_user' THEN c.customer_id ELSE eu.customer_id END end_user_id,
       CASE WHEN customer_type.code = 'end_user' THEN c.customer_name ELSE eu.customer_name END end_user_name,
       project_status.
       code AS project_status_code, 
       project_status.name AS project_status_name, 
       p.date_created, 
       p.created_by
  FROM dbo.projects p INNER JOIN
       dbo.lookups project_status ON p.project_status_type_id = project_status.lookup_id INNER JOIN
       dbo.customers c ON p.customer_id = c.customer_id INNER JOIN
       dbo.lookups customer_type ON c.customer_type_id = customer_type.lookup_id LEFT OUTER JOIN
       dbo.customers eu ON p.end_user_id = eu.customer_id
GO