select
    c.customer_id,
    c.customer_name
from (
select distinct
    case ct.code
        when 'end_user' then cp.customer_id else c.customer_id
    end customer_id,
    case ct.code
        when 'end_user' then cp.customer_name else c.customer_name
    end customer_name
from
    requests r
    join projects p on
        p.project_id = r.project_id
    join customers c on
        c.customer_id = p.customer_id
    left join lookups ct on
        ct.lookup_id = c.customer_type_id
    left join customers cp on
        c.end_user_parent_id = cp.customer_id
    join lookups rt on
        rt.lookup_id = r.request_type_id
    join lookups rs on
        rs.lookup_id = r.request_status_type_id
    join lookups ps on
        ps.lookup_id = p.project_status_type_id
where
    c.organization_id = 2 -- <?s:org_id.toPStmtString()?>
    and rt.code = 'workorder'
    and ps.code <> 'folder_closed'
    and rs.code <> 'closed') c
order by
    c.customer_name