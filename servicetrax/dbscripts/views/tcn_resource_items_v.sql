
CREATE VIEW tcn_resource_items_v
AS
SELECT i.name AS item_name, 
       item_type.code AS item_type_code, 
       ri.resource_id, 
       i.item_id, 
       i.organization_id, 
       job_type.code, 
       j.job_type_id, 
       j.job_id
  FROM dbo.resource_items  ri INNER JOIN
       dbo.items i on ri.item_id = i.item_id INNER JOIN
       dbo.LOOKUPS item_type ON i.item_type_id = item_type.lookup_id INNER JOIN
       dbo.jobs j ON i.job_type_id = j.job_type_id INNER JOIN
       dbo.lookups job_type ON j.job_type_id = job_type.lookup_id

