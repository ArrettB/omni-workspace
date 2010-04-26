if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jobs_with_costs_v]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[jobs_with_costs_v]
GO


CREATE VIEW jobs_with_costs_v AS 
SELECT TOP 100 PERCENT dbo.ORGANIZATIONS.ORGANIZATION_ID ,
    dbo.ORGANIZATIONS.NAME                                         AS [Organization Name] ,
    dbo.JOBS.JOB_NO                                                AS [Job No] ,
    dbo.CUSTOMERS.CUSTOMER_NAME                                    AS [Customer Name] ,
    dbo.CUSTOMERS.DEALER_NAME                                      AS [Dealer Name] ,
    dbo.USERS.FIRST_NAME + ' ' + dbo.USERS.LAST_NAME               AS [Job Owner] ,
    dbo.INVOICES.INVOICE_ID                                        AS [Invoice No] ,
    dbo.INVOICES.DATE_SENT                                         AS [Invoiced Date] ,
    dbo.RESOURCES.NAME                                             AS [Job Supervisor] ,
    dbo.CONTACTS.CONTACT_NAME                                      AS [SP Sales] ,
    SUM(ISNULL(dbo.INVOICE_LINES.EXTENDED_PRICE,0)) + SUM(ISNULL(sl_inv.bill_total,0)) AS [Total Invoiced] ,
    (   SELECT ISNULL(SUM(sl.bill_qty * ISNULL(i.cost_per_uom, 0)), 0) 
        FROM service_lines sl 
            INNER JOIN items i 
            ON sl.item_id = i.item_id 
        WHERE sl.invoice_id = invoices.invoice_id 
            AND sl.tc_job_id = jobs.job_id 
            AND sl.item_type_code = 'hours' 
            AND i.NAME NOT LIKE 'TRUCK%' 
            AND (NAME NOT LIKE 'sub%' 
            OR NAME LIKE 'sub%exp%') 
    )
    AS [Labor Cost] ,
    (   SELECT ISNULL(SUM(sl.bill_qty * ISNULL(i.cost_per_uom, 0)), 0) 
        FROM service_lines sl 
            INNER JOIN items i 
            ON sl.item_id = i.item_id 
        WHERE sl.invoice_id = invoices.invoice_id 
            AND sl.tc_job_id = jobs.job_id 
            AND sl.item_type_code = 'hours' 
            AND i.NAME LIKE 'TRUCK%' 
    )
    AS [Truck Cost ] ,
    (   SELECT ISNULL(SUM(sl.bill_qty * ISNULL(i.cost_per_uom, 0)), 0) 
        FROM service_lines sl 
            INNER JOIN items i 
            ON sl.item_id = i.item_id 
        WHERE sl.invoice_id = invoices.invoice_id 
            AND sl.tc_job_id = jobs.job_id 
            AND sl.item_type_code = 'hours' 
            AND i.NAME LIKE 'SUB-%' 
            AND i.NAME NOT LIKE 'SUB%EXP%' 
    )
    AS [Sub Cost ] ,
    (   SELECT ISNULL(SUM( 
            CASE 
                WHEN sl.entry_method = 'great plains' 
                THEN sl.expense_total 
                ELSE (sl.bill_qty * i.cost_per_uom) 
            END),0) 
        FROM service_lines sl 
            INNER JOIN items i 
            ON sl.item_id = i.item_id 
        WHERE sl.invoice_id = invoices.invoice_id 
            AND sl.tc_job_id = jobs.job_id 
            AND sl.item_type_code = 'expense' 
    )
    AS [Expense Cost ] 
FROM dbo.JOBS 
        INNER JOIN dbo.INVOICES 
        ON dbo.JOBS.JOB_ID = dbo.INVOICES.JOB_ID 
        LEFT OUTER JOIN dbo.service_lines sl_inv 
        ON invoices.invoice_id = sl_inv.invoice_id 
        LEFT OUTER JOIN dbo.INVOICE_LINES 
        ON dbo.INVOICES.INVOICE_ID = dbo.INVOICE_LINES.INVOICE_ID 
        INNER JOIN dbo.CUSTOMERS 
        ON dbo.JOBS.CUSTOMER_ID = dbo.CUSTOMERS.CUSTOMER_ID 
        INNER JOIN dbo.ORGANIZATIONS 
        ON dbo.CUSTOMERS.ORGANIZATION_ID = dbo.ORGANIZATIONS. ORGANIZATION_ID 
        LEFT OUTER JOIN dbo.RESOURCES 
        ON dbo.JOBS.FOREMAN_RESOURCE_ID = dbo.RESOURCES. RESOURCE_ID 
        LEFT OUTER JOIN dbo.USERS 
        ON dbo.JOBS.BILLING_USER_ID = dbo.USERS.USER_ID 
        LEFT OUTER JOIN dbo.CONTACTS 
        ON dbo.JOBS.A_M_SALES_CONTACT_ID = dbo.CONTACTS.CONTACT_ID 
        GROUP BY dbo.ORGANIZATIONS.NAME ,
            dbo.JOBS.JOB_NO ,
            dbo.CUSTOMERS.DEALER_NAME ,
            dbo.USERS.FIRST_NAME + ' ' + dbo.USERS.LAST_NAME ,
            dbo.RESOURCES.NAME ,
            dbo.INVOICES.INVOICE_ID ,
            dbo.INVOICES.DATE_SENT ,
            dbo.ORGANIZATIONS.ORGANIZATION_ID ,
            dbo.CUSTOMERS.CUSTOMER_NAME ,
            dbo.CONTACTS.CONTACT_NAME ,
            dbo.JOBS.JOB_ID 
        ORDER BY dbo.ORGANIZATIONS.NAME ,
            dbo.JOBS.JOB_NO