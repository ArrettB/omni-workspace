SELECT sum(iv.custom_line_total) custom_tot,
		              sum(iv.bill_hourly_total) hours_total,
		              sum(iv.bill_exp_total) exp_tot,
		              sum(iv.bill_total + iv.custom_line_total) total_tot,
		              iv.assigned_to_name, iv.job_no, iv.job_id, ibs.name batch_status_name,
					  iv.invoice_id_trk, iv.invoice_id, iv.invoice_description, iv.invoice_type_name, iv.invoice_status_id, iv.date_sent,
					  iv.customer_name, iv.end_user_name, iv.job_type_name, iv.po_no, iv.invoice_date_created
		         FROM invoice_pre_total_v iv,
		              invoice_batch_statuses ibs
		        WHERE iv.batch_status_id = ibs.status_id
		          AND iv.organization_id =  2 
		          AND iv.invoice_status_id =  2
		     GROUP BY iv.invoice_id, iv.invoice_id_trk, iv.invoice_description, iv.invoice_type_name, iv.invoice_status_id, iv.date_sent,
		              iv.customer_name, iv.end_user_name, iv.assigned_to_name, iv.job_type_name, iv.job_no, iv.job_id, iv.po_no,
		              iv.invoice_date_created, ibs.name
		     ORDER BY iv.invoice_id