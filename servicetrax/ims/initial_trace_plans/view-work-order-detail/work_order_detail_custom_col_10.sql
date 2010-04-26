SELECT DISTINCT ISNULL(wdv.cust_col_10,'--empty--') custom_col, ISNULL(wdv.cust_col_10,'--empty--') custom_col, wdv.cust_col_10
					FROM workorder_detail_v wdv
					WHERE wdv.request_type_code = 'workorder'
					AND wdv.request_status_type_code <> 'closed'
					AND wdv.organization_id =  2
					ORDER BY wdv.cust_col_10