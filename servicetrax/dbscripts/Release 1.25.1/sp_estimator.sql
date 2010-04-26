DROP PROCEDURE sp_estimator
GO

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