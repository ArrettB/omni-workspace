select
    data.project_id,
    data.project_no,
    data.ext_dealer_id,
    data.ext_direct_dealer_id,
    data.ext_dci_dealer_id,
    data.dealer_name,
    data.customer_name,
    data.invoice_id,
    data.invoice_total,
    data.po_no,
    data.date_sent,
    data.empty
from
(select
    p.project_id,
    p.project_no,
    c.ext_dealer_id,
    o.ext_direct_dealer_id,
    o.ext_dci_dealer_id,
    c.dealer_name,
    c.customer_name,
    i.invoice_id,
    sum(IsNull(il.unit_price, 0) * IsNull(il.qty, 0)) invoice_total,
    i.po_no,
    i.date_sent,
    null empty
from
    invoices i
    left join invoice_lines il on
        i.invoice_id = il.invoice_id
    left join lookups lt on
        lt.lookup_id = il.invoice_line_type_id
    join jobs j on
        i.job_id = j.job_id
    join projects p on
        p.project_id = j.project_id
    join invoice_statuses s on
        s.status_id = i.status_id
    join lookups pt on
        pt.lookup_id = p.project_type_id
    join customers c on
        p.customer_id = c.customer_id
    join organizations o on
        o.organization_id = i.organization_id
where
    i.organization_id = 2 -- <?s:org_id.toPStmtString()?>
    and s.code = 'invoiced'
    and pt.code = 'service_account'
    and p.project_id like '%' -- <?p:r_project_id.isNull('%').toPStmtString()?>
group by
    p.project_id,
    p.project_no,
    i.invoice_id,
    c.ext_dealer_id,
    o.ext_direct_dealer_id,
    o.ext_dci_dealer_id,
    c.dealer_name,
    c.customer_name,
    i.po_no,
    i.date_sent,
    lt.code) data
order by
    data.project_no desc,
    data.invoice_id desc