select distinct
    customer_name,
    customer_name
from
(select
    case ct.code
        when 'end_user' then pc.customer_name
        else c.customer_name
    end customer_name
from
    projects p join
    customers c on
        p.customer_id = c.customer_id
    left join customers pc on
        c.end_user_parent_id = pc.customer_id
    join lookups ct on
        c.customer_type_id = ct.lookup_id
where
    c.organization_id = 2 -- <?s:org_id.toPStmtString()?>
    ) data
order by
    customer_name