CREATE VIEW jobs_with_posted_costs_v AS 
SELECT TOP 100 PERCENT dbo.ORGANIZATIONS.ORGANIZATION_ID,
    dbo.ORGANIZATIONS.NAME                                AS [Organization Name],
    dbo.JOBS.JOB_NO                                       AS [Job No],
    dbo.CUSTOMERS.CUSTOMER_NAME                           AS [Customer Name],
    dbo.CUSTOMERS.DEALER_NAME                             AS [Dealer Name],
    dbo.USERS.FIRST_NAME + ' ' + dbo.USERS.LAST_NAME      AS [Job Owner],
    NULL                                                  AS [Invoice No],
    sl.INVOICE_POST_DATE                                  AS [Invoiced Date],
    dbo.RESOURCES.NAME                                    AS [Job Supervisor],
    dbo.CONTACTS.CONTACT_NAME                             AS [SP Sales],
    0                                                     AS [Total Invoiced],
    SUM(ISNULL(sl.BILL_QTY * labor_items.COST_PER_UOM,0)) AS [labor cost],
    SUM(ISNULL(sl.BILL_QTY * truck_items.COST_PER_UOM,0)) AS [truck cost],
    SUM(ISNULL(sl.BILL_QTY * sub_items.COST_PER_UOM,0))   AS [sub cost],
    SUM(ISNULL( 
    CASE 
        WHEN (sl.entry_method = 'great plains') 
        THEN sl.expense_total 
        ELSE (sl.expense_qty * expense_items.cost_per_uom) 
    END,0))                               AS [expense cost] 
FROM dbo.JOBS 
        INNER JOIN dbo.CUSTOMERS 
        ON dbo.JOBS.CUSTOMER_ID = dbo.CUSTOMERS.CUSTOMER_ID 
        INNER JOIN dbo.ORGANIZATIONS 
        ON dbo.CUSTOMERS.ORGANIZATION_ID = dbo.ORGANIZATIONS.ORGANIZATION_ID 
        INNER JOIN dbo.SERVICE_LINES sl 
        ON dbo.JOBS.JOB_ID = sl.bill_job_id 
        LEFT OUTER JOIN dbo.RESOURCES 
        ON dbo.JOBS.FOREMAN_RESOURCE_ID = dbo.RESOURCES.RESOURCE_ID 
        LEFT OUTER JOIN dbo.CONTACTS 
        ON dbo.CONTACTS.CONTACT_ID = dbo.JOBS. A_M_SALES_CONTACT_ID 
        LEFT OUTER JOIN dbo.USERS 
        ON dbo.USERS.USER_ID = dbo.JOBS.BILLING_USER_ID 
        LEFT OUTER JOIN dbo.ITEMS labor_items 
        ON sl.ITEM_ID = labor_items.ITEM_ID 
        AND sl.item_type_code = 'hours' 
        AND labor_items.NAME NOT LIKE 'TRUCK%' 
        AND (labor_items.NAME NOT LIKE 'SUB%' 
        OR labor_items.NAME LIKE 'SUB%EXP%') 
        LEFT OUTER JOIN dbo.ITEMS truck_items 
        ON sl.ITEM_ID = truck_items.ITEM_ID 
        AND sl.item_type_code = 'hours' 
        AND truck_items.NAME LIKE 'TRUCK%' 
        LEFT OUTER JOIN dbo.ITEMS sub_items 
        ON sl.ITEM_ID = sub_items .ITEM_ID 
        AND sl.item_type_code = 'hours' 
        AND sub_items.NAME LIKE 'SUB-%' 
        AND sub_items.NAME NOT LIKE 'SUB%EXP%' 
        LEFT OUTER JOIN dbo.ITEMS expense_items 
        ON sl.ITEM_ID = expense_items.ITEM_ID 
        AND sl.item_type_code = 'expense' 
WHERE sl.INVOICE_POST_DATE IS NOT NULL 
GROUP BY dbo.organizations.organization_id,
    dbo.ORGANIZATIONS.NAME,
    dbo.JOBS.JOB_NO,
    dbo.CUSTOMERS.CUSTOMER_NAME,
    dbo.CUSTOMERS.DEALER_NAME,
    dbo.USERS.FIRST_NAME + ' ' + dbo.USERS.LAST_NAME,
    sl.INVOICE_POST_DATE,
    dbo.RESOURCES.NAME,
    dbo.CONTACTS.CONTACT_NAME