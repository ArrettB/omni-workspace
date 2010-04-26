INSERT INTO lookups
(code, name, attribute1, attribute2, attribute3, active_flag, updatable_flag, sequence_no, lookup_type_id, created_by, date_created)
(SELECT 'carpet', 'Carpet', 'CA', 'Y', 'long', 'Y', 'Y', 1, lt.lookup_type_id, 1, CURRENT_TIMESTAMP
FROM lookup_types lt
WHERE lt.code = 'job_type')
go

INSERT INTO lookups
(code, name, attribute1, attribute2, attribute3, active_flag, updatable_flag, sequence_no, lookup_type_id, created_by, date_created)
(SELECT 'construction', 'Construction', 'CO', 'N', 'long', 'Y', 'Y', 1, lt.lookup_type_id, 1, CURRENT_TIMESTAMP
FROM lookup_types lt
WHERE lt.code = 'job_type')
go

INSERT INTO lookups
(code, name, attribute1, attribute2, attribute3, active_flag, updatable_flag, sequence_no, lookup_type_id, created_by, date_created)
(SELECT 'warehousing', 'Warehousing', 'W', 'N', 'short', 'Y', 'Y', 1, lt.lookup_type_id, 1, CURRENT_TIMESTAMP
FROM lookup_types lt
WHERE lt.code = 'job_type')
go

INSERT INTO lookups
(code, name, attribute1, attribute2, attribute3, active_flag, updatable_flag, sequence_no, lookup_type_id, created_by, date_created)
(SELECT 'overhead', 'Overhead', 'OH', 'N', 'short', 'Y', 'Y', 1, lt.lookup_type_id, 1, CURRENT_TIMESTAMP
FROM lookup_types lt
WHERE lt.code = 'job_type')
go

INSERT INTO lookups
(code, name, attribute1, attribute2, attribute3, active_flag, updatable_flag, sequence_no, lookup_type_id, created_by, date_created)
(SELECT 'used_furniture', 'Used Furniture', 'U', 'N', 'short', 'Y', 'Y', 1, lt.lookup_type_id, 1, CURRENT_TIMESTAMP
FROM lookup_types lt
WHERE lt.code = 'job_type')
go

UPDATE lookups
SET name = 'Furniture'
, attribute1 = 'F'
, attribute2 = 'Y'
, attribute3 = 'long'
WHERE code = 'project'
AND lookup_type_id = (SELECT lookup_type_id FROM lookup_types WHERE code = 'job_type')
go

UPDATE lookups
SET name = 'Service Acct.'
, attribute1 = 'S'
, attribute2 = 'N'
, attribute3 = 'short'
WHERE code = 'service_account'
AND lookup_type_id = (SELECT lookup_type_id FROM lookup_types WHERE code = 'job_type')
go


ALTER TABLE items
ADD JOB_TYPE_ID numeric(18) NULL
go

ALTER TABLE items
ADD CONSTRAINT FK_ITEMS_TYPE_TYPES FOREIGN KEY
(JOB_TYPE_ID) REFERENCES lookups (lookup_id)
go


drop view dbo_items_v
go

CREATE VIEW dbo.ITEMS_V  
AS  
SELECT     dbo.ITEMS.ORGANIZATION_ID, dbo.ITEMS.ITEM_ID, dbo.ITEMS.NAME, dbo.ITEMS.DESCRIPTION, dbo.ITEMS.EXT_ITEM_ID,   
                      dbo.ITEMS.ITEM_TYPE_ID, ITEM_TYPE.CODE AS item_type_code, ITEM_TYPE.NAME AS item_type_name, dbo.ITEMS.ITEM_STATUS_TYPE_ID,   
                      STATUS_TYPE.CODE AS item_status_type_code, STATUS_TYPE.NAME AS item_status_type_name, dbo.ITEMS.CODE, dbo.ITEMS.BILLABLE_FLAG,   
                      dbo.ITEMS.SEQUENCE_NO, dbo.ITEMS.EXPENSE_EXPORT_CODE, dbo.ITEMS.job_type_id, dbo.ITEMS.CREATED_BY, dbo.ITEMS.DATE_CREATED,   
                      CREATE_USER.FIRST_NAME + ' ' + CREATE_USER.LAST_NAME AS created_by_name, dbo.ITEMS.DATE_MODIFIED, dbo.ITEMS.MODIFIED_BY,   
                      MOD_USER.FIRST_NAME + ' ' + MOD_USER.LAST_NAME AS modified_by_name  
FROM         dbo.LOOKUPS ITEM_TYPE RIGHT OUTER JOIN  
                      dbo.LOOKUPS STATUS_TYPE RIGHT OUTER JOIN  
                      dbo.ITEMS LEFT OUTER JOIN  
                      dbo.USERS MOD_USER ON dbo.ITEMS.MODIFIED_BY = MOD_USER.USER_ID LEFT OUTER JOIN  
                      dbo.USERS CREATE_USER ON dbo.ITEMS.CREATED_BY = CREATE_USER.USER_ID ON   
                      STATUS_TYPE.LOOKUP_ID = dbo.ITEMS.ITEM_STATUS_TYPE_ID ON ITEM_TYPE.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID  
go

CREATE VIEW dbo.ITEMS_BY_JOB_TYPES_V
(job_id, item_id)
AS
(SELECT j.job_id, i.item_id
FROM dbo.jobs j INNER JOIN dbo.items i ON j.job_type_id = i.job_type_id)
go


