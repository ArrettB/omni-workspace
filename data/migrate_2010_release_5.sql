/*
 * CR #13 update to the standard terms and conditions
 */
update dbo.STANDARD_CONDITIONS 
   set name = 'We will assist <?d:company_name?> in determining the delivery schedule and what furniture items will arrive on what day and time. Additional charges will result to receive trucks early, late, or out of sequence.',
       date_modified = current_timestamp
     where standard_condition_id = 8
       and name like 'Omni %'
GO
