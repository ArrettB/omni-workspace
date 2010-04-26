SELECT DISTINCT ISNULL(wdv.job_location_name,'--empty--') job_location_name, ISNULL(wdv.job_location_name,'--empty--') job_location_name
				FROM workorder_detail_v wdv
				WHERE wdv.request_type_code = 'workorder'
				AND wdv.request_status_type_code <> 'closed'
				AND wdv.organization_id = 2 
		   		ORDER BY wdv.job_location_name