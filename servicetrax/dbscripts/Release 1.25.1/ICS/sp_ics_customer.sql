DROP PROCEDURE sp_ics_customer
GO

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