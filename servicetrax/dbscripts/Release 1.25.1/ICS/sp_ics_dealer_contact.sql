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