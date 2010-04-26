DROP  VIEW invoices_extranet_v
GO

CREATE VIEW invoices_extranet_v
AS
SELECT TOP 100 PERCENT     
       p.project_id, 
       p.project_no,
       p.job_name,        
       p.project_status_type_id, 
       project_status_type.code project_status_type_code, 
       project_status_type.name project_status_type_name, 
       c.organization_id, 
       CASE WHEN customer_type.code = 'end_user' THEN c.end_user_parent_id ELSE c.customer_id END customer_id, 
       CASE WHEN customer_type.code = 'end_user' THEN (SELECT customer_name FROM customers WHERE customer_id = c.end_user_parent_id) ELSE c.customer_name END customer_name,
       CASE WHEN customer_type.code = 'end_user' THEN c.customer_name ELSE eu.customer_name END end_user_name, 
       CASE WHEN customer_type.code = 'dealer' THEN ISNULL(c.ext_customer_id, c.ext_dealer_id) ELSE c.ext_dealer_id END ext_dealer_id,
       c.dealer_name,
       c.ext_customer_id,   
       j.job_id, 
       j.job_no,      
       i.invoice_id, 
       i.status_id, 
       i.description, 
       i.date_sent as invoiced_date, 
       i.po_no, 
       ist.name AS invoice_status_name, 
       i_total_v.extended_price AS invoice_total,  
       MIN(DISTINCT sl_1.SERVICE_LINE_DATE) AS min_start_date, 
       MAX(DISTINCT sl_1.SERVICE_LINE_DATE) AS max_end_date, 
       invoice_type.name AS invoice_type_name
  FROM dbo.projects p INNER JOIN
       dbo.lookups project_status_type ON p.project_status_type_id = project_status_type.lookup_id INNER JOIN
       dbo.customers c ON p.customer_id = c.customer_id INNER JOIN
       dbo.lookups customer_type ON c.customer_type_id = customer_type.lookup_id LEFT OUTER JOIN
       dbo.customers eu ON p.end_user_id = eu.customer_id LEFT OUTER JOIN
       dbo.jobs j ON p.project_id = j.project_id LEFT OUTER JOIN       
       dbo.invoices i ON j.job_id = i.job_id LEFT OUTER JOIN
       dbo.lookups invoice_type ON i.invoice_type_id = invoice_type.lookup_id LEFT OUTER JOIN
       dbo.invoice_statuses ist ON i.status_id = ist.status_id LEFT OUTER JOIN
       dbo.service_lines sl_1 ON i.invoice_id = sl_1.invoice_id LEFT OUTER JOIN 
       (SELECT TOP 100 PERCENT 
               dbo.INVOICES.INVOICE_ID, 
               SUM(ISNULL(dbo.INVOICE_LINES.UNIT_PRICE, 0) * ISNULL(dbo.INVOICE_LINES.QTY, 0)) AS extended_price
          FROM dbo.LOOKUPS RIGHT OUTER JOIN
               dbo.INVOICE_LINES ON dbo.LOOKUPS.LOOKUP_ID = dbo.INVOICE_LINES.INVOICE_LINE_TYPE_ID RIGHT OUTER JOIN
               dbo.INVOICES ON dbo.INVOICE_LINES.INVOICE_ID = dbo.INVOICES.INVOICE_ID
      GROUP BY dbo.INVOICES.JOB_ID, 
               dbo.INVOICES.INVOICE_ID, 
               dbo.LOOKUPS.CODE
       ) i_total_v ON i.invoice_id = i_total_v.invoice_id
GROUP BY p.project_id, 
         p.project_no,
         p.job_name,
         p.project_status_type_id, 
         project_status_type.code,
         project_status_type.name,
         c.organization_id, 
         c.customer_id, 
         c.ext_dealer_id, 
         c.dealer_name,
         c.ext_customer_id, 
         c.customer_name, 
         c.parent_customer_id,
         j.job_id,
         j.job_no, 
         i.invoice_id, 
         i.status_id, 
         i.description, 
         i.date_sent,
         i.po_no, 
         ist.name,
         i_total_v.extended_price, 
         invoice_type.name,
         customer_type.code,
         c.end_user_parent_id,
         eu.customer_name
GO
         