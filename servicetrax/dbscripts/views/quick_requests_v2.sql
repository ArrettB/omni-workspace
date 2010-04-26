/* $Id: quick_requests_v2.sql 1655 2009-08-05 21:24:48Z bvonhaden $ */

ALTER VIEW [dbo].[quick_requests_v2]
AS
SELECT CONVERT(VARCHAR, p.project_no) + '-' + CONVERT(VARCHAR, r.request_no) + '.' + CONVERT(VARCHAR, r.version_no) AS project_request_version_no, 
       r.request_id, 
       r.request_no,
       p.project_id, 
       p.project_no, 
       c.organization_id,
       p.job_name,        
       r.dealer_po_no, 
       r.est_start_date, 
       r.description, 
       CASE WHEN customer_type.code = 'dealer' THEN ISNULL(c.ext_customer_id, c.ext_dealer_id) ELSE c.ext_dealer_id END ext_dealer_id, 
       CASE WHEN customer_type.code = 'end_user' THEN c.end_user_parent_id ELSE p.customer_id END customer_id,
       CASE WHEN customer_type.code = 'end_user' THEN (SELECT customer_name FROM customers WHERE customer_id=c.end_user_parent_id) ELSE c.customer_name END customer_name,
       CASE WHEN customer_type.code = 'end_user' THEN c.customer_id ELSE eu.customer_id END end_user_id,
       CASE WHEN customer_type.code = 'end_user' THEN c.customer_name ELSE eu.customer_name END end_user_name, 
       request_status.code AS record_status_code, 
       request_status.name AS record_status_name, 
       request_type.code AS record_type_code, 
       request_type.name AS record_type_name, 
       project_status.code AS project_status_code, 
       project_status.name AS project_status_name,
       r.is_quoted, 
       p.is_new
  FROM dbo.requests r INNER JOIN
       dbo.lookups request_status ON r.request_status_type_id = request_status.lookup_id INNER JOIN
       dbo.lookups request_type ON r.request_type_id = request_type.lookup_id INNER JOIN
       dbo.projects p ON r.project_id = p.project_id INNER JOIN
       dbo.customers c ON p.customer_id = c.customer_id INNER JOIN
       dbo.lookups project_status ON p.project_status_type_id = project_status.lookup_id INNER JOIN
       dbo.lookups customer_type ON c.customer_type_id = customer_type.lookup_id LEFT OUTER JOIN
       dbo.customers eu ON p.end_user_id = eu.customer_id 
 WHERE request_type.code = 'service_request'
   AND request_status.code <> 'closed'
