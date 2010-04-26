CREATE VIEW dbo.TC_SERVICES_V
AS
SELECT     dbo.SERVICES.JOB_ID, dbo.SERVICES.SERVICE_ID, dbo.SERVICES.SERVICE_NO, CAST(dbo.SERVICES.SERVICE_NO AS varchar) 
                      + ' - ' + ISNULL(dbo.SERVICES.DESCRIPTION, '') AS service_no_desc, dbo.SERVICES.SERV_STATUS_TYPE_ID, 
                      SERVICE_STATUS_TYPES.CODE AS serv_status_type_code, SERVICE_STATUS_TYPES.NAME AS serv_status_type_name, 
                      SERVICE_STATUS_TYPES.SEQUENCE_NO AS serv_status_type_seq_no, ISNULL(dbo.SERVICES.WOOD_PRODUCT_TYPE_ID, 142) 
                      AS wood_product_type_id
FROM         dbo.LOOKUPS SERVICE_STATUS_TYPES RIGHT OUTER JOIN
                      dbo.SERVICES ON SERVICE_STATUS_TYPES.LOOKUP_ID = dbo.SERVICES.SERV_STATUS_TYPE_ID

