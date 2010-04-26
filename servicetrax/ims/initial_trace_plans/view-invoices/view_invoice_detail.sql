SELECT iev.project_id, iev.project_no, iev.customer_name,iev.end_user_name, iev.job_name,
		              iev.project_status_type_name, iev.invoice_status_name,
					  iev.po_no, iev.invoice_total, invoiced_date, invoice_id, invoice_type_name, null empty
				 FROM invoices_extranet_v iev
				WHERE iev.organization_id =  2 
		  	 ORDER BY iev.project_no desc, iev.po_no