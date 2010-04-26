INSERT INTO customers (organization_id, ext_dealer_id, dealer_name, ext_customer_id,customer_name,active_flag,date_created,created_by, view_schedule_flag, customer_type_id)
SELECT o.organization_id, 
       (SELECT custnmbr FROM ciinc.dbo.rm00101 WHERE RTRIM(shrtname) LIKE 'CI, INC.%' AND userdef1='DEALER'),
       (SELECT custname FROM ciinc.dbo.rm00101 WHERE RTRIM(shrtname) LIKE 'CI, INC.%' AND userdef1='DEALER'),
       custnmbr,shrtname,
       'Y',
       getdate(),
       1,
       'N',
       l.lookup_id
  FROM ciinc.dbo.rm00101 rm,
       organizations o,
       lookups l INNER JOIN lookup_types lt ON l.lookup_type_id=lt.lookup_type_id
 WHERE rm.shrtname NOT LIKE 'CI, INC.%' 
   AND rm.userdef1='DEALER'
   AND o.db_prefix LIKE 'ciinc.dbo%'
   AND lt.code='customer_type' 
   AND l.code='dealer'
   AND rm.custnmbr NOT LIKE 'OLD%'
GO


UPDATE customers 
   SET customer_type_id=(SELECT l.lookup_id 
                           FROM lookups l INNER JOIN lookup_types lt ON l.lookup_type_id=lt.lookup_type_id
                          WHERE lt.code='customer_type' AND l.code='commercial') 
 WHERE ext_dealer_id = (SELECT custnmbr FROM ciinc.dbo.rm00101 WHERE RTRIM(shrtname) LIKE 'CI, INC.%' AND userdef1='DEALER') 
   AND ISNULL(ext_customer_id,'') NOT IN (SELECT custnmbr FROM ciinc.dbo.rm00101 WHERE shrtname NOT LIKE 'CI, INC.%' AND userdef1='DEALER')
   AND organization_id=(SELECT organization_id FROM organizations WHERE db_prefix LIKE 'ciinc.dbo%')
GO

UPDATE customers
   SET customer_type_id=(SELECT l.lookup_id 
                           FROM lookups l INNER JOIN lookup_types lt ON l.lookup_type_id=lt.lookup_type_id
                          WHERE lt.code='customer_type' AND l.code='end_user')
 WHERE ext_dealer_id != (SELECT custnmbr FROM ciinc.dbo.rm00101 WHERE RTRIM(shrtname) LIKE 'CI, INC.%' AND userdef1='DEALER')
   AND ISNULL(ext_customer_id,'') NOT IN (SELECT custnmbr FROM ciinc.dbo.rm00101 WHERE shrtname NOT LIKE 'CI, INC.%' AND userdef1='DEALER')
   AND organization_id=(SELECT organization_id FROM organizations WHERE db_prefix LIKE 'ciinc.dbo%')
GO
   
   
EXECUTE sp_ciinc_customer
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
                           AND c1.organization_id=(SELECT organization_id FROM organizations WHERE db_prefix LIKE 'ciinc.dbo%'))
  AND l.code='active'
  AND jl.active_flag='Y'
GO

EXECUTE sp_ciinc_dealer_contact
GO
   
EXECUTE sp_ciinc_new_end_user
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
     AND eu.ext_dealer_id = (SELECT custnmbr FROM ciinc.dbo.rm00101 WHERE RTRIM(shrtname) LIKE 'CI, INC.%' AND userdef1='DEALER')
     AND eu.end_user_parent_id IN (SELECT c.customer_id
                                     FROM customers c INNER JOIN 
                                          lookups l ON c.customer_type_id=l.lookup_id
                                    WHERE l.code IN ('commercial','corporate','government')
                                      AND c.ext_dealer_id = (SELECT custnmbr FROM ciinc.dbo.rm00101 WHERE RTRIM(shrtname) LIKE 'CI, INC.%' AND userdef1='DEALER')
                                      AND ISNULL(c.ext_customer_id,'') NOT IN (SELECT custnmbr FROM ciinc.dbo.rm00101 WHERE shrtname NOT LIKE 'CI, INC.%' AND userdef1='DEALER')
                                      AND c.organization_id=(SELECT organization_id FROM organizations WHERE db_prefix LIKE 'ciinc.dbo%')
                                      AND ISNULL(c.ext_customer_id,'') NOT LIKE 'old%'
                                      AND c.active_flag='Y')
GO