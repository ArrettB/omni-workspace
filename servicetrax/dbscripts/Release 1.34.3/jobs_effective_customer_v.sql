CREATE VIEW jobs_effective_customer_v
AS
SELECT j.job_id,
 CASE WHEN customer_type.code = 'dealer' THEN j.end_user_id ELSE j.customer_id END effective_customer_id
FROM dbo.jobs j INNER JOIN dbo.customers c ON j.customer_id = c.customer_id
                INNER JOIN dbo.lookups customer_type ON c.customer_type_id = customer_type.lookup_id 
