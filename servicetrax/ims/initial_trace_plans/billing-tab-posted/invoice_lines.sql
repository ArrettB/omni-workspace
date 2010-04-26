SELECT invoice_id, invoice_line_id, invoice_line_no, line_desc, qty, unit_price, (qty*unit_price) extended_total
	FROM invoice_lines_v
	WHERE invoice_line_type_code='custom'
		 
	ORDER BY invoice_id, invoice_line_no