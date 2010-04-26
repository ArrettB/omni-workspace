CREATE PROCEDURE sp_ics_new_end_user
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
   AND c.ext_dealer_id = (SELECT custnmbr FROM ics.dbo.rm00101 WHERE RTRIM(custname) = 'INTERIOR CONSTRUCTION SERVICES' AND userdef1='DEALER')
   AND ISNULL(c.ext_customer_id,'') NOT IN (SELECT custnmbr FROM ics.dbo.rm00101 WHERE custname <> 'INTERIOR CONSTRUCTION SERVICES' AND userdef1='DEALER')
   AND c.customer_id NOT IN (SELECT ISNULL(end_user_parent_id,0) FROM customers)
   AND c.organization_id=(SELECT organization_id FROM organizations WHERE db_prefix LIKE 'ics.dbo%')

 
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