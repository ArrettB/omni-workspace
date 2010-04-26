begin transaction
UPDATE invoices set modified_by =  2250  ,date_modified = getDate()  ,status_id =  4  where 1=1 and invoice_id =  164325
rollback transaction