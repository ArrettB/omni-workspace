UPDATE requests SET is_sent='Y' 
  FROM requests r INNER JOIN
       lookups request_type ON r.request_type_id = request_type.lookup_id INNER JOIN 
       lookups request_status_type ON r.request_status_type_id = request_status_type.lookup_id INNER JOIN
       lookup_types lt2 ON request_status_type.lookup_type_id = lt2.lookup_type_id
 WHERE request_type.code IN ('quote_request','service_request')
   AND lt2.code IN ('serv_req_status_type','quote_req_status_type')
   AND request_status_type.code = 'sent'
   AND is_sent='N'