select distinct
    c.customer_name,
    c.customer_name
from
    invoices i
    join jobs j on
        i.job_id = j.job_id
    join projects p on
        p.project_id = j.project_id
    join invoice_statuses s on
        s.status_id = i.status_id
    join lookups pt on
        pt.lookup_id = p.project_type_id
    join customers c on
        c.customer_id = p.customer_id
where
    i.organization_id = 2 -- <?s:org_id.toPStmtString()?>
    and s.code = 'invoiced'
    and pt.code = 'service_account'
    and p.project_id like '%' -- <?p:r_project_id.isNull('%').toPStmtString()?>
order by
    c.customer_name