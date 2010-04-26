SELECT bill_job_no, bill_job_id, bill_service_no, bill_service_id, service_description, invoice_id, bill_service_line_no, service_line_id, service_line_date,
			cust_col_1, cust_col_2, cust_col_3, cust_col_4, cust_col_5, cust_col_6, cust_col_7, cust_col_8, cust_col_9, cust_col_10,
			payroll_qty, bill_hourly_qty, bill_rate, bill_total, item_name, resource_name, item_type_code, '' statusCheckBox, posted_flag, billed_flag, posted_from_invoice_id,
			invoiced_date
	FROM billing_v
	WHERE billable_flag =  'Y'
	  AND ((status_id = 4 AND invoice_id IS NOT NULL) OR status_id = 5)
		 
		AND (posted_flag =  'Y' 
		      OR 
		     billed_flag =  'Y' )
	ORDER BY service_line_date desc, bill_service_no, bill_service_line_no