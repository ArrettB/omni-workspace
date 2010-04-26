
CREATE VIEW dbo.CONVERTED_REQUESTS_V  
AS  
SELECT project_id, request_no, is_converted = CASE ISNULL(service_id, '-1')
WHEN -1 THEN 'N'
ELSE 'Y' END
, record_seq_no
FROM   dbo.REQUESTS_V
WHERE request_type_code = 'service_request'

