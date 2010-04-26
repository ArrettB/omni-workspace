
ALTER VIEW quick_quote_requests_v2  
AS  
SELECT CONVERT(VARCHAR, p.project_no) + '-' + CONVERT(VARCHAR, r.request_no) + '.' + CONVERT(VARCHAR, r.version_no) AS project_request_version_no,   
       r.request_id,   
       r.request_no,   
       p.project_id,   
       p.project_no,   
       cust.organization_id,   
       p.job_name,  
       r.dealer_po_no,          
       r.date_created AS record_created,   
       r.date_modified AS record_last_modified,          
       CASE WHEN customer_type.code = 'dealer' THEN ISNULL(cust.ext_customer_id, cust.ext_dealer_id) ELSE cust.ext_dealer_id END ext_dealer_id,    
       CASE WHEN customer_type.code = 'end_user' THEN cust.end_user_parent_id ELSE cust.customer_id END customer_id,  
       CASE WHEN customer_type.code = 'end_user' THEN (SELECT customer_name FROM customers WHERE customer_id=cust.end_user_parent_id) ELSE cust.customer_name END customer_name,  
       CASE WHEN customer_type.code = 'end_user' THEN cust.customer_id ELSE eu.customer_id END end_user_id,  
       CASE WHEN customer_type.code = 'end_user' THEN cust.customer_name ELSE eu.customer_name END end_user_name,  
       request_status.code AS record_status_code,   
       request_status.name AS record_status_name,   
       request_type.code AS record_type_code,   
       request_type.name AS record_type_name,   
       request_type.sequence_no AS record_type_seq_no,   
       c.contact_name AS a_m_contact_name,   
       CASE WHEN EXISTS (SELECT request_id  
                           FROM quotes  
                          WHERE request_id = r.request_id AND is_sent = 'Y') THEN 'Y' ELSE 'N' END AS is_quoted,
       CASE WHEN EXISTS (SELECT request_id  
                           FROM requests  
                          WHERE quote_request_id = r.request_id) THEN 'Y' ELSE 'N' END AS has_service_request,  
       CASE WHEN p.end_user_id IS NULL THEN 'N' ELSE 'Y' END is_new  
  FROM dbo.requests r INNER JOIN  
       dbo.lookups request_status ON r.request_status_type_id = request_status.lookup_id INNER JOIN  
       dbo.lookups request_type ON r.request_type_id = request_type.lookup_id INNER JOIN  
       dbo.projects p ON r.project_id = p.project_id INNER JOIN  
       dbo.customers cust ON p.customer_id = cust.customer_id INNER JOIN  
       dbo.lookups customer_type ON cust.customer_type_id = customer_type.lookup_id LEFT OUTER JOIN  
       dbo.customers eu ON p.end_user_id = eu.customer_id LEFT OUTER JOIN  
       dbo.contacts c ON r.a_m_contact_id = c.contact_id  
 WHERE request_type.code='quote_request'   
   AND request_status.code <> 'closed'  