select
	IsNull(sum(il.unit_price * il.qty), 0) custom_tot,
	IsNull(sum(sl.bill_hourly_total), 0) hours_total,
	IsNull(sum(sl.bill_exp_total), 0) exp_tot,
	IsNull(sum(sl.bill_total), 0) + IsNull(sum(il.unit_price * il.qty), 0) total_tot,
	u.first_name + ' ' + u.last_name assigned_to_name,
	j.job_no,
	i.job_id,
	ib.name batch_status_name,
	i_trk.invoice_id_trk,
	i.invoice_id,
	i.description invoice_description,
	invoice_type.name invoice_type_name,
	i.status_id invoice_status_id,
	i.date_sent,
	j.customer_name,
	j.end_user_name,
	jt.name job_type_name,
	i.po_no,
	i.date_created invoice_date_created
from
	invoices i
	left join (
		select
			i2.invoice_id,
		case
			when iv.invoice_tracking_id is null then cast(i2.invoice_id as varchar) + ''
			else cast(i2.invoice_id as varchar) + '*'
		end invoice_id_trk
		from
			invoices i2
			left join invoice_tracking iv on
				i2.invoice_id = iv.invoice_id) i_trk on
			i.invoice_id = i_trk.invoice_id
	left join lookups invoice_type on
		i.invoice_type_id = invoice_type.lookup_id
	join (
		select
			j.job_id,
			j.job_no,
			j.billing_user_id,
			j.job_type_id,
			CASE 
				WHEN customer_type.code = 'end_user' THEN (SELECT customer_name FROM customers WHERE customer_id = c.end_user_parent_id) 
				ELSE c.customer_name 
			END customer_name,
			CASE 
				WHEN customer_type.code = 'end_user' THEN c.customer_name 
				ELSE eu.customer_name 
			END end_user_name
		from
			jobs j
			join customers c on
				j.customer_id = c.customer_id
			join lookups customer_type on
				c.customer_type_id = customer_type.lookup_id
			left join projects p on
				p.project_id = j.project_id
			left join customers eu on
				eu.customer_id = p.end_user_id	
		) j on
		i.job_id = j.job_id
	left join (
		select
			invoices.invoice_id,
			unit_price,
			qty
		from
			invoices
			join invoice_lines on
				invoices.invoice_id = invoice_lines.invoice_id
			join lookups l on
				invoice_lines.invoice_line_type_id = lookup_id
			join lookup_types lt on
				l.lookup_type_id = lt.lookup_type_id
		where 
			lt.code = 'invoice_line_type'
			and lt.active_flag <> 'N'
			and l.active_flag <> 'N'
			and l.code = 'custom') il on
		i.invoice_id = il.invoice_id
	left join (
		select
			invoice_id,
			bill_hourly_total,
			bill_exp_total,
			bill_total
		from
			service_lines
		where
			status_id > 3
			AND internal_req_flag = 'N') sl on
		i.invoice_id = sl.invoice_id
	left join users u on
		u.user_id = i.assigned_to_user_id
	left join invoice_batch_statuses ib on
		i.batch_status_id = ib.status_id
	left join lookups jt on
		jt.lookup_id = j.job_type_id
where
	i.organization_id = 2 -- <?s:org_id.toPStmtString()?>
	and i.status_id = 2 -- <?r:status_inv:status_id.toPStmtString()?>
	and (j.billing_user_id = 2250 OR 'true' = 'true') -- <?s:user_id.toPStmtString()?> OR 'true' = <?s:rights.view_all_jobs.view.toPStmtString()?>)
GROUP BY 
	i.invoice_id,
	i_trk.invoice_id_trk,
	i.description,
	invoice_type.name,
	i.status_id,
	j.customer_name,
	j.end_user_name,
	i.job_id,
	u.first_name,
	u.last_name,
	job_no,
	ib.name,
	i.date_sent,
	i.po_no,
	i.date_created,
	jt.name
order by
	i.invoice_id