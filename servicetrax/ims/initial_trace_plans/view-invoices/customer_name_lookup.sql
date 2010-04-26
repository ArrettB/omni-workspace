SELECT DISTINCT iev.customer_name, iev.customer_name
				FROM invoices_extranet_v iev
				WHERE iev.organization_id =  2
		  		ORDER BY iev.customer_name