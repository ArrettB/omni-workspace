
CREATE view jobs_with_costs_v AS 
SELECT TOP 100 PERCENT organizations.name AS [Organization Name], jobs.job_no AS [Job No], jobs.job_name AS [Job Name], customers.dealer_name AS [Dealer Name], 
                      users.first_name + ' ' + users.last_name AS [Job Owner], invoices.invoice_id AS [Invoice No], CONVERT(varchar, invoices.date_sent, 101) 
                      AS [Invoiced Date], resources.name AS [Job Supervisor], items.name AS [Item Name], SUM(invoice_lines.qty) AS [Qty], invoice_lines.unit_price [Rate], 
                      SUM(invoice_lines.extended_price) AS [Total], items.cost_per_uom AS [Cost Per Unit], SUM(items.cost_per_uom * invoice_lines.qty) AS [Total Cost],
                          (SELECT     SUM(sl.tc_qty)
                            FROM          service_lines sl
                            WHERE      sl.posted_from_invoice_id = invoices.invoice_id AND sl.item_id = invoice_lines.item_id) AS [Posted From Qty],
                          (SELECT     SUM(sl.tc_qty) * items.cost_per_uom
                            FROM          service_lines sl
                            WHERE      sl.posted_from_invoice_id = invoices.invoice_id AND sl.item_id = invoice_lines.item_id) AS [Posted From Cost], 
                      CASE WHEN items.name = 'Labor-Tax' THEN
                          (SELECT     SUM(sl.bill_qty)
                            FROM          service_lines sl
                            WHERE      sl.invoice_id = invoices.invoice_id AND sl.taxable_flag = 'Y') ELSE
                          (SELECT     SUM(sl.bill_qty)
                            FROM          service_lines sl
                            WHERE      sl.invoice_id = invoices.invoice_id AND sl.taxable_flag = 'N' AND sl.item_id = invoice_lines.item_id) END AS [Time Qty], 
                      CASE WHEN items.name = 'Labor-Tax' THEN
                          (SELECT     SUM(sl.bill_qty * i.cost_per_uom)
                            FROM          service_lines sl, items i
                            WHERE      sl.invoice_id = invoices.invoice_id AND sl.item_id = i.item_id AND sl.taxable_flag = 'Y') ELSE
                          (SELECT     SUM(sl.bill_qty) * items.cost_per_uom
                            FROM          service_lines sl
                            WHERE      sl.invoice_id = invoices.invoice_id AND sl.taxable_flag = 'N' AND sl.item_id = invoice_lines.item_id) END AS [Time Cost]
, invoices.date_sent as [Report Date]
FROM         jobs INNER JOIN
                      invoices ON jobs.job_id = invoices.job_id INNER JOIN
                      invoice_lines ON invoices.invoice_id = invoice_lines.invoice_id INNER JOIN
                      items ON invoice_lines.item_id = items.item_id INNER JOIN
                      customers ON jobs.customer_id = customers.customer_id INNER JOIN
                      organizations ON customers.organization_id = organizations.organization_id LEFT OUTER JOIN
                      resources ON jobs.foreman_resource_id = resources.resource_id LEFT OUTER JOIN
                      users ON jobs.billing_user_id = users.user_id
GROUP BY organizations.name, jobs.job_id, jobs.job_no, jobs.job_name, customers.dealer_name, users.first_name + ' ' + users.last_name, resources.name, 
                      items.name, invoice_lines.unit_price, items.cost_per_uom, invoices.invoice_id, invoices.date_sent, invoice_lines.item_id
ORDER BY organizations.name, jobs.job_no, invoices.date_sent