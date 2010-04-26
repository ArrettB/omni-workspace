
CREATE VIEW dbo.PKT_ITEMS_V
AS
SELECT DISTINCT rir.item_id, rir.item_name, rir.organization_id, rir.job_id, u.user_id
FROM resource_item_rates_v rir inner join items_by_job_types_v ijt
ON rir.job_id = ijt.job_id
AND rir.item_id = ijt.item_id
AND rir.item_type_code = 'hours'
INNER JOIN resources r
ON r.resource_id = rir.resource_id
INNER JOIN users u
ON u.user_id = r.user_id
AND rir.organization_id = r.organization_id

