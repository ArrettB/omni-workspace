select
	cn.contact_name customer_contact_name,
	cn.contact_name customer_contact_name
from
requests r
	join projects p on
		p.project_id = r.project_id
	join customers c on
		c.customer_id = p.customer_id
	join contacts cn on
		r.customer_contact_id = cn.contact_id
	join lookups rt on
		rt.lookup_id = r.request_type_id
	join lookups rs on
		rs.lookup_id = r.request_status_type_id
where
	c.organization_id = 2 -- <?s:org_id.toPStmtString()?>
	and rt.code = 'workorder'
	and rs.code <> 'closed'
group by
	cn.contact_name
order by
	cn.contact_name