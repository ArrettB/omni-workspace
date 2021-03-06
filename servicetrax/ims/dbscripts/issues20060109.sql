
drop VIEW dbo.QUOTE_REQUESTS_V
go

drop VIEW dbo.SERVICE_REQUESTS_V  
go

CREATE VIEW dbo.CONVERTED_REQUESTS_V  
AS  
SELECT project_id, request_no, is_converted = CASE ISNULL(service_id, '-1')
WHEN -1 THEN 'N'
ELSE 'Y' END
, record_seq_no
FROM   dbo.REQUESTS_V
WHERE request_type_code = 'service_request'
go


CREATE VIEW dbo.QUOTE_REQUESTS_V  
AS  
SELECT r.project_id, r.project_no, r.job_name, r.request_id, r.project_request_no
, r.dealer_name, r.ext_dealer_id, r.dealer_project_no
, r.customer_name, r.customer_id, r.parent_customer_id
, r.organization_id, r.a_m_contact_name, r.is_quoted
, r.request_type_code, r.request_status_type_code, r.request_status_type_name
, ISNULL(cr.is_converted, 'N') is_converted, r.record_seq_no
, r.date_created
FROM requests_v r LEFT OUTER JOIN dbo.CONVERTED_REQUESTS_V cr
 ON r.project_id = cr.project_id
 AND r.request_no = cr.request_no
WHERE r.request_type_code = 'quote_request'
go
