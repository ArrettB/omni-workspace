SELECT DISTINCT piv.ext_dealer_id, piv.dealer_name
				FROM project_invoices_v piv
				WHERE piv.organization_id = 2
				AND piv.invoice_status_code = 'invoiced'
				AND piv.project_type_code = 'service_account'
				AND piv.project_id like  '%'
		   		ORDER BY piv.dealer_name