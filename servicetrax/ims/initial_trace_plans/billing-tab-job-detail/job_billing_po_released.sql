SELECT po.po_id,
	              CONVERT(VARCHAR, j.job_no) + '-' + CONVERT(VARCHAR, r.request_no) + '-' + CONVERT(VARCHAR, po.po_no) project_request_po_no,
                  po.vendor_name,
                  j.job_name,
                  i.name item_name,
                  po.po_total,
                  po.date_created,
                  po_status_type.name status,
                  billing_type.name billing_type,
                  re.name resource_name,
                  '' foo,
                  '' selected
             FROM jobs j INNER JOIN
                  requests r ON j.project_id = r.project_id INNER JOIN
                  purchase_orders po ON r.request_id = po.request_id INNER JOIN
                  lookups po_status_type ON po.po_status_id = po_status_type.lookup_id INNER JOIN
                  lookups billing_type ON po.billing_type_id = billing_type.lookup_id INNER JOIN
                  items i ON po.item_id=i.item_id LEFT OUTER JOIN
                  resources re ON po.ext_vendor_id = re.ext_vendor_id
            WHERE po_status_type.code = 'released'
              AND j.job_id =  70867 
		 ORDER BY po.po_id