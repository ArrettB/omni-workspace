--
-- THIS VIEW IS NO LONGER USED
-- 


DROP VIEW  dbo.jobs_with_costs_v
Go

CREATE VIEW dbo.jobs_with_costs_v
AS
SELECT     TOP 100 PERCENT dbo.ORGANIZATIONS.ORGANIZATION_ID, dbo.ORGANIZATIONS.NAME AS [Organization Name], dbo.JOBS.JOB_NO AS [Job No], 
                      dbo.CUSTOMERS.CUSTOMER_NAME AS [Customer Name], dbo.CUSTOMERS.DEALER_NAME AS [Dealer Name], 
                      dbo.USERS.FIRST_NAME + ' ' + dbo.USERS.LAST_NAME AS [Job Owner], dbo.INVOICES.INVOICE_ID AS [Invoice No], 
                      dbo.INVOICES.DATE_SENT AS [Invoiced Date], dbo.RESOURCES.NAME AS [Job Supervisor], SUM(dbo.INVOICE_LINES.EXTENDED_PRICE) 
                      AS [Total Invoiced],
                          (SELECT     ISNULL(SUM(sl.bill_qty * ISNULL(i.cost_per_uom, 0)), 0)
                            FROM          service_lines sl, items i
                            WHERE      isnull(sl.invoice_id, sl.posted_from_invoice_id) = invoices.invoice_id AND sl.bill_job_id = invoices.job_id AND sl.item_id = i.item_id AND 
                                                   sl.item_type_code = 'hours' AND i.name NOT LIKE 'TRUCK%' AND (name NOT LIKE 'sub%' OR
                                                   name LIKE 'sub%exp%')) AS [Labor Cost],
                          (SELECT     ISNULL(SUM(sl.bill_qty * ISNULL(i.cost_per_uom, 0)), 0)
                            FROM          service_lines sl, items i
                            WHERE      isnull(sl.invoice_id, sl.posted_from_invoice_id) = invoices.invoice_id AND sl.bill_job_id = invoices.job_id AND sl.item_id = i.item_id AND 
                                                   sl.item_type_code = 'hours' AND i.name LIKE 'TRUCK%') AS [Truck Cost ],
                          (SELECT     ISNULL(SUM(sl.bill_qty * ISNULL(i.cost_per_uom, 0)), 0)
                            FROM          service_lines sl, items i
                            WHERE      isnull(sl.invoice_id, sl.posted_from_invoice_id) = invoices.invoice_id AND sl.bill_job_id = invoices.job_id AND sl.item_id = i.item_id AND 
                                                   sl.item_type_code = 'hours' AND i.name LIKE 'SUB-%' AND i.name NOT LIKE 'SUB%EXP%') AS [Sub Cost ],
                          (SELECT     ISNULL(SUM(sl.bill_qty * ISNULL(i.cost_per_uom, 0)), 0)
                            FROM          service_lines sl, items i
                            WHERE      isnull(sl.invoice_id, sl.posted_from_invoice_id) = invoices.invoice_id AND sl.bill_job_id = invoices.job_id AND sl.item_id = i.item_id AND 
                                                   sl.item_type_code = 'expense') AS [Expense Cost ]
FROM         dbo.JOBS INNER JOIN
                      dbo.INVOICES ON dbo.JOBS.JOB_ID = dbo.INVOICES.JOB_ID INNER JOIN
                      dbo.INVOICE_LINES ON dbo.INVOICES.INVOICE_ID = dbo.INVOICE_LINES.INVOICE_ID INNER JOIN
                      dbo.CUSTOMERS ON dbo.JOBS.CUSTOMER_ID = dbo.CUSTOMERS.CUSTOMER_ID INNER JOIN
                      dbo.ORGANIZATIONS ON dbo.CUSTOMERS.ORGANIZATION_ID = dbo.ORGANIZATIONS.ORGANIZATION_ID LEFT OUTER JOIN
                      dbo.RESOURCES ON dbo.JOBS.FOREMAN_RESOURCE_ID = dbo.RESOURCES.RESOURCE_ID LEFT OUTER JOIN
                      dbo.USERS ON dbo.JOBS.BILLING_USER_ID = dbo.USERS.USER_ID
GROUP BY dbo.ORGANIZATIONS.NAME, dbo.JOBS.JOB_NO, dbo.CUSTOMERS.DEALER_NAME, dbo.USERS.FIRST_NAME + ' ' + dbo.USERS.LAST_NAME, 
                      dbo.RESOURCES.NAME, dbo.INVOICES.INVOICE_ID, dbo.INVOICES.DATE_SENT, dbo.ORGANIZATIONS.ORGANIZATION_ID, 
                      dbo.CUSTOMERS.CUSTOMER_NAME, dbo.INVOICES.JOB_ID
ORDER BY dbo.ORGANIZATIONS.NAME, dbo.JOBS.JOB_NO
GO

