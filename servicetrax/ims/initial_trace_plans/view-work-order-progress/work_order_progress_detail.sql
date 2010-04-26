SELECT wpv.project_id,
		              wpv.request_id,
		              wpv.project_no,
		              wpv.workorder_no,
		              wpv.dealer_name,
		              wpv.customer_name,
		              wpv.request_status_type_name,
					  wpv.min_start_date,
					  wpv.max_end_date,
					  wpv.punchlist_flag,
					  ROUND((wpv.duration - wpv.cur_duration_left) / wpv.duration, 2) percent_complete
				 FROM workorder_progress_v wpv
				WHERE wpv.organization_id =  2
				  AND wpv.project_status_type_code != 'folder_closed'
				  AND wpv.request_status_type_code != 'closed'
				  AND wpv.request_type_code = 'workorder'
				ORDER BY wpv.project_no DESC