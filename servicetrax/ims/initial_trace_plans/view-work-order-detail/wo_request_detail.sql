SELECT wdv.project_id, wdv.request_id, wdv.project_no, wdv.request_no, wdv.workorder_no, wdv.ext_dealer_id, wdv.dealer_name,
				wdv.customer_id, wdv.customer_name, wdv.job_location_name, wdv.floor_number,
				wdv.cust_col_1, wdv.cust_col_2, wdv.cust_col_3, wdv.cust_col_4, wdv.cust_col_5,
				wdv.cust_col_6, wdv.cust_col_7, wdv.cust_col_8, wdv.cust_col_9, wdv.cust_col_10,
				wdv.customer_contact_name, wdv.description
				FROM workorder_detail_v wdv
				WHERE wdv.request_type_code = 'workorder'
				AND wdv.request_status_type_code <> 'closed'
				AND wdv.organization_id =  2
			    ORDER BY wdv.project_no DESC, wdv.request_no DESC, wdv.request_seq_no