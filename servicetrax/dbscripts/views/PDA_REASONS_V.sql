CREATE VIEW dbo.PDA_REASONS_V AS SELECT dbo.LOOKUPS.LOOKUP_ID AS reason_id, SUBSTRING(dbo.LOOKUPS.NAME, 0, 20) AS reason FROM dbo.LOOKUPS INNER JOIN dbo.LOOKUP_TYPES ON dbo.LOOKUPS.LOOKUP_TYPE_ID = dbo.LOOKUP_TYPES.LOOKUP_TYPE_ID WHERE (dbo.LOOKUP_TYPES.CODE = 'override_reason_type') AND (dbo.LOOKUP_TYPES.ACTIVE_FLAG = 'Y') 