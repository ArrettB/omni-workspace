SELECT sum(custom_line_total) custom_tot,
	              sum(bill_hourly_total) bill_hourly_total,
	              sum(bill_exp_total) bill_exp_total,
	              sum(bill_total + custom_line_total) total_total,
	              job_id,
	              invoice_id_trk,
				  invoice_id,
				  invoice_description,
				  invoice_type_name,
				  invoice_status_id,
				  customer_name,
				  end_user_name,
				  billing_user_name,
				  job_no
	         FROM invoice_pre_total_v
	        WHERE (billing_user_id =  2250  OR 'true' =  'true' )
	          AND invoice_status_id =  1 
	          AND organization_id =  2 
	     GROUP BY invoice_id,
	              invoice_id_trk,
	              invoice_description,
	              invoice_type_name,
	              invoice_status_id,
	              customer_name,
	              end_user_name,
	              job_id,
	              billing_user_name,
	              job_no
	     ORDER BY invoice_id