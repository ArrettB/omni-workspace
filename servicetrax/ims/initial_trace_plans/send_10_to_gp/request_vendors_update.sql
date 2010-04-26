BEGIN TRANSACTION
UPDATE request_vendors   SET total_cost = ISNULL(total_cost, 0) + ISNULL(i.sum_bill_total, 0),       invoice_date = getDate(),       invoice_numbers = ISNULL(invoice_numbers, '''') + CONVERT(VARCHAR, i.invoice_id)   FROM request_invoices_v i  WHERE request_vendors.request_id = i.request_id    AND request_vendors.vendor_contact_id = i.vendor_contact_id    AND i.invoice_id =  164325
ROLLBACK TRANSACTION
GO