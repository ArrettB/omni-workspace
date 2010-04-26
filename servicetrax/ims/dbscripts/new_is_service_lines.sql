SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

ALTER TRIGGER iu_service_lines ON dbo.SERVICE_LINES 
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

PRINT(' tc_qty = '+cast(ISNULL(@tc_qty,0) as varchar(10)))
PRINT(' tc_rate = '+cast(ISNULL(@tc_rate,0) as varchar(10)))
PRINT(' old_tc_qty = '+cast(ISNULL(@old_tc_qty,0) as varchar(10)) )
PRINT(' old_tc_rate = '+cast(ISNULL(@old_tc_rate,0) as varchar(10)))
PRINT(' item_type_code = '+ cast(ISNULL(@item_type_code,'none') as varchar(10)))
PRINT(' bill_qty = '+cast(ISNULL(@bill_qty,0) as varchar(10)))
PRINT(' bill_rate = '+cast(ISNULL(@bill_rate,0) as varchar(10)))
PRINT(' old_bill_qty = '+cast(ISNULL(@old_bill_qty,0) as varchar(10)) )
PRINT(' old_bill_rate = '+cast(ISNULL(@old_bill_rate,0) as varchar(10)))

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
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

