DROP VIEW [dbo].[invoice_lines_v]
GO

CREATE VIEW [dbo].[invoice_lines_v]
AS
SELECT i.organization_id, 
       i.invoice_id, 
       i.job_id, 
       i.status_id, 
       i.description header_desc, 
       i.ext_bill_cust_id, 
       i.date_sent, 
       il.invoice_line_no, 
       il.item_id, 
       il.description line_desc, 
       il.unit_price, 
       il.qty, 
       il.extended_price, 
       il.invoice_line_id,
       il.po_no as line_po_no, 
       il.taxable_flag,
       il.bill_service_id,
       item.name, 
       invoice_type.lookup_id, 
       invoice_type.code invoice_type_code, 
       invoice_type.name invoice_type_name, 
       invoice_line_type.code invoice_line_type_code, 
       invoice_line_type.name invoice_line_type_name, 
       RTRIM(ISNULL(item.ext_item_id, 'NA')) ext_item_id, 
       item.item_type_id, 
       item_type.code item_type_code, 
       item_type.name item_type_name
  FROM dbo.invoice_lines il INNER JOIN
       dbo.lookups invoice_line_type ON il.invoice_line_type_id = invoice_line_type.lookup_id INNER JOIN
       dbo.invoices i ON il.invoice_id = i.invoice_id LEFT OUTER JOIN 
       dbo.lookups invoice_type ON i.invoice_type_id = invoice_type.lookup_id LEFT OUTER JOIN
       dbo.items item ON il.item_id = item.item_id LEFT OUTER JOIN
       dbo.lookups item_type ON item.item_type_id = item_type.lookup_id
GO
       
       
  
