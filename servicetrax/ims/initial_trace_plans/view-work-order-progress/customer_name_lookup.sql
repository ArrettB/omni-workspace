SELECT DISTINCT wpv.customer_id, wpv.customer_name
				FROM workorder_progress_v wpv
				WHERE wpv.organization_id =  2
				  AND wpv.project_status_type_code != 'folder_closed'
				  AND wpv.request_status_type_code != 'closed'
				  AND wpv.request_type_code = 'workorder'
		  		ORDER BY wpv.customer_name