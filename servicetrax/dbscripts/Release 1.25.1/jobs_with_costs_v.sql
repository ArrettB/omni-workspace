DROP VIEW jobs_with_costs_v
GO

CREATE view jobs_with_costs_v AS 
SELECT TOP 100 PERCENT o.organization_id, 
       o.name AS [Organization Name], 
       j.job_no AS [Job No],	
       job_type.name AS [Job Type], 
       CASE WHEN customer_type.code = 'end_user' THEN (SELECT customer_name FROM customers WHERE customer_id = cust.end_user_parent_id) ELSE cust.customer_name END AS [Customer Name], 
       CASE WHEN customer_type.code = 'end_user' THEN cust.customer_name ELSE eu.customer_name END AS [End User Name], 
       u.first_name + ' ' + u.last_name AS [Job Owner], 
       inv.invoice_id AS [Invoice No], 
       inv.date_sent AS [Invoiced Date], 
       r.name AS [Job Supervisor], 
       c.contact_name AS [SP Sales], 
       SUM(ISNULL(il.extended_price, 0)) AS [Total Invoiced],
       (SELECT ISNULL(SUM(sl.tc_qty * ISNULL(i.cost_per_uom, 0)), 0)
          FROM service_lines sl INNER JOIN
               items i ON sl.item_id = i.item_id
         WHERE sl.invoice_id = inv.invoice_id 
           AND sl.tc_job_id = j.job_id 
           AND sl.item_type_code = 'hours' 
           AND i.name NOT LIKE 'TRUCK%' 
           AND (i.name NOT LIKE 'sub%' OR i.name LIKE 'sub%exp%')) AS [Labor Cost],
       (SELECT ISNULL(SUM(sl.tc_qty * ISNULL(i.cost_per_uom, 0)), 0)
          FROM service_lines sl INNER JOIN
               items i ON sl.item_id = i.item_id
         WHERE sl.invoice_id = inv.invoice_id 
           AND sl.tc_job_id = j.job_id 
           AND sl.item_type_code = 'hours' 
           AND i.name LIKE 'TRUCK%') AS [Truck Cost ],
       (SELECT ISNULL(SUM(sl.tc_qty * ISNULL(i.cost_per_uom, 0)), 0)
          FROM service_lines sl INNER JOIN
               items i ON sl.item_id = i.item_id
         WHERE sl.invoice_id = inv.invoice_id 
           AND sl.tc_job_id = j.job_id 
           AND sl.item_type_code = 'hours' 
           AND i.name LIKE 'SUB-%' 
           AND i.name NOT LIKE 'SUB%EXP%') AS [Sub Cost ],
        (SELECT ISNULL(SUM(CASE WHEN sl.entry_method = 'great plains' THEN sl.expense_total
                ELSE (sl.tc_qty * i.cost_per_uom) END), 0)
          FROM service_lines sl INNER JOIN
               items i ON sl.item_id = i.item_id
         WHERE sl.invoice_id = inv.invoice_id 
           AND sl.tc_job_id = j.job_id 
           AND sl.item_type_code = 'expense') AS [Expense Cost]
  FROM dbo.jobs j INNER JOIN 
       dbo.lookups job_type ON j.job_type_id=job_type.lookup_id INNER JOIN 
       dbo.invoices inv ON j.job_id = inv.job_id LEFT OUTER JOIN
       dbo.invoice_lines il ON inv.invoice_id = il.invoice_id INNER JOIN
       dbo.customers cust ON j.customer_id = cust.customer_id INNER JOIN
       dbo.lookups customer_type ON cust.customer_type_id = customer_type.lookup_id INNER JOIN 
       dbo.organizations o ON cust.organization_id = o.organization_id LEFT OUTER JOIN
       dbo.resources r ON j.foreman_resource_id = r.resource_id LEFT OUTER JOIN
       dbo.users u ON j.billing_user_id = u.user_id LEFT OUTER JOIN
       dbo.contacts c ON j.a_m_sales_contact_id = c.contact_id LEFT OUTER JOIN
       dbo.customers eu ON j.end_user_id = eu.customer_id
GROUP BY o.organization_id, 
         o.name, 
         j.job_no, 
         job_type.name,
         u.first_name + ' ' + u.last_name, 
	 inv.invoice_id, 
         inv.date_sent, 
         r.name, 
         c.contact_name, 
         j.job_id,
         cust.end_user_parent_id,
	 customer_type.code,
	 cust.customer_name,
         eu.customer_name
ORDER BY o.name, 
         j.job_no
GO