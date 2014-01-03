USE [IMS_NEW]
GO

/****** Object:  View [dbo].[extranet_email_v2]    Script Date: 01/03/2014 13:51:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* $Id: extranet_email_v2.sql 1655 2009-08-05 21:24:48Z bvonhaden $ */

ALTER VIEW [dbo].[extranet_email_v2]
AS
SELECT CONVERT(VARCHAR(20), GETDATE(), 113) AS todays_date, 
       CASE WHEN customer_type.code = 'end_user' THEN (SELECT customer_name FROM customers WHERE customer_id = cust.end_user_Parent_id) ELSE cust.customer_name END customer_name,
       CASE WHEN customer_type.code = 'end_user' THEN cust.customer_name ELSE eu.customer_name END end_user_name,
       p.job_name, 
       p.project_no, 
       CONVERT(VARCHAR, p.project_no) + '-' + CONVERT(VARCHAR, r.request_no) + '.' + CONVERT(VARCHAR, r.version_no) AS record_no, 
       r.request_id AS record_id,
       request_type.code AS record_type_code, 
       request_type.name AS record_type_name,
       request_status_type.code AS record_status_type_code,        
       r.a_m_contact_id,  
       r.a_m_sales_contact_id, 
       r.customer_contact_id, 
       r.customer_contact2_id, 
       r.customer_contact3_id, 
       r.customer_contact4_id,    
       r.d_sales_rep_contact_id, 
       r.d_sales_sup_contact_id, 
       r.d_designer_contact_id, 
       r.d_proj_mgr_contact_id, 
       r.description,
       r.est_start_date,
       r.est_end_date,
       o.scheduler_contact_id, 
       p.is_new
  FROM dbo.requests r INNER JOIN
       dbo.projects p ON r.project_id = p.project_id INNER JOIN
       dbo.lookups request_type ON r.request_type_id = request_type.lookup_id INNER JOIN
       dbo.lookups request_status_type ON r.request_status_type_id = request_status_type.lookup_id INNER JOIN
       dbo.customers cust ON p.customer_id = cust.customer_id INNER JOIN
       dbo.lookups customer_type ON cust.customer_type_id = customer_type.lookup_id INNER JOIN
       dbo.organizations o ON cust.organization_id = o.organization_id LEFT OUTER JOIN
       dbo.customers eu ON p.end_user_id = eu.customer_id
 WHERE request_type.code IN ('quote_request','service_request')

GO


