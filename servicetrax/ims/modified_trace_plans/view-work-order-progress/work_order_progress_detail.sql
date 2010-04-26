select
    project_id,
    request_id,
    project_no,
    workorder_no,
    dealer_name,
    customer_name,
    request_status_type_name,
    min_start_date,
    max_end_date,
    punchlist_flag,
    percent_complete
from
(select
    p.project_id,
    r.request_id,
    p.project_no,
    convert(varchar, p.project_no) + '-' + convert(varchar, r.request_no) workorder_no,
    c.dealer_name,
    case ct.code
        when 'end_user' then cp.customer_name else c.customer_name
    end customer_name,
    rs.name request_status_type_name,
    md.min_start_date,
    md.max_end_date,
    case
        when pl.punchlist_id is null then 'n'
        else 'y'
    end punchlist_flag,
    case md.duration
        when 0 then null
        else Round((md.duration - md.current_duration) / md.duration, 2)
    end percent_complete,
    r.request_no
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
    join lookups ps on
        ps.lookup_id = p.project_status_type_id
    left join lookups ct on
        c.customer_type_id = ct.lookup_id
    left join customers cp on
        c.end_user_parent_id = cp.customer_id
    left join punchlists pl on
        r.request_id = pl.request_id
    join (
        select
            imd.request_id,
            imd.min_start_date,
            imd.max_end_date,
            convert(numeric, datediff(hour, getdate(), imd.max_end_date + 1)) current_duration,
            convert(numeric, datediff(hour, imd.min_start_date, imd.max_end_date + 1)) duration
        from
        (select
            r.request_id,
            min(IsNull(act_start_date, IsNull(sch_start_date, r.est_start_date))) min_start_date,
            max(IsNull(act_end_date, IsNull(sch_end_date, r.est_end_date))) max_end_date
        from
            requests r
            left join request_vendors rv on
                r.request_id = rv.request_id
        group by
            r.request_id) imd) md on
        r.request_id = md.request_id
where
    c.organization_id = 2 -- <?s:org_id.toPStmtString()?>
    and rt.code = 'workorder'
    and ps.code <> 'folder_closed'
    and rs.code <> 'closed') data
order by
    data.project_no desc,
    data.request_no