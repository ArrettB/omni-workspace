CREATE VIEW dbo.LOOKUPS_VT
AS
SELECT     TOP 100 PERCENT dbo.LOOKUP_TYPES.LOOKUP_TYPE_ID, dbo.LOOKUP_TYPES.CODE AS type_code, dbo.LOOKUP_TYPES.NAME AS type_name, 
                      dbo.LOOKUP_TYPES.ACTIVE_FLAG AS type_active_flag, dbo.LOOKUP_TYPES.UPDATABLE_FLAG AS type_updatable_flag, 
                      dbo.LOOKUP_TYPES.PARENT_TYPE_ID,
              dbo.LOOKUPS.LOOKUP_ID, dbo.LOOKUPS.CODE AS lookup_code, 
                      dbo.LOOKUPS.NAME AS lookup_name, dbo.LOOKUPS.SEQUENCE_NO, dbo.LOOKUPS.ACTIVE_FLAG AS lookup_active_flag, 
                      dbo.LOOKUPS.UPDATABLE_FLAG AS lookup_updatable_flag, dbo.LOOKUPS.PARENT_LOOKUP_ID, dbo.LOOKUPS.EXT_ID, dbo.LOOKUPS.ATTRIBUTE1,
                       dbo.LOOKUPS.ATTRIBUTE2, dbo.LOOKUPS.ATTRIBUTE3
FROM dbo.LOOKUPS INNER JOIN LOOKUP_TYPES ON dbo.LOOKUPS.LOOKUP_TYPE_ID = dbo.LOOKUP_TYPES.LOOKUP_TYPE_ID
ORDER BY type_code, dbo.LOOKUPS.SEQUENCE_NO
go



CREATE VIEW dbo.QUOTE_REQUEST_TYPES_VT
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag,
           LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID
FROM       dbo.LOOKUPS_VT
WHERE     (type_code = 'request_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
go


CREATE VIEW dbo.CUSTOMER_TYPES_VT
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag,
           LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID
FROM       dbo.LOOKUPS_VT
WHERE     (type_code = 'customer_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
go



CREATE VIEW dbo.PROJECT_STATUS_TYPES_VT
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag,
           LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID
FROM       dbo.LOOKUPS_VT
WHERE     (type_code = 'project_status_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
go


CREATE VIEW dbo.SERV_REQ_STATUS_TYPES_VT
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag,
           LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID
FROM       dbo.LOOKUPS_VT
WHERE     (type_code = 'serv_req_status_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
go


CREATE VIEW dbo.QUOTE_REQ_STATUS_TYPES_VT
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag,
           LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID
FROM       dbo.LOOKUPS_VT
WHERE     (type_code = 'quote_req_status_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
go


CREATE VIEW dbo.WORKORDER_STATUS_TYPES_VT
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag,
           LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID
FROM       dbo.LOOKUPS_VT
WHERE     (type_code = 'workorder_status_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
go

