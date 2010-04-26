
CREATE VIEW dbo.ITEMS_BY_JOB_TYPES_V
(job_id, item_id)
AS
(SELECT j.job_id, i.item_id
FROM dbo.jobs j INNER JOIN dbo.items i ON j.job_type_id = i.job_type_id)

