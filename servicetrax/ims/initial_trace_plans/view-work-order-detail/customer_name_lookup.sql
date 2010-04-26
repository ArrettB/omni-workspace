SELECT DISTINCT wdv.customer_name, wdv.customer_name
				FROM workorder_detail_v wdv
				WHERE wdv.request_type_code = 'workorder'
				AND wdv.request_status_type_code <> 'closed'
				AND wdv.organization_id =  2 
		  		ORDER BY wdv.customer_name