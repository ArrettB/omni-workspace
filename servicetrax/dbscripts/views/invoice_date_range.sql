CREATE VIEW dbo.invoice_date_range
AS
SELECT     dbo.INVOICES.ORGANIZATION_ID, dbo.INVOICES.INVOICE_ID, dbo.INVOICE_LINES.INVOICE_LINE_NO, dbo.ITEMS.NAME, 
                      dbo.INVOICE_LINES.ITEM_ID, dbo.INVOICE_LINES.DESCRIPTION AS line_desc, dbo.INVOICE_LINES.UNIT_PRICE, dbo.INVOICE_LINES.QTY, 
                      dbo.INVOICE_LINES.EXTENDED_PRICE, dbo.INVOICES.JOB_ID, dbo.INVOICES.STATUS_ID, dbo.INVOICES.DESCRIPTION AS header_desc, 
                      dbo.INVOICES.EXT_BILL_CUST_ID, dbo.INVOICES.DATE_SENT, dbo.INVOICE_LINES.INVOICE_LINE_ID, dbo.INVOICE_TYPES_V.LOOKUP_ID, 
                      dbo.INVOICE_LINE_TYPES_V.invoice_type_code AS invoice_line_type_code, dbo.INVOICE_TYPES_V.invoice_type_code, 
                      dbo.INVOICE_TYPES_V.NAME AS invoice_type_name, dbo.INVOICE_LINE_TYPES_V.NAME AS invoice_line_type_name, 
                      RTRIM(ISNULL(dbo.ITEMS.EXT_ITEM_ID, 'NA')) AS ext_item_id, dbo.ITEMS.ITEM_TYPE_ID, dbo.ITEM_TYPES_V.lookup_code AS item_type_code, 
                      dbo.ITEM_TYPES_V.lookup_name AS item_type_name, dbo.INVOICE_LINES.PO_NO AS line_po_no, dbo.INVOICE_LINES.TAXABLE_FLAG
FROM         dbo.ITEM_TYPES_V RIGHT OUTER JOIN
                      dbo.ITEMS ON dbo.ITEM_TYPES_V.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID RIGHT OUTER JOIN
                      dbo.INVOICE_LINE_TYPES_V RIGHT OUTER JOIN
                      dbo.INVOICE_LINES ON dbo.INVOICE_LINE_TYPES_V.LOOKUP_ID = dbo.INVOICE_LINES.INVOICE_LINE_TYPE_ID LEFT OUTER JOIN
                      dbo.INVOICES LEFT OUTER JOIN
                      dbo.INVOICE_TYPES_V ON dbo.INVOICES.INVOICE_TYPE_ID = dbo.INVOICE_TYPES_V.LOOKUP_ID ON 
                      dbo.INVOICE_LINES.INVOICE_ID = dbo.INVOICES.INVOICE_ID ON dbo.ITEMS.ITEM_ID = dbo.INVOICE_LINES.ITEM_ID
WHERE     (dbo.INVOICES.STATUS_ID = 4) AND (dbo.INVOICES.INVOICE_ID = 86434)

