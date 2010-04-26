SELECT sum(custom_line_total) custom_tot, sum(bill_hourly_total) bill_hours_tot, sum(bill_exp_total) exp_tot, job_id, invoice_id_trk,
					sum(bill_total + custom_line_total) total_tot, invoice_id, invoice_description, job_type_name, invoice_status_id, ext_dealer_id, dealer_name, customer_name, po_no, billing_user_name
	FROM invoice_pre_total_v
	WHERE job_id =  70867
	AND invoice_status_id = 1
	GROUP BY invoice_id, invoice_id_trk, invoice_description, job_type_name, invoice_status_id, ext_dealer_id, dealer_name, customer_name, job_id, po_no, billing_user_name
	ORDER BY invoice_id