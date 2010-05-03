/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_CREDIT_REPORT]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_CRYSTAL_CREDIT_REPORT]
	@company varchar(25)
AS
declare @sqlstmt nvarchar(4000)
select @sqlStmt = 'use ' + @company + char(10)
select @sqlStmt = @sqlStmt + 'SELECT dbo.SOP30200.SOPNUMBE, dbo.SOP30200.CUSTNMBR, dbo.SOP30200.CUSTNAME, dbo.SOP30200.DOCAMNT, 
                      dbo.SOP30200.DOCDATE, dbo.SOP10106.USERDEF1, dbo.SOP10106.USRDEF03, dbo.SOP10106.USRDEF05, dbo.SOP10106.CMMTTEXT, dbo.SY03900.TXTFIELD
				FROM dbo.SOP30200 LEFT OUTER JOIN
                      dbo.SY03900 ON dbo.SOP30200.NOTEINDX = dbo.SY03900.NOTEINDX LEFT OUTER JOIN
                      dbo.SOP10106 ON dbo.SOP30200.SOPTYPE = dbo.SOP10106.SOPTYPE AND dbo.SOP30200.SOPNUMBE = dbo.SOP10106.SOPNUMBE
WHERE     (dbo.SOP30200.SOPTYPE = 4)'
exec sp_executesql @sqlStmt
GO
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_AMEX_PENDING]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_CRYSTAL_AMEX_PENDING]
	@company varchar(5)
AS
declare @sqlstmt nvarchar(4000)
select @sqlStmt = 'use ' + @company + char(10)
select @sqlStmt = @sqlStmt + 'SELECT     SOP10100.SOPTYPE, SOP10100.SOPNUMBE, SOP10106.USERDEF1, SOP10106.USERDEF2, SOP10106.USRDEF03, SOP10106.USRDEF04, 
                      SOP10106.USRDEF05, SOP10106.CMMTTEXT, SOP10100.DOCDATE, SOP10100.BACHNUMB, SOP10100.DOCAMNT
FROM         SOP10100 INNER JOIN
                      SOP10106 ON SOP10100.SOPTYPE = SOP10106.SOPTYPE AND SOP10100.SOPNUMBE = SOP10106.SOPNUMBE
WHERE     (SOP10100.BACHNUMB LIKE ''AMPR%'')'
exec sp_executesql @sqlStmt
GO
/****** Object:  UserDefinedFunction [dbo].[sp_varchar20_to_number]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[sp_varchar20_to_number] (@in_value varchar(20)) RETURNS numeric(18,2)
AS
BEGIN

DECLARE @l_value varchar(20)
DECLARE @result numeric(18,2)

SET @result = 0.00

IF @in_value IS NOT NULL
  BEGIN
    SET @l_value = REPLACE(REPLACE(REPLACE(REPLACE(@in_value,' ',''),'$',''),'-',''),',','') 

    IF @l_value IS NULL
      BEGIN
        SET @result = 0.00
      END 
    ELSE IF @l_value = ''
      BEGIN
        SET @result = 0.00
      END 
    ELSE 
      BEGIN
        SET @result = CONVERT(NUMERIC(18,2), @l_value)      
      END
   END

RETURN @result

END
GO
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_UNBILLED_AGING]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_CRYSTAL_UNBILLED_AGING]
AS
set nocount on
set ansi_warnings off
declare 	@datestamp smalldatetime
set @datestamp = getdate()
create table #tbl(
	[ORGANIZATION_ID] [numeric] (19,0),
	[BILL_JOB_NO] [numeric] (19,0) ,
	[BILL_JOB_ID] [numeric] (19,0) ,
	[job_status_type_name] varchar(255) ,
	[job_name] varchar(255) ,
	[BILLING_USER_ID] [numeric](19, 5),
	[EXT_DEALER_ID] char(255) ,
	[DEALER_NAME] varchar(255) ,
	[CUSTOMER_NAME] varchar(255) ,
	[job_owner] varchar(500) ,
	[billable_total] [numeric](19, 5) ,
	[non_billable_total] [numeric](19, 5),
	[PO_NO] varchar(100),
	[PooledTotal] [numeric](19, 5),
	[UnbilledOpsInvoicesTotal] numeric(19,5)

) 

create table #tbl2(
	tc_job_no numeric(19,0),
	pooledSum numeric(19,5)	
)

create table #tbl3(
	tc_job_no numeric(19,0),
	unbilledOpsInvoicesSum numeric(19,5)	
)

create table #tbl4(
	tc_job_no numeric(19,0),
	totalUnbilledInvoices numeric(19,5)	
)

/*Pooled Totals*/
insert into #tbl2
select distinct tc_job_no, (select sum(sum_bill_total) from jobs_not_billed_v
		   	WHERE 	internal_req_flag like 'Y'
				AND fully_allocated_flag like 'N' and tc_job_no=t1.tc_job_no) pooledSum
				from jobs_not_billed_v t1
		   	WHERE 	internal_req_flag like 'Y'
				AND fully_allocated_flag like 'N' 
	group by tc_job_no, sum_bill_total

/*Unbilled Ops - Invoices (ready to be sent to GP)*/
insert into #tbl4
SELECT job_no, sum(bill_total + custom_line_total) total_total
	FROM invoice_pre_total_v
	WHERE invoice_status_id =1 
	GROUP BY invoice_id, invoice_id_trk, invoice_description, invoice_type_name, invoice_status_id, ext_dealer_id, dealer_name,  customer_name, job_id, po_no, billing_user_name, job_no
	ORDER BY invoice_id

/*Unbilled Ops - Invoices DISTINCT Records (Grand Totals) */
insert into #tbl3
select distinct tc_job_no, (select sum(totalUnbilledInvoices) from #tbl4 where tc_job_no=t1.tc_job_no)
from #tbl4 t1

insert into #tbl 
select dbo.BILLING_V_DAILYREPORTCAPTURE.ORGANIZATION_ID, dbo.BILLING_V_DAILYREPORTCAPTURE.BILL_JOB_NO, dbo.BILLING_V_DAILYREPORTCAPTURE.BILL_JOB_ID, dbo.BILLING_V_DAILYREPORTCAPTURE.job_status_type_name, 
                      dbo.BILLING_V_DAILYREPORTCAPTURE.job_name, dbo.BILLING_V_DAILYREPORTCAPTURE.BILLING_USER_ID, dbo.BILLING_V_DAILYREPORTCAPTURE.EXT_DEALER_ID, dbo.BILLING_V_DAILYREPORTCAPTURE.DEALER_NAME, 
                      dbo.BILLING_V_DAILYREPORTCAPTURE.CUSTOMER_NAME, cast(dbo.BILLING_V_DAILYREPORTCAPTURE.billing_user_name AS varchar) AS job_owner, 
                      SUM(CASE BILLING_V_DAILYREPORTCAPTURE.billable_flag WHEN 'Y' THEN bill_total ELSE 0 END) billable_total, SUM(CASE BILLING_V_DAILYREPORTCAPTURE.billable_flag WHEN 'N' THEN bill_total ELSE 0 END)
                      non_billable_total, dbo.BILLING_V_DAILYREPORTCAPTURE.PO_NO,isnull(pooledSum,0),isnull(unbilledOpsInvoicesSum,0)
FROM         dbo.BILLING_V_DAILYREPORTCAPTURE 
				left outer join #tbl2 on #tbl2.tc_job_no=BILLING_V_DAILYREPORTCAPTURE.BILL_JOB_NO
				left outer join #tbl3 on #tbl3.tc_job_no=BILLING_V_DAILYREPORTCAPTURE.BILL_JOB_NO
WHERE     (dbo.BILLING_V_DAILYREPORTCAPTURE.invoice_status_id = 1 OR
                      dbo.BILLING_V_DAILYREPORTCAPTURE.invoice_status_id IS NULL) AND status_id = 4 
GROUP BY dbo.BILLING_V_DAILYREPORTCAPTURE.ORGANIZATION_ID, dbo.BILLING_V_DAILYREPORTCAPTURE.BILL_JOB_ID, dbo.BILLING_V_DAILYREPORTCAPTURE.BILL_JOB_NO, dbo.BILLING_V_DAILYREPORTCAPTURE.BILLING_USER_ID, 
                      dbo.BILLING_V_DAILYREPORTCAPTURE.DEALER_NAME, dbo.BILLING_V_DAILYREPORTCAPTURE.EXT_DEALER_ID, dbo.BILLING_V_DAILYREPORTCAPTURE.CUSTOMER_NAME, dbo.BILLING_V_DAILYREPORTCAPTURE.billing_user_name, 
                      dbo.BILLING_V_DAILYREPORTCAPTURE.job_status_type_name, dbo.BILLING_V_DAILYREPORTCAPTURE.job_name, dbo.BILLING_V_DAILYREPORTCAPTURE.PO_NO,pooledSum,unbilledOpsInvoicesSum

/* Account for unbilled ops invoices that are not in service lines table */
insert into #tbl
SELECT     ORGANIZATION_ID, JOB_NO, JOB_ID,job_status_type_name,JOB_NAME, BILLING_USER_ID, EXT_DEALER_ID, DEALER_NAME, CUSTOMER_NAME, 
                      job_owner,  
                      SUM(CASE status_id WHEN 2 THEN EXTENDED_PRICE WHEN 3 THEN EXTENDED_PRICE ELSE 0 END) AS BILLABLE_TOTAL,0 as non_billable_total,PO_NO,pooledSum,unbilledOpsInvoicesSum
FROM         (SELECT     JOBS_V.ORGANIZATION_ID, JOBS_V.JOB_NO, JOBS_V.JOB_ID, JOBS_V.job_status_type_name, JOBS_V.JOB_NAME, 
                                              JOBS_V.BILLING_USER_ID, JOBS_V.EXT_DEALER_ID, JOBS_V.DEALER_NAME, JOBS_V.CUSTOMER_NAME, 
                                              JOBS_V.billing_user_name AS job_owner, INVOICE_LINES.PO_NO, 
                                              INVOICES.STATUS_ID, INVOICE_LINES.EXTENDED_PRICE,isnull(pooledSum,0) pooledSum,isnull(unbilledOpsInvoicesSum,0) unbilledOpsInvoicesSum
                       FROM          INVOICE_LINES INNER JOIN
                                              INVOICES ON INVOICE_LINES.INVOICE_ID = INVOICES.INVOICE_ID RIGHT OUTER JOIN
                                              JOBS_V ON INVOICES.JOB_ID = JOBS_V.JOB_ID
																							left outer join #tbl2 on #tbl2.tc_job_no=jobs_v.job_no
																		  				left outer join #tbl3 on #tbl3.tc_job_no=jobs_v.job_no
						GROUP BY JOBS_V.ORGANIZATION_ID, JOBS_V.JOB_NO, JOBS_V.JOB_ID, JOBS_V.job_status_type_name, JOBS_V.JOB_NAME, JOBS_V.BILLING_USER_ID, 
                      JOBS_V.EXT_DEALER_ID, JOBS_V.DEALER_NAME, JOBS_V.CUSTOMER_NAME, JOBS_V.billing_user_name, INVOICES.STATUS_ID, 
                      INVOICE_LINES.EXTENDED_PRICE, INVOICE_LINES.PO_NO,pooledSum,unbilledOpsInvoicesSum
                       HAVING      (JOBS_V.JOB_NO in (select tc_job_no from #tbl3)) AND (INVOICES.STATUS_ID IN (1, 2, 3))) a
where JOB_NO not in (select bill_job_no from #tbl)
GROUP BY ORGANIZATION_ID, JOB_NO, job_status_type_name, JOB_ID, JOB_NAME, BILLING_USER_ID, EXT_DEALER_ID, DEALER_NAME, 
                      CUSTOMER_NAME, job_owner, PO_NO,pooledSum,unbilledOpsInvoicesSum

--Account for null job_owners which happen from time to time for unknown reason
update #tbl set job_owner='' where job_owner is null
update #tbl set BILLING_USER_ID=-999 where BILLING_USER_ID is null

select 	#tbl.[ORGANIZATION_ID],
	[BILL_JOB_NO] ,
	[BILL_JOB_ID] ,
	[job_status_type_name],
	[job_name] ,
	[BILLING_USER_ID],
	[EXT_DEALER_ID] ,
	[DEALER_NAME] ,
	[CUSTOMER_NAME] ,
	[job_owner] ,'','',
	[billable_total] ,
	[non_billable_total],
	[PO_NO] ,
	[PooledTotal] ,
	[UnbilledOpsInvoicesTotal],NAME,ltrim(str(month(@datestamp))) + '/' + ltrim(str(day(@datestamp))) + '/' + ltrim(str(year(@datestamp))) DATEREPORTRUN from #tbl
inner join ORGANIZATIONS on ORGANIZATIONS.ORGANIZATION_ID=#tbl.ORGANIZATION_ID

drop table #tbl
drop table #tbl2
drop table #tbl3
drop table #tbl4
GO
/****** Object:  UserDefinedFunction [dbo].[getShortName]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION [dbo].[getShortName] (@val as varchar(100))  
RETURNS varchar(12)  AS  
BEGIN

DECLARE @index AS integer
DECLARE @result AS varchar(12)

SET @index = charindex(' ', @val)
if (@index > 0) 
	SET @result = ( LEFT(@val, 1) + SUBSTRING(@val, @index, LEN(@val) - @index +1))
else
	SET @result = @val

return @result
END
GO
/****** Object:  UserDefinedFunction [dbo].[getSortName]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION [dbo].[getSortName] (@val as varchar(100))  
RETURNS varchar(12)  AS  
BEGIN

DECLARE @index AS integer
DECLARE @result AS varchar(12)

SET @index = charindex(' ', @val)
if (@index > 0) 
	SET @result = SUBSTRING(@val, @index+1, LEN(@val) - @index)
else
	SET @result = @val

return @result
END
GO
/****** Object:  UserDefinedFunction [dbo].[truncateDate]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION [dbo].[truncateDate] (@val as datetime)  
RETURNS datetime  AS  
BEGIN
return convert(datetime, convert(varchar, @val, 101))
END
GO
/****** Object:  StoredProcedure [dbo].[track_waitstats]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[track_waitstats] AS

IF EXISTS (SELECT 1 FROM sysobjects WHERE name = 'track_waitstats' AND type = 'P')
   DROP proc track_waitstats
GO
/****** Object:  StoredProcedure [dbo].[sp_reorder_req_no]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_reorder_req_no]
AS
BEGIN

DECLARE @request_id numeric(18,0)
DECLARE @version_no numeric(18,0)
DECLARE @request_type_id numeric(18,0)
DECLARE @quote_request_id numeric(18,0)
DECLARE @request_no numeric(18,0)
DECLARE @req CURSOR

SET @req = CURSOR FAST_FORWARD
FOR
SELECT request_id, version_no, request_type_id, quote_request_id
  FROM requests 
 WHERE project_id=65757
   AND request_no > 59
ORDER BY date_created, version_no

 
SET @request_no = 59

OPEN @req
FETCH NEXT FROM @req INTO @request_id,@version_no,@request_type_id,@quote_request_id
WHILE @@FETCH_STATUS=0
BEGIN
  PRINT @request_id
  
  IF @version_no = 1 
    IF @quote_request_id IS NULL
      BEGIN
        SET @request_no = @request_no + 1
      END

  IF @quote_request_id IS NULL
    BEGIN
	  UPDATE requests
	     SET request_no = @request_no,
	         date_modified=getdate(),
	         modified_by=1
	   WHERE request_id = @request_id
             AND quote_request_id IS NULL
    END
  ELSE
    IF @request_type_id=325
      BEGIN
	  UPDATE requests
	     SET request_no = (SELECT request_no FROM requests WHERE request_id=@quote_request_id),
	         date_modified=getdate(),
	         modified_by=1
	   WHERE request_id = @request_id
             AND quote_request_id = @quote_request_id
      END
    ELSE
      BEGIN
        UPDATE requests
	     SET request_no = @request_no,
	         date_modified=getdate(),
	         modified_by=1
	   WHERE request_id = @request_id
             AND request_type_id <> 325
      END

                             
  FETCH NEXT FROM @req INTO @request_id,@version_no,@request_type_id,@quote_request_id
END

CLOSE @req
DEALLOCATE @req

END
GO
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_OpenOrderReport]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*CREATE PROCEDURE NOW*/
create procedure [dbo].[sp_CRYSTAL_OpenOrderReport]
    (
        @DateRangeStart            datetime
        ,@DateRangeEnd             datetime
        ,@Customer                 varchar(200) = 'All'
        ,@SortBy                   varchar(200) = 'est_start_date'
        ,@SortOrder                varchar(10) = 'asc'
    )

as

set nocount on
set ansi_warnings off


/*GET FIRST SET OF DATA AND PUT IN TEMP TABLE TO USE IN DIFFERENT WAYS LATER*/
select r.project_id, r.project_no
	 , r.request_no, r.request_id
	 , r.version_no
     , r.est_start_date
     , r.est_end_date
	 , 'quote_total' = q.quote_total
     , 'EstimatedInvoiceDate' = dateadd(dd,7,r.est_end_date)
	 , 'QuotedGP' = q.quote_total - dbo.fn_StringToFloat([IND_OMNI_DIRECT_COST-TOTAL])
	 , 'QuotedGPPct' = 100*(q.quote_total - dbo.fn_StringToFloat([IND_OMNI_DIRECT_COST-TOTAL]))/case when isnull(q.quote_total,0) = 0 then null else q.quote_total end
     , 'JobNumber' = convert(varchar,r.project_no)+'-'+convert(varchar,r.request_no)+'.'+convert(varchar,r.version_no)
     , 'OmniSalesPerson' = isnull(OmniSalesPerson.contact_name,'')
     --this is used when grouped, but this ins't grouped, 'ProjectManager' = dbo.fn_ProjectManagerListPerProjectID(r.project_id)
     , 'ProjectManager' = r.a_m_contact_name
	 , 'ServiceSegment' =/*logic from katz 2007-12-18*/
				case p.project_type_name
					when 'Furniture' then 'NPI'
					when 'National Services' then 'NS'
					when 'Service Acct.' then 'MAC'
					when 'Warehousing' then 'AM'
					when 'Commercial Moving' then 'COM'
					else 'Other'
					end
--	 , 'Customer' = p.dealer_name
     , 'Customer' = p.customer_name
     , 'CustomerContactName' = customer_contact.contact_name
     , p.end_user_name
     , r.job_name
into #ReturnTable --put into temp table so it can be sorted by any column later using dynamic SQL
from requests_v as r (nolock)
	inner join projects_v as p (nolock) on r.project_id = p.project_id
	inner join quotes as q (nolock) on r.request_id = q.request_id and q.is_sent = 'y' and q.[ind_omni_discounted_bill-total] is not null
 	left outer join (
			select r.request_id, 'contact_name' = c.contact_name
			from requests as r (nolock)
			inner join contacts as c (nolock) on r.a_m_sales_contact_id = c.contact_id
			) as OmniSalesPerson on r.request_id = OmniSalesPerson.request_id
    left outer join contacts as customer_contact (nolock) on r.customer_contact_id = customer_contact.contact_id
where r.request_type_code = 'quote_request'
	and r.is_sent = 'y'
	and r.est_start_date >= @DateRangeStart and r.est_start_date <= @DateRangeEnd
	and isnull(p.customer_name,'') like case when @Customer = 'All' then '%' when  @Customer = 'None' then '' else @Customer end


/*take data and sort with the variable using dynamic sql*/
    --declare variable to put sql in to execute
    declare @sql varchar(1000)
    set @sql = 'select * from #ReturnTable '
			+ 'order by '+@SortBy+' '+@SortOrder+' '
    exec(@sql)



return
GO
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_QualityPerformanceReport]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*CREATE PROCEDURE NOW*/
create procedure [dbo].[sp_CRYSTAL_QualityPerformanceReport]
    (
        @DateRangeStart            datetime
        ,@DateRangeEnd             datetime
        ,@JobStatus                varchar(200) = '%'
        ,@ServiceSegment           varchar(200) = '%'
        ,@SortBy                   varchar(200) = 'OmniSalesPerson'
        ,@SortOrder                varchar(10) = 'asc'
    )

as

set nocount on
set ansi_warnings off



/*START GETTING DATA*/
select s.service_id
     , 'OmniSalesPerson' = (
            select top 1 salesrep.contact_name
            from jobs as sub_j (nolock)
            inner join contacts as salesrep (nolock) on sub_j.a_m_sales_contact_id = salesrep.contact_id
            where sub_j.job_id = j.job_id
            )
     , 'ProjectManager' = project_manager.contact_name
     , 'Supervisor' = j.foreman_user_name
     , 'Customer' = p.customer_name
     , 'EndUser' = p.end_user_name
     , j.job_name
     , 'FurnitureLine' = system_furniture_line.name
     , 'ServiceSegment' = /*logic from katz 2007-12-18*/
                case p.project_type_name
                    when 'Furniture' then 'NPI'
                    when 'National Services' then 'NS'
                    when 'Service Acct.' then 'MAC'
                    when 'Warehousing' then 'AM'
                    when 'Commercial Moving' then 'COM'
                    else 'Other'
                    end
     , 'JobNumber' = convert(varchar,p.project_no)+'-'+convert(varchar,s.service_no)
     , 'request_is_sent_date' = qr.is_sent_date
     , 'quote_date_modified' = q.date_modified
     , q.quote_total
     , 'quote_DirectCostTotal' = dbo.fn_StringToFloat(q.[IND_OMNI_DIRECT_COST-TOTAL])
     , 'service_est_start_date' = s.est_start_date
     , 'service_est_end_date' = s.est_end_date
     , change_order.change_order_qty
     , change_order.change_order_total
     , 'total_invoiced' = (
                /*GETTING TOTAL INVOICED ATTACHED TO A SERVICE*/
                select sum(ti_sub_sl.bill_qty * ti_sub_il.unit_price)
                from service_lines as ti_sub_sl (nolock)
                    inner join invoice_lines as ti_sub_il (nolock) on ti_sub_sl.invoice_id = ti_sub_il.invoice_id
                where ti_sub_sl.posted_flag = 'y' and ti_sub_sl.billed_flag = 'y'
                    and ti_sub_sl.tc_job_id = j.job_id and ti_sub_sl.tc_service_id = s.service_id
                )
     , 'invoice_date_sent' = (
                select min(i_sub_i.date_sent)
                from service_lines as i_sub_sl (nolock)
                    inner join invoices as i_sub_i (nolock) on i_sub_sl.invoice_id = i_sub_i.invoice_id and i_sub_i.date_sent is not null
                where i_sub_sl.posted_flag = 'y' and i_sub_sl.billed_flag = 'y'
                    and i_sub_sl.tc_job_id = j.job_id and i_sub_sl.tc_service_id = s.service_id
                )
     , 'total_costs' = (
                /*GETTING TOTAL COSTS ATTACHED TO A SERVICE -- DOES NOT INCLUDE POSTED COSTS*/
                select sum(tc_sub_sl.bill_qty * tc_sub_i.cost_per_uom)
                from service_lines as tc_sub_sl (nolock)
                    inner join items as tc_sub_i (nolock) on tc_sub_sl.item_id = tc_sub_i.item_id
                where tc_sub_sl.posted_flag = 'y' and tc_sub_sl.billed_flag = 'y'
                    and tc_sub_sl.tc_job_id = j.job_id and tc_sub_sl.tc_service_id = s.service_id
                )
into #tmpData
from jobs_v as j (nolock)
    inner join projects_v as p (nolock) on j.project_id = p.project_id
    inner join services as s (nolock) on j.job_id = s.job_id
    /*bring in quote request info*/
    inner join requests as sr (nolock) on s.request_id = sr.request_id and sr.is_sent = 'y' and sr.request_type_id = 325--service request
    inner join requests as qr (nolock) on sr.quote_request_id = qr.request_id and qr.is_sent = 'y' and qr.request_type_id = 324--quote request
    left outer join lookups as system_furniture_line (nolock) on sr.system_furniture_line_type_id = system_furniture_line.lookup_id
    left outer join contacts as project_manager (nolock) on sr.a_m_contact_id = project_manager.contact_id
    /*bring in quote info*/
    inner join quotes as q on s.quote_id = q.quote_id and q.is_sent = 'y' and q.[ind_omni_discounted_bill-total] is not null
    left outer join (
            /*bring in change order data*/
            select s.service_id, 'change_order_qty' = count(*), 'change_order_total' = sum(q.quote_total)
            from services as s (nolock) 
                inner join requests as r (nolock) on s.request_id = r.request_id and r.is_sent = 'y' and r.is_quoted = 'y'
                inner join lookups as order_type (nolock) on r.order_type_id = order_type.lookup_id and order_type.code = 'change_order'
                inner join quotes as q (nolock) on s.quote_id = q.quote_id
            group by s.service_id having isnull(sum(q.quote_total),0) > 0
        ) as change_order on s.service_id = change_order.service_id
where isnull(j.job_status_type_name,'') like case when @JobStatus = 'All' then '%' else @JobStatus end
    and s.est_start_date between @DateRangeStart and @DateRangeEnd

/*getting variances and other calculations from the temp table data*/
select service_id
     , OmniSalesPerson
     , ProjectManager
     , Supervisor
     , Customer
     , EndUser
     , job_name
     , FurnitureLine
     , ServiceSegment
     , JobNumber
     , request_is_sent_date
     , quote_date_modified
     , quote_total
     , quote_DirectCostTotal
     , service_est_start_date
     , service_est_end_date
     , change_order_qty
     , change_order_total
     , total_invoiced
     , invoice_date_sent
     , total_costs
        /*calculate turn times*/
     , 'TurnTime_Min_Request_to_Quote' = datediff(mi,request_is_sent_date,quote_date_modified)
     , 'TurnTime_Hr_Request_to_ServiceStart' = datediff(hh,request_is_sent_date,service_est_start_date)
     , 'TurnTime_Day_JobEnd_to_Invoice' = datediff(dd,service_est_end_date,invoice_date_sent)
        /*calculate margins*/
     , 'EstimatedGrossMargin' = 100 * (quote_total - quote_DirectCostTotal) / case when isnull(quote_total,0) = 0 then null else quote_total end
        --NOTE: THIS ACTUALGROSSMARGIN DOES NOT INCLUDE NON-POSTED COSTS
     , 'ActualGrossMargin' = 100 * (total_invoiced - total_costs) / case when isnull(total_invoiced,0) = 0 then null else total_invoiced end
        /*calculate variances*/
     , 'variance_quote_invoice' = isnull(quote_total,0) - isnull(total_invoiced,0)
     , 'variance_quote_invoice_gm' = isnull((100 * (quote_total - quote_DirectCostTotal) / case when isnull(quote_total,0) = 0 then null else quote_total end),0) --quote margin
                                   - isnull((100 * (total_invoiced - total_costs) / case when isnull(total_invoiced,0) = 0 then null else total_invoiced end),0) --actual margin with no posted costs included
into #ReturnTable
from #tmpData


/*take data and sort with the variable using dynamic sql*/
    /*declare variable to put sql in to execute*/
    declare @sql varchar(1000)
    set @sql = 'select * from #ReturnTable '
             + 'where ServiceSegment like '''+case when @ServiceSegment = 'All' then '%' else @ServiceSegment end +''' '
             + 'order by '+@SortBy+' '+@SortOrder
    exec(@sql)



return
GO
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_AR_UNBILLED_REPORT]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_CRYSTAL_AR_UNBILLED_REPORT]
	@company varchar(5)
AS
declare @sqlstmt nvarchar(4000)
select @sqlStmt = 'SELECT   ISNULL(dbo.TIME_CAPTURE_V.PAYROLL_QTY, 0) - ISNULL(dbo.TIME_CAPTURE_V.BILL_HOURLY_QTY, 0) AS hours_difference, 
                      CAST(dbo.JOBS_V.JOB_NO AS VARCHAR) AS job_no_varchar, dbo.TIME_CAPTURE_V.ORGANIZATION_ID, dbo.TIME_CAPTURE_V.TC_JOB_NO, 
                      dbo.TIME_CAPTURE_V.TC_SERVICE_NO, dbo.TIME_CAPTURE_V.TC_SERVICE_LINE_NO, dbo.TIME_CAPTURE_V.ITEM_NAME, 
                      dbo.TIME_CAPTURE_V.TC_JOB_ID, dbo.TIME_CAPTURE_V.TC_SERVICE_ID, dbo.TIME_CAPTURE_V.PH_SERVICE_ID, 
                      dbo.TIME_CAPTURE_V.SERVICE_LINE_ID, dbo.TIME_CAPTURE_V.SERVICE_LINE_DATE, dbo.TIME_CAPTURE_V.STATUS_ID, 
                      dbo.TIME_CAPTURE_V.status_name, dbo.TIME_CAPTURE_V.RESOURCE_ID, dbo.TIME_CAPTURE_V.ITEM_ID, dbo.TIME_CAPTURE_V.TC_QTY, 
                      dbo.TIME_CAPTURE_V.TC_RATE, dbo.TIME_CAPTURE_V.TC_TOTAL, dbo.TIME_CAPTURE_V.PAYROLL_QTY, dbo.TIME_CAPTURE_V.EXT_PAY_CODE, 
                      dbo.RESOURCES_V.EXT_EMPLOYEE_ID, dbo.RESOURCES_V.USER_ID, dbo.JOBS_V.CUSTOMER_ID, dbo.JOBS_V.CUSTOMER_NAME, 
                      dbo.JOBS_V.FOREMAN_RESOURCE_ID, dbo.JOBS_V.foreman_resource_name, dbo.JOBS_V.JOB_NAME, dbo.RESOURCES_V.resource_name, 
                      dbo.RESOURCES_V.resource_type_name, dbo.RESOURCES_V.RESOURCE_TYPE_ID, 
dbo.JOBS_V.billing_user_name, left(isnull(rtrim('
 + @company +'..GL00100.ACTNUMBR_1),'''') + ''-'' +
isnull(rtrim(' + @company + '..GL00100.ACTNUMBR_2),'''') + 
	''-'' + isnull(rtrim(' + @company +'..GL00100.ACTNUMBR_3),'''') + ''-'' + 
isnull(rtrim(' + @company + '..GL00100.ACTNUMBR_4), '''') + 
	''-'' + isnull(rtrim(' + @company + '..GL00100.ACTNUMBR_5),''''),13) as ACTNUM
FROM         dbo.RESOURCES_V RIGHT OUTER JOIN
                      dbo.TIME_CAPTURE_V ON dbo.RESOURCES_V.RESOURCE_ID = dbo.TIME_CAPTURE_V.RESOURCE_ID LEFT OUTER JOIN
                      dbo.JOBS_V ON dbo.TIME_CAPTURE_V.TC_JOB_ID = dbo.JOBS_V.JOB_ID
inner join ' + @company + '..IV00101 on ITEM_NAME=' + @company + '..IV00101.ITMSHNAM
inner join ' + @company + '..GL00100 on ' + @company + '..IV00101.IVSLSIDX = ' + 
@company + '..GL00100.ACTINDX'
exec sp_executesql @sqlStmt 
--print @sqlStmt
GO
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_JobEfficiencyReport]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*CREATE PROCEDURE NOW*/
create procedure [dbo].[sp_CRYSTAL_JobEfficiencyReport]
    (
        @DateRangeStart            datetime
        ,@DateRangeEnd             datetime
        ,@JobStatus                varchar(200) = '%'
        ,@ServiceSegment           varchar(200) = '%'
        ,@SortBy                   varchar(200) = 'JobNumber'
        ,@SortOrder                varchar(10) = 'asc'
    )

as

set nocount on
set ansi_warnings off


/*GET BASE QUERY RESULTS*/
select *
     , 'Variance_CompleteToNatlHrs' = case when isnull(data.ActualToComplete_TotalHours,0) - isnull(data.NationalStd_TotHrs,0) = 0 then null else isnull(data.ActualToComplete_TotalHours,0) - isnull(data.NationalStd_TotHrs,0) end
     , 'Variance_CompleteToRocHrs' = case when isnull(data.ActualToComplete_TotalHours,0) - isnull(data.ROC_TotHrs,0) = 0 then null else isnull(data.ActualToComplete_TotalHours,0) - isnull(data.ROC_TotHrs,0) end
     , 'Variance_CompleteToQuoteHrs' = case when isnull(data.ActualToComplete_TotalHours,0) - isnull(data.Omni_TotHrs,0) = 0 then null else isnull( data.ActualToComplete_TotalHours,0) - isnull(data.Omni_TotHrs,0) end
     , 'Variance_Whse_ActualToEst' = case when isnull(data.ActualToComplete_WarehouseHours,0) - isnull(data.Omni_WhseHrs,0) = 0 then null else isnull(data.ActualToComplete_WarehouseHours,0) - isnull(data.Omni_WhseHrs,0) end
     , 'Variance_Dlvry_ActualToEst' = case when isnull(data.ActualToComplete_DeliveryHours,0) - isnull(data.Omni_DlvryHrs,0) = 0 then null else isnull(data.ActualToComplete_DeliveryHours,0) - isnull(data.Omni_DlvryHrs,0) end
     , 'Variance_Instl_ActualToEst' = case when isnull(data.ActualToComplete_InstallationHours,0) - isnull(data.Omni_InstlHrs,0) = 0 then null else isnull(data.ActualToComplete_InstallationHours,0) - isnull(data.Omni_InstlHrs,0) end
into #ReturnTable --put data into temp table for sorting later
from (--break out into inline view to calculate variances 
        select  j.job_id 
             , 'JobStatus' = max(j.job_status_type_name)
             , 'ServiceSegment' = max(j.job_type_name)
             , 'date_created' = max(j.date_created)
             , 'est_start_date' = min(s.est_start_date)
             , 'est_end_date' = max(s.est_end_date)
             , 'OmniSalesPerson' = (
                            select top 1 salesrep.contact_name
                            from jobs as sub_j (nolock)
                            inner join contacts as salesrep (nolock) on sub_j.a_m_sales_contact_id = salesrep.contact_id
                            where sub_j.job_id = j.job_id
                            )
             , 'ProjectManager' = dbo.fn_ProjectManagerListPerProjectID(j.project_id)
             , 'Supervisor' =  max(j.foreman_user_name)
--             , 'Customer' = max(j.dealer_name)
             , 'Customer' = max(p.customer_name)
             , 'EndUser' = max(p.end_user_name)
             , 'FurnitureLine' = dbo.fn_FurnitureLineListPerProjectID(j.project_id)
             , 'JobNumber' = convert(varchar,j.job_no)
                --------------------------------------
             , 'NationalStd_WhseHrs' = case when sum(quotehours.NationalStd_WhseHrs) = 0 then NULL else sum(quotehours.NationalStd_WhseHrs) end
             , 'NationalStd_DlvryHrs' = case when sum(quotehours.NationalStd_DlvryHrs) = 0 then NULL else sum(quotehours.NationalStd_DlvryHrs) end
             , 'NationalStd_InstlHrs' = case when sum(quotehours.NationalStd_InstlHrs) = 0 then NULL else sum(quotehours.NationalStd_InstlHrs) end
             , 'NationalStd_TotHrs' = case when sum(quotehours.NationalStd_TotHrs) = 0 then NULL else sum(quotehours.NationalStd_TotHrs) end
             , 'ROC_WhseHrs' = case when sum(quotehours.ROC_WhseHrs) = 0 then NULL else sum(quotehours.ROC_WhseHrs) end
             , 'ROC_DlvryHrs' = case when sum(quotehours.ROC_DlvryHrs) = 0 then NULL else sum(quotehours.ROC_DlvryHrs) end
             , 'ROC_InstlHrs' = case when sum(quotehours.ROC_InstlHrs) = 0 then NULL else sum(quotehours.ROC_InstlHrs) end
             , 'ROC_TotHrs' = case when sum(quotehours.ROC_TotHrs) = 0 then NULL else sum(quotehours.ROC_TotHrs) end
             , 'Omni_WhseHrs' = case when sum(quotehours.Omni_WhseHrs) = 0 then NULL else sum(quotehours.Omni_WhseHrs) end
             , 'Omni_DlvryHrs' = case when sum(quotehours.Omni_DlvryHrs) = 0 then NULL else sum(quotehours.Omni_DlvryHrs) end
             , 'Omni_InstlHrs' = case when sum(quotehours.Omni_InstlHrs) = 0 then NULL else sum(quotehours.Omni_InstlHrs) end
             , 'Omni_TotHrs' = case when sum(quotehours.Omni_TotHrs) = 0 then NULL else sum(quotehours.Omni_TotHrs) end
                --------------------------------------
             , 'ActualToComplete_WarehouseHours' = (--USING A CORRELATED SUBQUERY TO QUICKLY GET THE ACTUAL HOURS
                        select convert(decimal(10,1),sum(sub_sl.tc_qty))
                        from service_lines as sub_sl (nolock)
                            inner join items_reporting_type as sub_irt (nolock) on sub_sl.item_name = sub_irt.item_name and sub_irt.reporting_type = 'warehouse'
                        where sub_sl.item_type_code = 'hours' and sub_sl.tc_job_id = j.job_id
                        )
             , 'ActualToComplete_DeliveryHours' = (--USING A CORRELATED SUBQUERY TO QUICKLY GET THE ACTUAL HOURS
                        select convert(decimal(10,1),sum(sub_sl.tc_qty))
                        from service_lines as sub_sl (nolock)
                            inner join items_reporting_type as sub_irt (nolock) on sub_sl.item_name = sub_irt.item_name and sub_irt.reporting_type = 'delivery'
                        where sub_sl.item_type_code = 'hours' and sub_sl.tc_job_id = j.job_id
                        )
             , 'ActualToComplete_InstallationHours' = (--USING A CORRELATED SUBQUERY TO QUICKLY GET THE ACTUAL HOURS
                        select convert(decimal(10,1),sum(sub_sl.tc_qty))
                        from service_lines as sub_sl (nolock)
                            inner join items_reporting_type as sub_irt (nolock) on sub_sl.item_name = sub_irt.item_name and sub_irt.reporting_type = 'installation'
                        where sub_sl.item_type_code = 'hours' and sub_sl.tc_job_id = j.job_id
                        )
             , 'ActualToComplete_TotalHours' = (--USING A CORRELATED SUBQUERY TO QUICKLY GET THE ACTUAL HOURS
                        select convert(decimal(10,1),sum(sub_sl.tc_qty))
                        from service_lines as sub_sl (nolock)
                            inner join items_reporting_type as sub_irt (nolock) on sub_sl.item_name = sub_irt.item_name
                        where sub_sl.item_type_code = 'hours' and sub_sl.tc_job_id = j.job_id
                        )
        from jobs_v as j (nolock)
            inner join projects_v as p (nolock) on j.project_id = p.project_id
            inner join services as s (nolock) on j.job_id = s.job_id and s.est_start_date between @DateRangeStart and @DateRangeEnd
            inner join (
                    --BRING IN INFORMATION FROM QUOTES TABLE
                    select q.quote_id
                         , 'NationalStd_WhseHrs' = convert(decimal(10,1),sum(isnull(dbo.fn_StringToFloat(q.[IND_INDUSTRY_STD_HOURS-RECEIVE]),0)+isnull(dbo.fn_StringToFloat(q.[IND_INDUSTRY_STD_HOURS-RELOAD]),0)))
                         , 'NationalStd_DlvryHrs' = convert(decimal(10,1),sum(isnull(dbo.fn_StringToFloat(q.[IND_INDUSTRY_STD_HOURS-DRIVER]),0)+isnull(dbo.fn_StringToFloat(q.[IND_INDUSTRY_STD_HOURS-TRUCK]),0)))
                         , 'NationalStd_InstlHrs' = convert(decimal(10,1),sum(isnull(dbo.fn_StringToFloat(q.[IND_INDUSTRY_STD_HOURS-ELECTRICAL]),0)+isnull(dbo.fn_StringToFloat(q.[IND_INDUSTRY_STD_HOURS-INSTALL]),0)+isnull(dbo.fn_StringToFloat(q.[IND_INDUSTRY_STD_HOURS-MOVE_STAGE]),0)+isnull(dbo.fn_StringToFloat(q.[IND_INDUSTRY_STD_HOURS-UNLOAD]),0)))
                         , 'NationalStd_TotHrs' = convert(decimal(10,1),sum(isnull(dbo.fn_StringToFloat(q.[IND_INDUSTRY_STD_HOURS-TOTAL]),0)))
                         , 'ROC_WhseHrs' = convert(decimal(10,1),sum(isnull(dbo.fn_StringToFloat(q.[ROC_OMNI_DISCOUNTED_HOURS-RECEIVE]),0)+isnull(dbo.fn_StringToFloat(q.[ROC_OMNI_DISCOUNTED_HOURS-RELOAD]),0)))
                         , 'ROC_DlvryHrs' = convert(decimal(10,1),sum(isnull(dbo.fn_StringToFloat(q.[ROC_OMNI_DISCOUNTED_HOURS-DRIVER]),0)+isnull(dbo.fn_StringToFloat(q.[ROC_OMNI_DISCOUNTED_HOURS-TRUCK]),0)))
                         , 'ROC_InstlHrs' = convert(decimal(10,1),sum(isnull(dbo.fn_StringToFloat(q.[ROC_OMNI_DISCOUNTED_HOURS-ELECTRICAL]),0)+isnull(dbo.fn_StringToFloat(q.[ROC_OMNI_DISCOUNTED_HOURS-INSTALL]),0)+isnull(dbo.fn_StringToFloat(q.[ROC_OMNI_DISCOUNTED_HOURS-MOVE_STAGE]),0)+isnull(dbo.fn_StringToFloat(q.[ROC_OMNI_DISCOUNTED_HOURS-UNLOAD]),0)))
                         , 'ROC_TotHrs' = convert(decimal(10,1),sum(isnull(dbo.fn_StringToFloat(q.[ROC_OMNI_DISCOUNTED_HOURS-TOTAL]),0)))
                         , 'Omni_WhseHrs' = convert(decimal(10,1),sum(isnull(dbo.fn_StringToFloat(q.[IND_OMNI_DISCOUNTED_HOURS-RECEIVE]),0)+isnull(dbo.fn_StringToFloat(q.[IND_OMNI_DISCOUNTED_HOURS-RELOAD]),0)))
                         , 'Omni_DlvryHrs' = convert(decimal(10,1),sum(isnull(dbo.fn_StringToFloat(q.[IND_OMNI_DISCOUNTED_HOURS-DRIVER]),0)+isnull(dbo.fn_StringToFloat(q.[IND_OMNI_DISCOUNTED_HOURS-TRUCK]),0)))
                         , 'Omni_InstlHrs' = convert(decimal(10,1),sum(isnull(dbo.fn_StringToFloat(q.[IND_OMNI_DISCOUNTED_HOURS-ELECTRICAL]),0)+isnull(dbo.fn_StringToFloat(q.[IND_OMNI_DISCOUNTED_HOURS-INSTALL]),0)+isnull(dbo.fn_StringToFloat(q.[IND_OMNI_DISCOUNTED_HOURS-MOVE_STAGE]),0)+isnull(dbo.fn_StringToFloat(q.[IND_OMNI_DISCOUNTED_HOURS-UNLOAD]),0)))
                         , 'Omni_TotHrs' = convert(decimal(10,1),sum(isnull(dbo.fn_StringToFloat(q.[IND_OMNI_DISCOUNTED_HOURS-TOTAL]),0)))
                    from quotes as q (nolock)--make sure to only get sent quotes
                    where q.is_sent = 'y'
                    group by q.quote_id
                    ) as quotehours on s.quote_id = quotehours.quote_id
        where isnull(j.job_status_type_name,'') like case when @JobStatus = 'All' then '%' else @JobStatus end
            and isnull(j.job_type_name,'') like case when @ServiceSegment = 'All' then '%' else @ServiceSegment end
            --LIMIT RESULTS TO ONLY JOBS WITH VALUES FOR A QUOTE
            and quotehours.NationalStd_WhseHrs+ quotehours.NationalStd_DlvryHrs+ quotehours.NationalStd_InstlHrs+ quotehours.NationalStd_TotHrs
              + quotehours.Omni_WhseHrs+ quotehours.Omni_DlvryHrs+ quotehours.Omni_InstlHrs+ quotehours.Omni_TotHrs
              + quotehours.ROC_WhseHrs+ quotehours.ROC_DlvryHrs+ quotehours.ROC_InstlHrs+ quotehours.ROC_TotHrs
              > 0
        group by j.job_id, j.job_no, j.project_id, p.project_no
        ) as data


/*take data and sort with the variable using dynamic sql*/
    --declare variable to put sql in to execute
    declare @sql varchar(1000)
    set @sql = 'select * from #ReturnTable order by '+@SortBy+' '+@SortOrder
    exec(@sql)

return
GO
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_JobCostReport]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*CREATE PROCEDURE NOW*/
create procedure [dbo].[sp_CRYSTAL_JobCostReport]
    (
        @DateRangeStart            datetime
        ,@DateRangeEnd             datetime
        ,@JobStatus                varchar(200) = '%'
        ,@ServiceSegment           varchar(200) = '%'
        ,@SortBy                   varchar(200) = 'JobNumber'
        ,@SortOrder                varchar(10) = 'asc'
    )

as

set nocount on

/*GET BASE QUERY RESULTS*/
select *
     , 'Variance_CompleteToNatlBill' = data.ActualToComplete_TotalBill - data.NationalStd_TotBill
     , 'Variance_CompleteToRocBill' = data.ActualToComplete_TotalBill - data.ROC_TotBill
     , 'Variance_CompleteToQuoteBill' = data.ActualToComplete_TotalBill - data.Omni_TotBill
into #ReturnTable --put data into temp table for sorting later
from (--break out into inline view to calculate variances 
        select  j.job_id 
             , 'JobStatus' = max(j.job_status_type_name)
             , 'ServiceSegment' = max(j.job_type_name)
             , 'date_created' = max(j.date_created)
             , 'est_start_date' = min(s.est_start_date)
             , 'est_end_date' = max(s.est_end_date)
             , 'OmniSalesPerson' = (
                            select top 1 salesrep.contact_name
                            from jobs as sub_j (nolock)
                            inner join contacts as salesrep (nolock) on sub_j.a_m_sales_contact_id = salesrep.contact_id
                            where sub_j.job_id = j.job_id
                            )
             , 'ProjectManager' = dbo.fn_ProjectManagerListPerProjectID(j.project_id)
             , 'Supervisor' =  max(j.foreman_user_name)
--             , 'Customer' = max(j.dealer_name)
             , 'Customer' = max(p.customer_name)
             , 'EndUser' = max(p.end_user_name)
             , 'FurnitureLine' = dbo.fn_FurnitureLineListPerProjectID(j.project_id)
             , 'JobNumber' = convert(varchar,j.job_no)
                --------------------------------------
             , 'quote_total' = sum(quotedata.quote_total)
             , 'OtherServicesTotalBill' = sum(quotedata.OtherServicesTotalBill)
             , 'NationalStd_WhseBill' = case when sum(quotedata.NationalStd_WhseBill) = 0 then NULL else sum(quotedata.NationalStd_WhseBill) end
             , 'NationalStd_DlvryBill' = case when sum(quotedata.NationalStd_DlvryBill) = 0 then NULL else sum(quotedata.NationalStd_DlvryBill) end
             , 'NationalStd_InstlBill' = case when sum(quotedata.NationalStd_InstlBill) = 0 then NULL else sum(quotedata.NationalStd_InstlBill) end
             , 'NationalStd_TotBill' = case when sum(quotedata.NationalStd_TotBill) + sum(quotedata.OtherServicesTotalBill) = 0 then NULL else sum(quotedata.NationalStd_TotBill) + sum(quotedata.OtherServicesTotalBill) end
             , 'ROC_WhseBill' = case when sum(quotedata.ROC_WhseBill) = 0 then NULL else sum(quotedata.ROC_WhseBill) end
             , 'ROC_DlvryBill' = case when sum(quotedata.ROC_DlvryBill) = 0 then NULL else sum(quotedata.ROC_DlvryBill) end
             , 'ROC_InstlBill' = case when sum(quotedata.ROC_InstlBill) = 0 then NULL else sum(quotedata.ROC_InstlBill) end
             , 'ROC_TotBill' = case when sum(quotedata.ROC_TotBill) + sum(quotedata.OtherServicesTotalBill) = 0 then NULL else sum(quotedata.ROC_TotBill) + sum(quotedata.OtherServicesTotalBill) end
             , 'Omni_WhseBill' = case when sum(quotedata.Omni_WhseBill) = 0 then NULL else sum(quotedata.Omni_WhseBill) end
             , 'Omni_DlvryBill' = case when sum(quotedata.Omni_DlvryBill) = 0 then NULL else sum(quotedata.Omni_DlvryBill) end
             , 'Omni_InstlBill' = case when sum(quotedata.Omni_InstlBill) = 0 then NULL else sum(quotedata.Omni_InstlBill) end
             , 'Omni_TotBill' = case when sum(quotedata.Omni_TotBill) + sum(quotedata.OtherServicesTotalBill) = 0 then NULL else sum(quotedata.Omni_TotBill) + sum(quotedata.OtherServicesTotalBill) end
                --------------------------------------
             , 'ActualToComplete_WarehouseBill' = (--USING A CORRELATED SUBQUERY TO QUICKLY GET THE ACTUAL HOURS
                        select sum(convert(float,sub_sl.tc_total))
                        from service_lines as sub_sl (nolock)
                            inner join items_reporting_type as sub_irt (nolock) on sub_sl.item_name = sub_irt.item_name and sub_irt.reporting_type = 'warehouse'
                        where sub_sl.item_type_code = 'hours' and sub_sl.tc_job_id = j.job_id 
                        )
             , 'ActualToComplete_DeliveryBill' = (--USING A CORRELATED SUBQUERY TO QUICKLY GET THE ACTUAL HOURS
                        select sum(convert(float,sub_sl.tc_total))
                        from service_lines as sub_sl (nolock)
                            inner join items_reporting_type as sub_irt (nolock) on sub_sl.item_name = sub_irt.item_name and sub_irt.reporting_type = 'delivery'
                        where sub_sl.item_type_code = 'hours' and sub_sl.tc_job_id = j.job_id 
                        )
             , 'ActualToComplete_InstallationBill' = (--USING A CORRELATED SUBQUERY TO QUICKLY GET THE ACTUAL HOURS
                        select sum(convert(float,sub_sl.tc_total))
                        from service_lines as sub_sl (nolock)
                            inner join items_reporting_type as sub_irt (nolock) on sub_sl.item_name = sub_irt.item_name and sub_irt.reporting_type = 'installation'
                        where sub_sl.item_type_code = 'hours' and sub_sl.tc_job_id = j.job_id 
                        )
             , 'ActualToComplete_TotalBill' = (--USING A CORRELATED SUBQUERY TO QUICKLY GET THE ACTUAL HOURS
                        select sum(convert(float,sub_sl.tc_total))
                        from service_lines as sub_sl (nolock)
                            inner join items_reporting_type as sub_irt (nolock) on sub_sl.item_name = sub_irt.item_name
                        where sub_sl.item_type_code = 'hours' and sub_sl.tc_job_id = j.job_id 
                        )
        from jobs_v as j (nolock)
            inner join projects_v as p (nolock) on j.project_id = p.project_id
            inner join services as s (nolock) on j.job_id = s.job_id and s.est_start_date between @DateRangeStart and @DateRangeEnd
            inner join (
                    --BRING IN INFORMATION FROM QUOTES TABLE
                    select q.quote_id
                         , 'quote_total' = sum(q.quote_total)
                         , 'OtherServicesTotalBill' = sum(isnull(dbo.fn_StringToFloat(q.[SPECIFY_SERVICES_BILL_1]),0) + isnull(dbo.fn_StringToFloat(q.[SPECIFY_SERVICES_BILL_2]),0) + isnull(dbo.fn_StringToFloat(q.[SPECIFY_SERVICES_BILL_3]),0) + isnull(dbo.fn_StringToFloat(q.[SPECIFY_SERVICES_BILL_4]),0) + isnull(dbo.fn_StringToFloat(q.[SPECIFY_SERVICES_BILL_5]),0) + isnull(dbo.fn_StringToFloat(q.[SPECIFY_SERVICES_BILL_6]),0) + isnull(dbo.fn_StringToFloat(q.[SPECIFY_SERVICES_BILL_7]),0))
                         , 'NationalStd_WhseBill' = sum(isnull(dbo.fn_StringToFloat(q.[IND_INDUSTRY_STD_BILL-RECEIVE]),0)+isnull(dbo.fn_StringToFloat(q.[IND_INDUSTRY_STD_BILL-RELOAD]),0))
                         , 'NationalStd_DlvryBill' = sum(isnull(dbo.fn_StringToFloat(q.[IND_INDUSTRY_STD_BILL-DRIVER]),0)+isnull(dbo.fn_StringToFloat(q.[IND_INDUSTRY_STD_BILL-TRUCK]),0))
                         , 'NationalStd_InstlBill' = sum(isnull(dbo.fn_StringToFloat(q.[IND_INDUSTRY_STD_BILL-ELECTRICAL]),0)+isnull(dbo.fn_StringToFloat(q.[IND_INDUSTRY_STD_BILL-INSTALL]),0)+isnull(dbo.fn_StringToFloat(q.[IND_INDUSTRY_STD_BILL-MOVE_STAGE]),0)+isnull(dbo.fn_StringToFloat(q.[IND_INDUSTRY_STD_BILL-UNLOAD]),0))
                         , 'NationalStd_TotBill' = sum(isnull(dbo.fn_StringToFloat(q.[IND_INDUSTRY_STD_BILL-TOTAL]),0))
                         , 'ROC_WhseBill' = sum(isnull(dbo.fn_StringToFloat(q.[ROC_INDUSTRY_STD_BILL-RECEIVE]),0)+isnull(dbo.fn_StringToFloat(q.[ROC_INDUSTRY_STD_BILL-RELOAD]),0))
                         , 'ROC_DlvryBill' = sum(isnull(dbo.fn_StringToFloat(q.[ROC_INDUSTRY_STD_BILL-DRIVER]),0)+isnull(dbo.fn_StringToFloat(q.[ROC_INDUSTRY_STD_BILL-TRUCK]),0))
                         , 'ROC_InstlBill' = sum(isnull(dbo.fn_StringToFloat(q.[ROC_INDUSTRY_STD_BILL-ELECTRICAL]),0)+isnull(dbo.fn_StringToFloat(q.[ROC_INDUSTRY_STD_BILL-INSTALL]),0)+isnull(dbo.fn_StringToFloat(q.[ROC_INDUSTRY_STD_BILL-MOVE_STAGE]),0)+isnull(dbo.fn_StringToFloat(q.[ROC_INDUSTRY_STD_BILL-UNLOAD]),0))
                         , 'ROC_TotBill' = sum(isnull(dbo.fn_StringToFloat(q.[ROC_INDUSTRY_STD_BILL-TOTAL]),0))
                         , 'Omni_WhseBill' = sum(isnull(dbo.fn_StringToFloat(q.[IND_OMNI_DISCOUNTED_BILL-RECEIVE]),0)+isnull(dbo.fn_StringToFloat(q.[IND_OMNI_DISCOUNTED_BILL-RELOAD]),0))
                         , 'Omni_DlvryBill' = sum(isnull(dbo.fn_StringToFloat(q.[IND_OMNI_DISCOUNTED_BILL-DRIVER]),0)+isnull(dbo.fn_StringToFloat(q.[IND_OMNI_DISCOUNTED_BILL-TRUCK]),0))
                         , 'Omni_InstlBill' = sum(isnull(dbo.fn_StringToFloat(q.[IND_OMNI_DISCOUNTED_BILL-ELECTRICAL]),0)+isnull(dbo.fn_StringToFloat(q.[IND_OMNI_DISCOUNTED_BILL-INSTALL]),0)+isnull(dbo.fn_StringToFloat(q.[IND_OMNI_DISCOUNTED_BILL-MOVE_STAGE]),0)+isnull(dbo.fn_StringToFloat(q.[IND_OMNI_DISCOUNTED_BILL-UNLOAD]),0))
                         , 'Omni_TotBill' = sum(isnull(dbo.fn_StringToFloat(q.[IND_OMNI_DISCOUNTED_BILL-TOTAL]),0))
                    from quotes as q (nolock)--make sure to only get sent quotes
                    where q.is_sent = 'y'
                    group by q.quote_id
                    ) as quotedata on s.quote_id = quotedata.quote_id
        where isnull(j.job_status_type_name,'') like case when @JobStatus = 'All' then '%' else @JobStatus end
            and isnull(j.job_type_name,'') like case when @ServiceSegment = 'All' then '%' else @ServiceSegment end
            --LIMIT RESULTS TO ONLY JOBS WITH VALUES FOR A QUOTE
            and quotedata.NationalStd_WhseBill + quotedata.NationalStd_DlvryBill + quotedata.NationalStd_InstlBill + quotedata.NationalStd_TotBill
              + quotedata.Omni_WhseBill + quotedata.Omni_DlvryBill + quotedata.Omni_InstlBill + quotedata.Omni_TotBill
              + quotedata.ROC_WhseBill + quotedata.ROC_DlvryBill + quotedata.ROC_InstlBill + quotedata.ROC_TotBill
              > 0
        group by j.job_id, j.job_no, j.project_id, p.project_no
        ) as data

/*take data and sort with the variable using dynamic sql*/
    --declare variable to put sql in to execute
    declare @sql varchar(1000)
    set @sql = 'select * from #ReturnTable order by '+@SortBy+' '+@SortOrder
    exec(@sql)


return
GO
/****** Object:  UserDefinedFunction [dbo].[fn_StringToFloat]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_StringToFloat] (@string varchar(200))
RETURNS float
AS
BEGIN
/**************************************************
    2007-12-05
    Created by Robert Smith for use in reporting off
    ServiceTRAX software for Omni Workspace. This
    function strips all non numeric, non decimal 
    characters from a string.
***************************************************/
    /*LOOP THROUGH STRING IF NON NUMBER OR DECIMAL CHARACTER IS FOUND*/
    while patindex('%[^0123456789.]%',@string) > 0
        begin
            /*REPLACE ORIGINAL STRING WITH TWO SUBSTRINGS BEFORE AND AFTER THE CHARACTER TO REMOVE*/
            set @string = substring(@string,1,patindex('%[^0123456789.]%',@string)-1)
                        + substring(@string,patindex('%[^0123456789.]%',@string)+1,len(@string))
        end
    /*DEAL WITH NULL VALUES*/
    select @string = convert(float,case when @string = '' then NULL else @string end)

   RETURN(@string)
END
GO
/****** Object:  StoredProcedure [dbo].[convert_date_to_time]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[convert_date_to_time]
@date datetime,   -- This is the input parameter.
@result varchar(20) OUTPUT -- This is the output parameter.
AS  

SELECT @result = convert(varchar, @date)
RETURN
GO
/****** Object:  Trigger [role_d]    Script Date: 05/03/2010 14:18:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE TRIGGER [dbo].[role_d] ON [dbo].[ROLES] 
FOR  DELETE 
AS
DECLARE @role_id as numeric;

SELECT @role_id = role_id FROM deleted
DELETE FROM role_function_rights WHERE role_id = @role_id;
GO
/****** Object:  StoredProcedure [dbo].[sp_aia_end_user]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_aia_end_user]
AS
BEGIN

DECLARE @customer_id numeric(18,0)
DECLARE @ext_customer_id char(15)
DECLARE @end_user_type_id numeric(18,0)
DECLARE @c1 CURSOR

SET @c1 = CURSOR FAST_FORWARD
FOR

select DISTINCT c.customer_id, c.ext_customer_id 
  from customers eu JOIN
       customers c ON eu.ext_dealer_id = c.ext_customer_id           
 where eu.organization_id=8 
   and c.organization_id = 8
   and eu.customer_type_id=738
   and ISNULL(eu.end_user_parent_id,0) <> c.customer_id
 and c.customer_type_id=80
 and c.ext_customer_id is not null
ORDER BY c.ext_customer_id
   
SET @end_user_type_id 
= (SELECT l.lookup_id 
     FROM lookups l INNER JOIN lookup_types lt ON l.lookup_type_id=lt.lookup_type_id
    WHERE lt.code='customer_type' AND l.code='end_user')

OPEN @c1
FETCH NEXT FROM @c1 INTO @customer_id,@ext_customer_id

WHILE @@FETCH_STATUS=0
BEGIN
  UPDATE customers 
     SET end_user_parent_id=@customer_id,
         date_modified=getdate(),
         modified_by=0
   WHERE customer_type_id = @end_user_type_id
     AND ext_dealer_id = @ext_customer_id
     AND organization_id=8
     AND end_user_parent_id <> @customer_id
     
  FETCH NEXT FROM @c1  INTO @customer_id,@ext_customer_id
END

CLOSE @c1
DEALLOCATE @c1

END
GO
/****** Object:  StoredProcedure [dbo].[sp_estimator]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_estimator]
(
	@Action		AS INT,
	@RequestID	AS INT,
	@QuoteID	AS INT,
	@Version	AS INT,
	@Sub_Version	AS INT,
	@Table_Column 	AS VARCHAR(200),
	@Value 		AS VARCHAR(200)	
)
AS
BEGIN

	SET NOCOUNT OFF

	DECLARE @Query AS VARCHAR(2500)
	DECLARE @quote_status_saved numeric(18,0)
	DECLARE @quote_status_sent numeric(18,0)

	SET @quote_status_saved 
	= (SELECT l.lookup_id 
		 FROM lookups l INNER JOIN lookup_types lt ON l.lookup_type_id=lt.lookup_type_id
		WHERE lt.code='quote_status_type' AND l.code='saved')

	SET @quote_status_sent 
	= (SELECT l.lookup_id 
		 FROM lookups l INNER JOIN lookup_types lt ON l.lookup_type_id=lt.lookup_type_id
		WHERE lt.code='quote_status_type' AND l.code='sent')

	-- insert the value into the table
	IF @Action = 1
		BEGIN

			SET @Value = RTRIM(LTRIM(@Value))

			IF @Table_Column = '[QUOTE_TOTAL]'
			       BEGIN

			       	IF @Value IS NULL
			       	BEGIN
			       		SET @Value = '0.00'
			       	END

			       	SET @Value = REPLACE(@Value, '-', '')
			       	SET @Value = REPLACE(@Value, ' ', '')
			       	SET @Value = REPLACE(@Value, '$', '')
			       	SET @Value = REPLACE(@Value, ',', '')
			       	SET @Value = RTRIM(@Value)
			       	SET @Value = LTRIM(@Value)

			       	IF ISNUMERIC(@Value) = 0
			       	BEGIN
			       		SET @Value = '0.00'
			       	END

			       	SET @Query = 'UPDATE [quotes] SET ' + @Table_Column + ' = ' + @Value + ', [date_modified] = getDate(), [modified_by] = ' + ISNULL(CAST(@QuoteID AS VARCHAR), 0) + ' WHERE [request_id] = ' + CAST(@RequestID AS VARCHAR(200)) + ' AND [version] = ' + CAST(@Version AS VARCHAR) + ' AND [sub_version] = ' + CAST(@Sub_Version AS VARCHAR)

			       END
			ELSE
			       BEGIN

			       	SET @Query = 'UPDATE [quotes] SET ' + @Table_Column + ' = ''' + @Value + ''', [date_modified] = getDate(), [modified_by] = ' + ISNULL(CAST(@QuoteID AS VARCHAR), 0) + ' WHERE [request_id] = ' + CAST(@RequestID AS VARCHAR(200)) + ' AND [version] = ' + CAST(@Version AS VARCHAR) + ' AND [sub_version] = ' + CAST(@Sub_Version AS VARCHAR)
			       	
			       END

			EXEC(@Query)

		END
	
	-- get the next highest version of an estimate quote
	IF @Action = 2
		BEGIN
			
			SET @Version = ISNULL((SELECT TOP 1 [version] FROM [quotes] WHERE [request_id] = @RequestID ORDER BY [version] DESC), 0)
			SET @Version = @Version + 1
			
			SELECT @Version AS [version]

		END

	-- get the next sub version and current version
	IF @Action = 3
		BEGIN

			SET @RequestID = (SELECT [request_id] FROM [quotes] WHERE [quote_id] = @QuoteID)
			SET @Version = (SELECT [version] FROM [quotes] WHERE [quote_id] = @QuoteID)
			SET @Sub_Version = (SELECT [sub_version] FROM [quotes] WHERE [quote_id] = @QuoteID)

			SELECT TOP 1 @Version as [version], @Sub_Version AS [sub_version], [sub_version]+1 AS [next_sub_version] FROM [quotes] WHERE [request_id] = @RequestID AND [version] = @Version ORDER BY [next_sub_version] DESC

		END

	-- get the version from an esimate id
	IF @Action = 4
		BEGIN

			SET @RequestID = (SELECT [request_id] FROM [quotes] WHERE [quote_id] = @QuoteID)
			SET @Version = (SELECT [version] FROM [quotes] WHERE [quote_id] = @QuoteID)
			SET @Sub_Version = (SELECT [sub_version] FROM [quotes] WHERE [quote_id] = @QuoteID)

			SELECT TOP 1 @Version as [version], @Sub_Version AS [sub_version] FROM [quotes] WHERE [request_id] = @RequestID AND [version] = @Version

		END

	-- get the list of quotes estimats for a quote
	IF @Action = 5
		BEGIN

			SELECT  'estimate_' + CAST(@Value AS VARCHAR) + '-' + CAST([T3].[request_no] AS VARCHAR) + '.' + CAST([T3].[version_no] AS VARCHAR) AS [name],
			       [quote_id] AS [estimate_id], [version], [sub_version], [T2].[first_name] + ' ' + [T2].[last_name] AS [updated_by], [T1].[date_modified] AS [updated_on],
			       CASE [T1].[is_sent]
			       	WHEN 'N' THEN 'Created'
			       	WHEN 'Y' THEN 'Sent'
			       END AS [sent]
			FROM [quotes] AS [T1]
			LEFT JOIN [users] AS [T2] ON [T1].[modified_by] = [T2].[user_id]
			LEFT JOIN [requests] AS [T3] ON [T1].[request_id] = [T3].[request_id]
			WHERE [T1].[request_id] = @RequestID
			ORDER BY [version], [sub_version] ASC


		END

	-- insert new quote
	IF @Action = 6
		BEGIN

			DECLARE @Request_No AS INT
			SET @Request_No = (SELECT [request_no] FROM requests WHERE [request_id] = @RequestID)

			INSERT INTO [quotes]
			       ([request_id], [version], [sub_version], [date_created], [created_by], [date_modified], [modified_by], [quote_status_type_id], [quote_type_id], [quote_no], [request_type_id], [is_sent])
			       VALUES
			       (@RequestID, @Version, @Sub_Version, getDate(), @QuoteID, getDate(), @QuoteID, 158, 17, @Request_No, 326, 'N')

		END

	-- update all records in quote to create and update the sent record
	IF @Action = 7
		BEGIN
			UPDATE [quotes] 
			   SET [is_sent] = 'Y', 
			       quote_status_type_id =  @quote_status_sent,
			       [date_modified] = getDate() 
			 WHERE [request_id] = @RequestID 
			   AND [version] = @Version 
		END


	-- update all records in a quoute then update one record based on estimate id
	IF @Action = 8
		BEGIN
		    UPDATE [quotes] 
		       SET [is_sent] = 'Y', 
			   quote_status_type_id =  @quote_status_sent,
			   [date_modified] = getDate(), 
			   [modified_by] = @Version 
		     WHERE [quote_id] = @QuoteID
		END

	-- get the fields to put into the excel spreed sheet
	IF @Action = 9
		BEGIN

			SELECT  [T3].[customer_id]	AS [CUSTOMER_ID],
			       [T3].[customer_name] 	AS [C_NAME],
			       [T3].[street1] 		AS [C_ADDRESS],
			       [T3].[city]		AS [C_CITY],
			       [T3].[state]		AS [C_STATE],
			       [T3].[zip]		AS [C_ZIP],
			       '' 			AS [C_CONTACT],
			       '' 			AS [C_PHONE],
			       [T5].[customer_name] 	AS [E_NAME],
			       [T10].[street1]		AS [E_ADDRESS],
			       [T10].[city]		AS [E_CITY],
			       [T10].[state]		AS [E_STATE],
			       [T10].[zip]		AS [E_ZIP],
			       '' 			AS [E_CONTACT],
			       '' 			AS [E_PHONE],
			       [T6].[name]		AS [ORGINIZATION],
			       [T7].[name]		AS [DELIVERY_NAME],
			       [T8].[name]		AS [OTHER_DELIVERY_NAME],
			       [T9].[name]		AS [ELEVATOR_NAME],
			       (SELECT [value] FROM [quotes_mapping] WHERE [name] = [T6].[name] AND [group] = 1 ) AS [OMNI_CODE],
			       (SELECT [value] FROM [quotes_mapping] WHERE [name] = [T7].[name] AND [group] = 2 ) AS [DELIVERY],
			       (SELECT [value] FROM [quotes_mapping] WHERE [name] = [T8].[name] AND [group] = 2 ) AS [OTHER_DELIVERY],
			       (SELECT [value] FROM [quotes_mapping] WHERE [name] = [T9].[name] AND [group] = 3 ) AS [ELEVATOR],
			       'QUOTE NO. ' + CAST([T2].[project_no] AS VARCHAR) + '-' + CAST([T1].[REQUEST_NO] AS VARCHAR) + '.' + CAST([T1].[VERSION_NO] AS VARCHAR) AS [quote_no]
			FROM [requests] AS [T1]
			LEFT JOIN [projects] AS [T2]
			       ON [T1].[project_id] = [T2].[project_id]
			LEFT JOIN [CUSTOMERS] AS [T3]
			       ON [T2].[customer_id] = [T3].[customer_id]
			LEFT JOIN [customers] AS [T5]
			       ON CAST([T2].[end_user_id] AS VARCHAR) = [T5].[customer_id]
			LEFT JOIN [organizations] AS [T6]
			       ON [T3].[organization_id] = [T6].[organization_id]
			LEFT JOIN [lookups] AS [T7]
			       ON [T7].[lookup_id] = [T1].[delivery_type_id]
			LEFT JOIN [lookups] AS [T8]
			       ON [T8].[lookup_id] = [T1].[other_delivery_type_id]
			LEFT JOIN [lookups] AS [T9]
			       ON [T9].[lookup_id] = [T1].[elevator_avail_type_id]
			LEFT JOIN [job_locations] AS [T10]
			       ON [T1].[job_location_id] = [T10].[job_location_id]
			WHERE [T1].[request_id] = @RequestID

		END

	-- get the values for the report
	IF @Action = 10
		BEGIN

			SET DATEFORMAT mdy
			
			SELECT [T5].[customer_id],
			       [T5].[customer_name] 	AS [C_NAME],
			       [T5].[street1] 		AS [C_ADDRESS],
			       [T5].[city]		AS [C_CITY],
			       [T5].[state]		AS [C_STATE],
			       [T5].[zip]		AS [C_ZIP],
			       [T3].[contact_name] 	AS [C_CONTACT],
			       [T3].[phone_work]	AS [C_PHONE],
			       [T8].[customer_name] 	AS [E_NAME],
			       [T6].[street1] 		AS [E_ADDRESS],
			       [T6].[city]		AS [E_CITY],
			       [T6].[state]		AS [E_STATE],
			       [T6].[zip]		AS [E_ZIP],
			       '' 			AS [E_CONTACT],
			       '' 			AS [E_PHONE],
			       [T5].[dealer_name]	AS [DEALER_NAME],
			       [T1].[description]	AS [DESCRIPTION],
			       [T1].[other_conditions]	AS [OTHER_CONDITIONS],
			       [T7].[Code]		AS [CODE_name],
			       [T0].[QUOTE_TOTAL]	AS [TOTAL],
			       [T2].[job_name]		AS [PROJECT_NAME],
			       [T1].[DAYS_TO_COMPLETE]	AS [DAYS],
			       [T0].*,
			       [T0].[total-panels_non-powered] AS [TOTAL_PANELS_NON-POWERED],
			       [T0].[total-panels_powered] AS [TOTAL_PANELS_POWERED],
			       [T0].[total-beltline_power] AS [TOTAL_BELTLINE_POWER],
			       [T0].[total-tiles] AS [TOTAL_TILES],
			       [T0].[total-stack_fabric] AS [TOTAL_STACK-ON_FRAME_FABRIC],
			       [T0].[total-stack_glass] AS [TOTAL_STACK-ON_FRAME_GLASS],
			       [T0].[total-worksurfaces] AS [TOTAL_WORKSURFACES],
			       [T0].[total-overheads] AS [TOTAL_OVERHEADS],
			       [T0].[total-pedestals] AS [TOTAL_PEDESTALS],
			       [T0].[total-tasklights] AS [TOTAL_TASKLIGHTS],
			       [T0].[total-keyboard_trays] AS [TOTAL_KEYBOARD_TRAYS],
			       [T0].[total-walltracks] AS [TOTAL_WALLTRACK],
			       [T0].[total-doors] AS [TOTAL_DOORS],
			       [T0].[total-accessories] AS [TOTAL_ACCESSORIES],
			       (SELECT [value] FROM [quotes_mapping] WHERE [name] = [T7].[name] AND [group] = 1 ) AS [CODE],
			       CAST([T2].[project_no] AS VARCHAR(100)) + '-' + CAST([T1].[REQUEST_NO] AS VARCHAR(100)) + '.' + CAST([T1].[VERSION_NO] AS VARCHAR(100)) AS [QUOTE_NUM],
			       created_by.first_name + ' ' + created_by.last_name created_by_user,
			       modified_by.first_name + ' ' + modified_by.last_name modified_by_user
			  FROM [quotes] AS [T0] LEFT JOIN 
			       [requests] AS [T1] ON [T0].[request_id] = [T1].[request_id] LEFT JOIN 
			       [projects] AS [T2] ON [T1].[project_id] = [T2].[project_id] LEFT JOIN 
			       [contacts] AS [T3]	ON [T1].[customer_contact_id] = [T3].[contact_id] LEFT JOIN 
			       [customers] AS [T5] ON CAST([T2].[customer_id] AS VARCHAR) = [T5].[customer_id] LEFT JOIN 
			       [organizations] AS [T7] ON [T5].[organization_id] = [T7].[organization_id] LEFT JOIN 
			       [job_locations] AS [T6] ON [T1].[job_location_id] = [T6].[job_location_id] LEFT JOIN 
			       [customers] AS [T8] ON CAST([T2].[end_user_id] AS VARCHAR) = [T8].[customer_id] INNER JOIN
			       users created_by ON [T0].created_by = created_by.user_id LEFT OUTER JOIN
			       users modified_by ON [T0].modified_by = modified_by.user_id
			 WHERE [T0].[quote_id] = @QuoteID

		END

END
GO
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_UNBILLED_REPORT_AMBIM]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_CRYSTAL_UNBILLED_REPORT_AMBIM]
AS
set nocount on

declare @tbl TABLE (
	[TYPE] char(255),
	[ORGANIZATION_ID] [numeric] (19,0),
	[CUSTOMER_NAME] varchar(255) ,
	[UnbilledDollars] [numeric](19, 5) ,
	[AvgDaySales] [numeric](19, 5),
	[DSO] [numeric](19, 5)
) 

/* Find number of days to divide unbilled $'s by.  Always done by 28 day time periods
   numdays is calculated as a failsafe if daily data capture missed a day, therefore the count
   would not include that day
*/
declare @numdays int, @begdate datetime, @enddate datetime
select @numdays=0
select @begdate = CAST(FLOOR(CAST(getdate()-28 AS FLOAT))AS DATETIME)
select @enddate = CAST(FLOOR(CAST(getdate()-1 AS FLOAT))AS DATETIME)
select @numdays=count(*) from (select distinct DATEREPORTRUN from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
	where DATEREPORTRUN <= @enddate and DATEREPORTRUN >= @begdate) a

/* avoid divide by zero error (no data in dailydatacapture)*/
if @numdays <= 0 goto endprocess

declare @customer varchar(255),
				@ORG_ID numeric(19,0),
				@JOB_NO varchar(255),
				@sumBillable numeric(19,5),
				@sumNonBillable numeric(19,5),
				@sumPooledTotal numeric(19,5),
				@sumUnbilledOpsInvoices numeric(19,5),
				@salesTotal numeric(19,5),
				@unbilledGrandTotal numeric(19,5),
				@DSOTotal numeric(19,5)

select @ORG_ID=2

declare C_Cursor CURSOR for select DISTINCT CUSTOMER_NAME from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK) where ORGANIZATION_ID=@ORG_ID order by CUSTOMER_NAME asc
OPEN C_Cursor
FETCH NEXT FROM C_Cursor INTO @customer
WHILE (@@FETCH_STATUS <> -1)
begin /*Find the totals for this particular customer and organization for this 28 day time period */
	select @sumBillable=sum(billable_total)/@numdays,@sumNonBillable=sum(non_billable_total)/@numdays
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where CUSTOMER_NAME=@customer and ORGANIZATION_ID=@ORG_ID and 
		DATEREPORTRUN between @begdate and @enddate 

		select @sumPooledTotal=sum(PooledTotal)/@numdays from
		(select bill_job_id,PooledTotal
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where CUSTOMER_NAME=@customer and ORGANIZATION_ID=@ORG_ID and 
		DATEREPORTRUN between @begdate and @enddate
		GROUP BY BILL_JOB_ID,PooledTotal) a 

		select @sumUnbilledOpsInvoices=sum(UnbilledOpsInvoicesTotal)/@numdays from
		(select bill_job_id,UnbilledOpsInvoicesTotal
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where CUSTOMER_NAME=@customer and ORGANIZATION_ID=@ORG_ID and 
		DATEREPORTRUN between @begdate and @enddate
		GROUP BY BILL_JOB_ID,UnbilledOpsInvoicesTotal) a 

	/*Total sales average for the number of days specified by @numdays */
	select @salesTotal=sum(DOCAMNT)/@numdays from (
	SELECT    ltrim(rtrim(str(INVOICE_ID))) INVOICE_ID,BILL_CUSTOMER_ID,EXT_BILL_CUST_ID,SALES_REPS,EXT_DEALER_ID,EXT_CUSTOMER_ID,CUSTOMER_NAME,a.ORGANIZATION_ID
	FROM         IMS_NEW..INVOICES a LEFT OUTER JOIN CUSTOMERS b on a.BILL_CUSTOMER_ID=b.CUSTOMER_ID
	WHERE a.ORGANIZATION_ID=@ORG_ID and a.STATUS_ID=4
	) a
	INNER JOIN
	(
	select case 
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),1) = '-' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-1)) /* -XXX*/
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),2) = '-0' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-2)) /* -0XXX*/
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),4) = 'CM-0' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-4)) /* CM-0XXX */
	ELSE SERVICE_TRAX_INVOICEID /* INV suffix */
	END as SERVICE_TRAX_INVOICEID
	,SOPNUMBE,SOPTYPE,DOCAMNT,BACHNUMB,CUSTNMBR,CUSTNAME,CSTPONBR from (
	select CASE SOPTYPE 
				 WHEN 3 then substring(SOPNUMBE,1,abs(datalength(rtrim(SOPNUMBE))-3)) /*720,XXX*/
				 WHEN 4 then substring(SOPNUMBE,1,abs(datalength(rtrim(SOPNUMBE))-6)) /*CR-XXX,CM-XXX*/
				 ELSE ''
				 END as SERVICE_TRAX_INVOICEID
	,SOPNUMBE,SOPTYPE,CASE SOPTYPE WHEN 3 then DOCAMNT WHEN 4 THEN DOCAMNT * -1 END DOCAMNT,BACHNUMB,CUSTNMBR,CUSTNAME,CSTPONBR 
	from AMBIM..SOP30200 
	where DOCDATE between @begdate and @enddate ) x
	) b on b.SERVICE_TRAX_INVOICEID=a.INVOICE_ID where CUSTOMER_NAME=@customer and ORGANIZATION_ID=@ORG_ID
/* This was the old way of calculating avg sales over 28 day period from servicee trax only 
	select @salesTotal=sum(bill_total)/@numdays from service_lines WITH (NOLOCK) inner join jobs WITH (NOLOCK) on jobs.JOB_NO=service_lines.BILL_JOB_NO 
		inner join CUSTOMERS WITH (NOLOCK) on JOBS.CUSTOMER_ID=CUSTOMERS.CUSTOMER_ID and BILLED_FLAG='Y' and SERVICE_LINE_DATE 
		in (select distinct DATEREPORTRUN from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK) 

		where DATEREPORTRUN between @begdate and @enddate) and CUSTOMER_NAME=@customer 
		and service_lines.ORGANIZATION_ID=@ORG_ID
*/
	select @unbilledGrandTotal=isnull(@sumBillable,0)+isnull(@sumPooledTotal,0)+isnull(@sumUnbilledOpsInvoices,0)
	if isnull(@salesTotal,0) <> 0 --Ensure there are sales for this time period, and not only unbilled sales to avoid divide by zero error
	begin
		select @DSOTotal=isnull(@unbilledGrandTotal,0)/isnull(@salesTotal,0)
	end
	insert into @tbl values('Unbilled OPs',@ORG_ID,@customer,@unbilledGrandTotal,isnull(@salesTotal,0),isnull(@DSOTotal,0))
	/* clear the variables for the next loop */
	select @customer='',@JOB_NO='',@sumBillable=0,@sumNonBillable=0,@sumPooledTotal=0,@sumUnbilledOpsInvoices=0,
			@salesTotal=0,@unbilledGrandTotal=0,@DSOTotal=0
	FETCH NEXT FROM C_Cursor INTO @customer
end
DEALLOCATE C_Cursor

declare @name varchar(255),
		@userID int

declare C_Cursor CURSOR for select rtrim(FIRST_NAME) + ' ' + rtrim(LAST_NAME) fullName,USER_ID
 from USERS WITH (NOLOCK) union
	select 'UNKNOWN USER','-999'
OPEN C_Cursor
FETCH NEXT FROM C_Cursor INTO @name,@userID
WHILE (@@FETCH_STATUS <> -1)
begin /*Find the totals for this particular customer and organization for this 28 day time period */
select @sumBillable=sum(billable_total)/@numdays,@sumNonBillable=sum(non_billable_total)/@numdays
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where BILLING_USER_ID=@userID and
		DATEREPORTRUN between @begdate and @enddate and ORGANIZATION_ID=@ORG_ID

		select @sumPooledTotal=sum(PooledTotal)/@numdays from
		(select bill_job_id,PooledTotal
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where BILLING_USER_ID=@userID and
		DATEREPORTRUN between @begdate and @enddate and ORGANIZATION_ID=@ORG_ID
		GROUP BY BILL_JOB_ID,PooledTotal) a 

		select @sumUnbilledOpsInvoices=sum(UnbilledOpsInvoicesTotal)/@numdays from
		(select bill_job_id,UnbilledOpsInvoicesTotal
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where BILLING_USER_ID=@userID and
		DATEREPORTRUN between @begdate and @enddate and ORGANIZATION_ID=@ORG_ID
		GROUP BY BILL_JOB_ID,UnbilledOpsInvoicesTotal) a 

	/*Total sales average for the number of days specified by @numdays for user*/
	select @salesTotal=sum(DOCAMNT)/@numdays from (
	SELECT    ltrim(rtrim(str(a.INVOICE_ID))) INVOICE_ID,BILL_CUSTOMER_ID,EXT_BILL_CUST_ID,SALES_REPS,a.ORGANIZATION_ID,b.BILLING_USER_ID
	FROM         IMS_NEW..INVOICES a left outer join JOBS b on a.JOB_ID=b.JOB_ID
	WHERE a.ORGANIZATION_ID=@ORG_ID and a.STATUS_ID=4 
	) a
	INNER JOIN
	(
	select case 
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),1) = '-' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-1)) /* -XXX*/
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),2) = '-0' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-2)) /* -0XXX*/
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),4) = 'CM-0' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-4)) /* CM-0XXX */
	ELSE SERVICE_TRAX_INVOICEID /* INV suffix */
	END as SERVICE_TRAX_INVOICEID
	,SOPNUMBE,SOPTYPE,DOCAMNT,BACHNUMB,CUSTNMBR,CUSTNAME,CSTPONBR from (
	select CASE SOPTYPE 
				 WHEN 3 then substring(SOPNUMBE,1,abs(datalength(rtrim(SOPNUMBE))-3)) /*720,XXX*/
				 WHEN 4 then substring(SOPNUMBE,1,abs(datalength(rtrim(SOPNUMBE))-6)) /*CR-XXX,CM-XXX*/
				 ELSE ''
				 END as SERVICE_TRAX_INVOICEID
	,SOPNUMBE,SOPTYPE,CASE SOPTYPE WHEN 3 then DOCAMNT WHEN 4 THEN DOCAMNT * -1 END DOCAMNT,BACHNUMB,CUSTNMBR,CUSTNAME,CSTPONBR from AMBIM..SOP30200 
	where DOCDATE between @begdate and @enddate ) x
	) b on b.SERVICE_TRAX_INVOICEID=a.INVOICE_ID where BILLING_USER_ID=@userID
/* This was the old way of calculating avg sales over 28 day period from service trax only
	select @salesTotal=sum(bill_total)/@numdays from service_lines WITH (NOLOCK) inner join jobs_v WITH (NOLOCK) on jobs_v.JOB_NO=service_lines.BILL_JOB_NO
		inner join CUSTOMERS WITH (NOLOCK) on JOBS_V.CUSTOMER_ID=CUSTOMERS.CUSTOMER_ID
		and SERVICE_LINE_DATE in (select distinct DATEREPORTRUN from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where DATEREPORTRUN between @begdate and @enddate)	and BILLING_USER_ID=@resid 
*/
	select @unbilledGrandTotal=isnull(@sumBillable,0)+isnull(@sumPooledTotal,0)+isnull(@sumUnbilledOpsInvoices,0)
	if isnull(@salesTotal,0) <> 0 --Ensure there are sales for this time period, and not only unbilled sales to avoid divide by zero error
	begin
		select @DSOTotal=isnull(@unbilledGrandTotal,0)/isnull(@salesTotal,0)
	end
	if @unbilledGrandTotal <> 0 
	begin	
		insert into @tbl values('Projects',999,@name,@unbilledGrandTotal,isnull(@salesTotal,0),isnull(@DSOTotal,0))
	end
	/* clear the variables for the next loop */
	select @name='',@userID=-1,@sumBillable=0,@sumNonBillable=0,@sumPooledTotal=0,@sumUnbilledOpsInvoices=0,
				@salesTotal=0,@unbilledGrandTotal=0,@DSOTotal=0
	FETCH NEXT FROM C_Cursor INTO @name,@userID
end
DEALLOCATE C_Cursor

/*Query for all Unbilled Accounting Items (Pending and Complete)
SELECT sum(iv.custom_line_total) custom_tot, sum(iv.bill_hourly_total) hours_total, sum(iv.bill_exp_total) exp_tot, iv.ext_batch_id, iv.assigned_to_name, iv.job_no, iv.job_id, iv.batch_status_id, ibs.name batch_status_name,
						sum(iv.bill_total + iv.custom_line_total) total_tot, iv.invoice_id_trk, iv.invoice_id, iv.invoice_description, iv.invoice_type_name, iv.invoice_status_id, iv.date_sent, iv.ext_dealer_id, iv.dealer_name, iv.customer_name, iv.invoice_format_type_name, iv.po_no, iv.invoice_date_created
		FROM invoice_pre_total_v iv, invoice_batch_statuses ibs
		WHERE iv.batch_status_id = ibs.status_id
		AND iv.invoice_status_id in (2,3) --Pending and Complete
		GROUP BY iv.invoice_id, iv.invoice_id_trk, iv.invoice_description, iv.invoice_type_name, iv.invoice_status_id, iv.date_sent, iv.ext_dealer_id, iv.dealer_name, iv.customer_name, iv.ext_batch_id, iv.assigned_to_name, iv.invoice_format_type_name, iv.job_no, iv.job_id, iv.po_no, iv.batch_status_id, iv.invoice_date_created, ibs.name
		ORDER BY iv.invoice_id
*/
insert into @tbl select 'Unbilled Accounting',iv.ORGANIZATION_ID,customer_name,sum(iv.bill_total + iv.custom_line_total) total_tot,0,0
		FROM invoice_pre_total_v iv WITH (NOLOCK), invoice_batch_statuses ibs WITH (NOLOCK)
		WHERE iv.batch_status_id = ibs.status_id
		AND iv.invoice_status_id in (2,3) --Pending and Complete
		and iv.ORGANIZATION_ID=@ORG_ID
		GROUP BY iv.invoice_id, iv.invoice_id_trk, iv.invoice_description, iv.invoice_type_name, iv.invoice_status_id, iv.date_sent, iv.ext_dealer_id, iv.dealer_name, iv.customer_name, iv.ext_batch_id, iv.assigned_to_name, iv.invoice_format_type_name, iv.job_no, iv.job_id, iv.po_no, iv.batch_status_id, iv.invoice_date_created, ibs.name, iv.ORGANIZATION_ID
		ORDER BY iv.invoice_id

select  TYPE,b.ORGANIZATION_ID,CUSTOMER_NAME,UnbilledDollars,AvgDaySales,DSO,b.NAME from @tbl a 
INNER JOIN (SELECT ORGANIZATION_ID,NAME FROM ORGANIZATIONS
UNION ALL
SELECT '999', 'PROJECTS') b on a.organization_id=b.organization_id
--select  TYPE,ORGANIZATIONS.ORGANIZATION_ID,CUSTOMER_NAME,UnbilledDollars,AvgDaySales,DSO,NAME from @tbl a
--left outer join ORGANIZATIONS on ORGANIZATIONS.ORGANIZATION_ID=a.ORGANIZATION_ID

--drop table @tbl

endprocess:

--exec sp_CRYSTAL_UNBILLED_REPORT_AMBIM
GO
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_UNBILLED_REPORT_AIA]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_CRYSTAL_UNBILLED_REPORT_AIA]
AS
set nocount on

declare @tbl TABLE (
	[TYPE] char(255),
	[ORGANIZATION_ID] [numeric] (19,0),
	[CUSTOMER_NAME] varchar(255) ,
	[UnbilledDollars] [numeric](19, 5) ,
	[AvgDaySales] [numeric](19, 5),
	[DSO] [numeric](19, 5)
) 

/* Find number of days to divide unbilled $'s by.  Always done by 28 day time periods
   numdays is calculated as a failsafe if daily data capture missed a day, therefore the count
   would not include that day
*/
declare @numdays int, @begdate datetime, @enddate datetime
select @numdays=0
select @begdate = CAST(FLOOR(CAST(getdate()-28 AS FLOAT))AS DATETIME)
select @enddate = CAST(FLOOR(CAST(getdate()-1 AS FLOAT))AS DATETIME)
select @numdays=count(*) from (select distinct DATEREPORTRUN from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
	where DATEREPORTRUN <= @enddate and DATEREPORTRUN >= @begdate) a

/* avoid divide by zero error (no data in dailydatacapture)*/
if @numdays <= 0 goto endprocess

declare @customer varchar(255),
				@ORG_ID numeric(19,0),
				@JOB_NO varchar(255),
				@sumBillable numeric(19,5),
				@sumNonBillable numeric(19,5),
				@sumPooledTotal numeric(19,5),
				@sumUnbilledOpsInvoices numeric(19,5),
				@salesTotal numeric(19,5),
				@unbilledGrandTotal numeric(19,5),
				@DSOTotal numeric(19,5)

select @ORG_ID=8

declare C_Cursor CURSOR for select DISTINCT CUSTOMER_NAME from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK) where ORGANIZATION_ID=@ORG_ID order by CUSTOMER_NAME asc
OPEN C_Cursor
FETCH NEXT FROM C_Cursor INTO @customer
WHILE (@@FETCH_STATUS <> -1)
begin /*Find the totals for this particular customer and organization for this 28 day time period */
	select @sumBillable=sum(billable_total)/@numdays,@sumNonBillable=sum(non_billable_total)/@numdays
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where CUSTOMER_NAME=@customer and ORGANIZATION_ID=@ORG_ID and 
		DATEREPORTRUN between @begdate and @enddate 

		select @sumPooledTotal=sum(PooledTotal)/@numdays from
		(select bill_job_id,PooledTotal
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where CUSTOMER_NAME=@customer and ORGANIZATION_ID=@ORG_ID and 
		DATEREPORTRUN between @begdate and @enddate
		GROUP BY BILL_JOB_ID,PooledTotal) a 

		select @sumUnbilledOpsInvoices=sum(UnbilledOpsInvoicesTotal)/@numdays from
		(select bill_job_id,UnbilledOpsInvoicesTotal
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where CUSTOMER_NAME=@customer and ORGANIZATION_ID=@ORG_ID and 
		DATEREPORTRUN between @begdate and @enddate
		GROUP BY BILL_JOB_ID,UnbilledOpsInvoicesTotal) a 

	/*Total sales average for the number of days specified by @numdays */
	select @salesTotal=sum(DOCAMNT)/@numdays from (
	SELECT    ltrim(rtrim(str(INVOICE_ID))) INVOICE_ID,BILL_CUSTOMER_ID,EXT_BILL_CUST_ID,SALES_REPS,EXT_DEALER_ID,EXT_CUSTOMER_ID,CUSTOMER_NAME,a.ORGANIZATION_ID
	FROM         IMS_NEW..INVOICES a LEFT OUTER JOIN CUSTOMERS b on a.BILL_CUSTOMER_ID=b.CUSTOMER_ID
	WHERE a.ORGANIZATION_ID=@ORG_ID and a.STATUS_ID=4
	) a
	INNER JOIN
	(
	select case 
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),1) = '-' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-1)) /* -XXX*/
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),2) = '-0' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-2)) /* -0XXX*/
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),4) = 'CM-0' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-4)) /* CM-0XXX */
	ELSE SERVICE_TRAX_INVOICEID /* INV suffix */
	END as SERVICE_TRAX_INVOICEID
	,SOPNUMBE,SOPTYPE,DOCAMNT,BACHNUMB,CUSTNMBR,CUSTNAME,CSTPONBR from (
	select CASE SOPTYPE 
				 WHEN 3 then substring(SOPNUMBE,1,abs(datalength(rtrim(SOPNUMBE))-3)) /*720,XXX*/
				 WHEN 4 then substring(SOPNUMBE,1,abs(datalength(rtrim(SOPNUMBE))-6)) /*CR-XXX,CM-XXX*/
				 ELSE ''
				 END as SERVICE_TRAX_INVOICEID
	,SOPNUMBE,SOPTYPE,CASE SOPTYPE WHEN 3 then DOCAMNT WHEN 4 THEN DOCAMNT * -1 END DOCAMNT,BACHNUMB,CUSTNMBR,CUSTNAME,CSTPONBR 
	from AIA..SOP30200 
	where DOCDATE between @begdate and @enddate ) x
	) b on b.SERVICE_TRAX_INVOICEID=a.INVOICE_ID where CUSTOMER_NAME=@customer and ORGANIZATION_ID=@ORG_ID
/* This was the old way of calculating avg sales over 28 day period from servicee trax only 
	select @salesTotal=sum(bill_total)/@numdays from service_lines WITH (NOLOCK) inner join jobs WITH (NOLOCK) on jobs.JOB_NO=service_lines.BILL_JOB_NO 
		inner join CUSTOMERS WITH (NOLOCK) on JOBS.CUSTOMER_ID=CUSTOMERS.CUSTOMER_ID and BILLED_FLAG='Y' and SERVICE_LINE_DATE 
		in (select distinct DATEREPORTRUN from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK) 

		where DATEREPORTRUN between @begdate and @enddate) and CUSTOMER_NAME=@customer 
		and service_lines.ORGANIZATION_ID=@ORG_ID
*/
	select @unbilledGrandTotal=isnull(@sumBillable,0)+isnull(@sumPooledTotal,0)+isnull(@sumUnbilledOpsInvoices,0)
	if isnull(@salesTotal,0) <> 0 --Ensure there are sales for this time period, and not only unbilled sales to avoid divide by zero error
	begin
		select @DSOTotal=isnull(@unbilledGrandTotal,0)/isnull(@salesTotal,0)
	end
	insert into @tbl values('Unbilled OPs',@ORG_ID,@customer,@unbilledGrandTotal,isnull(@salesTotal,0),isnull(@DSOTotal,0))
	/* clear the variables for the next loop */
	select @customer='',@JOB_NO='',@sumBillable=0,@sumNonBillable=0,@sumPooledTotal=0,@sumUnbilledOpsInvoices=0,
			@salesTotal=0,@unbilledGrandTotal=0,@DSOTotal=0
	FETCH NEXT FROM C_Cursor INTO @customer
end
DEALLOCATE C_Cursor

declare @name varchar(255),
		@userID int

declare C_Cursor CURSOR for select rtrim(FIRST_NAME) + ' ' + rtrim(LAST_NAME) fullName,USER_ID
 from USERS WITH (NOLOCK) union
	select 'UNKNOWN USER','-999'
OPEN C_Cursor
FETCH NEXT FROM C_Cursor INTO @name,@userID
WHILE (@@FETCH_STATUS <> -1)
begin /*Find the totals for this particular customer and organization for this 28 day time period */
select @sumBillable=sum(billable_total)/@numdays,@sumNonBillable=sum(non_billable_total)/@numdays
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where BILLING_USER_ID=@userID and
		DATEREPORTRUN between @begdate and @enddate and ORGANIZATION_ID=@ORG_ID

		select @sumPooledTotal=sum(PooledTotal)/@numdays from
		(select bill_job_id,PooledTotal
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where BILLING_USER_ID=@userID and
		DATEREPORTRUN between @begdate and @enddate and ORGANIZATION_ID=@ORG_ID
		GROUP BY BILL_JOB_ID,PooledTotal) a 

		select @sumUnbilledOpsInvoices=sum(UnbilledOpsInvoicesTotal)/@numdays from
		(select bill_job_id,UnbilledOpsInvoicesTotal
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where BILLING_USER_ID=@userID and
		DATEREPORTRUN between @begdate and @enddate and ORGANIZATION_ID=@ORG_ID
		GROUP BY BILL_JOB_ID,UnbilledOpsInvoicesTotal) a 

	/*Total sales average for the number of days specified by @numdays for user*/
	select @salesTotal=sum(DOCAMNT)/@numdays from (
	SELECT    ltrim(rtrim(str(a.INVOICE_ID))) INVOICE_ID,BILL_CUSTOMER_ID,EXT_BILL_CUST_ID,SALES_REPS,a.ORGANIZATION_ID,b.BILLING_USER_ID
	FROM         IMS_NEW..INVOICES a left outer join JOBS b on a.JOB_ID=b.JOB_ID
	WHERE a.ORGANIZATION_ID=@ORG_ID and a.STATUS_ID=4 
	) a
	INNER JOIN
	(
	select case 
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),1) = '-' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-1)) /* -XXX*/
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),2) = '-0' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-2)) /* -0XXX*/
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),4) = 'CM-0' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-4)) /* CM-0XXX */
	ELSE SERVICE_TRAX_INVOICEID /* INV suffix */
	END as SERVICE_TRAX_INVOICEID
	,SOPNUMBE,SOPTYPE,DOCAMNT,BACHNUMB,CUSTNMBR,CUSTNAME,CSTPONBR from (
	select CASE SOPTYPE 
				 WHEN 3 then substring(SOPNUMBE,1,abs(datalength(rtrim(SOPNUMBE))-3)) /*720,XXX*/
				 WHEN 4 then substring(SOPNUMBE,1,abs(datalength(rtrim(SOPNUMBE))-6)) /*CR-XXX,CM-XXX*/
				 ELSE ''
				 END as SERVICE_TRAX_INVOICEID
	,SOPNUMBE,SOPTYPE,CASE SOPTYPE WHEN 3 then DOCAMNT WHEN 4 THEN DOCAMNT * -1 END DOCAMNT,BACHNUMB,CUSTNMBR,CUSTNAME,CSTPONBR from AIA..SOP30200 
	where DOCDATE between @begdate and @enddate ) x
	) b on b.SERVICE_TRAX_INVOICEID=a.INVOICE_ID where BILLING_USER_ID=@userID
/* This was the old way of calculating avg sales over 28 day period from service trax only
	select @salesTotal=sum(bill_total)/@numdays from service_lines WITH (NOLOCK) inner join jobs_v WITH (NOLOCK) on jobs_v.JOB_NO=service_lines.BILL_JOB_NO
		inner join CUSTOMERS WITH (NOLOCK) on JOBS_V.CUSTOMER_ID=CUSTOMERS.CUSTOMER_ID
		and SERVICE_LINE_DATE in (select distinct DATEREPORTRUN from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where DATEREPORTRUN between @begdate and @enddate)	and BILLING_USER_ID=@resid 
*/
	select @unbilledGrandTotal=isnull(@sumBillable,0)+isnull(@sumPooledTotal,0)+isnull(@sumUnbilledOpsInvoices,0)
	if isnull(@salesTotal,0) <> 0 --Ensure there are sales for this time period, and not only unbilled sales to avoid divide by zero error
	begin
		select @DSOTotal=isnull(@unbilledGrandTotal,0)/isnull(@salesTotal,0)
	end
	if @unbilledGrandTotal <> 0 
	begin	
		insert into @tbl values('Projects',999,@name,@unbilledGrandTotal,isnull(@salesTotal,0),isnull(@DSOTotal,0))
	end
	/* clear the variables for the next loop */
	select @name='',@userID=-1,@sumBillable=0,@sumNonBillable=0,@sumPooledTotal=0,@sumUnbilledOpsInvoices=0,
				@salesTotal=0,@unbilledGrandTotal=0,@DSOTotal=0
	FETCH NEXT FROM C_Cursor INTO @name,@userID
end
DEALLOCATE C_Cursor

/*Query for all Unbilled Accounting Items (Pending and Complete)
SELECT sum(iv.custom_line_total) custom_tot, sum(iv.bill_hourly_total) hours_total, sum(iv.bill_exp_total) exp_tot, iv.ext_batch_id, iv.assigned_to_name, iv.job_no, iv.job_id, iv.batch_status_id, ibs.name batch_status_name,
						sum(iv.bill_total + iv.custom_line_total) total_tot, iv.invoice_id_trk, iv.invoice_id, iv.invoice_description, iv.invoice_type_name, iv.invoice_status_id, iv.date_sent, iv.ext_dealer_id, iv.dealer_name, iv.customer_name, iv.invoice_format_type_name, iv.po_no, iv.invoice_date_created
		FROM invoice_pre_total_v iv, invoice_batch_statuses ibs
		WHERE iv.batch_status_id = ibs.status_id
		AND iv.invoice_status_id in (2,3) --Pending and Complete
		GROUP BY iv.invoice_id, iv.invoice_id_trk, iv.invoice_description, iv.invoice_type_name, iv.invoice_status_id, iv.date_sent, iv.ext_dealer_id, iv.dealer_name, iv.customer_name, iv.ext_batch_id, iv.assigned_to_name, iv.invoice_format_type_name, iv.job_no, iv.job_id, iv.po_no, iv.batch_status_id, iv.invoice_date_created, ibs.name
		ORDER BY iv.invoice_id
*/
insert into @tbl select 'Unbilled Accounting',iv.ORGANIZATION_ID,customer_name,sum(iv.bill_total + iv.custom_line_total) total_tot,0,0
		FROM invoice_pre_total_v iv WITH (NOLOCK), invoice_batch_statuses ibs WITH (NOLOCK)
		WHERE iv.batch_status_id = ibs.status_id
		AND iv.invoice_status_id in (2,3) --Pending and Complete
		and iv.ORGANIZATION_ID=@ORG_ID
		GROUP BY iv.invoice_id, iv.invoice_id_trk, iv.invoice_description, iv.invoice_type_name, iv.invoice_status_id, iv.date_sent, iv.ext_dealer_id, iv.dealer_name, iv.customer_name, iv.ext_batch_id, iv.assigned_to_name, iv.invoice_format_type_name, iv.job_no, iv.job_id, iv.po_no, iv.batch_status_id, iv.invoice_date_created, ibs.name, iv.ORGANIZATION_ID
		ORDER BY iv.invoice_id

select  TYPE,b.ORGANIZATION_ID,CUSTOMER_NAME,UnbilledDollars,AvgDaySales,DSO,b.NAME from @tbl a 
INNER JOIN (SELECT ORGANIZATION_ID,NAME FROM ORGANIZATIONS
UNION ALL
SELECT '999', 'PROJECTS') b on a.organization_id=b.organization_id
--select  TYPE,ORGANIZATIONS.ORGANIZATION_ID,CUSTOMER_NAME,UnbilledDollars,AvgDaySales,DSO,NAME from @tbl a
--left outer join ORGANIZATIONS on ORGANIZATIONS.ORGANIZATION_ID=a.ORGANIZATION_ID

--drop table @tbl

endprocess:

--exec sp_CRYSTAL_UNBILLED_REPORT_AIA
GO
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_UNBILLED_REPORT_AMBIM_DATERANGE]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_CRYSTAL_UNBILLED_REPORT_AMBIM_DATERANGE]
	@begdate datetime, @enddate datetime
AS
set nocount on

declare @tbl TABLE (
	[TYPE] char(255),
	[ORGANIZATION_ID] [numeric] (19,0),
	[CUSTOMER_NAME] varchar(255) ,
	[UnbilledDollars] [numeric](19, 5) ,
	[AvgDaySales] [numeric](19, 5),
	[DSO] [numeric](19, 5)
) 

/* Find number of days to divide unbilled $'s by.  Always done by 28 day time periods*/
declare @numdays int
select @numdays=0
select @begdate=CAST(FLOOR(CAST(@begdate AS FLOAT))AS DATETIME)
select @enddate=CAST(FLOOR(CAST(@enddate AS FLOAT))AS DATETIME)
select @numdays=count(*) from (select distinct DATEREPORTRUN from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
	where DATEREPORTRUN <= @enddate and DATEREPORTRUN >= @begdate) a

/* avoid divide by zero error (no data in dailydatacapture)*/
if @numdays <= 0 goto endprocess

declare @customer varchar(255),
				@ORG_ID numeric(19,0),
				@JOB_NO varchar(255),
				@sumBillable numeric(19,5),
				@sumNonBillable numeric(19,5),
				@sumPooledTotal numeric(19,5),
				@sumUnbilledOpsInvoices numeric(19,5),
				@salesTotal numeric(19,5),
				@unbilledGrandTotal numeric(19,5),
				@DSOTotal numeric(19,5)

select @ORG_ID=2

declare C_Cursor CURSOR for select DISTINCT CUSTOMER_NAME from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK) where ORGANIZATION_ID=@ORG_ID order by CUSTOMER_NAME asc
OPEN C_Cursor
FETCH NEXT FROM C_Cursor INTO @customer
WHILE (@@FETCH_STATUS <> -1)
begin /*Find the totals for this particular customer and organization for this 28 day time period */
	select @sumBillable=sum(billable_total)/@numdays
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where CUSTOMER_NAME=@customer and ORGANIZATION_ID=@ORG_ID and 
		DATEREPORTRUN between @begdate and @enddate 

		select @sumPooledTotal=sum(PooledTotal)/@numdays from
		(select bill_job_id,PooledTotal
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where CUSTOMER_NAME=@customer and ORGANIZATION_ID=@ORG_ID and 
		DATEREPORTRUN between @begdate and @enddate
		GROUP BY BILL_JOB_ID,PooledTotal) a 

		select @sumUnbilledOpsInvoices=sum(UnbilledOpsInvoicesTotal)/@numdays from
		(select bill_job_id,UnbilledOpsInvoicesTotal
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where CUSTOMER_NAME=@customer and ORGANIZATION_ID=@ORG_ID and 
		DATEREPORTRUN between @begdate and @enddate
		GROUP BY BILL_JOB_ID,UnbilledOpsInvoicesTotal) a 

	/*Total sales average for the number of days specified by @numdays */
	select @salesTotal=sum(DOCAMNT)/@numdays from (
	SELECT    ltrim(rtrim(str(INVOICE_ID))) INVOICE_ID,BILL_CUSTOMER_ID,EXT_BILL_CUST_ID,SALES_REPS,EXT_DEALER_ID,EXT_CUSTOMER_ID,CUSTOMER_NAME,a.ORGANIZATION_ID
	FROM         IMS_NEW..INVOICES a LEFT OUTER JOIN CUSTOMERS b on a.BILL_CUSTOMER_ID=b.CUSTOMER_ID
	WHERE a.ORGANIZATION_ID=@ORG_ID and a.STATUS_ID=4
	) a
	INNER JOIN
	(
	select case 
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),1) = '-' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-1)) /* -XXX*/
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),2) = '-0' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-2)) /* -0XXX*/
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),4) = 'CM-0' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-4)) /* CM-0XXX */
	ELSE SERVICE_TRAX_INVOICEID /* INV suffix */
	END as SERVICE_TRAX_INVOICEID
	,SOPNUMBE,SOPTYPE,DOCAMNT,BACHNUMB,CUSTNMBR,CUSTNAME,CSTPONBR from (
	select CASE SOPTYPE 
				 WHEN 3 then substring(SOPNUMBE,1,abs(datalength(rtrim(SOPNUMBE))-3)) /*720,XXX*/
				 WHEN 4 then substring(SOPNUMBE,1,abs(datalength(rtrim(SOPNUMBE))-6)) /*CR-XXX,CM-XXX*/
				 ELSE ''
				 END as SERVICE_TRAX_INVOICEID
	,SOPNUMBE,SOPTYPE,CASE SOPTYPE WHEN 3 then DOCAMNT WHEN 4 THEN DOCAMNT * -1 END DOCAMNT,BACHNUMB,CUSTNMBR,CUSTNAME,CSTPONBR 
	from AMBIM..SOP30200 
	where DOCDATE between @begdate and @enddate ) x
	) b on b.SERVICE_TRAX_INVOICEID=a.INVOICE_ID where CUSTOMER_NAME=@customer and ORGANIZATION_ID=@ORG_ID
/* This was the old way of calculating avg sales over 28 day period from servicee trax only 
	select @salesTotal=sum(bill_total)/@numdays from service_lines WITH (NOLOCK) inner join jobs WITH (NOLOCK) on jobs.JOB_NO=service_lines.BILL_JOB_NO 
		inner join CUSTOMERS WITH (NOLOCK) on JOBS.CUSTOMER_ID=CUSTOMERS.CUSTOMER_ID and BILLED_FLAG='Y' and SERVICE_LINE_DATE 
		in (select distinct DATEREPORTRUN from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK) 

		where DATEREPORTRUN between @begdate and @enddate) and CUSTOMER_NAME=@customer 
		and service_lines.ORGANIZATION_ID=@ORG_ID
*/
	select @unbilledGrandTotal=isnull(@sumBillable,0)+isnull(@sumPooledTotal,0)+isnull(@sumUnbilledOpsInvoices,0)
	if isnull(@salesTotal,0) <> 0 --Ensure there are sales for this time period, and not only unbilled sales to avoid divide by zero error
	begin
		select @DSOTotal=isnull(@unbilledGrandTotal,0)/isnull(@salesTotal,0)
	end
	insert into @tbl values('Unbilled OPs',@ORG_ID,@customer,@unbilledGrandTotal,isnull(@salesTotal,0),isnull(@DSOTotal,0))
	/* clear the variables for the next loop */
	select @customer='',@JOB_NO='',@sumBillable=0,@sumNonBillable=0,@sumPooledTotal=0,@sumUnbilledOpsInvoices=0,
			@salesTotal=0,@unbilledGrandTotal=0,@DSOTotal=0
	FETCH NEXT FROM C_Cursor INTO @customer
end
DEALLOCATE C_Cursor

declare @name varchar(255),
		@userID int

declare C_Cursor CURSOR for select rtrim(FIRST_NAME) + ' ' + rtrim(LAST_NAME) fullName,USER_ID
 from USERS WITH (NOLOCK) union
	select 'UNKNOWN USER','-999'
OPEN C_Cursor
FETCH NEXT FROM C_Cursor INTO @name,@userID
WHILE (@@FETCH_STATUS <> -1)
begin /*Find the totals for this particular customer and organization for this 28 day time period */
select @sumBillable=sum(billable_total)/@numdays,@sumNonBillable=sum(non_billable_total)/@numdays
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where BILLING_USER_ID=@userID and
		DATEREPORTRUN between @begdate and @enddate and ORGANIZATION_ID=@ORG_ID

		select @sumPooledTotal=sum(PooledTotal)/@numdays from
		(select bill_job_id,PooledTotal
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where BILLING_USER_ID=@userID and
		DATEREPORTRUN between @begdate and @enddate and ORGANIZATION_ID=@ORG_ID
		GROUP BY BILL_JOB_ID,PooledTotal) a 

		select @sumUnbilledOpsInvoices=sum(UnbilledOpsInvoicesTotal)/@numdays from
		(select bill_job_id,UnbilledOpsInvoicesTotal
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where BILLING_USER_ID=@userID and
		DATEREPORTRUN between @begdate and @enddate and ORGANIZATION_ID=@ORG_ID
		GROUP BY BILL_JOB_ID,UnbilledOpsInvoicesTotal) a 

	/*Total sales average for the number of days specified by @numdays for user*/
	select @salesTotal=sum(DOCAMNT)/@numdays from (
	SELECT    ltrim(rtrim(str(a.INVOICE_ID))) INVOICE_ID,BILL_CUSTOMER_ID,EXT_BILL_CUST_ID,SALES_REPS,a.ORGANIZATION_ID,b.BILLING_USER_ID
	FROM         IMS_NEW..INVOICES a left outer join JOBS b on a.JOB_ID=b.JOB_ID
	WHERE a.ORGANIZATION_ID=@ORG_ID and a.STATUS_ID=4 
	) a
	INNER JOIN
	(
	select case 
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),1) = '-' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-1)) /* -XXX*/
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),2) = '-0' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-2)) /* -0XXX*/
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),4) = 'CM-0' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-4)) /* CM-0XXX */
	ELSE SERVICE_TRAX_INVOICEID /* INV suffix */
	END as SERVICE_TRAX_INVOICEID
	,SOPNUMBE,SOPTYPE,DOCAMNT,BACHNUMB,CUSTNMBR,CUSTNAME,CSTPONBR from (
	select CASE SOPTYPE 
				 WHEN 3 then substring(SOPNUMBE,1,abs(datalength(rtrim(SOPNUMBE))-3)) /*720,XXX*/
				 WHEN 4 then substring(SOPNUMBE,1,abs(datalength(rtrim(SOPNUMBE))-6)) /*CR-XXX,CM-XXX*/
				 ELSE ''
				 END as SERVICE_TRAX_INVOICEID
	,SOPNUMBE,SOPTYPE,CASE SOPTYPE WHEN 3 then DOCAMNT WHEN 4 THEN DOCAMNT * -1 END DOCAMNT,BACHNUMB,CUSTNMBR,CUSTNAME,CSTPONBR from AMBIM..SOP30200 
	where DOCDATE between @begdate and @enddate ) x
	) b on b.SERVICE_TRAX_INVOICEID=a.INVOICE_ID where BILLING_USER_ID=@userID
/* This was the old way of calculating avg sales over 28 day period from service trax only
	select @salesTotal=sum(bill_total)/@numdays from service_lines WITH (NOLOCK) inner join jobs_v WITH (NOLOCK) on jobs_v.JOB_NO=service_lines.BILL_JOB_NO
		inner join CUSTOMERS WITH (NOLOCK) on JOBS_V.CUSTOMER_ID=CUSTOMERS.CUSTOMER_ID
		and SERVICE_LINE_DATE in (select distinct DATEREPORTRUN from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where DATEREPORTRUN between @begdate and @enddate)	and BILLING_USER_ID=@resid 
*/
	select @unbilledGrandTotal=isnull(@sumBillable,0)+isnull(@sumPooledTotal,0)+isnull(@sumUnbilledOpsInvoices,0)
	if isnull(@salesTotal,0) <> 0 --Ensure there are sales for this time period, and not only unbilled sales to avoid divide by zero error
	begin
		select @DSOTotal=isnull(@unbilledGrandTotal,0)/isnull(@salesTotal,0)
	end
	if @unbilledGrandTotal <> 0 
	begin	
		insert into @tbl values('Projects',999,@name,@unbilledGrandTotal,isnull(@salesTotal,0),isnull(@DSOTotal,0))
	end
	/* clear the variables for the next loop */
	select @name='',@userID=-1,@sumBillable=0,@sumNonBillable=0,@sumPooledTotal=0,@sumUnbilledOpsInvoices=0,
				@salesTotal=0,@unbilledGrandTotal=0,@DSOTotal=0
	FETCH NEXT FROM C_Cursor INTO @name,@userID
end
DEALLOCATE C_Cursor

/*Query for all Unbilled Accounting Items (Pending and Complete)
SELECT sum(iv.custom_line_total) custom_tot, sum(iv.bill_hourly_total) hours_total, sum(iv.bill_exp_total) exp_tot, iv.ext_batch_id, iv.assigned_to_name, iv.job_no, iv.job_id, iv.batch_status_id, ibs.name batch_status_name,
						sum(iv.bill_total + iv.custom_line_total) total_tot, iv.invoice_id_trk, iv.invoice_id, iv.invoice_description, iv.invoice_type_name, iv.invoice_status_id, iv.date_sent, iv.ext_dealer_id, iv.dealer_name, iv.customer_name, iv.invoice_format_type_name, iv.po_no, iv.invoice_date_created
		FROM invoice_pre_total_v iv, invoice_batch_statuses ibs
		WHERE iv.batch_status_id = ibs.status_id
		AND iv.invoice_status_id in (2,3) --Pending and Complete
		GROUP BY iv.invoice_id, iv.invoice_id_trk, iv.invoice_description, iv.invoice_type_name, iv.invoice_status_id, iv.date_sent, iv.ext_dealer_id, iv.dealer_name, iv.customer_name, iv.ext_batch_id, iv.assigned_to_name, iv.invoice_format_type_name, iv.job_no, iv.job_id, iv.po_no, iv.batch_status_id, iv.invoice_date_created, ibs.name
		ORDER BY iv.invoice_id
*/
insert into @tbl select 'Unbilled Accounting',iv.ORGANIZATION_ID,customer_name,sum(iv.bill_total + iv.custom_line_total) total_tot,0,0
		FROM invoice_pre_total_v iv WITH (NOLOCK), invoice_batch_statuses ibs WITH (NOLOCK)
		WHERE iv.batch_status_id = ibs.status_id
		AND iv.invoice_status_id in (2,3) --Pending and Complete
		and iv.ORGANIZATION_ID=@ORG_ID
		GROUP BY iv.invoice_id, iv.invoice_id_trk, iv.invoice_description, iv.invoice_type_name, iv.invoice_status_id, iv.date_sent, iv.ext_dealer_id, iv.dealer_name, iv.customer_name, iv.ext_batch_id, iv.assigned_to_name, iv.invoice_format_type_name, iv.job_no, iv.job_id, iv.po_no, iv.batch_status_id, iv.invoice_date_created, ibs.name, iv.ORGANIZATION_ID
		ORDER BY iv.invoice_id

select  TYPE,b.ORGANIZATION_ID,CUSTOMER_NAME,UnbilledDollars,AvgDaySales,DSO,b.NAME from @tbl a 
INNER JOIN (SELECT ORGANIZATION_ID,NAME FROM ORGANIZATIONS
UNION ALL
SELECT '999', 'PROJECTS') b on a.organization_id=b.organization_id
--select  TYPE,ORGANIZATIONS.ORGANIZATION_ID,CUSTOMER_NAME,UnbilledDollars,AvgDaySales,DSO,NAME from @tbl a
--left outer join ORGANIZATIONS on ORGANIZATIONS.ORGANIZATION_ID=a.ORGANIZATION_ID

--drop table @tbl

endprocess:

--exec sp_CRYSTAL_UNBILLED_REPORT_AMBIM_DATERANGE
GO
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_UNBILLED_REPORT_AMBIM_SALESNUMBERS]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec sp_CRYSTAL_UNBILLED_REPORT_AMBIM_SALESNUMBERS
--drop procedure sp_CRYSTAL_UNBILLED_REPORT_AMBIM_SALESNUMBERS
CREATE PROCEDURE [dbo].[sp_CRYSTAL_UNBILLED_REPORT_AMBIM_SALESNUMBERS]
	@begdate datetime, @enddate datetime
AS
set nocount on

declare @numdays int
select @numdays=0
select @begdate=CAST(FLOOR(CAST(@begdate AS FLOAT))AS DATETIME)
select @enddate=CAST(FLOOR(CAST(@enddate AS FLOAT))AS DATETIME)
select @numdays=count(*) from (select distinct DATEREPORTRUN from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
	where DATEREPORTRUN <= @enddate and DATEREPORTRUN >= @begdate) a

select @numdays as NumberOfDays,@begdate as BeginDate,@enddate as EndDate,* from (
	SELECT    ltrim(rtrim(str(INVOICE_ID))) INVOICE_ID,BILL_CUSTOMER_ID,EXT_BILL_CUST_ID,SALES_REPS,EXT_DEALER_ID,EXT_CUSTOMER_ID,CUSTOMER_NAME,a.ORGANIZATION_ID
	FROM         IMS_NEW..INVOICES a LEFT OUTER JOIN CUSTOMERS b on a.BILL_CUSTOMER_ID=b.CUSTOMER_ID
	WHERE a.ORGANIZATION_ID=2 and a.STATUS_ID=4
	) a
	INNER JOIN
	(
	select case 
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),1) = '-' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-1)) /* -XXX*/
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),2) = '-0' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-2)) /* -0XXX*/
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),4) = 'CM-0' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-4)) /* CM-0XXX */
	ELSE SERVICE_TRAX_INVOICEID /* INV suffix */
	END as SERVICE_TRAX_INVOICEID
	,SOPNUMBE,SOPTYPE,DOCAMNT,BACHNUMB,CUSTNMBR,CUSTNAME,CSTPONBR from (
	select CASE SOPTYPE 
				 WHEN 3 then substring(SOPNUMBE,1,abs(datalength(rtrim(SOPNUMBE))-3)) /*720,XXX*/
				 WHEN 4 then substring(SOPNUMBE,1,abs(datalength(rtrim(SOPNUMBE))-6)) /*CR-XXX,CM-XXX*/
				 ELSE ''
				 END as SERVICE_TRAX_INVOICEID
	,SOPNUMBE,SOPTYPE,CASE SOPTYPE WHEN 3 then DOCAMNT WHEN 4 THEN DOCAMNT * -1 END DOCAMNT,BACHNUMB,CUSTNMBR,CUSTNAME,CSTPONBR 
	from AMBIM..SOP30200 
	where DOCDATE between @begdate and @enddate ) x
	) b on b.SERVICE_TRAX_INVOICEID=a.INVOICE_ID where  ORGANIZATION_ID=2
GO
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_UNBILLED_REPORT_CIINC]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_CRYSTAL_UNBILLED_REPORT_CIINC]
AS
set nocount on

declare @tbl TABLE (
	[TYPE] char(255),
	[ORGANIZATION_ID] [numeric] (19,0),
	[CUSTOMER_NAME] varchar(255) ,
	[UnbilledDollars] [numeric](19, 5) ,
	[AvgDaySales] [numeric](19, 5),
	[DSO] [numeric](19, 5)
) 

/* Find number of days to divide unbilled $'s by.  Always done by 28 day time periods
   numdays is calculated as a failsafe if daily data capture missed a day, therefore the count
   would not include that day
*/
declare @numdays int, @begdate datetime, @enddate datetime
select @numdays=0
select @begdate = CAST(FLOOR(CAST(getdate()-28 AS FLOAT))AS DATETIME)
select @enddate = CAST(FLOOR(CAST(getdate()-1 AS FLOAT))AS DATETIME)
select @numdays=count(*) from (select distinct DATEREPORTRUN from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
	where DATEREPORTRUN <= @enddate and DATEREPORTRUN >= @begdate) a

/* avoid divide by zero error (no data in dailydatacapture)*/
if @numdays <= 0 goto endprocess

declare @customer varchar(255),
				@ORG_ID numeric(19,0),
				@JOB_NO varchar(255),
				@sumBillable numeric(19,5),
				@sumNonBillable numeric(19,5),
				@sumPooledTotal numeric(19,5),
				@sumUnbilledOpsInvoices numeric(19,5),
				@salesTotal numeric(19,5),
				@unbilledGrandTotal numeric(19,5),
				@DSOTotal numeric(19,5)

select @ORG_ID=10

declare C_Cursor CURSOR for select DISTINCT CUSTOMER_NAME from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK) where ORGANIZATION_ID=@ORG_ID order by CUSTOMER_NAME asc
OPEN C_Cursor
FETCH NEXT FROM C_Cursor INTO @customer
WHILE (@@FETCH_STATUS <> -1)
begin /*Find the totals for this particular customer and organization for this 28 day time period */
	select @sumBillable=sum(billable_total)/@numdays,@sumNonBillable=sum(non_billable_total)/@numdays
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where CUSTOMER_NAME=@customer and ORGANIZATION_ID=@ORG_ID and 
		DATEREPORTRUN between @begdate and @enddate 

		select @sumPooledTotal=sum(PooledTotal)/@numdays from
		(select bill_job_id,PooledTotal
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where CUSTOMER_NAME=@customer and ORGANIZATION_ID=@ORG_ID and 
		DATEREPORTRUN between @begdate and @enddate
		GROUP BY BILL_JOB_ID,PooledTotal) a 

		select @sumUnbilledOpsInvoices=sum(UnbilledOpsInvoicesTotal)/@numdays from
		(select bill_job_id,UnbilledOpsInvoicesTotal
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where CUSTOMER_NAME=@customer and ORGANIZATION_ID=@ORG_ID and 
		DATEREPORTRUN between @begdate and @enddate
		GROUP BY BILL_JOB_ID,UnbilledOpsInvoicesTotal) a 

	/*Total sales average for the number of days specified by @numdays */
	select @salesTotal=sum(DOCAMNT)/@numdays from (
	SELECT    ltrim(rtrim(str(INVOICE_ID))) INVOICE_ID,BILL_CUSTOMER_ID,EXT_BILL_CUST_ID,SALES_REPS,EXT_DEALER_ID,EXT_CUSTOMER_ID,CUSTOMER_NAME,a.ORGANIZATION_ID
	FROM         IMS_NEW..INVOICES a LEFT OUTER JOIN CUSTOMERS b on a.BILL_CUSTOMER_ID=b.CUSTOMER_ID
	WHERE a.ORGANIZATION_ID=@ORG_ID and a.STATUS_ID=4
	) a
	INNER JOIN
	(
	select case right(rtrim(SERVICE_TRAX_INVOICEID),1)
	WHEN '-' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-1)) /* -XXX*/
	WHEN '0' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-2)) /* -0XXX*/
	WHEN 'C' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-1)) /* CM-0XXX */
	ELSE SERVICE_TRAX_INVOICEID /* INV suffix */
	END as SERVICE_TRAX_INVOICEID
	,SOPNUMBE,SOPTYPE,DOCAMNT,BACHNUMB,CUSTNMBR,CUSTNAME,CSTPONBR from (
	select CASE SOPTYPE 
				 WHEN 3 then substring(SOPNUMBE,1,abs(datalength(rtrim(SOPNUMBE))-3)) /*720,XXX*/
				 WHEN 4 then substring(SOPNUMBE,1,abs(datalength(rtrim(SOPNUMBE))-6)) /*CR-XXX,CM-XXX*/
				 ELSE ''
				 END as SERVICE_TRAX_INVOICEID
	,SOPNUMBE,SOPTYPE,CASE SOPTYPE WHEN 3 then DOCAMNT WHEN 4 THEN DOCAMNT * -1 END DOCAMNT,BACHNUMB,CUSTNMBR,CUSTNAME,CSTPONBR 
	from CIINC..SOP30200 
	where DOCDATE between @begdate and @enddate ) x
	) b on b.SERVICE_TRAX_INVOICEID=a.INVOICE_ID where CUSTOMER_NAME=@customer and ORGANIZATION_ID=@ORG_ID
/* This was the old way of calculating avg sales over 28 day period from servicee trax only 
	select @salesTotal=sum(bill_total)/@numdays from service_lines WITH (NOLOCK) inner join jobs WITH (NOLOCK) on jobs.JOB_NO=service_lines.BILL_JOB_NO 
		inner join CUSTOMERS WITH (NOLOCK) on JOBS.CUSTOMER_ID=CUSTOMERS.CUSTOMER_ID and BILLED_FLAG='Y' and SERVICE_LINE_DATE 
		in (select distinct DATEREPORTRUN from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK) 

		where DATEREPORTRUN between @begdate and @enddate) and CUSTOMER_NAME=@customer 
		and service_lines.ORGANIZATION_ID=@ORG_ID
*/
	select @unbilledGrandTotal=isnull(@sumBillable,0)+isnull(@sumPooledTotal,0)+isnull(@sumUnbilledOpsInvoices,0)
	if isnull(@salesTotal,0) <> 0 --Ensure there are sales for this time period, and not only unbilled sales to avoid divide by zero error
	begin
		select @DSOTotal=isnull(@unbilledGrandTotal,0)/isnull(@salesTotal,0)
	end
	insert into @tbl values('Unbilled OPs',@ORG_ID,@customer,@unbilledGrandTotal,isnull(@salesTotal,0),isnull(@DSOTotal,0))
	/* clear the variables for the next loop */
	select @customer='',@JOB_NO='',@sumBillable=0,@sumNonBillable=0,@sumPooledTotal=0,@sumUnbilledOpsInvoices=0,
			@salesTotal=0,@unbilledGrandTotal=0,@DSOTotal=0
	FETCH NEXT FROM C_Cursor INTO @customer
end
DEALLOCATE C_Cursor

declare @name varchar(255),
		@userID int

declare C_Cursor CURSOR for select rtrim(FIRST_NAME) + ' ' + rtrim(LAST_NAME) fullName,USER_ID
 from USERS WITH (NOLOCK) union
	select 'UNKNOWN USER','-999'
OPEN C_Cursor
FETCH NEXT FROM C_Cursor INTO @name,@userID
WHILE (@@FETCH_STATUS <> -1)
begin /*Find the totals for this particular customer and organization for this 28 day time period */
select @sumBillable=sum(billable_total)/@numdays,@sumNonBillable=sum(non_billable_total)/@numdays
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where BILLING_USER_ID=@userID and
		DATEREPORTRUN between @begdate and @enddate and ORGANIZATION_ID=@ORG_ID

		select @sumPooledTotal=sum(PooledTotal)/@numdays from
		(select bill_job_id,PooledTotal
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where BILLING_USER_ID=@userID and
		DATEREPORTRUN between @begdate and @enddate and ORGANIZATION_ID=@ORG_ID
		GROUP BY BILL_JOB_ID,PooledTotal) a 

		select @sumUnbilledOpsInvoices=sum(UnbilledOpsInvoicesTotal)/@numdays from
		(select bill_job_id,UnbilledOpsInvoicesTotal
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where BILLING_USER_ID=@userID and
		DATEREPORTRUN between @begdate and @enddate and ORGANIZATION_ID=@ORG_ID
		GROUP BY BILL_JOB_ID,UnbilledOpsInvoicesTotal) a 

	/*Total sales average for the number of days specified by @numdays for user*/
	select @salesTotal=sum(DOCAMNT)/@numdays from (
	SELECT    ltrim(rtrim(str(a.INVOICE_ID))) INVOICE_ID,BILL_CUSTOMER_ID,EXT_BILL_CUST_ID,SALES_REPS,a.ORGANIZATION_ID,b.BILLING_USER_ID
	FROM         IMS_NEW..INVOICES a left outer join JOBS b on a.JOB_ID=b.JOB_ID
	WHERE a.ORGANIZATION_ID=@ORG_ID and a.STATUS_ID=4 
	) a
	INNER JOIN
	(
	select case right(rtrim(SERVICE_TRAX_INVOICEID),1)
	WHEN '-' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-1)) /* -XXX*/
	WHEN '0' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-2)) /* -0XXX*/
	WHEN 'C' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-1)) /* CM-0XXX */
	ELSE SERVICE_TRAX_INVOICEID /* INV suffix */
	END as SERVICE_TRAX_INVOICEID
	,SOPNUMBE,SOPTYPE,DOCAMNT,BACHNUMB,CUSTNMBR,CUSTNAME,CSTPONBR from (
	select CASE SOPTYPE 
				 WHEN 3 then substring(SOPNUMBE,1,abs(datalength(rtrim(SOPNUMBE))-3)) /*720,XXX*/
				 WHEN 4 then substring(SOPNUMBE,1,abs(datalength(rtrim(SOPNUMBE))-6)) /*CR-XXX,CM-XXX*/
				 ELSE ''
				 END as SERVICE_TRAX_INVOICEID
	,SOPNUMBE,SOPTYPE,CASE SOPTYPE WHEN 3 then DOCAMNT WHEN 4 THEN DOCAMNT * -1 END DOCAMNT,BACHNUMB,CUSTNMBR,CUSTNAME,CSTPONBR from CIINC..SOP30200 
	where DOCDATE between @begdate and @enddate ) x
	) b on b.SERVICE_TRAX_INVOICEID=a.INVOICE_ID where BILLING_USER_ID=@userID
/* This was the old way of calculating avg sales over 28 day period from service trax only
	select @salesTotal=sum(bill_total)/@numdays from service_lines WITH (NOLOCK) inner join jobs_v WITH (NOLOCK) on jobs_v.JOB_NO=service_lines.BILL_JOB_NO
		inner join CUSTOMERS WITH (NOLOCK) on JOBS_V.CUSTOMER_ID=CUSTOMERS.CUSTOMER_ID
		and SERVICE_LINE_DATE in (select distinct DATEREPORTRUN from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where DATEREPORTRUN between @begdate and @enddate)	and BILLING_USER_ID=@resid 
*/
	select @unbilledGrandTotal=isnull(@sumBillable,0)+isnull(@sumPooledTotal,0)+isnull(@sumUnbilledOpsInvoices,0)
	if isnull(@salesTotal,0) <> 0 --Ensure there are sales for this time period, and not only unbilled sales to avoid divide by zero error
	begin
		select @DSOTotal=isnull(@unbilledGrandTotal,0)/isnull(@salesTotal,0)
	end
	if @unbilledGrandTotal <> 0 
	begin	
		insert into @tbl values('Projects',999,@name,@unbilledGrandTotal,isnull(@salesTotal,0),isnull(@DSOTotal,0))
	end
	/* clear the variables for the next loop */
	select @name='',@userID=-1,@sumBillable=0,@sumNonBillable=0,@sumPooledTotal=0,@sumUnbilledOpsInvoices=0,
				@salesTotal=0,@unbilledGrandTotal=0,@DSOTotal=0
	FETCH NEXT FROM C_Cursor INTO @name,@userID
end
DEALLOCATE C_Cursor

/*Query for all Unbilled Accounting Items (Pending and Complete)
SELECT sum(iv.custom_line_total) custom_tot, sum(iv.bill_hourly_total) hours_total, sum(iv.bill_exp_total) exp_tot, iv.ext_batch_id, iv.assigned_to_name, iv.job_no, iv.job_id, iv.batch_status_id, ibs.name batch_status_name,
						sum(iv.bill_total + iv.custom_line_total) total_tot, iv.invoice_id_trk, iv.invoice_id, iv.invoice_description, iv.invoice_type_name, iv.invoice_status_id, iv.date_sent, iv.ext_dealer_id, iv.dealer_name, iv.customer_name, iv.invoice_format_type_name, iv.po_no, iv.invoice_date_created
		FROM invoice_pre_total_v iv, invoice_batch_statuses ibs
		WHERE iv.batch_status_id = ibs.status_id
		AND iv.invoice_status_id in (2,3) --Pending and Complete
		GROUP BY iv.invoice_id, iv.invoice_id_trk, iv.invoice_description, iv.invoice_type_name, iv.invoice_status_id, iv.date_sent, iv.ext_dealer_id, iv.dealer_name, iv.customer_name, iv.ext_batch_id, iv.assigned_to_name, iv.invoice_format_type_name, iv.job_no, iv.job_id, iv.po_no, iv.batch_status_id, iv.invoice_date_created, ibs.name
		ORDER BY iv.invoice_id
*/
insert into @tbl select 'Unbilled Accounting',iv.ORGANIZATION_ID,customer_name,sum(iv.bill_total + iv.custom_line_total) total_tot,0,0
		FROM invoice_pre_total_v iv WITH (NOLOCK), invoice_batch_statuses ibs WITH (NOLOCK)
		WHERE iv.batch_status_id = ibs.status_id
		AND iv.invoice_status_id in (2,3) --Pending and Complete
		and iv.ORGANIZATION_ID=@ORG_ID
		GROUP BY iv.invoice_id, iv.invoice_id_trk, iv.invoice_description, iv.invoice_type_name, iv.invoice_status_id, iv.date_sent, iv.ext_dealer_id, iv.dealer_name, iv.customer_name, iv.ext_batch_id, iv.assigned_to_name, iv.invoice_format_type_name, iv.job_no, iv.job_id, iv.po_no, iv.batch_status_id, iv.invoice_date_created, ibs.name, iv.ORGANIZATION_ID
		ORDER BY iv.invoice_id

select  TYPE,b.ORGANIZATION_ID,CUSTOMER_NAME,UnbilledDollars,AvgDaySales,DSO,b.NAME from @tbl a 
INNER JOIN (SELECT ORGANIZATION_ID,NAME FROM ORGANIZATIONS
UNION ALL
SELECT '999', 'PROJECTS') b on a.organization_id=b.organization_id
--select  TYPE,ORGANIZATIONS.ORGANIZATION_ID,CUSTOMER_NAME,UnbilledDollars,AvgDaySales,DSO,NAME from @tbl a
--left outer join ORGANIZATIONS on ORGANIZATIONS.ORGANIZATION_ID=a.ORGANIZATION_ID

--drop table @tbl

endprocess:

--exec sp_CRYSTAL_UNBILLED_REPORT_CIINC
GO
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_UNBILLED_REPORT_ICS_DATERANGE]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_CRYSTAL_UNBILLED_REPORT_ICS_DATERANGE]
	@begdate datetime, @enddate datetime
AS
set nocount on

declare @tbl TABLE (
	[TYPE] char(255),
	[ORGANIZATION_ID] [numeric] (19,0),
	[CUSTOMER_NAME] varchar(255) ,
	[UnbilledDollars] [numeric](19, 5) ,
	[AvgDaySales] [numeric](19, 5),
	[DSO] [numeric](19, 5)
) 

/* Find number of days to divide unbilled $'s by.  Always done by 28 day time periods*/
declare @numdays int
select @numdays=0
select @begdate=CAST(FLOOR(CAST(@begdate AS FLOAT))AS DATETIME)
select @enddate=CAST(FLOOR(CAST(@enddate AS FLOAT))AS DATETIME)
select @numdays=count(*) from (select distinct DATEREPORTRUN from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
	where DATEREPORTRUN <= @enddate and DATEREPORTRUN >= @begdate) a

/* avoid divide by zero error (no data in dailydatacapture)*/
if @numdays <= 0 goto endprocess

declare @customer varchar(255),
				@ORG_ID numeric(19,0),
				@JOB_NO varchar(255),
				@sumBillable numeric(19,5),
				@sumNonBillable numeric(19,5),
				@sumPooledTotal numeric(19,5),
				@sumUnbilledOpsInvoices numeric(19,5),
				@salesTotal numeric(19,5),
				@unbilledGrandTotal numeric(19,5),
				@DSOTotal numeric(19,5)

select @ORG_ID=12

declare C_Cursor CURSOR for select DISTINCT CUSTOMER_NAME from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK) where ORGANIZATION_ID=@ORG_ID order by CUSTOMER_NAME asc
OPEN C_Cursor
FETCH NEXT FROM C_Cursor INTO @customer
WHILE (@@FETCH_STATUS <> -1)
begin /*Find the totals for this particular customer and organization for this 28 day time period */
	select @sumBillable=sum(billable_total)/@numdays
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where CUSTOMER_NAME=@customer and ORGANIZATION_ID=@ORG_ID and 
		DATEREPORTRUN between @begdate and @enddate 

		select @sumPooledTotal=sum(PooledTotal)/@numdays from
		(select bill_job_id,PooledTotal
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where CUSTOMER_NAME=@customer and ORGANIZATION_ID=@ORG_ID and 
		DATEREPORTRUN between @begdate and @enddate
		GROUP BY BILL_JOB_ID,PooledTotal) a 

		select @sumUnbilledOpsInvoices=sum(UnbilledOpsInvoicesTotal)/@numdays from
		(select bill_job_id,UnbilledOpsInvoicesTotal
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where CUSTOMER_NAME=@customer and ORGANIZATION_ID=@ORG_ID and 
		DATEREPORTRUN between @begdate and @enddate
		GROUP BY BILL_JOB_ID,UnbilledOpsInvoicesTotal) a 

	/*Total sales average for the number of days specified by @numdays */
	select @salesTotal=sum(DOCAMNT)/@numdays from (
	SELECT    ltrim(rtrim(str(INVOICE_ID))) INVOICE_ID,BILL_CUSTOMER_ID,EXT_BILL_CUST_ID,SALES_REPS,EXT_DEALER_ID,EXT_CUSTOMER_ID,CUSTOMER_NAME,a.ORGANIZATION_ID
	FROM         IMS_NEW..INVOICES a LEFT OUTER JOIN CUSTOMERS b on a.BILL_CUSTOMER_ID=b.CUSTOMER_ID
	WHERE a.ORGANIZATION_ID=@ORG_ID and a.STATUS_ID=4
	) a
	INNER JOIN
	(
	select case 
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),1) = '-' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-1)) /* -XXX*/
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),2) = '-0' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-2)) /* -0XXX*/
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),4) = 'CM-0' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-4)) /* CM-0XXX */
	ELSE SERVICE_TRAX_INVOICEID /* INV suffix */
	END as SERVICE_TRAX_INVOICEID
	,SOPNUMBE,SOPTYPE,DOCAMNT,BACHNUMB,CUSTNMBR,CUSTNAME,CSTPONBR from (
	select CASE SOPTYPE 
				 WHEN 3 then substring(SOPNUMBE,1,abs(datalength(rtrim(SOPNUMBE))-3)) /*720,XXX*/
				 WHEN 4 then substring(SOPNUMBE,1,abs(datalength(rtrim(SOPNUMBE))-6)) /*CR-XXX,CM-XXX*/
				 ELSE ''
				 END as SERVICE_TRAX_INVOICEID
	,SOPNUMBE,SOPTYPE,CASE SOPTYPE WHEN 3 then DOCAMNT WHEN 4 THEN DOCAMNT * -1 END DOCAMNT,BACHNUMB,CUSTNMBR,CUSTNAME,CSTPONBR 
	from ICS..SOP30200 
	where DOCDATE between @begdate and @enddate ) x
	) b on b.SERVICE_TRAX_INVOICEID=a.INVOICE_ID where CUSTOMER_NAME=@customer and ORGANIZATION_ID=@ORG_ID
/* This was the old way of calculating avg sales over 28 day period from servicee trax only 
	select @salesTotal=sum(bill_total)/@numdays from service_lines WITH (NOLOCK) inner join jobs WITH (NOLOCK) on jobs.JOB_NO=service_lines.BILL_JOB_NO 
		inner join CUSTOMERS WITH (NOLOCK) on JOBS.CUSTOMER_ID=CUSTOMERS.CUSTOMER_ID and BILLED_FLAG='Y' and SERVICE_LINE_DATE 
		in (select distinct DATEREPORTRUN from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK) 

		where DATEREPORTRUN between @begdate and @enddate) and CUSTOMER_NAME=@customer 
		and service_lines.ORGANIZATION_ID=@ORG_ID
*/
	select @unbilledGrandTotal=isnull(@sumBillable,0)+isnull(@sumPooledTotal,0)+isnull(@sumUnbilledOpsInvoices,0)
	if isnull(@salesTotal,0) <> 0 --Ensure there are sales for this time period, and not only unbilled sales to avoid divide by zero error
	begin
		select @DSOTotal=isnull(@unbilledGrandTotal,0)/isnull(@salesTotal,0)
	end
	insert into @tbl values('Unbilled OPs',@ORG_ID,@customer,@unbilledGrandTotal,isnull(@salesTotal,0),isnull(@DSOTotal,0))
	/* clear the variables for the next loop */
	select @customer='',@JOB_NO='',@sumBillable=0,@sumNonBillable=0,@sumPooledTotal=0,@sumUnbilledOpsInvoices=0,
			@salesTotal=0,@unbilledGrandTotal=0,@DSOTotal=0
	FETCH NEXT FROM C_Cursor INTO @customer
end
DEALLOCATE C_Cursor

declare @name varchar(255),
		@userID int

declare C_Cursor CURSOR for select rtrim(FIRST_NAME) + ' ' + rtrim(LAST_NAME) fullName,USER_ID
 from USERS WITH (NOLOCK) union
	select 'UNKNOWN USER','-999'
OPEN C_Cursor
FETCH NEXT FROM C_Cursor INTO @name,@userID
WHILE (@@FETCH_STATUS <> -1)
begin /*Find the totals for this particular customer and organization for this 28 day time period */
select @sumBillable=sum(billable_total)/@numdays,@sumNonBillable=sum(non_billable_total)/@numdays
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where BILLING_USER_ID=@userID and
		DATEREPORTRUN between @begdate and @enddate and ORGANIZATION_ID=@ORG_ID

		select @sumPooledTotal=sum(PooledTotal)/@numdays from
		(select bill_job_id,PooledTotal
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where BILLING_USER_ID=@userID and
		DATEREPORTRUN between @begdate and @enddate and ORGANIZATION_ID=@ORG_ID
		GROUP BY BILL_JOB_ID,PooledTotal) a 

		select @sumUnbilledOpsInvoices=sum(UnbilledOpsInvoicesTotal)/@numdays from
		(select bill_job_id,UnbilledOpsInvoicesTotal
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where BILLING_USER_ID=@userID and
		DATEREPORTRUN between @begdate and @enddate and ORGANIZATION_ID=@ORG_ID
		GROUP BY BILL_JOB_ID,UnbilledOpsInvoicesTotal) a 

	/*Total sales average for the number of days specified by @numdays for user*/
	select @salesTotal=sum(DOCAMNT)/@numdays from (
	SELECT    ltrim(rtrim(str(a.INVOICE_ID))) INVOICE_ID,BILL_CUSTOMER_ID,EXT_BILL_CUST_ID,SALES_REPS,a.ORGANIZATION_ID,b.BILLING_USER_ID
	FROM         IMS_NEW..INVOICES a left outer join JOBS b on a.JOB_ID=b.JOB_ID
	WHERE a.ORGANIZATION_ID=@ORG_ID and a.STATUS_ID=4 
	) a
	INNER JOIN
	(
	select case 
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),1) = '-' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-1)) /* -XXX*/
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),2) = '-0' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-2)) /* -0XXX*/
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),4) = 'CM-0' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-4)) /* CM-0XXX */
	ELSE SERVICE_TRAX_INVOICEID /* INV suffix */
	END as SERVICE_TRAX_INVOICEID
	,SOPNUMBE,SOPTYPE,DOCAMNT,BACHNUMB,CUSTNMBR,CUSTNAME,CSTPONBR from (
	select CASE SOPTYPE 
				 WHEN 3 then substring(SOPNUMBE,1,abs(datalength(rtrim(SOPNUMBE))-3)) /*720,XXX*/
				 WHEN 4 then substring(SOPNUMBE,1,abs(datalength(rtrim(SOPNUMBE))-6)) /*CR-XXX,CM-XXX*/
				 ELSE ''
				 END as SERVICE_TRAX_INVOICEID
	,SOPNUMBE,SOPTYPE,CASE SOPTYPE WHEN 3 then DOCAMNT WHEN 4 THEN DOCAMNT * -1 END DOCAMNT,BACHNUMB,CUSTNMBR,CUSTNAME,CSTPONBR from ICS..SOP30200 
	where DOCDATE between @begdate and @enddate ) x
	) b on b.SERVICE_TRAX_INVOICEID=a.INVOICE_ID where BILLING_USER_ID=@userID
/* This was the old way of calculating avg sales over 28 day period from service trax only
	select @salesTotal=sum(bill_total)/@numdays from service_lines WITH (NOLOCK) inner join jobs_v WITH (NOLOCK) on jobs_v.JOB_NO=service_lines.BILL_JOB_NO
		inner join CUSTOMERS WITH (NOLOCK) on JOBS_V.CUSTOMER_ID=CUSTOMERS.CUSTOMER_ID
		and SERVICE_LINE_DATE in (select distinct DATEREPORTRUN from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where DATEREPORTRUN between @begdate and @enddate)	and BILLING_USER_ID=@resid 
*/
	select @unbilledGrandTotal=isnull(@sumBillable,0)+isnull(@sumPooledTotal,0)+isnull(@sumUnbilledOpsInvoices,0)
	if isnull(@salesTotal,0) <> 0 --Ensure there are sales for this time period, and not only unbilled sales to avoid divide by zero error
	begin
		select @DSOTotal=isnull(@unbilledGrandTotal,0)/isnull(@salesTotal,0)
	end
	if @unbilledGrandTotal <> 0 
	begin	
		insert into @tbl values('Projects',999,@name,@unbilledGrandTotal,isnull(@salesTotal,0),isnull(@DSOTotal,0))
	end
	/* clear the variables for the next loop */
	select @name='',@userID=-1,@sumBillable=0,@sumNonBillable=0,@sumPooledTotal=0,@sumUnbilledOpsInvoices=0,
				@salesTotal=0,@unbilledGrandTotal=0,@DSOTotal=0
	FETCH NEXT FROM C_Cursor INTO @name,@userID
end
DEALLOCATE C_Cursor

/*Query for all Unbilled Accounting Items (Pending and Complete)
SELECT sum(iv.custom_line_total) custom_tot, sum(iv.bill_hourly_total) hours_total, sum(iv.bill_exp_total) exp_tot, iv.ext_batch_id, iv.assigned_to_name, iv.job_no, iv.job_id, iv.batch_status_id, ibs.name batch_status_name,
						sum(iv.bill_total + iv.custom_line_total) total_tot, iv.invoice_id_trk, iv.invoice_id, iv.invoice_description, iv.invoice_type_name, iv.invoice_status_id, iv.date_sent, iv.ext_dealer_id, iv.dealer_name, iv.customer_name, iv.invoice_format_type_name, iv.po_no, iv.invoice_date_created
		FROM invoice_pre_total_v iv, invoice_batch_statuses ibs
		WHERE iv.batch_status_id = ibs.status_id
		AND iv.invoice_status_id in (2,3) --Pending and Complete
		GROUP BY iv.invoice_id, iv.invoice_id_trk, iv.invoice_description, iv.invoice_type_name, iv.invoice_status_id, iv.date_sent, iv.ext_dealer_id, iv.dealer_name, iv.customer_name, iv.ext_batch_id, iv.assigned_to_name, iv.invoice_format_type_name, iv.job_no, iv.job_id, iv.po_no, iv.batch_status_id, iv.invoice_date_created, ibs.name
		ORDER BY iv.invoice_id
*/
insert into @tbl select 'Unbilled Accounting',iv.ORGANIZATION_ID,customer_name,sum(iv.bill_total + iv.custom_line_total) total_tot,0,0
		FROM invoice_pre_total_v iv WITH (NOLOCK), invoice_batch_statuses ibs WITH (NOLOCK)
		WHERE iv.batch_status_id = ibs.status_id
		AND iv.invoice_status_id in (2,3) --Pending and Complete
		and iv.ORGANIZATION_ID=@ORG_ID
		GROUP BY iv.invoice_id, iv.invoice_id_trk, iv.invoice_description, iv.invoice_type_name, iv.invoice_status_id, iv.date_sent, iv.ext_dealer_id, iv.dealer_name, iv.customer_name, iv.ext_batch_id, iv.assigned_to_name, iv.invoice_format_type_name, iv.job_no, iv.job_id, iv.po_no, iv.batch_status_id, iv.invoice_date_created, ibs.name, iv.ORGANIZATION_ID
		ORDER BY iv.invoice_id

select  TYPE,b.ORGANIZATION_ID,CUSTOMER_NAME,UnbilledDollars,AvgDaySales,DSO,b.NAME from @tbl a 
INNER JOIN (SELECT ORGANIZATION_ID,NAME FROM ORGANIZATIONS
UNION ALL
SELECT '999', 'PROJECTS') b on a.organization_id=b.organization_id
--select  TYPE,ORGANIZATIONS.ORGANIZATION_ID,CUSTOMER_NAME,UnbilledDollars,AvgDaySales,DSO,NAME from @tbl a
--left outer join ORGANIZATIONS on ORGANIZATIONS.ORGANIZATION_ID=a.ORGANIZATION_ID

--drop table @tbl

endprocess:

--exec sp_CRYSTAL_UNBILLED_REPORT_ICS_DATERANGE
GO
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_UNBILLED_REPORT_AMBIM_DEALERNUMBER_DATERANGE]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec sp_CRYSTAL_UNBILLED_REPORT_AMBIM_DEALERNUMBER_DATERANGE '03/01/2006','03/02/2006','3017'
CREATE PROCEDURE [dbo].[sp_CRYSTAL_UNBILLED_REPORT_AMBIM_DEALERNUMBER_DATERANGE]
	@begdate datetime, @enddate datetime, @DEALERNUMBER char(31)
AS
set nocount on

declare @tbl TABLE (
	[TYPE] char(255),
	[ORGANIZATION_ID] [numeric] (19,0),
	[CUSTOMER_NAME] varchar(255) ,
	[UnbilledDollars] [numeric](19, 5) ,
	[AvgDaySales] [numeric](19, 5),
	[DSO] [numeric](19, 5)
) 

/* Find number of days to divide unbilled $'s by.  Always done by 28 day time periods*/
declare @numdays int
select @numdays=0
select @begdate=CAST(FLOOR(CAST(@begdate AS FLOAT))AS DATETIME)
select @enddate=CAST(FLOOR(CAST(@enddate AS FLOAT))AS DATETIME)
select @numdays=count(*) from (select distinct DATEREPORTRUN from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
	where DATEREPORTRUN <= @enddate and DATEREPORTRUN >= @begdate) a

/* avoid divide by zero error (no data in dailydatacapture)*/
if @numdays <= 0 goto endprocess

declare @customer varchar(255),
				@ORG_ID numeric(19,0),
				@JOB_NO varchar(255),
				@sumBillable numeric(19,5),
				@sumNonBillable numeric(19,5),
				@sumPooledTotal numeric(19,5),
				@sumUnbilledOpsInvoices numeric(19,5),
				@salesTotal numeric(19,5),
				@unbilledGrandTotal numeric(19,5),
				@DSOTotal numeric(19,5)

select @ORG_ID=2

declare C_Cursor CURSOR for select DISTINCT CUSTOMER_NAME from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK) 
	where ORGANIZATION_ID=@ORG_ID 
	and EXT_DEALER_ID=@DEALERNUMBER and DATEREPORTRUN between @begdate and @enddate order by CUSTOMER_NAME asc
OPEN C_Cursor
FETCH NEXT FROM C_Cursor INTO @customer
WHILE (@@FETCH_STATUS <> -1)
begin /*Find the totals for this particular customer and organization for this 28 day time period */
	select @sumBillable=sum(billable_total)/@numdays
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where CUSTOMER_NAME=@customer and ORGANIZATION_ID=@ORG_ID and 
		DATEREPORTRUN between @begdate and @enddate 
		and EXT_DEALER_ID=@DEALERNUMBER

		select @sumPooledTotal=sum(PooledTotal)/@numdays from
		(select bill_job_id,PooledTotal
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where CUSTOMER_NAME=@customer and ORGANIZATION_ID=@ORG_ID and 
		DATEREPORTRUN between @begdate and @enddate
		and EXT_DEALER_ID=@DEALERNUMBER
		GROUP BY BILL_JOB_ID,PooledTotal) a 

		select @sumUnbilledOpsInvoices=sum(UnbilledOpsInvoicesTotal)/@numdays from
		(select bill_job_id,UnbilledOpsInvoicesTotal
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where CUSTOMER_NAME=@customer and ORGANIZATION_ID=@ORG_ID and 
		DATEREPORTRUN between @begdate and @enddate
		and EXT_DEALER_ID=@DEALERNUMBER
		GROUP BY BILL_JOB_ID,UnbilledOpsInvoicesTotal) a 

	/*Total sales average for the number of days specified by @numdays */
	select @salesTotal=sum(DOCAMNT)/@numdays from (
	SELECT    ltrim(rtrim(str(INVOICE_ID))) INVOICE_ID,BILL_CUSTOMER_ID,EXT_BILL_CUST_ID,SALES_REPS,EXT_DEALER_ID,EXT_CUSTOMER_ID,CUSTOMER_NAME,a.ORGANIZATION_ID
	FROM         IMS_NEW..INVOICES a LEFT OUTER JOIN CUSTOMERS b on a.BILL_CUSTOMER_ID=b.CUSTOMER_ID
	WHERE a.ORGANIZATION_ID=@ORG_ID and a.STATUS_ID=4
	) a
	INNER JOIN
	(
	select case 
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),1) = '-' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-1)) /* -XXX*/
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),2) = '-0' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-2)) /* -0XXX*/
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),4) = 'CM-0' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-4)) /* CM-0XXX */
	ELSE SERVICE_TRAX_INVOICEID /* INV suffix */
	END as SERVICE_TRAX_INVOICEID
	,SOPNUMBE,SOPTYPE,DOCAMNT,BACHNUMB,CUSTNMBR,CUSTNAME,CSTPONBR from (
	select CASE SOPTYPE 
				 WHEN 3 then substring(SOPNUMBE,1,abs(datalength(rtrim(SOPNUMBE))-3)) /*720,XXX*/
				 WHEN 4 then substring(SOPNUMBE,1,abs(datalength(rtrim(SOPNUMBE))-6)) /*CR-XXX,CM-XXX*/
				 ELSE ''
				 END as SERVICE_TRAX_INVOICEID
	,SOPNUMBE,SOPTYPE,CASE SOPTYPE WHEN 3 then DOCAMNT WHEN 4 THEN DOCAMNT * -1 END DOCAMNT,BACHNUMB,CUSTNMBR,CUSTNAME,CSTPONBR 
	from AMBIM..SOP30200 
	where DOCDATE between @begdate and @enddate and CUSTNMBR=@DEALERNUMBER) x
	) b on b.SERVICE_TRAX_INVOICEID=a.INVOICE_ID where CUSTOMER_NAME=@customer and ORGANIZATION_ID=@ORG_ID
/* This was the old way of calculating avg sales over 28 day period from servicee trax only 
	select @salesTotal=sum(bill_total)/@numdays from service_lines WITH (NOLOCK) inner join jobs WITH (NOLOCK) on jobs.JOB_NO=service_lines.BILL_JOB_NO 
		inner join CUSTOMERS WITH (NOLOCK) on JOBS.CUSTOMER_ID=CUSTOMERS.CUSTOMER_ID and BILLED_FLAG='Y' and SERVICE_LINE_DATE 
		in (select distinct DATEREPORTRUN from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK) 

		where DATEREPORTRUN between @begdate and @enddate) and CUSTOMER_NAME=@customer 
		and service_lines.ORGANIZATION_ID=@ORG_ID
*/
	select @unbilledGrandTotal=isnull(@sumBillable,0)+isnull(@sumPooledTotal,0)+isnull(@sumUnbilledOpsInvoices,0)
	if isnull(@salesTotal,0) <> 0 --Ensure there are sales for this time period, and not only unbilled sales to avoid divide by zero error
	begin
		select @DSOTotal=isnull(@unbilledGrandTotal,0)/isnull(@salesTotal,0)
	end
	insert into @tbl values('Unbilled OPs',@ORG_ID,@customer,@unbilledGrandTotal,isnull(@salesTotal,0),isnull(@DSOTotal,0))
	/* clear the variables for the next loop */
	select @customer='',@JOB_NO='',@sumBillable=0,@sumNonBillable=0,@sumPooledTotal=0,@sumUnbilledOpsInvoices=0,
			@salesTotal=0,@unbilledGrandTotal=0,@DSOTotal=0

	FETCH NEXT FROM C_Cursor INTO @customer
end
DEALLOCATE C_Cursor

declare @name varchar(255),
		@userID int

declare C_Cursor CURSOR for select rtrim(FIRST_NAME) + ' ' + rtrim(LAST_NAME) fullName,USER_ID
 from USERS WITH (NOLOCK) union
	select 'UNKNOWN USER','-999'
OPEN C_Cursor
FETCH NEXT FROM C_Cursor INTO @name,@userID
WHILE (@@FETCH_STATUS <> -1)
begin /*Find the totals for this particular customer and organization for this 28 day time period */
select @sumBillable=sum(billable_total)/@numdays,@sumNonBillable=sum(non_billable_total)/@numdays
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where BILLING_USER_ID=@userID and
		DATEREPORTRUN between @begdate and @enddate and ORGANIZATION_ID=@ORG_ID and EXT_DEALER_ID=@DEALERNUMBER

		select @sumPooledTotal=sum(PooledTotal)/@numdays from
		(select bill_job_id,PooledTotal
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where BILLING_USER_ID=@userID and
		DATEREPORTRUN between @begdate and @enddate and ORGANIZATION_ID=@ORG_ID and EXT_DEALER_ID=@DEALERNUMBER
		GROUP BY BILL_JOB_ID,PooledTotal) a 

		select @sumUnbilledOpsInvoices=sum(UnbilledOpsInvoicesTotal)/@numdays from
		(select bill_job_id,UnbilledOpsInvoicesTotal
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where BILLING_USER_ID=@userID and
		DATEREPORTRUN between @begdate and @enddate and ORGANIZATION_ID=@ORG_ID and EXT_DEALER_ID=@DEALERNUMBER
		GROUP BY BILL_JOB_ID,UnbilledOpsInvoicesTotal) a 

	/*Total sales average for the number of days specified by @numdays for user*/
	select @salesTotal=sum(DOCAMNT)/@numdays from (
	SELECT    ltrim(rtrim(str(a.INVOICE_ID))) INVOICE_ID,BILL_CUSTOMER_ID,EXT_BILL_CUST_ID,SALES_REPS,a.ORGANIZATION_ID,b.BILLING_USER_ID
	FROM         IMS_NEW..INVOICES a left outer join JOBS b on a.JOB_ID=b.JOB_ID
	WHERE a.ORGANIZATION_ID=@ORG_ID and a.STATUS_ID=4 
	) a
	INNER JOIN
	(
	select case 
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),1) = '-' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-1)) /* -XXX*/
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),2) = '-0' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-2)) /* -0XXX*/
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),4) = 'CM-0' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-4)) /* CM-0XXX */
	ELSE SERVICE_TRAX_INVOICEID /* INV suffix */
	END as SERVICE_TRAX_INVOICEID
	,SOPNUMBE,SOPTYPE,DOCAMNT,BACHNUMB,CUSTNMBR,CUSTNAME,CSTPONBR from (
	select CASE SOPTYPE 
				 WHEN 3 then substring(SOPNUMBE,1,abs(datalength(rtrim(SOPNUMBE))-3)) /*720,XXX*/
				 WHEN 4 then substring(SOPNUMBE,1,abs(datalength(rtrim(SOPNUMBE))-6)) /*CR-XXX,CM-XXX*/
				 ELSE ''
				 END as SERVICE_TRAX_INVOICEID
	,SOPNUMBE,SOPTYPE,CASE SOPTYPE WHEN 3 then DOCAMNT WHEN 4 THEN DOCAMNT * -1 END DOCAMNT,BACHNUMB,CUSTNMBR,CUSTNAME,CSTPONBR from AMBIM..SOP30200 
	where DOCDATE between @begdate and @enddate and CUSTNMBR=@DEALERNUMBER ) x
	) b on b.SERVICE_TRAX_INVOICEID=a.INVOICE_ID where BILLING_USER_ID=@userID

/* This was the old way of calculating avg sales over 28 day period from service trax only
	select @salesTotal=sum(bill_total)/@numdays from service_lines WITH (NOLOCK) inner join jobs_v WITH (NOLOCK) on jobs_v.JOB_NO=service_lines.BILL_JOB_NO
		inner join CUSTOMERS WITH (NOLOCK) on JOBS_V.CUSTOMER_ID=CUSTOMERS.CUSTOMER_ID
		and SERVICE_LINE_DATE in (select distinct DATEREPORTRUN from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where DATEREPORTRUN between @begdate and @enddate)	and BILLING_USER_ID=@resid 
*/
	select @unbilledGrandTotal=isnull(@sumBillable,0)+isnull(@sumPooledTotal,0)+isnull(@sumUnbilledOpsInvoices,0)
	if isnull(@salesTotal,0) <> 0 --Ensure there are sales for this time period, and not only unbilled sales to avoid divide by zero error
	begin
		select @DSOTotal=isnull(@unbilledGrandTotal,0)/isnull(@salesTotal,0)
	end
	if @unbilledGrandTotal <> 0 
	begin	
		insert into @tbl values('Projects',999,@name,@unbilledGrandTotal,isnull(@salesTotal,0),isnull(@DSOTotal,0))
	end
	/* clear the variables for the next loop */
	select @name='',@userID=-1,@sumBillable=0,@sumNonBillable=0,@sumPooledTotal=0,@sumUnbilledOpsInvoices=0,
				@salesTotal=0,@unbilledGrandTotal=0,@DSOTotal=0
	FETCH NEXT FROM C_Cursor INTO @name,@userID
end
DEALLOCATE C_Cursor

/*Query for all Unbilled Accounting Items (Pending and Complete)
SELECT sum(iv.custom_line_total) custom_tot, sum(iv.bill_hourly_total) hours_total, sum(iv.bill_exp_total) exp_tot, iv.ext_batch_id, iv.assigned_to_name, iv.job_no, iv.job_id, iv.batch_status_id, ibs.name batch_status_name,
						sum(iv.bill_total + iv.custom_line_total) total_tot, iv.invoice_id_trk, iv.invoice_id, iv.invoice_description, iv.invoice_type_name, iv.invoice_status_id, iv.date_sent, iv.ext_dealer_id, iv.dealer_name, iv.customer_name, iv.invoice_format_type_name, iv.po_no, iv.invoice_date_created
		FROM invoice_pre_total_v iv, invoice_batch_statuses ibs
		WHERE iv.batch_status_id = ibs.status_id
		AND iv.invoice_status_id in (2,3) --Pending and Complete
		GROUP BY iv.invoice_id, iv.invoice_id_trk, iv.invoice_description, iv.invoice_type_name, iv.invoice_status_id, iv.date_sent, iv.ext_dealer_id, iv.dealer_name, iv.customer_name, iv.ext_batch_id, iv.assigned_to_name, iv.invoice_format_type_name, iv.job_no, iv.job_id, iv.po_no, iv.batch_status_id, iv.invoice_date_created, ibs.name
		ORDER BY iv.invoice_id
*/
insert into @tbl select 'Unbilled Accounting',iv.ORGANIZATION_ID,customer_name,sum(iv.bill_total + iv.custom_line_total) total_tot,0,0
		FROM invoice_pre_total_v iv WITH (NOLOCK), invoice_batch_statuses ibs WITH (NOLOCK)
		WHERE iv.batch_status_id = ibs.status_id
		AND iv.invoice_status_id in (2,3) --Pending and Complete
		and iv.ORGANIZATION_ID=@ORG_ID
		and iv.EXT_DEALER_ID=@DEALERNUMBER
		GROUP BY iv.invoice_id, iv.invoice_id_trk, iv.invoice_description, iv.invoice_type_name, iv.invoice_status_id, iv.date_sent, iv.ext_dealer_id, iv.dealer_name, iv.customer_name, iv.ext_batch_id, iv.assigned_to_name, iv.invoice_format_type_name, iv.job_no, iv.job_id, iv.po_no, iv.batch_status_id, iv.invoice_date_created, ibs.name, iv.ORGANIZATION_ID
		ORDER BY iv.invoice_id

select  TYPE,b.ORGANIZATION_ID,CUSTOMER_NAME,UnbilledDollars,AvgDaySales,DSO,b.NAME from @tbl a 
INNER JOIN (SELECT ORGANIZATION_ID,NAME FROM ORGANIZATIONS
UNION ALL
SELECT '999', 'PROJECTS') b on a.organization_id=b.organization_id
--select  TYPE,ORGANIZATIONS.ORGANIZATION_ID,CUSTOMER_NAME,UnbilledDollars,AvgDaySales,DSO,NAME from @tbl a
--left outer join ORGANIZATIONS on ORGANIZATIONS.ORGANIZATION_ID=a.ORGANIZATION_ID

--drop table @tbl

endprocess:

--exec sp_CRYSTAL_UNBILLED_REPORT_AMBIM_DATERANGE
GO
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_UNBILLED_REPORT_CIINC_DATERANGE]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_CRYSTAL_UNBILLED_REPORT_CIINC_DATERANGE]
	@begdate datetime, @enddate datetime
AS
set nocount on

declare @tbl TABLE (
	[TYPE] char(255),
	[ORGANIZATION_ID] [numeric] (19,0),
	[CUSTOMER_NAME] varchar(255) ,
	[UnbilledDollars] [numeric](19, 5) ,
	[AvgDaySales] [numeric](19, 5),
	[DSO] [numeric](19, 5)
) 

/* Find number of days to divide unbilled $'s by.  Always done by 28 day time periods*/
declare @numdays int
select @numdays=0
select @begdate=CAST(FLOOR(CAST(@begdate AS FLOAT))AS DATETIME)
select @enddate=CAST(FLOOR(CAST(@enddate AS FLOAT))AS DATETIME)
select @numdays=count(*) from (select distinct DATEREPORTRUN from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
	where DATEREPORTRUN <= @enddate and DATEREPORTRUN >= @begdate) a

/* avoid divide by zero error (no data in dailydatacapture)*/
if @numdays <= 0 goto endprocess

declare @customer varchar(255),
				@ORG_ID numeric(19,0),
				@JOB_NO varchar(255),
				@sumBillable numeric(19,5),
				@sumNonBillable numeric(19,5),
				@sumPooledTotal numeric(19,5),
				@sumUnbilledOpsInvoices numeric(19,5),
				@salesTotal numeric(19,5),
				@unbilledGrandTotal numeric(19,5),
				@DSOTotal numeric(19,5)

select @ORG_ID=10

declare C_Cursor CURSOR for select DISTINCT CUSTOMER_NAME from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK) where ORGANIZATION_ID=@ORG_ID order by CUSTOMER_NAME asc
OPEN C_Cursor
FETCH NEXT FROM C_Cursor INTO @customer
WHILE (@@FETCH_STATUS <> -1)
begin /*Find the totals for this particular customer and organization for this 28 day time period */
	select @sumBillable=sum(billable_total)/@numdays
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where CUSTOMER_NAME=@customer and ORGANIZATION_ID=@ORG_ID and 
		DATEREPORTRUN between @begdate and @enddate 

		select @sumPooledTotal=sum(PooledTotal)/@numdays from
		(select bill_job_id,PooledTotal
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where CUSTOMER_NAME=@customer and ORGANIZATION_ID=@ORG_ID and 
		DATEREPORTRUN between @begdate and @enddate
		GROUP BY BILL_JOB_ID,PooledTotal) a 

		select @sumUnbilledOpsInvoices=sum(UnbilledOpsInvoicesTotal)/@numdays from
		(select bill_job_id,UnbilledOpsInvoicesTotal
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where CUSTOMER_NAME=@customer and ORGANIZATION_ID=@ORG_ID and 
		DATEREPORTRUN between @begdate and @enddate
		GROUP BY BILL_JOB_ID,UnbilledOpsInvoicesTotal) a 

	/*Total sales average for the number of days specified by @numdays */
	select @salesTotal=sum(DOCAMNT)/@numdays from (
	SELECT    ltrim(rtrim(str(INVOICE_ID))) INVOICE_ID,BILL_CUSTOMER_ID,EXT_BILL_CUST_ID,SALES_REPS,EXT_DEALER_ID,EXT_CUSTOMER_ID,CUSTOMER_NAME,a.ORGANIZATION_ID
	FROM         IMS_NEW..INVOICES a LEFT OUTER JOIN CUSTOMERS b on a.BILL_CUSTOMER_ID=b.CUSTOMER_ID
	WHERE a.ORGANIZATION_ID=@ORG_ID and a.STATUS_ID=4
	) a
	INNER JOIN
	(
	select case 
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),1) = '-' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-1)) /* -XXX*/
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),2) = '-0' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-2)) /* -0XXX*/
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),4) = 'CM-0' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-4)) /* CM-0XXX */
	ELSE SERVICE_TRAX_INVOICEID /* INV suffix */
	END as SERVICE_TRAX_INVOICEID
	,SOPNUMBE,SOPTYPE,DOCAMNT,BACHNUMB,CUSTNMBR,CUSTNAME,CSTPONBR from (
	select CASE SOPTYPE 
				 WHEN 3 then substring(SOPNUMBE,1,abs(datalength(rtrim(SOPNUMBE))-3)) /*720,XXX*/
				 WHEN 4 then substring(SOPNUMBE,1,abs(datalength(rtrim(SOPNUMBE))-6)) /*CR-XXX,CM-XXX*/
				 ELSE ''
				 END as SERVICE_TRAX_INVOICEID
	,SOPNUMBE,SOPTYPE,CASE SOPTYPE WHEN 3 then DOCAMNT WHEN 4 THEN DOCAMNT * -1 END DOCAMNT,BACHNUMB,CUSTNMBR,CUSTNAME,CSTPONBR 
	from CIINC..SOP30200 
	where DOCDATE between @begdate and @enddate ) x
	) b on b.SERVICE_TRAX_INVOICEID=a.INVOICE_ID where CUSTOMER_NAME=@customer and ORGANIZATION_ID=@ORG_ID
/* This was the old way of calculating avg sales over 28 day period from servicee trax only 
	select @salesTotal=sum(bill_total)/@numdays from service_lines WITH (NOLOCK) inner join jobs WITH (NOLOCK) on jobs.JOB_NO=service_lines.BILL_JOB_NO 
		inner join CUSTOMERS WITH (NOLOCK) on JOBS.CUSTOMER_ID=CUSTOMERS.CUSTOMER_ID and BILLED_FLAG='Y' and SERVICE_LINE_DATE 
		in (select distinct DATEREPORTRUN from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK) 

		where DATEREPORTRUN between @begdate and @enddate) and CUSTOMER_NAME=@customer 
		and service_lines.ORGANIZATION_ID=@ORG_ID
*/
	select @unbilledGrandTotal=isnull(@sumBillable,0)+isnull(@sumPooledTotal,0)+isnull(@sumUnbilledOpsInvoices,0)
	if isnull(@salesTotal,0) <> 0 --Ensure there are sales for this time period, and not only unbilled sales to avoid divide by zero error
	begin
		select @DSOTotal=isnull(@unbilledGrandTotal,0)/isnull(@salesTotal,0)
	end
	insert into @tbl values('Unbilled OPs',@ORG_ID,@customer,@unbilledGrandTotal,isnull(@salesTotal,0),isnull(@DSOTotal,0))
	/* clear the variables for the next loop */
	select @customer='',@JOB_NO='',@sumBillable=0,@sumNonBillable=0,@sumPooledTotal=0,@sumUnbilledOpsInvoices=0,
			@salesTotal=0,@unbilledGrandTotal=0,@DSOTotal=0
	FETCH NEXT FROM C_Cursor INTO @customer
end
DEALLOCATE C_Cursor

declare @name varchar(255),
		@userID int

declare C_Cursor CURSOR for select rtrim(FIRST_NAME) + ' ' + rtrim(LAST_NAME) fullName,USER_ID
 from USERS WITH (NOLOCK) union
	select 'UNKNOWN USER','-999'
OPEN C_Cursor
FETCH NEXT FROM C_Cursor INTO @name,@userID
WHILE (@@FETCH_STATUS <> -1)
begin /*Find the totals for this particular customer and organization for this 28 day time period */
select @sumBillable=sum(billable_total)/@numdays,@sumNonBillable=sum(non_billable_total)/@numdays
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where BILLING_USER_ID=@userID and
		DATEREPORTRUN between @begdate and @enddate and ORGANIZATION_ID=@ORG_ID

		select @sumPooledTotal=sum(PooledTotal)/@numdays from
		(select bill_job_id,PooledTotal
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where BILLING_USER_ID=@userID and
		DATEREPORTRUN between @begdate and @enddate and ORGANIZATION_ID=@ORG_ID
		GROUP BY BILL_JOB_ID,PooledTotal) a 

		select @sumUnbilledOpsInvoices=sum(UnbilledOpsInvoicesTotal)/@numdays from
		(select bill_job_id,UnbilledOpsInvoicesTotal
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where BILLING_USER_ID=@userID and
		DATEREPORTRUN between @begdate and @enddate and ORGANIZATION_ID=@ORG_ID
		GROUP BY BILL_JOB_ID,UnbilledOpsInvoicesTotal) a 

	/*Total sales average for the number of days specified by @numdays for user*/
	select @salesTotal=sum(DOCAMNT)/@numdays from (
	SELECT    ltrim(rtrim(str(a.INVOICE_ID))) INVOICE_ID,BILL_CUSTOMER_ID,EXT_BILL_CUST_ID,SALES_REPS,a.ORGANIZATION_ID,b.BILLING_USER_ID
	FROM         IMS_NEW..INVOICES a left outer join JOBS b on a.JOB_ID=b.JOB_ID
	WHERE a.ORGANIZATION_ID=@ORG_ID and a.STATUS_ID=4 
	) a
	INNER JOIN
	(
	select case 
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),1) = '-' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-1)) /* -XXX*/
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),2) = '-0' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-2)) /* -0XXX*/
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),4) = 'CM-0' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-4)) /* CM-0XXX */
	ELSE SERVICE_TRAX_INVOICEID /* INV suffix */
	END as SERVICE_TRAX_INVOICEID
	,SOPNUMBE,SOPTYPE,DOCAMNT,BACHNUMB,CUSTNMBR,CUSTNAME,CSTPONBR from (
	select CASE SOPTYPE 
				 WHEN 3 then substring(SOPNUMBE,1,abs(datalength(rtrim(SOPNUMBE))-3)) /*720,XXX*/
				 WHEN 4 then substring(SOPNUMBE,1,abs(datalength(rtrim(SOPNUMBE))-6)) /*CR-XXX,CM-XXX*/
				 ELSE ''
				 END as SERVICE_TRAX_INVOICEID
	,SOPNUMBE,SOPTYPE,CASE SOPTYPE WHEN 3 then DOCAMNT WHEN 4 THEN DOCAMNT * -1 END DOCAMNT,BACHNUMB,CUSTNMBR,CUSTNAME,CSTPONBR from CIINC..SOP30200 
	where DOCDATE between @begdate and @enddate ) x
	) b on b.SERVICE_TRAX_INVOICEID=a.INVOICE_ID where BILLING_USER_ID=@userID
/* This was the old way of calculating avg sales over 28 day period from service trax only
	select @salesTotal=sum(bill_total)/@numdays from service_lines WITH (NOLOCK) inner join jobs_v WITH (NOLOCK) on jobs_v.JOB_NO=service_lines.BILL_JOB_NO
		inner join CUSTOMERS WITH (NOLOCK) on JOBS_V.CUSTOMER_ID=CUSTOMERS.CUSTOMER_ID
		and SERVICE_LINE_DATE in (select distinct DATEREPORTRUN from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where DATEREPORTRUN between @begdate and @enddate)	and BILLING_USER_ID=@resid 
*/
	select @unbilledGrandTotal=isnull(@sumBillable,0)+isnull(@sumPooledTotal,0)+isnull(@sumUnbilledOpsInvoices,0)
	if isnull(@salesTotal,0) <> 0 --Ensure there are sales for this time period, and not only unbilled sales to avoid divide by zero error
	begin
		select @DSOTotal=isnull(@unbilledGrandTotal,0)/isnull(@salesTotal,0)
	end
	if @unbilledGrandTotal <> 0 
	begin	
		insert into @tbl values('Projects',999,@name,@unbilledGrandTotal,isnull(@salesTotal,0),isnull(@DSOTotal,0))
	end
	/* clear the variables for the next loop */
	select @name='',@userID=-1,@sumBillable=0,@sumNonBillable=0,@sumPooledTotal=0,@sumUnbilledOpsInvoices=0,
				@salesTotal=0,@unbilledGrandTotal=0,@DSOTotal=0
	FETCH NEXT FROM C_Cursor INTO @name,@userID
end
DEALLOCATE C_Cursor

/*Query for all Unbilled Accounting Items (Pending and Complete)
SELECT sum(iv.custom_line_total) custom_tot, sum(iv.bill_hourly_total) hours_total, sum(iv.bill_exp_total) exp_tot, iv.ext_batch_id, iv.assigned_to_name, iv.job_no, iv.job_id, iv.batch_status_id, ibs.name batch_status_name,
						sum(iv.bill_total + iv.custom_line_total) total_tot, iv.invoice_id_trk, iv.invoice_id, iv.invoice_description, iv.invoice_type_name, iv.invoice_status_id, iv.date_sent, iv.ext_dealer_id, iv.dealer_name, iv.customer_name, iv.invoice_format_type_name, iv.po_no, iv.invoice_date_created
		FROM invoice_pre_total_v iv, invoice_batch_statuses ibs
		WHERE iv.batch_status_id = ibs.status_id
		AND iv.invoice_status_id in (2,3) --Pending and Complete
		GROUP BY iv.invoice_id, iv.invoice_id_trk, iv.invoice_description, iv.invoice_type_name, iv.invoice_status_id, iv.date_sent, iv.ext_dealer_id, iv.dealer_name, iv.customer_name, iv.ext_batch_id, iv.assigned_to_name, iv.invoice_format_type_name, iv.job_no, iv.job_id, iv.po_no, iv.batch_status_id, iv.invoice_date_created, ibs.name
		ORDER BY iv.invoice_id
*/
insert into @tbl select 'Unbilled Accounting',iv.ORGANIZATION_ID,customer_name,sum(iv.bill_total + iv.custom_line_total) total_tot,0,0
		FROM invoice_pre_total_v iv WITH (NOLOCK), invoice_batch_statuses ibs WITH (NOLOCK)
		WHERE iv.batch_status_id = ibs.status_id
		AND iv.invoice_status_id in (2,3) --Pending and Complete
		and iv.ORGANIZATION_ID=@ORG_ID
		GROUP BY iv.invoice_id, iv.invoice_id_trk, iv.invoice_description, iv.invoice_type_name, iv.invoice_status_id, iv.date_sent, iv.ext_dealer_id, iv.dealer_name, iv.customer_name, iv.ext_batch_id, iv.assigned_to_name, iv.invoice_format_type_name, iv.job_no, iv.job_id, iv.po_no, iv.batch_status_id, iv.invoice_date_created, ibs.name, iv.ORGANIZATION_ID
		ORDER BY iv.invoice_id

select  TYPE,b.ORGANIZATION_ID,CUSTOMER_NAME,UnbilledDollars,AvgDaySales,DSO,b.NAME from @tbl a 
INNER JOIN (SELECT ORGANIZATION_ID,NAME FROM ORGANIZATIONS
UNION ALL
SELECT '999', 'PROJECTS') b on a.organization_id=b.organization_id
--select  TYPE,ORGANIZATIONS.ORGANIZATION_ID,CUSTOMER_NAME,UnbilledDollars,AvgDaySales,DSO,NAME from @tbl a
--left outer join ORGANIZATIONS on ORGANIZATIONS.ORGANIZATION_ID=a.ORGANIZATION_ID

--drop table @tbl

endprocess:

--exec sp_CRYSTAL_UNBILLED_REPORT_CIINC_DATERANGE
GO
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_UNBILLED_REPORT_CILLC_DATERANGE]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_CRYSTAL_UNBILLED_REPORT_CILLC_DATERANGE]
	@begdate datetime, @enddate datetime
AS
set nocount on

declare @tbl TABLE (
	[TYPE] char(255),
	[ORGANIZATION_ID] [numeric] (19,0),
	[CUSTOMER_NAME] varchar(255) ,
	[UnbilledDollars] [numeric](19, 5) ,
	[AvgDaySales] [numeric](19, 5),
	[DSO] [numeric](19, 5)
) 

/* Find number of days to divide unbilled $'s by.  Always done by 28 day time periods*/
declare @numdays int
select @numdays=0
select @begdate=CAST(FLOOR(CAST(@begdate AS FLOAT))AS DATETIME)
select @enddate=CAST(FLOOR(CAST(@enddate AS FLOAT))AS DATETIME)
select @numdays=count(*) from (select distinct DATEREPORTRUN from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
	where DATEREPORTRUN <= @enddate and DATEREPORTRUN >= @begdate) a

/* avoid divide by zero error (no data in dailydatacapture)*/
if @numdays <= 0 goto endprocess

declare @customer varchar(255),
				@ORG_ID numeric(19,0),
				@JOB_NO varchar(255),
				@sumBillable numeric(19,5),
				@sumNonBillable numeric(19,5),
				@sumPooledTotal numeric(19,5),
				@sumUnbilledOpsInvoices numeric(19,5),
				@salesTotal numeric(19,5),
				@unbilledGrandTotal numeric(19,5),
				@DSOTotal numeric(19,5)

select @ORG_ID=11

declare C_Cursor CURSOR for select DISTINCT CUSTOMER_NAME from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK) where ORGANIZATION_ID=@ORG_ID order by CUSTOMER_NAME asc
OPEN C_Cursor
FETCH NEXT FROM C_Cursor INTO @customer
WHILE (@@FETCH_STATUS <> -1)
begin /*Find the totals for this particular customer and organization for this 28 day time period */
	select @sumBillable=sum(billable_total)/@numdays
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where CUSTOMER_NAME=@customer and ORGANIZATION_ID=@ORG_ID and 
		DATEREPORTRUN between @begdate and @enddate 

		select @sumPooledTotal=sum(PooledTotal)/@numdays from
		(select bill_job_id,PooledTotal
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where CUSTOMER_NAME=@customer and ORGANIZATION_ID=@ORG_ID and 
		DATEREPORTRUN between @begdate and @enddate
		GROUP BY BILL_JOB_ID,PooledTotal) a 

		select @sumUnbilledOpsInvoices=sum(UnbilledOpsInvoicesTotal)/@numdays from
		(select bill_job_id,UnbilledOpsInvoicesTotal
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where CUSTOMER_NAME=@customer and ORGANIZATION_ID=@ORG_ID and 
		DATEREPORTRUN between @begdate and @enddate
		GROUP BY BILL_JOB_ID,UnbilledOpsInvoicesTotal) a 

	/*Total sales average for the number of days specified by @numdays */
	select @salesTotal=sum(DOCAMNT)/@numdays from (
	SELECT    ltrim(rtrim(str(INVOICE_ID))) INVOICE_ID,BILL_CUSTOMER_ID,EXT_BILL_CUST_ID,SALES_REPS,EXT_DEALER_ID,EXT_CUSTOMER_ID,CUSTOMER_NAME,a.ORGANIZATION_ID
	FROM         IMS_NEW..INVOICES a LEFT OUTER JOIN CUSTOMERS b on a.BILL_CUSTOMER_ID=b.CUSTOMER_ID
	WHERE a.ORGANIZATION_ID=@ORG_ID and a.STATUS_ID=4
	) a
	INNER JOIN
	(
	select case 
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),1) = '-' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-1)) /* -XXX*/
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),2) = '-0' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-2)) /* -0XXX*/
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),4) = 'CM-0' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-4)) /* CM-0XXX */
	ELSE SERVICE_TRAX_INVOICEID /* INV suffix */
	END as SERVICE_TRAX_INVOICEID
	,SOPNUMBE,SOPTYPE,DOCAMNT,BACHNUMB,CUSTNMBR,CUSTNAME,CSTPONBR from (
	select CASE SOPTYPE 
				 WHEN 3 then substring(SOPNUMBE,1,abs(datalength(rtrim(SOPNUMBE))-3)) /*720,XXX*/
				 WHEN 4 then substring(SOPNUMBE,1,abs(datalength(rtrim(SOPNUMBE))-6)) /*CR-XXX,CM-XXX*/
				 ELSE ''
				 END as SERVICE_TRAX_INVOICEID
	,SOPNUMBE,SOPTYPE,CASE SOPTYPE WHEN 3 then DOCAMNT WHEN 4 THEN DOCAMNT * -1 END DOCAMNT,BACHNUMB,CUSTNMBR,CUSTNAME,CSTPONBR 
	from CILLC..SOP30200 
	where DOCDATE between @begdate and @enddate ) x
	) b on b.SERVICE_TRAX_INVOICEID=a.INVOICE_ID where CUSTOMER_NAME=@customer and ORGANIZATION_ID=@ORG_ID
/* This was the old way of calculating avg sales over 28 day period from servicee trax only 
	select @salesTotal=sum(bill_total)/@numdays from service_lines WITH (NOLOCK) inner join jobs WITH (NOLOCK) on jobs.JOB_NO=service_lines.BILL_JOB_NO 
		inner join CUSTOMERS WITH (NOLOCK) on JOBS.CUSTOMER_ID=CUSTOMERS.CUSTOMER_ID and BILLED_FLAG='Y' and SERVICE_LINE_DATE 
		in (select distinct DATEREPORTRUN from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK) 

		where DATEREPORTRUN between @begdate and @enddate) and CUSTOMER_NAME=@customer 
		and service_lines.ORGANIZATION_ID=@ORG_ID
*/
	select @unbilledGrandTotal=isnull(@sumBillable,0)+isnull(@sumPooledTotal,0)+isnull(@sumUnbilledOpsInvoices,0)
	if isnull(@salesTotal,0) <> 0 --Ensure there are sales for this time period, and not only unbilled sales to avoid divide by zero error
	begin
		select @DSOTotal=isnull(@unbilledGrandTotal,0)/isnull(@salesTotal,0)
	end
	insert into @tbl values('Unbilled OPs',@ORG_ID,@customer,@unbilledGrandTotal,isnull(@salesTotal,0),isnull(@DSOTotal,0))
	/* clear the variables for the next loop */
	select @customer='',@JOB_NO='',@sumBillable=0,@sumNonBillable=0,@sumPooledTotal=0,@sumUnbilledOpsInvoices=0,
			@salesTotal=0,@unbilledGrandTotal=0,@DSOTotal=0
	FETCH NEXT FROM C_Cursor INTO @customer
end
DEALLOCATE C_Cursor

declare @name varchar(255),
		@userID int

declare C_Cursor CURSOR for select rtrim(FIRST_NAME) + ' ' + rtrim(LAST_NAME) fullName,USER_ID
 from USERS WITH (NOLOCK) union
	select 'UNKNOWN USER','-999'
OPEN C_Cursor
FETCH NEXT FROM C_Cursor INTO @name,@userID
WHILE (@@FETCH_STATUS <> -1)
begin /*Find the totals for this particular customer and organization for this 28 day time period */
select @sumBillable=sum(billable_total)/@numdays,@sumNonBillable=sum(non_billable_total)/@numdays
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where BILLING_USER_ID=@userID and
		DATEREPORTRUN between @begdate and @enddate and ORGANIZATION_ID=@ORG_ID

		select @sumPooledTotal=sum(PooledTotal)/@numdays from
		(select bill_job_id,PooledTotal
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where BILLING_USER_ID=@userID and
		DATEREPORTRUN between @begdate and @enddate and ORGANIZATION_ID=@ORG_ID
		GROUP BY BILL_JOB_ID,PooledTotal) a 

		select @sumUnbilledOpsInvoices=sum(UnbilledOpsInvoicesTotal)/@numdays from
		(select bill_job_id,UnbilledOpsInvoicesTotal
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where BILLING_USER_ID=@userID and
		DATEREPORTRUN between @begdate and @enddate and ORGANIZATION_ID=@ORG_ID
		GROUP BY BILL_JOB_ID,UnbilledOpsInvoicesTotal) a 

	/*Total sales average for the number of days specified by @numdays for user*/
	select @salesTotal=sum(DOCAMNT)/@numdays from (
	SELECT    ltrim(rtrim(str(a.INVOICE_ID))) INVOICE_ID,BILL_CUSTOMER_ID,EXT_BILL_CUST_ID,SALES_REPS,a.ORGANIZATION_ID,b.BILLING_USER_ID
	FROM         IMS_NEW..INVOICES a left outer join JOBS b on a.JOB_ID=b.JOB_ID
	WHERE a.ORGANIZATION_ID=@ORG_ID and a.STATUS_ID=4 
	) a
	INNER JOIN
	(
	select case 
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),1) = '-' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-1)) /* -XXX*/
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),2) = '-0' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-2)) /* -0XXX*/
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),4) = 'CM-0' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-4)) /* CM-0XXX */
	ELSE SERVICE_TRAX_INVOICEID /* INV suffix */
	END as SERVICE_TRAX_INVOICEID
	,SOPNUMBE,SOPTYPE,DOCAMNT,BACHNUMB,CUSTNMBR,CUSTNAME,CSTPONBR from (
	select CASE SOPTYPE 
				 WHEN 3 then substring(SOPNUMBE,1,abs(datalength(rtrim(SOPNUMBE))-3)) /*720,XXX*/
				 WHEN 4 then substring(SOPNUMBE,1,abs(datalength(rtrim(SOPNUMBE))-6)) /*CR-XXX,CM-XXX*/
				 ELSE ''
				 END as SERVICE_TRAX_INVOICEID
	,SOPNUMBE,SOPTYPE,CASE SOPTYPE WHEN 3 then DOCAMNT WHEN 4 THEN DOCAMNT * -1 END DOCAMNT,BACHNUMB,CUSTNMBR,CUSTNAME,CSTPONBR from CILLC..SOP30200 
	where DOCDATE between @begdate and @enddate ) x
	) b on b.SERVICE_TRAX_INVOICEID=a.INVOICE_ID where BILLING_USER_ID=@userID
/* This was the old way of calculating avg sales over 28 day period from service trax only
	select @salesTotal=sum(bill_total)/@numdays from service_lines WITH (NOLOCK) inner join jobs_v WITH (NOLOCK) on jobs_v.JOB_NO=service_lines.BILL_JOB_NO
		inner join CUSTOMERS WITH (NOLOCK) on JOBS_V.CUSTOMER_ID=CUSTOMERS.CUSTOMER_ID
		and SERVICE_LINE_DATE in (select distinct DATEREPORTRUN from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where DATEREPORTRUN between @begdate and @enddate)	and BILLING_USER_ID=@resid 
*/
	select @unbilledGrandTotal=isnull(@sumBillable,0)+isnull(@sumPooledTotal,0)+isnull(@sumUnbilledOpsInvoices,0)
	if isnull(@salesTotal,0) <> 0 --Ensure there are sales for this time period, and not only unbilled sales to avoid divide by zero error
	begin
		select @DSOTotal=isnull(@unbilledGrandTotal,0)/isnull(@salesTotal,0)
	end
	if @unbilledGrandTotal <> 0 
	begin	
		insert into @tbl values('Projects',999,@name,@unbilledGrandTotal,isnull(@salesTotal,0),isnull(@DSOTotal,0))
	end
	/* clear the variables for the next loop */
	select @name='',@userID=-1,@sumBillable=0,@sumNonBillable=0,@sumPooledTotal=0,@sumUnbilledOpsInvoices=0,
				@salesTotal=0,@unbilledGrandTotal=0,@DSOTotal=0
	FETCH NEXT FROM C_Cursor INTO @name,@userID
end
DEALLOCATE C_Cursor

/*Query for all Unbilled Accounting Items (Pending and Complete)
SELECT sum(iv.custom_line_total) custom_tot, sum(iv.bill_hourly_total) hours_total, sum(iv.bill_exp_total) exp_tot, iv.ext_batch_id, iv.assigned_to_name, iv.job_no, iv.job_id, iv.batch_status_id, ibs.name batch_status_name,
						sum(iv.bill_total + iv.custom_line_total) total_tot, iv.invoice_id_trk, iv.invoice_id, iv.invoice_description, iv.invoice_type_name, iv.invoice_status_id, iv.date_sent, iv.ext_dealer_id, iv.dealer_name, iv.customer_name, iv.invoice_format_type_name, iv.po_no, iv.invoice_date_created
		FROM invoice_pre_total_v iv, invoice_batch_statuses ibs
		WHERE iv.batch_status_id = ibs.status_id
		AND iv.invoice_status_id in (2,3) --Pending and Complete
		GROUP BY iv.invoice_id, iv.invoice_id_trk, iv.invoice_description, iv.invoice_type_name, iv.invoice_status_id, iv.date_sent, iv.ext_dealer_id, iv.dealer_name, iv.customer_name, iv.ext_batch_id, iv.assigned_to_name, iv.invoice_format_type_name, iv.job_no, iv.job_id, iv.po_no, iv.batch_status_id, iv.invoice_date_created, ibs.name
		ORDER BY iv.invoice_id
*/
insert into @tbl select 'Unbilled Accounting',iv.ORGANIZATION_ID,customer_name,sum(iv.bill_total + iv.custom_line_total) total_tot,0,0
		FROM invoice_pre_total_v iv WITH (NOLOCK), invoice_batch_statuses ibs WITH (NOLOCK)
		WHERE iv.batch_status_id = ibs.status_id
		AND iv.invoice_status_id in (2,3) --Pending and Complete
		and iv.ORGANIZATION_ID=@ORG_ID
		GROUP BY iv.invoice_id, iv.invoice_id_trk, iv.invoice_description, iv.invoice_type_name, iv.invoice_status_id, iv.date_sent, iv.ext_dealer_id, iv.dealer_name, iv.customer_name, iv.ext_batch_id, iv.assigned_to_name, iv.invoice_format_type_name, iv.job_no, iv.job_id, iv.po_no, iv.batch_status_id, iv.invoice_date_created, ibs.name, iv.ORGANIZATION_ID
		ORDER BY iv.invoice_id

select  TYPE,b.ORGANIZATION_ID,CUSTOMER_NAME,UnbilledDollars,AvgDaySales,DSO,b.NAME from @tbl a 
INNER JOIN (SELECT ORGANIZATION_ID,NAME FROM ORGANIZATIONS
UNION ALL
SELECT '999', 'PROJECTS') b on a.organization_id=b.organization_id
--select  TYPE,ORGANIZATIONS.ORGANIZATION_ID,CUSTOMER_NAME,UnbilledDollars,AvgDaySales,DSO,NAME from @tbl a
--left outer join ORGANIZATIONS on ORGANIZATIONS.ORGANIZATION_ID=a.ORGANIZATION_ID

--drop table @tbl

endprocess:

--exec sp_CRYSTAL_UNBILLED_REPORT_CILLC_DATERANGE
GO
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_UNBILLED_REPORT_CILLC]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_CRYSTAL_UNBILLED_REPORT_CILLC]
AS
set nocount on

declare @tbl TABLE (
	[TYPE] char(255),
	[ORGANIZATION_ID] [numeric] (19,0),
	[CUSTOMER_NAME] varchar(255) ,
	[UnbilledDollars] [numeric](19, 5) ,
	[AvgDaySales] [numeric](19, 5),
	[DSO] [numeric](19, 5)
) 

/* Find number of days to divide unbilled $'s by.  Always done by 28 day time periods
   numdays is calculated as a failsafe if daily data capture missed a day, therefore the count
   would not include that day
*/
declare @numdays int, @begdate datetime, @enddate datetime
select @numdays=0
select @begdate = CAST(FLOOR(CAST(getdate()-28 AS FLOAT))AS DATETIME)
select @enddate = CAST(FLOOR(CAST(getdate()-1 AS FLOAT))AS DATETIME)
select @numdays=count(*) from (select distinct DATEREPORTRUN from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
	where DATEREPORTRUN <= @enddate and DATEREPORTRUN >= @begdate) a

/* avoid divide by zero error (no data in dailydatacapture)*/
if @numdays <= 0 goto endprocess

declare @customer varchar(255),
				@ORG_ID numeric(19,0),
				@JOB_NO varchar(255),
				@sumBillable numeric(19,5),
				@sumNonBillable numeric(19,5),
				@sumPooledTotal numeric(19,5),
				@sumUnbilledOpsInvoices numeric(19,5),
				@salesTotal numeric(19,5),
				@unbilledGrandTotal numeric(19,5),
				@DSOTotal numeric(19,5)

select @ORG_ID=11

declare C_Cursor CURSOR for select DISTINCT CUSTOMER_NAME from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK) where ORGANIZATION_ID=@ORG_ID order by CUSTOMER_NAME asc
OPEN C_Cursor
FETCH NEXT FROM C_Cursor INTO @customer
WHILE (@@FETCH_STATUS <> -1)
begin /*Find the totals for this particular customer and organization for this 28 day time period */
	select @sumBillable=sum(billable_total)/@numdays,@sumNonBillable=sum(non_billable_total)/@numdays
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where CUSTOMER_NAME=@customer and ORGANIZATION_ID=@ORG_ID and 
		DATEREPORTRUN between @begdate and @enddate 

		select @sumPooledTotal=sum(PooledTotal)/@numdays from
		(select bill_job_id,PooledTotal
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where CUSTOMER_NAME=@customer and ORGANIZATION_ID=@ORG_ID and 
		DATEREPORTRUN between @begdate and @enddate
		GROUP BY BILL_JOB_ID,PooledTotal) a 

		select @sumUnbilledOpsInvoices=sum(UnbilledOpsInvoicesTotal)/@numdays from
		(select bill_job_id,UnbilledOpsInvoicesTotal
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where CUSTOMER_NAME=@customer and ORGANIZATION_ID=@ORG_ID and 
		DATEREPORTRUN between @begdate and @enddate
		GROUP BY BILL_JOB_ID,UnbilledOpsInvoicesTotal) a 

	/*Total sales average for the number of days specified by @numdays */
	select @salesTotal=sum(DOCAMNT)/@numdays from (
	SELECT    ltrim(rtrim(str(INVOICE_ID))) INVOICE_ID,BILL_CUSTOMER_ID,EXT_BILL_CUST_ID,SALES_REPS,EXT_DEALER_ID,EXT_CUSTOMER_ID,CUSTOMER_NAME,a.ORGANIZATION_ID
	FROM         IMS_NEW..INVOICES a LEFT OUTER JOIN CUSTOMERS b on a.BILL_CUSTOMER_ID=b.CUSTOMER_ID
	WHERE a.ORGANIZATION_ID=@ORG_ID and a.STATUS_ID=4
	) a
	INNER JOIN
	(
	select case 
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),1) = '-' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-1)) /* -XXX*/
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),2) = '-0' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-2)) /* -0XXX*/
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),4) = 'CM-0' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-4)) /* CM-0XXX */
	ELSE SERVICE_TRAX_INVOICEID /* INV suffix */
	END as SERVICE_TRAX_INVOICEID
	,SOPNUMBE,SOPTYPE,DOCAMNT,BACHNUMB,CUSTNMBR,CUSTNAME,CSTPONBR from (
	select CASE SOPTYPE 
				 WHEN 3 then substring(SOPNUMBE,1,abs(datalength(rtrim(SOPNUMBE))-3)) /*720,XXX*/
				 WHEN 4 then substring(SOPNUMBE,1,abs(datalength(rtrim(SOPNUMBE))-6)) /*CR-XXX,CM-XXX*/
				 ELSE ''
				 END as SERVICE_TRAX_INVOICEID
	,SOPNUMBE,SOPTYPE,CASE SOPTYPE WHEN 3 then DOCAMNT WHEN 4 THEN DOCAMNT * -1 END DOCAMNT,BACHNUMB,CUSTNMBR,CUSTNAME,CSTPONBR 
	from CILLC..SOP30200 
	where DOCDATE between @begdate and @enddate ) x
	) b on b.SERVICE_TRAX_INVOICEID=a.INVOICE_ID where CUSTOMER_NAME=@customer and ORGANIZATION_ID=@ORG_ID
/* This was the old way of calculating avg sales over 28 day period from servicee trax only 
	select @salesTotal=sum(bill_total)/@numdays from service_lines WITH (NOLOCK) inner join jobs WITH (NOLOCK) on jobs.JOB_NO=service_lines.BILL_JOB_NO 
		inner join CUSTOMERS WITH (NOLOCK) on JOBS.CUSTOMER_ID=CUSTOMERS.CUSTOMER_ID and BILLED_FLAG='Y' and SERVICE_LINE_DATE 
		in (select distinct DATEREPORTRUN from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK) 

		where DATEREPORTRUN between @begdate and @enddate) and CUSTOMER_NAME=@customer 
		and service_lines.ORGANIZATION_ID=@ORG_ID
*/
	select @unbilledGrandTotal=isnull(@sumBillable,0)+isnull(@sumPooledTotal,0)+isnull(@sumUnbilledOpsInvoices,0)
	if isnull(@salesTotal,0) <> 0 --Ensure there are sales for this time period, and not only unbilled sales to avoid divide by zero error
	begin
		select @DSOTotal=isnull(@unbilledGrandTotal,0)/isnull(@salesTotal,0)
	end
	insert into @tbl values('Unbilled OPs',@ORG_ID,@customer,@unbilledGrandTotal,isnull(@salesTotal,0),isnull(@DSOTotal,0))
	/* clear the variables for the next loop */
	select @customer='',@JOB_NO='',@sumBillable=0,@sumNonBillable=0,@sumPooledTotal=0,@sumUnbilledOpsInvoices=0,
			@salesTotal=0,@unbilledGrandTotal=0,@DSOTotal=0
	FETCH NEXT FROM C_Cursor INTO @customer
end
DEALLOCATE C_Cursor

declare @name varchar(255),
		@userID int

declare C_Cursor CURSOR for select rtrim(FIRST_NAME) + ' ' + rtrim(LAST_NAME) fullName,USER_ID
 from USERS WITH (NOLOCK) union
	select 'UNKNOWN USER','-999'
OPEN C_Cursor
FETCH NEXT FROM C_Cursor INTO @name,@userID
WHILE (@@FETCH_STATUS <> -1)
begin /*Find the totals for this particular customer and organization for this 28 day time period */
select @sumBillable=sum(billable_total)/@numdays,@sumNonBillable=sum(non_billable_total)/@numdays
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where BILLING_USER_ID=@userID and
		DATEREPORTRUN between @begdate and @enddate and ORGANIZATION_ID=@ORG_ID

		select @sumPooledTotal=sum(PooledTotal)/@numdays from
		(select bill_job_id,PooledTotal
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where BILLING_USER_ID=@userID and
		DATEREPORTRUN between @begdate and @enddate and ORGANIZATION_ID=@ORG_ID
		GROUP BY BILL_JOB_ID,PooledTotal) a 

		select @sumUnbilledOpsInvoices=sum(UnbilledOpsInvoicesTotal)/@numdays from
		(select bill_job_id,UnbilledOpsInvoicesTotal
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where BILLING_USER_ID=@userID and
		DATEREPORTRUN between @begdate and @enddate and ORGANIZATION_ID=@ORG_ID
		GROUP BY BILL_JOB_ID,UnbilledOpsInvoicesTotal) a 

	/*Total sales average for the number of days specified by @numdays for user*/
	select @salesTotal=sum(DOCAMNT)/@numdays from (
	SELECT    ltrim(rtrim(str(a.INVOICE_ID))) INVOICE_ID,BILL_CUSTOMER_ID,EXT_BILL_CUST_ID,SALES_REPS,a.ORGANIZATION_ID,b.BILLING_USER_ID
	FROM         IMS_NEW..INVOICES a left outer join JOBS b on a.JOB_ID=b.JOB_ID
	WHERE a.ORGANIZATION_ID=@ORG_ID and a.STATUS_ID=4 
	) a
	INNER JOIN
	(
	select case 
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),1) = '-' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-1)) /* -XXX*/
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),2) = '-0' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-2)) /* -0XXX*/
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),4) = 'CM-0' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-4)) /* CM-0XXX */
	ELSE SERVICE_TRAX_INVOICEID /* INV suffix */
	END as SERVICE_TRAX_INVOICEID
	,SOPNUMBE,SOPTYPE,DOCAMNT,BACHNUMB,CUSTNMBR,CUSTNAME,CSTPONBR from (
	select CASE SOPTYPE 
				 WHEN 3 then substring(SOPNUMBE,1,abs(datalength(rtrim(SOPNUMBE))-3)) /*720,XXX*/
				 WHEN 4 then substring(SOPNUMBE,1,abs(datalength(rtrim(SOPNUMBE))-6)) /*CR-XXX,CM-XXX*/
				 ELSE ''
				 END as SERVICE_TRAX_INVOICEID
	,SOPNUMBE,SOPTYPE,CASE SOPTYPE WHEN 3 then DOCAMNT WHEN 4 THEN DOCAMNT * -1 END DOCAMNT,BACHNUMB,CUSTNMBR,CUSTNAME,CSTPONBR from CILLC..SOP30200 
	where DOCDATE between @begdate and @enddate ) x
	) b on b.SERVICE_TRAX_INVOICEID=a.INVOICE_ID where BILLING_USER_ID=@userID
/* This was the old way of calculating avg sales over 28 day period from service trax only
	select @salesTotal=sum(bill_total)/@numdays from service_lines WITH (NOLOCK) inner join jobs_v WITH (NOLOCK) on jobs_v.JOB_NO=service_lines.BILL_JOB_NO
		inner join CUSTOMERS WITH (NOLOCK) on JOBS_V.CUSTOMER_ID=CUSTOMERS.CUSTOMER_ID
		and SERVICE_LINE_DATE in (select distinct DATEREPORTRUN from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where DATEREPORTRUN between @begdate and @enddate)	and BILLING_USER_ID=@resid 
*/
	select @unbilledGrandTotal=isnull(@sumBillable,0)+isnull(@sumPooledTotal,0)+isnull(@sumUnbilledOpsInvoices,0)
	if isnull(@salesTotal,0) <> 0 --Ensure there are sales for this time period, and not only unbilled sales to avoid divide by zero error
	begin
		select @DSOTotal=isnull(@unbilledGrandTotal,0)/isnull(@salesTotal,0)
	end
	if @unbilledGrandTotal <> 0 
	begin	
		insert into @tbl values('Projects',999,@name,@unbilledGrandTotal,isnull(@salesTotal,0),isnull(@DSOTotal,0))
	end
	/* clear the variables for the next loop */
	select @name='',@userID=-1,@sumBillable=0,@sumNonBillable=0,@sumPooledTotal=0,@sumUnbilledOpsInvoices=0,
				@salesTotal=0,@unbilledGrandTotal=0,@DSOTotal=0
	FETCH NEXT FROM C_Cursor INTO @name,@userID
end
DEALLOCATE C_Cursor

/*Query for all Unbilled Accounting Items (Pending and Complete)
SELECT sum(iv.custom_line_total) custom_tot, sum(iv.bill_hourly_total) hours_total, sum(iv.bill_exp_total) exp_tot, iv.ext_batch_id, iv.assigned_to_name, iv.job_no, iv.job_id, iv.batch_status_id, ibs.name batch_status_name,
						sum(iv.bill_total + iv.custom_line_total) total_tot, iv.invoice_id_trk, iv.invoice_id, iv.invoice_description, iv.invoice_type_name, iv.invoice_status_id, iv.date_sent, iv.ext_dealer_id, iv.dealer_name, iv.customer_name, iv.invoice_format_type_name, iv.po_no, iv.invoice_date_created
		FROM invoice_pre_total_v iv, invoice_batch_statuses ibs
		WHERE iv.batch_status_id = ibs.status_id
		AND iv.invoice_status_id in (2,3) --Pending and Complete
		GROUP BY iv.invoice_id, iv.invoice_id_trk, iv.invoice_description, iv.invoice_type_name, iv.invoice_status_id, iv.date_sent, iv.ext_dealer_id, iv.dealer_name, iv.customer_name, iv.ext_batch_id, iv.assigned_to_name, iv.invoice_format_type_name, iv.job_no, iv.job_id, iv.po_no, iv.batch_status_id, iv.invoice_date_created, ibs.name
		ORDER BY iv.invoice_id
*/
insert into @tbl select 'Unbilled Accounting',iv.ORGANIZATION_ID,customer_name,sum(iv.bill_total + iv.custom_line_total) total_tot,0,0
		FROM invoice_pre_total_v iv WITH (NOLOCK), invoice_batch_statuses ibs WITH (NOLOCK)
		WHERE iv.batch_status_id = ibs.status_id
		AND iv.invoice_status_id in (2,3) --Pending and Complete
		and iv.ORGANIZATION_ID=@ORG_ID
		GROUP BY iv.invoice_id, iv.invoice_id_trk, iv.invoice_description, iv.invoice_type_name, iv.invoice_status_id, iv.date_sent, iv.ext_dealer_id, iv.dealer_name, iv.customer_name, iv.ext_batch_id, iv.assigned_to_name, iv.invoice_format_type_name, iv.job_no, iv.job_id, iv.po_no, iv.batch_status_id, iv.invoice_date_created, ibs.name, iv.ORGANIZATION_ID
		ORDER BY iv.invoice_id

select  TYPE,b.ORGANIZATION_ID,CUSTOMER_NAME,UnbilledDollars,AvgDaySales,DSO,b.NAME from @tbl a 
INNER JOIN (SELECT ORGANIZATION_ID,NAME FROM ORGANIZATIONS
UNION ALL
SELECT '999', 'PROJECTS') b on a.organization_id=b.organization_id
--select  TYPE,ORGANIZATIONS.ORGANIZATION_ID,CUSTOMER_NAME,UnbilledDollars,AvgDaySales,DSO,NAME from @tbl a
--left outer join ORGANIZATIONS on ORGANIZATIONS.ORGANIZATION_ID=a.ORGANIZATION_ID

--drop table @tbl

endprocess:

--exec sp_CRYSTAL_UNBILLED_REPORT_CILLC
GO
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_UNBILLED_REPORT_AMMAD_DATERANGE]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_CRYSTAL_UNBILLED_REPORT_AMMAD_DATERANGE]
	@begdate datetime, @enddate datetime
AS
set nocount on

declare @tbl TABLE (
	[TYPE] char(255),
	[ORGANIZATION_ID] [numeric] (19,0),
	[CUSTOMER_NAME] varchar(255) ,
	[UnbilledDollars] [numeric](19, 5) ,
	[AvgDaySales] [numeric](19, 5),
	[DSO] [numeric](19, 5)
) 

/* Find number of days to divide unbilled $'s by.  Always done by 28 day time periods*/
declare @numdays int
select @numdays=0
select @begdate=CAST(FLOOR(CAST(@begdate AS FLOAT))AS DATETIME)
select @enddate=CAST(FLOOR(CAST(@enddate AS FLOAT))AS DATETIME)
select @numdays=count(*) from (select distinct DATEREPORTRUN from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
	where DATEREPORTRUN <= @enddate and DATEREPORTRUN >= @begdate) a

/* avoid divide by zero error (no data in dailydatacapture)*/
if @numdays <= 0 goto endprocess

declare @customer varchar(255),
				@ORG_ID numeric(19,0),
				@JOB_NO varchar(255),
				@sumBillable numeric(19,5),
				@sumNonBillable numeric(19,5),
				@sumPooledTotal numeric(19,5),
				@sumUnbilledOpsInvoices numeric(19,5),
				@salesTotal numeric(19,5),
				@unbilledGrandTotal numeric(19,5),
				@DSOTotal numeric(19,5)

select @ORG_ID=4

declare C_Cursor CURSOR for select DISTINCT CUSTOMER_NAME from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK) where ORGANIZATION_ID=@ORG_ID order by CUSTOMER_NAME asc
OPEN C_Cursor
FETCH NEXT FROM C_Cursor INTO @customer
WHILE (@@FETCH_STATUS <> -1)
begin /*Find the totals for this particular customer and organization for this 28 day time period */
	select @sumBillable=sum(billable_total)/@numdays
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where CUSTOMER_NAME=@customer and ORGANIZATION_ID=@ORG_ID and 
		DATEREPORTRUN between @begdate and @enddate 

		select @sumPooledTotal=sum(PooledTotal)/@numdays from
		(select bill_job_id,PooledTotal
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where CUSTOMER_NAME=@customer and ORGANIZATION_ID=@ORG_ID and 
		DATEREPORTRUN between @begdate and @enddate
		GROUP BY BILL_JOB_ID,PooledTotal) a 

		select @sumUnbilledOpsInvoices=sum(UnbilledOpsInvoicesTotal)/@numdays from
		(select bill_job_id,UnbilledOpsInvoicesTotal
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where CUSTOMER_NAME=@customer and ORGANIZATION_ID=@ORG_ID and 
		DATEREPORTRUN between @begdate and @enddate
		GROUP BY BILL_JOB_ID,UnbilledOpsInvoicesTotal) a 

	/*Total sales average for the number of days specified by @numdays */
	select @salesTotal=sum(DOCAMNT)/@numdays from (
	SELECT    ltrim(rtrim(str(INVOICE_ID))) INVOICE_ID,BILL_CUSTOMER_ID,EXT_BILL_CUST_ID,SALES_REPS,EXT_DEALER_ID,EXT_CUSTOMER_ID,CUSTOMER_NAME,a.ORGANIZATION_ID
	FROM         IMS_NEW..INVOICES a LEFT OUTER JOIN CUSTOMERS b on a.BILL_CUSTOMER_ID=b.CUSTOMER_ID
	WHERE a.ORGANIZATION_ID=@ORG_ID and a.STATUS_ID=4
	) a
	INNER JOIN
	(
	select case 
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),1) = '-' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-1)) /* -XXX*/
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),2) = '-0' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-2)) /* -0XXX*/
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),4) = 'CM-0' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-4)) /* CM-0XXX */
	ELSE SERVICE_TRAX_INVOICEID /* INV suffix */
	END as SERVICE_TRAX_INVOICEID
	,SOPNUMBE,SOPTYPE,DOCAMNT,BACHNUMB,CUSTNMBR,CUSTNAME,CSTPONBR from (
	select CASE SOPTYPE 
				 WHEN 3 then substring(SOPNUMBE,1,abs(datalength(rtrim(SOPNUMBE))-3)) /*720,XXX*/
				 WHEN 4 then substring(SOPNUMBE,1,abs(datalength(rtrim(SOPNUMBE))-6)) /*CR-XXX,CM-XXX*/
				 ELSE ''
				 END as SERVICE_TRAX_INVOICEID
	,SOPNUMBE,SOPTYPE,CASE SOPTYPE WHEN 3 then DOCAMNT WHEN 4 THEN DOCAMNT * -1 END DOCAMNT,BACHNUMB,CUSTNMBR,CUSTNAME,CSTPONBR 
	from AMMAD..SOP30200 
	where DOCDATE between @begdate and @enddate ) x
	) b on b.SERVICE_TRAX_INVOICEID=a.INVOICE_ID where CUSTOMER_NAME=@customer and ORGANIZATION_ID=@ORG_ID
/* This was the old way of calculating avg sales over 28 day period from servicee trax only 
	select @salesTotal=sum(bill_total)/@numdays from service_lines WITH (NOLOCK) inner join jobs WITH (NOLOCK) on jobs.JOB_NO=service_lines.BILL_JOB_NO 
		inner join CUSTOMERS WITH (NOLOCK) on JOBS.CUSTOMER_ID=CUSTOMERS.CUSTOMER_ID and BILLED_FLAG='Y' and SERVICE_LINE_DATE 
		in (select distinct DATEREPORTRUN from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK) 

		where DATEREPORTRUN between @begdate and @enddate) and CUSTOMER_NAME=@customer 
		and service_lines.ORGANIZATION_ID=@ORG_ID
*/
	select @unbilledGrandTotal=isnull(@sumBillable,0)+isnull(@sumPooledTotal,0)+isnull(@sumUnbilledOpsInvoices,0)
	if isnull(@salesTotal,0) <> 0 --Ensure there are sales for this time period, and not only unbilled sales to avoid divide by zero error
	begin
		select @DSOTotal=isnull(@unbilledGrandTotal,0)/isnull(@salesTotal,0)
	end
	insert into @tbl values('Unbilled OPs',@ORG_ID,@customer,@unbilledGrandTotal,isnull(@salesTotal,0),isnull(@DSOTotal,0))
	/* clear the variables for the next loop */
	select @customer='',@JOB_NO='',@sumBillable=0,@sumNonBillable=0,@sumPooledTotal=0,@sumUnbilledOpsInvoices=0,
			@salesTotal=0,@unbilledGrandTotal=0,@DSOTotal=0
	FETCH NEXT FROM C_Cursor INTO @customer
end
DEALLOCATE C_Cursor

declare @name varchar(255),
		@userID int

declare C_Cursor CURSOR for select rtrim(FIRST_NAME) + ' ' + rtrim(LAST_NAME) fullName,USER_ID
 from USERS WITH (NOLOCK) union
	select 'UNKNOWN USER','-999'
OPEN C_Cursor
FETCH NEXT FROM C_Cursor INTO @name,@userID
WHILE (@@FETCH_STATUS <> -1)
begin /*Find the totals for this particular customer and organization for this 28 day time period */
select @sumBillable=sum(billable_total)/@numdays,@sumNonBillable=sum(non_billable_total)/@numdays
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where BILLING_USER_ID=@userID and
		DATEREPORTRUN between @begdate and @enddate and ORGANIZATION_ID=@ORG_ID

		select @sumPooledTotal=sum(PooledTotal)/@numdays from
		(select bill_job_id,PooledTotal
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where BILLING_USER_ID=@userID and
		DATEREPORTRUN between @begdate and @enddate and ORGANIZATION_ID=@ORG_ID
		GROUP BY BILL_JOB_ID,PooledTotal) a 

		select @sumUnbilledOpsInvoices=sum(UnbilledOpsInvoicesTotal)/@numdays from
		(select bill_job_id,UnbilledOpsInvoicesTotal
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where BILLING_USER_ID=@userID and
		DATEREPORTRUN between @begdate and @enddate and ORGANIZATION_ID=@ORG_ID
		GROUP BY BILL_JOB_ID,UnbilledOpsInvoicesTotal) a 

	/*Total sales average for the number of days specified by @numdays for user*/
	select @salesTotal=sum(DOCAMNT)/@numdays from (
	SELECT    ltrim(rtrim(str(a.INVOICE_ID))) INVOICE_ID,BILL_CUSTOMER_ID,EXT_BILL_CUST_ID,SALES_REPS,a.ORGANIZATION_ID,b.BILLING_USER_ID
	FROM         IMS_NEW..INVOICES a left outer join JOBS b on a.JOB_ID=b.JOB_ID
	WHERE a.ORGANIZATION_ID=@ORG_ID and a.STATUS_ID=4 
	) a
	INNER JOIN
	(
	select case 
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),1) = '-' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-1)) /* -XXX*/
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),2) = '-0' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-2)) /* -0XXX*/
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),4) = 'CM-0' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-4)) /* CM-0XXX */
	ELSE SERVICE_TRAX_INVOICEID /* INV suffix */
	END as SERVICE_TRAX_INVOICEID
	,SOPNUMBE,SOPTYPE,DOCAMNT,BACHNUMB,CUSTNMBR,CUSTNAME,CSTPONBR from (
	select CASE SOPTYPE 
				 WHEN 3 then substring(SOPNUMBE,1,abs(datalength(rtrim(SOPNUMBE))-3)) /*720,XXX*/
				 WHEN 4 then substring(SOPNUMBE,1,abs(datalength(rtrim(SOPNUMBE))-6)) /*CR-XXX,CM-XXX*/
				 ELSE ''
				 END as SERVICE_TRAX_INVOICEID
	,SOPNUMBE,SOPTYPE,CASE SOPTYPE WHEN 3 then DOCAMNT WHEN 4 THEN DOCAMNT * -1 END DOCAMNT,BACHNUMB,CUSTNMBR,CUSTNAME,CSTPONBR from AMMAD..SOP30200 
	where DOCDATE between @begdate and @enddate ) x
	) b on b.SERVICE_TRAX_INVOICEID=a.INVOICE_ID where BILLING_USER_ID=@userID
/* This was the old way of calculating avg sales over 28 day period from service trax only
	select @salesTotal=sum(bill_total)/@numdays from service_lines WITH (NOLOCK) inner join jobs_v WITH (NOLOCK) on jobs_v.JOB_NO=service_lines.BILL_JOB_NO
		inner join CUSTOMERS WITH (NOLOCK) on JOBS_V.CUSTOMER_ID=CUSTOMERS.CUSTOMER_ID
		and SERVICE_LINE_DATE in (select distinct DATEREPORTRUN from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where DATEREPORTRUN between @begdate and @enddate)	and BILLING_USER_ID=@resid 
*/
	select @unbilledGrandTotal=isnull(@sumBillable,0)+isnull(@sumPooledTotal,0)+isnull(@sumUnbilledOpsInvoices,0)
	if isnull(@salesTotal,0) <> 0 --Ensure there are sales for this time period, and not only unbilled sales to avoid divide by zero error
	begin
		select @DSOTotal=isnull(@unbilledGrandTotal,0)/isnull(@salesTotal,0)
	end
	if @unbilledGrandTotal <> 0 
	begin	
		insert into @tbl values('Projects',999,@name,@unbilledGrandTotal,isnull(@salesTotal,0),isnull(@DSOTotal,0))
	end
	/* clear the variables for the next loop */
	select @name='',@userID=-1,@sumBillable=0,@sumNonBillable=0,@sumPooledTotal=0,@sumUnbilledOpsInvoices=0,
				@salesTotal=0,@unbilledGrandTotal=0,@DSOTotal=0
	FETCH NEXT FROM C_Cursor INTO @name,@userID
end
DEALLOCATE C_Cursor

/*Query for all Unbilled Accounting Items (Pending and Complete)
SELECT sum(iv.custom_line_total) custom_tot, sum(iv.bill_hourly_total) hours_total, sum(iv.bill_exp_total) exp_tot, iv.ext_batch_id, iv.assigned_to_name, iv.job_no, iv.job_id, iv.batch_status_id, ibs.name batch_status_name,
						sum(iv.bill_total + iv.custom_line_total) total_tot, iv.invoice_id_trk, iv.invoice_id, iv.invoice_description, iv.invoice_type_name, iv.invoice_status_id, iv.date_sent, iv.ext_dealer_id, iv.dealer_name, iv.customer_name, iv.invoice_format_type_name, iv.po_no, iv.invoice_date_created
		FROM invoice_pre_total_v iv, invoice_batch_statuses ibs
		WHERE iv.batch_status_id = ibs.status_id
		AND iv.invoice_status_id in (2,3) --Pending and Complete
		GROUP BY iv.invoice_id, iv.invoice_id_trk, iv.invoice_description, iv.invoice_type_name, iv.invoice_status_id, iv.date_sent, iv.ext_dealer_id, iv.dealer_name, iv.customer_name, iv.ext_batch_id, iv.assigned_to_name, iv.invoice_format_type_name, iv.job_no, iv.job_id, iv.po_no, iv.batch_status_id, iv.invoice_date_created, ibs.name
		ORDER BY iv.invoice_id
*/
insert into @tbl select 'Unbilled Accounting',iv.ORGANIZATION_ID,customer_name,sum(iv.bill_total + iv.custom_line_total) total_tot,0,0
		FROM invoice_pre_total_v iv WITH (NOLOCK), invoice_batch_statuses ibs WITH (NOLOCK)
		WHERE iv.batch_status_id = ibs.status_id
		AND iv.invoice_status_id in (2,3) --Pending and Complete
		and iv.ORGANIZATION_ID=@ORG_ID
		GROUP BY iv.invoice_id, iv.invoice_id_trk, iv.invoice_description, iv.invoice_type_name, iv.invoice_status_id, iv.date_sent, iv.ext_dealer_id, iv.dealer_name, iv.customer_name, iv.ext_batch_id, iv.assigned_to_name, iv.invoice_format_type_name, iv.job_no, iv.job_id, iv.po_no, iv.batch_status_id, iv.invoice_date_created, ibs.name, iv.ORGANIZATION_ID
		ORDER BY iv.invoice_id

select  TYPE,b.ORGANIZATION_ID,CUSTOMER_NAME,UnbilledDollars,AvgDaySales,DSO,b.NAME from @tbl a 
INNER JOIN (SELECT ORGANIZATION_ID,NAME FROM ORGANIZATIONS
UNION ALL
SELECT '999', 'PROJECTS') b on a.organization_id=b.organization_id
--select  TYPE,ORGANIZATIONS.ORGANIZATION_ID,CUSTOMER_NAME,UnbilledDollars,AvgDaySales,DSO,NAME from @tbl a
--left outer join ORGANIZATIONS on ORGANIZATIONS.ORGANIZATION_ID=a.ORGANIZATION_ID

--drop table @tbl

endprocess:

--exec sp_CRYSTAL_UNBILLED_REPORT_AMMAD_DATERANGE
GO
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_UNBILLED_REPORT_AMMAD]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_CRYSTAL_UNBILLED_REPORT_AMMAD]
AS
set nocount on

declare @tbl TABLE (
	[TYPE] char(255),
	[ORGANIZATION_ID] [numeric] (19,0),
	[CUSTOMER_NAME] varchar(255) ,
	[UnbilledDollars] [numeric](19, 5) ,
	[AvgDaySales] [numeric](19, 5),
	[DSO] [numeric](19, 5)
) 

/* Find number of days to divide unbilled $'s by.  Always done by 28 day time periods
   numdays is calculated as a failsafe if daily data capture missed a day, therefore the count
   would not include that day
*/
declare @numdays int, @begdate datetime, @enddate datetime
select @numdays=0
select @begdate = CAST(FLOOR(CAST(getdate()-28 AS FLOAT))AS DATETIME)
select @enddate = CAST(FLOOR(CAST(getdate()-1 AS FLOAT))AS DATETIME)
select @numdays=count(*) from (select distinct DATEREPORTRUN from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
	where DATEREPORTRUN <= @enddate and DATEREPORTRUN >= @begdate) a

/* avoid divide by zero error (no data in dailydatacapture)*/
if @numdays <= 0 goto endprocess

declare @customer varchar(255),
				@ORG_ID numeric(19,0),
				@JOB_NO varchar(255),
				@sumBillable numeric(19,5),
				@sumNonBillable numeric(19,5),
				@sumPooledTotal numeric(19,5),
				@sumUnbilledOpsInvoices numeric(19,5),
				@salesTotal numeric(19,5),
				@unbilledGrandTotal numeric(19,5),
				@DSOTotal numeric(19,5)

select @ORG_ID=4

declare C_Cursor CURSOR for select DISTINCT CUSTOMER_NAME from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK) where ORGANIZATION_ID=@ORG_ID order by CUSTOMER_NAME asc
OPEN C_Cursor
FETCH NEXT FROM C_Cursor INTO @customer
WHILE (@@FETCH_STATUS <> -1)
begin /*Find the totals for this particular customer and organization for this 28 day time period */
	select @sumBillable=sum(billable_total)/@numdays,@sumNonBillable=sum(non_billable_total)/@numdays
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where CUSTOMER_NAME=@customer and ORGANIZATION_ID=@ORG_ID and 
		DATEREPORTRUN between @begdate and @enddate 

		select @sumPooledTotal=sum(PooledTotal)/@numdays from
		(select bill_job_id,PooledTotal
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where CUSTOMER_NAME=@customer and ORGANIZATION_ID=@ORG_ID and 
		DATEREPORTRUN between @begdate and @enddate
		GROUP BY BILL_JOB_ID,PooledTotal) a 

		select @sumUnbilledOpsInvoices=sum(UnbilledOpsInvoicesTotal)/@numdays from
		(select bill_job_id,UnbilledOpsInvoicesTotal
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where CUSTOMER_NAME=@customer and ORGANIZATION_ID=@ORG_ID and 
		DATEREPORTRUN between @begdate and @enddate
		GROUP BY BILL_JOB_ID,UnbilledOpsInvoicesTotal) a 

	/*Total sales average for the number of days specified by @numdays */
	select @salesTotal=sum(DOCAMNT)/@numdays from (
	SELECT    ltrim(rtrim(str(INVOICE_ID))) INVOICE_ID,BILL_CUSTOMER_ID,EXT_BILL_CUST_ID,SALES_REPS,EXT_DEALER_ID,EXT_CUSTOMER_ID,CUSTOMER_NAME,a.ORGANIZATION_ID
	FROM         IMS_NEW..INVOICES a LEFT OUTER JOIN CUSTOMERS b on a.BILL_CUSTOMER_ID=b.CUSTOMER_ID
	WHERE a.ORGANIZATION_ID=@ORG_ID and a.STATUS_ID=4
	) a
	INNER JOIN
	(
	select case 
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),1) = '-' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-1)) /* -XXX*/
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),2) = '-0' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-2)) /* -0XXX*/
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),4) = 'CM-0' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-4)) /* CM-0XXX */
	ELSE SERVICE_TRAX_INVOICEID /* INV suffix */
	END as SERVICE_TRAX_INVOICEID
	,SOPNUMBE,SOPTYPE,DOCAMNT,BACHNUMB,CUSTNMBR,CUSTNAME,CSTPONBR from (
	select CASE SOPTYPE 
				 WHEN 3 then substring(SOPNUMBE,1,abs(datalength(rtrim(SOPNUMBE))-3)) /*720,XXX*/
				 WHEN 4 then substring(SOPNUMBE,1,abs(datalength(rtrim(SOPNUMBE))-6)) /*CR-XXX,CM-XXX*/
				 ELSE ''
				 END as SERVICE_TRAX_INVOICEID
	,SOPNUMBE,SOPTYPE,CASE SOPTYPE WHEN 3 then DOCAMNT WHEN 4 THEN DOCAMNT * -1 END DOCAMNT,BACHNUMB,CUSTNMBR,CUSTNAME,CSTPONBR 
	from AMMAD..SOP30200 
	where DOCDATE between @begdate and @enddate ) x
	) b on b.SERVICE_TRAX_INVOICEID=a.INVOICE_ID where CUSTOMER_NAME=@customer and ORGANIZATION_ID=@ORG_ID
/* This was the old way of calculating avg sales over 28 day period from servicee trax only 
	select @salesTotal=sum(bill_total)/@numdays from service_lines WITH (NOLOCK) inner join jobs WITH (NOLOCK) on jobs.JOB_NO=service_lines.BILL_JOB_NO 
		inner join CUSTOMERS WITH (NOLOCK) on JOBS.CUSTOMER_ID=CUSTOMERS.CUSTOMER_ID and BILLED_FLAG='Y' and SERVICE_LINE_DATE 
		in (select distinct DATEREPORTRUN from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK) 

		where DATEREPORTRUN between @begdate and @enddate) and CUSTOMER_NAME=@customer 
		and service_lines.ORGANIZATION_ID=@ORG_ID
*/
	select @unbilledGrandTotal=isnull(@sumBillable,0)+isnull(@sumPooledTotal,0)+isnull(@sumUnbilledOpsInvoices,0)
	if isnull(@salesTotal,0) <> 0 --Ensure there are sales for this time period, and not only unbilled sales to avoid divide by zero error
	begin
		select @DSOTotal=isnull(@unbilledGrandTotal,0)/isnull(@salesTotal,0)
	end
	insert into @tbl values('Unbilled OPs',@ORG_ID,@customer,@unbilledGrandTotal,isnull(@salesTotal,0),isnull(@DSOTotal,0))
	/* clear the variables for the next loop */
	select @customer='',@JOB_NO='',@sumBillable=0,@sumNonBillable=0,@sumPooledTotal=0,@sumUnbilledOpsInvoices=0,
			@salesTotal=0,@unbilledGrandTotal=0,@DSOTotal=0
	FETCH NEXT FROM C_Cursor INTO @customer
end
DEALLOCATE C_Cursor

declare @name varchar(255),
		@userID int

declare C_Cursor CURSOR for select rtrim(FIRST_NAME) + ' ' + rtrim(LAST_NAME) fullName,USER_ID
 from USERS WITH (NOLOCK) union
	select 'UNKNOWN USER','-999'
OPEN C_Cursor
FETCH NEXT FROM C_Cursor INTO @name,@userID
WHILE (@@FETCH_STATUS <> -1)
begin /*Find the totals for this particular customer and organization for this 28 day time period */
select @sumBillable=sum(billable_total)/@numdays,@sumNonBillable=sum(non_billable_total)/@numdays
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where BILLING_USER_ID=@userID and
		DATEREPORTRUN between @begdate and @enddate and ORGANIZATION_ID=@ORG_ID

		select @sumPooledTotal=sum(PooledTotal)/@numdays from
		(select bill_job_id,PooledTotal
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where BILLING_USER_ID=@userID and
		DATEREPORTRUN between @begdate and @enddate and ORGANIZATION_ID=@ORG_ID
		GROUP BY BILL_JOB_ID,PooledTotal) a 

		select @sumUnbilledOpsInvoices=sum(UnbilledOpsInvoicesTotal)/@numdays from
		(select bill_job_id,UnbilledOpsInvoicesTotal
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where BILLING_USER_ID=@userID and
		DATEREPORTRUN between @begdate and @enddate and ORGANIZATION_ID=@ORG_ID
		GROUP BY BILL_JOB_ID,UnbilledOpsInvoicesTotal) a 

	/*Total sales average for the number of days specified by @numdays for user*/
	select @salesTotal=sum(DOCAMNT)/@numdays from (
	SELECT    ltrim(rtrim(str(a.INVOICE_ID))) INVOICE_ID,BILL_CUSTOMER_ID,EXT_BILL_CUST_ID,SALES_REPS,a.ORGANIZATION_ID,b.BILLING_USER_ID
	FROM         IMS_NEW..INVOICES a left outer join JOBS b on a.JOB_ID=b.JOB_ID
	WHERE a.ORGANIZATION_ID=@ORG_ID and a.STATUS_ID=4 
	) a
	INNER JOIN
	(
	select case 
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),1) = '-' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-1)) /* -XXX*/
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),2) = '-0' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-2)) /* -0XXX*/
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),4) = 'CM-0' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-4)) /* CM-0XXX */
	ELSE SERVICE_TRAX_INVOICEID /* INV suffix */
	END as SERVICE_TRAX_INVOICEID
	,SOPNUMBE,SOPTYPE,DOCAMNT,BACHNUMB,CUSTNMBR,CUSTNAME,CSTPONBR from (
	select CASE SOPTYPE 
				 WHEN 3 then substring(SOPNUMBE,1,abs(datalength(rtrim(SOPNUMBE))-3)) /*720,XXX*/
				 WHEN 4 then substring(SOPNUMBE,1,abs(datalength(rtrim(SOPNUMBE))-6)) /*CR-XXX,CM-XXX*/
				 ELSE ''
				 END as SERVICE_TRAX_INVOICEID
	,SOPNUMBE,SOPTYPE,CASE SOPTYPE WHEN 3 then DOCAMNT WHEN 4 THEN DOCAMNT * -1 END DOCAMNT,BACHNUMB,CUSTNMBR,CUSTNAME,CSTPONBR from AMMAD..SOP30200 
	where DOCDATE between @begdate and @enddate ) x
	) b on b.SERVICE_TRAX_INVOICEID=a.INVOICE_ID where BILLING_USER_ID=@userID
/* This was the old way of calculating avg sales over 28 day period from service trax only
	select @salesTotal=sum(bill_total)/@numdays from service_lines WITH (NOLOCK) inner join jobs_v WITH (NOLOCK) on jobs_v.JOB_NO=service_lines.BILL_JOB_NO
		inner join CUSTOMERS WITH (NOLOCK) on JOBS_V.CUSTOMER_ID=CUSTOMERS.CUSTOMER_ID
		and SERVICE_LINE_DATE in (select distinct DATEREPORTRUN from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where DATEREPORTRUN between @begdate and @enddate)	and BILLING_USER_ID=@resid 
*/
	select @unbilledGrandTotal=isnull(@sumBillable,0)+isnull(@sumPooledTotal,0)+isnull(@sumUnbilledOpsInvoices,0)
	if isnull(@salesTotal,0) <> 0 --Ensure there are sales for this time period, and not only unbilled sales to avoid divide by zero error
	begin
		select @DSOTotal=isnull(@unbilledGrandTotal,0)/isnull(@salesTotal,0)
	end
	if @unbilledGrandTotal <> 0 
	begin	
		insert into @tbl values('Projects',999,@name,@unbilledGrandTotal,isnull(@salesTotal,0),isnull(@DSOTotal,0))
	end
	/* clear the variables for the next loop */
	select @name='',@userID=-1,@sumBillable=0,@sumNonBillable=0,@sumPooledTotal=0,@sumUnbilledOpsInvoices=0,
				@salesTotal=0,@unbilledGrandTotal=0,@DSOTotal=0
	FETCH NEXT FROM C_Cursor INTO @name,@userID
end
DEALLOCATE C_Cursor

/*Query for all Unbilled Accounting Items (Pending and Complete)
SELECT sum(iv.custom_line_total) custom_tot, sum(iv.bill_hourly_total) hours_total, sum(iv.bill_exp_total) exp_tot, iv.ext_batch_id, iv.assigned_to_name, iv.job_no, iv.job_id, iv.batch_status_id, ibs.name batch_status_name,
						sum(iv.bill_total + iv.custom_line_total) total_tot, iv.invoice_id_trk, iv.invoice_id, iv.invoice_description, iv.invoice_type_name, iv.invoice_status_id, iv.date_sent, iv.ext_dealer_id, iv.dealer_name, iv.customer_name, iv.invoice_format_type_name, iv.po_no, iv.invoice_date_created
		FROM invoice_pre_total_v iv, invoice_batch_statuses ibs
		WHERE iv.batch_status_id = ibs.status_id
		AND iv.invoice_status_id in (2,3) --Pending and Complete
		GROUP BY iv.invoice_id, iv.invoice_id_trk, iv.invoice_description, iv.invoice_type_name, iv.invoice_status_id, iv.date_sent, iv.ext_dealer_id, iv.dealer_name, iv.customer_name, iv.ext_batch_id, iv.assigned_to_name, iv.invoice_format_type_name, iv.job_no, iv.job_id, iv.po_no, iv.batch_status_id, iv.invoice_date_created, ibs.name
		ORDER BY iv.invoice_id
*/
insert into @tbl select 'Unbilled Accounting',iv.ORGANIZATION_ID,customer_name,sum(iv.bill_total + iv.custom_line_total) total_tot,0,0
		FROM invoice_pre_total_v iv WITH (NOLOCK), invoice_batch_statuses ibs WITH (NOLOCK)
		WHERE iv.batch_status_id = ibs.status_id
		AND iv.invoice_status_id in (2,3) --Pending and Complete
		and iv.ORGANIZATION_ID=@ORG_ID
		GROUP BY iv.invoice_id, iv.invoice_id_trk, iv.invoice_description, iv.invoice_type_name, iv.invoice_status_id, iv.date_sent, iv.ext_dealer_id, iv.dealer_name, iv.customer_name, iv.ext_batch_id, iv.assigned_to_name, iv.invoice_format_type_name, iv.job_no, iv.job_id, iv.po_no, iv.batch_status_id, iv.invoice_date_created, ibs.name, iv.ORGANIZATION_ID
		ORDER BY iv.invoice_id

select  TYPE,b.ORGANIZATION_ID,CUSTOMER_NAME,UnbilledDollars,AvgDaySales,DSO,b.NAME from @tbl a 
INNER JOIN (SELECT ORGANIZATION_ID,NAME FROM ORGANIZATIONS
UNION ALL
SELECT '999', 'PROJECTS') b on a.organization_id=b.organization_id
--select  TYPE,ORGANIZATIONS.ORGANIZATION_ID,CUSTOMER_NAME,UnbilledDollars,AvgDaySales,DSO,NAME from @tbl a
--left outer join ORGANIZATIONS on ORGANIZATIONS.ORGANIZATION_ID=a.ORGANIZATION_ID

--drop table @tbl

endprocess:

--exec sp_CRYSTAL_UNBILLED_REPORT_AMMAD
GO
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_UNBILLED_REPORT_CIMN]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_CRYSTAL_UNBILLED_REPORT_CIMN]
AS
set nocount on

declare @tbl TABLE (
	[TYPE] char(255),
	[ORGANIZATION_ID] [numeric] (19,0),
	[CUSTOMER_NAME] varchar(255) ,
	[UnbilledDollars] [numeric](19, 5) ,
	[AvgDaySales] [numeric](19, 5),
	[DSO] [numeric](19, 5)
) 

/* Find number of days to divide unbilled $'s by.  Always done by 28 day time periods
   numdays is calculated as a failsafe if daily data capture missed a day, therefore the count
   would not include that day
*/
declare @numdays int, @begdate datetime, @enddate datetime
select @numdays=0
select @begdate = CAST(FLOOR(CAST(getdate()-28 AS FLOAT))AS DATETIME)
select @enddate = CAST(FLOOR(CAST(getdate()-1 AS FLOAT))AS DATETIME)
select @numdays=count(*) from (select distinct DATEREPORTRUN from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
	where DATEREPORTRUN <= @enddate and DATEREPORTRUN >= @begdate) a

/* avoid divide by zero error (no data in dailydatacapture)*/
if @numdays <= 0 goto endprocess

declare @customer varchar(255),
				@ORG_ID numeric(19,0),
				@JOB_NO varchar(255),
				@sumBillable numeric(19,5),
				@sumNonBillable numeric(19,5),
				@sumPooledTotal numeric(19,5),
				@sumUnbilledOpsInvoices numeric(19,5),
				@salesTotal numeric(19,5),
				@unbilledGrandTotal numeric(19,5),
				@DSOTotal numeric(19,5)

select @ORG_ID=15

declare C_Cursor CURSOR for select DISTINCT CUSTOMER_NAME from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK) where ORGANIZATION_ID=@ORG_ID order by CUSTOMER_NAME asc
OPEN C_Cursor
FETCH NEXT FROM C_Cursor INTO @customer
WHILE (@@FETCH_STATUS <> -1)
begin /*Find the totals for this particular customer and organization for this 28 day time period */
	select @sumBillable=sum(billable_total)/@numdays,@sumNonBillable=sum(non_billable_total)/@numdays
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where CUSTOMER_NAME=@customer and ORGANIZATION_ID=@ORG_ID and 
		DATEREPORTRUN between @begdate and @enddate 

		select @sumPooledTotal=sum(PooledTotal)/@numdays from
		(select bill_job_id,PooledTotal
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where CUSTOMER_NAME=@customer and ORGANIZATION_ID=@ORG_ID and 
		DATEREPORTRUN between @begdate and @enddate
		GROUP BY BILL_JOB_ID,PooledTotal) a 

		select @sumUnbilledOpsInvoices=sum(UnbilledOpsInvoicesTotal)/@numdays from
		(select bill_job_id,UnbilledOpsInvoicesTotal
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where CUSTOMER_NAME=@customer and ORGANIZATION_ID=@ORG_ID and 
		DATEREPORTRUN between @begdate and @enddate
		GROUP BY BILL_JOB_ID,UnbilledOpsInvoicesTotal) a 

	/*Total sales average for the number of days specified by @numdays */
	select @salesTotal=sum(DOCAMNT)/@numdays from (
	SELECT    ltrim(rtrim(str(INVOICE_ID))) INVOICE_ID,BILL_CUSTOMER_ID,EXT_BILL_CUST_ID,SALES_REPS,EXT_DEALER_ID,EXT_CUSTOMER_ID,CUSTOMER_NAME,a.ORGANIZATION_ID
	FROM         IMS_NEW..INVOICES a LEFT OUTER JOIN CUSTOMERS b on a.BILL_CUSTOMER_ID=b.CUSTOMER_ID
	WHERE a.ORGANIZATION_ID=@ORG_ID and a.STATUS_ID=4
	) a
	INNER JOIN
	(
	select case 
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),1) = '-' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-1)) /* -XXX*/
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),2) = '-0' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-2)) /* -0XXX*/
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),4) = 'CM-0' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-4)) /* CM-0XXX */
	ELSE SERVICE_TRAX_INVOICEID /* INV suffix */
	END as SERVICE_TRAX_INVOICEID
	,SOPNUMBE,SOPTYPE,DOCAMNT,BACHNUMB,CUSTNMBR,CUSTNAME,CSTPONBR from (
	select CASE SOPTYPE 
				 WHEN 3 then substring(SOPNUMBE,1,abs(datalength(rtrim(SOPNUMBE))-3)) /*720,XXX*/
				 WHEN 4 then substring(SOPNUMBE,1,abs(datalength(rtrim(SOPNUMBE))-6)) /*CR-XXX,CM-XXX*/
				 ELSE ''
				 END as SERVICE_TRAX_INVOICEID
	,SOPNUMBE,SOPTYPE,CASE SOPTYPE WHEN 3 then DOCAMNT WHEN 4 THEN DOCAMNT * -1 END DOCAMNT,BACHNUMB,CUSTNMBR,CUSTNAME,CSTPONBR 
	from CIMN..SOP30200 
	where DOCDATE between @begdate and @enddate ) x
	) b on b.SERVICE_TRAX_INVOICEID=a.INVOICE_ID where CUSTOMER_NAME=@customer and ORGANIZATION_ID=@ORG_ID
/* This was the old way of calculating avg sales over 28 day period from servicee trax only 
	select @salesTotal=sum(bill_total)/@numdays from service_lines WITH (NOLOCK) inner join jobs WITH (NOLOCK) on jobs.JOB_NO=service_lines.BILL_JOB_NO 
		inner join CUSTOMERS WITH (NOLOCK) on JOBS.CUSTOMER_ID=CUSTOMERS.CUSTOMER_ID and BILLED_FLAG='Y' and SERVICE_LINE_DATE 
		in (select distinct DATEREPORTRUN from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK) 

		where DATEREPORTRUN between @begdate and @enddate) and CUSTOMER_NAME=@customer 
		and service_lines.ORGANIZATION_ID=@ORG_ID
*/
	select @unbilledGrandTotal=isnull(@sumBillable,0)+isnull(@sumPooledTotal,0)+isnull(@sumUnbilledOpsInvoices,0)
	if isnull(@salesTotal,0) <> 0 --Ensure there are sales for this time period, and not only unbilled sales to avoid divide by zero error
	begin
		select @DSOTotal=isnull(@unbilledGrandTotal,0)/isnull(@salesTotal,0)
	end
	insert into @tbl values('Unbilled OPs',@ORG_ID,@customer,@unbilledGrandTotal,isnull(@salesTotal,0),isnull(@DSOTotal,0))
	/* clear the variables for the next loop */
	select @customer='',@JOB_NO='',@sumBillable=0,@sumNonBillable=0,@sumPooledTotal=0,@sumUnbilledOpsInvoices=0,
			@salesTotal=0,@unbilledGrandTotal=0,@DSOTotal=0
	FETCH NEXT FROM C_Cursor INTO @customer
end
DEALLOCATE C_Cursor

declare @name varchar(255),
		@userID int

declare C_Cursor CURSOR for select rtrim(FIRST_NAME) + ' ' + rtrim(LAST_NAME) fullName,USER_ID
 from USERS WITH (NOLOCK) union
	select 'UNKNOWN USER','-999'
OPEN C_Cursor
FETCH NEXT FROM C_Cursor INTO @name,@userID
WHILE (@@FETCH_STATUS <> -1)
begin /*Find the totals for this particular customer and organization for this 28 day time period */
select @sumBillable=sum(billable_total)/@numdays,@sumNonBillable=sum(non_billable_total)/@numdays
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where BILLING_USER_ID=@userID and
		DATEREPORTRUN between @begdate and @enddate and ORGANIZATION_ID=@ORG_ID

		select @sumPooledTotal=sum(PooledTotal)/@numdays from
		(select bill_job_id,PooledTotal
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where BILLING_USER_ID=@userID and
		DATEREPORTRUN between @begdate and @enddate and ORGANIZATION_ID=@ORG_ID
		GROUP BY BILL_JOB_ID,PooledTotal) a 

		select @sumUnbilledOpsInvoices=sum(UnbilledOpsInvoicesTotal)/@numdays from
		(select bill_job_id,UnbilledOpsInvoicesTotal
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where BILLING_USER_ID=@userID and
		DATEREPORTRUN between @begdate and @enddate and ORGANIZATION_ID=@ORG_ID
		GROUP BY BILL_JOB_ID,UnbilledOpsInvoicesTotal) a 

	/*Total sales average for the number of days specified by @numdays for user*/
	select @salesTotal=sum(DOCAMNT)/@numdays from (
	SELECT    ltrim(rtrim(str(a.INVOICE_ID))) INVOICE_ID,BILL_CUSTOMER_ID,EXT_BILL_CUST_ID,SALES_REPS,a.ORGANIZATION_ID,b.BILLING_USER_ID
	FROM         IMS_NEW..INVOICES a left outer join JOBS b on a.JOB_ID=b.JOB_ID
	WHERE a.ORGANIZATION_ID=@ORG_ID and a.STATUS_ID=4 
	) a
	INNER JOIN
	(
	select case 
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),1) = '-' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-1)) /* -XXX*/
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),2) = '-0' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-2)) /* -0XXX*/
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),4) = 'CM-0' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-4)) /* CM-0XXX */
	ELSE SERVICE_TRAX_INVOICEID /* INV suffix */
	END as SERVICE_TRAX_INVOICEID
	,SOPNUMBE,SOPTYPE,DOCAMNT,BACHNUMB,CUSTNMBR,CUSTNAME,CSTPONBR from (
	select CASE SOPTYPE 
				 WHEN 3 then substring(SOPNUMBE,1,abs(datalength(rtrim(SOPNUMBE))-3)) /*720,XXX*/
				 WHEN 4 then substring(SOPNUMBE,1,abs(datalength(rtrim(SOPNUMBE))-6)) /*CR-XXX,CM-XXX*/
				 ELSE ''
				 END as SERVICE_TRAX_INVOICEID
	,SOPNUMBE,SOPTYPE,CASE SOPTYPE WHEN 3 then DOCAMNT WHEN 4 THEN DOCAMNT * -1 END DOCAMNT,BACHNUMB,CUSTNMBR,CUSTNAME,CSTPONBR from CIMN..SOP30200 
	where DOCDATE between @begdate and @enddate ) x
	) b on b.SERVICE_TRAX_INVOICEID=a.INVOICE_ID where BILLING_USER_ID=@userID
/* This was the old way of calculating avg sales over 28 day period from service trax only
	select @salesTotal=sum(bill_total)/@numdays from service_lines WITH (NOLOCK) inner join jobs_v WITH (NOLOCK) on jobs_v.JOB_NO=service_lines.BILL_JOB_NO
		inner join CUSTOMERS WITH (NOLOCK) on JOBS_V.CUSTOMER_ID=CUSTOMERS.CUSTOMER_ID
		and SERVICE_LINE_DATE in (select distinct DATEREPORTRUN from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where DATEREPORTRUN between @begdate and @enddate)	and BILLING_USER_ID=@resid 
*/
	select @unbilledGrandTotal=isnull(@sumBillable,0)+isnull(@sumPooledTotal,0)+isnull(@sumUnbilledOpsInvoices,0)
	if isnull(@salesTotal,0) <> 0 --Ensure there are sales for this time period, and not only unbilled sales to avoid divide by zero error
	begin
		select @DSOTotal=isnull(@unbilledGrandTotal,0)/isnull(@salesTotal,0)
	end
	if @unbilledGrandTotal <> 0 
	begin	
		insert into @tbl values('Projects',999,@name,@unbilledGrandTotal,isnull(@salesTotal,0),isnull(@DSOTotal,0))
	end
	/* clear the variables for the next loop */
	select @name='',@userID=-1,@sumBillable=0,@sumNonBillable=0,@sumPooledTotal=0,@sumUnbilledOpsInvoices=0,
				@salesTotal=0,@unbilledGrandTotal=0,@DSOTotal=0
	FETCH NEXT FROM C_Cursor INTO @name,@userID
end
DEALLOCATE C_Cursor

/*Query for all Unbilled Accounting Items (Pending and Complete)
SELECT sum(iv.custom_line_total) custom_tot, sum(iv.bill_hourly_total) hours_total, sum(iv.bill_exp_total) exp_tot, iv.ext_batch_id, iv.assigned_to_name, iv.job_no, iv.job_id, iv.batch_status_id, ibs.name batch_status_name,
						sum(iv.bill_total + iv.custom_line_total) total_tot, iv.invoice_id_trk, iv.invoice_id, iv.invoice_description, iv.invoice_type_name, iv.invoice_status_id, iv.date_sent, iv.ext_dealer_id, iv.dealer_name, iv.customer_name, iv.invoice_format_type_name, iv.po_no, iv.invoice_date_created
		FROM invoice_pre_total_v iv, invoice_batch_statuses ibs
		WHERE iv.batch_status_id = ibs.status_id
		AND iv.invoice_status_id in (2,3) --Pending and Complete
		GROUP BY iv.invoice_id, iv.invoice_id_trk, iv.invoice_description, iv.invoice_type_name, iv.invoice_status_id, iv.date_sent, iv.ext_dealer_id, iv.dealer_name, iv.customer_name, iv.ext_batch_id, iv.assigned_to_name, iv.invoice_format_type_name, iv.job_no, iv.job_id, iv.po_no, iv.batch_status_id, iv.invoice_date_created, ibs.name
		ORDER BY iv.invoice_id
*/
insert into @tbl select 'Unbilled Accounting',iv.ORGANIZATION_ID,customer_name,sum(iv.bill_total + iv.custom_line_total) total_tot,0,0
		FROM invoice_pre_total_v iv WITH (NOLOCK), invoice_batch_statuses ibs WITH (NOLOCK)
		WHERE iv.batch_status_id = ibs.status_id
		AND iv.invoice_status_id in (2,3) --Pending and Complete
		and iv.ORGANIZATION_ID=@ORG_ID
		GROUP BY iv.invoice_id, iv.invoice_id_trk, iv.invoice_description, iv.invoice_type_name, iv.invoice_status_id, iv.date_sent, iv.ext_dealer_id, iv.dealer_name, iv.customer_name, iv.ext_batch_id, iv.assigned_to_name, iv.invoice_format_type_name, iv.job_no, iv.job_id, iv.po_no, iv.batch_status_id, iv.invoice_date_created, ibs.name, iv.ORGANIZATION_ID
		ORDER BY iv.invoice_id

select  TYPE,b.ORGANIZATION_ID,CUSTOMER_NAME,UnbilledDollars,AvgDaySales,DSO,b.NAME from @tbl a 
INNER JOIN (SELECT ORGANIZATION_ID,NAME FROM ORGANIZATIONS
UNION ALL
SELECT '999', 'PROJECTS') b on a.organization_id=b.organization_id
--select  TYPE,ORGANIZATIONS.ORGANIZATION_ID,CUSTOMER_NAME,UnbilledDollars,AvgDaySales,DSO,NAME from @tbl a
--left outer join ORGANIZATIONS on ORGANIZATIONS.ORGANIZATION_ID=a.ORGANIZATION_ID

--drop table @tbl

endprocess:

--exec sp_CRYSTAL_UNBILLED_REPORT_CIMN
GO
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_UNBILLED_REPORT_CIMN_DATERANGE]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_CRYSTAL_UNBILLED_REPORT_CIMN_DATERANGE]
	@begdate datetime, @enddate datetime
AS
set nocount on

declare @tbl TABLE (
	[TYPE] char(255),
	[ORGANIZATION_ID] [numeric] (19,0),
	[CUSTOMER_NAME] varchar(255) ,
	[UnbilledDollars] [numeric](19, 5) ,
	[AvgDaySales] [numeric](19, 5),
	[DSO] [numeric](19, 5)
) 

/* Find number of days to divide unbilled $'s by.  Always done by 28 day time periods*/
declare @numdays int
select @numdays=0
select @begdate=CAST(FLOOR(CAST(@begdate AS FLOAT))AS DATETIME)
select @enddate=CAST(FLOOR(CAST(@enddate AS FLOAT))AS DATETIME)
select @numdays=count(*) from (select distinct DATEREPORTRUN from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
	where DATEREPORTRUN <= @enddate and DATEREPORTRUN >= @begdate) a

/* avoid divide by zero error (no data in dailydatacapture)*/
if @numdays <= 0 goto endprocess

declare @customer varchar(255),
				@ORG_ID numeric(19,0),
				@JOB_NO varchar(255),
				@sumBillable numeric(19,5),
				@sumNonBillable numeric(19,5),
				@sumPooledTotal numeric(19,5),
				@sumUnbilledOpsInvoices numeric(19,5),
				@salesTotal numeric(19,5),
				@unbilledGrandTotal numeric(19,5),
				@DSOTotal numeric(19,5)

select @ORG_ID=15

declare C_Cursor CURSOR for select DISTINCT CUSTOMER_NAME from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK) where ORGANIZATION_ID=@ORG_ID order by CUSTOMER_NAME asc
OPEN C_Cursor
FETCH NEXT FROM C_Cursor INTO @customer
WHILE (@@FETCH_STATUS <> -1)
begin /*Find the totals for this particular customer and organization for this 28 day time period */
	select @sumBillable=sum(billable_total)/@numdays
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where CUSTOMER_NAME=@customer and ORGANIZATION_ID=@ORG_ID and 
		DATEREPORTRUN between @begdate and @enddate 

		select @sumPooledTotal=sum(PooledTotal)/@numdays from
		(select bill_job_id,PooledTotal
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where CUSTOMER_NAME=@customer and ORGANIZATION_ID=@ORG_ID and 
		DATEREPORTRUN between @begdate and @enddate
		GROUP BY BILL_JOB_ID,PooledTotal) a 

		select @sumUnbilledOpsInvoices=sum(UnbilledOpsInvoicesTotal)/@numdays from
		(select bill_job_id,UnbilledOpsInvoicesTotal
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where CUSTOMER_NAME=@customer and ORGANIZATION_ID=@ORG_ID and 
		DATEREPORTRUN between @begdate and @enddate
		GROUP BY BILL_JOB_ID,UnbilledOpsInvoicesTotal) a 

	/*Total sales average for the number of days specified by @numdays */
	select @salesTotal=sum(DOCAMNT)/@numdays from (
	SELECT    ltrim(rtrim(str(INVOICE_ID))) INVOICE_ID,BILL_CUSTOMER_ID,EXT_BILL_CUST_ID,SALES_REPS,EXT_DEALER_ID,EXT_CUSTOMER_ID,CUSTOMER_NAME,a.ORGANIZATION_ID
	FROM         IMS_NEW..INVOICES a LEFT OUTER JOIN CUSTOMERS b on a.BILL_CUSTOMER_ID=b.CUSTOMER_ID
	WHERE a.ORGANIZATION_ID=@ORG_ID and a.STATUS_ID=4
	) a
	INNER JOIN
	(
	select case 
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),1) = '-' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-1)) /* -XXX*/
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),2) = '-0' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-2)) /* -0XXX*/
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),4) = 'CM-0' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-4)) /* CM-0XXX */
	ELSE SERVICE_TRAX_INVOICEID /* INV suffix */
	END as SERVICE_TRAX_INVOICEID
	,SOPNUMBE,SOPTYPE,DOCAMNT,BACHNUMB,CUSTNMBR,CUSTNAME,CSTPONBR from (
	select CASE SOPTYPE 
				 WHEN 3 then substring(SOPNUMBE,1,abs(datalength(rtrim(SOPNUMBE))-3)) /*720,XXX*/
				 WHEN 4 then substring(SOPNUMBE,1,abs(datalength(rtrim(SOPNUMBE))-6)) /*CR-XXX,CM-XXX*/
				 ELSE ''
				 END as SERVICE_TRAX_INVOICEID
	,SOPNUMBE,SOPTYPE,CASE SOPTYPE WHEN 3 then DOCAMNT WHEN 4 THEN DOCAMNT * -1 END DOCAMNT,BACHNUMB,CUSTNMBR,CUSTNAME,CSTPONBR 
	from CIMN..SOP30200 
	where DOCDATE between @begdate and @enddate ) x
	) b on b.SERVICE_TRAX_INVOICEID=a.INVOICE_ID where CUSTOMER_NAME=@customer and ORGANIZATION_ID=@ORG_ID
/* This was the old way of calculating avg sales over 28 day period from servicee trax only 
	select @salesTotal=sum(bill_total)/@numdays from service_lines WITH (NOLOCK) inner join jobs WITH (NOLOCK) on jobs.JOB_NO=service_lines.BILL_JOB_NO 
		inner join CUSTOMERS WITH (NOLOCK) on JOBS.CUSTOMER_ID=CUSTOMERS.CUSTOMER_ID and BILLED_FLAG='Y' and SERVICE_LINE_DATE 
		in (select distinct DATEREPORTRUN from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK) 

		where DATEREPORTRUN between @begdate and @enddate) and CUSTOMER_NAME=@customer 
		and service_lines.ORGANIZATION_ID=@ORG_ID
*/
	select @unbilledGrandTotal=isnull(@sumBillable,0)+isnull(@sumPooledTotal,0)+isnull(@sumUnbilledOpsInvoices,0)
	if isnull(@salesTotal,0) <> 0 --Ensure there are sales for this time period, and not only unbilled sales to avoid divide by zero error
	begin
		select @DSOTotal=isnull(@unbilledGrandTotal,0)/isnull(@salesTotal,0)
	end
	insert into @tbl values('Unbilled OPs',@ORG_ID,@customer,@unbilledGrandTotal,isnull(@salesTotal,0),isnull(@DSOTotal,0))
	/* clear the variables for the next loop */
	select @customer='',@JOB_NO='',@sumBillable=0,@sumNonBillable=0,@sumPooledTotal=0,@sumUnbilledOpsInvoices=0,
			@salesTotal=0,@unbilledGrandTotal=0,@DSOTotal=0
	FETCH NEXT FROM C_Cursor INTO @customer
end
DEALLOCATE C_Cursor

declare @name varchar(255),
		@userID int

declare C_Cursor CURSOR for select rtrim(FIRST_NAME) + ' ' + rtrim(LAST_NAME) fullName,USER_ID
 from USERS WITH (NOLOCK) union
	select 'UNKNOWN USER','-999'
OPEN C_Cursor
FETCH NEXT FROM C_Cursor INTO @name,@userID
WHILE (@@FETCH_STATUS <> -1)
begin /*Find the totals for this particular customer and organization for this 28 day time period */
select @sumBillable=sum(billable_total)/@numdays,@sumNonBillable=sum(non_billable_total)/@numdays
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where BILLING_USER_ID=@userID and
		DATEREPORTRUN between @begdate and @enddate and ORGANIZATION_ID=@ORG_ID

		select @sumPooledTotal=sum(PooledTotal)/@numdays from
		(select bill_job_id,PooledTotal
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where BILLING_USER_ID=@userID and
		DATEREPORTRUN between @begdate and @enddate and ORGANIZATION_ID=@ORG_ID
		GROUP BY BILL_JOB_ID,PooledTotal) a 

		select @sumUnbilledOpsInvoices=sum(UnbilledOpsInvoicesTotal)/@numdays from
		(select bill_job_id,UnbilledOpsInvoicesTotal
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where BILLING_USER_ID=@userID and
		DATEREPORTRUN between @begdate and @enddate and ORGANIZATION_ID=@ORG_ID
		GROUP BY BILL_JOB_ID,UnbilledOpsInvoicesTotal) a 

	/*Total sales average for the number of days specified by @numdays for user*/
	select @salesTotal=sum(DOCAMNT)/@numdays from (
	SELECT    ltrim(rtrim(str(a.INVOICE_ID))) INVOICE_ID,BILL_CUSTOMER_ID,EXT_BILL_CUST_ID,SALES_REPS,a.ORGANIZATION_ID,b.BILLING_USER_ID
	FROM         IMS_NEW..INVOICES a left outer join JOBS b on a.JOB_ID=b.JOB_ID
	WHERE a.ORGANIZATION_ID=@ORG_ID and a.STATUS_ID=4 
	) a
	INNER JOIN
	(
	select case 
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),1) = '-' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-1)) /* -XXX*/
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),2) = '-0' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-2)) /* -0XXX*/
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),4) = 'CM-0' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-4)) /* CM-0XXX */
	ELSE SERVICE_TRAX_INVOICEID /* INV suffix */
	END as SERVICE_TRAX_INVOICEID
	,SOPNUMBE,SOPTYPE,DOCAMNT,BACHNUMB,CUSTNMBR,CUSTNAME,CSTPONBR from (
	select CASE SOPTYPE 
				 WHEN 3 then substring(SOPNUMBE,1,abs(datalength(rtrim(SOPNUMBE))-3)) /*720,XXX*/
				 WHEN 4 then substring(SOPNUMBE,1,abs(datalength(rtrim(SOPNUMBE))-6)) /*CR-XXX,CM-XXX*/
				 ELSE ''
				 END as SERVICE_TRAX_INVOICEID
	,SOPNUMBE,SOPTYPE,CASE SOPTYPE WHEN 3 then DOCAMNT WHEN 4 THEN DOCAMNT * -1 END DOCAMNT,BACHNUMB,CUSTNMBR,CUSTNAME,CSTPONBR from CIMN..SOP30200 
	where DOCDATE between @begdate and @enddate ) x
	) b on b.SERVICE_TRAX_INVOICEID=a.INVOICE_ID where BILLING_USER_ID=@userID
/* This was the old way of calculating avg sales over 28 day period from service trax only
	select @salesTotal=sum(bill_total)/@numdays from service_lines WITH (NOLOCK) inner join jobs_v WITH (NOLOCK) on jobs_v.JOB_NO=service_lines.BILL_JOB_NO
		inner join CUSTOMERS WITH (NOLOCK) on JOBS_V.CUSTOMER_ID=CUSTOMERS.CUSTOMER_ID
		and SERVICE_LINE_DATE in (select distinct DATEREPORTRUN from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where DATEREPORTRUN between @begdate and @enddate)	and BILLING_USER_ID=@resid 
*/
	select @unbilledGrandTotal=isnull(@sumBillable,0)+isnull(@sumPooledTotal,0)+isnull(@sumUnbilledOpsInvoices,0)
	if isnull(@salesTotal,0) <> 0 --Ensure there are sales for this time period, and not only unbilled sales to avoid divide by zero error
	begin
		select @DSOTotal=isnull(@unbilledGrandTotal,0)/isnull(@salesTotal,0)
	end
	if @unbilledGrandTotal <> 0 
	begin	
		insert into @tbl values('Projects',999,@name,@unbilledGrandTotal,isnull(@salesTotal,0),isnull(@DSOTotal,0))
	end
	/* clear the variables for the next loop */
	select @name='',@userID=-1,@sumBillable=0,@sumNonBillable=0,@sumPooledTotal=0,@sumUnbilledOpsInvoices=0,
				@salesTotal=0,@unbilledGrandTotal=0,@DSOTotal=0
	FETCH NEXT FROM C_Cursor INTO @name,@userID
end
DEALLOCATE C_Cursor

/*Query for all Unbilled Accounting Items (Pending and Complete)
SELECT sum(iv.custom_line_total) custom_tot, sum(iv.bill_hourly_total) hours_total, sum(iv.bill_exp_total) exp_tot, iv.ext_batch_id, iv.assigned_to_name, iv.job_no, iv.job_id, iv.batch_status_id, ibs.name batch_status_name,
						sum(iv.bill_total + iv.custom_line_total) total_tot, iv.invoice_id_trk, iv.invoice_id, iv.invoice_description, iv.invoice_type_name, iv.invoice_status_id, iv.date_sent, iv.ext_dealer_id, iv.dealer_name, iv.customer_name, iv.invoice_format_type_name, iv.po_no, iv.invoice_date_created
		FROM invoice_pre_total_v iv, invoice_batch_statuses ibs
		WHERE iv.batch_status_id = ibs.status_id
		AND iv.invoice_status_id in (2,3) --Pending and Complete
		GROUP BY iv.invoice_id, iv.invoice_id_trk, iv.invoice_description, iv.invoice_type_name, iv.invoice_status_id, iv.date_sent, iv.ext_dealer_id, iv.dealer_name, iv.customer_name, iv.ext_batch_id, iv.assigned_to_name, iv.invoice_format_type_name, iv.job_no, iv.job_id, iv.po_no, iv.batch_status_id, iv.invoice_date_created, ibs.name
		ORDER BY iv.invoice_id
*/
insert into @tbl select 'Unbilled Accounting',iv.ORGANIZATION_ID,customer_name,sum(iv.bill_total + iv.custom_line_total) total_tot,0,0
		FROM invoice_pre_total_v iv WITH (NOLOCK), invoice_batch_statuses ibs WITH (NOLOCK)
		WHERE iv.batch_status_id = ibs.status_id
		AND iv.invoice_status_id in (2,3) --Pending and Complete
		and iv.ORGANIZATION_ID=@ORG_ID
		GROUP BY iv.invoice_id, iv.invoice_id_trk, iv.invoice_description, iv.invoice_type_name, iv.invoice_status_id, iv.date_sent, iv.ext_dealer_id, iv.dealer_name, iv.customer_name, iv.ext_batch_id, iv.assigned_to_name, iv.invoice_format_type_name, iv.job_no, iv.job_id, iv.po_no, iv.batch_status_id, iv.invoice_date_created, ibs.name, iv.ORGANIZATION_ID
		ORDER BY iv.invoice_id

select  TYPE,b.ORGANIZATION_ID,CUSTOMER_NAME,UnbilledDollars,AvgDaySales,DSO,b.NAME from @tbl a 
INNER JOIN (SELECT ORGANIZATION_ID,NAME FROM ORGANIZATIONS
UNION ALL
SELECT '999', 'PROJECTS') b on a.organization_id=b.organization_id
--select  TYPE,ORGANIZATIONS.ORGANIZATION_ID,CUSTOMER_NAME,UnbilledDollars,AvgDaySales,DSO,NAME from @tbl a
--left outer join ORGANIZATIONS on ORGANIZATIONS.ORGANIZATION_ID=a.ORGANIZATION_ID

--drop table @tbl

endprocess:

--exec sp_CRYSTAL_UNBILLED_REPORT_CIMN_DATERANGE
GO
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_UNBILLED_REPORT_ICS]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_CRYSTAL_UNBILLED_REPORT_ICS]
AS
set nocount on

declare @tbl TABLE (
	[TYPE] char(255),
	[ORGANIZATION_ID] [numeric] (19,0),
	[CUSTOMER_NAME] varchar(255) ,
	[UnbilledDollars] [numeric](19, 5) ,
	[AvgDaySales] [numeric](19, 5),
	[DSO] [numeric](19, 5)
) 

/* Find number of days to divide unbilled $'s by.  Always done by 28 day time periods
   numdays is calculated as a failsafe if daily data capture missed a day, therefore the count
   would not include that day
*/
declare @numdays int, @begdate datetime, @enddate datetime
select @numdays=0
select @begdate = CAST(FLOOR(CAST(getdate()-28 AS FLOAT))AS DATETIME)
select @enddate = CAST(FLOOR(CAST(getdate()-1 AS FLOAT))AS DATETIME)
select @numdays=count(*) from (select distinct DATEREPORTRUN from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
	where DATEREPORTRUN <= @enddate and DATEREPORTRUN >= @begdate) a

/* avoid divide by zero error (no data in dailydatacapture)*/
if @numdays <= 0 goto endprocess

declare @customer varchar(255),
				@ORG_ID numeric(19,0),
				@JOB_NO varchar(255),
				@sumBillable numeric(19,5),
				@sumNonBillable numeric(19,5),
				@sumPooledTotal numeric(19,5),
				@sumUnbilledOpsInvoices numeric(19,5),
				@salesTotal numeric(19,5),
				@unbilledGrandTotal numeric(19,5),
				@DSOTotal numeric(19,5)

select @ORG_ID=12

declare C_Cursor CURSOR for select DISTINCT CUSTOMER_NAME from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK) where ORGANIZATION_ID=@ORG_ID order by CUSTOMER_NAME asc
OPEN C_Cursor
FETCH NEXT FROM C_Cursor INTO @customer
WHILE (@@FETCH_STATUS <> -1)
begin /*Find the totals for this particular customer and organization for this 28 day time period */
	select @sumBillable=sum(billable_total)/@numdays,@sumNonBillable=sum(non_billable_total)/@numdays
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where CUSTOMER_NAME=@customer and ORGANIZATION_ID=@ORG_ID and 
		DATEREPORTRUN between @begdate and @enddate 

		select @sumPooledTotal=sum(PooledTotal)/@numdays from
		(select bill_job_id,PooledTotal
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where CUSTOMER_NAME=@customer and ORGANIZATION_ID=@ORG_ID and 
		DATEREPORTRUN between @begdate and @enddate
		GROUP BY BILL_JOB_ID,PooledTotal) a 

		select @sumUnbilledOpsInvoices=sum(UnbilledOpsInvoicesTotal)/@numdays from
		(select bill_job_id,UnbilledOpsInvoicesTotal
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where CUSTOMER_NAME=@customer and ORGANIZATION_ID=@ORG_ID and 
		DATEREPORTRUN between @begdate and @enddate
		GROUP BY BILL_JOB_ID,UnbilledOpsInvoicesTotal) a 

	/*Total sales average for the number of days specified by @numdays */
	select @salesTotal=sum(DOCAMNT)/@numdays from (
	SELECT    ltrim(rtrim(str(INVOICE_ID))) INVOICE_ID,BILL_CUSTOMER_ID,EXT_BILL_CUST_ID,SALES_REPS,EXT_DEALER_ID,EXT_CUSTOMER_ID,CUSTOMER_NAME,a.ORGANIZATION_ID
	FROM         IMS_NEW..INVOICES a LEFT OUTER JOIN CUSTOMERS b on a.BILL_CUSTOMER_ID=b.CUSTOMER_ID
	WHERE a.ORGANIZATION_ID=@ORG_ID and a.STATUS_ID=4
	) a
	INNER JOIN
	(
	select case 
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),1) = '-' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-1)) /* -XXX*/
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),2) = '-0' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-2)) /* -0XXX*/
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),4) = 'CM-0' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-4)) /* CM-0XXX */
	ELSE SERVICE_TRAX_INVOICEID /* INV suffix */
	END as SERVICE_TRAX_INVOICEID
	,SOPNUMBE,SOPTYPE,DOCAMNT,BACHNUMB,CUSTNMBR,CUSTNAME,CSTPONBR from (
	select CASE SOPTYPE 
				 WHEN 3 then substring(SOPNUMBE,1,abs(datalength(rtrim(SOPNUMBE))-3)) /*720,XXX*/
				 WHEN 4 then substring(SOPNUMBE,1,abs(datalength(rtrim(SOPNUMBE))-6)) /*CR-XXX,CM-XXX*/
				 ELSE ''
				 END as SERVICE_TRAX_INVOICEID
	,SOPNUMBE,SOPTYPE,CASE SOPTYPE WHEN 3 then DOCAMNT WHEN 4 THEN DOCAMNT * -1 END DOCAMNT,BACHNUMB,CUSTNMBR,CUSTNAME,CSTPONBR 
	from ICS..SOP30200 
	where DOCDATE between @begdate and @enddate ) x
	) b on b.SERVICE_TRAX_INVOICEID=a.INVOICE_ID where CUSTOMER_NAME=@customer and ORGANIZATION_ID=@ORG_ID
/* This was the old way of calculating avg sales over 28 day period from servicee trax only 
	select @salesTotal=sum(bill_total)/@numdays from service_lines WITH (NOLOCK) inner join jobs WITH (NOLOCK) on jobs.JOB_NO=service_lines.BILL_JOB_NO 
		inner join CUSTOMERS WITH (NOLOCK) on JOBS.CUSTOMER_ID=CUSTOMERS.CUSTOMER_ID and BILLED_FLAG='Y' and SERVICE_LINE_DATE 
		in (select distinct DATEREPORTRUN from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK) 

		where DATEREPORTRUN between @begdate and @enddate) and CUSTOMER_NAME=@customer 
		and service_lines.ORGANIZATION_ID=@ORG_ID
*/
	select @unbilledGrandTotal=isnull(@sumBillable,0)+isnull(@sumPooledTotal,0)+isnull(@sumUnbilledOpsInvoices,0)
	if isnull(@salesTotal,0) <> 0 --Ensure there are sales for this time period, and not only unbilled sales to avoid divide by zero error
	begin
		select @DSOTotal=isnull(@unbilledGrandTotal,0)/isnull(@salesTotal,0)
	end
	insert into @tbl values('Unbilled OPs',@ORG_ID,@customer,@unbilledGrandTotal,isnull(@salesTotal,0),isnull(@DSOTotal,0))
	/* clear the variables for the next loop */
	select @customer='',@JOB_NO='',@sumBillable=0,@sumNonBillable=0,@sumPooledTotal=0,@sumUnbilledOpsInvoices=0,
			@salesTotal=0,@unbilledGrandTotal=0,@DSOTotal=0
	FETCH NEXT FROM C_Cursor INTO @customer
end
DEALLOCATE C_Cursor

declare @name varchar(255),
		@userID int

declare C_Cursor CURSOR for select rtrim(FIRST_NAME) + ' ' + rtrim(LAST_NAME) fullName,USER_ID
 from USERS WITH (NOLOCK) union
	select 'UNKNOWN USER','-999'
OPEN C_Cursor
FETCH NEXT FROM C_Cursor INTO @name,@userID
WHILE (@@FETCH_STATUS <> -1)
begin /*Find the totals for this particular customer and organization for this 28 day time period */
select @sumBillable=sum(billable_total)/@numdays,@sumNonBillable=sum(non_billable_total)/@numdays
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where BILLING_USER_ID=@userID and
		DATEREPORTRUN between @begdate and @enddate and ORGANIZATION_ID=@ORG_ID

		select @sumPooledTotal=sum(PooledTotal)/@numdays from
		(select bill_job_id,PooledTotal
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where BILLING_USER_ID=@userID and
		DATEREPORTRUN between @begdate and @enddate and ORGANIZATION_ID=@ORG_ID
		GROUP BY BILL_JOB_ID,PooledTotal) a 

		select @sumUnbilledOpsInvoices=sum(UnbilledOpsInvoicesTotal)/@numdays from
		(select bill_job_id,UnbilledOpsInvoicesTotal
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where BILLING_USER_ID=@userID and
		DATEREPORTRUN between @begdate and @enddate and ORGANIZATION_ID=@ORG_ID
		GROUP BY BILL_JOB_ID,UnbilledOpsInvoicesTotal) a 

	/*Total sales average for the number of days specified by @numdays for user*/
	select @salesTotal=sum(DOCAMNT)/@numdays from (
	SELECT    ltrim(rtrim(str(a.INVOICE_ID))) INVOICE_ID,BILL_CUSTOMER_ID,EXT_BILL_CUST_ID,SALES_REPS,a.ORGANIZATION_ID,b.BILLING_USER_ID
	FROM         IMS_NEW..INVOICES a left outer join JOBS b on a.JOB_ID=b.JOB_ID
	WHERE a.ORGANIZATION_ID=@ORG_ID and a.STATUS_ID=4 
	) a
	INNER JOIN
	(
	select case 
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),1) = '-' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-1)) /* -XXX*/
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),2) = '-0' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-2)) /* -0XXX*/
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),4) = 'CM-0' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-4)) /* CM-0XXX */
	ELSE SERVICE_TRAX_INVOICEID /* INV suffix */
	END as SERVICE_TRAX_INVOICEID
	,SOPNUMBE,SOPTYPE,DOCAMNT,BACHNUMB,CUSTNMBR,CUSTNAME,CSTPONBR from (
	select CASE SOPTYPE 
				 WHEN 3 then substring(SOPNUMBE,1,abs(datalength(rtrim(SOPNUMBE))-3)) /*720,XXX*/
				 WHEN 4 then substring(SOPNUMBE,1,abs(datalength(rtrim(SOPNUMBE))-6)) /*CR-XXX,CM-XXX*/
				 ELSE ''
				 END as SERVICE_TRAX_INVOICEID
	,SOPNUMBE,SOPTYPE,CASE SOPTYPE WHEN 3 then DOCAMNT WHEN 4 THEN DOCAMNT * -1 END DOCAMNT,BACHNUMB,CUSTNMBR,CUSTNAME,CSTPONBR from ICS..SOP30200 
	where DOCDATE between @begdate and @enddate ) x
	) b on b.SERVICE_TRAX_INVOICEID=a.INVOICE_ID where BILLING_USER_ID=@userID
/* This was the old way of calculating avg sales over 28 day period from service trax only
	select @salesTotal=sum(bill_total)/@numdays from service_lines WITH (NOLOCK) inner join jobs_v WITH (NOLOCK) on jobs_v.JOB_NO=service_lines.BILL_JOB_NO
		inner join CUSTOMERS WITH (NOLOCK) on JOBS_V.CUSTOMER_ID=CUSTOMERS.CUSTOMER_ID
		and SERVICE_LINE_DATE in (select distinct DATEREPORTRUN from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where DATEREPORTRUN between @begdate and @enddate)	and BILLING_USER_ID=@resid 
*/
	select @unbilledGrandTotal=isnull(@sumBillable,0)+isnull(@sumPooledTotal,0)+isnull(@sumUnbilledOpsInvoices,0)
	if isnull(@salesTotal,0) <> 0 --Ensure there are sales for this time period, and not only unbilled sales to avoid divide by zero error
	begin
		select @DSOTotal=isnull(@unbilledGrandTotal,0)/isnull(@salesTotal,0)
	end
	if @unbilledGrandTotal <> 0 
	begin	
		insert into @tbl values('Projects',999,@name,@unbilledGrandTotal,isnull(@salesTotal,0),isnull(@DSOTotal,0))
	end
	/* clear the variables for the next loop */
	select @name='',@userID=-1,@sumBillable=0,@sumNonBillable=0,@sumPooledTotal=0,@sumUnbilledOpsInvoices=0,
				@salesTotal=0,@unbilledGrandTotal=0,@DSOTotal=0
	FETCH NEXT FROM C_Cursor INTO @name,@userID
end
DEALLOCATE C_Cursor

/*Query for all Unbilled Accounting Items (Pending and Complete)
SELECT sum(iv.custom_line_total) custom_tot, sum(iv.bill_hourly_total) hours_total, sum(iv.bill_exp_total) exp_tot, iv.ext_batch_id, iv.assigned_to_name, iv.job_no, iv.job_id, iv.batch_status_id, ibs.name batch_status_name,
						sum(iv.bill_total + iv.custom_line_total) total_tot, iv.invoice_id_trk, iv.invoice_id, iv.invoice_description, iv.invoice_type_name, iv.invoice_status_id, iv.date_sent, iv.ext_dealer_id, iv.dealer_name, iv.customer_name, iv.invoice_format_type_name, iv.po_no, iv.invoice_date_created
		FROM invoice_pre_total_v iv, invoice_batch_statuses ibs
		WHERE iv.batch_status_id = ibs.status_id
		AND iv.invoice_status_id in (2,3) --Pending and Complete
		GROUP BY iv.invoice_id, iv.invoice_id_trk, iv.invoice_description, iv.invoice_type_name, iv.invoice_status_id, iv.date_sent, iv.ext_dealer_id, iv.dealer_name, iv.customer_name, iv.ext_batch_id, iv.assigned_to_name, iv.invoice_format_type_name, iv.job_no, iv.job_id, iv.po_no, iv.batch_status_id, iv.invoice_date_created, ibs.name
		ORDER BY iv.invoice_id
*/
insert into @tbl select 'Unbilled Accounting',iv.ORGANIZATION_ID,customer_name,sum(iv.bill_total + iv.custom_line_total) total_tot,0,0
		FROM invoice_pre_total_v iv WITH (NOLOCK), invoice_batch_statuses ibs WITH (NOLOCK)
		WHERE iv.batch_status_id = ibs.status_id
		AND iv.invoice_status_id in (2,3) --Pending and Complete
		and iv.ORGANIZATION_ID=@ORG_ID
		GROUP BY iv.invoice_id, iv.invoice_id_trk, iv.invoice_description, iv.invoice_type_name, iv.invoice_status_id, iv.date_sent, iv.ext_dealer_id, iv.dealer_name, iv.customer_name, iv.ext_batch_id, iv.assigned_to_name, iv.invoice_format_type_name, iv.job_no, iv.job_id, iv.po_no, iv.batch_status_id, iv.invoice_date_created, ibs.name, iv.ORGANIZATION_ID
		ORDER BY iv.invoice_id

select  TYPE,b.ORGANIZATION_ID,CUSTOMER_NAME,UnbilledDollars,AvgDaySales,DSO,b.NAME from @tbl a 
INNER JOIN (SELECT ORGANIZATION_ID,NAME FROM ORGANIZATIONS
UNION ALL
SELECT '999', 'PROJECTS') b on a.organization_id=b.organization_id
--select  TYPE,ORGANIZATIONS.ORGANIZATION_ID,CUSTOMER_NAME,UnbilledDollars,AvgDaySales,DSO,NAME from @tbl a
--left outer join ORGANIZATIONS on ORGANIZATIONS.ORGANIZATION_ID=a.ORGANIZATION_ID

--drop table @tbl

endprocess:

--exec sp_CRYSTAL_UNBILLED_REPORT_ICS
GO
/****** Object:  StoredProcedure [dbo].[ottSOPIntegrationPrep]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ottSOPIntegrationPrep] AS

--CREATE HEADER TABLE
if exists(SELECT Name from SYSOBJECTS WHERE NAME='ottInvHeaderTEMP')
	begin
	DROP TABLE ottInvHeaderTEMP
	end

SELECT INVOICES.INVOICE_ID, JOBS_V.JOB_NO, JOBS_V.BILLING_USER_NAME, 
	CAST(INVOICES.INVOICE_ID AS VARCHAR) DOCUMENT_NO, INVOICES.EXT_BATCH_ID,
	UPPER(INVOICES.GP_DESCRIPTION) DESCRIPTION, INVOICES.PO_NO, RTRIM(INVOICES.EXT_BILL_CUST_ID) EXT_BILL_CUST_ID, 
	INVOICES.SALES_REPS, 
	(CASE WHEN JOBS_V.JOB_TYPE_CODE ='service_account' THEN NULL ELSE INVOICES.START_DATE END) start_date, 
	(CASE WHEN JOBS_V.JOB_TYPE_CODE = 'service_account' THEN NULL ELSE INVOICES.END_DATE END) end_date, 
	INVOICE_TYPES_V.NAME, UPPER(JOBS_V.JOB_NAME) JOB_NAME, UPPER(JOBS_V.CUSTOMER_NAME) CUSTOMER_NAME, 
	JOBS_V.JOB_TYPE_CODE,INVOICES.COST_CODES 
INTO ottInvHeaderTEMP
FROM INVOICES, INVOICE_TYPES_V, JOBS_V 
WHERE INVOICES.INVOICE_TYPE_ID = INVOICE_TYPES_V.LOOKUP_ID AND STATUS_ID = 4 AND BATCH_STATUS_ID = 2 
	AND INVOICES.JOB_ID = JOBS_V.JOB_ID and invoices.organization_id=2

--CREATE LINES TABLE
if exists(SELECT Name from SYSOBJECTS WHERE NAME='ottInvLineTEMP')
	begin
	DROP TABLE ottInvLineTEMP
	end

Select INVOICE_LINES_V.INVOICE_ID, INVOICE_LINES_V.UNIT_PRICE, INVOICE_LINES_V.QTY, INVOICE_LINES_V.LINE_DESC, 
	INVOICE_LINES_V.EXT_ITEM_ID 
INTO ottInvLineTEMP
From INVOICE_LINES_V 
INNER JOIN ottInvHeaderTEMP ON ottInvHeaderTEMP.INVOICE_ID = INVOICE_LINES_V.INVOICE_ID
ORDER BY INVOICE_LINES_V.INVOICE_ID

--CREATE TAXES TABLE
if exists(SELECT Name from SYSOBJECTS WHERE NAME='ottInvTaxesTEMP')
	begin
	DROP TABLE ottInvTaxesTEMP
	end

Select Taxes_V_Sum.* 
INTO ottInvTaxesTEMP
From Taxes_V_Sum 
INNER JOIN ottInvHeaderTEMP ON ottInvHeaderTEMP.INVOICE_ID = Taxes_V_Sum.INVOICE_ID
ORDER BY Taxes_V_Sum.INVOICE_ID
GO
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_UNBILLED_REPORT_AIA_DATERANGE]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_CRYSTAL_UNBILLED_REPORT_AIA_DATERANGE]
	@begdate datetime, @enddate datetime
AS
set nocount on

declare @tbl TABLE (
	[TYPE] char(255),
	[ORGANIZATION_ID] [numeric] (19,0),
	[CUSTOMER_NAME] varchar(255) ,
	[UnbilledDollars] [numeric](19, 5) ,
	[AvgDaySales] [numeric](19, 5),
	[DSO] [numeric](19, 5)
) 

/* Find number of days to divide unbilled $'s by.  Always done by 28 day time periods*/
declare @numdays int
select @numdays=0
select @numdays=count(*) from (select distinct DATEREPORTRUN from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
	where DATEREPORTRUN <= @enddate and DATEREPORTRUN >= @begdate) a

/* avoid divide by zero error (no data in dailydatacapture)*/
if @numdays <= 0 goto endprocess

declare @customer varchar(255),
				@ORG_ID numeric(19,0),
				@JOB_NO varchar(255),
				@sumBillable numeric(19,5),
				@sumNonBillable numeric(19,5),
				@sumPooledTotal numeric(19,5),
				@sumUnbilledOpsInvoices numeric(19,5),
				@salesTotal numeric(19,5),
				@unbilledGrandTotal numeric(19,5),
				@DSOTotal numeric(19,5)

select @ORG_ID=8

declare C_Cursor CURSOR for select DISTINCT CUSTOMER_NAME from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK) where ORGANIZATION_ID=@ORG_ID order by CUSTOMER_NAME asc
OPEN C_Cursor
FETCH NEXT FROM C_Cursor INTO @customer
WHILE (@@FETCH_STATUS <> -1)
begin /*Find the totals for this particular customer and organization for this 28 day time period */
	select @sumBillable=sum(billable_total)/@numdays
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where CUSTOMER_NAME=@customer and ORGANIZATION_ID=@ORG_ID and 
		DATEREPORTRUN between @begdate and @enddate 

		select @sumPooledTotal=sum(PooledTotal)/@numdays from
		(select bill_job_id,PooledTotal
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where CUSTOMER_NAME=@customer and ORGANIZATION_ID=@ORG_ID and 
		DATEREPORTRUN between @begdate and @enddate
		GROUP BY BILL_JOB_ID,PooledTotal) a 

		select @sumUnbilledOpsInvoices=sum(UnbilledOpsInvoicesTotal)/@numdays from
		(select bill_job_id,UnbilledOpsInvoicesTotal
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where CUSTOMER_NAME=@customer and ORGANIZATION_ID=@ORG_ID and 
		DATEREPORTRUN between @begdate and @enddate
		GROUP BY BILL_JOB_ID,UnbilledOpsInvoicesTotal) a 

	/*Total sales average for the number of days specified by @numdays */
	select @salesTotal=sum(DOCAMNT)/@numdays from (
	SELECT    ltrim(rtrim(str(INVOICE_ID))) INVOICE_ID,BILL_CUSTOMER_ID,EXT_BILL_CUST_ID,SALES_REPS,EXT_DEALER_ID,EXT_CUSTOMER_ID,CUSTOMER_NAME,a.ORGANIZATION_ID
	FROM         IMS_NEW..INVOICES a LEFT OUTER JOIN CUSTOMERS b on a.BILL_CUSTOMER_ID=b.CUSTOMER_ID
	WHERE a.ORGANIZATION_ID=@ORG_ID and a.STATUS_ID=4
	) a
	INNER JOIN
	(
	select CASE SOPTYPE 
				 WHEN 3 then substring(SOPNUMBE,1,abs(datalength(rtrim(SOPNUMBE))-4)) /*-720,-XXX*/
				 WHEN 4 then substring(SOPNUMBE,1,abs(datalength(rtrim(SOPNUMBE))-2)) /*CR/CM*/
				 ELSE ''
				 END as SERVICE_TRAX_INVOICEID
	,SOPNUMBE,SOPTYPE,CASE SOPTYPE WHEN 3 then DOCAMNT WHEN 4 THEN DOCAMNT * -1 END DOCAMNT,BACHNUMB,CUSTNMBR,CUSTNAME,CSTPONBR 
	from AIA..SOP30200 
	where DOCDATE between @begdate and @enddate 
	) b on b.SERVICE_TRAX_INVOICEID=a.INVOICE_ID where CUSTOMER_NAME=@customer and ORGANIZATION_ID=@ORG_ID
/* This was the old way of calculating avg sales over 28 day period from servicee trax only 
	select @salesTotal=sum(bill_total)/@numdays from service_lines WITH (NOLOCK) inner join jobs WITH (NOLOCK) on jobs.JOB_NO=service_lines.BILL_JOB_NO 
		inner join CUSTOMERS WITH (NOLOCK) on JOBS.CUSTOMER_ID=CUSTOMERS.CUSTOMER_ID and BILLED_FLAG='Y' and SERVICE_LINE_DATE 
		in (select distinct DATEREPORTRUN from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK) 

		where DATEREPORTRUN between @begdate and @enddate) and CUSTOMER_NAME=@customer 
		and service_lines.ORGANIZATION_ID=@ORG_ID
*/
	select @unbilledGrandTotal=isnull(@sumBillable,0)+isnull(@sumPooledTotal,0)+isnull(@sumUnbilledOpsInvoices,0)
	if isnull(@salesTotal,0) <> 0 --Ensure there are sales for this time period, and not only unbilled sales to avoid divide by zero error
	begin
		select @DSOTotal=isnull(@unbilledGrandTotal,0)/isnull(@salesTotal,0)
	end
	insert into @tbl values('Unbilled OPs',@ORG_ID,@customer,@unbilledGrandTotal,isnull(@salesTotal,0),isnull(@DSOTotal,0))
	/* clear the variables for the next loop */
	select @customer='',@JOB_NO='',@sumBillable=0,@sumNonBillable=0,@sumPooledTotal=0,@sumUnbilledOpsInvoices=0,
			@salesTotal=0,@unbilledGrandTotal=0,@DSOTotal=0
	FETCH NEXT FROM C_Cursor INTO @customer
end
DEALLOCATE C_Cursor

declare @name varchar(255),
		@userID int

declare C_Cursor CURSOR for select rtrim(FIRST_NAME) + ' ' + rtrim(LAST_NAME) fullName,USER_ID
 from USERS WITH (NOLOCK) union
	select 'UNKNOWN USER','-999'
OPEN C_Cursor
FETCH NEXT FROM C_Cursor INTO @name,@userID
WHILE (@@FETCH_STATUS <> -1)
begin /*Find the totals for this particular customer and organization for this 28 day time period */
select @sumBillable=sum(billable_total)/@numdays,@sumNonBillable=sum(non_billable_total)/@numdays
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where BILLING_USER_ID=@userID and
		DATEREPORTRUN between @begdate and @enddate and ORGANIZATION_ID=@ORG_ID

		select @sumPooledTotal=sum(PooledTotal)/@numdays from
		(select bill_job_id,PooledTotal
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where BILLING_USER_ID=@userID and
		DATEREPORTRUN between @begdate and @enddate and ORGANIZATION_ID=@ORG_ID
		GROUP BY BILL_JOB_ID,PooledTotal) a 

		select @sumUnbilledOpsInvoices=sum(UnbilledOpsInvoicesTotal)/@numdays from
		(select bill_job_id,UnbilledOpsInvoicesTotal
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where BILLING_USER_ID=@userID and
		DATEREPORTRUN between @begdate and @enddate and ORGANIZATION_ID=@ORG_ID
		GROUP BY BILL_JOB_ID,UnbilledOpsInvoicesTotal) a 

	/*Total sales average for the number of days specified by @numdays for user*/
	select @salesTotal=sum(DOCAMNT)/@numdays from (
	SELECT    ltrim(rtrim(str(a.INVOICE_ID))) INVOICE_ID,BILL_CUSTOMER_ID,EXT_BILL_CUST_ID,SALES_REPS,a.ORGANIZATION_ID,b.BILLING_USER_ID
	FROM         IMS_NEW..INVOICES a left outer join JOBS b on a.JOB_ID=b.JOB_ID
	WHERE a.ORGANIZATION_ID=@ORG_ID and a.STATUS_ID=4 
	) a
	INNER JOIN
	(
	select CASE SOPTYPE 
				 WHEN 3 then substring(SOPNUMBE,1,abs(datalength(rtrim(SOPNUMBE))-4)) /*-720,-XXX*/
				 WHEN 4 then substring(SOPNUMBE,1,abs(datalength(rtrim(SOPNUMBE))-2)) /*CR/CM*/
				 ELSE ''
				 END as SERVICE_TRAX_INVOICEID
	,SOPNUMBE,SOPTYPE,CASE SOPTYPE WHEN 3 then DOCAMNT WHEN 4 THEN DOCAMNT * -1 END DOCAMNT,BACHNUMB,CUSTNMBR,CUSTNAME,CSTPONBR from AIA..SOP30200 
	where DOCDATE between @begdate and @enddate 
	) b on b.SERVICE_TRAX_INVOICEID=a.INVOICE_ID where BILLING_USER_ID=@userID
/* This was the old way of calculating avg sales over 28 day period from service trax only
	select @salesTotal=sum(bill_total)/@numdays from service_lines WITH (NOLOCK) inner join jobs_v WITH (NOLOCK) on jobs_v.JOB_NO=service_lines.BILL_JOB_NO
		inner join CUSTOMERS WITH (NOLOCK) on JOBS_V.CUSTOMER_ID=CUSTOMERS.CUSTOMER_ID
		and SERVICE_LINE_DATE in (select distinct DATEREPORTRUN from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where DATEREPORTRUN between @begdate and @enddate)	and BILLING_USER_ID=@resid 
*/
	select @unbilledGrandTotal=isnull(@sumBillable,0)+isnull(@sumPooledTotal,0)+isnull(@sumUnbilledOpsInvoices,0)
	if isnull(@salesTotal,0) <> 0 --Ensure there are sales for this time period, and not only unbilled sales to avoid divide by zero error
	begin
		select @DSOTotal=isnull(@unbilledGrandTotal,0)/isnull(@salesTotal,0)
	end
	if @unbilledGrandTotal <> 0 
	begin	
		insert into @tbl values('Projects',999,@name,@unbilledGrandTotal,isnull(@salesTotal,0),isnull(@DSOTotal,0))
	end
	/* clear the variables for the next loop */
	select @name='',@userID=-1,@sumBillable=0,@sumNonBillable=0,@sumPooledTotal=0,@sumUnbilledOpsInvoices=0,
				@salesTotal=0,@unbilledGrandTotal=0,@DSOTotal=0
	FETCH NEXT FROM C_Cursor INTO @name,@userID
end
DEALLOCATE C_Cursor

/*Query for all Unbilled Accounting Items (Pending and Complete)
SELECT sum(iv.custom_line_total) custom_tot, sum(iv.bill_hourly_total) hours_total, sum(iv.bill_exp_total) exp_tot, iv.ext_batch_id, iv.assigned_to_name, iv.job_no, iv.job_id, iv.batch_status_id, ibs.name batch_status_name,
						sum(iv.bill_total + iv.custom_line_total) total_tot, iv.invoice_id_trk, iv.invoice_id, iv.invoice_description, iv.invoice_type_name, iv.invoice_status_id, iv.date_sent, iv.ext_dealer_id, iv.dealer_name, iv.customer_name, iv.invoice_format_type_name, iv.po_no, iv.invoice_date_created
		FROM invoice_pre_total_v iv, invoice_batch_statuses ibs
		WHERE iv.batch_status_id = ibs.status_id
		AND iv.invoice_status_id in (2,3) --Pending and Complete
		GROUP BY iv.invoice_id, iv.invoice_id_trk, iv.invoice_description, iv.invoice_type_name, iv.invoice_status_id, iv.date_sent, iv.ext_dealer_id, iv.dealer_name, iv.customer_name, iv.ext_batch_id, iv.assigned_to_name, iv.invoice_format_type_name, iv.job_no, iv.job_id, iv.po_no, iv.batch_status_id, iv.invoice_date_created, ibs.name
		ORDER BY iv.invoice_id
*/
insert into @tbl select 'Unbilled Accounting',iv.ORGANIZATION_ID,customer_name,sum(iv.bill_total + iv.custom_line_total) total_tot,0,0
		FROM invoice_pre_total_v iv WITH (NOLOCK), invoice_batch_statuses ibs WITH (NOLOCK)
		WHERE iv.batch_status_id = ibs.status_id
		AND iv.invoice_status_id in (2,3) --Pending and Complete
		and iv.ORGANIZATION_ID=@ORG_ID
		GROUP BY iv.invoice_id, iv.invoice_id_trk, iv.invoice_description, iv.invoice_type_name, iv.invoice_status_id, iv.date_sent, iv.ext_dealer_id, iv.dealer_name, iv.customer_name, iv.ext_batch_id, iv.assigned_to_name, iv.invoice_format_type_name, iv.job_no, iv.job_id, iv.po_no, iv.batch_status_id, iv.invoice_date_created, ibs.name, iv.ORGANIZATION_ID
		ORDER BY iv.invoice_id

select  TYPE,b.ORGANIZATION_ID,CUSTOMER_NAME,UnbilledDollars,AvgDaySales,DSO,b.NAME from @tbl a 
INNER JOIN (SELECT ORGANIZATION_ID,NAME FROM ORGANIZATIONS
UNION ALL
SELECT '999', 'PROJECTS') b on a.organization_id=b.organization_id
--select  TYPE,ORGANIZATIONS.ORGANIZATION_ID,CUSTOMER_NAME,UnbilledDollars,AvgDaySales,DSO,NAME from @tbl a
--left outer join ORGANIZATIONS on ORGANIZATIONS.ORGANIZATION_ID=a.ORGANIZATION_ID

--drop table @tbl

endprocess:

--exec sp_CRYSTAL_UNBILLED_REPORT_AIA_DATERANGE
GO
/****** Object:  Trigger [upd_invoices]    Script Date: 05/03/2010 14:18:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[upd_invoices] ON [dbo].[INVOICES] 
FOR UPDATE 
AS

DECLARE @invoice_id int
DECLARE @batch_status_id int

/* WHEN INVOICE PROCESSED SUCCESSFULLY TO GREAT PLAINS, THEN UPDATE THE ASSIGNED SERVICE LINES TO POSTED STATUS */
if( update(batch_status_id) )
begin
	UPDATE service_lines 
	SET status_id = 5 
	WHERE status_id = 4 AND invoice_id in (
		SELECT invoice_id FROM inserted WHERE batch_status_id = 3)
end
GO
/****** Object:  Trigger [ins_cust_bill_id]    Script Date: 05/03/2010 14:18:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[ins_cust_bill_id] ON [dbo].[INVOICES] 
FOR INSERT
AS

  DECLARE @customer_id varchar(15)
  DECLARE @invoice_id int
  DECLARE @job_id int

  SELECT @invoice_id = invoice_id,
	   @job_id = job_id
     FROM  Inserted

  SELECT @customer_id = customer_id
     FROM jobs
  WHERE job_id = @job_id

  UPDATE invoices
         SET bill_customer_id = @customer_id
   WHERE invoice_id = @invoice_id
GO
/****** Object:  Trigger [del_unassign_lines]    Script Date: 05/03/2010 14:18:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[del_unassign_lines] ON [dbo].[INVOICES] 
 instead of DELETE 
AS
  UPDATE service_lines
         SET status_id = 4, 
	    invoice_id = null
   WHERE invoice_id in (select invoice_id from deleted)

  DELETE FROM invoice_tracking WHERE invoice_id in (select invoice_id from deleted)

  DELETE FROM INVOICES WHERE INVOICE_ID IN (SELECT INVOICE_ID FROM DELETED)
GO
/****** Object:  StoredProcedure [dbo].[ottSOPIntegrationPrepAll]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ottSOPIntegrationPrepAll]
	@OrganizationID numeric(18,0)
AS
SET NOCOUNT ON


--DELETE ALL PREVIOUS INTEGRATION DATA
DELETE FROM ottInvHeaderTEMP_ALL WHERE organization_id=@OrganizationID
DELETE FROM ottInvLineTEMP_ALL WHERE organization_id=@OrganizationID
--DELETE FROM ottInvTaxesTEMP_ALL WHERE organization_id=@OrganizationID


--BUILD THE HEADER TABLE
INSERT INTO ottInvHeaderTEMP_ALL
	(organization_id, INVOICE_ID, JOB_NO, BILLING_USER_NAME, DOCUMENT_NO, EXT_BATCH_ID, DESCRIPTION, PO_NO, EXT_BILL_CUST_ID, 
                      SALES_REPS, start_date, end_date, NAME, JOB_NAME, CUSTOMER_NAME, JOB_TYPE_CODE, COST_CODES)
SELECT @OrganizationID as organization_id, INVOICES.INVOICE_ID, JOBS_V.JOB_NO, JOBS_V.BILLING_USER_NAME, 
	CAST(INVOICES.INVOICE_ID AS VARCHAR) DOCUMENT_NO, INVOICES.EXT_BATCH_ID,
	UPPER(INVOICES.GP_DESCRIPTION) DESCRIPTION, INVOICES.PO_NO, RTRIM(INVOICES.EXT_BILL_CUST_ID) EXT_BILL_CUST_ID, 
	INVOICES.SALES_REPS, 
	(CASE WHEN JOBS_V.JOB_TYPE_CODE ='service_account' THEN NULL ELSE INVOICES.START_DATE END) start_date, 
	(CASE WHEN JOBS_V.JOB_TYPE_CODE = 'service_account' THEN NULL ELSE INVOICES.END_DATE END) end_date, 
	INVOICE_TYPES_V.NAME, UPPER(JOBS_V.JOB_NAME) JOB_NAME, UPPER(JOBS_V.CUSTOMER_NAME) CUSTOMER_NAME, 
	JOBS_V.JOB_TYPE_CODE,INVOICES.COST_CODES 
FROM INVOICES, INVOICE_TYPES_V, JOBS_V 
WHERE INVOICES.INVOICE_TYPE_ID = INVOICE_TYPES_V.LOOKUP_ID AND STATUS_ID = 4 AND BATCH_STATUS_ID = 2 
	AND INVOICES.JOB_ID = JOBS_V.JOB_ID and invoices.organization_id=@OrganizationID


--BUILD THE LINES TABLE
INSERT INTO ottInvLineTEMP_ALL
	(organization_id, INVOICE_LINE_ID, INVOICE_ID, UNIT_PRICE, QTY, LINE_DESC, EXT_ITEM_ID)
Select @OrganizationID as organization_id, INVOICE_LINES_V.INVOICE_LINE_ID, INVOICE_LINES_V.INVOICE_ID, INVOICE_LINES_V.UNIT_PRICE, INVOICE_LINES_V.QTY, INVOICE_LINES_V.LINE_DESC, 
	INVOICE_LINES_V.EXT_ITEM_ID 
From INVOICE_LINES_V 
INNER JOIN ottInvHeaderTEMP_ALL ON ottInvHeaderTEMP_ALL.INVOICE_ID = INVOICE_LINES_V.INVOICE_ID
ORDER BY INVOICE_LINES_V.INVOICE_ID

/*  MAY BE UNNECESSARY - JERRY TO RESPOND
--BUILD TAXES TABLE
INSERT INTO ottInvTaxesTEMP_ALL
	(organization_id, INVOICE_ID, Total_tax)
Select @OrganizationID as organization_id, Taxes_V_Sum.INVOICE_ID,  Taxes_V_Sum.Total_tax
From Taxes_V_Sum 
INNER JOIN ottInvHeaderTEMP_ALL ON ottInvHeaderTEMP_ALL.INVOICE_ID = Taxes_V_Sum.INVOICE_ID

*/
SET NOCOUNT OFF
GO
/****** Object:  Trigger [ins_services]    Script Date: 05/03/2010 14:18:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[ins_services] ON [dbo].[SERVICES] 
FOR INSERT
AS

UPDATE    SERVICES
SET             
QUOTE_TOTAL = ISNULL
                          ((SELECT     dbo.QUOTES.QUOTE_TOTAL
                              FROM         inserted LEFT OUTER JOIN
                                                    dbo.REQUESTS ON inserted.REQUEST_ID = dbo.REQUESTS.REQUEST_ID LEFT OUTER JOIN
                                                    dbo.QUOTES ON dbo.REQUESTS.QUOTE_REQUEST_ID = dbo.QUOTES.REQUEST_ID
                              WHERE     SERVICES.service_id = inserted.service_id), 0),
QUOTE_ID = (SELECT     dbo.QUOTES.QUOTE_ID
                              FROM         inserted LEFT OUTER JOIN
                                                    dbo.REQUESTS ON inserted.REQUEST_ID = dbo.REQUESTS.REQUEST_ID LEFT OUTER JOIN
                                                    dbo.QUOTES ON dbo.REQUESTS.QUOTE_REQUEST_ID = dbo.QUOTES.REQUEST_ID
                              WHERE     SERVICES.service_id = inserted.service_id)
WHERE     (SERVICE_ID IN  (SELECT service_id FROM inserted))
GO
/****** Object:  StoredProcedure [dbo].[sp_reorder_service_no]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_reorder_service_no]
AS
BEGIN

DECLARE @request_no numeric(18,0)
DECLARE @service_id numeric(18,0)
DECLARE @req CURSOR

SET @req = CURSOR FAST_FORWARD
FOR
SELECT s.service_id, r.request_no
  FROM services s INNER JOIN
       jobs j ON s.job_id = j.job_id RIGHT OUTER JOIN
       requests r ON s.request_id = r.request_id
WHERE j.project_id = 65757
  AND r.request_no > 58
  and s.service_no > 300
  AND s.service_no <> r.request_no
ORDER BY s.service_no


OPEN @req
FETCH NEXT FROM @req INTO @service_id,@request_no

WHILE @@FETCH_STATUS=0
BEGIN
  PRINT @service_id
  
  UPDATE services
     SET service_no = @request_no,
         date_modified=getdate(),
         modified_by=1
   WHERE service_id = @service_id
     AND service_no <>  @request_no
                             
  FETCH NEXT FROM @req INTO @service_id,@request_no
END

CLOSE @req
DEALLOCATE @req

END
GO
/****** Object:  StoredProcedure [dbo].[sp_reorder_req_no2]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_reorder_req_no2]
AS
BEGIN

DECLARE @request_id numeric(18,0)
DECLARE @service_no numeric(18,0)
DECLARE @req CURSOR

SET @req = CURSOR FAST_FORWARD
FOR
SELECT s.request_id,s.service_no
  FROM services s INNER JOIN
       jobs j ON s.job_id = j.job_id
 WHERE j.project_id=65757
   AND s.service_no > 58
ORDER BY s.service_no


OPEN @req
FETCH NEXT FROM @req INTO @request_id,@service_no

WHILE @@FETCH_STATUS=0
BEGIN
  PRINT @request_id
  
  UPDATE requests
     SET request_no = @service_no,
         date_modified=getdate(),
         modified_by=1
   WHERE request_id = @request_id
     AND request_no <>  @service_no
                             
  FETCH NEXT FROM @req INTO @request_id,@service_no
END

CLOSE @req
DEALLOCATE @req

END
GO
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_UNBILLED_DASHBOARD_DSO]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
create TABLE #tbl(
	[TYPE] char(255),
	[ORGANIZATION_ID] [numeric] (19,0),
	[CUSTOMER_NAME] varchar(255) ,
	[UnbilledDollars] [numeric](19, 5) ,
	[AvgDaySales] [numeric](19, 5),
	[DSO] [numeric](19, 5)
) 

exec sp_CRYSTAL_UNBILLED_DASHBOARD_DSO '#tbl','AMBIM'
select * from #tbl
delete #tbl
delete #tbl where DSO=0
drop table #temptbl
select sum(UnbilledDollars)/sum(AvgDaySales) from #tbl
select avg(dso) from #tbl
*/

CREATE PROCEDURE [dbo].[sp_CRYSTAL_UNBILLED_DASHBOARD_DSO]
	@sqlTempTable as char(50),
	@COMPANY_INTERID as char(5)
AS
set nocount on

/* Find number of days to divide unbilled $'s by.  Always done by 28 day time periods
   numdays is calculated as a failsafe if daily data capture missed a day, therefore the count
   would not include that day
*/
declare @numdays int, @begdate datetime, @enddate datetime
select @numdays=0
select @begdate = CAST(FLOOR(CAST(getdate()-28 AS FLOAT))AS DATETIME)
select @enddate = CAST(FLOOR(CAST(getdate()-1 AS FLOAT))AS DATETIME)
select @numdays=count(*) from (select distinct DATEREPORTRUN from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
	where DATEREPORTRUN <= @enddate and DATEREPORTRUN >= @begdate) a

create table #temptbl(
	sumOfSales numeric(19,5)
)

/* avoid divide by zero error (no data in dailydatacapture)*/
if @numdays <= 0 goto endprocess

declare @customer varchar(255),
				@ORG_ID numeric(19,0),
				@JOB_NO varchar(255),
				@sumBillable numeric(19,5),
				@sumNonBillable numeric(19,5),
				@sumPooledTotal numeric(19,5),
				@sumUnbilledOpsInvoices numeric(19,5),
				@salesTotal numeric(19,5),
				@unbilledGrandTotal numeric(19,5),
				@DSOTotal numeric(19,5),
				@sqlInsertStmt char(4000),
				@sqlSalesStmt char(2000)

select @ORG_ID=ORGANIZATION_ID from
IMS_NEW..ORGANIZATIONS where DB_PREFIX like rtrim(@COMPANY_INTERID)+'%'

declare C_Cursor CURSOR for select DISTINCT CUSTOMER_NAME from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK) where ORGANIZATION_ID=@ORG_ID order by CUSTOMER_NAME asc
OPEN C_Cursor
FETCH NEXT FROM C_Cursor INTO @customer
WHILE (@@FETCH_STATUS <> -1)
begin /*Find the totals for this particular customer and organization for this 28 day time period */
	select @sumBillable=sum(billable_total)/@numdays,@sumNonBillable=sum(non_billable_total)/@numdays
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where CUSTOMER_NAME=@customer and ORGANIZATION_ID=@ORG_ID and 
		DATEREPORTRUN between @begdate and @enddate 

		select @sumPooledTotal=sum(PooledTotal)/@numdays from
		(select bill_job_id,PooledTotal
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where CUSTOMER_NAME=@customer and ORGANIZATION_ID=@ORG_ID and 
		DATEREPORTRUN between @begdate and @enddate
		GROUP BY BILL_JOB_ID,PooledTotal) a 

		select @sumUnbilledOpsInvoices=sum(UnbilledOpsInvoicesTotal)/@numdays from
		(select bill_job_id,UnbilledOpsInvoicesTotal
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where CUSTOMER_NAME=@customer and ORGANIZATION_ID=@ORG_ID and 
		DATEREPORTRUN between @begdate and @enddate
		GROUP BY BILL_JOB_ID,UnbilledOpsInvoicesTotal) a 

	/*Total sales average for the number of days specified by @numdays */
	select @sqlSalesStmt = 'insert into #temptbl (sumOfSales) select sum(DOCAMNT)/'+cast(@numdays as varchar(10)) + ' from (
	SELECT    ltrim(rtrim(str(INVOICE_ID))) INVOICE_ID,BILL_CUSTOMER_ID,EXT_BILL_CUST_ID,SALES_REPS,EXT_DEALER_ID,EXT_CUSTOMER_ID,CUSTOMER_NAME,a.ORGANIZATION_ID
	FROM         IMS_NEW..INVOICES a LEFT OUTER JOIN CUSTOMERS b on a.BILL_CUSTOMER_ID=b.CUSTOMER_ID
	WHERE a.ORGANIZATION_ID='+rtrim(cast(@ORG_ID as varchar(2))) + ' and a.STATUS_ID=4) a INNER JOIN (	select case 
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),1) = ''-'' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-1)) /* -XXX*/
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),2) = ''-0'' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-2)) /* -0XXX*/
	WHEN right(rtrim(SERVICE_TRAX_INVOICEID),4) = ''CM-0'' THEN substring(SERVICE_TRAX_INVOICEID,1,abs(datalength(rtrim(SERVICE_TRAX_INVOICEID))-4)) /* CM-0XXX */
	ELSE SERVICE_TRAX_INVOICEID /* INV suffix */
	END as SERVICE_TRAX_INVOICEID
	,SOPNUMBE,SOPTYPE,DOCAMNT,BACHNUMB,CUSTNMBR,CUSTNAME,CSTPONBR from (
	select CASE SOPTYPE 
				 WHEN 3 then substring(SOPNUMBE,1,abs(datalength(rtrim(SOPNUMBE))-3)) /*720,XXX*/
				 WHEN 4 then substring(SOPNUMBE,1,abs(datalength(rtrim(SOPNUMBE))-6)) /*CR-XXX,CM-XXX*/
				 ELSE ''''
				 END as SERVICE_TRAX_INVOICEID
	,SOPNUMBE,SOPTYPE,CASE SOPTYPE WHEN 3 then DOCAMNT WHEN 4 THEN DOCAMNT * -1 END DOCAMNT,BACHNUMB,CUSTNMBR,CUSTNAME,CSTPONBR 
	from '+rtrim(@COMPANY_INTERID)+'..SOP30200 
	where DOCDATE between ''' + cast(@begdate as varchar(50)) + ''' and ''' + cast(@enddate as varchar(50)) +
	''') x ) b on b.SERVICE_TRAX_INVOICEID=a.INVOICE_ID where CUSTOMER_NAME=''' + replace(rtrim(@customer),'''','''''') + ''' and ORGANIZATION_ID=''' + rtrim(cast(@ORG_ID as varchar(2))) + ''''

	exec (@sqlSalesStmt)
	--print @sqlSalesStmt
	select @salesTotal=sum(isnull(sumOfSales,0)) from #temptbl
	delete #temptbl
	select @unbilledGrandTotal=isnull(@sumBillable,0)+isnull(@sumPooledTotal,0)+isnull(@sumUnbilledOpsInvoices,0)
	if isnull(@salesTotal,0) <> 0 --Ensure there are sales for this time period, and not only unbilled sales to avoid divide by zero error
	begin
		select @DSOTotal=isnull(@unbilledGrandTotal,0)/isnull(@salesTotal,0)
	end
	set @sqlInsertStmt='insert into ' +rtrim(@sqlTempTable) + ' values(''Unbilled OPs'','''
			+rtrim(cast(@ORG_ID as char(2)))+''','''+replace(rtrim(@customer),'''','''''')+''','''+cast(@unbilledGrandTotal as varchar(255))+''','''+cast(isnull(@salesTotal,0) as varchar(255))+''','''+cast(isnull(@DSOTotal,0) as varchar(255)) +''')'
	--print @sqlInsertStmt
	exec (@sqlInsertStmt)
	/* clear the variables for the next loop */
	select @customer='',@JOB_NO='',@sumBillable=0,@sumNonBillable=0,@sumPooledTotal=0,@sumUnbilledOpsInvoices=0,
			@salesTotal=0,@unbilledGrandTotal=0,@DSOTotal=0,@sqlSalesStmt=''
	FETCH NEXT FROM C_Cursor INTO @customer
end
DEALLOCATE C_Cursor

--select  TYPE,ORGANIZATIONS.ORGANIZATION_ID,CUSTOMER_NAME,UnbilledDollars,AvgDaySales,DSO,NAME from @tbl a
--left outer join ORGANIZATIONS on ORGANIZATIONS.ORGANIZATION_ID=a.ORGANIZATION_ID

drop table #temptbl

endprocess:

--exec sp_CRYSTAL_UNBILLED_DASHBOARD_DSO
GO
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_UNBILLED_REPORT]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_CRYSTAL_UNBILLED_REPORT]
AS
set nocount on

declare @tbl TABLE (
	[TYPE] char(255),
	[ORGANIZATION_ID] [numeric] (19,0),
	[CUSTOMER_NAME] varchar(255) ,
	[UnbilledDollars] [numeric](19, 5) ,
	[AvgDaySales] [numeric](19, 5),
	[DSO] [numeric](19, 5)
) 

/* Find number of days to divide unbilled $'s by.  Always done by 28 day time periods*/
declare @numdays int, @begdate datetime, @enddate datetime
select @numdays=0
select @numdays=count(*) from (select distinct DATEREPORTRUN from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK) 
	where DATEREPORTRUN <= getdate() and DATEREPORTRUN >= getdate()-27) a
select @begdate = CAST(FLOOR(CAST(getdate()-@numdays AS FLOAT))AS DATETIME)
select @enddate = CAST(FLOOR(CAST(getdate() AS FLOAT))AS DATETIME)

/* avoid divide by zero error (no data in dailydatacapture)*/
if @numdays <= 0 goto endprocess

declare @customer varchar(255),
				@ORG_ID numeric(19,0),
				@JOB_NO varchar(255),
				@sumBillable numeric(19,5),
				@sumNonBillable numeric(19,5),
				@sumPooledTotal numeric(19,5),
				@sumUnbilledOpsInvoices numeric(19,5),
				@salesTotal numeric(19,5),
				@unbilledGrandTotal numeric(19,5),
				@DSOTotal numeric(19,5)

declare C_Cursor CURSOR for select DISTINCT CUSTOMER_NAME,ORGANIZATION_ID from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK) order by CUSTOMER_NAME asc
OPEN C_Cursor
FETCH NEXT FROM C_Cursor INTO @customer,@ORG_ID
WHILE (@@FETCH_STATUS <> -1)
begin /*Find the totals for this particular customer and organization for this 28 day time period */
	select @sumBillable=sum(billable_total)/@numdays,@sumNonBillable=sum(non_billable_total)/@numdays,
	  @sumPooledTotal=sum(PooledTotal)/@numdays,@sumUnbilledOpsInvoices=sum(UnbilledOpsInvoicesTotal)/@numdays
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where CUSTOMER_NAME=@customer and ORGANIZATION_ID=@ORG_ID and 
		DATEREPORTRUN between @begdate and @enddate

	/*Total sales average for the number of days specified by @numdays */
	select @salesTotal=sum(bill_total)/@numdays from service_lines WITH (NOLOCK) inner join jobs WITH (NOLOCK) on jobs.JOB_NO=service_lines.BILL_JOB_NO 
		inner join CUSTOMERS WITH (NOLOCK) on JOBS.CUSTOMER_ID=CUSTOMERS.CUSTOMER_ID and BILLED_FLAG='Y' and SERVICE_LINE_DATE 
		in (select distinct DATEREPORTRUN from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK) 
		where DATEREPORTRUN between @begdate and @enddate) and CUSTOMER_NAME=@customer 
		and service_lines.ORGANIZATION_ID=@ORG_ID
	select @unbilledGrandTotal=isnull(@sumBillable,0)-isnull(@sumNonBillable,0)+isnull(@sumPooledTotal,0)+isnull(@sumUnbilledOpsInvoices,0)
	if isnull(@salesTotal,0) <> 0 --Ensure there are sales for this time period, and not only unbilled sales to avoid divide by zero error
	begin
		select @DSOTotal=isnull(@unbilledGrandTotal,0)/isnull(@salesTotal,0)
	end
	insert into @tbl values('Unbilled OPs',@ORG_ID,@customer,@unbilledGrandTotal,isnull(@salesTotal,0),isnull(@DSOTotal,0))
	/* clear the variables for the next loop */
	select @customer='',@ORG_ID=0,@JOB_NO='',@sumBillable=0,@sumNonBillable=0,@sumPooledTotal=0,@sumUnbilledOpsInvoices=0,
			@salesTotal=0,@unbilledGrandTotal=0,@DSOTotal=0
	FETCH NEXT FROM C_Cursor INTO @customer,@ORG_ID
end
DEALLOCATE C_Cursor

declare @resource varchar(255),
		@resid int
declare C_Cursor CURSOR for select NAME,RESOURCE_ID from RESOURCES WITH (NOLOCK) where RESOURCE_ID in (14,1391,105,636,124,158,161,957)
OPEN C_Cursor
FETCH NEXT FROM C_Cursor INTO @resource,@resid
WHILE (@@FETCH_STATUS <> -1)
begin /*Find the totals for this particular customer and organization for this 28 day time period */
select @sumBillable=sum(billable_total)/@numdays,@sumNonBillable=sum(non_billable_total)/@numdays,
	  @sumPooledTotal=sum(PooledTotal)/@numdays,@sumUnbilledOpsInvoices=sum(UnbilledOpsInvoicesTotal)/@numdays
	  from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where job_owner=@resource and
		DATEREPORTRUN between @begdate and @enddate

	/*Total sales average for the number of days specified by @numdays for user*/
	select @salesTotal=sum(bill_total)/@numdays from service_lines WITH (NOLOCK) inner join jobs_v WITH (NOLOCK) on jobs_v.JOB_NO=service_lines.BILL_JOB_NO
		inner join CUSTOMERS WITH (NOLOCK) on JOBS_V.CUSTOMER_ID=CUSTOMERS.CUSTOMER_ID
		and SERVICE_LINE_DATE in (select distinct DATEREPORTRUN from UNBILLED_REPORT_DAILYDATACAPTURE WITH (NOLOCK)
		where DATEREPORTRUN between @begdate and @enddate)	and BILLING_USER_ID=@resid 
	select @unbilledGrandTotal=isnull(@sumBillable,0)-isnull(@sumNonBillable,0)+isnull(@sumPooledTotal,0)+isnull(@sumUnbilledOpsInvoices,0)
	if isnull(@salesTotal,0) <> 0 --Ensure there are sales for this time period, and not only unbilled sales to avoid divide by zero error
	begin
		select @DSOTotal=isnull(@unbilledGrandTotal,0)/isnull(@salesTotal,0)
	end
	insert into @tbl values('Projects',999,@resource,@unbilledGrandTotal,isnull(@salesTotal,0),isnull(@DSOTotal,0))
	/* clear the variables for the next loop */
	select @resource='',@resid=0,@sumBillable=0,@sumNonBillable=0,@sumPooledTotal=0,@sumUnbilledOpsInvoices=0,
				@salesTotal=0,@unbilledGrandTotal=0,@DSOTotal=0
	FETCH NEXT FROM C_Cursor INTO @resource,@resid
end
DEALLOCATE C_Cursor

/*Query for all Unbilled Accounting Items (Pending and Complete)
SELECT sum(iv.custom_line_total) custom_tot, sum(iv.bill_hourly_total) hours_total, sum(iv.bill_exp_total) exp_tot, iv.ext_batch_id, iv.assigned_to_name, iv.job_no, iv.job_id, iv.batch_status_id, ibs.name batch_status_name,
						sum(iv.bill_total + iv.custom_line_total) total_tot, iv.invoice_id_trk, iv.invoice_id, iv.invoice_description, iv.invoice_type_name, iv.invoice_status_id, iv.date_sent, iv.ext_dealer_id, iv.dealer_name, iv.customer_name, iv.invoice_format_type_name, iv.po_no, iv.invoice_date_created
		FROM invoice_pre_total_v iv, invoice_batch_statuses ibs
		WHERE iv.batch_status_id = ibs.status_id
		AND iv.invoice_status_id in (2,3) --Pending and Complete
		GROUP BY iv.invoice_id, iv.invoice_id_trk, iv.invoice_description, iv.invoice_type_name, iv.invoice_status_id, iv.date_sent, iv.ext_dealer_id, iv.dealer_name, iv.customer_name, iv.ext_batch_id, iv.assigned_to_name, iv.invoice_format_type_name, iv.job_no, iv.job_id, iv.po_no, iv.batch_status_id, iv.invoice_date_created, ibs.name
		ORDER BY iv.invoice_id
*/
insert into @tbl select 'Unbilled Accounting',iv.ORGANIZATION_ID,customer_name,sum(iv.bill_total + iv.custom_line_total) total_tot,0,0
		FROM invoice_pre_total_v iv WITH (NOLOCK), invoice_batch_statuses ibs WITH (NOLOCK)
		WHERE iv.batch_status_id = ibs.status_id
		AND iv.invoice_status_id in (2,3) --Pending and Complete
		GROUP BY iv.invoice_id, iv.invoice_id_trk, iv.invoice_description, iv.invoice_type_name, iv.invoice_status_id, iv.date_sent, iv.ext_dealer_id, iv.dealer_name, iv.customer_name, iv.ext_batch_id, iv.assigned_to_name, iv.invoice_format_type_name, iv.job_no, iv.job_id, iv.po_no, iv.batch_status_id, iv.invoice_date_created, ibs.name, iv.ORGANIZATION_ID
		ORDER BY iv.invoice_id

select  TYPE,b.ORGANIZATION_ID,CUSTOMER_NAME,UnbilledDollars,AvgDaySales,DSO,b.NAME from @tbl a 
INNER JOIN (SELECT ORGANIZATION_ID,NAME FROM ORGANIZATIONS
UNION ALL
SELECT '999', 'PROJECTS') b on a.organization_id=b.organization_id
--select  TYPE,ORGANIZATIONS.ORGANIZATION_ID,CUSTOMER_NAME,UnbilledDollars,AvgDaySales,DSO,NAME from @tbl a
--left outer join ORGANIZATIONS on ORGANIZATIONS.ORGANIZATION_ID=a.ORGANIZATION_ID

--drop table @tbl

endprocess:

--exec sp_CRYSTAL_UNBILLED_REPORT
GO
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_UNBILLED_REPORT_DAILYDATACAPTURE]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_CRYSTAL_UNBILLED_REPORT_DAILYDATACAPTURE]
	@datestamp as smalldatetime
AS
set nocount on
set ansi_warnings off
create table #tbl(
	[ORGANIZATION_ID] [numeric] (19,0),
	[BILL_JOB_NO] [numeric] (19,0) ,
	[BILL_JOB_ID] [numeric] (19,0) ,
	[job_status_type_name] varchar(255) ,
	[job_name] varchar(255) ,
	[BILLING_USER_ID] [numeric](19, 5),
	[EXT_DEALER_ID] char(255) ,
	[DEALER_NAME] varchar(255) ,
	[CUSTOMER_NAME] varchar(255) ,
	[job_owner] varchar(500) ,
	[billable_total] [numeric](19, 5) ,
	[non_billable_total] [numeric](19, 5),
	[PO_NO] varchar(100),
	[PooledTotal] [numeric](19, 5),
	[UnbilledOpsInvoicesTotal] numeric(19,5)

) 

create table #tbl2(
	tc_job_no numeric(19,0),
	pooledSum numeric(19,5)	
)

create table #tbl3(
	tc_job_no numeric(19,0),
	unbilledOpsInvoicesSum numeric(19,5)	
)

create table #tbl4(
	tc_job_no numeric(19,0),
	totalUnbilledInvoices numeric(19,5)	
)

/*Pooled Totals*/
insert into #tbl2
select distinct tc_job_no, (select sum(sum_bill_total) from jobs_not_billed_v
		   	WHERE 	internal_req_flag like 'Y'
				AND fully_allocated_flag like 'N' and tc_job_no=t1.tc_job_no) pooledSum
				from jobs_not_billed_v t1
		   	WHERE 	internal_req_flag like 'Y'
				AND fully_allocated_flag like 'N' 
	group by tc_job_no, sum_bill_total

/*Unbilled Ops - Invoices (ready to be sent to GP)*/
insert into #tbl4
SELECT job_no, sum(bill_total + custom_line_total) total_total
	FROM invoice_pre_total_v
	WHERE invoice_status_id =1 
	GROUP BY invoice_id, invoice_id_trk, invoice_description, invoice_type_name, invoice_status_id, ext_dealer_id, dealer_name,  customer_name, job_id, po_no, billing_user_name, job_no
	ORDER BY invoice_id

/*Unbilled Ops - Invoices DISTINCT Records (Grand Totals) */
insert into #tbl3
select distinct tc_job_no, (select sum(totalUnbilledInvoices) from #tbl4 where tc_job_no=t1.tc_job_no)
from #tbl4 t1

insert into #tbl 
select dbo.BILLING_V_DAILYREPORTCAPTURE.ORGANIZATION_ID, dbo.BILLING_V_DAILYREPORTCAPTURE.BILL_JOB_NO, dbo.BILLING_V_DAILYREPORTCAPTURE.BILL_JOB_ID, dbo.BILLING_V_DAILYREPORTCAPTURE.job_status_type_name, 
                      dbo.BILLING_V_DAILYREPORTCAPTURE.job_name, dbo.BILLING_V_DAILYREPORTCAPTURE.BILLING_USER_ID, dbo.BILLING_V_DAILYREPORTCAPTURE.EXT_DEALER_ID, dbo.BILLING_V_DAILYREPORTCAPTURE.DEALER_NAME, 
                      dbo.BILLING_V_DAILYREPORTCAPTURE.CUSTOMER_NAME, cast(dbo.BILLING_V_DAILYREPORTCAPTURE.billing_user_name AS varchar) AS job_owner, 
                      SUM(CASE BILLING_V_DAILYREPORTCAPTURE.billable_flag WHEN 'Y' THEN bill_total ELSE 0 END) billable_total, SUM(CASE BILLING_V_DAILYREPORTCAPTURE.billable_flag WHEN 'N' THEN bill_total ELSE 0 END)
                      non_billable_total, dbo.BILLING_V_DAILYREPORTCAPTURE.PO_NO,isnull(pooledSum,0),isnull(unbilledOpsInvoicesSum,0)
FROM         dbo.BILLING_V_DAILYREPORTCAPTURE 
				left outer join #tbl2 on #tbl2.tc_job_no=BILLING_V_DAILYREPORTCAPTURE.BILL_JOB_NO
				left outer join #tbl3 on #tbl3.tc_job_no=BILLING_V_DAILYREPORTCAPTURE.BILL_JOB_NO
WHERE     (dbo.BILLING_V_DAILYREPORTCAPTURE.invoice_status_id = 1 OR
                      dbo.BILLING_V_DAILYREPORTCAPTURE.invoice_status_id IS NULL) AND status_id = 4 
GROUP BY dbo.BILLING_V_DAILYREPORTCAPTURE.ORGANIZATION_ID, dbo.BILLING_V_DAILYREPORTCAPTURE.BILL_JOB_ID, dbo.BILLING_V_DAILYREPORTCAPTURE.BILL_JOB_NO, dbo.BILLING_V_DAILYREPORTCAPTURE.BILLING_USER_ID, 
                      dbo.BILLING_V_DAILYREPORTCAPTURE.DEALER_NAME, dbo.BILLING_V_DAILYREPORTCAPTURE.EXT_DEALER_ID, dbo.BILLING_V_DAILYREPORTCAPTURE.CUSTOMER_NAME, dbo.BILLING_V_DAILYREPORTCAPTURE.billing_user_name, 
                      dbo.BILLING_V_DAILYREPORTCAPTURE.job_status_type_name, dbo.BILLING_V_DAILYREPORTCAPTURE.job_name, dbo.BILLING_V_DAILYREPORTCAPTURE.PO_NO,pooledSum,unbilledOpsInvoicesSum

/* Account for unbilled ops invoices that are not in service lines table */
insert into #tbl
SELECT     ORGANIZATION_ID, JOB_NO, JOB_ID,job_status_type_name,JOB_NAME, BILLING_USER_ID, EXT_DEALER_ID, DEALER_NAME, CUSTOMER_NAME, 
                      job_owner,  
                      SUM(CASE status_id WHEN 2 THEN EXTENDED_PRICE WHEN 3 THEN EXTENDED_PRICE ELSE 0 END) AS BILLABLE_TOTAL,0 as non_billable_total,PO_NO,pooledSum,unbilledOpsInvoicesSum
FROM         (SELECT     JOBS_V.ORGANIZATION_ID, JOBS_V.JOB_NO, JOBS_V.JOB_ID, JOBS_V.job_status_type_name, JOBS_V.JOB_NAME, 
                                              JOBS_V.BILLING_USER_ID, JOBS_V.EXT_DEALER_ID, JOBS_V.DEALER_NAME, JOBS_V.CUSTOMER_NAME, 
                                              JOBS_V.billing_user_name AS job_owner, INVOICE_LINES.PO_NO, 
                                              INVOICES.STATUS_ID, INVOICE_LINES.EXTENDED_PRICE,isnull(pooledSum,0) pooledSum,isnull(unbilledOpsInvoicesSum,0) unbilledOpsInvoicesSum
                       FROM          INVOICE_LINES INNER JOIN
                                              INVOICES ON INVOICE_LINES.INVOICE_ID = INVOICES.INVOICE_ID RIGHT OUTER JOIN
                                              JOBS_V ON INVOICES.JOB_ID = JOBS_V.JOB_ID
																							left outer join #tbl2 on #tbl2.tc_job_no=jobs_v.job_no
																		  				left outer join #tbl3 on #tbl3.tc_job_no=jobs_v.job_no
						GROUP BY JOBS_V.ORGANIZATION_ID, JOBS_V.JOB_NO, JOBS_V.JOB_ID, JOBS_V.job_status_type_name, JOBS_V.JOB_NAME, JOBS_V.BILLING_USER_ID, 
                      JOBS_V.EXT_DEALER_ID, JOBS_V.DEALER_NAME, JOBS_V.CUSTOMER_NAME, JOBS_V.billing_user_name, INVOICES.STATUS_ID, 
                      INVOICE_LINES.EXTENDED_PRICE, INVOICE_LINES.PO_NO,pooledSum,unbilledOpsInvoicesSum
                       HAVING      (JOBS_V.JOB_NO in (select tc_job_no from #tbl3)) AND (INVOICES.STATUS_ID IN (1, 2, 3))) a
where JOB_NO not in (select bill_job_no from #tbl)
GROUP BY ORGANIZATION_ID, JOB_NO, job_status_type_name, JOB_ID, JOB_NAME, BILLING_USER_ID, EXT_DEALER_ID, DEALER_NAME, 
                      CUSTOMER_NAME, job_owner, PO_NO,pooledSum,unbilledOpsInvoicesSum

INSERT INTO UNBILLED_REPORT_DAILYDATACAPTURE
select 	#tbl.[ORGANIZATION_ID],
	[BILL_JOB_NO] ,
	[BILL_JOB_ID] ,
	[job_status_type_name],
	[job_name] ,
	[BILLING_USER_ID],
	[EXT_DEALER_ID] ,
	[DEALER_NAME] ,
	[CUSTOMER_NAME] ,
	[job_owner] ,'','',
	[billable_total] ,
	[non_billable_total],
	[PO_NO] ,
	[PooledTotal] ,
	[UnbilledOpsInvoicesTotal],NAME,ltrim(str(month(@datestamp))) + '/' + ltrim(str(day(@datestamp))) + '/' + ltrim(str(year(@datestamp))) DATEREPORTRUN from #tbl
inner join ORGANIZATIONS on ORGANIZATIONS.ORGANIZATION_ID=#tbl.ORGANIZATION_ID

--Account for null job_owners which happen from time to time for unknown reason
update UNBILLED_REPORT_DAILYDATACAPTURE set job_owner='' where job_owner is null
update UNBILLED_REPORT_DAILYDATACAPTURE set BILLING_USER_ID=-999 where BILLING_USER_ID is null

drop table #tbl
drop table #tbl2
drop table #tbl3
drop table #tbl4
--exec sp_CRYSTAL_UNBILLED_REPORT_DAILYDATACAPTURE '10/7/2005'
--select * from UNBILLED_REPORT_DAILYDATACAPTURE
GO
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_BILLABLE_VS_NONBILLABLE2006]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_CRYSTAL_BILLABLE_VS_NONBILLABLE2006]
	@begdate varchar(25)
AS
set nocount on
create table #tbl(
	[RESOURCEID] [numeric] (18,0),
	[RESOURCENAME] [varchar] (210) ,
	[TOTALHOURSPAID] [numeric](19, 5) ,
	[TOTALNONBILLABLEHOURS] [numeric](19, 5) ,
	[TOTALBILLABLEHOURS] [numeric](19, 5) ,
	[WEEK1NONBILL] [numeric](19, 5),
	[WEEK1BILL] [numeric](19, 5) ,
	[WEEK2NONBILL] [numeric](19, 5) ,
	[WEEK2BILL] [numeric](19, 5) ,
	[WEEK3NONBILL] [numeric](19, 5) ,
	[WEEK3BILL] [numeric](19, 5) ,
	[WEEK4NONBILL] [numeric](19, 5) ,
	[WEEK4BILL] [numeric](19, 5) ,
	[WEEK5NONBILL] [numeric](19, 5) ,
	[WEEK5BILL] [numeric](19, 5) ,
	[WEEK6NONBILL] [numeric](19, 5) ,
	[WEEK6BILL] [numeric](19, 5) ,
	[WEEK7NONBILL] [numeric](19, 5) ,
	[WEEK7BILL] [numeric](19, 5) ,
	[WEEK8NONBILL] [numeric](19, 5) ,
	[WEEK8BILL] [numeric](19, 5) ,
	[WEEK9NONBILL] [numeric](19, 5) ,
	[WEEK9BILL] [numeric](19, 5) ,
	[WEEK10NONBILL] [numeric](19, 5) ,
	[WEEK10BILL] [numeric](19, 5) ,
	[WEEK11NONBILL] [numeric](19, 5) ,
	[WEEK11BILL] [numeric](19, 5) ,
	[WEEK12NONBILL] [numeric](19, 5) ,
	[WEEK12BILL] [numeric](19, 5) ,
	[WEEK13NONBILL] [numeric](19, 5) ,
	[WEEK13BILL] [numeric](19, 5) ,
	[WEEK1] DATETIME, WEEK2 DATETIME,WEEK3 DATETIME,WEEK4 DATETIME,WEEK5 DATETIME,
	WEEK6 DATETIME,WEEK7 DATETIME,WEEK8 DATETIME,WEEK9 DATETIME,WEEK10 DATETIME,WEEK11 DATETIME,WEEK12 DATETIME,WEEK13 DATETIME
) 
/*Begin cursor to loop through the predefined resources*/
declare @BegYear datetime,
	@Week1Beg datetime,
	@Week2Beg datetime,
	@Week3Beg datetime,
	@Week4Beg datetime,
	@Week5Beg datetime,
	@Week6Beg datetime,
	@Week7Beg datetime,
	@Week8Beg datetime,
	@Week9Beg datetime,
	@Week10Beg datetime,
	@Week11Beg datetime,
	@Week12Beg datetime,
	@Week13Beg datetime,
	@TOTALHOURSPAID numeric(19,5),
	@TOTALNONBILLABLEHOURS numeric(19,5),
	@TOTALBILLABLEHOURS numeric(19,5),
	@WEEK1NONBILL numeric(19,5),
	@WEEK1BILL numeric(19,5),
	@WEEK2NONBILL numeric(19,5),
	@WEEK2BILL numeric(19,5),
	@WEEK3NONBILL numeric(19,5),
	@WEEK3BILL numeric(19,5),
	@WEEK4NONBILL numeric(19,5),
	@WEEK4BILL numeric(19,5),
	@WEEK5NONBILL numeric(19,5),
	@WEEK5BILL numeric(19,5),
	@WEEK6NONBILL numeric(19,5),
	@WEEK6BILL numeric(19,5),
	@WEEK7NONBILL numeric(19,5),
	@WEEK7BILL numeric(19,5),
	@WEEK8NONBILL numeric(19,5),
	@WEEK8BILL numeric(19,5),
	@WEEK9NONBILL numeric(19,5),
	@WEEK9BILL numeric(19,5),
	@WEEK10NONBILL numeric(19,5),
	@WEEK10BILL numeric(19,5),
	@WEEK11NONBILL numeric(19,5),
	@WEEK11BILL numeric(19,5),
	@WEEK12NONBILL numeric(19,5),
	@WEEK12BILL numeric(19,5),
	@WEEK13NONBILL numeric(19,5),
	@WEEK13BILL numeric(19,5),
	@RESOURCEID numeric(18,0),
	@RESOURCENAME varchar(255)

select @BegYear='1/1/'+str(year(@begdate))
select @Week1Beg = cast(dateadd(day,7,@begdate) as datetime)
select @Week2Beg = cast(dateadd(day,14,@begdate) as datetime)
select @Week3Beg = cast(dateadd(day,21,@begdate) as datetime)
select @Week4Beg = cast(dateadd(day,28,@begdate) as datetime)
select @Week5Beg = cast(dateadd(day,35,@begdate) as datetime)
select @Week6Beg = cast(dateadd(day,42,@begdate) as datetime)
select @Week7Beg = cast(dateadd(day,49,@begdate) as datetime)
select @Week8Beg = cast(dateadd(day,56,@begdate) as datetime)
select @Week9Beg = cast(dateadd(day,63,@begdate) as datetime)
select @Week10Beg = cast(dateadd(day,70,@begdate) as datetime)
select @Week11Beg = cast(dateadd(day,77,@begdate) as datetime)
select @Week12Beg = cast(dateadd(day,84,@begdate) as datetime)
select @Week13Beg = cast(dateadd(day,91,@begdate) as datetime)
print @WEek1Beg
print @Week2Beg
print @week3Beg
select @RESOURCEID=161
select @RESOURCENAME=name from RESOURCES where RESOURCE_ID=@RESOURCEID

select @TOTALHOURSPAID=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE<= @begdate and SERVICE_LINE_DATE >= @BegYear

select @TOTALNONBILLABLEHOURS=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE<= @begdate and SERVICE_LINE_DATE >= @BegYear 
and left(TC_JOB_NO,3) = '699'
 
select @TOTALBILLABLEHOURS=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE<= @begdate and SERVICE_LINE_DATE >= @BegYear 
and left(TC_JOB_NO,3) <> '699'

select @WEEK1NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @begdate and SERVICE_LINE_DATE < @Week1Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK1BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @begdate and SERVICE_LINE_DATE < @Week1Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK2NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week1Beg and SERVICE_LINE_DATE < @Week2Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK2BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week1Beg and SERVICE_LINE_DATE < @Week2Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK3NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week2Beg and SERVICE_LINE_DATE < @Week3Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK3BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week2Beg and SERVICE_LINE_DATE < @Week3Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK4NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week3Beg and SERVICE_LINE_DATE < @Week4Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK4BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week3Beg and SERVICE_LINE_DATE < @Week4Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK5NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week4Beg and SERVICE_LINE_DATE < @Week5Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK5BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week4Beg and SERVICE_LINE_DATE < @Week5Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK6NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week5Beg and SERVICE_LINE_DATE < @Week6Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK6BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week5Beg and SERVICE_LINE_DATE < @Week6Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK7NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week6Beg and SERVICE_LINE_DATE < @Week7Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK7BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week6Beg and SERVICE_LINE_DATE < @Week7Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK8NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week7Beg and SERVICE_LINE_DATE < @Week8Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK8BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week7Beg and SERVICE_LINE_DATE < @Week8Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK9NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week8Beg and SERVICE_LINE_DATE < @Week9Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK9BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week8Beg and SERVICE_LINE_DATE < @Week9Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK10NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week9Beg and SERVICE_LINE_DATE < @Week10Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK10BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week9Beg and SERVICE_LINE_DATE < @Week10Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK11NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week10Beg and SERVICE_LINE_DATE < @Week11Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK11BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week10Beg and SERVICE_LINE_DATE < @Week11Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK12NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week11Beg and SERVICE_LINE_DATE < @Week12Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK12BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week11Beg and SERVICE_LINE_DATE < @Week12Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK13NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week12Beg and SERVICE_LINE_DATE < @Week13Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK13BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week12Beg and SERVICE_LINE_DATE < @Week13Beg 
and left(TC_JOB_NO,3) <> '699'


insert into #tbl values(@RESOURCEID,@RESOURCENAME,@TOTALHOURSPAID,
ISNULL(@TOTALNONBILLABLEHOURS,0),ISNULL(@TOTALBILLABLEHOURS,0),ISNULL(@WEEK1NONBILL,0),ISNULL(@WEEK1BILL,0),
ISNULL(@WEEK2NONBILL,0),ISNULL(@WEEK2BILL,0),ISNULL(@WEEK3NONBILL,0),ISNULL(@WEEK3BILL,0),ISNULL(@WEEK4NONBILL,0),ISNULL(@WEEK4BILL,0),
ISNULL(@WEEK5NONBILL,0),ISNULL(@WEEK5BILL,0),
ISNULL(@WEEK6NONBILL,0),ISNULL(@WEEK6BILL,0),
ISNULL(@WEEK7NONBILL,0),ISNULL(@WEEK7BILL,0),
ISNULL(@WEEK8NONBILL,0),ISNULL(@WEEK8BILL,0),
ISNULL(@WEEK9NONBILL,0),ISNULL(@WEEK9BILL,0),
ISNULL(@WEEK10NONBILL,0),ISNULL(@WEEK10BILL,0),
ISNULL(@WEEK11NONBILL,0),ISNULL(@WEEK11BILL,0),
ISNULL(@WEEK12NONBILL,0),ISNULL(@WEEK12BILL,0),ISNULL(@WEEK13NONBILL,0),ISNULL(@WEEK13BILL,0),
dateadd(day,7,@begdate)-1,
dateadd(day,14,@begdate)-1,dateadd(day,21,@begdate)-1,dateadd(day,28,@begdate)-1,dateadd(day,35,@begdate)-1,
dateadd(day,42,@begdate)-1,dateadd(day,49,@begdate)-1,dateadd(day,56,@begdate)-1,dateadd(day,63,@begdate)-1,
dateadd(day,70,@begdate)-1,dateadd(day,77,@begdate)-1,dateadd(day,84,@begdate)-1,dateadd(day,91,@begdate)-1)

select @RESOURCEID=14
select @RESOURCENAME=name from RESOURCES where RESOURCE_ID=@RESOURCEID

select @TOTALHOURSPAID=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE<= @begdate and SERVICE_LINE_DATE >= @BegYear

select @TOTALNONBILLABLEHOURS=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE<= @begdate and SERVICE_LINE_DATE >= @BegYear 
and left(TC_JOB_NO,3) = '699'
 
select @TOTALBILLABLEHOURS=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE<= @begdate and SERVICE_LINE_DATE >= @BegYear 
and left(TC_JOB_NO,3) <> '699'

select @WEEK1NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @begdate and SERVICE_LINE_DATE < @Week1Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK1BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @begdate and SERVICE_LINE_DATE < @Week1Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK2NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week1Beg and SERVICE_LINE_DATE < @Week2Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK2BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week1Beg and SERVICE_LINE_DATE < @Week2Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK3NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week2Beg and SERVICE_LINE_DATE < @Week3Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK3BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week2Beg and SERVICE_LINE_DATE < @Week3Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK4NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week3Beg and SERVICE_LINE_DATE < @Week4Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK4BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week3Beg and SERVICE_LINE_DATE < @Week4Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK5NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week4Beg and SERVICE_LINE_DATE < @Week5Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK5BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week4Beg and SERVICE_LINE_DATE < @Week5Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK6NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week5Beg and SERVICE_LINE_DATE < @Week6Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK6BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week5Beg and SERVICE_LINE_DATE < @Week6Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK7NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week6Beg and SERVICE_LINE_DATE < @Week7Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK7BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week6Beg and SERVICE_LINE_DATE < @Week7Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK8NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week7Beg and SERVICE_LINE_DATE < @Week8Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK8BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week7Beg and SERVICE_LINE_DATE < @Week8Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK9NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week8Beg and SERVICE_LINE_DATE < @Week9Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK9BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week8Beg and SERVICE_LINE_DATE < @Week9Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK10NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week9Beg and SERVICE_LINE_DATE < @Week10Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK10BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week9Beg and SERVICE_LINE_DATE < @Week10Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK11NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week10Beg and SERVICE_LINE_DATE < @Week11Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK11BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week10Beg and SERVICE_LINE_DATE < @Week11Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK12NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week11Beg and SERVICE_LINE_DATE < @Week12Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK12BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week11Beg and SERVICE_LINE_DATE < @Week12Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK13NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week12Beg and SERVICE_LINE_DATE < @Week13Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK13BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week12Beg and SERVICE_LINE_DATE < @Week13Beg 
and left(TC_JOB_NO,3) <> '699'

insert into #tbl values(@RESOURCEID,@RESOURCENAME,@TOTALHOURSPAID,
ISNULL(@TOTALNONBILLABLEHOURS,0),ISNULL(@TOTALBILLABLEHOURS,0),ISNULL(@WEEK1NONBILL,0),ISNULL(@WEEK1BILL,0),
ISNULL(@WEEK2NONBILL,0),ISNULL(@WEEK2BILL,0),ISNULL(@WEEK3NONBILL,0),ISNULL(@WEEK3BILL,0),ISNULL(@WEEK4NONBILL,0),ISNULL(@WEEK4BILL,0),
ISNULL(@WEEK5NONBILL,0),ISNULL(@WEEK5BILL,0),
ISNULL(@WEEK6NONBILL,0),ISNULL(@WEEK6BILL,0),
ISNULL(@WEEK7NONBILL,0),ISNULL(@WEEK7BILL,0),
ISNULL(@WEEK8NONBILL,0),ISNULL(@WEEK8BILL,0),
ISNULL(@WEEK9NONBILL,0),ISNULL(@WEEK9BILL,0),
ISNULL(@WEEK10NONBILL,0),ISNULL(@WEEK10BILL,0),
ISNULL(@WEEK11NONBILL,0),ISNULL(@WEEK11BILL,0),
ISNULL(@WEEK12NONBILL,0),ISNULL(@WEEK12BILL,0),ISNULL(@WEEK13NONBILL,0),ISNULL(@WEEK13BILL,0),
dateadd(day,7,@begdate)-1,
dateadd(day,14,@begdate)-1,dateadd(day,21,@begdate)-1,dateadd(day,28,@begdate)-1,dateadd(day,35,@begdate)-1,
dateadd(day,42,@begdate)-1,dateadd(day,49,@begdate)-1,dateadd(day,56,@begdate)-1,dateadd(day,63,@begdate)-1,
dateadd(day,70,@begdate)-1,dateadd(day,77,@begdate)-1,dateadd(day,84,@begdate)-1,dateadd(day,91,@begdate)-1)

select @RESOURCEID=124
select @RESOURCENAME=name from RESOURCES where RESOURCE_ID=@RESOURCEID

select @TOTALHOURSPAID=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE<= @begdate and SERVICE_LINE_DATE >= @BegYear

select @TOTALNONBILLABLEHOURS=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE<= @begdate and SERVICE_LINE_DATE >= @BegYear 
and left(TC_JOB_NO,3) = '699'
 
select @TOTALBILLABLEHOURS=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE<= @begdate and SERVICE_LINE_DATE >= @BegYear 
and left(TC_JOB_NO,3) <> '699'

select @WEEK1NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @begdate and SERVICE_LINE_DATE < @Week1Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK1BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @begdate and SERVICE_LINE_DATE < @Week1Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK2NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week1Beg and SERVICE_LINE_DATE < @Week2Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK2BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week1Beg and SERVICE_LINE_DATE < @Week2Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK3NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week2Beg and SERVICE_LINE_DATE < @Week3Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK3BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week2Beg and SERVICE_LINE_DATE < @Week3Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK4NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week3Beg and SERVICE_LINE_DATE < @Week4Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK4BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week3Beg and SERVICE_LINE_DATE < @Week4Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK5NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week4Beg and SERVICE_LINE_DATE < @Week5Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK5BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week4Beg and SERVICE_LINE_DATE < @Week5Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK6NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week5Beg and SERVICE_LINE_DATE < @Week6Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK6BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week5Beg and SERVICE_LINE_DATE < @Week6Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK7NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week6Beg and SERVICE_LINE_DATE < @Week7Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK7BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week6Beg and SERVICE_LINE_DATE < @Week7Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK8NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week7Beg and SERVICE_LINE_DATE < @Week8Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK8BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week7Beg and SERVICE_LINE_DATE < @Week8Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK9NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week8Beg and SERVICE_LINE_DATE < @Week9Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK9BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week8Beg and SERVICE_LINE_DATE < @Week9Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK10NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week9Beg and SERVICE_LINE_DATE < @Week10Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK10BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week9Beg and SERVICE_LINE_DATE < @Week10Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK11NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week10Beg and SERVICE_LINE_DATE < @Week11Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK11BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week10Beg and SERVICE_LINE_DATE < @Week11Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK12NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week11Beg and SERVICE_LINE_DATE < @Week12Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK12BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week11Beg and SERVICE_LINE_DATE < @Week12Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK13NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week12Beg and SERVICE_LINE_DATE < @Week13Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK13BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week12Beg and SERVICE_LINE_DATE < @Week13Beg 
and left(TC_JOB_NO,3) <> '699'

insert into #tbl values(@RESOURCEID,@RESOURCENAME,@TOTALHOURSPAID,
ISNULL(@TOTALNONBILLABLEHOURS,0),ISNULL(@TOTALBILLABLEHOURS,0),ISNULL(@WEEK1NONBILL,0),ISNULL(@WEEK1BILL,0),
ISNULL(@WEEK2NONBILL,0),ISNULL(@WEEK2BILL,0),ISNULL(@WEEK3NONBILL,0),ISNULL(@WEEK3BILL,0),ISNULL(@WEEK4NONBILL,0),ISNULL(@WEEK4BILL,0),
ISNULL(@WEEK5NONBILL,0),ISNULL(@WEEK5BILL,0),
ISNULL(@WEEK6NONBILL,0),ISNULL(@WEEK6BILL,0),
ISNULL(@WEEK7NONBILL,0),ISNULL(@WEEK7BILL,0),
ISNULL(@WEEK8NONBILL,0),ISNULL(@WEEK8BILL,0),
ISNULL(@WEEK9NONBILL,0),ISNULL(@WEEK9BILL,0),
ISNULL(@WEEK10NONBILL,0),ISNULL(@WEEK10BILL,0),
ISNULL(@WEEK11NONBILL,0),ISNULL(@WEEK11BILL,0),
ISNULL(@WEEK12NONBILL,0),ISNULL(@WEEK12BILL,0),ISNULL(@WEEK13NONBILL,0),ISNULL(@WEEK13BILL,0),
dateadd(day,7,@begdate)-1,
dateadd(day,14,@begdate)-1,dateadd(day,21,@begdate)-1,dateadd(day,28,@begdate)-1,dateadd(day,35,@begdate)-1,
dateadd(day,42,@begdate)-1,dateadd(day,49,@begdate)-1,dateadd(day,56,@begdate)-1,dateadd(day,63,@begdate)-1,
dateadd(day,70,@begdate)-1,dateadd(day,77,@begdate)-1,dateadd(day,84,@begdate)-1,dateadd(day,91,@begdate)-1)

select @RESOURCEID=105
select @RESOURCENAME=name from RESOURCES where RESOURCE_ID=@RESOURCEID

select @TOTALHOURSPAID=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE<= @begdate and SERVICE_LINE_DATE >= @BegYear

select @TOTALNONBILLABLEHOURS=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE<= @begdate and SERVICE_LINE_DATE >= @BegYear 
and left(TC_JOB_NO,3) = '699'
 
select @TOTALBILLABLEHOURS=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE<= @begdate and SERVICE_LINE_DATE >= @BegYear 
and left(TC_JOB_NO,3) <> '699'

select @WEEK1NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @begdate and SERVICE_LINE_DATE < @Week1Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK1BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @begdate and SERVICE_LINE_DATE < @Week1Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK2NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week1Beg and SERVICE_LINE_DATE < @Week2Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK2BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week1Beg and SERVICE_LINE_DATE < @Week2Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK3NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week2Beg and SERVICE_LINE_DATE < @Week3Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK3BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week2Beg and SERVICE_LINE_DATE < @Week3Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK4NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week3Beg and SERVICE_LINE_DATE < @Week4Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK4BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week3Beg and SERVICE_LINE_DATE < @Week4Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK5NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week4Beg and SERVICE_LINE_DATE < @Week5Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK5BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week4Beg and SERVICE_LINE_DATE < @Week5Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK6NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week5Beg and SERVICE_LINE_DATE < @Week6Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK6BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week5Beg and SERVICE_LINE_DATE < @Week6Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK7NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week6Beg and SERVICE_LINE_DATE < @Week7Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK7BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week6Beg and SERVICE_LINE_DATE < @Week7Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK8NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week7Beg and SERVICE_LINE_DATE < @Week8Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK8BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week7Beg and SERVICE_LINE_DATE < @Week8Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK9NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week8Beg and SERVICE_LINE_DATE < @Week9Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK9BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week8Beg and SERVICE_LINE_DATE < @Week9Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK10NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week9Beg and SERVICE_LINE_DATE < @Week10Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK10BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week9Beg and SERVICE_LINE_DATE < @Week10Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK11NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week10Beg and SERVICE_LINE_DATE < @Week11Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK11BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week10Beg and SERVICE_LINE_DATE < @Week11Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK12NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week11Beg and SERVICE_LINE_DATE < @Week12Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK12BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week11Beg and SERVICE_LINE_DATE < @Week12Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK13NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week12Beg and SERVICE_LINE_DATE < @Week13Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK13BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week12Beg and SERVICE_LINE_DATE < @Week13Beg 
and left(TC_JOB_NO,3) <> '699'

insert into #tbl values(@RESOURCEID,@RESOURCENAME,@TOTALHOURSPAID,
ISNULL(@TOTALNONBILLABLEHOURS,0),ISNULL(@TOTALBILLABLEHOURS,0),ISNULL(@WEEK1NONBILL,0),ISNULL(@WEEK1BILL,0),
ISNULL(@WEEK2NONBILL,0),ISNULL(@WEEK2BILL,0),ISNULL(@WEEK3NONBILL,0),ISNULL(@WEEK3BILL,0),ISNULL(@WEEK4NONBILL,0),ISNULL(@WEEK4BILL,0),
ISNULL(@WEEK5NONBILL,0),ISNULL(@WEEK5BILL,0),
ISNULL(@WEEK6NONBILL,0),ISNULL(@WEEK6BILL,0),
ISNULL(@WEEK7NONBILL,0),ISNULL(@WEEK7BILL,0),
ISNULL(@WEEK8NONBILL,0),ISNULL(@WEEK8BILL,0),
ISNULL(@WEEK9NONBILL,0),ISNULL(@WEEK9BILL,0),
ISNULL(@WEEK10NONBILL,0),ISNULL(@WEEK10BILL,0),
ISNULL(@WEEK11NONBILL,0),ISNULL(@WEEK11BILL,0),
ISNULL(@WEEK12NONBILL,0),ISNULL(@WEEK12BILL,0),ISNULL(@WEEK13NONBILL,0),ISNULL(@WEEK13BILL,0),
dateadd(day,7,@begdate)-1,
dateadd(day,14,@begdate)-1,dateadd(day,21,@begdate)-1,dateadd(day,28,@begdate)-1,dateadd(day,35,@begdate)-1,
dateadd(day,42,@begdate)-1,dateadd(day,49,@begdate)-1,dateadd(day,56,@begdate)-1,dateadd(day,63,@begdate)-1,
dateadd(day,70,@begdate)-1,dateadd(day,77,@begdate)-1,dateadd(day,84,@begdate)-1,dateadd(day,91,@begdate)-1)

select @RESOURCEID=158
select @RESOURCENAME=name from RESOURCES where RESOURCE_ID=@RESOURCEID

select @TOTALHOURSPAID=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE<= @begdate and SERVICE_LINE_DATE >= @BegYear

select @TOTALNONBILLABLEHOURS=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE<= @begdate and SERVICE_LINE_DATE >= @BegYear 
and left(TC_JOB_NO,3) = '699'
 
select @TOTALBILLABLEHOURS=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE<= @begdate and SERVICE_LINE_DATE >= @BegYear 
and left(TC_JOB_NO,3) <> '699'

select @WEEK1NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @begdate and SERVICE_LINE_DATE < @Week1Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK1BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @begdate and SERVICE_LINE_DATE < @Week1Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK2NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week1Beg and SERVICE_LINE_DATE < @Week2Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK2BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week1Beg and SERVICE_LINE_DATE < @Week2Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK3NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week2Beg and SERVICE_LINE_DATE < @Week3Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK3BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week2Beg and SERVICE_LINE_DATE < @Week3Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK4NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week3Beg and SERVICE_LINE_DATE < @Week4Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK4BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week3Beg and SERVICE_LINE_DATE < @Week4Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK5NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week4Beg and SERVICE_LINE_DATE < @Week5Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK5BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week4Beg and SERVICE_LINE_DATE < @Week5Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK6NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week5Beg and SERVICE_LINE_DATE < @Week6Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK6BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week5Beg and SERVICE_LINE_DATE < @Week6Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK7NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week6Beg and SERVICE_LINE_DATE < @Week7Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK7BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week6Beg and SERVICE_LINE_DATE < @Week7Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK8NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week7Beg and SERVICE_LINE_DATE < @Week8Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK8BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week7Beg and SERVICE_LINE_DATE < @Week8Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK9NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week8Beg and SERVICE_LINE_DATE < @Week9Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK9BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week8Beg and SERVICE_LINE_DATE < @Week9Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK10NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week9Beg and SERVICE_LINE_DATE < @Week10Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK10BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week9Beg and SERVICE_LINE_DATE < @Week10Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK11NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week10Beg and SERVICE_LINE_DATE < @Week11Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK11BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week10Beg and SERVICE_LINE_DATE < @Week11Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK12NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week11Beg and SERVICE_LINE_DATE < @Week12Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK12BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week11Beg and SERVICE_LINE_DATE < @Week12Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK13NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week12Beg and SERVICE_LINE_DATE < @Week13Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK13BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week12Beg and SERVICE_LINE_DATE < @Week13Beg 
and left(TC_JOB_NO,3) <> '699'

insert into #tbl values(@RESOURCEID,@RESOURCENAME,@TOTALHOURSPAID,
ISNULL(@TOTALNONBILLABLEHOURS,0),ISNULL(@TOTALBILLABLEHOURS,0),ISNULL(@WEEK1NONBILL,0),ISNULL(@WEEK1BILL,0),
ISNULL(@WEEK2NONBILL,0),ISNULL(@WEEK2BILL,0),ISNULL(@WEEK3NONBILL,0),ISNULL(@WEEK3BILL,0),ISNULL(@WEEK4NONBILL,0),ISNULL(@WEEK4BILL,0),
ISNULL(@WEEK5NONBILL,0),ISNULL(@WEEK5BILL,0),
ISNULL(@WEEK6NONBILL,0),ISNULL(@WEEK6BILL,0),
ISNULL(@WEEK7NONBILL,0),ISNULL(@WEEK7BILL,0),
ISNULL(@WEEK8NONBILL,0),ISNULL(@WEEK8BILL,0),
ISNULL(@WEEK9NONBILL,0),ISNULL(@WEEK9BILL,0),
ISNULL(@WEEK10NONBILL,0),ISNULL(@WEEK10BILL,0),
ISNULL(@WEEK11NONBILL,0),ISNULL(@WEEK11BILL,0),
ISNULL(@WEEK12NONBILL,0),ISNULL(@WEEK12BILL,0),ISNULL(@WEEK13NONBILL,0),ISNULL(@WEEK13BILL,0),
dateadd(day,7,@begdate)-1,
dateadd(day,14,@begdate)-1,dateadd(day,21,@begdate)-1,dateadd(day,28,@begdate)-1,dateadd(day,35,@begdate)-1,
dateadd(day,42,@begdate)-1,dateadd(day,49,@begdate)-1,dateadd(day,56,@begdate)-1,dateadd(day,63,@begdate)-1,
dateadd(day,70,@begdate)-1,dateadd(day,77,@begdate)-1,dateadd(day,84,@begdate)-1,dateadd(day,91,@begdate)-1)

select @RESOURCEID=636
select @RESOURCENAME=name from RESOURCES where RESOURCE_ID=@RESOURCEID

select @TOTALHOURSPAID=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE<= @begdate and SERVICE_LINE_DATE >= @BegYear

select @TOTALNONBILLABLEHOURS=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE<= @begdate and SERVICE_LINE_DATE >= @BegYear 
and left(TC_JOB_NO,3) = '699'
 
select @TOTALBILLABLEHOURS=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE<= @begdate and SERVICE_LINE_DATE >= @BegYear 
and left(TC_JOB_NO,3) <> '699'

select @WEEK1NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @begdate and SERVICE_LINE_DATE < @Week1Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK1BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @begdate and SERVICE_LINE_DATE < @Week1Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK2NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week1Beg and SERVICE_LINE_DATE < @Week2Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK2BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week1Beg and SERVICE_LINE_DATE < @Week2Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK3NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week2Beg and SERVICE_LINE_DATE < @Week3Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK3BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week2Beg and SERVICE_LINE_DATE < @Week3Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK4NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week3Beg and SERVICE_LINE_DATE < @Week4Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK4BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week3Beg and SERVICE_LINE_DATE < @Week4Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK5NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week4Beg and SERVICE_LINE_DATE < @Week5Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK5BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week4Beg and SERVICE_LINE_DATE < @Week5Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK6NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week5Beg and SERVICE_LINE_DATE < @Week6Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK6BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week5Beg and SERVICE_LINE_DATE < @Week6Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK7NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week6Beg and SERVICE_LINE_DATE < @Week7Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK7BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week6Beg and SERVICE_LINE_DATE < @Week7Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK8NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week7Beg and SERVICE_LINE_DATE < @Week8Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK8BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week7Beg and SERVICE_LINE_DATE < @Week8Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK9NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week8Beg and SERVICE_LINE_DATE < @Week9Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK9BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week8Beg and SERVICE_LINE_DATE < @Week9Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK10NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week9Beg and SERVICE_LINE_DATE < @Week10Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK10BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week9Beg and SERVICE_LINE_DATE < @Week10Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK11NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week10Beg and SERVICE_LINE_DATE < @Week11Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK11BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week10Beg and SERVICE_LINE_DATE < @Week11Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK12NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week11Beg and SERVICE_LINE_DATE < @Week12Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK12BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week11Beg and SERVICE_LINE_DATE < @Week12Beg 
and left(TC_JOB_NO,3) <> '699'

select @WEEK13NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week12Beg and SERVICE_LINE_DATE < @Week13Beg 
and left(TC_JOB_NO,3) = '699'

select @WEEK13BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week12Beg and SERVICE_LINE_DATE < @Week13Beg 
and left(TC_JOB_NO,3) <> '699'

insert into #tbl values(@RESOURCEID,@RESOURCENAME,@TOTALHOURSPAID,
ISNULL(@TOTALNONBILLABLEHOURS,0),ISNULL(@TOTALBILLABLEHOURS,0),ISNULL(@WEEK1NONBILL,0),ISNULL(@WEEK1BILL,0),
ISNULL(@WEEK2NONBILL,0),ISNULL(@WEEK2BILL,0),ISNULL(@WEEK3NONBILL,0),ISNULL(@WEEK3BILL,0),ISNULL(@WEEK4NONBILL,0),ISNULL(@WEEK4BILL,0),
ISNULL(@WEEK5NONBILL,0),ISNULL(@WEEK5BILL,0),
ISNULL(@WEEK6NONBILL,0),ISNULL(@WEEK6BILL,0),
ISNULL(@WEEK7NONBILL,0),ISNULL(@WEEK7BILL,0),
ISNULL(@WEEK8NONBILL,0),ISNULL(@WEEK8BILL,0),
ISNULL(@WEEK9NONBILL,0),ISNULL(@WEEK9BILL,0),
ISNULL(@WEEK10NONBILL,0),ISNULL(@WEEK10BILL,0),
ISNULL(@WEEK11NONBILL,0),ISNULL(@WEEK11BILL,0),
ISNULL(@WEEK12NONBILL,0),ISNULL(@WEEK12BILL,0),ISNULL(@WEEK13NONBILL,0),ISNULL(@WEEK13BILL,0),
dateadd(day,7,@begdate)-1,
dateadd(day,14,@begdate)-1,dateadd(day,21,@begdate)-1,dateadd(day,28,@begdate)-1,dateadd(day,35,@begdate)-1,
dateadd(day,42,@begdate)-1,dateadd(day,49,@begdate)-1,dateadd(day,56,@begdate)-1,dateadd(day,63,@begdate)-1,
dateadd(day,70,@begdate)-1,dateadd(day,77,@begdate)-1,dateadd(day,84,@begdate)-1,dateadd(day,91,@begdate)-1)

select * from #tbl
drop table #tbl
GO
/****** Object:  Trigger [ud_ph_trig]    Script Date: 05/03/2010 14:18:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE TRIGGER [dbo].[ud_ph_trig] ON [dbo].[SERVICE_LINES] 
FOR UPDATE, DELETE
AS

print ('---------------------------')  
print ('ud_ph_trigger')  
print ('---------------------------')  

DECLARE @inserted_count as numeric(18)
DECLARE @deleted_count as numeric(18)
SELECT @inserted_count = count(*)  FROM inserted
SELECT @deleted_count = count(*) FROM deleted
print('inserted count = ' + cast(@inserted_count as varchar))
print('deleted count = ' + cast(@deleted_count as varchar))
/* pooled_flag updated in iu_service_lines trigger, want this to run after that trigger for updates or deletes, but then it didnt see the old row to update the previous qty. so hide now */
--IF( UPDATE(pooled_flag) OR @inserted_count = 0 OR @deleted_count > 0)

BEGIN

print ('ud_ph_trigger activated')  

DECLARE @service_id as numeric(18)
DECLARE @ph_service_id numeric(18)
DECLARE @rate as numeric(18,3)
DECLARE @item_id as numeric(18)
DECLARE @ir_flag as varchar(1)
DECLARE @pooled_qty as numeric(18,2)
DECLARE @dist_qty as numeric(18,2)

DECLARE rate_cursor CURSOR LOCAL FORWARD_ONLY READ_ONLY FOR
SELECT DISTINCT service_id, item_id, rate, ph_service_id, internal_req_flag
FROM (
SELECT tc_service_id service_id, item_id, bill_rate rate, ph_service_id, internal_req_flag 
FROM inserted 
WHERE internal_req_flag = 'Y' AND status_id > 1
UNION
SELECT tc_service_id service_id, item_id, bill_rate rate, ph_service_id, internal_req_flag
FROM deleted 
WHERE internal_req_flag = 'Y' AND status_id > 1
UNION
SELECT bill_service_id service_id, item_id, bill_rate rate, ph_service_id, internal_req_flag 
FROM inserted
WHERE (ph_service_id IS NOT NULL)
UNION
SELECT bill_service_id service_id, item_id, bill_rate rate, ph_service_id, internal_req_flag
FROM deleted 
WHERE ph_service_id IS NOT NULL
)  AS NEW

OPEN rate_cursor

-- Perform the first fetch.
FETCH NEXT FROM rate_cursor
INTO @service_id, @item_id, @rate, @ph_service_id, @ir_flag

WHILE (@@FETCH_STATUS = 0)
BEGIN
   
	print ('@service_id = '  + isnull(cast( @service_id as varchar), 'NULL'))
	print ('@ph_service_id = '  + isnull(cast( @ph_service_id as varchar), 'NULL'))
	print ('@item_id = '  + isnull(cast( @item_id as varchar), 'NULL'))
	print ('@rate = '  + isnull(cast( @rate as varchar), 'NULL'))
	print ('@ir_flag = '  + isnull(cast( @ir_flag as varchar), 'NULL'))

	--Make sure it is not a distribution req
    IF (@ph_service_id IS NULL)
    BEGIN
    
   	--Is this an internal (pooled) requisition
	IF (@ir_flag = 'Y')
	BEGIN
	
		--determine what our new pooled qty is
		SELECT @pooled_qty = SUM(sl.tc_qty)
		FROM service_lines sl
		WHERE sl.tc_service_id = @service_id
		AND sl.item_id = @item_id
		AND sl.bill_rate = @rate
		AND sl.status_id > 1

		print ('@pooled_qty = '  + isnull(cast( @pooled_qty as varchar), 'NULL'))

		IF (@pooled_qty < 0.01 OR @pooled_qty IS NULL)
		BEGIN
			--remove row from calc table
			print ('Nothing pooled, deleting')	
			DELETE FROM pooled_hours_calc
	    	 	WHERE service_id = @service_id
	    		AND item_id = @item_id
	    		AND rate = @rate

		END
		ELSE
		BEGIN
			--update our calc table
			print ('Updateing pooled_hours_calc setting qty_pooled = '+cast( @pooled_qty as varchar))	
		    	UPDATE pooled_hours_calc
		    	SET qty_pooled = @pooled_qty
		    	WHERE service_id = @service_id
		    	AND item_id = @item_id
		    	AND rate = @rate

			--if nothing got updated, need to insert intead
			IF (@@ROWCOUNT = 0)
			BEGIN
			
				print ('Update failed, so we need to insert a new row')			
				INSERT INTO  pooled_hours_calc (service_id, item_id, rate, qty_pooled, qty_dist)
				VALUES (@service_id, @item_id, @rate, @pooled_qty, 0)
	
			END
		END
	
	END
    END
    ELSE
    BEGIN
   		--if we got here, that means that ph_service_id is not null, so we need to 
   		--calc the new distributed qty

		SELECT @dist_qty = SUM(sl.bill_qty)
		FROM service_lines sl
		WHERE sl.ph_service_id = @ph_service_id
		AND sl.item_id = @item_id
		AND sl.bill_rate = @rate

		print ('@dist_qty = '  + isnull(cast( @dist_qty as varchar), 'NULL'))
 
		IF (@dist_qty IS NULL)
		BEGIN
			SET @dist_qty = 0
		END
	
		--update our calc table
		print ('Updateing pooled_hours_calc setting dist_qty = '+cast( @dist_qty as varchar))	
	    	UPDATE pooled_hours_calc
	    	SET qty_dist = @dist_qty
	    	WHERE service_id = @ph_service_id
	    	AND item_id = @item_id
	    	AND rate = @rate
    END
  
   FETCH NEXT FROM rate_cursor
   INTO @service_id, @item_id, @rate, @ph_service_id, @ir_flag
END

CLOSE rate_cursor
DEALLOCATE rate_cursor

END
GO
/****** Object:  Trigger [ins_exp_batch_line]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE TRIGGER [dbo].[ins_exp_batch_line] ON [dbo].[EXPENSES_BATCH_LINES] 
FOR INSERT
AS

UPDATE service_lines SET expenses_exported_flag='Y' WHERE service_line_id IN
(SELECT service_line_id FROM inserted)
GO
/****** Object:  Trigger [del_exp_batch_line]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE TRIGGER [dbo].[del_exp_batch_line] ON [dbo].[EXPENSES_BATCH_LINES] 
FOR DELETE 
AS

UPDATE service_lines SET expenses_exported_flag='N' WHERE service_line_id IN
(SELECT service_line_id FROM deleted)
GO
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_BILLABLE_VS_NONBILLABLE]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_CRYSTAL_BILLABLE_VS_NONBILLABLE]
	@begdate varchar(25)
AS
set nocount on
create table #tbl(
	[RESOURCEID] [numeric] (18,0),
	[RESOURCENAME] [varchar] (210) ,
	[TOTALHOURSPAID] [numeric](19, 5) ,
	[TOTALNONBILLABLEHOURS] [numeric](19, 5) ,
	[TOTALBILLABLEHOURS] [numeric](19, 5) ,
	[WEEK1NONBILL] [numeric](19, 5),
	[WEEK1BILL] [numeric](19, 5) ,
	[WEEK2NONBILL] [numeric](19, 5) ,
	[WEEK2BILL] [numeric](19, 5) ,
	[WEEK3NONBILL] [numeric](19, 5) ,
	[WEEK3BILL] [numeric](19, 5) ,
	[WEEK4NONBILL] [numeric](19, 5) ,
	[WEEK4BILL] [numeric](19, 5) ,
	[WEEK5NONBILL] [numeric](19, 5) ,
	[WEEK5BILL] [numeric](19, 5) ,
	[WEEK6NONBILL] [numeric](19, 5) ,
	[WEEK6BILL] [numeric](19, 5) ,
	[WEEK7NONBILL] [numeric](19, 5) ,
	[WEEK7BILL] [numeric](19, 5) ,
	[WEEK8NONBILL] [numeric](19, 5) ,
	[WEEK8BILL] [numeric](19, 5) ,
	[WEEK9NONBILL] [numeric](19, 5) ,
	[WEEK9BILL] [numeric](19, 5) ,
	[WEEK10NONBILL] [numeric](19, 5) ,
	[WEEK10BILL] [numeric](19, 5) ,
	[WEEK11NONBILL] [numeric](19, 5) ,
	[WEEK11BILL] [numeric](19, 5) ,
	[WEEK12NONBILL] [numeric](19, 5) ,
	[WEEK12BILL] [numeric](19, 5) ,
	[WEEK13NONBILL] [numeric](19, 5) ,
	[WEEK13BILL] [numeric](19, 5) ,
	[WEEK1] DATETIME, WEEK2 DATETIME,WEEK3 DATETIME,WEEK4 DATETIME,WEEK5 DATETIME,
	WEEK6 DATETIME,WEEK7 DATETIME,WEEK8 DATETIME,WEEK9 DATETIME,WEEK10 DATETIME,WEEK11 DATETIME,WEEK12 DATETIME,WEEK13 DATETIME
) 
/*Begin cursor to loop through the predefined resources*/
declare @BegYear datetime,
	@Week1Beg datetime,
	@Week2Beg datetime,
	@Week3Beg datetime,
	@Week4Beg datetime,
	@Week5Beg datetime,
	@Week6Beg datetime,
	@Week7Beg datetime,
	@Week8Beg datetime,
	@Week9Beg datetime,
	@Week10Beg datetime,
	@Week11Beg datetime,
	@Week12Beg datetime,
	@Week13Beg datetime,
	@TOTALHOURSPAID numeric(19,5),
	@TOTALNONBILLABLEHOURS numeric(19,5),
	@TOTALBILLABLEHOURS numeric(19,5),
	@WEEK1NONBILL numeric(19,5),
	@WEEK1BILL numeric(19,5),
	@WEEK2NONBILL numeric(19,5),
	@WEEK2BILL numeric(19,5),
	@WEEK3NONBILL numeric(19,5),
	@WEEK3BILL numeric(19,5),
	@WEEK4NONBILL numeric(19,5),
	@WEEK4BILL numeric(19,5),
	@WEEK5NONBILL numeric(19,5),
	@WEEK5BILL numeric(19,5),
	@WEEK6NONBILL numeric(19,5),
	@WEEK6BILL numeric(19,5),
	@WEEK7NONBILL numeric(19,5),
	@WEEK7BILL numeric(19,5),
	@WEEK8NONBILL numeric(19,5),
	@WEEK8BILL numeric(19,5),
	@WEEK9NONBILL numeric(19,5),
	@WEEK9BILL numeric(19,5),
	@WEEK10NONBILL numeric(19,5),
	@WEEK10BILL numeric(19,5),
	@WEEK11NONBILL numeric(19,5),
	@WEEK11BILL numeric(19,5),
	@WEEK12NONBILL numeric(19,5),
	@WEEK12BILL numeric(19,5),
	@WEEK13NONBILL numeric(19,5),
	@WEEK13BILL numeric(19,5),
	@RESOURCEID numeric(18,0),
	@RESOURCENAME varchar(255)

select @BegYear='1/1/'+str(year(@begdate))
select @Week1Beg = cast(dateadd(day,7,@begdate) as datetime)
select @Week2Beg = cast(dateadd(day,14,@begdate) as datetime)
select @Week3Beg = cast(dateadd(day,21,@begdate) as datetime)
select @Week4Beg = cast(dateadd(day,28,@begdate) as datetime)
select @Week5Beg = cast(dateadd(day,35,@begdate) as datetime)
select @Week6Beg = cast(dateadd(day,42,@begdate) as datetime)
select @Week7Beg = cast(dateadd(day,49,@begdate) as datetime)
select @Week8Beg = cast(dateadd(day,56,@begdate) as datetime)
select @Week9Beg = cast(dateadd(day,63,@begdate) as datetime)
select @Week10Beg = cast(dateadd(day,70,@begdate) as datetime)
select @Week11Beg = cast(dateadd(day,77,@begdate) as datetime)
select @Week12Beg = cast(dateadd(day,84,@begdate) as datetime)
select @Week13Beg = cast(dateadd(day,91,@begdate) as datetime)

select @RESOURCEID=161
select @RESOURCENAME=name from RESOURCES where RESOURCE_ID=@RESOURCEID

select @TOTALHOURSPAID=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE<= @begdate and SERVICE_LINE_DATE >= @BegYear

select @TOTALNONBILLABLEHOURS=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE<= @begdate and SERVICE_LINE_DATE >= @BegYear 
and left(TC_JOB_NO,3) = '599'
 
select @TOTALBILLABLEHOURS=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE<= @begdate and SERVICE_LINE_DATE >= @BegYear 
and left(TC_JOB_NO,3) <> '599'

select @WEEK1NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @begdate and SERVICE_LINE_DATE < @Week1Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK1BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @begdate and SERVICE_LINE_DATE < @Week1Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK2NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week1Beg and SERVICE_LINE_DATE < @Week2Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK2BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week1Beg and SERVICE_LINE_DATE < @Week2Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK3NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week2Beg and SERVICE_LINE_DATE < @Week3Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK3BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week2Beg and SERVICE_LINE_DATE < @Week3Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK4NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week3Beg and SERVICE_LINE_DATE < @Week4Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK4BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week3Beg and SERVICE_LINE_DATE < @Week4Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK5NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week4Beg and SERVICE_LINE_DATE < @Week5Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK5BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week4Beg and SERVICE_LINE_DATE < @Week5Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK6NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week5Beg and SERVICE_LINE_DATE < @Week6Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK6BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week5Beg and SERVICE_LINE_DATE < @Week6Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK7NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week6Beg and SERVICE_LINE_DATE < @Week7Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK7BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week6Beg and SERVICE_LINE_DATE < @Week7Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK8NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week7Beg and SERVICE_LINE_DATE < @Week8Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK8BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week7Beg and SERVICE_LINE_DATE < @Week8Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK9NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week8Beg and SERVICE_LINE_DATE < @Week9Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK9BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week8Beg and SERVICE_LINE_DATE < @Week9Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK10NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week9Beg and SERVICE_LINE_DATE < @Week10Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK10BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week9Beg and SERVICE_LINE_DATE < @Week10Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK11NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week10Beg and SERVICE_LINE_DATE < @Week11Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK11BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week10Beg and SERVICE_LINE_DATE < @Week11Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK12NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week11Beg and SERVICE_LINE_DATE < @Week12Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK12BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week11Beg and SERVICE_LINE_DATE < @Week12Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK13NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week12Beg and SERVICE_LINE_DATE < @Week13Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK13BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week12Beg and SERVICE_LINE_DATE < @Week13Beg 
and left(TC_JOB_NO,3) <> '599'


insert into #tbl values(@RESOURCEID,@RESOURCENAME,@TOTALHOURSPAID,
ISNULL(@TOTALNONBILLABLEHOURS,0),ISNULL(@TOTALBILLABLEHOURS,0),ISNULL(@WEEK1NONBILL,0),ISNULL(@WEEK1BILL,0),
ISNULL(@WEEK2NONBILL,0),ISNULL(@WEEK2BILL,0),ISNULL(@WEEK3NONBILL,0),ISNULL(@WEEK3BILL,0),ISNULL(@WEEK4NONBILL,0),ISNULL(@WEEK4BILL,0),
ISNULL(@WEEK5NONBILL,0),ISNULL(@WEEK5BILL,0),
ISNULL(@WEEK6NONBILL,0),ISNULL(@WEEK6BILL,0),
ISNULL(@WEEK7NONBILL,0),ISNULL(@WEEK7BILL,0),
ISNULL(@WEEK8NONBILL,0),ISNULL(@WEEK8BILL,0),
ISNULL(@WEEK9NONBILL,0),ISNULL(@WEEK9BILL,0),
ISNULL(@WEEK10NONBILL,0),ISNULL(@WEEK10BILL,0),
ISNULL(@WEEK11NONBILL,0),ISNULL(@WEEK11BILL,0),
ISNULL(@WEEK12NONBILL,0),ISNULL(@WEEK12BILL,0),ISNULL(@WEEK13NONBILL,0),ISNULL(@WEEK13BILL,0),
dateadd(day,7,@begdate)-1,
dateadd(day,14,@begdate)-1,dateadd(day,21,@begdate)-1,dateadd(day,28,@begdate)-1,dateadd(day,35,@begdate)-1,
dateadd(day,42,@begdate)-1,dateadd(day,49,@begdate)-1,dateadd(day,56,@begdate)-1,dateadd(day,63,@begdate)-1,
dateadd(day,70,@begdate)-1,dateadd(day,77,@begdate)-1,dateadd(day,84,@begdate)-1,dateadd(day,91,@begdate)-1)

select @RESOURCEID=14
select @RESOURCENAME=name from RESOURCES where RESOURCE_ID=@RESOURCEID

select @TOTALHOURSPAID=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE<= @begdate and SERVICE_LINE_DATE >= @BegYear

select @TOTALNONBILLABLEHOURS=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE<= @begdate and SERVICE_LINE_DATE >= @BegYear 
and left(TC_JOB_NO,3) = '599'
 
select @TOTALBILLABLEHOURS=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE<= @begdate and SERVICE_LINE_DATE >= @BegYear 
and left(TC_JOB_NO,3) <> '599'

select @WEEK1NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @begdate and SERVICE_LINE_DATE < @Week1Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK1BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @begdate and SERVICE_LINE_DATE < @Week1Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK2NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week1Beg and SERVICE_LINE_DATE < @Week2Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK2BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week1Beg and SERVICE_LINE_DATE < @Week2Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK3NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week2Beg and SERVICE_LINE_DATE < @Week3Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK3BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week2Beg and SERVICE_LINE_DATE < @Week3Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK4NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week3Beg and SERVICE_LINE_DATE < @Week4Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK4BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week3Beg and SERVICE_LINE_DATE < @Week4Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK5NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week4Beg and SERVICE_LINE_DATE < @Week5Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK5BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week4Beg and SERVICE_LINE_DATE < @Week5Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK6NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week5Beg and SERVICE_LINE_DATE < @Week6Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK6BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week5Beg and SERVICE_LINE_DATE < @Week6Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK7NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week6Beg and SERVICE_LINE_DATE < @Week7Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK7BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week6Beg and SERVICE_LINE_DATE < @Week7Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK8NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week7Beg and SERVICE_LINE_DATE < @Week8Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK8BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week7Beg and SERVICE_LINE_DATE < @Week8Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK9NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week8Beg and SERVICE_LINE_DATE < @Week9Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK9BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week8Beg and SERVICE_LINE_DATE < @Week9Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK10NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week9Beg and SERVICE_LINE_DATE < @Week10Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK10BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week9Beg and SERVICE_LINE_DATE < @Week10Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK11NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week10Beg and SERVICE_LINE_DATE < @Week11Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK11BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week10Beg and SERVICE_LINE_DATE < @Week11Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK12NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week11Beg and SERVICE_LINE_DATE < @Week12Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK12BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week11Beg and SERVICE_LINE_DATE < @Week12Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK13NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week12Beg and SERVICE_LINE_DATE < @Week13Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK13BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week12Beg and SERVICE_LINE_DATE < @Week13Beg 
and left(TC_JOB_NO,3) <> '599'

insert into #tbl values(@RESOURCEID,@RESOURCENAME,@TOTALHOURSPAID,
ISNULL(@TOTALNONBILLABLEHOURS,0),ISNULL(@TOTALBILLABLEHOURS,0),ISNULL(@WEEK1NONBILL,0),ISNULL(@WEEK1BILL,0),
ISNULL(@WEEK2NONBILL,0),ISNULL(@WEEK2BILL,0),ISNULL(@WEEK3NONBILL,0),ISNULL(@WEEK3BILL,0),ISNULL(@WEEK4NONBILL,0),ISNULL(@WEEK4BILL,0),
ISNULL(@WEEK5NONBILL,0),ISNULL(@WEEK5BILL,0),
ISNULL(@WEEK6NONBILL,0),ISNULL(@WEEK6BILL,0),
ISNULL(@WEEK7NONBILL,0),ISNULL(@WEEK7BILL,0),
ISNULL(@WEEK8NONBILL,0),ISNULL(@WEEK8BILL,0),
ISNULL(@WEEK9NONBILL,0),ISNULL(@WEEK9BILL,0),
ISNULL(@WEEK10NONBILL,0),ISNULL(@WEEK10BILL,0),
ISNULL(@WEEK11NONBILL,0),ISNULL(@WEEK11BILL,0),
ISNULL(@WEEK12NONBILL,0),ISNULL(@WEEK12BILL,0),ISNULL(@WEEK13NONBILL,0),ISNULL(@WEEK13BILL,0),
dateadd(day,7,@begdate)-1,
dateadd(day,14,@begdate)-1,dateadd(day,21,@begdate)-1,dateadd(day,28,@begdate)-1,dateadd(day,35,@begdate)-1,
dateadd(day,42,@begdate)-1,dateadd(day,49,@begdate)-1,dateadd(day,56,@begdate)-1,dateadd(day,63,@begdate)-1,
dateadd(day,70,@begdate)-1,dateadd(day,77,@begdate)-1,dateadd(day,84,@begdate)-1,dateadd(day,91,@begdate)-1)

select @RESOURCEID=124
select @RESOURCENAME=name from RESOURCES where RESOURCE_ID=@RESOURCEID

select @TOTALHOURSPAID=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE<= @begdate and SERVICE_LINE_DATE >= @BegYear

select @TOTALNONBILLABLEHOURS=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE<= @begdate and SERVICE_LINE_DATE >= @BegYear 
and left(TC_JOB_NO,3) = '599'
 
select @TOTALBILLABLEHOURS=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE<= @begdate and SERVICE_LINE_DATE >= @BegYear 
and left(TC_JOB_NO,3) <> '599'

select @WEEK1NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @begdate and SERVICE_LINE_DATE < @Week1Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK1BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @begdate and SERVICE_LINE_DATE < @Week1Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK2NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week1Beg and SERVICE_LINE_DATE < @Week2Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK2BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week1Beg and SERVICE_LINE_DATE < @Week2Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK3NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week2Beg and SERVICE_LINE_DATE < @Week3Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK3BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week2Beg and SERVICE_LINE_DATE < @Week3Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK4NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week3Beg and SERVICE_LINE_DATE < @Week4Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK4BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week3Beg and SERVICE_LINE_DATE < @Week4Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK5NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week4Beg and SERVICE_LINE_DATE < @Week5Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK5BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week4Beg and SERVICE_LINE_DATE < @Week5Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK6NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week5Beg and SERVICE_LINE_DATE < @Week6Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK6BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week5Beg and SERVICE_LINE_DATE < @Week6Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK7NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week6Beg and SERVICE_LINE_DATE < @Week7Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK7BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week6Beg and SERVICE_LINE_DATE < @Week7Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK8NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week7Beg and SERVICE_LINE_DATE < @Week8Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK8BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week7Beg and SERVICE_LINE_DATE < @Week8Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK9NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week8Beg and SERVICE_LINE_DATE < @Week9Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK9BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week8Beg and SERVICE_LINE_DATE < @Week9Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK10NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week9Beg and SERVICE_LINE_DATE < @Week10Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK10BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week9Beg and SERVICE_LINE_DATE < @Week10Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK11NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week10Beg and SERVICE_LINE_DATE < @Week11Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK11BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week10Beg and SERVICE_LINE_DATE < @Week11Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK12NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week11Beg and SERVICE_LINE_DATE < @Week12Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK12BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week11Beg and SERVICE_LINE_DATE < @Week12Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK13NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week12Beg and SERVICE_LINE_DATE < @Week13Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK13BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week12Beg and SERVICE_LINE_DATE < @Week13Beg 
and left(TC_JOB_NO,3) <> '599'

insert into #tbl values(@RESOURCEID,@RESOURCENAME,@TOTALHOURSPAID,
ISNULL(@TOTALNONBILLABLEHOURS,0),ISNULL(@TOTALBILLABLEHOURS,0),ISNULL(@WEEK1NONBILL,0),ISNULL(@WEEK1BILL,0),
ISNULL(@WEEK2NONBILL,0),ISNULL(@WEEK2BILL,0),ISNULL(@WEEK3NONBILL,0),ISNULL(@WEEK3BILL,0),ISNULL(@WEEK4NONBILL,0),ISNULL(@WEEK4BILL,0),
ISNULL(@WEEK5NONBILL,0),ISNULL(@WEEK5BILL,0),
ISNULL(@WEEK6NONBILL,0),ISNULL(@WEEK6BILL,0),
ISNULL(@WEEK7NONBILL,0),ISNULL(@WEEK7BILL,0),
ISNULL(@WEEK8NONBILL,0),ISNULL(@WEEK8BILL,0),
ISNULL(@WEEK9NONBILL,0),ISNULL(@WEEK9BILL,0),
ISNULL(@WEEK10NONBILL,0),ISNULL(@WEEK10BILL,0),
ISNULL(@WEEK11NONBILL,0),ISNULL(@WEEK11BILL,0),
ISNULL(@WEEK12NONBILL,0),ISNULL(@WEEK12BILL,0),ISNULL(@WEEK13NONBILL,0),ISNULL(@WEEK13BILL,0),
dateadd(day,7,@begdate)-1,
dateadd(day,14,@begdate)-1,dateadd(day,21,@begdate)-1,dateadd(day,28,@begdate)-1,dateadd(day,35,@begdate)-1,
dateadd(day,42,@begdate)-1,dateadd(day,49,@begdate)-1,dateadd(day,56,@begdate)-1,dateadd(day,63,@begdate)-1,
dateadd(day,70,@begdate)-1,dateadd(day,77,@begdate)-1,dateadd(day,84,@begdate)-1,dateadd(day,91,@begdate)-1)

select @RESOURCEID=105
select @RESOURCENAME=name from RESOURCES where RESOURCE_ID=@RESOURCEID

select @TOTALHOURSPAID=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE<= @begdate and SERVICE_LINE_DATE >= @BegYear

select @TOTALNONBILLABLEHOURS=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE<= @begdate and SERVICE_LINE_DATE >= @BegYear 
and left(TC_JOB_NO,3) = '599'
 
select @TOTALBILLABLEHOURS=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE<= @begdate and SERVICE_LINE_DATE >= @BegYear 
and left(TC_JOB_NO,3) <> '599'

select @WEEK1NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @begdate and SERVICE_LINE_DATE < @Week1Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK1BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @begdate and SERVICE_LINE_DATE < @Week1Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK2NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week1Beg and SERVICE_LINE_DATE < @Week2Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK2BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week1Beg and SERVICE_LINE_DATE < @Week2Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK3NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week2Beg and SERVICE_LINE_DATE < @Week3Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK3BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week2Beg and SERVICE_LINE_DATE < @Week3Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK4NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week3Beg and SERVICE_LINE_DATE < @Week4Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK4BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week3Beg and SERVICE_LINE_DATE < @Week4Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK5NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week4Beg and SERVICE_LINE_DATE < @Week5Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK5BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week4Beg and SERVICE_LINE_DATE < @Week5Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK6NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week5Beg and SERVICE_LINE_DATE < @Week6Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK6BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week5Beg and SERVICE_LINE_DATE < @Week6Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK7NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week6Beg and SERVICE_LINE_DATE < @Week7Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK7BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week6Beg and SERVICE_LINE_DATE < @Week7Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK8NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week7Beg and SERVICE_LINE_DATE < @Week8Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK8BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week7Beg and SERVICE_LINE_DATE < @Week8Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK9NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week8Beg and SERVICE_LINE_DATE < @Week9Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK9BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week8Beg and SERVICE_LINE_DATE < @Week9Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK10NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week9Beg and SERVICE_LINE_DATE < @Week10Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK10BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week9Beg and SERVICE_LINE_DATE < @Week10Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK11NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week10Beg and SERVICE_LINE_DATE < @Week11Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK11BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week10Beg and SERVICE_LINE_DATE < @Week11Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK12NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week11Beg and SERVICE_LINE_DATE < @Week12Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK12BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week11Beg and SERVICE_LINE_DATE < @Week12Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK13NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week12Beg and SERVICE_LINE_DATE < @Week13Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK13BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week12Beg and SERVICE_LINE_DATE < @Week13Beg 
and left(TC_JOB_NO,3) <> '599'

insert into #tbl values(@RESOURCEID,@RESOURCENAME,@TOTALHOURSPAID,
ISNULL(@TOTALNONBILLABLEHOURS,0),ISNULL(@TOTALBILLABLEHOURS,0),ISNULL(@WEEK1NONBILL,0),ISNULL(@WEEK1BILL,0),
ISNULL(@WEEK2NONBILL,0),ISNULL(@WEEK2BILL,0),ISNULL(@WEEK3NONBILL,0),ISNULL(@WEEK3BILL,0),ISNULL(@WEEK4NONBILL,0),ISNULL(@WEEK4BILL,0),
ISNULL(@WEEK5NONBILL,0),ISNULL(@WEEK5BILL,0),
ISNULL(@WEEK6NONBILL,0),ISNULL(@WEEK6BILL,0),
ISNULL(@WEEK7NONBILL,0),ISNULL(@WEEK7BILL,0),
ISNULL(@WEEK8NONBILL,0),ISNULL(@WEEK8BILL,0),
ISNULL(@WEEK9NONBILL,0),ISNULL(@WEEK9BILL,0),
ISNULL(@WEEK10NONBILL,0),ISNULL(@WEEK10BILL,0),
ISNULL(@WEEK11NONBILL,0),ISNULL(@WEEK11BILL,0),
ISNULL(@WEEK12NONBILL,0),ISNULL(@WEEK12BILL,0),ISNULL(@WEEK13NONBILL,0),ISNULL(@WEEK13BILL,0),
dateadd(day,7,@begdate)-1,
dateadd(day,14,@begdate)-1,dateadd(day,21,@begdate)-1,dateadd(day,28,@begdate)-1,dateadd(day,35,@begdate)-1,
dateadd(day,42,@begdate)-1,dateadd(day,49,@begdate)-1,dateadd(day,56,@begdate)-1,dateadd(day,63,@begdate)-1,
dateadd(day,70,@begdate)-1,dateadd(day,77,@begdate)-1,dateadd(day,84,@begdate)-1,dateadd(day,91,@begdate)-1)

select @RESOURCEID=158
select @RESOURCENAME=name from RESOURCES where RESOURCE_ID=@RESOURCEID

select @TOTALHOURSPAID=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE<= @begdate and SERVICE_LINE_DATE >= @BegYear

select @TOTALNONBILLABLEHOURS=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE<= @begdate and SERVICE_LINE_DATE >= @BegYear 
and left(TC_JOB_NO,3) = '599'
 
select @TOTALBILLABLEHOURS=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE<= @begdate and SERVICE_LINE_DATE >= @BegYear 
and left(TC_JOB_NO,3) <> '599'

select @WEEK1NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @begdate and SERVICE_LINE_DATE < @Week1Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK1BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @begdate and SERVICE_LINE_DATE < @Week1Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK2NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week1Beg and SERVICE_LINE_DATE < @Week2Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK2BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week1Beg and SERVICE_LINE_DATE < @Week2Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK3NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week2Beg and SERVICE_LINE_DATE < @Week3Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK3BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week2Beg and SERVICE_LINE_DATE < @Week3Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK4NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week3Beg and SERVICE_LINE_DATE < @Week4Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK4BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week3Beg and SERVICE_LINE_DATE < @Week4Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK5NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week4Beg and SERVICE_LINE_DATE < @Week5Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK5BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week4Beg and SERVICE_LINE_DATE < @Week5Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK6NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week5Beg and SERVICE_LINE_DATE < @Week6Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK6BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week5Beg and SERVICE_LINE_DATE < @Week6Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK7NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week6Beg and SERVICE_LINE_DATE < @Week7Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK7BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week6Beg and SERVICE_LINE_DATE < @Week7Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK8NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week7Beg and SERVICE_LINE_DATE < @Week8Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK8BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week7Beg and SERVICE_LINE_DATE < @Week8Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK9NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week8Beg and SERVICE_LINE_DATE < @Week9Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK9BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week8Beg and SERVICE_LINE_DATE < @Week9Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK10NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week9Beg and SERVICE_LINE_DATE < @Week10Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK10BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week9Beg and SERVICE_LINE_DATE < @Week10Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK11NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week10Beg and SERVICE_LINE_DATE < @Week11Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK11BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week10Beg and SERVICE_LINE_DATE < @Week11Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK12NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week11Beg and SERVICE_LINE_DATE < @Week12Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK12BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week11Beg and SERVICE_LINE_DATE < @Week12Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK13NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week12Beg and SERVICE_LINE_DATE < @Week13Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK13BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week12Beg and SERVICE_LINE_DATE < @Week13Beg 
and left(TC_JOB_NO,3) <> '599'

insert into #tbl values(@RESOURCEID,@RESOURCENAME,@TOTALHOURSPAID,
ISNULL(@TOTALNONBILLABLEHOURS,0),ISNULL(@TOTALBILLABLEHOURS,0),ISNULL(@WEEK1NONBILL,0),ISNULL(@WEEK1BILL,0),
ISNULL(@WEEK2NONBILL,0),ISNULL(@WEEK2BILL,0),ISNULL(@WEEK3NONBILL,0),ISNULL(@WEEK3BILL,0),ISNULL(@WEEK4NONBILL,0),ISNULL(@WEEK4BILL,0),
ISNULL(@WEEK5NONBILL,0),ISNULL(@WEEK5BILL,0),
ISNULL(@WEEK6NONBILL,0),ISNULL(@WEEK6BILL,0),
ISNULL(@WEEK7NONBILL,0),ISNULL(@WEEK7BILL,0),
ISNULL(@WEEK8NONBILL,0),ISNULL(@WEEK8BILL,0),
ISNULL(@WEEK9NONBILL,0),ISNULL(@WEEK9BILL,0),
ISNULL(@WEEK10NONBILL,0),ISNULL(@WEEK10BILL,0),
ISNULL(@WEEK11NONBILL,0),ISNULL(@WEEK11BILL,0),
ISNULL(@WEEK12NONBILL,0),ISNULL(@WEEK12BILL,0),ISNULL(@WEEK13NONBILL,0),ISNULL(@WEEK13BILL,0),
dateadd(day,7,@begdate)-1,
dateadd(day,14,@begdate)-1,dateadd(day,21,@begdate)-1,dateadd(day,28,@begdate)-1,dateadd(day,35,@begdate)-1,
dateadd(day,42,@begdate)-1,dateadd(day,49,@begdate)-1,dateadd(day,56,@begdate)-1,dateadd(day,63,@begdate)-1,
dateadd(day,70,@begdate)-1,dateadd(day,77,@begdate)-1,dateadd(day,84,@begdate)-1,dateadd(day,91,@begdate)-1)

select @RESOURCEID=636
select @RESOURCENAME=name from RESOURCES where RESOURCE_ID=@RESOURCEID

select @TOTALHOURSPAID=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE<= @begdate and SERVICE_LINE_DATE >= @BegYear

select @TOTALNONBILLABLEHOURS=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE<= @begdate and SERVICE_LINE_DATE >= @BegYear 
and left(TC_JOB_NO,3) = '599'
 
select @TOTALBILLABLEHOURS=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE<= @begdate and SERVICE_LINE_DATE >= @BegYear 
and left(TC_JOB_NO,3) <> '599'

select @WEEK1NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @begdate and SERVICE_LINE_DATE < @Week1Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK1BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @begdate and SERVICE_LINE_DATE < @Week1Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK2NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week1Beg and SERVICE_LINE_DATE < @Week2Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK2BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week1Beg and SERVICE_LINE_DATE < @Week2Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK3NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week2Beg and SERVICE_LINE_DATE < @Week3Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK3BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week2Beg and SERVICE_LINE_DATE < @Week3Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK4NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week3Beg and SERVICE_LINE_DATE < @Week4Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK4BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week3Beg and SERVICE_LINE_DATE < @Week4Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK5NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week4Beg and SERVICE_LINE_DATE < @Week5Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK5BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week4Beg and SERVICE_LINE_DATE < @Week5Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK6NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week5Beg and SERVICE_LINE_DATE < @Week6Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK6BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week5Beg and SERVICE_LINE_DATE < @Week6Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK7NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week6Beg and SERVICE_LINE_DATE < @Week7Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK7BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week6Beg and SERVICE_LINE_DATE < @Week7Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK8NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week7Beg and SERVICE_LINE_DATE < @Week8Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK8BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week7Beg and SERVICE_LINE_DATE < @Week8Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK9NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week8Beg and SERVICE_LINE_DATE < @Week9Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK9BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week8Beg and SERVICE_LINE_DATE < @Week9Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK10NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week9Beg and SERVICE_LINE_DATE < @Week10Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK10BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week9Beg and SERVICE_LINE_DATE < @Week10Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK11NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week10Beg and SERVICE_LINE_DATE < @Week11Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK11BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week10Beg and SERVICE_LINE_DATE < @Week11Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK12NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week11Beg and SERVICE_LINE_DATE < @Week12Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK12BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week11Beg and SERVICE_LINE_DATE < @Week12Beg 
and left(TC_JOB_NO,3) <> '599'

select @WEEK13NONBILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week12Beg and SERVICE_LINE_DATE < @Week13Beg 
and left(TC_JOB_NO,3) = '599'

select @WEEK13BILL=sum(BILL_QTY) from service_lines where resource_id=@RESOURCEID 
and SERVICE_LINE_DATE >= @Week12Beg and SERVICE_LINE_DATE < @Week13Beg 
and left(TC_JOB_NO,3) <> '599'

insert into #tbl values(@RESOURCEID,@RESOURCENAME,@TOTALHOURSPAID,
ISNULL(@TOTALNONBILLABLEHOURS,0),ISNULL(@TOTALBILLABLEHOURS,0),ISNULL(@WEEK1NONBILL,0),ISNULL(@WEEK1BILL,0),
ISNULL(@WEEK2NONBILL,0),ISNULL(@WEEK2BILL,0),ISNULL(@WEEK3NONBILL,0),ISNULL(@WEEK3BILL,0),ISNULL(@WEEK4NONBILL,0),ISNULL(@WEEK4BILL,0),
ISNULL(@WEEK5NONBILL,0),ISNULL(@WEEK5BILL,0),
ISNULL(@WEEK6NONBILL,0),ISNULL(@WEEK6BILL,0),
ISNULL(@WEEK7NONBILL,0),ISNULL(@WEEK7BILL,0),
ISNULL(@WEEK8NONBILL,0),ISNULL(@WEEK8BILL,0),
ISNULL(@WEEK9NONBILL,0),ISNULL(@WEEK9BILL,0),
ISNULL(@WEEK10NONBILL,0),ISNULL(@WEEK10BILL,0),
ISNULL(@WEEK11NONBILL,0),ISNULL(@WEEK11BILL,0),
ISNULL(@WEEK12NONBILL,0),ISNULL(@WEEK12BILL,0),ISNULL(@WEEK13NONBILL,0),ISNULL(@WEEK13BILL,0),
dateadd(day,7,@begdate)-1,
dateadd(day,14,@begdate)-1,dateadd(day,21,@begdate)-1,dateadd(day,28,@begdate)-1,dateadd(day,35,@begdate)-1,
dateadd(day,42,@begdate)-1,dateadd(day,49,@begdate)-1,dateadd(day,56,@begdate)-1,dateadd(day,63,@begdate)-1,
dateadd(day,70,@begdate)-1,dateadd(day,77,@begdate)-1,dateadd(day,84,@begdate)-1,dateadd(day,91,@begdate)-1)

select * from #tbl
drop table #tbl
GO
/****** Object:  Trigger [del_payroll_batch_line]    Script Date: 05/03/2010 14:18:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE TRIGGER [dbo].[del_payroll_batch_line] ON [dbo].[PAYROLL_BATCH_LINES] 
FOR DELETE 
AS

UPDATE service_lines SET payroll_exported_flag='N' WHERE service_line_id IN
(SELECT service_line_id FROM deleted)
GO
/****** Object:  Trigger [ins_payroll_batch_line]    Script Date: 05/03/2010 14:18:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE TRIGGER [dbo].[ins_payroll_batch_line] ON [dbo].[PAYROLL_BATCH_LINES] 
FOR INSERT
AS

UPDATE service_lines SET payroll_exported_flag='Y' WHERE service_line_id IN
(SELECT service_line_id FROM inserted)
GO
/****** Object:  Trigger [ins_upd_users]    Script Date: 05/03/2010 14:18:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[ins_upd_users] ON [dbo].[USERS] 
FOR INSERT, UPDATE
AS

DECLARE @user_id int
DECLARE @first_name varchar(100)
DECLARE @last_name varchar(100)

SELECT @user_id=user_id, @first_name=first_name, @last_name=last_name FROM inserted

UPDATE users SET full_name=@first_name+' '+@last_name WHERE user_id=@user_id
GO
/****** Object:  Trigger [d_users]    Script Date: 05/03/2010 14:18:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[d_users] ON [dbo].[USERS] 
FOR  DELETE 
AS

UPDATE resources SET attached_flag = 'N', user_id = null WHERE user_id in (SELECT u.user_id FROM users u, inserted i  WHERE u.user_id = i.user_id)
GO
/****** Object:  Trigger [res_sort_trigger]    Script Date: 05/03/2010 14:18:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE TRIGGER [dbo].[res_sort_trigger]
ON [dbo].[RESOURCES] FOR insert, update
AS

	DROP TABLE dbo.PDA_RESOURCE_SORT

	CREATE TABLE dbo.PDA_RESOURCE_SORT(
	row_number  int IDENTITY (1, 1),
	resource_id numeric(9) )

	INSERT INTO dbo.PDA_RESOURCE_SORT (resource_id)
	SELECT resource_id
	FROM resources
	ORDER BY name
GO
/****** Object:  Trigger [del_batch]    Script Date: 05/03/2010 14:18:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE TRIGGER [dbo].[del_batch] ON [dbo].[PAYROLL_BATCHES] 
FOR DELETE 
AS

DELETE FROM payroll_batch_lines WHERE int_batch_id in 
(SELECT int_batch_id FROM deleted)
GO
/****** Object:  Trigger [functions_d]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE TRIGGER [dbo].[functions_d] ON [dbo].[FUNCTIONS] 
INSTEAD OF DELETE 
AS
BEGIN
	DECLARE @function_id numeric;
	SELECT @function_id=function_id FROM deleted;
	DELETE FROM function_right_types where function_id=@function_id;
	DELETE FROM role_function_rights where function_id=@function_id;
	DELETE FROM functions where function_id=@function_id;
END
GO
/****** Object:  Trigger [functions_i]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[functions_i] ON [dbo].[FUNCTIONS] 
FOR INSERT
AS

DECLARE @function_id numeric;
DECLARE @created_by numeric;
SELECT @function_id = function_id, 
	 @created_by = created_by FROM inserted;

DECLARE @right_type_id numeric;
DECLARE right_types_cursor CURSOR FOR 
	SELECT right_type_id
	FROM right_types;

OPEN right_types_cursor;

FETCH NEXT FROM right_types_cursor 
	INTO @right_type_id

WHILE @@FETCH_STATUS = 0
BEGIN
	INSERT INTO function_right_types
	VALUES(@function_id, @right_type_id,'Y',getDate(), @created_by, null, null)
	FETCH NEXT FROM right_types_cursor 	
		INTO @right_type_id
END
CLOSE right_types_cursor
DEALLOCATE right_types_cursor
GO
/****** Object:  Trigger [functions_i_def]    Script Date: 05/03/2010 14:18:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[functions_i_def] ON [dbo].[FUNCTIONS] 
FOR INSERT
AS

DECLARE @function_id numeric
DECLARE @is_nav_function varchar
DECLARE @is_menu_function varchar

SELECT @function_id=function_id, 
	@is_nav_function=is_nav_function, 
	@is_menu_function=is_menu_function
FROM inserted

if( @is_nav_function is null )
	set @is_nav_function = 'N';
if( @is_menu_function is null)
	set @is_menu_function = 'N';

UPDATE functions SET
	is_nav_function=@is_nav_function,
	is_menu_function=@is_menu_function
WHERE function_id = @function_id;
GO
/****** Object:  UserDefinedFunction [dbo].[fn_FurnitureLineListPerProjectID]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_FurnitureLineListPerProjectID] (@project_id int)
RETURNS varchar(8000)
AS
BEGIN
/**************************************************
    2007-12-10
    Created by Robert Smith for use in reporting off
    ServiceTRAX software for Omni Workspace. This
	function takes the project_id as a parameter
	and then returns a comma delimited list of the 
	service furniture lines.
***************************************************/

/*DECARE THE VARIABLE VALUE TO RETURN AND OTHERS*/
declare @FurnitureLines	varchar(8000)
set @FurnitureLines = ''

/*PUT ALL DISTINCT FURNITURE LINE VALUES INTO VARIABLE*/
select @FurnitureLines = isnull(@FurnitureLines,'') + ', ' + isnull(fl.name,'')
from (
		select distinct l.name
		from requests as r (nolock)
			inner join lookups as l (nolock) on r.system_furniture_line_type_id = l.lookup_id
		where r.is_sent = 'y' and r.project_id = @project_id
		) as fl
/*GETTING RID OF FIRST COMMA AND SPACE*/
set @FurnitureLines = substring(@FurnitureLines,3,len(@FurnitureLines))
/*RETURN NULL IF BLANK STRING*/
set @FurnitureLines = case when @FurnitureLines = '' then NULL else @FurnitureLines end


   RETURN(@FurnitureLines)
END
GO
/****** Object:  StoredProcedure [dbo].[getNextVal]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
/*  used to return next_val of sequence, and increment next_val by 1 */
CREATE procedure [dbo].[getNextVal] 
	@@seq_name varchar(50),
	@@seq_num numeric OUTPUT
as
begin transaction
	select @@seq_num = next_val from dbo.sequences
		where seq_name = @@seq_name;
	update dbo.sequences set next_val = (@@seq_num+1)
		where seq_name = @@seq_name;
	commit
GO
/****** Object:  Trigger [del_inv_line_no]    Script Date: 05/03/2010 14:18:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[del_inv_line_no] ON [dbo].[INVOICE_LINES] 
FOR DELETE 
AS

  DECLARE @invoice_line_id int

  SELECT @invoice_line_id = invoice_line_id
     FROM  Inserted

  DELETE FROM serv_inv_lines
   WHERE invoice_line_id = @invoice_line_id
GO
/****** Object:  Trigger [del_job_loc]    Script Date: 05/03/2010 14:18:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[del_job_loc] ON [dbo].[JOB_LOCATIONS] 
instead of  DELETE 
AS

update services set job_location_id = null where service_id in (select service_id from services where job_location_id in (select job_location_id from deleted))
delete from job_locations where job_location_id in (select job_location_id from deleted);
GO
/****** Object:  Trigger [sch_resources_i]    Script Date: 05/03/2010 14:18:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE TRIGGER [dbo].[sch_resources_i] ON [dbo].[SCH_RESOURCES] 
FOR INSERT
AS

DECLARE @weekend_flag as VARCHAR
DECLARE @sch_resource_id as NUMERIC
DECLARE @weekend_sch_resource_id as NUMERIC

SELECT @weekend_flag=weekend_flag,
	@sch_resource_id=sch_resource_id,
	@weekend_sch_resource_id=weekend_sch_resource_id
FROM inserted

if( @weekend_flag = 'Y'  AND  @weekend_sch_resource_id is null )
	UPDATE sch_resources 
		SET weekend_sch_resource_id = @sch_resource_id
		WHERE sch_resource_id = @sch_resource_id;
GO
/****** Object:  Trigger [del_job_distributions]    Script Date: 05/03/2010 14:18:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE TRIGGER [dbo].[del_job_distributions] ON [dbo].[JOB_DISTRIBUTIONS] 
FOR DELETE 
AS

UPDATE    SCH_RESOURCES
SET              SEND_TO_PDA_FLAG = 'N'
WHERE     (SCH_RESOURCE_ID IN 
                          (SELECT     sch_resource_id
                            FROM          DELETED
                            WHERE      remove_date < getDate()))
GO
/****** Object:  Trigger [del_exp_batch]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE TRIGGER [dbo].[del_exp_batch] ON [dbo].[EXPENSES_BATCHES] 
FOR  DELETE 
AS

DELETE FROM expenses_batch_lines WHERE int_batch_id IN 
(SELECT int_batch_id FROM deleted)
GO
/****** Object:  StoredProcedure [dbo].[ottSOPIntegrationPrepMadison]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ottSOPIntegrationPrepMadison] AS

/*
Nearly the same as the Minneapolis stored proc, only an organization ID of 4 instead of 2
and a where clause on the lines SQL statement
*/


--CREATE HEADER TABLE
if exists(SELECT Name from SYSOBJECTS WHERE NAME='ottInvHeaderTEMP_Madison')
	begin
	DROP TABLE ottInvHeaderTEMP_Madison
	end

SELECT INVOICES.INVOICE_ID, JOBS_V.JOB_NO, JOBS_V.BILLING_USER_NAME, 
	CAST(INVOICES.INVOICE_ID AS VARCHAR) DOCUMENT_NO, INVOICES.EXT_BATCH_ID,
	UPPER(INVOICES.GP_DESCRIPTION) DESCRIPTION, INVOICES.PO_NO, INVOICES.EXT_BILL_CUST_ID, INVOICES.SALES_REPS, 
	(CASE WHEN JOBS_V.JOB_TYPE_CODE ='service_account' THEN NULL ELSE INVOICES.START_DATE END) start_date, 
	(CASE WHEN JOBS_V.JOB_TYPE_CODE = 'service_account' THEN NULL ELSE INVOICES.END_DATE END) end_date, 
	INVOICE_TYPES_V.NAME, UPPER(JOBS_V.JOB_NAME) JOB_NAME, UPPER(JOBS_V.CUSTOMER_NAME) CUSTOMER_NAME, 
	JOBS_V.JOB_TYPE_CODE,INVOICES.COST_CODES 
INTO ottInvHeaderTEMP_Madison
FROM INVOICES, INVOICE_TYPES_V, JOBS_V 
WHERE INVOICES.INVOICE_TYPE_ID = INVOICE_TYPES_V.LOOKUP_ID AND STATUS_ID = 4 AND BATCH_STATUS_ID = 2 
	AND INVOICES.JOB_ID = JOBS_V.JOB_ID and invoices.organization_id=4

--CREATE LINES TABLE
if exists(SELECT Name from SYSOBJECTS WHERE NAME='ottInvLineTEMP_Madison')
	begin
	DROP TABLE ottInvLineTEMP_Madison
	end

Select INVOICE_LINES_V.INVOICE_ID, INVOICE_LINES_V.UNIT_PRICE, INVOICE_LINES_V.QTY, INVOICE_LINES_V.LINE_DESC, 
	INVOICE_LINES_V.EXT_ITEM_ID 
INTO ottInvLineTEMP_Madison
From INVOICE_LINES_V 
INNER JOIN ottInvHeaderTEMP_Madison ON ottInvHeaderTEMP_Madison.INVOICE_ID = INVOICE_LINES_V.INVOICE_ID
WHERE INVOICE_LINES_V.EXT_ITEM_ID NOT IN ('Delivery Piece Count -Reg', 'Delivery Piece Count -OT', 'Truck PIECE COUNT', 'WAREHOUSE PIECE COUNT', 'WAREHOUSE PIECE COUNT -OT')
ORDER BY INVOICE_LINES_V.INVOICE_ID

/*
NO TAXES FOR MADISON INTEGRATION

--CREATE TAXES TABLE
if exists(SELECT Name from SYSOBJECTS WHERE NAME='ottInvTaxesTEMP_Madison')
	begin
	DROP TABLE ottInvTaxesTEMP_Madison
	end

Select Taxes_V_Sum.* 
INTO ottInvTaxesTEMP_Madison
From Taxes_V_Sum 
INNER JOIN ottInvHeaderTEMP ON ottInvHeaderTEMP.INVOICE_ID = Taxes_V_Sum.INVOICE_ID
ORDER BY Taxes_V_Sum.INVOICE_ID
*/
GO
/****** Object:  StoredProcedure [dbo].[sp_aia_direct_end_user]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_aia_direct_end_user]
AS
BEGIN

DECLARE @customer_id numeric(18,0)
DECLARE @end_user_id numeric(18,0)
DECLARE @c1 CURSOR

SET @c1 = CURSOR FAST_FORWARD
FOR
SELECT DISTINCT c.customer_id,eu.customer_id
  FROM customers eu JOIN
       customers c ON eu.customer_name=c.customer_name
 WHERE c.customer_type_id IN (735,736,737)
   AND eu.customer_type_id=738
   AND c.customer_id <> eu.end_user_parent_id
   AND c.active_flag='y'
   and eu.active_flag='y'
   and c.organization_id=8
   and eu.organization_id=8
   and c.ext_customer_id not like 'old%'
   and eu.created_by=1
order by eu.customer_id


OPEN @c1
FETCH NEXT FROM @c1 INTO @customer_id,@end_user_id

WHILE @@FETCH_STATUS=0
BEGIN
  UPDATE customers 
     SET end_user_parent_id=@customer_id,
         date_modified=getdate(),
         modified_by=1
   WHERE customer_type_id = 738
     AND organization_id=8
     AND customer_id = @end_user_id
     
  FETCH NEXT FROM @c1  INTO @customer_id,@end_user_id
END

CLOSE @c1
DEALLOCATE @c1

END
GO
/****** Object:  StoredProcedure [dbo].[sp_delete_duplicate_customers]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_delete_duplicate_customers]
AS
BEGIN

DECLARE @ext_customer_id CHAR(15)
DECLARE @service_id numeric(18,0)
DECLARE @c1 CURSOR

SET @c1 = CURSOR FAST_FORWARD
FOR
SELECT ext_customer_id
  FROM customers
 WHERE organization_id = 16
GROUP BY ext_customer_id
HAVING COUNT(*) > 1
ORDER BY ext_customer_id


OPEN @c1
FETCH NEXT FROM @c1 INTO @ext_customer_id

WHILE @@FETCH_STATUS=0
BEGIN
  PRINT @ext_customer_id
  
  DELETE FROM customers
   WHERE customer_id = (SELECT MIN(customer_id)
                          FROM customers
                         WHERE organization_id = 16
                           AND ext_customer_id = @ext_customer_id)
                             
  FETCH NEXT FROM @c1 INTO @ext_customer_id
END

CLOSE @c1
DEALLOCATE @c1

END
GO
/****** Object:  Trigger [iu_job_item_rates]    Script Date: 05/03/2010 14:18:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE TRIGGER [dbo].[iu_job_item_rates] ON [dbo].[JOB_ITEM_RATES] 
FOR INSERT, UPDATE 
AS

DECLARE @internal_req_flag varchar
 
/*
UPDATE service_lines
SET tc_rate = i.rate
FROM inserted i
WHERE i.job_id = service_lines.tc_job_id AND i.item_id = service_lines.item_id 

UPDATE service_lines
SET bill_rate = i.rate
FROM inserted i
WHERE i.job_id = service_lines.bill_job_id AND i.item_id = service_lines.item_id 
*/
GO
/****** Object:  UserDefinedFunction [dbo].[fn_ProjectManagerListPerProjectID]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_ProjectManagerListPerProjectID] (@project_id int)
RETURNS varchar(8000)
AS
BEGIN
/**************************************************
    2007-12-10
    Created by Robert Smith for use in reporting off
    ServiceTRAX software for Omni Workspace. This
	function takes the project_id as a parameter
	and then returns a comma delimited list of the 
	project managers for that project_id.
***************************************************/

/*DECARE THE VARIABLE VALUE TO RETURN AND OTHERS*/
declare @ProjectManagers	varchar(8000)
set @ProjectManagers = ''

/*PUT ALL DISTINCT FURNITURE LINE VALUES INTO VARIABLE*/
select @ProjectManagers = isnull(@ProjectManagers,'') + ', ' + isnull(data.name,'')
from (
		select distinct 'name' = rtrim(ltrim(project_manager.contact_name))
		from requests as r (nolock)
			inner join contacts as project_manager (nolock) on r.a_m_contact_id = project_manager.contact_id
		where r.is_sent = 'y' and r.project_id = @project_id
		) as data
/*GETTING RID OF FIRST COMMA AND SPACE*/
set @ProjectManagers = substring(@ProjectManagers,3,len(@ProjectManagers))
/*RETURN NULL IF BLANK STRING*/
set @ProjectManagers = case when @ProjectManagers = '' then NULL else @ProjectManagers end


   RETURN(@ProjectManagers)
END
GO
/****** Object:  UserDefinedFunction [dbo].[sp_contact_phone]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[sp_contact_phone] (@in_contact_id numeric(18,0)) RETURNS varchar(100)
AS
BEGIN

DECLARE @phone_w varchar(50)
DECLARE @phone_c varchar(50)
DECLARE @phone_h varchar(50)
DECLARE @contact_phones CURSOR
DECLARE @result varchar(100)

SET @result = ''

SET @contact_phones = CURSOR FAST_FORWARD
FOR
SELECT phone_work,
       phone_cell,
       phone_home
  FROM contacts 
 WHERE contact_id = @in_contact_id


OPEN @contact_phones
FETCH NEXT FROM @contact_phones INTO @phone_w,@phone_c,@phone_h

WHILE @@FETCH_STATUS=0
BEGIN
  
  IF @phone_w IS NOT NULL
    BEGIN
      SET @result = @phone_w + '(W)'
      
      IF @phone_c IS NOT NULL
        BEGIN
          SET @result = @result + ', ' + @phone_c + '(C)'
        END 
    END
  ELSE 
    BEGIN
      IF @phone_c IS NOT NULL
        BEGIN
          SET @result = @phone_c + '(C)'
        END
      ELSE
        IF @phone_h IS NOT NULL
          BEGIN 
            SET @result = @phone_h + '(H)'
          END
    END
     
  FETCH NEXT FROM @contact_phones INTO @phone_w,@phone_c,@phone_h 
END

CLOSE @contact_phones
DEALLOCATE @contact_phones

RETURN @result

END
GO
/****** Object:  Trigger [iu_service_lines]    Script Date: 05/03/2010 14:18:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[iu_service_lines] ON [dbo].[SERVICE_LINES] 
FOR INSERT, UPDATE
AS

print ('------------------------------------')  
print ('iu_service_lines trigger')  
print ('------------------------------------')  

  DECLARE @allocated_qty numeric(18,2)
  DECLARE @bill_exp_qty numeric(18,2)
  DECLARE @bill_exp_rate numeric(18,3)
  DECLARE @bill_hourly_qty numeric(18,2)
  DECLARE @bill_hourly_rate numeric(18,3)
  DECLARE @bill_job_id int
  DECLARE @bill_job_no numeric(18,2) 
  DECLARE @bill_qty numeric(18,2)
  DECLARE @bill_rate numeric(18,3)
  DECLARE @bill_service_id int
  DECLARE @bill_service_line_no int
  DECLARE @bill_service_no numeric(18,2)
  DECLARE @billable_flag varchar
  DECLARE @billed_flag varchar
  DECLARE @expense_qty numeric(18,2)
  DECLARE @expense_rate numeric(18,3)
  DECLARE @expenses_exported_flag varchar
  DECLARE @exported_flag varchar
  DECLARE @fully_allocated_flag varchar
  DECLARE @invoice_id numeric
  DECLARE @inserting varchar
  DECLARE @internal_req_flag varchar
  DECLARE @item_id int
  DECLARE @item_name varchar(200)
  DECLARE @item_type_code varchar(30)
  DECLARE @new_rate numeric(18,3)
  DECLARE @old_allocated_qty numeric(18,2)
  DECLARE @old_bill_qty numeric(18,2)
  DECLARE @old_bill_rate numeric(18,3)
  DECLARE @old_bill_job_id int
  DECLARE @old_bill_service_id int
  DECLARE @old_expense_qty numeric(18,2)
  DECLARE @old_expense_rate numeric(18,3)
  DECLARE @old_item_id numeric
  DECLARE @old_item_name varchar(200)
  DECLARE @old_payroll_qty numeric(18,2)
  DECLARE @old_payroll_rate numeric(18,3)
  DECLARE @old_resource_id int
  DECLARE @old_service_line_id int
  DECLARE @old_tc_qty numeric(18,2)
  DECLARE @old_tc_rate numeric(18,3)
  DECLARE @old_tc_job_id int
  DECLARE @old_tc_service_id int
  DECLARE @new_billable_flag varchar
  DECLARE @organization_id numeric
  DECLARE @partially_allocated_flag varchar
  DECLARE @payroll_exported_flag varchar
  DECLARE @payroll_qty numeric(18,2)
  DECLARE @payroll_rate numeric(18,3)
  DECLARE @ph_service_id numeric
  DECLARE @pooled_flag varchar
  DECLARE @posted_flag varchar
  DECLARE @resource_id int
  DECLARE @resource_name varchar(200)
  DECLARE @service_line_id int
  DECLARE @service_status_type_code varchar(50)
  DECLARE @sl_type_a_m_id int
  DECLARE @status_id int
  DECLARE @taxable_flag varchar
  DECLARE @tc_job_id int
  DECLARE @tc_job_no numeric(18,2) 
  DECLARE @tc_qty numeric(18,2)
  DECLARE @tc_rate numeric(18,3)
  DECLARE @rate_change varchar
  DECLARE @tc_service_id int
  DECLARE @tc_service_line_no int
  DECLARE @tc_service_no numeric(18,2)

DECLARE sl_cursor CURSOR LOCAL  FAST_FORWARD FOR
  SELECT 
allocated_qty,
bill_qty,
bill_rate,
bill_hourly_qty,
bill_hourly_rate,
bill_exp_qty,
bill_exp_rate,
bill_job_id,
bill_job_no,
bill_service_line_no,
bill_service_id,
billable_flag,
billed_flag, 
expenses_exported_flag,
expense_qty,
expense_rate,
exported_flag,
fully_allocated_flag,
internal_req_flag,
invoice_id,
item_id,
item_name,
partially_allocated_flag,
payroll_exported_flag,
payroll_qty,
payroll_rate,
ph_service_id,
posted_flag, 
resource_id,
resource_name,
service_line_id,
status_id,
taxable_flag,
tc_job_id,
tc_job_no,
tc_qty,
tc_rate,
tc_service_id,
tc_service_line_no
  FROM  Inserted as NEW

OPEN sl_cursor

-- Perform the first fetch.
FETCH NEXT FROM sl_cursor
INTO
@allocated_qty,
@bill_qty,
@bill_rate,
@bill_hourly_qty,
@bill_hourly_rate,
@bill_exp_qty,
@bill_exp_rate,
@bill_job_id,
@bill_job_no,
@bill_service_line_no,
@bill_service_id,
@billable_flag,
@billed_flag, 
@expenses_exported_flag,
@expense_qty,
@expense_rate,
@exported_flag,
@fully_allocated_flag,
@internal_req_flag,
@invoice_id,
@item_id,
@item_name,
@partially_allocated_flag,
@payroll_exported_flag,
@payroll_qty,
@payroll_rate,
@ph_service_id,
@posted_flag, 
@resource_id,
@resource_name,
@service_line_id,
@status_id,
@taxable_flag,
@tc_job_id,
@tc_job_no,
@tc_qty,
@tc_rate,
@tc_service_id,
@tc_service_line_no

WHILE (@@FETCH_STATUS = 0)
BEGIN

  /* USED IN THE UPCOMING SECTIONS */
  SELECT 
	@old_allocated_qty = allocated_qty,
	@old_bill_qty = bill_qty,
	@old_bill_rate = bill_rate,
	@old_bill_job_id = bill_job_id,
	@old_bill_service_id = bill_service_id,
	@old_item_id = item_id,
	@old_item_name = item_name,
	@old_resource_id = resource_id,
	@old_tc_qty = tc_qty,
	@old_tc_rate = tc_rate,
	@old_tc_job_id = tc_job_id,
	@old_tc_service_id = tc_service_id,
	@old_service_line_id = service_line_id
  FROM deleted
  WHERE service_line_id = @service_line_id

IF( @old_allocated_qty IS NULL)  SET @old_allocated_qty = 0
IF( @old_bill_qty IS NULL)  SET @old_bill_qty = 0
IF( @old_bill_rate IS NULL)  SET @old_bill_rate = 0
IF( @old_bill_job_id IS NULL)  SET @old_bill_job_id = 0
IF( @old_bill_service_id IS NULL)  SET @old_bill_service_id = 0
IF( @old_item_id IS NULL)  SET @old_item_id = 0
IF( @old_resource_id IS NULL)  SET @old_resource_id = 0
IF( @old_tc_qty IS NULL)  SET @old_tc_qty = 0
IF( @old_tc_rate IS NULL)  SET @old_tc_rate = 0
IF( @old_tc_job_id IS NULL)  SET @old_tc_job_id = 0
IF( @old_tc_service_id IS NULL)  SET @old_tc_service_id = 0
IF( @taxable_flag IS NULL ) SET @taxable_flag = 'N'
  /*TEST TO SEE IF THERE WAS A DELETED, IF NOT WE ARE INSERTING */
  IF( @old_service_line_id IS NULL)
    set @inserting = 'Y'
 ELSE
    set @inserting = 'N'

  /* HANDLE INTERNAL_REQ_FLAG */
  SELECT 
	@internal_req_flag = s.internal_req_flag, 
	@service_status_type_code = t.lookup_code
     FROM services s, service_status_types_v t
     WHERE s.service_id = @tc_service_id AND s.serv_status_type_id = t.lookup_id

  /* HANDLE POOLED_FLAG */
  IF( @fully_allocated_flag = 'Y' OR @partially_allocated_flag = 'Y' OR @ph_service_id IS NOT NULL)
    SET @pooled_flag = 'Y'
  ELSE
    SET @pooled_flag = 'N'

  /* GET RESOURCE INFO */
  SELECT 
	@resource_name = name
  FROM resources
  WHERE resource_id = @resource_id

  /* GET ITEM INFO FOR BILLABLE_FLAG AND QTY/RATE SECTION */
  SELECT 
	@organization_id = organization_id,
	@item_type_code = item_type_code ,
	@new_billable_flag = billable_flag,
	@item_name = name
  FROM items_v
  WHERE item_id = @item_id

PRINT(' tc_qty = '+cast(ISNULL(@tc_qty,0) as varchar(30)))
PRINT(' tc_rate = '+cast(ISNULL(@tc_rate,0) as varchar(30)))
PRINT(' old_tc_qty = '+cast(ISNULL(@old_tc_qty,0) as varchar(30)) )
PRINT(' old_tc_rate = '+cast(ISNULL(@old_tc_rate,0) as varchar(30)))
PRINT(' item_type_code = '+ cast(ISNULL(@item_type_code,'none') as varchar(30)))
PRINT(' bill_qty = '+cast(ISNULL(@bill_qty,0) as varchar(30)))
PRINT(' bill_rate = '+cast(ISNULL(@bill_rate,0) as varchar(30)))
PRINT(' old_bill_qty = '+cast(ISNULL(@old_bill_qty,0) as varchar(30)) )
PRINT(' old_bill_rate = '+cast(ISNULL(@old_bill_rate,0) as varchar(30)))

  /* HANDLE ITEM UPDATE: BILLABLE_FLAG */
  IF( @item_id <> @old_item_id OR @inserting = 'Y' )
  BEGIN
    IF( (@pooled_flag = 'N' AND @billed_flag = 'N' AND @posted_flag = 'N' ) OR @inserting = 'Y')
      SET @billable_flag = @new_billable_flag;
    ELSE IF( @inserting = 'N' ) 
    BEGIN
      PRINT('setting item_id '+cast(@item_id as varchar(10))+' back to '+cast(@old_item_id as varchar(10)))
      SET @item_id = @old_item_id  
    END
  END

  /* HANDLE RESOURCE UPDATE: RESOURCE_NAME */
  IF( @resource_id <> @old_resource_id )
  BEGIN
    IF( (@pooled_flag = 'Y' OR @billed_flag = 'Y' OR @posted_flag = 'Y') AND @inserting = 'N' )
    BEGIN
      PRINT('setting resource_id '+cast(@resource_id as varchar(10))+' back to '+cast(@old_resource_id as varchar(10)))
      SET @resource_id = @old_resource_id  
    END
  END

  /* HANDLE TC_SERVICE_ID AND LINE NUMBER UPDATE */
  IF( @tc_service_id <> @old_tc_service_id )
  BEGIN
    IF( ( @pooled_flag = 'N' ) OR @inserting = 'Y' )
    BEGIN
    /* new service means new line_no */
      PRINT('Setting tc line no')
      SELECT @tc_service_line_no = ISNULL(MAX(tc_service_line_no),0)+1
        FROM service_lines
        WHERE tc_service_id = @tc_service_id AND service_line_id != @service_line_id

      /*update bill_service_id if old tc_service same as old bill service and pooled or posted */
      IF( (@old_bill_service_id = @old_tc_service_id AND @pooled_flag = 'N' AND @posted_flag = 'N' ) OR @inserting = 'Y' )
      BEGIN
        PRINT('copying tc_service_id and tc_job_id into bill_service_id and bill_job_id')
        SET @bill_service_id = @tc_service_id
        SET @bill_job_id = @tc_job_id
      END
    END
 ELSE
    BEGIN
      PRINT('setting tc_service_id '+cast(@tc_service_id as varchar(10))+' back to '+cast(@old_tc_service_id as varchar(10)))
      SET @tc_service_id = @old_tc_service_id
    END
  END

  /* HANDLE BILL_SERVICE_ID AND LINE NUMBER UPDATE */
  IF( @bill_service_id <> @old_bill_service_id  )
  BEGIN
    IF( (@posted_flag = 'N') OR @inserting = 'Y' )
    BEGIN
    /* new service means new line_no */
      PRINT('Setting bill line no')
      SELECT @bill_service_line_no = ISNULL(MAX(bill_service_line_no),0)+1
        FROM service_lines
        WHERE bill_service_id = @bill_service_id AND service_line_id != @service_line_id
    END
    ELSE
    BEGIN
      PRINT('setting bill_service_id '+cast(@bill_service_id as varchar(10))+' back to '+cast(@old_bill_service_id as varchar(10)))
      SET @bill_service_id = @old_bill_service_id
    END
  END

  /* HANDLE TC_JOB_NO and TC_SERVICE_NO */
  SELECT @tc_job_id = j.job_id, @tc_job_no = j.job_no, @tc_service_no = s.service_no 
    FROM services s, jobs j  
    WHERE j.job_id = s.job_id and s.service_id = @tc_service_id; 

  /* HANDLE BILL_JOB_NO and BILL_SERVICE_NO */
  SELECT @bill_job_id = j.job_id, @bill_job_no = j.job_no, @bill_service_no = s.service_no 
    FROM services s, jobs j  
    WHERE j.job_id = s.job_id AND s.service_id = @bill_service_id; 

 /* UPDATED ALLOCATED_QTY, IF FULLY_ALLOCATED CHANGE STATUS TO 3 TO DISTINGUISH ALLOCATED FROM 4 SUBMITTED TO BILLING */
  IF( @allocated_qty != @old_allocated_qty AND @status_id = 4 AND @fully_allocated_flag = 'Y' )
	SET @status_id = 3;
  ELSE IF( @status_id = 3 AND @fully_allocated_flag = 'N')
	SET @status_id = 4;

  /* UPDATED ITEM_ID OR TC_SERVICE_ID or INSERTING HOURLY LINE so GET NEW JOB ITEM RATE */
  IF( @item_id <> @old_item_id  OR @tc_job_id <> @old_tc_job_id  )
  BEGIN
    IF( @item_type_code = 'hours'  AND @pooled_flag = 'N')
    BEGIN
      SELECT TOP 1 @new_rate = RATE
      FROM  dbo.JOB_ITEM_RATES
      WHERE JOB_ID = @tc_job_id AND ITEM_ID = @item_id  
print('new rate = ' + cast(isnull(@new_rate,0) as varchar(10)))
      IF( @new_rate is not null )
      BEGIN  
          PRINT('changed tc_rate from '+cast(ISNULL(@tc_rate,0) as varchar(10))+' to '+cast(ISNULL(@new_rate,0) as varchar(10)))
          SET @tc_rate = @new_rate
          /*updating tc_rate updates all other rates based on the correct logic down below*/
      END
    END
  END

  /* UPDATED ITEM_ID OR BILL_SERVICE_ID  OR IT IS A NEW LINE so GET NEW JOB ITEM RATE */
  IF( @item_id <> @old_item_id  OR @bill_job_id <> @old_bill_job_id  )
  BEGIN
    IF( @pooled_flag = 'N' AND @posted_flag = 'N' AND @billed_flag ='N' AND (NOT UPDATE(tc_rate) OR @bill_rate IS NULL OR @bill_rate = 0) )
    BEGIN
      SELECT TOP 1 @new_rate = RATE
        FROM  dbo.JOB_ITEM_RATES
        WHERE JOB_ID = @bill_job_id AND ITEM_ID = @item_id  
      IF( @new_rate <> 0 AND NOT @item_type_code ='expense' )
      BEGIN
        PRINT('changed bill_rate from '+cast(ISNULL(@bill_rate,0) as varchar(10))+' to '+cast(ISNULL(@new_rate,0) as varchar(10)))
        SET @bill_rate = @new_rate
      END
    END
  END

  /* HANDLE TIME CAPTURE UPDATE OF RATE OR QTY*/
  IF( @tc_qty <> @old_tc_qty OR @tc_rate <> @old_tc_rate OR @item_id <> @old_item_id  OR @tc_job_id <> @old_tc_job_id )

  BEGIN
PRINT('in qty rate update for time')
      /* hours, if we are in time capture and payroll has not been exported then update payroll*/
      IF( @item_type_code = 'hours' AND (( @pooled_flag = 'N' ) OR @inserting = 'Y'))
      BEGIN
         SET @payroll_qty = @tc_qty
         SET @payroll_rate = @tc_rate
         SET @expense_qty = 0
         SET @expense_rate = 0
      END
      ELSE /* expense, if we are in time capture and expenses have not been exported then update expenses*/
      IF( @item_type_code = 'expense' AND (( @pooled_flag = 'N' ) OR @inserting = 'Y'))
      BEGIN
         SET @expense_qty = @tc_qty
         SET @expense_rate = @tc_rate
         SET @payroll_qty = 0
         SET @payroll_rate = 0
      END
      ELSE /* should not update TC_QTY and TC_RATE since nothing changes */
      BEGIN
PRINT('tc getting set back to old_tc_qty and rate');
         SET @tc_qty = @old_tc_qty
         SET @tc_rate = @old_tc_rate
      END

      /* hours, copy tc hours to billing */
      IF( @item_type_code = 'hours'  AND (
	(@pooled_flag = 'N' AND @posted_flag = 'N' AND @billed_flag = 'N' AND (@tc_qty <> @old_tc_qty OR @tc_rate <> @old_tc_rate))
       OR (@inserting = 'Y' AND @pooled_flag = 'N' AND (@tc_qty <> @old_tc_qty OR @tc_rate <> @old_tc_rate)) ) )
      BEGIN
PRINT('TC HOURS, setting billing qty and rates using tc qty and rates');
        SET @bill_qty = @tc_qty
        SET @bill_rate = @tc_rate
        SET @bill_hourly_qty = @tc_qty
        SET @bill_hourly_rate = @tc_rate
        SET @bill_exp_qty = 0
        SET @bill_exp_rate = 0
      END
      ELSE /* expense, if changing bill rate */
      IF( @tc_job_id IS NOT NULL AND @item_type_code = 'expense'  AND @pooled_flag = 'N' AND @posted_flag = 'N' AND @billed_flag = 'N')
      BEGIN
PRINT('TC EXP, setting billing qty and rates using tc qty and rates');
        SET @bill_qty = @tc_qty
        SET @bill_hourly_qty = 0
        SET @bill_exp_qty = @tc_qty
        SET @bill_exp_rate = @bill_rate
        SET @bill_hourly_rate = 0
      END
  END

  /* HANDLE BILLING UPDATE OF QTY*/
  IF( @bill_qty <> @old_bill_qty  OR @item_id <> @old_item_id  OR @bill_job_id <> @old_bill_job_id )
  BEGIN
PRINT('in qty update for bill')
    IF( @item_type_code = 'hours' AND ((@pooled_flag = 'N' AND @posted_flag = 'N')  OR @inserting='Y'))
    BEGIN
      SET @bill_hourly_qty = @bill_qty
      SET @bill_exp_qty = 0
    END	
    ELSE IF( @item_type_code = 'expense' AND ((@pooled_flag = 'N' AND @posted_flag = 'N' )  OR @inserting='Y'))
    BEGIN
      SET @bill_exp_qty = @bill_qty
      SET @bill_hourly_qty = 0
    END
    ELSE /* should not update BILL_QTY  since nothing changes */
    BEGIN
PRINT('bill getting set back to old_bill_qty');
       SET @bill_qty = @old_bill_qty
    END
  END

  /* HANDLE BILLING UPDATE OF RATE*/
  IF( @bill_rate <> @old_bill_rate OR @item_id <> @old_item_id OR @bill_job_id <> @old_bill_job_id )
  BEGIN
PRINT('in bill rate update')
    IF( @item_type_code = 'hours' AND ((@pooled_flag = 'N' AND @posted_flag = 'N' AND @billed_flag ='N')  OR @inserting='Y'))
    BEGIN
      SET @bill_hourly_rate = @bill_rate
      SET @bill_exp_rate = 0
    END	
    ELSE IF( @item_type_code = 'expense' AND ((@pooled_flag = 'N' AND @posted_flag = 'N'  AND @billed_flag ='N')  OR @inserting='Y'))
    BEGIN
      SET @bill_exp_rate = @bill_rate
      SET @bill_hourly_rate = 0
    END
    ELSE /* should not update  BILL_RATE since nothing changes */
    BEGIN
PRINT('bill getting set back to old_bill_rate');
       SET @bill_rate = @old_bill_rate
    END
  END


  UPDATE service_lines
  SET 
	bill_qty = @bill_qty,
	bill_rate = @bill_rate,
	bill_exp_qty = @bill_exp_qty,
	bill_exp_rate = @bill_exp_rate,
	bill_hourly_qty = @bill_hourly_qty,
	bill_hourly_rate = @bill_hourly_rate,
	bill_job_id = @bill_job_id,
	bill_job_no = @bill_job_no,
	bill_service_id = @bill_service_id,
	bill_service_line_no = @bill_service_line_no,
	bill_service_no = @bill_service_no,
	billable_flag = @billable_flag,
	expense_qty = @expense_qty,
	expense_rate = @expense_rate,
	internal_req_flag = @internal_req_flag,
	item_id = @item_id,
	item_name = @item_name, 
	item_type_code = @item_type_code,
	organization_id = @organization_id,
	payroll_qty = @payroll_qty,
	payroll_rate = @payroll_rate,
	pooled_flag = @pooled_flag,
	resource_id = @resource_id,
	resource_name = @resource_name, 
	status_id = @status_id,
	taxable_flag = @taxable_flag,
	tc_job_id = @tc_job_id,
	tc_job_no = @tc_job_no,
	tc_qty = @tc_qty,
	tc_rate = @tc_rate,
	tc_service_id = @tc_service_id,
	tc_service_line_no = @tc_service_line_no,
	tc_service_no = @tc_service_no
  WHERE service_line_id = @service_line_id

-- Perform the next fetch.
FETCH NEXT FROM sl_cursor
INTO
@allocated_qty,
@bill_qty,
@bill_rate,
@bill_hourly_qty,
@bill_hourly_rate,
@bill_exp_qty,
@bill_exp_rate,
@bill_job_id,
@bill_job_no,
@bill_service_line_no,
@bill_service_id,
@billable_flag,
@billed_flag, 
@expenses_exported_flag,
@expense_qty,
@expense_rate,
@exported_flag,
@fully_allocated_flag,
@internal_req_flag,
@invoice_id,
@item_id,
@item_name,
@partially_allocated_flag,
@payroll_exported_flag,
@payroll_qty,
@payroll_rate,
@ph_service_id,
@posted_flag, 
@resource_id,
@resource_name,
@service_line_id,
@status_id,
@taxable_flag,
@tc_job_id,
@tc_job_no,
@tc_qty,
@tc_rate,
@tc_service_id,
@tc_service_line_no

END

CLOSE sl_cursor
DEALLOCATE sl_cursor
GO
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_JobVarianceReport]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*CREATE PROCEDURE NOW*/
CREATE procedure [dbo].[sp_CRYSTAL_JobVarianceReport]
    (
        @DateRangeStart            datetime
        ,@DateRangeEnd             datetime
        ,@JobStatus                varchar(200) = '%'
        ,@ServiceSegment           varchar(200) = '%'
        ,@SortBy                   varchar(200) = 'JobNumber'
        ,@SortOrder                varchar(10) = 'asc'
    )

as

set nocount on
set ansi_warnings off



/*GET BASE QUERY RESULTS*/
select data.job_id
     , JobStatus
     , ServiceSegment
     , date_created
     , est_start_date
     , est_end_date
     , OmniSalesPerson
     , ProjectManager
     , Supervisor
     , Customer
     , EndUser
     , FurnitureLine
     , JobNumber
     , quote_total
     , OtherServicesTotalBill
     , 'HrsVar_Whse' = case when isnull(Omni_WhseHrs,0) - isnull(ActualToComplete_WarehouseHours,0) = 0 then null else isnull(Omni_WhseHrs,0) - isnull(ActualToComplete_WarehouseHours,0) end
     , 'HrsVar_Dlvry' = case when isnull(Omni_DlvryHrs,0) - isnull(ActualToComplete_DeliveryHours,0) = 0 then null else isnull(Omni_DlvryHrs,0) - isnull(ActualToComplete_DeliveryHours,0) end
     , 'HrsVar_Instl' =  case when isnull(Omni_InstlHrs,0)- isnull(ActualToComplete_InstallationHours,0) = 0 then null else isnull(Omni_InstlHrs,0)- isnull(ActualToComplete_InstallationHours,0) end
     , 'HrsVar_Total' = case when isnull(Omni_TotHrs,0) - isnull(ActualToComplete_TotalHours,0) = 0 then null else isnull(Omni_TotHrs,0) - isnull(ActualToComplete_TotalHours,0) end
     , 'CstVar_Whse' = case when isnull(Omni_WhseBill,0) - isnull(ActualToComplete_WarehouseBill,0) = 0 then null else isnull(Omni_WhseBill,0) - isnull(ActualToComplete_WarehouseBill,0) end
     , 'CstVar_Dlvry' = case when isnull(Omni_DlvryBill,0) - isnull(ActualToComplete_DeliveryBill,0) = 0 then null else isnull(Omni_DlvryBill,0) - isnull(ActualToComplete_DeliveryBill,0) end
     , 'CstVar_Instl' = case when isnull(Omni_InstlBill,0) - isnull(ActualToComplete_InstallationBill,0) = 0 then null else isnull(Omni_InstlBill,0) - isnull(ActualToComplete_InstallationBill,0) end
     , 'CstVar_Total' = case when isnull(Omni_TotBill,0) - isnull(ActualToComplete_TotalBill,0) = 0 then null else isnull(Omni_TotBill,0) - isnull(ActualToComplete_TotalBill,0) end
     , change_order_qty
     , change_order_total
     , 'InvVar_Quote' = Omni_TotBill
     , 'InvVar_Actual' = total_invoiced
     , 'InvVar_Variance' = case when isnull(Omni_TotBill,0) - isnull(total_invoiced,0) = 0 then null else isnull(Omni_TotBill,0) - isnull(total_invoiced,0) end
     , 'estimated_gross_margin' = 100*(isnull(Omni_TotBill,0) - isnull(Omni_DirectCostTotal,0))/case when isnull(Omni_TotBill,0) = 0 then null else Omni_TotBill end
into #ReturnTable1 --put data into temp table to join up with gross margin invoic data and later sorting
from (--break out into inline view to calculate variances 
        select  j.job_id 
             , 'JobStatus' = max(j.job_status_type_name)
             , 'ServiceSegment' = max(j.job_type_name)
             , 'date_created' = max(j.date_created)
             , 'est_start_date' = min(s.est_start_date)
             , 'est_end_date' = max(s.est_end_date)
             , 'OmniSalesPerson' = (
                            select top 1 salesrep.contact_name
                            from jobs as sub_j (nolock)
                            inner join contacts as salesrep (nolock) on sub_j.a_m_sales_contact_id = salesrep.contact_id
                            where sub_j.job_id = j.job_id
                            )
             , 'ProjectManager' = dbo.fn_ProjectManagerListPerProjectID(j.project_id)
             , 'Supervisor' = max(j.foreman_user_name)
--             , 'Customer' = max(j.dealer_name)
             , 'Customer' = max(p.customer_name)
             , 'EndUser' = max(p.end_user_name)
             , 'FurnitureLine' = dbo.fn_FurnitureLineListPerProjectID(j.project_id)
             , 'JobNumber' = convert(varchar,j.job_no)
                --------------------------------------
             , 'quote_total' = sum(quotedata.quote_total)
             , 'OtherServicesTotalBill' = case when sum(quotedata.OtherServicesTotalBill) = 0 then null else sum(quotedata.OtherServicesTotalBill) end
             , 'Omni_WhseHrs' = case when sum(quotedata.Omni_WhseHrs) = 0 then NULL else sum(quotedata.Omni_WhseHrs) end
             , 'Omni_DlvryHrs' = case when sum(quotedata.Omni_DlvryHrs) = 0 then NULL else sum(quotedata.Omni_DlvryHrs) end
             , 'Omni_InstlHrs' = case when sum(quotedata.Omni_InstlHrs) = 0 then NULL else sum(quotedata.Omni_InstlHrs) end
             , 'Omni_TotHrs' = case when sum(quotedata.Omni_TotHrs) = 0 then NULL else sum(quotedata.Omni_TotHrs) end
             , 'Omni_WhseBill' = case when sum(quotedata.Omni_WhseBill) = 0 then NULL else sum(quotedata.Omni_WhseBill) end
             , 'Omni_DlvryBill' = case when sum(quotedata.Omni_DlvryBill) = 0 then NULL else sum(quotedata.Omni_DlvryBill) end
             , 'Omni_InstlBill' = case when sum(quotedata.Omni_InstlBill) = 0 then NULL else sum(quotedata.Omni_InstlBill) end
             , 'Omni_TotBill' = case when sum(quotedata.Omni_TotBill) + sum(quotedata.OtherServicesTotalBill) = 0 then NULL else sum(quotedata.Omni_TotBill) + sum(quotedata.OtherServicesTotalBill) end
             , 'Omni_DirectCostTotal' = case when sum(Omni_DirectCostTotal) = 0 then NULL else sum(Omni_DirectCostTotal) end
                --------------------------------------
             , 'ActualToComplete_WarehouseHours' = (--USING A CORRELATED SUBQUERY TO QUICKLY GET THE ACTUAL HOURS
                        select convert(decimal(10,1),sum(sub_sl.tc_qty))
                        from service_lines as sub_sl (nolock)
                            inner join items_reporting_type as sub_irt (nolock) on sub_sl.item_name = sub_irt.item_name and sub_irt.reporting_type = 'warehouse'
                        where sub_sl.item_type_code = 'hours' and sub_sl.tc_job_id = j.job_id
                        )
             , 'ActualToComplete_DeliveryHours' = (--USING A CORRELATED SUBQUERY TO QUICKLY GET THE ACTUAL HOURS
                        select convert(decimal(10,1),sum(sub_sl.tc_qty))
                        from service_lines as sub_sl (nolock)
                            inner join items_reporting_type as sub_irt (nolock) on sub_sl.item_name = sub_irt.item_name and sub_irt.reporting_type = 'delivery'
                        where sub_sl.item_type_code = 'hours' and sub_sl.tc_job_id = j.job_id
                        )
             , 'ActualToComplete_InstallationHours' = (--USING A CORRELATED SUBQUERY TO QUICKLY GET THE ACTUAL HOURS
                        select convert(decimal(10,1),sum(sub_sl.tc_qty))
                        from service_lines as sub_sl (nolock)
                            inner join items_reporting_type as sub_irt (nolock) on sub_sl.item_name = sub_irt.item_name and sub_irt.reporting_type = 'installation'
                        where sub_sl.item_type_code = 'hours' and sub_sl.tc_job_id = j.job_id
                        )
             , 'ActualToComplete_TotalHours' = (--USING A CORRELATED SUBQUERY TO QUICKLY GET THE ACTUAL HOURS
                        select convert(decimal(10,1),sum(sub_sl.tc_qty))
                        from service_lines as sub_sl (nolock)
                            inner join items_reporting_type as sub_irt (nolock) on sub_sl.item_name = sub_irt.item_name
                        where sub_sl.item_type_code = 'hours' and sub_sl.tc_job_id = j.job_id
                        )
                --------------------------------------
             , 'ActualToComplete_WarehouseBill' = (--USING A CORRELATED SUBQUERY TO QUICKLY GET THE ACTUAL HOURS
                        select sum(convert(float,sub_sl.tc_total))
                        from service_lines as sub_sl (nolock)
                            inner join items_reporting_type as sub_irt (nolock) on sub_sl.item_name = sub_irt.item_name and sub_irt.reporting_type = 'warehouse'
                        where sub_sl.item_type_code = 'hours' and sub_sl.tc_job_id = j.job_id 
                        )
             , 'ActualToComplete_DeliveryBill' = (--USING A CORRELATED SUBQUERY TO QUICKLY GET THE ACTUAL HOURS
                        select sum(convert(float,sub_sl.tc_total))
                        from service_lines as sub_sl (nolock)
                            inner join items_reporting_type as sub_irt (nolock) on sub_sl.item_name = sub_irt.item_name and sub_irt.reporting_type = 'delivery'
                        where sub_sl.item_type_code = 'hours' and sub_sl.tc_job_id = j.job_id 
                        )
             , 'ActualToComplete_InstallationBill' = (--USING A CORRELATED SUBQUERY TO QUICKLY GET THE ACTUAL HOURS
                        select sum(convert(float,sub_sl.tc_total))
                        from service_lines as sub_sl (nolock)
                            inner join items_reporting_type as sub_irt (nolock) on sub_sl.item_name = sub_irt.item_name and sub_irt.reporting_type = 'installation'
                        where sub_sl.item_type_code = 'hours' and sub_sl.tc_job_id = j.job_id 
                        )
             , 'ActualToComplete_TotalBill' = (--USING A CORRELATED SUBQUERY TO QUICKLY GET THE ACTUAL HOURS
                        select sum(convert(float,sub_sl.tc_total))
                        from service_lines as sub_sl (nolock)
                            inner join items_reporting_type as sub_irt (nolock) on sub_sl.item_name = sub_irt.item_name
                        where sub_sl.item_type_code = 'hours' and sub_sl.tc_job_id = j.job_id 
                        )
                --------------------------------------
             , 'total_invoiced' = (
                        select sum(il.extended_price)
                        from invoices as i (nolock)
                            inner join invoice_lines as il (nolock) on i.invoice_id = il.invoice_id
                        where i.status_id = 4 and i.job_id = j.job_id/*invoice_status 4 = invoiced*/
                        )
                --------------------------------------
        from jobs_v as j (nolock)
            inner join projects_v as p (nolock) on j.project_id = p.project_id
            inner join services as s (nolock) on j.job_id = s.job_id and s.est_start_date between @DateRangeStart and @DateRangeEnd
            left outer join (
                    --BRING IN INFORMATION FROM QUOTES TABLE
                    select q.quote_id
                         , 'quote_total' = sum(q.quote_total)
                         , 'OtherServicesTotalBill' = sum(isnull(dbo.fn_StringToFloat(q.[SPECIFY_SERVICES_BILL_1]),0) + isnull(dbo.fn_StringToFloat(q.[SPECIFY_SERVICES_BILL_2]),0) + isnull(dbo.fn_StringToFloat(q.[SPECIFY_SERVICES_BILL_3]),0) + isnull(dbo.fn_StringToFloat(q.[SPECIFY_SERVICES_BILL_4]),0) + isnull(dbo.fn_StringToFloat(q.[SPECIFY_SERVICES_BILL_5]),0) + isnull(dbo.fn_StringToFloat(q.[SPECIFY_SERVICES_BILL_6]),0) + isnull(dbo.fn_StringToFloat(q.[SPECIFY_SERVICES_BILL_7]),0))
                         , 'Omni_WhseHrs' = convert(decimal(10,1),sum(isnull(dbo.fn_StringToFloat(q.[IND_OMNI_DISCOUNTED_HOURS-RECEIVE]),0)+isnull(dbo.fn_StringToFloat(q.[IND_OMNI_DISCOUNTED_HOURS-RELOAD]),0)))
                         , 'Omni_DlvryHrs' = convert(decimal(10,1),sum(isnull(dbo.fn_StringToFloat(q.[IND_OMNI_DISCOUNTED_HOURS-DRIVER]),0)+isnull(dbo.fn_StringToFloat(q.[IND_OMNI_DISCOUNTED_HOURS-TRUCK]),0)))
                         , 'Omni_InstlHrs' = convert(decimal(10,1),sum(isnull(dbo.fn_StringToFloat(q.[IND_OMNI_DISCOUNTED_HOURS-ELECTRICAL]),0)+isnull(dbo.fn_StringToFloat(q.[IND_OMNI_DISCOUNTED_HOURS-INSTALL]),0)+isnull(dbo.fn_StringToFloat(q.[IND_OMNI_DISCOUNTED_HOURS-MOVE_STAGE]),0)+isnull(dbo.fn_StringToFloat(q.[IND_OMNI_DISCOUNTED_HOURS-UNLOAD]),0)))
                         , 'Omni_TotHrs' = convert(decimal(10,1),sum(isnull(dbo.fn_StringToFloat(q.[IND_OMNI_DISCOUNTED_HOURS-TOTAL]),0)))
                         , 'Omni_WhseBill' = sum(isnull(dbo.fn_StringToFloat(q.[IND_OMNI_DISCOUNTED_BILL-RECEIVE]),0)+isnull(dbo.fn_StringToFloat(q.[IND_OMNI_DISCOUNTED_BILL-RELOAD]),0))
                         , 'Omni_DlvryBill' = sum(isnull(dbo.fn_StringToFloat(q.[IND_OMNI_DISCOUNTED_BILL-DRIVER]),0)+isnull(dbo.fn_StringToFloat(q.[IND_OMNI_DISCOUNTED_BILL-TRUCK]),0))
                         , 'Omni_InstlBill' = sum(isnull(dbo.fn_StringToFloat(q.[IND_OMNI_DISCOUNTED_BILL-ELECTRICAL]),0)+isnull(dbo.fn_StringToFloat(q.[IND_OMNI_DISCOUNTED_BILL-INSTALL]),0)+isnull(dbo.fn_StringToFloat(q.[IND_OMNI_DISCOUNTED_BILL-MOVE_STAGE]),0)+isnull(dbo.fn_StringToFloat(q.[IND_OMNI_DISCOUNTED_BILL-UNLOAD]),0))
                         , 'Omni_TotBill' = sum(isnull(dbo.fn_StringToFloat(q.[IND_OMNI_DISCOUNTED_BILL-TOTAL]),0))
                         , 'Omni_DirectCostTotal' = sum(isnull(dbo.fn_StringToFloat(q.[IND_OMNI_DIRECT_COST-TOTAL]),0))
                    from quotes as q (nolock)--make sure to only get sent quotes
                    where q.is_sent = 'y'
                    group by q.quote_id
                    ) as quotedata on s.quote_id = quotedata.quote_id
        where isnull(j.job_status_type_name,'') like case when @JobStatus = 'All' then '%' else @JobStatus end
            and isnull(j.job_type_name,'') like case when @ServiceSegment = 'All' then '%' else @ServiceSegment end
            --LIMIT RESULTS TO ONLY JOBS WITH VALUES FOR A QUOTE
            and quotedata.Omni_TotBill > 0
        group by j.job_id, j.job_no, j.project_id, p.project_no
        ) as data
    left outer join (
            select 'job_id' = j.job_id, 'change_order_qty' = count(*), 'change_order_total' = sum(q.quote_total)
            from jobs as j (nolock)
                inner join services as s (nolock) on j.job_id = s.job_id
                inner join requests as r (nolock) on s.request_id = r.request_id and r.is_sent = 'y' and r.is_quoted = 'y'
                inner join lookups as order_type (nolock) on r.order_type_id = order_type.lookup_id and order_type.code = 'change_order'
                inner join quotes as q (nolock) on s.quote_id = q.quote_id
            group by j.job_id
        ) as change_orders on data.job_id = change_orders.job_id



/*TACK ON GROSS MARGIN FROM JOB PROFITABILITY QUERY - MUST DO IT THIS WAY TO AVOID A SERVER ERROR*/
select rt1.*
     , gm.gross_margin_total
     , 'gross_margin_variance' = case when isnull(estimated_gross_margin,0) - isnull(gm.gross_margin_total,0) = 0 then null else isnull(estimated_gross_margin,0) - isnull(gm.gross_margin_total,0) end
into #ReturnTable2
from #ReturnTable1 as rt1
left outer join (
        SELECT 'job_no' = tempTable.[job no]
             , 'gross_margin_invoiced' = SUM([Total Invoiced])
             , 'gross_margin_costs' = SUM([labor cost] + [truck cost] + [expense cost] + [sub cost])
             , 'gross_margin_total' = 100*(SUM([Total Invoiced]) - SUM([labor cost] + [truck cost] + [expense cost] + [sub cost])) / case when isnull(SUM([Total Invoiced]),0) = 0 then null else SUM([Total Invoiced]) end
        FROM (/*THIS CODE TAKEN FROM A QUERY FROM JERRY THAT OMNI HAS TESTED TO ACCURATELY RETURN THE GROSS PROFIT NUMBERS*/
                SELECT [organization name], [job no], [job type], [customer name], [end user name], [job owner], [job supervisor], [sp sales], [total invoiced], [labor cost], [truck cost], [expense cost], [sub cost], [invoice no]
                FROM jobs_with_costs_v (nolock)
                WHERE [Total Invoiced] > 0
                UNION ALL
                SELECT [organization name], [job no], [job type], [customer name], [end user name], [job owner], [job supervisor], [sp sales], [total invoiced], [labor cost], [truck cost], [expense cost], [sub cost], NULL AS [invoice no]
                FROM jobs_with_posted_costs_v (nolock)
                ) AS tempTable
        group by tempTable.[job no]
        ) as gm on rt1.JobNumber = gm.job_no


/*take data and sort with the variable using dynamic sql*/
    /*declare variable to put sql in to execute*/
    declare @sql varchar(1000)
    set @sql = 'select * from #ReturnTable2 order by '+@SortBy+' '+@SortOrder
    exec(@sql)



return
GO
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_JobCostReportWORK]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*CREATE PROCEDURE NOW*/
create procedure [dbo].[sp_CRYSTAL_JobCostReportWORK]
    (
        @DateRangeStart            datetime
        ,@DateRangeEnd             datetime
        ,@JobStatus                varchar(200) = '%'
        ,@ServiceSegment           varchar(200) = '%'
        ,@Organization           varchar(200) = '%'
        ,@SortBy                   varchar(200) = 'JobNumber'
        ,@SortOrder                varchar(10) = 'asc'
    )

as

set nocount on

/*GET BASE QUERY RESULTS*/
select *
     , 'Variance_CompleteToNatlBill' = data.ActualToComplete_TotalBill - data.NationalStd_TotBill
     , 'Variance_CompleteToRocBill' = data.ActualToComplete_TotalBill - data.ROC_TotBill
     , 'Variance_CompleteToQuoteBill' = data.ActualToComplete_TotalBill - data.Omni_TotBill
into #ReturnTable --put data into temp table for sorting later
from (--break out into inline view to calculate variances 
        select  j.job_id 
             , 'JobStatus' = max(j.job_status_type_name)
             , 'ServiceSegment' = max(j.job_type_name)
		, 'date_created' = max(j.date_created)
             , 'est_start_date' = min(s.est_start_date)
             , 'est_end_date' = max(s.est_end_date)
             , 'OmniSalesPerson' = (
                            select top 1 salesrep.contact_name
                            from jobs as sub_j (nolock)
                            inner join contacts as salesrep (nolock) on sub_j.a_m_sales_contact_id = salesrep.contact_id
                            where sub_j.job_id = j.job_id
                            )
             , 'ProjectManager' = dbo.fn_ProjectManagerListPerProjectID(j.project_id)
             , 'Supervisor' =  max(j.foreman_user_name)
--             , 'Customer' = max(j.dealer_name)
             , 'Customer' = max(p.customer_name)
             , 'EndUser' = max(p.end_user_name)
             , 'FurnitureLine' = dbo.fn_FurnitureLineListPerProjectID(j.project_id)
             , 'JobNumber' = convert(varchar,j.job_no)
                --------------------------------------
             , 'quote_total' = sum(quotedata.quote_total)
             , 'OtherServicesTotalBill' = sum(quotedata.OtherServicesTotalBill)
             , 'NationalStd_WhseBill' = case when sum(quotedata.NationalStd_WhseBill) = 0 then NULL else sum(quotedata.NationalStd_WhseBill) end
             , 'NationalStd_DlvryBill' = case when sum(quotedata.NationalStd_DlvryBill) = 0 then NULL else sum(quotedata.NationalStd_DlvryBill) end
             , 'NationalStd_InstlBill' = case when sum(quotedata.NationalStd_InstlBill) = 0 then NULL else sum(quotedata.NationalStd_InstlBill) end
             , 'NationalStd_TotBill' = case when sum(quotedata.NationalStd_TotBill) + sum(quotedata.OtherServicesTotalBill) = 0 then NULL else sum(quotedata.NationalStd_TotBill) + sum(quotedata.OtherServicesTotalBill) end
             , 'ROC_WhseBill' = case when sum(quotedata.ROC_WhseBill) = 0 then NULL else sum(quotedata.ROC_WhseBill) end
             , 'ROC_DlvryBill' = case when sum(quotedata.ROC_DlvryBill) = 0 then NULL else sum(quotedata.ROC_DlvryBill) end
             , 'ROC_InstlBill' = case when sum(quotedata.ROC_InstlBill) = 0 then NULL else sum(quotedata.ROC_InstlBill) end
             , 'ROC_TotBill' = case when sum(quotedata.ROC_TotBill) + sum(quotedata.OtherServicesTotalBill) = 0 then NULL else sum(quotedata.ROC_TotBill) + sum(quotedata.OtherServicesTotalBill) end
             , 'Omni_WhseBill' = case when sum(quotedata.Omni_WhseBill) = 0 then NULL else sum(quotedata.Omni_WhseBill) end
             , 'Omni_DlvryBill' = case when sum(quotedata.Omni_DlvryBill) = 0 then NULL else sum(quotedata.Omni_DlvryBill) end
             , 'Omni_InstlBill' = case when sum(quotedata.Omni_InstlBill) = 0 then NULL else sum(quotedata.Omni_InstlBill) end
             , 'Omni_TotBill' = case when sum(quotedata.Omni_TotBill) + sum(quotedata.OtherServicesTotalBill) = 0 then NULL else sum(quotedata.Omni_TotBill) + sum(quotedata.OtherServicesTotalBill) end
                --------------------------------------
             , 'ActualToComplete_WarehouseBill' = (--USING A CORRELATED SUBQUERY TO QUICKLY GET THE ACTUAL HOURS
                        select sum(convert(float,sub_sl.tc_total))
                        from service_lines as sub_sl (nolock)
                            inner join items_reporting_type as sub_irt (nolock) on sub_sl.item_name = sub_irt.item_name and sub_irt.reporting_type = 'warehouse'
                        where sub_sl.item_type_code = 'hours' and sub_sl.tc_job_id = j.job_id 
                        )
             , 'ActualToComplete_DeliveryBill' = (--USING A CORRELATED SUBQUERY TO QUICKLY GET THE ACTUAL HOURS
                        select sum(convert(float,sub_sl.tc_total))
                        from service_lines as sub_sl (nolock)
                            inner join items_reporting_type as sub_irt (nolock) on sub_sl.item_name = sub_irt.item_name and sub_irt.reporting_type = 'delivery'
                        where sub_sl.item_type_code = 'hours' and sub_sl.tc_job_id = j.job_id 
                        )
             , 'ActualToComplete_InstallationBill' = (--USING A CORRELATED SUBQUERY TO QUICKLY GET THE ACTUAL HOURS
                        select sum(convert(float,sub_sl.tc_total))
                        from service_lines as sub_sl (nolock)
                            inner join items_reporting_type as sub_irt (nolock) on sub_sl.item_name = sub_irt.item_name and sub_irt.reporting_type = 'installation'
                        where sub_sl.item_type_code = 'hours' and sub_sl.tc_job_id = j.job_id 
                        )
             , 'ActualToComplete_TotalBill' = (--USING A CORRELATED SUBQUERY TO QUICKLY GET THE ACTUAL HOURS
                        select sum(convert(float,sub_sl.tc_total))
                        from service_lines as sub_sl (nolock)
                            inner join items_reporting_type as sub_irt (nolock) on sub_sl.item_name = sub_irt.item_name
                        where sub_sl.item_type_code = 'hours' and sub_sl.tc_job_id = j.job_id 
                        )
        from jobs_v as j (nolock)
            inner join projects_v as p (nolock) on j.project_id = p.project_id
            inner join services as s (nolock) on j.job_id = s.job_id and s.est_start_date between @DateRangeStart and @DateRangeEnd
            inner join (
                    --BRING IN INFORMATION FROM QUOTES TABLE
                    select q.quote_id
                         , 'quote_total' = sum(q.quote_total)
                         , 'OtherServicesTotalBill' = sum(isnull(dbo.fn_StringToFloat(q.[SPECIFY_SERVICES_BILL_1]),0) + isnull(dbo.fn_StringToFloat(q.[SPECIFY_SERVICES_BILL_2]),0) + isnull(dbo.fn_StringToFloat(q.[SPECIFY_SERVICES_BILL_3]),0) + isnull(dbo.fn_StringToFloat(q.[SPECIFY_SERVICES_BILL_4]),0) + isnull(dbo.fn_StringToFloat(q.[SPECIFY_SERVICES_BILL_5]),0) + isnull(dbo.fn_StringToFloat(q.[SPECIFY_SERVICES_BILL_6]),0) + isnull(dbo.fn_StringToFloat(q.[SPECIFY_SERVICES_BILL_7]),0))
                         , 'NationalStd_WhseBill' = sum(isnull(dbo.fn_StringToFloat(q.[IND_INDUSTRY_STD_BILL-RECEIVE]),0)+isnull(dbo.fn_StringToFloat(q.[IND_INDUSTRY_STD_BILL-RELOAD]),0))
                         , 'NationalStd_DlvryBill' = sum(isnull(dbo.fn_StringToFloat(q.[IND_INDUSTRY_STD_BILL-DRIVER]),0)+isnull(dbo.fn_StringToFloat(q.[IND_INDUSTRY_STD_BILL-TRUCK]),0))
                         , 'NationalStd_InstlBill' = sum(isnull(dbo.fn_StringToFloat(q.[IND_INDUSTRY_STD_BILL-ELECTRICAL]),0)+isnull(dbo.fn_StringToFloat(q.[IND_INDUSTRY_STD_BILL-INSTALL]),0)+isnull(dbo.fn_StringToFloat(q.[IND_INDUSTRY_STD_BILL-MOVE_STAGE]),0)+isnull(dbo.fn_StringToFloat(q.[IND_INDUSTRY_STD_BILL-UNLOAD]),0))
                         , 'NationalStd_TotBill' = sum(isnull(dbo.fn_StringToFloat(q.[IND_INDUSTRY_STD_BILL-TOTAL]),0))
                         , 'ROC_WhseBill' = sum(isnull(dbo.fn_StringToFloat(q.[ROC_INDUSTRY_STD_BILL-RECEIVE]),0)+isnull(dbo.fn_StringToFloat(q.[ROC_INDUSTRY_STD_BILL-RELOAD]),0))
                         , 'ROC_DlvryBill' = sum(isnull(dbo.fn_StringToFloat(q.[ROC_INDUSTRY_STD_BILL-DRIVER]),0)+isnull(dbo.fn_StringToFloat(q.[ROC_INDUSTRY_STD_BILL-TRUCK]),0))
                         , 'ROC_InstlBill' = sum(isnull(dbo.fn_StringToFloat(q.[ROC_INDUSTRY_STD_BILL-ELECTRICAL]),0)+isnull(dbo.fn_StringToFloat(q.[ROC_INDUSTRY_STD_BILL-INSTALL]),0)+isnull(dbo.fn_StringToFloat(q.[ROC_INDUSTRY_STD_BILL-MOVE_STAGE]),0)+isnull(dbo.fn_StringToFloat(q.[ROC_INDUSTRY_STD_BILL-UNLOAD]),0))
                         , 'ROC_TotBill' = sum(isnull(dbo.fn_StringToFloat(q.[ROC_INDUSTRY_STD_BILL-TOTAL]),0))
                         , 'Omni_WhseBill' = sum(isnull(dbo.fn_StringToFloat(q.[IND_OMNI_DISCOUNTED_BILL-RECEIVE]),0)+isnull(dbo.fn_StringToFloat(q.[IND_OMNI_DISCOUNTED_BILL-RELOAD]),0))
                         , 'Omni_DlvryBill' = sum(isnull(dbo.fn_StringToFloat(q.[IND_OMNI_DISCOUNTED_BILL-DRIVER]),0)+isnull(dbo.fn_StringToFloat(q.[IND_OMNI_DISCOUNTED_BILL-TRUCK]),0))
                         , 'Omni_InstlBill' = sum(isnull(dbo.fn_StringToFloat(q.[IND_OMNI_DISCOUNTED_BILL-ELECTRICAL]),0)+isnull(dbo.fn_StringToFloat(q.[IND_OMNI_DISCOUNTED_BILL-INSTALL]),0)+isnull(dbo.fn_StringToFloat(q.[IND_OMNI_DISCOUNTED_BILL-MOVE_STAGE]),0)+isnull(dbo.fn_StringToFloat(q.[IND_OMNI_DISCOUNTED_BILL-UNLOAD]),0))
                         , 'Omni_TotBill' = sum(isnull(dbo.fn_StringToFloat(q.[IND_OMNI_DISCOUNTED_BILL-TOTAL]),0))
                    from quotes as q (nolock)--make sure to only get sent quotes
                    where q.is_sent = 'y'
                    group by q.quote_id
                    ) as quotedata on s.quote_id = quotedata.quote_id
        where isnull(j.job_status_type_name,'') like case when @JobStatus = 'All' then '%' else @JobStatus end
            and isnull(j.job_type_name,'') like case when @ServiceSegment = 'All' then '%' else @ServiceSegment end
            --LIMIT RESULTS TO ONLY JOBS WITH VALUES FOR A QUOTE
            and quotedata.NationalStd_WhseBill + quotedata.NationalStd_DlvryBill + quotedata.NationalStd_InstlBill + quotedata.NationalStd_TotBill
              + quotedata.Omni_WhseBill + quotedata.Omni_DlvryBill + quotedata.Omni_InstlBill + quotedata.Omni_TotBill
              + quotedata.ROC_WhseBill + quotedata.ROC_DlvryBill + quotedata.ROC_InstlBill + quotedata.ROC_TotBill
              > 0
        group by j.job_id, j.job_no, j.project_id, p.project_no
        ) as data

/*take data and sort with the variable using dynamic sql*/
    --declare variable to put sql in to execute
    declare @sql varchar(1000)
    set @sql = 'select * from #ReturnTable order by '+@SortBy+' '+@SortOrder
    exec(@sql)


return
GO
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_PriceRealizationReport]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*CREATE PROCEDURE NOW*/
CREATE procedure [dbo].[sp_CRYSTAL_PriceRealizationReport]
    (
        @DateRangeStart            datetime
        ,@DateRangeEnd             datetime
        ,@JobStatus                varchar(200) = '%'
        ,@SortBy                   varchar(200) = 'jobnumber'
        ,@SortOrder                varchar(10) = 'asc'
    )

as

set nocount on
set ansi_warnings off


/*GET BASE QUERY RESULTS*/
select  j.job_id 
     , 'JobStatus' = max(j.job_status_type_name)
     , 'ServiceSegment' = max(j.job_type_name)
     , 'date_created' = max(j.date_created)
     , 'est_start_date' = min(s.est_start_date)
     , 'est_end_date' = max(s.est_end_date)
     , 'OmniSalesPerson' = (
                    select top 1 salesrep.contact_name
                    from jobs as sub_j (nolock)
                    inner join contacts as salesrep (nolock) on sub_j.a_m_sales_contact_id = salesrep.contact_id
                    where sub_j.job_id = j.job_id
                    )
     , 'ProjectManager' = dbo.fn_ProjectManagerListPerProjectID(j.project_id)
     , 'Supervisor' = max(j.foreman_user_name)
--     , 'Customer' = max(j.dealer_name)
     , 'Customer' = max(p.customer_name)
     , 'EndUser' = max(p.end_user_name)
     , 'FurnitureLine' = dbo.fn_FurnitureLineListPerProjectID(j.project_id)
     , 'JobNumber' = j.job_no
        --------------------------------------
        /*QUOTE INFO*/
     , 'quote_total' = sum(quotedata.quote_total)
     , 'OtherServicesTotalBill' = sum(quotedata.OtherServicesTotalBill)
     , 'NationalBillTotal' = sum(quotedata.NationalBillTotal)
     , 'NationalHoursTotal' = sum(quotedata.NationalHoursTotal)
     , 'ROCBillTotal' = sum(quotedata.ROCBillTotal)
     , 'ROCDirectCost' = sum(quotedata.ROCDirectCost)
     , 'ROCHoursTotal' = sum(quotedata.ROCHoursTotal)
     , 'ROCHoursTruckAndDriver' = sum(quotedata.ROCHoursTruckAndDriver)
     , 'OmniDirectCost' = sum(quotedata.OmniDirectCost)
     , 'OmniBillTotal' = sum(quotedata.OmniBillTotal)
     , 'OmniHoursTotal' = sum(quotedata.OmniHoursTotal)
        --------------------------------------
        /*VARIANCES AND NEBR CALCUATIONS*/
     , 'ROC_NEBR' = avg(quotedata.ROC_NEBR)
     , 'ROC_GP_NoBilledServices_pct' = avg(quotedata.ROC_GP_NoBilledServices_pct)
     , 'ROC_GP_pct' = avg(quotedata.ROC_GP_pct)
     , 'Omni_NEBR' = avg(quotedata.Omni_NEBR)
     , 'Omni_GP_NoBilledServices_pct' = avg(quotedata.Omni_GP_NoBilledServices_pct)
     , 'Quote_GP' = avg(quotedata.Quote_GP)
     , 'Quote_GP_pct' = avg(quotedata.Quote_GP_pct)
        --------------------------------------
        /*DISCOUNTS CALCULATIONS*/
     , 'Discounts_HoursPct' = avg(quotedata.Discounts_HoursPct)
     , 'Discounts_HoursDiff' = avg(quotedata.Discounts_HoursDiff)
     , 'Discounts_BillPctDiff' = avg(quotedata.Discounts_BillPctDiff)
     , 'Discounts_BillDiff' = avg(quotedata.Discounts_BillDiff)
     , 'Discounts_GPDiff' = avg(quotedata.Discounts_GPDiff)
        --------------------------------------
into #tblQuoteInfo
from jobs_v as j (nolock)
    inner join projects_v as p (nolock) on j.project_id = p.project_id
    inner join services as s (nolock) on j.job_id = s.job_id and s.est_start_date between @DateRangeStart and @DateRangeEnd
    left outer join (
            --BRING IN INFORMATION FROM QUOTES TABLE
            select *
                    /*DISCOUNTS CALCULATIONS*/
                 , 'Discounts_HoursPct' = isnull(100*(ROCHoursTotal - OmniHoursTotal)/case when ROCHoursTotal - ROCHoursTruckAndDriver = 0 then null else ROCHoursTotal - ROCHoursTruckAndDriver end,0)
                 , 'Discounts_HoursDiff' = OmniHoursTotal - ROCHoursTotal
                 , 'Discounts_BillPctDiff' = 100*(OmniBillTotal - ROCBillTotal) / case when isnull(ROCBillTotal,0) = 0 then null else ROCBillTotal end
                 , 'Discounts_BillDiff' = OmniBillTotal - ROCBillTotal
                 , 'Discounts_GPDiff' = Quote_GP_pct - ROC_GP_NoBilledServices_pct
            from (
                    select *
                            /*VARIANCES AND NEBR CALCUATIONS*/
                         , 'ROC_NEBR' = ROCBillTotal / case when isnull(ROCHoursTotal,0) = 0 then null else ROCHoursTotal end
                         , 'ROC_GP_NoBilledServices_pct' = 100*(ROCBillTotal - OtherServicesTotalBill - ROCDirectCost) / case when isnull(ROCBillTotal - OtherServicesTotalBill,0) = 0 then null else ROCBillTotal - OtherServicesTotalBill end
                         , 'ROC_GP_pct' = 100*(ROCBillTotal - ROCDirectCost) / case when isnull(ROCBillTotal,0) +isnull(OtherServicesTotalBill,0) = 0 then null else isnull(ROCBillTotal,0) + isnull(OtherServicesTotalBill,0) end
                         , 'Omni_NEBR' = OmniBillTotal / case when isnull(OmniHoursTotal,0) = 0 then null else OmniHoursTotal end
                         , 'Omni_GP_NoBilledServices_pct' = 100*(OmniBillTotal - OtherServicesTotalBill - OmniDirectCost) / case when isnull(OmniBillTotal - OtherServicesTotalBill,0) = 0 then null else OmniBillTotal - OtherServicesTotalBill end
                         , 'Quote_GP' = quote_total - OmniDirectCost
                         , 'Quote_GP_pct' = 100*(quote_total - OmniDirectCost) / case when isnull(quote_total,0) = 0 then null else quote_total end
                    from (
                            select q.quote_id
                                 , 'quote_total' = q.quote_total
                                 , 'OtherServicesTotalBill' = isnull(dbo.fn_StringToFloat(q.[SPECIFY_SERVICES_BILL_1]),0) + isnull(dbo.fn_StringToFloat(q.[SPECIFY_SERVICES_BILL_2]),0) + isnull(dbo.fn_StringToFloat(q.[SPECIFY_SERVICES_BILL_3]),0) + isnull(dbo.fn_StringToFloat(q.[SPECIFY_SERVICES_BILL_4]),0) + isnull(dbo.fn_StringToFloat(q.[SPECIFY_SERVICES_BILL_5]),0) + isnull(dbo.fn_StringToFloat(q.[SPECIFY_SERVICES_BILL_6]),0) + isnull(dbo.fn_StringToFloat(q.[SPECIFY_SERVICES_BILL_7]),0)
                                 , 'NationalBillTotal' = isnull(dbo.fn_StringToFloat(q.[IND_INDUSTRY_STD_BILL-TOTAL]),0)+ isnull(dbo.fn_StringToFloat(q.[SPECIFY_SERVICES_BILL_1]),0) + isnull(dbo.fn_StringToFloat(q.[SPECIFY_SERVICES_BILL_2]),0) + isnull(dbo.fn_StringToFloat(q.[SPECIFY_SERVICES_BILL_3]),0) + isnull(dbo.fn_StringToFloat(q.[SPECIFY_SERVICES_BILL_4]),0) + isnull(dbo.fn_StringToFloat(q.[SPECIFY_SERVICES_BILL_5]),0) + isnull(dbo.fn_StringToFloat(q.[SPECIFY_SERVICES_BILL_6]),0) + isnull(dbo.fn_StringToFloat(q.[SPECIFY_SERVICES_BILL_7]),0)
                                 , 'NationalHoursTotal' = isnull(dbo.fn_StringToFloat(q.[IND_INDUSTRY_STD_HOURS-TOTAL]),0)
                                 , 'ROCBillTotal' = isnull(dbo.fn_StringToFloat(q.[ROC_INDUSTRY_STD_BILL-TOTAL]),0) + isnull(dbo.fn_StringToFloat(q.[SPECIFY_SERVICES_BILL_1]),0) + isnull(dbo.fn_StringToFloat(q.[SPECIFY_SERVICES_BILL_2]),0) + isnull(dbo.fn_StringToFloat(q.[SPECIFY_SERVICES_BILL_3]),0) + isnull(dbo.fn_StringToFloat(q.[SPECIFY_SERVICES_BILL_4]),0) + isnull(dbo.fn_StringToFloat(q.[SPECIFY_SERVICES_BILL_5]),0) + isnull(dbo.fn_StringToFloat(q.[SPECIFY_SERVICES_BILL_6]),0) + isnull(dbo.fn_StringToFloat(q.[SPECIFY_SERVICES_BILL_7]),0)
                                 , 'ROCDirectCost' = isnull(dbo.fn_StringToFloat(q.[ROC_OMNI_DIRECT_COST-TOTAL]),0)
                                 , 'ROCHoursTotal' = isnull(dbo.fn_StringToFloat(q.[ROC_OMNI_DISCOUNTED_HOURS-TOTAL]),0)
                                 , 'ROCHoursTruckAndDriver' = isnull(dbo.fn_StringToFloat(q.[ROC_OMNI_DISCOUNTED_HOURS-TRUCK]),0)+isnull(dbo.fn_StringToFloat(q.[ROC_OMNI_DISCOUNTED_HOURS-DRIVER]),0)
                                 , 'OmniDirectCost' = isnull(dbo.fn_StringToFloat(q.[IND_OMNI_DIRECT_COST-TOTAL]),0)
                                 , 'OmniBillTotal' = isnull(dbo.fn_StringToFloat(q.[IND_OMNI_DISCOUNTED_BILL-TOTAL]),0) + isnull(dbo.fn_StringToFloat(q.[SPECIFY_SERVICES_BILL_1]),0) + isnull(dbo.fn_StringToFloat(q.[SPECIFY_SERVICES_BILL_2]),0) + isnull(dbo.fn_StringToFloat(q.[SPECIFY_SERVICES_BILL_3]),0) + isnull(dbo.fn_StringToFloat(q.[SPECIFY_SERVICES_BILL_4]),0) + isnull(dbo.fn_StringToFloat(q.[SPECIFY_SERVICES_BILL_5]),0) + isnull(dbo.fn_StringToFloat(q.[SPECIFY_SERVICES_BILL_6]),0) + isnull(dbo.fn_StringToFloat(q.[SPECIFY_SERVICES_BILL_7]),0)
                                 , 'OmniHoursTotal' = isnull(dbo.fn_StringToFloat(q.[IND_OMNI_DISCOUNTED_HOURS-TOTAL]),0)
                            from quotes as q (nolock)--make sure to only get sent quotes
                            where q.is_sent = 'y'
                            ) as quotedata
                    ) as quotedata
            ) as quotedata on s.quote_id = quotedata.quote_id
where isnull(j.job_status_type_name,'') like case when @JobStatus = 'All' then '%' else @JobStatus end
    --LIMIT RESULTS TO ONLY JOBS WITH VALUES FOR A QUOTE
    and quotedata.OmniBillTotal > 0
group by j.job_id, j.job_no, j.project_id, p.project_no



/*GET GP CALCULATIONS AND PUT IN A TEMP TABLE TO AVOID A SERVER ERROR*/
SELECT 'job_no' = tempTable.[job no]
     , 'gross_margin_invoiced' = SUM([Total Invoiced])
     , 'gross_margin_costs' = SUM([labor cost] + [truck cost] + [expense cost] + [sub cost])
     , 'gross_margin_tc_costs_only' = SUM([labor cost] + [truck cost] + [expense cost])
     , 'gross_margin_total' = SUM([Total Invoiced]) - SUM([labor cost] + [truck cost] + [expense cost] + [sub cost])
     , 'gross_margin_total_pct' = 100*(SUM([Total Invoiced]) - SUM([labor cost] + [truck cost] + [expense cost] + [sub cost])) / case when isnull(SUM([Total Invoiced]),0) = 0 then null else SUM([Total Invoiced]) end
into #tblGPStuff
FROM (/*THIS CODE TAKEN FROM A QUERY FROM JERRY THAT OMNI HAS TESTED TO ACCURATELY RETURN THE GROSS PROFIT NUMBERS*/
        SELECT [organization name], [job no], [job type], [customer name], [end user name], [job owner], [job supervisor], [sp sales], [total invoiced], [labor cost], [truck cost], [expense cost], [sub cost], [invoice no]
        FROM jobs_with_costs_v as v (nolock)
            inner join #tblQuoteInfo as qi on v.[job no] = qi.jobnumber
        WHERE [Total Invoiced] > 0
        UNION ALL
        SELECT [organization name], [job no], [job type], [customer name], [end user name], [job owner], [job supervisor], [sp sales], [total invoiced], [labor cost], [truck cost], [expense cost], [sub cost], NULL AS [invoice no]
        FROM jobs_with_posted_costs_v as v( nolock)
            inner join #tblQuoteInfo as qi on v.[job no] = qi.jobnumber
        ) AS tempTable
group by tempTable.[job no]




/*START ADDING IN INVOICING DATA*/
select qi.*
     , invoicedata.SumOfInvoicedHours
     , change_orders.change_order_total
     , gp_stuff.gross_margin_invoiced
     , gp_stuff.gross_margin_costs
     , 'gp_nebr' = gp_stuff.gross_margin_costs/case when isnull(invoicedata.SumOfInvoicedHours,0) = 0 then null else invoicedata.SumOfInvoicedHours end
     , gp_stuff.gross_margin_total
     , gp_stuff.gross_margin_total_pct
into #tblQuoteInvoicingGPStuff /*put into another temp table to make calculation of the final variances easier*/
from #tblQuoteInfo as qi
    left outer join (/*getting all invoiced hours*/
            select inv.job_id, 'SumOfInvoicedHours' = sum(il.qty)
            from invoice_lines as il (nolock)
                inner join items as i (nolock) on il.item_id = i.item_id and i.item_type_id = 8 /*code = 'hours' from lookups*/
                inner join invoices as inv (nolock) on il.invoice_id = inv.invoice_id
            group by inv.job_id
            ) as invoicedata on qi.job_id = invoicedata.job_id
    left outer join (/*get change order data*/
            select 'job_id' = j.job_id, 'change_order_qty' = count(*), 'change_order_total' = sum(q.quote_total)
            from jobs as j (nolock)
                inner join services as s (nolock) on j.job_id = s.job_id
                inner join requests as r (nolock) on s.request_id = r.request_id and r.is_sent = 'y' and r.is_quoted = 'y'
                inner join lookups as order_type (nolock) on r.order_type_id = order_type.lookup_id and order_type.code = 'change_order'
                inner join quotes as q (nolock) on s.quote_id = q.quote_id
            group by j.job_id
            ) as change_orders on qi.job_id = change_orders.job_id
    left outer join #tblGPStuff as gp_stuff on qi.jobnumber = gp_stuff.job_no


select *
     , 'variance_hours' = isnull(OmniHoursTotal,0) - isnull(SumOfInvoicedHours,0)
     , 'variance_pricing' = isnull(quote_total,0) - isnull(gross_margin_costs,0)
     , 'variance_nebr' = isnull(Omni_NEBR,0) - isnull(gp_nebr,0)
     , 'variance_gp_pct' = isnull(Quote_gp_pct,0) - isnull(gross_margin_total_pct,0)
     , 'variance_gp' = isnull(Quote_gp,0) - isnull(gross_margin_total,0)
into #ReturnTable
from #tblQuoteInvoicingGPStuff



/*take data and sort with the variable using dynamic sql*/
    --declare variable to put sql in to execute
    declare @sql varchar(1000)
    set @sql = 'select * from #ReturnTable order by '+@SortBy+' '+@SortOrder
    exec(@sql)



return
GO
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_OVERHEAD_HOURS_TCI]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec sp_CRYSTAL_OVERHEAD_HOURS_TCI '4/1/2005'
CREATE PROCEDURE [dbo].[sp_CRYSTAL_OVERHEAD_HOURS_TCI]
	@begdate datetime
AS
--declare @begdate datetime
--set @begdate =getdate()
	select *,case 
	when SERVICE_LINE_DATE >= @begdate
		and SERVICE_LINE_DATE < dateadd(day,7,@begdate)   then TC_QTY
	else 0
	end as Week1, dateadd(day,7,@begdate)-1 Week1Date,
	case 
	when SERVICE_LINE_DATE >= dateadd(day,7,@begdate)
		and SERVICE_LINE_DATE < dateadd(day,14,@begdate)   then TC_QTY
	else 0
	end as Week2, dateadd(day,14,@begdate)-1 Week2Date,
	case 
	when SERVICE_LINE_DATE >= dateadd(day,14,@begdate)
		and SERVICE_LINE_DATE < dateadd(day,21,@begdate)   then TC_QTY
	else 0
	end as Week3, dateadd(day,21,@begdate)-1 Week3Date,
	case 
	when SERVICE_LINE_DATE >= dateadd(day,21,@begdate)
		and SERVICE_LINE_DATE < dateadd(day,28,@begdate)   then TC_QTY
	else 0
	end as Week4,dateadd(day,28,@begdate)-1 Week4Date,
	case
	when SERVICE_LINE_DATE >= dateadd(day,28,@begdate)
		and SERVICE_LINE_DATE < dateadd(day,35,@begdate)   then TC_QTY
	else 0
	end as Week5, dateadd(day,35,@begdate)-1 Week5Date
	from JOB_TIME_BY_JOB_V 
	where SERVICE_LINE_DATE >= @begdate and SERVICE_LINE_DATE < dateadd(day,35,@begdate)
	and left(job_no_varchar,3) = '109'
GO
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_OVERHEAD_HOURS_NODATE]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec sp_CRYSTAL_OVERHEAD_HOURS_NODATE

CREATE PROCEDURE [dbo].[sp_CRYSTAL_OVERHEAD_HOURS_NODATE]
AS

	declare @begdate varchar(25)
	
	select @begdate = cast(getdate() as varchar(25))

            select *,case 

            when SERVICE_LINE_DATE >= @begdate

                        and SERVICE_LINE_DATE < dateadd(day,7,@begdate)   then TC_QTY

            else 0

            end as Week1, dateadd(day,7,@begdate)-1 Week1Date,

            case 

            when SERVICE_LINE_DATE >= dateadd(day,7,@begdate)

                        and SERVICE_LINE_DATE < dateadd(day,14,@begdate)   then TC_QTY

            else 0

            end as Week2, dateadd(day,14,@begdate)-1 Week2Date,

            case 

            when SERVICE_LINE_DATE >= dateadd(day,14,@begdate)

                        and SERVICE_LINE_DATE < dateadd(day,21,@begdate)   then TC_QTY

            else 0

            end as Week3, dateadd(day,21,@begdate)-1 Week3Date,

            case 

            when SERVICE_LINE_DATE >= dateadd(day,21,@begdate)

                        and SERVICE_LINE_DATE < dateadd(day,28,@begdate)   then TC_QTY

            else 0

            end as Week4,dateadd(day,28,@begdate)-1 Week4Date,

            case

            when SERVICE_LINE_DATE >= dateadd(day,28,@begdate)

                        and SERVICE_LINE_DATE < dateadd(day,35,@begdate)   then TC_QTY

            else 0

            end as Week5, dateadd(day,35,@begdate)-1 Week5Date

            from JOB_TIME_BY_JOB_V 

            where SERVICE_LINE_DATE >= @begdate and SERVICE_LINE_DATE < dateadd(day,35,@begdate)

            and left(job_no_varchar,3) = '109'
GO
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_OVERHEAD_HOURS]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec sp_CRYSTAL_OVERHEAD_HOURS '4/1/2005'
CREATE PROCEDURE [dbo].[sp_CRYSTAL_OVERHEAD_HOURS]
	@begdate datetime
AS
--declare @begdate datetime
--set @begdate =getdate()
	select *,case 
	when SERVICE_LINE_DATE >= @begdate
		and SERVICE_LINE_DATE < dateadd(day,7,@begdate)   then TC_QTY
	else 0
	end as Week1, dateadd(day,7,@begdate)-1 Week1Date,
	case 
	when SERVICE_LINE_DATE >= dateadd(day,7,@begdate)
		and SERVICE_LINE_DATE < dateadd(day,14,@begdate)   then TC_QTY
	else 0
	end as Week2, dateadd(day,14,@begdate)-1 Week2Date,
	case 
	when SERVICE_LINE_DATE >= dateadd(day,14,@begdate)
		and SERVICE_LINE_DATE < dateadd(day,21,@begdate)   then TC_QTY
	else 0
	end as Week3, dateadd(day,21,@begdate)-1 Week3Date,
	case 
	when SERVICE_LINE_DATE >= dateadd(day,21,@begdate)
		and SERVICE_LINE_DATE < dateadd(day,28,@begdate)   then TC_QTY
	else 0
	end as Week4,dateadd(day,28,@begdate)-1 Week4Date,
	case
	when SERVICE_LINE_DATE >= dateadd(day,28,@begdate)
		and SERVICE_LINE_DATE < dateadd(day,35,@begdate)   then TC_QTY
	else 0
	end as Week5, dateadd(day,35,@begdate)-1 Week5Date
	from JOB_TIME_BY_JOB_V 
	where SERVICE_LINE_DATE >= @begdate and SERVICE_LINE_DATE < dateadd(day,35,@begdate)
	and left(job_no_varchar,3) = '109'
GO
/****** Object:  UserDefinedFunction [dbo].[nextVal]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION [dbo].[nextVal]( @seq_name varchar)
RETURNS numeric 
AS  
BEGIN 
	Declare @seq_num numeric;
	exec getNextVal @seq_name, @seq_num;
	return @seq_num;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_QuoteLogReport]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*CREATE PROCEDURE NOW*/
CREATE procedure [dbo].[sp_CRYSTAL_QuoteLogReport]
    (
        @DateRangeStart            datetime
        ,@DateRangeEnd             datetime
--        ,@JobStatus                varchar(200) = '%'
        ,@ServiceSegment           varchar(200) = '%'
        ,@Organization               varchar(200) = '%'
        ,@SortBy                   varchar(200) = 'QuoteNumber'
        ,@SortOrder                varchar(10) = 'asc'
    )

as

set nocount on
set ansi_warnings off



/*get results*/
select 'QuoteNumber' = convert(varchar,r.project_no)+'-'+convert(varchar,r.request_no)+'.'+convert(varchar,r.version_no)
     , r.project_no
     , r.request_no
     , r.version_no
     , r.is_quoted
     , 'QuoteStatus' = case when won_quotes.quote_request_id is not null then 'Won' else 'Open' end
     , 'QuoteValue' = q.quote_total
     , r.est_start_date
     , 'OmniSalesPerson' = (
                select top 1 salesrep.contact_name
                from requests as sub_r (nolock)
                inner join contacts as salesrep (nolock) on sub_r.a_m_sales_contact_id = salesrep.contact_id
                where sub_r.request_id = r.request_id
                )
     ,'ServiceSegment' = /*logic from katz 2007-12-18*/
                case p.project_type_name
                    when 'Furniture' then 'NPI'
                    when 'National Services' then 'NS'
                    when 'Service Acct.' then 'MAC'
                    when 'Warehousing' then 'AM'
                    when 'Commercial Moving' then 'COM'
                    else 'Other'
                    end
--     , 'Customer' = p.dealer_name
     , 'Customer' = p.customer_name
     , 'CustomerContact' = (
                select top 1 contact_name
                from contacts (nolock)
                where contact_id = r.customer_contact_id
                order by date_created desc
                )
     , 'EndUser' = p.end_user_name
     , r.job_name
     , 'Organization' = o.name
into #ReturnTable --put data into temp table for sorting later
from requests_v as r (nolock)
    inner join quotes as q (nolock) on r.request_id = q.request_id and q.is_sent = 'y' and q.[ind_omni_discounted_bill-total] is not null
    left outer join requests as won_quotes (nolock) on r.request_id = won_quotes.quote_request_id and won_quotes.request_type_id = 325 --service_request
    left outer join projects_v as p (nolock) on r.project_id = p.project_id
    left outer join jobs_v as j (nolock) on p.project_id = j.project_id
    left outer join organizations as o (nolock) on r.organization_id = o.organization_id
where r.request_type_id = 324 --quote_request
    and r.is_sent = 'y' and r.is_quoted = 'y'
    and r.est_start_date >= @DateRangeStart and r.est_start_date <= @DateRangeEnd
    and isnull(o.name,'') like  case when @Organization = 'All' then '%' else @Organization end

/*take data and sort with the variable using dynamic sql*/
    --declare variable to put sql in to execute
    declare @sql varchar(1000)
    set @sql = 'select * from #ReturnTable '
            + 'where ServiceSegment like '''+case when @ServiceSegment = 'All' then '%' else @ServiceSegment end+''' '
            + 'order by '+@SortBy+' '+case @SortOrder when 'QuoteNumber' then 'project_no' else @SortOrder end+', project_no, request_no, version_no'
    exec(@sql)


return
GO
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_WonOpenQuoteReport]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*CREATE PROCEDURE NOW*/
create procedure [dbo].[sp_CRYSTAL_WonOpenQuoteReport]
    (
        @DateRangeStart            datetime
        ,@DateRangeEnd             datetime
        ,@Customer                 varchar(200) = 'All'
        ,@SortBy                   varchar(200) = 'OmniSalesPerson'
        ,@SortOrder                varchar(10) = 'asc'
    )

as

set nocount on
set ansi_warnings off




/*GET FIRST SET OF DATA AND PUT IN TEMP TABLE TO USE IN DIFFERENT WAYS LATER*/
select 'OmniSalesPerson' = isnull(OmniSalesPerson.contact_name,'')
     , 'Organization' = o.name
     , 'Customer' = p.customer_name
     , r.project_id, r.project_no
     , r.request_no, r.request_id
     , r.version_no
     , 'ServiceSegment' = max(/*logic from katz 2007-12-18*/
                case p.project_type_name
                    when 'Furniture' then 'NPI'
                    when 'National Services' then 'NS'
                    when 'Service Acct.' then 'MAC'
                    when 'Warehousing' then 'AM'
                    when 'Commercial Moving' then 'COM'
                    else 'Other'
                    end)
     , 'QuoteStatus' = isnull((
                    select convert(varchar(4),'Won') from requests as won_quotes (nolock) where won_quotes.request_type_id = 325/*service_request*/ and won_quotes.quote_request_id = r.request_id
                ),'Open')
     , 'quote_total' = sum(q.quote_total)
     , 'QuotedGP' = sum(q.quote_total) - sum(dbo.fn_StringToFloat([IND_OMNI_DIRECT_COST-TOTAL]))
     , 'QuotedGPPct' = 100*(sum(q.quote_total) - sum(dbo.fn_StringToFloat([IND_OMNI_DIRECT_COST-TOTAL])))/case when isnull(sum(q.quote_total),0) = 0 then null else sum(q.quote_total) end
into #tmpData_1 --putting data in temp table to simplify writing of query and to save server time later on
from requests_v as r (nolock)
    inner join projects_v as p (nolock) on r.project_id = p.project_id
    inner join quotes as q (nolock) on r.request_id = q.request_id and q.is_sent = 'y' and q.[ind_omni_discounted_bill-total] is not null
     left outer join (
            select r.request_id, 'contact_name' = c.contact_name
            from requests as r (nolock)
            inner join contacts as c (nolock) on r.a_m_sales_contact_id = c.contact_id
            ) as OmniSalesPerson on r.request_id = OmniSalesPerson.request_id
    left outer join organizations as o (nolock) on r.organization_id = o.organization_id
where r.request_type_id = 324 --quote_request
    and r.is_sent = 'y'
    and r.est_start_date >= @DateRangeStart and r.est_start_date <= @DateRangeEnd
    and isnull(p.customer_name,'') like case when @Customer = 'All' then '%' when  @Customer = 'None' then '' else @Customer end
group by isnull(OmniSalesPerson.contact_name,''), p.customer_name, o.name, r.project_id, r.project_no, r.request_no, r.request_id, r.version_no

--testing data from temp table
--select * from #tmpData_1


--using data from temp table to get final results
select d2.OmniSalesPerson
     , d2.Customer
     , d2.QuoteQuantity
     , d2.QuoteValue
     , d2.NumWon
     , d2.NumOpen
     , 'PctWon' = convert(decimal(10,0),100*convert(float,d2.NumWon)/case when isnull(d2.NumWon,0) + isnull(d2.NumOpen,0) = 0 then null else isnull(d2.NumWon,0) + isnull(d2.NumOpen,0) end)
     , 'PctOpen' = convert(decimal(10,0),100*convert(float,d2.NumOpen)/case when isnull(d2.NumWon,0) + isnull(d2.NumOpen,0) = 0 then null else isnull(d2.NumWon,0) + isnull(d2.NumOpen,0) end)
     , 'WonQuotes_ServiceSegments' = WonQuotes.ServiceSegments
     , 'WonQuotes_QuoteValue' = convert(decimal(10,2),WonQuotes.QuoteValue)
     , 'WonQuotes_SumQuotedGP' = convert(decimal(10,2),WonQuotes.SumQuotedGP)
     , 'WonQuotes_AvgQuotedGPPct' = convert(decimal(10,0),WonQuotes.AvgQuotedGPPct)
     , 'OpenQuotes_ServiceSegments' = OpenQuotes.ServiceSegments
     , 'OpenQuotes_QuoteValue' = convert(decimal(10,2),OpenQuotes.QuoteValue)
     , 'OpenQuotes_SumQuotedGP' = convert(decimal(10,2),OpenQuotes.SumQuotedGP)
     , 'OpenQuotes_AvgQuotedGPPct' = convert(decimal(10,0),OpenQuotes.AvgQuotedGPPct)
into #ReturnTable
from (
        select OmniSalesPerson
             , Customer
             , 'QuoteQuantity' = count(*)
             , 'QuoteValue' = sum(d.quote_total)
             , 'NumWon' = sum(case when d.QuoteStatus = 'won' then 1 else 0 end)
             , 'NumOpen' = sum(case when d.QuoteStatus = 'Open' then 1 else 0 end)
        from #tmpData_1 as d
        group by OmniSalesPerson, Customer
        ) as d2
    left outer join (
        select OmniSalesPerson
             , Customer
             , 'ServiceSegments' = substring(/*IF MORE THAN ONE SERVICE SEGMENT EXISTS THEN MAKE A COMMA DELIMITED LIST*/
                                        case when exists(select 1 from #tmpData_1 where ServiceSegment = 'NPI' and OmniSalesPerson = d.OmniSalesPerson) then ', NPI' else '' end
                                         + case when exists(select 1 from #tmpData_1 where ServiceSegment = 'NS' and OmniSalesPerson = d.OmniSalesPerson) then ', NS' else '' end
                                         + case when exists(select 1 from #tmpData_1 where ServiceSegment = 'MAC' and OmniSalesPerson = d.OmniSalesPerson) then ', MAC' else '' end 
                                         + case when exists(select 1 from #tmpData_1 where ServiceSegment = 'AM' and OmniSalesPerson = d.OmniSalesPerson) then ', AM' else '' end 
                                         + case when exists(select 1 from #tmpData_1 where ServiceSegment = 'COM' and OmniSalesPerson = d.OmniSalesPerson) then ', COM' else '' end 
                                         + case when exists(select 1 from #tmpData_1 where ServiceSegment = 'Other' and OmniSalesPerson = d.OmniSalesPerson) then ', Other' else '' end 
                                    ,3,1000)
             , 'QuoteValue' = sum(d.quote_total)
             , 'SumQuotedGP' = sum(d.QuotedGP)
             , 'AvgQuotedGPPct' = avg(d.QuotedGPPct)
        from #tmpData_1 as d
        where d.QuoteStatus = 'Won'
        group by OmniSalesPerson, Customer
        ) as WonQuotes on isnull(d2.OmniSalesPerson,'') = isnull(WonQuotes.OmniSalesPerson,'') and isnull(d2.Customer,'') = isnull(WonQuotes.Customer,'')
    left outer join (
        select OmniSalesPerson
             , Customer
             , 'ServiceSegments' = substring(/*IF MORE THAN ONE SERVICE SEGMENT EXISTS THEN MAKE A COMMA DELIMITED LIST*/
                                        case when exists(select 1 from #tmpData_1 where ServiceSegment = 'NPI' and OmniSalesPerson = d.OmniSalesPerson) then ', NPI' else '' end
                                         + case when exists(select 1 from #tmpData_1 where ServiceSegment = 'NS' and OmniSalesPerson = d.OmniSalesPerson) then ', NS' else '' end
                                         + case when exists(select 1 from #tmpData_1 where ServiceSegment = 'MAC' and OmniSalesPerson = d.OmniSalesPerson) then ', MAC' else '' end 
                                         + case when exists(select 1 from #tmpData_1 where ServiceSegment = 'AM' and OmniSalesPerson = d.OmniSalesPerson) then ', AM' else '' end 
                                         + case when exists(select 1 from #tmpData_1 where ServiceSegment = 'COM' and OmniSalesPerson = d.OmniSalesPerson) then ', COM' else '' end 
                                         + case when exists(select 1 from #tmpData_1 where ServiceSegment = 'Other' and OmniSalesPerson = d.OmniSalesPerson) then ', Other' else '' end 
                                    ,3,1000)
             , 'QuoteValue' = sum(d.quote_total)
             , 'SumQuotedGP' = sum(d.QuotedGP)
             , 'AvgQuotedGPPct' = avg(d.QuotedGPPct)
        from #tmpData_1 as d
        where d.QuoteStatus = 'Open'
        group by OmniSalesPerson, Customer
        ) as OpenQuotes on isnull(d2.OmniSalesPerson,'') = isnull(OpenQuotes.OmniSalesPerson,'') and isnull(d2.Customer,'') = isnull(OpenQuotes.Customer,'')


/*take data and sort with the variable using dynamic sql*/
    --declare variable to put sql in to execute
    declare @sql varchar(1000)
    set @sql = 'select * from #ReturnTable '
            + 'order by '+@SortBy+' '+@SortOrder+' '
    exec(@sql)



return
GO
