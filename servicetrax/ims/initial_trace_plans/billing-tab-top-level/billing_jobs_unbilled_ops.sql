SELECT billing_user_id,
		          bill_job_no,
		          bill_job_id,
		          non_billable_total,
		          billable_total,
		          invoiced_total,
		          customer_name,
		          end_user_name,
		          max_est_end_date_varchar,
		          billing_user_name,
		          job_name,
		          organization_id,
		          po_count,
		          received_po_count
	         FROM bill_jobs_v
	        WHERE organization_id = 2
	          AND (billing_user_id = 2250 OR 'true' = 'true')
	     ORDER BY billing_user_name, bill_job_no