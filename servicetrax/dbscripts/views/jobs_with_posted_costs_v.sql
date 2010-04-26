
CREATE VIEW jobs_with_posted_costs_v 
AS 
SELECT TOP 100 PERCENT o.organization_id,
       sl.invoice_id,
       sl.status_id,
       o.name AS [Organization Name],
       j.job_no AS [Job No],
       job_type.name AS [Job Type],
       CASE WHEN customer_type.code = 'end_user' THEN (SELECT customer_name FROM customers WHERE customer_id = cust.end_user_parent_id) ELSE cust.customer_name END AS [Customer Name], 
       CASE WHEN customer_type.code = 'end_user' THEN cust.customer_name ELSE eu.customer_name END AS [End User Name], 
       u1.first_name + ' ' + u1.last_name AS [Job Owner],
       NULL AS [Invoice No],
       sl.invoice_post_date AS [Invoiced Date],
       u2.first_name + ' ' + u2.last_name AS [Posted By],
       r.name AS [Job Supervisor],
       c.contact_name AS [SP Sales],
       0 AS [Total Invoiced],
       SUM(ISNULL(sl.bill_qty * labor_items.cost_per_uom, 0)) AS [labor cost],
       SUM(ISNULL(sl.bill_qty * truck_items.cost_per_uom, 0)) AS [truck cost],
       SUM(ISNULL(sl.bill_qty * sub_items.cost_per_uom, 0)) AS [sub cost],
       SUM(ISNULL(CASE WHEN (sl.entry_method = 'great plains') THEN sl.expense_total 
            ELSE (sl.expense_qty * expense_items.cost_per_uom) END,0)) AS [expense cost] 
  FROM dbo.jobs j INNER JOIN 
       dbo.lookups job_type ON j.job_type_id=job_type.lookup_id INNER JOIN 
       dbo.customers cust ON j.customer_id = cust.customer_id INNER JOIN
       dbo.lookups customer_type ON cust.customer_type_id=customer_type.lookup_id INNER JOIN 
       dbo.organizations o ON cust.organization_id = o.organization_id INNER JOIN
       dbo.service_lines sl ON j.job_id = sl.bill_job_id LEFT OUTER JOIN
       dbo.resources r ON j.foreman_resource_id = r.resource_id LEFT OUTER JOIN
       dbo.contacts c ON j. a_m_sales_contact_id = c.contact_id LEFT OUTER JOIN
       dbo.users u1 ON j.billing_user_id = u1.user_id LEFT OUTER JOIN
       dbo.items labor_items ON sl.item_id = labor_items.item_id AND 
                                sl.item_type_code = 'hours' AND 
                                labor_items.name NOT LIKE 'TRUCK%' AND 
                                (labor_items.name NOT LIKE 'SUB%' OR labor_items.name LIKE 'SUB%EXP%') LEFT OUTER JOIN
       dbo.ITEMS truck_items ON sl.item_id = truck_items.item_id AND 
                                sl.item_type_code = 'hours' AND 
                                truck_items.name LIKE 'TRUCK%' LEFT OUTER JOIN 
       dbo.ITEMS sub_items ON sl.item_id = sub_items .item_id AND 
                              sl.item_type_code = 'hours' AND 
                              sub_items.name LIKE 'SUB-%' AND 
                              sub_items.name NOT LIKE 'SUB%EXP%' LEFT OUTER JOIN
       dbo.ITEMS expense_items ON sl.item_id = expense_items.item_id AND 
                                  sl.item_type_code = 'expense' LEFT OUTER JOIN
       dbo.users u2 ON sl.posted_by = u2.user_id LEFT OUTER JOIN
       dbo.customers eu ON j.end_user_id = eu.customer_id
 WHERE sl.invoice_post_date IS NOT NULL
GROUP BY o.organization_id,
         sl.invoice_id,
         sl.status_id,
         o.name,
         j.job_no,
         job_type.name,
         u1.first_name + ' ' + u1.last_name,
         sl.invoice_post_date,
         u2.first_name + ' ' + u2.last_name,
         r.name,
         c.contact_name,
         cust.end_user_parent_id,
         customer_type.code,
         cust.customer_name,
         eu.customer_name

