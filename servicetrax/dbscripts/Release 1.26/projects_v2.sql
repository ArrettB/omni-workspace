DROP VIEW projects_v2
GO

CREATE VIEW projects_v2
AS
SELECT TOP 100 PERCENT 
        p.project_id, 
        p.project_no, 
        p.project_type_id, 
        project_types.code AS project_type_code, 
        project_types.name AS project_type_name, 
        p.project_status_type_id, 
        project_status_type.code AS project_status_type_code, 
        project_status_type.name AS project_status_type_name, 
        p.job_name, 
        p.percent_complete, 
        p.date_created, 
        p.created_by, 
        p.date_modified, 
        p.modified_by, 
        u.first_name + ' ' + u.last_name AS created_by_name,
        c.organization_id,  
        c.parent_customer_id, 
        CASE WHEN customer_type.code = 'dealer' THEN ISNULL(c.ext_customer_id, c.ext_dealer_id) ELSE c.ext_dealer_id END ext_dealer_id, 
        c.dealer_name, 
        c.ext_customer_id, 
        eu.ext_customer_id ext_end_user_id,
        CASE WHEN customer_type.code = 'end_user' THEN c.end_user_parent_id ELSE p.customer_id END customer_id,
        CASE WHEN customer_type.code = 'end_user' THEN (SELECT customer_name FROM customers WHERE customer_id = c.end_user_parent_id) ELSE c.customer_name END customer_name,
        CASE WHEN customer_type.code = 'end_user' THEN c.customer_id ELSE p.end_user_id END end_user_id,
        CASE WHEN customer_type.code = 'end_user' THEN c.customer_name ELSE eu.customer_name END end_user_name,
        CASE WHEN p.end_user_id IS NULL THEN 'N' ELSE 'Y' END is_new,
        c.refusal_email_info, 
        c.survey_location
   FROM dbo.projects p INNER JOIN
        dbo.lookups project_types ON p.project_type_id = project_types.lookup_id INNER JOIN 
        dbo.lookups project_status_type ON p.project_status_type_id = project_status_type.lookup_id INNER JOIN 
        dbo.users u ON p.created_by = u.user_id INNER JOIN
        dbo.customers c ON p.customer_id = c.customer_id INNER JOIN
        dbo.lookups customer_type ON c.customer_type_id = customer_type.lookup_id LEFT OUTER JOIN
        dbo.customers eu ON p.end_user_id = eu.customer_id 
ORDER BY p.project_id
GO


top 100 percent p.project_id, 
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
       CASE WHEN p.end_user_id IS NULL THEN 'N' ELSE 'Y' END is_new