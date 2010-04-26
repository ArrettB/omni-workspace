
SELECT bill_job_id, item_name, bill_rate, job_item_status_id, quote_total, quote_id, quoted_total, is_new,
			      sum(bill_hourly_qty) sum_bill_hourly_qty,
			      sum(payroll_qty) sum_payroll_qty,
			      sum(bill_hourly_total) bill_hourly_total,
			      sum(bill_exp_qty) sum_bill_exp_qty,
			      sum(bill_exp_total) bill_exp_total,
			      sum(bill_total) bill_total
			 FROM billing_v
			WHERE bill_job_id =  70867 
			  AND status_id =  4 
			  AND invoice_id IS NULL and billable_flag =  'Y' 
		      AND (item_type_code =  null  or  null  is null)
	     GROUP BY bill_job_id, job_item_status_id, item_name, bill_rate, quote_id, quote_total, quoted_total, is_new
		 ORDER BY item_name