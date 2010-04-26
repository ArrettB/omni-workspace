CREATE VIEW dbo.SERVICE_REQUESTS_V  
AS  
SELECT project_id, project_no, job_name, request_id, project_request_no
, dealer_name, ext_dealer_id, dealer_project_no
, customer_name, customer_id, parent_customer_id
, organization_id, a_m_contact_name, is_quoted
, request_type_code, request_status_type_code, request_status_type_name
, date_created
,is_converted = CASE ISNULL(service_id, '-1')
WHEN -1 THEN 'N'
ELSE 'Y' END
, record_seq_no
FROM   dbo.REQUESTS_V
WHERE request_type_code = 'service_request'
go


CREATE VIEW dbo.QUOTE_REQUESTS_V  
AS  
SELECT r.project_id, r.project_no, r.job_name, r.request_id, r.project_request_no
, r.dealer_name, r.ext_dealer_id, r.dealer_project_no
, r.customer_name, r.customer_id, r.parent_customer_id
, r.organization_id, r.a_m_contact_name, r.is_quoted
, r.request_type_code, r.request_status_type_code, r.request_status_type_name
, ISNULL(qr.is_converted, 'N') is_converted, r.record_seq_no
, r.date_created
FROM requests_v r LEFT OUTER JOIN dbo.SERVICE_REQUESTS_V qr
 ON r.project_id = qr.project_id
WHERE r.request_type_code = 'quote_request'
go


DROP VIEW dbo.RESOURCE_ITEMS_V
go

CREATE VIEW dbo.RESOURCE_ITEMS_V  
AS  
SELECT     dbo.RESOURCES_V.ORGANIZATION_ID, dbo.RESOURCE_ITEMS.RESOURCE_ITEM_ID, dbo.RESOURCE_ITEMS.ITEM_ID,   
                      dbo.ITEMS_V.NAME AS item_name, dbo.ITEMS_V.EXT_ITEM_ID, dbo.ITEMS_V.ITEM_TYPE_ID, dbo.ITEMS_V.item_type_code,   
                      dbo.ITEMS_V.item_type_name, dbo.ITEMS_V.item_status_type_code, dbo.RESOURCE_ITEMS.RESOURCE_ID, dbo.RESOURCES_V.NAME AS resource_name,   
                      dbo.RESOURCES_V.RESOURCE_TYPE_ID, dbo.RESOURCES_V.resource_type_code, dbo.RESOURCES_V.resource_type_name,   
                      dbo.RESOURCES_V.USER_ID, dbo.RESOURCES_V.user_full_name, dbo.RESOURCES_V.ACTIVE_FLAG, dbo.RESOURCE_ITEMS.DEFAULT_ITEM_FLAG,   
                      dbo.RESOURCE_ITEMS.MAX_AMOUNT, dbo.RESOURCE_ITEMS.DATE_CREATED, dbo.RESOURCE_ITEMS.CREATED_BY,   
                      USERS_V_1.full_name AS created_by_name, dbo.RESOURCE_ITEMS.DATE_MODIFIED, USERS_V_1.full_name AS modified_by_name,   
                      dbo.RESOURCE_ITEMS.MODIFIED_BY, dbo.RESOURCES_V.FOREMAN_FLAG, dbo.ITEMS_V.ORGANIZATION_ID AS Expr1  
FROM         dbo.RESOURCE_ITEMS LEFT OUTER JOIN dbo.USERS_V USERS_V_1
 ON dbo.RESOURCE_ITEMS.MODIFIED_BY = USERS_V_1.USER_ID
LEFT OUTER JOIN dbo.RESOURCES_V
 ON dbo.RESOURCE_ITEMS.RESOURCE_ID = dbo.RESOURCES_V.RESOURCE_ID
LEFT OUTER JOIN dbo.ITEMS_V
 ON dbo.RESOURCE_ITEMS.ITEM_ID = dbo.ITEMS_V.ITEM_ID
LEFT OUTER JOIN dbo.USERS_V USERS_V_2
ON dbo.RESOURCE_ITEMS.CREATED_BY = USERS_V_2.USER_ID
go

DROP VIEW dbo.RESOURCE_ITEM_RATES_V
go

CREATE VIEW dbo.RESOURCE_ITEM_RATES_V  
AS  
SELECT     dbo.RESOURCE_ITEMS_V.ORGANIZATION_ID, dbo.RESOURCE_ITEMS_V.item_name, dbo.RESOURCE_ITEMS_V.RESOURCE_ITEM_ID,   
                      dbo.RESOURCE_ITEMS_V.ITEM_ID, dbo.RESOURCE_ITEMS_V.item_type_code, dbo.RESOURCE_ITEMS_V.item_status_type_code,
                      dbo.RESOURCE_ITEMS_V.RESOURCE_ID,   
                      dbo.RESOURCE_ITEMS_V.resource_name, dbo.RESOURCE_ITEMS_V.resource_type_code, dbo.JOB_ITEM_RATES.JOB_ID,   
                      dbo.JOB_ITEM_RATES.RATE, dbo.JOBS.JOB_NO  
FROM
dbo.JOBS INNER JOIN dbo.JOB_ITEM_RATES
 ON dbo.JOBS.JOB_ID = dbo.JOB_ITEM_RATES.JOB_ID
RIGHT OUTER JOIN dbo.RESOURCE_ITEMS_V
 ON dbo.JOB_ITEM_RATES.ITEM_ID = dbo.RESOURCE_ITEMS_V.ITEM_ID  
go



-- save original view
--  CREATE VIEW dbo.PKT_ITEMS_V  
--AS  
--SELECT     dbo.ITEMS.ITEM_ID, dbo.ITEMS.NAME AS item_name, dbo.ITEMS.ORGANIZATION_ID  
--FROM         dbo.LOOKUPS item_status INNER JOIN  
--                      dbo.ITEMS ON item_status.LOOKUP_ID = dbo.ITEMS.ITEM_STATUS_TYPE_ID  
--WHERE     (item_status.CODE = 'active')  

DROP VIEW dbo.PKT_ITEMS_V
go

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
go



