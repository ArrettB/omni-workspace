select
	wo.project_id,
	wo.request_id,	
	wo.project_no,
	wo.request_no,
	wo.workorder_no,
	c.ext_dealer_id,
	c.dealer_name,
	wo.customer_id,
	c.customer_name,
	wo.job_location_name,
	wo.floor_number,
	wo.cust_col_1,
	wo.cust_col_2,
	wo.cust_col_3,
	wo.cust_col_4,
	wo.cust_col_5,
	wo.cust_col_6,
	wo.cust_col_7,
	wo.cust_col_8,
	wo.cust_col_9,
	wo.cust_col_10,
	wo.customer_contact_name,
	wo.description
from
	customers c join
(select
	r.request_id,
	r.project_id,
	p.project_no,
	r.request_no,
	convert(varchar, p.project_no) + '-' + convert(varchar, r.request_no) workorder_no,
	c.customer_id,
	jl.job_location_name,
	fl.name floor_number,
	r.cust_col_1,
	r.cust_col_2,
	r.cust_col_3,
	r.cust_col_4,
	r.cust_col_5,
	r.cust_col_6,
	r.cust_col_7,
	r.cust_col_8,
	r.cust_col_9,
	r.cust_col_10,
	cn.contact_name customer_contact_name,
	r.description,
	rt.sequence_no
from
	requests r
	join projects p on
		p.project_id = r.project_id
	join customers c on
		c.customer_id = p.customer_id
	join lookups rt on
		rt.lookup_id = r.request_type_id
	join lookups rs on
		rs.lookup_id = r.request_status_type_id
	left join job_locations jl on
		r.job_location_id = jl.job_location_id
	left join lookups fl on
		r.floor_number_type_id = fl.lookup_id
	left join contacts cn on
		r.customer_contact_id = cn.contact_id
	join (
		select
			max(version_no) version_no,
			p.project_id,
			p.project_no,
			r.request_no
		from
			projects p
			left join requests r on
				p.project_id = r.project_id
		group by
			p.project_id,
			p.project_no,
			r.request_no) mv on
		p.project_id = mv.project_id
		and r.request_no = mv.request_no
		and r.version_no = mv.version_no
where
	c.organization_id = 2 -- <?s:org_id.toPStmtString()?>
	and rt.code = 'workorder'
	and rs.code <> 'closed') wo on
	c.customer_id = wo.customer_id
order by
	wo.project_no desc,
	wo.request_no desc,
	wo.sequence_no