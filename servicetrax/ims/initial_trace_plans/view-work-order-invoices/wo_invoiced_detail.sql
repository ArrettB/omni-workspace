SELECT piv.project_id, piv.project_no, piv.ext_dealer_id, piv.ext_direct_dealer_id, piv.ext_dci_dealer_id,
					piv.dealer_name, piv.customer_name, piv.invoice_id, piv.invoice_total, piv.po_no, piv.date_sent, null empty
				FROM project_invoices_v piv
				WHERE piv.organization_id =  2
				AND piv.invoice_status_code = 'invoiced'
				AND piv.project_type_code = 'service_account'
				AND piv.project_id like  '%' 
				ORDER BY piv.project_no DESC, piv.invoice_id DESC