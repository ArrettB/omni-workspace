select
    data.custom_tot,
	data.hours_total,
	data.exp_tot,
    data.ext_batch_id,
	data.total_tot,	
	data.assigned_to_name,
	data.job_no,
	data.job_id,	
	data.batch_status_id,
	data.batch_status_name,
	data.invoice_id_trk,
	data.invoice_id,
	data.invoice_description,
	data.invoice_type_name,
	data.invoice_status_id,
	data.date_sent,
	data.customer_name,
	data.end_user_name,
	data.job_type_name,
	data.po_no,
	data.readonly,
	data.invoice_date_created
from
(select
	cli.ct custom_tot,
	cli.ht hours_total,
	cli.et exp_tot,
    i.ext_batch_id,
	cli.ct + cli.ht + cli.et total_tot,	
	au.first_name + ' ' + au.last_name assigned_to_name,
	j.job_no,
	j.job_id,	
	ib.status_id batch_status_id,
	ib.name batch_status_name,
	convert(varchar, i.invoice_id) + 
	case
		when iv.invoice_id is null then ''
		else '*'
	end invoice_id_trk,
	i.invoice_id,
	i.description invoice_description,
	tl.name invoice_type_name,
	i.status_id invoice_status_id,
	CONVERT(VARCHAR(12), i.date_sent, 101) date_sent,
	case l.code
		when 'end_user' then pc.customer_name
		else c.customer_name
	end customer_name,
	case l.code
		when 'end_user' then c.customer_name
		else eu.customer_name
	end end_user_name,
	jt.name job_type_name,
	i.po_no,
	case ib.status_id
		when -1 then 'false'
		else 'true'
	end readonly,
	i.date_created invoice_date_created
from
	invoices i
	join (
		select
			il.invoice_id,
            sum(
            case
				when it.code = 'custom' then il.unit_price * il.qty else 0 end) ct,
            sum(
            case
				when it.code = 'system' and imt.code = 'hours' then il.unit_price * il.qty else 0 end) ht,
            sum(
            case
				when it.code = 'system' and imt.code = 'expense' then il.unit_price * il.qty
				else 0
			end) et
		from
			invoice_lines il
			left join items im on
				il.item_id = im.item_id
			left join lookups it on
				il.invoice_line_type_id = it.lookup_id
			left join lookups imt on
				im.item_type_id = imt.lookup_id
        group by
            il.invoice_id) cli on
		i.invoice_id = cli.invoice_id
	join jobs j on
		i.job_id = j.job_id
	left join invoice_tracking iv on
		i.invoice_id = iv.invoice_id
	left join users au on
		i.assigned_to_user_id = au.user_id
	join invoice_batch_statuses ib on
		ib.status_id = i.batch_status_id
	left join lookups tl on
		i.invoice_type_id = tl.lookup_id
	join customers c on
		c.customer_id = j.customer_id
	left join lookups l on
		c.customer_type_id = l.lookup_id
	left join (
		select
			j.job_id,
			customer_name
		from
			customers c
			join jobs j on
				c.customer_id = j.end_user_id
		where
			j.end_user_id is not null) eu on
		j.job_id = eu.job_id
	left join customers pc on
		c.end_user_parent_id = pc.customer_id
	join lookups jt on
		jt.lookup_id = j.job_type_id
where
	i.organization_id = 2 -- <?s:org_id.toPStmtInt()?>
	 and i.status_id = 4 -- <?r:status_inv:status_id.toPStmtInt()?>
group by
	i.invoice_id,
	j.job_no,
	j.job_id,
	i.description,
	iv.invoice_id,
	au.first_name,
	au.last_name,
	ib.status_id,
	ib.name,
	tl.name,
	i.status_id,
	i.date_sent,
	l.code,
	c.customer_name,
	eu.customer_name,
	pc.customer_name,
	jt.name,
	i.po_no,
	i.date_created,
	i.ext_batch_id,
    cli.ht,
    cli.ct,
    cli.et) data
order by
	invoice_id desc