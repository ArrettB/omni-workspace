CREATE PROCEDURE sp_ics_customer
AS
BEGIN

DECLARE @custnmbr char(15)
DECLARE @shrtname char(15)
DECLARE @dealer_type_id numeric(18,0)
DECLARE @end_user_type_id numeric(18,0)
DECLARE @c1 CURSOR

SET @c1 = CURSOR FAST_FORWARD
FOR
SELECT custnmbr, shrtname
  FROM ics.dbo.rm00101 
 WHERE userdef1='dealer' 
   AND custnmbr NOT LIKE 'old%'
   AND custname <> 'INTERIOR CONSTRUCTION SERVICES'
   
SET @dealer_type_id 
= (SELECT l.lookup_id 
     FROM lookups l INNER JOIN lookup_types lt ON l.lookup_type_id=lt.lookup_type_id
    WHERE lt.code='customer_type' AND l.code='dealer')
 
SET @end_user_type_id 
= (SELECT l.lookup_id 
     FROM lookups l INNER JOIN lookup_types lt ON l.lookup_type_id=lt.lookup_type_id
    WHERE lt.code='customer_type' AND l.code='end_user')

OPEN @c1
FETCH NEXT FROM @c1 INTO @custnmbr,@shrtname

WHILE @@FETCH_STATUS=0
BEGIN
  UPDATE customers 
     SET end_user_parent_id=(SELECT customer_id 
                               FROM customers 
                              WHERE ISNULL(ext_customer_id,'') = @custnmbr
                                AND customer_type_id = @dealer_type_id
                                AND organization_id=(SELECT organization_id FROM organizations WHERE db_prefix LIKE 'ics.dbo%')
                                AND active_flag='Y'
                                AND ext_dealer_id NOT LIKE 'old%')
   WHERE customer_type_id = @end_user_type_id
     AND ext_dealer_id = @custnmbr
     AND organization_id=(SELECT organization_id FROM organizations WHERE db_prefix LIKE 'ics.dbo%') 
     
  FETCH NEXT FROM @c1 INTO @custnmbr, @shrtname
END

CLOSE @c1
DEALLOCATE @c1

END
GO

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
GO

CREATE PROCEDURE sp_ics_dealer_contact
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
   AND c.ext_dealer_id IN (SELECT custnmbr FROM ics.dbo.rm00101 WHERE custname <> 'INTERIOR CONSTRUCTION SERVICES' AND userdef1='DEALER')
   AND cust.organization_id=(SELECT organization_id FROM organizations WHERE db_prefix LIKE 'ics.dbo%')
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

INSERT INTO customers (organization_id, ext_dealer_id, dealer_name, ext_customer_id,customer_name,active_flag,date_created,created_by, view_schedule_flag, customer_type_id)
SELECT o.organization_id, 
       (SELECT custnmbr FROM ics.dbo.rm00101 WHERE RTRIM(custname) = 'INTERIOR CONSTRUCTION SERVICES' AND userdef1='DEALER'),
       (SELECT custname FROM ics.dbo.rm00101 WHERE RTRIM(custname) = 'INTERIOR CONSTRUCTION SERVICES' AND userdef1='DEALER'),
       custnmbr,shrtname,
       'Y',
       getdate(),
       1,
       'N',
       l.lookup_id
  FROM ics.dbo.rm00101 rm,
       organizations o,
       lookups l INNER JOIN lookup_types lt ON l.lookup_type_id=lt.lookup_type_id
 WHERE rm.custname<>'INTERIOR CONSTRUCTION SERVICES' 
   AND rm.userdef1='DEALER'
   AND o.db_prefix LIKE 'ics.dbo%'
   AND lt.code='customer_type' 
   AND l.code='dealer'
   AND rm.custnmbr NOT LIKE 'OLD%'
   AND rm.custnmbr NOT IN (SELECT ISNULL(ext_customer_id,'') FROM customers WHERE organization_id = o.organization_id and active_flag='y' and ext_dealer_id not like 'old%')
GO

UPDATE customers 
   SET customer_type_id=(SELECT l.lookup_id 
                           FROM lookups l INNER JOIN lookup_types lt ON l.lookup_type_id=lt.lookup_type_id
                          WHERE lt.code='customer_type' AND l.code='dealer'),
       modified_by=1,
       date_modified = getdate()
 WHERE ext_dealer_id = (SELECT custnmbr FROM ics.dbo.rm00101 WHERE RTRIM(custname) = 'INTERIOR CONSTRUCTION SERVICES' AND userdef1='DEALER') 
   AND ISNULL(ext_customer_id,'') IN (SELECT custnmbr FROM ics.dbo.rm00101 WHERE custname <> 'INTERIOR CONSTRUCTION SERVICES' AND userdef1='DEALER')
   AND organization_id=(SELECT organization_id FROM organizations WHERE db_prefix LIKE 'ics.dbo%')
   AND customer_type_id IS NULL
   AND active_flag='Y'
GO


UPDATE customers 
   SET customer_type_id=(SELECT l.lookup_id 
                           FROM lookups l INNER JOIN lookup_types lt ON l.lookup_type_id=lt.lookup_type_id
                          WHERE lt.code='customer_type' AND l.code='commercial'),
       modified_by=1,
       date_modified = getdate()
 WHERE ext_dealer_id = (SELECT custnmbr FROM ics.dbo.rm00101 WHERE RTRIM(custname) = 'INTERIOR CONSTRUCTION SERVICES' AND userdef1='DEALER')
   AND ISNULL(ext_customer_id,'') NOT IN (SELECT custnmbr FROM ics.dbo.rm00101 WHERE custname <> 'INTERIOR CONSTRUCTION SERVICES' AND userdef1='DEALER')
   AND organization_id=(SELECT organization_id FROM organizations WHERE db_prefix LIKE 'ics.dbo%')
GO

UPDATE customers
   SET customer_type_id=(SELECT l.lookup_id 
                           FROM lookups l INNER JOIN lookup_types lt ON l.lookup_type_id=lt.lookup_type_id
                          WHERE lt.code='customer_type' AND l.code='end_user'),
       modified_by=1,
       date_modified = getdate()
 WHERE ext_dealer_id != (SELECT custnmbr FROM ics.dbo.rm00101 WHERE RTRIM(custname) = 'INTERIOR CONSTRUCTION SERVICES' AND userdef1='DEALER')
   AND ISNULL(ext_customer_id,'') NOT IN (SELECT custnmbr FROM ics.dbo.rm00101 WHERE custname <> 'INTERIOR CONSTRUCTION SERVICES' AND userdef1='DEALER')
   AND organization_id=(SELECT organization_id FROM organizations WHERE db_prefix LIKE 'ics.dbo%')
GO
   
   
EXECUTE sp_ics_customer
GO

INSERT INTO job_location_contacts (job_location_id,
                                   contact_id,
                                   created_by,
                                   date_created)
SELECT jl.job_location_id, c.contact_id,1, getDate()
  FROM contacts c INNER JOIN 
       lookups l ON c.cont_status_type_id=l.lookup_id INNER JOIN
       job_locations jl ON c.customer_id = jl.customer_id
 WHERE c.customer_id IN (SELECT customer_id 
                          FROM customers c1 INNER JOIN
                               lookups l1 ON c1.customer_type_id=l1.lookup_id 
                         WHERE l1.code='end_user'
                           AND c1.end_user_parent_id IN (SELECT c.customer_id 
                                                           FROM customers c INNER JOIN 
                                                                lookups l ON c.customer_type_id = l.lookup_id INNER JOIN 
                                                                lookup_types lt ON l.lookup_type_id = lt. lookup_type_id
                                                          WHERE lt.code = 'customer_type'
                                                            AND l.code='dealer')
                           AND c1.organization_id=(SELECT organization_id FROM organizations WHERE db_prefix LIKE 'ics.dbo%'))
  AND l.code='active'
  AND jl.active_flag='Y'
GO

EXECUTE sp_ics_dealer_contact
GO
   
EXECUTE sp_ics_new_end_user
GO

INSERT INTO job_location_contacts (job_location_id,
                                   contact_id,
                                   created_by,
                                   date_created)
  SELECT jl.job_location_id, c.contact_id, 1, getdate()
    FROM job_locations jl JOIN 
         customers eu ON jl.customer_id=eu.customer_id JOIN
         contacts c ON eu.end_user_parent_id=c.customer_id JOIN
         contact_groups cg ON c.contact_id = cg.contact_id JOIN
         lookups l ON c.cont_status_type_id=l.lookup_id JOIN
         lookups l2 ON eu.customer_type_id=l2.lookup_id JOIN        
         lookups l3 ON cg.contact_type_id=l3.lookup_id
   WHERE l.code='active'
     AND l2.code='end_user'
     AND l3.code='customer'
     AND eu.ext_dealer_id = (SELECT custnmbr FROM ics.dbo.rm00101 WHERE RTRIM(custname) = 'INTERIOR CONSTRUCTION SERVICES' AND userdef1='DEALER')
     AND eu.end_user_parent_id IN (SELECT c.customer_id
                                     FROM customers c INNER JOIN 
                                          lookups l ON c.customer_type_id=l.lookup_id
                                    WHERE l.code IN ('commercial','corporate','government')
                                      AND c.ext_dealer_id = (SELECT custnmbr FROM ics.dbo.rm00101 WHERE RTRIM(custname) = 'INTERIOR CONSTRUCTION SERVICES' AND userdef1='DEALER')
                                      AND ISNULL(c.ext_customer_id,'') NOT IN (SELECT custnmbr FROM ics.dbo.rm00101 WHERE custname <> 'INTERIOR CONSTRUCTION SERVICES' AND userdef1='DEALER')
                                      AND c.organization_id=(SELECT organization_id FROM organizations WHERE db_prefix LIKE 'ics.dbo%')
                                      AND ISNULL(c.ext_customer_id,'') NOT LIKE 'old%'
                                      AND c.active_flag='Y')
GO

DROP PROCEDURE sp_ics_customer
GO

DROP PROCEDURE sp_ics_dealer_contact
GO

DROP PROCEDURE sp_ics_new_end_user
GO