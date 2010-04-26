CREATE PROCEDURE sp_ntlsv_customer_124
AS
BEGIN

DECLARE @ntlsv_org_id numeric(18,0)
DECLARE @dealer_type_id numeric(18,0)
DECLARE @commercial_type_id numeric(18,0)
DECLARE @ext_dealer_id char(15)
DECLARE @dealer_name  VARCHAR(65)
 
SET @ntlsv_org_id 
= (SELECT organization_id 
     FROM organizations
    WHERE code='ntlsv')
    
SET @ext_dealer_id 
= (SELECT RTRIM(custnmbr) 
     FROM ntlsv.dbo.rm00101
    WHERE custname LIKE 'NATIONAL SERVICES - OMNI%' 
      AND userdef1='dealer')
      
SET @dealer_name 
= (SELECT RTRIM(custname) 
     FROM ntlsv.dbo.rm00101
    WHERE custname LIKE 'NATIONAL SERVICES - OMNI%' 
      AND userdef1='dealer')
          
INSERT INTO customers(organization_id,
		      ext_dealer_id,
		      dealer_name,
		      ext_customer_id,
		      customer_name,
		      active_flag,
		      date_created,
		      created_by,
		      a_m_furniture1_contact_id,
		      survey_frequency,
		      survey_location,
		      refusal_email_info,
		      view_schedule_flag,
		      customer_id_8)
SELECT @ntlsv_org_id ,
       @ext_dealer_id,
       @dealer_name,
       c.ext_customer_id,
       c.customer_name,
       'Y',
       getDate(),
       -1,
       c.a_m_furniture1_contact_id,
       c.survey_frequency,
       c.survey_location,
       c.refusal_email_info,
       c.view_schedule_flag,
       c.customer_id
  FROM dbo.customers c JOIN
       ntlsv.dbo.rm00101 rm ON RTRIM(ISNULL(c.ext_customer_id,'')) = RTRIM(rm.custnmbr) JOIN
       organizations o ON c.organization_id = o.organization_id
 WHERE rm.custnmbr NOT LIKE 'old%' 
   AND c.active_flag='Y'
   AND o.code='aia'
   AND ISNULL(c.ext_customer_id,'') <> @ext_dealer_id
   AND ISNULL(c.ext_customer_id,'') NOT IN (SELECT ISNULL(ext_customer_id,'') FROM customers WHERE organization_id=16)

END
GO

CREATE PROCEDURE sp_duplicate_customer_124
AS
BEGIN

DECLARE @ext_customer_id CHAR(15)
DECLARE @service_id numeric(18,0)
DECLARE @c1 CURSOR

SET @c1 = CURSOR FAST_FORWARD
FOR
SELECT ext_customer_id
  FROM customers
 WHERE organization_id = 16
   AND ext_customer_id IS NOT NULL
GROUP BY ext_customer_id
HAVING COUNT(*) > 1
ORDER BY ext_customer_id


OPEN @c1
FETCH NEXT FROM @c1 INTO @ext_customer_id

WHILE @@FETCH_STATUS=0
BEGIN
  PRINT @ext_customer_id
  
  DELETE FROM customers
   WHERE customer_id = (SELECT MIN(customer_id)
                          FROM customers
                         WHERE organization_id = 16
                           AND ISNULL(ext_customer_id,'') = @ext_customer_id)
                             
  FETCH NEXT FROM @c1 INTO @ext_customer_id
END

CLOSE @c1
DEALLOCATE @c1

END
GO

CREATE PROCEDURE sp_ntlsv_existing_customer_124
AS
BEGIN

DECLARE @customer_id_16 numeric(18,0)
DECLARE @customer_id_8 numeric(18,0)
DECLARE @c1 CURSOR

SET @c1 = CURSOR FAST_FORWARD
FOR
SELECT c16.customer_id,
       c8.customer_id customer_id_8 
  from customers c8 JOIN
       customers c16 ON c8.ext_customer_id=c16.ext_customer_id
 where c8.organization_id=8
   and c16.organization_id=16
   and c8.ext_customer_id IS NOT NULL 
   and c16.ext_customer_id IS NOT NULL 
   and c8.active_flag = 'y'
   and c16.created_by <> -1
    
      
OPEN @c1
FETCH NEXT FROM @c1 INTO @customer_id_16,@customer_id_8

WHILE @@FETCH_STATUS=0
BEGIN
  PRINT @customer_id_16
  
  UPDATE customers
     SET customer_id_8 = @customer_id_8,
         date_modified = getdate(),
         modified_by = -1
   WHERE customer_id=@customer_id_16
     AND organization_id=16
     AND created_by <> -1    
                             
  FETCH NEXT FROM @c1 INTO @customer_id_16,@customer_id_8
END

CLOSE @c1
DEALLOCATE @c1

END
GO

CREATE PROCEDURE sp_ntlsv_end_user_124
AS
BEGIN

DECLARE @ext_dealer_id char(15)
DECLARE @dealer_name  VARCHAR(65)
DECLARE @c1 CURSOR

SET @c1 = CURSOR FAST_FORWARD
FOR
SELECT ntl.custnmbr,
       ntl.custname
  FROM aia.dbo.rm00101 aia INNER JOIN
       ntlsv.dbo.rm00101 ntl ON aia.custnmbr=ntl.custnmbr
 WHERE aia.userdef1='dealer'
   AND ntl.userdef1='dealer'
   AND aia.custnmbr NOT LIKE 'old%'
   AND ntl.custnmbr NOT LIKE 'old%'
   AND ntl.custnmbr NOT IN ('10054','10088','10300','10309','10380')
ORDER BY ntl.custnmbr
    
      
OPEN @c1
FETCH NEXT FROM @c1 INTO @ext_dealer_id,@dealer_name

WHILE @@FETCH_STATUS=0
BEGIN
  PRINT @ext_dealer_id
  
  INSERT INTO customers (organization_id, 
                         ext_dealer_id, 
                         dealer_name, 
                         ext_customer_id,
                         customer_name,
                         active_flag,
                         date_created,
                         created_by, 
                         view_schedule_flag, 
                         customer_id_8)
  SELECT 16, 
         @ext_dealer_id,
         @dealer_name,
         ext_customer_id,
         customer_name,         
         active_flag,
         getdate(),
         -1,
         'Y',
         customer_id
    FROM customers
   WHERE organization_id = 8
     AND ext_dealer_id = @ext_dealer_id
     AND ext_dealer_id <> '10971'
     AND active_flag='Y'
    
                             
  FETCH NEXT FROM @c1 INTO @ext_dealer_id,@dealer_name
END

CLOSE @c1
DEALLOCATE @c1

END
GO