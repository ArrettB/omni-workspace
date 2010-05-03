/****** Object:  User [PHX]    Script Date: 03/02/2010 13:08:45 ******/
CREATE USER [PHX] FOR LOGIN [PHX] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [NTLSV]    Script Date: 03/02/2010 13:08:45 ******/
CREATE USER [NTLSV] FOR LOGIN [NTLSV] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [MAD]    Script Date: 03/02/2010 13:08:45 ******/
CREATE USER [MAD] FOR LOGIN [MAD] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [ims_new4]    Script Date: 03/02/2010 13:08:45 ******/
CREATE USER [ims_new4] FOR LOGIN [ims_new4] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [ICS]    Script Date: 03/02/2010 13:08:45 ******/
CREATE USER [ICS] FOR LOGIN [ICS] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [GP]    Script Date: 03/02/2010 13:08:45 ******/
CREATE USER [GP] FOR LOGIN [GP] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [ECMS]    Script Date: 03/02/2010 13:08:45 ******/
CREATE USER [ECMS] FOR LOGIN [ECMS] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [DYNSA]    Script Date: 03/02/2010 13:08:45 ******/
CREATE USER [DYNSA] FOR LOGIN [DYNSA] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [crystal]    Script Date: 03/02/2010 13:08:45 ******/
CREATE USER [crystal] FOR LOGIN [crystal] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [CIMN]    Script Date: 03/02/2010 13:08:45 ******/
CREATE USER [CIMN] FOR LOGIN [CIMN] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [CILLC]    Script Date: 03/02/2010 13:08:45 ******/
CREATE USER [CILLC] FOR LOGIN [CILLC] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [CIINC]    Script Date: 03/02/2010 13:08:45 ******/
CREATE USER [CIINC] FOR LOGIN [CIINC] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [ALABM]    Script Date: 03/02/2010 13:08:45 ******/
CREATE USER [ALABM] FOR LOGIN [ALABM] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [AIA]    Script Date: 03/02/2010 13:08:45 ******/
CREATE USER [AIA] FOR LOGIN [AIA] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_CREDIT_REPORT]    Script Date: 03/02/2010 13:08:53 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_AMEX_PENDING]    Script Date: 03/02/2010 13:08:53 ******/
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
/****** Object:  UserDefinedFunction [dbo].[sp_varchar20_to_number]    Script Date: 03/02/2010 13:08:54 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_UNBILLED_AGING]    Script Date: 03/02/2010 13:08:53 ******/
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
/****** Object:  UserDefinedFunction [dbo].[getShortName]    Script Date: 03/02/2010 13:08:54 ******/
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
/****** Object:  UserDefinedFunction [dbo].[getSortName]    Script Date: 03/02/2010 13:08:54 ******/
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
/****** Object:  UserDefinedFunction [dbo].[truncateDate]    Script Date: 03/02/2010 13:08:54 ******/
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
/****** Object:  StoredProcedure [dbo].[track_waitstats]    Script Date: 03/02/2010 13:08:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[track_waitstats] AS

IF EXISTS (SELECT 1 FROM sysobjects WHERE name = 'track_waitstats' AND type = 'P')
   DROP proc track_waitstats
GO
/****** Object:  StoredProcedure [dbo].[sp_reorder_req_no]    Script Date: 03/02/2010 13:08:54 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_OpenOrderReport]    Script Date: 03/02/2010 13:08:53 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_QualityPerformanceReport]    Script Date: 03/02/2010 13:08:53 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_AR_UNBILLED_REPORT]    Script Date: 03/02/2010 13:08:53 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_JobEfficiencyReport]    Script Date: 03/02/2010 13:08:53 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_JobCostReport]    Script Date: 03/02/2010 13:08:53 ******/
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
/****** Object:  UserDefinedFunction [dbo].[fn_StringToFloat]    Script Date: 03/02/2010 13:08:54 ******/
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
/****** Object:  StoredProcedure [dbo].[convert_date_to_time]    Script Date: 03/02/2010 13:08:53 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_estimator]    Script Date: 03/02/2010 13:08:54 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_aia_end_user]    Script Date: 03/02/2010 13:08:53 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_UNBILLED_REPORT_AMBIM_SALESNUMBERS]    Script Date: 03/02/2010 13:08:54 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_UNBILLED_REPORT_AMBIM_DEALERNUMBER_DATERANGE]    Script Date: 03/02/2010 13:08:54 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_UNBILLED_REPORT_CIINC]    Script Date: 03/02/2010 13:08:54 ******/
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
/****** Object:  StoredProcedure [dbo].[ottSOPIntegrationPrepAll]    Script Date: 03/02/2010 13:08:53 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_UNBILLED_REPORT_ICS_DATERANGE]    Script Date: 03/02/2010 13:08:54 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_UNBILLED_REPORT_CILLC_DATERANGE]    Script Date: 03/02/2010 13:08:54 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_UNBILLED_REPORT_CIMN]    Script Date: 03/02/2010 13:08:54 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_UNBILLED_REPORT_CIMN_DATERANGE]    Script Date: 03/02/2010 13:08:54 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_UNBILLED_REPORT_ICS]    Script Date: 03/02/2010 13:08:54 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_UNBILLED_REPORT_AMBIM]    Script Date: 03/02/2010 13:08:53 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_UNBILLED_REPORT_AIA]    Script Date: 03/02/2010 13:08:53 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_UNBILLED_REPORT_CIINC_DATERANGE]    Script Date: 03/02/2010 13:08:54 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_UNBILLED_REPORT_CILLC]    Script Date: 03/02/2010 13:08:54 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_UNBILLED_REPORT_AMBIM_DATERANGE]    Script Date: 03/02/2010 13:08:54 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_UNBILLED_REPORT_AMMAD]    Script Date: 03/02/2010 13:08:54 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_UNBILLED_REPORT_AMMAD_DATERANGE]    Script Date: 03/02/2010 13:08:54 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_UNBILLED_REPORT_AIA_DATERANGE]    Script Date: 03/02/2010 13:08:53 ******/
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
/****** Object:  StoredProcedure [dbo].[ottSOPIntegrationPrep]    Script Date: 03/02/2010 13:08:53 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_reorder_req_no2]    Script Date: 03/02/2010 13:08:54 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_reorder_service_no]    Script Date: 03/02/2010 13:08:54 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_UNBILLED_DASHBOARD_DSO]    Script Date: 03/02/2010 13:08:53 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_UNBILLED_REPORT]    Script Date: 03/02/2010 13:08:53 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_UNBILLED_REPORT_DAILYDATACAPTURE]    Script Date: 03/02/2010 13:08:54 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_BILLABLE_VS_NONBILLABLE2006]    Script Date: 03/02/2010 13:08:53 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_BILLABLE_VS_NONBILLABLE]    Script Date: 03/02/2010 13:08:53 ******/
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
/****** Object:  UserDefinedFunction [dbo].[fn_FurnitureLineListPerProjectID]    Script Date: 03/02/2010 13:08:54 ******/
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
/****** Object:  StoredProcedure [dbo].[getNextVal]    Script Date: 03/02/2010 13:08:53 ******/
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
/****** Object:  StoredProcedure [dbo].[ottSOPIntegrationPrepMadison]    Script Date: 03/02/2010 13:08:53 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_aia_direct_end_user]    Script Date: 03/02/2010 13:08:53 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_delete_duplicate_customers]    Script Date: 03/02/2010 13:08:54 ******/
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
/****** Object:  UserDefinedFunction [dbo].[fn_ProjectManagerListPerProjectID]    Script Date: 03/02/2010 13:08:54 ******/
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
/****** Object:  UserDefinedFunction [dbo].[sp_contact_phone]    Script Date: 03/02/2010 13:08:54 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_JobVarianceReport]    Script Date: 03/02/2010 13:08:53 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_JobCostReportWORK]    Script Date: 03/02/2010 13:08:53 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_PriceRealizationReport]    Script Date: 03/02/2010 13:08:53 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_OVERHEAD_HOURS_TCI]    Script Date: 03/02/2010 13:08:53 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_OVERHEAD_HOURS_NODATE]    Script Date: 03/02/2010 13:08:53 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_OVERHEAD_HOURS]    Script Date: 03/02/2010 13:08:53 ******/
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
/****** Object:  UserDefinedFunction [dbo].[nextVal]    Script Date: 03/02/2010 13:08:54 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_QuoteLogReport]    Script Date: 03/02/2010 13:08:53 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_CRYSTAL_WonOpenQuoteReport]    Script Date: 03/02/2010 13:08:54 ******/
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
/****** Object:  Check [ITEMS_COLUMN_POSITION_CHECK]    Script Date: 03/02/2010 13:08:45 ******/
ALTER TABLE [dbo].[ITEMS]  WITH CHECK ADD  CONSTRAINT [ITEMS_COLUMN_POSITION_CHECK] CHECK  (([COLUMN_POSITION] = 'material' or [COLUMN_POSITION] = 'subcontractor'))
GO
ALTER TABLE [dbo].[ITEMS] CHECK CONSTRAINT [ITEMS_COLUMN_POSITION_CHECK]
GO
/****** Object:  Check [SPREADSHEET_BILLING_YN]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[JOBS]  WITH CHECK ADD  CONSTRAINT [SPREADSHEET_BILLING_YN] CHECK  (([SPREADSHEET_BILLING_FLAG]='Y' OR [SPREADSHEET_BILLING_FLAG]='N'))
GO
ALTER TABLE [dbo].[JOBS] CHECK CONSTRAINT [SPREADSHEET_BILLING_YN]
GO
/****** Object:  Check [CSC_WO_FIELD_YN]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH CHECK ADD  CONSTRAINT [CSC_WO_FIELD_YN] CHECK  (([CSC_WO_FIELD_FLAG]='Y' OR [CSC_WO_FIELD_FLAG]='N'))
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [CSC_WO_FIELD_YN]
GO
/****** Object:  Check [PROD_DISP_YN]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH CHECK ADD  CONSTRAINT [PROD_DISP_YN] CHECK  (([PROD_DISP_FLAG]='Y' OR [PROD_DISP_FLAG]='N'))
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [PROD_DISP_YN]
GO
/****** Object:  Check [CK_STANDARD_CONDITIONS]    Script Date: 03/02/2010 13:08:47 ******/
ALTER TABLE [dbo].[STANDARD_CONDITIONS]  WITH CHECK ADD  CONSTRAINT [CK_STANDARD_CONDITIONS] CHECK  (([active_flag]='N' OR [active_flag]='Y'))
GO
ALTER TABLE [dbo].[STANDARD_CONDITIONS] CHECK CONSTRAINT [CK_STANDARD_CONDITIONS]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'BOOLEAN' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'STANDARD_CONDITIONS', @level2type=N'CONSTRAINT',@level2name=N'CK_STANDARD_CONDITIONS'
GO
/****** Object:  ForeignKey [FK_CHECKLIST_DATA_CHECKLISTS]    Script Date: 03/02/2010 13:08:45 ******/
ALTER TABLE [dbo].[CHECKLIST_DATA]  WITH NOCHECK ADD  CONSTRAINT [FK_CHECKLIST_DATA_CHECKLISTS] FOREIGN KEY([CHECKLIST_ID])
REFERENCES [dbo].[CHECKLISTS] ([CHECKLIST_ID])
GO
ALTER TABLE [dbo].[CHECKLIST_DATA] CHECK CONSTRAINT [FK_CHECKLIST_DATA_CHECKLISTS]
GO
/****** Object:  ForeignKey [FK_CHECKLISTS_REQUESTS]    Script Date: 03/02/2010 13:08:45 ******/
ALTER TABLE [dbo].[CHECKLISTS]  WITH NOCHECK ADD  CONSTRAINT [FK_CHECKLISTS_REQUESTS] FOREIGN KEY([REQUEST_ID])
REFERENCES [dbo].[REQUESTS] ([REQUEST_ID])
GO
ALTER TABLE [dbo].[CHECKLISTS] CHECK CONSTRAINT [FK_CHECKLISTS_REQUESTS]
GO
/****** Object:  ForeignKey [FK_CONTACT_GROUPS_CONTACTS]    Script Date: 03/02/2010 13:08:45 ******/
ALTER TABLE [dbo].[CONTACT_GROUPS]  WITH NOCHECK ADD  CONSTRAINT [FK_CONTACT_GROUPS_CONTACTS] FOREIGN KEY([CONTACT_ID])
REFERENCES [dbo].[CONTACTS] ([CONTACT_ID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CONTACT_GROUPS] CHECK CONSTRAINT [FK_CONTACT_GROUPS_CONTACTS]
GO
/****** Object:  ForeignKey [FK_CONTACT_GROUPS_LOOKUPS]    Script Date: 03/02/2010 13:08:45 ******/
ALTER TABLE [dbo].[CONTACT_GROUPS]  WITH NOCHECK ADD  CONSTRAINT [FK_CONTACT_GROUPS_LOOKUPS] FOREIGN KEY([CONTACT_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[CONTACT_GROUPS] NOCHECK CONSTRAINT [FK_CONTACT_GROUPS_LOOKUPS]
GO
/****** Object:  ForeignKey [FK_C_CONT_STATUS_TYPES]    Script Date: 03/02/2010 13:08:45 ******/
ALTER TABLE [dbo].[CONTACTS]  WITH NOCHECK ADD  CONSTRAINT [FK_C_CONT_STATUS_TYPES] FOREIGN KEY([CONT_STATUS_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[CONTACTS] CHECK CONSTRAINT [FK_C_CONT_STATUS_TYPES]
GO
/****** Object:  ForeignKey [FK_C_CONTACT_TYPES]    Script Date: 03/02/2010 13:08:45 ******/
ALTER TABLE [dbo].[CONTACTS]  WITH NOCHECK ADD  CONSTRAINT [FK_C_CONTACT_TYPES] FOREIGN KEY([CONTACT_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[CONTACTS] CHECK CONSTRAINT [FK_C_CONTACT_TYPES]
GO
/****** Object:  ForeignKey [FK_CONTACTS_CUSTOMERS]    Script Date: 03/02/2010 13:08:45 ******/
ALTER TABLE [dbo].[CONTACTS]  WITH NOCHECK ADD  CONSTRAINT [FK_CONTACTS_CUSTOMERS] FOREIGN KEY([CUSTOMER_ID])
REFERENCES [dbo].[CUSTOMERS] ([CUSTOMER_ID])
GO
ALTER TABLE [dbo].[CONTACTS] CHECK CONSTRAINT [FK_CONTACTS_CUSTOMERS]
GO
/****** Object:  ForeignKey [FK_CONTACTS_ORGANIZATIONS]    Script Date: 03/02/2010 13:08:45 ******/
ALTER TABLE [dbo].[CONTACTS]  WITH NOCHECK ADD  CONSTRAINT [FK_CONTACTS_ORGANIZATIONS] FOREIGN KEY([ORGANIZATION_ID])
REFERENCES [dbo].[ORGANIZATIONS] ([ORGANIZATION_ID])
GO
ALTER TABLE [dbo].[CONTACTS] CHECK CONSTRAINT [FK_CONTACTS_ORGANIZATIONS]
GO
/****** Object:  ForeignKey [FK_CUSTOM_COL_LISTS_CUSTOM_CUST_COLUMNS]    Script Date: 03/02/2010 13:08:45 ******/
ALTER TABLE [dbo].[CUSTOM_COL_LISTS]  WITH NOCHECK ADD  CONSTRAINT [FK_CUSTOM_COL_LISTS_CUSTOM_CUST_COLUMNS] FOREIGN KEY([CUSTOM_CUST_COL_ID])
REFERENCES [dbo].[CUSTOM_CUST_COLUMNS] ([CUSTOM_CUST_COL_ID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CUSTOM_COL_LISTS] CHECK CONSTRAINT [FK_CUSTOM_COL_LISTS_CUSTOM_CUST_COLUMNS]
GO
/****** Object:  ForeignKey [FK_CUSTOM_COLS_REQUESTS]    Script Date: 03/02/2010 13:08:45 ******/
ALTER TABLE [dbo].[CUSTOM_COLS]  WITH NOCHECK ADD  CONSTRAINT [FK_CUSTOM_COLS_REQUESTS] FOREIGN KEY([REQUEST_ID])
REFERENCES [dbo].[REQUESTS] ([REQUEST_ID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CUSTOM_COLS] CHECK CONSTRAINT [FK_CUSTOM_COLS_REQUESTS]
GO
/****** Object:  ForeignKey [FK_CUSTOM_CUST_COLUMNS_CUSTOMERS]    Script Date: 03/02/2010 13:08:45 ******/
ALTER TABLE [dbo].[CUSTOM_CUST_COLUMNS]  WITH NOCHECK ADD  CONSTRAINT [FK_CUSTOM_CUST_COLUMNS_CUSTOMERS] FOREIGN KEY([CUSTOMER_ID])
REFERENCES [dbo].[CUSTOMERS] ([CUSTOMER_ID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CUSTOM_CUST_COLUMNS] CHECK CONSTRAINT [FK_CUSTOM_CUST_COLUMNS_CUSTOMERS]
GO
/****** Object:  ForeignKey [fk_customer_customer_type]    Script Date: 03/02/2010 13:08:45 ******/
ALTER TABLE [dbo].[CUSTOMERS]  WITH CHECK ADD  CONSTRAINT [fk_customer_customer_type] FOREIGN KEY([customer_type_id])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[CUSTOMERS] CHECK CONSTRAINT [fk_customer_customer_type]
GO
/****** Object:  ForeignKey [fk_customer_end_user_parent]    Script Date: 03/02/2010 13:08:45 ******/
ALTER TABLE [dbo].[CUSTOMERS]  WITH CHECK ADD  CONSTRAINT [fk_customer_end_user_parent] FOREIGN KEY([end_user_parent_id])
REFERENCES [dbo].[CUSTOMERS] ([CUSTOMER_ID])
GO
ALTER TABLE [dbo].[CUSTOMERS] CHECK CONSTRAINT [fk_customer_end_user_parent]
GO
/****** Object:  ForeignKey [fk_customer_parent]    Script Date: 03/02/2010 13:08:45 ******/
ALTER TABLE [dbo].[CUSTOMERS]  WITH CHECK ADD  CONSTRAINT [fk_customer_parent] FOREIGN KEY([PARENT_CUSTOMER_ID])
REFERENCES [dbo].[CUSTOMERS] ([CUSTOMER_ID])
GO
ALTER TABLE [dbo].[CUSTOMERS] CHECK CONSTRAINT [fk_customer_parent]
GO
/****** Object:  ForeignKey [FK_CUSTOMERS_ORGANIZATIONS]    Script Date: 03/02/2010 13:08:45 ******/
ALTER TABLE [dbo].[CUSTOMERS]  WITH NOCHECK ADD  CONSTRAINT [FK_CUSTOMERS_ORGANIZATIONS] FOREIGN KEY([ORGANIZATION_ID])
REFERENCES [dbo].[ORGANIZATIONS] ([ORGANIZATION_ID])
GO
ALTER TABLE [dbo].[CUSTOMERS] NOCHECK CONSTRAINT [FK_CUSTOMERS_ORGANIZATIONS]
GO
/****** Object:  ForeignKey [FK_DOCUMENTS_FORMATS]    Script Date: 03/02/2010 13:08:45 ******/
ALTER TABLE [dbo].[DOCUMENTS]  WITH NOCHECK ADD  CONSTRAINT [FK_DOCUMENTS_FORMATS] FOREIGN KEY([FORMAT_ID])
REFERENCES [dbo].[FORMATS] ([FORMAT_ID])
GO
ALTER TABLE [dbo].[DOCUMENTS] CHECK CONSTRAINT [FK_DOCUMENTS_FORMATS]
GO
/****** Object:  ForeignKey [FK_DOCUMENTS_PROJECTS]    Script Date: 03/02/2010 13:08:45 ******/
ALTER TABLE [dbo].[DOCUMENTS]  WITH NOCHECK ADD  CONSTRAINT [FK_DOCUMENTS_PROJECTS] FOREIGN KEY([PROJECT_ID])
REFERENCES [dbo].[PROJECTS] ([PROJECT_ID])
GO
ALTER TABLE [dbo].[DOCUMENTS] NOCHECK CONSTRAINT [FK_DOCUMENTS_PROJECTS]
GO
/****** Object:  ForeignKey [FK_FRT_RIGHT_TYPES]    Script Date: 03/02/2010 13:08:45 ******/
ALTER TABLE [dbo].[FUNCTION_RIGHT_TYPES]  WITH NOCHECK ADD  CONSTRAINT [FK_FRT_RIGHT_TYPES] FOREIGN KEY([RIGHT_TYPE_ID])
REFERENCES [dbo].[RIGHT_TYPES] ([RIGHT_TYPE_ID])
GO
ALTER TABLE [dbo].[FUNCTION_RIGHT_TYPES] CHECK CONSTRAINT [FK_FRT_RIGHT_TYPES]
GO
/****** Object:  ForeignKey [FK_FUNCTION_RIGHT_TYPES_FUNCTIONS]    Script Date: 03/02/2010 13:08:45 ******/
ALTER TABLE [dbo].[FUNCTION_RIGHT_TYPES]  WITH CHECK ADD  CONSTRAINT [FK_FUNCTION_RIGHT_TYPES_FUNCTIONS] FOREIGN KEY([FUNCTION_ID])
REFERENCES [dbo].[FUNCTIONS] ([FUNCTION_ID])
GO
ALTER TABLE [dbo].[FUNCTION_RIGHT_TYPES] CHECK CONSTRAINT [FK_FUNCTION_RIGHT_TYPES_FUNCTIONS]
GO
/****** Object:  ForeignKey [FK_FUNCTIONS_FUNCTION_GROUPS]    Script Date: 03/02/2010 13:08:45 ******/
ALTER TABLE [dbo].[FUNCTIONS]  WITH NOCHECK ADD  CONSTRAINT [FK_FUNCTIONS_FUNCTION_GROUPS] FOREIGN KEY([FUNCTION_GROUP_ID])
REFERENCES [dbo].[FUNCTION_GROUPS] ([FUNCTION_GROUP_ID])
GO
ALTER TABLE [dbo].[FUNCTIONS] CHECK CONSTRAINT [FK_FUNCTIONS_FUNCTION_GROUPS]
GO
/****** Object:  ForeignKey [FK_FUNCTIONS_TEMPLATE_LOCATIONS]    Script Date: 03/02/2010 13:08:45 ******/
ALTER TABLE [dbo].[FUNCTIONS]  WITH CHECK ADD  CONSTRAINT [FK_FUNCTIONS_TEMPLATE_LOCATIONS] FOREIGN KEY([TEMPLATE_LOCATION_ID])
REFERENCES [dbo].[TEMPLATE_LOCATIONS] ([TEMPLATE_LOCATION_ID])
GO
ALTER TABLE [dbo].[FUNCTIONS] CHECK CONSTRAINT [FK_FUNCTIONS_TEMPLATE_LOCATIONS]
GO
/****** Object:  ForeignKey [FK_FUNCTIONS_TEMPLATES]    Script Date: 03/02/2010 13:08:45 ******/
ALTER TABLE [dbo].[FUNCTIONS]  WITH CHECK ADD  CONSTRAINT [FK_FUNCTIONS_TEMPLATES] FOREIGN KEY([TEMPLATE_ID])
REFERENCES [dbo].[TEMPLATES] ([TEMPLATE_ID])
GO
ALTER TABLE [dbo].[FUNCTIONS] CHECK CONSTRAINT [FK_FUNCTIONS_TEMPLATES]
GO
/****** Object:  ForeignKey [fk_il_bill_service_id]    Script Date: 03/02/2010 13:08:45 ******/
ALTER TABLE [dbo].[INVOICE_LINES]  WITH CHECK ADD  CONSTRAINT [fk_il_bill_service_id] FOREIGN KEY([bill_service_id])
REFERENCES [dbo].[SERVICES] ([SERVICE_ID])
GO
ALTER TABLE [dbo].[INVOICE_LINES] CHECK CONSTRAINT [fk_il_bill_service_id]
GO
/****** Object:  ForeignKey [FK_IL_INVOICES]    Script Date: 03/02/2010 13:08:45 ******/
ALTER TABLE [dbo].[INVOICE_LINES]  WITH NOCHECK ADD  CONSTRAINT [FK_IL_INVOICES] FOREIGN KEY([INVOICE_ID])
REFERENCES [dbo].[INVOICES] ([INVOICE_ID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[INVOICE_LINES] CHECK CONSTRAINT [FK_IL_INVOICES]
GO
/****** Object:  ForeignKey [FK_IL_ITEMS]    Script Date: 03/02/2010 13:08:45 ******/
ALTER TABLE [dbo].[INVOICE_LINES]  WITH NOCHECK ADD  CONSTRAINT [FK_IL_ITEMS] FOREIGN KEY([ITEM_ID])
REFERENCES [dbo].[ITEMS] ([ITEM_ID])
GO
ALTER TABLE [dbo].[INVOICE_LINES] CHECK CONSTRAINT [FK_IL_ITEMS]
GO
/****** Object:  ForeignKey [FK_IL_TYPES]    Script Date: 03/02/2010 13:08:45 ******/
ALTER TABLE [dbo].[INVOICE_LINES]  WITH NOCHECK ADD  CONSTRAINT [FK_IL_TYPES] FOREIGN KEY([INVOICE_LINE_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[INVOICE_LINES] CHECK CONSTRAINT [FK_IL_TYPES]
GO
/****** Object:  ForeignKey [FK_IT_CONTACTS]    Script Date: 03/02/2010 13:08:45 ******/
ALTER TABLE [dbo].[INVOICE_TRACKING]  WITH NOCHECK ADD  CONSTRAINT [FK_IT_CONTACTS] FOREIGN KEY([TO_CONTACT_ID])
REFERENCES [dbo].[CONTACTS] ([CONTACT_ID])
GO
ALTER TABLE [dbo].[INVOICE_TRACKING] CHECK CONSTRAINT [FK_IT_CONTACTS]
GO
/****** Object:  ForeignKey [FK_IT_INVOICE_TRACKING_TYPES]    Script Date: 03/02/2010 13:08:45 ******/
ALTER TABLE [dbo].[INVOICE_TRACKING]  WITH NOCHECK ADD  CONSTRAINT [FK_IT_INVOICE_TRACKING_TYPES] FOREIGN KEY([INVOICE_TRACKING_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[INVOICE_TRACKING] CHECK CONSTRAINT [FK_IT_INVOICE_TRACKING_TYPES]
GO
/****** Object:  ForeignKey [FK_IT_INVOICES]    Script Date: 03/02/2010 13:08:45 ******/
ALTER TABLE [dbo].[INVOICE_TRACKING]  WITH NOCHECK ADD  CONSTRAINT [FK_IT_INVOICES] FOREIGN KEY([INVOICE_ID])
REFERENCES [dbo].[INVOICES] ([INVOICE_ID])
GO
ALTER TABLE [dbo].[INVOICE_TRACKING] CHECK CONSTRAINT [FK_IT_INVOICES]
GO
/****** Object:  ForeignKey [FK_IT_NEW_INVOICE_STATUSES]    Script Date: 03/02/2010 13:08:45 ******/
ALTER TABLE [dbo].[INVOICE_TRACKING]  WITH NOCHECK ADD  CONSTRAINT [FK_IT_NEW_INVOICE_STATUSES] FOREIGN KEY([NEW_STATUS_ID])
REFERENCES [dbo].[INVOICE_STATUSES] ([STATUS_ID])
GO
ALTER TABLE [dbo].[INVOICE_TRACKING] CHECK CONSTRAINT [FK_IT_NEW_INVOICE_STATUSES]
GO
/****** Object:  ForeignKey [FK_IT_OLD_INVOICE_STATUSES]    Script Date: 03/02/2010 13:08:45 ******/
ALTER TABLE [dbo].[INVOICE_TRACKING]  WITH NOCHECK ADD  CONSTRAINT [FK_IT_OLD_INVOICE_STATUSES] FOREIGN KEY([OLD_STATUS_ID])
REFERENCES [dbo].[INVOICE_STATUSES] ([STATUS_ID])
GO
ALTER TABLE [dbo].[INVOICE_TRACKING] CHECK CONSTRAINT [FK_IT_OLD_INVOICE_STATUSES]
GO
/****** Object:  ForeignKey [FK_I_BATCH_STATUSES]    Script Date: 03/02/2010 13:08:45 ******/
ALTER TABLE [dbo].[INVOICES]  WITH NOCHECK ADD  CONSTRAINT [FK_I_BATCH_STATUSES] FOREIGN KEY([BATCH_STATUS_ID])
REFERENCES [dbo].[INVOICE_BATCH_STATUSES] ([STATUS_ID])
GO
ALTER TABLE [dbo].[INVOICES] CHECK CONSTRAINT [FK_I_BATCH_STATUSES]
GO
/****** Object:  ForeignKey [FK_I_BILLING_TYPES]    Script Date: 03/02/2010 13:08:45 ******/
ALTER TABLE [dbo].[INVOICES]  WITH NOCHECK ADD  CONSTRAINT [FK_I_BILLING_TYPES] FOREIGN KEY([BILLING_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[INVOICES] CHECK CONSTRAINT [FK_I_BILLING_TYPES]
GO
/****** Object:  ForeignKey [FK_I_CUSTOMERS]    Script Date: 03/02/2010 13:08:45 ******/
ALTER TABLE [dbo].[INVOICES]  WITH NOCHECK ADD  CONSTRAINT [FK_I_CUSTOMERS] FOREIGN KEY([BILL_CUSTOMER_ID])
REFERENCES [dbo].[CUSTOMERS] ([CUSTOMER_ID])
GO
ALTER TABLE [dbo].[INVOICES] CHECK CONSTRAINT [FK_I_CUSTOMERS]
GO
/****** Object:  ForeignKey [FK_I_INVOICE_FORMAT_TYPES]    Script Date: 03/02/2010 13:08:45 ******/
ALTER TABLE [dbo].[INVOICES]  WITH NOCHECK ADD  CONSTRAINT [FK_I_INVOICE_FORMAT_TYPES] FOREIGN KEY([INVOICE_FORMAT_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[INVOICES] CHECK CONSTRAINT [FK_I_INVOICE_FORMAT_TYPES]
GO
/****** Object:  ForeignKey [FK_I_INVOICE_STATUSES]    Script Date: 03/02/2010 13:08:45 ******/
ALTER TABLE [dbo].[INVOICES]  WITH NOCHECK ADD  CONSTRAINT [FK_I_INVOICE_STATUSES] FOREIGN KEY([STATUS_ID])
REFERENCES [dbo].[INVOICE_STATUSES] ([STATUS_ID])
GO
ALTER TABLE [dbo].[INVOICES] CHECK CONSTRAINT [FK_I_INVOICE_STATUSES]
GO
/****** Object:  ForeignKey [FK_I_INVOICE_TYPES]    Script Date: 03/02/2010 13:08:45 ******/
ALTER TABLE [dbo].[INVOICES]  WITH NOCHECK ADD  CONSTRAINT [FK_I_INVOICE_TYPES] FOREIGN KEY([INVOICE_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[INVOICES] CHECK CONSTRAINT [FK_I_INVOICE_TYPES]
GO
/****** Object:  ForeignKey [FK_I_JOBS]    Script Date: 03/02/2010 13:08:45 ******/
ALTER TABLE [dbo].[INVOICES]  WITH NOCHECK ADD  CONSTRAINT [FK_I_JOBS] FOREIGN KEY([JOB_ID])
REFERENCES [dbo].[JOBS] ([JOB_ID])
GO
ALTER TABLE [dbo].[INVOICES] CHECK CONSTRAINT [FK_I_JOBS]
GO
/****** Object:  ForeignKey [FK_I_ORGANIZATIONS]    Script Date: 03/02/2010 13:08:45 ******/
ALTER TABLE [dbo].[INVOICES]  WITH NOCHECK ADD  CONSTRAINT [FK_I_ORGANIZATIONS] FOREIGN KEY([ORGANIZATION_ID])
REFERENCES [dbo].[ORGANIZATIONS] ([ORGANIZATION_ID])
GO
ALTER TABLE [dbo].[INVOICES] CHECK CONSTRAINT [FK_I_ORGANIZATIONS]
GO
/****** Object:  ForeignKey [FK_I_STATUSES]    Script Date: 03/02/2010 13:08:45 ******/
ALTER TABLE [dbo].[INVOICES]  WITH NOCHECK ADD  CONSTRAINT [FK_I_STATUSES] FOREIGN KEY([STATUS_ID])
REFERENCES [dbo].[INVOICE_STATUSES] ([STATUS_ID])
GO
ALTER TABLE [dbo].[INVOICES] CHECK CONSTRAINT [FK_I_STATUSES]
GO
/****** Object:  ForeignKey [FK_ITEMS_ITEM_ID]    Script Date: 03/02/2010 13:08:45 ******/
ALTER TABLE [dbo].[ITEM_COSTING_HISTORY]  WITH CHECK ADD  CONSTRAINT [FK_ITEMS_ITEM_ID] FOREIGN KEY([ITEM_ID])
REFERENCES [dbo].[ITEMS] ([ITEM_ID])
GO
ALTER TABLE [dbo].[ITEM_COSTING_HISTORY] CHECK CONSTRAINT [FK_ITEMS_ITEM_ID]
GO
/****** Object:  ForeignKey [FK_ITEM_ORGANIZATIONS]    Script Date: 03/02/2010 13:08:45 ******/
ALTER TABLE [dbo].[ITEMS]  WITH NOCHECK ADD  CONSTRAINT [FK_ITEM_ORGANIZATIONS] FOREIGN KEY([ORGANIZATION_ID])
REFERENCES [dbo].[ORGANIZATIONS] ([ORGANIZATION_ID])
GO
ALTER TABLE [dbo].[ITEMS] CHECK CONSTRAINT [FK_ITEM_ORGANIZATIONS]
GO
/****** Object:  ForeignKey [FK_ITEM_STATUSES]    Script Date: 03/02/2010 13:08:45 ******/
ALTER TABLE [dbo].[ITEMS]  WITH NOCHECK ADD  CONSTRAINT [FK_ITEM_STATUSES] FOREIGN KEY([ITEM_STATUS_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[ITEMS] CHECK CONSTRAINT [FK_ITEM_STATUSES]
GO
/****** Object:  ForeignKey [FK_ITEM_TYPES]    Script Date: 03/02/2010 13:08:45 ******/
ALTER TABLE [dbo].[ITEMS]  WITH NOCHECK ADD  CONSTRAINT [FK_ITEM_TYPES] FOREIGN KEY([ITEM_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[ITEMS] CHECK CONSTRAINT [FK_ITEM_TYPES]
GO
/****** Object:  ForeignKey [fk_items_category_lookups]    Script Date: 03/02/2010 13:08:45 ******/
ALTER TABLE [dbo].[ITEMS]  WITH CHECK ADD  CONSTRAINT [fk_items_category_lookups] FOREIGN KEY([item_category_type_id])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[ITEMS] CHECK CONSTRAINT [fk_items_category_lookups]
GO
/****** Object:  ForeignKey [FK_ITEMS_TYPE_TYPES]    Script Date: 03/02/2010 13:08:45 ******/
ALTER TABLE [dbo].[ITEMS]  WITH CHECK ADD  CONSTRAINT [FK_ITEMS_TYPE_TYPES] FOREIGN KEY([JOB_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[ITEMS] CHECK CONSTRAINT [FK_ITEMS_TYPE_TYPES]
GO
/****** Object:  ForeignKey [FK_JD_JOBS]    Script Date: 03/02/2010 13:08:45 ******/
ALTER TABLE [dbo].[JOB_DISTRIBUTIONS]  WITH NOCHECK ADD  CONSTRAINT [FK_JD_JOBS] FOREIGN KEY([JOB_ID])
REFERENCES [dbo].[JOBS] ([JOB_ID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[JOB_DISTRIBUTIONS] CHECK CONSTRAINT [FK_JD_JOBS]
GO
/****** Object:  ForeignKey [FK_JIR_ITEMS]    Script Date: 03/02/2010 13:08:45 ******/
ALTER TABLE [dbo].[JOB_ITEM_RATES]  WITH NOCHECK ADD  CONSTRAINT [FK_JIR_ITEMS] FOREIGN KEY([ITEM_ID])
REFERENCES [dbo].[ITEMS] ([ITEM_ID])
GO
ALTER TABLE [dbo].[JOB_ITEM_RATES] CHECK CONSTRAINT [FK_JIR_ITEMS]
GO
/****** Object:  ForeignKey [FK_JIR_JOBS]    Script Date: 03/02/2010 13:08:45 ******/
ALTER TABLE [dbo].[JOB_ITEM_RATES]  WITH NOCHECK ADD  CONSTRAINT [FK_JIR_JOBS] FOREIGN KEY([JOB_ID])
REFERENCES [dbo].[JOBS] ([JOB_ID])
GO
ALTER TABLE [dbo].[JOB_ITEM_RATES] CHECK CONSTRAINT [FK_JIR_JOBS]
GO
/****** Object:  ForeignKey [FK_JIR_UOMS]    Script Date: 03/02/2010 13:08:45 ******/
ALTER TABLE [dbo].[JOB_ITEM_RATES]  WITH NOCHECK ADD  CONSTRAINT [FK_JIR_UOMS] FOREIGN KEY([UOM_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[JOB_ITEM_RATES] CHECK CONSTRAINT [FK_JIR_UOMS]
GO
/****** Object:  ForeignKey [FK_jlc_contact]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[job_location_contacts]  WITH CHECK ADD  CONSTRAINT [FK_jlc_contact] FOREIGN KEY([contact_id])
REFERENCES [dbo].[CONTACTS] ([CONTACT_ID])
GO
ALTER TABLE [dbo].[job_location_contacts] CHECK CONSTRAINT [FK_jlc_contact]
GO
/****** Object:  ForeignKey [FK_jlc_job_location]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[job_location_contacts]  WITH CHECK ADD  CONSTRAINT [FK_jlc_job_location] FOREIGN KEY([job_location_id])
REFERENCES [dbo].[JOB_LOCATIONS] ([JOB_LOCATION_ID])
GO
ALTER TABLE [dbo].[job_location_contacts] CHECK CONSTRAINT [FK_jlc_job_location]
GO
/****** Object:  ForeignKey [FK_JL_BLDG_CONTACTS]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[JOB_LOCATIONS]  WITH NOCHECK ADD  CONSTRAINT [FK_JL_BLDG_CONTACTS] FOREIGN KEY([BLDG_MGMT_CONTACT_ID])
REFERENCES [dbo].[CONTACTS] ([CONTACT_ID])
GO
ALTER TABLE [dbo].[JOB_LOCATIONS] CHECK CONSTRAINT [FK_JL_BLDG_CONTACTS]
GO
/****** Object:  ForeignKey [FK_JL_CONTACTS]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[JOB_LOCATIONS]  WITH NOCHECK ADD  CONSTRAINT [FK_JL_CONTACTS] FOREIGN KEY([JOB_LOC_CONTACT_ID])
REFERENCES [dbo].[CONTACTS] ([CONTACT_ID])
GO
ALTER TABLE [dbo].[JOB_LOCATIONS] CHECK CONSTRAINT [FK_JL_CONTACTS]
GO
/****** Object:  ForeignKey [FK_JL_CUSTOMERS]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[JOB_LOCATIONS]  WITH NOCHECK ADD  CONSTRAINT [FK_JL_CUSTOMERS] FOREIGN KEY([CUSTOMER_ID])
REFERENCES [dbo].[CUSTOMERS] ([CUSTOMER_ID])
GO
ALTER TABLE [dbo].[JOB_LOCATIONS] CHECK CONSTRAINT [FK_JL_CUSTOMERS]
GO
/****** Object:  ForeignKey [FK_JL_DOCK_RESERV_REQ_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[JOB_LOCATIONS]  WITH NOCHECK ADD  CONSTRAINT [FK_JL_DOCK_RESERV_REQ_TYPES] FOREIGN KEY([DOCK_RESERV_REQ_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[JOB_LOCATIONS] CHECK CONSTRAINT [FK_JL_DOCK_RESERV_REQ_TYPES]
GO
/****** Object:  ForeignKey [FK_JL_DOOR_PROT_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[JOB_LOCATIONS]  WITH NOCHECK ADD  CONSTRAINT [FK_JL_DOOR_PROT_TYPES] FOREIGN KEY([DOORWAY_PROT_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[JOB_LOCATIONS] CHECK CONSTRAINT [FK_JL_DOOR_PROT_TYPES]
GO
/****** Object:  ForeignKey [FK_JL_ELEV_AVAIL_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[JOB_LOCATIONS]  WITH NOCHECK ADD  CONSTRAINT [FK_JL_ELEV_AVAIL_TYPES] FOREIGN KEY([ELEVATOR_AVAIL_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[JOB_LOCATIONS] CHECK CONSTRAINT [FK_JL_ELEV_AVAIL_TYPES]
GO
/****** Object:  ForeignKey [FK_JL_ELEV_RESERV_REQ_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[JOB_LOCATIONS]  WITH NOCHECK ADD  CONSTRAINT [FK_JL_ELEV_RESERV_REQ_TYPES] FOREIGN KEY([ELEVATOR_RESERV_REQ_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[JOB_LOCATIONS] CHECK CONSTRAINT [FK_JL_ELEV_RESERV_REQ_TYPES]
GO
/****** Object:  ForeignKey [FK_JL_FLOOR_PROT_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[JOB_LOCATIONS]  WITH NOCHECK ADD  CONSTRAINT [FK_JL_FLOOR_PROT_TYPES] FOREIGN KEY([FLOOR_PROTECTION_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[JOB_LOCATIONS] CHECK CONSTRAINT [FK_JL_FLOOR_PROT_TYPES]
GO
/****** Object:  ForeignKey [FK_JL_LOADING_DOCK_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[JOB_LOCATIONS]  WITH NOCHECK ADD  CONSTRAINT [FK_JL_LOADING_DOCK_TYPES] FOREIGN KEY([LOADING_DOCK_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[JOB_LOCATIONS] CHECK CONSTRAINT [FK_JL_LOADING_DOCK_TYPES]
GO
/****** Object:  ForeignKey [FK_JL_MULTI_LEVEL_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[JOB_LOCATIONS]  WITH NOCHECK ADD  CONSTRAINT [FK_JL_MULTI_LEVEL_TYPES] FOREIGN KEY([MULTI_LEVEL_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[JOB_LOCATIONS] CHECK CONSTRAINT [FK_JL_MULTI_LEVEL_TYPES]
GO
/****** Object:  ForeignKey [FK_JL_SECURITY_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[JOB_LOCATIONS]  WITH NOCHECK ADD  CONSTRAINT [FK_JL_SECURITY_TYPES] FOREIGN KEY([SECURITY_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[JOB_LOCATIONS] CHECK CONSTRAINT [FK_JL_SECURITY_TYPES]
GO
/****** Object:  ForeignKey [FK_JL_SEMI_ACCESS_TYES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[JOB_LOCATIONS]  WITH NOCHECK ADD  CONSTRAINT [FK_JL_SEMI_ACCESS_TYES] FOREIGN KEY([SEMI_ACCESS_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[JOB_LOCATIONS] CHECK CONSTRAINT [FK_JL_SEMI_ACCESS_TYES]
GO
/****** Object:  ForeignKey [FK_JL_STAIR_CARRY_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[JOB_LOCATIONS]  WITH NOCHECK ADD  CONSTRAINT [FK_JL_STAIR_CARRY_TYPES] FOREIGN KEY([STAIR_CARRY_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[JOB_LOCATIONS] CHECK CONSTRAINT [FK_JL_STAIR_CARRY_TYPES]
GO
/****** Object:  ForeignKey [FK_JL_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[JOB_LOCATIONS]  WITH NOCHECK ADD  CONSTRAINT [FK_JL_TYPES] FOREIGN KEY([LOCATION_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[JOB_LOCATIONS] CHECK CONSTRAINT [FK_JL_TYPES]
GO
/****** Object:  ForeignKey [FK_JL_USERS_C]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[JOB_LOCATIONS]  WITH NOCHECK ADD  CONSTRAINT [FK_JL_USERS_C] FOREIGN KEY([CREATED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[JOB_LOCATIONS] CHECK CONSTRAINT [FK_JL_USERS_C]
GO
/****** Object:  ForeignKey [FK_JL_USERS_M]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[JOB_LOCATIONS]  WITH NOCHECK ADD  CONSTRAINT [FK_JL_USERS_M] FOREIGN KEY([MODIFIED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[JOB_LOCATIONS] CHECK CONSTRAINT [FK_JL_USERS_M]
GO
/****** Object:  ForeignKey [FK_JL_WALL_PROT_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[JOB_LOCATIONS]  WITH NOCHECK ADD  CONSTRAINT [FK_JL_WALL_PROT_TYPES] FOREIGN KEY([WALL_PROTECTION_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[JOB_LOCATIONS] CHECK CONSTRAINT [FK_JL_WALL_PROT_TYPES]
GO
/****** Object:  ForeignKey [fk_job_end_user]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[JOBS]  WITH CHECK ADD  CONSTRAINT [fk_job_end_user] FOREIGN KEY([end_user_id])
REFERENCES [dbo].[CUSTOMERS] ([CUSTOMER_ID])
GO
ALTER TABLE [dbo].[JOBS] CHECK CONSTRAINT [fk_job_end_user]
GO
/****** Object:  ForeignKey [FK_JOBS_BILLING_USERS]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[JOBS]  WITH NOCHECK ADD  CONSTRAINT [FK_JOBS_BILLING_USERS] FOREIGN KEY([BILLING_USER_ID])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[JOBS] CHECK CONSTRAINT [FK_JOBS_BILLING_USERS]
GO
/****** Object:  ForeignKey [FK_JOBS_CUSTOMERS]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[JOBS]  WITH NOCHECK ADD  CONSTRAINT [FK_JOBS_CUSTOMERS] FOREIGN KEY([CUSTOMER_ID])
REFERENCES [dbo].[CUSTOMERS] ([CUSTOMER_ID])
GO
ALTER TABLE [dbo].[JOBS] CHECK CONSTRAINT [FK_JOBS_CUSTOMERS]
GO
/****** Object:  ForeignKey [FK_JOBS_FOREMAN_RESOURCES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[JOBS]  WITH NOCHECK ADD  CONSTRAINT [FK_JOBS_FOREMAN_RESOURCES] FOREIGN KEY([FOREMAN_RESOURCE_ID])
REFERENCES [dbo].[RESOURCES] ([RESOURCE_ID])
GO
ALTER TABLE [dbo].[JOBS] CHECK CONSTRAINT [FK_JOBS_FOREMAN_RESOURCES]
GO
/****** Object:  ForeignKey [FK_JOBS_PROJECTS]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[JOBS]  WITH NOCHECK ADD  CONSTRAINT [FK_JOBS_PROJECTS] FOREIGN KEY([PROJECT_ID])
REFERENCES [dbo].[PROJECTS] ([PROJECT_ID])
GO
ALTER TABLE [dbo].[JOBS] CHECK CONSTRAINT [FK_JOBS_PROJECTS]
GO
/****** Object:  ForeignKey [FK_JOBS_STATUSES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[JOBS]  WITH NOCHECK ADD  CONSTRAINT [FK_JOBS_STATUSES] FOREIGN KEY([JOB_STATUS_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[JOBS] CHECK CONSTRAINT [FK_JOBS_STATUSES]
GO
/****** Object:  ForeignKey [FK_JOBS_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[JOBS]  WITH NOCHECK ADD  CONSTRAINT [FK_JOBS_TYPES] FOREIGN KEY([JOB_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[JOBS] CHECK CONSTRAINT [FK_JOBS_TYPES]
GO
/****** Object:  ForeignKey [FK_JOBS_USERS_C]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[JOBS]  WITH NOCHECK ADD  CONSTRAINT [FK_JOBS_USERS_C] FOREIGN KEY([CREATED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[JOBS] CHECK CONSTRAINT [FK_JOBS_USERS_C]
GO
/****** Object:  ForeignKey [FK_JOBS_USERS_M]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[JOBS]  WITH NOCHECK ADD  CONSTRAINT [FK_JOBS_USERS_M] FOREIGN KEY([MODIFIED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[JOBS] CHECK CONSTRAINT [FK_JOBS_USERS_M]
GO
/****** Object:  ForeignKey [FK_LOOKUP_TYPE_PARENTS]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[LOOKUP_TYPES]  WITH NOCHECK ADD  CONSTRAINT [FK_LOOKUP_TYPE_PARENTS] FOREIGN KEY([PARENT_TYPE_ID])
REFERENCES [dbo].[LOOKUP_TYPES] ([LOOKUP_TYPE_ID])
GO
ALTER TABLE [dbo].[LOOKUP_TYPES] CHECK CONSTRAINT [FK_LOOKUP_TYPE_PARENTS]
GO
/****** Object:  ForeignKey [FK_LT_USERS_C]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[LOOKUP_TYPES]  WITH NOCHECK ADD  CONSTRAINT [FK_LT_USERS_C] FOREIGN KEY([CREATED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[LOOKUP_TYPES] CHECK CONSTRAINT [FK_LT_USERS_C]
GO
/****** Object:  ForeignKey [FK_LT_USERS_M]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[LOOKUP_TYPES]  WITH NOCHECK ADD  CONSTRAINT [FK_LT_USERS_M] FOREIGN KEY([MODIFIED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[LOOKUP_TYPES] CHECK CONSTRAINT [FK_LT_USERS_M]
GO
/****** Object:  ForeignKey [FK_L_LOOKUP_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[LOOKUPS]  WITH NOCHECK ADD  CONSTRAINT [FK_L_LOOKUP_TYPES] FOREIGN KEY([LOOKUP_TYPE_ID])
REFERENCES [dbo].[LOOKUP_TYPES] ([LOOKUP_TYPE_ID])
GO
ALTER TABLE [dbo].[LOOKUPS] CHECK CONSTRAINT [FK_L_LOOKUP_TYPES]
GO
/****** Object:  ForeignKey [FK_L_LOOKUPS]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[LOOKUPS]  WITH NOCHECK ADD  CONSTRAINT [FK_L_LOOKUPS] FOREIGN KEY([PARENT_LOOKUP_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[LOOKUPS] CHECK CONSTRAINT [FK_L_LOOKUPS]
GO
/****** Object:  ForeignKey [FK_O_USERS_C]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[ORGANIZATIONS]  WITH NOCHECK ADD  CONSTRAINT [FK_O_USERS_C] FOREIGN KEY([CREATED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[ORGANIZATIONS] CHECK CONSTRAINT [FK_O_USERS_C]
GO
/****** Object:  ForeignKey [FK_O_USERS_M]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[ORGANIZATIONS]  WITH NOCHECK ADD  CONSTRAINT [FK_O_USERS_M] FOREIGN KEY([MODIFIED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[ORGANIZATIONS] CHECK CONSTRAINT [FK_O_USERS_M]
GO
/****** Object:  ForeignKey [FK_PBL_SERVICE_LINES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[PAYROLL_BATCH_LINES]  WITH NOCHECK ADD  CONSTRAINT [FK_PBL_SERVICE_LINES] FOREIGN KEY([SERVICE_LINE_ID])
REFERENCES [dbo].[SERVICE_LINES] ([SERVICE_LINE_ID])
GO
ALTER TABLE [dbo].[PAYROLL_BATCH_LINES] CHECK CONSTRAINT [FK_PBL_SERVICE_LINES]
GO
/****** Object:  ForeignKey [FK_PAYROLL_BATCH_STATUS_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[PAYROLL_BATCHES]  WITH NOCHECK ADD  CONSTRAINT [FK_PAYROLL_BATCH_STATUS_TYPES] FOREIGN KEY([PAYROLL_BATCH_STATUS_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[PAYROLL_BATCHES] CHECK CONSTRAINT [FK_PAYROLL_BATCH_STATUS_TYPES]
GO
/****** Object:  ForeignKey [FK_PAYROLL_BATCHE_USERS_C]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[PAYROLL_BATCHES]  WITH NOCHECK ADD  CONSTRAINT [FK_PAYROLL_BATCHE_USERS_C] FOREIGN KEY([CREATED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[PAYROLL_BATCHES] CHECK CONSTRAINT [FK_PAYROLL_BATCHE_USERS_C]
GO
/****** Object:  ForeignKey [FK_PB_ORGANIZATIONS]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[PAYROLL_BATCHES]  WITH NOCHECK ADD  CONSTRAINT [FK_PB_ORGANIZATIONS] FOREIGN KEY([ORGANIZATION_ID])
REFERENCES [dbo].[ORGANIZATIONS] ([ORGANIZATION_ID])
GO
ALTER TABLE [dbo].[PAYROLL_BATCHES] CHECK CONSTRAINT [FK_PB_ORGANIZATIONS]
GO
/****** Object:  ForeignKey [FK_PHC_ITEMS]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[POOLED_HOURS_CALC]  WITH NOCHECK ADD  CONSTRAINT [FK_PHC_ITEMS] FOREIGN KEY([ITEM_ID])
REFERENCES [dbo].[ITEMS] ([ITEM_ID])
GO
ALTER TABLE [dbo].[POOLED_HOURS_CALC] CHECK CONSTRAINT [FK_PHC_ITEMS]
GO
/****** Object:  ForeignKey [FK_PHC_SERVICES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[POOLED_HOURS_CALC]  WITH NOCHECK ADD  CONSTRAINT [FK_PHC_SERVICES] FOREIGN KEY([SERVICE_ID])
REFERENCES [dbo].[SERVICES] ([SERVICE_ID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[POOLED_HOURS_CALC] CHECK CONSTRAINT [FK_PHC_SERVICES]
GO
/****** Object:  ForeignKey [FK_PN_PROJECTS]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[PROJECT_NOTES]  WITH CHECK ADD  CONSTRAINT [FK_PN_PROJECTS] FOREIGN KEY([PROJECT_ID])
REFERENCES [dbo].[PROJECTS] ([PROJECT_ID])
GO
ALTER TABLE [dbo].[PROJECT_NOTES] CHECK CONSTRAINT [FK_PN_PROJECTS]
GO
/****** Object:  ForeignKey [FK_PN_USERS_C]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[PROJECT_NOTES]  WITH NOCHECK ADD  CONSTRAINT [FK_PN_USERS_C] FOREIGN KEY([CREATED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[PROJECT_NOTES] CHECK CONSTRAINT [FK_PN_USERS_C]
GO
/****** Object:  ForeignKey [FK_PN_USERS_M]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[PROJECT_NOTES]  WITH NOCHECK ADD  CONSTRAINT [FK_PN_USERS_M] FOREIGN KEY([MODIFIED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[PROJECT_NOTES] CHECK CONSTRAINT [FK_PN_USERS_M]
GO
/****** Object:  ForeignKey [fk_project_end_user]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[PROJECTS]  WITH CHECK ADD  CONSTRAINT [fk_project_end_user] FOREIGN KEY([END_USER_ID])
REFERENCES [dbo].[CUSTOMERS] ([CUSTOMER_ID])
GO
ALTER TABLE [dbo].[PROJECTS] CHECK CONSTRAINT [fk_project_end_user]
GO
/****** Object:  ForeignKey [FK_PROJECT_STATUSES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[PROJECTS]  WITH CHECK ADD  CONSTRAINT [FK_PROJECT_STATUSES] FOREIGN KEY([PROJECT_STATUS_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[PROJECTS] CHECK CONSTRAINT [FK_PROJECT_STATUSES]
GO
/****** Object:  ForeignKey [FK_PROJECT_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[PROJECTS]  WITH CHECK ADD  CONSTRAINT [FK_PROJECT_TYPES] FOREIGN KEY([PROJECT_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[PROJECTS] CHECK CONSTRAINT [FK_PROJECT_TYPES]
GO
/****** Object:  ForeignKey [FK_PROJECTS_CUSTOMERS]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[PROJECTS]  WITH NOCHECK ADD  CONSTRAINT [FK_PROJECTS_CUSTOMERS] FOREIGN KEY([CUSTOMER_ID])
REFERENCES [dbo].[CUSTOMERS] ([CUSTOMER_ID])
GO
ALTER TABLE [dbo].[PROJECTS] CHECK CONSTRAINT [FK_PROJECTS_CUSTOMERS]
GO
/****** Object:  ForeignKey [FK_PROJECTS_USERS_C]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[PROJECTS]  WITH NOCHECK ADD  CONSTRAINT [FK_PROJECTS_USERS_C] FOREIGN KEY([CREATED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[PROJECTS] CHECK CONSTRAINT [FK_PROJECTS_USERS_C]
GO
/****** Object:  ForeignKey [FK_PROJECTS_USERS_M]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[PROJECTS]  WITH NOCHECK ADD  CONSTRAINT [FK_PROJECTS_USERS_M] FOREIGN KEY([MODIFIED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[PROJECTS] CHECK CONSTRAINT [FK_PROJECTS_USERS_M]
GO
/****** Object:  ForeignKey [FK_PI_PUNCHLISTS]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[PUNCHLIST_ISSUES]  WITH NOCHECK ADD  CONSTRAINT [FK_PI_PUNCHLISTS] FOREIGN KEY([PUNCHLIST_ID])
REFERENCES [dbo].[PUNCHLISTS] ([PUNCHLIST_ID])
GO
ALTER TABLE [dbo].[PUNCHLIST_ISSUES] CHECK CONSTRAINT [FK_PI_PUNCHLISTS]
GO
/****** Object:  ForeignKey [FK_PI_ROOT_CAUSES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[PUNCHLIST_ISSUES]  WITH NOCHECK ADD  CONSTRAINT [FK_PI_ROOT_CAUSES] FOREIGN KEY([ROOT_CAUSE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[PUNCHLIST_ISSUES] CHECK CONSTRAINT [FK_PI_ROOT_CAUSES]
GO
/****** Object:  ForeignKey [FK_PI_STATUS_ID]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[PUNCHLIST_ISSUES]  WITH NOCHECK ADD  CONSTRAINT [FK_PI_STATUS_ID] FOREIGN KEY([STATUS_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[PUNCHLIST_ISSUES] CHECK CONSTRAINT [FK_PI_STATUS_ID]
GO
/****** Object:  ForeignKey [FK_PI_USERS_C]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[PUNCHLIST_ISSUES]  WITH NOCHECK ADD  CONSTRAINT [FK_PI_USERS_C] FOREIGN KEY([CREATED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[PUNCHLIST_ISSUES] CHECK CONSTRAINT [FK_PI_USERS_C]
GO
/****** Object:  ForeignKey [FK_PI_USERS_M]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[PUNCHLIST_ISSUES]  WITH NOCHECK ADD  CONSTRAINT [FK_PI_USERS_M] FOREIGN KEY([MODIFIED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[PUNCHLIST_ISSUES] CHECK CONSTRAINT [FK_PI_USERS_M]
GO
/****** Object:  ForeignKey [fk_punchlist_requests]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[PUNCHLISTS]  WITH NOCHECK ADD  CONSTRAINT [fk_punchlist_requests] FOREIGN KEY([request_id])
REFERENCES [dbo].[REQUESTS] ([REQUEST_ID])
GO
ALTER TABLE [dbo].[PUNCHLISTS] CHECK CONSTRAINT [fk_punchlist_requests]
GO
/****** Object:  ForeignKey [FK_PUNCHLISTS_PROJECTS]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[PUNCHLISTS]  WITH NOCHECK ADD  CONSTRAINT [FK_PUNCHLISTS_PROJECTS] FOREIGN KEY([PROJECT_ID])
REFERENCES [dbo].[PROJECTS] ([PROJECT_ID])
GO
ALTER TABLE [dbo].[PUNCHLISTS] CHECK CONSTRAINT [FK_PUNCHLISTS_PROJECTS]
GO
/****** Object:  ForeignKey [FK_PUNCHLISTS_USERS_C]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[PUNCHLISTS]  WITH NOCHECK ADD  CONSTRAINT [FK_PUNCHLISTS_USERS_C] FOREIGN KEY([CREATED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[PUNCHLISTS] CHECK CONSTRAINT [FK_PUNCHLISTS_USERS_C]
GO
/****** Object:  ForeignKey [FK_PUNCHLISTS_USERS_M]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[PUNCHLISTS]  WITH NOCHECK ADD  CONSTRAINT [FK_PUNCHLISTS_USERS_M] FOREIGN KEY([MODIFIED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[PUNCHLISTS] CHECK CONSTRAINT [FK_PUNCHLISTS_USERS_M]
GO
/****** Object:  ForeignKey [fk_po_billing_type_id]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[purchase_orders]  WITH CHECK ADD  CONSTRAINT [fk_po_billing_type_id] FOREIGN KEY([billing_type_id])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[purchase_orders] CHECK CONSTRAINT [fk_po_billing_type_id]
GO
/****** Object:  ForeignKey [fk_po_item_id]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[purchase_orders]  WITH CHECK ADD  CONSTRAINT [fk_po_item_id] FOREIGN KEY([item_id])
REFERENCES [dbo].[ITEMS] ([ITEM_ID])
GO
ALTER TABLE [dbo].[purchase_orders] CHECK CONSTRAINT [fk_po_item_id]
GO
/****** Object:  ForeignKey [fk_po_request_id]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[purchase_orders]  WITH CHECK ADD  CONSTRAINT [fk_po_request_id] FOREIGN KEY([request_id])
REFERENCES [dbo].[REQUESTS] ([REQUEST_ID])
GO
ALTER TABLE [dbo].[purchase_orders] CHECK CONSTRAINT [fk_po_request_id]
GO
/****** Object:  ForeignKey [fk_po_status_id]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[purchase_orders]  WITH CHECK ADD  CONSTRAINT [fk_po_status_id] FOREIGN KEY([po_status_id])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[purchase_orders] CHECK CONSTRAINT [fk_po_status_id]
GO
/****** Object:  ForeignKey [FK_QC_CONDITIONS]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[QUOTE_CONDITIONS]  WITH NOCHECK ADD  CONSTRAINT [FK_QC_CONDITIONS] FOREIGN KEY([CONDITION_ID])
REFERENCES [dbo].[CONDITIONS] ([CONDITION_ID])
GO
ALTER TABLE [dbo].[QUOTE_CONDITIONS] CHECK CONSTRAINT [FK_QC_CONDITIONS]
GO
/****** Object:  ForeignKey [FK_QC_USERS_C]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[QUOTE_CONDITIONS]  WITH NOCHECK ADD  CONSTRAINT [FK_QC_USERS_C] FOREIGN KEY([CREATED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[QUOTE_CONDITIONS] CHECK CONSTRAINT [FK_QC_USERS_C]
GO
/****** Object:  ForeignKey [FK_QC_USERS_M]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[QUOTE_CONDITIONS]  WITH NOCHECK ADD  CONSTRAINT [FK_QC_USERS_M] FOREIGN KEY([MODIFIED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[QUOTE_CONDITIONS] CHECK CONSTRAINT [FK_QC_USERS_M]
GO
/****** Object:  ForeignKey [FK_QOF_QUOTES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[QUOTE_OTHER_FURNITURE]  WITH NOCHECK ADD  CONSTRAINT [FK_QOF_QUOTES] FOREIGN KEY([QUOTE_ID])
REFERENCES [dbo].[QUOTES] ([quote_id])
GO
ALTER TABLE [dbo].[QUOTE_OTHER_FURNITURE] CHECK CONSTRAINT [FK_QOF_QUOTES]
GO
/****** Object:  ForeignKey [FK_QOF_USERS_C]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[QUOTE_OTHER_FURNITURE]  WITH NOCHECK ADD  CONSTRAINT [FK_QOF_USERS_C] FOREIGN KEY([CREATED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[QUOTE_OTHER_FURNITURE] CHECK CONSTRAINT [FK_QOF_USERS_C]
GO
/****** Object:  ForeignKey [FK_QOF_USERS_M]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[QUOTE_OTHER_FURNITURE]  WITH NOCHECK ADD  CONSTRAINT [FK_QOF_USERS_M] FOREIGN KEY([MODIFIED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[QUOTE_OTHER_FURNITURE] CHECK CONSTRAINT [FK_QOF_USERS_M]
GO
/****** Object:  ForeignKey [FK_QOFAH_QUOTES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[QUOTE_OTHER_FURNITURE_AD_HOC]  WITH NOCHECK ADD  CONSTRAINT [FK_QOFAH_QUOTES] FOREIGN KEY([QUOTE_ID])
REFERENCES [dbo].[QUOTES] ([quote_id])
GO
ALTER TABLE [dbo].[QUOTE_OTHER_FURNITURE_AD_HOC] CHECK CONSTRAINT [FK_QOFAH_QUOTES]
GO
/****** Object:  ForeignKey [FK_QOFAH_USERS_C]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[QUOTE_OTHER_FURNITURE_AD_HOC]  WITH NOCHECK ADD  CONSTRAINT [FK_QOFAH_USERS_C] FOREIGN KEY([CREATED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[QUOTE_OTHER_FURNITURE_AD_HOC] CHECK CONSTRAINT [FK_QOFAH_USERS_C]
GO
/****** Object:  ForeignKey [FK_QOFAH_USERS_M]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[QUOTE_OTHER_FURNITURE_AD_HOC]  WITH NOCHECK ADD  CONSTRAINT [FK_QOFAH_USERS_M] FOREIGN KEY([MODIFIED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[QUOTE_OTHER_FURNITURE_AD_HOC] CHECK CONSTRAINT [FK_QOFAH_USERS_M]
GO
/****** Object:  ForeignKey [FK_QSOS_QUOTES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[QUOTE_SPECIFY_OTHER_SERVICES]  WITH NOCHECK ADD  CONSTRAINT [FK_QSOS_QUOTES] FOREIGN KEY([QUOTE_ID])
REFERENCES [dbo].[QUOTES] ([quote_id])
GO
ALTER TABLE [dbo].[QUOTE_SPECIFY_OTHER_SERVICES] CHECK CONSTRAINT [FK_QSOS_QUOTES]
GO
/****** Object:  ForeignKey [FK_QSOS_USERS_C]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[QUOTE_SPECIFY_OTHER_SERVICES]  WITH NOCHECK ADD  CONSTRAINT [FK_QSOS_USERS_C] FOREIGN KEY([CREATED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[QUOTE_SPECIFY_OTHER_SERVICES] CHECK CONSTRAINT [FK_QSOS_USERS_C]
GO
/****** Object:  ForeignKey [FK_QSOS_USERS_M]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[QUOTE_SPECIFY_OTHER_SERVICES]  WITH NOCHECK ADD  CONSTRAINT [FK_QSOS_USERS_M] FOREIGN KEY([MODIFIED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[QUOTE_SPECIFY_OTHER_SERVICES] CHECK CONSTRAINT [FK_QSOS_USERS_M]
GO
/****** Object:  ForeignKey [FK_QSC_QUOTES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[QUOTE_STANDARD_CONDITIONS]  WITH NOCHECK ADD  CONSTRAINT [FK_QSC_QUOTES] FOREIGN KEY([QUOTE_ID])
REFERENCES [dbo].[QUOTES] ([quote_id])
GO
ALTER TABLE [dbo].[QUOTE_STANDARD_CONDITIONS] CHECK CONSTRAINT [FK_QSC_QUOTES]
GO
/****** Object:  ForeignKey [FK_QSC_STANDARD_CONDITIONS]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[QUOTE_STANDARD_CONDITIONS]  WITH NOCHECK ADD  CONSTRAINT [FK_QSC_STANDARD_CONDITIONS] FOREIGN KEY([STANDARD_CONDITION_ID])
REFERENCES [dbo].[STANDARD_CONDITIONS] ([standard_condition_id])
GO
ALTER TABLE [dbo].[QUOTE_STANDARD_CONDITIONS] CHECK CONSTRAINT [FK_QSC_STANDARD_CONDITIONS]
GO
/****** Object:  ForeignKey [FK_QSC_USERS_C]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[QUOTE_STANDARD_CONDITIONS]  WITH NOCHECK ADD  CONSTRAINT [FK_QSC_USERS_C] FOREIGN KEY([CREATED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[QUOTE_STANDARD_CONDITIONS] CHECK CONSTRAINT [FK_QSC_USERS_C]
GO
/****** Object:  ForeignKey [FK_QSC_USERS_M]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[QUOTE_STANDARD_CONDITIONS]  WITH NOCHECK ADD  CONSTRAINT [FK_QSC_USERS_M] FOREIGN KEY([MODIFIED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[QUOTE_STANDARD_CONDITIONS] CHECK CONSTRAINT [FK_QSC_USERS_M]
GO
/****** Object:  ForeignKey [FK_QWC_QUOTES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[QUOTE_WORKSTATION_CONFIGURATIONS]  WITH NOCHECK ADD  CONSTRAINT [FK_QWC_QUOTES] FOREIGN KEY([QUOTE_ID])
REFERENCES [dbo].[QUOTES] ([quote_id])
GO
ALTER TABLE [dbo].[QUOTE_WORKSTATION_CONFIGURATIONS] CHECK CONSTRAINT [FK_QWC_QUOTES]
GO
/****** Object:  ForeignKey [FK_QWC_USERS_C]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[QUOTE_WORKSTATION_CONFIGURATIONS]  WITH NOCHECK ADD  CONSTRAINT [FK_QWC_USERS_C] FOREIGN KEY([CREATED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[QUOTE_WORKSTATION_CONFIGURATIONS] CHECK CONSTRAINT [FK_QWC_USERS_C]
GO
/****** Object:  ForeignKey [FK_QWC_USERS_M]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[QUOTE_WORKSTATION_CONFIGURATIONS]  WITH NOCHECK ADD  CONSTRAINT [FK_QWC_USERS_M] FOREIGN KEY([MODIFIED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[QUOTE_WORKSTATION_CONFIGURATIONS] CHECK CONSTRAINT [FK_QWC_USERS_M]
GO
/****** Object:  ForeignKey [FK_QUOTE_REQUEST_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[QUOTES]  WITH NOCHECK ADD  CONSTRAINT [FK_QUOTE_REQUEST_TYPES] FOREIGN KEY([request_type_id])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[QUOTES] CHECK CONSTRAINT [FK_QUOTE_REQUEST_TYPES]
GO
/****** Object:  ForeignKey [FK_QUOTE_REQUESTS]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[QUOTES]  WITH NOCHECK ADD  CONSTRAINT [FK_QUOTE_REQUESTS] FOREIGN KEY([request_id])
REFERENCES [dbo].[REQUESTS] ([REQUEST_ID])
GO
ALTER TABLE [dbo].[QUOTES] CHECK CONSTRAINT [FK_QUOTE_REQUESTS]
GO
/****** Object:  ForeignKey [FK_QUOTE_STATUSES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[QUOTES]  WITH NOCHECK ADD  CONSTRAINT [FK_QUOTE_STATUSES] FOREIGN KEY([quote_status_type_id])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[QUOTES] CHECK CONSTRAINT [FK_QUOTE_STATUSES]
GO
/****** Object:  ForeignKey [FK_QUOTE_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[QUOTES]  WITH NOCHECK ADD  CONSTRAINT [FK_QUOTE_TYPES] FOREIGN KEY([quote_type_id])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[QUOTES] CHECK CONSTRAINT [FK_QUOTE_TYPES]
GO
/****** Object:  ForeignKey [FK_QUOTE_USERS]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[QUOTES]  WITH NOCHECK ADD  CONSTRAINT [FK_QUOTE_USERS] FOREIGN KEY([quoted_by_user_id])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[QUOTES] CHECK CONSTRAINT [FK_QUOTE_USERS]
GO
/****** Object:  ForeignKey [FK_QUOTE_USERS_C]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[QUOTES]  WITH NOCHECK ADD  CONSTRAINT [FK_QUOTE_USERS_C] FOREIGN KEY([created_by])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[QUOTES] CHECK CONSTRAINT [FK_QUOTE_USERS_C]
GO
/****** Object:  ForeignKey [FK_QUOTE_USERS_M]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[QUOTES]  WITH NOCHECK ADD  CONSTRAINT [FK_QUOTE_USERS_M] FOREIGN KEY([modified_by])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[QUOTES] CHECK CONSTRAINT [FK_QUOTE_USERS_M]
GO
/****** Object:  ForeignKey [FK_REQUEST_DOCUMENTS_CREATED_BY]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUEST_DOCUMENTS]  WITH CHECK ADD  CONSTRAINT [FK_REQUEST_DOCUMENTS_CREATED_BY] FOREIGN KEY([created_by])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[REQUEST_DOCUMENTS] CHECK CONSTRAINT [FK_REQUEST_DOCUMENTS_CREATED_BY]
GO
/****** Object:  ForeignKey [FK_REQUEST_DOCUMENTS_MODIFIED_BY]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUEST_DOCUMENTS]  WITH CHECK ADD  CONSTRAINT [FK_REQUEST_DOCUMENTS_MODIFIED_BY] FOREIGN KEY([modified_by])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[REQUEST_DOCUMENTS] CHECK CONSTRAINT [FK_REQUEST_DOCUMENTS_MODIFIED_BY]
GO
/****** Object:  ForeignKey [FK_REQUEST_DOCUMENTS_REQUESTS]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUEST_DOCUMENTS]  WITH CHECK ADD  CONSTRAINT [FK_REQUEST_DOCUMENTS_REQUESTS] FOREIGN KEY([request_id])
REFERENCES [dbo].[REQUESTS] ([REQUEST_ID])
GO
ALTER TABLE [dbo].[REQUEST_DOCUMENTS] CHECK CONSTRAINT [FK_REQUEST_DOCUMENTS_REQUESTS]
GO
/****** Object:  ForeignKey [FK_REQUEST_VENDOR_CONTACT]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUEST_VENDORS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_VENDOR_CONTACT] FOREIGN KEY([VENDOR_CONTACT_ID])
REFERENCES [dbo].[CONTACTS] ([CONTACT_ID])
GO
ALTER TABLE [dbo].[REQUEST_VENDORS] CHECK CONSTRAINT [FK_REQUEST_VENDOR_CONTACT]
GO
/****** Object:  ForeignKey [FK_REQUEST_VENDOR_CREATED_BY]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUEST_VENDORS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_VENDOR_CREATED_BY] FOREIGN KEY([CREATED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[REQUEST_VENDORS] CHECK CONSTRAINT [FK_REQUEST_VENDOR_CREATED_BY]
GO
/****** Object:  ForeignKey [FK_REQUEST_VENDOR_MODIFIED_BY]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUEST_VENDORS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_VENDOR_MODIFIED_BY] FOREIGN KEY([MODIFIED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[REQUEST_VENDORS] CHECK CONSTRAINT [FK_REQUEST_VENDOR_MODIFIED_BY]
GO
/****** Object:  ForeignKey [FK_REQUEST_VENDORS]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUEST_VENDORS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_VENDORS] FOREIGN KEY([REQUEST_ID])
REFERENCES [dbo].[REQUESTS] ([REQUEST_ID])
GO
ALTER TABLE [dbo].[REQUEST_VENDORS] CHECK CONSTRAINT [FK_REQUEST_VENDORS]
GO
/****** Object:  ForeignKey [FK_REQUEST_A_D_DESIGNER_CONTACTS]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_A_D_DESIGNER_CONTACTS] FOREIGN KEY([A_D_DESIGNER_CONTACT_ID])
REFERENCES [dbo].[CONTACTS] ([CONTACT_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_A_D_DESIGNER_CONTACTS]
GO
/****** Object:  ForeignKey [FK_REQUEST_A_M_CONTACTS]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_A_M_CONTACTS] FOREIGN KEY([A_M_CONTACT_ID])
REFERENCES [dbo].[CONTACTS] ([CONTACT_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_A_M_CONTACTS]
GO
/****** Object:  ForeignKey [FK_REQUEST_A_M_INSTALLER_CONTACTS]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_A_M_INSTALLER_CONTACTS] FOREIGN KEY([A_M_INSTALL_SUP_CONTACT_ID])
REFERENCES [dbo].[CONTACTS] ([CONTACT_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_A_M_INSTALLER_CONTACTS]
GO
/****** Object:  ForeignKey [FK_REQUEST_ACCOUNT_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_ACCOUNT_TYPES] FOREIGN KEY([ACCOUNT_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_ACCOUNT_TYPES]
GO
/****** Object:  ForeignKey [FK_REQUEST_ACTIVITY_CAT_TYPES1]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_ACTIVITY_CAT_TYPES1] FOREIGN KEY([ACTIVITY_CAT_TYPE_ID1])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_ACTIVITY_CAT_TYPES1]
GO
/****** Object:  ForeignKey [FK_REQUEST_ACTIVITY_CAT_TYPES10]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_ACTIVITY_CAT_TYPES10] FOREIGN KEY([ACTIVITY_CAT_TYPE_ID10])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_ACTIVITY_CAT_TYPES10]
GO
/****** Object:  ForeignKey [FK_REQUEST_ACTIVITY_CAT_TYPES2]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_ACTIVITY_CAT_TYPES2] FOREIGN KEY([ACTIVITY_CAT_TYPE_ID2])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_ACTIVITY_CAT_TYPES2]
GO
/****** Object:  ForeignKey [FK_REQUEST_ACTIVITY_CAT_TYPES3]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_ACTIVITY_CAT_TYPES3] FOREIGN KEY([ACTIVITY_CAT_TYPE_ID3])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_ACTIVITY_CAT_TYPES3]
GO
/****** Object:  ForeignKey [FK_REQUEST_ACTIVITY_CAT_TYPES4]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_ACTIVITY_CAT_TYPES4] FOREIGN KEY([ACTIVITY_CAT_TYPE_ID4])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_ACTIVITY_CAT_TYPES4]
GO
/****** Object:  ForeignKey [FK_REQUEST_ACTIVITY_CAT_TYPES5]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_ACTIVITY_CAT_TYPES5] FOREIGN KEY([ACTIVITY_CAT_TYPE_ID5])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_ACTIVITY_CAT_TYPES5]
GO
/****** Object:  ForeignKey [FK_REQUEST_ACTIVITY_CAT_TYPES6]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_ACTIVITY_CAT_TYPES6] FOREIGN KEY([ACTIVITY_CAT_TYPE_ID6])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_ACTIVITY_CAT_TYPES6]
GO
/****** Object:  ForeignKey [FK_REQUEST_ACTIVITY_CAT_TYPES7]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_ACTIVITY_CAT_TYPES7] FOREIGN KEY([ACTIVITY_CAT_TYPE_ID7])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_ACTIVITY_CAT_TYPES7]
GO
/****** Object:  ForeignKey [FK_REQUEST_ACTIVITY_CAT_TYPES8]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_ACTIVITY_CAT_TYPES8] FOREIGN KEY([ACTIVITY_CAT_TYPE_ID8])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_ACTIVITY_CAT_TYPES8]
GO
/****** Object:  ForeignKey [FK_REQUEST_ACTIVITY_CAT_TYPES9]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_ACTIVITY_CAT_TYPES9] FOREIGN KEY([ACTIVITY_CAT_TYPE_ID9])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_ACTIVITY_CAT_TYPES9]
GO
/****** Object:  ForeignKey [FK_REQUEST_ACTIVITY_TYPE1]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_ACTIVITY_TYPE1] FOREIGN KEY([ACTIVITY_TYPE_ID1])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_ACTIVITY_TYPE1]
GO
/****** Object:  ForeignKey [FK_REQUEST_ACTIVITY_TYPES10]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_ACTIVITY_TYPES10] FOREIGN KEY([ACTIVITY_TYPE_ID10])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_ACTIVITY_TYPES10]
GO
/****** Object:  ForeignKey [FK_REQUEST_ACTIVITY_TYPES2]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_ACTIVITY_TYPES2] FOREIGN KEY([ACTIVITY_TYPE_ID2])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_ACTIVITY_TYPES2]
GO
/****** Object:  ForeignKey [FK_REQUEST_ACTIVITY_TYPES3]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_ACTIVITY_TYPES3] FOREIGN KEY([ACTIVITY_TYPE_ID3])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_ACTIVITY_TYPES3]
GO
/****** Object:  ForeignKey [FK_REQUEST_ACTIVITY_TYPES4]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_ACTIVITY_TYPES4] FOREIGN KEY([ACTIVITY_TYPE_ID4])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_ACTIVITY_TYPES4]
GO
/****** Object:  ForeignKey [FK_REQUEST_ACTIVITY_TYPES5]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_ACTIVITY_TYPES5] FOREIGN KEY([ACTIVITY_TYPE_ID5])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_ACTIVITY_TYPES5]
GO
/****** Object:  ForeignKey [FK_REQUEST_ACTIVITY_TYPES6]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_ACTIVITY_TYPES6] FOREIGN KEY([ACTIVITY_TYPE_ID6])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_ACTIVITY_TYPES6]
GO
/****** Object:  ForeignKey [FK_REQUEST_ACTIVITY_TYPES7]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_ACTIVITY_TYPES7] FOREIGN KEY([ACTIVITY_TYPE_ID7])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_ACTIVITY_TYPES7]
GO
/****** Object:  ForeignKey [FK_REQUEST_ACTIVITY_TYPES8]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_ACTIVITY_TYPES8] FOREIGN KEY([ACTIVITY_TYPE_ID8])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_ACTIVITY_TYPES8]
GO
/****** Object:  ForeignKey [FK_REQUEST_ACTIVITY_TYPES9]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_ACTIVITY_TYPES9] FOREIGN KEY([ACTIVITY_TYPE_ID9])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_ACTIVITY_TYPES9]
GO
/****** Object:  ForeignKey [FK_REQUEST_ALT_CUST_CONTACTS]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_ALT_CUST_CONTACTS] FOREIGN KEY([ALT_CUSTOMER_CONTACT_ID])
REFERENCES [dbo].[CONTACTS] ([CONTACT_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_ALT_CUST_CONTACTS]
GO
/****** Object:  ForeignKey [FK_REQUEST_APPROVAL_REQ_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_APPROVAL_REQ_TYPES] FOREIGN KEY([APPROVAL_REQ_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_APPROVAL_REQ_TYPES]
GO
/****** Object:  ForeignKey [fk_request_approver_contact]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [fk_request_approver_contact] FOREIGN KEY([APPROVER_CONTACT_ID])
REFERENCES [dbo].[CONTACTS] ([CONTACT_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [fk_request_approver_contact]
GO
/****** Object:  ForeignKey [FK_REQUEST_BLDG_MGR_CONTACTS]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_BLDG_MGR_CONTACTS] FOREIGN KEY([BLDG_MGR_CONTACT_ID])
REFERENCES [dbo].[CONTACTS] ([CONTACT_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_BLDG_MGR_CONTACTS]
GO
/****** Object:  ForeignKey [FK_REQUEST_CARPET_CONTACTS]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_CARPET_CONTACTS] FOREIGN KEY([CARPET_LAYER_CONTACT_ID])
REFERENCES [dbo].[CONTACTS] ([CONTACT_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_CARPET_CONTACTS]
GO
/****** Object:  ForeignKey [FK_REQUEST_CASE_FURN_LINE_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_CASE_FURN_LINE_TYPES] FOREIGN KEY([CASE_FURN_LINE_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_CASE_FURN_LINE_TYPES]
GO
/****** Object:  ForeignKey [FK_REQUEST_CASE_FURN_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_CASE_FURN_TYPES] FOREIGN KEY([CASE_FURN_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_CASE_FURN_TYPES]
GO
/****** Object:  ForeignKey [FK_REQUEST_COORD_ELECTRICAL_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_COORD_ELECTRICAL_TYPES] FOREIGN KEY([COORD_ELECTRICAL_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_COORD_ELECTRICAL_TYPES]
GO
/****** Object:  ForeignKey [FK_REQUEST_COORD_FLOOR_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_COORD_FLOOR_TYPES] FOREIGN KEY([COORD_FLOOR_COVR_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_COORD_FLOOR_TYPES]
GO
/****** Object:  ForeignKey [FK_REQUEST_COORD_MOVER_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_COORD_MOVER_TYPES] FOREIGN KEY([COORD_MOVER_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_COORD_MOVER_TYPES]
GO
/****** Object:  ForeignKey [FK_REQUEST_COORD_PHONE_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_COORD_PHONE_TYPES] FOREIGN KEY([COORD_PHONE_DATA_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_COORD_PHONE_TYPES]
GO
/****** Object:  ForeignKey [FK_REQUEST_COORD_WALL_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_COORD_WALL_TYPES] FOREIGN KEY([COORD_WALL_COVR_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_COORD_WALL_TYPES]
GO
/****** Object:  ForeignKey [FK_REQUEST_COST_TO_CUST_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_COST_TO_CUST_TYPES] FOREIGN KEY([COST_TO_CUST_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_COST_TO_CUST_TYPES]
GO
/****** Object:  ForeignKey [FK_REQUEST_COST_TO_JOB_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_COST_TO_JOB_TYPES] FOREIGN KEY([COST_TO_JOB_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_COST_TO_JOB_TYPES]
GO
/****** Object:  ForeignKey [FK_REQUEST_COST_TO_VENDOR_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_COST_TO_VENDOR_TYPES] FOREIGN KEY([COST_TO_VEND_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_COST_TO_VENDOR_TYPES]
GO
/****** Object:  ForeignKey [fk_request_customer_contact2]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH CHECK ADD  CONSTRAINT [fk_request_customer_contact2] FOREIGN KEY([CUSTOMER_CONTACT2_ID])
REFERENCES [dbo].[CONTACTS] ([CONTACT_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [fk_request_customer_contact2]
GO
/****** Object:  ForeignKey [fk_request_customer_contact3]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH CHECK ADD  CONSTRAINT [fk_request_customer_contact3] FOREIGN KEY([CUSTOMER_CONTACT3_ID])
REFERENCES [dbo].[CONTACTS] ([CONTACT_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [fk_request_customer_contact3]
GO
/****** Object:  ForeignKey [fk_request_customer_contact4]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH CHECK ADD  CONSTRAINT [fk_request_customer_contact4] FOREIGN KEY([CUSTOMER_CONTACT4_ID])
REFERENCES [dbo].[CONTACTS] ([CONTACT_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [fk_request_customer_contact4]
GO
/****** Object:  ForeignKey [FK_REQUEST_CUSTOMER_CONTACTS]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_CUSTOMER_CONTACTS] FOREIGN KEY([CUSTOMER_CONTACT_ID])
REFERENCES [dbo].[CONTACTS] ([CONTACT_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_CUSTOMER_CONTACTS]
GO
/****** Object:  ForeignKey [fk_request_customer_costing_type]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH CHECK ADD  CONSTRAINT [fk_request_customer_costing_type] FOREIGN KEY([CUSTOMER_COSTING_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [fk_request_customer_costing_type]
GO
/****** Object:  ForeignKey [FK_REQUEST_D_DESIGNER_CONTACTS]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_D_DESIGNER_CONTACTS] FOREIGN KEY([D_DESIGNER_CONTACT_ID])
REFERENCES [dbo].[CONTACTS] ([CONTACT_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_D_DESIGNER_CONTACTS]
GO
/****** Object:  ForeignKey [FK_REQUEST_D_PROJ_MGR_CONTACTS]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_D_PROJ_MGR_CONTACTS] FOREIGN KEY([D_PROJ_MGR_CONTACT_ID])
REFERENCES [dbo].[CONTACTS] ([CONTACT_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_D_PROJ_MGR_CONTACTS]
GO
/****** Object:  ForeignKey [FK_REQUEST_D_SALES_REP_CONTACTS]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_D_SALES_REP_CONTACTS] FOREIGN KEY([D_SALES_REP_CONTACT_ID])
REFERENCES [dbo].[CONTACTS] ([CONTACT_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_D_SALES_REP_CONTACTS]
GO
/****** Object:  ForeignKey [FK_REQUEST_D_SALES_SUP_CONTACTS]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_D_SALES_SUP_CONTACTS] FOREIGN KEY([D_SALES_SUP_CONTACT_ID])
REFERENCES [dbo].[CONTACTS] ([CONTACT_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_D_SALES_SUP_CONTACTS]
GO
/****** Object:  ForeignKey [FK_REQUEST_DATA_PHONE_CONTACTS]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_DATA_PHONE_CONTACTS] FOREIGN KEY([DATA_PHONE_CONTACT_ID])
REFERENCES [dbo].[CONTACTS] ([CONTACT_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_DATA_PHONE_CONTACTS]
GO
/****** Object:  ForeignKey [FK_REQUEST_DELIVERY_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_DELIVERY_TYPES] FOREIGN KEY([DELIVERY_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_DELIVERY_TYPES]
GO
/****** Object:  ForeignKey [FK_REQUEST_DUMPSTER_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_DUMPSTER_TYPES] FOREIGN KEY([DUMPSTER_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_DUMPSTER_TYPES]
GO
/****** Object:  ForeignKey [FK_REQUEST_DUR_TIME_UOM_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_DUR_TIME_UOM_TYPES] FOREIGN KEY([DURATION_TIME_UOM_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_DUR_TIME_UOM_TYPES]
GO
/****** Object:  ForeignKey [FK_REQUEST_ELECTRICIAN_CONTACTS]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_ELECTRICIAN_CONTACTS] FOREIGN KEY([ELECTRICIAN_CONTACT_ID])
REFERENCES [dbo].[CONTACTS] ([CONTACT_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_ELECTRICIAN_CONTACTS]
GO
/****** Object:  ForeignKey [FK_REQUEST_EVENING_HOURS_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_EVENING_HOURS_TYPES] FOREIGN KEY([EVENING_HOURS_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_EVENING_HOURS_TYPES]
GO
/****** Object:  ForeignKey [fk_request_floor_number_types]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [fk_request_floor_number_types] FOREIGN KEY([FLOOR_NUMBER_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [fk_request_floor_number_types]
GO
/****** Object:  ForeignKey [FK_REQUEST_FURN_PLAN_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_FURN_PLAN_TYPES] FOREIGN KEY([FURN_PLAN_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_FURN_PLAN_TYPES]
GO
/****** Object:  ForeignKey [FK_REQUEST_FURN_SPEC_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_FURN_SPEC_TYPES] FOREIGN KEY([FURN_SPEC_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_FURN_SPEC_TYPES]
GO
/****** Object:  ForeignKey [fk_request_furn1_contact]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [fk_request_furn1_contact] FOREIGN KEY([FURNITURE1_CONTACT_ID])
REFERENCES [dbo].[CONTACTS] ([CONTACT_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [fk_request_furn1_contact]
GO
/****** Object:  ForeignKey [fk_request_furn2_contact]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [fk_request_furn2_contact] FOREIGN KEY([FURNITURE2_CONTACT_ID])
REFERENCES [dbo].[CONTACTS] ([CONTACT_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [fk_request_furn2_contact]
GO
/****** Object:  ForeignKey [FK_REQUEST_GEN_CONTRACT_CONTACTS]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_GEN_CONTRACT_CONTACTS] FOREIGN KEY([GEN_CONTRACTOR_CONTACT_ID])
REFERENCES [dbo].[CONTACTS] ([CONTACT_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_GEN_CONTRACT_CONTACTS]
GO
/****** Object:  ForeignKey [fk_request_job_loc_contact]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH CHECK ADD  CONSTRAINT [fk_request_job_loc_contact] FOREIGN KEY([JOB_LOCATION_CONTACT_ID])
REFERENCES [dbo].[CONTACTS] ([CONTACT_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [fk_request_job_loc_contact]
GO
/****** Object:  ForeignKey [FK_REQUEST_JOB_LOCATIONS]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_JOB_LOCATIONS] FOREIGN KEY([JOB_LOCATION_ID])
REFERENCES [dbo].[JOB_LOCATIONS] ([JOB_LOCATION_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_JOB_LOCATIONS]
GO
/****** Object:  ForeignKey [fk_request_level_types]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [fk_request_level_types] FOREIGN KEY([LEVEL_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [fk_request_level_types]
GO
/****** Object:  ForeignKey [FK_REQUEST_MOVER_CONTACTS]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_MOVER_CONTACTS] FOREIGN KEY([MOVER_CONTACT_ID])
REFERENCES [dbo].[CONTACTS] ([CONTACT_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_MOVER_CONTACTS]
GO
/****** Object:  ForeignKey [FK_REQUEST_NEW_SITE_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_NEW_SITE_TYPES] FOREIGN KEY([NEW_SITE_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_NEW_SITE_TYPES]
GO
/****** Object:  ForeignKey [FK_REQUEST_OCCUPIED_SITE_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_OCCUPIED_SITE_TYPES] FOREIGN KEY([OCCUPIED_SITE_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_OCCUPIED_SITE_TYPES]
GO
/****** Object:  ForeignKey [fk_request_order_type]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH CHECK ADD  CONSTRAINT [fk_request_order_type] FOREIGN KEY([ORDER_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [fk_request_order_type]
GO
/****** Object:  ForeignKey [FK_REQUEST_OTHER_CONTACTS]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_OTHER_CONTACTS] FOREIGN KEY([OTHER_CONTACT_ID])
REFERENCES [dbo].[CONTACTS] ([CONTACT_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_OTHER_CONTACTS]
GO
/****** Object:  ForeignKey [fk_request_other_delivery_type]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH CHECK ADD  CONSTRAINT [fk_request_other_delivery_type] FOREIGN KEY([OTHER_DELIVERY_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [fk_request_other_delivery_type]
GO
/****** Object:  ForeignKey [fk_request_other_furn_type]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH CHECK ADD  CONSTRAINT [fk_request_other_furn_type] FOREIGN KEY([OTHER_FURNITURE_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [fk_request_other_furn_type]
GO
/****** Object:  ForeignKey [FK_REQUEST_PHASED_INSTALL_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_PHASED_INSTALL_TYPES] FOREIGN KEY([PHASED_INSTALL_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_PHASED_INSTALL_TYPES]
GO
/****** Object:  ForeignKey [FK_REQUEST_PRI_FURN_LINE_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_PRI_FURN_LINE_TYPES] FOREIGN KEY([PRI_FURN_LINE_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_PRI_FURN_LINE_TYPES]
GO
/****** Object:  ForeignKey [FK_REQUEST_PRI_FURN_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_PRI_FURN_TYPES] FOREIGN KEY([PRI_FURN_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_PRI_FURN_TYPES]
GO
/****** Object:  ForeignKey [fk_request_priority_types]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [fk_request_priority_types] FOREIGN KEY([PRIORITY_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [fk_request_priority_types]
GO
/****** Object:  ForeignKey [FK_REQUEST_PROJECTS]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_PROJECTS] FOREIGN KEY([PROJECT_ID])
REFERENCES [dbo].[PROJECTS] ([PROJECT_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_PROJECTS]
GO
/****** Object:  ForeignKey [FK_REQUEST_PUNCHLIST_ITEM_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_PUNCHLIST_ITEM_TYPES] FOREIGN KEY([PUNCHLIST_ITEM_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_PUNCHLIST_ITEM_TYPES]
GO
/****** Object:  ForeignKey [FK_REQUEST_QUOTE_REQUESTS]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_QUOTE_REQUESTS] FOREIGN KEY([QUOTE_REQUEST_ID])
REFERENCES [dbo].[REQUESTS] ([REQUEST_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_QUOTE_REQUESTS]
GO
/****** Object:  ForeignKey [FK_REQUEST_QUOTE_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_QUOTE_TYPES] FOREIGN KEY([QUOTE_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_QUOTE_TYPES]
GO
/****** Object:  ForeignKey [FK_REQUEST_REGULAR_HOURS_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_REGULAR_HOURS_TYPES] FOREIGN KEY([REGULAR_HOURS_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_REGULAR_HOURS_TYPES]
GO
/****** Object:  ForeignKey [FK_REQUEST_SCHEDULE_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_SCHEDULE_TYPES] FOREIGN KEY([SCHEDULE_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_SCHEDULE_TYPES]
GO
/****** Object:  ForeignKey [FK_REQUEST_SEC_FURN_LINE_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_SEC_FURN_LINE_TYPES] FOREIGN KEY([SEC_FURN_LINE_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_SEC_FURN_LINE_TYPES]
GO
/****** Object:  ForeignKey [FK_REQUEST_SEC_FURN_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_SEC_FURN_TYPES] FOREIGN KEY([SEC_FURN_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_SEC_FURN_TYPES]
GO
/****** Object:  ForeignKey [FK_REQUEST_SECURITY_CONTACTS]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_SECURITY_CONTACTS] FOREIGN KEY([SECURITY_CONTACT_ID])
REFERENCES [dbo].[CONTACTS] ([CONTACT_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_SECURITY_CONTACTS]
GO
/****** Object:  ForeignKey [FK_REQUEST_SITE_VISIT_REQ_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_SITE_VISIT_REQ_TYPES] FOREIGN KEY([SITE_VISIT_REQ_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_SITE_VISIT_REQ_TYPES]
GO
/****** Object:  ForeignKey [FK_REQUEST_STAGING_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_STAGING_TYPES] FOREIGN KEY([STAGING_AREA_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_STAGING_TYPES]
GO
/****** Object:  ForeignKey [FK_REQUEST_STATION_TYPICAL_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_STATION_TYPICAL_TYPES] FOREIGN KEY([WORKSTATION_TYPICAL_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_STATION_TYPICAL_TYPES]
GO
/****** Object:  ForeignKey [FK_REQUEST_STATUSES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_STATUSES] FOREIGN KEY([REQUEST_STATUS_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_STATUSES]
GO
/****** Object:  ForeignKey [fk_request_sys_furn_line_type]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH CHECK ADD  CONSTRAINT [fk_request_sys_furn_line_type] FOREIGN KEY([SYSTEM_FURNITURE_LINE_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [fk_request_sys_furn_line_type]
GO
/****** Object:  ForeignKey [FK_REQUEST_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_TYPES] FOREIGN KEY([REQUEST_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_TYPES]
GO
/****** Object:  ForeignKey [FK_REQUEST_UNION_LABOR_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_UNION_LABOR_TYPES] FOREIGN KEY([UNION_LABOR_REQ_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_UNION_LABOR_TYPES]
GO
/****** Object:  ForeignKey [FK_REQUEST_USERS_C]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_USERS_C] FOREIGN KEY([CREATED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_USERS_C]
GO
/****** Object:  ForeignKey [FK_REQUEST_USERS_M]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_USERS_M] FOREIGN KEY([MODIFIED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_USERS_M]
GO
/****** Object:  ForeignKey [FK_REQUEST_WALKBOARD_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_WALKBOARD_TYPES] FOREIGN KEY([WALKBOARD_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_WALKBOARD_TYPES]
GO
/****** Object:  ForeignKey [FK_REQUEST_WALL_MOUNT_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_WALL_MOUNT_TYPES] FOREIGN KEY([WALL_MOUNT_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_WALL_MOUNT_TYPES]
GO
/****** Object:  ForeignKey [FK_REQUEST_WAREHOUSE_FEE_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_WAREHOUSE_FEE_TYPES] FOREIGN KEY([WAREHOUSE_FEE_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_WAREHOUSE_FEE_TYPES]
GO
/****** Object:  ForeignKey [FK_REQUEST_WEEKEND_HOURS_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_WEEKEND_HOURS_TYPES] FOREIGN KEY([WEEKEND_HOURS_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_WEEKEND_HOURS_TYPES]
GO
/****** Object:  ForeignKey [FK_REQUEST_WOOD_PRODUCT_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH NOCHECK ADD  CONSTRAINT [FK_REQUEST_WOOD_PRODUCT_TYPES] FOREIGN KEY([WOOD_PRODUCT_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUEST_WOOD_PRODUCT_TYPES]
GO
/****** Object:  ForeignKey [FK_REQUESTS_A_M_SALES_CONTACT_ID]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH CHECK ADD  CONSTRAINT [FK_REQUESTS_A_M_SALES_CONTACT_ID] FOREIGN KEY([A_M_SALES_CONTACT_ID])
REFERENCES [dbo].[CONTACTS] ([CONTACT_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUESTS_A_M_SALES_CONTACT_ID]
GO
/****** Object:  ForeignKey [FK_REQUESTS_PROD_DIST]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[REQUESTS]  WITH CHECK ADD  CONSTRAINT [FK_REQUESTS_PROD_DIST] FOREIGN KEY([PROD_DISP_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[REQUESTS] CHECK CONSTRAINT [FK_REQUESTS_PROD_DIST]
GO
/****** Object:  ForeignKey [FK_RE_JOB_ITEM_RATES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[RESOURCE_ESTIMATES]  WITH NOCHECK ADD  CONSTRAINT [FK_RE_JOB_ITEM_RATES] FOREIGN KEY([JOB_ITEM_RATE_ID])
REFERENCES [dbo].[JOB_ITEM_RATES] ([JOB_ITEM_RATE_ID])
GO
ALTER TABLE [dbo].[RESOURCE_ESTIMATES] CHECK CONSTRAINT [FK_RE_JOB_ITEM_RATES]
GO
/****** Object:  ForeignKey [FK_RE_JOBS]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[RESOURCE_ESTIMATES]  WITH NOCHECK ADD  CONSTRAINT [FK_RE_JOBS] FOREIGN KEY([JOB_ID])
REFERENCES [dbo].[JOBS] ([JOB_ID])
GO
ALTER TABLE [dbo].[RESOURCE_ESTIMATES] CHECK CONSTRAINT [FK_RE_JOBS]
GO
/****** Object:  ForeignKey [FK_RE_RESOURCE_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[RESOURCE_ESTIMATES]  WITH CHECK ADD  CONSTRAINT [FK_RE_RESOURCE_TYPES] FOREIGN KEY([RESOURCE_TYPE_ID])
REFERENCES [dbo].[RESOURCE_TYPES] ([RESOURCE_TYPE_ID])
GO
ALTER TABLE [dbo].[RESOURCE_ESTIMATES] CHECK CONSTRAINT [FK_RE_RESOURCE_TYPES]
GO
/****** Object:  ForeignKey [FK_RE_SERVICES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[RESOURCE_ESTIMATES]  WITH NOCHECK ADD  CONSTRAINT [FK_RE_SERVICES] FOREIGN KEY([SERVICE_ID])
REFERENCES [dbo].[SERVICES] ([SERVICE_ID])
GO
ALTER TABLE [dbo].[RESOURCE_ESTIMATES] CHECK CONSTRAINT [FK_RE_SERVICES]
GO
/****** Object:  ForeignKey [FK_RE_USERS_C]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[RESOURCE_ESTIMATES]  WITH NOCHECK ADD  CONSTRAINT [FK_RE_USERS_C] FOREIGN KEY([CREATED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[RESOURCE_ESTIMATES] CHECK CONSTRAINT [FK_RE_USERS_C]
GO
/****** Object:  ForeignKey [FK_RE_USERS_M]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[RESOURCE_ESTIMATES]  WITH NOCHECK ADD  CONSTRAINT [FK_RE_USERS_M] FOREIGN KEY([MODIFIED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[RESOURCE_ESTIMATES] CHECK CONSTRAINT [FK_RE_USERS_M]
GO
/****** Object:  ForeignKey [FK_RI_ITEMS]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[RESOURCE_ITEMS]  WITH NOCHECK ADD  CONSTRAINT [FK_RI_ITEMS] FOREIGN KEY([ITEM_ID])
REFERENCES [dbo].[ITEMS] ([ITEM_ID])
GO
ALTER TABLE [dbo].[RESOURCE_ITEMS] CHECK CONSTRAINT [FK_RI_ITEMS]
GO
/****** Object:  ForeignKey [FK_RI_RESOURCES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[RESOURCE_ITEMS]  WITH NOCHECK ADD  CONSTRAINT [FK_RI_RESOURCES] FOREIGN KEY([RESOURCE_ID])
REFERENCES [dbo].[RESOURCES] ([RESOURCE_ID])
GO
ALTER TABLE [dbo].[RESOURCE_ITEMS] NOCHECK CONSTRAINT [FK_RI_RESOURCES]
GO
/****** Object:  ForeignKey [FK_RI_USERS_C]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[RESOURCE_ITEMS]  WITH NOCHECK ADD  CONSTRAINT [FK_RI_USERS_C] FOREIGN KEY([CREATED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[RESOURCE_ITEMS] CHECK CONSTRAINT [FK_RI_USERS_C]
GO
/****** Object:  ForeignKey [FK_RI_USERS_M]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[RESOURCE_ITEMS]  WITH NOCHECK ADD  CONSTRAINT [FK_RI_USERS_M] FOREIGN KEY([MODIFIED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[RESOURCE_ITEMS] CHECK CONSTRAINT [FK_RI_USERS_M]
GO
/****** Object:  ForeignKey [FK_RTI_ITEMS]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[RESOURCE_TYPE_ITEMS]  WITH NOCHECK ADD  CONSTRAINT [FK_RTI_ITEMS] FOREIGN KEY([ITEM_ID])
REFERENCES [dbo].[ITEMS] ([ITEM_ID])
GO
ALTER TABLE [dbo].[RESOURCE_TYPE_ITEMS] CHECK CONSTRAINT [FK_RTI_ITEMS]
GO
/****** Object:  ForeignKey [FK_RTI_RESOURCE_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[RESOURCE_TYPE_ITEMS]  WITH NOCHECK ADD  CONSTRAINT [FK_RTI_RESOURCE_TYPES] FOREIGN KEY([RESOURCE_TYPE_ID])
REFERENCES [dbo].[RESOURCE_TYPES] ([RESOURCE_TYPE_ID])
GO
ALTER TABLE [dbo].[RESOURCE_TYPE_ITEMS] CHECK CONSTRAINT [FK_RTI_RESOURCE_TYPES]
GO
/****** Object:  ForeignKey [FK_RTI_USERS_C]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[RESOURCE_TYPE_ITEMS]  WITH NOCHECK ADD  CONSTRAINT [FK_RTI_USERS_C] FOREIGN KEY([CREATED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[RESOURCE_TYPE_ITEMS] CHECK CONSTRAINT [FK_RTI_USERS_C]
GO
/****** Object:  ForeignKey [FK_RTI_USERS_M]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[RESOURCE_TYPE_ITEMS]  WITH NOCHECK ADD  CONSTRAINT [FK_RTI_USERS_M] FOREIGN KEY([MODIFIED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[RESOURCE_TYPE_ITEMS] CHECK CONSTRAINT [FK_RTI_USERS_M]
GO
/****** Object:  ForeignKey [FK_RT_USERS_C]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[RESOURCE_TYPES]  WITH NOCHECK ADD  CONSTRAINT [FK_RT_USERS_C] FOREIGN KEY([CREATED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[RESOURCE_TYPES] CHECK CONSTRAINT [FK_RT_USERS_C]
GO
/****** Object:  ForeignKey [FK_RT_USERS_M]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[RESOURCE_TYPES]  WITH NOCHECK ADD  CONSTRAINT [FK_RT_USERS_M] FOREIGN KEY([MODIFIED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[RESOURCE_TYPES] CHECK CONSTRAINT [FK_RT_USERS_M]
GO
/****** Object:  ForeignKey [FK_RESOURCE_ORGANIZATIONS]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[RESOURCES]  WITH NOCHECK ADD  CONSTRAINT [FK_RESOURCE_ORGANIZATIONS] FOREIGN KEY([ORGANIZATION_ID])
REFERENCES [dbo].[ORGANIZATIONS] ([ORGANIZATION_ID])
GO
ALTER TABLE [dbo].[RESOURCES] CHECK CONSTRAINT [FK_RESOURCE_ORGANIZATIONS]
GO
/****** Object:  ForeignKey [FK_RESOURCE_RESOURCE_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[RESOURCES]  WITH NOCHECK ADD  CONSTRAINT [FK_RESOURCE_RESOURCE_TYPES] FOREIGN KEY([RESOURCE_TYPE_ID])
REFERENCES [dbo].[RESOURCE_TYPES] ([RESOURCE_TYPE_ID])
GO
ALTER TABLE [dbo].[RESOURCES] CHECK CONSTRAINT [FK_RESOURCE_RESOURCE_TYPES]
GO
/****** Object:  ForeignKey [FK_RESOURCE_USERS]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[RESOURCES]  WITH NOCHECK ADD  CONSTRAINT [FK_RESOURCE_USERS] FOREIGN KEY([USER_ID])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[RESOURCES] CHECK CONSTRAINT [FK_RESOURCE_USERS]
GO
/****** Object:  ForeignKey [FK_RESOURCE_USERS_C]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[RESOURCES]  WITH NOCHECK ADD  CONSTRAINT [FK_RESOURCE_USERS_C] FOREIGN KEY([CREATED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[RESOURCES] CHECK CONSTRAINT [FK_RESOURCE_USERS_C]
GO
/****** Object:  ForeignKey [FK_RESOURCE_USERS_M]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[RESOURCES]  WITH NOCHECK ADD  CONSTRAINT [FK_RESOURCE_USERS_M] FOREIGN KEY([MODIFIED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[RESOURCES] CHECK CONSTRAINT [FK_RESOURCE_USERS_M]
GO
/****** Object:  ForeignKey [FK_RIGHT_TYPE_USERS_C]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[RIGHT_TYPES]  WITH NOCHECK ADD  CONSTRAINT [FK_RIGHT_TYPE_USERS_C] FOREIGN KEY([CREATED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[RIGHT_TYPES] CHECK CONSTRAINT [FK_RIGHT_TYPE_USERS_C]
GO
/****** Object:  ForeignKey [FK_RIGHT_TYPE_USERS_M]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[RIGHT_TYPES]  WITH NOCHECK ADD  CONSTRAINT [FK_RIGHT_TYPE_USERS_M] FOREIGN KEY([MODIFIED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[RIGHT_TYPES] CHECK CONSTRAINT [FK_RIGHT_TYPE_USERS_M]
GO
/****** Object:  ForeignKey [FK_RFR_FUNCTIONS]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[ROLE_FUNCTION_RIGHTS]  WITH NOCHECK ADD  CONSTRAINT [FK_RFR_FUNCTIONS] FOREIGN KEY([FUNCTION_ID])
REFERENCES [dbo].[FUNCTIONS] ([FUNCTION_ID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ROLE_FUNCTION_RIGHTS] CHECK CONSTRAINT [FK_RFR_FUNCTIONS]
GO
/****** Object:  ForeignKey [FK_RFR_RIGHT_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[ROLE_FUNCTION_RIGHTS]  WITH NOCHECK ADD  CONSTRAINT [FK_RFR_RIGHT_TYPES] FOREIGN KEY([RIGHT_TYPE_ID])
REFERENCES [dbo].[RIGHT_TYPES] ([RIGHT_TYPE_ID])
GO
ALTER TABLE [dbo].[ROLE_FUNCTION_RIGHTS] CHECK CONSTRAINT [FK_RFR_RIGHT_TYPES]
GO
/****** Object:  ForeignKey [FK_RFR_ROLES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[ROLE_FUNCTION_RIGHTS]  WITH NOCHECK ADD  CONSTRAINT [FK_RFR_ROLES] FOREIGN KEY([ROLE_ID])
REFERENCES [dbo].[ROLES] ([ROLE_ID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ROLE_FUNCTION_RIGHTS] CHECK CONSTRAINT [FK_RFR_ROLES]
GO
/****** Object:  ForeignKey [FK_RFR_USERS_C]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[ROLE_FUNCTION_RIGHTS]  WITH NOCHECK ADD  CONSTRAINT [FK_RFR_USERS_C] FOREIGN KEY([CREATED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[ROLE_FUNCTION_RIGHTS] CHECK CONSTRAINT [FK_RFR_USERS_C]
GO
/****** Object:  ForeignKey [FK_RFR_USERS_M]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[ROLE_FUNCTION_RIGHTS]  WITH NOCHECK ADD  CONSTRAINT [FK_RFR_USERS_M] FOREIGN KEY([MODIFIED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[ROLE_FUNCTION_RIGHTS] CHECK CONSTRAINT [FK_RFR_USERS_M]
GO
/****** Object:  ForeignKey [FK_ROLE_USERS_C]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[ROLES]  WITH NOCHECK ADD  CONSTRAINT [FK_ROLE_USERS_C] FOREIGN KEY([CREATED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[ROLES] CHECK CONSTRAINT [FK_ROLE_USERS_C]
GO
/****** Object:  ForeignKey [FK_ROLE_USERS_M]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[ROLES]  WITH NOCHECK ADD  CONSTRAINT [FK_ROLE_USERS_M] FOREIGN KEY([MODIFIED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[ROLES] CHECK CONSTRAINT [FK_ROLE_USERS_M]
GO
/****** Object:  ForeignKey [FK_RESOURCE_SCH_RESOURCES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[SCH_RESOURCES]  WITH NOCHECK ADD  CONSTRAINT [FK_RESOURCE_SCH_RESOURCES] FOREIGN KEY([RESOURCE_ID])
REFERENCES [dbo].[RESOURCES] ([RESOURCE_ID])
GO
ALTER TABLE [dbo].[SCH_RESOURCES] CHECK CONSTRAINT [FK_RESOURCE_SCH_RESOURCES]
GO
/****** Object:  ForeignKey [FK_SR_DATE_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[SCH_RESOURCES]  WITH NOCHECK ADD  CONSTRAINT [FK_SR_DATE_TYPES] FOREIGN KEY([DATE_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[SCH_RESOURCES] CHECK CONSTRAINT [FK_SR_DATE_TYPES]
GO
/****** Object:  ForeignKey [FK_SR_HIDDEN_SERVICES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[SCH_RESOURCES]  WITH NOCHECK ADD  CONSTRAINT [FK_SR_HIDDEN_SERVICES] FOREIGN KEY([HIDDEN_SERVICE_ID])
REFERENCES [dbo].[SERVICES] ([SERVICE_ID])
GO
ALTER TABLE [dbo].[SCH_RESOURCES] CHECK CONSTRAINT [FK_SR_HIDDEN_SERVICES]
GO
/****** Object:  ForeignKey [FK_SR_JOBS]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[SCH_RESOURCES]  WITH NOCHECK ADD  CONSTRAINT [FK_SR_JOBS] FOREIGN KEY([JOB_ID])
REFERENCES [dbo].[JOBS] ([JOB_ID])
GO
ALTER TABLE [dbo].[SCH_RESOURCES] CHECK CONSTRAINT [FK_SR_JOBS]
GO
/****** Object:  ForeignKey [FK_SR_REASON_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[SCH_RESOURCES]  WITH NOCHECK ADD  CONSTRAINT [FK_SR_REASON_TYPES] FOREIGN KEY([REASON_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[SCH_RESOURCES] CHECK CONSTRAINT [FK_SR_REASON_TYPES]
GO
/****** Object:  ForeignKey [FK_SR_REPORT_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[SCH_RESOURCES]  WITH NOCHECK ADD  CONSTRAINT [FK_SR_REPORT_TYPES] FOREIGN KEY([REPORT_TO_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[SCH_RESOURCES] CHECK CONSTRAINT [FK_SR_REPORT_TYPES]
GO
/****** Object:  ForeignKey [FK_SR_RES_STATUS_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[SCH_RESOURCES]  WITH NOCHECK ADD  CONSTRAINT [FK_SR_RES_STATUS_TYPES] FOREIGN KEY([RES_STATUS_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[SCH_RESOURCES] CHECK CONSTRAINT [FK_SR_RES_STATUS_TYPES]
GO
/****** Object:  ForeignKey [FK_SR_RESOURCES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[SCH_RESOURCES]  WITH NOCHECK ADD  CONSTRAINT [FK_SR_RESOURCES] FOREIGN KEY([RESOURCE_ID])
REFERENCES [dbo].[RESOURCES] ([RESOURCE_ID])
GO
ALTER TABLE [dbo].[SCH_RESOURCES] CHECK CONSTRAINT [FK_SR_RESOURCES]
GO
/****** Object:  ForeignKey [FK_SR_SERVICES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[SCH_RESOURCES]  WITH NOCHECK ADD  CONSTRAINT [FK_SR_SERVICES] FOREIGN KEY([SERVICE_ID])
REFERENCES [dbo].[SERVICES] ([SERVICE_ID])
GO
ALTER TABLE [dbo].[SCH_RESOURCES] CHECK CONSTRAINT [FK_SR_SERVICES]
GO
/****** Object:  ForeignKey [FK_SR_USERS_C]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[SCH_RESOURCES]  WITH NOCHECK ADD  CONSTRAINT [FK_SR_USERS_C] FOREIGN KEY([CREATED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[SCH_RESOURCES] CHECK CONSTRAINT [FK_SR_USERS_C]
GO
/****** Object:  ForeignKey [FK_SR_USERS_M]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[SCH_RESOURCES]  WITH NOCHECK ADD  CONSTRAINT [FK_SR_USERS_M] FOREIGN KEY([MODIFIED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[SCH_RESOURCES] CHECK CONSTRAINT [FK_SR_USERS_M]
GO
/****** Object:  ForeignKey [FK_SR_WEEKEND]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[SCH_RESOURCES]  WITH NOCHECK ADD  CONSTRAINT [FK_SR_WEEKEND] FOREIGN KEY([WEEKEND_SCH_RESOURCE_ID])
REFERENCES [dbo].[SCH_RESOURCES] ([SCH_RESOURCE_ID])
GO
ALTER TABLE [dbo].[SCH_RESOURCES] CHECK CONSTRAINT [FK_SR_WEEKEND]
GO
/****** Object:  ForeignKey [FK_SIL_INVOICE_LINES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[SERV_INV_LINES]  WITH NOCHECK ADD  CONSTRAINT [FK_SIL_INVOICE_LINES] FOREIGN KEY([INVOICE_LINE_ID])
REFERENCES [dbo].[INVOICE_LINES] ([INVOICE_LINE_ID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[SERV_INV_LINES] CHECK CONSTRAINT [FK_SIL_INVOICE_LINES]
GO
/****** Object:  ForeignKey [FK_SIL_SERVICE_LINES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[SERV_INV_LINES]  WITH NOCHECK ADD  CONSTRAINT [FK_SIL_SERVICE_LINES] FOREIGN KEY([SERVICE_LINE_ID])
REFERENCES [dbo].[SERVICE_LINES] ([SERVICE_LINE_ID])
GO
ALTER TABLE [dbo].[SERV_INV_LINES] CHECK CONSTRAINT [FK_SIL_SERVICE_LINES]
GO
/****** Object:  ForeignKey [FK_SL_BILL_SERVICES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[SERVICE_LINES]  WITH NOCHECK ADD  CONSTRAINT [FK_SL_BILL_SERVICES] FOREIGN KEY([BILL_SERVICE_ID])
REFERENCES [dbo].[SERVICES] ([SERVICE_ID])
GO
ALTER TABLE [dbo].[SERVICE_LINES] CHECK CONSTRAINT [FK_SL_BILL_SERVICES]
GO
/****** Object:  ForeignKey [FK_SL_ENTERED_BY]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[SERVICE_LINES]  WITH NOCHECK ADD  CONSTRAINT [FK_SL_ENTERED_BY] FOREIGN KEY([ENTERED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[SERVICE_LINES] CHECK CONSTRAINT [FK_SL_ENTERED_BY]
GO
/****** Object:  ForeignKey [FK_SL_INVOICES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[SERVICE_LINES]  WITH NOCHECK ADD  CONSTRAINT [FK_SL_INVOICES] FOREIGN KEY([INVOICE_ID])
REFERENCES [dbo].[INVOICES] ([INVOICE_ID])
GO
ALTER TABLE [dbo].[SERVICE_LINES] CHECK CONSTRAINT [FK_SL_INVOICES]
GO
/****** Object:  ForeignKey [FK_SL_ITEMS]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[SERVICE_LINES]  WITH NOCHECK ADD  CONSTRAINT [FK_SL_ITEMS] FOREIGN KEY([ITEM_ID])
REFERENCES [dbo].[ITEMS] ([ITEM_ID])
GO
ALTER TABLE [dbo].[SERVICE_LINES] CHECK CONSTRAINT [FK_SL_ITEMS]
GO
/****** Object:  ForeignKey [FK_SL_OVERRIDE_BY]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[SERVICE_LINES]  WITH NOCHECK ADD  CONSTRAINT [FK_SL_OVERRIDE_BY] FOREIGN KEY([OVERRIDE_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[SERVICE_LINES] CHECK CONSTRAINT [FK_SL_OVERRIDE_BY]
GO
/****** Object:  ForeignKey [FK_SL_OVERRIDE_REASON_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[SERVICE_LINES]  WITH NOCHECK ADD  CONSTRAINT [FK_SL_OVERRIDE_REASON_TYPES] FOREIGN KEY([OVERRIDE_REASON])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[SERVICE_LINES] CHECK CONSTRAINT [FK_SL_OVERRIDE_REASON_TYPES]
GO
/****** Object:  ForeignKey [FK_SL_POOL_SERVICE_ID]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[SERVICE_LINES]  WITH NOCHECK ADD  CONSTRAINT [FK_SL_POOL_SERVICE_ID] FOREIGN KEY([PH_SERVICE_ID])
REFERENCES [dbo].[SERVICES] ([SERVICE_ID])
GO
ALTER TABLE [dbo].[SERVICE_LINES] CHECK CONSTRAINT [FK_SL_POOL_SERVICE_ID]
GO
/****** Object:  ForeignKey [FK_SL_RESOURCES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[SERVICE_LINES]  WITH NOCHECK ADD  CONSTRAINT [FK_SL_RESOURCES] FOREIGN KEY([RESOURCE_ID])
REFERENCES [dbo].[RESOURCES] ([RESOURCE_ID])
GO
ALTER TABLE [dbo].[SERVICE_LINES] CHECK CONSTRAINT [FK_SL_RESOURCES]
GO
/****** Object:  ForeignKey [FK_SL_SERVICE_LINE_STATUSES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[SERVICE_LINES]  WITH NOCHECK ADD  CONSTRAINT [FK_SL_SERVICE_LINE_STATUSES] FOREIGN KEY([STATUS_ID])
REFERENCES [dbo].[SERVICE_LINE_STATUSES] ([STATUS_ID])
GO
ALTER TABLE [dbo].[SERVICE_LINES] CHECK CONSTRAINT [FK_SL_SERVICE_LINE_STATUSES]
GO
/****** Object:  ForeignKey [FK_SL_SERVICES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[SERVICE_LINES]  WITH NOCHECK ADD  CONSTRAINT [FK_SL_SERVICES] FOREIGN KEY([TC_SERVICE_ID])
REFERENCES [dbo].[SERVICES] ([SERVICE_ID])
GO
ALTER TABLE [dbo].[SERVICE_LINES] CHECK CONSTRAINT [FK_SL_SERVICES]
GO
/****** Object:  ForeignKey [FK_SL_USERS_C]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[SERVICE_LINES]  WITH NOCHECK ADD  CONSTRAINT [FK_SL_USERS_C] FOREIGN KEY([CREATED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[SERVICE_LINES] CHECK CONSTRAINT [FK_SL_USERS_C]
GO
/****** Object:  ForeignKey [FK_SL_USERS_M]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[SERVICE_LINES]  WITH NOCHECK ADD  CONSTRAINT [FK_SL_USERS_M] FOREIGN KEY([MODIFIED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[SERVICE_LINES] CHECK CONSTRAINT [FK_SL_USERS_M]
GO
/****** Object:  ForeignKey [FK_SL_VERIFIED_BY]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[SERVICE_LINES]  WITH NOCHECK ADD  CONSTRAINT [FK_SL_VERIFIED_BY] FOREIGN KEY([VERIFIED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[SERVICE_LINES] CHECK CONSTRAINT [FK_SL_VERIFIED_BY]
GO
/****** Object:  ForeignKey [FK_ST_PHASE_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[SERVICE_TASKS]  WITH CHECK ADD  CONSTRAINT [FK_ST_PHASE_TYPES] FOREIGN KEY([PHASE_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[SERVICE_TASKS] CHECK CONSTRAINT [FK_ST_PHASE_TYPES]
GO
/****** Object:  ForeignKey [FK_ST_SERVICES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[SERVICE_TASKS]  WITH NOCHECK ADD  CONSTRAINT [FK_ST_SERVICES] FOREIGN KEY([SERVICE_ID])
REFERENCES [dbo].[SERVICES] ([SERVICE_ID])
GO
ALTER TABLE [dbo].[SERVICE_TASKS] CHECK CONSTRAINT [FK_ST_SERVICES]
GO
/****** Object:  ForeignKey [FK_ST_SUB_ACT_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[SERVICE_TASKS]  WITH CHECK ADD  CONSTRAINT [FK_ST_SUB_ACT_TYPES] FOREIGN KEY([SUB_ACT_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[SERVICE_TASKS] CHECK CONSTRAINT [FK_ST_SUB_ACT_TYPES]
GO
/****** Object:  ForeignKey [FK_ST_USERS_C]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[SERVICE_TASKS]  WITH NOCHECK ADD  CONSTRAINT [FK_ST_USERS_C] FOREIGN KEY([CREATED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[SERVICE_TASKS] CHECK CONSTRAINT [FK_ST_USERS_C]
GO
/****** Object:  ForeignKey [FK_ST_USERS_M]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[SERVICE_TASKS]  WITH CHECK ADD  CONSTRAINT [FK_ST_USERS_M] FOREIGN KEY([MODIFIED_BY])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[SERVICE_TASKS] CHECK CONSTRAINT [FK_ST_USERS_M]
GO
/****** Object:  ForeignKey [FK_JL_SERVICES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[SERVICES]  WITH NOCHECK ADD  CONSTRAINT [FK_JL_SERVICES] FOREIGN KEY([JOB_LOCATION_ID])
REFERENCES [dbo].[JOB_LOCATIONS] ([JOB_LOCATION_ID])
GO
ALTER TABLE [dbo].[SERVICES] CHECK CONSTRAINT [FK_JL_SERVICES]
GO
/****** Object:  ForeignKey [fk_service_customer_contact2]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[SERVICES]  WITH CHECK ADD  CONSTRAINT [fk_service_customer_contact2] FOREIGN KEY([customer_contact2_id])
REFERENCES [dbo].[CONTACTS] ([CONTACT_ID])
GO
ALTER TABLE [dbo].[SERVICES] CHECK CONSTRAINT [fk_service_customer_contact2]
GO
/****** Object:  ForeignKey [fk_service_customer_contact3]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[SERVICES]  WITH CHECK ADD  CONSTRAINT [fk_service_customer_contact3] FOREIGN KEY([customer_contact3_id])
REFERENCES [dbo].[CONTACTS] ([CONTACT_ID])
GO
ALTER TABLE [dbo].[SERVICES] CHECK CONSTRAINT [fk_service_customer_contact3]
GO
/****** Object:  ForeignKey [fk_service_customer_contact4]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[SERVICES]  WITH CHECK ADD  CONSTRAINT [fk_service_customer_contact4] FOREIGN KEY([customer_contact4_id])
REFERENCES [dbo].[CONTACTS] ([CONTACT_ID])
GO
ALTER TABLE [dbo].[SERVICES] CHECK CONSTRAINT [fk_service_customer_contact4]
GO
/****** Object:  ForeignKey [fk_service_job_loc_contact]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[SERVICES]  WITH CHECK ADD  CONSTRAINT [fk_service_job_loc_contact] FOREIGN KEY([job_location_contact_id])
REFERENCES [dbo].[CONTACTS] ([CONTACT_ID])
GO
ALTER TABLE [dbo].[SERVICES] CHECK CONSTRAINT [fk_service_job_loc_contact]
GO
/****** Object:  ForeignKey [FK_SERVICE_REQUESTS]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[SERVICES]  WITH NOCHECK ADD  CONSTRAINT [FK_SERVICE_REQUESTS] FOREIGN KEY([REQUEST_ID])
REFERENCES [dbo].[REQUESTS] ([REQUEST_ID])
GO
ALTER TABLE [dbo].[SERVICES] NOCHECK CONSTRAINT [FK_SERVICE_REQUESTS]
GO
/****** Object:  ForeignKey [FK_SERVICES_BILLING_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[SERVICES]  WITH NOCHECK ADD  CONSTRAINT [FK_SERVICES_BILLING_TYPES] FOREIGN KEY([BILLING_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[SERVICES] CHECK CONSTRAINT [FK_SERVICES_BILLING_TYPES]
GO
/****** Object:  ForeignKey [FK_SERVICES_CUSTOMER_CONTACTS]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[SERVICES]  WITH NOCHECK ADD  CONSTRAINT [FK_SERVICES_CUSTOMER_CONTACTS] FOREIGN KEY([CUSTOMER_CONTACT_ID])
REFERENCES [dbo].[CONTACTS] ([CONTACT_ID])
GO
ALTER TABLE [dbo].[SERVICES] CHECK CONSTRAINT [FK_SERVICES_CUSTOMER_CONTACTS]
GO
/****** Object:  ForeignKey [FK_SERVICES_DELIVERY_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[SERVICES]  WITH NOCHECK ADD  CONSTRAINT [FK_SERVICES_DELIVERY_TYPES] FOREIGN KEY([DELIVERY_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[SERVICES] CHECK CONSTRAINT [FK_SERVICES_DELIVERY_TYPES]
GO
/****** Object:  ForeignKey [FK_SERVICES_DESIGNER_CONTACTS]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[SERVICES]  WITH NOCHECK ADD  CONSTRAINT [FK_SERVICES_DESIGNER_CONTACTS] FOREIGN KEY([DESIGNER_CONTACT_ID])
REFERENCES [dbo].[CONTACTS] ([CONTACT_ID])
GO
ALTER TABLE [dbo].[SERVICES] CHECK CONSTRAINT [FK_SERVICES_DESIGNER_CONTACTS]
GO
/****** Object:  ForeignKey [FK_SERVICES_IDM_CONTACTS]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[SERVICES]  WITH NOCHECK ADD  CONSTRAINT [FK_SERVICES_IDM_CONTACTS] FOREIGN KEY([IDM_CONTACT_ID])
REFERENCES [dbo].[CONTACTS] ([CONTACT_ID])
GO
ALTER TABLE [dbo].[SERVICES] CHECK CONSTRAINT [FK_SERVICES_IDM_CONTACTS]
GO
/****** Object:  ForeignKey [FK_SERVICES_JOB_LOCATIONS]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[SERVICES]  WITH NOCHECK ADD  CONSTRAINT [FK_SERVICES_JOB_LOCATIONS] FOREIGN KEY([JOB_LOCATION_ID])
REFERENCES [dbo].[JOB_LOCATIONS] ([JOB_LOCATION_ID])
GO
ALTER TABLE [dbo].[SERVICES] CHECK CONSTRAINT [FK_SERVICES_JOB_LOCATIONS]
GO
/****** Object:  ForeignKey [FK_SERVICES_JOBS]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[SERVICES]  WITH NOCHECK ADD  CONSTRAINT [FK_SERVICES_JOBS] FOREIGN KEY([JOB_ID])
REFERENCES [dbo].[JOBS] ([JOB_ID])
GO
ALTER TABLE [dbo].[SERVICES] NOCHECK CONSTRAINT [FK_SERVICES_JOBS]
GO
/****** Object:  ForeignKey [FK_SERVICES_PRI_FURN_LINE_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[SERVICES]  WITH NOCHECK ADD  CONSTRAINT [FK_SERVICES_PRI_FURN_LINE_TYPES] FOREIGN KEY([PRI_FURN_LINE_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[SERVICES] CHECK CONSTRAINT [FK_SERVICES_PRI_FURN_LINE_TYPES]
GO
/****** Object:  ForeignKey [FK_SERVICES_PRI_FURN_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[SERVICES]  WITH NOCHECK ADD  CONSTRAINT [FK_SERVICES_PRI_FURN_TYPES] FOREIGN KEY([PRI_FURN_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[SERVICES] CHECK CONSTRAINT [FK_SERVICES_PRI_FURN_TYPES]
GO
/****** Object:  ForeignKey [FK_SERVICES_PROJ_MRG_CONTACTS]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[SERVICES]  WITH NOCHECK ADD  CONSTRAINT [FK_SERVICES_PROJ_MRG_CONTACTS] FOREIGN KEY([PROJECT_MGR_CONTACT_ID])
REFERENCES [dbo].[CONTACTS] ([CONTACT_ID])
GO
ALTER TABLE [dbo].[SERVICES] CHECK CONSTRAINT [FK_SERVICES_PROJ_MRG_CONTACTS]
GO
/****** Object:  ForeignKey [FK_SERVICES_PUNCHLIST_TYPE_ID]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[SERVICES]  WITH NOCHECK ADD  CONSTRAINT [FK_SERVICES_PUNCHLIST_TYPE_ID] FOREIGN KEY([PUNCHLIST_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[SERVICES] CHECK CONSTRAINT [FK_SERVICES_PUNCHLIST_TYPE_ID]
GO
/****** Object:  ForeignKey [FK_SERVICES_REPORT_TO_LOCS]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[SERVICES]  WITH NOCHECK ADD  CONSTRAINT [FK_SERVICES_REPORT_TO_LOCS] FOREIGN KEY([REPORT_TO_LOC_ID])
REFERENCES [dbo].[JOB_LOCATIONS] ([JOB_LOCATION_ID])
GO
ALTER TABLE [dbo].[SERVICES] CHECK CONSTRAINT [FK_SERVICES_REPORT_TO_LOCS]
GO
/****** Object:  ForeignKey [FK_SERVICES_SALES_CONTACTS]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[SERVICES]  WITH NOCHECK ADD  CONSTRAINT [FK_SERVICES_SALES_CONTACTS] FOREIGN KEY([SALES_CONTACT_ID])
REFERENCES [dbo].[CONTACTS] ([CONTACT_ID])
GO
ALTER TABLE [dbo].[SERVICES] CHECK CONSTRAINT [FK_SERVICES_SALES_CONTACTS]
GO
/****** Object:  ForeignKey [FK_SERVICES_SCHEDULE_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[SERVICES]  WITH NOCHECK ADD  CONSTRAINT [FK_SERVICES_SCHEDULE_TYPES] FOREIGN KEY([SCHEDULE_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[SERVICES] CHECK CONSTRAINT [FK_SERVICES_SCHEDULE_TYPES]
GO
/****** Object:  ForeignKey [FK_SERVICES_SEC_FURN_LINE_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[SERVICES]  WITH NOCHECK ADD  CONSTRAINT [FK_SERVICES_SEC_FURN_LINE_TYPES] FOREIGN KEY([SEC_FURN_LINE_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[SERVICES] CHECK CONSTRAINT [FK_SERVICES_SEC_FURN_LINE_TYPES]
GO
/****** Object:  ForeignKey [FK_SERVICES_SEC_FURN_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[SERVICES]  WITH NOCHECK ADD  CONSTRAINT [FK_SERVICES_SEC_FURN_TYPES] FOREIGN KEY([SEC_FURN_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[SERVICES] CHECK CONSTRAINT [FK_SERVICES_SEC_FURN_TYPES]
GO
/****** Object:  ForeignKey [FK_SERVICES_STATUS_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[SERVICES]  WITH NOCHECK ADD  CONSTRAINT [FK_SERVICES_STATUS_TYPES] FOREIGN KEY([SERV_STATUS_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[SERVICES] CHECK CONSTRAINT [FK_SERVICES_STATUS_TYPES]
GO
/****** Object:  ForeignKey [FK_SERVICES_SUPPORT_CONTACTS]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[SERVICES]  WITH NOCHECK ADD  CONSTRAINT [FK_SERVICES_SUPPORT_CONTACTS] FOREIGN KEY([SUPPORT_CONTACT_ID])
REFERENCES [dbo].[CONTACTS] ([CONTACT_ID])
GO
ALTER TABLE [dbo].[SERVICES] CHECK CONSTRAINT [FK_SERVICES_SUPPORT_CONTACTS]
GO
/****** Object:  ForeignKey [FK_SERVICES_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[SERVICES]  WITH NOCHECK ADD  CONSTRAINT [FK_SERVICES_TYPES] FOREIGN KEY([SERVICE_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[SERVICES] CHECK CONSTRAINT [FK_SERVICES_TYPES]
GO
/****** Object:  ForeignKey [FK_SERVICES_USERS_C]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[SERVICES]  WITH NOCHECK ADD  CONSTRAINT [FK_SERVICES_USERS_C] FOREIGN KEY([CREATED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[SERVICES] CHECK CONSTRAINT [FK_SERVICES_USERS_C]
GO
/****** Object:  ForeignKey [FK_SERVICES_USERS_M]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[SERVICES]  WITH NOCHECK ADD  CONSTRAINT [FK_SERVICES_USERS_M] FOREIGN KEY([MODIFIED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[SERVICES] CHECK CONSTRAINT [FK_SERVICES_USERS_M]
GO
/****** Object:  ForeignKey [FK_SERVICES_WOOD_PRODUCT_TYPES]    Script Date: 03/02/2010 13:08:46 ******/
ALTER TABLE [dbo].[SERVICES]  WITH NOCHECK ADD  CONSTRAINT [FK_SERVICES_WOOD_PRODUCT_TYPES] FOREIGN KEY([WOOD_PRODUCT_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[SERVICES] CHECK CONSTRAINT [FK_SERVICES_WOOD_PRODUCT_TYPES]
GO
/****** Object:  ForeignKey [FK_SC_USERS_C]    Script Date: 03/02/2010 13:08:47 ******/
ALTER TABLE [dbo].[STANDARD_CONDITIONS]  WITH NOCHECK ADD  CONSTRAINT [FK_SC_USERS_C] FOREIGN KEY([created_by])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[STANDARD_CONDITIONS] CHECK CONSTRAINT [FK_SC_USERS_C]
GO
/****** Object:  ForeignKey [FK_SC_USERS_M]    Script Date: 03/02/2010 13:08:47 ******/
ALTER TABLE [dbo].[STANDARD_CONDITIONS]  WITH NOCHECK ADD  CONSTRAINT [FK_SC_USERS_M] FOREIGN KEY([modified_by])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[STANDARD_CONDITIONS] CHECK CONSTRAINT [FK_SC_USERS_M]
GO
/****** Object:  ForeignKey [fk_states_country]    Script Date: 03/02/2010 13:08:47 ******/
ALTER TABLE [dbo].[states]  WITH CHECK ADD  CONSTRAINT [fk_states_country] FOREIGN KEY([country_code])
REFERENCES [dbo].[countries] ([code])
GO
ALTER TABLE [dbo].[states] CHECK CONSTRAINT [fk_states_country]
GO
/****** Object:  ForeignKey [FK_TRACKING_FROM_USERS]    Script Date: 03/02/2010 13:08:47 ******/
ALTER TABLE [dbo].[TRACKING]  WITH NOCHECK ADD  CONSTRAINT [FK_TRACKING_FROM_USERS] FOREIGN KEY([FROM_USER_ID])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[TRACKING] CHECK CONSTRAINT [FK_TRACKING_FROM_USERS]
GO
/****** Object:  ForeignKey [FK_TRACKING_JOBS]    Script Date: 03/02/2010 13:08:47 ******/
ALTER TABLE [dbo].[TRACKING]  WITH NOCHECK ADD  CONSTRAINT [FK_TRACKING_JOBS] FOREIGN KEY([JOB_ID])
REFERENCES [dbo].[JOBS] ([JOB_ID])
GO
ALTER TABLE [dbo].[TRACKING] CHECK CONSTRAINT [FK_TRACKING_JOBS]
GO
/****** Object:  ForeignKey [FK_TRACKING_NEW_STATUSES]    Script Date: 03/02/2010 13:08:47 ******/
ALTER TABLE [dbo].[TRACKING]  WITH CHECK ADD  CONSTRAINT [FK_TRACKING_NEW_STATUSES] FOREIGN KEY([NEW_STATUS_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[TRACKING] CHECK CONSTRAINT [FK_TRACKING_NEW_STATUSES]
GO
/****** Object:  ForeignKey [FK_TRACKING_OLD_STATUSES]    Script Date: 03/02/2010 13:08:47 ******/
ALTER TABLE [dbo].[TRACKING]  WITH CHECK ADD  CONSTRAINT [FK_TRACKING_OLD_STATUSES] FOREIGN KEY([OLD_STATUS_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[TRACKING] CHECK CONSTRAINT [FK_TRACKING_OLD_STATUSES]
GO
/****** Object:  ForeignKey [FK_TRACKING_SERVICES]    Script Date: 03/02/2010 13:08:47 ******/
ALTER TABLE [dbo].[TRACKING]  WITH NOCHECK ADD  CONSTRAINT [FK_TRACKING_SERVICES] FOREIGN KEY([SERVICE_ID])
REFERENCES [dbo].[SERVICES] ([SERVICE_ID])
GO
ALTER TABLE [dbo].[TRACKING] CHECK CONSTRAINT [FK_TRACKING_SERVICES]
GO
/****** Object:  ForeignKey [FK_TRACKING_TO_CONTACTS]    Script Date: 03/02/2010 13:08:47 ******/
ALTER TABLE [dbo].[TRACKING]  WITH NOCHECK ADD  CONSTRAINT [FK_TRACKING_TO_CONTACTS] FOREIGN KEY([TO_CONTACT_ID])
REFERENCES [dbo].[CONTACTS] ([CONTACT_ID])
GO
ALTER TABLE [dbo].[TRACKING] CHECK CONSTRAINT [FK_TRACKING_TO_CONTACTS]
GO
/****** Object:  ForeignKey [FK_TRACKING_TYPES]    Script Date: 03/02/2010 13:08:47 ******/
ALTER TABLE [dbo].[TRACKING]  WITH CHECK ADD  CONSTRAINT [FK_TRACKING_TYPES] FOREIGN KEY([TRACKING_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[TRACKING] CHECK CONSTRAINT [FK_TRACKING_TYPES]
GO
/****** Object:  ForeignKey [FK_TRACKING_USERS_C]    Script Date: 03/02/2010 13:08:47 ******/
ALTER TABLE [dbo].[TRACKING]  WITH NOCHECK ADD  CONSTRAINT [FK_TRACKING_USERS_C] FOREIGN KEY([CREATED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[TRACKING] CHECK CONSTRAINT [FK_TRACKING_USERS_C]
GO
/****** Object:  ForeignKey [FK_TRACKING_USERS_M]    Script Date: 03/02/2010 13:08:47 ******/
ALTER TABLE [dbo].[TRACKING]  WITH NOCHECK ADD  CONSTRAINT [FK_TRACKING_USERS_M] FOREIGN KEY([MODIFIED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[TRACKING] CHECK CONSTRAINT [FK_TRACKING_USERS_M]
GO
/****** Object:  ForeignKey [FK_USER_APPROVERS_CUSTOMERS]    Script Date: 03/02/2010 13:08:47 ******/
ALTER TABLE [dbo].[USER_APPROVERS]  WITH CHECK ADD  CONSTRAINT [FK_USER_APPROVERS_CUSTOMERS] FOREIGN KEY([customer_id])
REFERENCES [dbo].[CUSTOMERS] ([CUSTOMER_ID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[USER_APPROVERS] CHECK CONSTRAINT [FK_USER_APPROVERS_CUSTOMERS]
GO
/****** Object:  ForeignKey [FK_USER_APPROVERS_USERS]    Script Date: 03/02/2010 13:08:47 ******/
ALTER TABLE [dbo].[USER_APPROVERS]  WITH CHECK ADD  CONSTRAINT [FK_USER_APPROVERS_USERS] FOREIGN KEY([user_id])
REFERENCES [dbo].[USERS] ([USER_ID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[USER_APPROVERS] CHECK CONSTRAINT [FK_USER_APPROVERS_USERS]
GO
/****** Object:  ForeignKey [fk_uceu_customer_id]    Script Date: 03/02/2010 13:08:47 ******/
ALTER TABLE [dbo].[user_customer_end_users]  WITH CHECK ADD  CONSTRAINT [fk_uceu_customer_id] FOREIGN KEY([customer_id])
REFERENCES [dbo].[CUSTOMERS] ([CUSTOMER_ID])
GO
ALTER TABLE [dbo].[user_customer_end_users] CHECK CONSTRAINT [fk_uceu_customer_id]
GO
/****** Object:  ForeignKey [fk_uceu_user_customer_id]    Script Date: 03/02/2010 13:08:47 ******/
ALTER TABLE [dbo].[user_customer_end_users]  WITH CHECK ADD  CONSTRAINT [fk_uceu_user_customer_id] FOREIGN KEY([user_customer_id])
REFERENCES [dbo].[USER_CUSTOMERS] ([user_customer_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[user_customer_end_users] CHECK CONSTRAINT [fk_uceu_user_customer_id]
GO
/****** Object:  ForeignKey [FK_USER_CUSTOMERS_CUSTOMERS]    Script Date: 03/02/2010 13:08:47 ******/
ALTER TABLE [dbo].[USER_CUSTOMERS]  WITH CHECK ADD  CONSTRAINT [FK_USER_CUSTOMERS_CUSTOMERS] FOREIGN KEY([customer_id])
REFERENCES [dbo].[CUSTOMERS] ([CUSTOMER_ID])
GO
ALTER TABLE [dbo].[USER_CUSTOMERS] CHECK CONSTRAINT [FK_USER_CUSTOMERS_CUSTOMERS]
GO
/****** Object:  ForeignKey [FK_USER_CUSTOMERS_USERS]    Script Date: 03/02/2010 13:08:47 ******/
ALTER TABLE [dbo].[USER_CUSTOMERS]  WITH CHECK ADD  CONSTRAINT [FK_USER_CUSTOMERS_USERS] FOREIGN KEY([user_id])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[USER_CUSTOMERS] CHECK CONSTRAINT [FK_USER_CUSTOMERS_USERS]
GO
/****** Object:  ForeignKey [FK_USER_JOB_TYPES_LOOKUPS]    Script Date: 03/02/2010 13:08:47 ******/
ALTER TABLE [dbo].[USER_JOB_TYPES]  WITH CHECK ADD  CONSTRAINT [FK_USER_JOB_TYPES_LOOKUPS] FOREIGN KEY([LOOKUP_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[USER_JOB_TYPES] CHECK CONSTRAINT [FK_USER_JOB_TYPES_LOOKUPS]
GO
/****** Object:  ForeignKey [FK_USER_JOB_TYPES_USERS]    Script Date: 03/02/2010 13:08:47 ******/
ALTER TABLE [dbo].[USER_JOB_TYPES]  WITH CHECK ADD  CONSTRAINT [FK_USER_JOB_TYPES_USERS] FOREIGN KEY([USER_ID])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[USER_JOB_TYPES] CHECK CONSTRAINT [FK_USER_JOB_TYPES_USERS]
GO
/****** Object:  ForeignKey [FK_UO_ORGANIZATIONS]    Script Date: 03/02/2010 13:08:47 ******/
ALTER TABLE [dbo].[USER_ORGANIZATIONS]  WITH NOCHECK ADD  CONSTRAINT [FK_UO_ORGANIZATIONS] FOREIGN KEY([ORGANIZATION_ID])
REFERENCES [dbo].[ORGANIZATIONS] ([ORGANIZATION_ID])
GO
ALTER TABLE [dbo].[USER_ORGANIZATIONS] CHECK CONSTRAINT [FK_UO_ORGANIZATIONS]
GO
/****** Object:  ForeignKey [FK_UO_USERS]    Script Date: 03/02/2010 13:08:47 ******/
ALTER TABLE [dbo].[USER_ORGANIZATIONS]  WITH NOCHECK ADD  CONSTRAINT [FK_UO_USERS] FOREIGN KEY([USER_ID])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[USER_ORGANIZATIONS] CHECK CONSTRAINT [FK_UO_USERS]
GO
/****** Object:  ForeignKey [FK_UO_USERS_C]    Script Date: 03/02/2010 13:08:47 ******/
ALTER TABLE [dbo].[USER_ORGANIZATIONS]  WITH NOCHECK ADD  CONSTRAINT [FK_UO_USERS_C] FOREIGN KEY([CREATED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[USER_ORGANIZATIONS] CHECK CONSTRAINT [FK_UO_USERS_C]
GO
/****** Object:  ForeignKey [FK_UO_USERS_M]    Script Date: 03/02/2010 13:08:47 ******/
ALTER TABLE [dbo].[USER_ORGANIZATIONS]  WITH NOCHECK ADD  CONSTRAINT [FK_UO_USERS_M] FOREIGN KEY([MODIFIED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[USER_ORGANIZATIONS] CHECK CONSTRAINT [FK_UO_USERS_M]
GO
/****** Object:  ForeignKey [FK_UR_ROLES]    Script Date: 03/02/2010 13:08:47 ******/
ALTER TABLE [dbo].[USER_ROLES]  WITH CHECK ADD  CONSTRAINT [FK_UR_ROLES] FOREIGN KEY([ROLE_ID])
REFERENCES [dbo].[ROLES] ([ROLE_ID])
GO
ALTER TABLE [dbo].[USER_ROLES] CHECK CONSTRAINT [FK_UR_ROLES]
GO
/****** Object:  ForeignKey [FK_UR_USERS]    Script Date: 03/02/2010 13:08:47 ******/
ALTER TABLE [dbo].[USER_ROLES]  WITH NOCHECK ADD  CONSTRAINT [FK_UR_USERS] FOREIGN KEY([USER_ID])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[USER_ROLES] CHECK CONSTRAINT [FK_UR_USERS]
GO
/****** Object:  ForeignKey [FK_UR_USERS_C]    Script Date: 03/02/2010 13:08:47 ******/
ALTER TABLE [dbo].[USER_ROLES]  WITH NOCHECK ADD  CONSTRAINT [FK_UR_USERS_C] FOREIGN KEY([CREATED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[USER_ROLES] CHECK CONSTRAINT [FK_UR_USERS_C]
GO
/****** Object:  ForeignKey [FK_UR_USERS_M]    Script Date: 03/02/2010 13:08:47 ******/
ALTER TABLE [dbo].[USER_ROLES]  WITH NOCHECK ADD  CONSTRAINT [FK_UR_USERS_M] FOREIGN KEY([MODIFIED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[USER_ROLES] CHECK CONSTRAINT [FK_UR_USERS_M]
GO
/****** Object:  ForeignKey [FK_USER_VENDORS_CUSTOMERS]    Script Date: 03/02/2010 13:08:47 ******/
ALTER TABLE [dbo].[USER_VENDORS]  WITH CHECK ADD  CONSTRAINT [FK_USER_VENDORS_CUSTOMERS] FOREIGN KEY([customer_id])
REFERENCES [dbo].[CUSTOMERS] ([CUSTOMER_ID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[USER_VENDORS] CHECK CONSTRAINT [FK_USER_VENDORS_CUSTOMERS]
GO
/****** Object:  ForeignKey [FK_USER_VENDORS_USERS]    Script Date: 03/02/2010 13:08:47 ******/
ALTER TABLE [dbo].[USER_VENDORS]  WITH CHECK ADD  CONSTRAINT [FK_USER_VENDORS_USERS] FOREIGN KEY([user_id])
REFERENCES [dbo].[USERS] ([USER_ID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[USER_VENDORS] CHECK CONSTRAINT [FK_USER_VENDORS_USERS]
GO
/****** Object:  ForeignKey [FK_USER_CONTACTS]    Script Date: 03/02/2010 13:08:47 ******/
ALTER TABLE [dbo].[USERS]  WITH NOCHECK ADD  CONSTRAINT [FK_USER_CONTACTS] FOREIGN KEY([CONTACT_ID])
REFERENCES [dbo].[CONTACTS] ([CONTACT_ID])
GO
ALTER TABLE [dbo].[USERS] CHECK CONSTRAINT [FK_USER_CONTACTS]
GO
/****** Object:  ForeignKey [FK_USER_EMPLOYMENT_TYPES]    Script Date: 03/02/2010 13:08:47 ******/
ALTER TABLE [dbo].[USERS]  WITH NOCHECK ADD  CONSTRAINT [FK_USER_EMPLOYMENT_TYPES] FOREIGN KEY([EMPLOYMENT_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[USERS] CHECK CONSTRAINT [FK_USER_EMPLOYMENT_TYPES]
GO
/****** Object:  ForeignKey [FK_USER_TYPES]    Script Date: 03/02/2010 13:08:47 ******/
ALTER TABLE [dbo].[USERS]  WITH NOCHECK ADD  CONSTRAINT [FK_USER_TYPES] FOREIGN KEY([USER_TYPE_ID])
REFERENCES [dbo].[LOOKUPS] ([LOOKUP_ID])
GO
ALTER TABLE [dbo].[USERS] CHECK CONSTRAINT [FK_USER_TYPES]
GO
/****** Object:  ForeignKey [FK_USER_USERS_C]    Script Date: 03/02/2010 13:08:47 ******/
ALTER TABLE [dbo].[USERS]  WITH NOCHECK ADD  CONSTRAINT [FK_USER_USERS_C] FOREIGN KEY([CREATED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[USERS] CHECK CONSTRAINT [FK_USER_USERS_C]
GO
/****** Object:  ForeignKey [FK_USER_USERS_M]    Script Date: 03/02/2010 13:08:47 ******/
ALTER TABLE [dbo].[USERS]  WITH NOCHECK ADD  CONSTRAINT [FK_USER_USERS_M] FOREIGN KEY([MODIFIED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[USERS] CHECK CONSTRAINT [FK_USER_USERS_M]
GO
/****** Object:  ForeignKey [fk_user_vendor_contact]    Script Date: 03/02/2010 13:08:47 ******/
ALTER TABLE [dbo].[USERS]  WITH NOCHECK ADD  CONSTRAINT [fk_user_vendor_contact] FOREIGN KEY([VENDOR_CONTACT_ID])
REFERENCES [dbo].[CONTACTS] ([CONTACT_ID])
GO
ALTER TABLE [dbo].[USERS] CHECK CONSTRAINT [fk_user_vendor_contact]
GO
/****** Object:  ForeignKey [FK_VERSIONS_DOCUMENTS]    Script Date: 03/02/2010 13:08:47 ******/
ALTER TABLE [dbo].[VERSIONS]  WITH CHECK ADD  CONSTRAINT [FK_VERSIONS_DOCUMENTS] FOREIGN KEY([DOCUMENT_ID])
REFERENCES [dbo].[DOCUMENTS] ([DOCUMENT_ID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[VERSIONS] CHECK CONSTRAINT [FK_VERSIONS_DOCUMENTS]
GO
