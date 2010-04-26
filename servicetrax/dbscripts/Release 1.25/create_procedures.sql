CREATE PROCEDURE sp_estimator
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
			
			SELECT  [T5].[customer_id],
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
				CAST([T2].[project_no] AS VARCHAR(100)) + '-' + CAST([T1].[REQUEST_NO] AS VARCHAR(100)) + '.' + CAST([T1].[VERSION_NO] AS VARCHAR(100)) AS [QUOTE_NUM]
			FROM [quotes] AS [T0]
			LEFT JOIN [requests] AS [T1]
				ON [T0].[request_id] = [T1].[request_id]
			LEFT JOIN [projects] AS [T2]
				ON [T1].[project_id] = [T2].[project_id]
			LEFT JOIN [contacts] AS [T3]
				ON [T1].[customer_contact_id] = [T3].[contact_id]
			LEFT JOIN [customers] AS [T5]
				ON CAST([T2].[customer_id] AS VARCHAR) = [T5].[customer_id]
			LEFT JOIN [organizations] AS [T7]
				ON [T5].[organization_id] = [T7].[organization_id]
			LEFT JOIN [job_locations] AS [T6]
				ON [T1].[job_location_id] = [T6].[job_location_id]
			LEFT JOIN [customers] AS [T8]
				ON CAST([T2].[end_user_id] AS VARCHAR) = [T8].[customer_id]
			WHERE [T0].[quote_id] = @QuoteID

		END

END
GO

CREATE FUNCTION sp_contact_phone (@in_contact_id numeric(18,0)) RETURNS varchar(100)
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

CREATE FUNCTION sp_varchar20_to_number (@in_value varchar(20)) RETURNS numeric(18,2)
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



CREATE PROCEDURE sp_ambim_customer
AS
BEGIN

DECLARE @custnmbr char(15)
DECLARE @shrtname char(15)
DECLARE @dealer_type_id numeric(18,0)
DECLARE @end_user_type_id numeric(18,0)
DECLARE @rm CURSOR

SET @rm = CURSOR FAST_FORWARD
FOR
SELECT custnmbr, shrtname
  FROM ambim.dbo.rm00101 
 WHERE userdef1='dealer' 
   AND custnmbr NOT LIKE 'old%'
   AND shrtname NOT LIKE 'A&M%'
   
SET @dealer_type_id 
= (SELECT l.lookup_id 
     FROM lookups l INNER JOIN lookup_types lt ON l.lookup_type_id=lt.lookup_type_id
    WHERE lt.code='customer_type' AND l.code='dealer')
 
SET @end_user_type_id 
= (SELECT l.lookup_id 
     FROM lookups l INNER JOIN lookup_types lt ON l.lookup_type_id=lt.lookup_type_id
    WHERE lt.code='customer_type' AND l.code='end_user')

OPEN @rm
FETCH NEXT FROM @rm INTO @custnmbr,@shrtname

WHILE @@FETCH_STATUS=0
BEGIN
  UPDATE customers 
     SET end_user_parent_id=(SELECT customer_id 
                               FROM customers 
                              WHERE ISNULL(ext_customer_id,'') = @custnmbr
                                AND customer_type_id = @dealer_type_id
                                AND organization_id=(SELECT organization_id FROM organizations WHERE db_prefix LIKE 'ambim.dbo%'))
   WHERE customer_type_id = @end_user_type_id
     AND ext_dealer_id = @custnmbr
     AND organization_id=(SELECT organization_id FROM organizations WHERE db_prefix LIKE 'ambim.dbo%') 
     
  FETCH NEXT FROM @rm INTO @custnmbr, @shrtname
END

CLOSE @rm
DEALLOCATE @rm

END
GO

CREATE PROCEDURE sp_ambim_dealer_contact
AS
BEGIN

DECLARE @contact_id numeric(18,0)
DECLARE @customer_id numeric(18,0)
DECLARE @dealer_contacts CURSOR

SET @dealer_contacts = CURSOR FAST_FORWARD
FOR
SELECT c.contact_id,cust.customer_id
  FROM customers cust INNER JOIN 
       contacts c ON ISNULL(cust.ext_customer_id,'')=c.ext_dealer_id INNER JOIN
       lookups l ON c.cont_status_type_id=l.lookup_id INNER JOIN 
       lookup_types lt ON l.lookup_type_id=lt.lookup_type_id INNER JOIN
       lookups l2 ON cust.customer_type_id=l2.lookup_id INNER JOIN
       lookup_types lt2 ON l2.lookup_type_id=lt2.lookup_type_id  INNER JOIN
       contact_groups cg ON c.contact_id = cg.contact_id INNER JOIN
       lookups l3 ON cg.contact_type_id = l3.lookup_id INNER JOIN
       lookup_types lt3 ON l3.lookup_type_id=lt3.lookup_type_id
 WHERE c.customer_id IS NULL 
   AND c.ext_dealer_id IN (SELECT custnmbr FROM ambim.dbo.rm00101 WHERE shrtname NOT LIKE 'A&M%' AND userdef1='DEALER')
   AND cust.organization_id=(SELECT organization_id FROM organizations WHERE db_prefix='ambim.dbo.')
   AND lt.code='contact_status_type'
   AND l.code='active'
   AND lt2.code='customer_type'
   AND l2.code='dealer'
   AND lt3.code='contact_type'
   AND l3.code IN ('sales','designer','support','project_mgr')


OPEN @dealer_contacts
FETCH NEXT FROM @dealer_contacts INTO @contact_id,@customer_id 

WHILE @@FETCH_STATUS=0
BEGIN
  
  UPDATE contacts 
     SET customer_id = @customer_id,
         notes = 'dealer contact',
         date_modified = getdate(),
         modified_by = 0
   WHERE contact_id = @contact_id
     
  FETCH NEXT FROM @dealer_contacts INTO @contact_id,@customer_id 
END

CLOSE @dealer_contacts
DEALLOCATE @dealer_contacts

END
GO

CREATE PROCEDURE sp_ambim_new_end_user
AS
BEGIN

DECLARE @customer_id numeric(18,0)
DECLARE @customer_name varchar(65)
DECLARE @organization_id numeric(18,0)
DECLARE @ext_dealer_id char(15)
DECLARE @end_user_type_id numeric(18,0)
DECLARE @end_user CURSOR

SET @end_user = CURSOR FAST_FORWARD
FOR
SELECT c.customer_id,c.customer_name,organization_id,ext_dealer_id
  FROM customers c INNER JOIN 
       lookups l ON c.customer_type_id=l.lookup_id INNER JOIN
       lookup_types lt ON l.lookup_type_id=lt.lookup_type_id 
 WHERE lt.code='customer_type'
   AND l.code IN ('commercial', 'corporate','government')
   AND ISNULL(c.ext_customer_id,'') NOT LIKE 'old%'
   AND c.ext_dealer_id = (SELECT custnmbr FROM ambim.dbo.rm00101 WHERE RTRIM(shrtname)='A&M Business In' AND userdef1='DEALER')
   AND ISNULL(c.ext_customer_id,'') NOT IN (SELECT custnmbr FROM ambim.dbo.rm00101 WHERE shrtname NOT LIKE 'A&M%' AND userdef1='DEALER')

 
SET @end_user_type_id 
= (SELECT l.lookup_id 
     FROM lookups l INNER JOIN lookup_types lt ON l.lookup_type_id=lt.lookup_type_id
    WHERE lt.code='customer_type' AND l.code='end_user')

OPEN @end_user
FETCH NEXT FROM @end_user INTO @customer_id,@customer_name,@organization_id,@ext_dealer_id 

WHILE @@FETCH_STATUS=0
BEGIN
  PRINT @customer_name
  
  INSERT INTO customers (organization_id, 
                         ext_dealer_id, 
                         dealer_name, 
                         customer_name,
                         active_flag,
                         date_created,
                         created_by, 
                         view_schedule_flag, 
                         customer_type_id,
                         end_user_parent_id)
  VALUES (@organization_id, 
          @ext_dealer_id,
          'A&M Business In',
          @customer_name,
          'Y',
          getdate(),
          1,
          'N',
          @end_user_type_id,
          @customer_id)
          
  INSERT INTO job_locations (customer_id,
                             job_location_name,
                             location_type_id,
                             ext_address_id,
                             street1,
                             street2,
                             street3,
                             city,
                             state,
                             zip,
                             country,
                             directions,
                             job_loc_contact_id,
                             bldg_mgmt_contact_id,
                             loading_dock_type_id,
                             dock_available_time,
                             dock_reserv_req_type_id,
                             semi_access_type_id,
                             dock_height,
                             elevator_avail_type_id,
                             elevator_reserv_req_type_id,
                             floor_protection_type_id,
                             wall_protection_type_id,
                             doorway_prot_type_id,
                             stair_carry_type_id,
                             stair_carry_flights,
                             stair_carry_stairs,
                             smallest_door_elev_width,
                             multi_level_type_id,
                             security_type_id,
                             date_created,
                             created_by)                           
  SELECT eu.customer_id,
         jl.job_location_name,
         jl.location_type_id,
         jl.ext_address_id,
         jl.street1,
         jl.street2,
         jl.street3,
         jl.city,
         jl.state,
         jl.zip,
         jl.country,
         jl.directions,
         jl.job_loc_contact_id,
         jl.bldg_mgmt_contact_id,
         jl.loading_dock_type_id,
         jl.dock_available_time,
         jl.dock_reserv_req_type_id,
         jl.semi_access_type_id,
         jl.dock_height,
         jl.elevator_avail_type_id,
         jl.elevator_reserv_req_type_id,
         jl.floor_protection_type_id,
         jl.wall_protection_type_id,
         jl.doorway_prot_type_id,
         jl.stair_carry_type_id,
         jl.stair_carry_flights,
         jl.stair_carry_stairs,
         jl.smallest_door_elev_width,
         jl.multi_level_type_id,
         jl.security_type_id,
         getDate(),
         1
    FROM customers eu,
         job_locations jl
   WHERE jl.customer_id = @customer_id
     AND eu.end_user_parent_id = @customer_id
     
  FETCH NEXT FROM @end_user INTO @customer_id,@customer_name,@organization_id,@ext_dealer_id
END

CLOSE @end_user
DEALLOCATE @end_user

END
GO

CREATE PROCEDURE sp_ammad_customer
AS
BEGIN

DECLARE @custnmbr char(15)
DECLARE @shrtname char(15)
DECLARE @dealer_type_id numeric(18,0)
DECLARE @end_user_type_id numeric(18,0)
DECLARE @rm CURSOR

SET @rm = CURSOR FAST_FORWARD
FOR
SELECT custnmbr, shrtname
  FROM ammad.dbo.rm00101 
 WHERE userdef1='dealer' 
   AND custnmbr NOT LIKE 'old%'
   AND shrtname NOT LIKE 'A&M%'
   
SET @dealer_type_id 
= (SELECT l.lookup_id 
     FROM lookups l INNER JOIN lookup_types lt ON l.lookup_type_id=lt.lookup_type_id
    WHERE lt.code='customer_type' AND l.code='dealer')
 
SET @end_user_type_id 
= (SELECT l.lookup_id 
     FROM lookups l INNER JOIN lookup_types lt ON l.lookup_type_id=lt.lookup_type_id
    WHERE lt.code='customer_type' AND l.code='end_user')

OPEN @rm
FETCH NEXT FROM @rm INTO @custnmbr,@shrtname

WHILE @@FETCH_STATUS=0
BEGIN
  UPDATE customers 
     SET end_user_parent_id=(SELECT customer_id 
                               FROM customers 
                              WHERE ISNULL(ext_customer_id,'') = @custnmbr
                                AND customer_type_id = @dealer_type_id
                                AND organization_id=(SELECT organization_id FROM organizations WHERE db_prefix LIKE 'ammad.dbo%'))
   WHERE customer_type_id = @end_user_type_id
     AND ext_dealer_id = @custnmbr
     AND organization_id=(SELECT organization_id FROM organizations WHERE db_prefix LIKE 'ammad.dbo%') 
     
  FETCH NEXT FROM @rm INTO @custnmbr, @shrtname
END

CLOSE @rm
DEALLOCATE @rm

END
GO

CREATE PROCEDURE sp_ammad_dealer_contact
AS
BEGIN

DECLARE @contact_id numeric(18,0)
DECLARE @customer_id numeric(18,0)
DECLARE @dealer_contacts CURSOR

SET @dealer_contacts = CURSOR FAST_FORWARD
FOR
SELECT c.contact_id,cust.customer_id
  FROM customers cust INNER JOIN 
       contacts c ON ISNULL(cust.ext_customer_id,'')=c.ext_dealer_id INNER JOIN
       lookups l ON c.cont_status_type_id=l.lookup_id INNER JOIN 
       lookup_types lt ON l.lookup_type_id=lt.lookup_type_id INNER JOIN
       lookups l2 ON cust.customer_type_id=l2.lookup_id INNER JOIN
       lookup_types lt2 ON l2.lookup_type_id=lt2.lookup_type_id  INNER JOIN
       contact_groups cg ON c.contact_id = cg.contact_id INNER JOIN
       lookups l3 ON cg.contact_type_id = l3.lookup_id INNER JOIN
       lookup_types lt3 ON l3.lookup_type_id=lt3.lookup_type_id
 WHERE c.customer_id IS NULL 
   AND c.ext_dealer_id IN (SELECT custnmbr FROM ammad.dbo.rm00101 WHERE shrtname NOT LIKE 'A&M%' AND userdef1='DEALER')
   AND cust.organization_id=(SELECT organization_id FROM organizations WHERE db_prefix='ammad.dbo.')
   AND lt.code='contact_status_type'
   AND l.code='active'
   AND lt2.code='customer_type'
   AND l2.code='dealer'
   AND lt3.code='contact_type'
   AND l3.code IN ('sales','designer','support','project_mgr')


OPEN @dealer_contacts
FETCH NEXT FROM @dealer_contacts INTO @contact_id,@customer_id 

WHILE @@FETCH_STATUS=0
BEGIN
  
  UPDATE contacts 
     SET customer_id = @customer_id,
         notes = 'dealer contact',
         date_modified = getdate(),
         modified_by = 0
   WHERE contact_id = @contact_id
     
  FETCH NEXT FROM @dealer_contacts INTO @contact_id,@customer_id 
END

CLOSE @dealer_contacts
DEALLOCATE @dealer_contacts

END
GO

CREATE PROCEDURE sp_ammad_new_end_user
AS
BEGIN

DECLARE @customer_id numeric(18,0)
DECLARE @customer_name varchar(65)
DECLARE @organization_id numeric(18,0)
DECLARE @ext_dealer_id char(15)
DECLARE @end_user_type_id numeric(18,0)
DECLARE @end_user CURSOR

SET @end_user = CURSOR FAST_FORWARD
FOR
SELECT c.customer_id,c.customer_name,organization_id,ext_dealer_id
  FROM customers c INNER JOIN 
       lookups l ON c.customer_type_id=l.lookup_id INNER JOIN
       lookup_types lt ON l.lookup_type_id=lt.lookup_type_id 
 WHERE lt.code='customer_type'
   AND l.code IN ('commercial', 'corporate','government')
   AND ISNULL(c.ext_customer_id,'') NOT LIKE 'old%'
   AND c.ext_dealer_id = (SELECT custnmbr FROM ammad.dbo.rm00101 WHERE RTRIM(shrtname)='A&M Business In' AND userdef1='DEALER')
   AND ISNULL(c.ext_customer_id,'') NOT IN (SELECT custnmbr FROM ammad.dbo.rm00101 WHERE shrtname NOT LIKE 'A&M%' AND userdef1='DEALER')
   AND c.customer_id NOT IN (SELECT ISNULL(end_user_parent_id,0) FROM customers)

 
SET @end_user_type_id 
= (SELECT l.lookup_id 
     FROM lookups l INNER JOIN lookup_types lt ON l.lookup_type_id=lt.lookup_type_id
    WHERE lt.code='customer_type' AND l.code='end_user')

OPEN @end_user
FETCH NEXT FROM @end_user INTO @customer_id,@customer_name,@organization_id,@ext_dealer_id 

WHILE @@FETCH_STATUS=0
BEGIN
  PRINT @customer_name
  
  INSERT INTO customers (organization_id, 
                         ext_dealer_id, 
                         dealer_name, 
                         customer_name,
                         active_flag,
                         date_created,
                         created_by, 
                         view_schedule_flag, 
                         customer_type_id,
                         end_user_parent_id)
  VALUES (@organization_id, 
          @ext_dealer_id,
          'A&M Business In',
          @customer_name,
          'Y',
          getdate(),
          1,
          'N',
          @end_user_type_id,
          @customer_id)
          
  INSERT INTO job_locations (customer_id,
                             job_location_name,
                             location_type_id,
                             ext_address_id,
                             street1,
                             street2,
                             street3,
                             city,
                             state,
                             zip,
                             country,
                             directions,
                             job_loc_contact_id,
                             bldg_mgmt_contact_id,
                             loading_dock_type_id,
                             dock_available_time,
                             dock_reserv_req_type_id,
                             semi_access_type_id,
                             dock_height,
                             elevator_avail_type_id,
                             elevator_reserv_req_type_id,
                             floor_protection_type_id,
                             wall_protection_type_id,
                             doorway_prot_type_id,
                             stair_carry_type_id,
                             stair_carry_flights,
                             stair_carry_stairs,
                             smallest_door_elev_width,
                             multi_level_type_id,
                             security_type_id,
                             date_created,
                             created_by)
                             
  SELECT eu.customer_id,
         jl.job_location_name,
         jl.location_type_id,
         jl.ext_address_id,
         jl.street1,
         jl.street2,
         jl.street3,
         jl.city,
         jl.state,
         jl.zip,
         jl.country,
         jl.directions,
         jl.job_loc_contact_id,
         jl.bldg_mgmt_contact_id,
         jl.loading_dock_type_id,
         jl.dock_available_time,
         jl.dock_reserv_req_type_id,
         jl.semi_access_type_id,
         jl.dock_height,
         jl.elevator_avail_type_id,
         jl.elevator_reserv_req_type_id,
         jl.floor_protection_type_id,
         jl.wall_protection_type_id,
         jl.doorway_prot_type_id,
         jl.stair_carry_type_id,
         jl.stair_carry_flights,
         jl.stair_carry_stairs,
         jl.smallest_door_elev_width,
         jl.multi_level_type_id,
         jl.security_type_id,
         getDate(),
         1
    FROM customers eu,
         job_locations jl
   WHERE jl.customer_id = @customer_id
     AND eu.end_user_parent_id = @customer_id
     
  FETCH NEXT FROM @end_user INTO @customer_id,@customer_name,@organization_id,@ext_dealer_id
END

CLOSE @end_user
DEALLOCATE @end_user

END
GO

CREATE PROCEDURE sp_aia_customer
AS
BEGIN

DECLARE @custnmbr char(15)
DECLARE @shrtname char(15)
DECLARE @dealer_type_id numeric(18,0)
DECLARE @end_user_type_id numeric(18,0)
DECLARE @rm CURSOR

SET @rm = CURSOR FAST_FORWARD
FOR
SELECT custnmbr, shrtname
  FROM aia.dbo.rm00101 
 WHERE userdef1='dealer' 
   AND custnmbr NOT LIKE 'old%'
   AND shrtname NOT LIKE 'aia%'
   
SET @dealer_type_id 
= (SELECT l.lookup_id 
     FROM lookups l INNER JOIN lookup_types lt ON l.lookup_type_id=lt.lookup_type_id
    WHERE lt.code='customer_type' AND l.code='dealer')
 
SET @end_user_type_id 
= (SELECT l.lookup_id 
     FROM lookups l INNER JOIN lookup_types lt ON l.lookup_type_id=lt.lookup_type_id
    WHERE lt.code='customer_type' AND l.code='end_user')

OPEN @rm
FETCH NEXT FROM @rm INTO @custnmbr,@shrtname

WHILE @@FETCH_STATUS=0
BEGIN
  UPDATE customers 
     SET end_user_parent_id=(SELECT customer_id 
                               FROM customers 
                              WHERE ISNULL(ext_customer_id,'') = @custnmbr
                                AND customer_type_id = @dealer_type_id
                                AND organization_id=(SELECT organization_id FROM organizations WHERE db_prefix LIKE 'aia.dbo%'))
   WHERE customer_type_id = @end_user_type_id
     AND ext_dealer_id = @custnmbr
     AND organization_id=(SELECT organization_id FROM organizations WHERE db_prefix LIKE 'aia.dbo%') 
     
  FETCH NEXT FROM @rm INTO @custnmbr, @shrtname
END

CLOSE @rm
DEALLOCATE @rm

END
GO

CREATE PROCEDURE sp_aia_dealer_contact
AS
BEGIN

DECLARE @contact_id numeric(18,0)
DECLARE @customer_id numeric(18,0)
DECLARE @dealer_contacts CURSOR

SET @dealer_contacts = CURSOR FAST_FORWARD
FOR
SELECT c.contact_id,cust.customer_id
  FROM customers cust INNER JOIN 
       contacts c ON ISNULL(cust.ext_customer_id,'')=c.ext_dealer_id INNER JOIN
       lookups l ON c.cont_status_type_id=l.lookup_id INNER JOIN 
       lookup_types lt ON l.lookup_type_id=lt.lookup_type_id INNER JOIN
       lookups l2 ON cust.customer_type_id=l2.lookup_id INNER JOIN
       lookup_types lt2 ON l2.lookup_type_id=lt2.lookup_type_id  INNER JOIN
       contact_groups cg ON c.contact_id = cg.contact_id INNER JOIN
       lookups l3 ON cg.contact_type_id = l3.lookup_id INNER JOIN
       lookup_types lt3 ON l3.lookup_type_id=lt3.lookup_type_id
 WHERE c.customer_id IS NULL 
   AND c.ext_dealer_id IN (SELECT custnmbr FROM aia.dbo.rm00101 WHERE shrtname NOT LIKE 'AIA%' AND userdef1='DEALER')
   AND cust.organization_id=(SELECT organization_id FROM organizations WHERE db_prefix='aia.dbo.')
   AND lt.code='contact_status_type'
   AND l.code='active'
   AND lt2.code='customer_type'
   AND l2.code='dealer'
   AND lt3.code='contact_type'
   AND l3.code IN ('sales','designer','support','project_mgr')


OPEN @dealer_contacts
FETCH NEXT FROM @dealer_contacts INTO @contact_id,@customer_id 

WHILE @@FETCH_STATUS=0
BEGIN
  
  UPDATE contacts 
     SET customer_id = @customer_id,
         notes = 'dealer contact',
         date_modified = getdate(),
         modified_by = 0
   WHERE contact_id = @contact_id
     
  FETCH NEXT FROM @dealer_contacts INTO @contact_id,@customer_id 
END

CLOSE @dealer_contacts
DEALLOCATE @dealer_contacts

END
GO

CREATE PROCEDURE sp_aia_new_end_user
AS
BEGIN

DECLARE @customer_id numeric(18,0)
DECLARE @customer_name varchar(65)
DECLARE @organization_id numeric(18,0)
DECLARE @ext_dealer_id char(15)
DECLARE @end_user_type_id numeric(18,0)
DECLARE @end_user CURSOR

SET @end_user = CURSOR FAST_FORWARD
FOR
SELECT c.customer_id,c.customer_name,organization_id,ext_dealer_id
  FROM customers c INNER JOIN 
       lookups l ON c.customer_type_id=l.lookup_id INNER JOIN
       lookup_types lt ON l.lookup_type_id=lt.lookup_type_id 
 WHERE lt.code='customer_type'
   AND l.code IN ('commercial', 'corporate','government')
   AND ISNULL(c.ext_customer_id,'') NOT LIKE 'old%'
   AND c.ext_dealer_id = (SELECT custnmbr FROM aia.dbo.rm00101 WHERE RTRIM(shrtname)='AIA' AND userdef1='DEALER')
   AND ISNULL(c.ext_customer_id,'') NOT IN (SELECT custnmbr FROM aia.dbo.rm00101 WHERE shrtname NOT LIKE 'aia%' AND userdef1='DEALER')
   AND c.customer_id NOT IN (SELECT ISNULL(end_user_parent_id,0) FROM customers)

 
SET @end_user_type_id 
= (SELECT l.lookup_id 
     FROM lookups l INNER JOIN lookup_types lt ON l.lookup_type_id=lt.lookup_type_id
    WHERE lt.code='customer_type' AND l.code='end_user')

OPEN @end_user
FETCH NEXT FROM @end_user INTO @customer_id,@customer_name,@organization_id,@ext_dealer_id 

WHILE @@FETCH_STATUS=0
BEGIN
  PRINT @customer_name
  
  INSERT INTO customers (organization_id, 
                         ext_dealer_id, 
                         dealer_name, 
                         customer_name,
                         active_flag,
                         date_created,
                         created_by, 
                         view_schedule_flag, 
                         customer_type_id,
                         end_user_parent_id)
  VALUES (@organization_id, 
          @ext_dealer_id,
          'AIA',
          @customer_name,
          'Y',
          getdate(),
          1,
          'N',
          @end_user_type_id,
          @customer_id)
          
  INSERT INTO job_locations (customer_id,
                             job_location_name,
                             location_type_id,
                             ext_address_id,
                             street1,
                             street2,
                             street3,
                             city,
                             state,
                             zip,
                             country,
                             directions,
                             job_loc_contact_id,
                             bldg_mgmt_contact_id,
                             loading_dock_type_id,
                             dock_available_time,
                             dock_reserv_req_type_id,
                             semi_access_type_id,
                             dock_height,
                             elevator_avail_type_id,
                             elevator_reserv_req_type_id,
                             floor_protection_type_id,
                             wall_protection_type_id,
                             doorway_prot_type_id,
                             stair_carry_type_id,
                             stair_carry_flights,
                             stair_carry_stairs,
                             smallest_door_elev_width,
                             multi_level_type_id,
                             security_type_id,
                             date_created,
                             created_by)
                             
  SELECT eu.customer_id,
         jl.job_location_name,
         jl.location_type_id,
         jl.ext_address_id,
         jl.street1,
         jl.street2,
         jl.street3,
         jl.city,
         jl.state,
         jl.zip,
         jl.country,
         jl.directions,
         jl.job_loc_contact_id,
         jl.bldg_mgmt_contact_id,
         jl.loading_dock_type_id,
         jl.dock_available_time,
         jl.dock_reserv_req_type_id,
         jl.semi_access_type_id,
         jl.dock_height,
         jl.elevator_avail_type_id,
         jl.elevator_reserv_req_type_id,
         jl.floor_protection_type_id,
         jl.wall_protection_type_id,
         jl.doorway_prot_type_id,
         jl.stair_carry_type_id,
         jl.stair_carry_flights,
         jl.stair_carry_stairs,
         jl.smallest_door_elev_width,
         jl.multi_level_type_id,
         jl.security_type_id,
         getDate(),
         1
    FROM customers eu,
         job_locations jl
   WHERE jl.customer_id = @customer_id
     AND eu.end_user_parent_id = @customer_id
     
  FETCH NEXT FROM @end_user INTO @customer_id,@customer_name,@organization_id,@ext_dealer_id
END

CLOSE @end_user
DEALLOCATE @end_user

END
GO

CREATE PROCEDURE sp_ciinc_customer
AS
BEGIN

DECLARE @custnmbr char(15)
DECLARE @shrtname char(15)
DECLARE @dealer_type_id numeric(18,0)
DECLARE @end_user_type_id numeric(18,0)
DECLARE @rm CURSOR

SET @rm = CURSOR FAST_FORWARD
FOR
SELECT custnmbr, shrtname
  FROM ciinc.dbo.rm00101 
 WHERE userdef1='dealer' 
   AND custnmbr NOT LIKE 'old%'
   AND shrtname NOT LIKE 'CI, INC.%'
   
SET @dealer_type_id 
= (SELECT l.lookup_id 
     FROM lookups l INNER JOIN lookup_types lt ON l.lookup_type_id=lt.lookup_type_id
    WHERE lt.code='customer_type' AND l.code='dealer')
 
SET @end_user_type_id 
= (SELECT l.lookup_id 
     FROM lookups l INNER JOIN lookup_types lt ON l.lookup_type_id=lt.lookup_type_id
    WHERE lt.code='customer_type' AND l.code='end_user')

OPEN @rm
FETCH NEXT FROM @rm INTO @custnmbr,@shrtname

WHILE @@FETCH_STATUS=0
BEGIN
  UPDATE customers 
     SET end_user_parent_id=(SELECT customer_id 
                               FROM customers 
                              WHERE ISNULL(ext_customer_id,'') = @custnmbr
                                AND customer_type_id = @dealer_type_id
                                AND organization_id=(SELECT organization_id FROM organizations WHERE db_prefix LIKE 'ciinc.dbo%'))
   WHERE customer_type_id = @end_user_type_id
     AND ext_dealer_id = @custnmbr
     AND organization_id=(SELECT organization_id FROM organizations WHERE db_prefix LIKE 'ciinc.dbo%') 
     
  FETCH NEXT FROM @rm INTO @custnmbr, @shrtname
END

CLOSE @rm
DEALLOCATE @rm

END
GO

CREATE PROCEDURE sp_ciinc_dealer_contact
AS
BEGIN

DECLARE @contact_id numeric(18,0)
DECLARE @customer_id numeric(18,0)
DECLARE @dealer_contacts CURSOR

SET @dealer_contacts = CURSOR FAST_FORWARD
FOR
SELECT c.contact_id,cust.customer_id
  FROM customers cust INNER JOIN 
       contacts c ON ISNULL(cust.ext_customer_id,'')=c.ext_dealer_id INNER JOIN
       lookups l ON c.cont_status_type_id=l.lookup_id INNER JOIN 
       lookup_types lt ON l.lookup_type_id=lt.lookup_type_id INNER JOIN
       lookups l2 ON cust.customer_type_id=l2.lookup_id INNER JOIN
       lookup_types lt2 ON l2.lookup_type_id=lt2.lookup_type_id  INNER JOIN
       contact_groups cg ON c.contact_id = cg.contact_id INNER JOIN
       lookups l3 ON cg.contact_type_id = l3.lookup_id INNER JOIN
       lookup_types lt3 ON l3.lookup_type_id=lt3.lookup_type_id
 WHERE c.customer_id IS NULL 
   AND c.ext_dealer_id IN (SELECT custnmbr FROM ciinc.dbo.rm00101 WHERE shrtname NOT LIKE 'CI, INC.%' AND userdef1='DEALER')
   AND cust.organization_id=(SELECT organization_id FROM organizations WHERE db_prefix LIKE 'ciinc.dbo%')
   AND lt.code='contact_status_type'
   AND l.code='active'
   AND lt2.code='customer_type'
   AND l2.code='dealer'
   AND lt3.code='contact_type'
   AND l3.code IN ('sales','designer','support','project_mgr')


OPEN @dealer_contacts
FETCH NEXT FROM @dealer_contacts INTO @contact_id,@customer_id 

WHILE @@FETCH_STATUS=0
BEGIN
  
  UPDATE contacts 
     SET customer_id = @customer_id,
         notes = 'dealer contact',
         date_modified = getdate(),
         modified_by = 0
   WHERE contact_id = @contact_id
     
  FETCH NEXT FROM @dealer_contacts INTO @contact_id,@customer_id 
END

CLOSE @dealer_contacts
DEALLOCATE @dealer_contacts

END
GO

CREATE PROCEDURE sp_ciinc_new_end_user
AS
BEGIN

DECLARE @customer_id numeric(18,0)
DECLARE @customer_name varchar(65)
DECLARE @organization_id numeric(18,0)
DECLARE @ext_dealer_id char(15)
DECLARE @end_user_type_id numeric(18,0)
DECLARE @end_user CURSOR

SET @end_user = CURSOR FAST_FORWARD
FOR
SELECT c.customer_id,c.customer_name,organization_id,ext_dealer_id
  FROM customers c INNER JOIN 
       lookups l ON c.customer_type_id=l.lookup_id INNER JOIN
       lookup_types lt ON l.lookup_type_id=lt.lookup_type_id 
 WHERE lt.code='customer_type'
   AND l.code IN ('commercial', 'corporate','government')
   AND ISNULL(c.ext_customer_id,'') NOT LIKE 'old%'
   AND c.ext_dealer_id = (SELECT custnmbr FROM ciinc.dbo.rm00101 WHERE RTRIM(shrtname) LIKE 'CI, INC.%' AND userdef1='DEALER')
   AND ISNULL(c.ext_customer_id,'') NOT IN (SELECT custnmbr FROM ciinc.dbo.rm00101 WHERE shrtname NOT LIKE 'CI, INC.%' AND userdef1='DEALER')
   AND c.customer_id NOT IN (SELECT ISNULL(end_user_parent_id,0) FROM customers)
   AND c.organization_id=(SELECT organization_id FROM organizations WHERE db_prefix LIKE 'ciinc.dbo%')

 
SET @end_user_type_id 
= (SELECT l.lookup_id 
     FROM lookups l INNER JOIN lookup_types lt ON l.lookup_type_id=lt.lookup_type_id
    WHERE lt.code='customer_type' AND l.code='end_user')

OPEN @end_user
FETCH NEXT FROM @end_user INTO @customer_id,@customer_name,@organization_id,@ext_dealer_id 

WHILE @@FETCH_STATUS=0
BEGIN
  PRINT @customer_name
  
  INSERT INTO customers (organization_id, 
                         ext_dealer_id, 
                         dealer_name, 
                         customer_name,
                         active_flag,
                         date_created,
                         created_by, 
                         view_schedule_flag, 
                         customer_type_id,
                         end_user_parent_id)
  VALUES (@organization_id, 
          @ext_dealer_id,
          'CI, INC.',
          @customer_name,
          'Y',
          getdate(),
          1,
          'N',
          @end_user_type_id,
          @customer_id)
          
  INSERT INTO job_locations (customer_id,
                             job_location_name,
                             location_type_id,
                             ext_address_id,
                             street1,
                             street2,
                             street3,
                             city,
                             state,
                             zip,
                             country,
                             directions,
                             job_loc_contact_id,
                             bldg_mgmt_contact_id,
                             loading_dock_type_id,
                             dock_available_time,
                             dock_reserv_req_type_id,
                             semi_access_type_id,
                             dock_height,
                             elevator_avail_type_id,
                             elevator_reserv_req_type_id,
                             floor_protection_type_id,
                             wall_protection_type_id,
                             doorway_prot_type_id,
                             stair_carry_type_id,
                             stair_carry_flights,
                             stair_carry_stairs,
                             smallest_door_elev_width,
                             multi_level_type_id,
                             security_type_id,
                             date_created,
                             created_by)
                             
  SELECT eu.customer_id,
         jl.job_location_name,
         jl.location_type_id,
         jl.ext_address_id,
         jl.street1,
         jl.street2,
         jl.street3,
         jl.city,
         jl.state,
         jl.zip,
         jl.country,
         jl.directions,
         jl.job_loc_contact_id,
         jl.bldg_mgmt_contact_id,
         jl.loading_dock_type_id,
         jl.dock_available_time,
         jl.dock_reserv_req_type_id,
         jl.semi_access_type_id,
         jl.dock_height,
         jl.elevator_avail_type_id,
         jl.elevator_reserv_req_type_id,
         jl.floor_protection_type_id,
         jl.wall_protection_type_id,
         jl.doorway_prot_type_id,
         jl.stair_carry_type_id,
         jl.stair_carry_flights,
         jl.stair_carry_stairs,
         jl.smallest_door_elev_width,
         jl.multi_level_type_id,
         jl.security_type_id,
         getDate(),
         1
    FROM customers eu,
         job_locations jl
   WHERE jl.customer_id = @customer_id
     AND eu.end_user_parent_id = @customer_id
     
  FETCH NEXT FROM @end_user INTO @customer_id,@customer_name,@organization_id,@ext_dealer_id
END

CLOSE @end_user
DEALLOCATE @end_user

END
GO

CREATE PROCEDURE sp_cillc_customer
AS
BEGIN

DECLARE @custnmbr char(15)
DECLARE @shrtname char(15)
DECLARE @dealer_type_id numeric(18,0)
DECLARE @end_user_type_id numeric(18,0)
DECLARE @rm CURSOR

SET @rm = CURSOR FAST_FORWARD
FOR
SELECT custnmbr, shrtname
  FROM cillc.dbo.rm00101 
 WHERE userdef1='dealer' 
   AND custnmbr NOT LIKE 'old%'
   AND shrtname NOT LIKE 'CI, ILL%'
   
SET @dealer_type_id 
= (SELECT l.lookup_id 
     FROM lookups l INNER JOIN lookup_types lt ON l.lookup_type_id=lt.lookup_type_id
    WHERE lt.code='customer_type' AND l.code='dealer')
 
SET @end_user_type_id 
= (SELECT l.lookup_id 
     FROM lookups l INNER JOIN lookup_types lt ON l.lookup_type_id=lt.lookup_type_id
    WHERE lt.code='customer_type' AND l.code='end_user')

OPEN @rm
FETCH NEXT FROM @rm INTO @custnmbr,@shrtname

WHILE @@FETCH_STATUS=0
BEGIN
  UPDATE customers 
     SET end_user_parent_id=(SELECT customer_id 
                               FROM customers 
                              WHERE ISNULL(ext_customer_id,'') = @custnmbr
                                AND customer_type_id = @dealer_type_id
                                AND organization_id=(SELECT organization_id FROM organizations WHERE db_prefix LIKE 'cillc.dbo%'))
   WHERE customer_type_id = @end_user_type_id
     AND ext_dealer_id = @custnmbr
     AND organization_id=(SELECT organization_id FROM organizations WHERE db_prefix LIKE 'cillc.dbo%') 
     
  FETCH NEXT FROM @rm INTO @custnmbr, @shrtname
END

CLOSE @rm
DEALLOCATE @rm

END
GO

CREATE PROCEDURE sp_cillc_dealer_contact
AS
BEGIN

DECLARE @contact_id numeric(18,0)
DECLARE @customer_id numeric(18,0)
DECLARE @dealer_contacts CURSOR

SET @dealer_contacts = CURSOR FAST_FORWARD
FOR
SELECT c.contact_id,cust.customer_id
  FROM customers cust INNER JOIN 
       contacts c ON ISNULL(cust.ext_customer_id,'')=c.ext_dealer_id INNER JOIN
       lookups l ON c.cont_status_type_id=l.lookup_id INNER JOIN 
       lookup_types lt ON l.lookup_type_id=lt.lookup_type_id INNER JOIN
       lookups l2 ON cust.customer_type_id=l2.lookup_id INNER JOIN
       lookup_types lt2 ON l2.lookup_type_id=lt2.lookup_type_id  INNER JOIN
       contact_groups cg ON c.contact_id = cg.contact_id INNER JOIN
       lookups l3 ON cg.contact_type_id = l3.lookup_id INNER JOIN
       lookup_types lt3 ON l3.lookup_type_id=lt3.lookup_type_id
 WHERE c.customer_id IS NULL 
   AND c.ext_dealer_id IN (SELECT custnmbr FROM cillc.dbo.rm00101 WHERE shrtname NOT LIKE 'CI, ILL%' AND userdef1='DEALER')
   AND cust.organization_id=(SELECT organization_id FROM organizations WHERE db_prefix='cillc.dbo.')
   AND lt.code='contact_status_type'
   AND l.code='active'
   AND lt2.code='customer_type'
   AND l2.code='dealer'
   AND lt3.code='contact_type'
   AND l3.code IN ('sales','designer','support','project_mgr')


OPEN @dealer_contacts
FETCH NEXT FROM @dealer_contacts INTO @contact_id,@customer_id 

WHILE @@FETCH_STATUS=0
BEGIN
  
  UPDATE contacts 
     SET customer_id = @customer_id,
         notes = 'dealer contact',
         date_modified = getdate(),
         modified_by = 0
   WHERE contact_id = @contact_id
     
  FETCH NEXT FROM @dealer_contacts INTO @contact_id,@customer_id 
END

CLOSE @dealer_contacts
DEALLOCATE @dealer_contacts

END
GO

CREATE PROCEDURE sp_cillc_new_end_user
AS
BEGIN

DECLARE @customer_id numeric(18,0)
DECLARE @customer_name varchar(65)
DECLARE @organization_id numeric(18,0)
DECLARE @ext_dealer_id char(15)
DECLARE @end_user_type_id numeric(18,0)
DECLARE @end_user CURSOR

SET @end_user = CURSOR FAST_FORWARD
FOR
SELECT c.customer_id,c.customer_name,organization_id,ext_dealer_id
  FROM customers c INNER JOIN 
       lookups l ON c.customer_type_id=l.lookup_id INNER JOIN
       lookup_types lt ON l.lookup_type_id=lt.lookup_type_id 
 WHERE lt.code='customer_type'
   AND l.code IN ('commercial', 'corporate','government')
   AND ISNULL(c.ext_customer_id,'') NOT LIKE 'old%'
   AND c.ext_dealer_id = (SELECT custnmbr FROM cillc.dbo.rm00101 WHERE RTRIM(shrtname) LIKE 'CI, ILL%' AND userdef1='DEALER')
   AND ISNULL(c.ext_customer_id,'') NOT IN (SELECT custnmbr FROM cillc.dbo.rm00101 WHERE shrtname NOT LIKE 'CI, ILL%' AND userdef1='DEALER')
   AND c.customer_id NOT IN (SELECT ISNULL(end_user_parent_id,0) FROM customers)

 
SET @end_user_type_id 
= (SELECT l.lookup_id 
     FROM lookups l INNER JOIN lookup_types lt ON l.lookup_type_id=lt.lookup_type_id
    WHERE lt.code='customer_type' AND l.code='end_user')

OPEN @end_user
FETCH NEXT FROM @end_user INTO @customer_id,@customer_name,@organization_id,@ext_dealer_id 

WHILE @@FETCH_STATUS=0
BEGIN
  PRINT @customer_name
  
  INSERT INTO customers (organization_id, 
                         ext_dealer_id, 
                         dealer_name, 
                         customer_name,
                         active_flag,
                         date_created,
                         created_by, 
                         view_schedule_flag, 
                         customer_type_id,
                         end_user_parent_id)
  VALUES (@organization_id, 
          @ext_dealer_id,
          'CI, ILL',
          @customer_name,
          'Y',
          getdate(),
          1,
          'N',
          @end_user_type_id,
          @customer_id)
          
  INSERT INTO job_locations (customer_id,
                             job_location_name,
                             location_type_id,
                             ext_address_id,
                             street1,
                             street2,
                             street3,
                             city,
                             state,
                             zip,
                             country,
                             directions,
                             job_loc_contact_id,
                             bldg_mgmt_contact_id,
                             loading_dock_type_id,
                             dock_available_time,
                             dock_reserv_req_type_id,
                             semi_access_type_id,
                             dock_height,
                             elevator_avail_type_id,
                             elevator_reserv_req_type_id,
                             floor_protection_type_id,
                             wall_protection_type_id,
                             doorway_prot_type_id,
                             stair_carry_type_id,
                             stair_carry_flights,
                             stair_carry_stairs,
                             smallest_door_elev_width,
                             multi_level_type_id,
                             security_type_id,
                             date_created,
                             created_by)
                             
  SELECT eu.customer_id,
         jl.job_location_name,
         jl.location_type_id,
         jl.ext_address_id,
         jl.street1,
         jl.street2,
         jl.street3,
         jl.city,
         jl.state,
         jl.zip,
         jl.country,
         jl.directions,
         jl.job_loc_contact_id,
         jl.bldg_mgmt_contact_id,
         jl.loading_dock_type_id,
         jl.dock_available_time,
         jl.dock_reserv_req_type_id,
         jl.semi_access_type_id,
         jl.dock_height,
         jl.elevator_avail_type_id,
         jl.elevator_reserv_req_type_id,
         jl.floor_protection_type_id,
         jl.wall_protection_type_id,
         jl.doorway_prot_type_id,
         jl.stair_carry_type_id,
         jl.stair_carry_flights,
         jl.stair_carry_stairs,
         jl.smallest_door_elev_width,
         jl.multi_level_type_id,
         jl.security_type_id,
         getDate(),
         1
    FROM customers eu,
         job_locations jl
   WHERE jl.customer_id = @customer_id
     AND eu.end_user_parent_id = @customer_id
     
  FETCH NEXT FROM @end_user INTO @customer_id,@customer_name,@organization_id,@ext_dealer_id
END

CLOSE @end_user
DEALLOCATE @end_user

END
GO

CREATE PROCEDURE sp_cimn_customer
AS
BEGIN

DECLARE @custnmbr char(15)
DECLARE @shrtname char(15)
DECLARE @dealer_type_id numeric(18,0)
DECLARE @end_user_type_id numeric(18,0)
DECLARE @rm CURSOR

SET @rm = CURSOR FAST_FORWARD
FOR
SELECT custnmbr, shrtname
  FROM cimn.dbo.rm00101 
 WHERE userdef1='dealer' 
   AND custnmbr NOT LIKE 'old%'
   AND shrtname NOT LIKE 'CORPORATE INSTA%'
   
SET @dealer_type_id 
= (SELECT l.lookup_id 
     FROM lookups l INNER JOIN lookup_types lt ON l.lookup_type_id=lt.lookup_type_id
    WHERE lt.code='customer_type' AND l.code='dealer')
 
SET @end_user_type_id 
= (SELECT l.lookup_id 
     FROM lookups l INNER JOIN lookup_types lt ON l.lookup_type_id=lt.lookup_type_id
    WHERE lt.code='customer_type' AND l.code='end_user')

OPEN @rm
FETCH NEXT FROM @rm INTO @custnmbr,@shrtname

WHILE @@FETCH_STATUS=0
BEGIN
  UPDATE customers 
     SET end_user_parent_id=(SELECT customer_id 
                               FROM customers 
                              WHERE ISNULL(ext_customer_id,'') = @custnmbr
                                AND customer_type_id = @dealer_type_id
                                AND organization_id=(SELECT organization_id FROM organizations WHERE db_prefix LIKE 'cimn.dbo%'))
   WHERE customer_type_id = @end_user_type_id
     AND ext_dealer_id = @custnmbr
     AND organization_id=(SELECT organization_id FROM organizations WHERE db_prefix LIKE 'cimn.dbo%') 
     
  FETCH NEXT FROM @rm INTO @custnmbr, @shrtname
END

CLOSE @rm
DEALLOCATE @rm

END
GO

CREATE PROCEDURE sp_cimn_dealer_contact
AS
BEGIN

DECLARE @contact_id numeric(18,0)
DECLARE @customer_id numeric(18,0)
DECLARE @dealer_contacts CURSOR

SET @dealer_contacts = CURSOR FAST_FORWARD
FOR
SELECT c.contact_id,cust.customer_id
  FROM customers cust INNER JOIN 
       contacts c ON ISNULL(cust.ext_customer_id,'')=c.ext_dealer_id INNER JOIN
       lookups l ON c.cont_status_type_id=l.lookup_id INNER JOIN 
       lookup_types lt ON l.lookup_type_id=lt.lookup_type_id INNER JOIN
       lookups l2 ON cust.customer_type_id=l2.lookup_id INNER JOIN
       lookup_types lt2 ON l2.lookup_type_id=lt2.lookup_type_id  INNER JOIN
       contact_groups cg ON c.contact_id = cg.contact_id INNER JOIN
       lookups l3 ON cg.contact_type_id = l3.lookup_id INNER JOIN
       lookup_types lt3 ON l3.lookup_type_id=lt3.lookup_type_id
 WHERE c.customer_id IS NULL 
   AND c.ext_dealer_id IN (SELECT custnmbr FROM cimn.dbo.rm00101 WHERE shrtname NOT LIKE 'CORPORATE INSTA%' AND userdef1='DEALER')
   AND cust.organization_id=(SELECT organization_id FROM organizations WHERE db_prefix='cimn.dbo.')
   AND lt.code='contact_status_type'
   AND l.code='active'
   AND lt2.code='customer_type'
   AND l2.code='dealer'
   AND lt3.code='contact_type'
   AND l3.code IN ('sales','designer','support','project_mgr')


OPEN @dealer_contacts
FETCH NEXT FROM @dealer_contacts INTO @contact_id,@customer_id 

WHILE @@FETCH_STATUS=0
BEGIN
  
  UPDATE contacts 
     SET customer_id = @customer_id,
         notes = 'dealer contact',
         date_modified = getdate(),
         modified_by = 0
   WHERE contact_id = @contact_id
     
  FETCH NEXT FROM @dealer_contacts INTO @contact_id,@customer_id 
END

CLOSE @dealer_contacts
DEALLOCATE @dealer_contacts

END
GO

CREATE PROCEDURE sp_cimn_new_end_user
AS
BEGIN

DECLARE @customer_id numeric(18,0)
DECLARE @customer_name varchar(65)
DECLARE @organization_id numeric(18,0)
DECLARE @ext_dealer_id char(15)
DECLARE @end_user_type_id numeric(18,0)
DECLARE @end_user CURSOR

SET @end_user = CURSOR FAST_FORWARD
FOR
SELECT c.customer_id,c.customer_name,organization_id,ext_dealer_id
  FROM customers c INNER JOIN 
       lookups l ON c.customer_type_id=l.lookup_id INNER JOIN
       lookup_types lt ON l.lookup_type_id=lt.lookup_type_id 
 WHERE lt.code='customer_type'
   AND l.code IN ('commercial', 'corporate','government')
   AND ISNULL(c.ext_customer_id,'') NOT LIKE 'old%'
   AND c.ext_dealer_id = (SELECT custnmbr FROM cimn.dbo.rm00101 WHERE RTRIM(shrtname) LIKE 'CORPORATE INSTA%' AND userdef1='DEALER')
   AND ISNULL(c.ext_customer_id,'') NOT IN (SELECT custnmbr FROM cimn.dbo.rm00101 WHERE shrtname NOT LIKE 'CORPORATE INSTA%' AND userdef1='DEALER')
   AND c.customer_id NOT IN (SELECT ISNULL(end_user_parent_id,0) FROM customers)

 
SET @end_user_type_id 
= (SELECT l.lookup_id 
     FROM lookups l INNER JOIN lookup_types lt ON l.lookup_type_id=lt.lookup_type_id
    WHERE lt.code='customer_type' AND l.code='end_user')

OPEN @end_user
FETCH NEXT FROM @end_user INTO @customer_id,@customer_name,@organization_id,@ext_dealer_id 

WHILE @@FETCH_STATUS=0
BEGIN
  PRINT @customer_name
  
  INSERT INTO customers (organization_id, 
                         ext_dealer_id, 
                         dealer_name, 
                         customer_name,
                         active_flag,
                         date_created,
                         created_by, 
                         view_schedule_flag, 
                         customer_type_id,
                         end_user_parent_id)
  VALUES (@organization_id, 
          @ext_dealer_id,
          'CORPORATE INSTA',
          @customer_name,
          'Y',
          getdate(),
          1,
          'N',
          @end_user_type_id,
          @customer_id)
          
  INSERT INTO job_locations (customer_id,
                             job_location_name,
                             location_type_id,
                             ext_address_id,
                             street1,
                             street2,
                             street3,
                             city,
                             state,
                             zip,
                             country,
                             directions,
                             job_loc_contact_id,
                             bldg_mgmt_contact_id,
                             loading_dock_type_id,
                             dock_available_time,
                             dock_reserv_req_type_id,
                             semi_access_type_id,
                             dock_height,
                             elevator_avail_type_id,
                             elevator_reserv_req_type_id,
                             floor_protection_type_id,
                             wall_protection_type_id,
                             doorway_prot_type_id,
                             stair_carry_type_id,
                             stair_carry_flights,
                             stair_carry_stairs,
                             smallest_door_elev_width,
                             multi_level_type_id,
                             security_type_id,
                             date_created,
                             created_by)
                             
  SELECT eu.customer_id,
         jl.job_location_name,
         jl.location_type_id,
         jl.ext_address_id,
         jl.street1,
         jl.street2,
         jl.street3,
         jl.city,
         jl.state,
         jl.zip,
         jl.country,
         jl.directions,
         jl.job_loc_contact_id,
         jl.bldg_mgmt_contact_id,
         jl.loading_dock_type_id,
         jl.dock_available_time,
         jl.dock_reserv_req_type_id,
         jl.semi_access_type_id,
         jl.dock_height,
         jl.elevator_avail_type_id,
         jl.elevator_reserv_req_type_id,
         jl.floor_protection_type_id,
         jl.wall_protection_type_id,
         jl.doorway_prot_type_id,
         jl.stair_carry_type_id,
         jl.stair_carry_flights,
         jl.stair_carry_stairs,
         jl.smallest_door_elev_width,
         jl.multi_level_type_id,
         jl.security_type_id,
         getDate(),
         1
    FROM customers eu,
         job_locations jl
   WHERE jl.customer_id = @customer_id
     AND eu.end_user_parent_id = @customer_id
     
  FETCH NEXT FROM @end_user INTO @customer_id,@customer_name,@organization_id,@ext_dealer_id
END

CLOSE @end_user
DEALLOCATE @end_user

END
GO



CREATE PROCEDURE sp_ntlsv_customer
AS
BEGIN

DECLARE @custnmbr char(15)
DECLARE @shrtname char(15)
DECLARE @dealer_type_id numeric(18,0)
DECLARE @end_user_type_id numeric(18,0)
DECLARE @rm CURSOR

SET @rm = CURSOR FAST_FORWARD
FOR
SELECT custnmbr, shrtname
  FROM ntlsv.dbo.rm00101 
 WHERE userdef1='dealer' 
   AND custnmbr NOT LIKE 'old%'
   AND shrtname NOT LIKE 'NATIONAL SERVIC%'
   
SET @dealer_type_id 
= (SELECT l.lookup_id 
     FROM lookups l INNER JOIN lookup_types lt ON l.lookup_type_id=lt.lookup_type_id
    WHERE lt.code='customer_type' AND l.code='dealer')
 
SET @end_user_type_id 
= (SELECT l.lookup_id 
     FROM lookups l INNER JOIN lookup_types lt ON l.lookup_type_id=lt.lookup_type_id
    WHERE lt.code='customer_type' AND l.code='end_user')

OPEN @rm
FETCH NEXT FROM @rm INTO @custnmbr,@shrtname

WHILE @@FETCH_STATUS=0
BEGIN
  UPDATE customers 
     SET end_user_parent_id=(SELECT customer_id 
                               FROM customers 
                              WHERE ISNULL(ext_customer_id,'') = @custnmbr
                                AND customer_type_id = @dealer_type_id
                                AND organization_id=(SELECT organization_id FROM organizations WHERE db_prefix LIKE 'ntlsv.dbo%'))
   WHERE customer_type_id = @end_user_type_id
     AND ext_dealer_id = @custnmbr
     AND organization_id=(SELECT organization_id FROM organizations WHERE db_prefix LIKE 'ntlsv.dbo%') 
     
  FETCH NEXT FROM @rm INTO @custnmbr, @shrtname
END

CLOSE @rm
DEALLOCATE @rm

END
GO

CREATE PROCEDURE sp_ntlsv_dealer_contact
AS
BEGIN

DECLARE @contact_id numeric(18,0)
DECLARE @customer_id numeric(18,0)
DECLARE @dealer_contacts CURSOR

SET @dealer_contacts = CURSOR FAST_FORWARD
FOR
SELECT c.contact_id,cust.customer_id
  FROM customers cust INNER JOIN 
       contacts c ON ISNULL(cust.ext_customer_id,'')=c.ext_dealer_id INNER JOIN
       lookups l ON c.cont_status_type_id=l.lookup_id INNER JOIN 
       lookup_types lt ON l.lookup_type_id=lt.lookup_type_id INNER JOIN
       lookups l2 ON cust.customer_type_id=l2.lookup_id INNER JOIN
       lookup_types lt2 ON l2.lookup_type_id=lt2.lookup_type_id  INNER JOIN
       contact_groups cg ON c.contact_id = cg.contact_id INNER JOIN
       lookups l3 ON cg.contact_type_id = l3.lookup_id INNER JOIN
       lookup_types lt3 ON l3.lookup_type_id=lt3.lookup_type_id
 WHERE c.customer_id IS NULL 
   AND c.ext_dealer_id IN (SELECT custnmbr FROM ntlsv.dbo.rm00101 WHERE shrtname NOT LIKE 'NATIONAL SERVIC%' AND userdef1='DEALER')
   AND cust.organization_id=(SELECT organization_id FROM organizations WHERE db_prefix='ntlsv.dbo.')
   AND lt.code='contact_status_type'
   AND l.code='active'
   AND lt2.code='customer_type'
   AND l2.code='dealer'
   AND lt3.code='contact_type'
   AND l3.code IN ('sales','designer','support','project_mgr')


OPEN @dealer_contacts
FETCH NEXT FROM @dealer_contacts INTO @contact_id,@customer_id 

WHILE @@FETCH_STATUS=0
BEGIN
  
  UPDATE contacts 
     SET customer_id = @customer_id,
         notes = 'dealer contact',
         date_modified = getdate(),
         modified_by = 0
   WHERE contact_id = @contact_id
     
  FETCH NEXT FROM @dealer_contacts INTO @contact_id,@customer_id 
END

CLOSE @dealer_contacts
DEALLOCATE @dealer_contacts

END
GO

CREATE PROCEDURE sp_ntlsv_new_end_user
AS
BEGIN

DECLARE @customer_id numeric(18,0)
DECLARE @customer_name varchar(65)
DECLARE @organization_id numeric(18,0)
DECLARE @ext_dealer_id char(15)
DECLARE @end_user_type_id numeric(18,0)
DECLARE @end_user CURSOR

SET @end_user = CURSOR FAST_FORWARD
FOR
SELECT c.customer_id,c.customer_name,organization_id,ext_dealer_id
  FROM customers c INNER JOIN 
       lookups l ON c.customer_type_id=l.lookup_id INNER JOIN
       lookup_types lt ON l.lookup_type_id=lt.lookup_type_id 
 WHERE lt.code='customer_type'
   AND l.code IN ('commercial', 'corporate','government')
   AND ISNULL(c.ext_customer_id,'') NOT LIKE 'old%'
   AND c.ext_dealer_id = (SELECT custnmbr FROM ntlsv.dbo.rm00101 WHERE RTRIM(shrtname) LIKE 'NATIONAL SERVIC%' AND userdef1='DEALER')
   AND ISNULL(c.ext_customer_id,'') NOT IN (SELECT custnmbr FROM ntlsv.dbo.rm00101 WHERE shrtname NOT LIKE 'NATIONAL SERVIC%' AND userdef1='DEALER')
   AND c.customer_id NOT IN (SELECT ISNULL(end_user_parent_id,0) FROM customers)

 
SET @end_user_type_id 
= (SELECT l.lookup_id 
     FROM lookups l INNER JOIN lookup_types lt ON l.lookup_type_id=lt.lookup_type_id
    WHERE lt.code='customer_type' AND l.code='end_user')

OPEN @end_user
FETCH NEXT FROM @end_user INTO @customer_id,@customer_name,@organization_id,@ext_dealer_id 

WHILE @@FETCH_STATUS=0
BEGIN
  PRINT @customer_name
  
  INSERT INTO customers (organization_id, 
                         ext_dealer_id, 
                         dealer_name, 
                         customer_name,
                         active_flag,
                         date_created,
                         created_by, 
                         view_schedule_flag, 
                         customer_type_id,
                         end_user_parent_id)
  VALUES (@organization_id, 
          @ext_dealer_id,
          'NATIONAL SERVICES - OMNI',
          @customer_name,
          'Y',
          getdate(),
          1,
          'N',
          @end_user_type_id,
          @customer_id)
          
  INSERT INTO job_locations (customer_id,
                             job_location_name,
                             location_type_id,
                             ext_address_id,
                             street1,
                             street2,
                             street3,
                             city,
                             state,
                             zip,
                             country,
                             directions,
                             job_loc_contact_id,
                             bldg_mgmt_contact_id,
                             loading_dock_type_id,
                             dock_available_time,
                             dock_reserv_req_type_id,
                             semi_access_type_id,
                             dock_height,
                             elevator_avail_type_id,
                             elevator_reserv_req_type_id,
                             floor_protection_type_id,
                             wall_protection_type_id,
                             doorway_prot_type_id,
                             stair_carry_type_id,
                             stair_carry_flights,
                             stair_carry_stairs,
                             smallest_door_elev_width,
                             multi_level_type_id,
                             security_type_id,
                             date_created,
                             created_by)
                             
  SELECT eu.customer_id,
         jl.job_location_name,
         jl.location_type_id,
         jl.ext_address_id,
         jl.street1,
         jl.street2,
         jl.street3,
         jl.city,
         jl.state,
         jl.zip,
         jl.country,
         jl.directions,
         jl.job_loc_contact_id,
         jl.bldg_mgmt_contact_id,
         jl.loading_dock_type_id,
         jl.dock_available_time,
         jl.dock_reserv_req_type_id,
         jl.semi_access_type_id,
         jl.dock_height,
         jl.elevator_avail_type_id,
         jl.elevator_reserv_req_type_id,
         jl.floor_protection_type_id,
         jl.wall_protection_type_id,
         jl.doorway_prot_type_id,
         jl.stair_carry_type_id,
         jl.stair_carry_flights,
         jl.stair_carry_stairs,
         jl.smallest_door_elev_width,
         jl.multi_level_type_id,
         jl.security_type_id,
         getDate(),
         1
    FROM customers eu,
         job_locations jl
   WHERE jl.customer_id = @customer_id
     AND eu.end_user_parent_id = @customer_id
     
  FETCH NEXT FROM @end_user INTO @customer_id,@customer_name,@organization_id,@ext_dealer_id
END

CLOSE @end_user
DEALLOCATE @end_user

END
GO






