SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

ALTER TRIGGER ud_ph_trig ON dbo.SERVICE_LINES 
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
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

