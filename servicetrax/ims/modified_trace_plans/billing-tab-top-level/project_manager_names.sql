select
	ub.billing_user_name,
	ub.billing_user_name
from
(
	select
		u.first_name + ' ' + u.last_name billing_user_name
from
	service_lines sl
	join jobs j on
		j.job_id = sl.bill_job_id	
	left join users u on
		u.user_id = j.billing_user_id
	left join invoices i on
		i.invoice_id = sl.invoice_id
	left join invoice_lines il on
		i.invoice_id = il.invoice_id
where
	(billing_user_id = 2250 OR 'true' = 'true') -- <?s:user_id.toPStmtString()?> OR 'true' = <?s:rights.view_all_jobs.view.isNull('false').toPStmtString()?>
	and sl.organization_id = 2 -- <?s:org_id.toPStmtString()?>
	and (i.status_id = 1 OR i.status_id IS NULL)
	and sl.status_id = 4
	and sl.internal_req_flag = 'N') ub
group by
	ub.billing_user_name
order by
	ub.billing_user_name