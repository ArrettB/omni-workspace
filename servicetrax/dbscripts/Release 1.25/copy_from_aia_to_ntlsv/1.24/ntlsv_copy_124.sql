ALTER TABLE customers ADD customer_id_8 numeric(18,0)
GO

ALTER TABLE contacts ADD contact_id_8 numeric(18,0)
GO

/* create stopred procedures */

UPDATE ntlsv.dbo.rm00101 SET custnmbr='10371' WHERE custnmbr='10316'
GO

/* UPDATE ntlsv.dbo.rm00101 SET custnmbr='10677' WHERE custnmbr='10676' */

UPDATE customers SET ext_customer_id='10200' WHERE organization_id=8 AND customer_name LIKE 'the mail store%' and ext_customer_id IS NULL 
GO

UPDATE organizations SET ext_direct_dealer_id='10971' WHERE organization_id=16
GO

EXECUTE sp_ntlsv_customer_124
GO

EXECUTE sp_duplicate_customer_124
GO

EXECUTE sp_ntlsv_end_user_124
GO

EXECUTE sp_ntlsv_existing_customer_124
GO

/* job locations */
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
  SELECT c.customer_id,
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
         0
    FROM customers c,
         job_locations jl
   WHERE jl.customer_id = c.customer_id_8
     AND c.organization_id=16
     AND ISNULL(c.ext_customer_id,'') NOT IN ('10054','10088','10300','10309','10380')
GO
  
/* dealer contacts */  
INSERT INTO contacts (contact_name,
                      organization_id,
                      ext_dealer_id,
                      contact_type_id,
                      cont_status_type_id,
                      phone_work,
                      phone_cell,
                      phone_home,
                      email,
                      email_phone,
                      street1,
                      street2,
                      street3,
                      city,
                      state,
                      zip,
                      notes,
                      date_created,
                      created_by,
                      contact_id_8)
SELECT c.contact_name,
       16,
       c.ext_dealer_id,
       c.contact_type_id,
       c.cont_status_type_id,
       c.phone_work,
       c.phone_cell,
       c.phone_home,
       c.email,
       c.email_phone,
       c.street1,
       c.street2,
       c.street3,
       c.city,
       c.state,
       c.zip,
       c.notes,
       getdate(),
       -1,
       c.contact_id
  FROM contacts c INNER JOIN
       ntlsv.dbo.rm00101 ntl ON c.ext_dealer_id = ntl.custnmbr INNER JOIN
       lookups l ON c.cont_status_type_id = l.lookup_id
 WHERE ntl.custnmbr <> '10971'
   AND ntl.custnmbr NOT LIKE 'old%'
   AND ntl.userdef1 = 'dealer'
   AND c.organization_id=8
   AND c.customer_id IS NULL
   AND ntl.custnmbr NOT IN ('10054','10088','10300','10309','10380')
   AND l.code='active'
GO
   
/* other contacts */
INSERT INTO contacts (contact_name,
                      organization_id,
                      ext_dealer_id,
                      customer_id,
                      contact_type_id,
                      cont_status_type_id,
                      phone_work,
                      phone_cell,
                      phone_home,
                      email,
                      email_phone,
                      street1,
                      street2,
                      street3,
                      city,
                      state,
                      zip,
                      notes,
                      date_created,
                      created_by,
                      contact_id_8)
SELECT c.contact_name,
       cust.organization_id,
       cust.ext_dealer_id,
       cust.customer_id,
       c.contact_type_id,
       c.cont_status_type_id,
       c.phone_work,
       c.phone_cell,
       c.phone_home,
       c.email,
       c.email_phone,
       c.street1,
       c.street2,
       c.street3,
       c.city,
       c.state,
       c.zip,
       c.notes,
       getdate(),
       -1,
       c.contact_id
  FROM contacts c INNER JOIN
       customers cust ON ISNULL(c.customer_id,0) = cust.customer_id_8 INNER JOIN
       lookups l ON c.cont_status_type_id = l.lookup_id
 WHERE cust.organization_id=16
   AND c.organization_id=8
   AND c.customer_id IS NOT NULL
   AND ISNULL(cust.ext_customer_id,'') NOT IN ('10054','10088','10300','10309','10380')
   AND l.code='active'
   AND (contact_name NOT LIKE '%N/A%' OR contact_name <> 'NA' OR contact_name IS NOT NULL) 
GO
   
/* contact_groups */
INSERT INTO contact_groups (contact_id,
                            contact_type_id,
                            date_created,
                            created_by)
SELECT c.contact_id, 
       cg.contact_type_id,
       getdate(),
       -1
  FROM contacts c INNER JOIN
       contact_groups cg ON c.contact_id_8 = cg.contact_id
 WHERE c.organization_id = 16'
 GO
 
 