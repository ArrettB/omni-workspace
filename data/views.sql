CREATE FUNCTION sp_varchar20_to_number (@in_value varchar(20)) RETURNS numeric(18,2)
AS
BEGIN

DECLARE @l_value varchar(20)
DECLARE @result numeric(18,2)

SET @result = 0.00

IF @in_value IS NOT NULL
  BEGIN
    SET @l_value = REPLACE(REPLACE(REPLACE(REPLACE(@in_value,' ',''),'$',''),'-',''),',','')

    IF @l_value IS NULL
      BEGIN
        SET @result = 0.00
      END
    ELSE IF @l_value = ''
      BEGIN
        SET @result = 0.00
      END
    ELSE
      BEGIN
        SET @result = CONVERT(NUMERIC(18,2), @l_value)
      END
   END

RETURN @result

END
GO

CREATE FUNCTION sp_contact_phone (@in_contact_id numeric(18,0)) RETURNS varchar(100)
AS
BEGIN

DECLARE @phone_w varchar(50)
DECLARE @phone_c varchar(50)
DECLARE @phone_h varchar(50)
DECLARE @contact_phones CURSOR
DECLARE @result varchar(100)

SET @result = ''

SET @contact_phones = CURSOR FAST_FORWARD
FOR
SELECT phone_work,
       phone_cell,
       phone_home
  FROM contacts
 WHERE contact_id = @in_contact_id


OPEN @contact_phones
FETCH NEXT FROM @contact_phones INTO @phone_w,@phone_c,@phone_h

WHILE @@FETCH_STATUS=0
BEGIN

  IF @phone_w IS NOT NULL
    BEGIN
      SET @result = @phone_w + '(W)'

      IF @phone_c IS NOT NULL
        BEGIN
          SET @result = @result + ', ' + @phone_c + '(C)'
        END
    END
  ELSE
    BEGIN
      IF @phone_c IS NOT NULL
        BEGIN
          SET @result = @phone_c + '(C)'
        END
      ELSE
        IF @phone_h IS NOT NULL
          BEGIN
            SET @result = @phone_h + '(H)'
          END
    END

  FETCH NEXT FROM @contact_phones INTO @phone_w,@phone_c,@phone_h
END

CLOSE @contact_phones
DEALLOCATE @contact_phones

RETURN @result

END
GO

/****** Object:  View [dbo].[projects_v]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* $Id: projects_v.sql 1655 2009-08-05 21:24:48Z bvonhaden $ */

CREATE VIEW [dbo].[projects_v]
AS
SELECT top 100 percent p.project_id, 
       p.project_no, 
       p.project_type_id, 
       project_type.code AS project_type_code, 
       project_type.name AS project_type_name, 
       p.project_status_type_id, 
       project_status_type.code AS project_status_type_code, 
       project_status_type.name AS project_status_type_name, 
       c.organization_id, 
       p.customer_id, 
       c.parent_customer_id, 
       c.ext_dealer_id, 
       c.dealer_name, 
       c.ext_customer_id, 
       c.customer_name, 
       p.job_name, 
       p.percent_complete, 
       p.date_created, 
       p.created_by, 
       p.date_modified, 
       p.modified_by, 
       u.first_name + ' ' + u.last_name AS created_by_name,
       p.end_user_id,
       eu.customer_name end_user_name,
       eu.ext_customer_id ext_end_user_id,
       p.is_new
  FROM dbo.projects p INNER JOIN
       dbo.lookups project_type ON p.project_type_id  = project_type.lookup_id INNER JOIN
       dbo.lookups project_status_type ON p.project_status_type_id = project_status_type.lookup_id INNER JOIN
       dbo.customers c ON p.customer_id = c.customer_id INNER JOIN
       dbo.users u ON p.created_by = u.user_id LEFT OUTER JOIN
       dbo.customers eu ON p.end_user_id = eu.customer_id 
ORDER BY p.project_id
GO
/****** Object:  View [dbo].[LOOKUPS_V]    Script Date: 05/03/2010 14:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[LOOKUPS_V]
AS
SELECT     TOP 100 PERCENT dbo.LOOKUP_TYPES.LOOKUP_TYPE_ID, dbo.LOOKUP_TYPES.CODE AS type_code, dbo.LOOKUP_TYPES.NAME AS type_name, 
                      dbo.LOOKUP_TYPES.ACTIVE_FLAG AS type_active_flag, dbo.LOOKUP_TYPES.UPDATABLE_FLAG AS type_updatable_flag, 
                      dbo.LOOKUP_TYPES.PARENT_TYPE_ID, dbo.LOOKUP_TYPES.DATE_CREATED AS type_date_created, 
                      dbo.LOOKUP_TYPES.CREATED_BY AS type_created_by, USERS_1.FIRST_NAME + ' ' + USERS_1.LAST_NAME AS type_created_by_name, 
                      dbo.LOOKUP_TYPES.DATE_MODIFIED AS type_date_modified, dbo.LOOKUP_TYPES.MODIFIED_BY AS type_modified_by, 
                      USERS_2.FIRST_NAME + ' ' + USERS_2.LAST_NAME AS type_modified_by_name, dbo.LOOKUPS.LOOKUP_ID, dbo.LOOKUPS.CODE AS lookup_code, 
                      dbo.LOOKUPS.NAME AS lookup_name, dbo.LOOKUPS.SEQUENCE_NO, dbo.LOOKUPS.ACTIVE_FLAG AS lookup_active_flag, 
                      dbo.LOOKUPS.UPDATABLE_FLAG AS lookup_updatable_flag, dbo.LOOKUPS.PARENT_LOOKUP_ID, dbo.LOOKUPS.EXT_ID, dbo.LOOKUPS.ATTRIBUTE1,
                       dbo.LOOKUPS.ATTRIBUTE2, dbo.LOOKUPS.ATTRIBUTE3, dbo.LOOKUPS.DATE_CREATED AS lookup_date_created, 
                      dbo.LOOKUPS.CREATED_BY AS lookup_created_by, USERS_3.FIRST_NAME + ' ' + USERS_3.LAST_NAME AS lookup_created_by_name, 
                      dbo.LOOKUPS.DATE_MODIFIED AS lookup_date_modified, dbo.LOOKUPS.MODIFIED_BY AS lookup_modified_by, 
                      USERS_4.FIRST_NAME + ' ' + USERS_4.LAST_NAME AS lookup_modified_by_name
FROM         dbo.USERS USERS_4 RIGHT OUTER JOIN
                      dbo.LOOKUPS ON USERS_4.USER_ID = dbo.LOOKUPS.MODIFIED_BY LEFT OUTER JOIN
                      dbo.USERS USERS_3 ON dbo.LOOKUPS.CREATED_BY = USERS_3.USER_ID RIGHT OUTER JOIN
                      dbo.USERS USERS_2 RIGHT OUTER JOIN
                      dbo.LOOKUP_TYPES ON USERS_2.USER_ID = dbo.LOOKUP_TYPES.MODIFIED_BY ON 
                      dbo.LOOKUPS.LOOKUP_TYPE_ID = dbo.LOOKUP_TYPES.LOOKUP_TYPE_ID LEFT OUTER JOIN
                      dbo.USERS USERS_1 ON dbo.LOOKUP_TYPES.CREATED_BY = USERS_1.USER_ID
ORDER BY type_code, dbo.LOOKUPS.SEQUENCE_NO
GO
/* $Id: jobs_v.sql 1667 2009-08-17 21:49:29Z bvonhaden $ */

CREATE VIEW [dbo].[jobs_v]
AS
SELECT j.job_id, 
       j.project_id, 
       j.job_no, 
       j.job_name, 
       CAST(j.job_no AS varchar) + ' - ' + ISNULL(c.customer_name, '') + ' - ' + ISNULL(j.job_name, '') AS job_no_name, 
       j.job_type_id, 
       job_type.code AS job_type_code, 
       job_type.name AS job_type_name, 
       j.job_status_type_id, 
       job_status_type.code AS job_status_type_code, 
       job_status_type.name AS job_status_type_name, 
       job_status_type.sequence_no AS job_status_seq_no, 
       c.organization_id, 
       CASE WHEN customer_type.code = 'dealer' THEN c.customer_name ELSE c.dealer_name END dealer_name,
       CASE WHEN customer_type.code = 'dealer' THEN c.ext_customer_id ELSE c.ext_dealer_id END ext_dealer_id, 
       c.ext_customer_id, 
       j.ext_price_level_id, 
       j.foreman_resource_id, 
       r.name AS foreman_resource_name, 
       r.user_id AS foreman_user_id, 
       foreman_user.first_name + ' ' + foreman_user.last_name AS foreman_user_name, 
       j.billing_user_id, 
       j.a_m_sales_contact_id,
       j.watch_flag, 
       u_billing.first_name + ' ' + u_billing.last_name AS billing_user_name, 
       j.created_by, 
       created_by.first_name + ' ' + created_by.last_name AS created_by_name, 
       j.date_created, 
       j.modified_by, 
       modified_by.first_name + ' ' + modified_by.last_name AS modified_by_name, 
       j.date_modified,
       CASE WHEN customer_type.code = 'end_user' THEN c.end_user_parent_id ELSE c.customer_id END customer_id,
       CASE WHEN customer_type.code = 'end_user' THEN (SELECT customer_name FROM customers WHERE customer_id = c.end_user_parent_id) ELSE c.customer_name END customer_name,
       CASE WHEN customer_type.code = 'end_user' THEN c.customer_id ELSE eu.customer_id END end_user_id,
       CASE WHEN customer_type.code = 'end_user' THEN c.customer_name ELSE eu.customer_name END end_user_name,
       ISNULL(p.is_new, 'N') is_new
  FROM dbo.jobs j INNER JOIN
       dbo.customers c ON j.customer_id = c.customer_id INNER JOIN
       dbo.lookups customer_type ON c.customer_type_id = customer_type.lookup_id INNER JOIN
       dbo.lookups job_type ON j.job_type_id = job_type.lookup_id INNER JOIN 
       dbo.lookups job_status_type ON j.job_status_type_id = job_status_type.lookup_id INNER JOIN
       dbo.users created_by ON j.created_by = created_by.user_id LEFT OUTER JOIN
       dbo.users u_billing ON j.billing_user_id = u_billing.user_id LEFT OUTER JOIN
       dbo.users modified_by ON j.modified_by = modified_by.user_id LEFT OUTER JOIN
       dbo.resources r ON j.foreman_resource_id = r.resource_id LEFT OUTER JOIN
       dbo.users foreman_user ON r.user_id = foreman_user.user_id LEFT OUTER JOIN
       dbo.projects p ON j.project_id = p.project_id LEFT OUTER JOIN
       dbo.customers eu ON p.end_user_id = eu.customer_id
GO
/****** Object:  View [dbo].[TEMPLATE_LOCATIONS_2_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[TEMPLATE_LOCATIONS_2_V]
AS
SELECT     dbo.TEMPLATE_LOCATIONS.LOCATION, TEMPLATES_1.TEMPLATE_NAME, TEMPLATES1.TEMPLATE_NAME AS TAB_NAME
FROM         dbo.TABS INNER JOIN
                      dbo.TEMPLATES TEMPLATES1 ON dbo.TABS.TEMPLATE_ID = TEMPLATES1.TEMPLATE_ID INNER JOIN
                      dbo.TEMPLATES TEMPLATES_1 INNER JOIN
                      dbo.TEMPLATE_LOCATIONS ON TEMPLATES_1.TEMPLATE_ID = dbo.TEMPLATE_LOCATIONS.LEVEL_2_TEMPLATE ON 
                      dbo.TABS.TAB_ID = dbo.TEMPLATE_LOCATIONS.LEVEL_2_TAB
GO
/****** Object:  View [dbo].[TIME_UOM_TYPES_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[TIME_UOM_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      ATTRIBUTE1 AS category, ATTRIBUTE2 AS multiplier, lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, 
                      lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'uom_type') AND (ATTRIBUTE1 = 'time_hours') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO
/****** Object:  View [dbo].[TRACKING_TYPES_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[TRACKING_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'tracking_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO
/****** Object:  View [dbo].[UOM_TYPES_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[UOM_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      ATTRIBUTE1 AS category, ATTRIBUTE2 AS multiplier, lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, 
                      lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'uom_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO
/****** Object:  View [dbo].[WEEKEND_DATE_TYPES_V]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[WEEKEND_DATE_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name, 
                      ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'date_type') AND (lookup_code = 'this_weekend' OR
                      lookup_code = 'this_friday' OR
                      lookup_code = 'this_saturday' OR
                      lookup_code = 'this_sunday') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO
/****** Object:  View [dbo].[WOOD_PRODUCT_TYPES_V]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[WOOD_PRODUCT_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'wood_product_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO
/****** Object:  View [dbo].[YES_NO_TYPE_V]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[YES_NO_TYPE_V]
AS
SELECT     dbo.LOOKUPS.LOOKUP_ID, dbo.LOOKUPS.CODE AS yes_no_type_code, dbo.LOOKUPS.NAME, dbo.LOOKUP_TYPES.CODE AS Lookup_type_code, 
                      dbo.LOOKUPS.SEQUENCE_NO, dbo.LOOKUPS.ACTIVE_FLAG, dbo.LOOKUP_TYPES.ACTIVE_FLAG AS TYPE_ACTIVE_FLAG
FROM         dbo.LOOKUP_TYPES INNER JOIN
                      dbo.LOOKUPS ON dbo.LOOKUP_TYPES.LOOKUP_TYPE_ID = dbo.LOOKUPS.LOOKUP_TYPE_ID
WHERE     (dbo.LOOKUP_TYPES.CODE = 'yes_no_type') AND (dbo.LOOKUPS.ACTIVE_FLAG = 'Y') AND (dbo.LOOKUP_TYPES.ACTIVE_FLAG = 'Y')
GO
/****** Object:  View [dbo].[PDA_RESOURCES_V]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[PDA_RESOURCES_V]
AS
SELECT     TOP 100 PERCENT dbo.RESOURCES.RESOURCE_ID, dbo.RESOURCES.NAME, dbo.RESOURCES.FOREMAN_FLAG AS sup_flag, dbo.USERS.LOGIN, 
                      dbo.USERS.PASSWORD, SUBSTRING(dbo.USERS.FIRST_NAME, 0, 3) + SUBSTRING(dbo.USERS.LAST_NAME, 0, 8) AS res_code, 
                      dbo.PDA_RESOURCE_SORT.row_number AS sort_order, dbo.USERS.EXT_EMPLOYEE_ID AS res_no, ISNULL(dbo.USERS.PIN, '') AS pin, 
                      dbo.USERS.ACTIVE_FLAG, PALM_USER.USER_ID AS ims_user_id, PALM_RESOURCE.ORGANIZATION_ID
FROM         dbo.USERS RIGHT OUTER JOIN
                      dbo.USERS PALM_USER INNER JOIN
                      dbo.RESOURCES INNER JOIN
                      dbo.PDA_RESOURCE_SORT ON dbo.RESOURCES.RESOURCE_ID = dbo.PDA_RESOURCE_SORT.resource_id INNER JOIN
                      dbo.RESOURCES PALM_RESOURCE ON dbo.RESOURCES.ORGANIZATION_ID = PALM_RESOURCE.ORGANIZATION_ID ON 
                      PALM_USER.USER_ID = PALM_RESOURCE.USER_ID ON dbo.USERS.USER_ID = dbo.RESOURCES.USER_ID
WHERE     (dbo.RESOURCES.ACTIVE_FLAG = 'Y') AND (dbo.USERS.ACTIVE_FLAG = 'Y' OR
                      dbo.USERS.ACTIVE_FLAG IS NULL)
ORDER BY PALM_USER.USER_ID
GO
/****** Object:  View [dbo].[PDA_REASONS_V]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[PDA_REASONS_V] AS SELECT dbo.LOOKUPS.LOOKUP_ID AS reason_id, SUBSTRING(dbo.LOOKUPS.NAME, 0, 20) AS reason FROM dbo.LOOKUPS INNER JOIN dbo.LOOKUP_TYPES ON dbo.LOOKUPS.LOOKUP_TYPE_ID = dbo.LOOKUP_TYPES.LOOKUP_TYPE_ID WHERE (dbo.LOOKUP_TYPES.CODE = 'override_reason_type') AND (dbo.LOOKUP_TYPES.ACTIVE_FLAG = 'Y')
GO
/****** Object:  View [dbo].[MAX_REQ_NO_V]    Script Date: 05/03/2010 14:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[MAX_REQ_NO_V]
AS
SELECT     TOP 100 PERCENT dbo.PROJECTS.PROJECT_ID, dbo.PROJECTS.PROJECT_NO, MAX(ISNULL(dbo.REQUESTS.REQUEST_NO, 0)) AS max_request_no, 
                      dbo.JOBS.JOB_ID, dbo.JOBS.JOB_NO, MAX(ISNULL(dbo.SERVICES.SERVICE_NO, 0)) AS max_service_no
FROM         dbo.REQUESTS RIGHT OUTER JOIN
                      dbo.PROJECTS ON dbo.REQUESTS.PROJECT_ID = dbo.PROJECTS.PROJECT_ID FULL OUTER JOIN
                      dbo.JOBS LEFT OUTER JOIN
                      dbo.SERVICES ON dbo.JOBS.JOB_ID = dbo.SERVICES.JOB_ID ON dbo.PROJECTS.PROJECT_ID = dbo.JOBS.PROJECT_ID
GROUP BY dbo.PROJECTS.PROJECT_ID, dbo.JOBS.JOB_ID, dbo.JOBS.JOB_NO, dbo.PROJECTS.PROJECT_NO
ORDER BY dbo.JOBS.JOB_ID
GO
/****** Object:  View [dbo].[crystal_pkf_quote_V]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[crystal_pkf_quote_V]
AS
SELECT     dbo.QUOTES.QUOTE_ID, dbo.QUOTES.QUOTE_NO, dbo.REQUESTS.PROJECT_ID, dbo.QUOTES.REQUEST_ID, dbo.QUOTES.IS_SENT, 
                      dbo.QUOTES.QUOTED_BY_USER_ID, dbo.QUOTES.DESCRIPTION, dbo.QUOTES.QUOTE_TOTAL, dbo.REQUESTS.DURATION_QTY, 
                      dbo.QUOTES.TAXABLE_FLAG, dbo.REQUESTS.CUST_COL_1, dbo.REQUESTS.CUST_COL_2, dbo.REQUESTS.CUST_COL_3, 
                      dbo.REQUESTS.CUST_COL_4, dbo.REQUESTS.CUST_COL_5, dbo.REQUESTS.CUST_COL_6, dbo.REQUESTS.CUST_COL_7, 
                      dbo.REQUESTS.CUST_COL_8, dbo.REQUESTS.CUST_COL_9, dbo.REQUESTS.CUST_COL_10, dbo.REQUESTS.CUSTOMER_PO_NO, 
                      dbo.REQUESTS.REQUEST_NO
FROM         dbo.QUOTES LEFT OUTER JOIN
                      dbo.REQUESTS ON dbo.QUOTES.REQUEST_ID = dbo.REQUESTS.REQUEST_ID
WHERE     (dbo.REQUESTS.PROJECT_ID = 22045)
GO
/****** Object:  View [dbo].[SYSCOLUMNS_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[SYSCOLUMNS_V]
AS
SELECT     TOP 100 PERCENT dbo.sysobjects.name AS table_name, dbo.sysobjects.id AS table_id, dbo.syscolumns.name AS column_name, 
                      dbo.sysobjects.xtype
FROM         dbo.sysobjects LEFT OUTER JOIN
                      dbo.syscolumns ON dbo.sysobjects.id = dbo.syscolumns.id
WHERE     (dbo.sysobjects.xtype = 'U') OR
                      (dbo.sysobjects.xtype = 'V')
ORDER BY table_name, column_name
GO

/****** View [dbo].[Taxes_V]  ******/
-- SET ANSI_NULLS ON
-- GO
-- SET QUOTED_IDENTIFIER ON
-- GO
--
-- CREATE VIEW
--     [dbo].[Taxes_V] ( ITEMNMBR, TAXOPTNS, CUSTNMBR, TAXSCHID, INVOICE_ID, ext_item_id, UNIT_PRICE, QTY, Total_line, line_tax, ORGANIZATION_ID ) AS
-- SELECT
--     TOP 100 PERCENT AMBIM.dbo.IV00101.ITEMNMBR,
--     AMBIM.dbo.IV00101.TAXOPTNS,
--     AMBIM.dbo.RM00101.CUSTNMBR,
--     AMBIM.dbo.RM00101.TAXSCHID,
--     dbo.INVOICES.INVOICE_ID,
--     dbo.INVOICE_LINES_V.ext_item_id,
--     dbo.INVOICE_LINES_V.UNIT_PRICE,
--     dbo.INVOICE_LINES_V.QTY,
--     dbo.INVOICE_LINES_V.UNIT_PRICE * dbo.INVOICE_LINES_V.QTY       AS Total_line,
--     dbo.INVOICE_LINES_V.UNIT_PRICE * dbo.INVOICE_LINES_V.QTY * .07 AS line_tax,
--     dbo.INVOICES.ORGANIZATION_ID
-- FROM
--     dbo.INVOICES
-- INNER JOIN AMBGP_MPLS_PAY_CODE_VIM.dbo.RM00101
-- ON
--     CAST(dbo.INVOICES.EXT_BILL_CUST_ID AS CHAR(15)) = AMBIM.dbo.RM00101.CUSTNMBR
-- INNER JOIN AMBIM.dbo.IV00101
-- INNER JOIN dbo.INVOICE_LINES_V
-- ON
--     AMBIM.dbo.IV00101.ITEMNMBR = CAST(dbo.INVOICE_LINES_V.ext_item_id AS CHAR(31))
-- ON
--     dbo.INVOICES.INVOICE_ID = dbo.INVOICE_LINES_V.INVOICE_ID
-- WHERE
--     (
--         dbo.INVOICES.ORGANIZATION_ID = 2
--     )
-- AND
--     (                                         `
--         AMBIM.dbo.RM00101.TAXSCHID <> 'EXEMPT'
--     )
-- ORDER BY
--     dbo.INVOICES.INVOICE_ID
--
-- GO

/****** Object:  View [dbo].[Taxes_V_Sum]    Script Date: 05/03/2010 14:18:09 ******/
-- SET ANSI_NULLS ON
-- GO
-- SET QUOTED_IDENTIFIER ON
-- GO
-- CREATE VIEW [dbo].[Taxes_V_Sum]
-- AS
-- SELECT     TOP 100 PERCENT INVOICE_ID, SUM(line_tax) AS Total_tax
-- FROM         dbo.Taxes_V
-- WHERE     (TAXOPTNS = 1)
-- GROUP BY INVOICE_ID
-- ORDER BY INVOICE_ID
-- GO
/****** Object:  View [dbo].[PDA_ITEMS_V]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[PDA_ITEMS_V]
AS
SELECT     dbo.ITEMS.ITEM_ID, dbo.ITEMS.NAME, LOOKUPS_1.CODE AS item_code, PALM_USER.USER_ID AS ims_user_id
FROM         dbo.RESOURCES PALM_RESOURCE INNER JOIN
                      dbo.USERS PALM_USER ON PALM_RESOURCE.USER_ID = PALM_USER.USER_ID INNER JOIN
                      dbo.ITEMS INNER JOIN
                      dbo.LOOKUPS status ON dbo.ITEMS.ITEM_STATUS_TYPE_ID = status.LOOKUP_ID INNER JOIN
                      dbo.LOOKUPS LOOKUPS_1 ON dbo.ITEMS.ITEM_TYPE_ID = LOOKUPS_1.LOOKUP_ID ON 
                      PALM_RESOURCE.ORGANIZATION_ID = dbo.ITEMS.ORGANIZATION_ID
WHERE     (status.CODE = 'active')
GO
/****** Object:  View [dbo].[JOBS_V_jerry]    Script Date: 05/03/2010 14:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[JOBS_V_jerry]
AS
SELECT     JOB_ID, PROJECT_ID, JOB_NO, JOB_NAME, DATE_CREATED
FROM         dbo.JOBS
WHERE     (DATE_CREATED > '12/31/2007')
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[9] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "JOBS"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 222
               Right = 315
            End
            DisplayFlags = 280
            TopColumn = 6
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'JOBS_V_jerry'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'JOBS_V_jerry'
GO

/****** Object:  View [dbo].[SERVICES_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[SERVICES_V]
AS
SELECT     dbo.SERVICES.JOB_ID, dbo.JOBS.JOB_NO, dbo.SERVICES.SERVICE_ID, dbo.SERVICES.SERVICE_NO, CAST(dbo.SERVICES.SERVICE_NO AS varchar)
                      + ' - ' + ISNULL(dbo.SERVICES.DESCRIPTION, '') AS service_no_desc, dbo.SERVICES.REQUEST_ID, dbo.CUSTOMERS.CUSTOMER_NAME,
                      dbo.CUSTOMERS.DEALER_NAME, dbo.JOBS.JOB_NAME, dbo.SERVICES.WATCH_FLAG, dbo.SERVICES.SERVICE_TYPE_ID,
                      SERVICE_TYPES.CODE AS service_type_code, SERVICE_TYPES.NAME AS service_type_name, dbo.SERVICES.INTERNAL_REQ_FLAG,
                      dbo.SERVICES.REPORT_TO_LOC_ID, REPORT_TO_LOC_TYPES.CODE AS report_to_loc_code,
                      REPORT_TO_LOC_TYPES.NAME AS report_to_loc_name, dbo.SERVICES.DESCRIPTION, dbo.SERVICES.SERV_STATUS_TYPE_ID,
                      SERVICE_STATUS_TYPES.CODE AS serv_status_type_code, SERVICE_STATUS_TYPES.NAME AS serv_status_type_name,
                      SERVICE_STATUS_TYPES.SEQUENCE_NO AS serv_status_type_seq_no, dbo.RESOURCES.NAME AS resource_name,
                      dbo.JOBS.FOREMAN_RESOURCE_ID, dbo.JOBS.JOB_TYPE_ID, JOB_TYPES_1.CODE AS job_type_code, JOB_TYPES_1.NAME AS job_type_name,
                      dbo.JOBS.JOB_STATUS_TYPE_ID, JOB_STATUS_TYPE.CODE AS job_status_type_code, JOB_STATUS_TYPE.NAME AS job_status_type_name,
                      dbo.JOBS.CUSTOMER_ID, dbo.JOBS.EXT_PRICE_LEVEL_ID, dbo.CUSTOMERS.EXT_DEALER_ID, dbo.CUSTOMERS.ORGANIZATION_ID,
                      dbo.JOBS.DATE_CREATED AS job_date_created, dbo.SERVICES.JOB_LOCATION_ID, dbo.JOB_LOCATIONS.JOB_LOCATION_NAME,
                      dbo.SERVICES.CUSTOMER_REF_NO, dbo.SERVICES.PO_NO, dbo.SERVICES.BILLING_TYPE_ID, dbo.SERVICES.IDM_CONTACT_ID,
                      dbo.SERVICES.CUSTOMER_CONTACT_ID, dbo.CONTACTS.CONTACT_NAME AS idm_contact_name, dbo.SERVICES.SALES_CONTACT_ID,
                      dbo.SERVICES.SUPPORT_CONTACT_ID, dbo.SERVICES.DESIGNER_CONTACT_ID, dbo.SERVICES.PROJECT_MGR_CONTACT_ID,
                      dbo.SERVICES.PRODUCT_SETUP_DESC, dbo.SERVICES.DELIVERY_TYPE_ID, dbo.SERVICES.WAREHOUSE_LOC, dbo.SERVICES.PRI_FURN_TYPE_ID,
                       dbo.SERVICES.PRI_FURN_LINE_TYPE_ID, dbo.SERVICES.SEC_FURN_TYPE_ID, dbo.SERVICES.SEC_FURN_LINE_TYPE_ID,
                      dbo.SERVICES.NUM_STATIONS, dbo.SERVICES.PRODUCT_QTY, ISNULL(dbo.SERVICES.WOOD_PRODUCT_TYPE_ID, 142) AS wood_product_type_id,
                      dbo.SERVICES.PUNCHLIST_TYPE_ID, PUNCH_LIST_TYPES.CODE AS punchlist_type_code, PUNCH_LIST_TYPES.NAME AS punchlist_type_name,
                      dbo.SERVICES.BLUEPRINT_LOCATION, dbo.SERVICES.SCHEDULE_TYPE_ID, SCHEDULE_TYPES.CODE AS schedule_type_code,
                      SCHEDULE_TYPES.NAME AS schedule_type_name, dbo.SERVICES.ORDERED_BY, dbo.SERVICES.ORDERED_DATE,
                      dbo.SERVICES.EST_START_DATE, dbo.SERVICES.EST_START_TIME, dbo.SERVICES.EST_END_DATE, dbo.SERVICES.SCH_START_DATE,
                      dbo.SERVICES.SCH_START_TIME, dbo.SERVICES.SCH_END_DATE, dbo.SERVICES.ACT_START_DATE, dbo.SERVICES.ACT_START_TIME,
                      dbo.SERVICES.ACT_END_DATE, dbo.SERVICES.TRUCK_SHIP_DATE, dbo.SERVICES.TRUCK_ARRIVAL_DATE, dbo.SERVICES.HEAD_VAL_FLAG,
                      dbo.SERVICES.LOC_VAL_FLAG, dbo.SERVICES.PROD_VAL_FLAG, dbo.SERVICES.SCH_VAL_FLAG, dbo.SERVICES.TASK_VAL_FLAG,
                      dbo.SERVICES.RES_VAL_FLAG, dbo.SERVICES.CUST_VAL_FLAG, dbo.SERVICES.BILL_VAL_FLAG, dbo.SERVICES.DATE_CREATED,
                      dbo.SERVICES.CREATED_BY, CREATE_USER.FIRST_NAME + ' ' + CREATE_USER.LAST_NAME AS created_by_name, dbo.SERVICES.DATE_MODIFIED,
                      dbo.SERVICES.MODIFIED_BY, MOD_USER.FIRST_NAME + ' ' + MOD_USER.LAST_NAME AS modified_by_name, dbo.SERVICES.CUST_COL_1,
                      dbo.SERVICES.CUST_COL_2, dbo.SERVICES.CUST_COL_3, dbo.SERVICES.CUST_COL_4, dbo.SERVICES.CUST_COL_5, dbo.SERVICES.CUST_COL_6,
                      dbo.SERVICES.CUST_COL_7, dbo.SERVICES.CUST_COL_8, dbo.SERVICES.CUST_COL_9, dbo.SERVICES.CUST_COL_10,
                      dbo.SERVICES.WEEKEND_FLAG, dbo.SERVICES.TAXABLE_FLAG, dbo.SERVICES.PRIORITY_TYPE_ID, PRIORITY_TYPES.CODE AS priority_type_code,
                      PRIORITY_TYPES.NAME AS priority_type_name, dbo.SERVICES.MISC
FROM         dbo.LOOKUPS SERVICE_STATUS_TYPES RIGHT OUTER JOIN
                      dbo.LOOKUPS SERVICE_TYPES RIGHT OUTER JOIN
                      dbo.USERS MOD_USER RIGHT OUTER JOIN
                      dbo.LOOKUPS REPORT_TO_LOC_TYPES RIGHT OUTER JOIN
                      dbo.CONTACTS RIGHT OUTER JOIN
                      dbo.SERVICES LEFT OUTER JOIN
                      dbo.LOOKUPS PRIORITY_TYPES ON dbo.SERVICES.PRIORITY_TYPE_ID = PRIORITY_TYPES.LOOKUP_ID ON
                      dbo.CONTACTS.CONTACT_ID = dbo.SERVICES.IDM_CONTACT_ID ON REPORT_TO_LOC_TYPES.LOOKUP_ID = dbo.SERVICES.REPORT_TO_LOC_ID ON
                      MOD_USER.USER_ID = dbo.SERVICES.MODIFIED_BY LEFT OUTER JOIN
                      dbo.USERS CREATE_USER ON dbo.SERVICES.CREATED_BY = CREATE_USER.USER_ID LEFT OUTER JOIN
                      dbo.LOOKUPS PUNCH_LIST_TYPES ON dbo.SERVICES.PUNCHLIST_TYPE_ID = PUNCH_LIST_TYPES.LOOKUP_ID LEFT OUTER JOIN
                      dbo.LOOKUPS SCHEDULE_TYPES ON dbo.SERVICES.SCHEDULE_TYPE_ID = SCHEDULE_TYPES.LOOKUP_ID ON
                      SERVICE_TYPES.LOOKUP_ID = dbo.SERVICES.SERVICE_TYPE_ID ON
                      SERVICE_STATUS_TYPES.LOOKUP_ID = dbo.SERVICES.SERV_STATUS_TYPE_ID LEFT OUTER JOIN
                      dbo.JOB_LOCATIONS ON dbo.SERVICES.JOB_LOCATION_ID = dbo.JOB_LOCATIONS.JOB_LOCATION_ID FULL OUTER JOIN
                      dbo.RESOURCES RIGHT OUTER JOIN
                      dbo.CUSTOMERS INNER JOIN
                      dbo.JOBS ON dbo.CUSTOMERS.CUSTOMER_ID = dbo.JOBS.CUSTOMER_ID ON
                      dbo.RESOURCES.RESOURCE_ID = dbo.JOBS.FOREMAN_RESOURCE_ID FULL OUTER JOIN
                      dbo.LOOKUPS JOB_TYPES_1 ON dbo.JOBS.JOB_TYPE_ID = JOB_TYPES_1.LOOKUP_ID FULL OUTER JOIN
                      dbo.LOOKUPS JOB_STATUS_TYPE ON dbo.JOBS.JOB_STATUS_TYPE_ID = JOB_STATUS_TYPE.LOOKUP_ID ON
                      dbo.SERVICES.JOB_ID = dbo.JOBS.JOB_ID
GO

/****** Object:  View [dbo].[JOB_SEARCH_V]    Script Date: 05/03/2010 14:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[JOB_SEARCH_V]
AS
SELECT     jobs_1.ORGANIZATION_ID, jobs_1.JOB_NO, jobs_1.JOB_ID, jobs_1.JOB_NAME, s.SERVICE_ID, s.SERVICE_NO, jobs_1.CUSTOMER_NAME,
                      jobs_1.CUSTOMER_ID, jl.JOB_LOCATION_NAME, jobs_1.JOB_STATUS_TYPE_ID, jobs_1.JOB_TYPE_ID, jobs_1.DATE_CREATED, s.service_no_desc,
                      s.serv_status_type_name
FROM         dbo.JOBS_V jobs_1 LEFT OUTER JOIN
                      dbo.SERVICES_V s ON jobs_1.JOB_ID = s.JOB_ID LEFT OUTER JOIN
                      dbo.JOB_LOCATIONS jl ON s.JOB_LOCATION_ID = jl.JOB_LOCATION_ID
GO
/****** Object:  View [dbo].[CUSTOMER_CONTACTS_V]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[CUSTOMER_CONTACTS_V]
AS
SELECT     dbo.CONTACTS.*
FROM         dbo.CONTACTS LEFT OUTER JOIN
                      dbo.LOOKUPS ON dbo.CONTACTS.CONTACT_TYPE_ID = dbo.LOOKUPS.LOOKUP_ID
WHERE     (dbo.LOOKUPS.CODE = 'customer')
GO
/****** Object:  View [dbo].[VAR_JOB_QUOTED_V]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[VAR_JOB_QUOTED_V]
AS
SELECT     dbo.JOBS.JOB_ID, SUM(ISNULL(dbo.SERVICES.QUOTE_TOTAL, 0)) AS sum_quote
FROM         dbo.JOBS INNER JOIN
                      dbo.SERVICES ON dbo.JOBS.JOB_ID = dbo.SERVICES.JOB_ID
GROUP BY dbo.JOBS.JOB_ID
GO
/****** Object:  View [dbo].[DATE_OFFSETS_V]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[DATE_OFFSETS_V]
AS
SELECT    cast( (cast(datepart(mm,getDATE()) as varchar(2))+'/'+cast(datepart(dd,getDATE()) as varchar(2))+'/'+cast(datepart(yyyy,getDATE()) as varchar(4))) as datetime) todays_date,
1 AS tomorrows_offset, - 1 AS yesterdays_offset, 6 - DATEPART(dw, GETDATE()) AS fridays_offset, 7 - DATEPART(dw, GETDATE()) AS saturdays_offset, 
                      (CASE (8 - DATEPART(dw, GETDATE())) WHEN 7 THEN 0 ELSE (8 - DATEPART(dw, GETDATE())) END) AS sundays_offset, 6 - DATEPART(dw, GETDATE()) 
                      - 7 AS last_fridays_offset, 7 - DATEPART(dw, GETDATE()) - 7 AS last_saturdays_offset, (CASE (8 - DATEPART(dw, GETDATE())) 
                      WHEN 7 THEN 0 ELSE (8 - DATEPART(dw, GETDATE())) END) - 7 AS last_sundays_offset,Datepart(wk, GETDATE() ) % 2 even_odd_week
GO
/****** Object:  View [dbo].[FUNCTION_RIGHT_TYPES_V]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[FUNCTION_RIGHT_TYPES_V]
AS
SELECT     TOP 100 PERCENT dbo.FUNCTION_RIGHT_TYPES.FUNCTION_RIGHT_TYPE_ID, dbo.FUNCTION_RIGHT_TYPES.FUNCTION_ID, 
                      dbo.FUNCTIONS.CODE AS function_code, dbo.FUNCTION_RIGHT_TYPES.RIGHT_TYPE_ID, dbo.RIGHT_TYPES.CODE AS right_type_code, 
                      dbo.FUNCTION_RIGHT_TYPES.UPDATABLE_FLAG, dbo.FUNCTION_RIGHT_TYPES.DATE_CREATED, dbo.FUNCTION_RIGHT_TYPES.CREATED_BY, 
                      USERS_1.FIRST_NAME + ' ' + USERS_1.LAST_NAME AS created_by_name, dbo.FUNCTION_RIGHT_TYPES.DATE_MODIFIED, 
                      dbo.FUNCTION_RIGHT_TYPES.MODIFIED_BY, USERS_2.FIRST_NAME + ' ' + USERS_2.LAST_NAME AS modified_by_name, 
                      dbo.FUNCTIONS.FUNCTION_GROUP_ID, dbo.FUNCTIONS.TEMPLATE_ID, dbo.FUNCTIONS.NAME AS function_name, 
                      dbo.FUNCTIONS.DESCRIPTION AS function_desc, dbo.FUNCTIONS.IS_NAV_FUNCTION, dbo.FUNCTIONS.TARGET, 
                      dbo.RIGHT_TYPES.NAME AS right_type_name, dbo.RIGHT_TYPES.DESCRIPTION AS right_type_desc
FROM         dbo.USERS USERS_2 RIGHT OUTER JOIN
                      dbo.FUNCTION_RIGHT_TYPES INNER JOIN
                      dbo.FUNCTIONS ON dbo.FUNCTION_RIGHT_TYPES.FUNCTION_ID = dbo.FUNCTIONS.FUNCTION_ID INNER JOIN
                      dbo.RIGHT_TYPES ON dbo.FUNCTION_RIGHT_TYPES.RIGHT_TYPE_ID = dbo.RIGHT_TYPES.RIGHT_TYPE_ID ON 
                      USERS_2.USER_ID = dbo.FUNCTION_RIGHT_TYPES.MODIFIED_BY LEFT OUTER JOIN
                      dbo.USERS USERS_1 ON dbo.FUNCTION_RIGHT_TYPES.CREATED_BY = USERS_1.USER_ID
GO

/****** Object:  View [dbo].[INVOICE_FORMAT_TYPES_V]    Script Date: 05/03/2010 14:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[INVOICE_FORMAT_TYPES_V]
AS
SELECT     dbo.LOOKUPS.LOOKUP_ID, dbo.LOOKUPS.CODE AS invoice_type_code, dbo.LOOKUPS.NAME, dbo.LOOKUP_TYPES.CODE AS Lookup_type_code, 
                      dbo.LOOKUPS.SEQUENCE_NO
FROM         dbo.LOOKUP_TYPES INNER JOIN
                      dbo.LOOKUPS ON dbo.LOOKUP_TYPES.LOOKUP_TYPE_ID = dbo.LOOKUPS.LOOKUP_TYPE_ID
WHERE     (dbo.LOOKUP_TYPES.CODE = 'invoice_format_type') AND (dbo.LOOKUPS.ACTIVE_FLAG <> 'N') AND (dbo.LOOKUP_TYPES.ACTIVE_FLAG <> 'N')
GO
/****** Object:  View [dbo].[ROOT_CAUSES_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ROOT_CAUSES_V]
AS
SELECT     dbo.LOOKUPS.LOOKUP_ID AS root_cause_id, dbo.LOOKUPS.NAME, dbo.LOOKUPS.ATTRIBUTE1 AS cause_number
FROM         dbo.LOOKUP_TYPES INNER JOIN
                      dbo.LOOKUPS ON dbo.LOOKUP_TYPES.LOOKUP_TYPE_ID = dbo.LOOKUPS.LOOKUP_TYPE_ID
WHERE     (dbo.LOOKUP_TYPES.CODE = 'root_cause_types') AND (dbo.LOOKUPS.ACTIVE_FLAG <> 'N') AND (dbo.LOOKUP_TYPES.ACTIVE_FLAG <> 'N')
GO
/****** Object:  View [dbo].[SYS_TABLES_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[SYS_TABLES_V]
AS
SELECT     id AS table_id, name AS table_name
FROM         dbo.sysobjects [Table]
WHERE     (xtype = 'U')
GO
/****** Object:  View [dbo].[INVOICE_LINE_TYPES_V]    Script Date: 05/03/2010 14:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[INVOICE_LINE_TYPES_V]
AS
SELECT     dbo.LOOKUPS.LOOKUP_ID, dbo.LOOKUPS.CODE AS invoice_type_code, dbo.LOOKUPS.NAME, dbo.LOOKUP_TYPES.CODE AS Lookup_type_code, 
                      dbo.LOOKUPS.SEQUENCE_NO
FROM         dbo.LOOKUP_TYPES INNER JOIN
                      dbo.LOOKUPS ON dbo.LOOKUP_TYPES.LOOKUP_TYPE_ID = dbo.LOOKUPS.LOOKUP_TYPE_ID
WHERE     (dbo.LOOKUP_TYPES.CODE = 'invoice_line_type') AND (dbo.LOOKUPS.ACTIVE_FLAG <> 'N') AND (dbo.LOOKUP_TYPES.ACTIVE_FLAG <> 'N')
GO
/****** Object:  View [dbo].[INVOICE_TYPES_V]    Script Date: 05/03/2010 14:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[INVOICE_TYPES_V]
AS
SELECT     dbo.LOOKUPS.LOOKUP_ID, dbo.LOOKUPS.CODE AS invoice_type_code, dbo.LOOKUPS.NAME, dbo.LOOKUP_TYPES.CODE AS Lookup_type_code, 
                      dbo.LOOKUPS.SEQUENCE_NO
FROM         dbo.LOOKUP_TYPES INNER JOIN
                      dbo.LOOKUPS ON dbo.LOOKUP_TYPES.LOOKUP_TYPE_ID = dbo.LOOKUPS.LOOKUP_TYPE_ID
WHERE     (dbo.LOOKUP_TYPES.CODE = 'invoice_type') AND (dbo.LOOKUPS.ACTIVE_FLAG <> 'N') AND (dbo.LOOKUP_TYPES.ACTIVE_FLAG <> 'N')
GO
/****** Object:  View [dbo].[YES_NO_NONE_TYPES_V]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[YES_NO_NONE_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'yes_no_none_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO
/****** Object:  View [dbo].[SERV_REQ_STATUS_TYPES_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[SERV_REQ_STATUS_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'serv_req_status_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO
/****** Object:  View [dbo].[WALL_MOUNT_TYPES_V]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[WALL_MOUNT_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'wall_mount_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO
/****** Object:  View [dbo].[PDA_JOBS_V]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[PDA_JOBS_V]
AS
SELECT     dbo.JOBS.JOB_ID, dbo.JOBS.JOB_NO AS ref_no, dbo.JOBS.JOB_NAME,
dbo.RESOURCES.USER_ID AS ims_user_id, 
                      dbo.CUSTOMERS.CUSTOMER_NAME AS customer,
dbo.CUSTOMERS.DEALER_NAME AS dealer
FROM         dbo.JOBS INNER JOIN
                      dbo.RESOURCES ON dbo.JOBS.FOREMAN_RESOURCE_ID =
dbo.RESOURCES.RESOURCE_ID INNER JOIN
                      dbo.CUSTOMERS ON dbo.JOBS.CUSTOMER_ID =
dbo.CUSTOMERS.CUSTOMER_ID INNER JOIN
                      dbo.LOOKUPS ON dbo.JOBS.JOB_STATUS_TYPE_ID =
dbo.LOOKUPS.LOOKUP_ID
WHERE     (dbo.LOOKUPS.CODE <> 'install_complete') AND (dbo.LOOKUPS.CODE <>
'invoiced') AND (dbo.LOOKUPS.CODE <> 'closed')
UNION
SELECT     dbo.JOBS.JOB_ID, dbo.JOBS.JOB_NO AS ref_no, dbo.JOBS.JOB_NAME,
dbo.JOB_DISTRIBUTIONS.USER_ID AS ims_user_id, 
                      dbo.CUSTOMERS.CUSTOMER_NAME AS customer,
dbo.CUSTOMERS.DEALER_NAME AS dealer
FROM         dbo.JOBS INNER JOIN
                      dbo.CUSTOMERS ON dbo.JOBS.CUSTOMER_ID =
dbo.CUSTOMERS.CUSTOMER_ID INNER JOIN
                      dbo.JOB_DISTRIBUTIONS ON dbo.JOBS.JOB_ID =
dbo.JOB_DISTRIBUTIONS.JOB_ID INNER JOIN
                      dbo.LOOKUPS ON dbo.JOBS.JOB_STATUS_TYPE_ID =
dbo.LOOKUPS.LOOKUP_ID
WHERE     (dbo.LOOKUPS.CODE <> 'install_complete') AND (dbo.LOOKUPS.CODE <>
'invoiced') AND (dbo.LOOKUPS.CODE <> 'closed')
GO
/****** Object:  View [dbo].[SERVICE_TYPES_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[SERVICE_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'service_type ') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO
/****** Object:  View [dbo].[YES_NO_TYPES_V]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[YES_NO_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'yes_no_type') AND (type_active_flag = 'Y') AND (lookup_active_flag = 'Y')
GO
/****** Object:  View [dbo].[QUOTE_CONDITION_XJOIN]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[QUOTE_CONDITION_XJOIN]
AS
SELECT     dbo.QUOTES.QUOTE_ID, dbo.CONDITIONS.CONDITION_ID, dbo.CONDITIONS.NAME
FROM         dbo.CONDITIONS CROSS JOIN
                      dbo.QUOTES
GO
/****** Object:  View [dbo].[REPORT_TO_TYPES_V]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[REPORT_TO_TYPES_V]
AS
SELECT     TOP 100 PERCENT dbo.LOOKUPS.LOOKUP_ID, dbo.LOOKUPS.NAME, dbo.LOOKUPS.CODE, dbo.LOOKUPS.SEQUENCE_NO
FROM         dbo.LOOKUP_TYPES INNER JOIN
                      dbo.LOOKUPS ON dbo.LOOKUP_TYPES.LOOKUP_TYPE_ID = dbo.LOOKUPS.LOOKUP_TYPE_ID
WHERE     (dbo.LOOKUP_TYPES.CODE = 'report_type_type') AND (dbo.LOOKUPS.ACTIVE_FLAG <> 'N') AND (dbo.LOOKUP_TYPES.ACTIVE_FLAG <> 'N')
ORDER BY dbo.LOOKUPS.SEQUENCE_NO
GO
/****** Object:  View [dbo].[JOB_OWNER_IS_NULL_V]    Script Date: 05/03/2010 14:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[JOB_OWNER_IS_NULL_V]
AS
SELECT     JOB_ID, PROJECT_ID, JOB_NO, JOB_NAME, JOB_NO_NAME, JOB_TYPE_ID, JOB_STATUS_TYPE_ID, job_status_type_code, job_status_type_name, 
                      CUSTOMER_ID, ORGANIZATION_ID, DEALER_NAME, EXT_DEALER_ID, CUSTOMER_NAME, EXT_CUSTOMER_ID, foreman_resource_name, 
                      foreman_user_name, BILLING_USER_ID, billing_user_name, DATE_CREATED, DATE_MODIFIED
FROM         dbo.JOBS_V
WHERE     (BILLING_USER_ID IS NULL)
GO
/****** Object:  View [dbo].[ROLES_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ROLES_V]
AS
SELECT     C_USER.FIRST_NAME + ' ' + C_USER.LAST_NAME AS created_by_name, M_USER.FIRST_NAME + ' ' + M_USER.LAST_NAME AS modified_by_name, 
                      dbo.ROLES.*
FROM         dbo.ROLES LEFT OUTER JOIN
                      dbo.USERS C_USER ON dbo.ROLES.CREATED_BY = C_USER.USER_ID LEFT OUTER JOIN
                      dbo.USERS M_USER ON dbo.ROLES.MODIFIED_BY = M_USER.USER_ID
GO
/****** Object:  View [dbo].[VERSIONS_MAX_NO_V]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VERSIONS_MAX_NO_V]
AS
SELECT     dbo.PROJECTS.PROJECT_ID, dbo.PROJECTS.PROJECT_NO, dbo.REQUESTS.REQUEST_NO, MAX(dbo.REQUESTS.VERSION_NO) 
                      AS max_version_no
FROM         dbo.REQUESTS RIGHT OUTER JOIN
                      dbo.PROJECTS ON dbo.REQUESTS.PROJECT_ID = dbo.PROJECTS.PROJECT_ID
GROUP BY dbo.REQUESTS.REQUEST_NO, dbo.PROJECTS.PROJECT_ID, dbo.PROJECTS.PROJECT_NO
GO
/****** Object:  View [dbo].[SCHEDULE_TYPES_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[SCHEDULE_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'schedule_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO
/****** Object:  View [dbo].[LOOKUP_TYPES_V]    Script Date: 05/03/2010 14:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[LOOKUP_TYPES_V]
AS
SELECT     dbo.LOOKUP_TYPES.LOOKUP_TYPE_ID, dbo.LOOKUP_TYPES.CODE AS type_code, dbo.LOOKUP_TYPES.NAME AS type_name, 
                      dbo.LOOKUP_TYPES.ACTIVE_FLAG, dbo.LOOKUP_TYPES.UPDATABLE_FLAG, dbo.LOOKUP_TYPES.PARENT_TYPE_ID, 
                      dbo.LOOKUP_TYPES.DATE_CREATED AS type_date_created, dbo.LOOKUP_TYPES.CREATED_BY AS type_created_by, 
                      created_by_name.FIRST_NAME + ' ' + created_by_name.LAST_NAME AS type_created_by_name, 
                      dbo.LOOKUP_TYPES.DATE_MODIFIED AS type_date_modified, dbo.LOOKUP_TYPES.MODIFIED_BY AS type_modified_by, 
                      modified_by_name.FIRST_NAME + ' ' + modified_by_name.LAST_NAME AS type_modified_by_name
FROM         dbo.LOOKUP_TYPES LEFT OUTER JOIN
                      dbo.USERS modified_by_name ON dbo.LOOKUP_TYPES.MODIFIED_BY = modified_by_name.USER_ID LEFT OUTER JOIN
                      dbo.USERS created_by_name ON dbo.LOOKUP_TYPES.CREATED_BY = created_by_name.USER_ID
GO
/****** Object:  View [dbo].[SERVICE_LINE_TYPES_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[SERVICE_LINE_TYPES_V]
AS
SELECT     TOP 100 PERCENT dbo.LOOKUPS.LOOKUP_ID, dbo.LOOKUPS.CODE, dbo.LOOKUPS.NAME
FROM         dbo.LOOKUP_TYPES INNER JOIN
                      dbo.LOOKUPS ON dbo.LOOKUP_TYPES.LOOKUP_TYPE_ID = dbo.LOOKUPS.LOOKUP_TYPE_ID
WHERE     (dbo.LOOKUP_TYPES.CODE = 'service_line_type') AND (dbo.LOOKUPS.ACTIVE_FLAG <> 'N') AND (dbo.LOOKUP_TYPES.ACTIVE_FLAG <> 'N')
ORDER BY dbo.LOOKUPS.SEQUENCE_NO
GO
/****** Object:  View [dbo].[SERVICE_STATUS_TYPES_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[SERVICE_STATUS_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'service_status_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO
/****** Object:  View [dbo].[SUB_ACTIVITY_TYPES_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[SUB_ACTIVITY_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, lookup_date_created, 
                      lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'sub_activity_type')
GO
/****** Object:  View [dbo].[crystal_SYNCH_REPORT_V]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[crystal_SYNCH_REPORT_V]
AS
SELECT     TOP 100 PERCENT FULL_NAME, IMOBILE_LOGIN, LAST_SYNCH_DATE, LAST_LOGIN AS LAST_SERVICETRAX_LOGIN
FROM         dbo.USERS
WHERE     (LAST_SYNCH_DATE IS NOT NULL) AND (ACTIVE_FLAG = 'Y') AND (IMOBILE_LOGIN IS NOT NULL)
ORDER BY FULL_NAME
GO
/****** Object:  View [dbo].[TABS_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[TABS_V]
AS
SELECT     dbo.TEMPLATES.TEMPLATE_NAME, dbo.TABS.NAME, dbo.TABS.SEQUENCE, dbo.TABS.TYPE_CODE, dbo.TABS.DEFAULT_TAB, 
                      dbo.TABS.TABLE_ID
FROM         dbo.TABS INNER JOIN
                      dbo.TEMPLATES ON dbo.TABS.TEMPLATE_ID = dbo.TEMPLATES.TEMPLATE_ID
GO
/****** Object:  View [dbo].[TEMPLATE_LOCATIONS_1_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[TEMPLATE_LOCATIONS_1_V]
AS
SELECT     dbo.TEMPLATE_LOCATIONS.LOCATION, TEMPLATES_1.TEMPLATE_NAME, TEMPLATES1.TEMPLATE_NAME AS TAB_NAME
FROM         dbo.TEMPLATES TEMPLATES1 INNER JOIN
                      dbo.TABS INNER JOIN
                      dbo.TEMPLATE_LOCATIONS ON dbo.TABS.TAB_ID = dbo.TEMPLATE_LOCATIONS.LEVEL_1_TAB INNER JOIN
                      dbo.TEMPLATES TEMPLATES_1 ON dbo.TEMPLATE_LOCATIONS.LEVEL_1_TEMPLATE = TEMPLATES_1.TEMPLATE_ID ON 
                      TEMPLATES1.TEMPLATE_ID = dbo.TABS.TEMPLATE_ID
GO
/****** Object:  View [dbo].[TABS_V2]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[TABS_V2]
AS
SELECT DISTINCT 
                      TOP 100 PERCENT dbo.TEMPLATES.TEMPLATE_NAME, dbo.TABS.NAME, dbo.TABS.SEQUENCE, dbo.TABS.TYPE_CODE, dbo.TABS.DEFAULT_TAB, 
                      dbo.TABS.TABLE_ID, dbo.USER_ROLES.USER_ID, dbo.TABS.TAB_LEVEL, dbo.FUNCTIONS.FUNCTION_ID, dbo.FUNCTIONS.NAME AS Expr1, 
                      dbo.TEMPLATES.TEMPLATE_ID, dbo.FUNCTIONS.FUNCTION_GROUP_ID, dbo.FUNCTION_GROUPS.CODE AS FUNCTION_TYPE_CODE
FROM         dbo.ROLES INNER JOIN
                      dbo.ROLE_FUNCTION_RIGHTS ON dbo.ROLES.ROLE_ID = dbo.ROLE_FUNCTION_RIGHTS.ROLE_ID INNER JOIN
                      dbo.FUNCTIONS ON dbo.ROLE_FUNCTION_RIGHTS.FUNCTION_ID = dbo.FUNCTIONS.FUNCTION_ID INNER JOIN
                      dbo.TABS INNER JOIN
                      dbo.TEMPLATES ON dbo.TABS.TEMPLATE_ID = dbo.TEMPLATES.TEMPLATE_ID ON 
                      dbo.FUNCTIONS.TEMPLATE_ID = dbo.TEMPLATES.TEMPLATE_ID INNER JOIN
                      dbo.USER_ROLES ON dbo.ROLES.ROLE_ID = dbo.USER_ROLES.ROLE_ID INNER JOIN
                      dbo.FUNCTION_GROUPS ON dbo.FUNCTIONS.FUNCTION_GROUP_ID = dbo.FUNCTION_GROUPS.FUNCTION_GROUP_ID
WHERE     (dbo.FUNCTION_GROUPS.CODE = 'TABS')
ORDER BY dbo.TABS.TAB_LEVEL, dbo.USER_ROLES.USER_ID, dbo.TABS.SEQUENCE
GO
/****** Object:  View [dbo].[USER_ROLES_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[USER_ROLES_V]
AS
SELECT     dbo.USER_ROLES.USER_ID, dbo.USER_ROLES.ROLE_ID, dbo.ROLES.NAME AS role_name, dbo.ROLES.CODE AS role_code, 
                      dbo.USER_ROLES.DATE_CREATED, dbo.USER_ROLES.CREATED_BY, USERS_1.FIRST_NAME + ' ' + USERS_1.LAST_NAME AS created_by_name, 
                      dbo.USER_ROLES.DATE_MODIFIED, dbo.USER_ROLES.MODIFIED_BY, 
                      USERS_2.FIRST_NAME + ' ' + USERS_2.LAST_NAME AS modified_by_name
FROM         dbo.USER_ROLES INNER JOIN
                      dbo.ROLES ON dbo.USER_ROLES.ROLE_ID = dbo.ROLES.ROLE_ID LEFT OUTER JOIN
                      dbo.USERS USERS_2 ON dbo.USER_ROLES.MODIFIED_BY = USERS_2.USER_ID LEFT OUTER JOIN
                      dbo.USERS USERS_1 ON dbo.USER_ROLES.CREATED_BY = USERS_1.USER_ID
GO
/****** Object:  View [dbo].[crystal_USERS_V]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[crystal_USERS_V]
AS
SELECT     TOP 100 PERCENT dbo.USER_ROLES.ROLE_ID, dbo.USERS.USER_ID, dbo.USERS.FULL_NAME, dbo.ROLES.NAME AS Role_Name, 
                      dbo.USER_ORGANIZATIONS.ORGANIZATION_ID, dbo.USERS.ACTIVE_FLAG
FROM         dbo.USER_ORGANIZATIONS INNER JOIN
                      dbo.USERS ON dbo.USER_ORGANIZATIONS.USER_ID = dbo.USERS.USER_ID LEFT OUTER JOIN
                      dbo.USER_ROLES INNER JOIN
                      dbo.ROLES ON dbo.USER_ROLES.ROLE_ID = dbo.ROLES.ROLE_ID ON dbo.USERS.USER_ID = dbo.USER_ROLES.USER_ID
WHERE     (dbo.USERS.ACTIVE_FLAG = 'y')
ORDER BY dbo.USER_ROLES.ROLE_ID
GO
/****** Object:  View [dbo].[Pep_USER_ROLES_V]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Pep_USER_ROLES_V]
AS
SELECT     TOP 100 PERCENT dbo.USERS.USER_ID, dbo.USERS.FIRST_NAME, dbo.USERS.LAST_NAME, dbo.USERS.LOGIN, dbo.USERS.PASSWORD, 
                      dbo.USERS.PIN, dbo.USERS.ACTIVE_FLAG, dbo.ROLES.NAME
FROM         dbo.USERS INNER JOIN
                      dbo.USER_ROLES ON dbo.USERS.USER_ID = dbo.USER_ROLES.USER_ID INNER JOIN
                      dbo.ROLES ON dbo.USER_ROLES.ROLE_ID = dbo.ROLES.ROLE_ID
WHERE     (dbo.USERS.ACTIVE_FLAG = 'y')
ORDER BY dbo.USERS.LAST_NAME
GO
/****** Object:  View [dbo].[ROLE_FUNCTIONS_ALL_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ROLE_FUNCTIONS_ALL_V]
AS
SELECT     dbo.ROLES.ROLE_ID, dbo.ROLES.NAME AS role_name, dbo.FUNCTIONS.FUNCTION_ID, dbo.FUNCTIONS.NAME AS function_name, 
                      dbo.FUNCTIONS.CODE AS function_code, dbo.FUNCTIONS.DESCRIPTION AS function_desc, dbo.FUNCTIONS.FUNCTION_GROUP_ID, 
                      dbo.FUNCTION_GROUPS.CODE AS function_group_code, dbo.FUNCTION_GROUPS.NAME AS function_group_name, dbo.FUNCTIONS.TEMPLATE_ID, 
                      dbo.FUNCTIONS.SEQUENCE_NO, dbo.FUNCTIONS.IS_NAV_FUNCTION, dbo.FUNCTIONS.IS_MENU_FUNCTION, dbo.FUNCTIONS.TARGET, 
                      dbo.FUNCTIONS.DATE_CREATED AS function_date_created, dbo.FUNCTIONS.CREATED_BY AS function_created_by, 
                      dbo.FUNCTIONS.DATE_MODIFIED AS function_date_modified, dbo.FUNCTIONS.MODIFIED_BY AS function_modified_by, 
                      dbo.FUNCTIONS.TEMPLATE_LOCATION_ID, dbo.TEMPLATE_LOCATIONS.LOCATION
FROM         dbo.TEMPLATE_LOCATIONS RIGHT OUTER JOIN
                      dbo.FUNCTIONS ON dbo.TEMPLATE_LOCATIONS.TEMPLATE_LOCATION_ID = dbo.FUNCTIONS.TEMPLATE_LOCATION_ID LEFT OUTER JOIN
                      dbo.FUNCTION_GROUPS ON dbo.FUNCTIONS.FUNCTION_GROUP_ID = dbo.FUNCTION_GROUPS.FUNCTION_GROUP_ID CROSS JOIN
                      dbo.ROLES
GO
/****** Object:  View [dbo].[PKT_REASONS_V]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[PKT_REASONS_V]
AS
SELECT     dbo.LOOKUPS.LOOKUP_ID AS reason_id, SUBSTRING(dbo.LOOKUPS.NAME, 0, 20) AS reason
FROM         dbo.LOOKUPS INNER JOIN
                      dbo.LOOKUP_TYPES ON dbo.LOOKUPS.LOOKUP_TYPE_ID = dbo.LOOKUP_TYPES.LOOKUP_TYPE_ID
WHERE     (dbo.LOOKUP_TYPES.CODE = 'override_reason_type') AND (dbo.LOOKUP_TYPES.ACTIVE_FLAG = 'Y')
GO
/****** Object:  View [dbo].[billing_v]    Script Date: 05/03/2010 14:18:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* $Id: billing_v.sql 1667 2009-08-17 21:49:29Z bvonhaden $ */

CREATE VIEW [dbo].[billing_v]
AS
SELECT sl.organization_id,
       sl.service_line_id,
       CAST(sl.bill_job_id AS VARCHAR) + '-' + CAST(sl.item_id AS VARCHAR) + '-' + CAST(sl.status_id AS VARCHAR) AS job_item_status_id,
       CAST(sl.bill_service_id AS VARCHAR) + '-' + CAST(sl.item_id AS VARCHAR) + '-' + CAST(sl.status_id AS VARCHAR) AS service_item_status_id,
       CAST(sl.bill_service_id AS VARCHAR) + '-' + CAST(sl.status_id AS VARCHAR) AS bill_service_status_id,
       sl.bill_job_no,
       sl.bill_service_no,
       sl.bill_service_line_no,
       j_v.job_status_type_name,
       sl.service_line_date,
       sl.service_line_date_VARCHAR,
       sl.service_line_week,
       sl.service_line_week_VARCHAR,
       sl.status_id,
       sls.name AS status_name,
       sl.exported_flag,
       sl.billed_flag,
       sl.posted_flag,
       sl.pooled_flag,
       sl.internal_req_flag,
       sl.bill_job_id,
       sl.bill_service_id,
       sl.ph_service_id,
       sl.resource_id,
       sl.resource_name,
       sl.item_id,
       sl.item_name,
       sl.item_type_code,
       sl.invoice_id,
       i.description AS invoice_description,
       sl.posted_from_invoice_id,
       ist.status_id AS invoice_status_id,
       ist.name AS invoice_status_name,
       sl.billable_flag,
       s.taxable_flag AS service_taxable_flag,
       sl.taxable_flag,
       sl.ext_pay_code,
       sl.tc_qty,
       sl.payroll_qty,
       sl.bill_qty,
       sl.bill_rate,
       sl.bill_total,
       sl.bill_exp_qty,
       sl.bill_exp_rate,
       sl.bill_exp_total,
       sl.bill_hourly_qty,
       sl.bill_hourly_rate,
       sl.bill_hourly_total,
       s.quote_total,
       s.quote_id,
       j_v.job_name,
       j_v.billing_user_name,
       j_v.dealer_name,
       j_v.ext_dealer_id,
       j_v.customer_name,
       j_v.ext_customer_id,
       j_v.billing_user_id,
       j_v.foreman_resource_name AS supervisor_name,
       j_v.foreman_user_id AS sup_user_id,
       s.billing_type_id,
       billing_types.code AS billing_type_code,
       billing_types.name AS billing_type_name,
       s.po_no,
       s.cust_col_1,
       s.cust_col_2,
       s.cust_col_3,
       s.cust_col_4,
       s.cust_col_5,
       s.cust_col_6,
       s.cust_col_7,
       s.cust_col_8,
       s.cust_col_9,
       s.cust_col_10,
       s.est_start_date,
       s.est_end_date,
       sl.palm_rep_id,
       s.description AS service_description,
       CAST(j_v.job_no AS VARCHAR) + ' - ' + ISNULL(j_v.job_name, '') AS job_no_name2,
       CAST(s.service_no AS VARCHAR) + ' - ' + ISNULL(s.description, '') AS service_no_description2,
       sl.entered_date,
       sl.entered_by,
       sl.entry_method,
       sl.override_date,
       sl.override_by,
       sl.override_reason,
       sl.verified_date,
       sl.verified_by,
       sl.date_created,
       sl.created_by,
       sl.date_modified,
       sl.modified_by,
       ISNULL(sl.invoice_post_date, i.date_sent) AS invoiced_date,
       sl.invoice_post_date,
       ISNULL(q.quote_total, 0) quoted_total,
       ISNULL(p.is_new, 'N') is_new
  FROM dbo.service_lines sl LEFT OUTER JOIN
       dbo.services s ON sl.bill_service_id = s.service_id LEFT OUTER JOIN
       dbo.jobs_v j_v ON sl.bill_job_id = j_v.job_id LEFT OUTER JOIN
       dbo.invoices i ON sl.invoice_id = i.invoice_id LEFT OUTER JOIN
       dbo.invoice_statuses ist ON i.status_id = ist.status_id LEFT OUTER JOIN
       dbo.lookups billing_types on s.billing_type_id = billing_types.lookup_id LEFT OUTER JOIN
       dbo.service_line_statuses sls ON sl.status_id = sls.status_id LEFT OUTER JOIN
       dbo.quotes q ON s.quote_id = q.quote_id LEFT OUTER JOIN
       dbo.projects p ON j_v.project_id = p.project_id
 WHERE sl.status_id > 3
   AND sl.internal_req_flag = 'N'
GO

/****** Object:  View [dbo].[JOBS_READY_TO_BILL_V]    Script Date: 05/03/2010 14:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[JOBS_READY_TO_BILL_V]
AS
SELECT     dbo.BILLING_V.ORGANIZATION_ID, dbo.BILLING_V.BILL_JOB_NO, dbo.BILLING_V.BILL_JOB_ID, dbo.BILLING_V.job_status_type_name, dbo.BILLING_V.job_name,
                      dbo.BILLING_V.BILLING_USER_ID, dbo.BILLING_V.EXT_DEALER_ID, dbo.BILLING_V.DEALER_NAME, dbo.BILLING_V.CUSTOMER_NAME,
                      dbo.BILLING_V.billing_user_name, MAX(dbo.SERVICES.EST_END_DATE) AS max_est_end_date, convert(varchar(12), MAX(dbo.SERVICES.EST_END_DATE), 101) max_est_end_date_varchar,
                      SUM(CASE billable_flag WHEN 'Y' THEN bill_total ELSE 0 END) billable_total, SUM(CASE billable_flag WHEN 'N' THEN bill_total ELSE 0 END)
                      non_billable_total
FROM         dbo.BILLING_V INNER JOIN
                      dbo.SERVICES ON dbo.BILLING_V.BILL_SERVICE_ID = dbo.SERVICES.SERVICE_ID
WHERE     (dbo.BILLING_V.invoice_status_id = 1 OR
                      dbo.BILLING_V.invoice_status_id IS NULL)  and status_id = 4
GROUP BY dbo.BILLING_V.ORGANIZATION_ID, dbo.BILLING_V.BILL_JOB_ID, dbo.BILLING_V.BILL_JOB_NO, dbo.BILLING_V.BILLING_USER_ID,
                      dbo.BILLING_V.DEALER_NAME, dbo.BILLING_V.EXT_DEALER_ID, dbo.BILLING_V.CUSTOMER_NAME, dbo.BILLING_V.billing_user_name,
                      dbo.BILLING_V.job_status_type_name, dbo.BILLING_V.job_name
GO

/****** Object:  View [dbo].[crystal_UNBILLED_OPS_V]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[crystal_UNBILLED_OPS_V]
AS
SELECT     dbo.BILLING_V.ORGANIZATION_ID, dbo.BILLING_V.BILL_JOB_NO, dbo.BILLING_V.BILL_JOB_ID, dbo.BILLING_V.job_status_type_name, dbo.BILLING_V.job_name,
                      dbo.BILLING_V.BILLING_USER_ID, dbo.BILLING_V.EXT_DEALER_ID, dbo.BILLING_V.DEALER_NAME, dbo.BILLING_V.CUSTOMER_NAME,
                      cast(dbo.BILLING_V.billing_user_name as varchar) as job_owner, MAX(dbo.SERVICES.EST_END_DATE) AS max_est_end_date, convert(varchar(12), MAX(dbo.SERVICES.EST_END_DATE), 101) max_est_end_date_varchar,
                      SUM(CASE billable_flag WHEN 'Y' THEN bill_total ELSE 0 END) billable_total, SUM(CASE billable_flag WHEN 'N' THEN bill_total ELSE 0 END)
                      non_billable_total, dbo.SERVICES.PO_NO
FROM         dbo.BILLING_V INNER JOIN
                      dbo.SERVICES ON dbo.BILLING_V.BILL_SERVICE_ID = dbo.SERVICES.SERVICE_ID
WHERE     (dbo.BILLING_V.invoice_status_id = 1 OR
                      dbo.BILLING_V.invoice_status_id IS NULL)  and status_id = 4
GROUP BY dbo.BILLING_V.ORGANIZATION_ID, dbo.BILLING_V.BILL_JOB_ID, dbo.BILLING_V.BILL_JOB_NO, dbo.BILLING_V.BILLING_USER_ID,
                      dbo.BILLING_V.DEALER_NAME, dbo.BILLING_V.EXT_DEALER_ID, dbo.BILLING_V.CUSTOMER_NAME, dbo.BILLING_V.billing_user_name,
                      dbo.BILLING_V.job_status_type_name, dbo.BILLING_V.job_name, dbo.SERVICES.PO_NO
GO

/****** Object:  View [dbo].[invoices_extranet_v]    Script Date: 05/03/2010 14:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[invoices_extranet_v]
AS
SELECT TOP 100 PERCENT     
       p.project_id, 
       p.project_no,
       p.job_name,        
       p.project_status_type_id, 
       project_status_type.code project_status_type_code, 
       project_status_type.name project_status_type_name, 
       c.organization_id, 
       CASE WHEN customer_type.code = 'end_user' THEN c.end_user_parent_id ELSE c.customer_id END customer_id, 
       CASE WHEN customer_type.code = 'end_user' THEN (SELECT customer_name FROM customers WHERE customer_id = c.end_user_parent_id) ELSE c.customer_name END customer_name,
       CASE WHEN customer_type.code = 'end_user' THEN c.customer_name ELSE eu.customer_name END end_user_name, 
       CASE WHEN customer_type.code = 'dealer' THEN ISNULL(c.ext_customer_id, c.ext_dealer_id) ELSE c.ext_dealer_id END ext_dealer_id,
       c.dealer_name,
       c.ext_customer_id,   
       j.job_id, 
       j.job_no,      
       i.invoice_id, 
       i.status_id, 
       i.description, 
       i.date_sent as invoiced_date, 
       i.po_no, 
       ist.name AS invoice_status_name, 
       i_total_v.extended_price AS invoice_total,  
       MIN(DISTINCT sl_1.SERVICE_LINE_DATE) AS min_start_date, 
       MAX(DISTINCT sl_1.SERVICE_LINE_DATE) AS max_end_date, 
       invoice_type.name AS invoice_type_name
  FROM dbo.projects p INNER JOIN
       dbo.lookups project_status_type ON p.project_status_type_id = project_status_type.lookup_id INNER JOIN
       dbo.customers c ON p.customer_id = c.customer_id INNER JOIN
       dbo.lookups customer_type ON c.customer_type_id = customer_type.lookup_id LEFT OUTER JOIN
       dbo.customers eu ON p.end_user_id = eu.customer_id LEFT OUTER JOIN
       dbo.jobs j ON p.project_id = j.project_id LEFT OUTER JOIN       
       dbo.invoices i ON j.job_id = i.job_id LEFT OUTER JOIN
       dbo.lookups invoice_type ON i.invoice_type_id = invoice_type.lookup_id LEFT OUTER JOIN
       dbo.invoice_statuses ist ON i.status_id = ist.status_id LEFT OUTER JOIN
       dbo.service_lines sl_1 ON i.invoice_id = sl_1.invoice_id LEFT OUTER JOIN 
       (SELECT TOP 100 PERCENT 
               dbo.INVOICES.INVOICE_ID, 
               SUM(ISNULL(dbo.INVOICE_LINES.UNIT_PRICE, 0) * ISNULL(dbo.INVOICE_LINES.QTY, 0)) AS extended_price
          FROM dbo.LOOKUPS RIGHT OUTER JOIN
               dbo.INVOICE_LINES ON dbo.LOOKUPS.LOOKUP_ID = dbo.INVOICE_LINES.INVOICE_LINE_TYPE_ID RIGHT OUTER JOIN
               dbo.INVOICES ON dbo.INVOICE_LINES.INVOICE_ID = dbo.INVOICES.INVOICE_ID
      GROUP BY dbo.INVOICES.JOB_ID, 
               dbo.INVOICES.INVOICE_ID, 
               dbo.LOOKUPS.CODE
       ) i_total_v ON i.invoice_id = i_total_v.invoice_id
GROUP BY p.project_id, 
         p.project_no,
         p.job_name,
         p.project_status_type_id, 
         project_status_type.code,
         project_status_type.name,
         c.organization_id, 
         c.customer_id, 
         c.ext_dealer_id, 
         c.dealer_name,
         c.ext_customer_id, 
         c.customer_name, 
         c.parent_customer_id,
         j.job_id,
         j.job_no, 
         i.invoice_id, 
         i.status_id, 
         i.description, 
         i.date_sent,
         i.po_no, 
         ist.name,
         i_total_v.extended_price, 
         invoice_type.name,
         customer_type.code,
         c.end_user_parent_id,
         eu.customer_name
GO
/****** Object:  View [dbo].[jobs_with_costs_v]    Script Date: 05/03/2010 14:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[jobs_with_costs_v] AS 
SELECT TOP 100 PERCENT o.organization_id, 
       o.name AS [Organization Name], 
       j.job_no AS [Job No],	
       job_type.name AS [Job Type], 
       CASE WHEN customer_type.code = 'end_user' THEN (SELECT customer_name FROM customers WHERE customer_id = cust.end_user_parent_id) ELSE cust.customer_name END AS [Customer Name], 
       CASE WHEN customer_type.code = 'end_user' THEN cust.customer_name ELSE eu.customer_name END AS [End User Name], 
       u.first_name + ' ' + u.last_name AS [Job Owner], 
       inv.invoice_id AS [Invoice No], 
       inv.date_sent AS [Invoiced Date], 
       r.name AS [Job Supervisor], 
       c.contact_name AS [SP Sales], 
       SUM(ISNULL(il.extended_price, 0)) AS [Total Invoiced],
       (SELECT ISNULL(SUM(sl.tc_qty * ISNULL(i.cost_per_uom, 0)), 0)
          FROM service_lines sl INNER JOIN
               items i ON sl.item_id = i.item_id
         WHERE sl.invoice_id = inv.invoice_id 
           AND sl.tc_job_id = j.job_id 
           AND sl.item_type_code = 'hours' 
           AND i.name NOT LIKE 'TRUCK%' 
           AND (i.name NOT LIKE 'sub%' OR i.name LIKE 'sub%exp%')) AS [Labor Cost],
       (SELECT ISNULL(SUM(sl.tc_qty * ISNULL(i.cost_per_uom, 0)), 0)
          FROM service_lines sl INNER JOIN
               items i ON sl.item_id = i.item_id
         WHERE sl.invoice_id = inv.invoice_id 
           AND sl.tc_job_id = j.job_id 
           AND sl.item_type_code = 'hours' 
           AND i.name LIKE 'TRUCK%') AS [Truck Cost ],
       (SELECT ISNULL(SUM(sl.tc_qty * ISNULL(i.cost_per_uom, 0)), 0)
          FROM service_lines sl INNER JOIN
               items i ON sl.item_id = i.item_id
         WHERE sl.invoice_id = inv.invoice_id 
           AND sl.tc_job_id = j.job_id 
           AND sl.item_type_code = 'hours' 
           AND i.name LIKE 'SUB-%' 
           AND i.name NOT LIKE 'SUB%EXP%') AS [Sub Cost ],
        (SELECT ISNULL(SUM(CASE WHEN sl.entry_method = 'great plains' THEN sl.expense_total
                ELSE (sl.tc_qty * i.cost_per_uom) END), 0)
          FROM service_lines sl INNER JOIN
               items i ON sl.item_id = i.item_id
         WHERE sl.invoice_id = inv.invoice_id 
           AND sl.tc_job_id = j.job_id 
           AND sl.item_type_code = 'expense') AS [Expense Cost]
  FROM dbo.jobs j INNER JOIN 
       dbo.lookups job_type ON j.job_type_id=job_type.lookup_id INNER JOIN 
       dbo.invoices inv ON j.job_id = inv.job_id LEFT OUTER JOIN
       dbo.invoice_lines il ON inv.invoice_id = il.invoice_id INNER JOIN
       dbo.customers cust ON j.customer_id = cust.customer_id INNER JOIN
       dbo.lookups customer_type ON cust.customer_type_id = customer_type.lookup_id INNER JOIN 
       dbo.organizations o ON cust.organization_id = o.organization_id LEFT OUTER JOIN
       dbo.resources r ON j.foreman_resource_id = r.resource_id LEFT OUTER JOIN
       dbo.users u ON j.billing_user_id = u.user_id LEFT OUTER JOIN
       dbo.contacts c ON j.a_m_sales_contact_id = c.contact_id LEFT OUTER JOIN
       dbo.customers eu ON j.end_user_id = eu.customer_id
GROUP BY o.organization_id, 
         o.name, 
         j.job_no, 
         job_type.name,
         u.first_name + ' ' + u.last_name, 
	 inv.invoice_id, 
         inv.date_sent, 
         r.name, 
         c.contact_name, 
         j.job_id,
         cust.end_user_parent_id,
	 customer_type.code,
	 cust.customer_name,
         eu.customer_name
ORDER BY o.name, 
         j.job_no
GO
/****** Object:  View [dbo].[crystal_INVOICES_NOT_SENT_V]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[crystal_INVOICES_NOT_SENT_V]
AS
SELECT     dbo.INVOICES.INVOICE_ID, dbo.INVOICES.ORGANIZATION_ID, dbo.JOBS.JOB_NO, dbo.JOBS.JOB_NAME, dbo.INVOICES.PO_NO, 
                      dbo.INVOICES.EXT_BATCH_ID, dbo.INVOICES.BATCH_STATUS_ID, dbo.INVOICES.STATUS_ID, dbo.INVOICES.DESCRIPTION, 
                      dbo.INVOICE_LINES.ITEM_ID, dbo.INVOICE_LINES.INVOICE_LINE_NO, dbo.INVOICE_LINES.DESCRIPTION AS LINE_DESCRIPTION, 
                      dbo.INVOICE_LINES.UNIT_PRICE, dbo.INVOICE_LINES.QTY, dbo.INVOICE_LINES.EXTENDED_PRICE, dbo.INVOICE_LINES.PO_NO AS LINE_PO, 
                      dbo.INVOICES.ASSIGNED_TO_USER_ID, dbo.JOBS.A_M_SALES_CONTACT_ID, dbo.CONTACTS.CONTACT_NAME, dbo.CUSTOMERS.CUSTOMER_NAME, 
                      dbo.JOB_LOCATIONS.JOB_LOCATION_NAME, dbo.JOB_LOCATIONS.STREET1, dbo.JOB_LOCATIONS.STREET2, dbo.JOB_LOCATIONS.CITY, 
                      dbo.JOB_LOCATIONS.STATE, dbo.JOB_LOCATIONS.ZIP, dbo.INVOICES.EXT_BILL_CUST_ID, dbo.INVOICES.DATE_CREATED
FROM         dbo.INVOICES INNER JOIN
                      dbo.INVOICE_LINES ON dbo.INVOICES.INVOICE_ID = dbo.INVOICE_LINES.INVOICE_ID INNER JOIN
                      dbo.JOBS ON dbo.INVOICES.JOB_ID = dbo.JOBS.JOB_ID INNER JOIN
                      dbo.CONTACTS ON dbo.JOBS.A_M_SALES_CONTACT_ID = dbo.CONTACTS.CONTACT_ID INNER JOIN
                      dbo.CUSTOMERS ON dbo.INVOICES.BILL_CUSTOMER_ID = dbo.CUSTOMERS.CUSTOMER_ID INNER JOIN
                      dbo.SERVICES ON dbo.JOBS.JOB_ID = dbo.SERVICES.JOB_ID INNER JOIN
                      dbo.JOB_LOCATIONS ON dbo.SERVICES.JOB_LOCATION_ID = dbo.JOB_LOCATIONS.JOB_LOCATION_ID AND 
                      dbo.SERVICES.JOB_LOCATION_ID = dbo.JOB_LOCATIONS.JOB_LOCATION_ID
WHERE     (dbo.INVOICES.STATUS_ID = 1) OR
                      (dbo.INVOICES.STATUS_ID = 2) OR
                      (dbo.INVOICES.STATUS_ID = 3)
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[55] 4[17] 2[10] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "INVOICES"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 250
               Right = 255
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "INVOICE_LINES"
            Begin Extent = 
               Top = 203
               Left = 606
               Bottom = 428
               Right = 803
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "JOBS"
            Begin Extent = 
               Top = 392
               Left = 311
               Bottom = 500
               Right = 536
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CONTACTS"
            Begin Extent = 
               Top = 6
               Left = 630
               Bottom = 114
               Right = 829
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CUSTOMERS"
            Begin Extent = 
               Top = 11
               Left = 368
               Bottom = 119
               Right = 609
            End
            DisplayFlags = 280
            TopColumn = 16
         End
         Begin Table = "SERVICES"
            Begin Extent = 
               Top = 268
               Left = 0
               Bottom = 436
               Right = 224
            End
            DisplayFlags = 280
            TopColumn = 4
         End
         Begin Table = "JOB_LOCATIONS"
            Begin Extent = 
               Top = 236
               Left = 322
               Bottom = 344
               Right = 571
            End
            Displ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'crystal_INVOICES_NOT_SENT_V'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'ayFlags = 280
            TopColumn = 7
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 29
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1485
         Width = 1500
         Width = 1980
         Width = 840
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1605
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'crystal_INVOICES_NOT_SENT_V'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'crystal_INVOICES_NOT_SENT_V'
GO
/****** Object:  View [dbo].[INVOICE_COST_CODES_LINE_V]    Script Date: 05/03/2010 14:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[INVOICE_COST_CODES_LINE_V]
AS
SELECT     TOP 100 PERCENT dbo.INVOICES.INVOICE_ID, dbo.LOOKUPS.CODE AS cost_to_cust, LOOKUPS_1.CODE AS cost_to_vend, 
                      LOOKUPS_2.CODE AS cost_to_job, LOOKUPS_3.CODE AS warehouse_fee, dbo.SERVICES.SERVICE_ID, dbo.REQUESTS.D_SALES_REP_CONTACT_ID, 
                      dbo.CONTACTS.CONTACT_NAME AS sales_rep_name
FROM         dbo.INVOICES INNER JOIN
                      dbo.INVOICE_LINES ON dbo.INVOICES.INVOICE_ID = dbo.INVOICE_LINES.INVOICE_ID INNER JOIN
                      dbo.SERV_INV_LINES ON dbo.INVOICE_LINES.INVOICE_LINE_ID = dbo.SERV_INV_LINES.INVOICE_LINE_ID INNER JOIN
                      dbo.SERVICE_LINES ON dbo.SERV_INV_LINES.SERVICE_LINE_ID = dbo.SERVICE_LINES.SERVICE_LINE_ID INNER JOIN
                      dbo.SERVICES ON dbo.SERVICE_LINES.BILL_SERVICE_ID = dbo.SERVICES.SERVICE_ID INNER JOIN
                      dbo.REQUESTS ON dbo.SERVICES.REQUEST_ID = dbo.REQUESTS.REQUEST_ID INNER JOIN
                      dbo.LOOKUPS ON dbo.REQUESTS.COST_TO_CUST_TYPE_ID = dbo.LOOKUPS.LOOKUP_ID INNER JOIN
                      dbo.LOOKUPS LOOKUPS_1 ON dbo.REQUESTS.COST_TO_VEND_TYPE_ID = LOOKUPS_1.LOOKUP_ID INNER JOIN
                      dbo.LOOKUPS LOOKUPS_2 ON dbo.REQUESTS.COST_TO_JOB_TYPE_ID = LOOKUPS_2.LOOKUP_ID INNER JOIN
                      dbo.LOOKUPS LOOKUPS_3 ON dbo.REQUESTS.WAREHOUSE_FEE_TYPE_ID = LOOKUPS_3.LOOKUP_ID LEFT OUTER JOIN
                      dbo.CONTACTS ON dbo.REQUESTS.D_SALES_REP_CONTACT_ID = dbo.CONTACTS.CONTACT_ID
GROUP BY dbo.INVOICES.INVOICE_ID, dbo.LOOKUPS.CODE, LOOKUPS_1.CODE, LOOKUPS_2.CODE, LOOKUPS_3.CODE, dbo.SERVICES.SERVICE_ID, 
                      dbo.REQUESTS.D_SALES_REP_CONTACT_ID, dbo.CONTACTS.CONTACT_NAME
HAVING      (dbo.LOOKUPS.CODE = 'Y') OR
                      (LOOKUPS_1.CODE = 'Y') OR
                      (LOOKUPS_2.CODE = 'Y') OR
                      (LOOKUPS_3.CODE = 'Y')
ORDER BY dbo.INVOICES.INVOICE_ID
GO
/****** Object:  View [dbo].[INVOICE_COST_CODES_JOB_V]    Script Date: 05/03/2010 14:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[INVOICE_COST_CODES_JOB_V]
AS
SELECT     TOP 100 PERCENT dbo.INVOICES.INVOICE_ID, dbo.LOOKUPS.CODE AS cost_to_cust, LOOKUPS_1.CODE AS cost_to_vend, 
                      LOOKUPS_2.CODE AS cost_to_job, LOOKUPS_3.CODE AS warehouse_fee, dbo.REQUESTS.D_SALES_REP_CONTACT_ID, 
                      dbo.CONTACTS.CONTACT_NAME AS sales_rep_name, dbo.REQUESTS.DATE_CREATED
FROM         dbo.JOBS INNER JOIN
                      dbo.INVOICES ON dbo.JOBS.JOB_ID = dbo.INVOICES.JOB_ID INNER JOIN
                      dbo.PROJECTS ON dbo.JOBS.PROJECT_ID = dbo.PROJECTS.PROJECT_ID INNER JOIN
                      dbo.LOOKUPS INNER JOIN
                      dbo.REQUESTS ON dbo.LOOKUPS.LOOKUP_ID = dbo.REQUESTS.COST_TO_CUST_TYPE_ID INNER JOIN
                      dbo.LOOKUPS LOOKUPS_1 ON dbo.REQUESTS.COST_TO_VEND_TYPE_ID = LOOKUPS_1.LOOKUP_ID INNER JOIN
                      dbo.LOOKUPS LOOKUPS_2 ON dbo.REQUESTS.COST_TO_JOB_TYPE_ID = LOOKUPS_2.LOOKUP_ID INNER JOIN
                      dbo.LOOKUPS LOOKUPS_3 ON dbo.REQUESTS.WAREHOUSE_FEE_TYPE_ID = LOOKUPS_3.LOOKUP_ID ON 
                      dbo.PROJECTS.PROJECT_ID = dbo.REQUESTS.PROJECT_ID LEFT OUTER JOIN
                      dbo.CONTACTS ON dbo.REQUESTS.D_SALES_REP_CONTACT_ID = dbo.CONTACTS.CONTACT_ID
ORDER BY dbo.INVOICES.INVOICE_ID
GO
/****** Object:  View [dbo].[INVOICE_JOB_LOCATIONS_V]    Script Date: 05/03/2010 14:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[INVOICE_JOB_LOCATIONS_V]
AS
SELECT     *, '' AS Addr1, '' AS Addr2, '' AS Addr3, '' AS City, '' AS State, '' AS Zip
FROM         dbo.INVOICES
GO
/****** Object:  View [dbo].[invoices_arch]    Script Date: 05/03/2010 14:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[invoices_arch]
AS
SELECT     INVOICE_ID, ORGANIZATION_ID, PO_NO, INVOICE_TYPE_ID, BILLING_TYPE_ID, EXT_BATCH_ID, BATCH_STATUS_ID, ASSIGNED_TO_USER_ID, 
                      INVOICE_FORMAT_TYPE_ID, EXT_INVOICE_ID, STATUS_ID, JOB_ID, DESCRIPTION, GP_DESCRIPTION, COST_CODES, START_DATE, END_DATE, 
                      BILL_CUSTOMER_ID, EXT_BILL_CUST_ID, SALES_REPS, DATE_SENT, DATE_CREATED, CREATED_BY, DATE_MODIFIED, MODIFIED_BY
FROM         dbo.INVOICES
WHERE     (BATCH_STATUS_ID = 3) AND (DATE_MODIFIED < CONVERT(DATETIME, '2002-09-01 00:00:00', 102))
GO
/****** Object:  View [dbo].[invoice_lines_v]    Script Date: 05/03/2010 14:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[invoice_lines_v]
AS
SELECT i.organization_id, 
       i.invoice_id, 
       i.job_id, 
       i.status_id, 
       i.description header_desc, 
       i.ext_bill_cust_id, 
       i.date_sent, 
       il.invoice_line_no, 
       il.item_id, 
       il.description line_desc, 
       il.unit_price, 
       il.qty, 
       il.extended_price, 
       il.invoice_line_id,
       il.po_no as line_po_no, 
       il.taxable_flag,
       il.bill_service_id,
       item.name, 
       invoice_type.lookup_id, 
       invoice_type.code invoice_type_code, 
       invoice_type.name invoice_type_name, 
       invoice_line_type.code invoice_line_type_code, 
       invoice_line_type.name invoice_line_type_name, 
       RTRIM(ISNULL(item.ext_item_id, 'NA')) ext_item_id, 
       item.item_type_id, 
       item_type.code item_type_code, 
       item_type.name item_type_name
  FROM dbo.invoice_lines il INNER JOIN
       dbo.lookups invoice_line_type ON il.invoice_line_type_id = invoice_line_type.lookup_id INNER JOIN
       dbo.invoices i ON il.invoice_id = i.invoice_id LEFT OUTER JOIN 
       dbo.lookups invoice_type ON i.invoice_type_id = invoice_type.lookup_id LEFT OUTER JOIN
       dbo.items item ON il.item_id = item.item_id LEFT OUTER JOIN
       dbo.lookups item_type ON item.item_type_id = item_type.lookup_id
GO
/****** Object:  View [dbo].[VAR_INV_DATE_V]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VAR_INV_DATE_V]
AS
SELECT     TOP 100 PERCENT dbo.JOBS.JOB_ID, SUM(ISNULL(dbo.INVOICE_LINES.UNIT_PRICE, 0) * ISNULL(dbo.INVOICE_LINES.QTY, 0)) AS sum_inv, 
                      dbo.INVOICES.DATE_SENT AS date_sent
FROM         dbo.JOBS RIGHT OUTER JOIN
                      dbo.INVOICE_LINES RIGHT OUTER JOIN
                      dbo.INVOICES ON dbo.INVOICE_LINES.INVOICE_ID = dbo.INVOICES.INVOICE_ID ON dbo.JOBS.JOB_ID = dbo.INVOICES.JOB_ID
WHERE     (dbo.INVOICES.STATUS_ID > 3)
GROUP BY dbo.JOBS.JOB_ID, dbo.INVOICES.DATE_SENT
HAVING      (SUM(ISNULL(dbo.INVOICE_LINES.UNIT_PRICE, 0) * ISNULL(dbo.INVOICE_LINES.QTY, 0)) > 0)
ORDER BY dbo.JOBS.JOB_ID
GO
/****** Object:  View [dbo].[contains_invoice_tracking_v]    Script Date: 05/03/2010 14:18:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[contains_invoice_tracking_v]
AS
SELECT i.invoice_id, 
       CASE inv_tracking.trk WHEN '*' THEN '*' ELSE '' END AS contains_tracking
  FROM dbo.INVOICES i LEFT OUTER JOIN
       (SELECT DISTINCT invoice_id, '*' trk
          FROM invoice_tracking) inv_tracking ON i.invoice_id = inv_tracking.invoice_id
GO
/****** Object:  View [dbo].[bill_jobs_v]    Script Date: 05/03/2010 14:18:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[bill_jobs_v]
AS
SELECT j.billing_user_id, 
       sl.bill_job_no, 
       sl.bill_job_id, 
       CASE WHEN customer_type.code = 'end_user' THEN eu_parent.customer_name ELSE c.customer_name END customer_name,
       CASE WHEN customer_type.code = 'end_user' THEN c.customer_name ELSE eu.customer_name END end_user_name,
       c.ext_dealer_id, 
       u.first_name + ' ' + u.last_name AS billing_user_name, 
       jl.name AS job_status_type_name, 
       j.job_name, 
       sl.organization_id, 
       CONVERT(varchar, MAX(s.est_end_date), 1) AS max_est_end_date_varchar,	
       SUM(CASE WHEN sl.billable_flag = 'Y'THEN sl.bill_total ELSE 0 END) billable_total, 
       SUM(CASE WHEN sl.billable_flag = 'N' THEN sl.bill_total ELSE 0 END) non_billable_total,
       (SELECT ISNULL(SUM(il.extended_price),0) 
	      FROM invoices i inner join invoice_lines il ON i.invoice_id = il.invoice_id
	     WHERE i.job_id = sl.bill_job_id) AS  invoiced_total,
       (SELECT COUNT(po.po_id) FROM purchase_orders po INNER JOIN 
                                    requests r ON po.request_id=r.request_id
         WHERE r.project_id=j.project_id) po_count,
       (SELECT COUNT(po.po_id) FROM purchase_orders po INNER JOIN 
                                    requests r ON po.request_id=r.request_id INNER JOIN
                                    lookups l ON po.po_status_id=l.lookup_id
         WHERE r.project_id=j.project_id AND l.code = 'received') received_po_count
  FROM dbo.service_lines sl INNER JOIN
       dbo.services s ON sl.bill_service_id = s.service_id INNER JOIN 
       dbo.jobs j ON sl.bill_job_id = j.job_id INNER JOIN 
       dbo.customers c ON j.customer_id = c.customer_id INNER JOIN 
       dbo.lookups jl ON j.job_status_type_id = jl.lookup_id INNER JOIN
       dbo.lookups customer_type ON c.customer_type_id = customer_type.lookup_id LEFT OUTER JOIN
       dbo.customers eu ON j.end_user_id = eu.customer_id LEFT OUTER JOIN 
       dbo.invoices i ON sl.invoice_id = i.invoice_id LEFT OUTER JOIN 
       dbo.users u ON j.billing_user_id = u.user_id LEFT OUTER JOIN 
       dbo.customers eu_parent ON c.end_user_parent_id = eu_parent.customer_id
 WHERE sl.status_id = 4
   AND sl.internal_req_flag = 'N'
   AND (i.status_id = 1 OR i.status_id IS NULL) 
GROUP BY j.billing_user_id, 
         sl.bill_job_no, 
         sl.bill_job_id, 
         CASE WHEN customer_type.code = 'end_user' THEN eu_parent.customer_name ELSE c.customer_name END,
         CASE WHEN customer_type.code = 'end_user' THEN c.customer_name ELSE eu.customer_name END,
         u.first_name, 
         u.last_name, 
         jl.name, 
         j.job_name, 
         sl.organization_id, 
         c.ext_dealer_id,
         j.project_id
GO

/****** Object:  View [dbo].[crystal_UNBILLED_OPS_V2]    Script Date: 05/03/2010 14:18:06 ******/
-- SET ANSI_NULLS ON
-- GO
-- SET QUOTED_IDENTIFIER ON
-- GO
-- CREATE VIEW [dbo].[crystal_UNBILLED_OPS_V2]
-- AS
-- SELECT     TOP 100 PERCENT billing_user_id, bill_job_no, bill_job_id, non_billable_total, billable_total, dealer_name, customer_name,
--                       max_est_end_date_varchar, billing_user_name, job_status_type_name, job_name, organization_id
-- FROM         dbo.BILL_JOBS_V
-- WHERE     (organization_id = 2) AND (job_status_type_name = 'invoiced')
-- GO

/****** Object:  View [dbo].[BILLING_V_DAILYREPORTCAPTURE]    Script Date: 05/03/2010 14:18:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[BILLING_V_DAILYREPORTCAPTURE]
AS
SELECT     dbo.SERVICE_LINES.ORGANIZATION_ID, dbo.SERVICE_LINES.SERVICE_LINE_ID, CAST(dbo.SERVICE_LINES.BILL_JOB_ID AS varchar) 
                      + '-' + CAST(dbo.SERVICE_LINES.ITEM_ID AS varchar) + '-' + CAST(dbo.SERVICE_LINES.STATUS_ID AS varchar) AS job_item_status_id, 
                      CAST(dbo.SERVICE_LINES.BILL_SERVICE_ID AS varchar) + '-' + CAST(dbo.SERVICE_LINES.ITEM_ID AS varchar) 
                      + '-' + CAST(dbo.SERVICE_LINES.STATUS_ID AS varchar) AS service_item_status_id, CAST(dbo.SERVICE_LINES.BILL_SERVICE_ID AS varchar) 
                      + '-' + CAST(dbo.SERVICE_LINES.STATUS_ID AS varchar) AS bill_service_status_id, dbo.SERVICE_LINES.BILL_JOB_NO, 
                      dbo.SERVICE_LINES.BILL_SERVICE_NO, dbo.SERVICE_LINES.BILL_SERVICE_LINE_NO, dbo.JOBS_V.job_status_type_name, 
                      dbo.SERVICE_LINES.SERVICE_LINE_DATE, dbo.SERVICE_LINES.SERVICE_LINE_DATE_VARCHAR, dbo.SERVICE_LINES.SERVICE_LINE_WEEK, 
                      dbo.SERVICE_LINES.SERVICE_LINE_WEEK_VARCHAR, dbo.SERVICE_LINES.STATUS_ID, dbo.SERVICE_LINE_STATUSES.NAME AS status_name, 
                      dbo.SERVICE_LINES.EXPORTED_FLAG, dbo.SERVICE_LINES.BILLED_FLAG, dbo.SERVICE_LINES.POSTED_FLAG, 
                      dbo.SERVICE_LINES.POOLED_FLAG, dbo.SERVICE_LINES.INTERNAL_REQ_FLAG, dbo.SERVICE_LINES.BILL_JOB_ID, 
                      dbo.SERVICE_LINES.BILL_SERVICE_ID, dbo.SERVICE_LINES.PH_SERVICE_ID, dbo.SERVICE_LINES.RESOURCE_ID, 
                      dbo.SERVICE_LINES.RESOURCE_NAME, dbo.SERVICE_LINES.ITEM_ID, dbo.SERVICE_LINES.ITEM_NAME, dbo.SERVICE_LINES.ITEM_TYPE_CODE, 
                      dbo.SERVICE_LINES.INVOICE_ID, dbo.INVOICES.DESCRIPTION AS invoice_description, dbo.SERVICE_LINES.POSTED_FROM_INVOICE_ID, 
                      dbo.INVOICE_STATUSES.STATUS_ID AS invoice_status_id, dbo.INVOICE_STATUSES.NAME AS invoice_status_name, 
                      dbo.SERVICE_LINES.BILLABLE_FLAG, dbo.SERVICES.TAXABLE_FLAG AS service_taxable_flag, dbo.SERVICE_LINES.TAXABLE_FLAG, 
                      dbo.SERVICE_LINES.EXT_PAY_CODE, dbo.SERVICE_LINES.TC_QTY, dbo.SERVICE_LINES.PAYROLL_QTY, dbo.SERVICE_LINES.BILL_QTY, 
                      dbo.SERVICE_LINES.BILL_RATE, dbo.SERVICE_LINES.BILL_TOTAL, dbo.SERVICE_LINES.BILL_EXP_QTY, dbo.SERVICE_LINES.BILL_EXP_RATE, 
                      dbo.SERVICE_LINES.BILL_EXP_TOTAL, dbo.SERVICE_LINES.BILL_HOURLY_QTY, dbo.SERVICE_LINES.BILL_HOURLY_RATE, 
                      dbo.SERVICE_LINES.BILL_HOURLY_TOTAL, dbo.SERVICES.QUOTE_TOTAL, dbo.SERVICES.QUOTE_ID, dbo.JOBS_V.JOB_NAME, 
                      dbo.JOBS_V.billing_user_name, dbo.JOBS_V.DEALER_NAME, dbo.JOBS_V.EXT_DEALER_ID, dbo.JOBS_V.CUSTOMER_NAME, 
                      dbo.JOBS_V.EXT_CUSTOMER_ID, dbo.JOBS_V.BILLING_USER_ID, dbo.JOBS_V.foreman_resource_name AS supervisor_name, 
                      dbo.JOBS_V.foreman_user_id AS sup_user_id, dbo.SERVICES.BILLING_TYPE_ID, BILLING_TYPES.CODE AS billing_type_code, 
                      BILLING_TYPES.NAME AS billing_type_name, dbo.SERVICES.PO_NO, dbo.SERVICES.CUST_COL_1, dbo.SERVICES.CUST_COL_2, 
                      dbo.SERVICES.CUST_COL_3, dbo.SERVICES.CUST_COL_4, dbo.SERVICES.CUST_COL_5, dbo.SERVICES.CUST_COL_6, dbo.SERVICES.CUST_COL_7, 
                      dbo.SERVICES.CUST_COL_8, dbo.SERVICES.CUST_COL_9, dbo.SERVICES.CUST_COL_10, dbo.SERVICES.EST_START_DATE, 
                      dbo.SERVICES.EST_END_DATE, dbo.SERVICE_LINES.PALM_REP_ID, dbo.SERVICES.DESCRIPTION AS SERVICE_DESCRIPTION, 
                      CAST(dbo.JOBS_V.JOB_NO AS varchar) + ' - ' + ISNULL(dbo.JOBS_V.JOB_NAME, '') AS job_no_name2, CAST(dbo.SERVICES.SERVICE_NO AS varchar) 
                      + ' - ' + ISNULL(dbo.SERVICES.DESCRIPTION, '') AS service_no_description2, dbo.SERVICE_LINES.ENTERED_DATE, 
                      dbo.SERVICE_LINES.ENTERED_BY, dbo.SERVICE_LINES.ENTRY_METHOD, dbo.SERVICE_LINES.OVERRIDE_DATE, 
                      dbo.SERVICE_LINES.OVERRIDE_BY, dbo.SERVICE_LINES.OVERRIDE_REASON, dbo.SERVICE_LINES.VERIFIED_DATE, 
                      dbo.SERVICE_LINES.VERIFIED_BY, dbo.SERVICE_LINES.DATE_CREATED, dbo.SERVICE_LINES.CREATED_BY, dbo.SERVICE_LINES.DATE_MODIFIED, 
                      dbo.SERVICE_LINES.MODIFIED_BY
FROM         dbo.SERVICES LEFT OUTER JOIN
                      dbo.LOOKUPS BILLING_TYPES ON dbo.SERVICES.BILLING_TYPE_ID = BILLING_TYPES.LOOKUP_ID RIGHT OUTER JOIN
                      dbo.SERVICE_LINE_STATUSES RIGHT OUTER JOIN
                      dbo.INVOICE_STATUSES RIGHT OUTER JOIN
                      dbo.INVOICES ON dbo.INVOICE_STATUSES.STATUS_ID = dbo.INVOICES.STATUS_ID RIGHT OUTER JOIN
                      dbo.SERVICE_LINES LEFT OUTER JOIN
                      dbo.JOBS_V ON dbo.SERVICE_LINES.BILL_JOB_ID = dbo.JOBS_V.JOB_ID ON dbo.INVOICES.INVOICE_ID = dbo.SERVICE_LINES.INVOICE_ID ON 
                      dbo.SERVICE_LINE_STATUSES.STATUS_ID = dbo.SERVICE_LINES.STATUS_ID ON 
                      dbo.SERVICES.SERVICE_ID = dbo.SERVICE_LINES.BILL_SERVICE_ID
WHERE  (SERVICE_LINES.STATUS_ID > 3)
GO
/****** Object:  View [dbo].[FINANCE_REPORT1_V]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[FINANCE_REPORT1_V]
AS
SELECT     dbo.INVOICES.INVOICE_ID, dbo.INVOICES.ORGANIZATION_ID, dbo.INVOICES.PO_NO, dbo.INVOICES.STATUS_ID, dbo.INVOICES.JOB_ID, 
                      dbo.JOBS.JOB_NO, dbo.JOBS.JOB_NAME, dbo.INVOICES.BILL_CUSTOMER_ID, dbo.CUSTOMERS.CUSTOMER_NAME, 
                      dbo.SERVICE_LINES.TC_SERVICE_NO AS Rec, dbo.INVOICE_LINES.INVOICE_LINE_TYPE_ID, dbo.INVOICE_LINES.DESCRIPTION, 
                      dbo.INVOICE_LINES.UNIT_PRICE, dbo.INVOICE_LINES.QTY, dbo.INVOICE_LINES.EXTENDED_PRICE
FROM         dbo.INVOICES INNER JOIN
                      dbo.JOBS ON dbo.INVOICES.JOB_ID = dbo.JOBS.JOB_ID INNER JOIN
                      dbo.CUSTOMERS ON dbo.INVOICES.BILL_CUSTOMER_ID = dbo.CUSTOMERS.CUSTOMER_ID INNER JOIN
                      dbo.INVOICE_LINES ON dbo.INVOICES.INVOICE_ID = dbo.INVOICE_LINES.INVOICE_ID FULL OUTER JOIN
                      dbo.SERVICE_LINES ON dbo.INVOICES.INVOICE_ID = dbo.SERVICE_LINES.INVOICE_ID
WHERE     (dbo.INVOICES.ORGANIZATION_ID = 11)
GO
/****** Object:  View [dbo].[INVOICE_TOTALS_V]    Script Date: 05/03/2010 14:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[INVOICE_TOTALS_V]
AS
SELECT     TOP 100 PERCENT dbo.INVOICES.JOB_ID, dbo.INVOICES.INVOICE_ID, SUM(ISNULL(dbo.INVOICE_LINES.UNIT_PRICE, 0) 
                      * ISNULL(dbo.INVOICE_LINES.QTY, 0)) AS extended_price, 
                      (CASE WHEN dbo.LOOKUPS.CODE = 'custom' THEN (SUM(ISNULL(dbo.INVOICE_LINES.UNIT_PRICE, 0) * ISNULL(dbo.INVOICE_LINES.QTY, 0))) 
                      ELSE 0 END) custom_total
FROM         dbo.LOOKUPS RIGHT OUTER JOIN
                      dbo.INVOICE_LINES ON dbo.LOOKUPS.LOOKUP_ID = dbo.INVOICE_LINES.INVOICE_LINE_TYPE_ID RIGHT OUTER JOIN
                      dbo.INVOICES ON dbo.INVOICE_LINES.INVOICE_ID = dbo.INVOICES.INVOICE_ID
GROUP BY dbo.INVOICES.JOB_ID, dbo.INVOICES.INVOICE_ID, dbo.LOOKUPS.CODE
ORDER BY dbo.INVOICES.JOB_ID, dbo.INVOICES.INVOICE_ID
GO
/****** Object:  View [dbo].[crystal_QUOTES_OTHER_SERVICE_V]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[crystal_QUOTES_OTHER_SERVICE_V]
AS
SELECT     QUOTE_ID, SPECIFY_SERVICE, BILL, DATE_CREATED
FROM         dbo.QUOTE_SPECIFY_OTHER_SERVICES
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "QUOTE_SPECIFY_OTHER_SERVICES"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 258
               Right = 377
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 2385
         Width = 1815
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'crystal_QUOTES_OTHER_SERVICE_V'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'crystal_QUOTES_OTHER_SERVICE_V'
GO
/****** Object:  View [dbo].[TEMPLATE_LOCATIONS_4_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[TEMPLATE_LOCATIONS_4_V]
AS
SELECT     dbo.TEMPLATE_LOCATIONS.LOCATION, TEMPLATES_1.TEMPLATE_NAME, TEMPLATES1.TEMPLATE_NAME AS TAB_NAME, dbo.TABS.TYPE_CODE, 
                      dbo.TABS.TAB_LEVEL
FROM         dbo.TABS INNER JOIN
                      dbo.TEMPLATES TEMPLATES1 ON dbo.TABS.TEMPLATE_ID = TEMPLATES1.TEMPLATE_ID INNER JOIN
                      dbo.TEMPLATES TEMPLATES_1 INNER JOIN
                      dbo.TEMPLATE_LOCATIONS ON TEMPLATES_1.TEMPLATE_ID = dbo.TEMPLATE_LOCATIONS.LEVEL_3_TEMPLATE ON 
                      dbo.TABS.TAB_ID = dbo.TEMPLATE_LOCATIONS.LEVEL_3_TAB
WHERE     (dbo.TABS.TYPE_CODE = 'JOB_BILL')
GO
/****** Object:  View [dbo].[TEMPLATE_LOCATIONS_3_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[TEMPLATE_LOCATIONS_3_V]
AS
SELECT     dbo.TEMPLATE_LOCATIONS.LOCATION, TEMPLATES_1.TEMPLATE_NAME, TEMPLATES1.TEMPLATE_NAME AS TAB_NAME
FROM         dbo.TABS INNER JOIN
                      dbo.TEMPLATES TEMPLATES1 ON dbo.TABS.TEMPLATE_ID = TEMPLATES1.TEMPLATE_ID INNER JOIN
                      dbo.TEMPLATES TEMPLATES_1 INNER JOIN
                      dbo.TEMPLATE_LOCATIONS ON TEMPLATES_1.TEMPLATE_ID = dbo.TEMPLATE_LOCATIONS.LEVEL_3_TEMPLATE ON 
                      dbo.TABS.TAB_ID = dbo.TEMPLATE_LOCATIONS.LEVEL_3_TAB
	WHERE	(dbo.TABS.TYPE_CODE = 'SERVICE')
GO
/****** Object:  View [dbo].[TIME_CAPTURE_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[TIME_CAPTURE_V]
AS
SELECT dbo.SERVICE_LINES.ORGANIZATION_ID, 
       dbo.SERVICE_LINES.TC_JOB_NO, 
       dbo.SERVICE_LINES.TC_SERVICE_NO, 
       dbo.SERVICE_LINES.TC_SERVICE_LINE_NO, 
       dbo.SERVICE_LINES.BILL_JOB_NO, 
       dbo.SERVICE_LINES.BILL_SERVICE_NO, 
       dbo.SERVICE_LINES.BILL_SERVICE_LINE_NO, 
       dbo.JOBS_V.JOB_NAME, 
       dbo.SERVICE_LINES.RESOURCE_NAME, 
       dbo.SERVICE_LINES.ITEM_NAME, 
       dbo.JOBS_V.billing_user_name, 
       dbo.JOBS_V.foreman_resource_name, 
       dbo.SERVICE_LINES.TC_JOB_ID, 
       dbo.SERVICE_LINES.TC_SERVICE_ID, 
       dbo.SERVICE_LINES.BILL_JOB_ID, 
       dbo.SERVICE_LINES.BILL_SERVICE_ID, 
       dbo.SERVICE_LINES.PH_SERVICE_ID, 
       dbo.SERVICE_LINES.SERVICE_LINE_ID, 
       CAST(dbo.SERVICES.JOB_ID AS varchar) + '-' + CAST(dbo.SERVICE_LINES.ITEM_ID AS varchar) + '-' + CAST(dbo.SERVICE_LINES.STATUS_ID AS varchar) AS job_item_status_id, 
       CAST(dbo.SERVICE_LINES.TC_SERVICE_ID AS varchar) + '-' + CAST(dbo.SERVICE_LINES.STATUS_ID AS varchar) AS service_status_id, 
       CAST(dbo.SERVICES.SERVICE_ID AS varchar) + '-' + CAST(dbo.SERVICE_LINES.ITEM_ID AS varchar) + '-' + CAST(dbo.SERVICE_LINES.STATUS_ID AS varchar) AS service_item_status_id, 
       dbo.JOBS_V.BILLING_USER_ID, 
       dbo.JOBS_V.foreman_user_id, 
       dbo.SERVICE_LINES.SERVICE_LINE_DATE, 
       dbo.SERVICE_LINES.SERVICE_LINE_DATE_VARCHAR, 
       dbo.SERVICE_LINES.SERVICE_LINE_WEEK, 
       dbo.SERVICE_LINES.SERVICE_LINE_WEEK_VARCHAR, 
       dbo.JOBS_V.job_status_type_code, 
       dbo.JOBS_V.job_status_type_name, 
       SERV_STATUS_TYPES.CODE AS serv_status_type_code, 
       SERV_STATUS_TYPES.NAME AS serv_status_type_name, 
       dbo.SERVICE_LINES.STATUS_ID, 
       dbo.SERVICE_LINE_STATUSES.NAME AS status_name, 
       dbo.SERVICE_LINE_STATUSES.CODE AS status_code, 
       dbo.SERVICE_LINES.EXPORTED_FLAG, 
       dbo.SERVICE_LINES.BILLED_FLAG, 
       dbo.SERVICE_LINES.POSTED_FLAG, 
       dbo.SERVICE_LINES.POOLED_FLAG, 
       dbo.SERVICE_LINES.RESOURCE_ID, 
       dbo.SERVICE_LINES.ITEM_ID, 
       dbo.SERVICE_LINES.ITEM_TYPE_CODE, 
       dbo.SERVICE_LINES.BILLABLE_FLAG, 
       dbo.SERVICE_LINES.TC_QTY, 
       dbo.SERVICE_LINES.TC_RATE, 
       dbo.SERVICE_LINES.tc_total, 
       dbo.SERVICE_LINES.PAYROLL_QTY, 
       dbo.SERVICE_LINES.PAYROLL_RATE, 
       dbo.SERVICE_LINES.payroll_total, 
       dbo.SERVICE_LINES.EXT_PAY_CODE, 
       dbo.SERVICE_LINES.EXPENSE_QTY, 
       dbo.SERVICE_LINES.EXPENSE_RATE, 
       dbo.SERVICE_LINES.expense_total, 
       dbo.SERVICE_LINES.BILL_QTY, 
       dbo.SERVICE_LINES.BILL_RATE, 
       dbo.SERVICE_LINES.bill_total, 
       dbo.SERVICE_LINES.BILL_EXP_QTY, 
       dbo.SERVICE_LINES.BILL_EXP_RATE, 
       dbo.SERVICE_LINES.bill_exp_total, 
       dbo.SERVICE_LINES.BILL_HOURLY_QTY, 
       dbo.SERVICE_LINES.BILL_HOURLY_RATE, 
       dbo.SERVICE_LINES.bill_hourly_total, 
       dbo.SERVICE_LINES.ALLOCATED_QTY, 
       dbo.SERVICE_LINES.INTERNAL_REQ_FLAG, 
       dbo.SERVICE_LINES.PARTIALLY_ALLOCATED_FLAG, 
       dbo.SERVICE_LINES.FULLY_ALLOCATED_FLAG, 
       dbo.SERVICE_LINES.PALM_REP_ID, 
       dbo.SERVICE_LINES.ENTERED_DATE, 
       dbo.SERVICE_LINES.ENTERED_BY, 
       USERS_1.FULL_NAME AS entered_by_name, 
       dbo.SERVICE_LINES.ENTRY_METHOD, 
       dbo.SERVICE_LINES.OVERRIDE_DATE, 
       dbo.SERVICE_LINES.OVERRIDE_BY, 
       USERS_1.FULL_NAME AS override_by_name, 
       dbo.SERVICE_LINES.OVERRIDE_REASON, 
       dbo.SERVICE_LINES.VERIFIED_DATE, 
       dbo.SERVICE_LINES.VERIFIED_BY, 
       USERS_2.FULL_NAME AS verified_by_name, 
       dbo.SERVICES.DESCRIPTION AS service_description, 
       dbo.SERVICE_LINES.DATE_CREATED, 
       dbo.SERVICE_LINES.CREATED_BY, 
       USERS_3.FULL_NAME AS created_by_name, 
       dbo.SERVICE_LINES.DATE_MODIFIED, 
       dbo.SERVICE_LINES.MODIFIED_BY, 
       USERS_4.FULL_NAME AS modified_by_name,
       dbo.SERVICES.service_no
  FROM dbo.LOOKUPS SERV_STATUS_TYPES RIGHT OUTER JOIN
       dbo.JOBS_V RIGHT OUTER JOIN
       dbo.SERVICES ON dbo.JOBS_V.JOB_ID = dbo.SERVICES.JOB_ID ON SERV_STATUS_TYPES.LOOKUP_ID = dbo.SERVICES.SERV_STATUS_TYPE_ID RIGHT OUTER JOIN
       dbo.SERVICE_LINE_STATUSES RIGHT OUTER JOIN
       dbo.USERS USERS_4 RIGHT OUTER JOIN
       dbo.USERS USERS_5 RIGHT OUTER JOIN
       dbo.USERS USERS_1 RIGHT OUTER JOIN
       dbo.SERVICE_LINES ON USERS_1.USER_ID = dbo.SERVICE_LINES.OVERRIDE_BY ON USERS_5.USER_ID = dbo.SERVICE_LINES.ENTERED_BY LEFT OUTER JOIN
       dbo.USERS USERS_2 ON dbo.SERVICE_LINES.VERIFIED_BY = USERS_2.USER_ID ON USERS_4.USER_ID = dbo.SERVICE_LINES.MODIFIED_BY LEFT OUTER JOIN
       dbo.USERS USERS_3 ON dbo.SERVICE_LINES.CREATED_BY = USERS_3.USER_ID ON dbo.SERVICE_LINE_STATUSES.STATUS_ID = dbo.SERVICE_LINES.STATUS_ID ON dbo.SERVICES.SERVICE_ID = dbo.SERVICE_LINES.TC_SERVICE_ID
GO

/****** Object:  View [dbo].[crystal_VAR_TIME_EXP_V]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[crystal_VAR_TIME_EXP_V]
AS
SELECT     TOP 100 PERCENT TC_JOB_ID AS job_id, SUM(ISNULL(TC_QTY * BILL_RATE, 0)) AS sum_time_exp, SUM(ISNULL(PAYROLL_QTY * BILL_RATE, 0))
                      AS sum_time, SUM(ISNULL(EXPENSE_QTY * BILL_RATE, 0)) AS sum_exp
FROM         dbo.TIME_CAPTURE_V
GROUP BY TC_JOB_ID, PH_SERVICE_ID
HAVING      (PH_SERVICE_ID IS NULL)
ORDER BY TC_JOB_ID
GO

/****** Object:  View [dbo].[crystal_AIA_REQUESTS_V]    Script Date: 05/03/2010 14:18:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[crystal_AIA_REQUESTS_V]
AS
SELECT     dbo.PROJECTS_V.ORGANIZATION_ID, dbo.PROJECTS_V.PROJECT_ID, dbo.PROJECTS_V.PROJECT_NO, dbo.PROJECTS_V.JOB_NAME, 
                      dbo.PROJECTS_V.project_status_type_name, dbo.JOBS.JOB_STATUS_TYPE_ID, JOB_STATUS_TYPE.CODE AS job_status_type_code, 
                      JOB_STATUS_TYPE.NAME AS job_status_type_name, dbo.JOBS.JOB_NO, dbo.SERVICES.SERVICE_NO, dbo.REQUESTS.DEALER_PO_NO, 
                      dbo.PROJECTS_V.CUSTOMER_NAME, dbo.REQUESTS.DESCRIPTION, CONTACTS_1.CONTACT_NAME AS sales_rep_name, 
                      CONTACTS_2.CONTACT_NAME AS sales_sup_name, CONTACTS_3.CONTACT_NAME AS project_mgr_name, 
                      CONTACTS_4.CONTACT_NAME AS a_m_name, MIN(dbo.REQUESTS.EST_START_DATE) AS EST_START, MAX(dbo.REQUESTS.EST_END_DATE) 
                      AS EST_END, dbo.SERVICES.DATE_CREATED, dbo.SERVICES.DATE_MODIFIED, dbo.SERVICES.ACT_START_DATE, 
                      dbo.SERVICES.SCH_START_DATE
FROM         dbo.LOOKUPS JOB_STATUS_TYPE RIGHT OUTER JOIN
                      dbo.CONTACTS CONTACTS_1 RIGHT OUTER JOIN
                      dbo.CONTACTS CONTACTS_2 RIGHT OUTER JOIN
                      dbo.CONTACTS CONTACTS_3 RIGHT OUTER JOIN
                      dbo.CONTACTS CONTACTS_4 RIGHT OUTER JOIN
                      dbo.REQUESTS ON CONTACTS_4.CONTACT_ID = dbo.REQUESTS.A_M_CONTACT_ID ON 
                      CONTACTS_3.CONTACT_ID = dbo.REQUESTS.D_PROJ_MGR_CONTACT_ID ON 
                      CONTACTS_2.CONTACT_ID = dbo.REQUESTS.D_SALES_SUP_CONTACT_ID ON 
                      CONTACTS_1.CONTACT_ID = dbo.REQUESTS.D_SALES_REP_CONTACT_ID RIGHT OUTER JOIN
                      dbo.JOBS RIGHT OUTER JOIN
                      dbo.SERVICES ON dbo.JOBS.JOB_ID = dbo.SERVICES.JOB_ID ON dbo.REQUESTS.REQUEST_ID = dbo.SERVICES.REQUEST_ID ON 
                      JOB_STATUS_TYPE.LOOKUP_ID = dbo.JOBS.JOB_STATUS_TYPE_ID RIGHT OUTER JOIN
                      dbo.PROJECTS_V ON dbo.JOBS.PROJECT_ID = dbo.PROJECTS_V.PROJECT_ID
GROUP BY dbo.PROJECTS_V.PROJECT_ID, dbo.JOBS.JOB_STATUS_TYPE_ID, dbo.PROJECTS_V.PROJECT_NO, dbo.PROJECTS_V.CUSTOMER_NAME, 
                      dbo.PROJECTS_V.JOB_NAME, dbo.PROJECTS_V.project_status_type_name, JOB_STATUS_TYPE.CODE, JOB_STATUS_TYPE.NAME, 
                      dbo.PROJECTS_V.ORGANIZATION_ID, dbo.JOBS.JOB_NO, dbo.SERVICES.SERVICE_NO, dbo.REQUESTS.DEALER_PO_NO, 
                      dbo.REQUESTS.DESCRIPTION, CONTACTS_1.CONTACT_NAME, CONTACTS_2.CONTACT_NAME, CONTACTS_3.CONTACT_NAME, 
                      CONTACTS_4.CONTACT_NAME, dbo.SERVICES.DATE_CREATED, dbo.SERVICES.DATE_MODIFIED, dbo.SERVICES.ACT_START_DATE, 
                      dbo.SERVICES.SCH_START_DATE
HAVING      (dbo.JOBS.JOB_STATUS_TYPE_ID < 117) AND (dbo.PROJECTS_V.ORGANIZATION_ID = 8)
GO
/****** Object:  View [dbo].[crystal_TARGET_REPORT1_V]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[crystal_TARGET_REPORT1_V]
AS
SELECT     TOP (100) PERCENT dbo.SERVICE_LINES.BILL_JOB_NO AS JOB_NO, dbo.SERVICE_LINES.BILL_SERVICE_NO AS Req, 
                      dbo.SERVICE_LINES.SERVICE_LINE_DATE, dbo.SERVICE_LINES.RESOURCE_NAME, dbo.SERVICE_LINES.ITEM_NAME, 
                      dbo.SERVICE_LINES.BILL_QTY, dbo.SERVICES.DESCRIPTION, dbo.SERVICE_LINES.BILL_RATE, dbo.SERVICE_LINES.bill_total, 
                      dbo.SERVICE_LINES.ORGANIZATION_ID, dbo.SERVICES.CUST_COL_6
FROM         dbo.SERVICE_LINES INNER JOIN
                      dbo.SERVICES ON dbo.SERVICE_LINES.TC_SERVICE_ID = dbo.SERVICES.SERVICE_ID
WHERE     (dbo.SERVICE_LINES.RESOURCE_NAME IS NOT NULL) AND (dbo.SERVICE_LINES.BILL_JOB_NO = 1091700) OR
                      (dbo.SERVICE_LINES.BILL_JOB_NO = 991700)
ORDER BY dbo.SERVICE_LINES.RESOURCE_NAME
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "SERVICE_LINES"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 276
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SERVICES"
            Begin Extent = 
               Top = 114
               Left = 38
               Bottom = 222
               Right = 262
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'crystal_TARGET_REPORT1_V'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'crystal_TARGET_REPORT1_V'
GO
/****** Object:  View [dbo].[JC_JOB_COSTS_V]    Script Date: 05/03/2010 14:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[JC_JOB_COSTS_V]
AS
SELECT     TOP (100) PERCENT dbo.ORGANIZATIONS.NAME AS [Organization Name], dbo.JOBS.JOB_NO AS [Job No], dbo.SERVICE_LINES.BILL_SERVICE_NO, 
                      dbo.SERVICE_LINES.BILL_SERVICE_LINE_NO, dbo.JOBS.JOB_NAME AS [Job Name], dbo.CUSTOMERS.DEALER_NAME AS [Dealer Name], 
                      dbo.USERS.FIRST_NAME + ' ' + dbo.USERS.LAST_NAME AS [Job Owner], dbo.SERVICE_LINES.SERVICE_LINE_DATE AS [Service Line Date ], 
                      dbo.RESOURCES.NAME AS [Job Supervisor], dbo.ITEMS.NAME AS [Item Name], item_types.CODE AS [Item Type Code], 
                      SUM(dbo.SERVICE_LINES.BILL_QTY) AS Qty, dbo.SERVICE_LINES.BILL_RATE AS Rate, 
                      SUM(dbo.SERVICE_LINES.BILL_QTY * dbo.SERVICE_LINES.BILL_RATE) AS Total, dbo.ITEMS.COST_PER_UOM AS [Cost Per Unit], 
                      SUM(dbo.ITEMS.COST_PER_UOM * dbo.SERVICE_LINES.BILL_QTY) AS [Total Cost], dbo.SERVICE_LINES.SERVICE_LINE_DATE AS [Report Date], 
                      dbo.SERVICE_LINE_STATUSES.CODE, dbo.SERVICE_LINES.BILLED_FLAG, dbo.SERVICE_LINES.POSTED_FLAG, dbo.SERVICE_LINES.POOLED_FLAG, 
                      dbo.SERVICE_LINES.BILLABLE_FLAG, dbo.SERVICES.INTERNAL_REQ_FLAG, dbo.SERVICES.PO_NO
FROM         dbo.JOBS INNER JOIN
                      dbo.SERVICES ON dbo.JOBS.JOB_ID = dbo.SERVICES.JOB_ID INNER JOIN
                      dbo.SERVICE_LINES ON dbo.SERVICE_LINES.BILL_SERVICE_ID = dbo.SERVICES.SERVICE_ID INNER JOIN
                      dbo.ITEMS ON dbo.SERVICE_LINES.ITEM_ID = dbo.ITEMS.ITEM_ID INNER JOIN
                      dbo.CUSTOMERS ON dbo.JOBS.CUSTOMER_ID = dbo.CUSTOMERS.CUSTOMER_ID INNER JOIN
                      dbo.ORGANIZATIONS ON dbo.CUSTOMERS.ORGANIZATION_ID = dbo.ORGANIZATIONS.ORGANIZATION_ID INNER JOIN
                      dbo.SERVICE_LINE_STATUSES ON dbo.SERVICE_LINES.STATUS_ID = dbo.SERVICE_LINE_STATUSES.STATUS_ID LEFT OUTER JOIN
                      dbo.RESOURCES ON dbo.JOBS.FOREMAN_RESOURCE_ID = dbo.RESOURCES.RESOURCE_ID LEFT OUTER JOIN
                      dbo.USERS ON dbo.JOBS.BILLING_USER_ID = dbo.USERS.USER_ID INNER JOIN
                      dbo.LOOKUPS AS item_types ON dbo.ITEMS.ITEM_TYPE_ID = item_types.LOOKUP_ID
GROUP BY dbo.ORGANIZATIONS.NAME, dbo.JOBS.JOB_NO, dbo.JOBS.JOB_NAME, dbo.CUSTOMERS.DEALER_NAME, 
                      dbo.USERS.FIRST_NAME + ' ' + dbo.USERS.LAST_NAME, dbo.RESOURCES.NAME, dbo.ITEMS.NAME, dbo.ITEMS.COST_PER_UOM, 
                      dbo.SERVICE_LINES.SERVICE_LINE_DATE, dbo.SERVICE_LINES.BILL_RATE, dbo.SERVICE_LINE_STATUSES.CODE, item_types.CODE, 
                      dbo.SERVICE_LINES.BILLED_FLAG, dbo.SERVICE_LINES.POSTED_FLAG, dbo.SERVICE_LINES.POOLED_FLAG, dbo.SERVICE_LINES.BILLABLE_FLAG, 
                      dbo.SERVICE_LINES.BILL_SERVICE_NO, dbo.SERVICE_LINES.BILL_SERVICE_LINE_NO, dbo.SERVICES.INTERNAL_REQ_FLAG, 
                      dbo.SERVICES.PO_NO
HAVING      (dbo.SERVICE_LINE_STATUSES.CODE = 'Submitted') AND (dbo.SERVICE_LINES.SERVICE_LINE_DATE > CONVERT(DATETIME, '2008-01-01 00:00:00', 
                      102)) AND (dbo.SERVICE_LINES.POSTED_FLAG = 'N') AND (dbo.SERVICE_LINES.BILLABLE_FLAG = 'y') AND 
                      (dbo.SERVICES.INTERNAL_REQ_FLAG = 'n')
ORDER BY [Organization Name], [Job No], [Service Line Date ]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "JOBS"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 279
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SERVICES"
            Begin Extent = 
               Top = 23
               Left = 335
               Bottom = 259
               Right = 632
            End
            DisplayFlags = 280
            TopColumn = 12
         End
         Begin Table = "SERVICE_LINES"
            Begin Extent = 
               Top = 222
               Left = 38
               Bottom = 330
               Right = 292
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ITEMS"
            Begin Extent = 
               Top = 330
               Left = 38
               Bottom = 438
               Right = 256
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CUSTOMERS"
            Begin Extent = 
               Top = 438
               Left = 38
               Bottom = 546
               Right = 295
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ORGANIZATIONS"
            Begin Extent = 
               Top = 546
               Left = 38
               Bottom = 654
               Right = 279
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SERVICE_LINE_STATUSES"
            Begin Extent = 
               Top = 330
               Left = 294
               Bottom = 423
               Right = 461
            End
       ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'JC_JOB_COSTS_V'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'     DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "RESOURCES"
            Begin Extent = 
               Top = 654
               Left = 38
               Bottom = 762
               Right = 260
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "USERS"
            Begin Extent = 
               Top = 762
               Left = 38
               Bottom = 870
               Right = 247
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "item_types"
            Begin Extent = 
               Top = 870
               Left = 38
               Bottom = 978
               Right = 236
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 25
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'JC_JOB_COSTS_V'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'JC_JOB_COSTS_V'
GO
/****** Object:  View [dbo].[crystal_dashboard_REQUESTS_V]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[crystal_dashboard_REQUESTS_V]
AS
SELECT     dbo.REQUESTS.REQUEST_ID, dbo.REQUESTS.REQUEST_NO, dbo.REQUESTS.VERSION_NO, dbo.VERSIONS_MAX_NO_V.max_version_no, 
                      dbo.REQUESTS.REQUEST_TYPE_ID, REQUEST_TYPE.CODE AS request_type_code, REQUEST_TYPE.NAME AS request_type_name, 
                      dbo.REQUESTS.REQUEST_STATUS_TYPE_ID, REQUEST_STATUS_TYPE.CODE AS request_status_type_code, 
                      REQUEST_STATUS_TYPE.NAME AS request_status_type_name, dbo.REQUESTS.PROJECT_ID, dbo.SERVICES.SERVICE_ID, 
                      dbo.SERVICES.SERV_STATUS_TYPE_ID, SERV_STATUS_TYPE.CODE AS serv_status_type_code, 
                      SERV_STATUS_TYPE.NAME AS serv_status_type_name, dbo.REQUESTS.DEALER_CUST_ID, dbo.REQUESTS.ACCOUNT_TYPE_ID, 
                      ACCOUNT_TYPE.CODE AS account_type_code, ACCOUNT_TYPE.NAME AS account_type_name, dbo.REQUESTS.QUOTE_TYPE_ID, 
                      QUOTE_TYPE.CODE AS quote_type_code, QUOTE_TYPE.NAME AS quote_type_name, dbo.REQUESTS.QUOTE_NEEDED_BY, 
                      dbo.REQUESTS.EST_START_DATE, CONVERT(varchar(12), dbo.REQUESTS.EST_START_DATE, 101) AS est_start_date_varchar, 
                      dbo.REQUESTS.EST_START_TIME, dbo.REQUESTS.DATE_CREATED, dbo.REQUESTS.CREATED_BY, dbo.REQUESTS.DATE_MODIFIED, 
                      dbo.REQUESTS.MODIFIED_BY, dbo.PROJECTS_V.PROJECT_NO, CONVERT(varchar, dbo.PROJECTS_V.PROJECT_NO) + '-' + CONVERT(varchar, 
                      dbo.REQUESTS.REQUEST_NO) AS project_request_no, dbo.PROJECTS_V.CUSTOMER_ID, CUSTOMERS_1.PARENT_CUSTOMER_ID, 
                      CUSTOMERS_1.EXT_DEALER_ID, CUSTOMERS_1.DEALER_NAME, CUSTOMERS_1.EXT_CUSTOMER_ID, CUSTOMERS_1.CUSTOMER_NAME, 
                      dbo.PROJECTS_V.JOB_NAME, dbo.REQUESTS.IS_SENT, dbo.REQUESTS.IS_QUOTED, dbo.REQUESTS.QUOTE_REQUEST_ID, 
                      dbo.REQUESTS.REQUEST_NO AS record_seq_no, USERS_1.FIRST_NAME + ' ' + USERS_1.LAST_NAME AS created_by_name, 
                      USERS_2.FIRST_NAME + ' ' + USERS_2.LAST_NAME AS modified_by_name, A_M_CONTACT.CONTACT_NAME AS a_m_contact_name, 
                      dbo.PROJECTS_V.PROJECT_STATUS_TYPE_ID, dbo.PROJECTS_V.project_status_type_code, dbo.PROJECTS_V.project_status_type_name, 
                      CONVERT(varchar(12), dbo.REQUESTS.DATE_CREATED, 101) AS date_created_varchar, dbo.ORGANIZATIONS.NAME AS Org_name, 
                      dbo.ORGANIZATIONS.CODE AS Org_code, dbo.PROJECTS_V.ORGANIZATION_ID
FROM         dbo.LOOKUPS REQUEST_TYPE RIGHT OUTER JOIN
                      dbo.LOOKUPS ACCOUNT_TYPE RIGHT OUTER JOIN
                      dbo.REQUESTS ON ACCOUNT_TYPE.LOOKUP_ID = dbo.REQUESTS.ACCOUNT_TYPE_ID LEFT OUTER JOIN
                      dbo.LOOKUPS QUOTE_TYPE ON dbo.REQUESTS.QUOTE_TYPE_ID = QUOTE_TYPE.LOOKUP_ID FULL OUTER JOIN
                      dbo.PROJECTS_V FULL OUTER JOIN
                      dbo.CONTACTS A_M_CONTACT INNER JOIN
                      dbo.USERS USERS_2 INNER JOIN
                      dbo.USERS USERS_1 INNER JOIN
                      dbo.ORGANIZATIONS ON USERS_1.USER_ID = dbo.ORGANIZATIONS.CREATED_BY AND USERS_1.USER_ID = dbo.ORGANIZATIONS.MODIFIED_BY ON
                       USERS_2.USER_ID = dbo.ORGANIZATIONS.CREATED_BY AND USERS_2.USER_ID = dbo.ORGANIZATIONS.MODIFIED_BY INNER JOIN
                      dbo.CUSTOMERS CUSTOMERS_1 ON dbo.ORGANIZATIONS.ORGANIZATION_ID = CUSTOMERS_1.ORGANIZATION_ID ON 
                      A_M_CONTACT.ORGANIZATION_ID = dbo.ORGANIZATIONS.ORGANIZATION_ID ON 
                      dbo.PROJECTS_V.ORGANIZATION_ID = dbo.ORGANIZATIONS.ORGANIZATION_ID AND 
                      dbo.PROJECTS_V.CUSTOMER_ID = CUSTOMERS_1.CUSTOMER_ID ON dbo.REQUESTS.MODIFIED_BY = USERS_2.USER_ID AND 
                      dbo.REQUESTS.CREATED_BY = USERS_1.USER_ID AND dbo.REQUESTS.A_M_CONTACT_ID = A_M_CONTACT.CONTACT_ID AND 
                      dbo.REQUESTS.PROJECT_ID = dbo.PROJECTS_V.PROJECT_ID LEFT OUTER JOIN
                      dbo.LOOKUPS REQUEST_STATUS_TYPE ON dbo.REQUESTS.REQUEST_STATUS_TYPE_ID = REQUEST_STATUS_TYPE.LOOKUP_ID ON 
                      REQUEST_TYPE.LOOKUP_ID = dbo.REQUESTS.REQUEST_TYPE_ID LEFT OUTER JOIN
                      dbo.VERSIONS_MAX_NO_V ON dbo.REQUESTS.PROJECT_ID = dbo.VERSIONS_MAX_NO_V.PROJECT_ID AND 
                      dbo.REQUESTS.REQUEST_NO = dbo.VERSIONS_MAX_NO_V.REQUEST_NO LEFT OUTER JOIN
                      dbo.JOB_LOCATIONS ON dbo.REQUESTS.JOB_LOCATION_ID = dbo.JOB_LOCATIONS.JOB_LOCATION_ID FULL OUTER JOIN
                      dbo.SERVICES ON dbo.REQUESTS.REQUEST_ID = dbo.SERVICES.REQUEST_ID FULL OUTER JOIN
                      dbo.LOOKUPS SERV_STATUS_TYPE ON dbo.SERVICES.SERV_STATUS_TYPE_ID = SERV_STATUS_TYPE.LOOKUP_ID
GO
/****** Object:  View [dbo].[REQUESTS_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  VIEW [dbo].[REQUESTS_V]
AS
SELECT     dbo.REQUESTS.REQUEST_ID, dbo.REQUESTS.REQUEST_NO, dbo.REQUESTS.VERSION_NO, dbo.VERSIONS_MAX_NO_V.max_version_no, 
                      dbo.REQUESTS.REQUEST_TYPE_ID, REQUEST_TYPE.CODE AS request_type_code, REQUEST_TYPE.NAME AS request_type_name, 
                      dbo.REQUESTS.REQUEST_STATUS_TYPE_ID, REQUEST_STATUS_TYPE.CODE AS request_status_type_code, 
                      REQUEST_STATUS_TYPE.NAME AS request_status_type_name, dbo.REQUESTS.PROJECT_ID, dbo.SERVICES.SERVICE_ID, 
                      dbo.SERVICES.SERV_STATUS_TYPE_ID, SERV_STATUS_TYPE.CODE AS serv_status_type_code, 
                      SERV_STATUS_TYPE.NAME AS serv_status_type_name, dbo.REQUESTS.DEALER_CUST_ID, dbo.REQUESTS.CUSTOMER_PO_NO, 
                      dbo.REQUESTS.DEALER_PO_NO, dbo.REQUESTS.DEALER_PO_LINE_NO, dbo.REQUESTS.DEALER_PROJECT_NO, 
                      dbo.REQUESTS.DESIGN_PROJECT_NO, dbo.REQUESTS.PROJECT_VOLUME, dbo.REQUESTS.ACCOUNT_TYPE_ID, 
                      ACCOUNT_TYPE.CODE AS account_type_code, ACCOUNT_TYPE.NAME AS account_type_name, dbo.REQUESTS.QUOTE_TYPE_ID, 
                      QUOTE_TYPE.CODE AS quote_type_code, QUOTE_TYPE.NAME AS quote_type_name, dbo.REQUESTS.QUOTE_NEEDED_BY, 
                      dbo.REQUESTS.JOB_LOCATION_ID, dbo.REQUESTS.CUSTOMER_CONTACT_ID, dbo.REQUESTS.ALT_CUSTOMER_CONTACT_ID, 
                      dbo.REQUESTS.D_SALES_REP_CONTACT_ID, dbo.REQUESTS.D_SALES_SUP_CONTACT_ID, dbo.REQUESTS.D_PROJ_MGR_CONTACT_ID, 
                      dbo.REQUESTS.D_DESIGNER_CONTACT_ID, dbo.REQUESTS.A_M_CONTACT_ID, dbo.REQUESTS.A_M_INSTALL_SUP_CONTACT_ID, 
                      dbo.REQUESTS.FURNITURE1_CONTACT_ID, dbo.REQUESTS.FURNITURE2_CONTACT_ID, dbo.REQUESTS.A_D_DESIGNER_CONTACT_ID, 
                      dbo.REQUESTS.GEN_CONTRACTOR_CONTACT_ID, dbo.REQUESTS.ELECTRICIAN_CONTACT_ID, dbo.REQUESTS.DATA_PHONE_CONTACT_ID, 
                      dbo.REQUESTS.PHONE_CONTACT_ID, dbo.REQUESTS.CARPET_LAYER_CONTACT_ID, dbo.REQUESTS.BLDG_MGR_CONTACT_ID, 
                      dbo.REQUESTS.SECURITY_CONTACT_ID, dbo.REQUESTS.MOVER_CONTACT_ID, dbo.REQUESTS.OTHER_CONTACT_ID, 
                      dbo.REQUESTS.PRI_FURN_TYPE_ID, PRI_FURN_TYPE.CODE AS pri_furn_type_code, PRI_FURN_TYPE.NAME AS pri_furn_type_name, 
                      dbo.REQUESTS.PRI_FURN_LINE_TYPE_ID, dbo.REQUESTS.CSC_WO_FIELD_FLAG,
                      PRI_FURN_LINE_TYPE.CODE AS pri_furn_line_type_code, 
                      PRI_FURN_LINE_TYPE.NAME AS pri_furn_line_type_name, dbo.REQUESTS.SEC_FURN_TYPE_ID, SEC_FURN_TYPE.CODE AS sec_furn_type_code, 
                      SEC_FURN_TYPE.NAME AS sec_furn_type_name, dbo.REQUESTS.SEC_FURN_LINE_TYPE_ID, 
                      SEC_FURN_LINE_TYPE.CODE AS sec_furn_line_type_code, SEC_FURN_LINE_TYPE.NAME AS sec_furn_line_type_name, 
                      dbo.REQUESTS.CASE_FURN_TYPE_ID, CASE_FURN_TYPE.CODE AS case_furn_type_code, CASE_FURN_TYPE.NAME AS case_furn_type_name, 
                      dbo.REQUESTS.CASE_FURN_LINE_TYPE_ID, CASE_FURN_LINE_TYPE.CODE AS case_furn_line_type_code, 
                      CASE_FURN_LINE_TYPE.NAME AS case_furn_line_type_name, dbo.REQUESTS.WOOD_PRODUCT_TYPE_ID, 
                      WOOD_PRODUCT_TYPE.CODE AS wood_product_type_code, WOOD_PRODUCT_TYPE.NAME AS wood_product_type_name, 
                      dbo.REQUESTS.DELIVERY_TYPE_ID, DELIVERY_TYPE.CODE AS delivery_type_code, DELIVERY_TYPE.NAME AS delivery_type_name, 
                      dbo.REQUESTS.WAREHOUSE_LOC, dbo.REQUESTS.FURN_PLAN_TYPE_ID, FURN_PLAN_TYPE.CODE AS furn_plan_type_code, 
                      FURN_PLAN_TYPE.NAME AS furn_plan_type_name, dbo.REQUESTS.PLAN_LOCATION, dbo.REQUESTS.FURN_SPEC_TYPE_ID, 
                      FURN_SPEC_TYPE.CODE AS furn_spec_type_code, FURN_SPEC_TYPE.NAME AS furn_spec_type_name, 
                      dbo.REQUESTS.WORKSTATION_TYPICAL_TYPE_ID, WORKSTATION_TYPICAL_TYPE.CODE AS workstation_typical_type_code, 
                      WORKSTATION_TYPICAL_TYPE.NAME AS workstation_typical_type_name, dbo.REQUESTS.POWER_TYPE, 
                      dbo.REQUESTS.PUNCHLIST_ITEM_TYPE_ID, PUNCHLIST_ITEM_TYPE.CODE AS punchlist_item_type_code, 
                      PUNCHLIST_ITEM_TYPE.NAME AS punchlist_item_type_name, dbo.REQUESTS.PUNCHLIST_LINE, dbo.REQUESTS.WALL_MOUNT_TYPE_ID, 
                      WALL_MOUNT_TYPE.CODE AS wall_mount_type_code, WALL_MOUNT_TYPE.NAME AS wall_mount_type_name, 
                      dbo.REQUESTS.INIT_PROJ_TEAM_MTG_DATE, dbo.REQUESTS.DESIGN_PRESENTATION_DATE, dbo.REQUESTS.DESIGN_COMPLETION_DATE, 
                      dbo.REQUESTS.SPEC_CHECK_CMPL_DATE, dbo.REQUESTS.DEALER_ORDER_PLACED_DATE, dbo.REQUESTS.INT_PRE_INSTALL_MTG_DATE, 
                      dbo.REQUESTS.EXT_PRE_INSTALL_MTG_DATE, dbo.REQUESTS.DEALER_INSTALL_PLAN_DATE, dbo.REQUESTS.MFG_SHIP_DATE, 
                      dbo.REQUESTS.PROD_DEL_TO_WH_DATE, dbo.REQUESTS.TRUCK_ARRIVAL_TIME, dbo.REQUESTS.CONSTRUCT_COMPLETE_DATE, 
                      dbo.REQUESTS.ELECTRICAL_COMPLETE_DATE, dbo.REQUESTS.CABLE_COMPLETE_DATE, dbo.REQUESTS.CARPET_COMPLETE_DATE, 
                      dbo.REQUESTS.SITE_VISIT_REQ_TYPE_ID, SITE_VISIT_REQ_TYPE.CODE AS site_visit_req_type_code, 
                      SITE_VISIT_REQ_TYPE.NAME AS site_visit_req_type_name, dbo.REQUESTS.SITE_VISIT_DATE, dbo.REQUESTS.PRODUCT_DEL_TO_SITE_DATE, 
                      dbo.REQUESTS.SCHEDULE_TYPE_ID, SCHEDULE_TYPE.CODE AS schedule_type_code, SCHEDULE_TYPE.NAME AS schedule_type_name, 
                      dbo.REQUESTS.EST_START_DATE, CONVERT(varchar(12), dbo.REQUESTS.EST_START_DATE, 101) AS est_start_date_varchar, 
                      dbo.REQUESTS.EST_START_TIME, dbo.REQUESTS.EST_END_DATE, dbo.REQUESTS.MOVE_IN_DATE, 
                      dbo.REQUESTS.PUNCHLIST_COMPLETE_DATE, dbo.REQUESTS.COORD_PHONE_DATA_TYPE_ID, dbo.REQUESTS.COORD_WALL_COVR_TYPE_ID, 
                      dbo.REQUESTS.COORD_FLOOR_COVR_TYPE_ID, dbo.REQUESTS.COORD_ELECTRICAL_TYPE_ID, dbo.REQUESTS.COORD_MOVER_TYPE_ID, 
                      dbo.REQUESTS.ACTIVITY_TYPE_ID1, dbo.REQUESTS.QTY1, dbo.REQUESTS.ACTIVITY_CAT_TYPE_ID1, dbo.REQUESTS.ACTIVITY_TYPE_ID2, 
                      dbo.REQUESTS.QTY2, dbo.REQUESTS.ACTIVITY_CAT_TYPE_ID2, dbo.REQUESTS.ACTIVITY_TYPE_ID3, dbo.REQUESTS.QTY3, 
                      dbo.REQUESTS.ACTIVITY_CAT_TYPE_ID3, dbo.REQUESTS.ACTIVITY_TYPE_ID4, dbo.REQUESTS.QTY4, dbo.REQUESTS.ACTIVITY_CAT_TYPE_ID4, 
                      dbo.REQUESTS.ACTIVITY_TYPE_ID5, dbo.REQUESTS.QTY5, dbo.REQUESTS.ACTIVITY_CAT_TYPE_ID5, dbo.REQUESTS.ACTIVITY_TYPE_ID6, 
                      dbo.REQUESTS.QTY6, dbo.REQUESTS.ACTIVITY_CAT_TYPE_ID6, dbo.REQUESTS.ACTIVITY_TYPE_ID7, dbo.REQUESTS.QTY7, 
                      dbo.REQUESTS.ACTIVITY_CAT_TYPE_ID7, dbo.REQUESTS.ACTIVITY_TYPE_ID8, dbo.REQUESTS.QTY8, dbo.REQUESTS.ACTIVITY_CAT_TYPE_ID8, 
                      dbo.REQUESTS.ACTIVITY_TYPE_ID9, dbo.REQUESTS.QTY9, dbo.REQUESTS.ACTIVITY_CAT_TYPE_ID9, dbo.REQUESTS.ACTIVITY_TYPE_ID10, 
                      dbo.REQUESTS.QTY10, dbo.REQUESTS.ACTIVITY_CAT_TYPE_ID10, dbo.REQUESTS.DESCRIPTION, dbo.REQUESTS.APPROVAL_REQ_TYPE_ID, 
                      APPROVAL_REQ_TYPE.CODE AS approval_req_type_code, APPROVAL_REQ_TYPE.NAME AS approval_req_type_name, 
                      dbo.REQUESTS.WHO_CAN_APPROVE_NAME, dbo.REQUESTS.WHO_CAN_APPROVE_PHONE, dbo.REQUESTS.REGULAR_HOURS_TYPE_ID, 
                      dbo.REQUESTS.EVENING_HOURS_TYPE_ID, dbo.REQUESTS.WEEKEND_HOURS_TYPE_ID, dbo.REQUESTS.UNION_LABOR_REQ_TYPE_ID, 
                      dbo.REQUESTS.COST_TO_CUST_TYPE_ID, dbo.REQUESTS.COST_TO_VEND_TYPE_ID, dbo.REQUESTS.COST_TO_JOB_TYPE_ID, 
                      dbo.REQUESTS.WAREHOUSE_FEE_TYPE_ID, dbo.REQUESTS.DURATION_TIME_UOM_TYPE_ID, dbo.REQUESTS.DURATION_QTY, 
                      dbo.REQUESTS.PHASED_INSTALL_TYPE_ID, dbo.REQUESTS.LOADING_DOCK_TYPE_ID, dbo.REQUESTS.DOCK_AVAILABLE_TIME, 
                      dbo.REQUESTS.DOCK_RESERV_REQ_TYPE_ID, dbo.REQUESTS.SEMI_ACCESS_TYPE_ID, dbo.REQUESTS.DOCK_HEIGHT, 
                      dbo.REQUESTS.ELEVATOR_AVAIL_TYPE_ID, dbo.REQUESTS.ELEVATOR_AVAIL_TIME, dbo.REQUESTS.ELEVATOR_RESERV_REQ_TYPE_ID, 
                      dbo.REQUESTS.STAIR_CARRY_TYPE_ID, dbo.REQUESTS.STAIR_CARRY_FLIGHTS, dbo.REQUESTS.STAIR_CARRY_STAIRS, 
                      dbo.REQUESTS.SMALLEST_DOOR_ELEV_WIDTH, dbo.REQUESTS.FLOOR_PROTECTION_TYPE_ID, dbo.REQUESTS.WALL_PROTECTION_TYPE_ID, 
                      dbo.REQUESTS.DOORWAY_PROT_TYPE_ID, dbo.REQUESTS.WALKBOARD_TYPE_ID, dbo.REQUESTS.STAGING_AREA_TYPE_ID, 
                      dbo.REQUESTS.DUMPSTER_TYPE_ID, dbo.REQUESTS.NEW_SITE_TYPE_ID, dbo.REQUESTS.OCCUPIED_SITE_TYPE_ID, 
                      dbo.REQUESTS.OTHER_CONDITIONS, dbo.REQUESTS.DATE_CREATED, dbo.REQUESTS.CREATED_BY, dbo.REQUESTS.DATE_MODIFIED, 
                      dbo.REQUESTS.MODIFIED_BY, dbo.PROJECTS_V.PROJECT_NO, CONVERT(varchar, dbo.PROJECTS_V.PROJECT_NO) + '-' + CONVERT(varchar, 
                      dbo.REQUESTS.REQUEST_NO) AS project_request_no, dbo.PROJECTS_V.CUSTOMER_ID, CUSTOMERS_1.PARENT_CUSTOMER_ID, 
                      CUSTOMERS_1.ORGANIZATION_ID, CUSTOMERS_1.EXT_DEALER_ID, CUSTOMERS_1.DEALER_NAME, CUSTOMERS_1.EXT_CUSTOMER_ID, 
                      CUSTOMERS_1.CUSTOMER_NAME, dbo.PROJECTS_V.JOB_NAME, dbo.REQUESTS.IS_SENT, dbo.REQUESTS.IS_QUOTED, 
                      dbo.REQUESTS.QUOTE_REQUEST_ID, dbo.REQUESTS.REQUEST_NO AS record_seq_no, 
                      USERS_1.FIRST_NAME + ' ' + USERS_1.LAST_NAME AS created_by_name, 
                      USERS_2.FIRST_NAME + ' ' + USERS_2.LAST_NAME AS modified_by_name, A_M_CONTACT.CONTACT_NAME AS a_m_contact_name, 
                      dbo.PROJECTS_V.PROJECT_STATUS_TYPE_ID, dbo.PROJECTS_V.project_status_type_code, dbo.PROJECTS_V.project_status_type_name, 
                      CONVERT(varchar(12), dbo.REQUESTS.DATE_CREATED, 101) AS date_created_varchar
FROM         dbo.LOOKUPS SITE_VISIT_REQ_TYPE RIGHT OUTER JOIN
                      dbo.LOOKUPS QUOTE_TYPE RIGHT OUTER JOIN
                      dbo.LOOKUPS SEC_FURN_TYPE RIGHT OUTER JOIN
                      dbo.LOOKUPS PRI_FURN_TYPE RIGHT OUTER JOIN
                      dbo.LOOKUPS REQUEST_STATUS_TYPE RIGHT OUTER JOIN
                      dbo.LOOKUPS FURN_PLAN_TYPE RIGHT OUTER JOIN
                      dbo.LOOKUPS ACCOUNT_TYPE RIGHT OUTER JOIN
                      dbo.LOOKUPS WORKSTATION_TYPICAL_TYPE RIGHT OUTER JOIN
                      dbo.LOOKUPS PUNCHLIST_ITEM_TYPE RIGHT OUTER JOIN
                      dbo.LOOKUPS CASE_FURN_TYPE RIGHT OUTER JOIN
                      dbo.LOOKUPS FURN_SPEC_TYPE RIGHT OUTER JOIN
                      dbo.LOOKUPS CASE_FURN_LINE_TYPE RIGHT OUTER JOIN
                      dbo.LOOKUPS WOOD_PRODUCT_TYPE RIGHT OUTER JOIN
                      dbo.LOOKUPS SCHEDULE_TYPE RIGHT OUTER JOIN
                      dbo.LOOKUPS APPROVAL_REQ_TYPE RIGHT OUTER JOIN
                      dbo.LOOKUPS SERV_STATUS_TYPE RIGHT OUTER JOIN
                      dbo.SERVICES RIGHT OUTER JOIN
                      dbo.USERS USERS_1 RIGHT OUTER JOIN
                      dbo.USERS USERS_2 RIGHT OUTER JOIN
                      dbo.VERSIONS_MAX_NO_V RIGHT OUTER JOIN
                      dbo.REQUESTS ON dbo.VERSIONS_MAX_NO_V.PROJECT_ID = dbo.REQUESTS.PROJECT_ID AND 
                      dbo.VERSIONS_MAX_NO_V.REQUEST_NO = dbo.REQUESTS.REQUEST_NO ON USERS_2.USER_ID = dbo.REQUESTS.MODIFIED_BY ON 
                      USERS_1.USER_ID = dbo.REQUESTS.CREATED_BY ON dbo.SERVICES.REQUEST_ID = dbo.REQUESTS.REQUEST_ID ON 
                      SERV_STATUS_TYPE.LOOKUP_ID = dbo.SERVICES.SERV_STATUS_TYPE_ID ON 
                      APPROVAL_REQ_TYPE.LOOKUP_ID = dbo.REQUESTS.APPROVAL_REQ_TYPE_ID ON 
                      SCHEDULE_TYPE.LOOKUP_ID = dbo.REQUESTS.SCHEDULE_TYPE_ID ON 
                      WOOD_PRODUCT_TYPE.LOOKUP_ID = dbo.REQUESTS.WOOD_PRODUCT_TYPE_ID ON 
                      CASE_FURN_LINE_TYPE.LOOKUP_ID = dbo.REQUESTS.CASE_FURN_LINE_TYPE_ID ON 
                      FURN_SPEC_TYPE.LOOKUP_ID = dbo.REQUESTS.FURN_SPEC_TYPE_ID ON 
                      CASE_FURN_TYPE.LOOKUP_ID = dbo.REQUESTS.CASE_FURN_TYPE_ID ON 
                      PUNCHLIST_ITEM_TYPE.LOOKUP_ID = dbo.REQUESTS.PUNCHLIST_ITEM_TYPE_ID ON 
                      WORKSTATION_TYPICAL_TYPE.LOOKUP_ID = dbo.REQUESTS.WORKSTATION_TYPICAL_TYPE_ID ON 
                      ACCOUNT_TYPE.LOOKUP_ID = dbo.REQUESTS.ACCOUNT_TYPE_ID ON FURN_PLAN_TYPE.LOOKUP_ID = dbo.REQUESTS.FURN_PLAN_TYPE_ID ON 
                      REQUEST_STATUS_TYPE.LOOKUP_ID = dbo.REQUESTS.REQUEST_STATUS_TYPE_ID ON 
                      PRI_FURN_TYPE.LOOKUP_ID = dbo.REQUESTS.PRI_FURN_TYPE_ID LEFT OUTER JOIN
                      dbo.LOOKUPS SEC_FURN_LINE_TYPE ON dbo.REQUESTS.SEC_FURN_LINE_TYPE_ID = SEC_FURN_LINE_TYPE.LOOKUP_ID LEFT OUTER JOIN
                      dbo.LOOKUPS REQUEST_TYPE ON dbo.REQUESTS.REQUEST_TYPE_ID = REQUEST_TYPE.LOOKUP_ID LEFT OUTER JOIN
                      dbo.LOOKUPS PRI_FURN_LINE_TYPE ON dbo.REQUESTS.PRI_FURN_LINE_TYPE_ID = PRI_FURN_LINE_TYPE.LOOKUP_ID ON 
                      SEC_FURN_TYPE.LOOKUP_ID = dbo.REQUESTS.SEC_FURN_TYPE_ID LEFT OUTER JOIN
                      dbo.LOOKUPS WALL_MOUNT_TYPE ON dbo.REQUESTS.WALL_MOUNT_TYPE_ID = WALL_MOUNT_TYPE.LOOKUP_ID ON 
                      QUOTE_TYPE.LOOKUP_ID = dbo.REQUESTS.QUOTE_TYPE_ID ON 
                      SITE_VISIT_REQ_TYPE.LOOKUP_ID = dbo.REQUESTS.SITE_VISIT_REQ_TYPE_ID LEFT OUTER JOIN
                      dbo.LOOKUPS DELIVERY_TYPE ON dbo.REQUESTS.DELIVERY_TYPE_ID = DELIVERY_TYPE.LOOKUP_ID LEFT OUTER JOIN
                      dbo.JOB_LOCATIONS ON dbo.REQUESTS.JOB_LOCATION_ID = dbo.JOB_LOCATIONS.JOB_LOCATION_ID LEFT OUTER JOIN
                      dbo.CUSTOMERS CUSTOMERS_1 RIGHT OUTER JOIN
                      dbo.PROJECTS_V ON CUSTOMERS_1.CUSTOMER_ID = dbo.PROJECTS_V.CUSTOMER_ID ON 
                      dbo.REQUESTS.PROJECT_ID = dbo.PROJECTS_V.PROJECT_ID LEFT OUTER JOIN
                      dbo.CONTACTS A_M_CONTACT ON dbo.REQUESTS.A_M_CONTACT_ID = A_M_CONTACT.CONTACT_ID
GO

/****** Object:  View [dbo].[CONVERTED_REQUESTS_V]    Script Date: 05/03/2010 14:18:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[CONVERTED_REQUESTS_V]
AS
SELECT project_id, request_no, is_converted = CASE ISNULL(service_id, '-1')
WHEN -1 THEN 'N'
ELSE 'Y' END
, record_seq_no
FROM   dbo.REQUESTS_V
WHERE request_type_code = 'service_request'
GO

/****** Object:  View [dbo].[job_services_v]    Script Date: 05/03/2010 14:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[job_services_v]
AS
SELECT CAST(j.job_id AS VARCHAR(30)) + ':' + ISNULL(CAST(s.service_id AS VARCHAR(30)), '') AS job_service_id, 
       c.organization_id, 
       j.job_id, 
       j.project_id, 
       j.job_no, 
       j.job_name, 
       j.job_type_id, 
       job_type.code job_type_code, 
       job_type.name job_type_name, 
       j.job_status_type_id, 
       job_status_type.code job_status_type_code, 
       job_status_type.name job_status_type_name, 
       job_status_type.sequence_no job_status_seq_no, 
       CASE WHEN customer_type.code = 'end_user' THEN c.end_user_parent_id ELSE c.customer_id END customer_id,
       CASE WHEN customer_type.code = 'end_user' THEN (SELECT customer_name FROM customers WHERE customer_id = c.end_user_parent_id) ELSE c.customer_name END customer_name,
       CASE WHEN customer_type.code = 'end_user' THEN c.customer_name ELSE eu.customer_name END end_user_name, 
       c.dealer_name, 
       CASE WHEN customer_type.code = 'dealer' THEN ISNULL(c.ext_customer_id, c.ext_dealer_id) ELSE c.ext_dealer_id END ext_dealer_id, 
       c.ext_customer_id, 
       j.foreman_resource_id, 
       r.name AS foreman_resource_name, 
       r.user_id AS foreman_user_id,
       foreman_user.first_name + ' ' + foreman_user.last_name AS foreman_user_name,  
       j.billing_user_id, 
       u_billing.first_name + ' ' + u_billing.last_name AS billing_user_name,  
       j.created_by AS job_created_by, 
       j_created_by.first_name + ' ' + j_created_by.last_name  AS job_created_by_name, 
       j.date_created AS job_date_created, 
       j.modified_by AS job_modified_by, 
       j_modified_by.first_name + ' ' + j_modified_by.last_name AS job_modified_by_name, 
       j.date_modified AS job_date_modified,   
       s.request_id, 
       s.service_id, 
       s.service_no, 
       CAST(s.service_no AS varchar) + ' - ' + ISNULL(s.description, '') AS service_no_desc, 
       s.service_type_id, 
       service_type.code AS service_type_code, 
       service_type.name AS service_type_name, 
       s.serv_status_type_id, serv_status_type.code AS serv_status_type_code, 
       serv_status_type.name AS serv_status_type_name, 
       s.internal_req_flag, s.description, 
       s.job_location_id, 
       jl.job_location_name, 
       s.report_to_loc_id, 
       report_to_loc_type.code AS report_to_loc_code, 
       report_to_loc_type.name AS report_to_loc_name, 
       s.customer_ref_no, 
       s.po_no AS po_no, 
       s.billing_type_id, 
       s.customer_contact_id, 
       s.idm_contact_id, 
       s.sales_contact_id, 
       s.support_contact_id, 
       s.designer_contact_id, 
       s.project_mgr_contact_id, 
       s.product_setup_desc, 
       s.delivery_type_id, 
       delivery_types.code AS delivery_type_code, 
       delivery_types.name AS delivery_type_name, 
       s.warehouse_loc, 
       s.pri_furn_type_id, 
       s.pri_furn_line_type_id, 
       pri_furn_line_types.name AS pri_furn_line_type_name, 
       s.sec_furn_type_id, 
       s.sec_furn_line_type_id, 
       sec_furn_line_types.name AS sec_furn_line_type_name, 
       s.num_stations, 
       s.product_qty, 
       s.wood_product_type_id, 
       s.punchlist_type_id, 
       punchlist_type.code AS punchlist_type_code, 
       punchlist_type.name AS punchlist_type_name, 
       s.blueprint_location, 
       s.schedule_type_id, 
       schedule_type.code AS schedule_type_code, 
       schedule_type.name AS schedule_type_name, 
       schedule_type.sequence_no AS sch_type_seq_no, 
       s.ordered_by, 
       s.ordered_date, 
       s.est_start_date, 
       s.est_start_time, 
       s.est_end_date, 
       s.truck_ship_date, 
       s.truck_arrival_date, 
       s.head_val_flag, 
       s.loc_val_flag, 
       s.prod_val_flag, 
       s.sch_val_flag, 
       s.task_val_flag, 
       s.res_val_flag, 
       s.cust_val_flag, 
       s.bill_val_flag, 
       s.cust_col_1, 
       s.cust_col_2, 
       s.cust_col_3, 
       s.cust_col_4, 
       s.cust_col_5, 
       s.cust_col_6, 
       s.cust_col_7, 
       s.cust_col_8, 
       s.cust_col_9, 
       s.cust_col_10, 
       s.date_created AS serv_date_created, 
       s.created_by AS serv_created_by, 
       s_created_by.first_name + ' ' + s_created_by.last_name AS serv_created_by_name, 
       s.date_modified AS serv_date_modified, 
       s.modified_by AS serv_modified_by, 
       s_modified_by.first_name + ' ' + s_modified_by.last_name AS serv_modified_by_name, 
       CONVERT(VARCHAR, s.est_start_time, 8) AS est_start_time_only, 
       serv_status_type.sequence_no AS serv_status_seq_no, 
       (CASE s.watch_flag WHEN 'Y' THEN s.watch_flag ELSE j.watch_flag END) AS watch_flag, 
       (CASE s.weekend_flag WHEN 'Y' THEN 'Yes' WHEN 'N' THEN 'No' ELSE 'N/A' END) AS weekend_flag_name
  FROM dbo.jobs j INNER JOIN
       dbo.lookups job_type ON j.job_type_id = job_type.lookup_id INNER JOIN 
       dbo.lookups job_status_type ON j.job_status_type_id = job_status_type.lookup_id INNER JOIN
       dbo.customers c ON j.customer_id = c.customer_id INNER JOIN
       dbo.lookups customer_type ON c.customer_type_id = customer_type.lookup_id INNER JOIN
       dbo.users j_created_by ON j.created_by = j_created_by.user_id LEFT OUTER JOIN
       dbo.users j_modified_by ON j.modified_by = j_modified_by.user_id LEFT OUTER JOIN
       dbo.users u_billing ON j.billing_user_id = u_billing.user_id LEFT OUTER JOIN
       dbo.resources r ON j.foreman_resource_id = r.resource_id LEFT OUTER JOIN
       dbo.users foreman_user ON r.user_id = foreman_user.user_id LEFT OUTER JOIN
       dbo.services s ON j.job_id = s.job_id LEFT OUTER JOIN     
       dbo.job_locations jl ON s.job_location_id = jl.job_location_id LEFT OUTER JOIN
       dbo.lookups delivery_types ON s.delivery_type_id = delivery_types.lookup_id LEFT OUTER JOIN
       dbo.lookups pri_furn_line_types ON s.pri_furn_line_type_id = pri_furn_line_types.lookup_id LEFT OUTER JOIN
       dbo.lookups punchlist_type ON s.punchlist_type_id = punchlist_type.lookup_id  LEFT OUTER JOIN
       dbo.lookups report_to_loc_type ON s.report_to_loc_id = report_to_loc_type.lookup_id LEFT OUTER JOIN
       dbo.lookups schedule_type ON s.schedule_type_id = schedule_type.lookup_id LEFT OUTER JOIN
       dbo.lookups sec_furn_line_types ON s.sec_furn_line_type_id = sec_furn_line_types.lookup_id LEFT OUTER JOIN
       dbo.lookups service_type ON s.service_type_id = service_type.lookup_id LEFT OUTER JOIN
       dbo.lookups serv_status_type ON s.serv_status_type_id = serv_status_type.lookup_id LEFT OUTER JOIN
       dbo.users s_modified_by ON s.modified_by = s_modified_by.user_id LEFT OUTER JOIN
       dbo.users s_created_by ON s.created_by = s_created_by.user_id LEFT OUTER JOIN
       dbo.customers eu ON j.end_user_id = eu.customer_id
GO
/****** Object:  View [dbo].[job_progress_v]    Script Date: 05/03/2010 14:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[job_progress_v]
AS
SELECT organization_id, 
       project_id, 
       project_no, 
       customer_id, 
       customer_name, 
       end_user_id,
       end_user_name,
       ext_dealer_id,
       job_name, 
       install_foreman, 
       job_status_type_id, 
       job_status_type_code, 
       job_status_type_name, 
       min_start_date, 
       CONVERT(VARCHAR(12), min_start_date, 101) AS min_start_date_varchar, 
       cur_date, 
       max_end_date, 
       CONVERT(VARCHAR(12), max_end_date, 101) AS max_end_date_varchar, 
       duration, 
       cur_duration_left, 
       percent_complete, 
       (CASE duration WHEN 0 THEN 0 ELSE round((duration - cur_duration_left) / duration, 2) END) AS act_percent_complete, 
       (CASE CAST(punchlist_count AS varchar) WHEN '0' THEN 'N' ELSE 'Y' END) AS punchlist, 
       project_status_type_code
  FROM (SELECT organization_id, 
	       project_id, 
	       project_no, 
	       customer_id, 
	       customer_name,
	       end_user_id,
	       end_user_name,
	       ext_dealer_id,
	       job_name, 
	       install_foreman, 
	       job_status_type_id, 
	       job_status_type_code, 
	       job_status_type_name, 
	       min_start_date, 
	       max_end_date, 
	       CAST(DATEDIFF([HOUR], min_start_date, max_end_date + 1) AS numeric) AS duration, 
	       GETDATE() AS cur_date, 
	       CAST(DATEDIFF([HOUR], GETDATE(), max_end_date + 1) AS numeric) AS cur_duration_left, 
	       percent_complete, 
	       punchlist_count, 
	       project_status_type_code
	  FROM (SELECT p.project_id, 
		       p.project_no, 
		       p.job_name, 
		       p.percent_complete, 
		       CASE WHEN customer_type.code = 'end_user' THEN c.end_user_parent_id ELSE c.customer_id END customer_id, 
		       CASE WHEN customer_type.code = 'end_user' THEN (SELECT customer_name FROM customers WHERE customer_id = c.end_user_parent_id) ELSE c.customer_name END customer_name,
		       CASE WHEN customer_type.code = 'end_user' THEN c.customer_id ELSE eu.customer_id END end_user_id, 
		       CASE WHEN customer_type.code = 'end_user' THEN c.customer_name ELSE eu.customer_name END end_user_name, 
		       CASE WHEN customer_type.code = 'dealer' THEN ISNULL(c.ext_customer_id, c.ext_dealer_id) ELSE c.ext_dealer_id END ext_dealer_id, 
		       c.organization_id, 
		       project_status_type.code project_status_type_code,  
		       j.job_status_type_id,   
		       job_status_type.code AS job_status_type_code, 
		       job_status_type.name AS job_status_type_name, 
		       MIN(s.est_start_date) AS min_start_date, 
		       MAX(s.est_end_date) AS max_end_date, 
		       COUNT(pu.punchlist_id) as punchlist_count, 
		       resource_user.first_name + ' ' + resource_user.last_name AS install_foreman      
		  FROM dbo.projects p INNER JOIN
		       dbo.lookups project_status_type ON p.project_status_type_id = project_status_type.lookup_id INNER JOIN
		       dbo.customers c ON p.customer_id = c.customer_id INNER JOIN
		       dbo.lookups customer_type ON c.customer_type_id = customer_type.lookup_id LEFT OUTER JOIN
		       dbo.customers eu ON p.end_user_id = eu.customer_id LEFT OUTER JOIN
		       dbo.jobs j ON p.project_id = j.project_id LEFT OUTER JOIN
		       dbo.lookups job_status_type ON j.job_status_type_id = job_status_type.lookup_id LEFT OUTER JOIN
		       dbo.services s ON j.job_id = s.job_id LEFT OUTER JOIN
		       dbo.punchlists pu ON p.project_id = pu.project_id LEFT OUTER JOIN
		       dbo.resources r ON j.foreman_resource_id = r.resource_id LEFT OUTER JOIN
		       dbo.users resource_user on r.user_id = resource_user.user_id
		GROUP BY p.project_id, 
			 j.job_status_type_id, 
			 p.project_no, 
			 c.customer_id, 
			 c.customer_name, 
			 c.ext_dealer_id,
                         c.ext_customer_id,
			 p.job_name, 
			 job_status_type.code, 
			 job_status_type.name, 
			 p.percent_complete, 
			 c.organization_id, 
			 resource_user.first_name + ' ' + resource_user.last_name,
			 project_status_type.code,
			 customer_type.code,
			 c.end_user_parent_id,
			 eu.customer_id,
			 eu.customer_name
		       ) v1
	       ) v2
GO
/****** Object:  View [dbo].[crystal_QUOTES_V]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[crystal_QUOTES_V]
AS
SELECT     TOP (100) PERCENT dbo.QUOTES.quote_id, dbo.QUOTES.request_id, dbo.QUOTES.is_sent, dbo.QUOTES.quote_no, dbo.QUOTES.version, 
                      dbo.QUOTES.quote_type_id, dbo.QUOTES.quote_status_type_id, dbo.QUOTES.quoted_by_user_id, dbo.QUOTES.quote_total, 
                      CAST(dbo.QUOTES.net_effective_billing_rate_per_hour AS MONEY) AS NEBR, CAST(dbo.QUOTES.[roc_omni_discounted_hours-receive] AS MONEY) 
                      AS roc_omni_discounted_hours_receive, CAST(dbo.QUOTES.[roc_omni_discounted_hours-reload] AS MONEY) AS roc_omni_discounted_hours_reload, 
                      CAST(dbo.QUOTES.[roc_omni_discounted_hours-truck] AS MONEY) AS roc_omni_discounted_hours_truck, 
                      CAST(dbo.QUOTES.[roc_omni_discounted_hours-driver] AS MONEY) AS roc_omni_discounted_hours_driver, 
                      CAST(dbo.QUOTES.[roc_omni_discounted_hours-unload] AS MONEY) AS roc_omni_discounted_hours_unload, 
                      CAST(dbo.QUOTES.[roc_omni_discounted_hours-move_stage] AS MONEY) AS roc_omni_discounted_hours_move_stage, 
                      CAST(dbo.QUOTES.[roc_omni_discounted_hours-install] AS MONEY) AS roc_omni_discounted_hours_install, 
                      CAST(dbo.QUOTES.[roc_omni_discounted_hours-electrical] AS MONEY) AS roc_omni_discounted_hours_electrical, 
                      CAST(dbo.QUOTES.[roc_omni_discounted_hours-total] AS MONEY) AS roc_omni_discounted_hours_total, 
                      CAST(dbo.QUOTES.[roc_industry_std_bill-receive] AS MONEY) AS roc_industry_std_bill_receive, 
                      CAST(dbo.QUOTES.[roc_industry_std_bill-reload] AS MONEY) AS roc_industry_std_bill_reload, 
                      CAST(dbo.QUOTES.[roc_industry_std_bill-truck] AS MONEY) AS roc_industry_std_bill_truck, 
                      CAST(dbo.QUOTES.[roc_industry_std_bill-driver] AS MONEY) AS roc_industry_std_bill_driver, 
                      CAST(dbo.QUOTES.[roc_industry_std_bill-unload] AS MONEY) AS roc_industry_std_bill_unload, 
                      CAST(dbo.QUOTES.[roc_industry_std_bill-move_stage] AS MONEY) AS roc_industry_std_bill_move_stage, 
                      CAST(dbo.QUOTES.[roc_industry_std_bill-install] AS MONEY) AS roc_industry_std_bill_install, 
                      CAST(dbo.QUOTES.[roc_industry_std_bill-electrical] AS MONEY) AS roc_industry_std_bill_electrical, 
                      CAST(dbo.QUOTES.[roc_industry_std_bill-total] AS MONEY) AS roc_industry_std_bill_total, 
                      CAST(dbo.QUOTES.[roc_omni_direct_cost-receive] AS MONEY) AS roc_omni_direct_cost_receive, 
                      CAST(dbo.QUOTES.[roc_omni_direct_cost-reload] AS MONEY) AS roc_omni_direct_cost_reload, 
                      CAST(dbo.QUOTES.[roc_omni_direct_cost-truck] AS MONEY) AS roc_omni_direct_cost_truck, 
                      CAST(dbo.QUOTES.[roc_omni_direct_cost-driver] AS MONEY) AS roc_omni_direct_cost_driver, 
                      CAST(dbo.QUOTES.[roc_omni_direct_cost-unload] AS MONEY) AS roc_omni_direct_cost_unload, 
                      CAST(dbo.QUOTES.[roc_omni_direct_cost-move-stage] AS MONEY) AS roc_omni_direct_cost_move_stage, 
                      CAST(dbo.QUOTES.[roc_omni_direct_cost-install] AS MONEY) AS roc_omni_direct_cost_install, 
                      CAST(dbo.QUOTES.[roc_omni_direct_cost-electrical] AS MONEY) AS roc_omni_direct_cost_electrical, 
                      CAST(dbo.QUOTES.[roc_omni_direct_cost-total] AS MONEY) AS roc_omni_direct_cost_total, 
                      CAST(dbo.QUOTES.[ind_industry_std_hours-receive] AS MONEY) AS ind_industry_std_hours_receive, 
                      CAST(dbo.QUOTES.[ind_industry_std_hours-reload] AS MONEY) AS ind_industry_std_hours_reload, 
                      CAST(dbo.QUOTES.[ind_industry_std_hours-truck] AS MONEY) AS ind_industry_std_hours_truck, 
                      CAST(dbo.QUOTES.[ind_industry_std_hours-driver] AS MONEY) AS ind_industry_std_hours_driver, 
                      CAST(dbo.QUOTES.[ind_industry_std_hours-move_stage] AS MONEY) AS ind_industry_std_hours_move_stage, 
                      CAST(dbo.QUOTES.[ind_industry_std_hours-unload] AS MONEY) AS ind_industry_std_hours_unload, 
                      CAST(dbo.QUOTES.[ind_industry_std_hours-install] AS MONEY) AS ind_industry_std_hours_install, 
                      CAST(dbo.QUOTES.[ind_industry_std_hours-electrical] AS MONEY) AS ind_industry_std_hours_electrical, 
                      CAST(dbo.QUOTES.[ind_industry_std_hours-total] AS MONEY) AS ind_industry_std_hours_total, 
                      CAST(dbo.QUOTES.[ind_omni_discounted_hours-receive] AS MONEY) AS ind_omni_discounted_hours_receive, 
                      CAST(dbo.QUOTES.[ind_omni_discounted_hours-reload] AS MONEY) AS ind_omni_discounted_hours_reload, 
                      CAST(dbo.QUOTES.[ind_omni_discounted_hours-truck] AS MONEY) AS ind_omni_discounted_hours_truck, 
                      CAST(dbo.QUOTES.[ind_omni_discounted_hours-driver] AS MONEY) AS ind_omni_discounted_hours_driver, 
                      CAST(dbo.QUOTES.[ind_omni_discounted_hours-unload] AS MONEY) AS ind_omni_discounted_hours_unload, 
                      CAST(dbo.QUOTES.[ind_omni_discounted_hours-move_stage] AS MONEY) AS ind_omni_discounted_hours_move_stage, 
                      CAST(dbo.QUOTES.[ind_omni_discounted_hours-install] AS MONEY) AS ind_omni_discounted_hours_install, 
                      CAST(dbo.QUOTES.[ind_omni_discounted_hours-electrical] AS MONEY) AS ind_omni_discounted_hours_electrical, 
                      CAST(dbo.QUOTES.[ind_omni_discounted_hours-total] AS MONEY) AS ind_omni_discounted_hours_total, 
                      CAST(dbo.QUOTES.[ind_industry_std_bill-receive] AS MONEY) AS ind_industry_std_bill_receive, 
                      CAST(dbo.QUOTES.[ind_industry_std_bill-reload] AS MONEY) AS ind_industry_std_bill_reload, 
                      CAST(dbo.QUOTES.[ind_industry_std_bill-truck] AS MONEY) AS ind_industry_std_bill_truck, 
                      CAST(dbo.QUOTES.[ind_industry_std_bill-driver] AS MONEY) AS ind_industry_std_bill_driver, 
                      CAST(dbo.QUOTES.[ind_industry_std_bill-unload] AS MONEY) AS ind_industry_std_bill_unload, 
                      CAST(dbo.QUOTES.[ind_industry_std_bill-move_stage] AS MONEY) AS ind_industry_std_bill_move_stage, 
                      CAST(dbo.QUOTES.[ind_industry_std_bill-install] AS MONEY) AS ind_industry_std_bill_install, 
                      CAST(dbo.QUOTES.[ind_industry_std_bill-electrical] AS MONEY) AS ind_industry_std_bill_electrical, 
                      CAST(dbo.QUOTES.[ind_industry_std_bill-total] AS MONEY) AS ind_industry_std_bill_total, 
                      CAST(dbo.QUOTES.[ind_omni_discounted_bill-receive] AS MONEY) AS ind_omni_discounted_bill_receive, 
                      CAST(dbo.QUOTES.[ind_omni_discounted_bill-reload] AS MONEY) AS ind_omni_discounted_bill_reload, 
                      CAST(dbo.QUOTES.[ind_omni_discounted_bill-truck] AS MONEY) AS ind_omni_discounted_bill_truck, 
                      CAST(dbo.QUOTES.[ind_omni_discounted_bill-driver] AS MONEY) AS ind_omni_discounted_bill_driver, 
                      CAST(dbo.QUOTES.[ind_omni_discounted_bill-unload] AS MONEY) AS ind_omni_discounted_bill_unload, 
                      CAST(dbo.QUOTES.[ind_omni_discounted_bill-move_stage] AS MONEY) AS ind_omni_discounted_bill_move_stage, 
                      CAST(dbo.QUOTES.[ind_omni_discounted_bill-install] AS MONEY) AS ind_omni_discounted_bill_install, 
                      CAST(dbo.QUOTES.[ind_omni_discounted_bill-electrical] AS MONEY) AS ind_omni_discounted_bill_electrical, 
                      CAST(dbo.QUOTES.[ind_omni_discounted_bill-total] AS MONEY) AS ind_omni_discounted_bill_total, 
                      CAST(dbo.QUOTES.[ind_omni_direct_cost-receive] AS MONEY) AS ind_omni_direct_cost_receive, 
                      CAST(dbo.QUOTES.[ind_omni_direct_cost-reload] AS MONEY) AS ind_omni_direct_cost_reload, 
                      CAST(dbo.QUOTES.[ind_omni_direct_cost-truck] AS MONEY) AS ind_omni_direct_cost_truck, 
                      CAST(dbo.QUOTES.[ind_omni_direct_cost-driver] AS MONEY) AS ind_omni_direct_cost_driver, 
                      CAST(dbo.QUOTES.[ind_omni_direct_cost-unload] AS MONEY) AS ind_omni_direct_cost_unload, 
                      CAST(dbo.QUOTES.[ind_omni_direct_cost-move_stage] AS MONEY) AS ind_omni_direct_cost_move_stage, 
                      CAST(dbo.QUOTES.[ind_omni_direct_cost-install] AS MONEY) AS ind_omni_direct_cost_install, 
                      CAST(dbo.QUOTES.[ind_omni_direct_cost-electrical] AS MONEY) AS ind_omni_direct_cost_electrical, 
                      CAST(dbo.QUOTES.[ind_omni_direct_cost-total] AS MONEY) AS ind_omni_direct_cost_total, dbo.REQUESTS.REQUEST_NO, 
                      dbo.REQUESTS.REQUEST_TYPE_ID, dbo.REQUESTS.A_M_CONTACT_ID, dbo.REQUESTS.A_M_SALES_CONTACT_ID, dbo.REQUESTS.DESCRIPTION, 
                      dbo.PROJECTS.PROJECT_NO, dbo.PROJECTS.CUSTOMER_ID, dbo.PROJECTS.JOB_NAME, dbo.PROJECTS.PROJECT_TYPE_ID, 
                      dbo.PROJECTS.END_USER_ID, dbo.CUSTOMERS.ORGANIZATION_ID, dbo.CUSTOMERS.DEALER_NAME, dbo.CUSTOMERS.CUSTOMER_NAME, 
                      CUSTOMERS_1.CUSTOMER_NAME AS END_USER, CONTACTS_1.CONTACT_NAME AS SALESPERSON, 
                      dbo.CONTACTS.CONTACT_NAME AS PROJECT_MGR, dbo.QUOTES.date_modified, dbo.SERVICES.SERVICE_ID, dbo.QUOTES.date_quoted, 
                      dbo.REQUESTS.IS_SENT_DATE
FROM         dbo.QUOTES INNER JOIN
                      dbo.REQUESTS ON dbo.QUOTES.request_id = dbo.REQUESTS.REQUEST_ID INNER JOIN
                      dbo.PROJECTS ON dbo.REQUESTS.PROJECT_ID = dbo.PROJECTS.PROJECT_ID INNER JOIN
                      dbo.CUSTOMERS ON dbo.PROJECTS.CUSTOMER_ID = dbo.CUSTOMERS.CUSTOMER_ID INNER JOIN
                      dbo.CONTACTS ON dbo.REQUESTS.A_M_CONTACT_ID = dbo.CONTACTS.CONTACT_ID LEFT OUTER JOIN
                      dbo.CONTACTS AS CONTACTS_1 ON dbo.REQUESTS.A_M_SALES_CONTACT_ID = CONTACTS_1.CONTACT_ID LEFT OUTER JOIN
                      dbo.SERVICES ON dbo.QUOTES.quote_id = dbo.SERVICES.QUOTE_ID LEFT OUTER JOIN
                      dbo.CUSTOMERS AS CUSTOMERS_1 ON dbo.PROJECTS.END_USER_ID = CUSTOMERS_1.CUSTOMER_ID
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[14] 2[15] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "QUOTES"
            Begin Extent = 
               Top = 12
               Left = 10
               Bottom = 242
               Right = 258
            End
            DisplayFlags = 280
            TopColumn = 12
         End
         Begin Table = "REQUESTS"
            Begin Extent = 
               Top = 7
               Left = 279
               Bottom = 233
               Right = 535
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PROJECTS"
            Begin Extent = 
               Top = 247
               Left = 303
               Bottom = 435
               Right = 519
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CUSTOMERS"
            Begin Extent = 
               Top = 253
               Left = 69
               Bottom = 409
               Right = 239
            End
            DisplayFlags = 280
            TopColumn = 4
         End
         Begin Table = "CONTACTS"
            Begin Extent = 
               Top = 11
               Left = 640
               Bottom = 119
               Right = 839
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CONTACTS_1"
            Begin Extent = 
               Top = 171
               Left = 681
               Bottom = 279
               Right = 880
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SERVICES"
            Begin Extent = 
               Top = 135
               Left = 593
               Bottom = 334
               Right = 817
            End
            DisplayFl' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'crystal_QUOTES_V'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'ags = 280
            TopColumn = 0
         End
         Begin Table = "CUSTOMERS_1"
            Begin Extent = 
               Top = 137
               Left = 0
               Bottom = 245
               Right = 241
            End
            DisplayFlags = 280
            TopColumn = 3
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 103
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 2085
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 2940
         Width = 2805
         Width = 2655
         Width = 2775
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 2235
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1800
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1065
         Width = 1680
         Width = 1800
         Width = 1500
         Width = 1500
         Width = 1995
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 3795
         Alias = 705
         Table = 930
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 840
         SortOrder = 660
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'crystal_QUOTES_V'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'crystal_QUOTES_V'
GO
/****** Object:  View [dbo].[UNBILLED_DATA_DAILY_CAPTURE_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[UNBILLED_DATA_DAILY_CAPTURE_V]
AS
SELECT     RECORDID, ORGANIZATION_ID, BILL_JOB_NO, job_status_type_name, job_name, BILLING_USER_ID, EXT_DEALER_ID, DEALER_NAME, 
                      CUSTOMER_NAME, job_owner, max_est_end_date, max_est_end_date_varchar, billable_total, non_billable_total, PO_NO, PooledTotal, 
                      UnbilledOpsInvoicesTotal, NAME, DATEREPORTRUN
FROM         dbo.UNBILLED_REPORT_DAILYDATACAPTURE
WHERE     (ORGANIZATION_ID = 11) AND (DATEREPORTRUN > CONVERT(DATETIME, '2007-12-01 00:00:00', 102))
GO
/****** Object:  View [dbo].[extranet_email_v2]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* $Id: extranet_email_v2.sql 1655 2009-08-05 21:24:48Z bvonhaden $ */

CREATE VIEW [dbo].[extranet_email_v2]
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
/****** Object:  View [dbo].[quick_quotes_v]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* $Id: quick_quotes_v.sql 1655 2009-08-05 21:24:48Z bvonhaden $ */

CREATE VIEW [dbo].[quick_quotes_v]
AS
SELECT CONVERT(VARCHAR, p.project_no) + '-' + CONVERT(VARCHAR, r.request_no) + '.' + ISNULL(CONVERT(VARCHAR, q.version),' ') AS project_request_version_no,  
       r.request_id,  
       r.request_no, 
       p.project_id, 
       p.project_no, 
       c.organization_id, 
       p.job_name, 
       r.customer_po_no, 
       r.dealer_po_no, 
       r.dealer_project_no, 
       r.est_start_date, 
       r.description, 
       r.is_quoted, 
       r.date_created AS record_created, 
       r.date_modified AS record_last_modified,             
       c.parent_customer_id, 
       CASE WHEN customer_type.code = 'dealer' THEN ISNULL(c.ext_customer_id, c.ext_dealer_id) ELSE c.ext_dealer_id END ext_dealer_id,
       c.dealer_name, 
       CASE WHEN customer_type.code = 'end_user' THEN c.end_user_parent_id ELSE c.customer_id END customer_id,
       CASE WHEN customer_type.code = 'end_user' THEN (SELECT customer_name FROM customers WHERE customer_id=c.end_user_parent_id) ELSE c.customer_name END customer_name,
       CASE WHEN customer_type.code = 'end_user' THEN c.customer_id ELSE eu.customer_id END end_user_id,
       CASE WHEN customer_type.code = 'end_user' THEN c.customer_name ELSE eu.customer_name END end_user_name,
       request_status.code AS record_status_code, 
       request_status.name AS record_status_name, 
       request_type.code AS record_type_code, 
       request_type.name AS record_type_name, 
       request_type.sequence_no AS record_type_seq_no, 
       r.a_m_contact_id, 
       r.customer_contact_id, 
       r.alt_customer_contact_id, 
       r.d_sales_rep_contact_id, 
       r.d_sales_sup_contact_id, 
       r.d_proj_mgr_contact_id, 
       r.d_designer_contact_id, 
       quoted_by.first_name + '  ' + quoted_by.last_name AS quoted_by_name, 
       q.quote_id, 
       q.version,
       q.quote_total, 
       q.date_quoted, 
       quote_type.code AS quote_type_code, 
       quote_type.name AS quote_type_name,
       p.is_new
  FROM dbo.requests r INNER JOIN
       dbo.projects p ON r.project_id = p.project_id INNER JOIN
       dbo.customers c ON p.customer_id = c.customer_id INNER JOIN
       dbo.quotes q ON r.request_id = q.request_id INNER JOIN
       dbo.users quoted_by ON ISNULL(q.quoted_by_user_id,q.created_by) = quoted_by.user_id INNER JOIN
       dbo.lookups quote_type ON q.quote_type_id = quote_type.lookup_id INNER JOIN
       dbo.lookups request_type ON q.request_type_id = request_type.lookup_id INNER JOIN
       dbo.lookups request_status ON q.quote_status_type_id = request_status.lookup_id INNER JOIN
       dbo.lookups customer_type ON c.customer_type_id = customer_type.lookup_id LEFT OUTER JOIN
       dbo.customers eu ON p.end_user_id = eu.customer_id
 WHERE request_type.code = 'quote' 
   AND request_status.code = 'sent'
GO
/****** Object:  View [dbo].[quick_quote_requests_v2]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* $Id: quick_quote_requests_v2.sql 1655 2009-08-05 21:24:48Z bvonhaden $ */

CREATE VIEW [dbo].[quick_quote_requests_v2]  
AS  
SELECT CONVERT(VARCHAR, p.project_no) + '-' + CONVERT(VARCHAR, r.request_no) + '.' + CONVERT(VARCHAR, r.version_no) AS project_request_version_no,   
       r.request_id,   
       r.request_no,   
       p.project_id,   
       p.project_no,   
       cust.organization_id,   
       p.job_name,  
       r.dealer_po_no,          
       r.date_created AS record_created,   
       r.date_modified AS record_last_modified,          
       CASE WHEN customer_type.code = 'dealer' THEN ISNULL(cust.ext_customer_id, cust.ext_dealer_id) ELSE cust.ext_dealer_id END ext_dealer_id,    
       CASE WHEN customer_type.code = 'end_user' THEN cust.end_user_parent_id ELSE cust.customer_id END customer_id,  
       CASE WHEN customer_type.code = 'end_user' THEN (SELECT customer_name FROM customers WHERE customer_id=cust.end_user_parent_id) ELSE cust.customer_name END customer_name,  
       CASE WHEN customer_type.code = 'end_user' THEN cust.customer_id ELSE eu.customer_id END end_user_id,  
       CASE WHEN customer_type.code = 'end_user' THEN cust.customer_name ELSE eu.customer_name END end_user_name,  
       request_status.code AS record_status_code,   
       request_status.name AS record_status_name,   
       request_type.code AS record_type_code,   
       request_type.name AS record_type_name,   
       request_type.sequence_no AS record_type_seq_no,   
       c.contact_name AS a_m_contact_name,   
       CASE WHEN EXISTS (SELECT request_id  
                           FROM quotes  
                          WHERE request_id = r.request_id AND is_sent = 'Y') THEN 'Y' ELSE 'N' END AS is_quoted,
       CASE WHEN EXISTS (SELECT request_id  
                           FROM requests  
                          WHERE quote_request_id = r.request_id) THEN 'Y' ELSE 'N' END AS has_service_request,  
       p.is_new  
  FROM dbo.requests r INNER JOIN  
       dbo.lookups request_status ON r.request_status_type_id = request_status.lookup_id INNER JOIN  
       dbo.lookups request_type ON r.request_type_id = request_type.lookup_id INNER JOIN  
       dbo.projects p ON r.project_id = p.project_id INNER JOIN  
       dbo.customers cust ON p.customer_id = cust.customer_id INNER JOIN  
       dbo.lookups customer_type ON cust.customer_type_id = customer_type.lookup_id LEFT OUTER JOIN  
       dbo.customers eu ON p.end_user_id = eu.customer_id LEFT OUTER JOIN  
       dbo.contacts c ON r.a_m_contact_id = c.contact_id  
 WHERE request_type.code='quote_request'   
   AND request_status.code <> 'closed'
GO
/****** Object:  View [dbo].[extranet_email_quote_v]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* $Id: extranet_email_quote_v.sql 1655 2009-08-05 21:24:48Z bvonhaden $ */

CREATE VIEW [dbo].[extranet_email_quote_v]
 AS
 SELECT CONVERT(VARCHAR(20), GETDATE(), 113) AS todays_date,
        CASE WHEN customer_type.code = 'end_user' THEN (SELECT customer_name FROM customers WHERE customer_id = cust.end_user_Parent_id) ELSE cust.customer_name END customer_name,
        CASE WHEN customer_type.code = 'end_user' THEN cust.customer_name ELSE eu.customer_name END end_user_name,
        p.job_name,
        p.project_no,
        CONVERT(VARCHAR, p.project_no) + '-' + CONVERT(VARCHAR, q.quote_no) + '.' + ISNULL(CONVERT(VARCHAR, q.version),' ') AS record_no,
        q.quote_id record_id,
        request_type.code AS record_type_code,
        request_type.name AS record_type_name,
        quote_status_type.code AS record_status_type_code,
        r.a_m_contact_id,
        r.a_m_sales_contact_id,
        r.customer_contact_id,
        r.customer_contact2_id,
        r.customer_contact3_id,
        r.customer_contact4_id,
        r.d_sales_rep_contact_id,
        r.d_sales_sup_contact_id,
        r.d_proj_mgr_contact_id,
        r.d_designer_contact_id,
        r.a_m_install_sup_contact_id,
        r.furniture1_contact_id,
        r.furniture2_contact_id,
        r.approver_contact_id,
        r.alt_customer_contact_id,
        r.a_d_designer_contact_id,
        r.gen_contractor_contact_id,
        r.electrician_contact_id,
        r.data_phone_contact_id,
        r.carpet_layer_contact_id,
        r.bldg_mgr_contact_id,
        r.security_contact_id,
        r.mover_contact_id,
        r.phone_contact_id,
        r.other_contact_id,
        r.est_start_date,
        q.description,
        cust.refusal_email_info,
        cust.survey_location,
        o.scheduler_contact_id,
        customer_contact.contact_name AS customer_contact_name,
        approver_contact.contact_name AS approver_contact_name,
        phone_contact.contact_name AS phone_contact_name,
        p.is_new
   FROM dbo.quotes q INNER JOIN
        dbo.lookups request_type ON q.request_type_id = request_type.lookup_id INNER JOIN
        dbo.requests r ON q.request_id = r.request_id INNER JOIN
        dbo.lookups quote_status_type ON quote_status_type.lookup_id = q.quote_status_type_id INNER JOIN
        dbo.projects p ON r.project_id = p.project_id INNER JOIN
        dbo.customers cust ON p.customer_id = cust.customer_id INNER JOIN
        dbo.lookups customer_type ON cust.customer_type_id = customer_type.lookup_id INNER JOIN
        dbo.organizations o ON cust.organization_id = o.organization_id LEFT OUTER JOIN
        dbo.customers eu ON p.end_user_id = eu.customer_id LEFT OUTER JOIN
        dbo.contacts approver_contact ON r.approver_contact_id = approver_contact.contact_id  LEFT OUTER JOIN
        dbo.contacts customer_contact ON r.customer_contact_id = customer_contact.contact_id LEFT OUTER JOIN
        dbo.contacts phone_contact ON r.phone_contact_id = phone_contact.contact_id
GO
/****** Object:  View [dbo].[extranet_email_none_quote_v]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* $Id: extranet_email_none_quote_v.sql 1655 2009-08-05 21:24:48Z bvonhaden $ */

CREATE VIEW [dbo].[extranet_email_none_quote_v]
AS
SELECT CONVERT(VARCHAR(20), GETDATE(), 113) AS todays_date, 
       cust.customer_name,
       p.job_name, 
       p.project_no, 
       CONVERT(VARCHAR, p.project_no) + '-' + CONVERT(VARCHAR, r.request_no) + '.' + CONVERT(VARCHAR, r.version_no) AS record_no, 
       r.request_id record_id, 
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
       r.d_proj_mgr_contact_id, 
       r.d_designer_contact_id, 
       r.a_m_install_sup_contact_id,
       r.description, 
       r.furniture1_contact_id, 
       r.furniture2_contact_id, 
       r.approver_contact_id, 
       r.alt_customer_contact_id,
       r.a_d_designer_contact_id, 
       r.gen_contractor_contact_id, 
       r.electrician_contact_id, 
       r.data_phone_contact_id, 
       r.carpet_layer_contact_id, 
       r.bldg_mgr_contact_id, 
       r.security_contact_id, 
       r.mover_contact_id, 
       r.phone_contact_id, 
       r.other_contact_id,
       r.est_start_date,
       cust.refusal_email_info, 
       cust.survey_location,
       o.scheduler_contact_id,
       customer_contact.contact_name AS customer_contact_name, 
       approver_contact.contact_name AS approver_contact_name, 
       phone_contact.contact_name AS phone_contact_name,
       p.is_new
  FROM dbo.requests r INNER JOIN 
       dbo.lookups request_type ON r.request_type_id = request_type.lookup_id INNER JOIN
       dbo.lookups request_status_type ON r.request_status_type_id = request_status_type.lookup_id INNER JOIN
       dbo.projects p ON r.project_id = p.project_id INNER JOIN
       dbo.customers cust ON p.customer_id = cust.customer_id INNER JOIN
       dbo.organizations o ON cust.organization_id = o.organization_id LEFT OUTER JOIN
       dbo.contacts approver_contact ON r.approver_contact_id = approver_contact.contact_id  LEFT OUTER JOIN
       dbo.contacts customer_contact ON r.customer_contact_id = customer_contact.contact_id LEFT OUTER JOIN
       dbo.contacts phone_contact ON r.phone_contact_id = phone_contact.contact_id
GO
/****** Object:  View [dbo].[versions_copy_v]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[versions_copy_v]
AS    
SELECT project_id,
request_no,
version_no,
request_type_id,
request_status_type_id,
is_sent,
is_sent_date,
is_quoted,
quote_request_id,
dealer_cust_id,
customer_po_no,
dealer_po_no,
dealer_po_line_no,
dealer_project_no,
design_project_no,
project_volume,
account_type_id,
quote_type_id,
quote_needed_by,
job_location_id,
customer_contact_id,
alt_customer_contact_id,
d_sales_rep_contact_id,
d_sales_sup_contact_id,
d_proj_mgr_contact_id,
d_designer_contact_id,
a_m_contact_id,
a_m_install_sup_contact_id,
a_d_designer_contact_id,
gen_contractor_contact_id,
electrician_contact_id,
data_phone_contact_id,
carpet_layer_contact_id,
bldg_mgr_contact_id,
security_contact_id,
mover_contact_id,
other_contact_id,
pri_furn_type_id,
pri_furn_line_type_id,
sec_furn_type_id,
sec_furn_line_type_id,
case_furn_type_id,
case_furn_line_type_id,
wood_product_type_id,
warehouse_loc,
furn_plan_type_id,
plan_location,
furn_spec_type_id,
workstation_typical_type_id,
power_type,
punchlist_item_type_id,
punchlist_line,
wall_mount_type_id,
init_proj_team_mtg_date,
design_presentation_date,
design_completion_date,
spec_check_cmpl_date,
dealer_order_placed_date,
int_pre_install_mtg_date,
ext_pre_install_mtg_date,
dealer_install_plan_date,
mfg_ship_date,
prod_del_to_wh_date,
truck_arrival_time,
construct_complete_date,
electrical_complete_date,
cable_complete_date,
carpet_complete_date,
site_visit_req_type_id,
site_visit_date,
product_del_to_site_date,
schedule_type_id,
est_start_date,
est_start_time,
est_end_date,
days_to_complete,
move_in_date,
punchlist_complete_date,
coord_phone_data_type_id,
coord_wall_covr_type_id,
coord_floor_covr_type_id,
coord_electrical_type_id,
coord_mover_type_id,
activity_type_id1,
qty1,
activity_cat_type_id1,
activity_type_id2,
qty2,
activity_cat_type_id2,
activity_type_id3,
qty3,
activity_cat_type_id3,
activity_type_id4,
qty4,
activity_cat_type_id4,
activity_type_id5,
qty5,
activity_cat_type_id5,
activity_type_id6,
qty6,
activity_cat_type_id6,
activity_type_id7,
qty7,
activity_cat_type_id7,
activity_type_id8,
qty8,
activity_cat_type_id8,
activity_type_id9,
qty9,
activity_cat_type_id9,
activity_type_id10,
qty10,
activity_cat_type_id10,
description,
approval_req_type_id,
who_can_approve_name,
who_can_approve_phone,
regular_hours_type_id,
evening_hours_type_id,
weekend_hours_type_id,
union_labor_req_type_id,
cost_to_cust_type_id,
cost_to_vend_type_id,
cost_to_job_type_id,
warehouse_fee_type_id,
taxable_flag,
duration_time_uom_type_id,
duration_qty,
phased_install_type_id,
loading_dock_type_id,
dock_available_time,
dock_reserv_req_type_id,
semi_access_type_id,
dock_height,
elevator_avail_type_id,
elevator_avail_time,
elevator_reserv_req_type_id,
stair_carry_type_id,
stair_carry_flights,
stair_carry_stairs,
smallest_door_elev_width,
floor_protection_type_id,
wall_protection_type_id,
doorway_prot_type_id,
walkboard_type_id,
staging_area_type_id,
dumpster_type_id,
new_site_type_id,
occupied_site_type_id,
other_conditions,
p_card_number,
furniture1_contact_id,
furniture2_contact_id,
approver_contact_id,
phone_contact_id,
floor_number_type_id,
priority_type_id,
level_type_id,
furn_req_type_id,
cust_contact_mod_date,
job_location_mod_date,
cust_col_1,
cust_col_2,
cust_col_3,
cust_col_4,
cust_col_5,
cust_col_6,
cust_col_7,
cust_col_8,
cust_col_9,
cust_col_10,
is_copy,
is_surveyed,
furniture_type,
furniture_qty,
prod_disp_flag,
prod_disp_id,
a_m_sales_contact_id,
work_order_received_date,
csc_wo_field_flag,
customer_costing_type_id,
customer_contact2_id,
customer_contact3_id,
customer_contact4_id,
job_location_contact_id,
system_furniture_line_type_id,
delivery_type_id,
other_furniture_type_id,
other_delivery_type_id,
other_furniture_desc,
schedule_with_client_flag,
order_type_id,
is_stair_carry_required,
date_created,
created_by,
date_modified,
modified_by
  FROM requests r
GO
/****** Object:  View [dbo].[quick_requests_v2]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* $Id: quick_requests_v2.sql 1655 2009-08-05 21:24:48Z bvonhaden $ */

CREATE VIEW [dbo].[quick_requests_v2]
AS
SELECT CONVERT(VARCHAR, p.project_no) + '-' + CONVERT(VARCHAR, r.request_no) + '.' + CONVERT(VARCHAR, r.version_no) AS project_request_version_no, 
       r.request_id, 
       r.request_no,
       p.project_id, 
       p.project_no, 
       c.organization_id,
       p.job_name,        
       r.dealer_po_no, 
       r.est_start_date, 
       r.description, 
       CASE WHEN customer_type.code = 'dealer' THEN ISNULL(c.ext_customer_id, c.ext_dealer_id) ELSE c.ext_dealer_id END ext_dealer_id, 
       CASE WHEN customer_type.code = 'end_user' THEN c.end_user_parent_id ELSE p.customer_id END customer_id,
       CASE WHEN customer_type.code = 'end_user' THEN (SELECT customer_name FROM customers WHERE customer_id=c.end_user_parent_id) ELSE c.customer_name END customer_name,
       CASE WHEN customer_type.code = 'end_user' THEN c.customer_id ELSE eu.customer_id END end_user_id,
       CASE WHEN customer_type.code = 'end_user' THEN c.customer_name ELSE eu.customer_name END end_user_name, 
       request_status.code AS record_status_code, 
       request_status.name AS record_status_name, 
       request_type.code AS record_type_code, 
       request_type.name AS record_type_name, 
       project_status.code AS project_status_code, 
       project_status.name AS project_status_name,
       r.is_quoted, 
       p.is_new
  FROM dbo.requests r INNER JOIN
       dbo.lookups request_status ON r.request_status_type_id = request_status.lookup_id INNER JOIN
       dbo.lookups request_type ON r.request_type_id = request_type.lookup_id INNER JOIN
       dbo.projects p ON r.project_id = p.project_id INNER JOIN
       dbo.customers c ON p.customer_id = c.customer_id INNER JOIN
       dbo.lookups project_status ON p.project_status_type_id = project_status.lookup_id INNER JOIN
       dbo.lookups customer_type ON c.customer_type_id = customer_type.lookup_id LEFT OUTER JOIN
       dbo.customers eu ON p.end_user_id = eu.customer_id 
 WHERE request_type.code = 'service_request'
   AND request_status.code <> 'closed'
GO
/****** Object:  View [dbo].[crystal_QUOTES_OTHER_FURN_V]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[crystal_QUOTES_OTHER_FURN_V]
AS
SELECT     QUOTE_ID, DESCRIPTION, BILL, DATE_CREATED
FROM         dbo.QUOTE_OTHER_FURNITURE_AD_HOC
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "QUOTE_OTHER_FURNITURE_AD_HOC"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 226
               Right = 357
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'crystal_QUOTES_OTHER_FURN_V'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'crystal_QUOTES_OTHER_FURN_V'
GO
/****** Object:  View [dbo].[JOB_COSTING_V]    Script Date: 05/03/2010 14:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[JOB_COSTING_V]
AS
SELECT     dbo.SERVICE_LINES.TC_JOB_ID, dbo.SERVICE_LINES.TC_SERVICE_ID, dbo.SERVICE_LINES.BILL_JOB_ID, dbo.SERVICE_LINES.BILL_SERVICE_ID, 
                      dbo.SERVICE_LINES.ITEM_ID, dbo.SERVICE_LINES.ITEM_NAME, dbo.SERVICE_LINES.ITEM_TYPE_CODE, dbo.SERVICE_LINES.TC_QTY, 
                      dbo.SERVICE_LINES.TC_RATE, dbo.SERVICE_LINES.tc_total, dbo.ITEMS.COST_PER_UOM, dbo.ITEMS.COLUMN_POSITION, 
                      dbo.SERVICE_LINES.ENTRY_METHOD
FROM         dbo.SERVICE_LINES INNER JOIN
                      dbo.ITEMS ON dbo.SERVICE_LINES.ITEM_ID = dbo.ITEMS.ITEM_ID
WHERE     (dbo.SERVICE_LINES.STATUS_ID >= 3) AND (dbo.SERVICE_LINES.INTERNAL_REQ_FLAG = 'N')
GO
/****** Object:  View [dbo].[service_line_edit_v]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[service_line_edit_v]
AS
SELECT     ORGANIZATION_ID, SERVICE_LINE_ID, TC_JOB_NO, TC_SERVICE_NO, TC_SERVICE_LINE_NO, SERVICE_LINE_DATE, STATUS_ID, EXPORTED_FLAG, 
                      BILLED_FLAG, POSTED_FLAG, POOLED_FLAG, RESOURCE_ID, RESOURCE_NAME, ITEM_ID, ITEM_NAME, ITEM_TYPE_CODE, INVOICE_ID, 
                      POSTED_FROM_INVOICE_ID, TC_QTY, TC_RATE, TC_TOTAL, PAYROLL_QTY, PAYROLL_RATE, PAYROLL_TOTAL, EXT_PAY_CODE, 
                      PAYROLL_EXPORTED_FLAG, ALLOCATED_QTY, INTERNAL_REQ_FLAG, PARTIALLY_ALLOCATED_FLAG, FULLY_ALLOCATED_FLAG, ENTERED_DATE, 
                      ENTERED_BY, ENTRY_METHOD, OVERRIDE_DATE, OVERRIDE_BY, OVERRIDE_REASON, VERIFIED_DATE, VERIFIED_BY, DATE_CREATED, 
                      CREATED_BY, DATE_MODIFIED, MODIFIED_BY
FROM         dbo.SERVICE_LINES
WHERE     (TC_JOB_NO = 391200) AND (TC_SERVICE_LINE_NO = 764)
GO
/****** Object:  View [dbo].[PKT_SERVICE_LINES_V]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[PKT_SERVICE_LINES_V]
AS
SELECT     dbo.SERVICE_LINES.TC_JOB_ID AS job_id, dbo.SERVICE_LINES.TC_SERVICE_ID AS service_id, dbo.SERVICE_LINES.SERVICE_LINE_ID, 
                      dbo.SERVICE_LINES.TC_SERVICE_LINE_NO AS service_line_no, dbo.SERVICE_LINE_STATUSES.CODE AS status_code, 
                      dbo.SERVICE_LINES.STATUS_ID, dbo.SERVICE_LINES.TC_QTY AS qty, dbo.SERVICE_LINES.RESOURCE_ID, 
                      dbo.RESOURCES.NAME AS resource_name, dbo.SERVICE_LINES.ITEM_ID, dbo.ITEMS.NAME AS item_name, 
                      dbo.SERVICE_LINES.SERVICE_LINE_DATE, dbo.SERVICE_LINES.TC_SERVICE_NO AS service_no, dbo.RESOURCES.USER_ID
FROM         dbo.SERVICE_LINES INNER JOIN
                      dbo.SERVICE_LINE_STATUSES ON dbo.SERVICE_LINES.STATUS_ID = dbo.SERVICE_LINE_STATUSES.STATUS_ID INNER JOIN
                      dbo.RESOURCES ON dbo.SERVICE_LINES.RESOURCE_ID = dbo.RESOURCES.RESOURCE_ID INNER JOIN
                      dbo.ITEMS ON dbo.SERVICE_LINES.ITEM_ID = dbo.ITEMS.ITEM_ID
GO
/****** Object:  View [dbo].[crystal_TIME_CAPTURE_V]    Script Date: 05/03/2010 14:18:06 ******/
-- SET ANSI_NULLS ON
-- GO
-- SET QUOTED_IDENTIFIER OFF
-- GO
-- CREATE VIEW [dbo].[crystal_TIME_CAPTURE_V]
-- AS
-- SELECT     dbo.SERVICE_LINES.ORGANIZATION_ID, dbo.SERVICE_LINES.TC_JOB_NO, dbo.SERVICE_LINES.TC_SERVICE_NO,
--                       dbo.SERVICE_LINES.TC_SERVICE_LINE_NO, dbo.SERVICE_LINES.BILL_JOB_NO, dbo.SERVICE_LINES.BILL_SERVICE_NO,
--                       dbo.SERVICE_LINES.BILL_SERVICE_LINE_NO, dbo.JOBS_V.JOB_NAME, dbo.SERVICE_LINES.RESOURCE_NAME, dbo.SERVICE_LINES.ITEM_NAME,
--                       dbo.JOBS_V.billing_user_name, dbo.JOBS_V.foreman_resource_name, dbo.SERVICE_LINES.TC_JOB_ID, dbo.SERVICE_LINES.TC_SERVICE_ID,
--                       dbo.SERVICE_LINES.BILL_JOB_ID, dbo.SERVICE_LINES.BILL_SERVICE_ID, dbo.SERVICE_LINES.PH_SERVICE_ID,
--                       dbo.SERVICE_LINES.SERVICE_LINE_ID, CAST(dbo.SERVICES.JOB_ID AS varchar) + '-' + CAST(dbo.SERVICE_LINES.ITEM_ID AS varchar)
--                       + '-' + CAST(dbo.SERVICE_LINES.STATUS_ID AS varchar) AS job_item_status_id, CAST(dbo.SERVICE_LINES.TC_SERVICE_ID AS varchar)
--                       + '-' + CAST(dbo.SERVICE_LINES.STATUS_ID AS varchar) AS service_status_id, CAST(dbo.SERVICES.SERVICE_ID AS varchar)
--                       + '-' + CAST(dbo.SERVICE_LINES.ITEM_ID AS varchar) + '-' + CAST(dbo.SERVICE_LINES.STATUS_ID AS varchar) AS service_item_status_id,
--                       dbo.JOBS_V.BILLING_USER_ID, dbo.JOBS_V.foreman_user_id, CAST(dbo.SERVICE_LINES.SERVICE_LINE_DATE AS datetime)
--                       AS SERVICE_LINE_DATE, dbo.SERVICE_LINES.SERVICE_LINE_DATE_VARCHAR, CAST(dbo.SERVICE_LINES.SERVICE_LINE_WEEK AS DATETIME)
--                       AS SERVICE_LINE_WEEK, dbo.SERVICE_LINES.SERVICE_LINE_WEEK_VARCHAR, dbo.JOBS_V.job_status_type_code,
--                       dbo.JOBS_V.job_status_type_name, SERV_STATUS_TYPES.CODE AS serv_status_type_code,
--                       SERV_STATUS_TYPES.NAME AS serv_status_type_name, dbo.SERVICE_LINES.STATUS_ID, dbo.SERVICE_LINE_STATUSES.NAME AS status_name,
--                       dbo.SERVICE_LINES.EXPORTED_FLAG, dbo.SERVICE_LINES.BILLED_FLAG, dbo.SERVICE_LINES.POSTED_FLAG,
--                       dbo.SERVICE_LINES.POOLED_FLAG, dbo.SERVICE_LINES.RESOURCE_ID, dbo.SERVICE_LINES.ITEM_ID, dbo.SERVICE_LINES.ITEM_TYPE_CODE,
--                       dbo.SERVICE_LINES.BILLABLE_FLAG, dbo.SERVICE_LINES.TC_QTY, dbo.SERVICE_LINES.TC_RATE, dbo.SERVICE_LINES.TC_TOTAL,
--                       dbo.SERVICE_LINES.PAYROLL_QTY, dbo.SERVICE_LINES.PAYROLL_RATE, dbo.SERVICE_LINES.PAYROLL_TOTAL,
--                       dbo.SERVICE_LINES.EXT_PAY_CODE, dbo.SERVICE_LINES.EXPENSE_QTY, dbo.SERVICE_LINES.EXPENSE_RATE,
--                       dbo.SERVICE_LINES.EXPENSE_TOTAL, dbo.SERVICE_LINES.BILL_QTY, dbo.SERVICE_LINES.BILL_RATE, dbo.SERVICE_LINES.BILL_TOTAL,
--                       dbo.SERVICE_LINES.BILL_EXP_QTY, dbo.SERVICE_LINES.BILL_EXP_RATE, dbo.SERVICE_LINES.BILL_EXP_TOTAL,
--                       dbo.SERVICE_LINES.BILL_HOURLY_QTY, dbo.SERVICE_LINES.BILL_HOURLY_RATE, dbo.SERVICE_LINES.BILL_HOURLY_TOTAL,
--                       dbo.SERVICE_LINES.ALLOCATED_QTY, dbo.SERVICE_LINES.INTERNAL_REQ_FLAG, dbo.SERVICE_LINES.PARTIALLY_ALLOCATED_FLAG,
--                       dbo.SERVICE_LINES.FULLY_ALLOCATED_FLAG, dbo.SERVICE_LINES.PALM_REP_ID, CAST(dbo.SERVICE_LINES.ENTERED_DATE AS SMALLDATETIME(10)) AS DATE_ENTERED,
--                       dbo.SERVICE_LINES.ENTERED_BY, USERS_1.FULL_NAME AS entered_by_name, dbo.SERVICE_LINES.ENTRY_METHOD,
--                       dbo.SERVICE_LINES.OVERRIDE_DATE, dbo.SERVICE_LINES.OVERRIDE_BY, USERS_1.FULL_NAME AS override_by_name,
--                       dbo.SERVICE_LINES.OVERRIDE_REASON, dbo.SERVICE_LINES.VERIFIED_DATE, dbo.SERVICE_LINES.VERIFIED_BY,
--                       USERS_2.FULL_NAME AS verified_by_name, dbo.SERVICES.DESCRIPTION AS service_description,
--                       Convert(varchar, dbo.SERVICE_LINES.DATE_CREATED,101) as DATE_CREATED , dbo.SERVICE_LINES.CREATED_BY,
--                       USERS_3.FULL_NAME AS created_by_name, dbo.SERVICE_LINES.DATE_MODIFIED, dbo.SERVICE_LINES.MODIFIED_BY,
--                       USERS_4.FULL_NAME AS modified_by_name
-- FROM         dbo.LOOKUPS SERV_STATUS_TYPES RIGHT OUTER JOIN
--                       dbo.JOBS_V RIGHT OUTER JOIN
--                       dbo.SERVICES ON dbo.JOBS_V.JOB_ID = dbo.SERVICES.JOB_ID ON
--                       SERV_STATUS_TYPES.LOOKUP_ID = dbo.SERVICES.SERV_STATUS_TYPE_ID RIGHT OUTER JOIN
--                       dbo.SERVICE_LINE_STATUSES RIGHT OUTER JOIN
--                       dbo.USERS USERS_4 RIGHT OUTER JOIN
--                       dbo.USERS USERS_5 RIGHT OUTER JOIN
--                       dbo.USERS USERS_1 RIGHT OUTER JOIN
--                       dbo.SERVICE_LINES ON USERS_1.USER_ID = dbo.SERVICE_LINES.OVERRIDE_BY ON
--                       USERS_5.USER_ID = dbo.SERVICE_LINES.ENTERED_BY LEFT OUTER JOIN
--                       dbo.USERS USERS_2 ON dbo.SERVICE_LINES.VERIFIED_BY = USERS_2.USER_ID ON
--                       USERS_4.USER_ID = dbo.SERVICE_LINES.MODIFIED_BY LEFT OUTER JOIN
--                       dbo.USERS USERS_3 ON dbo.SERVICE_LINES.CREATED_BY = USERS_3.USER_ID ON
--                       dbo.SERVICE_LINE_STATUSES.STATUS_ID = dbo.SERVICE_LINES.STATUS_ID ON
--                       dbo.SERVICES.SERVICE_ID = dbo.SERVICE_LINES.TC_SERVICE_ID
-- WHERE     (dbo.SERVICE_LINES.RESOURCE_NAME IS NOT NULL)
-- GO
/****** Object:  View [dbo].[EXPENSES_BATCHES_V]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[EXPENSES_BATCHES_V]
AS
SELECT     dbo.EXPENSES_BATCHES.ORGANIZATION_ID, dbo.SERVICE_LINES.TC_JOB_ID, dbo.SERVICE_LINES.TC_JOB_NO, 
                      dbo.SERVICE_LINES.TC_SERVICE_NO, dbo.SERVICE_LINES.TC_SERVICE_LINE_NO, dbo.EXPENSES_BATCHES.INT_BATCH_ID, 
                      dbo.EXPENSES_BATCHES.EXT_BATCH_ID, dbo.EXPENSES_BATCHES.BEGIN_DATE, dbo.EXPENSES_BATCHES.END_DATE, CONVERT(varchar(12), 
                      dbo.EXPENSES_BATCHES.BEGIN_DATE, 101) AS begin_date_varchar, CONVERT(varchar(12), dbo.EXPENSES_BATCHES.END_DATE, 101) 
                      AS end_date_varchar, CONVERT(varchar(12), dbo.EXPENSES_BATCHES.DATE_CREATED, 101) AS date_created_varchar, 
                      dbo.EXPENSES_BATCH_LINES.SERVICE_LINE_ID, dbo.SERVICE_LINES.EXPENSE_QTY, dbo.SERVICE_LINES.EXPENSE_RATE, 
                      dbo.SERVICE_LINES.EXPENSE_TOTAL, dbo.SERVICE_LINES.ITEM_NAME, dbo.ITEMS.EXT_ITEM_ID, dbo.RESOURCES.USER_ID, 
                      dbo.USERS.EXT_EMPLOYEE_ID, dbo.USERS.FULL_NAME AS employee_name, dbo.EXPENSES_BATCHES.EXPENSES_BATCH_STATUS_TYPE_ID, 
                      dbo.LOOKUPS.CODE AS expenses_batch_status_type_code, dbo.LOOKUPS.NAME AS expenses_batch_status_type_name, 
                      dbo.SERVICE_LINES.SERVICE_LINE_DATE, dbo.SERVICE_LINES.SERVICE_LINE_DATE_VARCHAR, dbo.SERVICE_LINES.SERVICE_LINE_WEEK, 
                      dbo.SERVICE_LINES.SERVICE_LINE_WEEK_VARCHAR, dbo.ITEMS.EXPENSE_EXPORT_CODE
FROM         dbo.USERS RIGHT OUTER JOIN
                      dbo.RESOURCES RIGHT OUTER JOIN
                      dbo.LOOKUPS RIGHT OUTER JOIN
                      dbo.EXPENSES_BATCHES LEFT OUTER JOIN
                      dbo.ITEMS RIGHT OUTER JOIN
                      dbo.EXPENSES_BATCH_LINES LEFT OUTER JOIN
                      dbo.SERVICE_LINES ON dbo.EXPENSES_BATCH_LINES.SERVICE_LINE_ID = dbo.SERVICE_LINES.SERVICE_LINE_ID ON 
                      dbo.ITEMS.ITEM_ID = dbo.SERVICE_LINES.ITEM_ID ON dbo.EXPENSES_BATCHES.INT_BATCH_ID = dbo.EXPENSES_BATCH_LINES.INT_BATCH_ID ON
                       dbo.LOOKUPS.LOOKUP_ID = dbo.EXPENSES_BATCHES.EXPENSES_BATCH_STATUS_TYPE_ID ON 
                      dbo.RESOURCES.RESOURCE_ID = dbo.SERVICE_LINES.RESOURCE_ID ON dbo.USERS.USER_ID = dbo.RESOURCES.USER_ID
GO
/****** Object:  View [dbo].[crystal_SCH_ACT_2_V]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[crystal_SCH_ACT_2_V]
AS
SELECT     TC_JOB_NO, TC_SERVICE_NO, SERVICE_LINE_DATE, RESOURCE_ID, RESOURCE_NAME, ITEM_NAME, TC_QTY, OVERRIDE_DATE, VERIFIED_DATE, 
                      VERIFIED_BY, SERVICE_LINE_ID, TC_SERVICE_ID
FROM         dbo.SERVICE_LINES
GO
/****** Object:  View [dbo].[PAYROLL_V]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[PAYROLL_V]
AS
SELECT     dbo.SERVICE_LINES.ORGANIZATION_ID, dbo.SERVICE_LINES.TC_JOB_ID, dbo.SERVICE_LINES.TC_SERVICE_ID, 
                      dbo.SERVICE_LINES.SERVICE_LINE_ID, dbo.SERVICE_LINES.TC_JOB_NO, dbo.SERVICE_LINES.TC_SERVICE_NO, 
                      dbo.SERVICE_LINES.TC_SERVICE_LINE_NO, dbo.SERVICE_LINES.SERVICE_LINE_DATE, dbo.SERVICE_LINES.SERVICE_LINE_DATE_VARCHAR, 
                      dbo.SERVICE_LINES.SERVICE_LINE_WEEK, dbo.SERVICE_LINES.SERVICE_LINE_WEEK_VARCHAR, dbo.SERVICE_LINES.PAYROLL_QTY, 
                      dbo.SERVICE_LINES.PAYROLL_RATE, dbo.SERVICE_LINES.PAYROLL_TOTAL, dbo.SERVICE_LINES.EXT_PAY_CODE, dbo.USERS.EXT_EMPLOYEE_ID, 
                      dbo.USERS.FULL_NAME AS employee_name, dbo.ITEMS.EXT_ITEM_ID, dbo.SERVICE_LINES.ITEM_ID, dbo.SERVICE_LINES.ITEM_NAME, 
                      dbo.SERVICE_LINES.ITEM_TYPE_CODE, dbo.SERVICE_LINES.PAYROLL_EXPORTED_FLAG, dbo.RESOURCES.USER_ID, 
                      dbo.RESOURCES.NAME AS resource_name, dbo.SERVICE_LINES.STATUS_ID
FROM         dbo.LOOKUPS RIGHT OUTER JOIN
                      dbo.SERVICE_LINES LEFT OUTER JOIN
                      dbo.USERS RIGHT OUTER JOIN
                      dbo.RESOURCES ON dbo.USERS.USER_ID = dbo.RESOURCES.USER_ID ON 
                      dbo.SERVICE_LINES.RESOURCE_ID = dbo.RESOURCES.RESOURCE_ID LEFT OUTER JOIN
                      dbo.ITEMS ON dbo.SERVICE_LINES.ITEM_ID = dbo.ITEMS.ITEM_ID ON dbo.LOOKUPS.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID
WHERE     (dbo.RESOURCES.USER_ID IS NOT NULL) AND (dbo.SERVICE_LINES.STATUS_ID > 1) AND (dbo.SERVICE_LINES.PAYROLL_QTY > 0) AND 
                      (dbo.SERVICE_LINES.ITEM_TYPE_CODE = 'hours')
GO
/****** Object:  View [dbo].[PAYROLL_BATCHES_V]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[PAYROLL_BATCHES_V]
AS
SELECT     dbo.PAYROLL_BATCHES.ORGANIZATION_ID, dbo.SERVICE_LINES.TC_JOB_ID, dbo.SERVICE_LINES.TC_SERVICE_ID, 
                      dbo.SERVICE_LINES.TC_JOB_NO, dbo.SERVICE_LINES.TC_SERVICE_NO, dbo.SERVICE_LINES.TC_SERVICE_LINE_NO, 
                      dbo.PAYROLL_BATCHES.INT_BATCH_ID, dbo.PAYROLL_BATCHES.EXT_BATCH_ID, dbo.PAYROLL_BATCHES.BEGIN_DATE, 
                      dbo.PAYROLL_BATCHES.END_DATE, CONVERT(varchar(12), dbo.PAYROLL_BATCHES.BEGIN_DATE, 101) AS begin_date_varchar, 
                      CONVERT(varchar(12), dbo.PAYROLL_BATCHES.END_DATE, 101) AS end_date_varchar, CONVERT(varchar(12), 
                      dbo.PAYROLL_BATCHES.DATE_CREATED, 101) AS date_created_varchar, dbo.PAYROLL_BATCH_LINES.SERVICE_LINE_ID, 
                      dbo.SERVICE_LINES.PAYROLL_QTY, dbo.SERVICE_LINES.PAYROLL_RATE, dbo.SERVICE_LINES.EXT_PAY_CODE, dbo.SERVICE_LINES.ITEM_NAME, 
                      dbo.ITEMS.EXT_ITEM_ID, dbo.RESOURCES.USER_ID, dbo.USERS.EXT_EMPLOYEE_ID, dbo.USERS.FULL_NAME AS employee_name, 
                      dbo.PAYROLL_BATCHES.PAYROLL_BATCH_STATUS_TYPE_ID, dbo.LOOKUPS.CODE AS payroll_batch_status_type_code, 
                      dbo.LOOKUPS.NAME AS payroll_batch_status_type_name, dbo.SERVICE_LINES.SERVICE_LINE_DATE, 
                      dbo.SERVICE_LINES.SERVICE_LINE_DATE_VARCHAR, dbo.SERVICE_LINES.SERVICE_LINE_WEEK, 
                      dbo.SERVICE_LINES.SERVICE_LINE_WEEK_VARCHAR
FROM         dbo.USERS RIGHT OUTER JOIN
                      dbo.RESOURCES RIGHT OUTER JOIN
                      dbo.LOOKUPS RIGHT OUTER JOIN
                      dbo.PAYROLL_BATCHES LEFT OUTER JOIN
                      dbo.ITEMS RIGHT OUTER JOIN
                      dbo.PAYROLL_BATCH_LINES LEFT OUTER JOIN
                      dbo.SERVICE_LINES ON dbo.PAYROLL_BATCH_LINES.SERVICE_LINE_ID = dbo.SERVICE_LINES.SERVICE_LINE_ID ON 
                      dbo.ITEMS.ITEM_ID = dbo.SERVICE_LINES.ITEM_ID ON dbo.PAYROLL_BATCHES.INT_BATCH_ID = dbo.PAYROLL_BATCH_LINES.INT_BATCH_ID ON 
                      dbo.LOOKUPS.LOOKUP_ID = dbo.PAYROLL_BATCHES.PAYROLL_BATCH_STATUS_TYPE_ID ON 
                      dbo.RESOURCES.RESOURCE_ID = dbo.SERVICE_LINES.RESOURCE_ID ON dbo.USERS.USER_ID = dbo.RESOURCES.USER_ID
GO
/****** Object:  View [dbo].[TC_VERIFIED_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[TC_VERIFIED_V]
AS
SELECT     ORGANIZATION_ID, SERVICE_LINE_ID, TC_JOB_NO, TC_SERVICE_NO, TC_SERVICE_LINE_NO, SERVICE_LINE_DATE, STATUS_ID, TC_JOB_ID, 
                      TC_SERVICE_ID, RESOURCE_ID, RESOURCE_NAME, ITEM_ID, ITEM_NAME, TC_QTY, TC_RATE, TC_TOTAL, PALM_REP_ID, ENTERED_DATE, 
                      ENTERED_BY, ENTRY_METHOD, VERIFIED_DATE, VERIFIED_BY, DATE_CREATED, CREATED_BY, DATE_MODIFIED, MODIFIED_BY
FROM         dbo.SERVICE_LINES
WHERE     (VERIFIED_BY IS NULL) AND (DATE_CREATED > CONVERT(DATETIME, '2004-01-01 00:00:00', 102))
GO
/****** Object:  View [dbo].[jobs_with_posted_costs_v]    Script Date: 05/03/2010 14:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[jobs_with_posted_costs_v] 
AS 
SELECT TOP 100 PERCENT o.organization_id,
       sl.invoice_id,
       sl.status_id,
       o.name AS [Organization Name],
       j.job_no AS [Job No],
       job_type.name AS [Job Type],
       CASE WHEN customer_type.code = 'end_user' THEN (SELECT customer_name FROM customers WHERE customer_id = cust.end_user_parent_id) ELSE cust.customer_name END AS [Customer Name], 
       CASE WHEN customer_type.code = 'end_user' THEN cust.customer_name ELSE eu.customer_name END AS [End User Name], 
       u1.first_name + ' ' + u1.last_name AS [Job Owner],
       NULL AS [Invoice No],
       sl.invoice_post_date AS [Invoiced Date],
       u2.first_name + ' ' + u2.last_name AS [Posted By],
       r.name AS [Job Supervisor],
       c.contact_name AS [SP Sales],
       0 AS [Total Invoiced],
       SUM(ISNULL(sl.bill_qty * labor_items.cost_per_uom, 0)) AS [labor cost],
       SUM(ISNULL(sl.bill_qty * truck_items.cost_per_uom, 0)) AS [truck cost],
       SUM(ISNULL(sl.bill_qty * sub_items.cost_per_uom, 0)) AS [sub cost],
       SUM(ISNULL(CASE WHEN (sl.entry_method = 'great plains') THEN sl.expense_total 
            ELSE (sl.expense_qty * expense_items.cost_per_uom) END,0)) AS [expense cost] 
  FROM dbo.jobs j INNER JOIN 
       dbo.lookups job_type ON j.job_type_id=job_type.lookup_id INNER JOIN 
       dbo.customers cust ON j.customer_id = cust.customer_id INNER JOIN
       dbo.lookups customer_type ON cust.customer_type_id=customer_type.lookup_id INNER JOIN 
       dbo.organizations o ON cust.organization_id = o.organization_id INNER JOIN
       dbo.service_lines sl ON j.job_id = sl.bill_job_id LEFT OUTER JOIN
       dbo.resources r ON j.foreman_resource_id = r.resource_id LEFT OUTER JOIN
       dbo.contacts c ON j. a_m_sales_contact_id = c.contact_id LEFT OUTER JOIN
       dbo.users u1 ON j.billing_user_id = u1.user_id LEFT OUTER JOIN
       dbo.items labor_items ON sl.item_id = labor_items.item_id AND 
                                sl.item_type_code = 'hours' AND 
                                labor_items.name NOT LIKE 'TRUCK%' AND 
                                (labor_items.name NOT LIKE 'SUB%' OR labor_items.name LIKE 'SUB%EXP%') LEFT OUTER JOIN
       dbo.ITEMS truck_items ON sl.item_id = truck_items.item_id AND 
                                sl.item_type_code = 'hours' AND 
                                truck_items.name LIKE 'TRUCK%' LEFT OUTER JOIN 
       dbo.ITEMS sub_items ON sl.item_id = sub_items .item_id AND 
                              sl.item_type_code = 'hours' AND 
                              sub_items.name LIKE 'SUB-%' AND 
                              sub_items.name NOT LIKE 'SUB%EXP%' LEFT OUTER JOIN
       dbo.ITEMS expense_items ON sl.item_id = expense_items.item_id AND 
                                  sl.item_type_code = 'expense' LEFT OUTER JOIN
       dbo.users u2 ON sl.posted_by = u2.user_id LEFT OUTER JOIN
       dbo.customers eu ON j.end_user_id = eu.customer_id
 WHERE sl.invoice_post_date IS NOT NULL
GROUP BY o.organization_id,
         sl.invoice_id,
         sl.status_id,
         o.name,
         j.job_no,
         job_type.name,
         u1.first_name + ' ' + u1.last_name,
         sl.invoice_post_date,
         u2.first_name + ' ' + u2.last_name,
         r.name,
         c.contact_name,
         cust.end_user_parent_id,
         customer_type.code,
         cust.customer_name,
         eu.customer_name
GO
/****** Object:  View [dbo].[EXPENSES_V]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[EXPENSES_V]
AS
SELECT     dbo.SERVICE_LINES.ORGANIZATION_ID, dbo.SERVICE_LINES.SERVICE_LINE_ID, dbo.SERVICE_LINES.TC_JOB_ID, dbo.SERVICE_LINES.TC_JOB_NO, 
                      dbo.SERVICE_LINES.TC_SERVICE_LINE_NO, dbo.SERVICE_LINES.SERVICE_LINE_DATE, dbo.SERVICE_LINES.SERVICE_LINE_DATE_VARCHAR, 
                      dbo.SERVICE_LINES.SERVICE_LINE_WEEK, dbo.SERVICE_LINES.SERVICE_LINE_WEEK_VARCHAR, dbo.SERVICE_LINES.EXPENSE_QTY, 
                      dbo.SERVICE_LINES.EXPENSE_RATE, dbo.SERVICE_LINES.EXPENSE_TOTAL, dbo.SERVICE_LINES.ITEM_ID, dbo.SERVICE_LINES.ITEM_NAME, 
                      dbo.SERVICE_LINES.ITEM_TYPE_CODE, dbo.ITEMS.EXT_ITEM_ID, dbo.USERS.EXT_EMPLOYEE_ID, dbo.USERS.FULL_NAME AS employee_name, 
                      dbo.SERVICE_LINES.EXPENSES_EXPORTED_FLAG, dbo.ITEMS.EXPENSE_EXPORT_CODE, dbo.RESOURCES.USER_ID, 
                      dbo.RESOURCES.NAME AS resource_name, dbo.SERVICE_LINES.STATUS_ID
FROM         dbo.SERVICE_LINES LEFT OUTER JOIN
                      dbo.USERS RIGHT OUTER JOIN
                      dbo.RESOURCES ON dbo.USERS.USER_ID = dbo.RESOURCES.USER_ID ON 
                      dbo.SERVICE_LINES.RESOURCE_ID = dbo.RESOURCES.RESOURCE_ID LEFT OUTER JOIN
                      dbo.ITEMS ON dbo.SERVICE_LINES.ITEM_ID = dbo.ITEMS.ITEM_ID
WHERE     (dbo.SERVICE_LINES.STATUS_ID > 1) AND (dbo.SERVICE_LINES.EXPENSE_QTY > 0) AND (dbo.SERVICE_LINES.ITEM_TYPE_CODE = 'expense') AND 
                      (dbo.ITEMS.EXPENSE_EXPORT_CODE IS NOT NULL AND dbo.ITEMS.EXPENSE_EXPORT_CODE <> '')
GO
/****** Object:  View [dbo].[EXPENSE_REPORT_V]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[EXPENSE_REPORT_V]
AS
SELECT     dbo.EXPENSES_V.ORGANIZATION_ID, dbo.EXPENSES_V.TC_JOB_NO, dbo.JOBS_V.JOB_NAME, dbo.EXPENSES_V.item_name,
                      dbo.EXPENSES_V.SERVICE_LINE_DATE, dbo.EXPENSES_V.EXPENSE_QTY, dbo.EXPENSES_V.EXPENSE_RATE, dbo.EXPENSES_V.EXPENSE_TOTAL,
                      dbo.EXPENSES_V.EXPENSES_EXPORTED_FLAG, dbo.EXPENSES_V.TC_JOB_ID, dbo.EXPENSES_V.ITEM_ID, dbo.EXPENSES_V.item_type_code,
                      dbo.EXPENSES_V.USER_ID, dbo.EXPENSES_V.EXT_EMPLOYEE_ID, dbo.EXPENSES_V.employee_name
FROM         dbo.JOBS_V RIGHT OUTER JOIN
                      dbo.EXPENSES_V ON dbo.JOBS_V.JOB_ID = dbo.EXPENSES_V.TC_JOB_ID
GO

/****** Object:  View [dbo].[EXPENSES_EXPORT_V]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[EXPENSES_EXPORT_V]
AS
SELECT     ORGANIZATION_ID, SERVICE_LINE_ID, TC_JOB_ID, TC_JOB_NO, TC_SERVICE_LINE_NO, SERVICE_LINE_DATE, SERVICE_LINE_DATE_VARCHAR,
                      SERVICE_LINE_WEEK, SERVICE_LINE_WEEK_VARCHAR, EXPENSE_QTY, EXPENSE_RATE, EXPENSE_TOTAL, ITEM_ID, ITEM_NAME,
                      ITEM_TYPE_CODE, EXT_ITEM_ID, EXT_EMPLOYEE_ID, employee_name, EXPENSES_EXPORTED_FLAG, EXPENSE_EXPORT_CODE, USER_ID,
                      resource_name, STATUS_ID
FROM         dbo.EXPENSES_V
WHERE     (USER_ID IS NOT NULL) AND (EXPENSE_EXPORT_CODE IS NOT NULL) OR
                      (USER_ID IS NOT NULL) AND (EXPENSE_EXPORT_CODE <> '')
GO
/****** Object:  View [dbo].[crystal_JOB_STATUS_RPT_V]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[crystal_JOB_STATUS_RPT_V]
AS
SELECT     TOP 100 PERCENT dbo.SERVICE_LINES.ORGANIZATION_ID, dbo.SERVICE_LINES.TC_JOB_ID, dbo.SERVICE_LINES.TC_SERVICE_ID, 
                      dbo.SERVICE_LINES.SERVICE_LINE_ID, dbo.SERVICE_LINES.TC_JOB_NO, dbo.SERVICE_LINES.TC_SERVICE_NO, 
                      dbo.SERVICE_LINES.TC_SERVICE_LINE_NO, dbo.JOBS_V.DEALER_NAME, dbo.JOBS_V.EXT_DEALER_ID, dbo.JOBS_V.CUSTOMER_NAME, 
                      cast(dbo.JOBS_V.billing_user_name as varchar(20)) AS job_owner, dbo.JOBS_V.job_status_type_name, dbo.SERVICE_LINES.SERVICE_LINE_DATE, 
                      dbo.SERVICE_LINES.SERVICE_LINE_DATE_VARCHAR, dbo.SERVICE_LINES.STATUS_ID AS serv_line_status_id, dbo.SERVICE_LINES.BILLABLE_FLAG, 
                      SUM(dbo.SERVICE_LINES.TC_QTY) AS sum_tc_qty, SUM(dbo.SERVICE_LINES.ALLOCATED_QTY) AS sum_allocated_qty, 
                      dbo.SERVICE_LINES.TC_RATE, SUM(dbo.SERVICE_LINES.TC_TOTAL) AS sum_tc_total, SUM(dbo.SERVICE_LINES.BILL_QTY) AS sum_bill_qty, 
                      dbo.SERVICE_LINES.BILL_RATE, SUM(dbo.SERVICE_LINES.BILL_TOTAL) AS sum_bill_total, 
                      ISNULL(CAST(dbo.SERVICE_LINES.INVOICE_ID AS VARCHAR), 'None') AS invoice_no, GETDATE() AS report_date, MAX(dbo.SERVICES.EST_END_DATE) 
                      AS job_end_date, dbo.SERVICE_LINES.EXPORTED_FLAG, dbo.SERVICE_LINES.BILLED_FLAG, dbo.SERVICE_LINES.POSTED_FLAG, 
                      dbo.SERVICE_LINES.FULLY_ALLOCATED_FLAG, dbo.SERVICE_LINES.INTERNAL_REQ_FLAG, dbo.SERVICE_LINES.PH_SERVICE_ID, 
                      dbo.SERVICE_LINE_STATUSES.CODE
FROM         dbo.SERVICE_LINES INNER JOIN
                      dbo.SERVICE_LINE_STATUSES ON dbo.SERVICE_LINES.STATUS_ID = dbo.SERVICE_LINE_STATUSES.STATUS_ID LEFT OUTER JOIN
                      dbo.JOBS_V ON dbo.SERVICE_LINES.TC_JOB_ID = dbo.JOBS_V.JOB_ID LEFT OUTER JOIN
                      dbo.SERVICES ON dbo.SERVICE_LINES.PH_SERVICE_ID = dbo.SERVICES.SERVICE_ID AND 
                      dbo.SERVICE_LINES.TC_SERVICE_ID = dbo.SERVICES.SERVICE_ID AND dbo.SERVICE_LINES.BILL_SERVICE_ID = dbo.SERVICES.SERVICE_ID
GROUP BY dbo.SERVICE_LINES.ORGANIZATION_ID, dbo.SERVICE_LINES.SERVICE_LINE_ID, dbo.SERVICE_LINES.TC_JOB_ID, 
                      dbo.SERVICE_LINES.TC_SERVICE_ID, dbo.SERVICE_LINES.TC_JOB_NO, dbo.SERVICE_LINES.TC_SERVICE_NO, 
                      dbo.SERVICE_LINES.TC_SERVICE_LINE_NO, dbo.JOBS_V.DEALER_NAME, dbo.JOBS_V.EXT_DEALER_ID, dbo.JOBS_V.CUSTOMER_NAME, 
                      dbo.JOBS_V.billing_user_name, dbo.JOBS_V.job_status_type_name, dbo.SERVICE_LINES.SERVICE_LINE_DATE, 
                      dbo.SERVICE_LINES.SERVICE_LINE_DATE_VARCHAR, dbo.SERVICE_LINES.STATUS_ID, dbo.SERVICE_LINES.BILLABLE_FLAG, 
                      dbo.SERVICE_LINES.TC_RATE, ISNULL(CAST(dbo.SERVICE_LINES.INVOICE_ID AS VARCHAR), 'None'), dbo.SERVICE_LINES.INVOICE_ID, 
                      dbo.SERVICE_LINES.FULLY_ALLOCATED_FLAG, dbo.SERVICE_LINES.BILL_RATE, dbo.SERVICE_LINES.EXPORTED_FLAG, 
                      dbo.SERVICE_LINES.POSTED_FLAG, dbo.SERVICE_LINES.BILLED_FLAG, dbo.SERVICE_LINES.INTERNAL_REQ_FLAG, 
                      dbo.SERVICE_LINES.PH_SERVICE_ID, dbo.SERVICE_LINE_STATUSES.CODE
HAVING      (dbo.JOBS_V.CUSTOMER_NAME IS NOT NULL)
GO
/****** Object:  View [dbo].[crystal_WPS_Timesheet_V]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[crystal_WPS_Timesheet_V]
AS
SELECT     dbo.SERVICE_LINES.ORGANIZATION_ID, dbo.SERVICE_LINES.SERVICE_LINE_ID, dbo.SERVICE_LINES.TC_JOB_NO, 
                      dbo.SERVICE_LINES.TC_SERVICE_NO, dbo.SERVICE_LINES.TC_SERVICE_LINE_NO, dbo.SERVICE_LINES.SERVICE_LINE_DATE, 
                      dbo.SERVICE_LINES.STATUS_ID, dbo.SERVICE_LINES.TC_JOB_ID, dbo.SERVICE_LINES.TC_SERVICE_ID, dbo.SERVICE_LINES.RESOURCE_ID, 
                      dbo.SERVICE_LINES.RESOURCE_NAME, dbo.SERVICE_LINES.ITEM_ID, dbo.SERVICE_LINES.ITEM_NAME, dbo.SERVICE_LINES.TC_QTY, 
                      dbo.SERVICE_LINES.TC_RATE, dbo.SERVICE_LINES.TC_TOTAL, dbo.SERVICE_LINES.PALM_REP_ID, dbo.SERVICE_LINES.ENTERED_DATE, 
                      dbo.SERVICE_LINES.ENTERED_BY, dbo.SERVICE_LINES.ENTRY_METHOD, dbo.SERVICE_LINES.VERIFIED_DATE, 
                      dbo.SERVICE_LINES.VERIFIED_BY, dbo.SERVICE_LINES.DATE_CREATED, dbo.SERVICE_LINES.CREATED_BY, dbo.SERVICE_LINES.DATE_MODIFIED, 
                      dbo.SERVICE_LINES.MODIFIED_BY, dbo.SERVICES.DESCRIPTION
FROM         dbo.SERVICE_LINES INNER JOIN
                      dbo.SERVICES ON dbo.SERVICE_LINES.TC_SERVICE_ID = dbo.SERVICES.SERVICE_ID AND 
                      dbo.SERVICE_LINES.TC_JOB_ID = dbo.SERVICES.JOB_ID
WHERE     (dbo.SERVICE_LINES.VERIFIED_BY IS NULL) AND (dbo.SERVICE_LINES.DATE_CREATED > CONVERT(DATETIME, '2004-01-01 00:00:00', 102))
GO
/****** Object:  View [dbo].[SERVICE_LINES_VERIFY_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[SERVICE_LINES_VERIFY_V]
AS
SELECT     dbo.SERVICE_LINES.SERVICE_LINE_ID, dbo.SERVICE_LINES.TC_SERVICE_LINE_NO, SUP_RES.NAME AS supervisor_resource_name, 
                      SUP_USER.PIN AS supervisor_pin, RESOURCES_1.NAME AS resource_name, USERS_1.PIN AS resource_pin, 
                      USERS_1.USER_ID AS resource_user_id, SUP_USER.USER_ID AS supervisor_user_id, dbo.SERVICE_LINES.STATUS_ID, 
                      dbo.SERVICE_LINES.VERIFIED_DATE, dbo.SERVICE_LINES.VERIFIED_BY, dbo.SERVICE_LINES.OVERRIDE_REASON, 
                      dbo.SERVICE_LINES.DATE_MODIFIED, dbo.SERVICE_LINES.MODIFIED_BY, dbo.SERVICE_LINES.TC_SERVICE_ID, dbo.SERVICES.SERVICE_NO, 
                      dbo.SERVICE_LINES.CREATED_BY, dbo.SERVICE_LINES.DATE_CREATED, USERS_3.PIN AS created_by_pin, 
                      OWNER_USER.USER_ID AS billing_user_id, OWNER_USER.PIN AS billing_user_pin, dbo.SERVICE_LINES.INVOICE_ID, 
                      dbo.SERVICE_LINES.OVERRIDE_DATE, dbo.SERVICE_LINES.OVERRIDE_BY
FROM         dbo.RESOURCES RESOURCES_1 INNER JOIN
                      dbo.SERVICE_LINES INNER JOIN
                      dbo.SERVICES ON dbo.SERVICE_LINES.TC_SERVICE_ID = dbo.SERVICES.SERVICE_ID ON 
                      RESOURCES_1.RESOURCE_ID = dbo.SERVICE_LINES.RESOURCE_ID INNER JOIN
                      dbo.JOBS ON dbo.SERVICES.JOB_ID = dbo.JOBS.JOB_ID INNER JOIN
                      dbo.USERS USERS_3 ON dbo.SERVICE_LINES.CREATED_BY = USERS_3.USER_ID LEFT OUTER JOIN
                      dbo.USERS SUP_USER INNER JOIN
                      dbo.RESOURCES SUP_RES ON SUP_USER.USER_ID = SUP_RES.USER_ID ON 
                      dbo.JOBS.FOREMAN_RESOURCE_ID = SUP_RES.RESOURCE_ID LEFT OUTER JOIN
                      dbo.USERS OWNER_USER ON dbo.JOBS.BILLING_USER_ID = OWNER_USER.USER_ID LEFT OUTER JOIN
                      dbo.USERS USERS_1 ON RESOURCES_1.USER_ID = USERS_1.USER_ID
GO
/****** Object:  View [dbo].[crystal_JOBS_INVOICED_BUT_DOLLARS_REMAIN_IN_JOB_V]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[crystal_JOBS_INVOICED_BUT_DOLLARS_REMAIN_IN_JOB_V]
AS
SELECT     TOP 100 PERCENT dbo.SERVICE_LINES.ORGANIZATION_ID, dbo.SERVICE_LINES.SERVICE_LINE_ID, dbo.SERVICE_LINES.TC_JOB_NO, 
                      dbo.SERVICE_LINES.TC_SERVICE_NO, dbo.SERVICE_LINES.TC_SERVICE_LINE_NO, dbo.SERVICE_LINES.STATUS_ID, 
                      dbo.SERVICE_LINES.BILLED_FLAG, dbo.SERVICE_LINES.POSTED_FLAG, dbo.SERVICE_LINES.RESOURCE_ID, 
                      dbo.SERVICE_LINES.RESOURCE_NAME, dbo.SERVICE_LINES.ITEM_ID, dbo.SERVICE_LINES.ITEM_NAME, dbo.SERVICE_LINES.ITEM_TYPE_CODE, 
                      dbo.SERVICE_LINES.INVOICE_ID, dbo.SERVICE_LINES.POSTED_FROM_INVOICE_ID, dbo.SERVICE_LINES.BILLABLE_FLAG, 
                      dbo.SERVICE_LINES.bill_exp_total, dbo.SERVICE_LINES.bill_hourly_total, dbo.SERVICE_LINES.bill_total, dbo.SERVICE_LINES.expense_total, 
                      dbo.JOBS.JOB_NAME, dbo.JOBS.BILLING_USER_ID, dbo.USERS.FULL_NAME
FROM         dbo.SERVICE_LINES INNER JOIN
                      dbo.JOBS ON dbo.SERVICE_LINES.TC_JOB_NO = dbo.JOBS.JOB_NO INNER JOIN
                      dbo.USERS ON dbo.JOBS.BILLING_USER_ID = dbo.USERS.USER_ID
WHERE     (dbo.SERVICE_LINES.BILLABLE_FLAG = 'y') AND (dbo.SERVICE_LINES.POSTED_FLAG = 'n') AND (dbo.SERVICE_LINES.INVOICE_ID IS NOT NULL)
ORDER BY dbo.SERVICE_LINES.TC_JOB_NO
GO
/****** Object:  View [dbo].[JOBS_NOT_BILLED_V]    Script Date: 05/03/2010 14:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[JOBS_NOT_BILLED_V]
AS
SELECT     TOP 100 PERCENT dbo.SERVICE_LINES.ORGANIZATION_ID, dbo.SERVICE_LINES.TC_JOB_ID, dbo.SERVICE_LINES.TC_SERVICE_ID, 
                      dbo.SERVICE_LINES.SERVICE_LINE_ID, dbo.SERVICE_LINES.TC_JOB_NO, dbo.SERVICE_LINES.TC_SERVICE_NO, 
                      dbo.SERVICE_LINES.TC_SERVICE_LINE_NO, dbo.JOBS_V.DEALER_NAME, dbo.JOBS_V.EXT_DEALER_ID, dbo.JOBS_V.CUSTOMER_NAME, 
                      dbo.JOBS_V.billing_user_name AS job_owner, dbo.JOBS_V.job_status_type_name, dbo.SERVICE_LINES.SERVICE_LINE_DATE, 
                      dbo.SERVICE_LINES.SERVICE_LINE_DATE_VARCHAR, dbo.SERVICE_LINES.STATUS_ID AS serv_line_status_id, dbo.SERVICE_LINES.BILLABLE_FLAG, 
                      SUM(dbo.SERVICE_LINES.TC_QTY) AS sum_tc_qty, SUM(dbo.SERVICE_LINES.ALLOCATED_QTY) AS sum_allocated_qty, 
                      dbo.SERVICE_LINES.TC_RATE, SUM(dbo.SERVICE_LINES.TC_TOTAL) AS sum_tc_total, SUM(dbo.SERVICE_LINES.BILL_QTY) AS sum_bill_qty, 
                      dbo.SERVICE_LINES.BILL_RATE, SUM(dbo.SERVICE_LINES.BILL_TOTAL) AS sum_bill_total, 
                      ISNULL(CAST(dbo.SERVICE_LINES.INVOICE_ID AS VARCHAR), 'None') AS invoice_no, GETDATE() AS report_date, MAX(dbo.SERVICES.EST_END_DATE) 
                      AS job_end_date, dbo.SERVICE_LINES.EXPORTED_FLAG, dbo.SERVICE_LINES.BILLED_FLAG, dbo.SERVICE_LINES.POSTED_FLAG, 
                      dbo.SERVICE_LINES.FULLY_ALLOCATED_FLAG, dbo.SERVICE_LINES.INTERNAL_REQ_FLAG, dbo.SERVICE_LINES.PH_SERVICE_ID
FROM         dbo.SERVICE_LINES LEFT OUTER JOIN
                      dbo.JOBS_V ON dbo.SERVICE_LINES.TC_JOB_ID = dbo.JOBS_V.JOB_ID LEFT OUTER JOIN
                      dbo.SERVICES ON dbo.SERVICE_LINES.PH_SERVICE_ID = dbo.SERVICES.SERVICE_ID AND 
                      dbo.SERVICE_LINES.TC_SERVICE_ID = dbo.SERVICES.SERVICE_ID AND dbo.SERVICE_LINES.BILL_SERVICE_ID = dbo.SERVICES.SERVICE_ID
GROUP BY dbo.SERVICE_LINES.ORGANIZATION_ID, dbo.SERVICE_LINES.SERVICE_LINE_ID, dbo.SERVICE_LINES.TC_JOB_ID, 
                      dbo.SERVICE_LINES.TC_SERVICE_ID, dbo.SERVICE_LINES.TC_JOB_NO, dbo.SERVICE_LINES.TC_SERVICE_NO, 
                      dbo.SERVICE_LINES.TC_SERVICE_LINE_NO, dbo.JOBS_V.DEALER_NAME, dbo.JOBS_V.EXT_DEALER_ID, dbo.JOBS_V.CUSTOMER_NAME, 
                      dbo.JOBS_V.billing_user_name, dbo.JOBS_V.job_status_type_name, dbo.SERVICE_LINES.SERVICE_LINE_DATE, 
                      dbo.SERVICE_LINES.SERVICE_LINE_DATE_VARCHAR, dbo.SERVICE_LINES.STATUS_ID, dbo.SERVICE_LINES.BILLABLE_FLAG, 
                      dbo.SERVICE_LINES.TC_RATE, ISNULL(CAST(dbo.SERVICE_LINES.INVOICE_ID AS VARCHAR), 'None'), dbo.SERVICE_LINES.INVOICE_ID, 
                      dbo.SERVICE_LINES.FULLY_ALLOCATED_FLAG, dbo.SERVICE_LINES.BILL_RATE, dbo.SERVICE_LINES.EXPORTED_FLAG, 
                      dbo.SERVICE_LINES.POSTED_FLAG, dbo.SERVICE_LINES.BILLED_FLAG, dbo.SERVICE_LINES.INTERNAL_REQ_FLAG, 
                      dbo.SERVICE_LINES.PH_SERVICE_ID
GO
/****** Object:  View [dbo].[REQUEST_INVOICES_V_ORIG]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[REQUEST_INVOICES_V_ORIG]
AS
SELECT     ISNULL(dbo.SERVICE_LINES.INVOICE_ID, dbo.SERVICE_LINES.POSTED_FROM_INVOICE_ID) AS invoice_id, SUM(dbo.SERVICE_LINES.BILL_TOTAL) 
                      AS sum_bill_total, dbo.PROJECTS.PROJECT_NO, dbo.REQUESTS.REQUEST_NO, dbo.REQUESTS.REQUEST_ID, 
                      dbo.REQUEST_VENDORS.VENDOR_CONTACT_ID
FROM         dbo.REQUESTS INNER JOIN
                      dbo.SERVICE_LINES INNER JOIN
                      dbo.SERVICES ON dbo.SERVICE_LINES.BILL_SERVICE_ID = dbo.SERVICES.SERVICE_ID ON 
                      dbo.REQUESTS.REQUEST_ID = dbo.SERVICES.REQUEST_ID INNER JOIN
                      dbo.PROJECTS ON dbo.REQUESTS.PROJECT_ID = dbo.PROJECTS.PROJECT_ID INNER JOIN
                      dbo.REQUEST_VENDORS INNER JOIN
                      dbo.CUSTOMERS ON dbo.REQUEST_VENDORS.VENDOR_CONTACT_ID = dbo.CUSTOMERS.A_M_FURNITURE1_CONTACT_ID ON 
                      dbo.REQUESTS.REQUEST_ID = dbo.REQUEST_VENDORS.REQUEST_ID AND 
                      dbo.REQUESTS.FURNITURE1_CONTACT_ID = dbo.REQUEST_VENDORS.VENDOR_CONTACT_ID AND 
                      dbo.PROJECTS.CUSTOMER_ID = dbo.CUSTOMERS.CUSTOMER_ID INNER JOIN
                      dbo.ORGANIZATIONS ON dbo.CUSTOMERS.ORGANIZATION_ID = dbo.ORGANIZATIONS.ORGANIZATION_ID
GROUP BY ISNULL(dbo.SERVICE_LINES.INVOICE_ID, dbo.SERVICE_LINES.POSTED_FROM_INVOICE_ID), dbo.REQUESTS.REQUEST_ID, 
                      dbo.REQUEST_VENDORS.VENDOR_CONTACT_ID, dbo.PROJECTS.PROJECT_NO, dbo.REQUESTS.REQUEST_NO
GO
/****** Object:  View [dbo].[REQUEST_INVOICES_V]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[REQUEST_INVOICES_V]
AS
SELECT     ISNULL(dbo.SERVICE_LINES.INVOICE_ID, dbo.SERVICE_LINES.POSTED_FROM_INVOICE_ID) AS invoice_id, SUM(dbo.SERVICE_LINES.BILL_TOTAL) 
                      AS sum_bill_total, dbo.PROJECTS.PROJECT_NO, dbo.REQUESTS.REQUEST_NO, dbo.REQUESTS.REQUEST_ID, 
                      dbo.REQUEST_VENDORS.VENDOR_CONTACT_ID
FROM         dbo.CUSTOMERS INNER JOIN
                      dbo.REQUEST_VENDORS INNER JOIN
                      dbo.REQUESTS INNER JOIN
                      dbo.SERVICE_LINES INNER JOIN
                      dbo.SERVICES ON dbo.SERVICE_LINES.BILL_SERVICE_ID = dbo.SERVICES.SERVICE_ID ON 
                      dbo.REQUESTS.REQUEST_ID = dbo.SERVICES.REQUEST_ID INNER JOIN
                      dbo.PROJECTS ON dbo.REQUESTS.PROJECT_ID = dbo.PROJECTS.PROJECT_ID ON 
                      dbo.REQUEST_VENDORS.REQUEST_ID = dbo.REQUESTS.REQUEST_ID AND 
                      dbo.REQUEST_VENDORS.VENDOR_CONTACT_ID = dbo.REQUESTS.FURNITURE1_CONTACT_ID ON 
                      dbo.CUSTOMERS.CUSTOMER_ID = dbo.PROJECTS.CUSTOMER_ID
GROUP BY ISNULL(dbo.SERVICE_LINES.INVOICE_ID, dbo.SERVICE_LINES.POSTED_FROM_INVOICE_ID), dbo.REQUESTS.REQUEST_ID, 
                      dbo.REQUEST_VENDORS.VENDOR_CONTACT_ID, dbo.PROJECTS.PROJECT_NO, dbo.REQUESTS.REQUEST_NO
GO
/****** Object:  View [dbo].[REQUEST_INVOICES_V2]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[REQUEST_INVOICES_V2]
AS
SELECT     ISNULL(dbo.SERVICE_LINES.INVOICE_ID, dbo.SERVICE_LINES.POSTED_FROM_INVOICE_ID) AS invoice_id, SUM(dbo.SERVICE_LINES.BILL_TOTAL) 
                      AS sum_bill_total, dbo.PROJECTS.PROJECT_NO, dbo.REQUESTS.REQUEST_NO, dbo.REQUESTS.REQUEST_ID, 
                      dbo.REQUEST_VENDORS.VENDOR_CONTACT_ID
FROM         dbo.REQUESTS INNER JOIN
                      dbo.SERVICE_LINES INNER JOIN
                      dbo.SERVICES ON dbo.SERVICE_LINES.BILL_SERVICE_ID = dbo.SERVICES.SERVICE_ID ON 
                      dbo.REQUESTS.REQUEST_ID = dbo.SERVICES.REQUEST_ID INNER JOIN
                      dbo.PROJECTS ON dbo.REQUESTS.PROJECT_ID = dbo.PROJECTS.PROJECT_ID INNER JOIN
                      dbo.REQUEST_VENDORS INNER JOIN
                      dbo.CUSTOMERS ON dbo.REQUEST_VENDORS.VENDOR_CONTACT_ID = dbo.CUSTOMERS.A_M_FURNITURE1_CONTACT_ID ON 
                      dbo.REQUESTS.REQUEST_ID = dbo.REQUEST_VENDORS.REQUEST_ID AND 
                      dbo.REQUESTS.FURNITURE1_CONTACT_ID = dbo.REQUEST_VENDORS.VENDOR_CONTACT_ID AND 
                      dbo.PROJECTS.CUSTOMER_ID = dbo.CUSTOMERS.CUSTOMER_ID INNER JOIN
                      dbo.ORGANIZATIONS ON dbo.CUSTOMERS.ORGANIZATION_ID = dbo.ORGANIZATIONS.ORGANIZATION_ID AND 
                      dbo.CUSTOMERS.EXT_DEALER_ID <> dbo.ORGANIZATIONS.EXT_DCI_DEALER_ID
GROUP BY ISNULL(dbo.SERVICE_LINES.INVOICE_ID, dbo.SERVICE_LINES.POSTED_FROM_INVOICE_ID), dbo.REQUESTS.REQUEST_ID, 
                      dbo.REQUEST_VENDORS.VENDOR_CONTACT_ID, dbo.PROJECTS.PROJECT_NO, dbo.REQUESTS.REQUEST_NO
GO
/****** Object:  View [dbo].[VAR_JOB_TIME_EXP_V]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VAR_JOB_TIME_EXP_V]
AS
SELECT     TC_JOB_ID AS job_id, ISNULL(SUM(TC_QTY * TC_RATE), 0) AS sum_time_exp, ISNULL(SUM(PAYROLL_QTY * TC_RATE), 0) AS sum_time, 
                      ISNULL(SUM(EXPENSE_QTY * TC_RATE), 0) AS sum_exp
FROM         dbo.SERVICE_LINES
WHERE     (PH_SERVICE_ID IS NULL)
GROUP BY TC_JOB_ID
GO
/****** Object:  View [dbo].[crystal_GRACO_REPORT_V]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[crystal_GRACO_REPORT_V]
AS
SELECT     TOP 100 PERCENT dbo.SERVICE_LINES.BILL_JOB_NO AS JOB_NO, dbo.SERVICES.PO_NO AS PO, dbo.SERVICE_LINES.BILL_SERVICE_NO AS Req, 
                      dbo.SERVICE_LINES.SERVICE_LINE_DATE, dbo.SERVICE_LINES.RESOURCE_NAME, dbo.SERVICE_LINES.ITEM_NAME, 
                      dbo.SERVICE_LINES.BILL_QTY
FROM         dbo.SERVICE_LINES INNER JOIN
                      dbo.SERVICES ON dbo.SERVICE_LINES.TC_SERVICE_ID = dbo.SERVICES.SERVICE_ID
WHERE     (dbo.SERVICE_LINES.RESOURCE_NAME IS NOT NULL) AND (dbo.SERVICE_LINES.BILL_JOB_NO = 392055)
ORDER BY dbo.SERVICE_LINES.RESOURCE_NAME
GO
/****** Object:  View [dbo].[ITEMS_USAGE_V]    Script Date: 05/03/2010 14:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ITEMS_USAGE_V]
AS
SELECT     TOP 100 PERCENT ORGANIZATION_ID, TC_JOB_NO, TC_SERVICE_NO, TC_SERVICE_LINE_NO, SERVICE_LINE_DATE, STATUS_ID, RESOURCE_NAME,
                       ITEM_ID, ITEM_NAME, ITEM_TYPE_CODE, TC_QTY, EXPENSE_QTY, BILL_QTY, BILL_HOURLY_QTY, BILL_EXP_QTY, bill_hourly_total, 
                      bill_exp_total
FROM         dbo.SERVICE_LINES
ORDER BY ITEM_NAME
GO
/****** Object:  View [dbo].[POOLED_HRS_RPT_V]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[POOLED_HRS_RPT_V]
AS
SELECT     TOP 100 PERCENT sl.BILL_JOB_NO, sl.BILL_SERVICE_NO, sl.BILL_JOB_ID AS job_id, sl.BILL_SERVICE_ID AS service_id, sl.ITEM_ID, 
                      sl.ITEM_NAME, SUM(sl.BILL_QTY) AS total_qty, sl.BILL_RATE AS rate, sl.STATUS_ID AS service_line_status_id, sl.INVOICE_ID, sl.ORGANIZATION_ID, 
                      sl.TC_SERVICE_LINE_NO, sl.POOLED_FLAG, sl.BILLED_FLAG, sl.POSTED_FLAG, sl.EXPORTED_FLAG, sl.BILLABLE_FLAG, 
                      dbo.JOBS.JOB_STATUS_TYPE_ID
FROM         dbo.SERVICE_LINES sl INNER JOIN
                      dbo.JOBS ON sl.TC_JOB_NO = dbo.JOBS.JOB_NO LEFT OUTER JOIN
                      dbo.POOLED_HOURS_CALC ON sl.BILL_SERVICE_ID = dbo.POOLED_HOURS_CALC.SERVICE_ID
GROUP BY sl.STATUS_ID, sl.BILL_JOB_ID, sl.BILL_SERVICE_ID, sl.BILL_JOB_NO, sl.BILL_SERVICE_NO, sl.BILL_RATE, sl.ITEM_ID, sl.INVOICE_ID, 
                      sl.ITEM_NAME, sl.ORGANIZATION_ID, sl.TC_SERVICE_LINE_NO, sl.POOLED_FLAG, sl.BILLED_FLAG, sl.POSTED_FLAG, sl.EXPORTED_FLAG, 
                      sl.BILLABLE_FLAG, dbo.JOBS.JOB_STATUS_TYPE_ID
HAVING      (sl.INVOICE_ID IS NULL) AND (sl.POOLED_FLAG = 'y') AND (sl.BILLED_FLAG = 'n') AND (sl.POSTED_FLAG = 'n') AND (sl.BILLABLE_FLAG = 'y') AND 
                      (dbo.JOBS.JOB_STATUS_TYPE_ID < 115)
ORDER BY sl.BILL_JOB_NO, sl.BILL_SERVICE_NO
GO
/****** Object:  View [dbo].[job_time_by_job_v]    Script Date: 05/03/2010 14:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[job_time_by_job_v]
AS
SELECT j.job_name,
       CAST(j.job_no AS VARCHAR) AS job_no_varchar, 
       j.foreman_resource_id,
       foreman_r.name foreman_resource_name,
       billing_user.first_name + ' ' + billing_user.last_name AS billing_user_name,
       CASE WHEN customer_type.code = 'end_user' THEN c.end_user_parent_id ELSE c.customer_id END customer_id, 
       CASE WHEN customer_type.code = 'end_user' THEN (SELECT customer_name FROM customers WHERE customer_id = c.end_user_parent_id) ELSE c.customer_name END customer_name, 
       CASE WHEN customer_type.code = 'end_user' THEN c.customer_id ELSE eu.customer_id END end_user_id, 
       CASE WHEN customer_type.code = 'end_user' THEN c.customer_name ELSE eu.customer_name END end_user_name, 
       sl.organization_id, 
       sl.tc_job_no,       
       sl.tc_service_no,    
       sl.tc_service_line_no, 
       sl.item_name, 
       sl.tc_job_id, 
       sl.tc_service_id, 
       sl.ph_service_id, 
       sl.service_line_id, 
       sl.service_line_date, 
       sl.status_id, 
       sls.name status_name, 
       sl.resource_id,  
       sl.item_id, 
       sl.tc_qty, 
       sl.tc_rate, 
       sl.tc_total,
       sl.payroll_qty,
       sl.ext_pay_code, 
       ISNULL(sl.payroll_qty, 0) - ISNULL(sl.bill_hourly_qty, 0) AS hours_difference, 
       r.name resource_name, 
       rt.name resource_type_name,
       r.user_id,
       r.resource_type_id,
       resource_user.ext_employee_id      
  FROM dbo.service_lines sl LEFT OUTER JOIN
       dbo.service_line_statuses sls ON sl.status_id=sls.status_id LEFT OUTER JOIN
       dbo.jobs j ON sl.tc_job_id = j.job_id LEFT OUTER JOIN
       dbo.customers c ON j.customer_id=c.customer_id LEFT OUTER JOIN
       dbo.lookups customer_type ON c.customer_type_id=customer_type.lookup_id LEFT OUTER JOIN
       dbo.customers eu ON j.end_user_id = eu.customer_id LEFT OUTER JOIN
       dbo.users billing_user ON  j.billing_user_id = billing_user.user_id LEFT OUTER JOIN
       dbo.resources foreman_r ON j.foreman_resource_id = foreman_r.resource_id LEFT OUTER JOIN
       dbo.resources r ON sl.resource_id = r.resource_id LEFT OUTER JOIN
       dbo.resource_types rt ON r.resource_type_id = rt.resource_type_id LEFT OUTER JOIN
       dbo.users resource_user ON r.user_id = resource_user.user_id
GO
/****** Object:  View [dbo].[Expense_Report_for_Sandy]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Expense_Report_for_Sandy]
AS
SELECT     ORGANIZATION_ID, SERVICE_LINE_ID, TC_JOB_NO, TC_SERVICE_NO, TC_SERVICE_LINE_NO, SERVICE_LINE_DATE, STATUS_ID, RESOURCE_NAME,
                       ITEM_NAME, ITEM_TYPE_CODE, TAXABLE_FLAG, BILLABLE_FLAG, EXPENSE_QTY, EXPENSE_RATE, EXPENSE_TOTAL
FROM         dbo.SERVICE_LINES
WHERE     (ITEM_TYPE_CODE = 'expense') AND (ORGANIZATION_ID = 2) AND (SERVICE_LINE_DATE >= CONVERT(DATETIME, '2005-09-18 00:00:00', 102))
GO
/****** Object:  View [dbo].[POOLED_HOURS_TOTALS_V]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[POOLED_HOURS_TOTALS_V]
AS
SELECT     TOP 100 PERCENT sl.BILL_JOB_NO, sl.BILL_SERVICE_NO, sl.BILL_JOB_ID job_id, sl.BILL_SERVICE_ID service_id, sl.ITEM_ID, sl.ITEM_NAME, SUM(sl.BILL_QTY) 
                      AS total_qty, sl.BILL_RATE AS rate, sl.STATUS_ID AS service_line_status_id, sl.INVOICE_ID
FROM         dbo.SERVICE_LINES sl LEFT OUTER JOIN
                      dbo.POOLED_HOURS_CALC ON sl.BILL_SERVICE_ID = dbo.POOLED_HOURS_CALC.SERVICE_ID
GROUP BY sl.STATUS_ID, sl.BILL_JOB_ID, sl.BILL_SERVICE_ID, sl.BILL_JOB_NO, sl.BILL_SERVICE_NO, sl.BILL_RATE, sl.ITEM_ID, sl.INVOICE_ID, 
                      sl.ITEM_NAME
HAVING      (sl.STATUS_ID = 4) AND (sl.INVOICE_ID IS NULL)
ORDER BY sl.BILL_JOB_NO, sl.BILL_SERVICE_NO
GO
/****** Object:  View [dbo].[VAR_JOB_ACT_HOURS_V]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[VAR_JOB_ACT_HOURS_V]
AS
SELECT     dbo.JOBS.JOB_ID, SUM(ISNULL(dbo.SERVICE_LINES.PAYROLL_QTY, 0)) AS sum_payroll_qty, SUM(ISNULL(dbo.SERVICE_LINES.EXPENSE_QTY, 0)) 
                      AS sum_expense_qty
FROM         dbo.SERVICES LEFT OUTER JOIN
                      dbo.JOBS ON dbo.SERVICES.JOB_ID = dbo.JOBS.JOB_ID LEFT OUTER JOIN
                      dbo.SERVICE_LINES ON dbo.SERVICES.SERVICE_ID = dbo.SERVICE_LINES.TC_SERVICE_ID
GROUP BY dbo.JOBS.JOB_ID
GO
/****** Object:  View [dbo].[crystal_RETURN_TO_JOB_MAD_V]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[crystal_RETURN_TO_JOB_MAD_V]
AS
SELECT     TOP 100 PERCENT dbo.CHECKLIST_DATA.CHECKLIST_ID, dbo.CHECKLIST_DATA.DATA_NAME AS JOB_COMPLETED_ON_FIRST_TRIP, 
                      dbo.CHECKLIST_DATA.DATA_VALUE, dbo.REQUESTS.PROJECT_ID, dbo.PROJECTS.PROJECT_NO, dbo.PROJECTS.JOB_NAME, 
                      dbo.CHECKLISTS.DATE_CREATED AS CHECKLIST_CREATED, dbo.PROJECTS.DATE_CREATED AS JOB_CREATED, 
                      dbo.CHECKLISTS.CREATED_BY AS CHECKLIST_CREATED_BY, dbo.CUSTOMERS.ORGANIZATION_ID
FROM         dbo.CHECKLIST_DATA INNER JOIN
                      dbo.CHECKLISTS ON dbo.CHECKLIST_DATA.CHECKLIST_ID = dbo.CHECKLISTS.CHECKLIST_ID INNER JOIN
                      dbo.REQUESTS ON dbo.CHECKLISTS.REQUEST_ID = dbo.REQUESTS.REQUEST_ID INNER JOIN
                      dbo.PROJECTS ON dbo.REQUESTS.PROJECT_ID = dbo.PROJECTS.PROJECT_ID INNER JOIN
                      dbo.CUSTOMERS ON dbo.PROJECTS.CUSTOMER_ID = dbo.CUSTOMERS.CUSTOMER_ID
WHERE     (dbo.CHECKLIST_DATA.DATA_NAME = '2') AND (dbo.CUSTOMERS.ORGANIZATION_ID = 2)
ORDER BY dbo.PROJECTS.PROJECT_NO
GO
/****** Object:  View [dbo].[crystal_RETURN_TO_JOB_V]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[crystal_RETURN_TO_JOB_V]
AS
SELECT     dbo.CHECKLIST_DATA.CHECKLIST_ID, dbo.CHECKLIST_DATA.DATA_NAME AS JOB_COMPLETED_ON_FIRST_TRIP, 
                      dbo.CHECKLIST_DATA.DATA_VALUE, dbo.REQUESTS.PROJECT_ID, dbo.PROJECTS.PROJECT_NO, dbo.PROJECTS.JOB_NAME, 
                      dbo.CHECKLISTS.DATE_CREATED AS CHECKLIST_CREATED, dbo.PROJECTS.DATE_CREATED AS JOB_CREATED, 
                      dbo.CHECKLISTS.CREATED_BY AS CHECKLIST_CREATED_BY
FROM         dbo.CHECKLIST_DATA INNER JOIN
                      dbo.CHECKLISTS ON dbo.CHECKLIST_DATA.CHECKLIST_ID = dbo.CHECKLISTS.CHECKLIST_ID INNER JOIN
                      dbo.REQUESTS ON dbo.CHECKLISTS.REQUEST_ID = dbo.REQUESTS.REQUEST_ID INNER JOIN
                      dbo.PROJECTS ON dbo.REQUESTS.PROJECT_ID = dbo.PROJECTS.PROJECT_ID
WHERE     (dbo.CHECKLIST_DATA.DATA_NAME = '2')
GO
/****** Object:  View [dbo].[crystal_CHECKLIST_RPT_V]    Script Date: 05/03/2010 14:18:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[crystal_CHECKLIST_RPT_V]
AS
SELECT     dbo.CHECKLIST_DATA.CHECKLIST_DATA_ID, dbo.CHECKLIST_DATA.CHECKLIST_ID, dbo.CHECKLIST_DATA.DATA_NAME, 
                      dbo.CHECKLIST_DATA.DATA_VALUE, dbo.CHECKLIST_DATA.NUM_STATIONS, dbo.CHECKLISTS.DATE_CREATED, dbo.REQUESTS.REQUEST_NO, 
                      dbo.PROJECTS.PROJECT_NO, dbo.CHECKLISTS.NUM_STATIONS AS STATIONS, dbo.CUSTOMERS.EXT_DEALER_ID, 
                      dbo.CUSTOMERS.DEALER_NAME
FROM         dbo.CHECKLIST_DATA INNER JOIN
                      dbo.CHECKLISTS ON dbo.CHECKLIST_DATA.CHECKLIST_ID = dbo.CHECKLISTS.CHECKLIST_ID INNER JOIN
                      dbo.REQUESTS ON dbo.CHECKLISTS.REQUEST_ID = dbo.REQUESTS.REQUEST_ID INNER JOIN
                      dbo.PROJECTS ON dbo.REQUESTS.PROJECT_ID = dbo.PROJECTS.PROJECT_ID INNER JOIN
                      dbo.CUSTOMERS ON dbo.PROJECTS.CUSTOMER_ID = dbo.CUSTOMERS.CUSTOMER_ID
WHERE     (dbo.CUSTOMERS.EXT_DEALER_ID = '3017') OR
                      (dbo.CUSTOMERS.EXT_DEALER_ID = '1002') OR
                      (dbo.CUSTOMERS.EXT_DEALER_ID = '1000') OR
                      (dbo.CUSTOMERS.EXT_DEALER_ID = '1001')
GO
/****** Object:  View [dbo].[RETURN_TO_JOB_MAD_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[RETURN_TO_JOB_MAD_V]
AS
SELECT     TOP 100 PERCENT dbo.CHECKLIST_DATA.CHECKLIST_ID, dbo.CHECKLIST_DATA.DATA_NAME AS JOB_COMPLETED_ON_FIRST_TRIP, 
                      dbo.CHECKLIST_DATA.DATA_VALUE, dbo.REQUESTS.PROJECT_ID, dbo.PROJECTS.PROJECT_NO, dbo.PROJECTS.JOB_NAME, 
                      dbo.CHECKLISTS.DATE_CREATED AS CHECKLIST_CREATED, dbo.PROJECTS.DATE_CREATED AS JOB_CREATED, 
                      dbo.CHECKLISTS.CREATED_BY AS CHECKLIST_CREATED_BY, dbo.CUSTOMERS.ORGANIZATION_ID
FROM         dbo.CHECKLIST_DATA INNER JOIN
                      dbo.CHECKLISTS ON dbo.CHECKLIST_DATA.CHECKLIST_ID = dbo.CHECKLISTS.CHECKLIST_ID INNER JOIN
                      dbo.REQUESTS ON dbo.CHECKLISTS.REQUEST_ID = dbo.REQUESTS.REQUEST_ID INNER JOIN
                      dbo.PROJECTS ON dbo.REQUESTS.PROJECT_ID = dbo.PROJECTS.PROJECT_ID INNER JOIN
                      dbo.CUSTOMERS ON dbo.PROJECTS.CUSTOMER_ID = dbo.CUSTOMERS.CUSTOMER_ID
WHERE     (dbo.CHECKLIST_DATA.DATA_NAME = '2') AND (dbo.CUSTOMERS.ORGANIZATION_ID = 2)
ORDER BY dbo.PROJECTS.PROJECT_NO
GO
/****** Object:  View [dbo].[SURVEY_TEST_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[SURVEY_TEST_V]

AS

SELECT     dbo.REQUESTS.PROJECT_ID, ISNULL(dbo.CUSTOMERS.SURVEY_LAST_COUNT, 0) AS survey_last_count, 

                      ISNULL(dbo.CUSTOMERS.SURVEY_FREQUENCY, 0) AS survey_frequency, COUNT(dbo.REQUEST_VENDORS.COMPLETE_FLAG) AS sum_complete, 

                      dbo.CUSTOMERS.SURVEY_LOCATION

FROM         dbo.CUSTOMERS INNER JOIN

                      dbo.CONTACTS ON dbo.CUSTOMERS.A_M_FURNITURE1_CONTACT_ID = dbo.CONTACTS.CONTACT_ID INNER JOIN

                      dbo.REQUEST_VENDORS ON dbo.CONTACTS.CONTACT_ID = dbo.REQUEST_VENDORS.VENDOR_CONTACT_ID INNER JOIN

                      dbo.REQUESTS ON dbo.REQUEST_VENDORS.REQUEST_ID = dbo.REQUESTS.REQUEST_ID INNER JOIN

                      dbo.PROJECTS ON dbo.CUSTOMERS.CUSTOMER_ID = dbo.PROJECTS.CUSTOMER_ID AND 

                      dbo.REQUESTS.PROJECT_ID = dbo.PROJECTS.PROJECT_ID

GROUP BY dbo.REQUEST_VENDORS.COMPLETE_FLAG, ISNULL(dbo.CUSTOMERS.SURVEY_FREQUENCY, 0), ISNULL(dbo.CUSTOMERS.SURVEY_LAST_COUNT,

                       0), dbo.CUSTOMERS.SURVEY_LOCATION, dbo.REQUESTS.PROJECT_ID

HAVING      (dbo.REQUEST_VENDORS.COMPLETE_FLAG = 'Y')
GO
/****** Object:  View [dbo].[QUICK_REQUEST_VENDORS_HELPER_V]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[QUICK_REQUEST_VENDORS_HELPER_V] as
SELECT     REQUEST_ID, COUNT(REQUEST_VENDOR_ID) AS VENDOR_COUNT, MIN(SCH_START_DATE) AS MIN_SCH_START_DATE, MIN(ACT_START_DATE) 
                      AS MIN_ACT_START_DATE, MAX(SCH_START_DATE) AS MAX_SCH_START_DATE, MAX(ACT_END_DATE) AS MAX_ACT_END_DATE, 
                      ISNULL(COUNT(CASE WHEN COMPLETE_FLAG = 'y' THEN 1 ELSE 0 END),0) AS VENDOR_COMPLETE_COUNT, 
                      ISNULL(COUNT(CASE WHEN invoiced_FLAG = 'y' THEN 1 ELSE 0 END),0) AS VENDOR_INVOICED_COUNT
FROM         dbo.REQUEST_VENDORS
GROUP BY REQUEST_ID
GO
/****** Object:  View [dbo].[request_vendor_totals_v]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[request_vendor_totals_v]
AS
SELECT TOP 100 PERCENT 
       cust.organization_id,
       r.project_id, 
       r.request_id,
       p.project_no,
       r.request_no,
       CONVERT(VARCHAR, p.project_no) + '-' + CONVERT(VARCHAR, r.request_no) AS workorder_no, 
       p.project_status_type_id,
       project_status.code AS project_status_type_code, 
       project_status.name AS project_status_type_name, 
       r.request_status_type_id,
       request_status_type.code AS request_status_type_code, 
       request_status_type.name AS request_status_type_name, 
       dbo.lookups_v.sequence_no AS approved_seq_no,
       request_status_type.sequence_no AS request_seq_no, 
       r.request_type_id,
       request_type.code AS request_type_code,
       request_type.name AS request_type_name,       
       CASE WHEN customer_type.code = 'dealer' THEN ISNULL(cust.ext_customer_id, cust.ext_dealer_id) ELSE cust.ext_dealer_id END ext_dealer_id, 
       CASE WHEN customer_type.code = 'end_user' THEN cust.end_user_parent_id ELSE cust.customer_id END customer_id,
       CASE WHEN customer_type.code = 'end_user' THEN (SELECT customer_name FROM customers WHERE customer_id=cust.end_user_parent_id) ELSE cust.customer_name END customer_name,
       CASE WHEN customer_type.code = 'end_user' THEN cust.customer_id ELSE eu.customer_id END end_user_id,
       CASE WHEN customer_type.code = 'end_user' THEN cust.customer_name ELSE eu.customer_name END end_user_name, 
       cust.dealer_name, 
       cust.parent_customer_id, 
       p.job_name,
       r.dealer_po_no, 
       r.customer_po_no, 
       priorities.name AS priority,
       SUM(rv.estimated_cost) AS sum_estimated_cost, 
       SUM(rv.total_cost) AS sum_total_cost,
       SUM(rv.visit_count) 
       AS sum_visit_count, 
       r.date_created,
       r.created_by,
       users_1.full_name AS created_by_name, 
       r.date_modified, 
       r.modified_by, 
       users_2.full_name AS modified_by_name,
       COUNT(rv.request_vendor_id) AS vendor_count,
       MIN(rv.act_start_date) AS min_act_start_date, 
       MIN(rv.sch_start_date) AS min_sch_start_date,
       MIN(r.est_start_date) AS min_est_start_date,
       MAX(rv.act_end_date) AS max_act_end_date, 
       MAX(rv.sch_end_date) AS max_sch_end_date,
       MAX(r.est_end_date) AS max_est_end_date,
       MIN(rv.invoice_date) AS min_invoice_date, 
       r.description, 
       (CASE WHEN COUNT(dbo.punchlists.punchlist_id) > 0 THEN 'y' ELSE 'n' END) AS punchlist_flag, 
       SUM((CASE WHEN rv.complete_flag = 'y' THEN 1 ELSE 0 END)) vendor_complete_count,
       SUM((CASE WHEN rv.invoiced_flag = 'y' THEN 1 ELSE 0 END)) invoiced_complete_count
  FROM dbo.requests r INNER JOIN
       dbo.lookups request_type ON r.request_type_id = request_type.lookup_id INNER JOIN
       dbo.lookups request_status_type ON r.request_status_type_id = request_status_type.lookup_id INNER JOIN
       dbo.users users_1 on r.created_by = users_1.user_id INNER JOIN
       dbo.projects p ON r.project_id = p.project_id INNER JOIN
       dbo.lookups project_status ON p.project_status_type_id = project_status.lookup_id INNER JOIN
       dbo.customers cust ON p.customer_id = cust.customer_id LEFT OUTER JOIN 
       dbo.customers eu ON p.customer_id = eu.customer_id LEFT OUTER JOIN 
       dbo.lookups customer_type ON cust.customer_type_id = customer_type.lookup_id LEFT OUTER JOIN 
       dbo.users users_2 ON r.modified_by = users_2.user_id LEFT OUTER JOIN 
       dbo.lookups priorities ON r.priority_type_id = priorities.lookup_id LEFT OUTER JOIN 
       dbo.punchlists ON r.request_id = dbo.punchlists.request_id LEFT OUTER JOIN 
       dbo.request_vendors rv ON r.request_id = rv.request_id LEFT OUTER JOIN 
       dbo.contacts c ON rv.vendor_contact_id = c.contact_id LEFT OUTER JOIN
       dbo.users u ON rv.vendor_contact_id = u.vendor_contact_id CROSS JOIN
       dbo.lookups_v
 WHERE (dbo.lookups_v.type_code = 'workorder_status_type') 
   AND (dbo.lookups_v.lookup_code = 'approved')
GROUP BY r.project_id, r.request_id, p.project_no, r.request_no, 
         CONVERT(varchar, p.project_no) + '.' + CONVERT(varchar, r.request_no), 
         cust.ext_dealer_id, cust.customer_name, r.dealer_po_no, r.customer_po_no, 
         priorities.name, r.date_created, r.created_by, users_1.full_name, r.date_modified, 
         r.modified_by, users_2.full_name, dbo.lookups_v.sequence_no, request_status_type.sequence_no, 
         request_status_type.code, request_status_type.name, cust.dealer_name, p.job_name, 
         r.request_type_id, request_type.code, request_type.name, cust.organization_id, 
         cust.customer_id, cust.parent_customer_id, project_status.code, project_status.name, 
         p.project_status_type_id, r.request_status_type_id, r.description, 
         customer_type.code, cust.ext_customer_id, cust.end_user_parent_id, eu.customer_id, eu.customer_name
GO
/****** Object:  View [dbo].[crystal_csc_WORK_ORDER_MASTER_V]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* original view
 ALTER  VIEW dbo.crystal_csc_WORK_ORDER_MASTER_V
 AS
 SELECT     dbo.REQUESTS.PROJECT_ID, dbo.PROJECTS.PROJECT_NO, dbo.REQUESTS.REQUEST_NO, dbo.REQUESTS.PRIORITY_TYPE_ID, 
                       LOOKUPS_1.NAME AS PRIORITY, dbo.REQUESTS.LEVEL_TYPE_ID, dbo.REQUEST_VENDORS.VENDOR_CONTACT_ID, 
                       dbo.CONTACTS.CONTACT_NAME AS VENDOR_NAME, dbo.REQUEST_VENDORS.EMAILED_DATE, dbo.REQUEST_VENDORS.SCH_START_DATE, 
                       dbo.REQUEST_VENDORS.SCH_START_TIME, dbo.REQUEST_VENDORS.SCH_END_DATE, dbo.REQUEST_VENDORS.ACT_START_DATE, 
                       dbo.REQUEST_VENDORS.ACT_START_TIME, dbo.REQUEST_VENDORS.ACT_END_DATE, dbo.REQUEST_VENDORS.ESTIMATED_COST, 
                       dbo.REQUEST_VENDORS.TOTAL_COST, dbo.REQUEST_VENDORS.INVOICE_DATE, dbo.REQUEST_VENDORS.INVOICE_NUMBERS, 
                       dbo.REQUEST_VENDORS.VISIT_COUNT, dbo.REQUEST_VENDORS.COMPLETE_FLAG, dbo.REQUEST_VENDORS.INVOICED_FLAG, 
                       dbo.PROJECTS.JOB_NAME, LOOKUPS_1.NAME AS ACTIVITY, dbo.REQUESTS.QTY1, LOOKUPS_2.NAME AS CATEGORY
 FROM         dbo.REQUEST_VENDORS INNER JOIN
                       dbo.REQUESTS ON dbo.REQUEST_VENDORS.REQUEST_ID = dbo.REQUESTS.REQUEST_ID INNER JOIN
                       dbo.CONTACTS ON dbo.REQUEST_VENDORS.VENDOR_CONTACT_ID = dbo.CONTACTS.CONTACT_ID INNER JOIN
                       dbo.PROJECTS ON dbo.REQUESTS.PROJECT_ID = dbo.PROJECTS.PROJECT_ID INNER JOIN
                       dbo.LOOKUPS LOOKUPS_1 ON dbo.REQUESTS.ACTIVITY_TYPE_ID1 = LOOKUPS_1.LOOKUP_ID INNER JOIN
                       dbo.LOOKUPS LOOKUPS_2 ON dbo.REQUESTS.ACTIVITY_CAT_TYPE_ID1 = LOOKUPS_2.LOOKUP_ID LEFT OUTER JOIN
                       dbo.LOOKUPS LOOKUPS_3 ON dbo.REQUESTS.PRIORITY_TYPE_ID = LOOKUPS_3.LOOKUP_ID
 
 GO*/
CREATE VIEW [dbo].[crystal_csc_WORK_ORDER_MASTER_V]
AS
SELECT     dbo.REQUESTS.PROJECT_ID, dbo.PROJECTS.PROJECT_NO, dbo.REQUESTS.REQUEST_NO, dbo.REQUESTS.PRIORITY_TYPE_ID, 
                      LOOKUPS_1.NAME AS PRIORITY, dbo.REQUESTS.LEVEL_TYPE_ID, dbo.REQUESTS.WORK_ORDER_RECEIVED_DATE, 
                      dbo.REQUEST_VENDORS.VENDOR_CONTACT_ID, dbo.CONTACTS.CONTACT_NAME AS VENDOR_NAME, dbo.REQUEST_VENDORS.EMAILED_DATE, 
                      dbo.REQUEST_VENDORS.SCH_START_DATE, dbo.REQUEST_VENDORS.SCH_START_TIME, dbo.REQUEST_VENDORS.SCH_END_DATE, 
                      dbo.REQUEST_VENDORS.ACT_START_DATE, dbo.REQUEST_VENDORS.ACT_START_TIME, dbo.REQUEST_VENDORS.ACT_END_DATE, 
                      dbo.REQUEST_VENDORS.ESTIMATED_COST, dbo.REQUEST_VENDORS.TOTAL_COST, dbo.REQUEST_VENDORS.INVOICE_DATE, 
                      dbo.REQUEST_VENDORS.INVOICE_NUMBERS, dbo.REQUEST_VENDORS.VISIT_COUNT, dbo.REQUEST_VENDORS.COMPLETE_FLAG, 
                      dbo.REQUEST_VENDORS.INVOICED_FLAG, dbo.PROJECTS.JOB_NAME, LOOKUPS_1.NAME AS ACTIVITY, dbo.REQUESTS.QTY1, 
                      LOOKUPS_2.NAME AS CATEGORY, dbo.REQUESTS.REQUEST_STATUS_TYPE_ID, dbo.REQUESTS.CUSTOMER_PO_NO, 
                      dbo.REQUESTS.DESCRIPTION, dbo.CUSTOMERS.CUSTOMER_NAME, dbo.REQUESTS.IS_SENT_DATE
FROM         dbo.REQUEST_VENDORS INNER JOIN
                      dbo.REQUESTS ON dbo.REQUEST_VENDORS.REQUEST_ID = dbo.REQUESTS.REQUEST_ID INNER JOIN
                      dbo.CONTACTS ON dbo.REQUEST_VENDORS.VENDOR_CONTACT_ID = dbo.CONTACTS.CONTACT_ID INNER JOIN
                      dbo.PROJECTS ON dbo.REQUESTS.PROJECT_ID = dbo.PROJECTS.PROJECT_ID INNER JOIN
                      dbo.LOOKUPS LOOKUPS_1 ON dbo.REQUESTS.ACTIVITY_TYPE_ID1 = LOOKUPS_1.LOOKUP_ID INNER JOIN
                      dbo.LOOKUPS LOOKUPS_2 ON dbo.REQUESTS.ACTIVITY_CAT_TYPE_ID1 = LOOKUPS_2.LOOKUP_ID INNER JOIN
                      dbo.CUSTOMERS ON dbo.CONTACTS.CUSTOMER_ID = dbo.CUSTOMERS.CUSTOMER_ID AND 
                      dbo.PROJECTS.CUSTOMER_ID = dbo.CUSTOMERS.CUSTOMER_ID LEFT OUTER JOIN
                      dbo.LOOKUPS LOOKUPS_3 ON dbo.REQUESTS.PRIORITY_TYPE_ID = LOOKUPS_3.LOOKUP_ID
GO
/****** Object:  View [dbo].[REQUEST_VENDORS_V]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[REQUEST_VENDORS_V]
AS
SELECT     TOP 100 PERCENT c.ORGANIZATION_ID, r.PROJECT_ID, rv.REQUEST_ID, p.CUSTOMER_ID, c.PARENT_CUSTOMER_ID, rv.REQUEST_VENDOR_ID, 
                      rv.VENDOR_CONTACT_ID, p.PROJECT_NO, r.REQUEST_NO, CONVERT(varchar, p.PROJECT_NO) + '-' + CONVERT(varchar, r.REQUEST_NO) 
                      AS workorder_no, dbo.CONTACTS.CONTACT_NAME AS vendor_contact_name, c.DEALER_NAME, c.EXT_DEALER_ID, c.CUSTOMER_NAME, 
                      r.DEALER_PO_NO, r.CUSTOMER_PO_NO, r.EST_START_DATE, rv.EMAILED_DATE, priorities.NAME AS priority, rv.SCH_START_DATE, 
                      rv.SCH_START_TIME, rv.SCH_END_DATE, rv.ACT_START_DATE, rv.ACT_START_TIME, rv.ACT_END_DATE, rv.ESTIMATED_COST, rv.TOTAL_COST, 
                      rv.INVOICE_DATE, rv.INVOICE_NUMBERS, rv.VISIT_COUNT, rv.COMPLETE_FLAG, rv.INVOICED_FLAG, rv.VENDOR_NOTES, rv.DATE_CREATED, 
                      rv.CREATED_BY, USERS_1.FULL_NAME AS created_by_name, rv.DATE_MODIFIED, rv.MODIFIED_BY, USERS_2.FULL_NAME AS modified_by_name, 
                      request_types.CODE AS request_type_code, dbo.LOOKUPS_V.SEQUENCE_NO AS approved_seq_no, status.SEQUENCE_NO AS status_seq_no, 
                      status.CODE AS request_status_type_code, status.NAME AS request_status_type_name, CONVERT(VARCHAR(12), r.EST_START_DATE, 101) 
                      AS est_start_date_varchar, CONVERT(VARCHAR(12), r.EST_END_DATE, 101) AS est_end_date_varchar, CONVERT(VARCHAR(12), rv.SCH_START_DATE, 
                      101) AS sch_start_date_varchar, CONVERT(VARCHAR(12), rv.SCH_END_DATE, 101) AS sch_end_date_varchar, CONVERT(VARCHAR(12), 
                      rv.INVOICE_DATE, 101) AS invoice_date_varchar
FROM         dbo.CUSTOMERS c RIGHT OUTER JOIN
                      dbo.USERS USERS_1 RIGHT OUTER JOIN
                      dbo.LOOKUPS priorities RIGHT OUTER JOIN
                      dbo.LOOKUPS request_types RIGHT OUTER JOIN
                      dbo.CONTACTS RIGHT OUTER JOIN
                      dbo.VERSIONS_MAX_NO_V INNER JOIN
                      dbo.PROJECTS p ON dbo.VERSIONS_MAX_NO_V.PROJECT_ID = p.PROJECT_ID INNER JOIN
                      dbo.REQUESTS r ON dbo.VERSIONS_MAX_NO_V.PROJECT_ID = r.PROJECT_ID AND dbo.VERSIONS_MAX_NO_V.REQUEST_NO = r.REQUEST_NO AND 
                      dbo.VERSIONS_MAX_NO_V.max_version_no = r.VERSION_NO AND p.PROJECT_ID = r.PROJECT_ID RIGHT OUTER JOIN
                      dbo.REQUEST_VENDORS rv ON r.REQUEST_ID = rv.REQUEST_ID ON dbo.CONTACTS.CONTACT_ID = rv.VENDOR_CONTACT_ID LEFT OUTER JOIN
                      dbo.USERS USERS_2 ON rv.MODIFIED_BY = USERS_2.USER_ID ON request_types.LOOKUP_ID = r.REQUEST_TYPE_ID LEFT OUTER JOIN
                      dbo.LOOKUPS status ON r.REQUEST_STATUS_TYPE_ID = status.LOOKUP_ID ON priorities.LOOKUP_ID = r.PRIORITY_TYPE_ID ON 
                      USERS_1.USER_ID = rv.CREATED_BY ON c.CUSTOMER_ID = p.CUSTOMER_ID CROSS JOIN
                      dbo.LOOKUPS_V
WHERE     (dbo.LOOKUPS_V.type_code = 'workorder_status_type') AND (dbo.LOOKUPS_V.lookup_code = 'approved')
ORDER BY rv.SCH_START_DATE
GO

/****** Object:  View [dbo].[QP3_RESOURCE_TYPES_V]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[QP3_RESOURCE_TYPES_V]
AS
SELECT     TOP 100 PERCENT dbo.USERS.USER_ID, dbo.USER_ORGANIZATIONS.ORGANIZATION_ID, dbo.RESOURCES.ACTIVE_FLAG, dbo.USERS.FULL_NAME, 
                      dbo.USERS.EXT_EMPLOYEE_ID, dbo.RESOURCES.RESOURCE_TYPE_ID, dbo.USERS.LAST_NAME, dbo.USERS.LOGIN, dbo.USERS.PASSWORD, 
                      dbo.USERS.QP3, dbo.RESOURCES.ATTACHED_FLAG
FROM         dbo.USER_ORGANIZATIONS LEFT OUTER JOIN
                      dbo.USERS ON dbo.USER_ORGANIZATIONS.USER_ID = dbo.USERS.USER_ID RIGHT OUTER JOIN
                      dbo.RESOURCES ON dbo.USERS.USER_ID = dbo.RESOURCES.USER_ID
WHERE     (dbo.USERS.EXT_EMPLOYEE_ID IS NOT NULL) AND (dbo.USER_ORGANIZATIONS.ORGANIZATION_ID IS NOT NULL) AND 
                      (dbo.RESOURCES.ATTACHED_FLAG = 'y') AND (dbo.RESOURCES.ACTIVE_FLAG = 'Y')
ORDER BY dbo.USERS.LAST_NAME
GO
/****** Object:  View [dbo].[crystal_USERS_AND_RESOURCE_TYPES]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[crystal_USERS_AND_RESOURCE_TYPES]
AS
SELECT     dbo.USERS.USER_ID, dbo.USERS.FULL_NAME, dbo.RESOURCE_TYPES.NAME, dbo.RESOURCES.ORGANIZATION_ID, dbo.RESOURCES.ACTIVE_FLAG,
                       dbo.ORGANIZATIONS.NAME AS Org_Id_Name
FROM         dbo.USERS INNER JOIN
                      dbo.RESOURCES ON dbo.USERS.USER_ID = dbo.RESOURCES.USER_ID INNER JOIN
                      dbo.RESOURCE_TYPES ON dbo.RESOURCES.RESOURCE_TYPE_ID = dbo.RESOURCE_TYPES.RESOURCE_TYPE_ID INNER JOIN
                      dbo.ORGANIZATIONS ON dbo.RESOURCES.ORGANIZATION_ID = dbo.ORGANIZATIONS.ORGANIZATION_ID
WHERE     (dbo.RESOURCES.ACTIVE_FLAG = 'y')
GO
/****** Object:  View [dbo].[quotes_v]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[quotes_v]
AS
SELECT c.organization_id, 
       q.quote_id,
       q.quote_no, 
       CAST(p.project_no AS VARCHAR) + '-' + CAST(q.quote_no AS VARCHAR) AS project_quote_no, 
       r.project_id, 
       p.project_no, 
       q.request_id, 
       q.request_type_id, 
       request_type.code AS request_type_code, 
       request_type.name AS request_type_name, 
       c.ext_dealer_id, 
       c.customer_name, 
       p.job_name,
       q.is_sent, 
       q.quote_type_id, 
       quote_type.code AS quote_type_code, 
       quote_type.name AS quote_type_name, 
       q.quote_status_type_id, 
       quote_status_type.code AS quote_status_type_code, 
       quote_status_type.name AS quote_status_type_name, 
       q.quoted_by_user_id, 
       q.date_quoted, 
       quoted_by.first_name + ' ' + quoted_by.last_name AS quoted_by_user_name, 
       q.description, 
       q.quote_total, 
       q.extra_conditions, 
       q.date_created, 
       q.created_by, 
       q.date_modified, 
       q.modified_by, 
       quoted_by_contact.phone_work AS quoted_by_phone, 
       quoted_by_contact.contact_name AS quoted_by_name, 
       dealer_sales_rep_contact.contact_name AS sales_rep_contact_name, 
       time_uom.name AS duration_name, 
       r.duration_qty, 
       q.warehouse_fee_flag, 
       request_type.sequence_no AS request_type_sequence_no, 
       o.ext_direct_dealer_id, 
       q.taxable_flag, 
       q.taxable_amount,
       q.version
  FROM dbo.customers c LEFT OUTER JOIN
       dbo.organizations o ON c.organization_id = o.organization_id RIGHT OUTER JOIN
       dbo.projects p RIGHT OUTER JOIN
       dbo.contacts quoted_by_contact RIGHT OUTER JOIN
       dbo.users quoted_by ON quoted_by_contact.contact_id = quoted_by.contact_id RIGHT OUTER JOIN
       dbo.lookups quote_type RIGHT OUTER JOIN
       dbo.lookups quote_status_type RIGHT OUTER JOIN
       dbo.quotes q LEFT OUTER JOIN
       dbo.lookups request_type ON q.request_type_id = request_type.lookup_id 
                                ON quote_status_type.lookup_id = q.quote_status_type_id 
                                ON quote_type.lookup_id = q.quote_type_id 
                                ON quoted_by.user_id = q.quoted_by_user_id LEFT OUTER JOIN
       dbo.lookups time_uom RIGHT OUTER JOIN
       dbo.contacts dealer_sales_rep_contact RIGHT OUTER JOIN
       dbo.requests r ON dealer_sales_rep_contact.contact_id = r.d_sales_rep_contact_id 
		      ON time_uom.lookup_id = r.duration_time_uom_type_id 
		      ON q.request_id = r.request_id 
		      ON p.project_id = r.project_id 
		      ON c.customer_id = p.customer_id
GO
/****** Object:  View [dbo].[SERVICE_QUOTES_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[SERVICE_QUOTES_V]
AS
SELECT     dbo.PROJECTS_V.PROJECT_ID, QUOTE_REQUESTS.REQUEST_ID AS quote_request_id, SERVICE_REQUESTS.REQUEST_ID AS service_request_id,
                      dbo.QUOTES_V.QUOTE_ID, dbo.SERVICES.JOB_ID, dbo.SERVICES.SERVICE_ID, dbo.PROJECTS_V.PROJECT_NO, dbo.QUOTES_V.QUOTE_NO,
                      dbo.QUOTES_V.project_quote_no, dbo.QUOTES_V.QUOTE_TOTAL
FROM         dbo.REQUESTS QUOTE_REQUESTS INNER JOIN
                      dbo.REQUESTS SERVICE_REQUESTS INNER JOIN
                      dbo.SERVICES ON SERVICE_REQUESTS.REQUEST_ID = dbo.SERVICES.REQUEST_ID ON
                      QUOTE_REQUESTS.REQUEST_ID = SERVICE_REQUESTS.QUOTE_REQUEST_ID INNER JOIN
                      dbo.QUOTES_V ON QUOTE_REQUESTS.REQUEST_ID = dbo.QUOTES_V.REQUEST_ID INNER JOIN
                      dbo.PROJECTS_V ON QUOTE_REQUESTS.PROJECT_ID = dbo.PROJECTS_V.PROJECT_ID
GO

/****** Object:  View [dbo].[jobs_v]    Script Date: 05/03/2010 14:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  View [dbo].[tcn_resources_v]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[tcn_resources_v]
AS
SELECT     dbo.USERS.EXT_EMPLOYEE_ID AS employee_no, dbo.RESOURCES.NAME AS resource_name, dbo.RESOURCES.RESOURCE_ID, 
                      dbo.RESOURCES.ORGANIZATION_ID
FROM         dbo.USERS INNER JOIN
                      dbo.RESOURCES ON dbo.USERS.USER_ID = dbo.RESOURCES.USER_ID
WHERE     (dbo.RESOURCES.ACTIVE_FLAG = 'Y')
GO
/****** Object:  View [dbo].[projects_v2]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* $Id: projects_v2.sql 1655 2009-08-05 21:24:48Z bvonhaden $ */

CREATE VIEW [dbo].[projects_v2]
AS
SELECT TOP 100 PERCENT 
        p.project_id, 
        p.project_no, 
        p.project_type_id, 
        project_types.code AS project_type_code, 
        project_types.name AS project_type_name, 
        p.project_status_type_id, 
        project_status_type.code AS project_status_type_code, 
        project_status_type.name AS project_status_type_name, 
        p.job_name, 
        p.percent_complete, 
        p.date_created, 
        p.created_by, 
        p.date_modified, 
        p.modified_by, 
        u.first_name + ' ' + u.last_name AS created_by_name,
        c.organization_id,  
        c.parent_customer_id, 
        CASE WHEN customer_type.code = 'dealer' THEN ISNULL(c.ext_customer_id, c.ext_dealer_id) ELSE c.ext_dealer_id END ext_dealer_id, 
        c.dealer_name, 
        c.ext_customer_id, 
        eu.ext_customer_id ext_end_user_id,
        CASE WHEN customer_type.code = 'end_user' THEN c.end_user_parent_id ELSE p.customer_id END customer_id,
        CASE WHEN customer_type.code = 'end_user' THEN (SELECT customer_name FROM customers WHERE customer_id = c.end_user_parent_id) ELSE c.customer_name END customer_name,
        CASE WHEN customer_type.code = 'end_user' THEN c.customer_id ELSE p.end_user_id END end_user_id,
        CASE WHEN customer_type.code = 'end_user' THEN c.customer_name ELSE eu.customer_name END end_user_name,
        p.is_new,
        c.refusal_email_info, 
        c.survey_location
   FROM dbo.projects p INNER JOIN
        dbo.lookups project_types ON p.project_type_id = project_types.lookup_id INNER JOIN 
        dbo.lookups project_status_type ON p.project_status_type_id = project_status_type.lookup_id INNER JOIN 
        dbo.users u ON p.created_by = u.user_id INNER JOIN
        dbo.customers c ON p.customer_id = c.customer_id INNER JOIN
        dbo.lookups customer_type ON c.customer_type_id = customer_type.lookup_id LEFT OUTER JOIN
        dbo.customers eu ON p.end_user_id = eu.customer_id 
ORDER BY p.project_id
GO
/****** Object:  View [dbo].[USERS_V]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[USERS_V]
AS
SELECT     main.USER_ID, main.EXT_EMPLOYEE_ID, main.FIRST_NAME, main.LAST_NAME, main.CONTACT_ID, main.EMPLOYMENT_TYPE_ID, 
                      employement_types.CODE AS employment_type_code, employement_types.NAME AS employment_type_name, main.USER_TYPE_ID, 
                      user_types.CODE AS user_type_code, user_types.NAME AS user_type_name, main.EXT_DEALER_ID, main.DEALER_NAME, 
                      main.FIRST_NAME + ' ' + main.LAST_NAME AS full_name, main.LAST_LOGIN, main.LOGIN, main.PASSWORD, main.ACTIVE_FLAG, 
                      main.DATE_CREATED, main.DATE_MODIFIED, main.CREATED_BY, main.MODIFIED_BY, 
                      created_by.FIRST_NAME + ' ' + created_by.LAST_NAME AS created_by_name, 
                      modified_by.FIRST_NAME + ' ' + modified_by.LAST_NAME AS modified_by_name, main.PIN, main.IMOBILE_LOGIN, main.LAST_SYNCH_DATE, 
                      vendor_contact.EMAIL, main.VENDOR_CONTACT_ID, vendor_contact.CONTACT_NAME AS vendor_contact_name
FROM         dbo.CONTACTS CONTACTS_1 RIGHT OUTER JOIN
                      dbo.LOOKUPS employement_types RIGHT OUTER JOIN
                      dbo.CONTACTS vendor_contact RIGHT OUTER JOIN
                      dbo.LOOKUPS user_types RIGHT OUTER JOIN
                      dbo.USERS created_by RIGHT OUTER JOIN
                      dbo.USERS main LEFT OUTER JOIN
                      dbo.USERS modified_by ON main.MODIFIED_BY = modified_by.USER_ID ON created_by.USER_ID = main.CREATED_BY ON 
                      user_types.LOOKUP_ID = main.USER_TYPE_ID ON vendor_contact.CONTACT_ID = main.VENDOR_CONTACT_ID ON 
                      employement_types.LOOKUP_ID = main.EMPLOYMENT_TYPE_ID ON CONTACTS_1.CONTACT_ID = main.CONTACT_ID
WHERE     (main.ACTIVE_FLAG = 'Y')
GO
/****** Object:  View [dbo].[crystal_REQUESTS_COUNT_USAGE_V]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[crystal_REQUESTS_COUNT_USAGE_V]
AS
SELECT     dbo.REQUESTS.REQUEST_ID, dbo.REQUESTS.REQUEST_TYPE_ID, REQUEST_TYPE.CODE AS request_type_code, 
                      REQUEST_TYPE.NAME AS request_type_name, dbo.REQUESTS.REQUEST_STATUS_TYPE_ID, dbo.REQUESTS.DATE_CREATED, 
                      dbo.REQUESTS.CREATED_BY, USERS_1.FIRST_NAME + ' ' + USERS_1.LAST_NAME AS created_by_name, CONVERT(varchar(12), 
                      dbo.REQUESTS.DATE_CREATED, 101) AS date_created_varchar, USERS_1.EXT_DEALER_ID, dbo.REQUESTS.VERSION_NO, 
                      dbo.REQUESTS.IS_SURVEYED, dbo.REQUESTS.IS_QUOTED, dbo.REQUESTS.QUOTE_REQUEST_ID
FROM         dbo.LOOKUPS REQUEST_TYPE INNER JOIN
                      dbo.REQUESTS ON REQUEST_TYPE.LOOKUP_ID = dbo.REQUESTS.REQUEST_TYPE_ID INNER JOIN
                      dbo.USERS USERS_1 ON dbo.REQUESTS.CREATED_BY = USERS_1.USER_ID
GO
/****** Object:  View [dbo].[USER_CONTACTS_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[USER_CONTACTS_V]
AS
SELECT     dbo.USERS.USER_ID, dbo.USERS.FIRST_NAME, dbo.USERS.LAST_NAME, dbo.USERS.ACTIVE_FLAG, dbo.CONTACTS.EMAIL, 
                      dbo.CONTACTS.ORGANIZATION_ID
FROM         dbo.USERS INNER JOIN
                      dbo.CONTACTS ON dbo.USERS.CONTACT_ID = dbo.CONTACTS.CONTACT_ID
WHERE     (dbo.USERS.ACTIVE_FLAG = 'y') AND (dbo.CONTACTS.EMAIL IS NOT NULL)
GO
/****** Object:  View [dbo].[crystal_dashboard_QUOTES_V]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[crystal_dashboard_QUOTES_V]
AS
SELECT     dbo.CUSTOMERS.ORGANIZATION_ID, dbo.QUOTES.QUOTE_ID, dbo.QUOTES.QUOTE_NO, CAST(dbo.PROJECTS.PROJECT_NO AS VARCHAR) 
                      + '-' + CAST(dbo.QUOTES.QUOTE_NO AS VARCHAR) AS project_quote_no, dbo.REQUESTS.PROJECT_ID, dbo.PROJECTS.PROJECT_NO, 
                      dbo.QUOTES.REQUEST_ID, dbo.QUOTES.REQUEST_TYPE_ID, REQUEST_TYPE.CODE AS request_type_code, 
                      REQUEST_TYPE.NAME AS request_type_name, dbo.CUSTOMERS.EXT_DEALER_ID, dbo.CUSTOMERS.CUSTOMER_NAME, dbo.PROJECTS.JOB_NAME,
                       dbo.QUOTES.IS_SENT, dbo.QUOTES.QUOTE_TYPE_ID, QUOTE_TYPE.CODE AS quote_type_code, QUOTE_TYPE.NAME AS quote_type_name, 
                      dbo.QUOTES.QUOTE_STATUS_TYPE_ID, QUOTE_STATUS_TYPE.CODE AS quote_status_type_code, 
                      QUOTE_STATUS_TYPE.NAME AS quote_status_type_name, dbo.QUOTES.QUOTED_BY_USER_ID, dbo.QUOTES.DATE_QUOTED, 
                      QUOTED_BY.FIRST_NAME + ' ' + QUOTED_BY.LAST_NAME AS quoted_by_user_name, dbo.QUOTES.DESCRIPTION, dbo.QUOTES.QUOTE_TOTAL, 
                      dbo.QUOTES.EXTRA_CONDITIONS, dbo.QUOTES.DATE_CREATED, dbo.QUOTES.CREATED_BY, dbo.QUOTES.DATE_MODIFIED, 
                      dbo.QUOTES.MODIFIED_BY, Quoted_by_contact.PHONE_WORK AS quoted_by_phone, Quoted_by_contact.CONTACT_NAME AS quoted_by_name, 
                      DEALER_SALES_REP_CONTACT.CONTACT_NAME AS sales_rep_contact_name, time_uom.NAME AS duration_name, dbo.REQUESTS.DURATION_QTY, 
                      dbo.QUOTES.WAREHOUSE_FEE_FLAG, REQUEST_TYPE.SEQUENCE_NO AS REQUEST_TYPE_SEQUENCE_NO, 
                      dbo.ORGANIZATIONS.EXT_DIRECT_DEALER_ID, dbo.QUOTES.TAXABLE_FLAG, dbo.QUOTES.TAXABLE_AMOUNT, 
                      dbo.ORGANIZATIONS.CODE AS ORG_CODE, dbo.ORGANIZATIONS.NAME AS ORG_NAME, dbo.CUSTOMERS.DEALER_NAME, 
                      dbo.REQUESTS.IS_QUOTED, dbo.REQUESTS.QUOTE_NEEDED_BY, dbo.REQUESTS.QUOTE_REQUEST_ID, 
                      dbo.REQUESTS.DATE_CREATED AS Request_Created_Date, dbo.REQUESTS.REQUEST_NO
FROM         dbo.CONTACTS Quoted_by_contact RIGHT OUTER JOIN
                      dbo.USERS QUOTED_BY ON Quoted_by_contact.CONTACT_ID = QUOTED_BY.CONTACT_ID RIGHT OUTER JOIN
                      dbo.LOOKUPS QUOTE_TYPE RIGHT OUTER JOIN
                      dbo.LOOKUPS QUOTE_STATUS_TYPE RIGHT OUTER JOIN
                      dbo.QUOTES LEFT OUTER JOIN
                      dbo.LOOKUPS REQUEST_TYPE ON dbo.QUOTES.REQUEST_TYPE_ID = REQUEST_TYPE.LOOKUP_ID ON 
                      QUOTE_STATUS_TYPE.LOOKUP_ID = dbo.QUOTES.QUOTE_STATUS_TYPE_ID ON QUOTE_TYPE.LOOKUP_ID = dbo.QUOTES.QUOTE_TYPE_ID ON 
                      QUOTED_BY.USER_ID = dbo.QUOTES.QUOTED_BY_USER_ID FULL OUTER JOIN
                      dbo.CUSTOMERS LEFT OUTER JOIN
                      dbo.ORGANIZATIONS ON dbo.CUSTOMERS.ORGANIZATION_ID = dbo.ORGANIZATIONS.ORGANIZATION_ID RIGHT OUTER JOIN
                      dbo.PROJECTS RIGHT OUTER JOIN
                      dbo.LOOKUPS time_uom RIGHT OUTER JOIN
                      dbo.CONTACTS DEALER_SALES_REP_CONTACT RIGHT OUTER JOIN
                      dbo.REQUESTS ON DEALER_SALES_REP_CONTACT.CONTACT_ID = dbo.REQUESTS.D_SALES_REP_CONTACT_ID ON 
                      time_uom.LOOKUP_ID = dbo.REQUESTS.DURATION_TIME_UOM_TYPE_ID ON dbo.PROJECTS.PROJECT_ID = dbo.REQUESTS.PROJECT_ID ON 
                      dbo.CUSTOMERS.CUSTOMER_ID = dbo.PROJECTS.CUSTOMER_ID ON dbo.QUOTES.REQUEST_ID = dbo.REQUESTS.REQUEST_ID
GO
/****** Object:  View [dbo].[pep_vendor_user_v]    Script Date: 05/03/2010 14:18:08 ******/
-- SET ANSI_NULLS ON
-- GO
-- SET QUOTED_IDENTIFIER ON
-- GO
-- CREATE VIEW [dbo].[pep_vendor_user_v]
-- AS
-- SELECT     TOP 100 PERCENT dbo.USERS.LAST_NAME, dbo.USERS.FULL_NAME, dbo.USERS.CUSTOMER_ID, dbo.USERS.VENDOR_CONTACT_ID,
--                       dbo.CUSTOMERS.CUSTOMER_NAME
-- FROM         dbo.USERS INNER JOIN
--                       dbo.CUSTOMERS ON dbo.USERS.CUSTOMER_ID = dbo.CUSTOMERS.CUSTOMER_ID
-- ORDER BY dbo.USERS.LAST_NAME
-- GO
/****** Object:  View [dbo].[ITEMS_V]    Script Date: 05/03/2010 14:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ITEMS_V]

AS

SELECT     dbo.ITEMS.ORGANIZATION_ID, dbo.ITEMS.ITEM_ID, dbo.ITEMS.NAME, dbo.ITEMS.DESCRIPTION, dbo.ITEMS.EXT_ITEM_ID, 

                      dbo.ITEMS.ITEM_TYPE_ID, ITEM_TYPE.CODE AS item_type_code, ITEM_TYPE.NAME AS item_type_name, dbo.ITEMS.ITEM_STATUS_TYPE_ID, 

                      STATUS_TYPE.CODE AS item_status_type_code, STATUS_TYPE.NAME AS item_status_type_name, dbo.ITEMS.CODE, dbo.ITEMS.BILLABLE_FLAG, 

                      dbo.ITEMS.SEQUENCE_NO, dbo.ITEMS.EXPENSE_EXPORT_CODE, dbo.ITEMS.JOB_TYPE_ID, dbo.ITEMS.COST_PER_UOM, 

                      dbo.ITEMS.PERCENT_MARGIN, dbo.ITEMS.CREATED_BY, dbo.ITEMS.DATE_CREATED, 

                      CREATE_USER.FIRST_NAME + ' ' + CREATE_USER.LAST_NAME AS created_by_name, dbo.ITEMS.DATE_MODIFIED, dbo.ITEMS.MODIFIED_BY, 

                      MOD_USER.FIRST_NAME + ' ' + MOD_USER.LAST_NAME AS modified_by_name, dbo.ITEMS.allow_expense_entry, dbo.ITEMS.item_category_type_id, 

                      item_category.CODE AS item_category_type_code, item_category.NAME AS item_category_type_name

FROM         dbo.LOOKUPS ITEM_TYPE RIGHT OUTER JOIN

                      dbo.LOOKUPS STATUS_TYPE RIGHT OUTER JOIN

                      dbo.ITEMS LEFT OUTER JOIN

                      dbo.USERS MOD_USER ON dbo.ITEMS.MODIFIED_BY = MOD_USER.USER_ID LEFT OUTER JOIN

                      dbo.USERS CREATE_USER ON dbo.ITEMS.CREATED_BY = CREATE_USER.USER_ID ON 

                      STATUS_TYPE.LOOKUP_ID = dbo.ITEMS.ITEM_STATUS_TYPE_ID ON ITEM_TYPE.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID LEFT OUTER JOIN

                      dbo.LOOKUPS item_category ON dbo.ITEMS.item_category_type_id = item_category.LOOKUP_ID
GO
/****** Object:  View [dbo].[REQUEST_VENDORS_V2]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[REQUEST_VENDORS_V2]
AS
SELECT     TOP 100 PERCENT cust.ORGANIZATION_ID, r.PROJECT_ID, r.REQUEST_ID, cust.CUSTOMER_ID, cust.PARENT_CUSTOMER_ID, 
                      rv.REQUEST_VENDOR_ID, rv.VENDOR_CONTACT_ID, p.PROJECT_NO, r.REQUEST_NO, CONVERT(varchar, p.PROJECT_NO) + '-' + CONVERT(varchar, 
                      r.REQUEST_NO) AS workorder_no, dbo.CONTACTS.CONTACT_NAME AS vendor_contact_name, cust.DEALER_NAME, cust.EXT_DEALER_ID, 
                      cust.CUSTOMER_NAME, r.DEALER_PO_NO, r.CUSTOMER_PO_NO, r.EST_START_DATE, rv.EMAILED_DATE, priorities.NAME AS priority, 
                      rv.SCH_START_DATE, rv.SCH_START_TIME, rv.SCH_END_DATE, rv.ACT_START_DATE, rv.ACT_START_TIME, rv.ACT_END_DATE, 
                      rv.ESTIMATED_COST, rv.TOTAL_COST, rv.INVOICE_DATE, rv.INVOICE_NUMBERS, rv.VISIT_COUNT, rv.COMPLETE_FLAG, rv.INVOICED_FLAG, 
                      rv.VENDOR_NOTES, rv.DATE_CREATED, rv.CREATED_BY, Created.FULL_NAME AS created_by_name, rv.DATE_MODIFIED, rv.MODIFIED_BY, 
                      Modified.FULL_NAME AS modified_by_name, request_types.CODE AS request_type_code, status.SEQUENCE_NO AS status_seq_no, 
                      status.CODE AS request_status_type_code, status.NAME AS request_status_type_name, CONVERT(VARCHAR(12), r.EST_START_DATE, 101) 
                      AS est_start_date_varchar, CONVERT(VARCHAR(12), r.EST_END_DATE, 101) AS est_end_date_varchar, CONVERT(VARCHAR(12), rv.SCH_START_DATE, 
                      101) AS sch_start_date_varchar, CONVERT(VARCHAR(12), rv.SCH_END_DATE, 101) AS sch_end_date_varchar, CONVERT(VARCHAR(12), 
                      rv.INVOICE_DATE, 101) AS invoice_date_varchar, r.FURNITURE1_CONTACT_ID, r.FURNITURE2_CONTACT_ID
FROM         dbo.CUSTOMERS cust RIGHT OUTER JOIN
                      dbo.USERS Created RIGHT OUTER JOIN
                      dbo.LOOKUPS priorities RIGHT OUTER JOIN
                      dbo.LOOKUPS request_types RIGHT OUTER JOIN
                      dbo.CONTACTS RIGHT OUTER JOIN
                      dbo.PROJECTS p INNER JOIN
                      dbo.REQUESTS r ON p.PROJECT_ID = r.PROJECT_ID RIGHT OUTER JOIN
                      dbo.REQUEST_VENDORS rv ON r.REQUEST_ID = rv.REQUEST_ID ON dbo.CONTACTS.CONTACT_ID = rv.VENDOR_CONTACT_ID LEFT OUTER JOIN
                      dbo.USERS Modified ON rv.MODIFIED_BY = Modified.USER_ID ON request_types.LOOKUP_ID = r.REQUEST_TYPE_ID LEFT OUTER JOIN
                      dbo.LOOKUPS status ON r.REQUEST_STATUS_TYPE_ID = status.LOOKUP_ID ON priorities.LOOKUP_ID = r.PRIORITY_TYPE_ID ON 
                      Created.USER_ID = rv.CREATED_BY ON cust.CUSTOMER_ID = p.CUSTOMER_ID
WHERE     (r.VERSION_NO =
                          (SELECT     MAX(r2.version_no)
                            FROM          requests r2
                            WHERE      r2.project_id = r.project_id AND r2.request_no = r.request_no))
ORDER BY rv.SCH_START_DATE
GO
/****** Object:  View [dbo].[USERS_VQ]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[USERS_VQ]
AS
SELECT     main.USER_ID, main.EXT_EMPLOYEE_ID, main.FIRST_NAME, main.LAST_NAME, main.CONTACT_ID, main.EMPLOYMENT_TYPE_ID, 
                      main.USER_TYPE_ID, 
                       main.EXT_DEALER_ID, main.DEALER_NAME, 
                      main.FIRST_NAME + ' ' + main.LAST_NAME AS full_name, main.LAST_LOGIN, main.LOGIN, main.PASSWORD, main.ACTIVE_FLAG, 
                      main.DATE_CREATED, main.DATE_MODIFIED, main.CREATED_BY, main.MODIFIED_BY, 
                      main.PIN, main.IMOBILE_LOGIN, main.LAST_SYNCH_DATE, 
                      main.VENDOR_CONTACT_ID
FROM                  dbo.USERS main
WHERE     (main.ACTIVE_FLAG = 'Y')
GO
/****** Object:  View [dbo].[INVOICE_TRACKING_V]    Script Date: 05/03/2010 14:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[INVOICE_TRACKING_V]
AS
SELECT     INVOICE_STATUSES_1.CODE AS invoice_status_code, INVOICE_STATUSES_1.NAME AS invoice_status_name, dbo.INVOICES.STATUS_ID, 
                      dbo.INVOICES.DESCRIPTION, dbo.INVOICE_TRACKING.DATE_CREATED, INVOICE_STATUSES_2.NAME AS new_status_name, 
                      INVOICE_STATUSES_1.NAME AS old_status_name, dbo.CONTACTS.CONTACT_NAME AS to_contact_name, 
                      dbo.USERS.FIRST_NAME + ' ' + dbo.USERS.LAST_NAME AS created_by_name, 
                      USERS_1.FIRST_NAME + ' ' + USERS_1.LAST_NAME AS modified_by_name, dbo.CONTACTS.EMAIL, 
                      USERS_2.FIRST_NAME + ' ' + USERS_2.LAST_NAME AS from_user_name, dbo.INVOICE_TRACKING.DATE_MODIFIED, dbo.INVOICE_TRACKING.NOTES, 
                      dbo.INVOICE_TRACKING.FROM_USER_ID, dbo.INVOICE_TRACKING.TO_CONTACT_ID, dbo.INVOICE_TRACKING.INVOICE_TRACKING_ID, 
                      dbo.INVOICE_TRACKING.INVOICE_ID, dbo.INVOICES.PO_NO, TRACKING_TYPES.CODE AS invoice_tracking_type_code, 
                      TRACKING_TYPES.NAME AS invoice_tracking_type_name, dbo.INVOICE_TRACKING.EMAIL_SENT_FLAG
FROM         dbo.CONTACTS RIGHT OUTER JOIN
                      dbo.INVOICE_STATUSES INVOICE_STATUSES_1 INNER JOIN
                      dbo.INVOICES INNER JOIN
                      dbo.INVOICE_TRACKING ON dbo.INVOICES.INVOICE_ID = dbo.INVOICE_TRACKING.INVOICE_ID ON 
                      INVOICE_STATUSES_1.STATUS_ID = dbo.INVOICES.STATUS_ID INNER JOIN
                      dbo.LOOKUPS TRACKING_TYPES ON dbo.INVOICE_TRACKING.INVOICE_TRACKING_TYPE_ID = TRACKING_TYPES.LOOKUP_ID INNER JOIN
                      dbo.USERS ON dbo.INVOICE_TRACKING.CREATED_BY = dbo.USERS.USER_ID ON 
                      dbo.CONTACTS.CONTACT_ID = dbo.INVOICE_TRACKING.TO_CONTACT_ID LEFT OUTER JOIN
                      dbo.USERS USERS_2 ON dbo.INVOICE_TRACKING.FROM_USER_ID = USERS_2.USER_ID LEFT OUTER JOIN
                      dbo.USERS USERS_1 ON dbo.INVOICE_TRACKING.MODIFIED_BY = USERS_1.USER_ID LEFT OUTER JOIN
                      dbo.INVOICE_STATUSES INVOICE_STATUSES_2 ON dbo.INVOICE_TRACKING.NEW_STATUS_ID = INVOICE_STATUSES_2.STATUS_ID LEFT OUTER JOIN
                      dbo.INVOICE_STATUSES INVOICE_STATUSES_3 ON dbo.INVOICE_TRACKING.OLD_STATUS_ID = INVOICE_STATUSES_3.STATUS_ID
GO
/****** Object:  View [dbo].[PENDING_TRACKING_V]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[PENDING_TRACKING_V]
AS
SELECT     
	'service' type, 
	t .TRACKING_ID, 
	t .NOTES, 
	ISNULL(CONVERT(varchar, s.SERVICE_NO), 'N') AS record_no, 
	j.JOB_NO,
	ISNULL(j.JOB_NAME, 'N/A') AS job_name, 
	CONVERT(varchar, t .DATE_CREATED) AS date_created, 
	Tracking_type.ATTRIBUTE1, 
	c.contact_id,
	c.contact_name, 
	c.EMAIL as to_email,
	t .EMAIL_SENT_FLAG,
	CONTACTS_1.EMAIL AS from_email
FROM          dbo.TRACKING t LEFT OUTER JOIN
                      dbo.CONTACTS c ON t .TO_CONTACT_ID = c.CONTACT_ID RIGHT OUTER JOIN
                      dbo.USERS LEFT OUTER JOIN
                      dbo.CONTACTS CONTACTS_1 ON dbo.USERS.CONTACT_ID = CONTACTS_1.CONTACT_ID ON 
                      t .FROM_USER_ID = dbo.USERS.USER_ID LEFT OUTER JOIN
                      dbo.LOOKUPS Tracking_type ON t .TRACKING_TYPE_ID = Tracking_type.LOOKUP_ID LEFT OUTER JOIN
                      dbo.JOBS j ON t .JOB_ID = j.JOB_ID LEFT OUTER JOIN
                      dbo.SERVICES s ON t .SERVICE_ID = s.SERVICE_ID
WHERE     (Tracking_type.ATTRIBUTE1 = 'SEND_EMAIL') AND (t .EMAIL_SENT_FLAG= 'N')
UNION ALL
SELECT     
   'invoice' AS type, 
   t.INVOICE_TRACKING_ID AS TRACKING_ID, 
   t.NOTES, 
   ISNULL(CONVERT(varchar, i.INVOICE_ID), 'N') AS record_no, 
   j.JOB_NO, 
   ISNULL(j.JOB_NAME, 'N/A') AS job_name,
   CONVERT(varchar, t.DATE_CREATED) AS date_created,
   Tracking_type.ATTRIBUTE1, 
   c.CONTACT_ID, 
   c.CONTACT_NAME, 
   c.EMAIL AS to_email, 
   t.EMAIL_SENT_FLAG, 
   CONTACTS_1.EMAIL AS from_email
FROM         dbo.USERS LEFT OUTER JOIN
                      dbo.CONTACTS CONTACTS_1 ON dbo.USERS.CONTACT_ID = CONTACTS_1.CONTACT_ID RIGHT OUTER JOIN
                      dbo.JOBS j RIGHT OUTER JOIN
                      dbo.CONTACTS c RIGHT OUTER JOIN
                      dbo.INVOICE_TRACKING t LEFT OUTER JOIN
                      dbo.LOOKUPS Tracking_type ON t.INVOICE_TRACKING_TYPE_ID = Tracking_type.LOOKUP_ID ON c.CONTACT_ID = t.TO_CONTACT_ID LEFT OUTER JOIN
                      dbo.INVOICES i ON t.INVOICE_ID = i.INVOICE_ID ON j.JOB_ID = i.JOB_ID ON dbo.USERS.USER_ID = t.FROM_USER_ID
WHERE     (Tracking_type.ATTRIBUTE1 = 'SEND_EMAIL') AND (t.EMAIL_SENT_FLAG = 'N')
GO
/****** Object:  View [dbo].[USER_CUSTOMERS_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[USER_CUSTOMERS_V]
AS
SELECT     dbo.USER_CUSTOMERS.user_id, dbo.CUSTOMERS.CUSTOMER_ID
FROM         dbo.CUSTOMERS INNER JOIN
                      dbo.USER_CUSTOMERS ON dbo.CUSTOMERS.PARENT_CUSTOMER_ID = dbo.USER_CUSTOMERS.customer_id
UNION
SELECT     dbo.USER_CUSTOMERS.user_id, dbo.USER_CUSTOMERS.customer_id
FROM         dbo.USER_CUSTOMERS
GO
/****** Object:  View [dbo].[crystal_UNBILLED_OPS_AIA_V]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[crystal_UNBILLED_OPS_AIA_V]
AS
SELECT     ORGANIZATION_ID, BILL_JOB_NO, BILL_JOB_ID, job_status_type_name, job_name, BILLING_USER_ID, EXT_DEALER_ID, DEALER_NAME, 
                      CUSTOMER_NAME, job_owner, max_est_end_date, max_est_end_date_varchar, billable_total, non_billable_total, PO_NO
FROM         dbo.crystal_UNBILLED_OPS_V
WHERE     (ORGANIZATION_ID = 8)
GO
/****** Object:  View [dbo].[PKT_ROSTER_V]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[PKT_ROSTER_V]
AS
SELECT     JOB_ID, RESOURCE_ID
FROM         (SELECT     JOB_ID, RESOURCE_ID
                       FROM          dbo.SCH_RESOURCES
                       WHERE      (CONVERT(datetime, CONVERT(varchar, RES_START_DATE, 101)) <= CONVERT(datetime, CONVERT(varchar, GETDATE(), 101))) AND 
                                              (ISNULL(CONVERT(datetime, CONVERT(varchar, RES_END_DATE, 101)), DATEADD(day, 1, CONVERT(datetime, CONVERT(varchar, 
                                              GETDATE(), 101)))) >= CONVERT(datetime, CONVERT(varchar, GETDATE(), 101)))
                       UNION
                       SELECT     dbo.PDA_ROSTER_CHANGES.JOB_ID, dbo.PDA_ROSTER_CHANGES.RESOURCE_ID
                       FROM         dbo.PDA_ROSTER_CHANGES INNER JOIN
                                             dbo.RESOURCES ON dbo.PDA_ROSTER_CHANGES.RESOURCE_ID = dbo.RESOURCES.RESOURCE_ID
                       WHERE     (dbo.RESOURCES.ACTIVE_FLAG = 'Y')) tempTable
GO
/****** Object:  View [dbo].[pkt_job_user_res_v]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[pkt_job_user_res_v]
AS
SELECT job_id, 
       user_id, 
       resource_id
  FROM (SELECT j.job_id, 
               jd.user_id, 
               r.resource_id
          FROM dbo.jobs j INNER JOIN
               dbo.job_distributions jd ON j.job_id = jd.job_id INNER JOIN
               dbo.resources r ON jd.user_id = r.user_id
         WHERE (r.active_flag = 'Y')
       UNION
        SELECT sr.job_id, 
               r.user_id, 
               r.resource_id
          FROM dbo.sch_resources sr INNER JOIN
               dbo.RESOURCES r ON sr.resource_id = r.resource_id
         WHERE CONVERT(DATETIME, CONVERT(VARCHAR, sr.res_start_date, 101)) <= CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(), 101))
           AND ISNULL(CONVERT(DATETIME, CONVERT(VARCHAR, sr.res_end_date, 101)), DATEADD(DAY, 1, CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(), 101)))) >= CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(), 101)) 
           AND r.ACTIVE_FLAG = 'Y'
       UNION
        SELECT prc.job_id, 
               r.user_id, 
               prc.resource_id
          FROM dbo.pda_roster_changes prc INNER JOIN
               dbo.resources r ON prc.resource_id = r.resource_id
         WHERE r.active_flag = 'Y') tmp
GO
/****** Object:  View [dbo].[PKT_JOB_RESOURCES_V]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[PKT_JOB_RESOURCES_V]
AS
SELECT     dbo.JOBS.JOB_ID, dbo.RESOURCES.RESOURCE_ID, dbo.RESOURCES.NAME AS resource_name
FROM         dbo.RESOURCES INNER JOIN
                      dbo.PKT_JOB_USER_RES_V INNER JOIN
                      dbo.JOBS INNER JOIN
                      dbo.LOOKUPS ON dbo.JOBS.JOB_STATUS_TYPE_ID = dbo.LOOKUPS.LOOKUP_ID ON dbo.PKT_JOB_USER_RES_V.JOB_ID = dbo.JOBS.JOB_ID ON
                      dbo.RESOURCES.RESOURCE_ID = dbo.PKT_JOB_USER_RES_V.RESOURCE_ID
WHERE     (dbo.LOOKUPS.CODE <> 'install_complete') AND (dbo.LOOKUPS.CODE <> 'invoiced') AND (dbo.LOOKUPS.CODE <> 'closed')
GO
/****** Object:  View [dbo].[RESOURCES_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[RESOURCES_V]
AS
SELECT     dbo.RESOURCES.ORGANIZATION_ID, dbo.RESOURCES.RESOURCE_ID, dbo.RESOURCES.NAME, dbo.RESOURCES.NAME AS resource_name, 
                      dbo.RESOURCES.RES_CATEGORY_TYPE_ID, RES_CATEGORY_TYPES.CODE AS res_cat_type_code, 
                      RES_CATEGORY_TYPES.NAME AS res_cat_type_name, dbo.RESOURCES.RESOURCE_TYPE_ID, 
                      dbo.RESOURCE_TYPES.CODE AS resource_type_code, dbo.RESOURCE_TYPES.NAME AS resource_type_name, RESOURCE_USER.PIN, 
                      RESOURCE_USER.EXT_EMPLOYEE_ID, RESOURCE_USER.EMPLOYMENT_TYPE_ID, ISNULL(EMPLOYMENT_TYPES.CODE, 'None') 
                      AS employment_type_code, ISNULL(EMPLOYMENT_TYPES.NAME, 'None') AS employment_type_name, dbo.RESOURCES.USER_ID, 
                      RESOURCE_USER.FIRST_NAME + ' ' + RESOURCE_USER.LAST_NAME AS user_full_name, RESOURCE_USER.CONTACT_ID AS user_contact_id, 
                      dbo.CONTACTS.CONTACT_NAME AS user_contact_name, dbo.RESOURCES.ATTACHED_FLAG, dbo.RESOURCES.VENDOR_NAME, 
                      dbo.RESOURCES.EXT_VENDOR_ID, dbo.RESOURCE_TYPES.UNIQUE_FLAG, dbo.RESOURCES.ACTIVE_FLAG, dbo.RESOURCES.FOREMAN_FLAG, 
                      dbo.RESOURCES.NOTES, dbo.RESOURCES.DATE_CREATED, dbo.RESOURCES.CREATED_BY, 
                      CREATED_BY.FIRST_NAME + ' ' + CREATED_BY.LAST_NAME AS created_by_name, dbo.RESOURCES.DATE_MODIFIED, 
                      dbo.RESOURCES.MODIFIED_BY, MODIFIED_BY.FIRST_NAME + '
' + MODIFIED_BY.LAST_NAME AS modified_by_name
FROM         dbo.LOOKUPS EMPLOYMENT_TYPES RIGHT OUTER JOIN
                      dbo.CONTACTS RIGHT OUTER JOIN
                      dbo.USERS RESOURCE_USER ON dbo.CONTACTS.CONTACT_ID = RESOURCE_USER.CONTACT_ID RIGHT OUTER JOIN
                      dbo.RESOURCES LEFT OUTER JOIN
                      dbo.RESOURCE_TYPES ON dbo.RESOURCES.RESOURCE_TYPE_ID = dbo.RESOURCE_TYPES.RESOURCE_TYPE_ID LEFT OUTER JOIN
                      dbo.LOOKUPS RES_CATEGORY_TYPES ON dbo.RESOURCES.RES_CATEGORY_TYPE_ID = RES_CATEGORY_TYPES.LOOKUP_ID LEFT OUTER JOIN
                      dbo.USERS MODIFIED_BY ON dbo.RESOURCES.MODIFIED_BY = MODIFIED_BY.USER_ID LEFT OUTER JOIN
                      dbo.USERS CREATED_BY ON dbo.RESOURCES.CREATED_BY = CREATED_BY.USER_ID ON 
                      RESOURCE_USER.USER_ID = dbo.RESOURCES.USER_ID ON EMPLOYMENT_TYPES.LOOKUP_ID = RESOURCE_USER.EMPLOYMENT_TYPE_ID
GO

/****** Object:  View [dbo].[ACTIVE_USERS_COUNT_V]    Script Date: 05/03/2010 14:18:05 ******/
-- SET ANSI_NULLS ON
-- GO
-- SET QUOTED_IDENTIFIER ON
-- GO
-- CREATE VIEW [dbo].[ACTIVE_USERS_COUNT_V]
-- AS
-- SELECT     USER_ID, CONTACT_ID, EMPLOYMENT_TYPE_ID, EXT_DEALER_ID, DEALER_NAME, CUSTOMER_ID, USER_TYPE_ID, FIRST_NAME, LAST_NAME,
--                       LOGIN, LAST_LOGIN, ACTIVE_FLAG, FULL_NAME
-- FROM         dbo.USERS
-- WHERE     (ACTIVE_FLAG = 'y') AND (LAST_LOGIN > CONVERT(DATETIME, '2004-01-01 00:00:00', 102))
-- GO

/****** Object:  View [dbo].[SERVICE_LINE_EXPENSE_V]    Script Date: 05/03/2010 14:18:09 ******/
-- SET ANSI_NULLS ON
-- GO
-- SET QUOTED_IDENTIFIER ON
-- GO
-- CREATE VIEW [dbo].[SERVICE_LINE_EXPENSE_V]
-- AS
-- SELECT     dbo.RESOURCES.RESOURCE_ID, dbo.SERVICES.JOB_ID, dbo.JOBS.JOB_NO, dbo.SERVICE_LINES.SERVICE_ID, dbo.SERVICES.SERVICE_NO,
--                       dbo.RESOURCES.NAME AS resource_name, dbo.RESOURCES.RES_CATEGORY_TYPE_ID, LOOKUPS_4.CODE AS res_cat_type_code,
--                       LOOKUPS_4.NAME AS res_cat_type_name, dbo.RESOURCES.RESOURCE_TYPE_ID, dbo.RESOURCES.USER_ID,
--                       dbo.USERS.FIRST_NAME + ' ' + dbo.USERS.LAST_NAME AS user_name, dbo.RESOURCES.ACTIVE_FLAG, dbo.SERVICE_LINES.STATUS_ID,
--                       dbo.SERVICE_LINES.ITEM_ID, dbo.ITEMS.NAME AS item_name, dbo.SERVICE_LINES.EXT_PAY_CODE, ITEM_TYPE.CODE AS item_type_code,
--                       ITEM_TYPE.NAME AS item_type_name, dbo.RESOURCE_TYPES.CODE AS resource_type_code,
--                       dbo.RESOURCE_TYPES.NAME AS resource_type_name, dbo.SERVICE_LINES.QTY, dbo.SERVICE_LINES.SERVICE_LINE_DATE, DATEADD(day,
--                       7 - DATEPART(dw, dbo.SERVICE_LINES.SERVICE_LINE_DATE), dbo.SERVICE_LINES.SERVICE_LINE_DATE) AS service_line_week,
--                       dbo.USERS.FIRST_NAME + ' ' + dbo.USERS.LAST_NAME AS employee_name, dbo.SERVICE_LINES.RATE, dbo.CUSTOMERS.CUSTOMER_NAME,
--                       dbo.SERVICE_LINES.EXPENSES_EXPORTED_FLAG, dbo.USERS.EXT_EMPLOYEE_ID, dbo.SERVICE_LINES.RATE * dbo.SERVICE_LINES.QTY AS total,
--                       dbo.SERVICE_LINES.SERVICE_LINE_NO, dbo.SERVICE_LINES.SERVICE_LINE_ID, dbo.JOBS.JOB_NAME, dbo.JOBS.CUSTOMER_ID,
--                       dbo.CUSTOMERS.ORGANIZATION_ID, dbo.ORGANIZATIONS.CODE AS organization_code, ITEM_STATUS_TYPE.CODE AS item_status_type_code,
--                       ITEM_STATUS_TYPE.NAME AS item_status_type_name
-- FROM         dbo.LOOKUPS ITEM_STATUS_TYPE RIGHT OUTER JOIN
--                       dbo.LOOKUPS ITEM_TYPE INNER JOIN
--                       dbo.ITEMS INNER JOIN
--                       dbo.JOBS INNER JOIN
--                       dbo.SERVICES INNER JOIN
--                       dbo.SERVICE_LINES ON dbo.SERVICES.SERVICE_ID = dbo.SERVICE_LINES.SERVICE_ID ON dbo.JOBS.JOB_ID = dbo.SERVICES.JOB_ID ON
--                       dbo.ITEMS.ITEM_ID = dbo.SERVICE_LINES.ITEM_ID ON ITEM_TYPE.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID ON
--                       ITEM_STATUS_TYPE.LOOKUP_ID = dbo.ITEMS.ITEM_STATUS_TYPE_ID RIGHT OUTER JOIN
--                       dbo.USERS INNER JOIN
--                       dbo.RESOURCE_TYPES INNER JOIN
--                       dbo.RESOURCES ON dbo.RESOURCE_TYPES.RESOURCE_TYPE_ID = dbo.RESOURCES.RESOURCE_TYPE_ID INNER JOIN
--                       dbo.LOOKUPS LOOKUPS_4 ON dbo.RESOURCES.RES_CATEGORY_TYPE_ID = LOOKUPS_4.LOOKUP_ID ON
--                       dbo.USERS.USER_ID = dbo.RESOURCES.USER_ID ON dbo.SERVICE_LINES.RESOURCE_ID = dbo.RESOURCES.RESOURCE_ID LEFT OUTER JOIN
--                       dbo.CUSTOMERS ON dbo.JOBS.CUSTOMER_ID = dbo.CUSTOMERS.CUSTOMER_ID LEFT OUTER JOIN
--                       dbo.ORGANIZATIONS ON dbo.CUSTOMERS.ORGANIZATION_ID = dbo.ORGANIZATIONS.ORGANIZATION_ID
-- WHERE     (dbo.SERVICE_LINES.STATUS_ID > 1 OR
--                       dbo.SERVICE_LINES.STATUS_ID IS NULL) AND (dbo.RESOURCES.ACTIVE_FLAG = 'Y') AND (ITEM_TYPE.CODE = 'expense') AND
--                       (LOOKUPS_4.CODE = 'employee')
-- GO
/****** Object:  View [dbo].[USER_RESOURCES_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[USER_RESOURCES_V]
AS
SELECT     dbo.USERS.USER_ID, CAST(dbo.USERS.EXT_EMPLOYEE_ID AS NUMERIC) AS emp_no,
                      dbo.USERS.FIRST_NAME + ' ' + dbo.USERS.LAST_NAME AS employee_name, dbo.RESOURCES.ORGANIZATION_ID, dbo.RESOURCES.RESOURCE_ID,
                      dbo.USERS.EMPLOYMENT_TYPE_ID, dbo.LOOKUPS.CODE, dbo.LOOKUPS.NAME, dbo.RESOURCES.ACTIVE_FLAG
FROM         dbo.USERS INNER JOIN
                      dbo.RESOURCES ON dbo.USERS.USER_ID = dbo.RESOURCES.USER_ID LEFT OUTER JOIN
                      dbo.LOOKUPS ON dbo.USERS.EMPLOYMENT_TYPE_ID = dbo.LOOKUPS.LOOKUP_ID
GO


/****** Object:  View [dbo].[SERVICE_LINE_PAYROLL_V]    Script Date: 05/03/2010 14:18:09 ******/
-- SET ANSI_NULLS ON
-- GO
-- SET QUOTED_IDENTIFIER ON
-- GO
-- CREATE VIEW [dbo].[SERVICE_LINE_PAYROLL_V]
-- AS
-- SELECT     dbo.CUSTOMERS.ORGANIZATION_ID, dbo.RESOURCES.RESOURCE_ID, dbo.SERVICES.JOB_ID, dbo.JOBS.JOB_NO,
--                       dbo.SERVICE_LINES.SERVICE_ID, dbo.SERVICES.SERVICE_NO, dbo.RESOURCES.NAME AS resource_name,
--                       dbo.RESOURCES.RES_CATEGORY_TYPE_ID, LOOKUPS_4.CODE AS res_cat_type_code, LOOKUPS_4.NAME AS res_cat_type_name,
--                       dbo.RESOURCES.RESOURCE_TYPE_ID, dbo.RESOURCES.USER_ID, dbo.RESOURCES.ACTIVE_FLAG, dbo.SERVICE_LINES.STATUS_ID,
--                       dbo.SERVICE_LINES.ITEM_ID, dbo.ITEMS.NAME AS item_name, dbo.SERVICE_LINES.EXT_PAY_CODE, LOOKUPS_3.CODE AS item_type_code,
--                       LOOKUPS_3.NAME AS item_type_name, dbo.RESOURCE_TYPES.CODE AS resource_type_code,
--                       dbo.RESOURCE_TYPES.NAME AS resource_type_name, dbo.SERVICE_LINES.QTY AS hours_qty, dbo.SERVICE_LINES.SERVICE_LINE_DATE,
--                       dbo.USERS.EXT_EMPLOYEE_ID, dbo.USERS.FIRST_NAME + ' ' + dbo.USERS.LAST_NAME AS employee_name,
--                       dbo.SERVICE_LINES.SERVICE_LINE_ID, dbo.SERVICE_LINES.SERVICE_LINE_NO, dbo.SERVICE_LINES.SERVICE_LINE_WEEK,
--                       dbo.PAYROLL_BATCHES.STATUS_ID AS batch_status_id, dbo.PAYROLL_BATCHES.INT_BATCH_ID, dbo.PAYROLL_BATCHES.EXT_BATCH_ID,
--                       dbo.PAYROLL_BATCHES.BEGIN_DATE, dbo.PAYROLL_BATCHES.END_DATE, dbo.PAYROLL_BATCH_STATUSES.CODE AS batch_status_code,
--                       dbo.PAYROLL_BATCH_STATUSES.NAME AS batch_status_name, dbo.JOBS.CUSTOMER_ID, dbo.ITEMS.EXT_ITEM_ID, CONVERT(varchar(12),
--                       dbo.PAYROLL_BATCHES.BEGIN_DATE, 101) AS begin_date_varchar, CONVERT(varchar(12), dbo.PAYROLL_BATCHES.END_DATE, 101)
--                       AS end_date_varchar, CONVERT(varchar(12), dbo.SERVICE_LINES.SERVICE_LINE_DATE, 101) AS service_line_date_varchar
-- FROM         dbo.SERVICES LEFT OUTER JOIN
--                       dbo.CUSTOMERS RIGHT OUTER JOIN
--                       dbo.JOBS ON dbo.CUSTOMERS.CUSTOMER_ID = dbo.JOBS.CUSTOMER_ID ON dbo.SERVICES.JOB_ID = dbo.JOBS.JOB_ID RIGHT OUTER JOIN
--                       dbo.RESOURCES LEFT OUTER JOIN
--                       dbo.USERS ON dbo.RESOURCES.USER_ID = dbo.USERS.USER_ID LEFT OUTER JOIN
--                       dbo.SERVICE_LINES LEFT OUTER JOIN
--                       dbo.PAYROLL_BATCH_LINES LEFT OUTER JOIN
--                       dbo.PAYROLL_BATCH_STATUSES RIGHT OUTER JOIN
--                       dbo.PAYROLL_BATCHES ON dbo.PAYROLL_BATCH_STATUSES.STATUS_ID = dbo.PAYROLL_BATCHES.STATUS_ID ON
--                       dbo.PAYROLL_BATCH_LINES.INT_BATCH_ID = dbo.PAYROLL_BATCHES.INT_BATCH_ID ON
--                       dbo.SERVICE_LINES.SERVICE_LINE_ID = dbo.PAYROLL_BATCH_LINES.SERVICE_LINE_ID ON
--                       dbo.RESOURCES.RESOURCE_ID = dbo.SERVICE_LINES.RESOURCE_ID LEFT OUTER JOIN
--                       dbo.RESOURCE_TYPES ON dbo.RESOURCES.RESOURCE_TYPE_ID = dbo.RESOURCE_TYPES.RESOURCE_TYPE_ID LEFT OUTER JOIN
--                       dbo.LOOKUPS LOOKUPS_4 ON dbo.RESOURCES.RES_CATEGORY_TYPE_ID = LOOKUPS_4.LOOKUP_ID ON
--                       dbo.SERVICES.SERVICE_ID = dbo.SERVICE_LINES.SERVICE_ID LEFT OUTER JOIN
--                       dbo.ITEMS ON dbo.SERVICE_LINES.ITEM_ID = dbo.ITEMS.ITEM_ID LEFT OUTER JOIN
--                       dbo.LOOKUPS LOOKUPS_3 ON dbo.ITEMS.ITEM_TYPE_ID = LOOKUPS_3.LOOKUP_ID
-- WHERE     (dbo.SERVICE_LINES.STATUS_ID > 1 OR
--                       dbo.SERVICE_LINES.STATUS_ID IS NULL) AND (LOOKUPS_4.CODE = 'employee') AND (dbo.RESOURCES.ACTIVE_FLAG = 'Y') AND
--                       (LOOKUPS_3.CODE = 'hours' OR
--                       LOOKUPS_3.CODE IS NULL)
-- GO
/****** Object:  View [dbo].[PEP_RESOURCES_V]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[PEP_RESOURCES_V]
AS
SELECT     RESOURCE_ID, ORGANIZATION_ID, NAME, USER_ID, ATTACHED_FLAG, ACTIVE_FLAG, FOREMAN_FLAG
FROM         dbo.RESOURCES
WHERE     (ORGANIZATION_ID = 2) AND (ACTIVE_FLAG = 'y') AND (USER_ID IS NULL)
GO
/****** Object:  View [dbo].[crystal_routing_ticket]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[crystal_routing_ticket]
AS
SELECT     dbo.SCH_RESOURCES.RES_START_DATE AS scheduled_date, dbo.SERVICES.CUST_COL_6 AS Delivery_Ticket, dbo.SERVICES.PO_NO AS Target_PO, 
                      CAST(dbo.JOBS.JOB_NO AS varchar) + '-' + CAST(dbo.SERVICES.SERVICE_NO AS varchar) AS job_number_and_req, 
                      dbo.SERVICES.CUST_COL_1 AS Customer, dbo.RESOURCES.NAME AS Driver
FROM         dbo.RESOURCES INNER JOIN
                      dbo.SCH_RESOURCES INNER JOIN
                      dbo.JOBS INNER JOIN
                      dbo.SERVICES ON dbo.JOBS.JOB_ID = dbo.SERVICES.JOB_ID INNER JOIN
                      dbo.CUSTOMERS ON dbo.JOBS.CUSTOMER_ID = dbo.CUSTOMERS.CUSTOMER_ID ON ISNULL(dbo.SCH_RESOURCES.SERVICE_ID, 
                      dbo.SCH_RESOURCES.HIDDEN_SERVICE_ID) = dbo.SERVICES.SERVICE_ID ON 
                      dbo.RESOURCES.RESOURCE_ID = dbo.SCH_RESOURCES.RESOURCE_ID
WHERE     (dbo.CUSTOMERS.CUSTOMER_NAME = 'TARGET COMMERICAL INTERIORS')
GO
/****** Object:  View [dbo].[crystal_INTERNAL_REQ_V]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[crystal_INTERNAL_REQ_V]
AS
SELECT     TOP 100 PERCENT dbo.JOBS.JOB_NO, dbo.SERVICES.SERVICE_ID, dbo.SERVICES.SERVICE_NO, CAST(dbo.SERVICES.SERVICE_NO AS varchar) 
                      + ' - ' + ISNULL(dbo.SERVICES.DESCRIPTION, '') AS service_no_desc, dbo.CUSTOMERS.CUSTOMER_NAME, dbo.CUSTOMERS.DEALER_NAME, 
                      dbo.JOBS.JOB_NAME, dbo.SERVICES.WATCH_FLAG, dbo.SERVICES.SERVICE_TYPE_ID, SERVICE_TYPES.CODE AS service_type_code, 
                      SERVICE_TYPES.NAME AS service_type_name, dbo.SERVICES.INTERNAL_REQ_FLAG, dbo.SERVICES.REPORT_TO_LOC_ID, 
                      REPORT_TO_LOC_TYPES.CODE AS report_to_loc_code, REPORT_TO_LOC_TYPES.NAME AS report_to_loc_name, dbo.SERVICES.DESCRIPTION, 
                      dbo.SERVICES.SERV_STATUS_TYPE_ID, SERVICE_STATUS_TYPES.CODE AS serv_status_type_code, 
                      SERVICE_STATUS_TYPES.NAME AS serv_status_type_name, SERVICE_STATUS_TYPES.SEQUENCE_NO AS serv_status_type_seq_no, 
                      dbo.RESOURCES.NAME AS resource_name, dbo.JOBS.FOREMAN_RESOURCE_ID, dbo.JOBS.JOB_TYPE_ID, JOB_TYPES_1.CODE AS job_type_code, 
                      JOB_TYPES_1.NAME AS job_type_name, dbo.JOBS.JOB_STATUS_TYPE_ID, JOB_STATUS_TYPE.CODE AS job_status_type_code, 
                      JOB_STATUS_TYPE.NAME AS job_status_type_name, dbo.JOBS.CUSTOMER_ID, dbo.JOBS.EXT_PRICE_LEVEL_ID, 
                      dbo.CUSTOMERS.EXT_DEALER_ID, dbo.CUSTOMERS.ORGANIZATION_ID, dbo.JOBS.DATE_CREATED AS job_date_created, 
                      dbo.SERVICES.JOB_LOCATION_ID, dbo.JOB_LOCATIONS.JOB_LOCATION_NAME, dbo.SERVICES.CUSTOMER_REF_NO, dbo.SERVICES.PO_NO, 
                      dbo.SERVICES.BILLING_TYPE_ID, dbo.SERVICES.IDM_CONTACT_ID, dbo.SERVICES.CUSTOMER_CONTACT_ID, 
                      dbo.CONTACTS.CONTACT_NAME AS idm_contact_name, dbo.SERVICES.SALES_CONTACT_ID, dbo.SERVICES.SUPPORT_CONTACT_ID, 
                      dbo.SERVICES.DESIGNER_CONTACT_ID, dbo.SERVICES.PROJECT_MGR_CONTACT_ID, dbo.SERVICES.PRODUCT_SETUP_DESC, 
                      dbo.SERVICES.DELIVERY_TYPE_ID, dbo.SERVICES.WAREHOUSE_LOC, dbo.SERVICES.PRI_FURN_TYPE_ID, 
                      dbo.SERVICES.PRI_FURN_LINE_TYPE_ID, dbo.SERVICES.SEC_FURN_TYPE_ID, dbo.SERVICES.SEC_FURN_LINE_TYPE_ID, 
                      dbo.SERVICES.NUM_STATIONS, dbo.SERVICES.PRODUCT_QTY, ISNULL(dbo.SERVICES.WOOD_PRODUCT_TYPE_ID, 142) AS wood_product_type_id, 
                      dbo.SERVICES.PUNCHLIST_TYPE_ID, PUNCH_LIST_TYPES.CODE AS punchlist_type_code, PUNCH_LIST_TYPES.NAME AS punchlist_type_name, 
                      dbo.SERVICES.BLUEPRINT_LOCATION, dbo.SERVICES.SCHEDULE_TYPE_ID, SCHEDULE_TYPES.CODE AS schedule_type_code, 
                      SCHEDULE_TYPES.NAME AS schedule_type_name, dbo.SERVICES.ORDERED_BY, dbo.SERVICES.ORDERED_DATE, 
                      dbo.SERVICES.EST_START_DATE, dbo.SERVICES.EST_START_TIME, dbo.SERVICES.EST_END_DATE, dbo.SERVICES.TRUCK_SHIP_DATE, 
                      dbo.SERVICES.TRUCK_ARRIVAL_DATE, dbo.SERVICES.HEAD_VAL_FLAG, dbo.SERVICES.LOC_VAL_FLAG, dbo.SERVICES.PROD_VAL_FLAG, 
                      dbo.SERVICES.SCH_VAL_FLAG, dbo.SERVICES.TASK_VAL_FLAG, dbo.SERVICES.RES_VAL_FLAG, dbo.SERVICES.CUST_VAL_FLAG, 
                      dbo.SERVICES.BILL_VAL_FLAG, dbo.SERVICES.DATE_CREATED, dbo.SERVICES.CREATED_BY, 
                      CREATE_USER.FIRST_NAME + ' ' + CREATE_USER.LAST_NAME AS created_by_name, dbo.SERVICES.DATE_MODIFIED, dbo.SERVICES.MODIFIED_BY, 
                      MOD_USER.FIRST_NAME + ' ' + MOD_USER.LAST_NAME AS modified_by_name, dbo.SERVICES.CUST_COL_1, dbo.SERVICES.CUST_COL_2, 
                      dbo.SERVICES.CUST_COL_3, dbo.SERVICES.CUST_COL_4, dbo.SERVICES.CUST_COL_5, dbo.SERVICES.CUST_COL_6, dbo.SERVICES.CUST_COL_7, 
                      dbo.SERVICES.CUST_COL_8, dbo.SERVICES.CUST_COL_9, dbo.SERVICES.CUST_COL_10, dbo.SERVICES.WEEKEND_FLAG, 
                      dbo.SERVICES.QUOTE_TOTAL, dbo.SERVICES.MISC
FROM         dbo.LOOKUPS PUNCH_LIST_TYPES RIGHT OUTER JOIN
                      dbo.USERS MOD_USER RIGHT OUTER JOIN
                      dbo.SERVICES LEFT OUTER JOIN
                      dbo.CONTACTS ON dbo.SERVICES.IDM_CONTACT_ID = dbo.CONTACTS.CONTACT_ID LEFT OUTER JOIN
                      dbo.LOOKUPS REPORT_TO_LOC_TYPES ON dbo.SERVICES.REPORT_TO_LOC_ID = REPORT_TO_LOC_TYPES.LOOKUP_ID LEFT OUTER JOIN
                      dbo.LOOKUPS SCHEDULE_TYPES ON dbo.SERVICES.SCHEDULE_TYPE_ID = SCHEDULE_TYPES.LOOKUP_ID LEFT OUTER JOIN
                      dbo.LOOKUPS SERVICE_TYPES ON dbo.SERVICES.SERVICE_TYPE_ID = SERVICE_TYPES.LOOKUP_ID ON 
                      MOD_USER.USER_ID = dbo.SERVICES.MODIFIED_BY LEFT OUTER JOIN
                      dbo.USERS CREATE_USER ON dbo.SERVICES.CREATED_BY = CREATE_USER.USER_ID ON 
                      PUNCH_LIST_TYPES.LOOKUP_ID = dbo.SERVICES.PUNCHLIST_TYPE_ID LEFT OUTER JOIN
                      dbo.LOOKUPS JOB_STATUS_TYPE RIGHT OUTER JOIN
                      dbo.CUSTOMERS INNER JOIN
                      dbo.JOBS ON dbo.CUSTOMERS.CUSTOMER_ID = dbo.JOBS.CUSTOMER_ID ON 
                      JOB_STATUS_TYPE.LOOKUP_ID = dbo.JOBS.JOB_STATUS_TYPE_ID LEFT OUTER JOIN
                      dbo.RESOURCES ON dbo.JOBS.FOREMAN_RESOURCE_ID = dbo.RESOURCES.RESOURCE_ID ON 
                      dbo.SERVICES.JOB_ID = dbo.JOBS.JOB_ID LEFT OUTER JOIN
                      dbo.JOB_LOCATIONS ON dbo.SERVICES.JOB_LOCATION_ID = dbo.JOB_LOCATIONS.JOB_LOCATION_ID LEFT OUTER JOIN
                      dbo.LOOKUPS JOB_TYPES_1 ON dbo.JOBS.JOB_TYPE_ID = JOB_TYPES_1.LOOKUP_ID LEFT OUTER JOIN
                      dbo.LOOKUPS SERVICE_STATUS_TYPES ON dbo.SERVICES.SERV_STATUS_TYPE_ID = SERVICE_STATUS_TYPES.LOOKUP_ID
WHERE     (dbo.SERVICES.INTERNAL_REQ_FLAG = 'Y')
ORDER BY dbo.JOBS.JOB_NO
GO
/****** Object:  View [dbo].[EMPLOYEES_V]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[EMPLOYEES_V]
AS
SELECT     dbo.RESOURCES.ORGANIZATION_ID, dbo.RESOURCES.RESOURCE_ID, dbo.RESOURCES.NAME, dbo.RESOURCES.RES_CATEGORY_TYPE_ID, 
                      RES_CATEGORY_TYPE.CODE AS res_cat_type_code, RES_CATEGORY_TYPE.NAME AS res_cat_type_name, dbo.RESOURCES.RESOURCE_TYPE_ID, 
                      RESOURCE_TYPE.CODE AS resource_type_code, RESOURCE_TYPE.NAME AS resource_type_name, dbo.RESOURCES.USER_ID, 
                      dbo.USERS.FIRST_NAME, dbo.USERS.LAST_NAME, dbo.USERS.EXT_EMPLOYEE_ID, dbo.USERS.EMPLOYMENT_TYPE_ID, 
                      EMPLOYEMENT_TYPE.CODE AS employement_type_code, EMPLOYEMENT_TYPE.NAME AS employement_type_name, dbo.USERS.PIN, 
                      dbo.USERS.ACTIVE_FLAG
FROM         dbo.RESOURCES INNER JOIN
                      dbo.USERS ON dbo.RESOURCES.USER_ID = dbo.USERS.USER_ID LEFT OUTER JOIN
                      dbo.LOOKUPS EMPLOYEMENT_TYPE ON dbo.USERS.EMPLOYMENT_TYPE_ID = EMPLOYEMENT_TYPE.LOOKUP_ID LEFT OUTER JOIN
                      dbo.LOOKUPS RESOURCE_TYPE ON dbo.RESOURCES.RESOURCE_TYPE_ID = RESOURCE_TYPE.LOOKUP_ID LEFT OUTER JOIN
                      dbo.LOOKUPS RES_CATEGORY_TYPE ON dbo.RESOURCES.RES_CATEGORY_TYPE_ID = RES_CATEGORY_TYPE.LOOKUP_ID
GO
/****** Object:  View [dbo].[RESOURCE_ESTIMATES_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[RESOURCE_ESTIMATES_V]
AS
SELECT     dbo.JOBS_V.ORGANIZATION_ID, dbo.RESOURCE_ESTIMATES.RESOURCE_EST_ID, dbo.RESOURCE_ESTIMATES.JOB_ID, dbo.JOBS_V.JOB_NO, 
                      dbo.JOBS_V.JOB_NAME, dbo.JOBS_V.JOB_TYPE_ID, dbo.JOBS_V.job_type_code AS Expr1, dbo.JOBS_V.job_type_name AS Expr2, 
                      dbo.SERVICES.SERVICE_ID, dbo.SERVICES.SERVICE_NO, dbo.RESOURCE_ESTIMATES.JOB_ITEM_RATE_ID, dbo.JOB_ITEM_RATES.ITEM_ID, 
                      dbo.ITEMS.NAME AS item_name, dbo.ITEMS.DESCRIPTION AS item_desc, dbo.ITEMS.ITEM_TYPE_ID, ITEM_TYPE.CODE AS item_type_code, 
                      ITEM_TYPE.NAME AS item_type_name, dbo.ITEMS.ITEM_STATUS_TYPE_ID, dbo.JOB_ITEM_RATES.RATE, 
                      dbo.RESOURCE_ESTIMATES.RESOURCE_TYPE_ID, dbo.RESOURCE_TYPES.CODE AS resource_type_code, 
                      dbo.RESOURCE_TYPES.NAME AS resource_type_name, dbo.RESOURCE_ESTIMATES.UNIT_QTY, dbo.RESOURCE_ESTIMATES.TIME_UOM_TYPE_ID, 
                      TIME_UOM_TYPE.CODE AS time_uom_type_code, TIME_UOM_TYPE.NAME AS time_uom_type_name, TIME_UOM_TYPE.ATTRIBUTE2 AS multiplier, 
                      dbo.RESOURCE_ESTIMATES.TIME_QTY, dbo.RESOURCE_ESTIMATES.TOTAL_HOURS, 
                      dbo.RESOURCE_ESTIMATES.UNIT_QTY * dbo.JOB_ITEM_RATES.RATE * dbo.RESOURCE_ESTIMATES.TIME_QTY * TIME_UOM_TYPE.ATTRIBUTE2 AS total_dollars,
                       dbo.RESOURCE_ESTIMATES.START_DATE, dbo.RESOURCE_ESTIMATES.DATE_CREATED, dbo.RESOURCE_ESTIMATES.CREATED_BY, 
                      USERS_1.FIRST_NAME + ' ' + USERS_1.LAST_NAME AS created_by_name, dbo.RESOURCE_ESTIMATES.DATE_MODIFIED, 
                      dbo.RESOURCE_ESTIMATES.MODIFIED_BY, USERS_2.FIRST_NAME + ' ' + USERS_2.LAST_NAME AS modified_by_name
FROM         dbo.LOOKUPS ITEM_TYPE RIGHT OUTER JOIN
                      dbo.ITEMS RIGHT OUTER JOIN
                      dbo.SERVICES RIGHT OUTER JOIN
                      dbo.JOB_ITEM_RATES RIGHT OUTER JOIN
                      dbo.RESOURCE_TYPES RIGHT OUTER JOIN
                      dbo.JOBS_V RIGHT OUTER JOIN
                      dbo.RESOURCE_ESTIMATES ON dbo.JOBS_V.JOB_ID = dbo.RESOURCE_ESTIMATES.JOB_ID ON 
                      dbo.RESOURCE_TYPES.RESOURCE_TYPE_ID = dbo.RESOURCE_ESTIMATES.RESOURCE_TYPE_ID ON 
                      dbo.JOB_ITEM_RATES.JOB_ITEM_RATE_ID = dbo.RESOURCE_ESTIMATES.JOB_ITEM_RATE_ID ON 
                      dbo.SERVICES.SERVICE_ID = dbo.RESOURCE_ESTIMATES.SERVICE_ID ON dbo.ITEMS.ITEM_ID = dbo.JOB_ITEM_RATES.ITEM_ID ON 
                      ITEM_TYPE.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID LEFT OUTER JOIN
                      dbo.USERS USERS_2 ON dbo.RESOURCE_ESTIMATES.MODIFIED_BY = USERS_2.USER_ID LEFT OUTER JOIN
                      dbo.USERS USERS_1 ON dbo.RESOURCE_ESTIMATES.CREATED_BY = USERS_1.USER_ID LEFT OUTER JOIN
                      dbo.LOOKUPS TIME_UOM_TYPE ON dbo.RESOURCE_ESTIMATES.TIME_UOM_TYPE_ID = TIME_UOM_TYPE.LOOKUP_ID
WHERE     (TIME_UOM_TYPE.ATTRIBUTE1 = 'time_hours')
GO
/****** Object:  View [dbo].[project_requests_v2]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[project_requests_v2]
AS
SELECT p_v.project_id, 
       p_v.project_no, 
       p_v.project_type_id, 
       p_v.project_type_code, 
       p_v.project_type_name, 
       p_v.project_status_type_id, 
       p_v.project_status_type_code, 
       p_v.project_status_type_name, 
       p_v.customer_id, 
       p_v.end_user_id,
       p_v.parent_customer_id, 
       p_v.organization_id, 
       p_v.ext_dealer_id, 
       p_v.dealer_name, 
       p_v.ext_customer_id, 
       p_v.customer_name, 
       p_v.end_user_name,
       p_v.job_name, 
       p_v.date_created, 
       p_v.created_by, 
       p_v.created_by_name,
       r.request_id, 
       r.request_no, 
       r.version_no, 
       r.request_type_id, 
       request_type.code AS request_type_code, 
       request_type.name AS request_type_name, 
       r.request_status_type_id, 
       request_status_type.code AS request_status_type_code, 
       request_status_type.name AS request_status_type_name, 
       CONVERT(VARCHAR(12), r.est_start_date, 101) AS est_start_date_varchar, 
       r.quote_request_id, 
       r.is_quoted, 
       r.csc_wo_field_flag,
       r.a_d_designer_contact_id,
       r.gen_contractor_contact_id, 
       r.electrician_contact_id,
       r.data_phone_contact_id,
       r.carpet_layer_contact_id, 
       r.bldg_mgr_contact_id,
       r.security_contact_id,
       r.mover_contact_id, 
       r.other_contact_id,
       r.furniture1_contact_id,
       r.furniture2_contact_id
  FROM dbo.projects_v2 p_v INNER JOIN
       dbo.requests r ON p_v.project_id = r.project_id INNER JOIN
       dbo.lookups request_type ON r.request_type_id = request_type.lookup_id INNER JOIN
       dbo.lookups request_status_type ON r.request_status_type_id = request_status_type.lookup_id
GO
/****** Object:  View [dbo].[jobs_effective_customer_v]    Script Date: 05/03/2010 14:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[jobs_effective_customer_v]
AS
SELECT j.job_id,
 CASE WHEN customer_type.code = 'dealer' THEN j.end_user_id ELSE j.customer_id END effective_customer_id
FROM dbo.jobs j INNER JOIN dbo.customers c ON j.customer_id = c.customer_id
                INNER JOIN dbo.lookups customer_type ON c.customer_type_id = customer_type.lookup_id
GO
/****** Object:  View [dbo].[SURVEY_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[SURVEY_V]
AS
SELECT     dbo.REQUESTS.PROJECT_ID, dbo.REQUESTS.REQUEST_ID, dbo.LOOKUPS.CODE AS request_type_code, dbo.SURVEY_TEST_V.survey_last_count, 
                      dbo.SURVEY_TEST_V.survey_frequency, dbo.SURVEY_TEST_V.sum_complete, dbo.SURVEY_TEST_V.SURVEY_LOCATION, 
                      dbo.REQUESTS.IS_SURVEYED
FROM         dbo.SURVEY_TEST_V INNER JOIN
                      dbo.REQUESTS ON dbo.SURVEY_TEST_V.PROJECT_ID = dbo.REQUESTS.PROJECT_ID LEFT OUTER JOIN
                      dbo.LOOKUPS ON dbo.REQUESTS.REQUEST_TYPE_ID = dbo.LOOKUPS.LOOKUP_ID
WHERE     (dbo.LOOKUPS.CODE = 'workorder')
GO
/****** Object:  View [dbo].[REQUEST_NO_PUNCHLISTS_V]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[REQUEST_NO_PUNCHLISTS_V]
AS
SELECT     dbo.PROJECTS_V.ORGANIZATION_ID, dbo.PROJECTS_V.PROJECT_ID, dbo.REQUESTS.REQUEST_ID, dbo.PROJECTS_V.PROJECT_NO, 
                      dbo.REQUESTS.REQUEST_NO, CONVERT(varchar, dbo.PROJECTS_V.PROJECT_NO) + '-' + CONVERT(varchar, dbo.REQUESTS.REQUEST_NO) 
                      AS project_request_no, dbo.PROJECTS_V.project_status_type_code, dbo.PROJECTS_V.CUSTOMER_ID, dbo.PROJECTS_V.PARENT_CUSTOMER_ID, 
                      dbo.PROJECTS_V.EXT_DEALER_ID, dbo.PROJECTS_V.DEALER_NAME, dbo.PROJECTS_V.EXT_CUSTOMER_ID, dbo.PROJECTS_V.CUSTOMER_NAME, 
                      dbo.PROJECTS_V.JOB_NAME, request_types.CODE AS request_type_code, request_status_types.CODE AS request_status_type_code, 
                      request_status_types.NAME AS request_status_type_name, dbo.REQUESTS.DATE_CREATED
FROM         dbo.PROJECTS_V INNER JOIN
                      dbo.REQUESTS INNER JOIN
                      dbo.VERSIONS_MAX_NO_V ON dbo.REQUESTS.PROJECT_ID = dbo.VERSIONS_MAX_NO_V.PROJECT_ID AND 
                      dbo.REQUESTS.REQUEST_NO = dbo.VERSIONS_MAX_NO_V.REQUEST_NO AND 
                      dbo.REQUESTS.VERSION_NO = dbo.VERSIONS_MAX_NO_V.max_version_no ON 
                      dbo.PROJECTS_V.PROJECT_ID = dbo.REQUESTS.PROJECT_ID LEFT OUTER JOIN
                      dbo.LOOKUPS request_status_types ON dbo.REQUESTS.REQUEST_STATUS_TYPE_ID = request_status_types.LOOKUP_ID LEFT OUTER JOIN
                      dbo.LOOKUPS request_types ON dbo.REQUESTS.REQUEST_TYPE_ID = request_types.LOOKUP_ID
WHERE     (NOT EXISTS
                          (SELECT     request_id
                            FROM          punchlists p
                            WHERE      p.request_id = dbo.REQUESTS.REQUEST_ID))
GO
/****** Object:  View [dbo].[SITE_CONDITIONS_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[SITE_CONDITIONS_V]
AS
SELECT     dbo.REQUESTS.REQUEST_ID, dbo.REQUESTS.PROJECT_ID, dbo.REQUESTS.REQUEST_NO, dbo.LOOKUPS.NAME AS LOAD_DOCK_AVAIL, 
                      dbo.JOB_LOCATIONS.DOCK_AVAILABLE_TIME, LOOKUPS_1.NAME AS DOCK_RESERV_REQ, LOOKUPS_2.NAME AS SEMI_ACCESS, 
                      dbo.JOB_LOCATIONS.DOCK_HEIGHT, LOOKUPS_3.NAME AS ELEVATOR_AVAIL, LOOKUPS_4.NAME AS ELEVATOR_RESERV_REQ, 
                      LOOKUPS_5.NAME AS SECURITY, LOOKUPS_6.NAME AS MULTI_LEVEL, LOOKUPS_7.NAME AS STAIR_CARRY, 
                      dbo.JOB_LOCATIONS.STAIR_CARRY_FLIGHTS, dbo.JOB_LOCATIONS.STAIR_CARRY_STAIRS, dbo.JOB_LOCATIONS.SMALLEST_DOOR_ELEV_WIDTH, 
                      LOOKUPS_8.NAME AS FLOOR_PROTECT, LOOKUPS_9.NAME AS WALL_PROTECT, LOOKUPS_10.NAME AS DOORWAY_PROTECT
FROM         dbo.REQUESTS INNER JOIN
                      dbo.JOB_LOCATIONS ON dbo.REQUESTS.JOB_LOCATION_ID = dbo.JOB_LOCATIONS.JOB_LOCATION_ID LEFT OUTER JOIN
                      dbo.LOOKUPS LOOKUPS_10 ON dbo.JOB_LOCATIONS.DOORWAY_PROT_TYPE_ID = LOOKUPS_10.LOOKUP_ID LEFT OUTER JOIN
                      dbo.LOOKUPS LOOKUPS_9 ON dbo.JOB_LOCATIONS.WALL_PROTECTION_TYPE_ID = LOOKUPS_9.LOOKUP_ID LEFT OUTER JOIN
                      dbo.LOOKUPS LOOKUPS_8 ON dbo.JOB_LOCATIONS.FLOOR_PROTECTION_TYPE_ID = LOOKUPS_8.LOOKUP_ID LEFT OUTER JOIN
                      dbo.LOOKUPS LOOKUPS_7 ON dbo.JOB_LOCATIONS.STAIR_CARRY_TYPE_ID = LOOKUPS_7.LOOKUP_ID LEFT OUTER JOIN
                      dbo.LOOKUPS LOOKUPS_6 ON dbo.JOB_LOCATIONS.MULTI_LEVEL_TYPE_ID = LOOKUPS_6.LOOKUP_ID LEFT OUTER JOIN
                      dbo.LOOKUPS LOOKUPS_5 ON dbo.JOB_LOCATIONS.SECURITY_TYPE_ID = LOOKUPS_5.LOOKUP_ID LEFT OUTER JOIN
                      dbo.LOOKUPS LOOKUPS_4 ON dbo.JOB_LOCATIONS.ELEVATOR_RESERV_REQ_TYPE_ID = LOOKUPS_4.LOOKUP_ID LEFT OUTER JOIN
                      dbo.LOOKUPS LOOKUPS_3 ON dbo.JOB_LOCATIONS.ELEVATOR_AVAIL_TYPE_ID = LOOKUPS_3.LOOKUP_ID LEFT OUTER JOIN
                      dbo.LOOKUPS LOOKUPS_2 ON dbo.JOB_LOCATIONS.SEMI_ACCESS_TYPE_ID = LOOKUPS_2.LOOKUP_ID LEFT OUTER JOIN
                      dbo.LOOKUPS LOOKUPS_1 ON dbo.JOB_LOCATIONS.DOCK_RESERV_REQ_TYPE_ID = LOOKUPS_1.LOOKUP_ID LEFT OUTER JOIN
                      dbo.LOOKUPS ON dbo.JOB_LOCATIONS.LOADING_DOCK_TYPE_ID = dbo.LOOKUPS.LOOKUP_ID
GO
/****** Object:  View [dbo].[SITE_CONDITIONS_MORE_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[SITE_CONDITIONS_MORE_V]
AS
SELECT     dbo.REQUESTS.REQUEST_ID, dbo.REQUESTS.PROJECT_ID, dbo.REQUESTS.REQUEST_NO, dbo.LOOKUPS.NAME AS STAGING_AREA, 
                      LOOKUPS_1.NAME AS DUMPSTER, dbo.REQUESTS.ELEVATOR_AVAIL_TIME, LOOKUPS_2.NAME AS WALKBOARD, LOOKUPS_3.NAME AS OCC_SITE, 
                      LOOKUPS_4.NAME AS NEW_SITE, dbo.REQUESTS.OTHER_CONDITIONS
FROM         dbo.REQUESTS LEFT OUTER JOIN
                      dbo.LOOKUPS LOOKUPS_4 ON dbo.REQUESTS.NEW_SITE_TYPE_ID = LOOKUPS_4.LOOKUP_ID LEFT OUTER JOIN
                      dbo.LOOKUPS LOOKUPS_3 ON dbo.REQUESTS.OCCUPIED_SITE_TYPE_ID = LOOKUPS_3.LOOKUP_ID LEFT OUTER JOIN
                      dbo.LOOKUPS LOOKUPS_2 ON dbo.REQUESTS.WALKBOARD_TYPE_ID = LOOKUPS_2.LOOKUP_ID LEFT OUTER JOIN
                      dbo.LOOKUPS LOOKUPS_1 ON dbo.REQUESTS.DUMPSTER_TYPE_ID = LOOKUPS_1.LOOKUP_ID LEFT OUTER JOIN
                      dbo.LOOKUPS ON dbo.REQUESTS.STAGING_AREA_TYPE_ID = dbo.LOOKUPS.LOOKUP_ID
GO


/****** View [dbo].[GP_ALABM_PAY_CODE_V]  ******/
-- SET ANSI_NULLS ON
-- GO
-- SET QUOTED_IDENTIFIER ON
-- GO
--
-- CREATE VIEW
--     [dbo].[GP_ALABM_PAY_CODE_V] ( PAYRCORD, DSCRIPTN, INACTIVE, PAYTYPE, BSPAYRCD, PAYRTAMT, PAYUNIT, PAYUNPER, PAYPEROD, PAYPRPRD, MXPYPPER, TipType, PAYADVNC, RPTASWGS, W2BXNMBR, W2BXLABL, TAXABLE, SBJTFDTX, SBJTSSEC, SBJTMCAR, SBJTSTTX, SBJTLTAX, SBJTFUTA, SBJTSUTA, FFEDTXRT, FLSTTXRT, ACRUVACN, ACRUSTIM, NOTEINDX, DATAENTDFLT, SHFTCODE, PAYFACTR, BSDONRTE, DEX_ROW_ID ) AS
-- SELECT
--     *
-- FROM
--     ALABM.dbo.UPR40600
-- WHERE
--     (
--         PAYRCORD IN ('1', '2', '3', '4', '8', '16')
--     )
-- AND
--     (
--         INACTIVE = 0
--     )
-- GO

/****** Object:  View [dbo].[GP_ALABM_ITEM_PAYCODES_V]    Script Date: 05/03/2010 14:18:06 ******/
-- SET ANSI_NULLS ON
-- GO
-- SET QUOTED_IDENTIFIER ON
-- GO
-- CREATE VIEW [dbo].[GP_ALABM_ITEM_PAYCODES_V]
-- AS
-- SELECT     ITEM_ID, item_name, pay_code, defaulted
-- FROM         (SELECT     GP_PAYCODES.PAYRCORD AS pay_code, dbo.ITEMS.NAME AS item_name, dbo.ITEMS.ITEM_ID, 'f' AS defaulted
--                        FROM          dbo.LOOKUPS ITEM_TYPES INNER JOIN
--                                               dbo.ITEMS ON ITEM_TYPES.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID INNER JOIN
--                                               dbo.GP_ALABM_PAY_CODE_V GP_PAYCODES ON RIGHT(dbo.ITEMS.NAME, CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) - 1)
--                                               = RIGHT(GP_PAYCODES.DSCRIPTN, CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) - 1)
--                        WHERE      (CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) > 0) AND (CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) > 0) AND
--                                               (ITEM_TYPES.CODE = 'hours') AND organization_id = 6
--                        UNION
--                        SELECT     '1' AS pay_code, dbo.ITEMS.NAME AS item_name, dbo.ITEMS.ITEM_ID, 't' AS defaulted
--                        FROM         dbo.ITEMS INNER JOIN
--                                              dbo.LOOKUPS item_types ON dbo.ITEMS.ITEM_TYPE_ID = item_types.LOOKUP_ID
--                        WHERE     (item_types.CODE = 'hours') AND (dbo.ITEMS.ITEM_ID NOT IN
--                                                  (SELECT     dbo.ITEMS.ITEM_ID
--                                                    FROM          dbo.LOOKUPS ITEM_TYPES INNER JOIN
--                                                                           dbo.ITEMS ON ITEM_TYPES.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID INNER JOIN
--                                                                           dbo.GP_ALABM_PAY_CODE_V GP_PAYCODES ON RIGHT(dbo.ITEMS.NAME, CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) - 1)
--                                                                           = RIGHT(GP_PAYCODES.DSCRIPTN, CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) - 1)
--                                                    WHERE      (CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) > 0) AND (CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) > 0) AND
--                                                                           (ITEM_TYPES.CODE = 'hours') AND dbo.items.organization_id = 6))) DERIVEDTBL
-- GO
/****** Object:  View [dbo].[GP_ICS_ITEM_PAYCODES_V]    Script Date: 05/03/2010 14:18:07 ******/
-- SET ANSI_NULLS ON
-- GO
-- SET QUOTED_IDENTIFIER ON
-- GO
-- CREATE VIEW [dbo].[GP_ICS_ITEM_PAYCODES_V]
-- AS
-- SELECT     ITEM_ID, item_name, pay_code, defaulted
-- FROM         (SELECT     GP_PAYCODES.PAYRCORD AS pay_code, dbo.ITEMS.NAME AS item_name, dbo.ITEMS.ITEM_ID, 'f' AS defaulted
--                        FROM          dbo.LOOKUPS ITEM_TYPES INNER JOIN
--                                               dbo.ITEMS ON ITEM_TYPES.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID INNER JOIN
--                                               dbo.GP_ICS_PAY_CODE_V GP_PAYCODES ON RIGHT(dbo.ITEMS.NAME, CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) - 1)
--                                               = RIGHT(GP_PAYCODES.DSCRIPTN, CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) - 1)
--                        WHERE      (CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) > 0) AND (CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) > 0) AND
--                                               (ITEM_TYPES.CODE = 'hours')
--                        UNION
--                        SELECT     '1' AS pay_code, dbo.ITEMS.NAME AS item_name, dbo.ITEMS.ITEM_ID, 't' AS defaulted
--                        FROM         dbo.ITEMS INNER JOIN
--                                              dbo.LOOKUPS item_types ON dbo.ITEMS.ITEM_TYPE_ID = item_types.LOOKUP_ID
--                        WHERE     (item_types.CODE = 'hours') AND (dbo.ITEMS.ITEM_ID NOT IN
--                                                  (SELECT     dbo.ITEMS.ITEM_ID
--                                                    FROM          dbo.LOOKUPS ITEM_TYPES INNER JOIN
--                                                                           dbo.ITEMS ON ITEM_TYPES.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID INNER JOIN
--                                                                           dbo.GP_ICS_PAY_CODE_V GP_PAYCODES ON RIGHT(dbo.ITEMS.NAME, CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) - 1)
--                                                                           = RIGHT(GP_PAYCODES.DSCRIPTN, CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) - 1)
--                                                    WHERE      (CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) > 0) AND (CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) > 0) AND
--                                                                           (ITEM_TYPES.CODE = 'hours')))) DERIVEDTBL
-- GO


/****** View [dbo].[GP_MAD_PAY_CODE_V]  ******/
-- SET ANSI_NULLS ON
-- GO
-- SET QUOTED_IDENTIFIER ON
-- GO
--
-- CREATE VIEW
--     [dbo].[GP_MAD_PAY_CODE_V] ( PAYRCORD, DSCRIPTN, INACTIVE, PAYTYPE, BSPAYRCD, PAYRTAMT, PAYUNIT, PAYUNPER, PAYPEROD, PAYPRPRD, MXPYPPER, TipType, PAYADVNC, RPTASWGS, W2BXNMBR, W2BXLABL, TAXABLE, SBJTFDTX, SBJTSSEC, SBJTMCAR, SBJTSTTX, SBJTLTAX, SBJTFUTA, SBJTSUTA, FFEDTXRT, FLSTTXRT, ACRUVACN, ACRUSTIM, NOTEINDX, DATAENTDFLT, SHFTCODE, PAYFACTR, BSDONRTE, DEX_ROW_ID ) AS
-- SELECT
--     *
-- FROM
--     AMMAD.dbo.UPR40600
-- WHERE
--     (
--         PAYRCORD IN ('1', '2', '3', '4', '8', '16')
--     )
-- AND
--     (
--         INACTIVE = 0
--     )
--
-- GO

/****** Object:  View [dbo].[GP_MAD_ITEM_PAYCODES_V]    Script Date: 05/03/2010 14:18:07 ******/
-- SET ANSI_NULLS ON
-- GO
-- SET QUOTED_IDENTIFIER ON
-- GO
-- CREATE VIEW [dbo].[GP_MAD_ITEM_PAYCODES_V]
-- AS
-- SELECT     ITEM_ID, item_name, pay_code, defaulted
-- FROM         (SELECT     GP_PAYCODES.PAYRCORD AS pay_code, dbo.ITEMS.NAME AS item_name, dbo.ITEMS.ITEM_ID, 'f' AS defaulted
--                        FROM          dbo.LOOKUPS ITEM_TYPES INNER JOIN
--                                               dbo.ITEMS ON ITEM_TYPES.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID INNER JOIN
--                                               dbo.GP_MAD_PAY_CODE_V GP_PAYCODES ON RIGHT(dbo.ITEMS.NAME, CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) - 1)
--                                               = RIGHT(GP_PAYCODES.DSCRIPTN, CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) - 1)
--                        WHERE      (CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) > 0) AND (CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) > 0) AND
--                                               (ITEM_TYPES.CODE = 'hours') AND organization_id = 4
--                        UNION
--                        SELECT     '1' AS pay_code, dbo.ITEMS.NAME AS item_name, dbo.ITEMS.ITEM_ID, 't' AS defaulted
--                        FROM         dbo.ITEMS INNER JOIN
--                                              dbo.LOOKUPS item_types ON dbo.ITEMS.ITEM_TYPE_ID = item_types.LOOKUP_ID
--                        WHERE     (item_types.CODE = 'hours') AND (dbo.ITEMS.ITEM_ID NOT IN
--                                                  (SELECT     dbo.ITEMS.ITEM_ID
--                                                    FROM          dbo.LOOKUPS ITEM_TYPES INNER JOIN
--                                                                           dbo.ITEMS ON ITEM_TYPES.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID INNER JOIN
--                                                                           dbo.GP_MAD_PAY_CODE_V GP_PAYCODES ON RIGHT(dbo.ITEMS.NAME, CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) - 1)
--                                                                           = RIGHT(GP_PAYCODES.DSCRIPTN, CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) - 1)
--                                                    WHERE      (CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) > 0) AND (CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) > 0) AND
--                                                                           (ITEM_TYPES.CODE = 'hours') AND dbo.items.organization_id = 4))) DERIVEDTBL
-- GO
/****** Object:  View [dbo].[crystal_workorder_detail_pkf_V]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[crystal_workorder_detail_pkf_V]
AS
SELECT     dbo.PROJECTS_V.ORGANIZATION_ID, dbo.REQUESTS.PROJECT_ID, dbo.REQUESTS.REQUEST_ID, dbo.PROJECTS_V.EXT_DEALER_ID, 
                      dbo.PROJECTS_V.CUSTOMER_ID, dbo.PROJECTS_V.PARENT_CUSTOMER_ID, dbo.PROJECTS_V.PROJECT_NO, dbo.REQUESTS.REQUEST_NO, 
                      CONVERT(varchar, dbo.PROJECTS_V.PROJECT_NO) + '-' + CONVERT(varchar, dbo.REQUESTS.REQUEST_NO) AS workorder_no, 
                      dbo.PROJECTS_V.DEALER_NAME, dbo.PROJECTS_V.CUSTOMER_NAME, dbo.JOB_LOCATIONS.JOB_LOCATION_NAME, 
                      request_types.CODE AS request_type_code, request_status_types.CODE AS request_status_type_code, 
                      request_types.SEQUENCE_NO AS request_seq_no, dbo.PROJECTS_V.project_status_type_code, dbo.REQUESTS.DESCRIPTION, 
                      dbo.REQUESTS.CUSTOMER_PO_NO, dbo.REQUESTS.DEALER_PO_NO
FROM         dbo.LOOKUPS request_status_types RIGHT OUTER JOIN
                      dbo.REQUESTS ON request_status_types.LOOKUP_ID = dbo.REQUESTS.REQUEST_STATUS_TYPE_ID LEFT OUTER JOIN
                      dbo.JOB_LOCATIONS ON dbo.REQUESTS.JOB_LOCATION_ID = dbo.JOB_LOCATIONS.JOB_LOCATION_ID LEFT OUTER JOIN
                      dbo.PROJECTS_V ON dbo.REQUESTS.PROJECT_ID = dbo.PROJECTS_V.PROJECT_ID CROSS JOIN
                      dbo.LOOKUPS request_types
GO
/****** Object:  View [dbo].[bad_reqs]    Script Date: 05/03/2010 14:18:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[bad_reqs]
AS
SELECT     TOP 100 PERCENT dbo.CUSTOMERS.DEALER_NAME, dbo.CUSTOMERS.CUSTOMER_NAME, dbo.JOBS.JOB_NO, dbo.JOBS.JOB_NAME, 
                      dbo.SERVICES.SERVICE_NO, dbo.CUSTOM_COLS.CUSTOM_COL_ID, dbo.SERVICES.DATE_CREATED, dbo.LOOKUPS.CODE, 
                      LOOKUPS_1.CODE AS Expr1
FROM         dbo.JOBS INNER JOIN
                      dbo.SERVICES ON dbo.JOBS.JOB_ID = dbo.SERVICES.JOB_ID INNER JOIN
                      dbo.CUSTOMERS ON dbo.JOBS.CUSTOMER_ID = dbo.CUSTOMERS.CUSTOMER_ID INNER JOIN
                      dbo.LOOKUPS ON dbo.SERVICES.SERVICE_TYPE_ID = dbo.LOOKUPS.LOOKUP_ID INNER JOIN
                      dbo.LOOKUPS LOOKUPS_1 ON dbo.JOBS.JOB_TYPE_ID = LOOKUPS_1.LOOKUP_ID LEFT OUTER JOIN
                      dbo.CUSTOM_COLS ON dbo.SERVICES.SERVICE_ID = dbo.CUSTOM_COLS.SERVICE_ID
WHERE     (dbo.CUSTOM_COLS.CUSTOM_COL_ID IS NULL) AND (dbo.LOOKUPS.CODE = 'short_view') AND (dbo.SERVICES.DATE_CREATED BETWEEN 
                      CONVERT(DATETIME, '2003-10-01 00:00:00', 102) AND GETDATE()) AND (LOOKUPS_1.CODE = 'service_account')
ORDER BY dbo.SERVICES.DATE_CREATED, dbo.CUSTOMERS.DEALER_NAME, dbo.CUSTOMERS.CUSTOMER_NAME, dbo.JOBS.JOB_NO, dbo.JOBS.JOB_NAME, 
                      dbo.SERVICES.SERVICE_NO
GO
/****** Object:  View [dbo].[request_mail_v2]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[request_mail_v2]
AS
SELECT p.project_id, 
       r.request_id, 
       p.project_no, 
       r.request_no, 
       l.code request_type_code, 
       r.a_m_contact_id, 
       r.a_m_sales_contact_id, 
       r.customer_contact_id,
       r.customer_contact2_id,
       r.customer_contact3_id,
       r.customer_contact4_id,
       ISNULL(am.contact_name, 'N/A') AS am_name,
       ISNULL(am_sales.contact_name, 'N/A') AS am_sales_name,
       ISNULL(cc.contact_name, 'N/A') AS customer_contact_name,
       ISNULL(cc2.contact_name, 'N/A') AS customer_contact2_name,
       ISNULL(cc3.contact_name, 'N/A') AS customer_contact3_name,
       ISNULL(cc4.contact_name, 'N/A') AS customer_contact4_name
  FROM requests r INNER JOIN 
       projects p ON r.project_id = p.project_id INNER JOIN
       lookups l ON r.request_type_id = l.lookup_id LEFT OUTER JOIN
       dbo.contacts am ON r.a_m_contact_id = am.contact_id LEFT OUTER JOIN
       dbo.contacts am_sales ON r.a_m_sales_contact_id = am_sales.contact_id LEFT OUTER JOIN
       dbo.contacts cc ON r.customer_contact_id = cc.contact_id LEFT OUTER JOIN
       dbo.contacts cc2 ON r.customer_contact2_id = cc2.contact_id LEFT OUTER JOIN
       dbo.contacts cc3 ON r.customer_contact3_id = cc3.contact_id LEFT OUTER JOIN
       dbo.contacts cc4 ON r.customer_contact4_id = cc4.contact_id
GO

/****** View [dbo].[GP_PHX_PAY_CODE_V]  ******/
-- SET ANSI_NULLS ON
-- GO
-- SET QUOTED_IDENTIFIER ON
-- GO
--
-- CREATE VIEW
--     [dbo].[GP_PHX_PAY_CODE_V] ( PAYRCORD, DSCRIPTN, INACTIVE, PAYTYPE, BSPAYRCD, PAYRTAMT, PAYUNIT, PAYUNPER, PAYPEROD, PAYPRPRD, MXPYPPER, TipType, PAYADVNC, RPTASWGS, W2BXNMBR, W2BXLABL, TAXABLE, SBJTFDTX, SBJTSSEC, SBJTMCAR, SBJTSTTX, SBJTLTAX, SBJTFUTA, SBJTSUTA, FFEDTXRT, FLSTTXRT, ACRUVACN, ACRUSTIM, NOTEINDX, DATAENTDFLT, SHFTCODE, PAYFACTR, BSDONRTE, DEX_ROW_ID ) AS
-- SELECT
--     *
-- FROM
--     PHX.dbo.UPR40600
-- WHERE
--     (
--         PAYRCORD IN ('1', '2', '3', '4', '8', '16')
--     )
-- AND
--     (
--         INACTIVE = 0
--     )
--
-- GO


/****** Object:  View [dbo].[GP_PHX_ITEM_PAYCODES_V]    Script Date: 05/03/2010 14:18:07 ******/
-- SET ANSI_NULLS ON
-- GO
-- SET QUOTED_IDENTIFIER ON
-- GO
-- CREATE VIEW [dbo].[GP_PHX_ITEM_PAYCODES_V]
-- AS
-- SELECT     ITEM_ID, item_name, pay_code, defaulted
-- FROM         (SELECT     GP_PAYCODES.PAYRCORD AS pay_code, dbo.ITEMS.NAME AS item_name, dbo.ITEMS.ITEM_ID, 'f' AS defaulted
--                        FROM          dbo.LOOKUPS AS ITEM_TYPES INNER JOIN
--                                               dbo.ITEMS ON ITEM_TYPES.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID INNER JOIN
--                                               dbo.GP_PHX_PAY_CODE_V AS GP_PAYCODES ON RIGHT(dbo.ITEMS.NAME, CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) - 1)
--                                               = RIGHT(GP_PAYCODES.DSCRIPTN, CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) - 1)
--                        WHERE      (CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) > 0) AND (CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) > 0) AND
--                                               (ITEM_TYPES.CODE = 'hours') AND (dbo.ITEMS.ORGANIZATION_ID = 20)
--                        UNION
--                        SELECT     '1' AS pay_code, ITEMS_2.NAME AS item_name, ITEMS_2.ITEM_ID, 't' AS defaulted
--                        FROM         dbo.ITEMS AS ITEMS_2 INNER JOIN
--                                              dbo.LOOKUPS AS item_types ON ITEMS_2.ITEM_TYPE_ID = item_types.LOOKUP_ID
--                        WHERE     (item_types.CODE = 'hours') AND (ITEMS_2.ITEM_ID NOT IN
--                                                  (SELECT     ITEMS_1.ITEM_ID
--                                                    FROM          dbo.LOOKUPS AS ITEM_TYPES INNER JOIN
--                                                                           dbo.ITEMS AS ITEMS_1 ON ITEM_TYPES.LOOKUP_ID = ITEMS_1.ITEM_TYPE_ID INNER JOIN
--                                                                           dbo.GP_PHX_PAY_CODE_V AS GP_PAYCODES ON RIGHT(ITEMS_1.NAME, CHARINDEX('-', REVERSE(ITEMS_1.NAME)) - 1)
--                                                                           = RIGHT(GP_PAYCODES.DSCRIPTN, CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) - 1)
--                                                    WHERE      (CHARINDEX('-', REVERSE(ITEMS_1.NAME)) > 0) AND (CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) > 0) AND
--                                                                           (ITEM_TYPES.CODE = 'hours') AND (ITEMS_1.ORGANIZATION_ID = 20)))) AS DERIVEDTBL
-- GO
-- EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
-- Begin DesignProperties =
--    Begin PaneConfigurations =
--       Begin PaneConfiguration = 0
--          NumPanes = 4
--          Configuration = "(H (1[40] 4[20] 2[20] 3) )"
--       End
--       Begin PaneConfiguration = 1
--          NumPanes = 3
--          Configuration = "(H (1 [50] 4 [25] 3))"
--       End
--       Begin PaneConfiguration = 2
--          NumPanes = 3
--          Configuration = "(H (1 [50] 2 [25] 3))"
--       End
--       Begin PaneConfiguration = 3
--          NumPanes = 3
--          Configuration = "(H (4 [30] 2 [40] 3))"
--       End
--       Begin PaneConfiguration = 4
--          NumPanes = 2
--          Configuration = "(H (1 [56] 3))"
--       End
--       Begin PaneConfiguration = 5
--          NumPanes = 2
--          Configuration = "(H (2 [66] 3))"
--       End
--       Begin PaneConfiguration = 6
--          NumPanes = 2
--          Configuration = "(H (4 [50] 3))"
--       End
--       Begin PaneConfiguration = 7
--          NumPanes = 1
--          Configuration = "(V (3))"
--       End
--       Begin PaneConfiguration = 8
--          NumPanes = 3
--          Configuration = "(H (1[56] 4[18] 2) )"
--       End
--       Begin PaneConfiguration = 9
--          NumPanes = 2
--          Configuration = "(H (1 [75] 4))"
--       End
--       Begin PaneConfiguration = 10
--          NumPanes = 2
--          Configuration = "(H (1[66] 2) )"
--       End
--       Begin PaneConfiguration = 11
--          NumPanes = 2
--          Configuration = "(H (4 [60] 2))"
--       End
--       Begin PaneConfiguration = 12
--          NumPanes = 1
--          Configuration = "(H (1) )"
--       End
--       Begin PaneConfiguration = 13
--          NumPanes = 1
--          Configuration = "(V (4))"
--       End
--       Begin PaneConfiguration = 14
--          NumPanes = 1
--          Configuration = "(V (2))"
--       End
--       ActivePaneConfig = 0
--    End
--    Begin DiagramPane =
--       Begin Origin =
--          Top = 0
--          Left = 0
--       End
--       Begin Tables =
--          Begin Table = "DERIVEDTBL"
--             Begin Extent =
--                Top = 6
--                Left = 38
--                Bottom = 114
--                Right = 189
--             End
--             DisplayFlags = 280
--             TopColumn = 0
--          End
--       End
--    End
--    Begin SQLPane =
--    End
--    Begin DataPane =
--       Begin ParameterDefaults = ""
--       End
--       Begin ColumnWidths = 9
--          Width = 284
--          Width = 1500
--          Width = 1500
--          Width = 1500
--          Width = 1500
--          Width = 1500
--          Width = 1500
--          Width = 1500
--          Width = 1500
--       End
--    End
--    Begin CriteriaPane =
--       Begin ColumnWidths = 11
--          Column = 1440
--          Alias = 900
--          Table = 1170
--          Output = 720
--          Append = 1400
--          NewValue = 1170
--          SortType = 1350
--          SortOrder = 1410
--          GroupBy = 1350
--          Filter = 1350
--          Or = 1350
--          Or = 1350
--          Or = 1350
--       End
--    End
-- End
-- ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'GP_PHX_ITEM_PAYCODES_V'
-- GO
-- EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'GP_PHX_ITEM_PAYCODES_V'
-- GO

/****** Object:  View [dbo].[Contacts_qry_lookupbyorg]    Script Date: 05/03/2010 14:18:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Contacts_qry_lookupbyorg]
AS
SELECT     TOP 100 PERCENT dbo.CUSTOMERS.DEALER_NAME, dbo.CUSTOMERS.CUSTOMER_NAME, dbo.CONTACTS.CONTACT_ID, 
                      dbo.CONTACTS.CONTACT_NAME, dbo.CONTACTS.EMAIL, dbo.LOOKUPS.NAME AS STATUS, dbo.CONTACTS.ORGANIZATION_ID, 
                      dbo.CONTACTS.EXT_DEALER_ID
FROM         dbo.CONTACTS INNER JOIN
                      dbo.LOOKUPS ON dbo.CONTACTS.CONT_STATUS_TYPE_ID = dbo.LOOKUPS.LOOKUP_ID INNER JOIN
                      dbo.CUSTOMERS ON dbo.CONTACTS.CUSTOMER_ID = dbo.CUSTOMERS.CUSTOMER_ID
WHERE     (dbo.CONTACTS.ORGANIZATION_ID = 4) AND (dbo.CONTACTS.EXT_DEALER_ID = '10002') OR
                      (dbo.CONTACTS.EXT_DEALER_ID = '10004') OR
                      (dbo.CONTACTS.EXT_DEALER_ID = '10006') OR
                      (dbo.CONTACTS.EXT_DEALER_ID = '10008')
ORDER BY dbo.CONTACTS.CONTACT_NAME
GO
/****** Object:  View [dbo].[JOBS_NO_OWNER_V]    Script Date: 05/03/2010 14:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[JOBS_NO_OWNER_V]
AS
SELECT     TOP 100 PERCENT dbo.JOBS.JOB_ID, dbo.JOBS.PROJECT_ID, dbo.JOBS.JOB_NO, dbo.JOBS.JOB_NAME, dbo.JOBS.JOB_TYPE_ID, 
                      dbo.JOBS.JOB_STATUS_TYPE_ID, dbo.JOBS.CUSTOMER_ID, dbo.CUSTOMERS.CUSTOMER_NAME, dbo.JOBS.BILLING_USER_ID, 
                      dbo.LOOKUPS.NAME, dbo.CUSTOMERS.DEALER_NAME
FROM         dbo.JOBS INNER JOIN
                      dbo.CUSTOMERS ON dbo.JOBS.CUSTOMER_ID = dbo.CUSTOMERS.CUSTOMER_ID INNER JOIN
                      dbo.LOOKUPS ON dbo.JOBS.JOB_STATUS_TYPE_ID = dbo.LOOKUPS.LOOKUP_ID
WHERE     (dbo.JOBS.BILLING_USER_ID IS NULL)
ORDER BY dbo.JOBS.JOB_NO
GO
/****** Object:  View [dbo].[TC_SERVICES_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[TC_SERVICES_V]
AS
SELECT     dbo.SERVICES.JOB_ID, dbo.SERVICES.SERVICE_ID, dbo.SERVICES.SERVICE_NO, CAST(dbo.SERVICES.SERVICE_NO AS varchar) 
                      + ' - ' + ISNULL(dbo.SERVICES.DESCRIPTION, '') AS service_no_desc, dbo.SERVICES.SERV_STATUS_TYPE_ID, 
                      SERVICE_STATUS_TYPES.CODE AS serv_status_type_code, SERVICE_STATUS_TYPES.NAME AS serv_status_type_name, 
                      SERVICE_STATUS_TYPES.SEQUENCE_NO AS serv_status_type_seq_no, ISNULL(dbo.SERVICES.WOOD_PRODUCT_TYPE_ID, 142) 
                      AS wood_product_type_id
FROM         dbo.LOOKUPS SERVICE_STATUS_TYPES RIGHT OUTER JOIN
                      dbo.SERVICES ON SERVICE_STATUS_TYPES.LOOKUP_ID = dbo.SERVICES.SERV_STATUS_TYPE_ID
GO
/****** Object:  View [dbo].[RESOURCE_TYPES_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[RESOURCE_TYPES_V]
AS
SELECT     dbo.RESOURCE_TYPES.RESOURCE_TYPE_ID, dbo.RESOURCE_TYPES.NAME AS resource_type_name, 
                      dbo.RESOURCE_TYPES.CODE AS resource_type_code, dbo.RESOURCE_TYPES.SEQUENCE_NO, dbo.RESOURCE_TYPES.DEF_TIME_UOM_TYPE_ID, 
                      LOOKUPS_2.CODE AS def_time_uom_type_code, LOOKUPS_2.NAME AS def_time_uom_type_name, dbo.RESOURCE_TYPES.DEF_RES_CAT_TYPE_ID, 
                      LOOKUPS_1.CODE AS def_res_cat_type_code, LOOKUPS_1.NAME AS def_res_cat_type_name, dbo.RESOURCE_TYPES.ESTIMATE_HOURS_FLAG, 
                      dbo.RESOURCE_TYPES.UNIQUE_FLAG, dbo.RESOURCE_TYPES.DATE_CREATED, dbo.RESOURCE_TYPES.CREATED_BY, 
                      USERS_1.FIRST_NAME + ' ' + USERS_1.LAST_NAME AS created_by_name, dbo.RESOURCE_TYPES.DATE_MODIFIED, 
                      dbo.RESOURCE_TYPES.MODIFIED_BY, USERS_2.FIRST_NAME + ' ' + USERS_2.LAST_NAME AS modified_by_name
FROM         dbo.USERS USERS_1 RIGHT OUTER JOIN
                      dbo.LOOKUPS LOOKUPS_1 RIGHT OUTER JOIN
                      dbo.RESOURCE_TYPES ON LOOKUPS_1.LOOKUP_ID = dbo.RESOURCE_TYPES.DEF_RES_CAT_TYPE_ID LEFT OUTER JOIN
                      dbo.USERS USERS_2 ON dbo.RESOURCE_TYPES.MODIFIED_BY = USERS_2.USER_ID ON 
                      USERS_1.USER_ID = dbo.RESOURCE_TYPES.CREATED_BY LEFT OUTER JOIN
                      dbo.LOOKUPS LOOKUPS_2 ON dbo.RESOURCE_TYPES.DEF_TIME_UOM_TYPE_ID = LOOKUPS_2.LOOKUP_ID
GO

/****** View [dbo].[GP_PHX_PAY_CODE_V]  ******/
-- SET ANSI_NULLS ON
-- GO
-- SET QUOTED_IDENTIFIER ON
-- GO
--
-- CREATE VIEW
--     [dbo].[GP_PHX_PAY_CODE_V] ( PAYRCORD, DSCRIPTN, INACTIVE, PAYTYPE, BSPAYRCD, PAYRTAMT, PAYUNIT, PAYUNPER, PAYPEROD, PAYPRPRD, MXPYPPER, TipType, PAYADVNC, RPTASWGS, W2BXNMBR, W2BXLABL, TAXABLE, SBJTFDTX, SBJTSSEC, SBJTMCAR, SBJTSTTX, SBJTLTAX, SBJTFUTA, SBJTSUTA, FFEDTXRT, FLSTTXRT, ACRUVACN, ACRUSTIM, NOTEINDX, DATAENTDFLT, SHFTCODE, PAYFACTR, BSDONRTE, DEX_ROW_ID ) AS
-- SELECT
--     *
-- FROM
--     PHX.dbo.UPR40600
-- WHERE
--     (
--         PAYRCORD IN ('1', '2', '3', '4', '8', '16')
--     )
-- AND
--     (
--         INACTIVE = 0
--     )
--
-- GO

/****** Object:  View [dbo].[GP_IT_ITEM_PAYCODES_V]    Script Date: 05/03/2010 14:18:07 ******/
-- SET ANSI_NULLS ON
-- GO
-- SET QUOTED_IDENTIFIER ON
-- GO
-- CREATE VIEW [dbo].[GP_IT_ITEM_PAYCODES_V]
-- AS
-- SELECT     ITEM_ID, item_name, pay_code, defaulted
-- FROM         (SELECT     GP_PAYCODES.PAYRCORD AS pay_code, dbo.ITEMS.NAME AS item_name, dbo.ITEMS.ITEM_ID, 'f' AS defaulted
--                        FROM          dbo.LOOKUPS ITEM_TYPES INNER JOIN
--                                               dbo.ITEMS ON ITEM_TYPES.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID INNER JOIN
--                                               dbo.GP_IT_PAY_CODE_V GP_PAYCODES ON RIGHT(dbo.ITEMS.NAME, CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) - 1)
--                                               = RIGHT(GP_PAYCODES.DSCRIPTN, CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) - 1)
--                        WHERE      (CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) > 0) AND (CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) > 0) AND
--                                               (ITEM_TYPES.CODE = 'hours')
--                        UNION
--                        SELECT     '1' AS pay_code, dbo.ITEMS.NAME AS item_name, dbo.ITEMS.ITEM_ID, 't' AS defaulted
--                        FROM         dbo.ITEMS INNER JOIN
--                                              dbo.LOOKUPS item_types ON dbo.ITEMS.ITEM_TYPE_ID = item_types.LOOKUP_ID
--                        WHERE     (item_types.CODE = 'hours') AND (dbo.ITEMS.ITEM_ID NOT IN
--                                                  (SELECT     dbo.ITEMS.ITEM_ID
--                                                    FROM          dbo.LOOKUPS ITEM_TYPES INNER JOIN
--                                                                           dbo.ITEMS ON ITEM_TYPES.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID INNER JOIN
--                                                                           dbo.GP_IT_PAY_CODE_V GP_PAYCODES ON RIGHT(dbo.ITEMS.NAME, CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) - 1)
--                                                                           = RIGHT(GP_PAYCODES.DSCRIPTN, CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) - 1)
--                                                    WHERE      (CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) > 0) AND (CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) > 0) AND
--                                                                           (ITEM_TYPES.CODE = 'hours')))) DERIVEDTBL
-- GO
/****** Object:  View [dbo].[requests_query_for_Tim_VVV]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[requests_query_for_Tim_VVV]
AS
SELECT     dbo.REQUESTS.REQUEST_ID, dbo.REQUESTS.REQUEST_NO, dbo.REQUESTS.REQUEST_TYPE_ID, dbo.LOOKUPS.NAME, 
                      dbo.REQUESTS.D_PROJ_MGR_CONTACT_ID, dbo.REQUESTS.EST_START_DATE, dbo.REQUESTS.EST_START_TIME, 
                      dbo.REQUESTS.EST_END_DATE, dbo.REQUESTS.CUSTOMER_PO_NO, dbo.REQUESTS.A_M_SALES_CONTACT_ID, 
                      dbo.REQUESTS.WHO_CAN_APPROVE_NAME, dbo.REQUESTS.WHO_CAN_APPROVE_PHONE, dbo.REQUESTS.DOCK_AVAILABLE_TIME, 
                      dbo.REQUESTS.DOCK_HEIGHT, dbo.REQUESTS.STAIR_CARRY_FLIGHTS, dbo.REQUESTS.STAIR_CARRY_STAIRS, 
                      dbo.REQUESTS.SMALLEST_DOOR_ELEV_WIDTH, dbo.REQUESTS.LEVEL_TYPE_ID, dbo.CUSTOMERS.ORGANIZATION_ID
FROM         dbo.LOOKUPS INNER JOIN
                      dbo.REQUESTS ON dbo.LOOKUPS.LOOKUP_ID = dbo.REQUESTS.REQUEST_TYPE_ID INNER JOIN
                      dbo.PROJECTS ON dbo.REQUESTS.PROJECT_ID = dbo.PROJECTS.PROJECT_ID INNER JOIN
                      dbo.CUSTOMERS ON dbo.PROJECTS.CUSTOMER_ID = dbo.CUSTOMERS.CUSTOMER_ID
GO

/****** View [dbo].[GP_NTLSV_PAY_CODE_V]  ******/
-- SET ANSI_NULLS ON
-- GO
-- SET QUOTED_IDENTIFIER ON
-- GO
--
-- CREATE VIEW
--     [dbo].[GP_NTLSV_PAY_CODE_V] ( PAYRCORD, DSCRIPTN, INACTIVE, PAYTYPE, BSPAYRCD, PAYRTAMT, PAYUNIT, PAYUNPER, PAYPEROD, PAYPRPRD, MXPYPPER, TipType, PAYADVNC, RPTASWGS, W2BXNMBR, W2BXLABL, TAXABLE, SBJTFDTX, SBJTSSEC, SBJTMCAR, SBJTSTTX, SBJTLTAX, SBJTFUTA, SBJTSUTA, FFEDTXRT, FLSTTXRT, ACRUVACN, ACRUSTIM, NOTEINDX, DATAENTDFLT, SHFTCODE, PAYFACTR, BSDONRTE, DEX_ROW_ID ) AS
-- SELECT
--     *
-- FROM
--     NTLSV.dbo.UPR40600
-- WHERE
--     (
--         PAYRCORD IN ('1', '2', '3', '4', '8', '16')
--     )
-- AND
--     (
--         INACTIVE = 0
--     )
--
-- GO

/****** Object:  View [dbo].[GP_NTLSV_ITEM_PAYCODES_V]    Script Date: 05/03/2010 14:18:07 ******/
-- SET ANSI_NULLS ON
-- GO
-- SET QUOTED_IDENTIFIER ON
-- GO
-- CREATE VIEW [dbo].[GP_NTLSV_ITEM_PAYCODES_V]
-- AS
-- SELECT     ITEM_ID, item_name, pay_code, defaulted
-- FROM         (SELECT     GP_PAYCODES.PAYRCORD AS pay_code, dbo.ITEMS.NAME AS item_name, dbo.ITEMS.ITEM_ID, 'f' AS defaulted
--                        FROM          dbo.LOOKUPS ITEM_TYPES INNER JOIN
--                                               dbo.ITEMS ON ITEM_TYPES.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID INNER JOIN
--                                               dbo.GP_NTLSV_PAY_CODE_V GP_PAYCODES ON RIGHT(dbo.ITEMS.NAME, CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) - 1)
--                                               = RIGHT(GP_PAYCODES.DSCRIPTN, CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) - 1)
--                        WHERE      (CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) > 0) AND (CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) > 0) AND
--                                               (ITEM_TYPES.CODE = 'hours') AND organization_id = 6
--                        UNION
--                        SELECT     '1' AS pay_code, dbo.ITEMS.NAME AS item_name, dbo.ITEMS.ITEM_ID, 't' AS defaulted
--                        FROM         dbo.ITEMS INNER JOIN
--                                              dbo.LOOKUPS item_types ON dbo.ITEMS.ITEM_TYPE_ID = item_types.LOOKUP_ID
--                        WHERE     (item_types.CODE = 'hours') AND (dbo.ITEMS.ITEM_ID NOT IN
--                                                  (SELECT     dbo.ITEMS.ITEM_ID
--                                                    FROM          dbo.LOOKUPS ITEM_TYPES INNER JOIN
--                                                                           dbo.ITEMS ON ITEM_TYPES.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID INNER JOIN
--                                                                           dbo.GP_NTLSV_PAY_CODE_V GP_PAYCODES ON RIGHT(dbo.ITEMS.NAME, CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) - 1)
--                                                                           = RIGHT(GP_PAYCODES.DSCRIPTN, CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) - 1)
--                                                    WHERE      (CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) > 0) AND (CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) > 0) AND
--                                                                           (ITEM_TYPES.CODE = 'hours') AND dbo.items.organization_id = 6))) DERIVEDTBL
-- GO
/****** Object:  View [dbo].[JOB_LOCATIONS_V]    Script Date: 05/03/2010 14:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[JOB_LOCATIONS_V]
AS
SELECT     dbo.CUSTOMERS.ORGANIZATION_ID, dbo.JOB_LOCATIONS.JOB_LOCATION_ID, dbo.JOB_LOCATIONS.CUSTOMER_ID, 
                      dbo.JOB_LOCATIONS.JOB_LOCATION_NAME, dbo.JOB_LOCATIONS.LOCATION_TYPE_ID, LOOKUPS_1.CODE AS location_type_code, 
                      LOOKUPS_1.NAME AS location_type_name, dbo.JOB_LOCATIONS.EXT_ADDRESS_ID, dbo.JOB_LOCATIONS.STREET1, dbo.JOB_LOCATIONS.STREET2, 
                      dbo.JOB_LOCATIONS.STREET3, dbo.JOB_LOCATIONS.CITY, dbo.JOB_LOCATIONS.STATE, dbo.JOB_LOCATIONS.ZIP, dbo.JOB_LOCATIONS.COUNTRY, 
                      dbo.JOB_LOCATIONS.DIRECTIONS, dbo.JOB_LOCATIONS.JOB_LOC_CONTACT_ID, dbo.JOB_LOCATIONS.BLDG_MGMT_CONTACT_ID, 
                      dbo.JOB_LOCATIONS.MULTI_LEVEL_TYPE_ID, LOOKUPS_3.CODE AS multi_level_type_code, LOOKUPS_3.NAME AS multi_level_type_name, 
                      dbo.JOB_LOCATIONS.FLOOR_PROTECTION_TYPE_ID AS floor_prot_type_id, LOOKUPS_4.CODE AS floor_prot_type_code, 
                      LOOKUPS_4.NAME AS floor_prot_type_name, dbo.JOB_LOCATIONS.LOADING_DOCK_TYPE_ID, LOOKUPS_5.CODE AS loading_dock_type_code, 
                      LOOKUPS_5.NAME AS loading_dock_type_name, dbo.JOB_LOCATIONS.SECURITY_TYPE_ID, LOOKUPS_6.CODE AS security_type_code, 
                      LOOKUPS_6.NAME AS security_type_name, dbo.JOB_LOCATIONS.DATE_CREATED, dbo.JOB_LOCATIONS.CREATED_BY, 
                      USERS_1.FIRST_NAME + ' ' + USERS_1.LAST_NAME AS created_by_name, dbo.JOB_LOCATIONS.DATE_MODIFIED, 
                      dbo.JOB_LOCATIONS.MODIFIED_BY, USERS_2.FIRST_NAME + ' ' + USERS_2.LAST_NAME AS modified_by_name, 
                      dbo.JOB_LOCATIONS.DOCK_AVAILABLE_TIME, dbo.JOB_LOCATIONS.DOCK_RESERV_REQ_TYPE_ID, dbo.JOB_LOCATIONS.SEMI_ACCESS_TYPE_ID, 
                      dbo.JOB_LOCATIONS.DOCK_HEIGHT, dbo.JOB_LOCATIONS.ELEVATOR_AVAIL_TYPE_ID, dbo.JOB_LOCATIONS.ELEVATOR_RESERV_REQ_TYPE_ID, 
                      dbo.JOB_LOCATIONS.FLOOR_PROTECTION_TYPE_ID, dbo.JOB_LOCATIONS.WALL_PROTECTION_TYPE_ID, 
                      dbo.JOB_LOCATIONS.DOORWAY_PROT_TYPE_ID, dbo.JOB_LOCATIONS.STAIR_CARRY_TYPE_ID, dbo.JOB_LOCATIONS.STAIR_CARRY_FLIGHTS, 
                      dbo.JOB_LOCATIONS.STAIR_CARRY_STAIRS, dbo.JOB_LOCATIONS.SMALLEST_DOOR_ELEV_WIDTH
FROM         dbo.USERS USERS_1 RIGHT OUTER JOIN
                      dbo.USERS USERS_2 RIGHT OUTER JOIN
                      dbo.CUSTOMERS RIGHT OUTER JOIN
                      dbo.JOB_LOCATIONS ON dbo.CUSTOMERS.CUSTOMER_ID = dbo.JOB_LOCATIONS.CUSTOMER_ID LEFT OUTER JOIN
                      dbo.LOOKUPS LOOKUPS_2 ON dbo.JOB_LOCATIONS.MULTI_LEVEL_TYPE_ID = LOOKUPS_2.LOOKUP_ID ON 
                      USERS_2.USER_ID = dbo.JOB_LOCATIONS.MODIFIED_BY ON USERS_1.USER_ID = dbo.JOB_LOCATIONS.CREATED_BY LEFT OUTER JOIN
                      dbo.LOOKUPS LOOKUPS_6 ON dbo.JOB_LOCATIONS.SECURITY_TYPE_ID = LOOKUPS_6.LOOKUP_ID LEFT OUTER JOIN
                      dbo.LOOKUPS LOOKUPS_5 ON dbo.JOB_LOCATIONS.LOADING_DOCK_TYPE_ID = LOOKUPS_5.LOOKUP_ID LEFT OUTER JOIN
                      dbo.LOOKUPS LOOKUPS_4 ON dbo.JOB_LOCATIONS.FLOOR_PROTECTION_TYPE_ID = LOOKUPS_4.LOOKUP_ID LEFT OUTER JOIN
                      dbo.LOOKUPS LOOKUPS_3 ON dbo.JOB_LOCATIONS.MULTI_LEVEL_TYPE_ID = LOOKUPS_3.LOOKUP_ID LEFT OUTER JOIN
                      dbo.LOOKUPS LOOKUPS_1 ON dbo.JOB_LOCATIONS.LOCATION_TYPE_ID = LOOKUPS_1.LOOKUP_ID
GO
/****** Object:  View [dbo].[PKT_SERVICES_V]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[PKT_SERVICES_V]

AS

SELECT     dbo.SERVICES.JOB_ID, dbo.JOBS.JOB_NO, dbo.JOBS.JOB_NAME, dbo.CUSTOMERS.CUSTOMER_NAME, dbo.SERVICES.SERVICE_ID, 

                      dbo.SERVICES.SERVICE_NO, dbo.SERVICES.DESCRIPTION AS service_description, dbo.REQUESTS.OTHER_CONDITIONS, 

                      dbo.JOB_LOCATIONS.JOB_LOCATION_NAME, CONVERT(varchar, dbo.JOBS.JOB_NO) + ' - ' + CONVERT(varchar, dbo.SERVICES.SERVICE_NO) 

                      AS job_service_no, dbo.REQUESTS.DEALER_PO_NO, priority.NAME AS priority, [LEVEL].NAME AS [level], dbo.REQUESTS.REQUEST_ID, 

                      dbo.JOB_LOCATIONS.STREET1, dbo.JOB_LOCATIONS.STREET2, dbo.JOB_LOCATIONS.STREET3, dbo.JOB_LOCATIONS.CITY, 

                      dbo.JOB_LOCATIONS.STATE, dbo.JOB_LOCATIONS.ZIP, dbo.SERVICES.SCH_START_DATE, dbo.REQUESTS.DOCK_AVAILABLE_TIME AS dock_time, 

                      dbo.REQUESTS.ELEVATOR_AVAIL_TIME AS elev_time, wall_mount.NAME AS wall_mount, PLAN_L.NAME AS plan_name, deliv.NAME AS delivery_by, 

                      dbo.REQUESTS.QUOTE_REQUEST_ID, change_order.NAME AS change_order

FROM         dbo.LOOKUPS PLAN_L RIGHT OUTER JOIN

                      dbo.LOOKUPS deliv INNER JOIN

                      dbo.REQUESTS ON deliv.LOOKUP_ID = dbo.REQUESTS.DELIVERY_TYPE_ID LEFT OUTER JOIN

                      dbo.LOOKUPS wall_mount ON dbo.REQUESTS.WALL_MOUNT_TYPE_ID = wall_mount.LOOKUP_ID ON 

                      PLAN_L.LOOKUP_ID = dbo.REQUESTS.FURN_PLAN_TYPE_ID LEFT OUTER JOIN

                      dbo.LOOKUPS [LEVEL] ON dbo.REQUESTS.LEVEL_TYPE_ID = [LEVEL].LOOKUP_ID LEFT OUTER JOIN

                      dbo.LOOKUPS priority ON dbo.REQUESTS.PRIORITY_TYPE_ID = priority.LOOKUP_ID RIGHT OUTER JOIN

                      dbo.SERVICES INNER JOIN

                      dbo.JOBS ON dbo.SERVICES.JOB_ID = dbo.JOBS.JOB_ID INNER JOIN

                      dbo.CUSTOMERS ON dbo.JOBS.CUSTOMER_ID = dbo.CUSTOMERS.CUSTOMER_ID ON 

                      dbo.REQUESTS.REQUEST_ID = dbo.SERVICES.REQUEST_ID LEFT OUTER JOIN

                      dbo.JOB_LOCATIONS ON ISNULL(dbo.REQUESTS.JOB_LOCATION_ID, dbo.SERVICES.JOB_LOCATION_ID) 

                      = dbo.JOB_LOCATIONS.JOB_LOCATION_ID INNER JOIN

                      dbo.LOOKUPS service_status ON dbo.SERVICES.SERV_STATUS_TYPE_ID = service_status.LOOKUP_ID LEFT OUTER JOIN

                      dbo.LOOKUPS change_order ON dbo.REQUESTS.APPROVAL_REQ_TYPE_ID = change_order.LOOKUP_ID

WHERE     (service_status.CODE <> 'closed')
GO
/****** Object:  View [dbo].[PUNCHLIST_REQUESTS_V]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[PUNCHLIST_REQUESTS_V]
AS
SELECT     dbo.PUNCHLISTS.PUNCHLIST_ID, dbo.PROJECTS.PROJECT_ID, dbo.REQUESTS.REQUEST_ID, CONVERT(varchar, dbo.PROJECTS.PROJECT_NO) 
                      + '-' + CONVERT(varchar, dbo.REQUESTS.REQUEST_NO) AS project_request_no, dbo.PROJECTS.PROJECT_NO, dbo.REQUESTS.REQUEST_NO, 
                      dbo.REQUESTS.DESCRIPTION, dbo.REQUESTS.D_SALES_REP_CONTACT_ID, sales_rep.CONTACT_NAME AS d_sales_rep_contact_name, 
                      dbo.REQUESTS.D_SALES_SUP_CONTACT_ID, sales_support.CONTACT_NAME AS d_sales_sup_contact_name, 
                      dbo.REQUESTS.CUSTOMER_CONTACT_ID, customer.CONTACT_NAME AS customer_contact_name, dbo.REQUESTS.A_M_CONTACT_ID, 
                      am_contact.CONTACT_NAME AS a_m_contact_name, dbo.LOOKUPS.CODE
FROM         dbo.PUNCHLISTS RIGHT OUTER JOIN
                      dbo.REQUESTS ON dbo.PUNCHLISTS.REQUEST_ID = dbo.REQUESTS.REQUEST_ID LEFT OUTER JOIN
                      dbo.PROJECTS ON dbo.REQUESTS.PROJECT_ID = dbo.PROJECTS.PROJECT_ID LEFT OUTER JOIN
                      dbo.LOOKUPS ON dbo.REQUESTS.REQUEST_TYPE_ID = dbo.LOOKUPS.LOOKUP_ID LEFT OUTER JOIN
                      dbo.CONTACTS customer ON dbo.REQUESTS.CUSTOMER_CONTACT_ID = customer.CONTACT_ID LEFT OUTER JOIN
                      dbo.CONTACTS sales_rep ON dbo.REQUESTS.D_SALES_REP_CONTACT_ID = sales_rep.CONTACT_ID LEFT OUTER JOIN
                      dbo.CONTACTS sales_support ON dbo.REQUESTS.D_SALES_SUP_CONTACT_ID = sales_support.CONTACT_ID LEFT OUTER JOIN
                      dbo.CONTACTS am_contact ON dbo.REQUESTS.A_M_CONTACT_ID = am_contact.CONTACT_ID
WHERE     (dbo.LOOKUPS.CODE = 'service_request') OR
                      (dbo.LOOKUPS.CODE = 'workorder')
GO
/****** Object:  View [dbo].[PKT_QUOTES_V]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[PKT_QUOTES_V]
AS
SELECT     dbo.QUOTES_V.QUOTE_ID, dbo.SERVICES.SERVICE_ID, dbo.REQUESTS.REQUEST_ID, dbo.QUOTES_V.QUOTE_NO, dbo.QUOTES_V.quote_type_name,
                       dbo.QUOTES_V.duration_name, dbo.QUOTES_V.DURATION_QTY, reg.NAME AS regular_name, weekend.NAME AS evenings_name, 
                      evening.NAME AS weekends_name, dbo.CONTACTS.CONTACT_NAME AS furniture
FROM         dbo.REQUESTS LEFT OUTER JOIN
                      dbo.QUOTES_V ON dbo.REQUESTS.REQUEST_ID = dbo.QUOTES_V.REQUEST_ID LEFT OUTER JOIN
                      dbo.CONTACTS ON dbo.REQUESTS.FURNITURE1_CONTACT_ID = dbo.CONTACTS.CONTACT_ID LEFT OUTER JOIN
                      dbo.LOOKUPS reg ON dbo.REQUESTS.REGULAR_HOURS_TYPE_ID = reg.LOOKUP_ID LEFT OUTER JOIN
                      dbo.LOOKUPS evening ON dbo.REQUESTS.EVENING_HOURS_TYPE_ID = evening.LOOKUP_ID LEFT OUTER JOIN
                      dbo.LOOKUPS weekend ON dbo.REQUESTS.WEEKEND_HOURS_TYPE_ID = weekend.LOOKUP_ID FULL OUTER JOIN
                      dbo.SERVICES ON dbo.REQUESTS.REQUEST_ID = dbo.SERVICES.REQUEST_ID
GO
/****** Object:  View [dbo].[INVOICES_V]    Script Date: 05/03/2010 14:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[INVOICES_V]
AS
SELECT     TOP 100 PERCENT dbo.INVOICES.ORGANIZATION_ID, dbo.INVOICES.INVOICE_ID, dbo.INVOICES.JOB_ID, CAST(dbo.INVOICES.INVOICE_ID AS varchar) 
                      + dbo.CONTAINS_INVOICE_TRACKING_V.contains_tracking AS invoice_id_trk, dbo.CONTAINS_INVOICE_TRACKING_V.contains_tracking, 
                      dbo.USERS.FIRST_NAME + ' ' + dbo.USERS.LAST_NAME AS created_by_name, 
                      USERS_1.FIRST_NAME + ' ' + USERS_1.LAST_NAME AS modified_by_name, dbo.INVOICES.INVOICE_TYPE_ID, 
                      INVOICE_TYPE.CODE AS invoice_type_code, INVOICE_TYPE.NAME AS invoice_type_name, dbo.INVOICES.BILLING_TYPE_ID, 
                      BILLING_TYPE.CODE AS billing_type_code, BILLING_TYPE.NAME AS billing_type_name, dbo.INVOICES.INVOICE_FORMAT_TYPE_ID, 
                      INVOICE_FORMAT_TYPE.CODE AS invoice_format_type_code, INVOICE_FORMAT_TYPE.NAME AS invoice_format_type_name, 
                      USERS_2.FIRST_NAME + ' ' + USERS_2.LAST_NAME AS assigned_to_name, dbo.INVOICES.MODIFIED_BY, dbo.INVOICES.DATE_MODIFIED, 
                      dbo.INVOICES.CREATED_BY, dbo.INVOICES.PO_NO, dbo.INVOICES.BATCH_STATUS_ID, dbo.INVOICE_BATCH_STATUSES.CODE, 
                      dbo.INVOICES.EXT_BATCH_ID, dbo.INVOICES.ASSIGNED_TO_USER_ID, dbo.INVOICES.EXT_INVOICE_ID, dbo.INVOICES.STATUS_ID, 
                      dbo.INVOICES.DESCRIPTION, dbo.INVOICES.EXT_BILL_CUST_ID, dbo.INVOICES.DATE_SENT, dbo.INVOICES.DATE_CREATED, 
                      dbo.INVOICES.GP_DESCRIPTION, dbo.INVOICES.COST_CODES, dbo.INVOICES.START_DATE, dbo.INVOICES.END_DATE
FROM         dbo.CONTAINS_INVOICE_TRACKING_V RIGHT OUTER JOIN
                      dbo.INVOICES LEFT OUTER JOIN
                      dbo.INVOICE_BATCH_STATUSES ON dbo.INVOICES.BATCH_STATUS_ID = dbo.INVOICE_BATCH_STATUSES.STATUS_ID LEFT OUTER JOIN
                      dbo.USERS ON dbo.INVOICES.CREATED_BY = dbo.USERS.USER_ID LEFT OUTER JOIN
                      dbo.USERS USERS_2 ON dbo.INVOICES.ASSIGNED_TO_USER_ID = USERS_2.USER_ID ON 
                      dbo.CONTAINS_INVOICE_TRACKING_V.INVOICE_ID = dbo.INVOICES.INVOICE_ID LEFT OUTER JOIN
                      dbo.LOOKUPS INVOICE_FORMAT_TYPE ON dbo.INVOICES.INVOICE_FORMAT_TYPE_ID = INVOICE_FORMAT_TYPE.LOOKUP_ID LEFT OUTER JOIN
                      dbo.LOOKUPS BILLING_TYPE ON dbo.INVOICES.BILLING_TYPE_ID = BILLING_TYPE.LOOKUP_ID LEFT OUTER JOIN
                      dbo.LOOKUPS INVOICE_TYPE ON dbo.INVOICES.INVOICE_TYPE_ID = INVOICE_TYPE.LOOKUP_ID LEFT OUTER JOIN
                      dbo.USERS USERS_1 ON dbo.INVOICES.MODIFIED_BY = USERS_1.USER_ID
ORDER BY dbo.INVOICES.INVOICE_ID
GO

/****** View [dbo].[GP_AIA_PAY_CODE_V]  ******/
-- SET ANSI_NULLS ON
-- GO
-- SET QUOTED_IDENTIFIER ON
-- GO
--
-- CREATE VIEW
--     [dbo].[GP_AIA_PAY_CODE_V] ( PAYRCORD, DSCRIPTN, INACTIVE, PAYTYPE, BSPAYRCD, PAYRTAMT, PAYUNIT, PAYUNPER, PAYPEROD, PAYPRPRD, MXPYPPER, TipType, PAYADVNC, RPTASWGS, W2BXNMBR, W2BXLABL, TAXABLE, SBJTFDTX, SBJTSSEC, SBJTMCAR, SBJTSTTX, SBJTLTAX, SBJTFUTA, SBJTSUTA, FFEDTXRT, FLSTTXRT, ACRUVACN, ACRUSTIM, NOTEINDX, DATAENTDFLT, SHFTCODE, PAYFACTR, BSDONRTE, DEX_ROW_ID ) AS
-- SELECT
--     *
-- FROM
--     AIA.dbo.UPR40600
-- WHERE
--     (
--         PAYRCORD IN ('1', '2', '3', '4', '8', '16')
--     )
-- AND
--     (
--         INACTIVE = 0
--     )
-- GO
/****** Object:  View [dbo].[GP_AIA_ITEM_PAYCODES_V]    Script Date: 05/03/2010 14:18:06 ******/
-- SET ANSI_NULLS ON
-- GO
-- SET QUOTED_IDENTIFIER ON
-- GO
-- CREATE VIEW [dbo].[GP_AIA_ITEM_PAYCODES_V]
-- AS
-- SELECT     ITEM_ID, item_name, pay_code, defaulted
-- FROM         (SELECT     GP_PAYCODES.PAYRCORD AS pay_code, dbo.ITEMS.NAME AS item_name, dbo.ITEMS.ITEM_ID, 'f' AS defaulted
--                        FROM          dbo.LOOKUPS ITEM_TYPES INNER JOIN
--                                               dbo.ITEMS ON ITEM_TYPES.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID INNER JOIN
--                                               dbo.GP_AIA_PAY_CODE_V GP_PAYCODES ON RIGHT(dbo.ITEMS.NAME, CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) - 1)
--                                               = RIGHT(GP_PAYCODES.DSCRIPTN, CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) - 1)
--                        WHERE      (CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) > 0) AND (CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) > 0) AND
--                                               (ITEM_TYPES.CODE = 'hours') AND organization_id = 6
--                        UNION
--                        SELECT     '1' AS pay_code, dbo.ITEMS.NAME AS item_name, dbo.ITEMS.ITEM_ID, 't' AS defaulted
--                        FROM         dbo.ITEMS INNER JOIN
--                                              dbo.LOOKUPS item_types ON dbo.ITEMS.ITEM_TYPE_ID = item_types.LOOKUP_ID
--                        WHERE     (item_types.CODE = 'hours') AND (dbo.ITEMS.ITEM_ID NOT IN
--                                                  (SELECT     dbo.ITEMS.ITEM_ID
--                                                    FROM          dbo.LOOKUPS ITEM_TYPES INNER JOIN
--                                                                           dbo.ITEMS ON ITEM_TYPES.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID INNER JOIN
--                                                                           dbo.GP_AIA_PAY_CODE_V GP_PAYCODES ON RIGHT(dbo.ITEMS.NAME, CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) - 1)
--                                                                           = RIGHT(GP_PAYCODES.DSCRIPTN, CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) - 1)
--                                                    WHERE      (CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) > 0) AND (CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) > 0) AND
--                                                                           (ITEM_TYPES.CODE = 'hours') AND dbo.items.organization_id = 6))) DERIVEDTBL
-- GO
/****** Object:  View [dbo].[CONTACT_EMAILS_V]    Script Date: 05/03/2010 14:18:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[CONTACT_EMAILS_V]
AS
SELECT     dbo.CONTACTS.CONTACT_ID, dbo.CONTACTS.CONTACT_NAME, dbo.CONTACTS.CONT_STATUS_TYPE_ID, dbo.LOOKUPS.NAME AS Status, 
                      dbo.CONTACTS.EMAIL
FROM         dbo.CONTACTS INNER JOIN
                      dbo.LOOKUPS ON dbo.CONTACTS.CONT_STATUS_TYPE_ID = dbo.LOOKUPS.LOOKUP_ID
WHERE     (dbo.CONTACTS.CONT_STATUS_TYPE_ID = 128) AND (dbo.CONTACTS.EMAIL IS NOT NULL)
GO
/****** Object:  View [dbo].[CONTACTS_V]    Script Date: 05/03/2010 14:18:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[CONTACTS_V]
AS
SELECT     dbo.CONTACTS.ORGANIZATION_ID, dbo.CONTACTS.CONTACT_ID, dbo.CONTACTS.CONTACT_NAME, dbo.CONTACTS.EXT_DEALER_ID, 
                      dbo.CONTACTS.CUSTOMER_ID, dbo.CUSTOMERS.PARENT_CUSTOMER_ID, dbo.CUSTOMERS.CUSTOMER_NAME, 
                      dbo.CONTACT_GROUPS.CONTACT_TYPE_ID, LOOKUPS_2.CODE AS contact_type_code, LOOKUPS_2.NAME AS contact_type_name, 
                      dbo.CONTACTS.CONT_STATUS_TYPE_ID, CONT_STATUS_TYPE.CODE AS cont_status_type_code, 
                      CONT_STATUS_TYPE.NAME AS cont_status_type_name, dbo.CONTACTS.PHONE_WORK, dbo.CONTACTS.PHONE_CELL, 
                      dbo.CONTACTS.PHONE_HOME, dbo.CONTACTS.EMAIL, dbo.CONTACTS.STREET1, dbo.CONTACTS.STREET2, dbo.CONTACTS.STREET3, 
                      dbo.CONTACTS.CITY, dbo.CONTACTS.STATE, dbo.CONTACTS.ZIP, dbo.CONTACTS.NOTES, dbo.CONTACTS.DATE_CREATED, 
                      dbo.CONTACTS.CREATED_BY, USERS_V_1.full_name AS created_by_name, dbo.CONTACTS.DATE_MODIFIED, dbo.CONTACTS.MODIFIED_BY, 
                      USERS_V_2.full_name AS modified_by_name
FROM         dbo.CUSTOMERS RIGHT OUTER JOIN
                      dbo.CONTACTS LEFT OUTER JOIN
                      dbo.CONTACT_GROUPS ON dbo.CONTACTS.CONTACT_ID = dbo.CONTACT_GROUPS.CONTACT_ID LEFT OUTER JOIN
                      dbo.LOOKUPS CONT_STATUS_TYPE ON dbo.CONTACTS.CONT_STATUS_TYPE_ID = CONT_STATUS_TYPE.LOOKUP_ID LEFT OUTER JOIN
                      dbo.LOOKUPS LOOKUPS_2 ON dbo.CONTACT_GROUPS.CONTACT_TYPE_ID = LOOKUPS_2.LOOKUP_ID ON 
                      dbo.CUSTOMERS.CUSTOMER_ID = dbo.CONTACTS.CUSTOMER_ID LEFT OUTER JOIN
                      dbo.USERS_V USERS_V_2 ON dbo.CONTACTS.MODIFIED_BY = USERS_V_2.USER_ID LEFT OUTER JOIN
                      dbo.USERS_V USERS_V_1 ON dbo.CONTACTS.CREATED_BY = USERS_V_1.USER_ID
GO
/****** Object:  View [dbo].[POOLED_HOURS_CALC_V]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[POOLED_HOURS_CALC_V]
AS
SELECT     dbo.POOLED_HOURS_CALC.SERVICE_ID, dbo.POOLED_HOURS_CALC.ITEM_ID, dbo.POOLED_HOURS_CALC.RATE, 
                      dbo.POOLED_HOURS_CALC.QTY_POOLED, dbo.POOLED_HOURS_CALC.QTY_DIST, 
                      dbo.POOLED_HOURS_CALC.QTY_POOLED - dbo.POOLED_HOURS_CALC.QTY_DIST AS qty_left, dbo.ITEMS.NAME AS item_name, 
                      dbo.LOOKUPS.CODE AS item_type_code
FROM         dbo.POOLED_HOURS_CALC LEFT OUTER JOIN
                      dbo.ITEMS ON dbo.POOLED_HOURS_CALC.ITEM_ID = dbo.ITEMS.ITEM_ID LEFT OUTER JOIN
                      dbo.LOOKUPS ON dbo.ITEMS.ITEM_TYPE_ID = dbo.LOOKUPS.LOOKUP_ID
GO
/****** Object:  View [dbo].[PDA_PDS_V]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[PDA_PDS_V]
AS
SELECT     dbo.PDA_JOBS_V.ims_user_id, dbo.JOBS.JOB_ID, dbo.JOBS.JOB_NO, dbo.SERVICES.SERVICE_ID, dbo.SERVICES.SERVICE_NO, 
                      substring(ISNULL(dbo.REQUESTS.DESCRIPTION, dbo.SERVICES.DESCRIPTION),1,500) AS [desc], dbo.JOB_LOCATIONS.JOB_LOCATION_NAME AS job_locat, 
                      CONVERT(varchar, dbo.REQUESTS.DEALER_PO_NO) + '-' + CONVERT(varchar, dbo.REQUESTS.DEALER_PO_LINE_NO) AS d_po_no, 
                      dealer_sales_rep.CONTACT_NAME AS dsr_name, dealer_sales_rep.PHONE_WORK AS dsr_phone, customer.CONTACT_NAME AS c_name, 
                      customer.PHONE_WORK AS c_phone, a_m.CONTACT_NAME AS am_name, a_m.PHONE_WORK AS am_phone, 
                      dealer_sales_sup.CONTACT_NAME AS dss_name, dealer_sales_sup.PHONE_WORK AS dss_phone, deliv.NAME AS deliv_by, 
                      furn_plan.NAME AS [plan], dbo.REQUESTS.ELEVATOR_AVAIL_TIME AS elev, dbo.REQUESTS.DOCK_AVAILABLE_TIME AS dock, 
                      dbo.REQUESTS.WHO_CAN_APPROVE_NAME AS a_name, dbo.REQUESTS.WHO_CAN_APPROVE_PHONE AS a_phone, 
                      dbo.REQUESTS.PLAN_LOCATION AS plan_locat, dbo.REQUESTS.WAREHOUSE_LOC AS location, dbo.SERVICES.EST_START_DATE AS ins_date, 
                      dbo.SERVICES.EST_START_TIME AS ins_time, dbo.SERVICES.EST_END_DATE AS target, Wall.NAME AS wall, 
                      dbo.CUSTOMERS.CUSTOMER_NAME AS customer, address = CASE WHEN dbo.JOB_LOCATIONS.street2 IS NULL AND 
                      dbo.JOB_LOCATIONS.street3 IS NULL THEN ISNULL(dbo.JOB_LOCATIONS.street1, '') + char(10) + ISNULL(dbo.JOB_LOCATIONS.city, '') 
                      + ', ' + ISNULL(dbo.JOB_LOCATIONS.state, '') + ' ' + ISNULL(dbo.JOB_LOCATIONS.zip, '') WHEN dbo.JOB_LOCATIONS.street3 IS NULL 
                      THEN dbo.JOB_LOCATIONS.street1 + char(10) + dbo.JOB_LOCATIONS.street2 + char(10) + ISNULL(dbo.JOB_LOCATIONS.city, '') 
                      + ', ' + ISNULL(dbo.JOB_LOCATIONS.state, '') + ' ' + ISNULL(dbo.JOB_LOCATIONS.zip, '') ELSE dbo.JOB_LOCATIONS.street1 + char(10) 
                      + dbo.JOB_LOCATIONS.street2 + char(10) + dbo.JOB_LOCATIONS.street3 + char(10) + ISNULL(dbo.JOB_LOCATIONS.city, '') 
                      + ', ' + ISNULL(dbo.JOB_LOCATIONS.state, '') + '' + ISNULL(dbo.JOB_LOCATIONS.zip, '') END
FROM         dbo.CONTACTS dealer_sales_sup RIGHT OUTER JOIN
                      dbo.JOB_LOCATIONS RIGHT OUTER JOIN
                      dbo.JOBS INNER JOIN
                      dbo.PDA_JOBS_V ON dbo.JOBS.JOB_ID = dbo.PDA_JOBS_V.JOB_ID INNER JOIN
                      dbo.SERVICES ON dbo.JOBS.JOB_ID = dbo.SERVICES.JOB_ID INNER JOIN
                      dbo.LOOKUPS Service_statuses ON dbo.SERVICES.SERV_STATUS_TYPE_ID = Service_statuses.LOOKUP_ID ON 
                      dbo.JOB_LOCATIONS.JOB_LOCATION_ID = dbo.SERVICES.JOB_LOCATION_ID LEFT OUTER JOIN
                      dbo.CONTACTS dealer_sales_rep ON dbo.SERVICES.SUPPORT_CONTACT_ID = dealer_sales_rep.CONTACT_ID ON 
                      dealer_sales_sup.CONTACT_ID = dbo.SERVICES.SUPPORT_CONTACT_ID LEFT OUTER JOIN
                      dbo.CONTACTS customer ON dbo.SERVICES.IDM_CONTACT_ID = customer.CONTACT_ID LEFT OUTER JOIN
                      dbo.CONTACTS a_m ON dbo.SERVICES.IDM_CONTACT_ID = a_m.CONTACT_ID LEFT OUTER JOIN
                      dbo.CUSTOMERS ON dbo.JOBS.CUSTOMER_ID = dbo.CUSTOMERS.CUSTOMER_ID LEFT OUTER JOIN
                      dbo.LOOKUPS Wall RIGHT OUTER JOIN
                      dbo.REQUESTS ON Wall.LOOKUP_ID = dbo.REQUESTS.WALL_MOUNT_TYPE_ID LEFT OUTER JOIN
                      dbo.LOOKUPS deliv ON dbo.REQUESTS.DELIVERY_TYPE_ID = deliv.LOOKUP_ID LEFT OUTER JOIN
                      dbo.LOOKUPS furn_plan ON dbo.REQUESTS.FURN_PLAN_TYPE_ID = furn_plan.LOOKUP_ID ON 
                      dbo.SERVICES.REQUEST_ID = dbo.REQUESTS.REQUEST_ID
WHERE     (Service_statuses.CODE <> 'closed')
GO
/****** Object:  View [dbo].[TRACKING_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[TRACKING_V]
AS
SELECT     dbo.TRACKING.TRACKING_ID, dbo.TRACKING.JOB_ID, dbo.JOBS.JOB_NO, dbo.TRACKING.SERVICE_ID, dbo.SERVICES.SERVICE_NO, 
                      dbo.TRACKING.TRACKING_TYPE_ID, LOOKUPS_3.CODE AS tracking_type_code, LOOKUPS_3.NAME AS tracking_type_name, 
                      dbo.TRACKING.TO_CONTACT_ID, dbo.CONTACTS.CONTACT_NAME AS to_contact_name, dbo.CONTACTS.EMAIL, dbo.TRACKING.FROM_USER_ID, 
                      USERS_3.FIRST_NAME + ' ' + USERS_3.LAST_NAME AS from_user_name, dbo.SERVICES.SERV_STATUS_TYPE_ID AS cur_status_type_id, 
                      dbo.TRACKING.NEW_STATUS_ID, LOOKUPS_1.CODE AS new_status_type_code, LOOKUPS_1.NAME AS new_status_type_name, 
                      dbo.TRACKING.OLD_STATUS_ID, LOOKUPS_1.CODE AS old_status_type_code, LOOKUPS_1.NAME AS old_status_type_name, dbo.TRACKING.NOTES, 
                      dbo.TRACKING.DATE_CREATED, dbo.TRACKING.CREATED_BY, USERS_2.FIRST_NAME + ' ' + USERS_2.LAST_NAME AS created_by_name, 
                      dbo.TRACKING.DATE_MODIFIED, dbo.TRACKING.MODIFIED_BY, USERS_1.FIRST_NAME + ' ' + USERS_1.LAST_NAME AS modified_by_name, 
                      dbo.TRACKING.EMAIL_SENT_FLAG
FROM         dbo.LOOKUPS LOOKUPS_1 RIGHT OUTER JOIN
                      dbo.LOOKUPS LOOKUPS_2 RIGHT OUTER JOIN
                      dbo.USERS USERS_2 RIGHT OUTER JOIN
                      dbo.USERS USERS_3 RIGHT OUTER JOIN
                      dbo.CONTACTS RIGHT OUTER JOIN
                      dbo.SERVICES RIGHT OUTER JOIN
                      dbo.USERS USERS_1 RIGHT OUTER JOIN
                      dbo.JOBS RIGHT OUTER JOIN
                      dbo.TRACKING ON dbo.JOBS.JOB_ID = dbo.TRACKING.JOB_ID LEFT OUTER JOIN
                      dbo.LOOKUPS LOOKUPS_3 ON dbo.TRACKING.TRACKING_TYPE_ID = LOOKUPS_3.LOOKUP_ID ON 
                      USERS_1.USER_ID = dbo.TRACKING.MODIFIED_BY ON dbo.SERVICES.SERVICE_ID = dbo.TRACKING.SERVICE_ID ON 
                      dbo.CONTACTS.CONTACT_ID = dbo.TRACKING.TO_CONTACT_ID ON USERS_3.USER_ID = dbo.TRACKING.FROM_USER_ID ON 
                      USERS_2.USER_ID = dbo.TRACKING.CREATED_BY ON LOOKUPS_2.LOOKUP_ID = dbo.TRACKING.OLD_STATUS_ID ON 
                      LOOKUPS_1.LOOKUP_ID = dbo.TRACKING.NEW_STATUS_ID
GO
/****** Object:  View [dbo].[pda_services_v]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[pda_services_v]
AS
SELECT     TOP 100 PERCENT dbo.PDA_JOBS_V.ims_user_id, dbo.SERVICES.SERVICE_ID, dbo.SERVICES.SERVICE_NO, dbo.SERVICES.JOB_ID, 
                      ISNULL(dbo.CONTACTS.CONTACT_NAME, 'N/A') AS contact, ISNULL(dbo.CONTACTS.PHONE_WORK, 'N/A') AS phone, 
                      substring(ISNULL(dbo.SERVICES.DESCRIPTION, 'N/A'),1,500) AS [desc], dbo.JOB_LOCATIONS.JOB_LOCATION_NAME AS job_loc, REPORT_TO.NAME AS report_to, 
                      dbo.SERVICES.EST_START_DATE AS start_date, LTRIM(SUBSTRING(CONVERT(varchar, dbo.SERVICES.EST_START_DATE, 100), 13, 7)) AS start_time, 
                      address = CASE WHEN dbo.JOB_LOCATIONS.street2 IS NULL AND dbo.JOB_LOCATIONS.street3 IS NULL THEN ISNULL(dbo.JOB_LOCATIONS.street1, 
                      '') + char(10) + ISNULL(dbo.JOB_LOCATIONS.city, '') + ', ' + ISNULL(dbo.JOB_LOCATIONS.state, '') + ' ' + ISNULL(dbo.JOB_LOCATIONS.zip, '') 
                      WHEN dbo.JOB_LOCATIONS.street3 IS NULL THEN dbo.JOB_LOCATIONS.street1 + char(10) + dbo.JOB_LOCATIONS.street2 + char(10) 
                      + ISNULL(dbo.JOB_LOCATIONS.city, '') + ', ' + ISNULL(dbo.JOB_LOCATIONS.state, '') + ' ' + ISNULL(dbo.JOB_LOCATIONS.zip, '') 
                      ELSE dbo.JOB_LOCATIONS.street1 + char(10) + dbo.JOB_LOCATIONS.street2 + char(10) + dbo.JOB_LOCATIONS.street3 + char(10) 
                      + ISNULL(dbo.JOB_LOCATIONS.city, '') + ', ' + ISNULL(dbo.JOB_LOCATIONS.state, '') + '' + ISNULL(dbo.JOB_LOCATIONS.zip, '') END
FROM         dbo.JOBS INNER JOIN
                      dbo.SERVICES ON dbo.JOBS.JOB_ID = dbo.SERVICES.JOB_ID INNER JOIN
                      dbo.PDA_JOBS_V ON dbo.JOBS.JOB_ID = dbo.PDA_JOBS_V.JOB_ID LEFT OUTER JOIN
                      dbo.LOOKUPS REPORT_TO ON dbo.SERVICES.REPORT_TO_LOC_ID = REPORT_TO.LOOKUP_ID LEFT OUTER JOIN
                      dbo.JOB_LOCATIONS LEFT OUTER JOIN
                      dbo.CONTACTS ON dbo.JOB_LOCATIONS.JOB_LOC_CONTACT_ID = dbo.CONTACTS.CONTACT_ID ON 
                      dbo.SERVICES.JOB_LOCATION_ID = dbo.JOB_LOCATIONS.JOB_LOCATION_ID LEFT OUTER JOIN
                      dbo.LOOKUPS Service_Status ON dbo.SERVICES.SERV_STATUS_TYPE_ID = Service_Status.LOOKUP_ID
WHERE     (Service_Status.CODE <> 'closed')
GO
/****** Object:  View [dbo].[quick_project_v]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[quick_project_v]
AS
SELECT p.project_id, 
       p.project_no, 
       p.job_name, 
       c.organization_id, 
       CASE WHEN customer_type.code = 'end_user' THEN c.end_user_parent_id ELSE c.customer_id END customer_id,
       CASE WHEN customer_type.code = 'end_user' THEN (SELECT customer_name FROM customers WHERE customer_id=c.end_user_parent_id) ELSE c.customer_name END customer_name,
       CASE WHEN customer_type.code = 'end_user' THEN c.customer_id ELSE eu.customer_id END end_user_id,
       CASE WHEN customer_type.code = 'end_user' THEN c.customer_name ELSE eu.customer_name END end_user_name,
       project_status.
       code AS project_status_code, 
       project_status.name AS project_status_name, 
       p.date_created, 
       p.created_by
  FROM dbo.projects p INNER JOIN
       dbo.lookups project_status ON p.project_status_type_id = project_status.lookup_id INNER JOIN
       dbo.customers c ON p.customer_id = c.customer_id INNER JOIN
       dbo.lookups customer_type ON c.customer_type_id = customer_type.lookup_id LEFT OUTER JOIN
       dbo.customers eu ON p.end_user_id = eu.customer_id
GO
/****** Object:  View [dbo].[GP_CIINC_ITEM_PAYCODES_V]    Script Date: 05/03/2010 14:18:07 ******/
-- SET ANSI_NULLS ON
-- GO
-- SET QUOTED_IDENTIFIER ON
-- GO
-- CREATE VIEW [dbo].[GP_CIINC_ITEM_PAYCODES_V]
-- AS
-- SELECT     ITEM_ID, item_name, pay_code, defaulted
-- FROM         (SELECT     GP_PAYCODES.PAYRCORD AS pay_code, dbo.ITEMS.NAME AS item_name, dbo.ITEMS.ITEM_ID, 'f' AS defaulted
--                        FROM          dbo.LOOKUPS ITEM_TYPES INNER JOIN
--                                               dbo.ITEMS ON ITEM_TYPES.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID INNER JOIN
--                                               dbo.GP_MPLS_PAY_CODE_V GP_PAYCODES ON RIGHT(dbo.ITEMS.NAME, CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) - 1) 
--                                               = RIGHT(GP_PAYCODES.DSCRIPTN, CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) - 1)
--                        WHERE      (CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) > 0) AND (CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) > 0) AND
--                                               (ITEM_TYPES.CODE = 'hours')
--                        UNION
--                        SELECT     '1' AS pay_code, dbo.ITEMS.NAME AS item_name, dbo.ITEMS.ITEM_ID, 't' AS defaulted
--                        FROM         dbo.ITEMS INNER JOIN
--                                              dbo.LOOKUPS item_types ON dbo.ITEMS.ITEM_TYPE_ID = item_types.LOOKUP_ID
--                        WHERE     (item_types.CODE = 'hours') AND (dbo.ITEMS.ITEM_ID NOT IN
--                                                  (SELECT     dbo.ITEMS.ITEM_ID
--                                                    FROM          dbo.LOOKUPS ITEM_TYPES INNER JOIN
--                                                                           dbo.ITEMS ON ITEM_TYPES.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID INNER JOIN
--                                                                           dbo.GP_MPLS_PAY_CODE_V GP_PAYCODES ON RIGHT(dbo.ITEMS.NAME, CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) - 1)
--                                                                           = RIGHT(GP_PAYCODES.DSCRIPTN, CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) - 1)
--                                                    WHERE      (CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) > 0) AND (CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) > 0) AND
--                                                                           (ITEM_TYPES.CODE = 'hours')))) DERIVEDTBL
-- GO
/****** Object:  View [dbo].[INVOICE_COST_CODES_V]    Script Date: 05/03/2010 14:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[INVOICE_COST_CODES_V]
AS
SELECT     TOP 100 PERCENT dbo.INVOICES.INVOICE_ID, dbo.LOOKUPS.CODE AS cost_to_cust, LOOKUPS_1.CODE AS cost_to_vend, 
                      LOOKUPS_2.CODE AS cost_to_job, LOOKUPS_3.CODE AS warehouse_fee, dbo.SERVICES.SERVICE_ID, dbo.REQUESTS.D_SALES_REP_CONTACT_ID, 
                      dbo.CONTACTS.CONTACT_NAME AS sales_rep_name
FROM         dbo.INVOICES INNER JOIN
                      dbo.INVOICE_LINES ON dbo.INVOICES.INVOICE_ID = dbo.INVOICE_LINES.INVOICE_ID INNER JOIN
                      dbo.SERV_INV_LINES ON dbo.INVOICE_LINES.INVOICE_LINE_ID = dbo.SERV_INV_LINES.INVOICE_LINE_ID INNER JOIN
                      dbo.SERVICE_LINES ON dbo.SERV_INV_LINES.SERVICE_LINE_ID = dbo.SERVICE_LINES.SERVICE_LINE_ID INNER JOIN
                      dbo.SERVICES ON dbo.SERVICE_LINES.BILL_SERVICE_ID = dbo.SERVICES.SERVICE_ID INNER JOIN
                      dbo.REQUESTS ON dbo.SERVICES.REQUEST_ID = dbo.REQUESTS.REQUEST_ID INNER JOIN
                      dbo.LOOKUPS ON dbo.REQUESTS.COST_TO_CUST_TYPE_ID = dbo.LOOKUPS.LOOKUP_ID INNER JOIN
                      dbo.LOOKUPS LOOKUPS_1 ON dbo.REQUESTS.COST_TO_VEND_TYPE_ID = LOOKUPS_1.LOOKUP_ID INNER JOIN
                      dbo.LOOKUPS LOOKUPS_2 ON dbo.REQUESTS.COST_TO_JOB_TYPE_ID = LOOKUPS_2.LOOKUP_ID INNER JOIN
                      dbo.LOOKUPS LOOKUPS_3 ON dbo.REQUESTS.WAREHOUSE_FEE_TYPE_ID = LOOKUPS_3.LOOKUP_ID LEFT OUTER JOIN
                      dbo.CONTACTS ON dbo.REQUESTS.D_SALES_REP_CONTACT_ID = dbo.CONTACTS.CONTACT_ID
GROUP BY dbo.INVOICES.INVOICE_ID, dbo.LOOKUPS.CODE, LOOKUPS_1.CODE, LOOKUPS_2.CODE, LOOKUPS_3.CODE, dbo.SERVICES.SERVICE_ID, 
                      dbo.REQUESTS.D_SALES_REP_CONTACT_ID, dbo.CONTACTS.CONTACT_NAME
HAVING      (dbo.LOOKUPS.CODE = 'Y') OR
                      (LOOKUPS_1.CODE = 'Y') OR
                      (LOOKUPS_2.CODE = 'Y') OR
                      (LOOKUPS_3.CODE = 'Y')
ORDER BY dbo.INVOICES.INVOICE_ID
GO

/****** Object:  View [dbo].[INVOICE_COST_CODES_PROBLEMS_V]    Script Date: 05/03/2010 14:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[INVOICE_COST_CODES_PROBLEMS_V]
AS
SELECT     dbo.INVOICE_COST_CODES_V.INVOICE_ID, dbo.INVOICE_COST_CODES_V.SERVICE_ID, INVOICE_COST_CODES_V_1.SERVICE_ID AS Expr6,
                      dbo.INVOICE_COST_CODES_V.cost_to_cust, dbo.INVOICE_COST_CODES_V.cost_to_vend, dbo.INVOICE_COST_CODES_V.cost_to_job,
                      dbo.INVOICE_COST_CODES_V.warehouse_fee, INVOICE_COST_CODES_V_1.INVOICE_ID AS Expr1, INVOICE_COST_CODES_V_1.cost_to_cust AS Expr2,
                       INVOICE_COST_CODES_V_1.cost_to_vend AS Expr3, INVOICE_COST_CODES_V_1.cost_to_job AS Expr4,
                      INVOICE_COST_CODES_V_1.warehouse_fee AS Expr5
FROM         dbo.INVOICE_COST_CODES_V INNER JOIN
                      dbo.INVOICE_COST_CODES_V INVOICE_COST_CODES_V_1 ON
                      dbo.INVOICE_COST_CODES_V.SERVICE_ID <> INVOICE_COST_CODES_V_1.SERVICE_ID AND
                      dbo.INVOICE_COST_CODES_V.INVOICE_ID = INVOICE_COST_CODES_V_1.INVOICE_ID AND
                      dbo.INVOICE_COST_CODES_V.cost_to_cust <> INVOICE_COST_CODES_V_1.cost_to_cust
GO

/****** Object:  View [dbo].[GP_MPLS_ITEM_PAYCODES_V]    Script Date: 05/03/2010 14:18:07 ******/
-- SET ANSI_NULLS ON
-- GO
-- SET QUOTED_IDENTIFIER ON
-- GO
-- CREATE VIEW [dbo].[GP_MPLS_ITEM_PAYCODES_V]
-- AS
-- SELECT     ITEM_ID, item_name, pay_code, defaulted
-- FROM         (SELECT     GP_PAYCODES.PAYRCORD AS pay_code, dbo.ITEMS.NAME AS item_name, dbo.ITEMS.ITEM_ID, 'f' AS defaulted
--                        FROM          dbo.LOOKUPS ITEM_TYPES INNER JOIN
--                                               dbo.ITEMS ON ITEM_TYPES.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID INNER JOIN
--                                               dbo.GP_MPLS_PAY_CODE_V GP_PAYCODES ON RIGHT(dbo.ITEMS.NAME, CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) - 1)
--                                               = RIGHT(GP_PAYCODES.DSCRIPTN, CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) - 1)
--                        WHERE      (CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) > 0) AND (CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) > 0) AND
--                                               (ITEM_TYPES.CODE = 'hours')
--                        UNION
--                        SELECT     '1' AS pay_code, dbo.ITEMS.NAME AS item_name, dbo.ITEMS.ITEM_ID, 't' AS defaulted
--                        FROM         dbo.ITEMS INNER JOIN
--                                              dbo.LOOKUPS item_types ON dbo.ITEMS.ITEM_TYPE_ID = item_types.LOOKUP_ID
--                        WHERE     (item_types.CODE = 'hours') AND (dbo.ITEMS.ITEM_ID NOT IN
--                                                  (SELECT     dbo.ITEMS.ITEM_ID
--                                                    FROM          dbo.LOOKUPS ITEM_TYPES INNER JOIN
--                                                                           dbo.ITEMS ON ITEM_TYPES.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID INNER JOIN
--                                                                           dbo.GP_MPLS_PAY_CODE_V GP_PAYCODES ON RIGHT(dbo.ITEMS.NAME, CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) - 1)
--                                                                           = RIGHT(GP_PAYCODES.DSCRIPTN, CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) - 1)
--                                                    WHERE      (CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) > 0) AND (CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) > 0) AND
--                                                                           (ITEM_TYPES.CODE = 'hours')))) DERIVEDTBL
-- GO
/****** Object:  View [dbo].[GP_CIMN_ITEM_PAYCODES_V]    Script Date: 05/03/2010 14:18:07 ******/
-- SET ANSI_NULLS ON
-- GO
-- SET QUOTED_IDENTIFIER ON
-- GO
-- CREATE VIEW [dbo].[GP_CIMN_ITEM_PAYCODES_V]
-- AS
-- SELECT     ITEM_ID, item_name, pay_code, defaulted
-- FROM         (SELECT     GP_PAYCODES.PAYRCORD AS pay_code, dbo.ITEMS.NAME AS item_name, dbo.ITEMS.ITEM_ID, 'f' AS defaulted
--                        FROM          dbo.LOOKUPS ITEM_TYPES INNER JOIN
--                                               dbo.ITEMS ON ITEM_TYPES.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID INNER JOIN
--                                               dbo.GP_CIMN_PAY_CODE_V GP_PAYCODES ON RIGHT(dbo.ITEMS.NAME, CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) - 1)
--                                               = RIGHT(GP_PAYCODES.DSCRIPTN, CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) - 1)
--                        WHERE      (CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) > 0) AND (CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) > 0) AND
--                                               (ITEM_TYPES.CODE = 'hours') AND organization_id = 15
--                        UNION
--                        SELECT     '1' AS pay_code, dbo.ITEMS.NAME AS item_name, dbo.ITEMS.ITEM_ID, 't' AS defaulted
--                        FROM         dbo.ITEMS INNER JOIN
--                                              dbo.LOOKUPS item_types ON dbo.ITEMS.ITEM_TYPE_ID = item_types.LOOKUP_ID
--                        WHERE     (item_types.CODE = 'hours') AND (dbo.ITEMS.ITEM_ID NOT IN
--                                                  (SELECT     dbo.ITEMS.ITEM_ID
--                                                    FROM          dbo.LOOKUPS ITEM_TYPES INNER JOIN
--                                                                           dbo.ITEMS ON ITEM_TYPES.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID INNER JOIN
--                                                                           dbo.GP_CIMN_PAY_CODE_V GP_PAYCODES ON RIGHT(dbo.ITEMS.NAME, CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) - 1) 
--                                                                           = RIGHT(GP_PAYCODES.DSCRIPTN, CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) - 1)
--                                                    WHERE      (CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) > 0) AND (CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) > 0) AND
--                                                                           (ITEM_TYPES.CODE = 'hours') AND dbo.items.organization_id = 15))) DERIVEDTBL
-- GO
/****** Object:  View [dbo].[crystal_MADISON_RPT1_V]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[crystal_MADISON_RPT1_V]
AS
SELECT     dbo.REQUESTS.REQUEST_ID, dbo.REQUESTS.REQUEST_NO, dbo.REQUESTS.PROJECT_ID, dbo.SERVICES.SERVICE_ID, 
                      dbo.REQUESTS.DEALER_CUST_ID, dbo.REQUESTS.CUSTOMER_PO_NO, dbo.REQUESTS.DEALER_PO_NO, dbo.REQUESTS.DEALER_PO_LINE_NO, 
                      dbo.REQUESTS.DEALER_PROJECT_NO, dbo.REQUESTS.PUNCHLIST_ITEM_TYPE_ID, PUNCHLIST_ITEM_TYPE.CODE AS punchlist_item_type_code, 
                      PUNCHLIST_ITEM_TYPE.NAME AS punchlist_item_type_name, dbo.REQUESTS.PUNCHLIST_LINE, dbo.REQUESTS.PUNCHLIST_COMPLETE_DATE, 
                      dbo.PROJECTS_V.PROJECT_NO, CONVERT(varchar, dbo.PROJECTS_V.PROJECT_NO) + '-' + CONVERT(varchar, dbo.REQUESTS.REQUEST_NO) 
                      AS project_request_no, dbo.PROJECTS_V.CUSTOMER_ID, CUSTOMERS_1.ORGANIZATION_ID, CUSTOMERS_1.EXT_DEALER_ID, 
                      CUSTOMERS_1.DEALER_NAME, CUSTOMERS_1.EXT_CUSTOMER_ID, CUSTOMERS_1.CUSTOMER_NAME, dbo.PROJECTS_V.JOB_NAME, 
                      dbo.REQUESTS.EST_START_DATE
FROM         dbo.LOOKUPS DELIVERY_TYPE RIGHT OUTER JOIN
                      dbo.LOOKUPS SITE_VISIT_REQ_TYPE RIGHT OUTER JOIN
                      dbo.LOOKUPS WALL_MOUNT_TYPE RIGHT OUTER JOIN
                      dbo.LOOKUPS SEC_FURN_LINE_TYPE RIGHT OUTER JOIN
                      dbo.LOOKUPS PRI_FURN_TYPE RIGHT OUTER JOIN
                      dbo.LOOKUPS REQUEST_STATUS_TYPE RIGHT OUTER JOIN
                      dbo.LOOKUPS FURN_PLAN_TYPE RIGHT OUTER JOIN
                      dbo.LOOKUPS ACCOUNT_TYPE RIGHT OUTER JOIN
                      dbo.LOOKUPS WORKSTATION_TYPICAL_TYPE RIGHT OUTER JOIN
                      dbo.LOOKUPS PUNCHLIST_ITEM_TYPE RIGHT OUTER JOIN
                      dbo.LOOKUPS CASE_FURN_TYPE RIGHT OUTER JOIN
                      dbo.LOOKUPS FURN_SPEC_TYPE RIGHT OUTER JOIN
                      dbo.LOOKUPS CASE_FURN_LINE_TYPE RIGHT OUTER JOIN
                      dbo.LOOKUPS WOOD_PRODUCT_TYPE RIGHT OUTER JOIN
                      dbo.LOOKUPS SCHEDULE_TYPE RIGHT OUTER JOIN
                      dbo.LOOKUPS APPROVAL_REQ_TYPE RIGHT OUTER JOIN
                      dbo.LOOKUPS SERV_STATUS_TYPE RIGHT OUTER JOIN
                      dbo.SERVICES RIGHT OUTER JOIN
                      dbo.USERS USERS_1 RIGHT OUTER JOIN
                      dbo.USERS USERS_2 RIGHT OUTER JOIN
                      dbo.REQUESTS ON USERS_2.USER_ID = dbo.REQUESTS.MODIFIED_BY ON USERS_1.USER_ID = dbo.REQUESTS.CREATED_BY ON 
                      dbo.SERVICES.REQUEST_ID = dbo.REQUESTS.REQUEST_ID ON SERV_STATUS_TYPE.LOOKUP_ID = dbo.SERVICES.SERV_STATUS_TYPE_ID ON 
                      APPROVAL_REQ_TYPE.LOOKUP_ID = dbo.REQUESTS.APPROVAL_REQ_TYPE_ID ON 
                      SCHEDULE_TYPE.LOOKUP_ID = dbo.REQUESTS.SCHEDULE_TYPE_ID ON 
                      WOOD_PRODUCT_TYPE.LOOKUP_ID = dbo.REQUESTS.WOOD_PRODUCT_TYPE_ID ON 
                      CASE_FURN_LINE_TYPE.LOOKUP_ID = dbo.REQUESTS.CASE_FURN_LINE_TYPE_ID ON 
                      FURN_SPEC_TYPE.LOOKUP_ID = dbo.REQUESTS.FURN_SPEC_TYPE_ID ON 
                      CASE_FURN_TYPE.LOOKUP_ID = dbo.REQUESTS.CASE_FURN_TYPE_ID ON 
                      PUNCHLIST_ITEM_TYPE.LOOKUP_ID = dbo.REQUESTS.PUNCHLIST_ITEM_TYPE_ID ON 
                      WORKSTATION_TYPICAL_TYPE.LOOKUP_ID = dbo.REQUESTS.WORKSTATION_TYPICAL_TYPE_ID ON 
                      ACCOUNT_TYPE.LOOKUP_ID = dbo.REQUESTS.ACCOUNT_TYPE_ID ON FURN_PLAN_TYPE.LOOKUP_ID = dbo.REQUESTS.FURN_PLAN_TYPE_ID ON 
                      REQUEST_STATUS_TYPE.LOOKUP_ID = dbo.REQUESTS.REQUEST_STATUS_TYPE_ID ON 
                      PRI_FURN_TYPE.LOOKUP_ID = dbo.REQUESTS.PRI_FURN_TYPE_ID ON 
                      SEC_FURN_LINE_TYPE.LOOKUP_ID = dbo.REQUESTS.SEC_FURN_LINE_TYPE_ID LEFT OUTER JOIN
                      dbo.LOOKUPS REQUEST_TYPE ON dbo.REQUESTS.REQUEST_TYPE_ID = REQUEST_TYPE.LOOKUP_ID LEFT OUTER JOIN
                      dbo.LOOKUPS PRI_FURN_LINE_TYPE ON dbo.REQUESTS.PRI_FURN_LINE_TYPE_ID = PRI_FURN_LINE_TYPE.LOOKUP_ID LEFT OUTER JOIN
                      dbo.LOOKUPS SEC_FURN_TYPE ON dbo.REQUESTS.SEC_FURN_TYPE_ID = SEC_FURN_TYPE.LOOKUP_ID ON 
                      WALL_MOUNT_TYPE.LOOKUP_ID = dbo.REQUESTS.WALL_MOUNT_TYPE_ID LEFT OUTER JOIN
                      dbo.LOOKUPS QUOTE_TYPE ON dbo.REQUESTS.QUOTE_TYPE_ID = QUOTE_TYPE.LOOKUP_ID ON 
                      SITE_VISIT_REQ_TYPE.LOOKUP_ID = dbo.REQUESTS.SITE_VISIT_REQ_TYPE_ID ON 
                      DELIVERY_TYPE.LOOKUP_ID = dbo.REQUESTS.DELIVERY_TYPE_ID LEFT OUTER JOIN
                      dbo.JOB_LOCATIONS ON dbo.REQUESTS.JOB_LOCATION_ID = dbo.JOB_LOCATIONS.JOB_LOCATION_ID LEFT OUTER JOIN
                      dbo.CUSTOMERS CUSTOMERS_1 RIGHT OUTER JOIN
                      dbo.PROJECTS_V ON CUSTOMERS_1.CUSTOMER_ID = dbo.PROJECTS_V.CUSTOMER_ID ON 
                      dbo.REQUESTS.PROJECT_ID = dbo.PROJECTS_V.PROJECT_ID LEFT OUTER JOIN
                      dbo.CONTACTS A_M_CONTACT ON dbo.REQUESTS.A_M_CONTACT_ID = A_M_CONTACT.CONTACT_ID
WHERE     (CUSTOMERS_1.ORGANIZATION_ID = 4) AND (PUNCHLIST_ITEM_TYPE.CODE IS NOT NULL)
GO
/****** Object:  View [dbo].[QUICK_REQUESTS_V]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[QUICK_REQUESTS_V]
AS
SELECT     dbo.REQUESTS.REQUEST_ID, dbo.REQUESTS.REQUEST_ID AS RECORD_ID, dbo.REQUESTS.REQUEST_NO AS RECORD_NO, 
                      dbo.REQUESTS.CUSTOMER_PO_NO, dbo.REQUESTS.DEALER_PO_NO, dbo.REQUESTS.DEALER_PROJECT_NO, dbo.REQUESTS.EST_START_DATE, 
                      dbo.REQUESTS.DESCRIPTION, dbo.REQUESTS.IS_QUOTED, dbo.REQUESTS.DATE_CREATED AS RECORD_CREATED, 
                      dbo.REQUESTS.DATE_MODIFIED AS RECORD_LAST_MODIFIED, dbo.PROJECTS.PROJECT_ID, dbo.PROJECTS.PROJECT_NO, 
                      dbo.PROJECTS.JOB_NAME, CONVERT(varchar, dbo.PROJECTS.PROJECT_NO) + '-' + CONVERT(varchar, dbo.REQUESTS.REQUEST_NO) 
                      AS PROJECT_REQUEST_NO, dbo.CUSTOMERS.ORGANIZATION_ID, dbo.CUSTOMERS.CUSTOMER_ID, dbo.CUSTOMERS.PARENT_CUSTOMER_ID, 
                      dbo.CUSTOMERS.EXT_DEALER_ID, dbo.CUSTOMERS.CUSTOMER_NAME, dbo.CUSTOMERS.DEALER_NAME, 
                      request_status.CODE AS RECORD_STATUS_CODE, request_status.NAME AS RECORD_STATUS_NAME, 
                      request_status.SEQUENCE_NO AS RECORD_STATUS_SEQ_NO, request_type.CODE AS RECORD_TYPE_CODE, 
                      request_type.NAME AS RECORD_TYPE_NAME, request_type.SEQUENCE_NO AS RECORD_TYPE_SEQ_NO, dbo.REQUESTS.A_M_CONTACT_ID, 
                      dbo.REQUESTS.CUSTOMER_CONTACT_ID, dbo.REQUESTS.ALT_CUSTOMER_CONTACT_ID, dbo.REQUESTS.D_SALES_REP_CONTACT_ID, 
                      dbo.REQUESTS.D_SALES_SUP_CONTACT_ID, dbo.REQUESTS.D_PROJ_MGR_CONTACT_ID, dbo.REQUESTS.D_DESIGNER_CONTACT_ID, 
                      project_status.CODE AS PROJECT_STATUS_CODE, project_status.NAME AS PROJECT_STATUS_NAME
FROM         dbo.REQUESTS INNER JOIN
                      dbo.LOOKUPS request_status ON dbo.REQUESTS.REQUEST_STATUS_TYPE_ID = request_status.LOOKUP_ID INNER JOIN
                      dbo.LOOKUPS request_type ON dbo.REQUESTS.REQUEST_TYPE_ID = request_type.LOOKUP_ID INNER JOIN
                      dbo.PROJECTS ON dbo.REQUESTS.PROJECT_ID = dbo.PROJECTS.PROJECT_ID INNER JOIN
                      dbo.CUSTOMERS ON dbo.PROJECTS.CUSTOMER_ID = dbo.CUSTOMERS.CUSTOMER_ID INNER JOIN
                      dbo.LOOKUPS project_status ON dbo.PROJECTS.PROJECT_STATUS_TYPE_ID = project_status.LOOKUP_ID
GO
/****** Object:  View [dbo].[WORKORDER_DETAIL_V]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[WORKORDER_DETAIL_V]
AS
SELECT     dbo.PROJECTS_V.ORGANIZATION_ID, dbo.REQUESTS.PROJECT_ID, dbo.REQUESTS.REQUEST_ID, dbo.PROJECTS_V.EXT_DEALER_ID, 
                      dbo.PROJECTS_V.CUSTOMER_ID, dbo.PROJECTS_V.PARENT_CUSTOMER_ID, dbo.PROJECTS_V.PROJECT_NO, dbo.REQUESTS.REQUEST_NO, 
                      CONVERT(varchar, dbo.PROJECTS_V.PROJECT_NO) + '-' + CONVERT(varchar, dbo.REQUESTS.REQUEST_NO) AS workorder_no, 
                      dbo.PROJECTS_V.DEALER_NAME, dbo.PROJECTS_V.CUSTOMER_NAME, dbo.JOB_LOCATIONS.JOB_LOCATION_NAME, 
                      floor_numbers.NAME AS floor_number, request_types.CODE AS request_type_code, request_status_types.CODE AS request_status_type_code, 
                      request_types.SEQUENCE_NO AS request_seq_no, dbo.PROJECTS_V.project_status_type_code, dbo.REQUESTS.CUST_COL_1, 
                      dbo.REQUESTS.CUST_COL_2, dbo.REQUESTS.CUST_COL_3, dbo.REQUESTS.CUST_COL_4, dbo.REQUESTS.CUST_COL_5, 
                      dbo.REQUESTS.CUST_COL_6, dbo.REQUESTS.CUST_COL_7, dbo.REQUESTS.CUST_COL_8, dbo.REQUESTS.CUST_COL_9, 
                      dbo.REQUESTS.CUST_COL_10, dbo.CONTACTS.CONTACT_NAME AS customer_contact_name, dbo.REQUESTS.DESCRIPTION
FROM         dbo.LOOKUPS request_status_types RIGHT OUTER JOIN
                      dbo.REQUESTS INNER JOIN
                      dbo.VERSIONS_MAX_NO_V ON dbo.REQUESTS.PROJECT_ID = dbo.VERSIONS_MAX_NO_V.PROJECT_ID AND 
                      dbo.REQUESTS.REQUEST_NO = dbo.VERSIONS_MAX_NO_V.REQUEST_NO AND 
                      dbo.REQUESTS.VERSION_NO = dbo.VERSIONS_MAX_NO_V.max_version_no LEFT OUTER JOIN
                      dbo.CONTACTS ON dbo.REQUESTS.CUSTOMER_CONTACT_ID = dbo.CONTACTS.CONTACT_ID ON 
                      request_status_types.LOOKUP_ID = dbo.REQUESTS.REQUEST_STATUS_TYPE_ID LEFT OUTER JOIN
                      dbo.LOOKUPS floor_numbers ON dbo.REQUESTS.FLOOR_NUMBER_TYPE_ID = floor_numbers.LOOKUP_ID LEFT OUTER JOIN
                      dbo.JOB_LOCATIONS ON dbo.REQUESTS.JOB_LOCATION_ID = dbo.JOB_LOCATIONS.JOB_LOCATION_ID LEFT OUTER JOIN
                      dbo.LOOKUPS request_types ON dbo.REQUESTS.REQUEST_TYPE_ID = request_types.LOOKUP_ID LEFT OUTER JOIN
                      dbo.PROJECTS_V ON dbo.REQUESTS.PROJECT_ID = dbo.PROJECTS_V.PROJECT_ID
GO
/****** Object:  View [dbo].[JOBS_OVERVIEW_V]    Script Date: 05/03/2010 14:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[JOBS_OVERVIEW_V]
AS
SELECT     dbo.JOBS_V.ORGANIZATION_ID, dbo.JOBS_V.JOB_ID, dbo.JOBS_V.job_type_name, dbo.JOBS_V.JOB_NO, dbo.JOBS_V.DEALER_NAME, 
                      dbo.JOBS_V.CUSTOMER_NAME, dbo.JOBS_V.JOB_NAME, dbo.SERVICES.SERVICE_ID, dbo.SERVICES.SERVICE_NO, 
                      dbo.SERVICES.EST_START_DATE, ISNULL(dbo.SERVICES.LOC_VAL_FLAG, 'N') AS loc_val_flag, ISNULL(dbo.SERVICES.PROD_VAL_FLAG, 'N') 
                      AS prod_val_flag, ISNULL(dbo.SERVICES.SCH_VAL_FLAG, 'N') AS sch_val_flag, ISNULL(dbo.SERVICES.TASK_VAL_FLAG, 'N') AS task_val_flag, 
                      ISNULL(dbo.SERVICES.BILL_VAL_FLAG, 'N') AS bill_val_flag, dbo.JOBS_V.JOB_STATUS_TYPE_ID, dbo.JOBS_V.job_status_type_code, 
                      dbo.JOBS_V.job_status_type_name, dbo.SERVICES.SERV_STATUS_TYPE_ID, dbo.LOOKUPS.CODE AS serv_status_type_code, 
                      dbo.LOOKUPS.NAME AS serv_status_type_name, dbo.SERVICES.HEAD_VAL_FLAG, dbo.SERVICES.LOC_VAL_FLAG AS Expr1, 
                      dbo.SERVICES.PROD_VAL_FLAG AS Expr2, dbo.SERVICES.SCH_VAL_FLAG AS Expr3, dbo.SERVICES.RES_VAL_FLAG, 
                      dbo.SERVICES.TASK_VAL_FLAG AS Expr4, dbo.SERVICES.CUST_VAL_FLAG, dbo.SERVICES.PO_NO
FROM         dbo.LOOKUPS RIGHT OUTER JOIN
                      dbo.SERVICES ON dbo.LOOKUPS.LOOKUP_ID = dbo.SERVICES.SERV_STATUS_TYPE_ID RIGHT OUTER JOIN
                      dbo.JOBS_V ON dbo.SERVICES.JOB_ID = dbo.JOBS_V.JOB_ID
GO
/****** Object:  View [dbo].[REQUESTS_V_jerry]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[REQUESTS_V_jerry]
AS
SELECT     dbo.REQUESTS.REQUEST_ID, dbo.REQUESTS.PROJECT_ID, dbo.REQUESTS.REQUEST_NO, dbo.REQUESTS.REQUEST_TYPE_ID, 
                      dbo.REQUESTS.REQUEST_STATUS_TYPE_ID, dbo.REQUESTS.IS_SENT, dbo.REQUESTS.IS_QUOTED, dbo.REQUESTS.QUOTE_REQUEST_ID, 
                      dbo.REQUESTS.EST_START_DATE, dbo.LOOKUPS.NAME, dbo.QUOTES.quote_total
FROM         dbo.REQUESTS INNER JOIN
                      dbo.LOOKUPS ON dbo.REQUESTS.REQUEST_TYPE_ID = dbo.LOOKUPS.LOOKUP_ID INNER JOIN
                      dbo.QUOTES ON dbo.REQUESTS.REQUEST_ID = dbo.QUOTES.request_id
WHERE     (dbo.REQUESTS.EST_START_DATE > CONVERT(DATETIME, '2007-12-31 00:00:00', 102))
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[10] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "REQUESTS"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 224
               Right = 396
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "LOOKUPS"
            Begin Extent = 
               Top = 8
               Left = 548
               Bottom = 116
               Right = 730
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "QUOTES"
            Begin Extent = 
               Top = 143
               Left = 508
               Bottom = 251
               Right = 789
            End
            DisplayFlags = 280
            TopColumn = 12
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 11
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 2895
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'REQUESTS_V_jerry'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'REQUESTS_V_jerry'
GO
/****** Object:  View [dbo].[JOB_ITEM_RATES_V]    Script Date: 05/03/2010 14:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[JOB_ITEM_RATES_V]
AS
SELECT     dbo.ITEMS_V.ORGANIZATION_ID, dbo.JOB_ITEM_RATES.JOB_ITEM_RATE_ID, dbo.JOB_ITEM_RATES.JOB_ID, dbo.JOB_ITEM_RATES.ITEM_ID, 
                      dbo.ITEMS_V.NAME AS item_name, dbo.ITEMS_V.ITEM_TYPE_ID, dbo.ITEMS_V.item_type_code, dbo.ITEMS_V.item_type_name, 
                      dbo.ITEMS_V.ITEM_STATUS_TYPE_ID, dbo.ITEMS_V.item_status_type_code, dbo.JOB_ITEM_RATES.RATE, dbo.JOB_ITEM_RATES.EXT_RATE_ID, 
                      dbo.JOB_ITEM_RATES.UOM_TYPE_ID, dbo.LOOKUPS.CODE AS uom_type_code, dbo.LOOKUPS.NAME AS uom_type_name, 
                      dbo.JOB_ITEM_RATES.EXT_UOM_NAME, dbo.ITEMS_V.BILLABLE_FLAG, dbo.ITEMS_V.EXPENSE_EXPORT_CODE, 
                      dbo.JOB_ITEM_RATES.DATE_CREATED, dbo.JOB_ITEM_RATES.CREATED_BY, 
                      CREATED_BY.FIRST_NAME + ' ' + CREATED_BY.LAST_NAME AS created_by_name, dbo.JOB_ITEM_RATES.DATE_MODIFIED, 
                      dbo.JOB_ITEM_RATES.MODIFIED_BY, MODIFIED_BY.FIRST_NAME + ' ' + MODIFIED_BY.LAST_NAME AS modified_by_name
FROM         dbo.ITEMS_V RIGHT OUTER JOIN
                      dbo.USERS CREATED_BY RIGHT OUTER JOIN
                      dbo.JOB_ITEM_RATES LEFT OUTER JOIN
                      dbo.USERS MODIFIED_BY ON dbo.JOB_ITEM_RATES.DATE_MODIFIED = MODIFIED_BY.USER_ID ON 
                      CREATED_BY.USER_ID = dbo.JOB_ITEM_RATES.DATE_CREATED LEFT OUTER JOIN
                      dbo.LOOKUPS ON dbo.JOB_ITEM_RATES.UOM_TYPE_ID = dbo.LOOKUPS.LOOKUP_ID ON dbo.ITEMS_V.ITEM_ID = dbo.JOB_ITEM_RATES.ITEM_ID
GO
/****** Object:  View [dbo].[crystal_JOBS_COMPLETED_V]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[crystal_JOBS_COMPLETED_V]
AS
SELECT     dbo.PROJECTS_V.ORGANIZATION_ID, dbo.PROJECTS_V.PROJECT_ID, dbo.PROJECTS_V.PROJECT_NO, dbo.PROJECTS_V.CUSTOMER_NAME, 
                      dbo.PROJECTS_V.JOB_NAME, dbo.PROJECTS_V.project_status_type_name, dbo.PROJECTS_V.project_status_type_code, 
                      dbo.JOBS.JOB_STATUS_TYPE_ID, JOB_STATUS_TYPE.CODE AS job_status_type_code, JOB_STATUS_TYPE.NAME AS job_status_type_name, 
                      MIN(dbo.SERVICES.EST_START_DATE) AS min_start_date, MAX(dbo.SERVICES.EST_END_DATE) AS max_end_date, 
                      dbo.PROJECTS_V.PERCENT_COMPLETE, COUNT(dbo.PUNCHLISTS.PUNCHLIST_ID) AS punchlist_count, dbo.PROJECTS_V.EXT_DEALER_ID, 
                      dbo.PROJECTS_V.DEALER_NAME, dbo.REQUESTS.CUSTOMER_CONTACT_ID, dbo.CONTACTS.CONTACT_ID, dbo.CONTACTS.CONTACT_NAME, 
                      dbo.CONTACTS.PHONE_WORK, dbo.REQUESTS.DEALER_PO_NO
FROM         dbo.REQUESTS INNER JOIN
                      dbo.CONTACTS ON dbo.REQUESTS.CUSTOMER_CONTACT_ID = dbo.CONTACTS.CONTACT_ID FULL OUTER JOIN
                      dbo.SERVICES ON dbo.REQUESTS.REQUEST_ID = dbo.SERVICES.REQUEST_ID FULL OUTER JOIN
                      dbo.PUNCHLISTS RIGHT OUTER JOIN
                      dbo.PROJECTS_V ON dbo.PUNCHLISTS.PROJECT_ID = dbo.PROJECTS_V.PROJECT_ID LEFT OUTER JOIN
                      dbo.JOBS LEFT OUTER JOIN
                      dbo.LOOKUPS JOB_STATUS_TYPE ON dbo.JOBS.JOB_STATUS_TYPE_ID = JOB_STATUS_TYPE.LOOKUP_ID ON 
                      dbo.PROJECTS_V.PROJECT_ID = dbo.JOBS.PROJECT_ID ON dbo.SERVICES.JOB_ID = dbo.JOBS.JOB_ID
GROUP BY dbo.PROJECTS_V.PROJECT_ID, dbo.JOBS.JOB_STATUS_TYPE_ID, dbo.PROJECTS_V.PROJECT_NO, dbo.PROJECTS_V.CUSTOMER_NAME, 
                      dbo.PROJECTS_V.JOB_NAME, dbo.PROJECTS_V.project_status_type_name, dbo.PROJECTS_V.project_status_type_code, JOB_STATUS_TYPE.CODE, 
                      JOB_STATUS_TYPE.NAME, dbo.PROJECTS_V.PERCENT_COMPLETE, dbo.PROJECTS_V.ORGANIZATION_ID, dbo.PROJECTS_V.EXT_DEALER_ID, 
                      dbo.PROJECTS_V.DEALER_NAME, dbo.REQUESTS.CUSTOMER_CONTACT_ID, dbo.CONTACTS.CONTACT_ID, dbo.CONTACTS.CONTACT_NAME, 
                      dbo.CONTACTS.PHONE_WORK, dbo.REQUESTS.DEALER_PO_NO
HAVING      (dbo.PROJECTS_V.ORGANIZATION_ID = 4) AND (dbo.JOBS.JOB_STATUS_TYPE_ID = 113) OR
                      (dbo.JOBS.JOB_STATUS_TYPE_ID = 120)
GO
/****** Object:  View [dbo].[VAR_JOB_EST_HOURS_V]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[VAR_JOB_EST_HOURS_V]
AS
SELECT     dbo.JOBS.JOB_ID, SUM(cast(ISNULL(dbo.RESOURCE_ESTIMATES.TOTAL_HOURS,0.0) as decimal)) AS sum_estimated_hours
FROM         dbo.JOBS LEFT OUTER JOIN
                      dbo.RESOURCE_ESTIMATES ON dbo.JOBS.JOB_ID = dbo.RESOURCE_ESTIMATES.JOB_ID LEFT OUTER JOIN
                      dbo.ITEMS ITEMS_2 LEFT OUTER JOIN
                      dbo.LOOKUPS ITEM_TYPE ON ITEMS_2.ITEM_TYPE_ID = ITEM_TYPE.LOOKUP_ID RIGHT OUTER JOIN
                      dbo.JOB_ITEM_RATES ON ITEMS_2.ITEM_ID = dbo.JOB_ITEM_RATES.ITEM_ID ON 
                      dbo.RESOURCE_ESTIMATES.JOB_ITEM_RATE_ID = dbo.JOB_ITEM_RATES.JOB_ITEM_RATE_ID
GROUP BY dbo.JOBS.JOB_ID
GO
/****** Object:  View [dbo].[GP_ECMS_ITEM_PAYCODES_V]    Script Date: 05/03/2010 14:18:07 ******/
-- SET ANSI_NULLS ON
-- GO
-- SET QUOTED_IDENTIFIER ON
-- GO
-- CREATE VIEW [dbo].[GP_ECMS_ITEM_PAYCODES_V]
-- AS
-- SELECT     ITEM_ID, item_name, pay_code, defaulted
-- FROM         (SELECT     GP_PAYCODES.PAYRCORD AS pay_code, dbo.ITEMS.NAME AS item_name, dbo.ITEMS.ITEM_ID, 'f' AS defaulted
--                        FROM          dbo.LOOKUPS ITEM_TYPES INNER JOIN
--                                               dbo.ITEMS ON ITEM_TYPES.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID INNER JOIN
--                                               dbo.GP_ECMS_PAY_CODE_V GP_PAYCODES ON RIGHT(dbo.ITEMS.NAME, CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) - 1)
--                                               = RIGHT(GP_PAYCODES.DSCRIPTN, CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) - 1)
--                        WHERE      (CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) > 0) AND (CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) > 0) AND
--                                               (ITEM_TYPES.CODE = 'hours')
--                        UNION
--                        SELECT     '1' AS pay_code, dbo.ITEMS.NAME AS item_name, dbo.ITEMS.ITEM_ID, 't' AS defaulted
--                        FROM         dbo.ITEMS INNER JOIN
--                                              dbo.LOOKUPS item_types ON dbo.ITEMS.ITEM_TYPE_ID = item_types.LOOKUP_ID
--                        WHERE     (item_types.CODE = 'hours') AND (dbo.ITEMS.ITEM_ID NOT IN
--                                                  (SELECT     dbo.ITEMS.ITEM_ID
--                                                    FROM          dbo.LOOKUPS ITEM_TYPES INNER JOIN
--                                                                           dbo.ITEMS ON ITEM_TYPES.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID INNER JOIN
--                                                                           dbo.GP_ECMS_PAY_CODE_V GP_PAYCODES ON RIGHT(dbo.ITEMS.NAME, CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) - 1) 
--                                                                           = RIGHT(GP_PAYCODES.DSCRIPTN, CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) - 1)
--                                                    WHERE      (CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) > 0) AND (CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) > 0) AND
--                                                                           (ITEM_TYPES.CODE = 'hours')))) DERIVEDTBL
-- GO
/****** Object:  View [dbo].[crystal_JOBS_CLOSED_V]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[crystal_JOBS_CLOSED_V]
AS
SELECT     TOP 100 PERCENT dbo.JOBS.JOB_ID, dbo.JOBS.PROJECT_ID, dbo.JOBS.JOB_NO, dbo.JOBS.JOB_NAME, dbo.JOBS.JOB_TYPE_ID, 
                      dbo.JOBS.JOB_STATUS_TYPE_ID, dbo.JOBS.CUSTOMER_ID, dbo.CUSTOMERS.ORGANIZATION_ID, dbo.CUSTOMERS.DEALER_NAME, 
                      dbo.CUSTOMERS.CUSTOMER_NAME, dbo.LOOKUPS.NAME
FROM         dbo.JOBS INNER JOIN
                      dbo.CUSTOMERS ON dbo.JOBS.CUSTOMER_ID = dbo.CUSTOMERS.CUSTOMER_ID INNER JOIN
                      dbo.LOOKUPS ON dbo.JOBS.JOB_STATUS_TYPE_ID = dbo.LOOKUPS.LOOKUP_ID
WHERE     (dbo.CUSTOMERS.ORGANIZATION_ID = 11) AND (dbo.JOBS.JOB_STATUS_TYPE_ID = 115)
ORDER BY dbo.JOBS.JOB_NO
GO
/****** Object:  View [dbo].[tcn_resource_items_v]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[tcn_resource_items_v]
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
GO
/****** Object:  View [dbo].[EXTRANET_REQ_V]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[EXTRANET_REQ_V]
AS
SELECT     dbo.SERVICES.SERVICE_ID, w.REQUEST_ID, dbo.LOOKUPS.CODE request_type_code
FROM         dbo.REQUESTS w INNER JOIN
                      dbo.LOOKUPS ON w.REQUEST_TYPE_ID = dbo.LOOKUPS.LOOKUP_ID INNER JOIN
                      dbo.VERSIONS_MAX_NO_V ON w.PROJECT_ID = dbo.VERSIONS_MAX_NO_V.PROJECT_ID AND 
                      w.REQUEST_NO = dbo.VERSIONS_MAX_NO_V.REQUEST_NO AND w.VERSION_NO = dbo.VERSIONS_MAX_NO_V.max_version_no INNER JOIN
                      dbo.SERVICES ON w.REQUEST_ID = dbo.SERVICES.REQUEST_ID
GO
/****** Object:  View [dbo].[GP_MDWST_ITEM_PAYCODES_V]    Script Date: 05/03/2010 14:18:07 ******/
-- SET ANSI_NULLS ON
-- GO
-- SET QUOTED_IDENTIFIER ON
-- GO
-- CREATE VIEW [dbo].[GP_MDWST_ITEM_PAYCODES_V]
-- AS
-- SELECT     ITEM_ID, item_name, pay_code, defaulted
-- FROM         (SELECT     GP_PAYCODES.PAYRCORD AS pay_code, dbo.ITEMS.NAME AS item_name, dbo.ITEMS.ITEM_ID, 'f' AS defaulted
--                        FROM          dbo.LOOKUPS ITEM_TYPES INNER JOIN
--                                               dbo.ITEMS ON ITEM_TYPES.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID INNER JOIN
--                                               dbo.GP_MDWST_PAY_CODE_V GP_PAYCODES ON RIGHT(dbo.ITEMS.NAME, CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) - 1)
--                                               = RIGHT(GP_PAYCODES.DSCRIPTN, CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) - 1)
--                        WHERE      (CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) > 0) AND (CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) > 0) AND
--                                               (ITEM_TYPES.CODE = 'hours') AND organization_id = 6
--                        UNION
--                        SELECT     '1' AS pay_code, dbo.ITEMS.NAME AS item_name, dbo.ITEMS.ITEM_ID, 't' AS defaulted
--                        FROM         dbo.ITEMS INNER JOIN
--                                              dbo.LOOKUPS item_types ON dbo.ITEMS.ITEM_TYPE_ID = item_types.LOOKUP_ID
--                        WHERE     (item_types.CODE = 'hours') AND (dbo.ITEMS.ITEM_ID NOT IN
--                                                  (SELECT     dbo.ITEMS.ITEM_ID
--                                                    FROM          dbo.LOOKUPS ITEM_TYPES INNER JOIN
--                                                                           dbo.ITEMS ON ITEM_TYPES.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID INNER JOIN
--                                                                           dbo.[dbo].[INVOICE_COST_CODES_PROBLEMS_V]GP_PAYCODES ON RIGHT(dbo.ITEMS.NAME, CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) - 1)
--                                                                           = RIGHT(GP_PAYCODES.DSCRIPTN, CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) - 1)
--                                                    WHERE      (CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) > 0) AND (CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) > 0) AND
--                                                                           (ITEM_TYPES.CODE = 'hours') AND dbo.items.organization_id = 6))) DERIVEDTBL
-- GO
/****** Object:  View [dbo].[REQUEST_SCHEDULE_DIFF_V]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[REQUEST_SCHEDULE_DIFF_V]
AS
SELECT     requests_a.REQUEST_ID, requests_b.REQUEST_ID AS REQUEST_ID_B, ISNULL(requests_a.SCHEDULE_TYPE_ID, - 1) AS SCHEDULE_TYPE_ID, 
		ISNULL(requests_b.SCHEDULE_TYPE_ID, - 1) AS SCHEDULE_TYPE_ID_B, ISNULL(schedule_types.NAME, 'None') AS schedule_type_name, 
		ISNULL(schedule_types_b.NAME, 'None') AS schedule_type_name_b, ISNULL(CONVERT(VARCHAR(12), requests_a.EST_START_DATE, 101), - 1) 
		AS EST_START_DATE, ISNULL(CONVERT(VARCHAR(12), requests_b.EST_START_DATE, 101), - 1) AS EST_START_DATE_B, 
		ISNULL(CONVERT(VARCHAR(17), requests_a.EST_START_TIME, 113), - 1) AS EST_START_TIME, ISNULL(CONVERT(VARCHAR(17), 
		requests_b.EST_START_TIME, 113), - 1) AS EST_START_TIME_B, ISNULL(CONVERT(VARCHAR(12), requests_a.EST_END_DATE, 101), - 1) 
		AS EST_END_DATE, ISNULL(CONVERT(VARCHAR(12), requests_b.EST_END_DATE, 101), - 1) AS EST_END_DATE_B, ISNULL(requests_a.DESCRIPTION,
		'None') AS DESCRIPTION, ISNULL(requests_b.DESCRIPTION, 'None') AS DESCRIPTION_B, ISNULL(requests_a.OTHER_CONDITIONS, 'None') 
		AS OTHER_CONDITIONS, ISNULL(requests_b.OTHER_CONDITIONS, 'None') AS OTHER_CONDITIONS_B, 
		ISNULL(requests_a.CUST_CONTACT_MOD_DATE, - 1) AS CUST_CONTACT_MOD_DATE, ISNULL(requests_b.CUST_CONTACT_MOD_DATE, - 1) 
		AS CUST_CONTACT_MOD_DATE_B, ISNULL(requests_a.JOB_LOCATION_MOD_DATE, - 1) AS JOB_LOCATION_MOD_DATE, 
		ISNULL(requests_b.JOB_LOCATION_MOD_DATE, - 1) AS JOB_LOCATION_MOD_DATE_B, ISNULL(job_locations_b.JOB_LOCATION_NAME, 'None') 
		AS JOB_LOCATION_NAME_B, ISNULL(job_locations_b.STREET1, 'None') AS STREET1_B, ISNULL(job_locations_b.STREET2, 'None') AS STREET2_B, 
		ISNULL(job_locations_b.STREET3, 'None') AS STREET3_B, ISNULL(job_locations_b.CITY, 'None') AS CITY_B, ISNULL(job_locations_b.STATE, 'None') 
		AS STATE_B, ISNULL(job_locations_b.ZIP, 'None') AS ZIP_B, ISNULL(contacts_b.CONTACT_NAME, 'None') AS CONTACT_NAME_B, 
		ISNULL(contacts_b.PHONE_WORK, 'None') AS PHONE_WORK_B, ISNULL(contacts_b.PHONE_CELL, 'None') AS PHONE_CELL_B, 
		LOOKUPS_1.CODE AS request_type_code
FROM         dbo.LOOKUPS schedule_types INNER JOIN dbo.PROJECTS
		RIGHT OUTER JOIN dbo.REQUESTS requests_a
		INNER JOIN dbo.REQUESTS requests_b
		ON requests_a.PROJECT_ID = requests_b.PROJECT_ID
		AND requests_a.REQUEST_NO = requests_b.REQUEST_NO
		INNER JOIN dbo.LOOKUPS LOOKUPS_1
		ON requests_b.REQUEST_TYPE_ID = LOOKUPS_1.LOOKUP_ID
		ON dbo.PROJECTS.PROJECT_ID = requests_b.PROJECT_ID
		LEFT OUTER JOIN dbo.LOOKUPS schedule_types_b
		ON requests_b.SCHEDULE_TYPE_ID = schedule_types_b.LOOKUP_ID
		ON schedule_types.LOOKUP_ID = requests_a.SCHEDULE_TYPE_ID
		LEFT OUTER JOIN dbo.CONTACTS contacts_b
		ON requests_b.CUSTOMER_CONTACT_ID = contacts_b.CONTACT_ID
		LEFT OUTER JOIN dbo.JOB_LOCATIONS job_locations_b
		ON requests_b.JOB_LOCATION_ID = job_locations_b.JOB_LOCATION_ID
WHERE      (LOOKUPS_1.CODE = 'workorder')
		OR (LOOKUPS_1.CODE = 'service_request')
GO
/****** Object:  View [dbo].[SCH_JOBS_REPORT_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[SCH_JOBS_REPORT_V]
AS
SELECT     dbo.PROJECTS_V.ORGANIZATION_ID, dbo.PROJECTS_V.PROJECT_ID, dbo.PROJECTS_V.PROJECT_NO, dbo.PROJECTS_V.JOB_NAME, 
                      dbo.PROJECTS_V.project_status_type_name, dbo.JOBS.JOB_STATUS_TYPE_ID, JOB_STATUS_TYPE.CODE AS job_status_type_code, 
                      JOB_STATUS_TYPE.NAME AS job_status_type_name, dbo.JOBS.JOB_NO, dbo.SERVICES.SERVICE_NO, dbo.REQUESTS.DEALER_PO_NO, 
                      dbo.PROJECTS_V.CUSTOMER_NAME, dbo.REQUESTS.DESCRIPTION, CONTACTS_1.CONTACT_NAME AS sales_rep_name, 
                      CONTACTS_2.CONTACT_NAME AS sales_sup_name, CONTACTS_3.CONTACT_NAME AS project_mgr_name, 
                      CONTACTS_4.CONTACT_NAME AS a_m_name, MIN(dbo.REQUESTS.EST_START_DATE) AS job_start_date, MAX(dbo.REQUESTS.EST_END_DATE) 
                      AS job_end_date
FROM         dbo.LOOKUPS JOB_STATUS_TYPE RIGHT OUTER JOIN
                      dbo.CONTACTS CONTACTS_1 RIGHT OUTER JOIN
                      dbo.CONTACTS CONTACTS_2 RIGHT OUTER JOIN
                      dbo.CONTACTS CONTACTS_3 RIGHT OUTER JOIN
                      dbo.CONTACTS CONTACTS_4 RIGHT OUTER JOIN
                      dbo.REQUESTS ON CONTACTS_4.CONTACT_ID = dbo.REQUESTS.A_M_CONTACT_ID ON 
                      CONTACTS_3.CONTACT_ID = dbo.REQUESTS.D_PROJ_MGR_CONTACT_ID ON 
                      CONTACTS_2.CONTACT_ID = dbo.REQUESTS.D_SALES_SUP_CONTACT_ID ON 
                      CONTACTS_1.CONTACT_ID = dbo.REQUESTS.D_SALES_REP_CONTACT_ID RIGHT OUTER JOIN
                      dbo.JOBS RIGHT OUTER JOIN
                      dbo.SERVICES ON dbo.JOBS.JOB_ID = dbo.SERVICES.JOB_ID ON dbo.REQUESTS.REQUEST_ID = dbo.SERVICES.REQUEST_ID ON 
                      JOB_STATUS_TYPE.LOOKUP_ID = dbo.JOBS.JOB_STATUS_TYPE_ID RIGHT OUTER JOIN
                      dbo.PROJECTS_V ON dbo.JOBS.PROJECT_ID = dbo.PROJECTS_V.PROJECT_ID
GROUP BY dbo.PROJECTS_V.PROJECT_ID, dbo.JOBS.JOB_STATUS_TYPE_ID, dbo.PROJECTS_V.PROJECT_NO, dbo.PROJECTS_V.CUSTOMER_NAME, 
                      dbo.PROJECTS_V.JOB_NAME, dbo.PROJECTS_V.project_status_type_name, JOB_STATUS_TYPE.CODE, JOB_STATUS_TYPE.NAME, 
                      dbo.PROJECTS_V.ORGANIZATION_ID, dbo.JOBS.JOB_NO, dbo.SERVICES.SERVICE_NO, dbo.REQUESTS.DEALER_PO_NO, 
                      dbo.REQUESTS.DESCRIPTION, CONTACTS_1.CONTACT_NAME, CONTACTS_2.CONTACT_NAME, CONTACTS_3.CONTACT_NAME, 
                      CONTACTS_4.CONTACT_NAME
GO
/****** Object:  View [dbo].[GP_CILLC_ITEM_PAYCODES_V]    Script Date: 05/03/2010 14:18:07 ******/
-- SET ANSI_NULLS ON
-- GO
-- SET QUOTED_IDENTIFIER ON
-- GO
-- CREATE VIEW [dbo].[GP_CILLC_ITEM_PAYCODES_V] AS
-- SELECT ITEM_ID, item_name, pay_code, defaulted
--   FROM (SELECT GP_PAYCODES.PAYRCORD AS pay_code, dbo.ITEMS.NAME AS item_name, dbo.ITEMS.ITEM_ID, 'f' AS defaulted
--           FROM dbo.LOOKUPS ITEM_TYPES INNER JOIN dbo.ITEMS ON ITEM_TYPES.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID
--                                       INNER JOIN dbo.GP_MPLS_PAY_CODE_V GP_PAYCODES ON RIGHT(dbo.ITEMS.NAME, CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) - 1)
--                                               = RIGHT(GP_PAYCODES.DSCRIPTN, CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) - 1)
--          WHERE (CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) > 0) AND (CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) > 0) AND (ITEM_TYPES.CODE = 'hours')
--        UNION
--         SELECT '1' AS pay_code, dbo.ITEMS.NAME AS item_name, dbo.ITEMS.ITEM_ID, 't' AS defaulted
--           FROM dbo.ITEMS INNER JOIN dbo.LOOKUPS item_types ON dbo.ITEMS.ITEM_TYPE_ID = item_types.LOOKUP_ID
--          WHERE (item_types.CODE = 'hours')
--            AND (dbo.ITEMS.ITEM_ID NOT IN (SELECT dbo.ITEMS.ITEM_ID
--                                             FROM dbo.LOOKUPS ITEM_TYPES INNER JOIN dbo.ITEMS ON ITEM_TYPES.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID
--                                                                         INNER JOIN dbo.GP_MPLS_PAY_CODE_V GP_PAYCODES ON RIGHT(dbo.ITEMS.NAME, CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) - 1)
--                                                                           = RIGHT(GP_PAYCODES.DSCRIPTN, CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) - 1)
--                                            WHERE (CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) > 0) AND (CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) > 0)
--                                              AND (ITEM_TYPES.CODE = 'hours')))
--            AND RIGHT(dbo.ITEMS.NAME, CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) - 1) <> 'DT'
--        UNION
--         SELECT '16' AS pay_code, dbo.ITEMS.NAME AS item_name, dbo.ITEMS.ITEM_ID, 't' AS defaulted
--           FROM dbo.ITEMS INNER JOIN dbo.LOOKUPS item_types ON dbo.ITEMS.ITEM_TYPE_ID = item_types.LOOKUP_ID
--          WHERE (item_types.CODE = 'hours')
--            AND (dbo.ITEMS.ITEM_ID NOT IN (SELECT dbo.ITEMS.ITEM_ID
--                                             FROM dbo.LOOKUPS ITEM_TYPES INNER JOIN dbo.ITEMS ON ITEM_TYPES.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID
--                                                                         INNER JOIN dbo.GP_MPLS_PAY_CODE_V GP_PAYCODES ON RIGHT(dbo.ITEMS.NAME, CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) - 1)
--                                                                           = RIGHT(GP_PAYCODES.DSCRIPTN, CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) - 1)
--                                            WHERE (CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) > 0) AND (CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) > 0)
--                                              AND (ITEM_TYPES.CODE = 'hours')))
--            AND RIGHT(dbo.ITEMS.NAME, CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) - 1) = 'DT'
--         ) DERIVEDTBL
-- GO
/****** Object:  View [dbo].[SERVICE_CUSTOM_COLS_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[SERVICE_CUSTOM_COLS_V]
AS
SELECT     dbo.SERVICES.JOB_ID, dbo.SERVICES.SERVICE_ID, dbo.SERVICES.CUST_COL_1 AS col1_value, CUSTOM_COL_LISTS_1.LIST_VALUE AS col1_lookup, 
                      dbo.SERVICES.CUST_COL_2 AS col2_value, CUSTOM_COL_LISTS_2.LIST_VALUE AS col2_lookup, dbo.SERVICES.CUST_COL_3 AS col3_value, 
                      CUSTOM_COL_LISTS_3.LIST_VALUE AS col3_lookup, dbo.SERVICES.CUST_COL_4 AS col4_value, 
                      CUSTOM_COL_LISTS_4.LIST_VALUE AS col4_lookup, dbo.SERVICES.CUST_COL_5 AS col5_value, 
                      CUSTOM_COL_LISTS_5.LIST_VALUE AS col5_lookup, dbo.SERVICES.CUST_COL_6 AS col6_value, 
                      CUSTOM_COL_LISTS_6.LIST_VALUE AS col6_lookup, dbo.SERVICES.CUST_COL_7 AS col7_value, 
                      CUSTOM_COL_LISTS_7.LIST_VALUE AS col7_lookup, dbo.SERVICES.CUST_COL_8 AS col8_value, 
                      CUSTOM_COL_LISTS_8.LIST_VALUE AS col8_lookup, dbo.SERVICES.CUST_COL_9 AS col9_value, 
                      CUSTOM_COL_LISTS_9.LIST_VALUE AS col9_lookup, dbo.SERVICES.CUST_COL_10 AS col10_value, 
                      CUSTOM_COL_LISTS_10.LIST_VALUE AS col10_lookup
FROM         dbo.SERVICES INNER JOIN
                      dbo.JOBS ON dbo.SERVICES.JOB_ID = dbo.JOBS.JOB_ID LEFT OUTER JOIN
                      dbo.CUSTOM_COL_LISTS CUSTOM_COL_LISTS_10 ON 
                      dbo.SERVICES.CUST_COL_10 = CAST(CUSTOM_COL_LISTS_10.CUSTOM_COL_LIST_ID AS varchar) LEFT OUTER JOIN
                      dbo.CUSTOM_COL_LISTS CUSTOM_COL_LISTS_9 ON dbo.SERVICES.CUST_COL_9 = CAST(CUSTOM_COL_LISTS_9.CUSTOM_COL_LIST_ID AS varchar)
                       LEFT OUTER JOIN
                      dbo.CUSTOM_COL_LISTS CUSTOM_COL_LISTS_8 ON dbo.SERVICES.CUST_COL_8 = CAST(CUSTOM_COL_LISTS_8.CUSTOM_COL_LIST_ID AS varchar)
                       LEFT OUTER JOIN
                      dbo.CUSTOM_COL_LISTS CUSTOM_COL_LISTS_7 ON dbo.SERVICES.CUST_COL_7 = CAST(CUSTOM_COL_LISTS_7.CUSTOM_COL_LIST_ID AS varchar)
                       LEFT OUTER JOIN
                      dbo.CUSTOM_COL_LISTS CUSTOM_COL_LISTS_6 ON dbo.SERVICES.CUST_COL_6 = CAST(CUSTOM_COL_LISTS_6.CUSTOM_COL_LIST_ID AS varchar)
                       LEFT OUTER JOIN
                      dbo.CUSTOM_COL_LISTS CUSTOM_COL_LISTS_5 ON dbo.SERVICES.CUST_COL_5 = CAST(CUSTOM_COL_LISTS_5.CUSTOM_COL_LIST_ID AS varchar)
                       LEFT OUTER JOIN
                      dbo.CUSTOM_COL_LISTS CUSTOM_COL_LISTS_4 ON dbo.SERVICES.CUST_COL_4 = CAST(CUSTOM_COL_LISTS_4.CUSTOM_COL_LIST_ID AS varchar)
                       LEFT OUTER JOIN
                      dbo.CUSTOM_COL_LISTS CUSTOM_COL_LISTS_3 ON dbo.SERVICES.CUST_COL_3 = CAST(CUSTOM_COL_LISTS_3.CUSTOM_COL_LIST_ID AS varchar)
                       LEFT OUTER JOIN
                      dbo.CUSTOM_COL_LISTS CUSTOM_COL_LISTS_2 ON dbo.SERVICES.CUST_COL_2 = CAST(CUSTOM_COL_LISTS_2.CUSTOM_COL_LIST_ID AS varchar)
                       LEFT OUTER JOIN
                      dbo.CUSTOM_COL_LISTS CUSTOM_COL_LISTS_1 ON dbo.SERVICES.CUST_COL_1 = CAST(CUSTOM_COL_LISTS_1.CUSTOM_COL_LIST_ID AS varchar)
GO
/****** Object:  View [dbo].[RESOURCE_TYPE_ITEMS_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[RESOURCE_TYPE_ITEMS_V]
AS
SELECT     dbo.ITEMS_V.ORGANIZATION_ID, dbo.RESOURCE_TYPE_ITEMS.RES_TYPE_ITEM_ID, dbo.RESOURCE_TYPES.RESOURCE_TYPE_ID, 
                      dbo.RESOURCE_TYPES.NAME AS resource_type_name, dbo.RESOURCE_TYPE_ITEMS.ITEM_ID, 
                      dbo.RESOURCE_TYPE_ITEMS.DEFAULT_ITEM_FLAG, dbo.ITEMS_V.NAME AS item_name, dbo.ITEMS_V.DESCRIPTION AS item_desc, 
                      dbo.ITEMS_V.EXT_ITEM_ID, dbo.ITEMS_V.ITEM_TYPE_ID, dbo.ITEMS_V.item_type_name, dbo.ITEMS_V.item_type_code, 
                      dbo.ITEMS_V.ITEM_STATUS_TYPE_ID, dbo.ITEMS_V.item_status_type_code, dbo.ITEMS_V.item_status_type_name, dbo.ITEMS_V.BILLABLE_FLAG, 
                      dbo.RESOURCE_TYPE_ITEMS.DATE_CREATED, dbo.RESOURCE_TYPE_ITEMS.CREATED_BY, 
                      USERS_1.FIRST_NAME + ' ' + USERS_1.LAST_NAME AS created_by_name, dbo.RESOURCE_TYPE_ITEMS.DATE_MODIFIED, 
                      dbo.RESOURCE_TYPE_ITEMS.MODIFIED_BY, USERS_2.FIRST_NAME + ' ' + USERS_2.LAST_NAME AS modified_by_name
FROM         dbo.ITEMS_V RIGHT OUTER JOIN
                      dbo.USERS USERS_2 RIGHT OUTER JOIN
                      dbo.RESOURCE_TYPE_ITEMS RIGHT OUTER JOIN
                      dbo.RESOURCE_TYPES ON dbo.RESOURCE_TYPE_ITEMS.RESOURCE_TYPE_ID = dbo.RESOURCE_TYPES.RESOURCE_TYPE_ID ON 
                      USERS_2.USER_ID = dbo.RESOURCE_TYPE_ITEMS.MODIFIED_BY LEFT OUTER JOIN
                      dbo.USERS USERS_1 ON dbo.RESOURCE_TYPE_ITEMS.CREATED_BY = USERS_1.USER_ID ON 
                      dbo.ITEMS_V.ITEM_ID = dbo.RESOURCE_TYPE_ITEMS.ITEM_ID
GO
/****** Object:  View [dbo].[PDA_TIME_V]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[PDA_TIME_V] 
AS 
SELECT     dbo.SERVICE_LINE_STATUSES.CODE, dbo.SERVICE_LINES.CREATED_BY AS ims_user_id, dbo.SERVICE_LINES.ENTRY_METHOD, 

                      dbo.SERVICE_LINES.PALM_REP_ID AS rep_id 
FROM         dbo.SERVICE_LINES INNER JOIN 
                      dbo.SERVICE_LINE_STATUSES ON dbo.SERVICE_LINES.STATUS_ID = dbo.SERVICE_LINE_STATUSES.STATUS_ID 
WHERE     (dbo.SERVICE_LINES.ENTRY_METHOD = 'pda') AND (dbo.SERVICE_LINE_STATUSES.CODE = 'new')
GO
/****** Object:  View [dbo].[SERVICE_LINE_STATUSES_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[SERVICE_LINE_STATUSES_V]
AS
SELECT     STATUS_ID, CODE, NAME
FROM         dbo.SERVICE_LINE_STATUSES
GO
/****** Object:  View [dbo].[QUOTE_CONDITIONS_V2]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[QUOTE_CONDITIONS_V2]
AS
SELECT     dbo.QUOTE_CONDITIONS.QUOTE_CONDITION_ID, dbo.QUOTE_CONDITION_XJOIN.QUOTE_ID, dbo.QUOTE_CONDITION_XJOIN.CONDITION_ID, 
                      dbo.QUOTE_CONDITION_XJOIN.NAME, dbo.QUOTE_CONDITIONS.USE_FLAG, dbo.QUOTE_CONDITIONS.DATE_CREATED, 
                      dbo.QUOTE_CONDITIONS.CREATED_BY, USERS_1.FIRST_NAME + ' ' + USERS_1.LAST_NAME AS created_by_name, 
                      dbo.QUOTE_CONDITIONS.DATE_MODIFIED, dbo.QUOTE_CONDITIONS.MODIFIED_BY, 
                      USERS_2.FIRST_NAME + ' ' + USERS_2.LAST_NAME AS modified_by_name, dbo.CONDITIONS.SEQUENCE_NO
FROM         dbo.QUOTE_CONDITIONS RIGHT OUTER JOIN
                      dbo.QUOTE_CONDITION_XJOIN LEFT OUTER JOIN
                      dbo.CONDITIONS ON dbo.QUOTE_CONDITION_XJOIN.CONDITION_ID = dbo.CONDITIONS.CONDITION_ID ON 
                      dbo.QUOTE_CONDITIONS.QUOTE_ID = dbo.QUOTE_CONDITION_XJOIN.QUOTE_ID AND 
                      dbo.QUOTE_CONDITIONS.CONDITION_ID = dbo.QUOTE_CONDITION_XJOIN.CONDITION_ID LEFT OUTER JOIN
                      dbo.USERS USERS_2 ON dbo.QUOTE_CONDITIONS.MODIFIED_BY = USERS_2.USER_ID LEFT OUTER JOIN
                      dbo.USERS USERS_1 ON dbo.QUOTE_CONDITIONS.CREATED_BY = USERS_1.USER_ID
GO
/****** Object:  View [dbo].[QUOTE_CONDITIONS_V]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[QUOTE_CONDITIONS_V]
AS
SELECT     dbo.QUOTE_CONDITIONS.QUOTE_CONDITION_ID, dbo.QUOTE_CONDITIONS.QUOTE_ID, dbo.QUOTE_CONDITIONS.CONDITION_ID, 
                      dbo.CONDITIONS.NAME, dbo.QUOTE_CONDITIONS.USE_FLAG, dbo.QUOTE_CONDITIONS.DATE_CREATED, dbo.QUOTE_CONDITIONS.CREATED_BY, 
                      USERS_1.FIRST_NAME + ' ' + USERS_1.LAST_NAME AS created_by_name, dbo.QUOTE_CONDITIONS.DATE_MODIFIED, 
                      dbo.QUOTE_CONDITIONS.MODIFIED_BY, USERS_2.FIRST_NAME + ' ' + USERS_2.LAST_NAME AS modified_by_name, 
                      dbo.CONDITIONS.SEQUENCE_NO
FROM         dbo.CONDITIONS INNER JOIN
                      dbo.QUOTE_CONDITIONS ON dbo.CONDITIONS.CONDITION_ID = dbo.QUOTE_CONDITIONS.CONDITION_ID LEFT OUTER JOIN
                      dbo.USERS USERS_2 ON dbo.QUOTE_CONDITIONS.MODIFIED_BY = USERS_2.USER_ID LEFT OUTER JOIN
                      dbo.USERS USERS_1 ON dbo.QUOTE_CONDITIONS.CREATED_BY = USERS_1.USER_ID
GO
/****** Object:  View [dbo].[INVOICE_LINES_arch_2004]    Script Date: 05/03/2010 14:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[INVOICE_LINES_arch_2004]
AS
SELECT     *
FROM         dbo.INVOICE_LINES
WHERE     (DATE_CREATED <= '9/1/2002')
GO
/****** Object:  View [dbo].[AIA_JOB_LOCATIONS_V]    Script Date: 05/03/2010 14:18:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[AIA_JOB_LOCATIONS_V]
AS
SELECT     dbo.JOB_LOCATIONS.JOB_LOCATION_ID, dbo.CUSTOMERS.EXT_DEALER_ID, dbo.JOB_LOCATIONS.CUSTOMER_ID, 
                      dbo.JOB_LOCATIONS.JOB_LOCATION_NAME, dbo.JOB_LOCATIONS.LOCATION_TYPE_ID, dbo.JOB_LOCATIONS.EXT_ADDRESS_ID, 
                      dbo.JOB_LOCATIONS.STREET1, dbo.JOB_LOCATIONS.STREET2, dbo.JOB_LOCATIONS.STREET3, dbo.JOB_LOCATIONS.CITY, 
                      dbo.JOB_LOCATIONS.STATE, dbo.JOB_LOCATIONS.ZIP, dbo.JOB_LOCATIONS.COUNTRY, dbo.JOB_LOCATIONS.active_flag, 
                      dbo.JOB_LOCATIONS.county, dbo.CUSTOMERS.CUSTOMER_NAME
FROM         dbo.CUSTOMERS INNER JOIN
                      dbo.JOB_LOCATIONS ON dbo.CUSTOMERS.CUSTOMER_ID = dbo.JOB_LOCATIONS.CUSTOMER_ID
WHERE     (dbo.CUSTOMERS.EXT_DEALER_ID = '10309') AND (dbo.JOB_LOCATIONS.active_flag = 'y') OR
                      (dbo.CUSTOMERS.EXT_DEALER_ID = '10046') OR
                      (dbo.CUSTOMERS.EXT_DEALER_ID = '11133') OR
                      (dbo.CUSTOMERS.EXT_DEALER_ID = '10300') OR
                      (dbo.CUSTOMERS.EXT_DEALER_ID = '10971') OR
                      (dbo.CUSTOMERS.EXT_DEALER_ID = '10000')
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[14] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "CUSTOMERS"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 254
               Right = 279
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "JOB_LOCATIONS"
            Begin Extent = 
               Top = 13
               Left = 415
               Bottom = 245
               Right = 664
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 17
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 14
         Column = 2085
         Alias = 1140
         Table = 1590
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 2190
         Or = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'AIA_JOB_LOCATIONS_V'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'AIA_JOB_LOCATIONS_V'
GO
/****** Object:  View [dbo].[DATES_V]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[DATES_V]
AS
SELECT      todays_date AS today,  (todays_date + tomorrows_offset) AS tomorrow, (todays_date + yesterdays_offset) AS yesterday, DATEADD(hh,16,(todays_date + fridays_offset)) AS this_friday, 
(todays_date + saturdays_offset) AS this_saturday, (todays_date + sundays_offset) AS this_sunday, DATEADD(hh,16,(todays_date + last_fridays_offset)) AS last_friday, 
(todays_date + last_saturdays_offset) AS last_saturday, (todays_date + last_sundays_offset) AS last_sunday, 
(case even_odd_week when 1 then 'Rotation B' else 'Rotation A' end) cur_rotation
FROM         dbo.DATE_OFFSETS_V
GO
/****** Object:  View [dbo].[PUNCHLISTS_V]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[PUNCHLISTS_V]
AS
SELECT     dbo.PUNCHLISTS.PUNCHLIST_ID, dbo.PUNCHLISTS.PROJECT_ID, dbo.PUNCHLISTS.request_id, CONVERT(varchar, dbo.PROJECTS.PROJECT_NO) 
                      + '-' + CONVERT(varchar, dbo.REQUESTS.REQUEST_NO) AS punchlist_no, dbo.REQUESTS.DESCRIPTION, 
                      dbo.REQUESTS.D_SALES_REP_CONTACT_ID, sales_rep.CONTACT_NAME AS d_sales_rep_contact_name, 
                      dbo.REQUESTS.D_SALES_SUP_CONTACT_ID, sales_support.CONTACT_NAME AS d_sales_sup_contact_name, 
                      dbo.REQUESTS.CUSTOMER_CONTACT_ID, customer.CONTACT_NAME AS customer_contact_name, dbo.REQUESTS.A_M_CONTACT_ID, 
                      am_contact.CONTACT_NAME AS a_m_contact_name, dbo.PUNCHLISTS.WALKTHROUGH_DATE, dbo.PUNCHLISTS.PRINT_LOCATION, 
                      dbo.PUNCHLISTS.CREATED_BY, dbo.PUNCHLISTS.DATE_CREATED, dbo.PUNCHLISTS.MODIFIED_BY, dbo.PUNCHLISTS.DATE_MODIFIED
FROM         dbo.PUNCHLISTS LEFT OUTER JOIN
                      dbo.REQUESTS INNER JOIN
                      dbo.PROJECTS ON dbo.REQUESTS.PROJECT_ID = dbo.PROJECTS.PROJECT_ID ON 
                      dbo.PUNCHLISTS.request_id = dbo.REQUESTS.REQUEST_ID LEFT OUTER JOIN
                      dbo.CONTACTS customer ON dbo.REQUESTS.CUSTOMER_CONTACT_ID = customer.CONTACT_ID LEFT OUTER JOIN
                      dbo.CONTACTS sales_rep ON dbo.REQUESTS.D_SALES_REP_CONTACT_ID = sales_rep.CONTACT_ID LEFT OUTER JOIN
                      dbo.CONTACTS sales_support ON dbo.REQUESTS.D_SALES_SUP_CONTACT_ID = sales_support.CONTACT_ID LEFT OUTER JOIN
                      dbo.CONTACTS am_contact ON dbo.REQUESTS.A_M_CONTACT_ID = am_contact.CONTACT_ID
GO
/****** Object:  View [dbo].[CONDITIONS_V]    Script Date: 05/03/2010 14:18:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[CONDITIONS_V]
AS
SELECT     dbo.CONDITIONS.CONDITION_ID, dbo.QUOTE_CONDITIONS.USE_FLAG, dbo.CONDITIONS.NAME, dbo.CONDITIONS.DATE_CREATED, 
                      dbo.CONDITIONS.CREATED_BY, USERS_1.FIRST_NAME + ' ' + USERS_1.LAST_NAME AS created_by_name, dbo.CONDITIONS.DATE_MODIFIED, 
                      dbo.CONDITIONS.MODIFIED_BY, USERS_2.FIRST_NAME + ' ' + USERS_2.LAST_NAME AS modified_by_name
FROM         dbo.QUOTE_CONDITIONS RIGHT OUTER JOIN
                      dbo.CONDITIONS ON dbo.QUOTE_CONDITIONS.CONDITION_ID = dbo.CONDITIONS.CONDITION_ID LEFT OUTER JOIN
                      dbo.USERS USERS_2 ON dbo.CONDITIONS.MODIFIED_BY = USERS_2.USER_ID LEFT OUTER JOIN
                      dbo.USERS USERS_1 ON dbo.CONDITIONS.CREATED_BY = USERS_1.USER_ID
GO
/****** Object:  View [dbo].[SYS_COLUMNS_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[SYS_COLUMNS_V]
AS
SELECT     TOP 100 PERCENT dbo.SYS_TABLES_V.table_name, dbo.syscolumns.name AS column_name, dbo.systypes.name AS column_type, 
                      dbo.syscolumns.length, dbo.SYS_TABLES_V.table_id, dbo.syscolumns.id AS column_id
FROM         dbo.SYS_TABLES_V INNER JOIN
                      dbo.syscolumns ON dbo.SYS_TABLES_V.table_id = dbo.syscolumns.id INNER JOIN
                      dbo.systypes ON dbo.syscolumns.xtype = dbo.systypes.xtype
ORDER BY dbo.SYS_TABLES_V.table_name, dbo.syscolumns.colid
GO
/****** Object:  View [dbo].[SYS_FOREIGN_KEYS_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[SYS_FOREIGN_KEYS_V]
AS
SELECT     [key].name AS foreign_key_name, [table].table_name AS foreign_table_name, foreign_col.name AS foreign_column_name, 
                      related_table.name AS related_table_name, related_col.name AS related_column_name, 
                      'Create Index ' + [key].name + '_idx On ' + [table].table_name + ' (' + foreign_col.name + ');' AS create_index_sql, 
                      'Alter Table ' + [table].table_name + ' NOCHECK CONSTRAINT ' + [key].name + ';
                      ' AS disable_fk_sql, 
                      'Alter Table ' + [table].table_name + ' CHECK CONSTRAINT ' + [key].name + ';' AS enable_fk_sql
FROM         dbo.sysobjects [key] INNER JOIN
                      dbo.SYS_TABLES_V [table] ON [key].parent_obj = [table].table_id INNER JOIN
                      dbo.sysforeignkeys ON [key].id = dbo.sysforeignkeys.constid INNER JOIN
                      dbo.sysobjects related_table ON dbo.sysforeignkeys.rkeyid = related_table.id INNER JOIN
                      dbo.syscolumns related_col ON related_table.id = related_col.id AND dbo.sysforeignkeys.rkey = related_col.colid INNER JOIN
                      dbo.syscolumns foreign_col ON dbo.sysforeignkeys.fkeyid = foreign_col.id AND dbo.sysforeignkeys.fkey = foreign_col.colid
GO
/****** Object:  View [dbo].[USER_ORGANIZATIONS_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[USER_ORGANIZATIONS_V]
AS
SELECT     dbo.USER_ORGANIZATIONS.ORGANIZATION_ID, dbo.USERS.USER_ID, dbo.USERS.EXT_EMPLOYEE_ID, dbo.USERS.CONTACT_ID, 
                      dbo.USERS.EMPLOYMENT_TYPE_ID, dbo.USERS.EXT_DEALER_ID, dbo.USERS.DEALER_NAME, dbo.USERS.USER_TYPE_ID, 
                      dbo.USERS.FIRST_NAME, dbo.USERS.LAST_NAME, dbo.USERS.LOGIN, dbo.USERS.PASSWORD, dbo.USERS.LAST_LOGIN, dbo.USERS.PIN, 
                      dbo.USERS.ACTIVE_FLAG, dbo.USERS.IMOBILE_LOGIN, dbo.USERS.LAST_SYNCH_DATE, dbo.USERS.DATE_CREATED, dbo.USERS.CREATED_BY, 
                      dbo.USERS.DATE_MODIFIED, dbo.USERS.MODIFIED_BY, dbo.USER_ORGANIZATIONS.DATE_CREATED AS user_org_date_created, 
                      dbo.USER_ORGANIZATIONS.CREATED_BY AS user_org_created_by, dbo.USER_ORGANIZATIONS.DATE_MODIFIED AS user_org_date_modified, 
                      dbo.USER_ORGANIZATIONS.MODIFIED_BY AS user_org_modified_by
FROM         dbo.USERS LEFT OUTER JOIN
                      dbo.USER_ORGANIZATIONS ON dbo.USERS.USER_ID = dbo.USER_ORGANIZATIONS.USER_ID
GO
/****** Object:  View [dbo].[DOCUMENTS_V]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[DOCUMENTS_V]
AS
SELECT     dbo.FORMATS.NAME AS format_name, dbo.DOCUMENTS.NAME AS document_name, dbo.VERSIONS.VERSION_ID, 
                      dbo.VERSIONS.COMMENTS AS version_comments, dbo.VERSIONS.CODE AS version_code, 
                      V_C_USER.FIRST_NAME + ' ' + V_C_USER.LAST_NAME AS version_created_by_name, dbo.VERSIONS.DATE_CREATED AS version_date_created, 
                      CONVERT(varchar, dbo.VERSIONS.DATE_CREATED) AS version_date_created_str, 
                      D_L_USER.FIRST_NAME + ' ' + D_L_USER.LAST_NAME AS locked_by_name, dbo.DOCUMENTS.LOCKED_BY, dbo.DOCUMENTS.CODE, 
                      dbo.DOCUMENTS.FORMAT_ID, dbo.VERSIONS.CREATED_BY, dbo.VERSIONS.NUM_DOWNLOADS, dbo.DOCUMENTS.DOCUMENT_ID, 
                      dbo.DOCUMENTS.PROJECT_ID, dbo.DOCUMENTS.DATE_LOCKED, dbo.FORMATS.EXTENSION
FROM         dbo.DOCUMENTS INNER JOIN
                      dbo.VERSIONS ON dbo.DOCUMENTS.DOCUMENT_ID = dbo.VERSIONS.DOCUMENT_ID INNER JOIN
                      dbo.FORMATS ON dbo.DOCUMENTS.FORMAT_ID = dbo.FORMATS.FORMAT_ID INNER JOIN
                      dbo.USERS V_C_USER ON dbo.VERSIONS.CREATED_BY = V_C_USER.USER_ID LEFT OUTER JOIN
                      dbo.USERS D_L_USER ON dbo.DOCUMENTS.LOCKED_BY = D_L_USER.USER_ID
GO
/****** Object:  View [dbo].[JOB_PAYCODE_VIEW_V]    Script Date: 05/03/2010 14:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[JOB_PAYCODE_VIEW_V] AS SELECT dbo.JOBS.JOB_ID, dbo.ORG_GP_TABLES.VIEW_NAME AS PAYCODE_VIEW_NAME 
FROM dbo.CUSTOMERS INNER JOIN dbo.JOBS ON dbo.CUSTOMERS.CUSTOMER_ID = dbo.JOBS.CUSTOMER_ID 
INNER JOIN dbo.ORGANIZATIONS ON dbo.CUSTOMERS.ORGANIZATION_ID = dbo.ORGANIZATIONS.Organization_ID 
INNER JOIN dbo.ORG_GP_TABLES ON dbo.ORGANIZATIONS.Organization_ID = dbo.ORG_GP_TABLES.ORG_ID 
INNER JOIN dbo.GREAT_PLAINS_TABLES ON dbo.ORG_GP_TABLES.TABLE_ID = dbo.GREAT_PLAINS_TABLES.TABLE_ID 
WHERE (dbo.GREAT_PLAINS_TABLES.TABLE_NAME = 'item_pay_codes_view')
GO
/****** Object:  View [dbo].[SCH_REQUEST_VENDORS_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[SCH_REQUEST_VENDORS_V]
AS
SELECT     dbo.SERVICES.SERVICE_ID, dbo.PROJECTS.PROJECT_ID, dbo.REQUEST_VENDORS.REQUEST_ID, dbo.REQUEST_VENDORS.REQUEST_VENDOR_ID, 
                      dbo.PROJECTS.PROJECT_NO, dbo.REQUESTS.REQUEST_NO, dbo.SERVICES.EST_START_DATE, dbo.SERVICES.EST_START_TIME, 
                      dbo.SERVICES.EST_END_DATE
FROM         dbo.SERVICES INNER JOIN
                      dbo.REQUESTS ON dbo.SERVICES.REQUEST_ID = dbo.REQUESTS.REQUEST_ID INNER JOIN
                      dbo.PROJECTS ON dbo.REQUESTS.PROJECT_ID = dbo.PROJECTS.PROJECT_ID INNER JOIN
                      dbo.CUSTOMERS ON dbo.PROJECTS.CUSTOMER_ID = dbo.CUSTOMERS.CUSTOMER_ID INNER JOIN
                      dbo.REQUEST_VENDORS ON dbo.REQUESTS.REQUEST_ID = dbo.REQUEST_VENDORS.REQUEST_ID AND 
                      dbo.REQUESTS.FURNITURE1_CONTACT_ID = dbo.REQUEST_VENDORS.VENDOR_CONTACT_ID AND 
                      dbo.CUSTOMERS.A_M_FURNITURE1_CONTACT_ID = dbo.REQUEST_VENDORS.VENDOR_CONTACT_ID
GO
/****** Object:  View [dbo].[crystal_dashboard_REQUEST_SENT_V]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[crystal_dashboard_REQUEST_SENT_V]
AS
SELECT     dbo.REQUESTS.REQUEST_ID, dbo.REQUESTS.PROJECT_ID, dbo.PROJECTS.PROJECT_NO, dbo.PROJECTS.JOB_NAME, 
                      dbo.REQUESTS.REQUEST_NO, dbo.REQUESTS.VERSION_NO, dbo.REQUESTS.REQUEST_TYPE_ID, dbo.REQUESTS.REQUEST_STATUS_TYPE_ID, 
                      dbo.REQUESTS.IS_SENT, dbo.REQUESTS.EST_START_DATE, dbo.REQUESTS.EST_END_DATE, dbo.REQUESTS.DESCRIPTION, 
                      dbo.REQUESTS.DATE_CREATED, dbo.CUSTOMERS.ORGANIZATION_ID, dbo.CUSTOMERS.EXT_DEALER_ID, 
                      dbo.ORGANIZATIONS.NAME AS Org_Name, dbo.REQUESTS.IS_SENT_DATE AS Req_Sent_Date
FROM         dbo.REQUESTS INNER JOIN
                      dbo.PROJECTS ON dbo.REQUESTS.PROJECT_ID = dbo.PROJECTS.PROJECT_ID INNER JOIN
                      dbo.CUSTOMERS ON dbo.PROJECTS.CUSTOMER_ID = dbo.CUSTOMERS.CUSTOMER_ID INNER JOIN
                      dbo.ORGANIZATIONS ON dbo.CUSTOMERS.ORGANIZATION_ID = dbo.ORGANIZATIONS.ORGANIZATION_ID
GO
/****** Object:  View [dbo].[CUSTOMERS_V]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[CUSTOMERS_V]
AS
SELECT     dbo.CUSTOMERS.CUSTOMER_ID, dbo.CUSTOMERS.ORGANIZATION_ID, dbo.CUSTOMERS.PARENT_CUSTOMER_ID, 
                      parent_customers.CUSTOMER_NAME AS parent_customer_name, dbo.CUSTOMERS.EXT_DEALER_ID, dbo.CUSTOMERS.DEALER_NAME, 
                      dbo.CUSTOMERS.EXT_CUSTOMER_ID, dbo.CUSTOMERS.CUSTOMER_NAME, dbo.CUSTOMERS.SURVEY_LOCATION, 
                      dbo.CUSTOMERS.SURVEY_FREQUENCY, dbo.CUSTOMERS.SURVEY_LAST_COUNT, dbo.CUSTOMERS.REFUSAL_EMAIL_INFO, 
                      dbo.CUSTOMERS.A_M_FURNITURE1_CONTACT_ID, dbo.CUSTOMERS.ACTIVE_FLAG, dbo.CUSTOMERS.DATE_CREATED, 
                      dbo.CUSTOMERS.CREATED_BY, dbo.CUSTOMERS.DATE_MODIFIED, dbo.CUSTOMERS.MODIFIED_BY
FROM         dbo.CUSTOMERS LEFT OUTER JOIN
                      dbo.CUSTOMERS AS parent_customers ON dbo.CUSTOMERS.PARENT_CUSTOMER_ID = parent_customers.CUSTOMER_ID
GO
/****** Object:  View [dbo].[crystal_REQUEST_SENT_V]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[crystal_REQUEST_SENT_V]
AS
SELECT     dbo.REQUESTS.REQUEST_ID, dbo.REQUESTS.PROJECT_ID, dbo.PROJECTS.PROJECT_NO, dbo.PROJECTS.JOB_NAME, 
                      dbo.REQUESTS.REQUEST_NO, dbo.REQUESTS.VERSION_NO, dbo.REQUESTS.REQUEST_TYPE_ID, dbo.REQUESTS.REQUEST_STATUS_TYPE_ID, 
                      dbo.REQUESTS.IS_SENT, dbo.REQUESTS.EST_START_DATE, dbo.REQUESTS.EST_END_DATE, dbo.REQUESTS.DESCRIPTION, 
                      dbo.REQUESTS.DATE_CREATED, dbo.CUSTOMERS.ORGANIZATION_ID, dbo.CUSTOMERS.EXT_DEALER_ID
FROM         dbo.REQUESTS INNER JOIN
                      dbo.PROJECTS ON dbo.REQUESTS.PROJECT_ID = dbo.PROJECTS.PROJECT_ID INNER JOIN
                      dbo.CUSTOMERS ON dbo.PROJECTS.CUSTOMER_ID = dbo.CUSTOMERS.CUSTOMER_ID
WHERE     (dbo.REQUESTS.IS_SENT = 'y') AND (dbo.CUSTOMERS.ORGANIZATION_ID = 2) AND (dbo.CUSTOMERS.EXT_DEALER_ID = '3017')
GO
/****** Object:  View [dbo].[SURVEY_REQUEST_VENDORS_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[SURVEY_REQUEST_VENDORS_V]
AS
SELECT     TOP 100 PERCENT dbo.REQUESTS.PROJECT_ID, dbo.REQUEST_VENDORS.REQUEST_ID, dbo.REQUEST_VENDORS.REQUEST_VENDOR_ID, 
                      dbo.REQUEST_VENDORS.COMPLETE_FLAG
FROM         dbo.CUSTOMERS INNER JOIN
                      dbo.CONTACTS ON dbo.CUSTOMERS.A_M_FURNITURE1_CONTACT_ID = dbo.CONTACTS.CONTACT_ID INNER JOIN
                      dbo.REQUEST_VENDORS ON dbo.CONTACTS.CONTACT_ID = dbo.REQUEST_VENDORS.VENDOR_CONTACT_ID INNER JOIN
                      dbo.REQUESTS ON dbo.REQUEST_VENDORS.REQUEST_ID = dbo.REQUESTS.REQUEST_ID INNER JOIN
                      dbo.PROJECTS ON dbo.CUSTOMERS.CUSTOMER_ID = dbo.PROJECTS.CUSTOMER_ID AND 
                      dbo.REQUESTS.PROJECT_ID = dbo.PROJECTS.PROJECT_ID INNER JOIN
                      dbo.SURVEY_TEST_V ON dbo.PROJECTS.PROJECT_ID = dbo.SURVEY_TEST_V.PROJECT_ID
WHERE     (dbo.REQUEST_VENDORS.COMPLETE_FLAG = 'Y')
ORDER BY dbo.REQUESTS.PROJECT_ID, dbo.REQUEST_VENDORS.REQUEST_ID, dbo.REQUEST_VENDORS.REQUEST_VENDOR_ID
GO
/****** Object:  View [dbo].[AIA_OFFICE_INTERIORS_CUSTOMER_V]    Script Date: 05/03/2010 14:18:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[AIA_OFFICE_INTERIORS_CUSTOMER_V]
AS
SELECT     dbo.CONTACTS.CONTACT_ID, dbo.CONTACTS.CONTACT_NAME, dbo.CONTACTS.ORGANIZATION_ID, dbo.CONTACTS.EXT_DEALER_ID, 
                      dbo.CONTACTS.CUSTOMER_ID, dbo.CUSTOMERS.DEALER_NAME, dbo.CUSTOMERS.EXT_CUSTOMER_ID, dbo.CUSTOMERS.CUSTOMER_NAME
FROM         dbo.CONTACTS FULL OUTER JOIN
                      dbo.CUSTOMERS ON dbo.CONTACTS.CUSTOMER_ID = dbo.CUSTOMERS.CUSTOMER_ID
WHERE     (dbo.CONTACTS.ORGANIZATION_ID = 8) AND (dbo.CUSTOMERS.CUSTOMER_NAME = 'Office Interior') OR
                      (dbo.CUSTOMERS.CUSTOMER_NAME = 'Office Interiors - Atlanta') OR
                      (dbo.CUSTOMERS.CUSTOMER_NAME = 'Facilitec')
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[35] 4[23] 2[13] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "CONTACTS"
            Begin Extent = 
               Top = 6
               Left = 185
               Bottom = 211
               Right = 384
            End
            DisplayFlags = 280
            TopColumn = 5
         End
         Begin Table = "CUSTOMERS"
            Begin Extent = 
               Top = 13
               Left = 546
               Bottom = 217
               Right = 787
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 10
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1995
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1635
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 2475
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'AIA_OFFICE_INTERIORS_CUSTOMER_V'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'AIA_OFFICE_INTERIORS_CUSTOMER_V'
GO
/****** Object:  View [dbo].[REQ_TYPES_V]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[REQ_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'service_type ') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO
/****** Object:  View [dbo].[SERV_LINE_STATUS_TYPES_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[SERV_LINE_STATUS_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'serv_line_status_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO
/****** Object:  View [dbo].[RESOURCE_CATEGORY_TYPES_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[RESOURCE_CATEGORY_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'resource_category_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO
/****** Object:  View [dbo].[PUNCHLIST_ITEM_TYPES_V]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[PUNCHLIST_ITEM_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'punchlist_item_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO
/****** Object:  View [dbo].[REASON_TYPES_V]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[REASON_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name, 
                      (CASE attribute2 WHEN 'available' THEN 'Y' ELSE 'N' END) available_flag
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'reason_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO
/****** Object:  View [dbo].[WORKORDER_STATUS_TYPES_V]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[WORKORDER_STATUS_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'workorder_status_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO
/****** Object:  View [dbo].[LEVEL_TYPES_V]    Script Date: 05/03/2010 14:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[LEVEL_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'level_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO
/****** Object:  View [dbo].[PRIORITY_TYPES_V]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[PRIORITY_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'priority_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO
/****** Object:  View [dbo].[SECURITY_TYPES_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[SECURITY_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'security_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO
/****** Object:  View [dbo].[OVERRIDE_REASON_TYPES_V]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[OVERRIDE_REASON_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'override_reason_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO
/****** Object:  View [dbo].[PRODUCT_DISPOSITION_V]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[PRODUCT_DISPOSITION_V]  
AS  
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified,   
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID,   
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name  
FROM         dbo.LOOKUPS_V  
WHERE     (type_code = 'product_disposition_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO
/****** Object:  View [dbo].[NOTIFICATION_TYPES_V]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[NOTIFICATION_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'notification_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO
/****** Object:  View [dbo].[REQUEST_TYPES_V]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[REQUEST_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'request_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO
/****** Object:  View [dbo].[APPROVAL_REQ_TYPES_V]    Script Date: 05/03/2010 14:18:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[APPROVAL_REQ_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'approval_req_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO
/****** Object:  View [dbo].[MULTI_LEVEL_TYPES_V]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[MULTI_LEVEL_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'multi_level_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO
/****** Object:  View [dbo].[ELEVATOR_AVAILABLE_TYPES_V]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ELEVATOR_AVAILABLE_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'elevator_available_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO
/****** Object:  View [dbo].[ACCOUNT_TYPES_V]    Script Date: 05/03/2010 14:18:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ACCOUNT_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'account_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO
/****** Object:  View [dbo].[ACTIVITY_CATEGORY_TYPES_V]    Script Date: 05/03/2010 14:18:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ACTIVITY_CATEGORY_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'activity_category_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO
/****** Object:  View [dbo].[PROJECT_STATUS_TYPES_V]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[PROJECT_STATUS_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'project_status_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO
/****** Object:  View [dbo].[QUOTE_REQ_STATUS_TYPES_V]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[QUOTE_REQ_STATUS_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'quote_req_status_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO
/****** Object:  View [dbo].[RESOURCE_STATUS_TYPES_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[RESOURCE_STATUS_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'resource_status_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO
/****** Object:  View [dbo].[PHASE_TYPES_V]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[PHASE_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'phase_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO
/****** Object:  View [dbo].[QUOTE_STATUS_TYPES_V]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[QUOTE_STATUS_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'quote_status_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO
/****** Object:  View [dbo].[CONTACT_TYPES_V]    Script Date: 05/03/2010 14:18:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[CONTACT_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'contact_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO
/****** Object:  View [dbo].[DELIVERY_TYPES_V]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[DELIVERY_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'delivery_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO
/****** Object:  View [dbo].[CUSTOMER_TYPES_V]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[CUSTOMER_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'customer_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO
/****** Object:  View [dbo].[DATE_TYPES_V]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[DATE_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'date_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO
/****** Object:  View [dbo].[SCHEDULE_TYPES_ENET_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[SCHEDULE_TYPES_ENET_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'schedule_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO
/****** Object:  View [dbo].[EMPLOYMENT_TYPES_V]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[EMPLOYMENT_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'employment_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO
/****** Object:  View [dbo].[ACTIVITY_TYPES_V]    Script Date: 05/03/2010 14:18:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ACTIVITY_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'activity_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO
/****** Object:  View [dbo].[ALERT_TYPES_V]    Script Date: 05/03/2010 14:18:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ALERT_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'alert_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO
/****** Object:  View [dbo].[BILLING_TYPES_V]    Script Date: 05/03/2010 14:18:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[BILLING_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'billing_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO
/****** Object:  View [dbo].[CONTACT_STATUS_TYPES_V]    Script Date: 05/03/2010 14:18:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[CONTACT_STATUS_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'contact_status_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO
/****** Object:  View [dbo].[USER_TYPES_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[USER_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      ATTRIBUTE1 AS category, ATTRIBUTE2 AS multiplier, lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, 
                      lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'user_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO
/****** Object:  View [dbo].[FURNITURE_TYPES_V]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[FURNITURE_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'furniture_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO
/****** Object:  View [dbo].[FLOOR_PROTECTION_TYPES_V]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[FLOOR_PROTECTION_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'floor_prot_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO
/****** Object:  View [dbo].[FURNITURE_LINE_TYPES_V]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[FURNITURE_LINE_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      PARENT_LOOKUP_ID, ATTRIBUTE2 AS furniture_type_code, lookup_date_created, lookup_created_by, lookup_created_by_name, 
                      lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'furniture_line_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO
/****** Object:  View [dbo].[ITEM_STATUS_TYPES_V]    Script Date: 05/03/2010 14:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ITEM_STATUS_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      ATTRIBUTE1 AS category, ATTRIBUTE2 AS multiplier, lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, 
                      lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'item_status_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO
/****** Object:  View [dbo].[ITEM_TYPES_V]    Script Date: 05/03/2010 14:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ITEM_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'item_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO
/****** Object:  View [dbo].[INVOICE_TRACKING_TYPES_V]    Script Date: 05/03/2010 14:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[INVOICE_TRACKING_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'tracking_type') AND (lookup_code <> 'pda_note') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO
/****** Object:  View [dbo].[LOADING_DOCK_TYPES_V]    Script Date: 05/03/2010 14:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[LOADING_DOCK_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'loading_dock_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO
/****** Object:  View [dbo].[LOCATION_TYPES_V]    Script Date: 05/03/2010 14:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[LOCATION_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'location_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO
/****** Object:  View [dbo].[JOB_TYPES_V]    Script Date: 05/03/2010 14:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[JOB_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'job_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO
/****** Object:  View [dbo].[JOB_STATUS_TYPES_V]    Script Date: 05/03/2010 14:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[JOB_STATUS_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'job_status_type ') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO
/****** Object:  View [dbo].[LOOKUPS_QUICK_V]    Script Date: 05/03/2010 14:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[LOOKUPS_QUICK_V]
AS
SELECT     TOP 100 PERCENT LOOKUP_TYPE_ID, type_name, SEQUENCE_NO, lookup_name, lookup_code, LOOKUP_ID
FROM         dbo.LOOKUPS_V
WHERE     (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
ORDER BY type_name, SEQUENCE_NO
GO

/****** Object:  View [dbo].[SCH_RESOURCES_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[SCH_RESOURCES_V]
AS
SELECT     CAST(dbo.RESOURCES_V.RESOURCE_ID AS varchar(30)) + ':' + ISNULL(CAST(dbo.SCH_RESOURCES.SCH_RESOURCE_ID AS varchar(30)), '')
                      AS res_sch_id, dbo.RESOURCES_V.RESOURCE_ID, dbo.RESOURCES_V.ORGANIZATION_ID, dbo.SCH_RESOURCES.SCH_RESOURCE_ID,
                      dbo.SCH_RESOURCES.WEEKEND_SCH_RESOURCE_ID, dbo.RESOURCES_V.NAME AS resource_name, dbo.SCH_RESOURCES.JOB_ID,
                      dbo.SCH_RESOURCES.SERVICE_ID, dbo.SERVICES.SERVICE_NO, dbo.SCH_RESOURCES.HIDDEN_SERVICE_ID,
                      ISNULL(dbo.SCH_RESOURCES.SERVICE_ID, dbo.SCH_RESOURCES.HIDDEN_SERVICE_ID) AS actual_service_id,
                      dbo.SCH_RESOURCES.RES_STATUS_TYPE_ID, RES_STATUS_TYPES.CODE AS res_status_type_code, ISNULL(RES_STATUS_TYPES.NAME,
                      'Available') AS res_status_type_name, dbo.SCH_RESOURCES.REASON_TYPE_ID, REASON_TYPE.CODE AS reason_type_code,
                      REASON_TYPE.NAME AS reason_type_name, dbo.RESOURCES_V.RES_CATEGORY_TYPE_ID, dbo.RESOURCES_V.res_cat_type_code,
                      dbo.RESOURCES_V.res_cat_type_name, dbo.RESOURCES_V.RESOURCE_TYPE_ID, dbo.RESOURCES_V.resource_type_code,
                      dbo.RESOURCES_V.resource_type_name, dbo.RESOURCES_V.UNIQUE_FLAG, dbo.RESOURCES_V.NOTES, dbo.RESOURCES_V.PIN,
                      dbo.RESOURCES_V.FOREMAN_FLAG, dbo.RESOURCES_V.ACTIVE_FLAG, dbo.RESOURCES_V.EXT_VENDOR_ID,
                      dbo.RESOURCES_V.EXT_EMPLOYEE_ID, dbo.RESOURCES_V.employment_type_name, dbo.RESOURCES_V.employment_type_code,
                      dbo.RESOURCES_V.EMPLOYMENT_TYPE_ID, dbo.RESOURCES_V.USER_ID, dbo.RESOURCES_V.user_full_name,
                      dbo.RESOURCES_V.user_contact_id, dbo.RESOURCES_V.user_contact_name, dbo.RESOURCES_V.modified_by_name AS res_modified_by_name,
                      dbo.RESOURCES_V.MODIFIED_BY AS res_modified_by, dbo.RESOURCES_V.DATE_MODIFIED AS res_date_modified,
                      dbo.RESOURCES_V.created_by_name AS res_created_by_name, dbo.RESOURCES_V.CREATED_BY AS res_created_by,
                      dbo.RESOURCES_V.DATE_CREATED AS res_date_created, ISNULL(dbo.SCH_RESOURCES.FOREMAN_FLAG, 'N') AS sch_foreman_flag,
                      dbo.SCH_RESOURCES.RES_START_DATE, dbo.SCH_RESOURCES.RES_START_TIME, dbo.SCH_RESOURCES.RES_END_DATE,
                      dbo.SCH_RESOURCES.RES_END_TIME, dbo.SCH_RESOURCES.DATE_CONFIRMED, dbo.SCH_RESOURCES.RESOURCE_QTY,
                      dbo.SCH_RESOURCES.SCH_NOTES, dbo.SCH_RESOURCES.WEEKEND_FLAG, dbo.SCH_RESOURCES.DATE_CREATED AS sch_date_created,
                      dbo.SCH_RESOURCES.CREATED_BY AS sch_created_by, CREATED_BY.FIRST_NAME + ' ' + CREATED_BY.LAST_NAME AS sch_created_by_name,
                      dbo.SCH_RESOURCES.DATE_MODIFIED AS sch_date_modified, dbo.SCH_RESOURCES.MODIFIED_BY AS sch_modified_by,
                      MODIFIED_BY.FIRST_NAME + ' ' + MODIFIED_BY.LAST_NAME AS sch_modified_by_name, ISNULL(report_to.NAME, 'Job Location')
                      AS report_to_name, dbo.SCH_RESOURCES.DATE_TYPE_ID, dbo.SERVICES.SERV_STATUS_TYPE_ID,
                      SERV_STATUS_TYPES.CODE AS serv_status_type_code, SERV_STATUS_TYPES.NAME AS serv_status_type_name,
                      SERV_STATUS_TYPES.SEQUENCE_NO AS serv_status_type_seq_no, dbo.JOBS_V.JOB_ID AS Expr1, dbo.JOBS_V.JOB_NO, dbo.JOBS_V.JOB_NAME,
                      dbo.JOBS_V.JOB_TYPE_ID, dbo.JOBS_V.job_type_code, dbo.JOBS_V.job_type_name, dbo.JOBS_V.JOB_STATUS_TYPE_ID,
                      dbo.JOBS_V.job_status_type_code, dbo.JOBS_V.job_status_type_name, dbo.JOBS_V.CUSTOMER_ID, dbo.JOBS_V.FOREMAN_RESOURCE_ID,
                      dbo.JOBS_V.foreman_resource_name, dbo.JOBS_V.foreman_user_id, dbo.JOBS_V.foreman_user_name,
                      dbo.SCH_RESOURCES.REPORT_TO_TYPE_ID, dbo.SCH_RESOURCES.SEND_TO_PDA_FLAG,
                      (CASE reason_type.code WHEN 'unconfirmed' THEN 'Y' ELSE 'N' END) AS unconfirmed_flag
FROM         dbo.RESOURCES_V RIGHT OUTER JOIN
                      dbo.LOOKUPS RES_STATUS_TYPES RIGHT OUTER JOIN
                      dbo.LOOKUPS report_to RIGHT OUTER JOIN
                      dbo.USERS MODIFIED_BY RIGHT OUTER JOIN
                      dbo.SCH_RESOURCES LEFT OUTER JOIN
                      dbo.JOBS_V ON dbo.SCH_RESOURCES.JOB_ID = dbo.JOBS_V.JOB_ID LEFT OUTER JOIN
                      dbo.LOOKUPS SERV_STATUS_TYPES RIGHT OUTER JOIN
                      dbo.SERVICES ON SERV_STATUS_TYPES.LOOKUP_ID = dbo.SERVICES.SERV_STATUS_TYPE_ID ON
                      dbo.SCH_RESOURCES.SERVICE_ID = dbo.SERVICES.SERVICE_ID LEFT OUTER JOIN
                      dbo.USERS CREATED_BY ON dbo.SCH_RESOURCES.CREATED_BY = CREATED_BY.USER_ID ON
                      MODIFIED_BY.USER_ID = dbo.SCH_RESOURCES.MODIFIED_BY ON
                      report_to.LOOKUP_ID = dbo.SCH_RESOURCES.REPORT_TO_TYPE_ID LEFT OUTER JOIN
                      dbo.LOOKUPS REASON_TYPE ON dbo.SCH_RESOURCES.REASON_TYPE_ID = REASON_TYPE.LOOKUP_ID ON
                      RES_STATUS_TYPES.LOOKUP_ID = dbo.SCH_RESOURCES.RES_STATUS_TYPE_ID ON
                      dbo.RESOURCES_V.RESOURCE_ID = dbo.SCH_RESOURCES.RESOURCE_ID
GO

/****** Object:  View [dbo].[PDA_SCHED_RES_V]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[PDA_SCHED_RES_V] AS SELECT dbo.SCH_RESOURCES_V.SCH_RESOURCE_ID AS sched_resource_id, dbo.SCH_RESOURCES_V.JOB_ID, dbo.SCH_RESOURCES_V.RESOURCE_ID, dbo.SCH_RESOURCES_V.resource_name AS name, dbo.PDA_JOBS_V.ims_user_id FROM dbo.SCH_RESOURCES_V INNER JOIN dbo.PDA_JOBS_V ON dbo.SCH_RESOURCES_V.JOB_ID = dbo.PDA_JOBS_V.JOB_ID WHERE (CONVERT(datetime, CONVERT(varchar, dbo.SCH_RESOURCES_V.RES_START_DATE, 101)) <= CONVERT(datetime, CONVERT(varchar, GETDATE(), 101))) AND (ISNULL(CONVERT(datetime, CONVERT(varchar, dbo.SCH_RESOURCES_V.RES_END_DATE, 101)), DATEADD(day, 1, CONVERT(datetime, CONVERT(varchar, GETDATE(), 101)))) >= CONVERT(datetime, CONVERT(varchar, GETDATE(), 101))) AND (dbo.PDA_JOBS_V.ims_user_id IS NOT NULL)
GO

/****** Object:  View [dbo].[PROJECT_NOTES_V]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[PROJECT_NOTES_V]
AS
SELECT     dbo.PROJECT_NOTES.PROJECT_NOTE_ID, dbo.PROJECT_NOTES.PROJECT_ID, dbo.PROJECT_NOTES.NOTE, dbo.PROJECT_NOTES.DATE_CREATED, 
                      dbo.PROJECT_NOTES.CREATED_BY, CREATED_BY.FIRST_NAME + ' ' + CREATED_BY.LAST_NAME AS created_by_name, 
                      dbo.PROJECT_NOTES.DATE_MODIFIED, dbo.PROJECT_NOTES.MODIFIED_BY, 
                      MODIFIED_BY.FIRST_NAME + ' ' + MODIFIED_BY.LAST_NAME AS modified_by_name
FROM         dbo.PROJECT_NOTES LEFT OUTER JOIN
                      dbo.USERS MODIFIED_BY ON dbo.PROJECT_NOTES.MODIFIED_BY = MODIFIED_BY.USER_ID LEFT OUTER JOIN
                      dbo.USERS CREATED_BY ON dbo.PROJECT_NOTES.CREATED_BY = CREATED_BY.USER_ID
GO
/****** Object:  View [dbo].[CUSTOM_CUST_COLUMNS_V]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[CUSTOM_CUST_COLUMNS_V]
AS
SELECT     dbo.CUSTOMERS_V.CUSTOMER_ID, dbo.CUSTOMERS_V.PARENT_CUSTOMER_ID, dbo.CUSTOMERS_V.ORGANIZATION_ID, 
                      dbo.CUSTOMERS_V.EXT_DEALER_ID, dbo.CUSTOMERS_V.DEALER_NAME, dbo.CUSTOMERS_V.EXT_CUSTOMER_ID, 
                      dbo.CUSTOMERS_V.CUSTOMER_NAME, COL1.COLUMN_DESC AS col1, COL1.ACTIVE_FLAG AS col1_active_flag, 
                      COL1.IS_MANDATORY AS col1_is_mandatory, COL1.IS_DROPLIST AS col1_is_droplist, COL2.COLUMN_DESC AS col2, 
                      COL2.ACTIVE_FLAG AS col2_active_flag, COL2.IS_MANDATORY AS col2_is_mandatory, COL2.IS_DROPLIST AS col2_is_droplist, 
                      COL3.COLUMN_DESC AS col3, COL3.ACTIVE_FLAG AS col3_active_flag, COL3.IS_MANDATORY AS col3_is_mandatory, 
                      COL3.IS_DROPLIST AS col3_is_droplist, COL4.COLUMN_DESC AS col4, COL4.ACTIVE_FLAG AS col4_active_flag, 
                      COL4.IS_MANDATORY AS col4_is_mandatory, COL4.IS_DROPLIST AS col4_is_droplist, COL5.COLUMN_DESC AS col5, 
                      COL5.ACTIVE_FLAG AS col5_active_flag, COL5.IS_MANDATORY AS col5_is_mandatory, COL5.IS_DROPLIST AS col5_is_droplist, 
                      COL6.COLUMN_DESC AS col6, COL6.ACTIVE_FLAG AS col6_active_flag, COL6.IS_MANDATORY AS col6_is_mandatory, 
                      COL6.IS_DROPLIST AS col6_is_droplist, COL7.COLUMN_DESC AS col7, COL7.ACTIVE_FLAG AS col7_active_flag, 
                      COL7.IS_MANDATORY AS col7_is_mandatory, COL7.IS_DROPLIST AS col7_is_droplist, COL8.COLUMN_DESC AS col8, 
                      COL8.ACTIVE_FLAG AS col8_active_flag, COL8.IS_MANDATORY AS col8_is_mandatory, COL8.IS_DROPLIST AS col8_is_droplist, 
                      COL9.COLUMN_DESC AS col9, COL9.ACTIVE_FLAG AS col9_active_flag, COL9.IS_MANDATORY AS col9_is_mandatory, 
                      COL9.IS_DROPLIST AS col9_is_droplist, COL10.COLUMN_DESC AS col10, COL10.ACTIVE_FLAG AS col10_active_flag, 
                      COL10.IS_MANDATORY AS col10_is_mandatory, COL10.IS_DROPLIST AS col10_is_droplist
FROM         dbo.CUSTOM_CUST_COLUMNS COL10 RIGHT OUTER JOIN
                      dbo.CUSTOMERS_V ON COL10.CUSTOMER_ID = dbo.CUSTOMERS_V.CUSTOMER_ID LEFT OUTER JOIN
                      dbo.CUSTOM_CUST_COLUMNS COL9 ON dbo.CUSTOMERS_V.CUSTOMER_ID = COL9.CUSTOMER_ID LEFT OUTER JOIN
                      dbo.CUSTOM_CUST_COLUMNS COL8 ON dbo.CUSTOMERS_V.CUSTOMER_ID = COL8.CUSTOMER_ID LEFT OUTER JOIN
                      dbo.CUSTOM_CUST_COLUMNS COL7 ON dbo.CUSTOMERS_V.CUSTOMER_ID = COL7.CUSTOMER_ID LEFT OUTER JOIN
                      dbo.CUSTOM_CUST_COLUMNS COL6 ON dbo.CUSTOMERS_V.CUSTOMER_ID = COL6.CUSTOMER_ID LEFT OUTER JOIN
                      dbo.CUSTOM_CUST_COLUMNS COL5 ON dbo.CUSTOMERS_V.CUSTOMER_ID = COL5.CUSTOMER_ID LEFT OUTER JOIN
                      dbo.CUSTOM_CUST_COLUMNS COL4 ON dbo.CUSTOMERS_V.CUSTOMER_ID = COL4.CUSTOMER_ID LEFT OUTER JOIN
                      dbo.CUSTOM_CUST_COLUMNS COL3 ON dbo.CUSTOMERS_V.CUSTOMER_ID = COL3.CUSTOMER_ID LEFT OUTER JOIN
                      dbo.CUSTOM_CUST_COLUMNS COL2 ON dbo.CUSTOMERS_V.CUSTOMER_ID = COL2.CUSTOMER_ID LEFT OUTER JOIN
                      dbo.CUSTOM_CUST_COLUMNS COL1 ON dbo.CUSTOMERS_V.CUSTOMER_ID = COL1.CUSTOMER_ID
WHERE     (COL1.COL_SEQUENCE = 1) AND (COL2.COL_SEQUENCE = 2) AND (COL3.COL_SEQUENCE = 3) AND (COL4.COL_SEQUENCE = 4) AND 
                      (COL5.COL_SEQUENCE = 5) AND (COL6.COL_SEQUENCE = 6) AND (COL7.COL_SEQUENCE = 7) AND (COL8.COL_SEQUENCE = 8) AND 
                      (COL9.COL_SEQUENCE = 9) AND (COL10.COL_SEQUENCE = 10)
GO
/****** Object:  View [dbo].[ITEMS_BY_JOB_TYPES_V]    Script Date: 05/03/2010 14:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ITEMS_BY_JOB_TYPES_V]
(job_id, item_id)
AS
(SELECT j.job_id, i.item_id
FROM dbo.jobs j INNER JOIN dbo.items i ON j.job_type_id = i.job_type_id)
GO

/****** Object:  View [dbo].[projects_all_requests_v]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[projects_all_requests_v]
AS
SELECT p_v.project_id,
       p_v.project_no,
       r.request_id,
       r.request_no,
       q_v.quote_id,
       q_v.quote_no,
       CONVERT(VARCHAR, p_v.project_no) + '-' + CONVERT(VARCHAR, r.request_no) + '.' + CONVERT(VARCHAR, r.version_no) AS record_no,
       r.request_id AS record_id,
       r.request_no AS record_seq_no,
       r.version_no,
       dbo.versions_max_no_v.max_version_no,
       r.request_type_id AS record_type_id,
       request_type.code AS record_type_code,
       request_type.name AS record_type_name,
       request_type.sequence_no AS record_type_seq_no,
       r.request_status_type_id AS record_status_type_id,
       request_status_type.code AS record_status_type_code,
       request_status_type.name AS record_status_type_name,
       r.is_sent AS record_is_sent,
       ISNULL(r.date_modified, r.date_created) AS record_last_modified,
       r.date_created AS record_created,
       r.date_modified AS record_modified,
       p_v.project_status_type_id,
       p_v.project_status_type_code,
       p_v.project_status_type_name,
       p_v.parent_customer_id,
       p_v.organization_id,
       p_v.ext_dealer_id,
       p_v.dealer_name,
       p_v.ext_customer_id,
       p_v.customer_id,
       p_v.customer_name,
       p_v.end_user_id,
       p_v.end_user_name,
       p_v.refusal_email_info,
       p_v.survey_location,
       p_v.job_name,
       r.quote_request_id,
       r.request_type_id,
       request_type.code AS request_type_code,
       request_type.name AS request_type_name,
       r.request_status_type_id,
       request_status_type.code AS request_status_type_code,
       request_status_type.name AS request_status_type_name,
       r.is_sent AS request_is_sent,
       r.dealer_po_no,
       r.customer_po_no,
       r.dealer_project_no,
       r.design_project_no,
       r.est_start_date,
       CONVERT(VARCHAR(12), r.est_start_date, 101) AS est_start_date_varchar,
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
       r.a_m_install_sup_contact_id,
       r.a_d_designer_contact_id,
       r.gen_contractor_contact_id,
       r.electrician_contact_id,
       r.data_phone_contact_id,
       r.phone_contact_id,
       r.carpet_layer_contact_id,
       r.bldg_mgr_contact_id,
       r.security_contact_id,
       r.mover_contact_id,
       r.other_contact_id,
       r.furniture1_contact_id,
       r.furniture2_contact_id,
       r.is_quoted,
       r.description,
       r.approver_contact_id,
       r.alt_customer_contact_id,
       q_v.is_sent AS quote_is_sent,
       q_v.quote_type_id,
       q_v.quote_type_code,
       q_v.quote_type_name,
       q_v.quote_status_type_id,
       q_v.quote_status_type_code,
       q_v.quote_status_type_name,
       q_v.date_quoted,
       q_v.quote_total,
       q_v.quoted_by_user_id,
       q_v.quoted_by_user_name,
       p_v.is_new
  FROM dbo.projects_v2 p_v LEFT OUTER JOIN
       dbo.requests r ON p_v.project_id = r.project_id LEFT OUTER JOIN
       dbo.lookups request_type ON r.request_type_id = request_type.lookup_id LEFT OUTER JOIN
       dbo.lookups request_status_type ON r.request_status_type_id = request_status_type.lookup_id LEFT OUTER JOIN
       dbo.quotes_v q_v ON r.request_id = q_v.request_id  LEFT OUTER JOIN
       dbo.versions_max_no_v ON r.request_no = dbo.versions_max_no_v.request_no AND r.project_id = dbo.versions_max_no_v.project_id
UNION
SELECT p_v.project_id,
       p_v.project_no,
       r.request_id,
       r.request_no,
       q_v.quote_id,
       q_v.quote_no,
       CONVERT(VARCHAR, p_v.project_no) + '-' + CONVERT(VARCHAR, q_v.quote_no) + '.' + ISNULL(CONVERT(VARCHAR, q_v.version),' ') AS record_no,
       q_v.quote_id record_id,
       q_v.quote_no AS record_seq_no,
       1 version_no,
       1 max_version_no,
       q_v.request_type_id AS record_type_id,
       q_v.request_type_code AS record_type_code,
       q_v.request_type_name AS record_type_name,
       q_v.request_type_sequence_no AS record_type_seq_no,
       q_v.quote_status_type_id record_status_type_id,
       q_v.quote_status_type_code AS record_status_type_code,
       q_v.quote_status_type_name AS record_status_type_name,
       q_v.is_sent AS record_is_sent,
       ISNULL(q_v.date_modified, q_v.date_created) AS record_date,
       q_v.date_created AS record_created,
       q_v.date_modified AS record_modified,
       p_v.project_status_type_id,
       p_v.project_status_type_code,
       p_v.project_status_type_name,
       p_v.parent_customer_id,
       p_v.organization_id,
       p_v.ext_dealer_id,
       p_v.dealer_name,
       p_v.ext_customer_id,
       p_v.customer_id,
       p_v.customer_name,
       p_v.end_user_id,
       p_v.end_user_name,
       p_v.refusal_email_info,
       p_v.survey_location,
       p_v.job_name,
       r.quote_request_id,
       r.request_type_id,
       request_type.code AS request_type_code,
       request_type.name AS request_type_name,
       r.request_status_type_id,
       request_status_type.code AS request_status_type_code,
       request_status_type.name AS request_status_type_name,
       r.is_sent AS request_is_sent,
       r.dealer_po_no,
       r.customer_po_no,
       r.dealer_project_no,
       r.design_project_no,
       r.est_start_date,
       CONVERT(VARCHAR(12), r.est_start_date, 101) AS est_start_date_varchar,
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
       r.a_m_install_sup_contact_id,
       r.a_d_designer_contact_id,
       r.gen_contractor_contact_id,
       r.electrician_contact_id,
       r.data_phone_contact_id,
       r.phone_contact_id,
       r.carpet_layer_contact_id,
       r.bldg_mgr_contact_id,
       r.security_contact_id,
       r.mover_contact_id,
       r.other_contact_id,
       r.furniture1_contact_id,
       r.furniture2_contact_id,
       r.is_quoted,
       r.description,
       r.approver_contact_id,
       r.alt_customer_contact_id,
       q_v.is_sent AS quote_is_sent,
       q_v.quote_type_id,
       q_v.quote_type_code,
       q_v.quote_type_name,
       q_v.quote_status_type_id,
       q_v.quote_status_type_code,
       q_v.quote_status_type_name,
       q_v.date_quoted,
       q_v.quote_total,
       q_v.quoted_by_user_id,
       q_v.quoted_by_user_name,
       p_v.is_new
  FROM dbo.projects_v2 p_v INNER JOIN
       dbo.requests r ON p_v.project_id = r.project_id INNER JOIN
       dbo.lookups request_type ON r.request_type_id = request_type.lookup_id INNER JOIN
       dbo.lookups request_status_type ON r.request_status_type_id = request_status_type.lookup_id INNER JOIN
       dbo.quotes_v q_v  ON r.request_id = q_v.request_id
 WHERE quote_id IS NOT NULL
GO

/****** Object:  View [dbo].[extranet_email_v]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[extranet_email_v]
AS
SELECT CONVERT(VARCHAR(20), GETDATE(), 113) AS todays_date, 
       par_v.customer_name, 
       par_v.job_name, 
       par_v.project_no, 
       par_v.record_no, 
       par_v.record_id, 
       par_v.record_type_code, 
       par_v.record_type_name, 
       par_v.record_status_type_code,       
       par_v.a_m_contact_id,  
       par_v.a_m_sales_contact_id, 
       par_v.customer_contact_id, 
       par_v.customer_contact2_id, 
       par_v.customer_contact3_id, 
       par_v.customer_contact4_id, 
       par_v.d_sales_rep_contact_id, 
       par_v.d_sales_sup_contact_id, 
       par_v.d_proj_mgr_contact_id, 
       par_v.d_designer_contact_id, 
       par_v.a_m_install_sup_contact_id,
       par_v.description, 
       par_v.furniture1_contact_id, 
       par_v.furniture2_contact_id, 
       par_v.approver_contact_id, 
       par_v.alt_customer_contact_id,
       par_v.a_d_designer_contact_id, 
       par_v.gen_contractor_contact_id, 
       par_v.electrician_contact_id, 
       par_v.data_phone_contact_id, 
       par_v.carpet_layer_contact_id, 
       par_v.bldg_mgr_contact_id, 
       par_v.security_contact_id, 
       par_v.mover_contact_id, 
       par_v.phone_contact_id, 
       par_v.other_contact_id,
       par_v.refusal_email_info, 
       par_v.survey_location,
       o.scheduler_contact_id,
       customer_contact.contact_name AS customer_contact_name, 
       approver_contact.contact_name AS approver_contact_name, 
       phone_contact.contact_name AS phone_contact_name
  FROM dbo.projects_all_requests_v par_v LEFT OUTER JOIN
       dbo.organizations o ON par_v.organization_id = o.organization_id LEFT OUTER JOIN
       dbo.contacts approver_contact ON par_v.approver_contact_id = approver_contact.contact_id  LEFT OUTER JOIN
       dbo.contacts customer_contact ON par_v.customer_contact_id = customer_contact.contact_id LEFT OUTER JOIN
       dbo.contacts phone_contact ON par_v.phone_contact_id = phone_contact.contact_id
GO
/****** Object:  View [dbo].[REQUEST_MAX_VERSION_V]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[REQUEST_MAX_VERSION_V]
AS
SELECT     dbo.VERSIONS_MAX_NO_V.PROJECT_ID, dbo.VERSIONS_MAX_NO_V.PROJECT_NO, dbo.REQUESTS.REQUEST_ID, 
                      dbo.VERSIONS_MAX_NO_V.REQUEST_NO, dbo.REQUESTS.VERSION_NO, dbo.VERSIONS_MAX_NO_V.max_version_no
FROM         dbo.REQUESTS INNER JOIN
                      dbo.VERSIONS_MAX_NO_V ON dbo.REQUESTS.PROJECT_ID = dbo.VERSIONS_MAX_NO_V.PROJECT_ID AND 
                      dbo.REQUESTS.REQUEST_NO = dbo.VERSIONS_MAX_NO_V.REQUEST_NO AND 
                      dbo.REQUESTS.VERSION_NO = dbo.VERSIONS_MAX_NO_V.max_version_no
GO

/****** Object:  View [dbo].[SCH_VACATION_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[SCH_VACATION_V]
AS
SELECT     res_sch_id, RESOURCE_ID, SCH_RESOURCE_ID, WEEKEND_SCH_RESOURCE_ID, resource_name, JOB_ID, JOB_NO, SERVICE_ID,
                      HIDDEN_SERVICE_ID, actual_service_id, SERVICE_NO, FOREMAN_RESOURCE_ID, FOREMAN_USER_ID, RES_STATUS_TYPE_ID,
                      res_status_type_code, res_status_type_name, REASON_TYPE_ID, reason_type_code, reason_type_name, RES_CATEGORY_TYPE_ID,
                      res_cat_type_code, res_cat_type_name, RESOURCE_TYPE_ID, resource_type_code, resource_type_name, UNIQUE_FLAG, NOTES, PIN,
                      FOREMAN_FLAG, ACTIVE_FLAG, EXT_VENDOR_ID, employment_type_name, employment_type_code, EMPLOYMENT_TYPE_ID, USER_ID,
                      user_full_name, user_contact_id, user_contact_name, res_modified_by_name, res_modified_by, res_date_modified, res_created_by_name,
                      res_created_by, res_date_created, sch_foreman_flag, RES_START_DATE, RES_START_TIME, RES_END_DATE, DATE_CONFIRMED, RESOURCE_QTY,
                      SCH_NOTES, WEEKEND_FLAG, sch_date_created, sch_created_by, sch_created_by_name, sch_date_modified, sch_modified_by,
                      sch_modified_by_name, unconfirmed_flag
FROM         dbo.SCH_RESOURCES_V
WHERE     (reason_type_code = 'vacation')
GO

/****** Object:  View [dbo].[SCH_VACATIONS_ALL_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[SCH_VACATIONS_ALL_V]
AS
SELECT     dbo.RESOURCES_V.ORGANIZATION_ID, CAST(dbo.RESOURCES_V.RESOURCE_ID AS varchar(30)) 
                      + ':' + ISNULL(CAST(dbo.SCH_VACATION_V.SCH_RESOURCE_ID AS varchar(30)), '') AS res_sch_id, dbo.RESOURCES_V.RESOURCE_ID, 
                      dbo.RESOURCES_V.NAME AS resource_name, dbo.RESOURCES_V.RES_CATEGORY_TYPE_ID, dbo.RESOURCES_V.res_cat_type_code, 
                      dbo.RESOURCES_V.res_cat_type_name, dbo.RESOURCES_V.RESOURCE_TYPE_ID, dbo.RESOURCES_V.resource_type_code, 
                      dbo.RESOURCES_V.resource_type_name, dbo.RESOURCES_V.UNIQUE_FLAG, dbo.RESOURCES_V.USER_ID, dbo.RESOURCES_V.user_full_name, 
                      dbo.RESOURCES_V.user_contact_id, dbo.RESOURCES_V.user_contact_name, dbo.RESOURCES_V.EMPLOYMENT_TYPE_ID, 
                      dbo.RESOURCES_V.employment_type_code, dbo.RESOURCES_V.employment_type_name, dbo.RESOURCES_V.EXT_VENDOR_ID, 
                      dbo.RESOURCES_V.ACTIVE_FLAG, dbo.RESOURCES_V.FOREMAN_FLAG, dbo.RESOURCES_V.PIN, dbo.RESOURCES_V.NOTES, 
                      dbo.RESOURCES_V.DATE_CREATED, dbo.RESOURCES_V.CREATED_BY, dbo.RESOURCES_V.modified_by_name, dbo.RESOURCES_V.MODIFIED_BY, 
                      dbo.RESOURCES_V.DATE_MODIFIED, dbo.RESOURCES_V.created_by_name, dbo.SCH_VACATION_V.SCH_RESOURCE_ID, 
                      dbo.SCH_VACATION_V.JOB_ID, dbo.SCH_VACATION_V.JOB_NO, dbo.SCH_VACATION_V.SERVICE_ID, dbo.SCH_VACATION_V.SERVICE_NO, 
                      dbo.SCH_VACATION_V.HIDDEN_SERVICE_ID, dbo.SCH_VACATION_V.RES_STATUS_TYPE_ID, dbo.SCH_VACATION_V.res_status_type_code, 
                      dbo.SCH_VACATION_V.res_status_type_name, dbo.SCH_VACATION_V.REASON_TYPE_ID, dbo.SCH_VACATION_V.reason_type_code, 
                      dbo.SCH_VACATION_V.reason_type_name, dbo.SCH_VACATION_V.RES_START_DATE, dbo.SCH_VACATION_V.RES_START_TIME, 
                      dbo.SCH_VACATION_V.RES_END_DATE, dbo.SCH_VACATION_V.sch_date_created, dbo.SCH_VACATION_V.sch_created_by, 
                      dbo.SCH_VACATION_V.sch_created_by_name, dbo.SCH_VACATION_V.sch_date_modified, dbo.SCH_VACATION_V.sch_modified_by, 
                      dbo.SCH_VACATION_V.sch_modified_by_name
FROM         dbo.RESOURCES_V LEFT OUTER JOIN
                      dbo.SCH_VACATION_V ON dbo.RESOURCES_V.RESOURCE_ID = dbo.SCH_VACATION_V.RESOURCE_ID
GO
/****** Object:  View [dbo].[SCH_RESOURCE_DATES_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[SCH_RESOURCE_DATES_V]
AS
SELECT     TOP 100 PERCENT dbo.SCH_RESOURCES.SCH_RESOURCE_ID, dbo.SCH_RESOURCES.RESOURCE_ID, dbo.SCH_RESOURCES.JOB_ID, 
                      dbo.SCH_RESOURCES.SERVICE_ID, dbo.SCH_RESOURCES.RES_START_DATE, dbo.SCH_RESOURCES.RES_END_DATE, CAST(CONVERT(varchar(12), 
                      dbo.SCH_RESOURCES.RES_START_DATE + dbo.NUMBERS.number, 101) AS datetime) AS exploded_date
FROM         dbo.SCH_RESOURCES INNER JOIN
                      dbo.NUMBERS ON DATEDIFF(day, dbo.SCH_RESOURCES.RES_START_DATE, ISNULL(dbo.SCH_RESOURCES.RES_END_DATE, GETDATE())) 
                      >= dbo.NUMBERS.number
ORDER BY CAST(CONVERT(varchar(12), dbo.SCH_RESOURCES.RES_START_DATE + dbo.NUMBERS.number, 101) AS datetime) DESC
GO
/****** Object:  View [dbo].[QUOTE_REQUESTS_V]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[QUOTE_REQUESTS_V]  
AS  
SELECT r.project_id, r.project_no, r.job_name, r.request_id, r.project_request_no
, r.dealer_name, r.ext_dealer_id, r.dealer_project_no
, r.customer_name, r.customer_id, r.parent_customer_id
, r.organization_id, r.a_m_contact_name, r.is_quoted
, r.request_type_code, r.request_status_type_code, r.request_status_type_name
, ISNULL(cr.is_converted, 'N') is_converted, r.record_seq_no
, r.date_created
FROM requests_v r LEFT OUTER JOIN dbo.CONVERTED_REQUESTS_V cr
 ON r.project_id = cr.project_id
 AND r.request_no = cr.request_no
WHERE r.request_type_code = 'quote_request'
GO
/****** Object:  View [dbo].[PKT_CONTACTS_V]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[PKT_CONTACTS_V]
AS
SELECT     customer.CONTACT_NAME AS customer_name, customer.PHONE_CELL AS customer_cell, customer.PHONE_WORK AS customer_work, 
                      dealer_sr.CONTACT_NAME AS dealer_sr_name, dealer_sr.PHONE_CELL AS dealer_sr_cell, dealer_sr.PHONE_WORK AS dealer_sr_work, 
                      dealer_ss.CONTACT_NAME AS dealer_ss_name, dealer_ss.PHONE_CELL AS dealer_ss_cell, dealer_ss.PHONE_WORK AS dealer_ss_work, 
                      am.CONTACT_NAME AS am_name, am.PHONE_CELL AS am_cell, am.PHONE_WORK AS am_work, approver.CONTACT_NAME AS approver_name, 
                      approver.PHONE_CELL AS approver_cell, approver.PHONE_WORK AS approver_work, dbo.SERVICES.SERVICE_ID
FROM         dbo.REQUESTS LEFT OUTER JOIN
                      dbo.SERVICES ON dbo.REQUESTS.REQUEST_ID = dbo.SERVICES.REQUEST_ID LEFT OUTER JOIN
                      dbo.CONTACTS approver ON dbo.REQUESTS.A_M_CONTACT_ID = approver.CONTACT_ID LEFT OUTER JOIN
                      dbo.CONTACTS dealer_ss ON ISNULL(dbo.REQUESTS.D_SALES_SUP_CONTACT_ID, dbo.SERVICES.SUPPORT_CONTACT_ID) 
                      = dealer_ss.CONTACT_ID LEFT OUTER JOIN
                      dbo.CONTACTS am ON dbo.REQUESTS.A_M_CONTACT_ID = am.CONTACT_ID LEFT OUTER JOIN
                      dbo.CONTACTS dealer_sr ON ISNULL(dbo.REQUESTS.D_SALES_REP_CONTACT_ID, dbo.SERVICES.SALES_CONTACT_ID) 
                      = dealer_sr.CONTACT_ID LEFT OUTER JOIN
                      dbo.CONTACTS customer ON ISNULL(dbo.REQUESTS.CUSTOMER_CONTACT_ID, dbo.SERVICES.CUSTOMER_CONTACT_ID) = customer.CONTACT_ID
GO
/****** Object:  View [dbo].[Contact_pkf_V]    Script Date: 05/03/2010 14:18:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Contact_pkf_V]
AS
SELECT     CONTACT_ID, CONTACT_NAME, CUSTOMER_ID, CONTACT_TYPE_ID
FROM         dbo.CONTACTS
WHERE     (CUSTOMER_ID IS NULL) AND (CONTACT_TYPE_ID = 137)
GO
/****** Object:  View [dbo].[REQUEST_MAIL_V]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[REQUEST_MAIL_V]
AS
SELECT dbo.PROJECTS_ALL_REQUESTS_V.record_id
, dbo.PROJECTS_ALL_REQUESTS_V.record_type_code
, ISNULL(sales.CONTACT_NAME, 'N/A') AS sales_name
, ISNULL(sales_sup.CONTACT_NAME, 'N/A') AS sales_sup_name
, ISNULL(designer.CONTACT_NAME, 'N/A') AS designer_name
, ISNULL(proj_mgr.CONTACT_NAME, 'N/A') AS proj_mgr_name
, ISNULL(am.CONTACT_NAME, 'N/A') AS am_name
FROM  dbo.CONTACTS proj_mgr RIGHT OUTER JOIN  
                      dbo.PROJECTS_ALL_REQUESTS_V LEFT OUTER JOIN  
                      dbo.CONTACTS am ON dbo.PROJECTS_ALL_REQUESTS_V.a_m_contact_id = am.CONTACT_ID LEFT OUTER JOIN  
                      dbo.CONTACTS designer ON dbo.PROJECTS_ALL_REQUESTS_V.d_designer_contact_id = designer.CONTACT_ID ON   
                      proj_mgr.CONTACT_ID = dbo.PROJECTS_ALL_REQUESTS_V.d_proj_mgr_contact_id LEFT OUTER JOIN  
                      dbo.CONTACTS sales_sup ON dbo.PROJECTS_ALL_REQUESTS_V.d_sales_sup_contact_id = sales_sup.CONTACT_ID
                      LEFT OUTER JOIN dbo.CONTACTS sales ON dbo.PROJECTS_ALL_REQUESTS_V.d_sales_rep_contact_id = sales.CONTACT_ID
GO
/****** Object:  View [dbo].[JOB_ITEM_RATES_ECMS_V]    Script Date: 05/03/2010 14:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[JOB_ITEM_RATES_ECMS_V]
AS
SELECT     dbo.ITEMS_V.ORGANIZATION_ID, dbo.JOB_ITEM_RATES.JOB_ITEM_RATE_ID, dbo.JOB_ITEM_RATES.JOB_ID, dbo.JOB_ITEM_RATES.ITEM_ID, 
                      dbo.ITEMS_V.NAME AS item_name, dbo.ITEMS_V.ITEM_TYPE_ID, dbo.ITEMS_V.item_type_code, dbo.ITEMS_V.item_type_name, 
                      dbo.ITEMS_V.ITEM_STATUS_TYPE_ID, dbo.ITEMS_V.item_status_type_code, dbo.JOB_ITEM_RATES.RATE, dbo.JOB_ITEM_RATES.EXT_RATE_ID, 
                      dbo.JOB_ITEM_RATES.UOM_TYPE_ID, dbo.LOOKUPS.CODE AS uom_type_code, dbo.LOOKUPS.NAME AS uom_type_name, 
                      dbo.JOB_ITEM_RATES.EXT_UOM_NAME, dbo.ITEMS_V.BILLABLE_FLAG, dbo.ITEMS_V.EXPENSE_EXPORT_CODE, 
                      dbo.JOB_ITEM_RATES.DATE_CREATED, dbo.JOB_ITEM_RATES.CREATED_BY, 
                      CREATED_BY.FIRST_NAME + ' ' + CREATED_BY.LAST_NAME AS created_by_name, dbo.JOB_ITEM_RATES.DATE_MODIFIED, 
                      dbo.JOB_ITEM_RATES.MODIFIED_BY, MODIFIED_BY.FIRST_NAME + ' ' + MODIFIED_BY.LAST_NAME AS modified_by_name
FROM         dbo.ITEMS_V RIGHT OUTER JOIN
                      dbo.USERS AS CREATED_BY RIGHT OUTER JOIN
                      dbo.JOB_ITEM_RATES LEFT OUTER JOIN
                      dbo.USERS AS MODIFIED_BY ON dbo.JOB_ITEM_RATES.DATE_MODIFIED = MODIFIED_BY.USER_ID ON 
                      CREATED_BY.USER_ID = dbo.JOB_ITEM_RATES.DATE_CREATED LEFT OUTER JOIN
                      dbo.LOOKUPS ON dbo.JOB_ITEM_RATES.UOM_TYPE_ID = dbo.LOOKUPS.LOOKUP_ID ON 
                      dbo.ITEMS_V.ITEM_ID = dbo.JOB_ITEM_RATES.ITEM_ID
WHERE     (dbo.ITEMS_V.ORGANIZATION_ID = '14')
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[34] 4[20] 2[12] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ITEMS_V"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 247
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CREATED_BY"
            Begin Extent = 
               Top = 6
               Left = 285
               Bottom = 114
               Right = 478
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "JOB_ITEM_RATES"
            Begin Extent = 
               Top = 6
               Left = 516
               Bottom = 114
               Right = 694
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "MODIFIED_BY"
            Begin Extent = 
               Top = 114
               Left = 38
               Bottom = 222
               Right = 231
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "LOOKUPS"
            Begin Extent = 
               Top = 114
               Left = 269
               Bottom = 222
               Right = 451
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 9' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'JOB_ITEM_RATES_ECMS_V'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'00
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'JOB_ITEM_RATES_ECMS_V'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'JOB_ITEM_RATES_ECMS_V'
GO
/****** Object:  View [dbo].[SERVICE_ACCOUNT_REPORT_TEMP]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[SERVICE_ACCOUNT_REPORT_TEMP]
AS
SELECT     dbo.jobs_v.job_id, dbo.jobs_v.job_no, dbo.jobs_v.job_name, dbo.jobs_v.job_no_name, dbo.jobs_v.job_type_id, dbo.jobs_v.job_type_code, 
                      dbo.jobs_v.job_type_name, dbo.jobs_v.job_status_type_id, dbo.jobs_v.job_status_type_code, dbo.jobs_v.job_status_type_name, 
                      dbo.jobs_v.job_status_seq_no, dbo.jobs_v.customer_id, dbo.jobs_v.organization_id, dbo.jobs_v.dealer_name, dbo.jobs_v.ext_dealer_id, 
                      dbo.jobs_v.customer_name, dbo.jobs_v.ext_customer_id, dbo.INVOICES.INVOICE_ID, dbo.INVOICES.PO_NO, 
                      dbo.INVOICES.STATUS_ID AS invoice_status_id, dbo.INVOICE_STATUSES.CODE AS invoice_status_code, 
                      dbo.INVOICE_STATUSES.NAME AS invoice_status_name, dbo.INVOICES.DESCRIPTION AS Invoice_Desc, dbo.SERVICES.SERVICE_ID, 
                      dbo.SERVICES.SERVICE_NO, dbo.SERVICE_LINES.SERVICE_LINE_ID, dbo.SERVICES.DESCRIPTION, dbo.SERVICES.EST_START_DATE, 
                      dbo.SERVICES.SCH_START_DATE, dbo.SERVICES.PO_NO AS req_po_no, dbo.SERVICE_LINES.BILL_SERVICE_LINE_NO, 
                      dbo.SERVICE_LINES.SERVICE_LINE_DATE, dbo.SERVICE_LINES.STATUS_ID AS serv_line_status_id, dbo.SERVICE_LINES.TC_SERVICE_LINE_NO, 
                      dbo.SERVICE_LINES.TAXABLE_FLAG, dbo.SERVICE_LINES.bill_total, dbo.SERVICE_LINE_STATUSES.CODE AS serv_line_status_code, 
                      dbo.SERVICE_LINE_STATUSES.NAME AS serv_line_status_name, dbo.RESOURCES.RESOURCE_TYPE_ID, 
                      dbo.RESOURCE_TYPES_V.resource_type_code, dbo.RESOURCE_TYPES_V.resource_type_name, 
                      dbo.RESOURCES.RES_CATEGORY_TYPE_ID AS res_cat_type_id, res_cat_types.CODE AS res_cat_type_code, 
                      res_cat_types.NAME AS res_cat_type_name, dbo.SERVICE_LINES.ITEM_ID, dbo.ITEMS_V.NAME AS item_name, dbo.ITEMS_V.ITEM_TYPE_ID, 
                      dbo.ITEMS_V.item_type_name, dbo.ITEMS_V.item_type_code, dbo.ITEMS_V.BILLABLE_FLAG, dbo.SERVICE_LINES.EXT_PAY_CODE, 
                      dbo.SERVICE_LINES.BILLABLE_FLAG AS SL_BILLABLE_FLAG, dbo.SERVICE_LINES.BILL_HOURLY_RATE AS hourly_rate, 
                      dbo.SERVICE_LINES.BILL_EXP_RATE AS expense_rate, dbo.SERVICE_LINES.BILL_QTY, dbo.CUSTOM_CUST_COLUMNS_V.col1, 
                      dbo.CUSTOM_CUST_COLUMNS_V.col1_active_flag AS col1_enabled, dbo.SERVICES.CUST_COL_1, dbo.CUSTOM_CUST_COLUMNS_V.col2, 
                      dbo.CUSTOM_CUST_COLUMNS_V.col2_active_flag AS col2_enabled, dbo.SERVICES.CUST_COL_2, dbo.CUSTOM_CUST_COLUMNS_V.col3, 
                      dbo.CUSTOM_CUST_COLUMNS_V.col3_active_flag AS col3_enabled, dbo.SERVICES.CUST_COL_3, dbo.CUSTOM_CUST_COLUMNS_V.col4, 
                      dbo.CUSTOM_CUST_COLUMNS_V.col4_active_flag AS col4_enabled, dbo.SERVICES.CUST_COL_4, dbo.CUSTOM_CUST_COLUMNS_V.col5, 
                      dbo.CUSTOM_CUST_COLUMNS_V.col5_active_flag AS col5_enabled, dbo.SERVICES.CUST_COL_5, dbo.CUSTOM_CUST_COLUMNS_V.col6, 
                      dbo.CUSTOM_CUST_COLUMNS_V.col6_active_flag AS col6_enabled, dbo.SERVICES.CUST_COL_6, dbo.CUSTOM_CUST_COLUMNS_V.col7, 
                      dbo.CUSTOM_CUST_COLUMNS_V.col7_active_flag AS col7_enabled, dbo.SERVICES.CUST_COL_7, dbo.CUSTOM_CUST_COLUMNS_V.col8, 
                      dbo.CUSTOM_CUST_COLUMNS_V.col8_active_flag AS col8_enabled, dbo.SERVICES.CUST_COL_8, dbo.CUSTOM_CUST_COLUMNS_V.col9, 
                      dbo.CUSTOM_CUST_COLUMNS_V.col9_active_flag AS col9_enabled, dbo.SERVICES.CUST_COL_9, dbo.CUSTOM_CUST_COLUMNS_V.col10, 
                      dbo.CUSTOM_CUST_COLUMNS_V.col10_active_flag AS col10_enabled, dbo.SERVICES.CUST_COL_10, 
                      (CASE WHEN dbo.ITEMS_V.name NOT IN ('Keys', 'Keys-F', 'Keys-OH', 'Keys-S', 'Keys-W', 'baggies-s', 'baggies', 'baggies-w', 'baggies-f', 'boxes-s', 
                      'boxes', 'boxes-w', 'boxes-f', 'Equip Rental-S', 'Equip Rental', 'Equip Rental-W', 'Equip Rental-F', 'labels-s', 'labels', 'labels-w', 'labels-f', 'fasteners', 
                      'fasteners-f', 'fasteners-s', 'fasteners-w', 'Supplies-Exp', 'tape-s', 'tape', 'tape-w', 'tape-f', 'trash-s', 'trash', 'trash-w', 'trash-f', 'custom-s-reg', 
                      'custom-s-ot', 'custom-reg', 'custom-ot', 'custom-w-reg', 'custom-w-ot', 'custom-f-reg', 'custom-f-ot', 'ac-s-reg', 'ac-s-ot', 'ac-reg', 'ac-ot', 'ac-w-reg', 
                      'ac-w-ot', 'ac-f-reg', 'ac-f-ot', 'am-s-reg', 'am-s-ot', 'am-reg', 'am-ot', 'am-w-reg', 'am-w-ot', 'am-f-reg', 'am-f-ot', 'lead-s-reg', 'lead-s-ot', 'lead-reg', 'lead-ot', 
                      'lead-w-reg', 'lead-w-ot', 'lead-f-reg', 'lead-f-ot', 'mac-s-reg', 'mac-s-ot', 'mac-reg', 'mac-ot', 'mac-w-reg', 'mac-w-ot', 'mac-f-reg', 'mac-f-ot', 'mps-s-reg', 
                      'mps-s-ot', 'mps-reg', 'mps-ot', 'mps-w-reg', 'mps-w-ot', 'mps-f-reg', 'mps-f-ot', 'ps-s-reg', 'ps-s-ot', 'ps-reg', 'ps-ot', 'ps-w-reg', 'ps-w-ot', 'ps-f-reg', 
                      'ps-f-ot', 'Foreman-F-Reg', 'Foreman-F-OT', 'Foreman-S-Reg', 'Foreman-S-OT', 'Foreman-W-Reg', 'Foreman-W-OT', 'Proj Mgr-F-Reg', 'Proj Mgr-F-OT', 
                      'Proj Mgr-S-Reg', 'Proj Mgr-S-OT', 'Proj Mgr-W-Reg', 'Proj Mgr-W-OT', 'Gen Labor-F-Reg', 'Gen Labor-F-OT', 'Gen Labor-S-Reg', 'Gen Labor-S-OT', 
                      ' Gen Labor-W-Reg', 'Gen Labor-W-OT', 'installer-s-reg', 'installer-s-ot', 'installer-reg', 'installer-ot', 'installer-w-reg', 'installer-w-ot', 'installer-f-reg', 
                      'installer-f-ot', 'sub-s-reg', 'sub-s-ot', 'sub-ot', 'sub-req', 'sub-w-reg', 'sub-w-ot', 'sub-f-reg', 'sub-f-ot', 'subcontractor', 'Sub - Exp.-S', 'Sub - Exp.-F', 
                      'Sub - Exp.-W', 'sub-reg', 'sub-ot', 'MOVER-S-REG', 'MOVER-S-OT', 'MOVER-F-REG', 'MOVER-F-OT', 'MOVER-W-REG', 'MOVER-W-OT', 
                      'Mover-s-Reg Hrs', 'MOVER-s-OT HRS', 'Mover-Reg Hrs', 'MOVER-OT HRS', 'Mover-w-Reg Hrs', 'MOVER-w-OT HRS', 'Mover-f-Reg Hrs', 
                      'MOVER-f-OT HRS', 'pc/fab-s-reg', 'pc/fab-s-ot', 'pc/fab-reg', 'pc/fab-ot', 'pc/fab-w-reg', 'pc/fab-w-ot', 'pc/fab-f-reg', 'pc/fab-f-ot', 'am spec.-s-reg', 
                      'amspec.-s-ot', 'am spec.-reg', 'amspec.-ot', 'am spec.-w-reg', 'amspec.-w-ot', 'am spec.-f-reg', 'amspec.-f-ot', 'AssetHdlr-F-Reg', 'AssetHdlr-F-OT', 
                      'AssetHdlr-S-Reg', 'AssetHdlr-S-OT', 'AssetHdlr-W-Reg', 'AssetHdlr-W-OT', 'Snaptrack-F-OT', 'Snaptrack-S-OT', 'Snaptrack-W-OT', 'Snaptrack-F-Reg', 
                      'Snaptrack-S-Reg', 'Snaptrack-W-Reg', 'Snaptkr-W-OT', 'Snaptkr-W-Reg', 'Snaptkr-OH-OT', 'Snaptkr-OH-Reg', 'ST-OH-OT', 'ST-OH-Reg', 'whse-s-reg', 
                      'whse-s-ot', 'whse-reg', 'whse-ot', 'whse-w-reg', 'whse-w-ot', 'whse-f-reg', 'whse-f-ot', 'whse sup-s-reg', 'whse sup-s-ot', 'whse sup-reg', 'whse sup-ot', 
                      'whse sup-w-reg', 'whse sup-w-ot', 'whse sup-f-reg', 'whse sup-f-ot', 'Piece Count In', 'Piece Count Out', 'Perdiem', 'Perdiem-F', 'Perdiem-OH', 
                      'Perdiem-W', 'Perdiem-S', 'Lodging', 'Lodging-S', 'Lodging-W', 'Lodging-F', 'Lodging-OH', 'Travel', 'Travel-F', 'Travel-OH', 'Travel-W', 'TRAVEL OT', 
                      'TRAVEL REG', 'Travel-F-OT', 'Travel-F-Reg', 'Travel-OH-OT', 'Travel-OH-Reg', 'Travel-S', 'Travel-S-OT', 'Travel-S-Reg', 'Travel-W-OT', 'Travel-W-Reg', 
                      'MileOutTown-S', 'MileOutTown-W', 'MileOutTown-F', 'MileOutTown-OH', 'MileOutofTown', 'MileageInTown-s', 'MileageInTown', 'MileageInTown-w', 
                      'MileageInTown-f', 'delivery-s-reg', 'delivery-s-ot', 'delivery-reg', 'delivery-ot', 'delivery-w-reg', 'delivery-w-ot', 'delivery-f-reg', 'delivery-f-ot', 
                      'Driver-F-Reg', 'Driver-F-OT', 'Driver-S-Reg', 'Driver-S-OT', 'Driver-W-Reg', 'Driver-W-OT', 'truck-emp-s', 'truck-emp', 'truck-emp-w', 'truck-emp-f', 
                      'truck-s-reg', 'truck-w', 'truck', 'truck-w-reg', 'truck-f-reg', 'truck-s', 'van-s', 'van', 'van-w', 'van-f', 'Freight', 'Freight-S', 'Freight-OH', 'Freight-F', 'Freight-W', 
                      'campfurnmgr-s-reg', 'campfurnmgr-s-ot', 'campfurnmgr-reg', 'campfurnmgr-ot', 'campfurnmgr-w-reg', 'campfurnmgr-w-ot', 'campfurnmgr-f-reg', 
                      'campfurnmgr-f-ot', 'PC Coord-s-Reg', 'PC Coord-s-OT', 'PC Coord-Reg', 'PC Coord-OT', 'PC Coord-w-Reg', 'PC Coord-w-OT', 'PC Coord-f-Reg', 
                      'PC Coord-f-OT', 'PC Mover-s-Reg', 'PC Mover-s-OT', 'PC Mover-Reg', 'PC Mover-OT', 'PC Mover-w-Reg', 'PC Mover-w-OT', 'PC Mover-f-Reg', 
                      'PC Mover-f-OT', 'regprojmgr-s-reg', 'regprojmgr-s-ot', 'regprojmgr-reg', 'regprojmgr-ot', 'regprojmgr-w-reg', 'regprojmgr-w-ot', 'regprojmgr-f-reg', 
                      'regprojmgr-f-ot', 'EquMovLab-F-REG', 'EquMovLab-S-REG', 'EquMovLab-F-OT', 'EquMovLab-S-OT', 'OffEquMgr-F-REG', 'OffEquMgr-S-REG', 
                      'OffEquMgr-F-OT', 'OffEquMgr-S-OT', 'ProjCoor-S-REG', 'ProjCoor-F-REG', 'ProjCoor-W-REG', 'ProjCoor-S-OT', 'ProjCoor-F-OT', 'ProjCoor-W-OT') 
                      THEN dbo.SERVICE_LINES.BILL_RATE END) AS other_rate, (CASE WHEN dbo.ITEMS_V.name NOT IN ('Keys', 'Keys-F', 'Keys-OH', 'Keys-S', 'Keys-W', 
                      'baggies-s', 'baggies', 'baggies-w', 'baggies-f', 'boxes-s', 'boxes', 'boxes-w', 'boxes-f', 'Equip Rental-S', 'Equip Rental', 'fasteners', 'fasteners-f', 
                      'fasteners-s', 'fasteners-w', 'Equip Rental-W', 'Equip Rental-F', 'labels-s', 'labels', 'labels-w', 'labels-f', 'Supplies-Exp', 'tape-s', 'tape', 'tape-w', 'tape-f', 
                      'trash-s', 'trash', 'trash-w', 'trash-f', 'custom-s-reg', 'custom-s-ot', 'custom-reg', 'custom-ot', 'custom-w-reg', 'custom-w-ot', 'custom-f-reg', 'custom-f-ot', 
                      'ac-s-reg', 'ac-s-ot', 'ac-reg', 'ac-ot', 'ac-w-reg', 'ac-w-ot', 'ac-f-reg', 'ac-f-ot', 'am-s-reg', 'am-s-ot', 'am-reg', 'am-ot', 'am-w-reg', 'am-w-ot', 'am-f-reg', 
                      'am-f-ot', 'lead-s-reg', 'lead-s-ot', 'lead-reg', 'lead-ot', 'lead-w-reg', 'lead-w-ot', 'lead-f-reg', 'lead-f-ot', 'mac-s-reg', 'mac-s-ot', 'mac-reg', 'mac-ot', 
                      'mac-w-reg', 'mac-w-ot', 'mac-f-reg', 'mac-f-ot', 'mps-s-reg', 'mps-s-ot', 'mps-reg', 'mps-ot', 'mps-w-reg', 'mps-w-ot', 'mps-f-reg', 'mps-f-ot', 'ps-s-reg', 
                      'ps-s-ot', 'ps-reg', 'ps-ot', 'ps-w-reg', 'ps-w-ot', 'ps-f-reg', 'ps-f-ot', 'Foreman-F-Reg', 'Foreman-F-OT', 'Foreman-S-Reg', 'Foreman-S-OT', 
                      'Foreman-W-Reg', 'Foreman-W-OT', 'Proj Mgr-F-Reg', 'Proj Mgr-F-OT', 'Proj Mgr-S-Reg', 'Proj Mgr-S-OT', 'Proj Mgr-W-Reg', 'Proj Mgr-W-OT', 
                      'Gen Labor-F-Reg', 'Gen Labor-F-OT', 'Gen Labor-S-Reg', 'Gen Labor-S-OT', ' Gen Labor-W-Reg', 'Gen Labor-W-OT', 'installer-s-reg', 'installer-s-ot', 
                      'installer-reg', 'installer-ot', 'installer-w-reg', 'installer-w-ot', 'installer-f-reg', 'installer-f-ot', 'sub-s-reg', 'sub-s-ot', 'sub-ot', 'sub-req', 'sub-w-reg', 
                      'sub-w-ot', 'sub-f-reg', 'sub-f-ot', 'subcontractor', 'Sub - Exp.-S', 'Sub - Exp.-F', 'Sub - Exp.-W', 'sub-reg', 'sub-ot', 'MOVER-S-REG', 'MOVER-S-OT', 
                      'MOVER-F-REG', 'MOVER-F-OT', 'MOVER-W-REG', 'MOVER-W-OT', 'Mover-s-Reg Hrs', 'MOVER-s-OT HRS', 'Mover-Reg Hrs', 'MOVER-OT HRS', 
                      'Mover-w-Reg Hrs', 'MOVER-w-OT HRS', 'Mover-f-Reg Hrs', 'MOVER-f-OT HRS', 'pc/fab-s-reg', 'pc/fab-s-ot', 'pc/fab-reg', 'pc/fab-ot', 'pc/fab-w-reg', 
                      'pc/fab-w-ot', 'pc/fab-f-reg', 'pc/fab-f-ot', 'am spec.-s-reg', 'amspec.-s-ot', 'am spec.-reg', 'amspec.-ot', 'am spec.-w-reg', 'amspec.-w-ot', 'am spec.-f-reg', 
                      'amspec.-f-ot', 'AssetHdlr-F-Reg', 'AssetHdlr-F-OT', 'AssetHdlr-S-Reg', 'AssetHdlr-S-OT', 'AssetHdlr-W-Reg', 'AssetHdlr-W-OT', 'Snaptrack-F-OT', 
                      'Snaptrack-S-OT', 'Snaptrack-W-OT', 'Snaptrack-F-Reg', 'Snaptrack-S-Reg', 'Snaptrack-W-Reg', 'Snaptkr-W-OT', 'Snaptkr-W-Reg', 'Snaptkr-OH-OT', 
                      'Snaptkr-OH-Reg', 'ST-OH-OT', 'ST-OH-Reg', 'whse-s-reg', 'whse-s-ot', 'whse-reg', 'whse-ot', 'whse-w-reg', 'whse-w-ot', 'whse-f-reg', 'whse-f-ot', 
                      'whse sup-s-reg', 'whse sup-s-ot', 'whse sup-reg', 'whse sup-ot', 'whse sup-w-reg', 'whse sup-w-ot', 'whse sup-f-reg', 'whse sup-f-ot', 'Piece Count In', 
                      'Piece Count Out', 'Perdiem', 'Perdiem-F', 'Perdiem-OH', 'Perdiem-W', 'Perdiem-S', 'Lodging', 'Lodging-S', 'Lodging-W', 'Lodging-F', 'Lodging-OH', 
                      'Travel', 'Travel-F', 'Travel-OH', 'Travel-W', 'TRAVEL OT', 'TRAVEL REG', 'Travel-F-OT', 'Travel-F-Reg', 'Travel-OH-OT', 'Travel-OH-Reg', 'Travel-S', 
                      'Travel-S-OT', 'Travel-S-Reg', 'Travel-W-OT', 'Travel-W-Reg', 'MileOutTown-S', 'MileOutTown-W', 'MileOutTown-F', 'MileOutTown-OH', 'MileOutofTown', 
                      'MileageInTown-s', 'MileageInTown', 'MileageInTown-w', 'MileageInTown-f', 'delivery-s-reg', 'delivery-s-ot', 'delivery-reg', 'delivery-ot', 'delivery-w-reg', 
                      'delivery-w-ot', 'delivery-f-reg', 'delivery-f-ot', 'Driver-F-Reg', 'Driver-F-OT', 'Driver-S-Reg', 'Driver-S-OT', 'Driver-W-Reg', 'Driver-W-OT', 'truck-emp-s', 
                      'truck-emp', 'truck-emp-w', 'truck-emp-f', 'truck-s-reg', 'truck-w', 'truck', 'truck-w-reg', 'truck-f-reg', 'truck-s', 'van-s', 'van', 'van-w', 'van-f', 'Freight', 
                      'Freight-S', 'Freight-OH', 'Freight-F', 'Freight-W', 'campfurnmgr-s-reg', 'campfurnmgr-s-ot', 'campfurnmgr-reg', 'campfurnmgr-ot', 'campfurnmgr-w-reg', 
                      'campfurnmgr-w-ot', 'campfurnmgr-f-reg', 'campfurnmgr-f-ot', 'PC Coord-s-Reg', 'PC Coord-s-OT', 'PC Coord-Reg', 'PC Coord-OT', 'PC Coord-w-Reg', 
                      'PC Coord-w-OT', 'PC Coord-f-Reg', 'PC Coord-f-OT', 'PC Mover-s-Reg', 'PC Mover-s-OT', 'PC Mover-Reg', 'PC Mover-OT', 'PC Mover-w-Reg', 
                      'PC Mover-w-OT', 'PC Mover-f-Reg', 'PC Mover-f-OT', 'regprojmgr-s-reg', 'regprojmgr-s-ot', 'regprojmgr-reg', 'regprojmgr-ot', 'regprojmgr-w-reg', 
                      'regprojmgr-w-ot', 'regprojmgr-f-reg', 'regprojmgr-f-ot', 'EquMovLab-F-REG', 'EquMovLab-S-REG', 'EquMovLab-F-OT', 'EquMovLab-S-OT', 
                      'OffEquMgr-F-REG', 'OffEquMgr-S-REG', 'OffEquMgr-F-OT', 'OffEquMgr-S-OT', 'ProjCoor-S-REG', 'ProjCoor-F-REG', 'ProjCoor-W-REG', 'ProjCoor-S-OT', 
                      'ProjCoor-F-OT', 'ProjCoor-W-OT') THEN dbo.SERVICE_LINES.BILL_QTY END) AS other_qty, (CASE WHEN dbo.ITEMS_V.name NOT IN ('Keys', 'Keys-F', 
                      'Keys-OH', 'Keys-S', 'Keys-W', 'baggies-s', 'baggies', 'baggies-w', 'baggies-f', 'boxes-s', 'boxes', 'boxes-w', 'boxes-f', 'Equip Rental-S', 'fasteners', 
                      'fasteners-f', 'fasteners-s', 'fasteners-w', 'Equip Rental', 'Equip Rental-W', 'Equip Rental-F', 'labels-s', 'labels', 'labels-w', 'labels-f', 'Supplies-Exp', 
                      'tape-s', 'tape', 'tape-w', 'tape-f', 'trash-s', 'trash', 'trash-w', 'trash-f', 'custom-s-reg', 'custom-s-ot', 'custom-reg', 'custom-ot', 'custom-w-reg', 
                      'custom-w-ot', 'custom-f-reg', 'custom-f-ot', 'ac-s-reg', 'ac-s-ot', 'ac-reg', 'ac-ot', 'ac-w-reg', 'ac-w-ot', 'ac-f-reg', 'ac-f-ot', 'am-s-reg', 'am-s-ot', 'am-reg', 
                      'am-ot', 'am-w-reg', 'am-w-ot', 'am-f-reg', 'am-f-ot', 'lead-s-reg', 'lead-s-ot', 'lead-reg', 'lead-ot', 'lead-w-reg', 'lead-w-ot', 'lead-f-reg', 'lead-f-ot', 
                      'mac-s-reg', 'mac-s-ot', 'mac-reg', 'mac-ot', 'mac-w-reg', 'mac-w-ot', 'mac-f-reg', 'mac-f-ot', 'mps-s-reg', 'mps-s-ot', 'mps-reg', 'mps-ot', 'mps-w-reg', 
                      'mps-w-ot', 'mps-f-reg', 'mps-f-ot', 'ps-s-reg', 'ps-s-ot', 'ps-reg', 'ps-ot', 'ps-w-reg', 'ps-w-ot', 'ps-f-reg', 'ps-f-ot', 'Foreman-F-Reg', 'Foreman-F-OT', 
                      'Foreman-S-Reg', 'Foreman-S-OT', 'Foreman-W-Reg', 'Foreman-W-OT', 'Proj Mgr-F-Reg', 'Proj Mgr-F-OT', 'Proj Mgr-S-Reg', 'Proj Mgr-S-OT', 
                      'Proj Mgr-W-Reg', 'Proj Mgr-W-OT', 'Gen Labor-F-Reg', 'Gen Labor-F-OT', 'Gen Labor-S-Reg', 'Gen Labor-S-OT', ' Gen Labor-W-Reg', 'Gen Labor-W-OT', 
                      'installer-s-reg', 'installer-s-ot', 'installer-reg', 'installer-ot', 'installer-w-reg', 'installer-w-ot', 'installer-f-reg', 'installer-f-ot', 'sub-s-reg', 'sub-s-ot', 'sub-ot',
                       'sub-req', 'sub-w-reg', 'sub-w-ot', 'sub-f-reg', 'sub-f-ot', 'subcontractor', 'Sub - Exp.-S', 'Sub - Exp.-F', 'Sub - Exp.-W', 'sub-reg', 'sub-ot', 'MOVER-S-REG', 
                      'MOVER-S-OT', 'MOVER-F-REG', 'MOVER-F-OT', 'MOVER-W-REG', 'MOVER-W-OT', 'Mover-s-Reg Hrs', 'MOVER-s-OT HRS', 'Mover-Reg Hrs', 
                      'MOVER-OT HRS', 'Mover-w-Reg Hrs', 'MOVER-w-OT HRS', 'Mover-f-Reg Hrs', 'MOVER-f-OT HRS', 'pc/fab-s-reg', 'pc/fab-s-ot', 'pc/fab-reg', 'pc/fab-ot', 
                      'pc/fab-w-reg', 'pc/fab-w-ot', 'pc/fab-f-reg', 'pc/fab-f-ot', 'am spec.-s-reg', 'amspec.-s-ot', 'am spec.-reg', 'amspec.-ot', 'am spec.-w-reg', 'amspec.-w-ot', 
                      'am spec.-f-reg', 'amspec.-f-ot', 'AssetHdlr-F-Reg', 'AssetHdlr-F-OT', 'AssetHdlr-S-Reg', 'AssetHdlr-S-OT', 'AssetHdlr-W-Reg', 'AssetHdlr-W-OT', 
                      'Snaptrack-F-OT', 'Snaptrack-S-OT', 'Snaptrack-W-OT', 'Snaptrack-F-Reg', 'Snaptrack-S-Reg', 'Snaptrack-W-Reg', 'Snaptkr-W-OT', 'Snaptkr-W-Reg', 
                      'Snaptkr-OH-OT', 'Snaptkr-OH-Reg', 'ST-OH-OT', 'ST-OH-Reg', 'whse-s-reg', 'whse-s-ot', 'whse-reg', 'whse-ot', 'whse-w-reg', 'whse-w-ot', 'whse-f-reg', 
                      'whse-f-ot', 'whse sup-s-reg', 'whse sup-s-ot', 'whse sup-reg', 'whse sup-ot', 'whse sup-w-reg', 'whse sup-w-ot', 'whse sup-f-reg', 'whse sup-f-ot', 
                      'Piece Count In', 'Piece Count Out', 'Perdiem', 'Perdiem-F', 'Perdiem-OH', 'Perdiem-W', 'Perdiem-S', 'Lodging', 'Lodging-S', 'Lodging-W', 'Lodging-F', 
                      'Lodging-OH', 'Travel', 'Travel-F', 'Travel-OH', 'Travel-W', 'TRAVEL OT', 'TRAVEL REG', 'Travel-F-OT', 'Travel-F-Reg', 'Travel-OH-OT', 'Travel-OH-Reg', 
                      'Travel-S', 'Travel-S-OT', 'Travel-S-Reg', 'Travel-W-OT', 'Travel-W-Reg', 'MileOutTown-S', 'MileOutTown-W', 'MileOutTown-F', 'MileOutTown-OH', 
                      'MileOutofTown', 'MileageInTown-s', 'MileageInTown', 'MileageInTown-w', 'MileageInTown-f', 'delivery-s-reg', 'delivery-s-ot', 'delivery-reg', 'delivery-ot', 
                      'delivery-w-reg', 'delivery-w-ot', 'delivery-f-reg', 'delivery-f-ot', 'Driver-F-Reg', 'Driver-F-OT', 'Driver-S-Reg', 'Driver-S-OT', 'Driver-W-Reg', 'Driver-W-OT', 
                      'truck-emp-s', 'truck-emp', 'truck-emp-w', 'truck-emp-f', 'truck-s-reg', 'truck-w', 'truck', 'truck-w-reg', 'truck-f-reg', 'truck-s', 'van-s', 'van', 'van-w', 'van-f', 
                      'Freight', 'Freight-S', 'Freight-OH', 'Freight-F', 'Freight-W', 'campfurnmgr-s-reg', 'campfurnmgr-s-ot', 'campfurnmgr-reg', 'campfurnmgr-ot', 
                      'campfurnmgr-w-reg', 'campfurnmgr-w-ot', 'campfurnmgr-f-reg', 'campfurnmgr-f-ot', 'PC Coord-s-Reg', 'PC Coord-s-OT', 'PC Coord-Reg', 'PC Coord-OT', 
                      'PC Coord-w-Reg', 'PC Coord-w-OT', 'PC Coord-f-Reg', 'PC Coord-f-OT', 'PC Mover-s-Reg', 'PC Mover-s-OT', 'PC Mover-Reg', 'PC Mover-OT', 
                      'PC Mover-w-Reg', 'PC Mover-w-OT', 'PC Mover-f-Reg', 'PC Mover-f-OT', 'regprojmgr-s-reg', 'regprojmgr-s-ot', 'regprojmgr-reg', 'regprojmgr-ot', 
                      'regprojmgr-w-reg', 'regprojmgr-w-ot', 'regprojmgr-f-reg', 'regprojmgr-f-ot', 'EquMovLab-F-REG', 'EquMovLab-S-REG', 'EquMovLab-F-OT', 
                      'EquMovLab-S-OT', 'OffEquMgr-F-REG', 'OffEquMgr-S-REG', 'OffEquMgr-F-OT', 'OffEquMgr-S-OT', 'ProjCoor-S-REG', 'ProjCoor-F-REG', 'ProjCoor-W-REG', 
                      'ProjCoor-S-OT', 'ProjCoor-F-OT', 'ProjCoor-W-OT') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS other_total, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('baggies', 'baggies-f', 'baggies-s', 'baggies-w') THEN dbo.SERVICE_LINES.BILL_RATE END) AS baggies_rate, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('baggies', 'baggies-f', 'baggies-s', 'baggies-w') THEN dbo.SERVICE_LINES.BILL_QTY END) AS baggies_qty, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('baggies', 'baggies-f', 'baggies-s', 'baggies-w') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS baggies_total, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('boxes', 'boxes-f', 'boxes-s', 'boxes-w') THEN dbo.SERVICE_LINES.BILL_RATE END) AS boxes_rate, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('boxes', 'boxes-f', 'boxes-s', 'boxes-w') THEN dbo.SERVICE_LINES.BILL_QTY END) AS boxes_qty, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('boxes', 'boxes-f', 'boxes-s', 'boxes-w') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS boxes_total, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('labels', 'labels-f', 'labels-s', 'labels-w') THEN dbo.SERVICE_LINES.BILL_RATE END) AS labels_rate, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('labels', 'labels-f', 'labels-s', 'labels-w') THEN dbo.SERVICE_LINES.BILL_QTY END) AS labels_qty, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('labels', 'labels-f', 'labels-s', 'labels-w') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS labels_total, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('tape', 'tape-f', 'tape-s', 'tape-w') THEN dbo.SERVICE_LINES.BILL_RATE END) AS tape_rate, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('tape', 'tape-f', 'tape-s', 'tape-w') THEN dbo.SERVICE_LINES.BILL_QTY END) AS tape_qty, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('tape', 'tape-f', 'tape-s', 'tape-w') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS tape_total, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('Supplies-Exp', 'fasteners', 'fasteners-f', 'fasteners-s', 'fasteners-w') THEN dbo.SERVICE_LINES.BILL_RATE END) 
                      AS supplies_rate, (CASE WHEN dbo.ITEMS_V.name IN ('Supplies-Exp', 'fasteners', 'fasteners-f', 'fasteners-s', 'fasteners-w') 
                      THEN dbo.SERVICE_LINES.BILL_QTY END) AS supplies_qty, (CASE WHEN dbo.ITEMS_V.name IN ('Supplies-Exp', 'fasteners', 'fasteners-f', 
                      'fasteners-s', 'fasteners-w') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS supplies_total, (CASE WHEN dbo.ITEMS_V.name IN ('trash', 'trash-f', 
                      'trash-s', 'trash-w') THEN dbo.SERVICE_LINES.BILL_RATE END) AS trash_rate, (CASE WHEN dbo.ITEMS_V.name IN ('trash', 'trash-f', 'trash-s', 'trash-w') 
                      THEN dbo.SERVICE_LINES.BILL_QTY END) AS trash_qty, (CASE WHEN dbo.ITEMS_V.name IN ('trash', 'trash-f', 'trash-s', 'trash-w') 
                      THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS trash_total, (CASE WHEN dbo.ITEMS_V.name IN ('Equip Rental', 'Equip Rental-F', 'Equip Rental-S', 
                      'Equip Rental-W', 'BOOKCARTS-A&M', 'BOOKCARTS-A&M-f', 'BOOKCARTS-A&M-s', 'BOOKCARTS-A&M-w', 'DOLLIES-A&M', 'DOLLIES-A&M-f', 
                      'DOLLIES-A&M-s', 'DOLLIES-A&M-w') THEN dbo.SERVICE_LINES.BILL_RATE END) AS EquipRental_rate, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('Equip Rental', 'Equip Rental-F', 'Equip Rental-S', 'Equip Rental-W', 'BOOKCARTS-A&M', 'BOOKCARTS-A&M-f', 
                      'BOOKCARTS-A&M-s', 'BOOKCARTS-A&M-w', 'DOLLIES-A&M', 'DOLLIES-A&M-f', 'DOLLIES-A&M-s', 'DOLLIES-A&M-w') 
                      THEN dbo.SERVICE_LINES.BILL_QTY END) AS EquipRental_qty, (CASE WHEN dbo.ITEMS_V.name IN ('Equip Rental', 'Equip Rental-F', 
                      'Equip Rental-S', 'Equip Rental-W', 'BOOKCARTS-A&M', 'BOOKCARTS-A&M-f', 'BOOKCARTS-A&M-s', 'BOOKCARTS-A&M-w', 'DOLLIES-A&M', 
                      'DOLLIES-A&M-f', 'DOLLIES-A&M-s', 'DOLLIES-A&M-w') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS EquipRental_total, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('Keys', 'Keys-F', 'Keys-OH', 'Keys-S', 'Keys-W') THEN dbo.SERVICE_LINES.BILL_RATE END) AS keys_rate, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('Keys', 'Keys-F', 'Keys-OH', 'Keys-S', 'Keys-W') THEN dbo.SERVICE_LINES.BILL_QTY END) AS keys_qty, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('Keys', 'Keys-F', 'Keys-OH', 'Keys-S', 'Keys-W') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS keys_total, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('custom-reg', 'custom-f-reg', 'custom-s-reg', 'custom-w-reg') THEN dbo.SERVICE_LINES.BILL_RATE END) 
                      AS custom_reg_rate, (CASE WHEN dbo.ITEMS_V.name IN ('custom-reg', 'custom-f-reg', 'custom-s-reg', 'custom-w-reg') 
                      THEN dbo.SERVICE_LINES.BILL_QTY END) AS custom_reg_qty, (CASE WHEN dbo.ITEMS_V.name IN ('custom-reg', 'custom-f-reg', 'custom-s-reg', 
                      'custom-w-reg') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS custom_reg_total, (CASE WHEN dbo.ITEMS_V.name IN ('custom-ot', 'custom-f-ot', 
                      'custom-s-ot', 'custom-w-ot') THEN dbo.SERVICE_LINES.BILL_RATE END) AS custom_ot_rate, (CASE WHEN dbo.ITEMS_V.name IN ('custom-ot', 
                      'custom-f-ot', 'custom-s-ot', 'custom-w-ot') THEN dbo.SERVICE_LINES.BILL_QTY END) AS custom_ot_qty, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('custom-ot', 'custom-f-ot', 'custom-s-ot', 'custom-w-ot') THEN dbo.SERVICE_LINES.BILL_TOTAL END) 
                      AS custom_ot_total, (CASE WHEN dbo.ITEMS_V.name IN ('delivery-reg', 'delivery-f-reg', 'delivery-s-reg', 'delivery-w-reg') 
                      THEN dbo.SERVICE_LINES.BILL_RATE END) AS delivery_reg_rate, (CASE WHEN dbo.ITEMS_V.name IN ('delivery-reg', 'delivery-f-reg', 'delivery-s-reg', 
                      'delivery-w-reg') THEN dbo.SERVICE_LINES.BILL_QTY END) AS delivery_reg_qty, (CASE WHEN dbo.ITEMS_V.name IN ('delivery-reg', 'delivery-f-reg', 
                      'delivery-s-reg', 'delivery-w-reg') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS delivery_reg_total, (CASE WHEN dbo.ITEMS_V.name IN ('delivery-ot',
                       'delivery-f-ot', 'delivery-s-ot', 'delivery-w-ot') THEN dbo.SERVICE_LINES.BILL_RATE END) AS delivery_ot_rate, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('delivery-ot', 'delivery-f-ot', 'delivery-s-ot', 'delivery-w-ot') THEN dbo.SERVICE_LINES.BILL_QTY END) 
                      AS delivery_ot_qty, (CASE WHEN dbo.ITEMS_V.name IN ('delivery-ot', 'delivery-f-ot', 'delivery-s-ot', 'delivery-w-ot') 
                      THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS delivery_ot_total, (CASE WHEN dbo.ITEMS_V.name IN ('driver-f-reg', 'driver-s-reg', 'driver-w-reg') 
                      THEN dbo.SERVICE_LINES.BILL_RATE END) AS driver_reg_rate, (CASE WHEN dbo.ITEMS_V.name IN ('driver-f-reg', 'driver-s-reg', 'driver-w-reg') 
                      THEN dbo.SERVICE_LINES.BILL_QTY END) AS driver_reg_qty, (CASE WHEN dbo.ITEMS_V.name IN ('driver-f-reg', 'driver-s-reg', 'driver-w-reg') 
                      THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS driver_reg_total, (CASE WHEN dbo.ITEMS_V.name IN ('driver-f-ot', 'driver-s-ot', 'driver-w-ot') 
                      THEN dbo.SERVICE_LINES.BILL_RATE END) AS driver_ot_rate, (CASE WHEN dbo.ITEMS_V.name IN ('driver-f-ot', 'driver-s-ot', 'driver-w-ot') 
                      THEN dbo.SERVICE_LINES.BILL_QTY END) AS driver_ot_qty, (CASE WHEN dbo.ITEMS_V.name IN ('driver-f-ot', 'driver-s-ot', 'driver-w-ot') 
                      THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS driver_ot_total, (CASE WHEN dbo.ITEMS_V.name IN ('truck-reg', 'truck-f-reg', 'truck-s-reg', 
                      'truck-w-reg', 'truck-w', 'truck-s', 'truck-emp', 'truck-emp-f', 'truck-emp-s', 'truck-emp-w') THEN dbo.SERVICE_LINES.BILL_RATE END) AS truck_rate, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('truck-reg', 'truck-f-reg', 'truck-s-reg', 'truck-w-reg', 'truck-s', 'truck-w', 'truck-emp', 'truck-emp-f', 'truck-emp-s', 
                      'truck-emp-w') THEN dbo.SERVICE_LINES.BILL_QTY END) AS truck_qty, (CASE WHEN dbo.ITEMS_V.name IN ('truck-reg', 'truck-f-reg', 'truck-s-reg', 
                      'truck-w-reg', 'truck-s', 'truck-w', 'truck-emp', 'truck-emp-f', 'truck-emp-s', 'truck-emp-w') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS truck_total, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('Van', 'Van-f', 'Van-s', 'Van-w') THEN dbo.SERVICE_LINES.BILL_RATE END) AS van_rate, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('Van', 'Van-f', 'Van-s', 'Van-w') THEN dbo.SERVICE_LINES.BILL_QTY END) AS van_qty, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('Van', 'Van-f', 'Van-s', 'Van-w') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS van_total, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('MileageInTown', 'MileageInTown-f', 'MileageInTown-s', 'MileageInTown-w') 
                      THEN dbo.SERVICE_LINES.BILL_RATE END) AS MileageInTown_rate, (CASE WHEN dbo.ITEMS_V.name IN ('MileageInTown', 'MileageInTown-f', 
                      'MileageInTown-s', 'MileageInTown-w') THEN dbo.SERVICE_LINES.BILL_QTY END) AS MileageInTown_qty, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('MileageInTown', 'MileageInTown-f', 'MileageInTown-s', 'MileageInTown-w') 
                      THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS MileageInTown_total, (CASE WHEN dbo.ITEMS_V.name IN ('MileOutTown-S', 'MileOutTown-W', 
                      'MileOutTown-F', 'MileOutTown-OH', 'MileOutofTown') THEN dbo.SERVICE_LINES.BILL_RATE END) AS MileageOutTown_rate, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('MileOutTown-S', 'MileOutTown-W', 'MileOutTown-F', 'MileOutTown-OH', 'MileOutofTown') 
                      THEN dbo.SERVICE_LINES.BILL_QTY END) AS MileageOutTown_qty, (CASE WHEN dbo.ITEMS_V.name IN ('MileOutTown-S', 'MileOutTown-W', 
                      'MileOutTown-F', 'MileOutTown-OH', 'MileOutofTown') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS MileageOutTown_total, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('installer-reg', 'installer-f-reg', 'installer-s-reg', 'installer-w-reg') THEN dbo.SERVICE_LINES.BILL_RATE END) 
                      AS installer_reg_rate, (CASE WHEN dbo.ITEMS_V.name IN ('installer-reg', 'installer-f-reg', 'installer-s-reg', 'installer-w-reg') 
                      THEN dbo.SERVICE_LINES.BILL_QTY END) AS installer_reg_qty, (CASE WHEN dbo.ITEMS_V.name IN ('installer-reg', 'installer-f-reg', 'installer-s-reg', 
                      'installer-w-reg') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS installer_reg_total, (CASE WHEN dbo.ITEMS_V.name IN ('installer-ot', 'installer-f-ot', 
                      'installer-s-ot', 'installer-w-ot') THEN dbo.SERVICE_LINES.BILL_RATE END) AS installer_ot_rate, (CASE WHEN dbo.ITEMS_V.name IN ('installer-ot', 
                      'installer-f-ot', 'installer-s-ot', 'installer-w-ot') THEN dbo.SERVICE_LINES.BILL_QTY END) AS installer_ot_qty, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('installer-ot', 'installer-f-ot', 'installer-s-ot', 'installer-w-ot') THEN dbo.SERVICE_LINES.BILL_TOTAL END) 
                      AS installer_ot_total, (CASE WHEN dbo.ITEMS_V.name IN ('sub-reg', 'sub-f-reg', 'sub-s-reg', 'sub-w-reg', 'subcontractor') 
                      THEN dbo.SERVICE_LINES.BILL_RATE END) AS sub_reg_rate, (CASE WHEN dbo.ITEMS_V.name IN ('sub-reg', 'sub-f-reg', 'sub-s-reg', 'sub-w-reg', 
                      'subcontractor') THEN dbo.SERVICE_LINES.BILL_QTY END) AS sub_reg_qty, (CASE WHEN dbo.ITEMS_V.name IN ('sub-reg', 'sub-f-reg', 'sub-s-reg', 
                      'sub-w-reg', 'subcontractor') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS sub_reg_total, (CASE WHEN dbo.ITEMS_V.name IN ('sub-ot', 'sub-f-ot', 
                      'sub-s-ot', 'sub-w-ot') THEN dbo.SERVICE_LINES.BILL_RATE END) AS sub_ot_rate, (CASE WHEN dbo.ITEMS_V.name IN ('sub-ot', 'sub-f-ot', 'sub-s-ot', 
                      'sub-w-ot') THEN dbo.SERVICE_LINES.BILL_QTY END) AS sub_ot_qty, (CASE WHEN dbo.ITEMS_V.name IN ('sub-ot', 'sub-f-ot', 'sub-s-ot', 'sub-w-ot') 
                      THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS sub_ot_total, (CASE WHEN dbo.ITEMS_V.name IN ('Sub - Exp.-F', 'Sub - Exp.-W', 'Sub - Exp.-S') 
                      THEN dbo.SERVICE_LINES.BILL_RATE END) AS sub_exp_rate, (CASE WHEN dbo.ITEMS_V.name IN ('Sub - Exp.-F', 'Sub - Exp.-W', 'Sub - Exp.-S') 
                      THEN dbo.SERVICE_LINES.BILL_QTY END) AS sub_exp_qty, (CASE WHEN dbo.ITEMS_V.name IN ('Sub - Exp.-F', 'Sub - Exp.-W', 'Sub - Exp.-S') 
                      THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS sub_exp_total, (CASE WHEN dbo.ITEMS_V.name IN ('Gen Labor-f-reg', 'Gen Labor-s-reg', 
                      'Gen Labor-w-reg') THEN dbo.SERVICE_LINES.BILL_RATE END) AS GenLabor_reg_rate, (CASE WHEN dbo.ITEMS_V.name IN ('Gen Labor-f-reg', 
                      'Gen Labor-s-reg', 'Gen Labor-w-reg') THEN dbo.SERVICE_LINES.BILL_QTY END) AS GenLabor_reg_qty, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('Gen Labor-f-reg', 'Gen Labor-s-reg', 'Gen Labor-w-reg') THEN dbo.SERVICE_LINES.BILL_TOTAL END) 
                      AS GenLabor_reg_total, (CASE WHEN dbo.ITEMS_V.name IN ('Gen Labor-f-ot', 'Gen Labor-s-ot', 'Gen Labor-w-ot') 
                      THEN dbo.SERVICE_LINES.BILL_RATE END) AS GenLabor_ot_rate, (CASE WHEN dbo.ITEMS_V.name IN ('Gen Labor-f-ot', 'Gen Labor-s-ot', 
                      'Gen Labor-w-ot') THEN dbo.SERVICE_LINES.BILL_QTY END) AS GenLabor_ot_qty, (CASE WHEN dbo.ITEMS_V.name IN ('Gen Labor-f-ot', 
                      'Gen Labor-s-ot', 'Gen Labor-w-ot') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS GenLabor_ot_total, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('Mover-Reg Hrs', 'Mover-f-Reg Hrs', 'Mover-s-Reg Hrs', 'Mover-w-Reg Hrs', 'Mover-Reg', 'Mover-f-Reg', 
                      'Mover-s-Reg', 'Mover-w-Reg') THEN dbo.SERVICE_LINES.BILL_RATE END) AS Mover_Reg_Hrs_rate, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('Mover-Reg Hrs', 'Mover-f-Reg Hrs', 'Mover-s-Reg Hrs', 'Mover-w-Reg Hrs', 'Mover-Reg', 'Mover-f-Reg', 
                      'Mover-s-Reg', 'Mover-w-Reg') THEN dbo.SERVICE_LINES.BILL_QTY END) AS Mover_Reg_Hrs_qty, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('Mover-Reg Hrs', 'Mover-f-Reg Hrs', 'Mover-s-Reg Hrs', 'Mover-w-Reg Hrs', 'Mover-Reg', 'Mover-f-Reg', 
                      'Mover-s-Reg', 'Mover-w-Reg') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS Mover_Reg_Hrs_total, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('Mover-OT Hrs', 'Mover-f-OT Hrs', 'Mover-s-OT Hrs', 'Mover-w-OT Hrs', 'Mover-OT', 'Mover-f-OT', 'Mover-s-OT', 
                      'Mover-w-OT') THEN dbo.SERVICE_LINES.BILL_RATE END) AS Mover_OT_Hrs_rate, (CASE WHEN dbo.ITEMS_V.name IN ('Mover-OT Hrs', 
                      'Mover-f-OT Hrs', 'Mover-s-OT Hrs', 'Mover-w-OT Hrs', 'Mover-OT', 'Mover-f-OT', 'Mover-s-OT', 'Mover-w-OT') 
                      THEN dbo.SERVICE_LINES.BILL_QTY END) AS Mover_OT_Hrs_qty, (CASE WHEN dbo.ITEMS_V.name IN ('Mover-OT Hrs', 'Mover-f-OT Hrs', 
                      'Mover-s-OT Hrs', 'Mover-w-OT Hrs', 'Mover-OT', 'Mover-f-OT', 'Mover-s-OT', 'Mover-w-OT') THEN dbo.SERVICE_LINES.BILL_TOTAL END) 
                      AS Mover_OT_Hrs_total, (CASE WHEN dbo.ITEMS_V.name IN ('pc/fab-reg', 'pc/fab-f-reg', 'pc/fab-s-reg', 'pc/fab-w-reg') 
                      THEN dbo.SERVICE_LINES.BILL_RATE END) AS pc_fab_reg_rate, (CASE WHEN dbo.ITEMS_V.name IN ('pc/fab-reg', 'pc/fab-f-reg', 'pc/fab-s-reg', 
                      'pc/fab-w-reg') THEN dbo.SERVICE_LINES.BILL_QTY END) AS pc_fab_reg_qty, (CASE WHEN dbo.ITEMS_V.name IN ('pc/fab-reg', 'pc/fab-f-reg', 
                      'pc/fab-s-reg', 'pc/fab-w-reg') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS pc_fab_reg_total, (CASE WHEN dbo.ITEMS_V.name IN ('pc/fab-ot', 
                      'pc/fab-f-ot', 'pc/fab-s-ot', 'pc/fab-w-ot') THEN dbo.SERVICE_LINES.BILL_RATE END) AS pc_fab_ot_rate, (CASE WHEN dbo.ITEMS_V.name IN ('pc/fab-ot', 
                      'pc/fab-f-ot', 'pc/fab-s-ot', 'pc/fab-w-ot') THEN dbo.SERVICE_LINES.BILL_QTY END) AS pc_fab_ot_qty, (CASE WHEN dbo.ITEMS_V.name IN ('pc/fab-ot', 
                      'pc/fab-f-ot', 'pc/fab-s-ot', 'pc/fab-w-ot') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS pc_fab_ot_total, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('Foreman-f-reg', 'Foreman-s-reg', 'Foreman-w-reg') THEN dbo.SERVICE_LINES.BILL_RATE END) 
                      AS Foreman_reg_rate, (CASE WHEN dbo.ITEMS_V.name IN ('Foreman-f-reg', 'Foreman-s-reg', 'Foreman-w-reg') 
                      THEN dbo.SERVICE_LINES.BILL_QTY END) AS Foreman_reg_qty, (CASE WHEN dbo.ITEMS_V.name IN ('Foreman-f-reg', 'Foreman-s-reg', 
                      'Foreman-w-reg') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS Foreman_reg_total, (CASE WHEN dbo.ITEMS_V.name IN ('Foreman-f-ot', 
                      'Foreman-s-ot', 'Foreman-w-ot') THEN dbo.SERVICE_LINES.BILL_RATE END) AS Foreman_ot_rate, (CASE WHEN dbo.ITEMS_V.name IN ('Foreman-f-ot', 
                      'Foreman-s-ot', 'Foreman-w-ot') THEN dbo.SERVICE_LINES.BILL_QTY END) AS Foreman_ot_qty, (CASE WHEN dbo.ITEMS_V.name IN ('Foreman-f-ot', 
                      'Foreman-s-ot', 'Foreman-w-ot') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS Foreman_ot_total, (CASE WHEN dbo.ITEMS_V.name IN ('lead-reg', 
                      'lead-f-reg', 'lead-s-reg', 'lead-w-reg') THEN dbo.SERVICE_LINES.BILL_RATE END) AS lead_reg_rate, (CASE WHEN dbo.ITEMS_V.name IN ('lead-reg', 
                      'lead-f-reg', 'lead-s-reg', 'lead-w-reg') THEN dbo.SERVICE_LINES.BILL_QTY END) AS lead_reg_qty, (CASE WHEN dbo.ITEMS_V.name IN ('lead-reg', 
                      'lead-f-reg', 'lead-s-reg', 'lead-w-reg') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS lead_reg_total, (CASE WHEN dbo.ITEMS_V.name IN ('lead-ot', 
                      'lead-f-ot', 'lead-s-ot', 'lead-w-ot') THEN dbo.SERVICE_LINES.BILL_RATE END) AS lead_ot_rate, (CASE WHEN dbo.ITEMS_V.name IN ('lead-ot', 
                      'lead-f-ot', 'lead-s-ot', 'lead-w-ot') THEN dbo.SERVICE_LINES.BILL_QTY END) AS lead_ot_qty, (CASE WHEN dbo.ITEMS_V.name IN ('lead-ot', 'lead-f-ot', 
                      'lead-s-ot', 'lead-w-ot') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS lead_ot_total, (CASE WHEN dbo.ITEMS_V.name IN ('ac-reg', 'ac-f-reg', 
                      'ac-s-reg', 'ac-w-reg') THEN dbo.SERVICE_LINES.BILL_RATE END) AS ac_reg_rate, (CASE WHEN dbo.ITEMS_V.name IN ('ac-reg', 'ac-f-reg', 'ac-s-reg', 
                      'ac-w-reg') THEN dbo.SERVICE_LINES.BILL_QTY END) AS ac_reg_qty, (CASE WHEN dbo.ITEMS_V.name IN ('ac-reg', 'ac-f-reg', 'ac-s-reg', 'ac-w-reg') 
                      THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS ac_reg_total, (CASE WHEN dbo.ITEMS_V.name IN ('ac-ot', 'ac-f-ot', 'ac-s-ot', 'ac-w-ot') 
                      THEN dbo.SERVICE_LINES.BILL_RATE END) AS ac_ot_rate, (CASE WHEN dbo.ITEMS_V.name IN ('ac-ot', 'ac-f-ot', 'ac-s-ot', 'ac-w-ot') 
                      THEN dbo.SERVICE_LINES.BILL_QTY END) AS ac_ot_qty, (CASE WHEN dbo.ITEMS_V.name IN ('ac-ot', 'ac-f-ot', 'ac-s-ot', 'ac-w-ot') 
                      THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS ac_ot_total, (CASE WHEN dbo.ITEMS_V.name IN ('am-reg', 'am-f-reg', 'am-s-reg', 'am-w-reg') 
                      THEN dbo.SERVICE_LINES.BILL_RATE END) AS am_reg_rate, (CASE WHEN dbo.ITEMS_V.name IN ('am-reg', 'am-f-reg', 'am-s-reg', 'am-w-reg') 
                      THEN dbo.SERVICE_LINES.BILL_QTY END) AS am_reg_qty, (CASE WHEN dbo.ITEMS_V.name IN ('am-reg', 'am-f-reg', 'am-s-reg', 'am-w-reg') 
                      THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS am_reg_total, (CASE WHEN dbo.ITEMS_V.name IN ('am-ot', 'am-f-ot', 'am-s-ot', 'am-w-ot') 
                      THEN dbo.SERVICE_LINES.BILL_RATE END) AS am_ot_rate, (CASE WHEN dbo.ITEMS_V.name IN ('am-ot', 'am-f-ot', 'am-s-ot', 'am-w-ot') 
                      THEN dbo.SERVICE_LINES.BILL_QTY END) AS am_ot_qty, (CASE WHEN dbo.ITEMS_V.name IN ('am-ot', 'am-f-ot', 'am-s-ot', 'am-w-ot') 
                      THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS am_ot_total, (CASE WHEN dbo.ITEMS_V.name IN ('mac-reg', 'mac-f-reg', 'mac-s-reg', 'mac-w-reg') 
                      THEN dbo.SERVICE_LINES.BILL_RATE END) AS mac_reg_rate, (CASE WHEN dbo.ITEMS_V.name IN ('mac-reg', 'mac-f-reg', 'mac-s-reg', 'mac-w-reg') 
                      THEN dbo.SERVICE_LINES.BILL_QTY END) AS mac_reg_qty, (CASE WHEN dbo.ITEMS_V.name IN ('mac-reg', 'mac-f-reg', 'mac-s-reg', 'mac-w-reg') 
                      THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS mac_reg_total, (CASE WHEN dbo.ITEMS_V.name IN ('mac-ot', 'mac-f-ot', 'mac-s-ot', 'mac-w-ot') 
                      THEN dbo.SERVICE_LINES.BILL_RATE END) AS mac_ot_rate, (CASE WHEN dbo.ITEMS_V.name IN ('mac-ot', 'mac-f-ot', 'mac-s-ot', 'mac-w-ot') 
                      THEN dbo.SERVICE_LINES.BILL_QTY END) AS mac_ot_qty, (CASE WHEN dbo.ITEMS_V.name IN ('mac-ot', 'mac-f-ot', 'mac-s-ot', 'mac-w-ot') 
                      THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS mac_ot_total, (CASE WHEN dbo.ITEMS_V.name IN ('mps-reg', 'mps-f-reg', 'mps-s-reg', 'mps-w-reg') 
                      THEN dbo.SERVICE_LINES.BILL_RATE END) AS mps_reg_rate, (CASE WHEN dbo.ITEMS_V.name IN ('mps-reg', 'mps-f-reg', 'mps-s-reg', 'mps-w-reg') 
                      THEN dbo.SERVICE_LINES.BILL_QTY END) AS mps_reg_qty, (CASE WHEN dbo.ITEMS_V.name IN ('mps-reg', 'mps-f-reg', 'mps-s-reg', 'mps-w-reg') 
                      THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS mps_reg_total, (CASE WHEN dbo.ITEMS_V.name IN ('mps-ot', 'mps-f-ot', 'mps-s-ot', 'mps-w-ot') 
                      THEN dbo.SERVICE_LINES.BILL_RATE END) AS mps_ot_rate, (CASE WHEN dbo.ITEMS_V.name IN ('mps-ot', 'mps-f-ot', 'mps-s-ot', 'mps-w-ot') 
                      THEN dbo.SERVICE_LINES.BILL_QTY END) AS mps_ot_qty, (CASE WHEN dbo.ITEMS_V.name IN ('mps-ot', 'mps-f-ot', 'mps-s-ot', 'mps-w-ot') 
                      THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS mps_ot_total, (CASE WHEN dbo.ITEMS_V.name IN ('ps-reg', 'ps-f-reg', 'ps-s-reg', 'ps-w-reg') 
                      THEN dbo.SERVICE_LINES.BILL_RATE END) AS ps_reg_rate, (CASE WHEN dbo.ITEMS_V.name IN ('ps-reg', 'ps-f-reg', 'ps-s-reg', 'ps-w-reg') 
                      THEN dbo.SERVICE_LINES.BILL_QTY END) AS ps_reg_qty, (CASE WHEN dbo.ITEMS_V.name IN ('ps-reg', 'ps-f-reg', 'ps-s-reg', 'ps-w-reg') 
                      THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS ps_reg_total, (CASE WHEN dbo.ITEMS_V.name IN ('ps-ot', 'ps-f-ot', 'ps-s-ot', 'ps-w-ot') 
                      THEN dbo.SERVICE_LINES.BILL_RATE END) AS ps_ot_rate, (CASE WHEN dbo.ITEMS_V.name IN ('ps-ot', 'ps-f-ot', 'ps-s-ot', 'ps-w-ot') 
                      THEN dbo.SERVICE_LINES.BILL_QTY END) AS ps_ot_qty, (CASE WHEN dbo.ITEMS_V.name IN ('ps-ot', 'ps-f-ot', 'ps-s-ot', 'ps-w-ot') 
                      THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS ps_ot_total, (CASE WHEN dbo.ITEMS_V.name IN ('campfurnmgr-reg', 'campfurnmgr-f-reg', 
                      'campfurnmgr-s-reg', 'campfurnmgr-w-reg') THEN dbo.SERVICE_LINES.BILL_RATE END) AS campfurnmgr_reg_rate, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('campfurnmgr-reg', 'campfurnmgr-f-reg', 'campfurnmgr-s-reg', 'campfurnmgr-w-reg') 
                      THEN dbo.SERVICE_LINES.BILL_QTY END) AS campfurnmgr_reg_qty, (CASE WHEN dbo.ITEMS_V.name IN ('campfurnmgr-reg', 'campfurnmgr-f-reg', 
                      'campfurnmgr-s-reg', 'campfurnmgr-w-reg') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS campfurnmgr_reg_total, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('campfurnmgr-ot', 'campfurnmgr-f-ot', 'campfurnmgr-s-ot', 'campfurnmgr-w-ot') 
                      THEN dbo.SERVICE_LINES.BILL_RATE END) AS campfurnmgr_ot_rate, (CASE WHEN dbo.ITEMS_V.name IN ('campfurnmgr-ot', 'campfurnmgr-f-ot', 
                      'campfurnmgr-s-ot', 'campfurnmgr-w-ot') THEN dbo.SERVICE_LINES.BILL_QTY END) AS campfurnmgr_ot_qty, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('campfurnmgr-ot', 'campfurnmgr-f-ot', 'campfurnmgr-s-ot', 'campfurnmgr-w-ot') 
                      THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS campfurnmgr_ot_total, (CASE WHEN dbo.ITEMS_V.name IN ('EquMovLab-F-REG', 
                      'EquMovLab-S-REG') THEN dbo.SERVICE_LINES.BILL_RATE END) AS EquMovLabor_reg_rate, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('EquMovLab-F-REG', 'EquMovLab-S-REG') THEN dbo.SERVICE_LINES.BILL_QTY END) AS EquMovLabor_reg_qty, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('EquMovLab-F-REG', 'EquMovLab-S-REG') THEN dbo.SERVICE_LINES.BILL_TOTAL END) 
                      AS EquMovLabor_reg_total, (CASE WHEN dbo.ITEMS_V.name IN ('EquMovLab-F-OT', 'EquMovLab-S-OT') THEN dbo.SERVICE_LINES.BILL_RATE END) 
                      AS EquMovLabor_ot_rate, (CASE WHEN dbo.ITEMS_V.name IN ('EquMovLab-F-OT', 'EquMovLab-S-OT') THEN dbo.SERVICE_LINES.BILL_QTY END) 
                      AS EquMovLabor_ot_qty, (CASE WHEN dbo.ITEMS_V.name IN ('EquMovLab-F-OT', 'EquMovLab-S-OT') THEN dbo.SERVICE_LINES.BILL_TOTAL END) 
                      AS EquMovLabor_ot_total, (CASE WHEN dbo.ITEMS_V.name IN ('OffEquMgr-F-REG', 'OffEquMgr-S-REG') THEN dbo.SERVICE_LINES.BILL_RATE END) 
                      AS OfficeEquMgr_reg_rate, (CASE WHEN dbo.ITEMS_V.name IN ('OffEquMgr-F-REG', 'OffEquMgr-S-REG') THEN dbo.SERVICE_LINES.BILL_QTY END) 
                      AS OfficeEquMgr_reg_qty, (CASE WHEN dbo.ITEMS_V.name IN ('OffEquMgr-F-REG', 'OffEquMgr-S-REG') THEN dbo.SERVICE_LINES.BILL_TOTAL END) 
                      AS OfficeEquMgr_reg_total, (CASE WHEN dbo.ITEMS_V.name IN ('OffEquMgr-F-OT', 'OffEquMgr-S-OT') THEN dbo.SERVICE_LINES.BILL_RATE END) 
                      AS OfficeEquMgr_ot_rate, (CASE WHEN dbo.ITEMS_V.name IN ('OffEquMgr-F-OT', 'OffEquMgr-S-OT') THEN dbo.SERVICE_LINES.BILL_QTY END) 
                      AS OfficeEquMgr_ot_qty, (CASE WHEN dbo.ITEMS_V.name IN ('OffEquMgr-F-OT', 'OffEquMgr-S-OT') THEN dbo.SERVICE_LINES.BILL_TOTAL END) 
                      AS OfficeEquMgr_ot_total, (CASE WHEN dbo.ITEMS_V.name IN ('PC Coord-reg', 'PC Coord-f-reg', 'PC Coord-s-reg', 'PC Coord-w-reg') 
                      THEN dbo.SERVICE_LINES.BILL_RATE END) AS pc_coord_reg_rate, (CASE WHEN dbo.ITEMS_V.name IN ('PC Coord-reg', 'PC Coord-f-reg', 
                      'PC Coord-s-reg', 'PC Coord-w-reg') THEN dbo.SERVICE_LINES.BILL_QTY END) AS pc_coord_reg_qty, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('PC Coord-reg', 'PC Coord-f-reg', 'PC Coord-s-reg', 'PC Coord-w-reg') THEN dbo.SERVICE_LINES.BILL_TOTAL END) 
                      AS pc_coord_reg_total, (CASE WHEN dbo.ITEMS_V.name IN ('PC Coord-ot', 'PC Coord-f-ot', 'PC Coord-s-ot', 'PC Coord-w-ot') 
                      THEN dbo.SERVICE_LINES.BILL_RATE END) AS pc_coord_ot_rate, (CASE WHEN dbo.ITEMS_V.name IN ('PC Coord-ot', 'PC Coord-f-ot', 'PC Coord-s-ot', 
                      'PC Coord-w-ot') THEN dbo.SERVICE_LINES.BILL_QTY END) AS pc_coord_ot_qty, (CASE WHEN dbo.ITEMS_V.name IN ('PC Coord-ot', 'PC Coord-f-ot', 
                      'PC Coord-s-ot', 'PC Coord-w-ot') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS pc_coord_ot_total, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('PC Mover-reg', 'PC Mover-f-reg', 'PC Mover-s-reg', 'PC Mover-w-reg') THEN dbo.SERVICE_LINES.BILL_RATE END)
                       AS pc_mover_reg_rate, (CASE WHEN dbo.ITEMS_V.name IN ('PC Mover-reg', 'PC Mover-f-reg', 'PC Mover-s-reg', 'PC Mover-w-reg') 
                      THEN dbo.SERVICE_LINES.BILL_QTY END) AS pc_mover_reg_qty, (CASE WHEN dbo.ITEMS_V.name IN ('PC Mover-reg', 'PC Mover-f-reg', 
                      'PC Mover-s-reg', 'PC Mover-w-reg') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS pc_mover_reg_total, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('PC Mover-ot', 'PC Mover-f-ot', 'PC Mover-s-ot', 'PC Mover-w-ot') THEN dbo.SERVICE_LINES.BILL_RATE END) 
                      AS pc_mover_ot_rate, (CASE WHEN dbo.ITEMS_V.name IN ('PC Mover-ot', 'PC Mover-f-ot', 'PC Mover-s-ot', 'PC Mover-w-ot') 
                      THEN dbo.SERVICE_LINES.BILL_QTY END) AS pc_mover_ot_qty, (CASE WHEN dbo.ITEMS_V.name IN ('PC Mover-ot', 'PC Mover-f-ot', 'PC Mover-s-ot', 
                      'PC Mover-w-ot') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS pc_mover_ot_total, (CASE WHEN dbo.ITEMS_V.name IN ('Proj Mgr-F-Reg', 
                      'Proj Mgr-S-Reg', 'Proj Mgr-W-Reg') THEN dbo.SERVICE_LINES.BILL_RATE END) AS ProjMgr_reg_rate, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('Proj Mgr-F-Reg', 'Proj Mgr-S-Reg', 'Proj Mgr-W-Reg') THEN dbo.SERVICE_LINES.BILL_QTY END) 
                      AS ProjMgr_reg_qty, (CASE WHEN dbo.ITEMS_V.name IN ('Proj Mgr-F-Reg', 'Proj Mgr-S-Reg', 'Proj Mgr-W-Reg') 
                      THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS ProjMgr_reg_total, (CASE WHEN dbo.ITEMS_V.name IN ('Proj Mgr-F-OT', 'Proj Mgr-S-OT', 
                      'Proj Mgr-W-OT') THEN dbo.SERVICE_LINES.BILL_RATE END) AS ProjMgr_ot_rate, (CASE WHEN dbo.ITEMS_V.name IN ('Proj Mgr-F-OT', 
                      'Proj Mgr-S-OT', 'Proj Mgr-W-OT') THEN dbo.SERVICE_LINES.BILL_QTY END) AS ProjMgr_ot_qty, (CASE WHEN dbo.ITEMS_V.name IN ('Proj Mgr-F-OT', 
                      'Proj Mgr-S-OT', 'Proj Mgr-W-OT') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS ProjMgr_ot_total, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('regprojmgr-reg', 'regprojmgr-f-reg', 'regprojmgr-s-reg', 'regprojmgr-w-reg') 
                      THEN dbo.SERVICE_LINES.BILL_RATE END) AS regProjMgr_reg_rate, (CASE WHEN dbo.ITEMS_V.name IN ('regprojmgr-reg', 'regprojmgr-f-reg', 
                      'regprojmgr-s-reg', 'regprojmgr-w-reg') THEN dbo.SERVICE_LINES.BILL_QTY END) AS regProjMgr_reg_qty, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('regprojmgr-reg', 'regprojmgr-f-reg', 'regprojmgr-s-reg', 'regprojmgr-w-reg') 
                      THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS regProjMgr_reg_total, (CASE WHEN dbo.ITEMS_V.name IN ('regprojmgr-ot', 'regprojmgr-f-ot', 
                      'regprojmgr-s-ot', 'regprojmgr-w-ot') THEN dbo.SERVICE_LINES.BILL_RATE END) AS regProjMgr_ot_rate, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('regprojmgr-ot', 'regprojmgr-f-ot', 'regprojmgr-s-ot', 'regprojmgr-w-ot') THEN dbo.SERVICE_LINES.BILL_QTY END) 
                      AS regProjMgr_ot_qty, (CASE WHEN dbo.ITEMS_V.name IN ('regprojmgr-ot', 'regprojmgr-f-ot', 'regprojmgr-s-ot', 'regprojmgr-w-ot') 
                      THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS regProjMgr_ot_total, (CASE WHEN dbo.ITEMS_V.name IN ('AssetHdlr-f-reg', 'AssetHdlr-s-reg', 
                      'AssetHdlr-w-reg') THEN dbo.SERVICE_LINES.BILL_RATE END) AS AssetHdlr_reg_rate, (CASE WHEN dbo.ITEMS_V.name IN ('AssetHdlr-f-reg', 
                      'AssetHdlr-s-reg', 'AssetHdlr-w-reg') THEN dbo.SERVICE_LINES.BILL_QTY END) AS AssetHdlr_reg_qty, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('AssetHdlr-f-reg', 'AssetHdlr-s-reg', 'AssetHdlr-w-reg') THEN dbo.SERVICE_LINES.BILL_TOTAL END) 
                      AS AssetHdlr_reg_total, (CASE WHEN dbo.ITEMS_V.name IN ('AssetHdlr-f-ot', 'AssetHdlr-s-ot', 'AssetHdlr-w-ot') 
                      THEN dbo.SERVICE_LINES.BILL_RATE END) AS AssetHdlr_ot_rate, (CASE WHEN dbo.ITEMS_V.name IN ('AssetHdlr-f-ot', 'AssetHdlr-s-ot', 
                      'AssetHdlr-w-ot') THEN dbo.SERVICE_LINES.BILL_QTY END) AS AssetHdlr_ot_qty, (CASE WHEN dbo.ITEMS_V.name IN ('AssetHdlr-f-ot', 
                      'AssetHdlr-s-ot', 'AssetHdlr-w-ot') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS AssetHdlr_ot_total, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('am spec.-reg', 'am spec.-f-reg', 'am spec.-s-reg', 'am spec.-w-reg') THEN dbo.SERVICE_LINES.BILL_RATE END) 
                      AS am_spec_reg_rate, (CASE WHEN dbo.ITEMS_V.name IN ('am spec.-reg', 'am spec.-f-reg', 'am spec.-s-reg', 'am spec.-w-reg') 
                      THEN dbo.SERVICE_LINES.BILL_QTY END) AS am_spec_reg_qty, (CASE WHEN dbo.ITEMS_V.name IN ('am spec.-reg', 'am spec.-f-reg', 
                      'am spec.-s-reg', 'am spec.-w-reg') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS am_spec_reg_total, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('am spec.-ot', 'am spec.-f-ot', 'am spec.-s-ot', 'am spec.-w-ot') THEN dbo.SERVICE_LINES.BILL_RATE END) 
                      AS am_spec_ot_rate, (CASE WHEN dbo.ITEMS_V.name IN ('am spec.-ot', 'am spec.-f-ot', 'am spec.-s-ot', 'am spec.-w-ot') 
                      THEN dbo.SERVICE_LINES.BILL_QTY END) AS am_spec_ot_qty, (CASE WHEN dbo.ITEMS_V.name IN ('am spec.-ot', 'am spec.-f-ot', 'am spec.-s-ot', 
                      'am spec.-w-ot') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS am_spec_ot_total, (CASE WHEN dbo.ITEMS_V.name IN ('whse-reg', 'whse-f-reg', 
                      'whse-s-reg', 'whse-w-reg', 'Snaptrack-F-Reg', 'Snaptrack-S-Reg', 'Snaptrack-W-Reg', 'Snaptkr-W-Reg', 'Snaptkr-OH-Reg', 'ST-OH-Reg') 
                      THEN dbo.SERVICE_LINES.BILL_RATE END) AS whse_reg_rate, (CASE WHEN dbo.ITEMS_V.name IN ('whse-reg', 'whse-f-reg', 'whse-s-reg', 
                      'whse-w-reg', 'Snaptrack-F-Reg', 'Snaptrack-S-Reg', 'Snaptrack-W-Reg', 'Snaptkr-W-Reg', 'Snaptkr-OH-Reg', 'ST-OH-Reg') 
                      THEN dbo.SERVICE_LINES.BILL_QTY END) AS whse_reg_qty, (CASE WHEN dbo.ITEMS_V.name IN ('whse-reg', 'whse-f-reg', 'whse-s-reg', 'whse-w-reg', 
                      'Snaptrack-F-Reg', 'Snaptrack-S-Reg', 'Snaptrack-W-Reg', 'Snaptkr-W-Reg', 'Snaptkr-OH-Reg', 'ST-OH-Reg') 
                      THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS whse_reg_total, (CASE WHEN dbo.ITEMS_V.name IN ('whse-ot', 'whse-f-ot', 'whse-s-ot', 'whse-w-ot', 
                      'Snaptrack-F-OT', 'Snaptrack-S-OT', 'Snaptrack-W-OT', 'Snaptkr-W-OT', 'Snaptkr-OH-OT', 'ST-OH-OT') THEN dbo.SERVICE_LINES.BILL_RATE END) 
                      AS whse_ot_rate, (CASE WHEN dbo.ITEMS_V.name IN ('whse-ot', 'whse-f-ot', 'whse-s-ot', 'whse-w-ot', 'Snaptrack-F-OT', 'Snaptrack-S-OT', 
                      'Snaptrack-W-OT', 'Snaptkr-W-OT', 'Snaptkr-OH-OT', 'ST-OH-OT') THEN dbo.SERVICE_LINES.BILL_QTY END) AS whse_ot_qty, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('whse-ot', 'whse-f-ot', 'whse-s-ot', 'whse-w-ot', 'Snaptrack-F-OT', 'Snaptrack-S-OT', 'Snaptrack-W-OT', 
                      'Snaptkr-W-OT', 'Snaptkr-OH-OT', 'ST-OH-OT') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS whse_ot_total, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('whse sup-reg', 'whse sup-f-reg', 'whse sup-s-reg', 'whse sup-w-reg') THEN dbo.SERVICE_LINES.BILL_RATE END) 
                      AS WhseSup_reg_rate, (CASE WHEN dbo.ITEMS_V.name IN ('whse sup-reg', 'whse sup-f-reg', 'whse sup-s-reg', 'whse sup-w-reg') 
                      THEN dbo.SERVICE_LINES.BILL_QTY END) AS WhseSup_reg_qty, (CASE WHEN dbo.ITEMS_V.name IN ('whse sup-reg', 'whse sup-f-reg', 
                      'whse sup-s-reg', 'whse sup-w-reg') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS WhseSup_reg_total, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('whse sup-ot', 'whse sup-f-ot', 'whse sup-s-ot', 'whse sup-w-ot') THEN dbo.SERVICE_LINES.BILL_RATE END) 
                      AS WhseSup_ot_rate, (CASE WHEN dbo.ITEMS_V.name IN ('whse sup-ot', 'whse sup-f-ot', 'whse sup-s-ot', 'whse sup-w-ot') 
                      THEN dbo.SERVICE_LINES.BILL_QTY END) AS WhseSup_ot_qty, (CASE WHEN dbo.ITEMS_V.name IN ('whse sup-ot', 'whse sup-f-ot', 'whse sup-s-ot', 
                      'whse sup-w-ot') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS WhseSup_ot_total, (CASE WHEN dbo.ITEMS_V.name IN ('Piece Count In') 
                      THEN dbo.SERVICE_LINES.BILL_RATE END) AS PieceCountIn_rate, (CASE WHEN dbo.ITEMS_V.name IN ('Piece Count In') 
                      THEN dbo.SERVICE_LINES.BILL_QTY END) AS PieceCountIn_qty, (CASE WHEN dbo.ITEMS_V.name IN ('Piece Count In') 
                      THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS PieceCountIn_total, (CASE WHEN dbo.ITEMS_V.name IN ('Piece Count Out') 
                      THEN dbo.SERVICE_LINES.BILL_RATE END) AS PieceCountOut_rate, (CASE WHEN dbo.ITEMS_V.name IN ('Piece Count Out') 
                      THEN dbo.SERVICE_LINES.BILL_QTY END) AS PieceCountOut_qty, (CASE WHEN dbo.ITEMS_V.name IN ('Piece Count Out') 
                      THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS PieceCountOut_total, (CASE WHEN dbo.ITEMS_V.name IN ('Freight', 'Freight-S', 'Freight-OH', 
                      'Freight-F', 'Freight-W') THEN dbo.SERVICE_LINES.BILL_RATE END) AS Freight_rate, (CASE WHEN dbo.ITEMS_V.name IN ('Freight', 'Freight-S', 
                      'Freight-OH', 'Freight-F', 'Freight-W') THEN dbo.SERVICE_LINES.BILL_QTY END) AS Freight_qty, (CASE WHEN dbo.ITEMS_V.name IN ('Freight', 
                      'Freight-S', 'Freight-OH', 'Freight-F', 'Freight-W') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS Freight_total, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('Perdiem', 'Perdiem-F', 'Perdiem-OH', 'Perdiem-W', 'Perdiem-S') THEN dbo.SERVICE_LINES.BILL_TOTAL END) 
                      AS perdiem, (CASE WHEN dbo.ITEMS_V.name IN ('Lodging', 'Lodging-S', 'Lodging-W', 'Lodging-F', 'Lodging-OH') 
                      THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS lodging, (CASE WHEN dbo.ITEMS_V.name IN ('Travel', 'Travel-F', 'Travel-OH', 'Travel-W', 
                      'TRAVEL REG', 'Travel-F-Reg', 'Travel-OH-Reg', 'Travel-S', 'Travel-S-Reg', 'Travel-W-Reg') THEN dbo.SERVICE_LINES.BILL_RATE END) 
                      AS travel_reg_rate, (CASE WHEN dbo.ITEMS_V.name IN ('Travel', 'Travel-F', 'Travel-OH', 'Travel-W', 'TRAVEL REG', 'Travel-F-Reg', 'Travel-OH-Reg', 
                      'Travel-S', 'Travel-S-Reg', 'Travel-W-Reg') THEN dbo.SERVICE_LINES.BILL_QTY END) AS travel_reg_qty, (CASE WHEN dbo.ITEMS_V.name IN ('Travel', 
                      'Travel-F', 'Travel-OH', 'Travel-W', 'TRAVEL REG', 'Travel-F-Reg', 'Travel-OH-Reg', 'Travel-S', 'Travel-S-Reg', 'Travel-W-Reg') 
                      THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS travel_reg_total, (CASE WHEN dbo.ITEMS_V.name IN ('TRAVEL OT', 'Travel-F-OT', 'Travel-OH-OT', 
                      'Travel-S-OT', 'Travel-W-OT') THEN dbo.SERVICE_LINES.BILL_RATE END) AS travel_ot_rate, (CASE WHEN dbo.ITEMS_V.name IN ('TRAVEL OT', 
                      'Travel-F-OT', 'Travel-OH-OT', 'Travel-S-OT', 'Travel-W-OT') THEN dbo.SERVICE_LINES.BILL_QTY END) AS travel_ot_qty, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('TRAVEL OT', 'Travel-F-OT', 'Travel-OH-OT', 'Travel-S-OT', 'Travel-W-OT') 
                      THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS travel_ot_total, (CASE WHEN dbo.ITEMS_V.name IN ('ProjCoor-S-REG', 'ProjCoor-F-REG', 
                      'ProjCoor-W-REG') THEN dbo.SERVICE_LINES.BILL_QTY END) AS ProjCoor_reg_qty, (CASE WHEN dbo.ITEMS_V.name IN ('ProjCoor-S-REG', 
                      'ProjCoor-F-REG', 'ProjCoor-W-REG') THEN dbo.SERVICE_LINES.BILL_RATE END) AS ProjCoor_reg_rate, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('ProjCoor-S-REG', 'ProjCoor-F-REG', 'ProjCoor-W-REG') THEN dbo.SERVICE_LINES.BILL_TOTAL END) 
                      AS ProjCoor_reg_total, (CASE WHEN dbo.ITEMS_V.name IN ('ProjCoor-S-OT', 'ProjCoor-F-OT', 'ProjCoor-W-OT') 
                      THEN dbo.SERVICE_LINES.BILL_QTY END) AS ProjCoor_ot_qty, (CASE WHEN dbo.ITEMS_V.name IN ('ProjCoor-S-OT', 'ProjCoor-F-OT', 
                      'ProjCoor-W-OT') THEN dbo.SERVICE_LINES.BILL_RATE END) AS ProjCoor_ot_rate, (CASE WHEN dbo.ITEMS_V.name IN ('ProjCoor-S-OT', 
                      'ProjCoor-F-OT', 'ProjCoor-W-OT') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS ProjCoor_ot_total, 
                      dbo.JOB_LOCATIONS_V.JOB_LOCATION_NAME
FROM         dbo.SERVICES INNER JOIN
                      dbo.JOB_LOCATIONS_V ON dbo.SERVICES.JOB_LOCATION_ID = dbo.JOB_LOCATIONS_V.JOB_LOCATION_ID LEFT OUTER JOIN
                      dbo.jobs_v LEFT OUTER JOIN
                      dbo.CUSTOM_CUST_COLUMNS_V ON dbo.jobs_v.customer_id = dbo.CUSTOM_CUST_COLUMNS_V.CUSTOMER_ID ON 
                      dbo.SERVICES.JOB_ID = dbo.jobs_v.job_id RIGHT OUTER JOIN
                      dbo.INVOICES LEFT OUTER JOIN
                      dbo.INVOICE_STATUSES ON dbo.INVOICES.STATUS_ID = dbo.INVOICE_STATUSES.STATUS_ID RIGHT OUTER JOIN
                      dbo.SERVICE_LINE_STATUSES RIGHT OUTER JOIN
                      dbo.RESOURCE_TYPES_V RIGHT OUTER JOIN
                      dbo.LOOKUPS AS res_cat_types RIGHT OUTER JOIN
                      dbo.RESOURCES ON res_cat_types.LOOKUP_ID = dbo.RESOURCES.RES_CATEGORY_TYPE_ID ON 
                      dbo.RESOURCE_TYPES_V.RESOURCE_TYPE_ID = dbo.RESOURCES.RESOURCE_TYPE_ID RIGHT OUTER JOIN
                      dbo.SERVICE_LINES ON dbo.RESOURCES.RESOURCE_ID = dbo.SERVICE_LINES.RESOURCE_ID ON 
                      dbo.SERVICE_LINE_STATUSES.STATUS_ID = dbo.SERVICE_LINES.STATUS_ID ON dbo.INVOICES.INVOICE_ID = dbo.SERVICE_LINES.INVOICE_ID ON 
                      dbo.SERVICES.SERVICE_ID = dbo.SERVICE_LINES.BILL_SERVICE_ID LEFT OUTER JOIN
                      dbo.ITEMS_V ON dbo.SERVICE_LINES.ITEM_ID = dbo.ITEMS_V.ITEM_ID
WHERE     (dbo.INVOICE_STATUSES.CODE IN ('COMPLETE', 'INVOICED'))
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4[30] 2[40] 3) )"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2[66] 3) )"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2) )"
      End
      ActivePaneConfig = 14
   End
   Begin DiagramPane = 
      PaneHidden = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "SERVICES"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 262
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "JOB_LOCATIONS_V"
            Begin Extent = 
               Top = 114
               Left = 38
               Bottom = 222
               Right = 287
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "jobs_v"
            Begin Extent = 
               Top = 222
               Left = 38
               Bottom = 330
               Right = 238
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CUSTOM_CUST_COLUMNS_V"
            Begin Extent = 
               Top = 222
               Left = 276
               Bottom = 330
               Right = 473
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "INVOICES"
            Begin Extent = 
               Top = 330
               Left = 38
               Bottom = 438
               Right = 255
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "INVOICE_STATUSES"
            Begin Extent = 
               Top = 6
               Left = 300
               Bottom = 99
               Right = 451
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SERVICE_LINE_STATUSES"
            Begin Extent = 
               Top = 102
               Left = 300
               Bottom = 195
          ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'SERVICE_ACCOUNT_REPORT_TEMP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'     Right = 451
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "RESOURCE_TYPES_V"
            Begin Extent = 
               Top = 438
               Left = 38
               Bottom = 546
               Right = 246
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "res_cat_types"
            Begin Extent = 
               Top = 330
               Left = 293
               Bottom = 438
               Right = 475
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "RESOURCES"
            Begin Extent = 
               Top = 546
               Left = 38
               Bottom = 654
               Right = 244
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SERVICE_LINES"
            Begin Extent = 
               Top = 654
               Left = 38
               Bottom = 762
               Right = 276
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ITEMS_V"
            Begin Extent = 
               Top = 762
               Left = 38
               Bottom = 870
               Right = 247
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      PaneHidden = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      PaneHidden = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'SERVICE_ACCOUNT_REPORT_TEMP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'SERVICE_ACCOUNT_REPORT_TEMP'
GO

/****** Object:  View [dbo].[ICVERIFY_V]    Script Date: 05/03/2010 14:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ICVERIFY_V]
AS
SELECT     JOB_ID, JOB_NO, CUSTOMER_NAME, INVOICE_ID, CAST(bill_total AS money) AS Bill_Total, CUST_COL_4
FROM         dbo.SERVICE_ACCOUNT_REPORT_TEMP
GO

/****** Object:  View [dbo].[SERVICE_ACCT_RPT_TEMP_V_AZ]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[SERVICE_ACCT_RPT_TEMP_V_AZ]
AS
SELECT     dbo.jobs_v.job_id, dbo.jobs_v.job_no, dbo.jobs_v.job_name, dbo.jobs_v.job_no_name, dbo.jobs_v.job_type_id, dbo.jobs_v.job_type_code, 
                      dbo.jobs_v.job_type_name, dbo.jobs_v.job_status_type_id, dbo.jobs_v.job_status_type_code, dbo.jobs_v.job_status_type_name, 
                      dbo.jobs_v.job_status_seq_no, dbo.jobs_v.customer_id, dbo.jobs_v.organization_id, dbo.jobs_v.dealer_name, dbo.jobs_v.ext_dealer_id, 
                      dbo.jobs_v.customer_name, dbo.jobs_v.ext_customer_id, dbo.INVOICES.INVOICE_ID, dbo.INVOICES.PO_NO, 
                      dbo.INVOICES.STATUS_ID AS invoice_status_id, dbo.INVOICE_STATUSES.CODE AS invoice_status_code, 
                      dbo.INVOICE_STATUSES.NAME AS invoice_status_name, dbo.INVOICES.DESCRIPTION AS Invoice_Desc, dbo.SERVICES.SERVICE_ID, 
                      dbo.SERVICES.SERVICE_NO, dbo.SERVICE_LINES.SERVICE_LINE_ID, dbo.SERVICES.DESCRIPTION, dbo.SERVICES.EST_START_DATE, 
                      dbo.SERVICES.SCH_START_DATE, dbo.SERVICES.PO_NO AS req_po_no, dbo.SERVICE_LINES.BILL_SERVICE_LINE_NO, 
                      dbo.SERVICE_LINES.SERVICE_LINE_DATE, dbo.SERVICE_LINES.STATUS_ID AS serv_line_status_id, dbo.SERVICE_LINES.TC_SERVICE_LINE_NO, 
                      dbo.SERVICE_LINES.TAXABLE_FLAG, dbo.SERVICE_LINES.bill_total, dbo.SERVICE_LINE_STATUSES.CODE AS serv_line_status_code, 
                      dbo.SERVICE_LINE_STATUSES.NAME AS serv_line_status_name, dbo.RESOURCES.RESOURCE_TYPE_ID, 
                      dbo.RESOURCE_TYPES_V.resource_type_code, dbo.RESOURCE_TYPES_V.resource_type_name, 
                      dbo.RESOURCES.RES_CATEGORY_TYPE_ID AS res_cat_type_id, res_cat_types.CODE AS res_cat_type_code, 
                      res_cat_types.NAME AS res_cat_type_name, dbo.SERVICE_LINES.ITEM_ID, dbo.ITEMS_V.NAME AS item_name, dbo.ITEMS_V.ITEM_TYPE_ID, 
                      dbo.ITEMS_V.item_type_name, dbo.ITEMS_V.item_type_code, dbo.ITEMS_V.BILLABLE_FLAG, dbo.SERVICE_LINES.EXT_PAY_CODE, 
                      dbo.SERVICE_LINES.BILLABLE_FLAG AS SL_BILLABLE_FLAG, dbo.SERVICE_LINES.BILL_HOURLY_RATE AS hourly_rate, 
                      dbo.SERVICE_LINES.BILL_EXP_RATE AS expense_rate, dbo.SERVICE_LINES.BILL_QTY, dbo.CUSTOM_CUST_COLUMNS_V.col1, 
                      dbo.CUSTOM_CUST_COLUMNS_V.col1_active_flag AS col1_enabled, dbo.SERVICES.CUST_COL_1, dbo.CUSTOM_CUST_COLUMNS_V.col2, 
                      dbo.CUSTOM_CUST_COLUMNS_V.col2_active_flag AS col2_enabled, dbo.SERVICES.CUST_COL_2, dbo.CUSTOM_CUST_COLUMNS_V.col3, 
                      dbo.CUSTOM_CUST_COLUMNS_V.col3_active_flag AS col3_enabled, dbo.SERVICES.CUST_COL_3, dbo.CUSTOM_CUST_COLUMNS_V.col4, 
                      dbo.CUSTOM_CUST_COLUMNS_V.col4_active_flag AS col4_enabled, dbo.SERVICES.CUST_COL_4, dbo.CUSTOM_CUST_COLUMNS_V.col5, 
                      dbo.CUSTOM_CUST_COLUMNS_V.col5_active_flag AS col5_enabled, dbo.SERVICES.CUST_COL_5, dbo.CUSTOM_CUST_COLUMNS_V.col6, 
                      dbo.CUSTOM_CUST_COLUMNS_V.col6_active_flag AS col6_enabled, dbo.SERVICES.CUST_COL_6, dbo.CUSTOM_CUST_COLUMNS_V.col7, 
                      dbo.CUSTOM_CUST_COLUMNS_V.col7_active_flag AS col7_enabled, dbo.SERVICES.CUST_COL_7, dbo.CUSTOM_CUST_COLUMNS_V.col8, 
                      dbo.CUSTOM_CUST_COLUMNS_V.col8_active_flag AS col8_enabled, dbo.SERVICES.CUST_COL_8, dbo.CUSTOM_CUST_COLUMNS_V.col9, 
                      dbo.CUSTOM_CUST_COLUMNS_V.col9_active_flag AS col9_enabled, dbo.SERVICES.CUST_COL_9, dbo.CUSTOM_CUST_COLUMNS_V.col10, 
                      dbo.CUSTOM_CUST_COLUMNS_V.col10_active_flag AS col10_enabled, dbo.SERVICES.CUST_COL_10, 
                      (CASE WHEN dbo.ITEMS_V.name NOT IN ('Keys', 'Keys-F', 'Keys-OH', 'Keys-S', 'Keys-W', 'baggies-s', 'baggies', 'baggies-w', 'baggies-f', 'boxes-s', 
                      'boxes', 'boxes-w', 'boxes-f', 'Equip Rental-S', 'Equip Rental', 'Equip Rental-W', 'Equip Rental-F', 'labels-s', 'labels', 'labels-w', 'labels-f', 'fasteners', 
                      'fasteners-f', 'fasteners-s', 'fasteners-w', 'Supplies-Exp', 'tape-s', 'tape', 'tape-w', 'tape-f', 'trash-s', 'trash', 'trash-w', 'trash-f', 'custom-s-reg', 
                      'custom-s-ot', 'custom-reg', 'custom-ot', 'custom-w-reg', 'custom-w-ot', 'custom-f-reg', 'custom-f-ot', 'ac-s-reg', 'ac-s-ot', 'ac-reg', 'ac-ot', 'ac-w-reg', 
                      'ac-w-ot', 'ac-f-reg', 'ac-f-ot', 'am-s-reg', 'am-s-ot', 'am-reg', 'am-ot', 'am-w-reg', 'am-w-ot', 'am-f-reg', 'am-f-ot', 'lead-s-reg', 'lead-s-ot', 'lead-reg', 'lead-ot', 
                      'lead-w-reg', 'lead-w-ot', 'lead-f-reg', 'lead-f-ot', 'mac-s-reg', 'mac-s-ot', 'mac-reg', 'mac-ot', 'mac-w-reg', 'mac-w-ot', 'mac-f-reg', 'mac-f-ot', 'mps-s-reg', 
                      'mps-s-ot', 'mps-reg', 'mps-ot', 'mps-w-reg', 'mps-w-ot', 'mps-f-reg', 'mps-f-ot', 'ps-s-reg', 'ps-s-ot', 'ps-reg', 'ps-ot', 'ps-w-reg', 'ps-w-ot', 'ps-f-reg', 
                      'ps-f-ot', 'Foreman-F-Reg', 'Foreman-F-OT', 'Foreman-S-Reg', 'Foreman-S-OT', 'Foreman-W-Reg', 'Foreman-W-OT', 'Proj Mgr-F-Reg', 'Proj Mgr-F-OT', 
                      'Proj Mgr-S-Reg', 'Proj Mgr-S-OT', 'Proj Mgr-W-Reg', 'Proj Mgr-W-OT', 'Gen Labor-F-Reg', 'Gen Labor-F-OT', 'Gen Labor-S-Reg', 'Gen Labor-S-OT', 
                      ' Gen Labor-W-Reg', 'Gen Labor-W-OT', 'installer-s-reg', 'installer-s-ot', 'installer-reg', 'installer-ot', 'installer-w-reg', 'installer-w-ot', 'installer-f-reg', 
                      'installer-f-ot', 'sub-s-reg', 'sub-s-ot', 'sub-ot', 'sub-req', 'sub-w-reg', 'sub-w-ot', 'sub-f-reg', 'sub-f-ot', 'subcontractor', 'Sub - Exp.-S', 'Sub - Exp.-F', 
                      'Sub - Exp.-W', 'sub-reg', 'sub-ot', 'MOVER-S-REG', 'MOVER-S-OT', 'MOVER-F-REG', 'MOVER-F-OT', 'MOVER-W-REG', 'MOVER-W-OT', 
                      'Mover-s-Reg Hrs', 'MOVER-s-OT HRS', 'Mover-Reg Hrs', 'MOVER-OT HRS', 'Mover-w-Reg Hrs', 'MOVER-w-OT HRS', 'Mover-f-Reg Hrs', 
                      'MOVER-f-OT HRS', 'pc/fab-s-reg', 'pc/fab-s-ot', 'pc/fab-reg', 'pc/fab-ot', 'pc/fab-w-reg', 'pc/fab-w-ot', 'pc/fab-f-reg', 'pc/fab-f-ot', 'am spec.-s-reg', 
                      'amspec.-s-ot', 'am spec.-reg', 'amspec.-ot', 'am spec.-w-reg', 'amspec.-w-ot', 'am spec.-f-reg', 'amspec.-f-ot', 'AssetHdlr-F-Reg', 'AssetHdlr-F-OT', 
                      'AssetHdlr-S-Reg', 'AssetHdlr-S-OT', 'AssetHdlr-W-Reg', 'AssetHdlr-W-OT', 'Snaptrack-F-OT', 'Snaptrack-S-OT', 'Snaptrack-W-OT', 'Snaptrack-F-Reg', 
                      'Snaptrack-S-Reg', 'Snaptrack-W-Reg', 'Snaptkr-W-OT', 'Snaptkr-W-Reg', 'Snaptkr-OH-OT', 'Snaptkr-OH-Reg', 'ST-OH-OT', 'ST-OH-Reg', 'whse-s-reg', 
                      'whse-s-ot', 'whse-reg', 'whse-ot', 'whse-w-reg', 'whse-w-ot', 'whse-f-reg', 'whse-f-ot', 'whse sup-s-reg', 'whse sup-s-ot', 'whse sup-reg', 'whse sup-ot', 
                      'whse sup-w-reg', 'whse sup-w-ot', 'whse sup-f-reg', 'whse sup-f-ot', 'Piece Count In', 'Piece Count Out', 'Perdiem', 'Perdiem-F', 'Perdiem-OH', 
                      'Perdiem-W', 'Perdiem-S', 'Lodging', 'Lodging-S', 'Lodging-W', 'Lodging-F', 'Lodging-OH', 'Travel', 'Travel-F', 'Travel-OH', 'Travel-W', 'TRAVEL OT', 
                      'TRAVEL REG', 'Travel-F-OT', 'Travel-F-Reg', 'Travel-OH-OT', 'Travel-OH-Reg', 'Travel-S', 'Travel-S-OT', 'Travel-S-Reg', 'Travel-W-OT', 'Travel-W-Reg', 
                      'MileOutTown-S', 'MileOutTown-W', 'MileOutTown-F', 'MileOutTown-OH', 'MileOutofTown', 'MileageInTown-s', 'MileageInTown', 'MileageInTown-w', 
                      'MileageInTown-f', 'delivery-s-reg', 'delivery-s-ot', 'delivery-reg', 'delivery-ot', 'delivery-w-reg', 'delivery-w-ot', 'delivery-f-reg', 'delivery-f-ot', 
                      'Driver-F-Reg', 'Driver-F-OT', 'Driver-S-Reg', 'Driver-S-OT', 'Driver-W-Reg', 'Driver-W-OT', 'truck-emp-s', 'truck-emp', 'truck-emp-w', 'truck-emp-f', 
                      'truck-s-reg', 'truck-w', 'truck', 'truck-w-reg', 'truck-f-reg', 'truck-s', 'van-s', 'van', 'van-w', 'van-f', 'Freight', 'Freight-S', 'Freight-OH', 'Freight-F', 'Freight-W', 
                      'campfurnmgr-s-reg', 'campfurnmgr-s-ot', 'campfurnmgr-reg', 'campfurnmgr-ot', 'campfurnmgr-w-reg', 'campfurnmgr-w-ot', 'campfurnmgr-f-reg', 
                      'campfurnmgr-f-ot', 'PC Coord-s-Reg', 'PC Coord-s-OT', 'PC Coord-Reg', 'PC Coord-OT', 'PC Coord-w-Reg', 'PC Coord-w-OT', 'PC Coord-f-Reg', 
                      'PC Coord-f-OT', 'PC Mover-s-Reg', 'PC Mover-s-OT', 'PC Mover-Reg', 'PC Mover-OT', 'PC Mover-w-Reg', 'PC Mover-w-OT', 'PC Mover-f-Reg', 
                      'PC Mover-f-OT', 'regprojmgr-s-reg', 'regprojmgr-s-ot', 'regprojmgr-reg', 'regprojmgr-ot', 'regprojmgr-w-reg', 'regprojmgr-w-ot', 'regprojmgr-f-reg', 
                      'regprojmgr-f-ot', 'EquMovLab-F-REG', 'EquMovLab-S-REG', 'EquMovLab-F-OT', 'EquMovLab-S-OT', 'OffEquMgr-F-REG', 'OffEquMgr-S-REG', 
                      'OffEquMgr-F-OT', 'OffEquMgr-S-OT', 'ProjCoor-S-REG', 'ProjCoor-F-REG', 'ProjCoor-W-REG', 'ProjCoor-S-OT', 'ProjCoor-F-OT', 'ProjCoor-W-OT') 
                      THEN dbo.SERVICE_LINES.BILL_RATE END) AS other_rate, (CASE WHEN dbo.ITEMS_V.name NOT IN ('Keys', 'Keys-F', 'Keys-OH', 'Keys-S', 'Keys-W', 
                      'baggies-s', 'baggies', 'baggies-w', 'baggies-f', 'boxes-s', 'boxes', 'boxes-w', 'boxes-f', 'Equip Rental-S', 'Equip Rental', 'fasteners', 'fasteners-f', 
                      'fasteners-s', 'fasteners-w', 'Equip Rental-W', 'Equip Rental-F', 'labels-s', 'labels', 'labels-w', 'labels-f', 'Supplies-Exp', 'tape-s', 'tape', 'tape-w', 'tape-f', 
                      'trash-s', 'trash', 'trash-w', 'trash-f', 'custom-s-reg', 'custom-s-ot', 'custom-reg', 'custom-ot', 'custom-w-reg', 'custom-w-ot', 'custom-f-reg', 'custom-f-ot', 
                      'ac-s-reg', 'ac-s-ot', 'ac-reg', 'ac-ot', 'ac-w-reg', 'ac-w-ot', 'ac-f-reg', 'ac-f-ot', 'am-s-reg', 'am-s-ot', 'am-reg', 'am-ot', 'am-w-reg', 'am-w-ot', 'am-f-reg', 
                      'am-f-ot', 'lead-s-reg', 'lead-s-ot', 'lead-reg', 'lead-ot', 'lead-w-reg', 'lead-w-ot', 'lead-f-reg', 'lead-f-ot', 'mac-s-reg', 'mac-s-ot', 'mac-reg', 'mac-ot', 
                      'mac-w-reg', 'mac-w-ot', 'mac-f-reg', 'mac-f-ot', 'mps-s-reg', 'mps-s-ot', 'mps-reg', 'mps-ot', 'mps-w-reg', 'mps-w-ot', 'mps-f-reg', 'mps-f-ot', 'ps-s-reg', 
                      'ps-s-ot', 'ps-reg', 'ps-ot', 'ps-w-reg', 'ps-w-ot', 'ps-f-reg', 'ps-f-ot', 'Foreman-F-Reg', 'Foreman-F-OT', 'Foreman-S-Reg', 'Foreman-S-OT', 
                      'Foreman-W-Reg', 'Foreman-W-OT', 'Proj Mgr-F-Reg', 'Proj Mgr-F-OT', 'Proj Mgr-S-Reg', 'Proj Mgr-S-OT', 'Proj Mgr-W-Reg', 'Proj Mgr-W-OT', 
                      'Gen Labor-F-Reg', 'Gen Labor-F-OT', 'Gen Labor-S-Reg', 'Gen Labor-S-OT', ' Gen Labor-W-Reg', 'Gen Labor-W-OT', 'installer-s-reg', 'installer-s-ot', 
                      'installer-reg', 'installer-ot', 'installer-w-reg', 'installer-w-ot', 'installer-f-reg', 'installer-f-ot', 'sub-s-reg', 'sub-s-ot', 'sub-ot', 'sub-req', 'sub-w-reg', 
                      'sub-w-ot', 'sub-f-reg', 'sub-f-ot', 'subcontractor', 'Sub - Exp.-S', 'Sub - Exp.-F', 'Sub - Exp.-W', 'sub-reg', 'sub-ot', 'MOVER-S-REG', 'MOVER-S-OT', 
                      'MOVER-F-REG', 'MOVER-F-OT', 'MOVER-W-REG', 'MOVER-W-OT', 'Mover-s-Reg Hrs', 'MOVER-s-OT HRS', 'Mover-Reg Hrs', 'MOVER-OT HRS', 
                      'Mover-w-Reg Hrs', 'MOVER-w-OT HRS', 'Mover-f-Reg Hrs', 'MOVER-f-OT HRS', 'pc/fab-s-reg', 'pc/fab-s-ot', 'pc/fab-reg', 'pc/fab-ot', 'pc/fab-w-reg', 
                      'pc/fab-w-ot', 'pc/fab-f-reg', 'pc/fab-f-ot', 'am spec.-s-reg', 'amspec.-s-ot', 'am spec.-reg', 'amspec.-ot', 'am spec.-w-reg', 'amspec.-w-ot', 'am spec.-f-reg', 
                      'amspec.-f-ot', 'AssetHdlr-F-Reg', 'AssetHdlr-F-OT', 'AssetHdlr-S-Reg', 'AssetHdlr-S-OT', 'AssetHdlr-W-Reg', 'AssetHdlr-W-OT', 'Snaptrack-F-OT', 
                      'Snaptrack-S-OT', 'Snaptrack-W-OT', 'Snaptrack-F-Reg', 'Snaptrack-S-Reg', 'Snaptrack-W-Reg', 'Snaptkr-W-OT', 'Snaptkr-W-Reg', 'Snaptkr-OH-OT', 
                      'Snaptkr-OH-Reg', 'ST-OH-OT', 'ST-OH-Reg', 'whse-s-reg', 'whse-s-ot', 'whse-reg', 'whse-ot', 'whse-w-reg', 'whse-w-ot', 'whse-f-reg', 'whse-f-ot', 
                      'whse sup-s-reg', 'whse sup-s-ot', 'whse sup-reg', 'whse sup-ot', 'whse sup-w-reg', 'whse sup-w-ot', 'whse sup-f-reg', 'whse sup-f-ot', 'Piece Count In', 
                      'Piece Count Out', 'Perdiem', 'Perdiem-F', 'Perdiem-OH', 'Perdiem-W', 'Perdiem-S', 'Lodging', 'Lodging-S', 'Lodging-W', 'Lodging-F', 'Lodging-OH', 
                      'Travel', 'Travel-F', 'Travel-OH', 'Travel-W', 'TRAVEL OT', 'TRAVEL REG', 'Travel-F-OT', 'Travel-F-Reg', 'Travel-OH-OT', 'Travel-OH-Reg', 'Travel-S', 
                      'Travel-S-OT', 'Travel-S-Reg', 'Travel-W-OT', 'Travel-W-Reg', 'MileOutTown-S', 'MileOutTown-W', 'MileOutTown-F', 'MileOutTown-OH', 'MileOutofTown', 
                      'MileageInTown-s', 'MileageInTown', 'MileageInTown-w', 'MileageInTown-f', 'delivery-s-reg', 'delivery-s-ot', 'delivery-reg', 'delivery-ot', 'delivery-w-reg', 
                      'delivery-w-ot', 'delivery-f-reg', 'delivery-f-ot', 'Driver-F-Reg', 'Driver-F-OT', 'Driver-S-Reg', 'Driver-S-OT', 'Driver-W-Reg', 'Driver-W-OT', 'truck-emp-s', 
                      'truck-emp', 'truck-emp-w', 'truck-emp-f', 'truck-s-reg', 'truck-w', 'truck', 'truck-w-reg', 'truck-f-reg', 'truck-s', 'van-s', 'van', 'van-w', 'van-f', 'Freight', 
                      'Freight-S', 'Freight-OH', 'Freight-F', 'Freight-W', 'campfurnmgr-s-reg', 'campfurnmgr-s-ot', 'campfurnmgr-reg', 'campfurnmgr-ot', 'campfurnmgr-w-reg', 
                      'campfurnmgr-w-ot', 'campfurnmgr-f-reg', 'campfurnmgr-f-ot', 'PC Coord-s-Reg', 'PC Coord-s-OT', 'PC Coord-Reg', 'PC Coord-OT', 'PC Coord-w-Reg', 
                      'PC Coord-w-OT', 'PC Coord-f-Reg', 'PC Coord-f-OT', 'PC Mover-s-Reg', 'PC Mover-s-OT', 'PC Mover-Reg', 'PC Mover-OT', 'PC Mover-w-Reg', 
                      'PC Mover-w-OT', 'PC Mover-f-Reg', 'PC Mover-f-OT', 'regprojmgr-s-reg', 'regprojmgr-s-ot', 'regprojmgr-reg', 'regprojmgr-ot', 'regprojmgr-w-reg', 
                      'regprojmgr-w-ot', 'regprojmgr-f-reg', 'regprojmgr-f-ot', 'EquMovLab-F-REG', 'EquMovLab-S-REG', 'EquMovLab-F-OT', 'EquMovLab-S-OT', 
                      'OffEquMgr-F-REG', 'OffEquMgr-S-REG', 'OffEquMgr-F-OT', 'OffEquMgr-S-OT', 'ProjCoor-S-REG', 'ProjCoor-F-REG', 'ProjCoor-W-REG', 'ProjCoor-S-OT', 
                      'ProjCoor-F-OT', 'ProjCoor-W-OT') THEN dbo.SERVICE_LINES.BILL_QTY END) AS other_qty, (CASE WHEN dbo.ITEMS_V.name NOT IN ('Keys', 'Keys-F', 
                      'Keys-OH', 'Keys-S', 'Keys-W', 'baggies-s', 'baggies', 'baggies-w', 'baggies-f', 'boxes-s', 'boxes', 'boxes-w', 'boxes-f', 'Equip Rental-S', 'fasteners', 
                      'fasteners-f', 'fasteners-s', 'fasteners-w', 'Equip Rental', 'Equip Rental-W', 'Equip Rental-F', 'labels-s', 'labels', 'labels-w', 'labels-f', 'Supplies-Exp', 
                      'tape-s', 'tape', 'tape-w', 'tape-f', 'trash-s', 'trash', 'trash-w', 'trash-f', 'custom-s-reg', 'custom-s-ot', 'custom-reg', 'custom-ot', 'custom-w-reg', 
                      'custom-w-ot', 'custom-f-reg', 'custom-f-ot', 'ac-s-reg', 'ac-s-ot', 'ac-reg', 'ac-ot', 'ac-w-reg', 'ac-w-ot', 'ac-f-reg', 'ac-f-ot', 'am-s-reg', 'am-s-ot', 'am-reg', 
                      'am-ot', 'am-w-reg', 'am-w-ot', 'am-f-reg', 'am-f-ot', 'lead-s-reg', 'lead-s-ot', 'lead-reg', 'lead-ot', 'lead-w-reg', 'lead-w-ot', 'lead-f-reg', 'lead-f-ot', 
                      'mac-s-reg', 'mac-s-ot', 'mac-reg', 'mac-ot', 'mac-w-reg', 'mac-w-ot', 'mac-f-reg', 'mac-f-ot', 'mps-s-reg', 'mps-s-ot', 'mps-reg', 'mps-ot', 'mps-w-reg', 
                      'mps-w-ot', 'mps-f-reg', 'mps-f-ot', 'ps-s-reg', 'ps-s-ot', 'ps-reg', 'ps-ot', 'ps-w-reg', 'ps-w-ot', 'ps-f-reg', 'ps-f-ot', 'Foreman-F-Reg', 'Foreman-F-OT', 
                      'Foreman-S-Reg', 'Foreman-S-OT', 'Foreman-W-Reg', 'Foreman-W-OT', 'Proj Mgr-F-Reg', 'Proj Mgr-F-OT', 'Proj Mgr-S-Reg', 'Proj Mgr-S-OT', 
                      'Proj Mgr-W-Reg', 'Proj Mgr-W-OT', 'Gen Labor-F-Reg', 'Gen Labor-F-OT', 'Gen Labor-S-Reg', 'Gen Labor-S-OT', ' Gen Labor-W-Reg', 'Gen Labor-W-OT', 
                      'installer-s-reg', 'installer-s-ot', 'installer-reg', 'installer-ot', 'installer-w-reg', 'installer-w-ot', 'installer-f-reg', 'installer-f-ot', 'sub-s-reg', 'sub-s-ot', 'sub-ot',
                       'sub-req', 'sub-w-reg', 'sub-w-ot', 'sub-f-reg', 'sub-f-ot', 'subcontractor', 'Sub - Exp.-S', 'Sub - Exp.-F', 'Sub - Exp.-W', 'sub-reg', 'sub-ot', 'MOVER-S-REG', 
                      'MOVER-S-OT', 'MOVER-F-REG', 'MOVER-F-OT', 'MOVER-W-REG', 'MOVER-W-OT', 'Mover-s-Reg Hrs', 'MOVER-s-OT HRS', 'Mover-Reg Hrs', 
                      'MOVER-OT HRS', 'Mover-w-Reg Hrs', 'MOVER-w-OT HRS', 'Mover-f-Reg Hrs', 'MOVER-f-OT HRS', 'pc/fab-s-reg', 'pc/fab-s-ot', 'pc/fab-reg', 'pc/fab-ot', 
                      'pc/fab-w-reg', 'pc/fab-w-ot', 'pc/fab-f-reg', 'pc/fab-f-ot', 'am spec.-s-reg', 'amspec.-s-ot', 'am spec.-reg', 'amspec.-ot', 'am spec.-w-reg', 'amspec.-w-ot', 
                      'am spec.-f-reg', 'amspec.-f-ot', 'AssetHdlr-F-Reg', 'AssetHdlr-F-OT', 'AssetHdlr-S-Reg', 'AssetHdlr-S-OT', 'AssetHdlr-W-Reg', 'AssetHdlr-W-OT', 
                      'Snaptrack-F-OT', 'Snaptrack-S-OT', 'Snaptrack-W-OT', 'Snaptrack-F-Reg', 'Snaptrack-S-Reg', 'Snaptrack-W-Reg', 'Snaptkr-W-OT', 'Snaptkr-W-Reg', 
                      'Snaptkr-OH-OT', 'Snaptkr-OH-Reg', 'ST-OH-OT', 'ST-OH-Reg', 'whse-s-reg', 'whse-s-ot', 'whse-reg', 'whse-ot', 'whse-w-reg', 'whse-w-ot', 'whse-f-reg', 
                      'whse-f-ot', 'whse sup-s-reg', 'whse sup-s-ot', 'whse sup-reg', 'whse sup-ot', 'whse sup-w-reg', 'whse sup-w-ot', 'whse sup-f-reg', 'whse sup-f-ot', 
                      'Piece Count In', 'Piece Count Out', 'Perdiem', 'Perdiem-F', 'Perdiem-OH', 'Perdiem-W', 'Perdiem-S', 'Lodging', 'Lodging-S', 'Lodging-W', 'Lodging-F', 
                      'Lodging-OH', 'Travel', 'Travel-F', 'Travel-OH', 'Travel-W', 'TRAVEL OT', 'TRAVEL REG', 'Travel-F-OT', 'Travel-F-Reg', 'Travel-OH-OT', 'Travel-OH-Reg', 
                      'Travel-S', 'Travel-S-OT', 'Travel-S-Reg', 'Travel-W-OT', 'Travel-W-Reg', 'MileOutTown-S', 'MileOutTown-W', 'MileOutTown-F', 'MileOutTown-OH', 
                      'MileOutofTown', 'MileageInTown-s', 'MileageInTown', 'MileageInTown-w', 'MileageInTown-f', 'delivery-s-reg', 'delivery-s-ot', 'delivery-reg', 'delivery-ot', 
                      'delivery-w-reg', 'delivery-w-ot', 'delivery-f-reg', 'delivery-f-ot', 'Driver-F-Reg', 'Driver-F-OT', 'Driver-S-Reg', 'Driver-S-OT', 'Driver-W-Reg', 'Driver-W-OT', 
                      'truck-emp-s', 'truck-emp', 'truck-emp-w', 'truck-emp-f', 'truck-s-reg', 'truck-w', 'truck', 'truck-w-reg', 'truck-f-reg', 'truck-s', 'van-s', 'van', 'van-w', 'van-f', 
                      'Freight', 'Freight-S', 'Freight-OH', 'Freight-F', 'Freight-W', 'campfurnmgr-s-reg', 'campfurnmgr-s-ot', 'campfurnmgr-reg', 'campfurnmgr-ot', 
                      'campfurnmgr-w-reg', 'campfurnmgr-w-ot', 'campfurnmgr-f-reg', 'campfurnmgr-f-ot', 'PC Coord-s-Reg', 'PC Coord-s-OT', 'PC Coord-Reg', 'PC Coord-OT', 
                      'PC Coord-w-Reg', 'PC Coord-w-OT', 'PC Coord-f-Reg', 'PC Coord-f-OT', 'PC Mover-s-Reg', 'PC Mover-s-OT', 'PC Mover-Reg', 'PC Mover-OT', 
                      'PC Mover-w-Reg', 'PC Mover-w-OT', 'PC Mover-f-Reg', 'PC Mover-f-OT', 'regprojmgr-s-reg', 'regprojmgr-s-ot', 'regprojmgr-reg', 'regprojmgr-ot', 
                      'regprojmgr-w-reg', 'regprojmgr-w-ot', 'regprojmgr-f-reg', 'regprojmgr-f-ot', 'EquMovLab-F-REG', 'EquMovLab-S-REG', 'EquMovLab-F-OT', 
                      'EquMovLab-S-OT', 'OffEquMgr-F-REG', 'OffEquMgr-S-REG', 'OffEquMgr-F-OT', 'OffEquMgr-S-OT', 'ProjCoor-S-REG', 'ProjCoor-F-REG', 'ProjCoor-W-REG', 
                      'ProjCoor-S-OT', 'ProjCoor-F-OT', 'ProjCoor-W-OT') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS other_total, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('baggies', 'baggies-f', 'baggies-s', 'baggies-w') THEN dbo.SERVICE_LINES.BILL_RATE END) AS baggies_rate, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('baggies', 'baggies-f', 'baggies-s', 'baggies-w') THEN dbo.SERVICE_LINES.BILL_QTY END) AS baggies_qty, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('baggies', 'baggies-f', 'baggies-s', 'baggies-w') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS baggies_total, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('boxes', 'boxes-f', 'boxes-s', 'boxes-w') THEN dbo.SERVICE_LINES.BILL_RATE END) AS boxes_rate, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('boxes', 'boxes-f', 'boxes-s', 'boxes-w') THEN dbo.SERVICE_LINES.BILL_QTY END) AS boxes_qty, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('boxes', 'boxes-f', 'boxes-s', 'boxes-w') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS boxes_total, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('labels', 'labels-f', 'labels-s', 'labels-w') THEN dbo.SERVICE_LINES.BILL_RATE END) AS labels_rate, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('labels', 'labels-f', 'labels-s', 'labels-w') THEN dbo.SERVICE_LINES.BILL_QTY END) AS labels_qty, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('labels', 'labels-f', 'labels-s', 'labels-w') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS labels_total, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('tape', 'tape-f', 'tape-s', 'tape-w') THEN dbo.SERVICE_LINES.BILL_RATE END) AS tape_rate, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('tape', 'tape-f', 'tape-s', 'tape-w') THEN dbo.SERVICE_LINES.BILL_QTY END) AS tape_qty, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('tape', 'tape-f', 'tape-s', 'tape-w') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS tape_total, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('Supplies-Exp', 'fasteners', 'fasteners-f', 'fasteners-s', 'fasteners-w') THEN dbo.SERVICE_LINES.BILL_RATE END) 
                      AS supplies_rate, (CASE WHEN dbo.ITEMS_V.name IN ('Supplies-Exp', 'fasteners', 'fasteners-f', 'fasteners-s', 'fasteners-w') 
                      THEN dbo.SERVICE_LINES.BILL_QTY END) AS supplies_qty, (CASE WHEN dbo.ITEMS_V.name IN ('Supplies-Exp', 'fasteners', 'fasteners-f', 
                      'fasteners-s', 'fasteners-w') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS supplies_total, (CASE WHEN dbo.ITEMS_V.name IN ('trash', 'trash-f', 
                      'trash-s', 'trash-w') THEN dbo.SERVICE_LINES.BILL_RATE END) AS trash_rate, (CASE WHEN dbo.ITEMS_V.name IN ('trash', 'trash-f', 'trash-s', 'trash-w') 
                      THEN dbo.SERVICE_LINES.BILL_QTY END) AS trash_qty, (CASE WHEN dbo.ITEMS_V.name IN ('trash', 'trash-f', 'trash-s', 'trash-w') 
                      THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS trash_total, (CASE WHEN dbo.ITEMS_V.name IN ('Equip Rental', 'Equip Rental-F', 'Equip Rental-S', 
                      'Equip Rental-W', 'BOOKCARTS-A&M', 'BOOKCARTS-A&M-f', 'BOOKCARTS-A&M-s', 'BOOKCARTS-A&M-w', 'DOLLIES-A&M', 'DOLLIES-A&M-f', 
                      'DOLLIES-A&M-s', 'DOLLIES-A&M-w') THEN dbo.SERVICE_LINES.BILL_RATE END) AS EquipRental_rate, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('Equip Rental', 'Equip Rental-F', 'Equip Rental-S', 'Equip Rental-W', 'BOOKCARTS-A&M', 'BOOKCARTS-A&M-f', 
                      'BOOKCARTS-A&M-s', 'BOOKCARTS-A&M-w', 'DOLLIES-A&M', 'DOLLIES-A&M-f', 'DOLLIES-A&M-s', 'DOLLIES-A&M-w') 
                      THEN dbo.SERVICE_LINES.BILL_QTY END) AS EquipRental_qty, (CASE WHEN dbo.ITEMS_V.name IN ('Equip Rental', 'Equip Rental-F', 
                      'Equip Rental-S', 'Equip Rental-W', 'BOOKCARTS-A&M', 'BOOKCARTS-A&M-f', 'BOOKCARTS-A&M-s', 'BOOKCARTS-A&M-w', 'DOLLIES-A&M', 
                      'DOLLIES-A&M-f', 'DOLLIES-A&M-s', 'DOLLIES-A&M-w') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS EquipRental_total, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('Keys', 'Keys-F', 'Keys-OH', 'Keys-S', 'Keys-W') THEN dbo.SERVICE_LINES.BILL_RATE END) AS keys_rate, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('Keys', 'Keys-F', 'Keys-OH', 'Keys-S', 'Keys-W') THEN dbo.SERVICE_LINES.BILL_QTY END) AS keys_qty, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('Keys', 'Keys-F', 'Keys-OH', 'Keys-S', 'Keys-W') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS keys_total, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('custom-reg', 'custom-f-reg', 'custom-s-reg', 'custom-w-reg') THEN dbo.SERVICE_LINES.BILL_RATE END) 
                      AS custom_reg_rate, (CASE WHEN dbo.ITEMS_V.name IN ('custom-reg', 'custom-f-reg', 'custom-s-reg', 'custom-w-reg') 
                      THEN dbo.SERVICE_LINES.BILL_QTY END) AS custom_reg_qty, (CASE WHEN dbo.ITEMS_V.name IN ('custom-reg', 'custom-f-reg', 'custom-s-reg', 
                      'custom-w-reg') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS custom_reg_total, (CASE WHEN dbo.ITEMS_V.name IN ('custom-ot', 'custom-f-ot', 
                      'custom-s-ot', 'custom-w-ot') THEN dbo.SERVICE_LINES.BILL_RATE END) AS custom_ot_rate, (CASE WHEN dbo.ITEMS_V.name IN ('custom-ot', 
                      'custom-f-ot', 'custom-s-ot', 'custom-w-ot') THEN dbo.SERVICE_LINES.BILL_QTY END) AS custom_ot_qty, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('custom-ot', 'custom-f-ot', 'custom-s-ot', 'custom-w-ot') THEN dbo.SERVICE_LINES.BILL_TOTAL END) 
                      AS custom_ot_total, (CASE WHEN dbo.ITEMS_V.name IN ('delivery-reg', 'delivery-f-reg', 'delivery-s-reg', 'delivery-w-reg') 
                      THEN dbo.SERVICE_LINES.BILL_RATE END) AS delivery_reg_rate, (CASE WHEN dbo.ITEMS_V.name IN ('delivery-reg', 'delivery-f-reg', 'delivery-s-reg', 
                      'delivery-w-reg') THEN dbo.SERVICE_LINES.BILL_QTY END) AS delivery_reg_qty, (CASE WHEN dbo.ITEMS_V.name IN ('delivery-reg', 'delivery-f-reg', 
                      'delivery-s-reg', 'delivery-w-reg') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS delivery_reg_total, (CASE WHEN dbo.ITEMS_V.name IN ('delivery-ot',
                       'delivery-f-ot', 'delivery-s-ot', 'delivery-w-ot') THEN dbo.SERVICE_LINES.BILL_RATE END) AS delivery_ot_rate, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('delivery-ot', 'delivery-f-ot', 'delivery-s-ot', 'delivery-w-ot') THEN dbo.SERVICE_LINES.BILL_QTY END) 
                      AS delivery_ot_qty, (CASE WHEN dbo.ITEMS_V.name IN ('delivery-ot', 'delivery-f-ot', 'delivery-s-ot', 'delivery-w-ot') 
                      THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS delivery_ot_total, (CASE WHEN dbo.ITEMS_V.name IN ('driver-f-reg', 'driver-s-reg', 'driver-w-reg') 
                      THEN dbo.SERVICE_LINES.BILL_RATE END) AS driver_reg_rate, (CASE WHEN dbo.ITEMS_V.name IN ('driver-f-reg', 'driver-s-reg', 'driver-w-reg') 
                      THEN dbo.SERVICE_LINES.BILL_QTY END) AS driver_reg_qty, (CASE WHEN dbo.ITEMS_V.name IN ('driver-f-reg', 'driver-s-reg', 'driver-w-reg') 
                      THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS driver_reg_total, (CASE WHEN dbo.ITEMS_V.name IN ('driver-f-ot', 'driver-s-ot', 'driver-w-ot') 
                      THEN dbo.SERVICE_LINES.BILL_RATE END) AS driver_ot_rate, (CASE WHEN dbo.ITEMS_V.name IN ('driver-f-ot', 'driver-s-ot', 'driver-w-ot') 
                      THEN dbo.SERVICE_LINES.BILL_QTY END) AS driver_ot_qty, (CASE WHEN dbo.ITEMS_V.name IN ('driver-f-ot', 'driver-s-ot', 'driver-w-ot') 
                      THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS driver_ot_total, (CASE WHEN dbo.ITEMS_V.name IN ('truck-reg', 'truck-f-reg', 'truck-s-reg', 
                      'truck-w-reg', 'truck-w', 'truck-s', 'truck-emp', 'truck-emp-f', 'truck-emp-s', 'truck-emp-w') THEN dbo.SERVICE_LINES.BILL_RATE END) AS truck_rate, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('truck-reg', 'truck-f-reg', 'truck-s-reg', 'truck-w-reg', 'truck-s', 'truck-w', 'truck-emp', 'truck-emp-f', 'truck-emp-s', 
                      'truck-emp-w') THEN dbo.SERVICE_LINES.BILL_QTY END) AS truck_qty, (CASE WHEN dbo.ITEMS_V.name IN ('truck-reg', 'truck-f-reg', 'truck-s-reg', 
                      'truck-w-reg', 'truck-s', 'truck-w', 'truck-emp', 'truck-emp-f', 'truck-emp-s', 'truck-emp-w') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS truck_total, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('Van', 'Van-f', 'Van-s', 'Van-w') THEN dbo.SERVICE_LINES.BILL_RATE END) AS van_rate, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('Van', 'Van-f', 'Van-s', 'Van-w') THEN dbo.SERVICE_LINES.BILL_QTY END) AS van_qty, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('Van', 'Van-f', 'Van-s', 'Van-w') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS van_total, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('MileageInTown', 'MileageInTown-f', 'MileageInTown-s', 'MileageInTown-w') 
                      THEN dbo.SERVICE_LINES.BILL_RATE END) AS MileageInTown_rate, (CASE WHEN dbo.ITEMS_V.name IN ('MileageInTown', 'MileageInTown-f', 
                      'MileageInTown-s', 'MileageInTown-w') THEN dbo.SERVICE_LINES.BILL_QTY END) AS MileageInTown_qty, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('MileageInTown', 'MileageInTown-f', 'MileageInTown-s', 'MileageInTown-w') 
                      THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS MileageInTown_total, (CASE WHEN dbo.ITEMS_V.name IN ('MileOutTown-S', 'MileOutTown-W', 
                      'MileOutTown-F', 'MileOutTown-OH', 'MileOutofTown') THEN dbo.SERVICE_LINES.BILL_RATE END) AS MileageOutTown_rate, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('MileOutTown-S', 'MileOutTown-W', 'MileOutTown-F', 'MileOutTown-OH', 'MileOutofTown') 
                      THEN dbo.SERVICE_LINES.BILL_QTY END) AS MileageOutTown_qty, (CASE WHEN dbo.ITEMS_V.name IN ('MileOutTown-S', 'MileOutTown-W', 
                      'MileOutTown-F', 'MileOutTown-OH', 'MileOutofTown') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS MileageOutTown_total, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('installer-reg', 'installer-f-reg', 'installer-s-reg', 'installer-w-reg') THEN dbo.SERVICE_LINES.BILL_RATE END) 
                      AS installer_reg_rate, (CASE WHEN dbo.ITEMS_V.name IN ('installer-reg', 'installer-f-reg', 'installer-s-reg', 'installer-w-reg') 
                      THEN dbo.SERVICE_LINES.BILL_QTY END) AS installer_reg_qty, (CASE WHEN dbo.ITEMS_V.name IN ('installer-reg', 'installer-f-reg', 'installer-s-reg', 
                      'installer-w-reg') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS installer_reg_total, (CASE WHEN dbo.ITEMS_V.name IN ('installer-ot', 'installer-f-ot', 
                      'installer-s-ot', 'installer-w-ot') THEN dbo.SERVICE_LINES.BILL_RATE END) AS installer_ot_rate, (CASE WHEN dbo.ITEMS_V.name IN ('installer-ot', 
                      'installer-f-ot', 'installer-s-ot', 'installer-w-ot') THEN dbo.SERVICE_LINES.BILL_QTY END) AS installer_ot_qty, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('installer-ot', 'installer-f-ot', 'installer-s-ot', 'installer-w-ot') THEN dbo.SERVICE_LINES.BILL_TOTAL END) 
                      AS installer_ot_total, (CASE WHEN dbo.ITEMS_V.name IN ('sub-reg', 'sub-f-reg', 'sub-s-reg', 'sub-w-reg', 'subcontractor') 
                      THEN dbo.SERVICE_LINES.BILL_RATE END) AS sub_reg_rate, (CASE WHEN dbo.ITEMS_V.name IN ('sub-reg', 'sub-f-reg', 'sub-s-reg', 'sub-w-reg', 
                      'subcontractor') THEN dbo.SERVICE_LINES.BILL_QTY END) AS sub_reg_qty, (CASE WHEN dbo.ITEMS_V.name IN ('sub-reg', 'sub-f-reg', 'sub-s-reg', 
                      'sub-w-reg', 'subcontractor') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS sub_reg_total, (CASE WHEN dbo.ITEMS_V.name IN ('sub-ot', 'sub-f-ot', 
                      'sub-s-ot', 'sub-w-ot') THEN dbo.SERVICE_LINES.BILL_RATE END) AS sub_ot_rate, (CASE WHEN dbo.ITEMS_V.name IN ('sub-ot', 'sub-f-ot', 'sub-s-ot', 
                      'sub-w-ot') THEN dbo.SERVICE_LINES.BILL_QTY END) AS sub_ot_qty, (CASE WHEN dbo.ITEMS_V.name IN ('sub-ot', 'sub-f-ot', 'sub-s-ot', 'sub-w-ot') 
                      THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS sub_ot_total, (CASE WHEN dbo.ITEMS_V.name IN ('Sub - Exp.-F', 'Sub - Exp.-W', 'Sub - Exp.-S') 
                      THEN dbo.SERVICE_LINES.BILL_RATE END) AS sub_exp_rate, (CASE WHEN dbo.ITEMS_V.name IN ('Sub - Exp.-F', 'Sub - Exp.-W', 'Sub - Exp.-S') 
                      THEN dbo.SERVICE_LINES.BILL_QTY END) AS sub_exp_qty, (CASE WHEN dbo.ITEMS_V.name IN ('Sub - Exp.-F', 'Sub - Exp.-W', 'Sub - Exp.-S') 
                      THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS sub_exp_total, (CASE WHEN dbo.ITEMS_V.name IN ('Gen Labor-f-reg', 'Gen Labor-s-reg', 
                      'Gen Labor-w-reg') THEN dbo.SERVICE_LINES.BILL_RATE END) AS GenLabor_reg_rate, (CASE WHEN dbo.ITEMS_V.name IN ('Gen Labor-f-reg', 
                      'Gen Labor-s-reg', 'Gen Labor-w-reg') THEN dbo.SERVICE_LINES.BILL_QTY END) AS GenLabor_reg_qty, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('Gen Labor-f-reg', 'Gen Labor-s-reg', 'Gen Labor-w-reg') THEN dbo.SERVICE_LINES.BILL_TOTAL END) 
                      AS GenLabor_reg_total, (CASE WHEN dbo.ITEMS_V.name IN ('Gen Labor-f-ot', 'Gen Labor-s-ot', 'Gen Labor-w-ot') 
                      THEN dbo.SERVICE_LINES.BILL_RATE END) AS GenLabor_ot_rate, (CASE WHEN dbo.ITEMS_V.name IN ('Gen Labor-f-ot', 'Gen Labor-s-ot', 
                      'Gen Labor-w-ot') THEN dbo.SERVICE_LINES.BILL_QTY END) AS GenLabor_ot_qty, (CASE WHEN dbo.ITEMS_V.name IN ('Gen Labor-f-ot', 
                      'Gen Labor-s-ot', 'Gen Labor-w-ot') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS GenLabor_ot_total, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('Mover-Reg Hrs', 'Mover-f-Reg Hrs', 'Mover-s-Reg Hrs', 'Mover-w-Reg Hrs', 'Mover-Reg', 'Mover-f-Reg', 
                      'Mover-s-Reg', 'Mover-w-Reg') THEN dbo.SERVICE_LINES.BILL_RATE END) AS Mover_Reg_Hrs_rate, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('Mover-Reg Hrs', 'Mover-f-Reg Hrs', 'Mover-s-Reg Hrs', 'Mover-w-Reg Hrs', 'Mover-Reg', 'Mover-f-Reg', 
                      'Mover-s-Reg', 'Mover-w-Reg') THEN dbo.SERVICE_LINES.BILL_QTY END) AS Mover_Reg_Hrs_qty, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('Mover-Reg Hrs', 'Mover-f-Reg Hrs', 'Mover-s-Reg Hrs', 'Mover-w-Reg Hrs', 'Mover-Reg', 'Mover-f-Reg', 
                      'Mover-s-Reg', 'Mover-w-Reg') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS Mover_Reg_Hrs_total, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('Mover-OT Hrs', 'Mover-f-OT Hrs', 'Mover-s-OT Hrs', 'Mover-w-OT Hrs', 'Mover-OT', 'Mover-f-OT', 'Mover-s-OT', 
                      'Mover-w-OT') THEN dbo.SERVICE_LINES.BILL_RATE END) AS Mover_OT_Hrs_rate, (CASE WHEN dbo.ITEMS_V.name IN ('Mover-OT Hrs', 
                      'Mover-f-OT Hrs', 'Mover-s-OT Hrs', 'Mover-w-OT Hrs', 'Mover-OT', 'Mover-f-OT', 'Mover-s-OT', 'Mover-w-OT') 
                      THEN dbo.SERVICE_LINES.BILL_QTY END) AS Mover_OT_Hrs_qty, (CASE WHEN dbo.ITEMS_V.name IN ('Mover-OT Hrs', 'Mover-f-OT Hrs', 
                      'Mover-s-OT Hrs', 'Mover-w-OT Hrs', 'Mover-OT', 'Mover-f-OT', 'Mover-s-OT', 'Mover-w-OT') THEN dbo.SERVICE_LINES.BILL_TOTAL END) 
                      AS Mover_OT_Hrs_total, (CASE WHEN dbo.ITEMS_V.name IN ('pc/fab-reg', 'pc/fab-f-reg', 'pc/fab-s-reg', 'pc/fab-w-reg') 
                      THEN dbo.SERVICE_LINES.BILL_RATE END) AS pc_fab_reg_rate, (CASE WHEN dbo.ITEMS_V.name IN ('pc/fab-reg', 'pc/fab-f-reg', 'pc/fab-s-reg', 
                      'pc/fab-w-reg') THEN dbo.SERVICE_LINES.BILL_QTY END) AS pc_fab_reg_qty, (CASE WHEN dbo.ITEMS_V.name IN ('pc/fab-reg', 'pc/fab-f-reg', 
                      'pc/fab-s-reg', 'pc/fab-w-reg') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS pc_fab_reg_total, (CASE WHEN dbo.ITEMS_V.name IN ('pc/fab-ot', 
                      'pc/fab-f-ot', 'pc/fab-s-ot', 'pc/fab-w-ot') THEN dbo.SERVICE_LINES.BILL_RATE END) AS pc_fab_ot_rate, (CASE WHEN dbo.ITEMS_V.name IN ('pc/fab-ot', 
                      'pc/fab-f-ot', 'pc/fab-s-ot', 'pc/fab-w-ot') THEN dbo.SERVICE_LINES.BILL_QTY END) AS pc_fab_ot_qty, (CASE WHEN dbo.ITEMS_V.name IN ('pc/fab-ot', 
                      'pc/fab-f-ot', 'pc/fab-s-ot', 'pc/fab-w-ot') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS pc_fab_ot_total, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('Foreman-f-reg', 'Foreman-s-reg', 'Foreman-w-reg') THEN dbo.SERVICE_LINES.BILL_RATE END) 
                      AS Foreman_reg_rate, (CASE WHEN dbo.ITEMS_V.name IN ('Foreman-f-reg', 'Foreman-s-reg', 'Foreman-w-reg') 
                      THEN dbo.SERVICE_LINES.BILL_QTY END) AS Foreman_reg_qty, (CASE WHEN dbo.ITEMS_V.name IN ('Foreman-f-reg', 'Foreman-s-reg', 
                      'Foreman-w-reg') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS Foreman_reg_total, (CASE WHEN dbo.ITEMS_V.name IN ('Foreman-f-ot', 
                      'Foreman-s-ot', 'Foreman-w-ot') THEN dbo.SERVICE_LINES.BILL_RATE END) AS Foreman_ot_rate, (CASE WHEN dbo.ITEMS_V.name IN ('Foreman-f-ot', 
                      'Foreman-s-ot', 'Foreman-w-ot') THEN dbo.SERVICE_LINES.BILL_QTY END) AS Foreman_ot_qty, (CASE WHEN dbo.ITEMS_V.name IN ('Foreman-f-ot', 
                      'Foreman-s-ot', 'Foreman-w-ot') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS Foreman_ot_total, (CASE WHEN dbo.ITEMS_V.name IN ('lead-reg', 
                      'lead-f-reg', 'lead-s-reg', 'lead-w-reg') THEN dbo.SERVICE_LINES.BILL_RATE END) AS lead_reg_rate, (CASE WHEN dbo.ITEMS_V.name IN ('lead-reg', 
                      'lead-f-reg', 'lead-s-reg', 'lead-w-reg') THEN dbo.SERVICE_LINES.BILL_QTY END) AS lead_reg_qty, (CASE WHEN dbo.ITEMS_V.name IN ('lead-reg', 
                      'lead-f-reg', 'lead-s-reg', 'lead-w-reg') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS lead_reg_total, (CASE WHEN dbo.ITEMS_V.name IN ('lead-ot', 
                      'lead-f-ot', 'lead-s-ot', 'lead-w-ot') THEN dbo.SERVICE_LINES.BILL_RATE END) AS lead_ot_rate, (CASE WHEN dbo.ITEMS_V.name IN ('lead-ot', 
                      'lead-f-ot', 'lead-s-ot', 'lead-w-ot') THEN dbo.SERVICE_LINES.BILL_QTY END) AS lead_ot_qty, (CASE WHEN dbo.ITEMS_V.name IN ('lead-ot', 'lead-f-ot', 
                      'lead-s-ot', 'lead-w-ot') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS lead_ot_total, (CASE WHEN dbo.ITEMS_V.name IN ('ac-reg', 'ac-f-reg', 
                      'ac-s-reg', 'ac-w-reg') THEN dbo.SERVICE_LINES.BILL_RATE END) AS ac_reg_rate, (CASE WHEN dbo.ITEMS_V.name IN ('ac-reg', 'ac-f-reg', 'ac-s-reg', 
                      'ac-w-reg') THEN dbo.SERVICE_LINES.BILL_QTY END) AS ac_reg_qty, (CASE WHEN dbo.ITEMS_V.name IN ('ac-reg', 'ac-f-reg', 'ac-s-reg', 'ac-w-reg') 
                      THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS ac_reg_total, (CASE WHEN dbo.ITEMS_V.name IN ('ac-ot', 'ac-f-ot', 'ac-s-ot', 'ac-w-ot') 
                      THEN dbo.SERVICE_LINES.BILL_RATE END) AS ac_ot_rate, (CASE WHEN dbo.ITEMS_V.name IN ('ac-ot', 'ac-f-ot', 'ac-s-ot', 'ac-w-ot') 
                      THEN dbo.SERVICE_LINES.BILL_QTY END) AS ac_ot_qty, (CASE WHEN dbo.ITEMS_V.name IN ('ac-ot', 'ac-f-ot', 'ac-s-ot', 'ac-w-ot') 
                      THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS ac_ot_total, (CASE WHEN dbo.ITEMS_V.name IN ('am-reg', 'am-f-reg', 'am-s-reg', 'am-w-reg') 
                      THEN dbo.SERVICE_LINES.BILL_RATE END) AS am_reg_rate, (CASE WHEN dbo.ITEMS_V.name IN ('am-reg', 'am-f-reg', 'am-s-reg', 'am-w-reg') 
                      THEN dbo.SERVICE_LINES.BILL_QTY END) AS am_reg_qty, (CASE WHEN dbo.ITEMS_V.name IN ('am-reg', 'am-f-reg', 'am-s-reg', 'am-w-reg') 
                      THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS am_reg_total, (CASE WHEN dbo.ITEMS_V.name IN ('am-ot', 'am-f-ot', 'am-s-ot', 'am-w-ot') 
                      THEN dbo.SERVICE_LINES.BILL_RATE END) AS am_ot_rate, (CASE WHEN dbo.ITEMS_V.name IN ('am-ot', 'am-f-ot', 'am-s-ot', 'am-w-ot') 
                      THEN dbo.SERVICE_LINES.BILL_QTY END) AS am_ot_qty, (CASE WHEN dbo.ITEMS_V.name IN ('am-ot', 'am-f-ot', 'am-s-ot', 'am-w-ot') 
                      THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS am_ot_total, (CASE WHEN dbo.ITEMS_V.name IN ('mac-reg', 'mac-f-reg', 'mac-s-reg', 'mac-w-reg') 
                      THEN dbo.SERVICE_LINES.BILL_RATE END) AS mac_reg_rate, (CASE WHEN dbo.ITEMS_V.name IN ('mac-reg', 'mac-f-reg', 'mac-s-reg', 'mac-w-reg') 
                      THEN dbo.SERVICE_LINES.BILL_QTY END) AS mac_reg_qty, (CASE WHEN dbo.ITEMS_V.name IN ('mac-reg', 'mac-f-reg', 'mac-s-reg', 'mac-w-reg') 
                      THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS mac_reg_total, (CASE WHEN dbo.ITEMS_V.name IN ('mac-ot', 'mac-f-ot', 'mac-s-ot', 'mac-w-ot') 
                      THEN dbo.SERVICE_LINES.BILL_RATE END) AS mac_ot_rate, (CASE WHEN dbo.ITEMS_V.name IN ('mac-ot', 'mac-f-ot', 'mac-s-ot', 'mac-w-ot') 
                      THEN dbo.SERVICE_LINES.BILL_QTY END) AS mac_ot_qty, (CASE WHEN dbo.ITEMS_V.name IN ('mac-ot', 'mac-f-ot', 'mac-s-ot', 'mac-w-ot') 
                      THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS mac_ot_total, (CASE WHEN dbo.ITEMS_V.name IN ('mps-reg', 'mps-f-reg', 'mps-s-reg', 'mps-w-reg') 
                      THEN dbo.SERVICE_LINES.BILL_RATE END) AS mps_reg_rate, (CASE WHEN dbo.ITEMS_V.name IN ('mps-reg', 'mps-f-reg', 'mps-s-reg', 'mps-w-reg') 
                      THEN dbo.SERVICE_LINES.BILL_QTY END) AS mps_reg_qty, (CASE WHEN dbo.ITEMS_V.name IN ('mps-reg', 'mps-f-reg', 'mps-s-reg', 'mps-w-reg') 
                      THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS mps_reg_total, (CASE WHEN dbo.ITEMS_V.name IN ('mps-ot', 'mps-f-ot', 'mps-s-ot', 'mps-w-ot') 
                      THEN dbo.SERVICE_LINES.BILL_RATE END) AS mps_ot_rate, (CASE WHEN dbo.ITEMS_V.name IN ('mps-ot', 'mps-f-ot', 'mps-s-ot', 'mps-w-ot') 
                      THEN dbo.SERVICE_LINES.BILL_QTY END) AS mps_ot_qty, (CASE WHEN dbo.ITEMS_V.name IN ('mps-ot', 'mps-f-ot', 'mps-s-ot', 'mps-w-ot') 
                      THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS mps_ot_total, (CASE WHEN dbo.ITEMS_V.name IN ('ps-reg', 'ps-f-reg', 'ps-s-reg', 'ps-w-reg') 
                      THEN dbo.SERVICE_LINES.BILL_RATE END) AS ps_reg_rate, (CASE WHEN dbo.ITEMS_V.name IN ('ps-reg', 'ps-f-reg', 'ps-s-reg', 'ps-w-reg') 
                      THEN dbo.SERVICE_LINES.BILL_QTY END) AS ps_reg_qty, (CASE WHEN dbo.ITEMS_V.name IN ('ps-reg', 'ps-f-reg', 'ps-s-reg', 'ps-w-reg') 
                      THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS ps_reg_total, (CASE WHEN dbo.ITEMS_V.name IN ('ps-ot', 'ps-f-ot', 'ps-s-ot', 'ps-w-ot') 
                      THEN dbo.SERVICE_LINES.BILL_RATE END) AS ps_ot_rate, (CASE WHEN dbo.ITEMS_V.name IN ('ps-ot', 'ps-f-ot', 'ps-s-ot', 'ps-w-ot') 
                      THEN dbo.SERVICE_LINES.BILL_QTY END) AS ps_ot_qty, (CASE WHEN dbo.ITEMS_V.name IN ('ps-ot', 'ps-f-ot', 'ps-s-ot', 'ps-w-ot') 
                      THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS ps_ot_total, (CASE WHEN dbo.ITEMS_V.name IN ('campfurnmgr-reg', 'campfurnmgr-f-reg', 
                      'campfurnmgr-s-reg', 'campfurnmgr-w-reg') THEN dbo.SERVICE_LINES.BILL_RATE END) AS campfurnmgr_reg_rate, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('campfurnmgr-reg', 'campfurnmgr-f-reg', 'campfurnmgr-s-reg', 'campfurnmgr-w-reg') 
                      THEN dbo.SERVICE_LINES.BILL_QTY END) AS campfurnmgr_reg_qty, (CASE WHEN dbo.ITEMS_V.name IN ('campfurnmgr-reg', 'campfurnmgr-f-reg', 
                      'campfurnmgr-s-reg', 'campfurnmgr-w-reg') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS campfurnmgr_reg_total, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('campfurnmgr-ot', 'campfurnmgr-f-ot', 'campfurnmgr-s-ot', 'campfurnmgr-w-ot') 
                      THEN dbo.SERVICE_LINES.BILL_RATE END) AS campfurnmgr_ot_rate, (CASE WHEN dbo.ITEMS_V.name IN ('campfurnmgr-ot', 'campfurnmgr-f-ot', 
                      'campfurnmgr-s-ot', 'campfurnmgr-w-ot') THEN dbo.SERVICE_LINES.BILL_QTY END) AS campfurnmgr_ot_qty, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('campfurnmgr-ot', 'campfurnmgr-f-ot', 'campfurnmgr-s-ot', 'campfurnmgr-w-ot') 
                      THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS campfurnmgr_ot_total, (CASE WHEN dbo.ITEMS_V.name IN ('EquMovLab-F-REG', 
                      'EquMovLab-S-REG') THEN dbo.SERVICE_LINES.BILL_RATE END) AS EquMovLabor_reg_rate, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('EquMovLab-F-REG', 'EquMovLab-S-REG') THEN dbo.SERVICE_LINES.BILL_QTY END) AS EquMovLabor_reg_qty, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('EquMovLab-F-REG', 'EquMovLab-S-REG') THEN dbo.SERVICE_LINES.BILL_TOTAL END) 
                      AS EquMovLabor_reg_total, (CASE WHEN dbo.ITEMS_V.name IN ('EquMovLab-F-OT', 'EquMovLab-S-OT') THEN dbo.SERVICE_LINES.BILL_RATE END) 
                      AS EquMovLabor_ot_rate, (CASE WHEN dbo.ITEMS_V.name IN ('EquMovLab-F-OT', 'EquMovLab-S-OT') THEN dbo.SERVICE_LINES.BILL_QTY END) 
                      AS EquMovLabor_ot_qty, (CASE WHEN dbo.ITEMS_V.name IN ('EquMovLab-F-OT', 'EquMovLab-S-OT') THEN dbo.SERVICE_LINES.BILL_TOTAL END) 
                      AS EquMovLabor_ot_total, (CASE WHEN dbo.ITEMS_V.name IN ('OffEquMgr-F-REG', 'OffEquMgr-S-REG') THEN dbo.SERVICE_LINES.BILL_RATE END) 
                      AS OfficeEquMgr_reg_rate, (CASE WHEN dbo.ITEMS_V.name IN ('OffEquMgr-F-REG', 'OffEquMgr-S-REG') THEN dbo.SERVICE_LINES.BILL_QTY END) 
                      AS OfficeEquMgr_reg_qty, (CASE WHEN dbo.ITEMS_V.name IN ('OffEquMgr-F-REG', 'OffEquMgr-S-REG') THEN dbo.SERVICE_LINES.BILL_TOTAL END) 
                      AS OfficeEquMgr_reg_total, (CASE WHEN dbo.ITEMS_V.name IN ('OffEquMgr-F-OT', 'OffEquMgr-S-OT') THEN dbo.SERVICE_LINES.BILL_RATE END) 
                      AS OfficeEquMgr_ot_rate, (CASE WHEN dbo.ITEMS_V.name IN ('OffEquMgr-F-OT', 'OffEquMgr-S-OT') THEN dbo.SERVICE_LINES.BILL_QTY END) 
                      AS OfficeEquMgr_ot_qty, (CASE WHEN dbo.ITEMS_V.name IN ('OffEquMgr-F-OT', 'OffEquMgr-S-OT') THEN dbo.SERVICE_LINES.BILL_TOTAL END) 
                      AS OfficeEquMgr_ot_total, (CASE WHEN dbo.ITEMS_V.name IN ('PC Coord-reg', 'PC Coord-f-reg', 'PC Coord-s-reg', 'PC Coord-w-reg') 
                      THEN dbo.SERVICE_LINES.BILL_RATE END) AS pc_coord_reg_rate, (CASE WHEN dbo.ITEMS_V.name IN ('PC Coord-reg', 'PC Coord-f-reg', 
                      'PC Coord-s-reg', 'PC Coord-w-reg') THEN dbo.SERVICE_LINES.BILL_QTY END) AS pc_coord_reg_qty, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('PC Coord-reg', 'PC Coord-f-reg', 'PC Coord-s-reg', 'PC Coord-w-reg') THEN dbo.SERVICE_LINES.BILL_TOTAL END) 
                      AS pc_coord_reg_total, (CASE WHEN dbo.ITEMS_V.name IN ('PC Coord-ot', 'PC Coord-f-ot', 'PC Coord-s-ot', 'PC Coord-w-ot') 
                      THEN dbo.SERVICE_LINES.BILL_RATE END) AS pc_coord_ot_rate, (CASE WHEN dbo.ITEMS_V.name IN ('PC Coord-ot', 'PC Coord-f-ot', 'PC Coord-s-ot', 
                      'PC Coord-w-ot') THEN dbo.SERVICE_LINES.BILL_QTY END) AS pc_coord_ot_qty, (CASE WHEN dbo.ITEMS_V.name IN ('PC Coord-ot', 'PC Coord-f-ot', 
                      'PC Coord-s-ot', 'PC Coord-w-ot') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS pc_coord_ot_total, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('PC Mover-reg', 'PC Mover-f-reg', 'PC Mover-s-reg', 'PC Mover-w-reg') THEN dbo.SERVICE_LINES.BILL_RATE END)
                       AS pc_mover_reg_rate, (CASE WHEN dbo.ITEMS_V.name IN ('PC Mover-reg', 'PC Mover-f-reg', 'PC Mover-s-reg', 'PC Mover-w-reg') 
                      THEN dbo.SERVICE_LINES.BILL_QTY END) AS pc_mover_reg_qty, (CASE WHEN dbo.ITEMS_V.name IN ('PC Mover-reg', 'PC Mover-f-reg', 
                      'PC Mover-s-reg', 'PC Mover-w-reg') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS pc_mover_reg_total, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('PC Mover-ot', 'PC Mover-f-ot', 'PC Mover-s-ot', 'PC Mover-w-ot') THEN dbo.SERVICE_LINES.BILL_RATE END) 
                      AS pc_mover_ot_rate, (CASE WHEN dbo.ITEMS_V.name IN ('PC Mover-ot', 'PC Mover-f-ot', 'PC Mover-s-ot', 'PC Mover-w-ot') 
                      THEN dbo.SERVICE_LINES.BILL_QTY END) AS pc_mover_ot_qty, (CASE WHEN dbo.ITEMS_V.name IN ('PC Mover-ot', 'PC Mover-f-ot', 'PC Mover-s-ot', 
                      'PC Mover-w-ot') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS pc_mover_ot_total, (CASE WHEN dbo.ITEMS_V.name IN ('Proj Mgr-F-Reg', 
                      'Proj Mgr-S-Reg', 'Proj Mgr-W-Reg') THEN dbo.SERVICE_LINES.BILL_RATE END) AS ProjMgr_reg_rate, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('Proj Mgr-F-Reg', 'Proj Mgr-S-Reg', 'Proj Mgr-W-Reg') THEN dbo.SERVICE_LINES.BILL_QTY END) 
                      AS ProjMgr_reg_qty, (CASE WHEN dbo.ITEMS_V.name IN ('Proj Mgr-F-Reg', 'Proj Mgr-S-Reg', 'Proj Mgr-W-Reg') 
                      THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS ProjMgr_reg_total, (CASE WHEN dbo.ITEMS_V.name IN ('Proj Mgr-F-OT', 'Proj Mgr-S-OT', 
                      'Proj Mgr-W-OT') THEN dbo.SERVICE_LINES.BILL_RATE END) AS ProjMgr_ot_rate, (CASE WHEN dbo.ITEMS_V.name IN ('Proj Mgr-F-OT', 
                      'Proj Mgr-S-OT', 'Proj Mgr-W-OT') THEN dbo.SERVICE_LINES.BILL_QTY END) AS ProjMgr_ot_qty, (CASE WHEN dbo.ITEMS_V.name IN ('Proj Mgr-F-OT', 
                      'Proj Mgr-S-OT', 'Proj Mgr-W-OT') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS ProjMgr_ot_total, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('regprojmgr-reg', 'regprojmgr-f-reg', 'regprojmgr-s-reg', 'regprojmgr-w-reg') 
                      THEN dbo.SERVICE_LINES.BILL_RATE END) AS regProjMgr_reg_rate, (CASE WHEN dbo.ITEMS_V.name IN ('regprojmgr-reg', 'regprojmgr-f-reg', 
                      'regprojmgr-s-reg', 'regprojmgr-w-reg') THEN dbo.SERVICE_LINES.BILL_QTY END) AS regProjMgr_reg_qty, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('regprojmgr-reg', 'regprojmgr-f-reg', 'regprojmgr-s-reg', 'regprojmgr-w-reg') 
                      THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS regProjMgr_reg_total, (CASE WHEN dbo.ITEMS_V.name IN ('regprojmgr-ot', 'regprojmgr-f-ot', 
                      'regprojmgr-s-ot', 'regprojmgr-w-ot') THEN dbo.SERVICE_LINES.BILL_RATE END) AS regProjMgr_ot_rate, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('regprojmgr-ot', 'regprojmgr-f-ot', 'regprojmgr-s-ot', 'regprojmgr-w-ot') THEN dbo.SERVICE_LINES.BILL_QTY END) 
                      AS regProjMgr_ot_qty, (CASE WHEN dbo.ITEMS_V.name IN ('regprojmgr-ot', 'regprojmgr-f-ot', 'regprojmgr-s-ot', 'regprojmgr-w-ot') 
                      THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS regProjMgr_ot_total, (CASE WHEN dbo.ITEMS_V.name IN ('AssetHdlr-f-reg', 'AssetHdlr-s-reg', 
                      'AssetHdlr-w-reg') THEN dbo.SERVICE_LINES.BILL_RATE END) AS AssetHdlr_reg_rate, (CASE WHEN dbo.ITEMS_V.name IN ('AssetHdlr-f-reg', 
                      'AssetHdlr-s-reg', 'AssetHdlr-w-reg') THEN dbo.SERVICE_LINES.BILL_QTY END) AS AssetHdlr_reg_qty, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('AssetHdlr-f-reg', 'AssetHdlr-s-reg', 'AssetHdlr-w-reg') THEN dbo.SERVICE_LINES.BILL_TOTAL END) 
                      AS AssetHdlr_reg_total, (CASE WHEN dbo.ITEMS_V.name IN ('AssetHdlr-f-ot', 'AssetHdlr-s-ot', 'AssetHdlr-w-ot') 
                      THEN dbo.SERVICE_LINES.BILL_RATE END) AS AssetHdlr_ot_rate, (CASE WHEN dbo.ITEMS_V.name IN ('AssetHdlr-f-ot', 'AssetHdlr-s-ot', 
                      'AssetHdlr-w-ot') THEN dbo.SERVICE_LINES.BILL_QTY END) AS AssetHdlr_ot_qty, (CASE WHEN dbo.ITEMS_V.name IN ('AssetHdlr-f-ot', 
                      'AssetHdlr-s-ot', 'AssetHdlr-w-ot') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS AssetHdlr_ot_total, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('am spec.-reg', 'am spec.-f-reg', 'am spec.-s-reg', 'am spec.-w-reg') THEN dbo.SERVICE_LINES.BILL_RATE END) 
                      AS am_spec_reg_rate, (CASE WHEN dbo.ITEMS_V.name IN ('am spec.-reg', 'am spec.-f-reg', 'am spec.-s-reg', 'am spec.-w-reg') 
                      THEN dbo.SERVICE_LINES.BILL_QTY END) AS am_spec_reg_qty, (CASE WHEN dbo.ITEMS_V.name IN ('am spec.-reg', 'am spec.-f-reg', 
                      'am spec.-s-reg', 'am spec.-w-reg') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS am_spec_reg_total, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('am spec.-ot', 'am spec.-f-ot', 'am spec.-s-ot', 'am spec.-w-ot') THEN dbo.SERVICE_LINES.BILL_RATE END) 
                      AS am_spec_ot_rate, (CASE WHEN dbo.ITEMS_V.name IN ('am spec.-ot', 'am spec.-f-ot', 'am spec.-s-ot', 'am spec.-w-ot') 
                      THEN dbo.SERVICE_LINES.BILL_QTY END) AS am_spec_ot_qty, (CASE WHEN dbo.ITEMS_V.name IN ('am spec.-ot', 'am spec.-f-ot', 'am spec.-s-ot', 
                      'am spec.-w-ot') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS am_spec_ot_total, (CASE WHEN dbo.ITEMS_V.name IN ('whse-reg', 'whse-f-reg', 
                      'whse-s-reg', 'whse-w-reg', 'Snaptrack-F-Reg', 'Snaptrack-S-Reg', 'Snaptrack-W-Reg', 'Snaptkr-W-Reg', 'Snaptkr-OH-Reg', 'ST-OH-Reg') 
                      THEN dbo.SERVICE_LINES.BILL_RATE END) AS whse_reg_rate, (CASE WHEN dbo.ITEMS_V.name IN ('whse-reg', 'whse-f-reg', 'whse-s-reg', 
                      'whse-w-reg', 'Snaptrack-F-Reg', 'Snaptrack-S-Reg', 'Snaptrack-W-Reg', 'Snaptkr-W-Reg', 'Snaptkr-OH-Reg', 'ST-OH-Reg') 
                      THEN dbo.SERVICE_LINES.BILL_QTY END) AS whse_reg_qty, (CASE WHEN dbo.ITEMS_V.name IN ('whse-reg', 'whse-f-reg', 'whse-s-reg', 'whse-w-reg', 
                      'Snaptrack-F-Reg', 'Snaptrack-S-Reg', 'Snaptrack-W-Reg', 'Snaptkr-W-Reg', 'Snaptkr-OH-Reg', 'ST-OH-Reg') 
                      THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS whse_reg_total, (CASE WHEN dbo.ITEMS_V.name IN ('whse-ot', 'whse-f-ot', 'whse-s-ot', 'whse-w-ot', 
                      'Snaptrack-F-OT', 'Snaptrack-S-OT', 'Snaptrack-W-OT', 'Snaptkr-W-OT', 'Snaptkr-OH-OT', 'ST-OH-OT') THEN dbo.SERVICE_LINES.BILL_RATE END) 
                      AS whse_ot_rate, (CASE WHEN dbo.ITEMS_V.name IN ('whse-ot', 'whse-f-ot', 'whse-s-ot', 'whse-w-ot', 'Snaptrack-F-OT', 'Snaptrack-S-OT', 
                      'Snaptrack-W-OT', 'Snaptkr-W-OT', 'Snaptkr-OH-OT', 'ST-OH-OT') THEN dbo.SERVICE_LINES.BILL_QTY END) AS whse_ot_qty, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('whse-ot', 'whse-f-ot', 'whse-s-ot', 'whse-w-ot', 'Snaptrack-F-OT', 'Snaptrack-S-OT', 'Snaptrack-W-OT', 
                      'Snaptkr-W-OT', 'Snaptkr-OH-OT', 'ST-OH-OT') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS whse_ot_total, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('whse sup-reg', 'whse sup-f-reg', 'whse sup-s-reg', 'whse sup-w-reg') THEN dbo.SERVICE_LINES.BILL_RATE END) 
                      AS WhseSup_reg_rate, (CASE WHEN dbo.ITEMS_V.name IN ('whse sup-reg', 'whse sup-f-reg', 'whse sup-s-reg', 'whse sup-w-reg') 
                      THEN dbo.SERVICE_LINES.BILL_QTY END) AS WhseSup_reg_qty, (CASE WHEN dbo.ITEMS_V.name IN ('whse sup-reg', 'whse sup-f-reg', 
                      'whse sup-s-reg', 'whse sup-w-reg') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS WhseSup_reg_total, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('whse sup-ot', 'whse sup-f-ot', 'whse sup-s-ot', 'whse sup-w-ot') THEN dbo.SERVICE_LINES.BILL_RATE END) 
                      AS WhseSup_ot_rate, (CASE WHEN dbo.ITEMS_V.name IN ('whse sup-ot', 'whse sup-f-ot', 'whse sup-s-ot', 'whse sup-w-ot') 
                      THEN dbo.SERVICE_LINES.BILL_QTY END) AS WhseSup_ot_qty, (CASE WHEN dbo.ITEMS_V.name IN ('whse sup-ot', 'whse sup-f-ot', 'whse sup-s-ot', 
                      'whse sup-w-ot') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS WhseSup_ot_total, (CASE WHEN dbo.ITEMS_V.name IN ('Piece Count In') 
                      THEN dbo.SERVICE_LINES.BILL_RATE END) AS PieceCountIn_rate, (CASE WHEN dbo.ITEMS_V.name IN ('Piece Count In') 
                      THEN dbo.SERVICE_LINES.BILL_QTY END) AS PieceCountIn_qty, (CASE WHEN dbo.ITEMS_V.name IN ('Piece Count In') 
                      THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS PieceCountIn_total, (CASE WHEN dbo.ITEMS_V.name IN ('Piece Count Out') 
                      THEN dbo.SERVICE_LINES.BILL_RATE END) AS PieceCountOut_rate, (CASE WHEN dbo.ITEMS_V.name IN ('Piece Count Out') 
                      THEN dbo.SERVICE_LINES.BILL_QTY END) AS PieceCountOut_qty, (CASE WHEN dbo.ITEMS_V.name IN ('Piece Count Out') 
                      THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS PieceCountOut_total, (CASE WHEN dbo.ITEMS_V.name IN ('Freight', 'Freight-S', 'Freight-OH', 
                      'Freight-F', 'Freight-W') THEN dbo.SERVICE_LINES.BILL_RATE END) AS Freight_rate, (CASE WHEN dbo.ITEMS_V.name IN ('Freight', 'Freight-S', 
                      'Freight-OH', 'Freight-F', 'Freight-W') THEN dbo.SERVICE_LINES.BILL_QTY END) AS Freight_qty, (CASE WHEN dbo.ITEMS_V.name IN ('Freight', 
                      'Freight-S', 'Freight-OH', 'Freight-F', 'Freight-W') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS Freight_total, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('Perdiem', 'Perdiem-F', 'Perdiem-OH', 'Perdiem-W', 'Perdiem-S') THEN dbo.SERVICE_LINES.BILL_TOTAL END) 
                      AS perdiem, (CASE WHEN dbo.ITEMS_V.name IN ('Lodging', 'Lodging-S', 'Lodging-W', 'Lodging-F', 'Lodging-OH') 
                      THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS lodging, (CASE WHEN dbo.ITEMS_V.name IN ('Travel', 'Travel-F', 'Travel-OH', 'Travel-W', 
                      'TRAVEL REG', 'Travel-F-Reg', 'Travel-OH-Reg', 'Travel-S', 'Travel-S-Reg', 'Travel-W-Reg') THEN dbo.SERVICE_LINES.BILL_RATE END) 
                      AS travel_reg_rate, (CASE WHEN dbo.ITEMS_V.name IN ('Travel', 'Travel-F', 'Travel-OH', 'Travel-W', 'TRAVEL REG', 'Travel-F-Reg', 'Travel-OH-Reg', 
                      'Travel-S', 'Travel-S-Reg', 'Travel-W-Reg') THEN dbo.SERVICE_LINES.BILL_QTY END) AS travel_reg_qty, (CASE WHEN dbo.ITEMS_V.name IN ('Travel', 
                      'Travel-F', 'Travel-OH', 'Travel-W', 'TRAVEL REG', 'Travel-F-Reg', 'Travel-OH-Reg', 'Travel-S', 'Travel-S-Reg', 'Travel-W-Reg') 
                      THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS travel_reg_total, (CASE WHEN dbo.ITEMS_V.name IN ('TRAVEL OT', 'Travel-F-OT', 'Travel-OH-OT', 
                      'Travel-S-OT', 'Travel-W-OT') THEN dbo.SERVICE_LINES.BILL_RATE END) AS travel_ot_rate, (CASE WHEN dbo.ITEMS_V.name IN ('TRAVEL OT', 
                      'Travel-F-OT', 'Travel-OH-OT', 'Travel-S-OT', 'Travel-W-OT') THEN dbo.SERVICE_LINES.BILL_QTY END) AS travel_ot_qty, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('TRAVEL OT', 'Travel-F-OT', 'Travel-OH-OT', 'Travel-S-OT', 'Travel-W-OT') 
                      THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS travel_ot_total, (CASE WHEN dbo.ITEMS_V.name IN ('ProjCoor-S-REG', 'ProjCoor-F-REG', 
                      'ProjCoor-W-REG') THEN dbo.SERVICE_LINES.BILL_QTY END) AS ProjCoor_reg_qty, (CASE WHEN dbo.ITEMS_V.name IN ('ProjCoor-S-REG', 
                      'ProjCoor-F-REG', 'ProjCoor-W-REG') THEN dbo.SERVICE_LINES.BILL_RATE END) AS ProjCoor_reg_rate, 
                      (CASE WHEN dbo.ITEMS_V.name IN ('ProjCoor-S-REG', 'ProjCoor-F-REG', 'ProjCoor-W-REG') THEN dbo.SERVICE_LINES.BILL_TOTAL END) 
                      AS ProjCoor_reg_total, (CASE WHEN dbo.ITEMS_V.name IN ('ProjCoor-S-OT', 'ProjCoor-F-OT', 'ProjCoor-W-OT') 
                      THEN dbo.SERVICE_LINES.BILL_QTY END) AS ProjCoor_ot_qty, (CASE WHEN dbo.ITEMS_V.name IN ('ProjCoor-S-OT', 'ProjCoor-F-OT', 
                      'ProjCoor-W-OT') THEN dbo.SERVICE_LINES.BILL_RATE END) AS ProjCoor_ot_rate, (CASE WHEN dbo.ITEMS_V.name IN ('ProjCoor-S-OT', 
                      'ProjCoor-F-OT', 'ProjCoor-W-OT') THEN dbo.SERVICE_LINES.BILL_TOTAL END) AS ProjCoor_ot_total, 
                      dbo.JOB_LOCATIONS_V.JOB_LOCATION_NAME
FROM         dbo.SERVICES INNER JOIN
                      dbo.JOB_LOCATIONS_V ON dbo.SERVICES.JOB_LOCATION_ID = dbo.JOB_LOCATIONS_V.JOB_LOCATION_ID LEFT OUTER JOIN
                      dbo.jobs_v LEFT OUTER JOIN
                      dbo.CUSTOM_CUST_COLUMNS_V ON dbo.jobs_v.customer_id = dbo.CUSTOM_CUST_COLUMNS_V.CUSTOMER_ID ON 
                      dbo.SERVICES.JOB_ID = dbo.jobs_v.job_id RIGHT OUTER JOIN
                      dbo.INVOICES LEFT OUTER JOIN
                      dbo.INVOICE_STATUSES ON dbo.INVOICES.STATUS_ID = dbo.INVOICE_STATUSES.STATUS_ID RIGHT OUTER JOIN
                      dbo.SERVICE_LINE_STATUSES RIGHT OUTER JOIN
                      dbo.RESOURCE_TYPES_V RIGHT OUTER JOIN
                      dbo.LOOKUPS AS res_cat_types RIGHT OUTER JOIN
                      dbo.RESOURCES ON res_cat_types.LOOKUP_ID = dbo.RESOURCES.RES_CATEGORY_TYPE_ID ON 
                      dbo.RESOURCE_TYPES_V.RESOURCE_TYPE_ID = dbo.RESOURCES.RESOURCE_TYPE_ID RIGHT OUTER JOIN
                      dbo.SERVICE_LINES ON dbo.RESOURCES.RESOURCE_ID = dbo.SERVICE_LINES.RESOURCE_ID ON 
                      dbo.SERVICE_LINE_STATUSES.STATUS_ID = dbo.SERVICE_LINES.STATUS_ID ON dbo.INVOICES.INVOICE_ID = dbo.SERVICE_LINES.INVOICE_ID ON 
                      dbo.SERVICES.SERVICE_ID = dbo.SERVICE_LINES.BILL_SERVICE_ID LEFT OUTER JOIN
                      dbo.ITEMS_V ON dbo.SERVICE_LINES.ITEM_ID = dbo.ITEMS_V.ITEM_ID
WHERE     (dbo.INVOICE_STATUSES.CODE IN ('COMPLETE', 'INVOICED')) AND (dbo.jobs_v.organization_id = '20')
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "SERVICES"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 262
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "JOB_LOCATIONS_V"
            Begin Extent = 
               Top = 6
               Left = 300
               Bottom = 114
               Right = 549
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "jobs_v"
            Begin Extent = 
               Top = 6
               Left = 587
               Bottom = 114
               Right = 787
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CUSTOM_CUST_COLUMNS_V"
            Begin Extent = 
               Top = 114
               Left = 38
               Bottom = 222
               Right = 235
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "INVOICES"
            Begin Extent = 
               Top = 114
               Left = 273
               Bottom = 222
               Right = 490
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "INVOICE_STATUSES"
            Begin Extent = 
               Top = 114
               Left = 528
               Bottom = 207
               Right = 679
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SERVICE_LINE_STATUSES"
            Begin Extent = 
               Top = 210
               Left = 528
               Bottom = 303
               Right = 679
   ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'SERVICE_ACCT_RPT_TEMP_V_AZ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'         End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "RESOURCE_TYPES_V"
            Begin Extent = 
               Top = 222
               Left = 38
               Bottom = 330
               Right = 246
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "res_cat_types"
            Begin Extent = 
               Top = 222
               Left = 284
               Bottom = 330
               Right = 466
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "RESOURCES"
            Begin Extent = 
               Top = 306
               Left = 504
               Bottom = 414
               Right = 710
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SERVICE_LINES"
            Begin Extent = 
               Top = 330
               Left = 38
               Bottom = 438
               Right = 276
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ITEMS_V"
            Begin Extent = 
               Top = 414
               Left = 314
               Bottom = 522
               Right = 523
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'SERVICE_ACCT_RPT_TEMP_V_AZ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'SERVICE_ACCT_RPT_TEMP_V_AZ'
GO
/****** Object:  View [dbo].[PAYROLL_VERIFICATION_V]    Script Date: 05/03/2010 14:18:08 ******/
-- SET ANSI_NULLS ON
-- GO
-- SET QUOTED_IDENTIFIER ON
-- GO
-- CREATE VIEW [dbo].[PAYROLL_VERIFICATION_V]
-- AS
-- SELECT     pay.ORGANIZATION_ID, sl.RESOURCE_ID, pay.TC_JOB_ID AS JOB_ID, pay.TC_JOB_NO AS JOB_NO, pay.TC_SERVICE_ID AS SERVICE_ID,
--                       pay.TC_SERVICE_NO AS SERVICE_NO, pay.resource_name, dbo.RESOURCES_V.RES_CATEGORY_TYPE_ID, dbo.RESOURCES_V.res_cat_type_code,
--                       dbo.RESOURCES_V.res_cat_type_name, dbo.jobs_v.ext_customer_id, dbo.jobs_v.dealer_name, dbo.jobs_v.ext_dealer_id, sl.VERIFIED_DATE,
--                       sl.VERIFIED_BY, sl.PAYROLL_QTY AS hours_qty, sl.BILL_HOURLY_QTY AS hours_bill_qty, sl.BILL_HOURLY_RATE AS hours_bill_rate,
--                       pay.EXT_EMPLOYEE_ID, pay.employee_name, CONVERT(varchar(12), DATEADD(day, - 6, sl.SERVICE_LINE_WEEK), 101) AS begin_date,
--                       CONVERT(varchar(12), sl.SERVICE_LINE_WEEK, 101) AS end_date, pay.SERVICE_LINE_DATE, pay.ITEM_ID, pay.ITEM_NAME, pay.EXT_PAY_CODE,
--                       pay.ITEM_TYPE_CODE, dbo.ITEMS_V.item_type_name, sl.bill_hourly_total AS hours_bill_price, dbo.jobs_v.job_no_name, sl.ENTERED_DATE,
--                       sl.EXT_PAY_CODE AS EXT_PAYCODE, dbo.GP_MPLS_PAY_CODE_V.PAYRCORD, dbo.GP_MPLS_PAY_CODE_V.DSCRIPTN, sl.ENTERED_BY,
--                       sl.entered_by_name, dbo.USERS.USER_ID, dbo.USERS.FIRST_NAME, dbo.USERS.LAST_NAME, dbo.USERS.EXT_EMPLOYEE_ID AS EMP_ID,
--                       sl.verified_by_name, sl.ENTRY_METHOD, sl.TC_QTY, sl.TC_RATE, sl.tc_total, dbo.jobs_v.foreman_resource_name, sl.modified_by_name
-- FROM         dbo.USERS RIGHT OUTER JOIN
--                       dbo.ITEMS_V RIGHT OUTER JOIN
--                       dbo.PAYROLL_V AS pay ON dbo.ITEMS_V.ITEM_ID = pay.ITEM_ID LEFT OUTER JOIN
--                       dbo.jobs_v ON pay.TC_JOB_ID = dbo.jobs_v.job_id LEFT OUTER JOIN
--                       dbo.RESOURCES_V RIGHT OUTER JOIN
--                       dbo.TIME_CAPTURE_V AS sl ON dbo.RESOURCES_V.RESOURCE_ID = sl.RESOURCE_ID ON pay.SERVICE_LINE_ID = sl.SERVICE_LINE_ID ON
--                       dbo.USERS.USER_ID = sl.ENTERED_BY LEFT OUTER JOIN
--                       dbo.GP_MPLS_PAY_CODE_V ON sl.EXT_PAY_CODE = dbo.GP_MPLS_PAY_CODE_V.PAYRCORD
-- WHERE     (pay.PAYROLL_EXPORTED_FLAG = 'N') OR
--                       (pay.PAYROLL_EXPORTED_FLAG = 'N')
-- GO
-- EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
-- Begin DesignProperties =
--    Begin PaneConfigurations =
--       Begin PaneConfiguration = 0
--          NumPanes = 4
--          Configuration = "(H (1[40] 4[20] 2[20] 3) )"
--       End
--       Begin PaneConfiguration = 1
--          NumPanes = 3
--          Configuration = "(H (1 [50] 4 [25] 3))"
--       End
--       Begin PaneConfiguration = 2
--          NumPanes = 3
--          Configuration = "(H (1 [50] 2 [25] 3))"
--       End
--       Begin PaneConfiguration = 3
--          NumPanes = 3
--          Configuration = "(H (4 [30] 2 [40] 3))"
--       End
--       Begin PaneConfiguration = 4
--          NumPanes = 2
--          Configuration = "(H (1 [56] 3))"
--       End
--       Begin PaneConfiguration = 5
--          NumPanes = 2
--          Configuration = "(H (2 [66] 3))"
--       End
--       Begin PaneConfiguration = 6
--          NumPanes = 2
--          Configuration = "(H (4 [50] 3))"
--       End
--       Begin PaneConfiguration = 7
--          NumPanes = 1
--          Configuration = "(V (3))"
--       End
--       Begin PaneConfiguration = 8
--          NumPanes = 3
--          Configuration = "(H (1[56] 4[18] 2) )"
--       End
--       Begin PaneConfiguration = 9
--          NumPanes = 2
--          Configuration = "(H (1 [75] 4))"
--       End
--       Begin PaneConfiguration = 10
--          NumPanes = 2
--          Configuration = "(H (1[66] 2) )"
--       End
--       Begin PaneConfiguration = 11
--          NumPanes = 2
--          Configuration = "(H (4 [60] 2))"
--       End
--       Begin PaneConfiguration = 12
--          NumPanes = 1
--          Configuration = "(H (1) )"
--       End
--       Begin PaneConfiguration = 13
--          NumPanes = 1
--          Configuration = "(V (4))"
--       End
--       Begin PaneConfiguration = 14
--          NumPanes = 1
--          Configuration = "(V (2))"
--       End
--       ActivePaneConfig = 0
--    End
--    Begin DiagramPane =
--       Begin Origin =
--          Top = -480
--          Left = 0
--       End
--       Begin Tables =
--          Begin Table = "USERS"
--             Begin Extent =
--                Top = 6
--                Left = 38
--                Bottom = 121
--                Right = 232
--             End
--             DisplayFlags = 280
--             TopColumn = 0
--          End
--          Begin Table = "ITEMS_V"
--             Begin Extent =
--                Top = 126
--                Left = 38
--                Bottom = 241
--                Right = 248
--             End
--             DisplayFlags = 280
--             TopColumn = 0
--          End
--          Begin Table = "pay"
--             Begin Extent =
--                Top = 246
--                Left = 38
--                Bottom = 361
--                Right = 277
--             End
--             DisplayFlags = 280
--             TopColumn = 0
--          End
--          Begin Table = "jobs_v"
--             Begin Extent =
--                Top = 6
--                Left = 270
--                Bottom = 121
--                Right = 471
--             End
--             DisplayFlags = 280
--             TopColumn = 18
--          End
--          Begin Table = "RESOURCES_V"
--             Begin Extent =
--                Top = 366
--                Left = 38
--                Bottom = 481
--                Right = 245
--             End
--             DisplayFlags = 280
--             TopColumn = 0
--          End
--          Begin Table = "sl"
--             Begin Extent =
--                Top = 486
--                Left = 38
--                Bottom = 699
--                Right = 395
--             End
--             DisplayFlags = 280
--             TopColumn = 74
--          End
--          Begin Table = "GP_MPLS_PAY_CODE_V"
--             Begin Extent =
--                Top = 126
--                Left = 286
--                Bottom = 241
--                Right = 438
--             End
--             DisplayFlags ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'PAYROLL_VERIFICATION_V'
-- GO
-- EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'= 280
--             TopColumn = 0
--          End
--       End
--    End
--    Begin SQLPane =
--    End
--    Begin DataPane =
--       Begin ParameterDefaults = ""
--       End
--    End
--    Begin CriteriaPane =
--       Begin ColumnWidths = 11
--          Column = 1440
--          Alias = 900
--          Table = 1170
--          Output = 720
--          Append = 1400
--          NewValue = 1170
--          SortType = 1350
--          SortOrder = 1410
--          GroupBy = 1350
--          Filter = 1350
--          Or = 1350
--          Or = 1350
--          Or = 1350
--       End
--    End
-- End
-- ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'PAYROLL_VERIFICATION_V'
-- GO
-- EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'PAYROLL_VERIFICATION_V'
-- GO
/****** Object:  View [dbo].[PUNCHLIST_ISSUES_V]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[PUNCHLIST_ISSUES_V]
AS
SELECT     dbo.PUNCHLIST_ISSUES.PUNCHLIST_ID, dbo.PUNCHLISTS_V.punchlist_no, dbo.PUNCHLISTS_V.PROJECT_ID, 
                      dbo.PUNCHLISTS_V.WALKTHROUGH_DATE, dbo.PUNCHLISTS_V.PRINT_LOCATION, dbo.PUNCHLIST_ISSUES.PUNCHLIST_ISSUE_ID, 
                      dbo.PUNCHLIST_ISSUES.STATUS_ID, dbo.PUNCHLIST_ISSUES.ISSUE_NO, dbo.PUNCHLIST_ISSUES.STATION_AREA, 
                      dbo.PUNCHLIST_ISSUES.ROOT_CAUSE_ID, dbo.PUNCHLIST_ISSUES.PROBLEM_DESC, dbo.PUNCHLIST_ISSUES.COMPLETE_DATE, 
                      dbo.PUNCHLIST_ISSUES.SOLUTION_DESC, dbo.PUNCHLIST_ISSUES.SOLUTION_DATE, dbo.PUNCHLIST_ISSUES.INSTALL_DESC, 
                      dbo.PUNCHLIST_ISSUES.INSTALL_DATE, dbo.PUNCHLIST_ISSUES.ORDER_NO, dbo.PUNCHLIST_ISSUES.SHIP_DATE, 
                      dbo.PUNCHLIST_ISSUES.DATE_CREATED AS issue_date_created, dbo.PUNCHLIST_ISSUES.CREATED_BY AS issue_created_by, 
                      dbo.PUNCHLIST_ISSUES.DATE_MODIFIED AS issue_date_modifiied, dbo.PUNCHLIST_ISSUES.MODIFIED_BY AS issue_modified_by, 
                      Cause.NAME AS root_cause_name, Cause.CODE AS root_cause_code, Status.NAME AS status_name, Status.CODE AS status_code, 
                      dbo.USERS.FIRST_NAME + ' ' + dbo.USERS.LAST_NAME AS completed_by_name, dbo.PUNCHLIST_ISSUES.SOLUTION_BY, CONVERT(varchar, 
                      dbo.PUNCHLIST_ISSUES.DATE_CREATED, 101) AS issue_date_created_nice, CONVERT(varchar, dbo.PUNCHLIST_ISSUES.SOLUTION_DATE, 101) 
                      AS solution_date_nice, CONVERT(varchar, dbo.PUNCHLIST_ISSUES.INSTALL_DATE, 101) AS install_date_nice
FROM         dbo.PUNCHLIST_ISSUES INNER JOIN
                      dbo.PUNCHLISTS_V ON dbo.PUNCHLIST_ISSUES.PUNCHLIST_ID = dbo.PUNCHLISTS_V.PUNCHLIST_ID INNER JOIN
                      dbo.LOOKUPS Status ON dbo.PUNCHLIST_ISSUES.STATUS_ID = Status.LOOKUP_ID LEFT OUTER JOIN
                      dbo.USERS ON dbo.PUNCHLIST_ISSUES.CREATED_BY = dbo.USERS.USER_ID AND 
                      dbo.PUNCHLIST_ISSUES.MODIFIED_BY = dbo.USERS.USER_ID LEFT OUTER JOIN
                      dbo.LOOKUPS Cause ON dbo.PUNCHLIST_ISSUES.ROOT_CAUSE_ID = Cause.LOOKUP_ID
GO
/****** Object:  View [dbo].[invoice_volume_v]    Script Date: 05/03/2010 14:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[invoice_volume_v]
AS
SELECT     dbo.INVOICES.ORGANIZATION_ID, dbo.INVOICES.INVOICE_ID, dbo.INVOICE_LINES.INVOICE_LINE_NO, dbo.ITEMS.NAME, 
                      dbo.INVOICE_LINES.ITEM_ID, dbo.INVOICE_LINES.DESCRIPTION AS line_desc, dbo.INVOICE_LINES.UNIT_PRICE, dbo.INVOICE_LINES.QTY, 
                      dbo.INVOICE_LINES.EXTENDED_PRICE, dbo.INVOICES.JOB_ID, dbo.INVOICES.STATUS_ID, dbo.INVOICES.DESCRIPTION AS header_desc, 
                      dbo.INVOICES.EXT_BILL_CUST_ID, dbo.INVOICES.DATE_SENT, dbo.INVOICE_LINES.INVOICE_LINE_ID, dbo.INVOICE_TYPES_V.LOOKUP_ID, 
                      dbo.INVOICE_LINE_TYPES_V.invoice_type_code AS invoice_line_type_code, dbo.INVOICE_TYPES_V.invoice_type_code, 
                      dbo.INVOICE_TYPES_V.NAME AS invoice_type_name, dbo.INVOICE_LINE_TYPES_V.NAME AS invoice_line_type_name, 
                      RTRIM(ISNULL(dbo.ITEMS.EXT_ITEM_ID, 'NA')) AS ext_item_id, dbo.ITEMS.ITEM_TYPE_ID, dbo.ITEM_TYPES_V.lookup_code AS item_type_code, 
                      dbo.ITEM_TYPES_V.lookup_name AS item_type_name, dbo.INVOICE_LINES.PO_NO AS line_po_no, dbo.INVOICE_LINES.TAXABLE_FLAG, 
                      dbo.CUSTOMERS.CUSTOMER_NAME
FROM         dbo.INVOICE_LINE_TYPES_V RIGHT OUTER JOIN
                      dbo.INVOICE_LINES ON dbo.INVOICE_LINE_TYPES_V.LOOKUP_ID = dbo.INVOICE_LINES.INVOICE_LINE_TYPE_ID LEFT OUTER JOIN
                      dbo.INVOICE_TYPES_V RIGHT OUTER JOIN
                      dbo.INVOICES INNER JOIN
                      dbo.CUSTOMERS ON dbo.INVOICES.BILL_CUSTOMER_ID = dbo.CUSTOMERS.CUSTOMER_ID ON 
                      dbo.INVOICE_TYPES_V.LOOKUP_ID = dbo.INVOICES.INVOICE_TYPE_ID ON 
                      dbo.INVOICE_LINES.INVOICE_ID = dbo.INVOICES.INVOICE_ID LEFT OUTER JOIN
                      dbo.ITEM_TYPES_V RIGHT OUTER JOIN
                      dbo.ITEMS ON dbo.ITEM_TYPES_V.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID ON dbo.INVOICE_LINES.ITEM_ID = dbo.ITEMS.ITEM_ID
GO
/****** Object:  View [dbo].[PROJECT_INVOICES_V]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[PROJECT_INVOICES_V]
AS
SELECT     dbo.PROJECTS_V.ORGANIZATION_ID, dbo.PROJECTS_V.PROJECT_ID, dbo.PROJECTS_V.PROJECT_NO, dbo.PROJECTS_V.project_type_code, 
                      dbo.PROJECTS_V.project_status_type_code, dbo.PROJECTS_V.CUSTOMER_ID, dbo.PROJECTS_V.PARENT_CUSTOMER_ID, 
                      dbo.PROJECTS_V.EXT_DEALER_ID, dbo.ORGANIZATIONS.EXT_DIRECT_DEALER_ID, dbo.ORGANIZATIONS.EXT_DCI_DEALER_ID, 
                      dbo.PROJECTS_V.DEALER_NAME, dbo.PROJECTS_V.CUSTOMER_NAME, dbo.INVOICE_TOTALS_V.INVOICE_ID, 
                      dbo.INVOICE_TOTALS_V.extended_price AS invoice_total, dbo.INVOICE_TOTALS_V.custom_total, dbo.INVOICES.PO_NO, dbo.INVOICES.DATE_SENT, 
                      dbo.INVOICE_STATUSES.CODE AS invoice_status_code
FROM         dbo.INVOICE_TOTALS_V INNER JOIN
                      dbo.PROJECTS_V INNER JOIN
                      dbo.JOBS ON dbo.PROJECTS_V.PROJECT_ID = dbo.JOBS.PROJECT_ID ON dbo.INVOICE_TOTALS_V.JOB_ID = dbo.JOBS.JOB_ID INNER JOIN
                      dbo.INVOICES ON dbo.INVOICE_TOTALS_V.INVOICE_ID = dbo.INVOICES.INVOICE_ID INNER JOIN
                      dbo.INVOICE_STATUSES ON dbo.INVOICES.STATUS_ID = dbo.INVOICE_STATUSES.STATUS_ID INNER JOIN
                      dbo.ORGANIZATIONS ON dbo.PROJECTS_V.ORGANIZATION_ID = dbo.ORGANIZATIONS.ORGANIZATION_ID
GO
/****** Object:  View [dbo].[crystal_POSTED_V]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[crystal_POSTED_V]
AS
SELECT     sl.ORGANIZATION_ID, sl.SERVICE_LINE_ID, CAST(sl.BILL_JOB_ID AS VARCHAR) + '-' + CAST(sl.ITEM_ID AS VARCHAR) 
                      + '-' + CAST(sl.STATUS_ID AS VARCHAR) AS job_item_status_id, CAST(sl.BILL_SERVICE_ID AS VARCHAR) + '-' + CAST(sl.ITEM_ID AS VARCHAR) 
                      + '-' + CAST(sl.STATUS_ID AS VARCHAR) AS service_item_status_id, CAST(sl.BILL_SERVICE_ID AS VARCHAR) + '-' + CAST(sl.STATUS_ID AS VARCHAR) 
                      AS bill_service_status_id, sl.BILL_JOB_NO, sl.BILL_SERVICE_NO, sl.BILL_SERVICE_LINE_NO, j_v.job_status_type_name, sl.SERVICE_LINE_DATE, 
                      sl.SERVICE_LINE_DATE_VARCHAR, sl.SERVICE_LINE_WEEK, sl.SERVICE_LINE_WEEK_VARCHAR, sl.STATUS_ID, sls.NAME AS status_name, 
                      sl.EXPORTED_FLAG, sl.BILLED_FLAG, sl.POSTED_FLAG, sl.POOLED_FLAG, sl.INTERNAL_REQ_FLAG, sl.BILL_JOB_ID, sl.BILL_SERVICE_ID, 
                      sl.PH_SERVICE_ID, sl.RESOURCE_ID, sl.RESOURCE_NAME, sl.ITEM_ID, sl.ITEM_NAME, sl.ITEM_TYPE_CODE, sl.INVOICE_ID, 
                      i.DESCRIPTION AS invoice_description, sl.POSTED_FROM_INVOICE_ID, ist.STATUS_ID AS invoice_status_id, ist.NAME AS invoice_status_name, 
                      sl.BILLABLE_FLAG, s.TAXABLE_FLAG AS service_taxable_flag, sl.TAXABLE_FLAG, sl.EXT_PAY_CODE, sl.TC_QTY, sl.PAYROLL_QTY, sl.BILL_QTY, 
                      sl.BILL_RATE, sl.bill_total, sl.BILL_EXP_QTY, sl.BILL_EXP_RATE, sl.bill_exp_total, sl.BILL_HOURLY_QTY, sl.BILL_HOURLY_RATE, 
                      sl.bill_hourly_total, s.QUOTE_TOTAL, s.QUOTE_ID, j_v.job_name, j_v.billing_user_name, j_v.dealer_name, j_v.ext_dealer_id, j_v.customer_name, 
                      j_v.ext_customer_id, j_v.billing_user_id, j_v.foreman_resource_name AS supervisor_name, j_v.foreman_user_id AS sup_user_id, 
                      s.BILLING_TYPE_ID, billing_types.CODE AS billing_type_code, billing_types.NAME AS billing_type_name, s.PO_NO, s.CUST_COL_1, s.CUST_COL_2, 
                      s.CUST_COL_3, s.CUST_COL_4, s.CUST_COL_5, s.CUST_COL_6, s.CUST_COL_7, s.CUST_COL_8, s.CUST_COL_9, s.CUST_COL_10, 
                      s.EST_START_DATE, s.EST_END_DATE, sl.PALM_REP_ID, s.DESCRIPTION AS service_description, CAST(j_v.job_no AS VARCHAR) 
                      + ' - ' + ISNULL(j_v.job_name, '') AS job_no_name2, CAST(s.SERVICE_NO AS VARCHAR) + ' - ' + ISNULL(s.DESCRIPTION, '') 
                      AS service_no_description2, sl.ENTERED_DATE, sl.ENTERED_BY, sl.ENTRY_METHOD, sl.OVERRIDE_DATE, sl.OVERRIDE_BY, 
                      sl.OVERRIDE_REASON, sl.VERIFIED_DATE, sl.VERIFIED_BY, sl.DATE_CREATED, sl.CREATED_BY, sl.DATE_MODIFIED, sl.MODIFIED_BY, 
                      ISNULL(sl.INVOICE_POST_DATE, i.DATE_SENT) AS invoiced_date, sl.INVOICE_POST_DATE, ISNULL(q.quote_total, 0) AS quoted_total, 
                      ISNULL(p.IS_NEW, 'N') AS is_new
FROM         dbo.SERVICE_LINES AS sl LEFT OUTER JOIN
                      dbo.SERVICES AS s ON sl.BILL_SERVICE_ID = s.SERVICE_ID LEFT OUTER JOIN
                      dbo.jobs_v AS j_v ON sl.BILL_JOB_ID = j_v.job_id LEFT OUTER JOIN
                      dbo.INVOICES AS i ON sl.INVOICE_ID = i.INVOICE_ID LEFT OUTER JOIN
                      dbo.INVOICE_STATUSES AS ist ON i.STATUS_ID = ist.STATUS_ID LEFT OUTER JOIN
                      dbo.LOOKUPS AS billing_types ON s.BILLING_TYPE_ID = billing_types.LOOKUP_ID LEFT OUTER JOIN
                      dbo.SERVICE_LINE_STATUSES AS sls ON sl.STATUS_ID = sls.STATUS_ID LEFT OUTER JOIN
                      dbo.QUOTES AS q ON s.QUOTE_ID = q.quote_id LEFT OUTER JOIN
                      dbo.PROJECTS AS p ON j_v.project_id = p.PROJECT_ID
WHERE     (sl.STATUS_ID > 3) AND (sl.INTERNAL_REQ_FLAG = 'N') AND (sl.SERVICE_LINE_DATE > CONVERT(DATETIME, '2008-10-01 00:00:00', 102)) AND 
                      (sl.POSTED_FLAG = 'y')
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[13] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "sl"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 241
               Right = 292
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "s"
            Begin Extent = 
               Top = 6
               Left = 330
               Bottom = 114
               Right = 554
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "j_v"
            Begin Extent = 
               Top = 6
               Left = 592
               Bottom = 114
               Right = 792
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "i"
            Begin Extent = 
               Top = 114
               Left = 330
               Bottom = 222
               Right = 547
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ist"
            Begin Extent = 
               Top = 114
               Left = 585
               Bottom = 207
               Right = 736
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "billing_types"
            Begin Extent = 
               Top = 210
               Left = 585
               Bottom = 318
               Right = 767
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "sls"
            Begin Extent = 
               Top = 222
               Left = 330
               Bottom = 315
               Right = 481
            End
            DisplayFlags = 280
            TopColumn ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'crystal_POSTED_V'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'= 0
         End
         Begin Table = "q"
            Begin Extent = 
               Top = 246
               Left = 38
               Bottom = 354
               Right = 319
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "p"
            Begin Extent = 
               Top = 318
               Left = 357
               Bottom = 426
               Right = 573
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 96
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1845
         Width = 1965
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 2400
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 2655
         Alias = 900
         Table = 1770
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'crystal_POSTED_V'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'crystal_POSTED_V'
GO
/****** Object:  View [dbo].[invoice_post_total_v]    Script Date: 05/03/2010 14:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[invoice_post_total_v]
AS
SELECT i.invoice_id, 
       CAST(i.invoice_id AS varchar) + cit_v.contains_tracking AS invoice_id_trk, 
       i.description invoice_description, 
       i.status_id invoice_status_id, 
       i.ext_batch_id, 
       i.job_id, 
       i.date_created invoice_date_created, 
       i.batch_status_id,
       i.batch_error_message,
       i.po_no, 
       CONVERT(VARCHAR(12), i.date_sent, 101) date_sent, 
       j.job_no, 
       j.billing_user_id, 
       c.organization_id,
       c.ext_dealer_id, 
       c.dealer_name,
       c.customer_name,
       eu.customer_name end_user_name,
       invoice_type.name AS invoice_type_name, 
       invoice_type.code AS invoice_type_code, 
       assigned_to.first_name + ' ' + assigned_to.last_name AS assigned_to_name, 
       billing_type.name AS billing_type_name,   
       invoice_format_type.name AS invoice_format_type_name,    
       CASE i.batch_status_id WHEN - 1 THEN 'false' ELSE 'true' END AS readonly, 
       job_type.name job_type_name, 
       job_type.code job_type_code,             
       CASE invoice_line_type.code WHEN 'custom' THEN il.unit_price * il.qty ELSE 0 END AS custom_line_total, 
       CASE invoice_line_type.code WHEN 'system' THEN CASE item_type.code WHEN 'hours' THEN il.unit_price * il.qty ELSE 0 END END AS bill_hourly_total,
       CASE invoice_line_type.code WHEN 'system' THEN CASE item_type.code WHEN 'expense' THEN il.unit_price * il.qty ELSE 0 END END AS bill_exp_total, 
       CASE invoice_line_type.code WHEN 'system' THEN il.unit_price * il.qty ELSE 0 END AS bill_total, 
       ibs.code batch_status_code,
       ibs.name batch_status_name,
       NULL AS bill_service_id
  FROM dbo.invoices i INNER JOIN
       dbo.lookups invoice_type ON i.invoice_type_id = invoice_type.lookup_id INNER JOIN
       dbo.jobs j ON i.job_id = j.job_id INNER JOIN
       dbo.lookups job_type ON j.job_type_id = job_type.lookup_id INNER JOIN 
       dbo.customers c ON j.customer_id = c.customer_id INNER JOIN
       dbo.lookups customer_type ON c.customer_type_id = customer_type.lookup_id LEFT OUTER JOIN
       dbo.customers eu ON j.end_user_id = eu.customer_id LEFT OUTER JOIN     
       dbo.invoice_batch_statuses ibs ON i.batch_status_id = ibs.status_id LEFT OUTER JOIN
       dbo.users assigned_to ON i.assigned_to_user_id = assigned_to.user_id LEFT OUTER JOIN
       dbo.contains_invoice_tracking_v cit_v ON i.invoice_id = cit_v.invoice_id LEFT OUTER JOIN
       dbo.lookups invoice_format_type ON i.invoice_format_type_id = invoice_format_type.lookup_id LEFT OUTER JOIN
       dbo.lookups billing_type ON i.billing_type_id = billing_type.lookup_id LEFT OUTER JOIN
       dbo.invoice_lines il ON i.invoice_id = il.invoice_id LEFT OUTER JOIN
       dbo.lookups invoice_line_type ON il.invoice_line_type_id = invoice_line_type.lookup_id LEFT OUTER JOIN
       dbo.items item ON il.item_id = item.item_id LEFT OUTER JOIN
       dbo.lookups item_type ON item.item_type_id = item_type.lookup_id
GO
/****** Object:  View [dbo].[BILLING_CUSTOM_COLS_TARGET_V]    Script Date: 05/03/2010 14:18:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[BILLING_CUSTOM_COLS_TARGET_V]
AS
SELECT     dbo.SERVICE_LINES.ORGANIZATION_ID, dbo.SERVICE_LINES.SERVICE_LINE_ID, dbo.SERVICE_LINES.BILL_JOB_NO, 
                      dbo.SERVICE_LINES.BILL_SERVICE_NO, dbo.SERVICE_LINES.BILL_SERVICE_LINE_NO, dbo.jobs_v.job_status_type_name, 
                      dbo.SERVICE_LINES.SERVICE_LINE_DATE, dbo.SERVICE_LINES.INTERNAL_REQ_FLAG, dbo.SERVICE_LINES.RESOURCE_ID, 
                      dbo.SERVICE_LINES.RESOURCE_NAME, dbo.SERVICE_LINES.ITEM_ID, dbo.SERVICE_LINES.ITEM_NAME, dbo.SERVICE_LINES.ITEM_TYPE_CODE, 
                      dbo.SERVICE_LINES.BILL_QTY, dbo.SERVICE_LINES.BILL_RATE, dbo.SERVICE_LINES.bill_total, dbo.SERVICES.CUST_COL_1, 
                      dbo.SERVICES.CUST_COL_2, dbo.SERVICES.CUST_COL_3, dbo.SERVICES.CUST_COL_4, dbo.SERVICES.CUST_COL_5, dbo.SERVICES.CUST_COL_6, 
                      dbo.SERVICES.CUST_COL_7, dbo.SERVICES.CUST_COL_8, dbo.SERVICES.CUST_COL_9, dbo.SERVICES.CUST_COL_10, 
                      dbo.JOB_LOCATIONS.JOB_LOCATION_NAME, dbo.JOB_LOCATIONS.STREET1, dbo.JOB_LOCATIONS.STREET2, dbo.JOB_LOCATIONS.STREET3, 
                      dbo.JOB_LOCATIONS.CITY, dbo.JOB_LOCATIONS.STATE, dbo.JOB_LOCATIONS.ZIP, dbo.JOB_LOCATIONS.COUNTRY
FROM         dbo.SERVICES INNER JOIN
                      dbo.JOB_LOCATIONS ON dbo.SERVICES.JOB_LOCATION_ID = dbo.JOB_LOCATIONS.JOB_LOCATION_ID AND 
                      dbo.SERVICES.JOB_LOCATION_ID = dbo.JOB_LOCATIONS.JOB_LOCATION_ID LEFT OUTER JOIN
                      dbo.LOOKUPS AS BILLING_TYPES ON dbo.SERVICES.BILLING_TYPE_ID = BILLING_TYPES.LOOKUP_ID LEFT OUTER JOIN
                      dbo.SERVICE_CUSTOM_COLS_V ON dbo.SERVICES.SERVICE_ID = dbo.SERVICE_CUSTOM_COLS_V.SERVICE_ID RIGHT OUTER JOIN
                      dbo.SERVICE_LINE_STATUSES RIGHT OUTER JOIN
                      dbo.INVOICE_STATUSES RIGHT OUTER JOIN
                      dbo.INVOICES ON dbo.INVOICE_STATUSES.STATUS_ID = dbo.INVOICES.STATUS_ID RIGHT OUTER JOIN
                      dbo.SERVICE_LINES LEFT OUTER JOIN
                      dbo.jobs_v ON dbo.SERVICE_LINES.BILL_JOB_ID = dbo.jobs_v.job_id ON dbo.INVOICES.INVOICE_ID = dbo.SERVICE_LINES.INVOICE_ID ON 
                      dbo.SERVICE_LINE_STATUSES.STATUS_ID = dbo.SERVICE_LINES.STATUS_ID ON 
                      dbo.SERVICES.SERVICE_ID = dbo.SERVICE_LINES.BILL_SERVICE_ID
WHERE     (dbo.SERVICE_LINES.INTERNAL_REQ_FLAG = 'N')
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "SERVICES"
            Begin Extent = 
               Top = 8
               Left = 45
               Bottom = 116
               Right = 269
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SERVICE_CUSTOM_COLS_V"
            Begin Extent = 
               Top = 6
               Left = 300
               Bottom = 114
               Right = 451
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "BILLING_TYPES"
            Begin Extent = 
               Top = 114
               Left = 38
               Bottom = 222
               Right = 220
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SERVICE_LINE_STATUSES"
            Begin Extent = 
               Top = 114
               Left = 258
               Bottom = 207
               Right = 488
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "INVOICE_STATUSES"
            Begin Extent = 
               Top = 210
               Left = 258
               Bottom = 303
               Right = 409
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "INVOICES"
            Begin Extent = 
               Top = 222
               Left = 38
               Bottom = 330
               Right = 255
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SERVICE_LINES"
            Begin Extent = 
               Top = 330
               Left = 38
               Bottom = 438
               Right = 276' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'BILLING_CUSTOM_COLS_TARGET_V'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "jobs_v"
            Begin Extent = 
               Top = 438
               Left = 38
               Bottom = 546
               Right = 308
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "JOB_LOCATIONS"
            Begin Extent = 
               Top = 17
               Left = 519
               Bottom = 191
               Right = 768
            End
            DisplayFlags = 280
            TopColumn = 12
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 112
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 2565
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 615
         SortOrder = 540
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'BILLING_CUSTOM_COLS_TARGET_V'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'BILLING_CUSTOM_COLS_TARGET_V'
GO
/****** Object:  View [dbo].[BILLING_CUSTOM_COLS_V]    Script Date: 05/03/2010 14:18:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[BILLING_CUSTOM_COLS_V]
AS
SELECT     dbo.SERVICE_LINES.ORGANIZATION_ID, dbo.SERVICE_LINES.SERVICE_LINE_ID, CAST(dbo.SERVICE_LINES.BILL_JOB_ID AS varchar) 
                      + '-' + CAST(dbo.SERVICE_LINES.ITEM_ID AS varchar) + '-' + CAST(dbo.SERVICE_LINES.STATUS_ID AS varchar) AS job_item_status_id, 
                      CAST(dbo.SERVICE_LINES.BILL_SERVICE_ID AS varchar) + '-' + CAST(dbo.SERVICE_LINES.ITEM_ID AS varchar) 
                      + '-' + CAST(dbo.SERVICE_LINES.STATUS_ID AS varchar) AS service_item_status_id, CAST(dbo.SERVICE_LINES.BILL_SERVICE_ID AS varchar) 
                      + '-' + CAST(dbo.SERVICE_LINES.STATUS_ID AS varchar) AS bill_service_status_id, dbo.SERVICE_LINES.BILL_JOB_NO, 
                      dbo.SERVICE_LINES.BILL_SERVICE_NO, dbo.SERVICE_LINES.BILL_SERVICE_LINE_NO, dbo.JOBS_V.job_status_type_name, 
                      dbo.SERVICE_LINES.SERVICE_LINE_DATE, dbo.SERVICE_LINES.SERVICE_LINE_DATE_VARCHAR, dbo.SERVICE_LINES.SERVICE_LINE_WEEK, 
                      dbo.SERVICE_LINES.SERVICE_LINE_WEEK_VARCHAR, dbo.SERVICE_LINES.STATUS_ID, dbo.SERVICE_LINE_STATUSES.NAME AS status_name, 
                      dbo.SERVICE_LINES.EXPORTED_FLAG, dbo.SERVICE_LINES.BILLED_FLAG, dbo.SERVICE_LINES.POSTED_FLAG, 
                      dbo.SERVICE_LINES.POOLED_FLAG, dbo.SERVICE_LINES.INTERNAL_REQ_FLAG, dbo.SERVICE_LINES.BILL_JOB_ID, 
                      dbo.SERVICE_LINES.BILL_SERVICE_ID, dbo.SERVICE_LINES.PH_SERVICE_ID, dbo.SERVICE_LINES.RESOURCE_ID, 
                      dbo.SERVICE_LINES.RESOURCE_NAME, dbo.SERVICE_LINES.ITEM_ID, dbo.SERVICE_LINES.ITEM_NAME, dbo.SERVICE_LINES.ITEM_TYPE_CODE, 
                      dbo.SERVICE_LINES.INVOICE_ID, dbo.INVOICES.DESCRIPTION AS invoice_description, dbo.SERVICE_LINES.POSTED_FROM_INVOICE_ID, 
                      dbo.INVOICE_STATUSES.STATUS_ID AS invoice_status_id, dbo.INVOICE_STATUSES.NAME AS invoice_status_name, 
                      dbo.SERVICE_LINES.BILLABLE_FLAG, dbo.SERVICES.TAXABLE_FLAG AS service_taxable_flag, dbo.SERVICE_LINES.TAXABLE_FLAG, 
                      dbo.SERVICE_LINES.EXT_PAY_CODE, dbo.SERVICE_LINES.TC_QTY, dbo.SERVICE_LINES.PAYROLL_QTY, dbo.SERVICE_LINES.BILL_QTY, 
                      dbo.SERVICE_LINES.BILL_RATE, dbo.SERVICE_LINES.BILL_TOTAL, dbo.SERVICE_LINES.BILL_EXP_QTY, dbo.SERVICE_LINES.BILL_EXP_RATE, 
                      dbo.SERVICE_LINES.BILL_EXP_TOTAL, dbo.SERVICE_LINES.BILL_HOURLY_QTY, dbo.SERVICE_LINES.BILL_HOURLY_RATE, 
                      dbo.SERVICE_LINES.BILL_HOURLY_TOTAL, dbo.SERVICES.QUOTE_TOTAL, dbo.SERVICES.QUOTE_ID, dbo.JOBS_V.JOB_NAME, 
                      dbo.JOBS_V.billing_user_name, dbo.JOBS_V.DEALER_NAME, dbo.JOBS_V.EXT_DEALER_ID, dbo.JOBS_V.CUSTOMER_NAME, 
                      dbo.JOBS_V.EXT_CUSTOMER_ID, dbo.JOBS_V.BILLING_USER_ID, dbo.JOBS_V.foreman_resource_name AS supervisor_name, 
                      dbo.JOBS_V.foreman_user_id AS sup_user_id, dbo.SERVICES.BILLING_TYPE_ID, BILLING_TYPES.CODE AS billing_type_code, 
                      BILLING_TYPES.NAME AS billing_type_name, dbo.SERVICES.PO_NO, dbo.SERVICES.CUST_COL_1, dbo.SERVICES.CUST_COL_2, 
                      dbo.SERVICES.CUST_COL_3, dbo.SERVICES.CUST_COL_4, dbo.SERVICES.CUST_COL_5, dbo.SERVICES.CUST_COL_6, dbo.SERVICES.CUST_COL_7, 
                      dbo.SERVICES.CUST_COL_8, dbo.SERVICES.CUST_COL_9, dbo.SERVICES.CUST_COL_10, dbo.SERVICES.EST_START_DATE, 
                      dbo.SERVICES.EST_END_DATE, dbo.SERVICE_LINES.PALM_REP_ID, dbo.SERVICES.DESCRIPTION AS SERVICE_DESCRIPTION, 
                      CAST(dbo.JOBS_V.JOB_NO AS varchar) + ' - ' + ISNULL(dbo.JOBS_V.JOB_NAME, '') AS job_no_name2, CAST(dbo.SERVICES.SERVICE_NO AS varchar) 
                      + ' - ' + ISNULL(dbo.SERVICES.DESCRIPTION, '') AS service_no_description2, dbo.SERVICE_LINES.ENTERED_DATE, 
                      dbo.SERVICE_LINES.ENTERED_BY, dbo.SERVICE_LINES.ENTRY_METHOD, dbo.SERVICE_LINES.OVERRIDE_DATE, 
                      dbo.SERVICE_LINES.OVERRIDE_BY, dbo.SERVICE_LINES.OVERRIDE_REASON, dbo.SERVICE_LINES.VERIFIED_DATE, 
                      dbo.SERVICE_LINES.VERIFIED_BY, dbo.SERVICE_LINES.DATE_CREATED, dbo.SERVICE_LINES.CREATED_BY, dbo.SERVICE_LINES.DATE_MODIFIED, 
                      dbo.SERVICE_LINES.MODIFIED_BY, dbo.SERVICE_CUSTOM_COLS_V.col1_value, dbo.SERVICE_CUSTOM_COLS_V.col1_lookup, 
                      dbo.SERVICE_CUSTOM_COLS_V.col2_value, dbo.SERVICE_CUSTOM_COLS_V.col2_lookup, dbo.SERVICE_CUSTOM_COLS_V.col3_value, 
                      dbo.SERVICE_CUSTOM_COLS_V.col3_lookup, dbo.SERVICE_CUSTOM_COLS_V.col4_value, dbo.SERVICE_CUSTOM_COLS_V.col4_lookup, 
                      dbo.SERVICE_CUSTOM_COLS_V.col5_value, dbo.SERVICE_CUSTOM_COLS_V.col5_lookup, dbo.SERVICE_CUSTOM_COLS_V.col6_value, 
                      dbo.SERVICE_CUSTOM_COLS_V.col6_lookup, dbo.SERVICE_CUSTOM_COLS_V.col7_value, dbo.SERVICE_CUSTOM_COLS_V.col7_lookup, 
                      dbo.SERVICE_CUSTOM_COLS_V.col8_value, dbo.SERVICE_CUSTOM_COLS_V.col8_lookup, dbo.SERVICE_CUSTOM_COLS_V.col9_value, 
                      dbo.SERVICE_CUSTOM_COLS_V.col9_lookup, dbo.SERVICE_CUSTOM_COLS_V.col10_value, dbo.SERVICE_CUSTOM_COLS_V.col10_lookup
FROM         dbo.SERVICES LEFT OUTER JOIN
                      dbo.SERVICE_CUSTOM_COLS_V ON dbo.SERVICES.SERVICE_ID = dbo.SERVICE_CUSTOM_COLS_V.SERVICE_ID LEFT OUTER JOIN
                      dbo.LOOKUPS BILLING_TYPES ON dbo.SERVICES.BILLING_TYPE_ID = BILLING_TYPES.LOOKUP_ID RIGHT OUTER JOIN
                      dbo.SERVICE_LINE_STATUSES RIGHT OUTER JOIN
                      dbo.INVOICE_STATUSES RIGHT OUTER JOIN
                      dbo.INVOICES ON dbo.INVOICE_STATUSES.STATUS_ID = dbo.INVOICES.STATUS_ID RIGHT OUTER JOIN
                      dbo.SERVICE_LINES LEFT OUTER JOIN
                      dbo.JOBS_V ON dbo.SERVICE_LINES.BILL_JOB_ID = dbo.JOBS_V.JOB_ID ON dbo.INVOICES.INVOICE_ID = dbo.SERVICE_LINES.INVOICE_ID ON 
                      dbo.SERVICE_LINE_STATUSES.STATUS_ID = dbo.SERVICE_LINES.STATUS_ID ON 
                      dbo.SERVICES.SERVICE_ID = dbo.SERVICE_LINES.BILL_SERVICE_ID
WHERE     (dbo.SERVICE_LINES.STATUS_ID > 3) AND (dbo.SERVICE_LINES.INTERNAL_REQ_FLAG = 'N')
GO
/****** Object:  View [dbo].[invoice_date_range]    Script Date: 05/03/2010 14:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[invoice_date_range]
AS
SELECT     dbo.INVOICES.ORGANIZATION_ID, dbo.INVOICES.INVOICE_ID, dbo.INVOICE_LINES.INVOICE_LINE_NO, dbo.ITEMS.NAME, 
                      dbo.INVOICE_LINES.ITEM_ID, dbo.INVOICE_LINES.DESCRIPTION AS line_desc, dbo.INVOICE_LINES.UNIT_PRICE, dbo.INVOICE_LINES.QTY, 
                      dbo.INVOICE_LINES.EXTENDED_PRICE, dbo.INVOICES.JOB_ID, dbo.INVOICES.STATUS_ID, dbo.INVOICES.DESCRIPTION AS header_desc, 
                      dbo.INVOICES.EXT_BILL_CUST_ID, dbo.INVOICES.DATE_SENT, dbo.INVOICE_LINES.INVOICE_LINE_ID, dbo.INVOICE_TYPES_V.LOOKUP_ID, 
                      dbo.INVOICE_LINE_TYPES_V.invoice_type_code AS invoice_line_type_code, dbo.INVOICE_TYPES_V.invoice_type_code, 
                      dbo.INVOICE_TYPES_V.NAME AS invoice_type_name, dbo.INVOICE_LINE_TYPES_V.NAME AS invoice_line_type_name, 
                      RTRIM(ISNULL(dbo.ITEMS.EXT_ITEM_ID, 'NA')) AS ext_item_id, dbo.ITEMS.ITEM_TYPE_ID, dbo.ITEM_TYPES_V.lookup_code AS item_type_code, 
                      dbo.ITEM_TYPES_V.lookup_name AS item_type_name, dbo.INVOICE_LINES.PO_NO AS line_po_no, dbo.INVOICE_LINES.TAXABLE_FLAG
FROM         dbo.ITEM_TYPES_V RIGHT OUTER JOIN
                      dbo.ITEMS ON dbo.ITEM_TYPES_V.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID RIGHT OUTER JOIN
                      dbo.INVOICE_LINE_TYPES_V RIGHT OUTER JOIN
                      dbo.INVOICE_LINES ON dbo.INVOICE_LINE_TYPES_V.LOOKUP_ID = dbo.INVOICE_LINES.INVOICE_LINE_TYPE_ID LEFT OUTER JOIN
                      dbo.INVOICES LEFT OUTER JOIN
                      dbo.INVOICE_TYPES_V ON dbo.INVOICES.INVOICE_TYPE_ID = dbo.INVOICE_TYPES_V.LOOKUP_ID ON 
                      dbo.INVOICE_LINES.INVOICE_ID = dbo.INVOICES.INVOICE_ID ON dbo.ITEMS.ITEM_ID = dbo.INVOICE_LINES.ITEM_ID
WHERE     (dbo.INVOICES.STATUS_ID = 4) AND (dbo.INVOICES.INVOICE_ID = 86434)
GO
/****** Object:  View [dbo].[PEP_POSTED_CUSTOM_LINES_V]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[PEP_POSTED_CUSTOM_LINES_V]
AS
SELECT     TOP 100 PERCENT dbo.JOBS_V.ORGANIZATION_ID, dbo.JOBS_V.JOB_NO, dbo.INVOICES.INVOICE_ID, dbo.JOBS_V.CUSTOMER_NAME, 
                      dbo.JOBS_V.JOB_NAME, dbo.INVOICES.DESCRIPTION AS INVOICE_DESC, dbo.INVOICES.START_DATE, dbo.INVOICES.END_DATE, 
                      SUM(ISNULL(dbo.INVOICE_LINES.UNIT_PRICE, 0) * ISNULL(dbo.INVOICE_LINES.QTY, 0)) AS custom_line_total, 
                      dbo.INVOICE_TOTALS_V.extended_price AS invoice_total, dbo.INVOICE_TOTALS_V.extended_price - ISNULL(dbo.INVOICE_LINES.UNIT_PRICE, 0) 
                      * ISNULL(dbo.INVOICE_LINES.QTY, 0) AS req_total
FROM         dbo.INVOICE_TOTALS_V RIGHT OUTER JOIN
                      dbo.INVOICE_LINES RIGHT OUTER JOIN
                      dbo.INVOICES ON dbo.INVOICE_LINES.INVOICE_ID = dbo.INVOICES.INVOICE_ID LEFT OUTER JOIN
                      dbo.LOOKUPS ON dbo.INVOICE_LINES.INVOICE_LINE_TYPE_ID = dbo.LOOKUPS.LOOKUP_ID ON 
                      dbo.INVOICE_TOTALS_V.INVOICE_ID = dbo.INVOICES.INVOICE_ID RIGHT OUTER JOIN
                      dbo.JOBS_V ON dbo.INVOICES.JOB_ID = dbo.JOBS_V.JOB_ID
WHERE     (dbo.INVOICES.DATE_SENT BETWEEN CONVERT(DATETIME, '2003-04-25 00:00:00', 102) AND CONVERT(DATETIME, '2004-05-04 00:00:00', 102))
GROUP BY dbo.JOBS_V.JOB_NO, dbo.JOBS_V.JOB_NAME, dbo.JOBS_V.CUSTOMER_NAME, dbo.INVOICE_TOTALS_V.extended_price, dbo.JOBS_V.JOB_ID, 
                      dbo.JOBS_V.ORGANIZATION_ID, dbo.INVOICES.STATUS_ID, dbo.INVOICES.DESCRIPTION, dbo.INVOICES.START_DATE, dbo.INVOICES.END_DATE, 
                      dbo.LOOKUPS.CODE, dbo.INVOICES.INVOICE_ID, dbo.INVOICE_TOTALS_V.extended_price - ISNULL(dbo.INVOICE_LINES.UNIT_PRICE, 0) 
                      * ISNULL(dbo.INVOICE_LINES.QTY, 0)
HAVING      (dbo.JOBS_V.CUSTOMER_NAME LIKE 'medtronic%') AND (dbo.INVOICES.STATUS_ID = 4) AND (dbo.LOOKUPS.CODE = 'CUSTOM')
ORDER BY dbo.JOBS_V.JOB_NO, dbo.INVOICES.INVOICE_ID
GO
/****** Object:  View [dbo].[crystal_BILLING_ECMS_V]    Script Date: 05/03/2010 14:18:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[crystal_BILLING_ECMS_V]
AS
SELECT     sl.ORGANIZATION_ID, sl.SERVICE_LINE_ID, CAST(sl.BILL_JOB_ID AS VARCHAR) + '-' + CAST(sl.ITEM_ID AS VARCHAR) 
                      + '-' + CAST(sl.STATUS_ID AS VARCHAR) AS job_item_status_id, CAST(sl.BILL_SERVICE_ID AS VARCHAR) + '-' + CAST(sl.ITEM_ID AS VARCHAR) 
                      + '-' + CAST(sl.STATUS_ID AS VARCHAR) AS service_item_status_id, CAST(sl.BILL_SERVICE_ID AS VARCHAR) + '-' + CAST(sl.STATUS_ID AS VARCHAR) 
                      AS bill_service_status_id, sl.BILL_JOB_NO, sl.BILL_SERVICE_NO, sl.BILL_SERVICE_LINE_NO, j_v.job_status_type_name, sl.SERVICE_LINE_DATE, 
                      sl.SERVICE_LINE_DATE_VARCHAR, sl.SERVICE_LINE_WEEK, sl.SERVICE_LINE_WEEK_VARCHAR, sl.STATUS_ID, sls.NAME AS status_name, 
                      sl.EXPORTED_FLAG, sl.BILLED_FLAG, sl.POSTED_FLAG, sl.POOLED_FLAG, sl.INTERNAL_REQ_FLAG, sl.BILL_JOB_ID, sl.BILL_SERVICE_ID, 
                      sl.PH_SERVICE_ID, sl.RESOURCE_ID, sl.RESOURCE_NAME, sl.ITEM_ID, sl.ITEM_NAME, sl.ITEM_TYPE_CODE, sl.INVOICE_ID, 
                      i.DESCRIPTION AS invoice_description, sl.POSTED_FROM_INVOICE_ID, ist.STATUS_ID AS invoice_status_id, ist.NAME AS invoice_status_name, 
                      sl.BILLABLE_FLAG, s.TAXABLE_FLAG AS service_taxable_flag, sl.TAXABLE_FLAG, sl.EXT_PAY_CODE, sl.TC_QTY, sl.PAYROLL_QTY, sl.BILL_QTY, 
                      sl.BILL_RATE, sl.bill_total, sl.BILL_EXP_QTY, sl.BILL_EXP_RATE, sl.bill_exp_total, sl.BILL_HOURLY_QTY, sl.BILL_HOURLY_RATE, 
                      sl.bill_hourly_total, s.QUOTE_TOTAL, s.QUOTE_ID, j_v.job_name, j_v.billing_user_name, j_v.dealer_name, j_v.ext_dealer_id, j_v.customer_name, 
                      j_v.ext_customer_id, j_v.billing_user_id, j_v.foreman_resource_name AS supervisor_name, j_v.foreman_user_id AS sup_user_id, 
                      s.BILLING_TYPE_ID, billing_types.CODE AS billing_type_code, billing_types.NAME AS billing_type_name, s.PO_NO, s.CUST_COL_1, s.CUST_COL_2, 
                      s.CUST_COL_3, s.CUST_COL_4, s.CUST_COL_5, s.CUST_COL_6, s.CUST_COL_7, s.CUST_COL_8, s.CUST_COL_9, s.CUST_COL_10, 
                      s.EST_START_DATE, s.EST_END_DATE, sl.PALM_REP_ID, s.DESCRIPTION AS service_description, CAST(j_v.job_no AS VARCHAR) 
                      + ' - ' + ISNULL(j_v.job_name, '') AS job_no_name2, CAST(s.SERVICE_NO AS VARCHAR) + ' - ' + ISNULL(s.DESCRIPTION, '') 
                      AS service_no_description2, sl.ENTERED_DATE, sl.ENTERED_BY, sl.ENTRY_METHOD, sl.OVERRIDE_DATE, sl.OVERRIDE_BY, 
                      sl.OVERRIDE_REASON, sl.VERIFIED_DATE, sl.VERIFIED_BY, sl.DATE_CREATED, sl.CREATED_BY, sl.DATE_MODIFIED, sl.MODIFIED_BY, 
                      ISNULL(sl.INVOICE_POST_DATE, i.DATE_SENT) AS invoiced_date, sl.INVOICE_POST_DATE, ISNULL(q.quote_total, 0) AS quoted_total, 
                      ISNULL(p.IS_NEW, 'N') AS is_new, dbo.ITEMS.item_category_type_id
FROM         dbo.QUOTES AS q RIGHT OUTER JOIN
                      dbo.SERVICES AS s ON q.quote_id = s.QUOTE_ID FULL OUTER JOIN
                      dbo.SERVICE_LINES AS sl INNER JOIN
                      dbo.ITEMS ON sl.ITEM_ID = dbo.ITEMS.ITEM_ID LEFT OUTER JOIN
                      dbo.jobs_v AS j_v ON sl.BILL_JOB_ID = j_v.job_id LEFT OUTER JOIN
                      dbo.INVOICES AS i ON sl.INVOICE_ID = i.INVOICE_ID LEFT OUTER JOIN
                      dbo.INVOICE_STATUSES AS ist ON i.STATUS_ID = ist.STATUS_ID LEFT OUTER JOIN
                      dbo.SERVICE_LINE_STATUSES AS sls ON sl.STATUS_ID = sls.STATUS_ID LEFT OUTER JOIN
                      dbo.PROJECTS AS p ON j_v.project_id = p.PROJECT_ID ON s.SERVICE_ID = sl.BILL_SERVICE_ID FULL OUTER JOIN
                      dbo.LOOKUPS AS billing_types ON s.BILLING_TYPE_ID = billing_types.LOOKUP_ID
WHERE     (sl.STATUS_ID > 3) AND (sl.INTERNAL_REQ_FLAG = 'N') AND (sl.ORGANIZATION_ID = 14)
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[14] 4[4] 2[64] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "sl"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 276
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "s"
            Begin Extent = 
               Top = 6
               Left = 314
               Bottom = 114
               Right = 538
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "j_v"
            Begin Extent = 
               Top = 114
               Left = 38
               Bottom = 222
               Right = 238
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "i"
            Begin Extent = 
               Top = 114
               Left = 276
               Bottom = 222
               Right = 493
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ist"
            Begin Extent = 
               Top = 6
               Left = 576
               Bottom = 99
               Right = 727
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "billing_types"
            Begin Extent = 
               Top = 102
               Left = 576
               Bottom = 210
               Right = 758
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "sls"
            Begin Extent = 
               Top = 210
               Left = 531
               Bottom = 303
               Right = 682
            End
            DisplayFlags = 280
            TopColumn = 0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'crystal_BILLING_ECMS_V'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'
         End
         Begin Table = "q"
            Begin Extent = 
               Top = 222
               Left = 38
               Bottom = 330
               Right = 319
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "p"
            Begin Extent = 
               Top = 306
               Left = 357
               Bottom = 414
               Right = 573
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ITEMS"
            Begin Extent = 
               Top = 306
               Left = 611
               Bottom = 414
               Right = 813
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 96
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'crystal_BILLING_ECMS_V'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'crystal_BILLING_ECMS_V'
GO
/****** Object:  View [dbo].[sch_job_list_v]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[sch_job_list_v] 
AS
SELECT CAST(j.job_id AS varchar(30)) + ':' + ISNULL(CAST(s.service_id AS varchar(30)), '') AS job_service_id,
       j.job_id,
       j.job_no,
       j.job_name,
       s.service_id,
       s.service_no, 
       s.request_id,
       c.organization_id,     
       c.ext_dealer_id,
       c.dealer_name,
       j.customer_id,
       c.customer_name,
       j.job_type_id,
       job_type.code job_type_code,
       substring(job_type.name,1,1) job_type_name, 
       j.job_status_type_id,
       job_status_type.code job_status_type_code,
       substring(job_status_type.name,1,8) job_status_type_name,
       s.serv_status_type_id,
       serv_status_type.code serv_status_type_code, 
       serv_status_type.name serv_status_type_name,
       s.schedule_type_id,
       schedule_type.code schedule_type_code,
       schedule_type.name schedule_type_name, 
       s.service_type_id,
       service_type.code service_type_code,
       service_type.name service_type_name,
       s.est_start_date,
       s.est_start_time,
       s.est_end_date,
       s.watch_flag,
       CASE s.weekend_flag WHEN 'Y' THEN 'Yes' WHEN 'N' THEN 'No' ELSE 'N/A' END AS weekend_flag_name,
       s.po_no,
       res.user_id foreman_user_id,
       foreman.first_name + ' ' + foreman.last_name AS foreman_user_name,
       eu.customer_name end_user_name,
       jl.job_location_name,
       (SELECT TOP 1 contact_name + ' - ' + dbo.sp_contact_phone(contact_id) FROM contacts WHERE contact_id=r.customer_contact_id) customer_contact,
       (SELECT TOP 1 contact_name + ' - ' + dbo.sp_contact_phone(contact_id) FROM contacts WHERE contact_id =r.job_location_contact_id) job_location_contact,
       ISNULL(r.schedule_with_client_flag,'N') schedule_with,
       q.[roc_omni_discounted_hours-total] est_hours
  FROM jobs j INNER JOIN
       lookups job_type ON j.job_type_id = job_type.lookup_id INNER JOIN
       lookups job_status_type ON j.job_status_type_id = job_status_type.lookup_id INNER JOIN
       customers c ON j.customer_id = c.customer_id LEFT OUTER JOIN
       users billing_user ON j.billing_user_id = billing_user.user_ID LEFT OUTER JOIN
       resources res ON j.foreman_resource_id = res.resource_id LEFT OUTER JOIN
       users foreman ON res.user_id = foreman.user_id LEFT OUTER JOIN
       services s ON j.job_id = s.job_id LEFT OUTER JOIN
       lookups serv_status_type ON s.serv_status_type_id = serv_status_type.lookup_id LEFT OUTER JOIN
       lookups schedule_type ON s.schedule_type_id = schedule_type.lookup_id LEFT OUTER JOIN
       lookups service_type ON s.service_type_id = service_type.lookup_id LEFT OUTER JOIN
       job_locations jl ON s.job_location_id = jl.job_location_id LEFT OUTER JOIN
       requests r ON s.request_id=r.request_id LEFT OUTER JOIN 
       projects p ON j.project_id = p.project_id LEFT OUTER JOIN
       customers eu ON p.end_user_id = eu.customer_id LEFT OUTER JOIN
       quotes q ON s.quote_id = q.quote_id
GO
/****** Object:  View [dbo].[sch_job_req_info_v]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* $Id: sch_job_req_info_v.sql 1667 2009-08-17 21:49:29Z bvonhaden $ */

CREATE VIEW [dbo].[sch_job_req_info_v]
AS
SELECT CAST(j.job_id AS VARCHAR(30)) + ':' + ISNULL(CAST(s.service_id AS VARCHAR(30)), '') AS job_service_id,
       j.job_id,
       j.project_id,
       s.service_id,
       r.request_id,
       c.organization_id, 
       j.job_no,
       s.service_no,
       s.po_no,
       j.job_type_id,
       job_type.name job_type,
       CASE WHEN customer_type.code = 'end_user' THEN (SELECT customer_name FROM customers WHERE customer_id = c.end_user_parent_id) 
            ELSE c.customer_name END customer_name,
       CASE WHEN customer_type.code = 'end_user' THEN c.customer_name 
            ELSE (SELECT customer_name 
                    FROM customers c1 INNER JOIN
                         projects p ON c1.customer_id=p.end_user_id 
                   WHERE p.project_id=j.project_id) END end_user_name,
       jl.job_location_name,
       jl.street1,
       jl.street2,
       jl.city,
       jl.state,
       jl.zip,
       (SELECT contact_name + ' - ' + dbo.sp_contact_phone(contact_id) FROM contacts WHERE contact_id=r.customer_contact_id) customer_contact,
       CASE WHEN r.customer_contact2_id IS NULL THEN NULL ELSE (SELECT contact_name + ' - ' + dbo.sp_contact_phone(contact_id) FROM contacts WHERE contact_id=r.customer_contact2_id) END customer_contact2,
       CASE WHEN r.customer_contact3_id IS NULL THEN NULL ELSE (SELECT contact_name + ' - ' + dbo.sp_contact_phone(contact_id) FROM contacts WHERE contact_id=r.customer_contact3_id) END customer_contact3,
       CASE WHEN r.customer_contact4_id IS NULL THEN NULL ELSE (SELECT contact_name + ' - ' + dbo.sp_contact_phone(contact_id) FROM contacts WHERE contact_id=r.customer_contact4_id) END customer_contact4,
       (SELECT contact_name FROM contacts WHERE contact_id=r.a_m_contact_id) omni_proj_mgr,
       s.description,
       s.est_start_date, 
       s.est_start_time, 
       s.est_end_date, 
       billing_type.name billing_type,
       product_disposition_type.name product_disposition,
       wall_mount_type.name wall_mount_type,
       system_furniture_type.name system_furniture,
       delivery_type.name delivery_type,
       other_furniture_type.name other_furniture_type, 
       other_delivery_type.name other_delivery_type,
       elevator_available_type.name elevator_available_type,
       dbo.sp_varchar20_to_number(q.[ROC_OMNI_DISCOUNTED_HOURS-RECEIVE]) + dbo.sp_varchar20_to_number(q.[ROC_OMNI_DISCOUNTED_HOURS-RELOAD]) est_warehouse_hours,
       dbo.sp_varchar20_to_number(q.[ROC_OMNI_DISCOUNTED_HOURS-TRUCK]) +  dbo.sp_varchar20_to_number(q.[ROC_OMNI_DISCOUNTED_HOURS-DRIVER]) est_delivery_hours, 
       dbo.sp_varchar20_to_number(q.[ROC_OMNI_DISCOUNTED_HOURS-UNLOAD]) + dbo.sp_varchar20_to_number(q.[ROC_OMNI_DISCOUNTED_HOURS-MOVE_STAGE]) + dbo.sp_varchar20_to_number(q.[ROC_OMNI_DISCOUNTED_HOURS-INSTALL]) + dbo.sp_varchar20_to_number(q.[ROC_OMNI_DISCOUNTED_HOURS-ELECTRICAL]) est_install_hours,
       (SELECT SUM(ISNULL(tc_qty,0)) FROM service_lines WHERE bill_service_id=s.service_id AND item_name IN ('AM-W-OT','AM-W-Reg','AssetHdlr-F-OT','AssetHdlr-F-Reg','AssetHdlr-S-OT','AssetHdlr-S-Reg','AssetHdlr-W-OT','AssetHdlr-W-Reg','Custom-W-OT','Custom-W-Reg','Cyc Cnt-F-OT','Cyc Cnt-F-Reg','Cyc Cnt-OH-OT','Cyc Cnt-OH-Reg','Cyc Cnt-S-OT','Cyc Cnt-S-Reg','Cyc Cnt-W-OT','Cyc Cnt-W-Reg','Delivery-W-OT','Delivery-W-Reg','Driver-W-OT','Driver-W-Reg','Gen Labor-W-OT','Gen Labor-W-Reg','Installer-W-OT','Installer-W-Reg','Lead-W-OT','Lead-W-Reg','MAC-W-OT','MAC-W-Reg','MOVER-W-OT','MOVER-W-REG','OH Whse-OT','OH Whse-Reg','Proj Mgr-W-OT','Proj Mgr-W-Reg','PS-W-OT','PS-W-Reg','Snaptrack-F-OT','Snaptrack-F-Reg','Snaptrack-S-OT','Snaptrack-S-Reg','Snaptrack-W-OT','Snaptrack-W-Reg','Snaptracker-OT','Snaptracker-Reg','Truck-W-Reg','VAN-W','Whse Mgr-OH-OT','Whse Mgr-OH-Reg','Whse Mgr-OT','Whse Mgr-Reg','Whse Proj - OT','Whse Proj - Reg','Whse Rent','Whse Sup-F-OT','Whse Sup-F-Reg',' Whse Sup-OT','Whse Sup-Reg','Whse Sup-S-OT','Whse Sup-S-Reg',' Whse Sup-W-OT','Whse Sup-W-Reg',' Whse-F-OT','Whse-F-Reg','Whse-OH-OT','Whse-OH-Reg','Whse-OT','Whse-Reg','Whse-S-OT','Whse-S-Reg','Whse-W-OT','Whse-W-Reg')) warehouse_hours_to_date,
       (SELECT SUM(ISNULL(tc_qty,0)) FROM service_lines WHERE bill_service_id=s.service_id AND item_name IN ('Delivery-F-OT','Delivery-F-Reg','Delivery-OT','Delivery-Reg','Delivery-S-OT','Delivery-S-Reg','Driver-F-OT','Driver-F-Reg','Driver-S-OT','Driver-S-Reg','Truck','Truck Rental','Truck Rental-F','Truck Rental-OH','Truck Rental-S','Truck Rental-W','Truck-Emp','Truck-Emp-F','Truck-Emp-OH','Truck-Emp-S','Truck-Emp-W','Truck-F-Reg','Truck-OH-Reg','Truck-S-Reg','Van','VAN-F','VAN-OH','VAN-S')) delivery_hours_to_date,
       (SELECT SUM(ISNULL(tc_qty,0)) FROM service_lines WHERE bill_service_id=s.service_id AND item_name IN ('AC-F-OT','AC-F-Reg','AC-OT','AC-Reg','AC-S-OT','AC-S-Reg','AC-W-OT','AC-W-Reg','AM Spec-F-OT','AM Spec-F-Reg','AM Spec-S-OT','AM Spec-S-Reg','AM Spec-W-OT','AM Spec-W-Reg','AM Spec.-OT','AM Spec.-Reg','AM-F-OT','AM-F-Reg','AM-OT','AM-Reg','AM-S-OT','AM-S-Reg','CampFuMgr-S-OT','CampFuMgr-S-Reg','CampFurnMgr-OT','CampFurnMgr-Reg','Custom-F-OT','Custom-F-Reg','Custom-OT','Custom-Reg','Custom-S-OT','Custom-S-Reg','Foreman-F-OT','Foreman-F-Reg','Foreman-S-OT','Foreman-S-Reg','Foreman-W-OT','Foreman-W-Reg','Gen Labor-F-OT','Gen Labor-F-Reg','Gen Labor-S-OT','Gen Labor-S-Reg','Install-OH-OT','Install-OH-Reg','Installer-F-OT','Installer-F-Reg','Installer-OT','Installer-Reg','Installer-S-OT','Installer-S-Reg','Lead-F-OT','Lead-F-Reg','Lead-OT','Lead-Reg','Lead-S-OT','Lead-S-Reg','MAC-F-OT','MAC-F-Reg','MAC-OT','MAC-Reg','MAC-S-OT','MAC-S-Reg','Mover','MOVER-F-OT','MOVER-F-REG','MOVER-OT HRS','MOVER-REG HRS','MOVER-S-OT','MOVER-S-REG','MPS-OT','MPS-Reg','MPS-S-OT','MPS-S-REG','OH Bid-OT','OH Bid-Reg','OH Install-OT','OH Install-Reg','OH Mgmt-OT','OH Mgmt-Reg','OH Train-OT','OH Train-Reg','PC Coord-OT','PC Coord-Reg','PC Coord-S-OT','PC Coord-S-Reg','PC Mover-OT','PC Mover-Reg','PC Mover-S-OT','PC Mover-S-Reg','PC/Fab-F-OT','PC/Fab-F-Reg','PC/Fab-OT','PC/Fab-Reg','PC/Fab-S-OT','PC/Fab-S-Reg','PC/Fab-W-OT','PC/Fab-W-Reg','Proj Mgr-F-OT','Proj Mgr-F-Reg','Proj Mgr-S-OT','Proj Mgr-S-Reg','PS-F-OT','PS-F-Reg','PS-OT','PS-OT-CA','PS-Reg','PS-Reg-CA','PS-Reg-F','PS-Reg-S','PS-S-OT','PS-S-Reg','RegProjMgr-OT','RegProjMgr-Reg','RegProjMgr-S-OT','RegProMgr-S-Reg')) installer_hours_to_date,
       ISNULL(p.is_new, 'N') is_new
  FROM jobs j INNER JOIN
       services s ON j.job_id = s.job_id INNER JOIN
       customers c ON j.customer_id = c.customer_id INNER JOIN 
       dbo.lookups customer_type ON c.customer_type_id = customer_type.lookup_id INNER JOIN
       dbo.lookups job_type ON j.job_type_id = job_type.lookup_id LEFT OUTER JOIN 
       dbo.job_locations jl ON s.job_location_id = jl.job_location_id LEFT OUTER JOIN
       dbo.lookups billing_type ON s.billing_type_id = billing_type.lookup_id LEFT OUTER JOIN 
       requests r ON s.request_id = r.request_id LEFT OUTER JOIN 
       dbo.lookups product_disposition_type ON r.prod_disp_id = product_disposition_type.lookup_id LEFT OUTER JOIN 
       dbo.lookups wall_mount_type ON r.wall_mount_type_id = wall_mount_type.lookup_id LEFT OUTER JOIN 
       dbo.lookups system_furniture_type ON r.system_furniture_line_type_id = system_furniture_type.lookup_id LEFT OUTER JOIN
       dbo.lookups delivery_type ON r.delivery_type_id = delivery_type.lookup_id LEFT OUTER JOIN 
       dbo.lookups other_furniture_type ON r.other_furniture_type_id = other_furniture_type.lookup_id LEFT OUTER JOIN 
       dbo.lookups other_delivery_type ON r.other_delivery_type_id = other_delivery_type.lookup_id LEFT OUTER JOIN 
       dbo.lookups elevator_available_type ON r.elevator_avail_type_id = elevator_available_type.lookup_id LEFT OUTER JOIN
       quotes q ON s.quote_id=q.quote_id  LEFT OUTER JOIN
       dbo.projects p ON j.project_id = p.project_id
GO
/****** Object:  View [dbo].[JOB_PROGRESS_1_V]    Script Date: 05/03/2010 14:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[JOB_PROGRESS_1_V]
AS
SELECT     dbo.PROJECTS_V.ORGANIZATION_ID, dbo.PROJECTS_V.PROJECT_ID, dbo.PROJECTS_V.PROJECT_NO, dbo.PROJECTS_V.CUSTOMER_ID, 
                      dbo.PROJECTS_V.PARENT_CUSTOMER_ID, dbo.PROJECTS_V.CUSTOMER_NAME, dbo.PROJECTS_V.JOB_NAME, dbo.JOBS.JOB_STATUS_TYPE_ID, 
                      JOB_STATUS_TYPE.CODE AS job_status_type_code, JOB_STATUS_TYPE.NAME AS job_status_type_name, MIN(dbo.SERVICES.EST_START_DATE) 
                      AS min_start_date, MAX(dbo.SERVICES.EST_END_DATE) AS max_end_date, dbo.PROJECTS_V.PERCENT_COMPLETE, 
                      COUNT(dbo.PUNCHLISTS.PUNCHLIST_ID) AS punchlist_count, dbo.PROJECTS_V.EXT_DEALER_ID, dbo.PROJECTS_V.DEALER_NAME, 
                      dbo.RESOURCES_V.user_full_name AS install_foreman, dbo.PROJECTS_V.project_status_type_code
FROM         dbo.REQUESTS RIGHT OUTER JOIN
                      dbo.SERVICES ON dbo.REQUESTS.REQUEST_ID = dbo.SERVICES.REQUEST_ID RIGHT OUTER JOIN
                      dbo.LOOKUPS JOB_STATUS_TYPE RIGHT OUTER JOIN
                      dbo.JOBS LEFT OUTER JOIN
                      dbo.RESOURCES_V ON dbo.JOBS.FOREMAN_RESOURCE_ID = dbo.RESOURCES_V.RESOURCE_ID ON 
                      JOB_STATUS_TYPE.LOOKUP_ID = dbo.JOBS.JOB_STATUS_TYPE_ID ON dbo.SERVICES.JOB_ID = dbo.JOBS.JOB_ID RIGHT OUTER JOIN
                      dbo.PUNCHLISTS RIGHT OUTER JOIN
                      dbo.PROJECTS_V ON dbo.PUNCHLISTS.PROJECT_ID = dbo.PROJECTS_V.PROJECT_ID ON 
                      dbo.JOBS.PROJECT_ID = dbo.PROJECTS_V.PROJECT_ID
GROUP BY dbo.PROJECTS_V.PROJECT_ID, dbo.JOBS.JOB_STATUS_TYPE_ID, dbo.PROJECTS_V.PROJECT_NO, dbo.PROJECTS_V.CUSTOMER_ID, 
                      dbo.PROJECTS_V.PARENT_CUSTOMER_ID, dbo.PROJECTS_V.CUSTOMER_NAME, dbo.PROJECTS_V.JOB_NAME, JOB_STATUS_TYPE.CODE, 
                      JOB_STATUS_TYPE.NAME, dbo.PROJECTS_V.PERCENT_COMPLETE, dbo.PROJECTS_V.ORGANIZATION_ID, dbo.PROJECTS_V.EXT_DEALER_ID, 
                      dbo.PROJECTS_V.DEALER_NAME, dbo.RESOURCES_V.user_full_name, dbo.PROJECTS_V.project_status_type_code
GO
/****** Object:  View [dbo].[crystal_dashboard_JOB_COSTING_V]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[crystal_dashboard_JOB_COSTING_V]
AS
SELECT     CAST(dbo.JOBS_V.JOB_NO AS VARCHAR) AS job_no_varchar, dbo.RESOURCES_V.EXT_EMPLOYEE_ID, dbo.RESOURCES_V.USER_ID, 
                      dbo.JOBS_V.CUSTOMER_ID, dbo.JOBS_V.CUSTOMER_NAME, dbo.JOBS_V.JOB_NAME, dbo.RESOURCES_V.resource_name, 
                      dbo.RESOURCES_V.resource_type_name, dbo.RESOURCES_V.RESOURCE_TYPE_ID, dbo.ORGANIZATIONS.NAME AS Org_Name, 
                      dbo.ORGANIZATIONS.CODE AS Org_Code, dbo.ITEMS.COST_PER_UOM, dbo.SERVICE_LINES.ORGANIZATION_ID, dbo.SERVICE_LINES.TC_JOB_NO, 
                      dbo.SERVICE_LINES.TC_SERVICE_NO, dbo.SERVICE_LINES.TC_SERVICE_LINE_NO, dbo.SERVICE_LINES.ITEM_NAME, 
                      dbo.SERVICE_LINES.TC_JOB_ID, dbo.SERVICE_LINES.TC_SERVICE_ID, dbo.SERVICE_LINES.PH_SERVICE_ID, 
                      dbo.SERVICE_LINES.SERVICE_LINE_ID, dbo.SERVICE_LINES.SERVICE_LINE_DATE, dbo.SERVICE_LINES.STATUS_ID, 
                      dbo.SERVICE_LINES.RESOURCE_ID, dbo.SERVICE_LINES.ITEM_ID, dbo.SERVICE_LINES.TC_QTY, dbo.SERVICE_LINES.TC_RATE, 
                      dbo.SERVICE_LINES.tc_total, dbo.SERVICE_LINES.PAYROLL_QTY, dbo.SERVICE_LINES.EXT_PAY_CODE, dbo.ITEMS.COLUMN_POSITION, 
                      dbo.ITEMS.ITEM_TYPE_ID, dbo.JOBS_V.PROJECT_ID, dbo.SERVICE_LINES.bill_total, dbo.INVOICE_TOTALS_V.extended_price, 
                      dbo.INVOICE_TOTALS_V.custom_total, dbo.SERVICE_LINES.BILL_QTY, dbo.SERVICE_LINES.BILL_EXP_QTY, dbo.SERVICE_LINES.BILL_RATE, 
                      dbo.SERVICE_LINES.BILL_EXP_RATE, dbo.SERVICE_LINES.bill_exp_total, dbo.SERVICE_LINES.bill_hourly_total, dbo.SERVICE_LINES.expense_total, 
                      dbo.SERVICE_LINES.payroll_total, dbo.JOBS_V.job_type_name
FROM         dbo.SERVICE_LINES INNER JOIN
                      dbo.ORGANIZATIONS ON dbo.SERVICE_LINES.ORGANIZATION_ID = dbo.ORGANIZATIONS.ORGANIZATION_ID INNER JOIN
                      dbo.REQUESTS_V ON dbo.ORGANIZATIONS.ORGANIZATION_ID = dbo.REQUESTS_V.ORGANIZATION_ID LEFT OUTER JOIN
                      dbo.ITEMS ON dbo.SERVICE_LINES.ITEM_ID = dbo.ITEMS.ITEM_ID LEFT OUTER JOIN
                      dbo.INVOICE_TOTALS_V ON dbo.SERVICE_LINES.TC_JOB_ID = dbo.INVOICE_TOTALS_V.JOB_ID AND 
                      dbo.SERVICE_LINES.INVOICE_ID = dbo.INVOICE_TOTALS_V.INVOICE_ID LEFT OUTER JOIN
                      dbo.RESOURCES_V ON dbo.SERVICE_LINES.RESOURCE_ID = dbo.RESOURCES_V.RESOURCE_ID FULL OUTER JOIN
                      dbo.JOBS_V ON dbo.SERVICE_LINES.TC_JOB_ID = dbo.JOBS_V.JOB_ID
GO
/****** Object:  View [dbo].[crystal_INVOICE_TOTAL_AND_HOURS_V]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[crystal_INVOICE_TOTAL_AND_HOURS_V]
AS
SELECT     CAST(dbo.JOBS_V.JOB_NO AS VARCHAR) AS job_no_varchar, dbo.TIME_CAPTURE_V.ORGANIZATION_ID, dbo.TIME_CAPTURE_V.TC_JOB_NO, 
                      dbo.TIME_CAPTURE_V.TC_SERVICE_NO, dbo.TIME_CAPTURE_V.TC_SERVICE_LINE_NO, dbo.TIME_CAPTURE_V.ITEM_NAME, 
                      dbo.TIME_CAPTURE_V.TC_JOB_ID, dbo.TIME_CAPTURE_V.TC_SERVICE_ID, dbo.TIME_CAPTURE_V.PH_SERVICE_ID, 
                      dbo.TIME_CAPTURE_V.SERVICE_LINE_ID, dbo.TIME_CAPTURE_V.SERVICE_LINE_DATE, dbo.TIME_CAPTURE_V.STATUS_ID, 
                      dbo.TIME_CAPTURE_V.status_name, dbo.TIME_CAPTURE_V.RESOURCE_ID, dbo.TIME_CAPTURE_V.ITEM_ID, dbo.TIME_CAPTURE_V.TC_QTY, 
                      dbo.TIME_CAPTURE_V.TC_RATE, dbo.TIME_CAPTURE_V.TC_TOTAL, dbo.TIME_CAPTURE_V.PAYROLL_QTY, dbo.TIME_CAPTURE_V.EXT_PAY_CODE, 
                      dbo.RESOURCES_V.EXT_EMPLOYEE_ID, dbo.JOBS_V.CUSTOMER_ID, dbo.JOBS_V.CUSTOMER_NAME, dbo.JOBS_V.JOB_NAME, 
                      dbo.RESOURCES_V.resource_name, dbo.RESOURCES_V.RESOURCE_TYPE_ID, dbo.INVOICE_TOTALS_V.INVOICE_ID, 
                      dbo.INVOICE_TOTALS_V.extended_price, dbo.INVOICE_TOTALS_V.custom_total, dbo.RESOURCES_V.resource_type_name, 
                      dbo.INVOICES_V.DATE_CREATED, dbo.INVOICES_V.CREATED_BY, dbo.INVOICES_V.assigned_to_name
FROM         dbo.INVOICE_TOTALS_V INNER JOIN
                      dbo.INVOICES_V ON dbo.INVOICE_TOTALS_V.INVOICE_ID = dbo.INVOICES_V.INVOICE_ID AND 
                      dbo.INVOICE_TOTALS_V.JOB_ID = dbo.INVOICES_V.JOB_ID RIGHT OUTER JOIN
                      dbo.TIME_CAPTURE_V ON dbo.INVOICES_V.JOB_ID = dbo.TIME_CAPTURE_V.TC_JOB_ID AND 
                      dbo.INVOICES_V.ORGANIZATION_ID = dbo.TIME_CAPTURE_V.ORGANIZATION_ID FULL OUTER JOIN
                      dbo.JOBS_V ON dbo.TIME_CAPTURE_V.TC_JOB_ID = dbo.JOBS_V.JOB_ID LEFT OUTER JOIN
                      dbo.RESOURCES_V ON dbo.TIME_CAPTURE_V.RESOURCE_ID = dbo.RESOURCES_V.RESOURCE_ID
GO
/****** Object:  View [dbo].[crystal_dashboard_JOB_COSTING_V2]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[crystal_dashboard_JOB_COSTING_V2]
AS
SELECT     distinct CAST(dbo.JOBS_V.JOB_NO AS VARCHAR) AS job_no_varchar, dbo.RESOURCES_V.EXT_EMPLOYEE_ID, dbo.RESOURCES_V.USER_ID, 
                      dbo.JOBS_V.CUSTOMER_ID, dbo.JOBS_V.CUSTOMER_NAME, dbo.JOBS_V.JOB_NAME, dbo.RESOURCES_V.resource_name, 
                      dbo.RESOURCES_V.resource_type_name, dbo.RESOURCES_V.RESOURCE_TYPE_ID, dbo.ORGANIZATIONS.NAME AS Org_Name, 
                      dbo.ORGANIZATIONS.CODE AS Org_Code, dbo.ITEMS.COST_PER_UOM, dbo.SERVICE_LINES.ORGANIZATION_ID, dbo.SERVICE_LINES.TC_JOB_NO, 
                      dbo.SERVICE_LINES.TC_SERVICE_NO, dbo.SERVICE_LINES.TC_SERVICE_LINE_NO, dbo.SERVICE_LINES.ITEM_NAME, 
                      dbo.SERVICE_LINES.TC_JOB_ID, dbo.SERVICE_LINES.TC_SERVICE_ID, dbo.SERVICE_LINES.PH_SERVICE_ID, 
                      dbo.SERVICE_LINES.SERVICE_LINE_ID, dbo.SERVICE_LINES.SERVICE_LINE_DATE, dbo.SERVICE_LINES.STATUS_ID, 
                      dbo.SERVICE_LINES.RESOURCE_ID, dbo.SERVICE_LINES.ITEM_ID, dbo.SERVICE_LINES.TC_QTY, dbo.SERVICE_LINES.TC_RATE, 
                      dbo.SERVICE_LINES.tc_total, dbo.SERVICE_LINES.PAYROLL_QTY, dbo.SERVICE_LINES.EXT_PAY_CODE, dbo.ITEMS.COLUMN_POSITION, 
                      dbo.ITEMS.ITEM_TYPE_ID, dbo.JOBS_V.PROJECT_ID, dbo.SERVICE_LINES.bill_total, dbo.INVOICE_TOTALS_V.extended_price, 
                      dbo.INVOICE_TOTALS_V.custom_total, dbo.SERVICE_LINES.BILL_QTY, dbo.SERVICE_LINES.BILL_EXP_QTY, dbo.SERVICE_LINES.BILL_RATE, 
                      dbo.SERVICE_LINES.BILL_EXP_RATE, dbo.SERVICE_LINES.bill_exp_total, dbo.SERVICE_LINES.bill_hourly_total, dbo.SERVICE_LINES.expense_total, 
                      dbo.SERVICE_LINES.payroll_total, dbo.JOBS_V.job_type_name
FROM         dbo.SERVICE_LINES INNER JOIN
                      dbo.ORGANIZATIONS ON dbo.SERVICE_LINES.ORGANIZATION_ID = dbo.ORGANIZATIONS.ORGANIZATION_ID INNER JOIN
                      dbo.REQUESTS_V ON dbo.ORGANIZATIONS.ORGANIZATION_ID = dbo.REQUESTS_V.ORGANIZATION_ID LEFT OUTER JOIN
                      dbo.ITEMS ON dbo.SERVICE_LINES.ITEM_ID = dbo.ITEMS.ITEM_ID LEFT OUTER JOIN
                      dbo.INVOICE_TOTALS_V ON dbo.SERVICE_LINES.TC_JOB_ID = dbo.INVOICE_TOTALS_V.JOB_ID AND 
                      dbo.SERVICE_LINES.INVOICE_ID = dbo.INVOICE_TOTALS_V.INVOICE_ID LEFT OUTER JOIN
                      dbo.RESOURCES_V ON dbo.SERVICE_LINES.RESOURCE_ID = dbo.RESOURCES_V.RESOURCE_ID FULL OUTER JOIN
                      dbo.JOBS_V ON dbo.SERVICE_LINES.TC_JOB_ID = dbo.JOBS_V.JOB_ID
GO
/****** Object:  View [dbo].[PEP_POSTED_REQS_V]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[PEP_POSTED_REQS_V]
AS
SELECT     TOP 100 PERCENT dbo.JOBS_V.ORGANIZATION_ID, dbo.JOBS_V.JOB_NO, dbo.SERVICES.SERVICE_NO, dbo.JOBS_V.CUSTOMER_NAME, 
                      dbo.JOBS_V.JOB_NAME, dbo.SERVICES.DESCRIPTION, dbo.SERVICES.CUST_COL_1 AS location, SUM(dbo.BILLING_V.BILL_TOTAL) AS sum_bill_total, 
                      dbo.BILLING_V.INVOICE_ID, dbo.INVOICE_TOTALS_V.extended_price AS invoice_total
FROM         dbo.INVOICE_TOTALS_V RIGHT OUTER JOIN
                      dbo.JOBS_V LEFT OUTER JOIN
                      dbo.BILLING_V ON dbo.JOBS_V.JOB_ID = dbo.BILLING_V.BILL_JOB_ID LEFT OUTER JOIN
                      dbo.SERVICES ON dbo.BILLING_V.BILL_SERVICE_ID = dbo.SERVICES.SERVICE_ID ON 
                      dbo.INVOICE_TOTALS_V.INVOICE_ID = dbo.BILLING_V.INVOICE_ID
WHERE     (dbo.BILLING_V.SERVICE_LINE_DATE BETWEEN '4/25/2003' AND '5/4/2004')
GROUP BY dbo.JOBS_V.JOB_NO, dbo.JOBS_V.JOB_NAME, dbo.JOBS_V.CUSTOMER_NAME, dbo.BILLING_V.STATUS_ID, dbo.SERVICES.SERVICE_NO, 
                      dbo.SERVICES.DESCRIPTION, dbo.SERVICES.CUST_COL_1, dbo.INVOICE_TOTALS_V.extended_price, dbo.JOBS_V.JOB_ID, 
                      dbo.JOBS_V.ORGANIZATION_ID, dbo.SERVICES.CUST_COL_1, dbo.BILLING_V.INVOICE_ID
HAVING      (dbo.BILLING_V.STATUS_ID = 5) AND (dbo.JOBS_V.CUSTOMER_NAME LIKE 'medtronic%')
ORDER BY dbo.JOBS_V.JOB_NO, dbo.BILLING_V.INVOICE_ID
GO
/****** Object:  View [dbo].[SERVICE_LINES_SCHD_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[SERVICE_LINES_SCHD_V]
AS
SELECT     dbo.SCH_RESOURCES_V.SCH_RESOURCE_ID, dbo.SCH_RESOURCE_DATES_V.exploded_date, dbo.SERVICE_LINES.SERVICE_LINE_ID
FROM         dbo.SCH_RESOURCES_V INNER JOIN
                      dbo.SCH_RESOURCE_DATES_V ON 
                      dbo.SCH_RESOURCES_V.SCH_RESOURCE_ID = dbo.SCH_RESOURCE_DATES_V.SCH_RESOURCE_ID LEFT OUTER JOIN
                      dbo.SERVICE_LINES ON dbo.SCH_RESOURCE_DATES_V.exploded_date = dbo.SERVICE_LINES.SERVICE_LINE_DATE AND 
                      dbo.SCH_RESOURCE_DATES_V.SERVICE_ID = dbo.SERVICE_LINES.TC_SERVICE_ID AND 
                      dbo.SCH_RESOURCE_DATES_V.RESOURCE_ID = dbo.SERVICE_LINES.RESOURCE_ID
GO
/****** Object:  View [dbo].[MISSING_EMP_HRS_V]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[MISSING_EMP_HRS_V]
AS
SELECT     dbo.JOBS_V.ORGANIZATION_ID, dbo.RESOURCES.USER_ID, dbo.USERS.EXT_EMPLOYEE_ID, dbo.USERS.FULL_NAME AS employee_name, 
                      dbo.JOBS_V.FOREMAN_RESOURCE_ID, dbo.JOBS_V.foreman_resource_name, dbo.SCH_RESOURCE_DATES_V.JOB_ID, dbo.JOBS_V.JOB_NO, 
                      dbo.JOBS_V.JOB_NAME, dbo.SCH_RESOURCE_DATES_V.RES_START_DATE, dbo.SCH_RESOURCE_DATES_V.RES_END_DATE, 
                      dbo.SCH_RESOURCE_DATES_V.exploded_date
FROM         dbo.SCH_RESOURCE_DATES_V LEFT OUTER JOIN
                      dbo.JOBS_V ON dbo.SCH_RESOURCE_DATES_V.JOB_ID = dbo.JOBS_V.JOB_ID LEFT OUTER JOIN
                      dbo.RESOURCES ON dbo.SCH_RESOURCE_DATES_V.RESOURCE_ID = dbo.RESOURCES.RESOURCE_ID LEFT OUTER JOIN
                      dbo.USERS ON dbo.RESOURCES.USER_ID = dbo.USERS.USER_ID
WHERE     (NOT EXISTS
                          (SELECT     1
                            FROM          SERVICE_LINES
                            WHERE      SCH_RESOURCE_DATES_V.JOB_ID = tc_JOB_ID AND 
                                                   dbo.SCH_RESOURCE_DATES_V.exploded_date = dbo.SERVICE_LINES.SERVICE_LINE_DATE_varchar))
GO
/****** Object:  View [dbo].[crystal_TC_VERIFIED_V]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[crystal_TC_VERIFIED_V]
AS
SELECT     dbo.SERVICE_LINES.ORGANIZATION_ID, dbo.SERVICE_LINES.SERVICE_LINE_ID, dbo.SERVICE_LINES.TC_JOB_NO, 
                      dbo.SERVICE_LINES.TC_SERVICE_NO, dbo.SERVICE_LINES.TC_SERVICE_LINE_NO, dbo.SERVICE_LINES.SERVICE_LINE_DATE, 
                      dbo.SERVICE_LINES.STATUS_ID, dbo.SERVICE_LINES.TC_JOB_ID, dbo.SERVICE_LINES.TC_SERVICE_ID, dbo.SERVICE_LINES.RESOURCE_ID, 
                      dbo.SERVICE_LINES.RESOURCE_NAME, dbo.SERVICE_LINES.ITEM_ID, dbo.SERVICE_LINES.ITEM_NAME, dbo.SERVICE_LINES.TC_QTY, 
                      dbo.SERVICE_LINES.TC_RATE, dbo.SERVICE_LINES.TC_TOTAL, dbo.SERVICE_LINES.PALM_REP_ID, dbo.SERVICE_LINES.ENTERED_DATE, 
                      dbo.SERVICE_LINES.ENTERED_BY, dbo.SERVICE_LINES.VERIFIED_DATE, dbo.SERVICE_LINES.VERIFIED_BY, dbo.SERVICE_LINES.DATE_CREATED, 
                      dbo.SERVICE_LINES.CREATED_BY, dbo.SERVICE_LINES.DATE_MODIFIED, dbo.SERVICE_LINES.MODIFIED_BY, dbo.SERVICES_V.DESCRIPTION
FROM         dbo.SERVICE_LINES INNER JOIN
                      dbo.SERVICES_V ON dbo.SERVICE_LINES.TC_JOB_NO = dbo.SERVICES_V.JOB_NO AND 
                      dbo.SERVICE_LINES.TC_SERVICE_NO = dbo.SERVICES_V.SERVICE_NO
GO
/****** Object:  View [dbo].[crystal_csc_pkf_WORK_ORDER_MASTER_V]    Script Date: 05/03/2010 14:18:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[crystal_csc_pkf_WORK_ORDER_MASTER_V]
AS
SELECT     TOP 100 PERCENT dbo.REQUESTS.PROJECT_ID, dbo.PROJECTS.PROJECT_NO, dbo.REQUESTS.REQUEST_NO, dbo.REQUESTS.PRIORITY_TYPE_ID, 
                      priority_lookup.NAME AS PRIORITY, dbo.REQUESTS.LEVEL_TYPE_ID, CONTACTS_1.CONTACT_NAME AS Customer_Contact, 
                      dbo.REQUEST_VENDORS.VENDOR_CONTACT_ID, VENDOR_CONTACT.CONTACT_NAME AS VENDOR_NAME, dbo.REQUESTS.EST_START_DATE, 
                      dbo.REQUESTS.EST_START_TIME, dbo.REQUESTS.EST_END_DATE, dbo.REQUEST_VENDORS.DATE_CREATED, dbo.REQUESTS.IS_SENT_DATE, 
                      dbo.REQUEST_VENDORS.SCH_START_DATE, dbo.REQUEST_VENDORS.SCH_START_TIME, dbo.REQUEST_VENDORS.SCH_END_DATE, 
                      dbo.REQUEST_VENDORS.ACT_START_DATE, dbo.REQUEST_VENDORS.ACT_START_TIME, dbo.REQUEST_VENDORS.ACT_END_DATE, 
                      dbo.REQUEST_VENDORS.ESTIMATED_COST, dbo.REQUEST_VENDORS.TOTAL_COST, dbo.REQUEST_VENDORS.INVOICE_DATE, 
                      dbo.REQUEST_VENDORS.INVOICE_NUMBERS, dbo.REQUEST_VENDORS.VISIT_COUNT, dbo.REQUEST_VENDORS.COMPLETE_FLAG, 
                      dbo.REQUEST_VENDORS.INVOICED_FLAG, dbo.PROJECTS.JOB_NAME, activiy_lookup.NAME AS ACTIVITY, dbo.REQUESTS.QTY1, 
                      category_lookup.NAME AS CATEGORY, dbo.REQUESTS.DESCRIPTION, dbo.REQUESTS.REQUEST_STATUS_TYPE_ID, 
                      dbo.JOB_LOCATIONS_V.JOB_LOCATION_NAME, dbo.REQUESTS.CUSTOMER_PO_NO, dbo.CUSTOMERS.CUSTOMER_NAME, 
                      dbo.REQUESTS.CUST_COL_1, dbo.REQUESTS.CUST_COL_2, dbo.REQUESTS.CUST_COL_3, dbo.REQUESTS.CUST_COL_4, 
                      dbo.REQUESTS.CUST_COL_5, dbo.REQUESTS.CUST_COL_6, dbo.REQUESTS.CUST_COL_7, dbo.REQUESTS.CUST_COL_8, 
                      dbo.REQUESTS.CUST_COL_9, dbo.REQUESTS.CUST_COL_10, dbo.REQUEST_VENDORS.VENDOR_NOTES, dbo.JOB_LOCATIONS_V.STREET1, 
                      dbo.JOB_LOCATIONS_V.CITY, dbo.JOB_LOCATIONS_V.STATE, dbo.JOB_LOCATIONS_V.ZIP, dbo.REQUESTS.WORK_ORDER_RECEIVED_DATE
FROM         dbo.REQUEST_VENDORS INNER JOIN
                      dbo.CONTACTS VENDOR_CONTACT ON dbo.REQUEST_VENDORS.VENDOR_CONTACT_ID = VENDOR_CONTACT.CONTACT_ID RIGHT OUTER JOIN
                      dbo.LOOKUPS activiy_lookup RIGHT OUTER JOIN
                      dbo.LOOKUPS priority_lookup RIGHT OUTER JOIN
                      dbo.PROJECTS INNER JOIN
                      dbo.REQUESTS ON dbo.PROJECTS.PROJECT_ID = dbo.REQUESTS.PROJECT_ID LEFT OUTER JOIN
                      dbo.CUSTOMERS LEFT OUTER JOIN
                      dbo.CONTACTS CONTACTS_1 ON dbo.CUSTOMERS.CUSTOMER_ID = CONTACTS_1.CUSTOMER_ID ON 
                      dbo.REQUESTS.CUSTOMER_CONTACT_ID = CONTACTS_1.CONTACT_ID AND dbo.PROJECTS.CUSTOMER_ID = dbo.CUSTOMERS.CUSTOMER_ID ON 
                      priority_lookup.LOOKUP_ID = dbo.REQUESTS.PRIORITY_TYPE_ID ON 
                      activiy_lookup.LOOKUP_ID = dbo.REQUESTS.ACTIVITY_TYPE_ID1 LEFT OUTER JOIN
                      dbo.LOOKUPS category_lookup ON dbo.REQUESTS.ACTIVITY_CAT_TYPE_ID1 = category_lookup.LOOKUP_ID ON 
                      dbo.REQUEST_VENDORS.REQUEST_ID = dbo.REQUESTS.REQUEST_ID FULL OUTER JOIN
                      dbo.JOB_LOCATIONS_V ON dbo.REQUESTS.JOB_LOCATION_ID = dbo.JOB_LOCATIONS_V.JOB_LOCATION_ID
ORDER BY dbo.REQUESTS.REQUEST_NO
GO
/****** Object:  View [dbo].[VAR_REPORT_V]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VAR_REPORT_V]
AS
SELECT     dbo.JOBS_V.JOB_ID, dbo.JOBS_V.JOB_NO, dbo.JOBS_V.JOB_NAME, dbo.JOBS_V.job_type_code, dbo.JOBS_V.job_status_type_name, 
                      dbo.JOBS_V.EXT_DEALER_ID, dbo.JOBS_V.DEALER_NAME, dbo.JOBS_V.CUSTOMER_ID, dbo.JOBS_V.CUSTOMER_NAME, 
                      dbo.JOBS_V.ORGANIZATION_ID, dbo.JOBS_V.BILLING_USER_ID, dbo.JOBS_V.foreman_user_id, ISNULL(dbo.VAR_JOB_TIME_EXP_V.sum_time_exp, 
                      0) AS sum_time_exp, ISNULL(dbo.VAR_JOB_TIME_EXP_V.sum_time, 0) AS sum_time, ISNULL(dbo.VAR_JOB_TIME_EXP_V.sum_exp, 0) AS sum_exp, 
                      ISNULL(dbo.VAR_JOB_QUOTED_V.sum_quote, 0) AS sum_quote, ISNULL(dbo.VAR_JOB_ACT_HOURS_V.sum_payroll_qty, 0) AS sum_payroll_qty, 
                      ISNULL(dbo.VAR_JOB_ACT_HOURS_V.sum_expense_qty, 0) AS sum_expense_qty, ISNULL(dbo.VAR_JOB_EST_HOURS_V.sum_estimated_hours, 0) 
                      AS sum_estimated_hours
FROM         dbo.JOBS_V LEFT OUTER JOIN
                      dbo.VAR_JOB_TIME_EXP_V ON dbo.JOBS_V.JOB_ID = dbo.VAR_JOB_TIME_EXP_V.job_id LEFT OUTER JOIN
                      dbo.VAR_JOB_QUOTED_V ON dbo.JOBS_V.JOB_ID = dbo.VAR_JOB_QUOTED_V.JOB_ID LEFT OUTER JOIN
                      dbo.VAR_JOB_ACT_HOURS_V ON dbo.JOBS_V.JOB_ID = dbo.VAR_JOB_ACT_HOURS_V.JOB_ID LEFT OUTER JOIN
                      dbo.VAR_JOB_EST_HOURS_V ON dbo.JOBS_V.JOB_ID = dbo.VAR_JOB_EST_HOURS_V.JOB_ID
GO
/****** Object:  View [dbo].[PAYROLL_VERIFICATION_V_PATTY]    Script Date: 05/03/2010 14:18:08 ******/
-- SET ANSI_NULLS ON
-- GO
-- SET QUOTED_IDENTIFIER ON
-- GO
-- CREATE VIEW [dbo].[PAYROLL_VERIFICATION_V_PATTY]
-- AS
-- SELECT     pay.ORGANIZATION_ID, sl.RESOURCE_ID, pay.TC_JOB_ID AS JOB_ID, pay.TC_JOB_NO AS JOB_NO, pay.TC_SERVICE_ID AS SERVICE_ID,
--                       pay.TC_SERVICE_NO AS SERVICE_NO, pay.resource_name, dbo.RESOURCES_V.RES_CATEGORY_TYPE_ID, dbo.RESOURCES_V.res_cat_type_code,
--                       dbo.RESOURCES_V.res_cat_type_name, dbo.JOBS_V.EXT_CUSTOMER_ID, dbo.JOBS_V.DEALER_NAME, dbo.JOBS_V.EXT_DEALER_ID,
--                       sl.VERIFIED_DATE, sl.VERIFIED_BY, sl.PAYROLL_QTY AS hours_qty, sl.BILL_HOURLY_QTY AS hours_bill_qty,
--                       sl.BILL_HOURLY_RATE AS hours_bill_rate, pay.EXT_EMPLOYEE_ID, pay.employee_name, CONVERT(varchar(12), DATEADD(day, - 6,
--                       sl.SERVICE_LINE_WEEK), 101) AS begin_date, CONVERT(varchar(12), sl.SERVICE_LINE_WEEK, 101) AS end_date, pay.SERVICE_LINE_DATE,
--                       pay.ITEM_ID, pay.ITEM_NAME, pay.EXT_PAY_CODE, pay.ITEM_TYPE_CODE, dbo.ITEMS_V.item_type_name,
--                       sl.BILL_HOURLY_TOTAL AS hours_bill_price, dbo.JOBS_V.JOB_NO_NAME, sl.ENTERED_DATE, sl.EXT_PAY_CODE AS EXT_PAYCODE,
--                       dbo.GP_MPLS_PAY_CODE_V.PAYRCORD, dbo.GP_MPLS_PAY_CODE_V.DSCRIPTN, sl.ENTERED_BY, sl.entered_by_name, dbo.USERS.USER_ID,
--                       dbo.USERS.FIRST_NAME, dbo.USERS.LAST_NAME, dbo.USERS.EXT_EMPLOYEE_ID AS EMP_ID, sl.verified_by_name, sl.ENTRY_METHOD,
--                       sl.TC_QTY, sl.TC_RATE, sl.TC_TOTAL
-- FROM         dbo.USERS RIGHT OUTER JOIN
--                       dbo.ITEMS_V RIGHT OUTER JOIN
--                       dbo.PAYROLL_V pay ON dbo.ITEMS_V.ITEM_ID = pay.ITEM_ID LEFT OUTER JOIN
--                       dbo.JOBS_V ON pay.TC_JOB_ID = dbo.JOBS_V.JOB_ID LEFT OUTER JOIN
--                       dbo.RESOURCES_V RIGHT OUTER JOIN
--                       dbo.TIME_CAPTURE_V sl ON dbo.RESOURCES_V.RESOURCE_ID = sl.RESOURCE_ID ON pay.SERVICE_LINE_ID = sl.SERVICE_LINE_ID ON
--                       dbo.USERS.USER_ID = sl.ENTERED_BY LEFT OUTER JOIN
--                       dbo.GP_MPLS_PAY_CODE_V ON sl.EXT_PAY_CODE = dbo.GP_MPLS_PAY_CODE_V.PAYRCORD
-- WHERE     (sl.VERIFIED_BY IS NOT NULL) OR
--                       (sl.OVERRIDE_BY IS NOT NULL)
-- GO

/****** Object:  View [dbo].[invoice_pre_total_v]    Script Date: 05/03/2010 14:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[invoice_pre_total_v]
AS
SELECT i_v.organization_id,
       i_v.job_id,
       j_v.job_no,
       b_v.bill_service_id AS service_id,
       i_v.invoice_id,
       i_v.invoice_id_trk,
       i_v.description AS invoice_description,
       i_v.status_id AS invoice_status_id,
       i_v.ext_batch_id,
       i_v.date_sent,
       i_v.invoice_type_name,
       i_v.invoice_type_code,
       i_v.batch_status_id,
       0 AS custom_line_total,
       ISNULL(b_v.bill_hourly_total, 0) AS bill_hourly_total,
       ISNULL(b_v.bill_exp_total, 0) AS bill_exp_total,
       ISNULL(b_v.bill_total, 0) AS bill_total,
       i_v.assigned_to_name,
       j_v.billing_user_id,
       j_v.billing_user_name,
       i_v.billing_type_name,
       i_v.invoice_format_type_name,
       i_v.po_no,
       j_v.dealer_name,
       j_v.ext_dealer_id,
       j_v.customer_name,
       j_v.end_user_name,
       i_v.date_created AS invoice_date_created,
       j_v.job_type_name,
       j_v.job_type_code
  FROM dbo.invoices_v i_v LEFT OUTER JOIN
       dbo.jobs_v j_v ON i_v.job_id = j_v.job_id LEFT OUTER JOIN
       dbo.billing_v b_v ON i_v.invoice_id = b_v.invoice_id
UNION ALL
SELECT j_v.organization_id,
       i_v.job_id,
       j_v.job_no,
       NULL,
       i_v.invoice_id,
       i_v.invoice_id_trk,
       i_v.description,
       i_v.status_id,
       i_v.ext_batch_id,
       i_v.date_sent,
       i_v.invoice_type_name,
       i_v.invoice_type_code,
       i_v.batch_status_id,
       (il_v.unit_price * il_v.qty) custom_line_total,
       0,
       0,
       0,
       i_v.assigned_to_name,
       j_v.billing_user_id,
       j_v.billing_user_name,
       i_v.billing_type_name,
       i_v.invoice_format_type_name,
       i_v.po_no,
       j_v.dealer_name,
       j_v.ext_dealer_id,
       j_v.customer_name,
       j_v.end_user_name,
       i_v.date_created invoice_date_created,
       j_v.job_type_name,
       j_v.job_type_code
  FROM dbo.jobs_v j_v RIGHT OUTER JOIN
       dbo.invoice_lines_v il_v on j_v.job_id = il_v.job_id RIGHT OUTER JOIN
       dbo.invoices_v i_v ON il_v.invoice_id = i_v.invoice_id
 WHERE i_v.invoice_id = il_v.invoice_id
   AND il_v.job_id = j_v.job_id
   AND il_v.invoice_line_type_code = 'custom'
GO

/****** Object:  View [dbo].[crystal_UNBILL_ACCT_V]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[crystal_UNBILL_ACCT_V]
AS
SELECT     dbo.INVOICES_V.ORGANIZATION_ID, dbo.INVOICES_V.PO_NO, dbo.INVOICES_V.DESCRIPTION, dbo.INVOICES_V.INVOICE_ID, 
                      dbo.INVOICE_PRE_TOTAL_V.JOB_NO, dbo.INVOICE_PRE_TOTAL_V.custom_line_total, dbo.INVOICE_PRE_TOTAL_V.bill_hourly_total, 
                      dbo.INVOICE_PRE_TOTAL_V.bill_exp_total, dbo.INVOICE_PRE_TOTAL_V.bill_total, dbo.INVOICES_V.STATUS_ID, dbo.INVOICE_STATUSES.NAME, 
                      dbo.INVOICES_V.DATE_CREATED, dbo.INVOICE_PRE_TOTAL_V.DEALER_NAME
FROM         dbo.INVOICES_V INNER JOIN
                      dbo.INVOICE_STATUSES ON dbo.INVOICES_V.STATUS_ID = dbo.INVOICE_STATUSES.STATUS_ID LEFT OUTER JOIN
                      dbo.INVOICE_LINES_V ON dbo.INVOICES_V.INVOICE_ID = dbo.INVOICE_LINES_V.INVOICE_ID LEFT OUTER JOIN
                      dbo.INVOICE_PRE_TOTAL_V ON dbo.INVOICES_V.INVOICE_ID = dbo.INVOICE_PRE_TOTAL_V.INVOICE_ID
GO
/****** Object:  View [dbo].[SCH_RESOURCES_ALL_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[SCH_RESOURCES_ALL_V]
AS
SELECT     CAST(dbo.RESOURCES_V.RESOURCE_ID AS varchar(30)) + ':' + ISNULL(CAST(dbo.SCH_RESOURCES.SCH_RESOURCE_ID AS varchar(30)), '') 
                      AS res_sch_id, dbo.RESOURCES_V.RESOURCE_ID, dbo.SCH_RESOURCES.SCH_RESOURCE_ID, 
                      dbo.SCH_RESOURCES.WEEKEND_SCH_RESOURCE_ID, dbo.SCH_RESOURCES.JOB_ID, dbo.JOBS.JOB_NO, dbo.SCH_RESOURCES.SERVICE_ID, 
                      dbo.SERVICES.SERVICE_NO, dbo.SCH_RESOURCES.HIDDEN_SERVICE_ID, dbo.JOBS.JOB_TYPE_ID, JOB_TYPES.CODE AS job_type_code, 
                      JOB_TYPES.NAME AS job_type_name, dbo.SCH_RESOURCES.RES_STATUS_TYPE_ID, RES_STATUS_TYPE.CODE AS res_status_type_code, 
                      ISNULL(RES_STATUS_TYPE.NAME, 'Available') AS res_status_type_name, dbo.SCH_RESOURCES.REASON_TYPE_ID, 
                      REASON_TYPE.CODE AS reason_type_code, REASON_TYPE.NAME AS reason_type_name, ISNULL(dbo.SCH_RESOURCES.FOREMAN_FLAG, 'N') 
                      AS sch_foreman_flag, dbo.SCH_RESOURCES.send_to_pda_flag, dbo.SCH_RESOURCES.RES_START_DATE, dbo.SCH_RESOURCES.RES_START_TIME, dbo.SCH_RESOURCES.RES_END_DATE, 
                      dbo.SCH_RESOURCES.DATE_CONFIRMED, dbo.SCH_RESOURCES.RESOURCE_QTY, dbo.SCH_RESOURCES.SCH_NOTES, 
                      ISNULL(dbo.SCH_RESOURCES.WEEKEND_FLAG, 'N') AS weekend_flag, dbo.SCH_RESOURCES.DATE_CREATED AS sch_date_created, 
                      dbo.SCH_RESOURCES.CREATED_BY AS sch_created_by, CREATED_BY.FIRST_NAME + ' ' + CREATED_BY.LAST_NAME AS sch_created_by_name, 
                      dbo.SCH_RESOURCES.DATE_MODIFIED AS sch_date_modified, dbo.SCH_RESOURCES.MODIFIED_BY AS sch_modified_by, 
                      MODIFIED_BY.FIRST_NAME + ' ' + MODIFIED_BY.LAST_NAME AS sch_modified_by_name, dbo.RESOURCES_V.NAME AS resource_name, 
                      dbo.RESOURCES_V.RES_CATEGORY_TYPE_ID, dbo.RESOURCES_V.res_cat_type_code, dbo.RESOURCES_V.res_cat_type_name, 
                      dbo.RESOURCES_V.RESOURCE_TYPE_ID, dbo.RESOURCES_V.resource_type_code, dbo.RESOURCES_V.resource_type_name, 
                      dbo.RESOURCES_V.UNIQUE_FLAG, dbo.RESOURCES_V.NOTES, dbo.RESOURCES_V.PIN, dbo.RESOURCES_V.FOREMAN_FLAG, 
                      dbo.RESOURCES_V.ACTIVE_FLAG, dbo.RESOURCES_V.EXT_VENDOR_ID, dbo.RESOURCES_V.employment_type_name, 
                      dbo.RESOURCES_V.employment_type_code, dbo.RESOURCES_V.EMPLOYMENT_TYPE_ID, dbo.RESOURCES_V.USER_ID, 
                      dbo.JOBS.FOREMAN_RESOURCE_ID, FOREMAN_USER.USER_ID AS FOREMAN_USER_ID, dbo.RESOURCES_V.user_full_name, 
                      dbo.RESOURCES_V.user_contact_id, dbo.RESOURCES_V.user_contact_name, dbo.RESOURCES_V.modified_by_name AS res_modified_by_name, 
                      dbo.RESOURCES_V.MODIFIED_BY AS res_modified_by, dbo.RESOURCES_V.DATE_MODIFIED AS res_date_modified, 
                      dbo.RESOURCES_V.created_by_name AS res_created_by_name, dbo.RESOURCES_V.CREATED_BY AS res_created_by, 
                      dbo.RESOURCES_V.DATE_CREATED AS res_date_created, CONVERT(varchar, dbo.SCH_RESOURCES.RES_START_TIME, 8) AS res_start_time_only, 
                      CONVERT(varchar, dbo.SCH_RESOURCES.RES_END_TIME, 8) AS res_end_time, (CASE reason_type.code WHEN 'unconfirmed' THEN 'Y' ELSE 'N' END)
                       AS unconfirmed_flag
FROM         dbo.USERS FOREMAN_USER RIGHT OUTER JOIN
                      dbo.LOOKUPS JOB_TYPES RIGHT OUTER JOIN
                      dbo.JOBS ON JOB_TYPES.LOOKUP_ID = dbo.JOBS.JOB_TYPE_ID LEFT OUTER JOIN
                      dbo.RESOURCES ON dbo.JOBS.FOREMAN_RESOURCE_ID = dbo.RESOURCES.RESOURCE_ID RIGHT OUTER JOIN
                      dbo.LOOKUPS RES_STATUS_TYPE RIGHT OUTER JOIN
                      dbo.USERS CREATED_BY RIGHT OUTER JOIN
                      dbo.USERS MODIFIED_BY RIGHT OUTER JOIN
                      dbo.SCH_RESOURCES ON MODIFIED_BY.USER_ID = dbo.SCH_RESOURCES.MODIFIED_BY ON 
                      CREATED_BY.USER_ID = dbo.SCH_RESOURCES.CREATED_BY LEFT OUTER JOIN
                      dbo.LOOKUPS REASON_TYPE ON dbo.SCH_RESOURCES.REASON_TYPE_ID = REASON_TYPE.LOOKUP_ID ON 
                      RES_STATUS_TYPE.LOOKUP_ID = dbo.SCH_RESOURCES.RES_STATUS_TYPE_ID ON 
                      dbo.JOBS.JOB_ID = dbo.SCH_RESOURCES.JOB_ID LEFT OUTER JOIN
                      dbo.SERVICES ON dbo.SCH_RESOURCES.SERVICE_ID = dbo.SERVICES.SERVICE_ID ON 
                      FOREMAN_USER.USER_ID = dbo.RESOURCES.USER_ID FULL OUTER JOIN
                      dbo.RESOURCES_V ON dbo.SCH_RESOURCES.RESOURCE_ID = dbo.RESOURCES_V.RESOURCE_ID
UNION
SELECT     CAST(dbo.RESOURCES_V.RESOURCE_ID AS varchar(30)) + ':' AS res_sch_id, dbo.RESOURCES_V.RESOURCE_ID, NULL SCH_RESOURCE_ID, NULL 
                      WEEKEND_SCH_RESOURCE_ID, NULL JOB_ID, NULL JOB_NO, NULL SERVICE_ID, NULL SERVICE_NO, NULL HIDDEN_SERVICE_ID, NULL 
                      JOB_TYPE_ID, NULL job_type_code, NULL job_type_name, NULL RES_STATUS_TYPE_ID, NULL res_status_type_code, NULL 
                      res_status_type_name, NULL REASON_TYPE_ID, NULL reason_type_code, NULL reason_type_name, 'N' sch_foreman_flag, 
                      'N' send_to_pda_flag, NULL 
                      RES_START_DATE, NULL RES_START_TIME, NULL RES_END_DATE, NULL DATE_CONFIRMED, NULL RESOURCE_QTY, NULL SCH_NOTES, 
                      'N' weekend_flag, NULL sch_date_created, NULL sch_created_by, NULL sch_created_by_name, NULL sch_date_modified, NULL 
                      sch_modified_by, NULL sch_modified_by_name, dbo.RESOURCES_V.NAME AS resource_name, dbo.RESOURCES_V.RES_CATEGORY_TYPE_ID, 
                      dbo.RESOURCES_V.res_cat_type_code, dbo.RESOURCES_V.res_cat_type_name, dbo.RESOURCES_V.RESOURCE_TYPE_ID, 
                      dbo.RESOURCES_V.resource_type_code, dbo.RESOURCES_V.resource_type_name, dbo.RESOURCES_V.UNIQUE_FLAG, dbo.RESOURCES_V.NOTES, 
                      dbo.RESOURCES_V.PIN, dbo.RESOURCES_V.FOREMAN_FLAG, dbo.RESOURCES_V.ACTIVE_FLAG, dbo.RESOURCES_V.EXT_VENDOR_ID, 
                      dbo.RESOURCES_V.employment_type_name, dbo.RESOURCES_V.employment_type_code, dbo.RESOURCES_V.EMPLOYMENT_TYPE_ID, 
                      dbo.RESOURCES_V.USER_ID, dbo.JOBS.FOREMAN_RESOURCE_ID, FOREMAN_USER.USER_ID AS FOREMAN_USER_ID, 
                      dbo.RESOURCES_V.user_full_name, dbo.RESOURCES_V.user_contact_id, dbo.RESOURCES_V.user_contact_name, 
                      dbo.RESOURCES_V.modified_by_name AS res_modified_by_name, dbo.RESOURCES_V.MODIFIED_BY AS res_modified_by, 
                      dbo.RESOURCES_V.DATE_MODIFIED AS res_date_modified, dbo.RESOURCES_V.created_by_name AS res_created_by_name, 
                      dbo.RESOURCES_V.CREATED_BY AS res_created_by, dbo.RESOURCES_V.DATE_CREATED AS res_date_created, NULL res_start_time_only, NULL 
                      res_end_time, 'N' unconfirmed_flag
FROM         dbo.USERS FOREMAN_USER RIGHT OUTER JOIN
                      dbo.LOOKUPS JOB_TYPES RIGHT OUTER JOIN
                      dbo.JOBS ON JOB_TYPES.LOOKUP_ID = dbo.JOBS.JOB_TYPE_ID LEFT OUTER JOIN
                      dbo.RESOURCES ON dbo.JOBS.FOREMAN_RESOURCE_ID = dbo.RESOURCES.RESOURCE_ID RIGHT OUTER JOIN
                      dbo.LOOKUPS RES_STATUS_TYPE RIGHT OUTER JOIN
                      dbo.USERS CREATED_BY RIGHT OUTER JOIN
                      dbo.USERS MODIFIED_BY RIGHT OUTER JOIN
                      dbo.SCH_RESOURCES ON MODIFIED_BY.USER_ID = dbo.SCH_RESOURCES.MODIFIED_BY ON 
                      CREATED_BY.USER_ID = dbo.SCH_RESOURCES.CREATED_BY LEFT OUTER JOIN
                      dbo.LOOKUPS REASON_TYPE ON dbo.SCH_RESOURCES.REASON_TYPE_ID = REASON_TYPE.LOOKUP_ID ON 
                      RES_STATUS_TYPE.LOOKUP_ID = dbo.SCH_RESOURCES.RES_STATUS_TYPE_ID ON 
                      dbo.JOBS.JOB_ID = dbo.SCH_RESOURCES.JOB_ID LEFT OUTER JOIN
                      dbo.SERVICES ON dbo.SCH_RESOURCES.SERVICE_ID = dbo.SERVICES.SERVICE_ID ON 
                      FOREMAN_USER.USER_ID = dbo.RESOURCES.USER_ID FULL OUTER JOIN
                      dbo.RESOURCES_V ON dbo.SCH_RESOURCES.RESOURCE_ID = dbo.RESOURCES_V.RESOURCE_ID
GO
/****** Object:  View [dbo].[NON_SYNC_FOREMAN_V]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[NON_SYNC_FOREMAN_V]
AS
SELECT     TOP 100 PERCENT dbo.JOBS_V.ORGANIZATION_ID, dbo.JOBS_V.JOB_NO, dbo.USERS.FULL_NAME AS employee_name, 
                      dbo.USERS.EXT_EMPLOYEE_ID, dbo.SCH_RESOURCE_DATES_V.exploded_date, dbo.USERS.LAST_SYNCH_DATE, GETDATE() AS todays_date
FROM         dbo.RESOURCES LEFT OUTER JOIN
                      dbo.USERS ON dbo.RESOURCES.USER_ID = dbo.USERS.USER_ID RIGHT OUTER JOIN
                      dbo.SCH_RESOURCES ON dbo.RESOURCES.RESOURCE_ID = dbo.SCH_RESOURCES.RESOURCE_ID AND 
                      dbo.RESOURCES.RESOURCE_ID = dbo.SCH_RESOURCES.RESOURCE_ID RIGHT OUTER JOIN
                      dbo.SCH_RESOURCE_DATES_V LEFT OUTER JOIN
                      dbo.JOBS_V ON dbo.SCH_RESOURCE_DATES_V.JOB_ID = dbo.JOBS_V.JOB_ID ON 
                      dbo.SCH_RESOURCES.SCH_RESOURCE_ID = dbo.SCH_RESOURCE_DATES_V.SCH_RESOURCE_ID
WHERE     (CONVERT(varchar(12), GETDATE(), 101) = dbo.SCH_RESOURCE_DATES_V.exploded_date) AND (CONVERT(varchar(12), 
                      dbo.USERS.LAST_SYNCH_DATE, 101) <> CONVERT(varchar(12), GETDATE(), 101))
GO
/****** Object:  View [dbo].[workorder_progress_v]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[workorder_progress_v]
AS
SELECT organization_id, 
       project_id, 
       request_id, 
       project_no, 
       request_no, 
       workorder_no, 
       project_status_type_id, 
       project_status_type_code,
       project_status_type_name, 
       request_status_type_id, 
       request_status_type_code, 
       request_status_type_name, 
       approved_seq_no, 
       request_seq_no, 
       request_type_id, 
       request_type_code, 
       request_type_name, 
       ext_dealer_id, 
       dealer_name, 
       customer_id, 
       parent_customer_id, 
       customer_name, 
       end_user_id,
       end_user_name,
       job_name, 
       dealer_po_no, 
       customer_po_no, 
       priority,
       sum_estimated_cost,
       sum_total_cost, 
       sum_visit_count,
       date_created, 
       created_by,
       created_by_name,
       date_modified,
       modified_by,
       modified_by_name,
       vendor_count, 
       punchlist_flag, 
       vendor_complete_count,
       min_invoice_date,
       ISNULL(min_act_start_date, ISNULL(min_sch_start_date, min_est_start_date)) AS min_start_date, 
       ISNULL(max_act_end_date, ISNULL(max_sch_end_date, max_est_end_date)) AS max_end_date, 
       GETDATE() AS cur_date, 
       CAST(DATEDIFF(hour, GETDATE(), ISNULL(max_act_end_date, ISNULL(max_sch_end_date, max_est_end_date)) + 1) AS numeric) AS cur_duration_left, 
       CASE CAST(DATEDIFF(hour, ISNULL(min_act_start_date, ISNULL(min_sch_start_date, min_est_start_date)), ISNULL(max_act_end_date, ISNULL(max_sch_end_date, max_est_end_date)) + 1) AS numeric) 
         WHEN 0 THEN NULL 
         ELSE CAST(DATEDIFF(hour, ISNULL(min_act_start_date, ISNULL(min_sch_start_date, min_est_start_date)), ISNULL(max_act_end_date, ISNULL(max_sch_end_date, max_est_end_date)) + 1) AS numeric) 
         END AS duration
  FROM dbo.REQUEST_VENDOR_TOTALS_V
GO
/****** Object:  View [dbo].[CHECKLISTS_V]    Script Date: 05/03/2010 14:18:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[CHECKLISTS_V]
AS
SELECT     dbo.PROJECTS_ALL_REQUESTS_V.ORGANIZATION_ID, dbo.CHECKLISTS.CHECKLIST_ID, dbo.PROJECTS_ALL_REQUESTS_V.PROJECT_ID,
                      dbo.CHECKLISTS.REQUEST_ID, dbo.PROJECTS_ALL_REQUESTS_V.record_no, dbo.CHECKLISTS.NUM_STATIONS, dbo.CHECKLISTS.DATE_CREATED,
                      dbo.CHECKLISTS.CREATED_BY, CREATED_BY.FIRST_NAME + ' ' + CREATED_BY.LAST_NAME AS created_by_name,
                      dbo.CHECKLISTS.DATE_MODIFIED, UPDATED_BY.FIRST_NAME + ' ' + UPDATED_BY.LAST_NAME AS modified_by_name
FROM         dbo.CHECKLISTS INNER JOIN
                      dbo.PROJECTS_ALL_REQUESTS_V ON dbo.CHECKLISTS.REQUEST_ID = dbo.PROJECTS_ALL_REQUESTS_V.record_id LEFT OUTER JOIN
                      dbo.USERS CREATED_BY ON dbo.CHECKLISTS.CREATED_BY = CREATED_BY.USER_ID LEFT OUTER JOIN
                      dbo.USERS UPDATED_BY ON dbo.CHECKLISTS.MODIFIED_BY = UPDATED_BY.USER_ID
WHERE     (dbo.PROJECTS_ALL_REQUESTS_V.record_type_code = 'service_request')
GO

/****** Object:  View [dbo].[PROJECT_QUOTES_V]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[PROJECT_QUOTES_V]  
AS  SELECT p_v.project_id,   
       p_v.project_no,  
       r.request_id,   
       r.request_no,   
       q_v.quote_id,   
       q_v.quote_no,   
  CONVERT(VARCHAR, p_v.project_no) + '-' + CONVERT(VARCHAR, q_v.quote_no) + '.' + ISNULL(CONVERT(VARCHAR, q_v.version),' ') AS record_no,   
       q_v.quote_id record_id,   
       q_v.quote_no AS record_seq_no,   
       1 version_no,   
       1 max_version_no,   
       q_v.request_type_id AS record_type_id,   
       q_v.request_type_code AS record_type_code,   
       q_v.request_type_name AS record_type_name,   
       q_v.request_type_sequence_no AS record_type_seq_no,   
       q_v.quote_status_type_id record_status_type_id,   
       q_v.quote_status_type_code AS record_status_type_code,   
       q_v.quote_status_type_name AS record_status_type_name,   
       q_v.is_sent AS record_is_sent,   
       ISNULL(q_v.date_modified, q_v.date_created) AS record_date,   
       q_v.date_created AS record_created,   
       q_v.date_modified AS record_modified,   
       p_v.project_status_type_id,    
       p_v.project_status_type_code,   
       p_v.project_status_type_name,  
       p_v.customer_id,   
       p_v.parent_customer_id,   
       p_v.organization_id,   
       p_v.ext_dealer_id,   
       p_v.dealer_name,   
       p_v.ext_customer_id,   
       p_v.customer_name,  
       p_v.end_user_name,  
       p_v.refusal_email_info,   
       p_v.survey_location,   
       p_v.job_name,          
       r.quote_request_id,         
       r.request_type_id,   
       request_type.code AS request_type_code,   
       request_type.name AS request_type_name,   
       r.request_status_type_id,   
       request_status_type.code AS request_status_type_code,   
       request_status_type.name AS request_status_type_name,   
       r.is_sent AS request_is_sent,   
       r.dealer_po_no,   
       r.customer_po_no,   
       r.dealer_project_no,   
       r.design_project_no,   
       r.est_start_date,   
       CONVERT(VARCHAR(12), r.est_start_date, 101) AS est_start_date_varchar,  
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
       r.a_m_install_sup_contact_id,   
       r.a_d_designer_contact_id,    
       r.gen_contractor_contact_id,    
       r.electrician_contact_id,   
       r.data_phone_contact_id,   
       r.phone_contact_id,   
       r.carpet_layer_contact_id,   
       r.bldg_mgr_contact_id,   
       r.security_contact_id,   
       r.mover_contact_id,   
       r.other_contact_id,   
       r.furniture1_contact_id,   
       r.furniture2_contact_id,  
       r.is_quoted,   
       r.description,   
       r.approver_contact_id,   
       r.alt_customer_contact_id,  
       q_v.is_sent AS quote_is_sent,   
       q_v.quote_type_id,   
       q_v.quote_type_code,   
       q_v.quote_type_name,   
       q_v.quote_status_type_id,   
       q_v.quote_status_type_code,   
       q_v.quote_status_type_name,   
       q_v.date_quoted,   
       q_v.quote_total,   
       q_v.quoted_by_user_id,   
       q_v.quoted_by_user_name,  
       p_v.is_new  
  FROM dbo.projects_v2 p_v INNER JOIN  
       dbo.requests r ON p_v.project_id = r.project_id INNER JOIN  
       dbo.lookups request_type ON r.request_type_id = request_type.lookup_id INNER JOIN    
       dbo.lookups request_status_type ON r.request_status_type_id = request_status_type.lookup_id INNER JOIN  
       dbo.quotes_v q_v  ON r.request_id = q_v.request_id   
 WHERE quote_id IS NOT NULL
GO
/****** Object:  View [dbo].[quick_request_vendors_v]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[quick_request_vendors_v]
AS
SELECT CONVERT(VARCHAR, p.project_no) + '-' + CONVERT(VARCHAR, r.request_no) AS project_request_no,
       r.request_id, 
       r.request_no, 
       p.project_id, 
       p.project_no, 
       c.organization_id, 
       p.job_name, 
       helper.min_sch_start_date, 
       helper.min_act_start_date, 
       helper.max_sch_start_date, 
       helper.max_act_end_date, 
       ISNULL(helper.vendor_count, 0) AS vendor_count, 
       ISNULL(helper.vendor_complete_count, 0) AS vendor_complete_count, 
       ISNULL(helper.vendor_invoiced_count, 0) AS vendor_invoiced_count, 
       r.customer_po_no, 
       r.dealer_po_no, 
       r.dealer_project_no, 
       r.est_start_date, 
       r.description, 
       r.is_quoted, 
       r.date_created AS record_created,  
       r.date_modified AS record_last_modified,     
       r.d_designer_contact_id, 
       r.d_proj_mgr_contact_id, 
       r.d_sales_sup_contact_id, 
       r.d_sales_rep_contact_id, 
       r.alt_customer_contact_id, 
       r.customer_contact_id, 
       r.a_m_contact_id,  
       CASE WHEN customer_type.code = 'end_user' THEN c.end_user_parent_id ELSE c.customer_id END customer_id,
       CASE WHEN customer_type.code = 'end_user' THEN (SELECT customer_name FROM customers WHERE customer_id=c.end_user_parent_id) ELSE c.customer_name END customer_name,
       CASE WHEN customer_type.code = 'end_user' THEN c.customer_id ELSE eu.customer_id END end_user_id,
       CASE WHEN customer_type.code = 'end_user' THEN c.customer_name ELSE eu.customer_name END end_user_name,
       c.parent_customer_id, 
       CASE WHEN customer_type.code = 'dealer' THEN ISNULL(c.ext_customer_id, c.ext_dealer_id) ELSE c.ext_dealer_id END ext_dealer_id, 
       c.dealer_name, 
       request_type.code AS record_type_code, 
       request_type.name AS record_type_name, 
       request_type.sequence_no AS record_type_seq_no, 
       request_status.code AS record_status_code, 
       request_status.name AS record_status_name, 
       request_status.sequence_no AS record_status_seq_no, 
       project_status.code AS project_status_code, 
       project_status.name AS project_status_name
  FROM dbo.requests r INNER JOIN
       dbo.lookups request_status ON r.request_status_type_id = request_status.lookup_id INNER JOIN
       dbo.lookups request_type ON r.request_type_id = request_type.lookup_id INNER JOIN
       dbo.projects p ON r.project_id = p.project_id INNER JOIN
       dbo.lookups project_status ON p.project_status_type_id = project_status.lookup_id INNER JOIN
       dbo.customers c ON p.customer_id = c.customer_id INNER JOIN
       dbo.lookups customer_type ON c.customer_type_id = customer_type.lookup_id LEFT OUTER JOIN
       dbo.customers eu ON p.end_user_id = eu.customer_id LEFT OUTER JOIN
       dbo.QUICK_REQUEST_VENDORS_HELPER_V helper ON r.request_id = helper.request_id
 WHERE request_type.code='workorder' 
   AND request_status.code <> 'closed'
GO
/****** Object:  View [dbo].[pkt_sch_jobs_v]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[pkt_sch_jobs_v]
AS
SELECT j.job_id, 
       j.job_no, 
       j.job_name, 
       c.customer_name AS customer, 
       ISNULL(CASE WHEN customer_type.code='dealer' THEN eu.customer_name ELSE c.customer_name END, '') end_user_name,
       c.dealer_name AS dealer, 
       pjur_v.user_id
  FROM dbo.jobs j INNER JOIN
       dbo.customers c ON j.customer_id = c.customer_id INNER JOIN
       dbo.lookups job_status_type ON j.job_status_type_id = job_status_type.lookup_id INNER JOIN
       dbo.pkt_job_user_res_v pjur_v ON j.job_id = pjur_v.job_id INNER JOIN
       dbo.lookups customer_type ON c.customer_type_id = customer_type.lookup_id LEFT OUTER JOIN
       dbo.projects p ON j.project_id = p.project_id LEFT OUTER JOIN
       dbo.customers eu ON p.end_user_id = eu.customer_id
 WHERE job_status_type.code <> 'install_complete' 
   AND job_status_type.code <> 'invoiced' 
   AND job_status_type.code <> 'closed'
GO
/****** Object:  View [dbo].[crystal_SERVICE_REQ_V]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[crystal_SERVICE_REQ_V]
AS
SELECT     dbo.PROJECTS.PROJECT_ID, dbo.PROJECTS.PROJECT_NO AS JOB_NO, dbo.PROJECTS.CUSTOMER_ID, dbo.CUSTOMERS.CUSTOMER_NAME, 
                      dbo.PROJECTS.JOB_NAME, dbo.REQUESTS.REQUEST_NO AS REQ_NO, dbo.CUSTOMERS.DEALER_NAME, dbo.REQUESTS.CUSTOMER_PO_NO, 
                      dbo.REQUESTS.DEALER_PO_NO, dbo.REQUESTS.JOB_LOCATION_ID, dbo.JOB_LOCATIONS.JOB_LOCATION_NAME, dbo.JOB_LOCATIONS.STREET1, 
                      dbo.JOB_LOCATIONS.CITY, dbo.JOB_LOCATIONS.STATE, dbo.JOB_LOCATIONS.ZIP, dbo.REQUESTS.CUSTOMER_CONTACT_ID, 
                      CONTACTS_6.CONTACT_NAME AS Customer_Contact, CONTACTS_6.PHONE_WORK, CONTACTS_6.PHONE_CELL, 
                      dbo.REQUESTS.ALT_CUSTOMER_CONTACT_ID, CONTACTS_1.CONTACT_NAME AS ALT_CUST_NAME, 
                      CONTACTS_1.PHONE_WORK AS ALT_CUST_PHONE, CONTACTS_1.PHONE_CELL AS ALT_CUST_CELL, dbo.REQUESTS.D_SALES_REP_CONTACT_ID, 
                      CONTACTS_2.CONTACT_NAME AS DEALER_SALES_REP, CONTACTS_2.PHONE_WORK AS DEAL_SALES_PHONE, 
                      CONTACTS_2.PHONE_CELL AS DEAL_SALES_CELL, dbo.REQUESTS.D_SALES_SUP_CONTACT_ID, 
                      CONTACTS_3.CONTACT_NAME AS D_SALES_SUP_NAME, CONTACTS_3.PHONE_WORK AS D_SALES_SUP_PHONE, 
                      CONTACTS_3.PHONE_CELL AS D_SALES_SUP_CELL, dbo.REQUESTS.D_PROJ_MGR_CONTACT_ID, CONTACTS_4.CONTACT_NAME AS D_PROJ_MGR, 
                      CONTACTS_4.PHONE_WORK AS D_PROJ_MGR_PHONE, CONTACTS_4.PHONE_CELL AS D_PROJ_MGR_CELL, 
                      dbo.REQUESTS.D_DESIGNER_CONTACT_ID, CONTACTS_5.CONTACT_NAME AS D_DESIGN_REP, CONTACTS_5.PHONE_WORK AS D_DESIGN_PHONE, 
                      CONTACTS_5.PHONE_CELL AS D_DESIGN_CELL, dbo.REQUESTS.A_M_CONTACT_ID, CONTACTS_6.CONTACT_NAME AS AM_CONTACT, 
                      CONTACTS_6.PHONE_WORK AS AM_PHONE, CONTACTS_6.PHONE_CELL AS AM_CELL, dbo.REQUESTS.A_M_INSTALL_SUP_CONTACT_ID, 
                      CONTACTS_7.CONTACT_NAME AS AM_INSTALL, CONTACTS_7.PHONE_WORK AS AM_INSTALL_PHONE, 
                      CONTACTS_7.PHONE_CELL AS AM_INSTALL_CELL, LOOKUPS_12.NAME AS FIRST_FURN_LINE, LOOKUPS_12.ATTRIBUTE2 AS FIRST_FURN_TYPE, 
                      LOOKUPS_1.NAME AS SEC_FURN_LINE, LOOKUPS_1.ATTRIBUTE2 AS SEC_FURN_TYPE, LOOKUPS_2.NAME AS CASE_GOODS, 
                      LOOKUPS_3.NAME AS WOOD_PRODUCT, LOOKUPS_4.NAME AS DELIVERY_TYPE, dbo.REQUESTS.WAREHOUSE_LOC, 
                      LOOKUPS_5.NAME AS FURNITURE_PLAN, dbo.REQUESTS.PLAN_LOCATION, LOOKUPS_6.NAME AS FURNITURE_SPEC, 
                      LOOKUPS_7.NAME AS WKST_TYPICAL, dbo.REQUESTS.POWER_TYPE, LOOKUPS_8.NAME AS PUNCHLIST_ITEM, dbo.REQUESTS.PUNCHLIST_LINE, 
                      LOOKUPS_9.NAME AS WALL_MOUNT, dbo.REQUESTS.EST_START_DATE, dbo.REQUESTS.EST_START_TIME, dbo.REQUESTS.EST_END_DATE, 
                      dbo.REQUESTS.PROD_DEL_TO_WH_DATE, dbo.REQUESTS.TRUCK_ARRIVAL_TIME, dbo.REQUESTS.DESCRIPTION, 
                      LOOKUPS_10.NAME AS APPROVAL_REQ, dbo.REQUESTS.WHO_CAN_APPROVE_NAME, dbo.REQUESTS.WHO_CAN_APPROVE_PHONE, 
                      dbo.SITE_CONDITIONS_V.LOAD_DOCK_AVAIL, dbo.SITE_CONDITIONS_V.DOCK_AVAILABLE_TIME, dbo.SITE_CONDITIONS_V.DOCK_RESERV_REQ, 
                      dbo.SITE_CONDITIONS_V.SEMI_ACCESS, dbo.SITE_CONDITIONS_V.DOCK_HEIGHT, dbo.SITE_CONDITIONS_V.ELEVATOR_AVAIL, 
                      dbo.SITE_CONDITIONS_V.ELEVATOR_RESERV_REQ, dbo.SITE_CONDITIONS_V.SECURITY, dbo.SITE_CONDITIONS_V.MULTI_LEVEL, 
                      dbo.SITE_CONDITIONS_V.STAIR_CARRY, dbo.SITE_CONDITIONS_V.STAIR_CARRY_FLIGHTS, dbo.SITE_CONDITIONS_V.STAIR_CARRY_STAIRS, 
                      dbo.SITE_CONDITIONS_V.SMALLEST_DOOR_ELEV_WIDTH, dbo.SITE_CONDITIONS_V.FLOOR_PROTECT, dbo.SITE_CONDITIONS_V.WALL_PROTECT, 
                      dbo.SITE_CONDITIONS_V.DOORWAY_PROTECT, dbo.SITE_CONDITIONS_MORE_V.STAGING_AREA, dbo.SITE_CONDITIONS_MORE_V.DUMPSTER, 
                      dbo.SITE_CONDITIONS_MORE_V.ELEVATOR_AVAIL_TIME, dbo.SITE_CONDITIONS_MORE_V.WALKBOARD, 
                      dbo.SITE_CONDITIONS_MORE_V.OCC_SITE, dbo.SITE_CONDITIONS_MORE_V.NEW_SITE, 
                      dbo.SITE_CONDITIONS_MORE_V.OTHER_CONDITIONS
FROM         dbo.JOB_LOCATIONS RIGHT OUTER JOIN
                      dbo.SITE_CONDITIONS_V INNER JOIN
                      dbo.PROJECTS INNER JOIN
                      dbo.CUSTOMERS ON dbo.PROJECTS.CUSTOMER_ID = dbo.CUSTOMERS.CUSTOMER_ID ON 
                      dbo.SITE_CONDITIONS_V.PROJECT_ID = dbo.PROJECTS.PROJECT_ID INNER JOIN
                      dbo.SITE_CONDITIONS_MORE_V ON dbo.PROJECTS.PROJECT_ID = dbo.SITE_CONDITIONS_MORE_V.PROJECT_ID INNER JOIN
                      dbo.REQUESTS ON dbo.PROJECTS.PROJECT_ID = dbo.REQUESTS.PROJECT_ID LEFT OUTER JOIN
                      dbo.LOOKUPS LOOKUPS_3 ON dbo.REQUESTS.WOOD_PRODUCT_TYPE_ID = LOOKUPS_3.LOOKUP_ID LEFT OUTER JOIN
                      dbo.LOOKUPS LOOKUPS_12 ON dbo.REQUESTS.PRI_FURN_LINE_TYPE_ID = LOOKUPS_12.LOOKUP_ID LEFT OUTER JOIN
                      dbo.CONTACTS CONTACTS_6 ON dbo.REQUESTS.A_M_CONTACT_ID = CONTACTS_6.CONTACT_ID ON 
                      dbo.JOB_LOCATIONS.JOB_LOCATION_ID = dbo.REQUESTS.JOB_LOCATION_ID LEFT OUTER JOIN
                      dbo.LOOKUPS LOOKUPS_2 ON dbo.REQUESTS.CASE_FURN_LINE_TYPE_ID = LOOKUPS_2.LOOKUP_ID LEFT OUTER JOIN
                      dbo.LOOKUPS LOOKUPS_4 ON dbo.REQUESTS.DELIVERY_TYPE_ID = LOOKUPS_4.LOOKUP_ID LEFT OUTER JOIN
                      dbo.LOOKUPS LOOKUPS_5 ON dbo.REQUESTS.FURN_PLAN_TYPE_ID = LOOKUPS_5.LOOKUP_ID LEFT OUTER JOIN
                      dbo.LOOKUPS LOOKUPS_6 ON dbo.REQUESTS.FURN_SPEC_TYPE_ID = LOOKUPS_6.LOOKUP_ID LEFT OUTER JOIN
                      dbo.LOOKUPS LOOKUPS_7 ON dbo.REQUESTS.WORKSTATION_TYPICAL_TYPE_ID = LOOKUPS_7.LOOKUP_ID LEFT OUTER JOIN
                      dbo.LOOKUPS LOOKUPS_8 ON dbo.REQUESTS.PUNCHLIST_ITEM_TYPE_ID = LOOKUPS_8.LOOKUP_ID LEFT OUTER JOIN
                      dbo.LOOKUPS LOOKUPS_9 ON dbo.REQUESTS.WALL_MOUNT_TYPE_ID = LOOKUPS_9.LOOKUP_ID LEFT OUTER JOIN
                      dbo.LOOKUPS LOOKUPS_10 ON dbo.REQUESTS.APPROVAL_REQ_TYPE_ID = LOOKUPS_10.LOOKUP_ID LEFT OUTER JOIN
                      dbo.CONTACTS CONTACTS_7 ON dbo.REQUESTS.A_M_INSTALL_SUP_CONTACT_ID = CONTACTS_7.CONTACT_ID LEFT OUTER JOIN
                      dbo.CONTACTS CONTACTS_3 ON dbo.REQUESTS.D_SALES_SUP_CONTACT_ID = CONTACTS_3.CONTACT_ID LEFT OUTER JOIN
                      dbo.LOOKUPS LOOKUPS_1 ON dbo.REQUESTS.SEC_FURN_LINE_TYPE_ID = LOOKUPS_1.LOOKUP_ID LEFT OUTER JOIN
                      dbo.CONTACTS CONTACTS_5 ON dbo.REQUESTS.D_DESIGNER_CONTACT_ID = CONTACTS_5.CONTACT_ID LEFT OUTER JOIN
                      dbo.CONTACTS CONTACTS_8 ON dbo.REQUESTS.CUSTOMER_CONTACT_ID = CONTACTS_8.CONTACT_ID LEFT OUTER JOIN
                      dbo.CONTACTS CONTACTS_2 ON dbo.REQUESTS.D_SALES_REP_CONTACT_ID = CONTACTS_2.CONTACT_ID LEFT OUTER JOIN
                      dbo.CONTACTS CONTACTS_4 ON dbo.REQUESTS.D_PROJ_MGR_CONTACT_ID = CONTACTS_4.CONTACT_ID LEFT OUTER JOIN
                      dbo.CONTACTS CONTACTS_1 ON dbo.REQUESTS.ALT_CUSTOMER_CONTACT_ID = CONTACTS_1.CONTACT_ID LEFT OUTER JOIN
                      dbo.LOOKUPS LOOKUPS_11 ON dbo.REQUESTS.PRI_FURN_LINE_TYPE_ID = LOOKUPS_11.LOOKUP_ID
GO
/****** Object:  View [dbo].[QUICK_QUOTE_REQUESTS_V]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   VIEW [dbo].[QUICK_QUOTE_REQUESTS_V] 
as
SELECT     dbo.quick_requests_v.*, dbo.CONTACTS.CONTACT_NAME AS A_M_CONTACT_NAME, CASE WHEN EXISTS
                          (SELECT     r.request_id
                            FROM          requests r
                            WHERE      quote_request_id = quick_requests_v.request_id) THEN 'Y' ELSE 'N' END AS HAS_SERVICE_REQUEST
FROM         dbo.quick_requests_v LEFT OUTER JOIN
                      dbo.CONTACTS ON dbo.quick_requests_v.A_M_CONTACT_ID = dbo.CONTACTS.CONTACT_ID
GO

/****** Object:  View [dbo].[crystal_VAR_JOB_INVOICED_V]    Script Date: 05/03/2010 14:18:06 ******/
-- SET ANSI_NULLS ON
-- GO
-- SET QUOTED_IDENTIFIER ON
-- GO
-- CREATE VIEW [dbo].[crystal_VAR_JOB_INVOICED_V]
-- AS
-- SELECT     TOP 100 PERCENT dbo.JOBS.JOB_ID, SUM(ISNULL(dbo.INVOICE_LINES.UNIT_PRICE, 0) * ISNULL(dbo.INVOICE_LINES.QTY, 0)) AS sum_inv,
--                       MIN(CAST(dbo.INVOICES.DATE_SENT AS datetime)) AS min_date_sent, MAX(dbo.INVOICES.DATE_SENT) AS max_date_sent,
--                       dbo.INVOICES.INVOICE_ID
-- FROM         dbo.JOBS RIGHT OUTER JOIN
--                       dbo.INVOICE_LINES RIGHT OUTER JOIN
--                       dbo.INVOICES ON dbo.INVOICE_LINES.INVOICE_ID = dbo.INVOICES.INVOICE_ID ON dbo.JOBS.JOB_ID = dbo.INVOICES.JOB_ID
-- WHERE     (dbo.INVOICES.STATUS_ID > 3)
-- GROUP BY dbo.JOBS.JOB_ID, dbo.INVOICES.INVOICE_ID
-- HAVING      (SUM(ISNULL(dbo.INVOICE_LINES.UNIT_PRICE, 0) * ISNULL(dbo.INVOICE_LINES.QTY, 0)) > 0)
-- ORDER BY dbo.JOBS.JOB_ID
-- GO


/****** Object:  View [dbo].[crystal_VAR_REPORT_SUMMARY_V]    Script Date: 05/03/2010 14:18:06 ******/
-- SET ANSI_NULLS ON
-- GO
-- SET QUOTED_IDENTIFIER OFF
-- GO
-- CREATE VIEW [dbo].[crystal_VAR_REPORT_SUMMARY_V]
-- AS
-- SELECT
-- 	dbo.JOBS_V.ORGANIZATION_ID,
-- 	dbo.JOBS_V.JOB_ID,
-- 	dbo.JOBS_V.EXT_DEALER_ID,
-- 	dbo.JOBS_V.CUSTOMER_ID,
-- 	dbo.JOBS_V.CUSTOMER_NAME,
-- 	dbo.JOBS_V.JOB_NO,
-- 	dbo.JOBS_V.DEALER_NAME,
-- 	dbo.JOBS_V.JOB_NAME,
-- 	cast(dbo.JOBS_V.billing_user_name as varchar) as JOB_OWNER,
-- 	dbo.JOBS_V.JOB_TYPE_CODE,
-- 	dbo.JOBS_V.FOREMAN_RESOURCE_ID,
-- 	dbo.JOBS_V.BILLING_USER_ID,
-- 	cast (dbo.VAR_JOB_INVOICED_V.min_date_sent as smalldatetime (8)) as start_date,
-- 	cast (dbo.VAR_JOB_INVOICED_V.max_date_sent as smalldatetime (8)) as end_date,
-- 	dbo.VAR_JOB_INVOICED_V.sum_inv,
-- 	dbo.VAR_JOB_TIME_EXP_V.sum_time_exp,
-- 	dbo.VAR_JOB_TIME_EXP_V.sum_time,
-- 	dbo.VAR_JOB_TIME_EXP_V.sum_exp,
-- 	dbo.VAR_JOB_QUOTED_V.sum_quote,
-- 	dbo.VAR_JOB_ACT_HOURS_V.sum_payroll_qty,
-- 	dbo.VAR_JOB_EST_HOURS_V.sum_estimated_hours,
--
-- 	(CAST(ISNULL(dbo.VAR_JOB_INVOICED_V.sum_inv,0) AS money) - CAST(ISNULL(dbo.VAR_JOB_TIME_EXP_V.sum_time_exp,0) AS money)) AS sum_inv_var,
-- 	(CASE ISNULL(dbo.VAR_JOB_INVOICED_V.sum_inv,0) WHEN 0 THEN 0 ELSE
-- 		(CAST(ISNULL(dbo.VAR_JOB_INVOICED_V.sum_inv,0) AS money) - CAST(ISNULL(dbo.VAR_JOB_TIME_EXP_V.sum_time_exp,0) AS money))
-- 		/ CAST(dbo.VAR_JOB_INVOICED_V.sum_inv AS MONEY) END) AS sum_inv_var_percent,
--
-- 	(CAST(dbo.VAR_JOB_QUOTED_V.sum_quote AS MONEY) - CAST(dbo.VAR_JOB_TIME_EXP_V.sum_time_exp AS MONEY)) AS sum_q_te_var,
-- 	(CASE ISNULL(dbo.VAR_JOB_TIME_EXP_V.sum_time_exp,0) WHEN 0 THEN 0 ELSE
-- 		(CAST(dbo.VAR_JOB_QUOTED_V.sum_quote AS money) - CAST(dbo.VAR_JOB_TIME_EXP_V.sum_time_exp AS MONEY))
-- 		/ CAST(dbo.VAR_JOB_TIME_EXP_V.sum_time_exp AS MONEY) END) AS sum_q_te_var_percent,
--
-- 	(CAST(dbo.VAR_JOB_INVOICED_V.sum_inv AS MONEY) - CAST(dbo.VAR_JOB_QUOTED_V.sum_quote AS MONEY))  AS sum_inv_q_var,
-- 	(CASE ISNULL(dbo.VAR_JOB_INVOICED_V.sum_inv,0) WHEN 0 THEN 0 ELSE
-- 		(CAST(dbo.VAR_JOB_INVOICED_V.sum_inv AS MONEY) - CAST(dbo.VAR_JOB_QUOTED_V.sum_quote AS MONEY))
-- 		/ CAST(dbo.VAR_JOB_INVOICED_V.sum_inv AS MONEY) END) AS sum_inv_q_var_percent,
--
-- 	CAST((CAST(ISNULL(dbo.VAR_JOB_EST_HOURS_V.sum_estimated_hours,0) as DECIMAL) - CAST(ISNULL(dbo.VAR_JOB_ACT_HOURS_V.sum_payroll_qty,0) AS DECIMAL)) as numeric(18,2)) AS sum_est_act_hours_var,
-- 	(CASE ISNULL(dbo.VAR_JOB_ACT_HOURS_V.sum_payroll_qty,0) WHEN 0 THEN 0 ELSE
-- 		(CAST(ISNULL(dbo.VAR_JOB_EST_HOURS_V.sum_estimated_hours,0) AS DECIMAL)  - CAST(ISNULL(dbo.VAR_JOB_ACT_HOURS_V.sum_payroll_qty,0) AS DECIMAL))
-- 		/ CAST(dbo.VAR_JOB_ACT_HOURS_V.sum_payroll_qty AS DECIMAL) END) AS sum_est_act_hours_var_percent
--
-- FROM         dbo.VAR_JOB_QUOTED_V RIGHT OUTER JOIN
--                       dbo.JOBS_V INNER JOIN
--                       dbo.VAR_JOB_INVOICED_V ON dbo.JOBS_V.JOB_ID = dbo.VAR_JOB_INVOICED_V.JOB_ID LEFT OUTER JOIN
--                       dbo.VAR_JOB_TIME_EXP_V ON dbo.JOBS_V.JOB_ID = dbo.VAR_JOB_TIME_EXP_V.JOB_ID ON
--                       dbo.VAR_JOB_QUOTED_V.JOB_ID = dbo.JOBS_V.JOB_ID LEFT OUTER JOIN
--                       dbo.VAR_JOB_ACT_HOURS_V ON dbo.JOBS_V.JOB_ID = dbo.VAR_JOB_ACT_HOURS_V.JOB_ID LEFT OUTER JOIN
--                       dbo.VAR_JOB_EST_HOURS_V ON dbo.JOBS_V.JOB_ID = dbo.VAR_JOB_EST_HOURS_V.JOB_ID
-- GO
/****** Object:  View [dbo].[DOCS_CURRENT_V]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[DOCS_CURRENT_V]
AS
SELECT     *
FROM         dbo.DOCUMENTS_V dv
WHERE     (VERSION_ID =
                          (SELECT     version_id
                            FROM          versions
                            WHERE      document_id = dv.document_id AND date_created =
                                                       (SELECT     MAX(date_created)
                                                         FROM          versions
                                                         WHERE      document_id = dv.document_id)))
GO
/****** Object:  View [dbo].[HOURS_BY_PAYCODE_V]    Script Date: 05/03/2010 14:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[HOURS_BY_PAYCODE_V]
AS
SELECT     ORGANIZATION_ID, TC_JOB_ID, TC_JOB_NO, TC_SERVICE_ID, TC_SERVICE_NO, SERVICE_LINE_DATE, EXT_EMPLOYEE_ID, employee_name, 
                      PAYROLL_QTY, EXT_PAY_CODE, USER_ID
FROM         dbo.PAYROLL_V
WHERE     (ORGANIZATION_ID IS NOT NULL)
GO
/****** Object:  View [dbo].[RESOURCE_ITEMS_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[RESOURCE_ITEMS_V]  
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
GO
/****** Object:  View [dbo].[ROLE_FUNCTION_RIGHTS_ALL_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ROLE_FUNCTION_RIGHTS_ALL_V]
AS
SELECT     dbo.ROLE_FUNCTIONS_ALL_V.ROLE_ID, dbo.ROLE_FUNCTIONS_ALL_V.role_name, dbo.ROLE_FUNCTIONS_ALL_V.FUNCTION_ID, 
                      dbo.ROLE_FUNCTIONS_ALL_V.function_name, dbo.ROLE_FUNCTIONS_ALL_V.function_code, dbo.ROLE_FUNCTIONS_ALL_V.function_desc, 
                      dbo.ROLE_FUNCTIONS_ALL_V.FUNCTION_GROUP_ID, dbo.ROLE_FUNCTIONS_ALL_V.function_group_code, 
                      dbo.ROLE_FUNCTIONS_ALL_V.function_group_name, dbo.ROLE_FUNCTIONS_ALL_V.TEMPLATE_ID, dbo.ROLE_FUNCTIONS_ALL_V.SEQUENCE_NO, 
                      dbo.ROLE_FUNCTIONS_ALL_V.IS_NAV_FUNCTION, dbo.ROLE_FUNCTIONS_ALL_V.IS_MENU_FUNCTION, dbo.ROLE_FUNCTIONS_ALL_V.TARGET, 
                      dbo.ROLE_FUNCTION_RIGHTS.ROLE_FUNCTION_RIGHT_ID, dbo.RIGHT_TYPES.RIGHT_TYPE_ID, dbo.RIGHT_TYPES.CODE AS right_type_code, 
                      dbo.RIGHT_TYPES.NAME AS right_type_name, dbo.RIGHT_TYPES.DESCRIPTION AS right_type_desc, 
                      dbo.ROLE_FUNCTIONS_ALL_V.function_date_created, dbo.ROLE_FUNCTIONS_ALL_V.function_created_by, 
                      dbo.ROLE_FUNCTIONS_ALL_V.function_date_modified, dbo.ROLE_FUNCTIONS_ALL_V.function_modified_by, 
                      dbo.FUNCTION_RIGHT_TYPES.UPDATABLE_FLAG AS right_updatable_flag, dbo.ROLE_FUNCTIONS_ALL_V.LOCATION, 
                      (CASE ISNULL(dbo.ROLE_FUNCTION_RIGHTS.ROLE_FUNCTION_RIGHT_ID, - 1) WHEN - 1 THEN 'N' ELSE 'Y' END) has_right
FROM         dbo.FUNCTION_RIGHT_TYPES INNER JOIN
                      dbo.ROLE_FUNCTIONS_ALL_V ON dbo.FUNCTION_RIGHT_TYPES.FUNCTION_ID = dbo.ROLE_FUNCTIONS_ALL_V.FUNCTION_ID LEFT OUTER JOIN
                      dbo.ROLE_FUNCTION_RIGHTS ON dbo.FUNCTION_RIGHT_TYPES.RIGHT_TYPE_ID = dbo.ROLE_FUNCTION_RIGHTS.RIGHT_TYPE_ID AND 
                      dbo.ROLE_FUNCTIONS_ALL_V.FUNCTION_ID = dbo.ROLE_FUNCTION_RIGHTS.FUNCTION_ID AND 
                      dbo.ROLE_FUNCTIONS_ALL_V.ROLE_ID = dbo.ROLE_FUNCTION_RIGHTS.ROLE_ID RIGHT OUTER JOIN
                      dbo.RIGHT_TYPES ON dbo.FUNCTION_RIGHT_TYPES.RIGHT_TYPE_ID = dbo.RIGHT_TYPES.RIGHT_TYPE_ID
GO
/****** Object:  View [dbo].[crystal_JOB_LOCATIONS_V]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[crystal_JOB_LOCATIONS_V]
AS
SELECT     TOP 100 PERCENT dbo.JOB_LOCATIONS_V.ORGANIZATION_ID, dbo.CUSTOMERS.CUSTOMER_ID, dbo.CUSTOMERS.EXT_CUSTOMER_ID, 
                      dbo.CUSTOMERS.CUSTOMER_NAME, dbo.CUSTOMERS.ACTIVE_FLAG, dbo.JOB_LOCATIONS_V.JOB_LOCATION_ID, 
                      dbo.JOB_LOCATIONS_V.JOB_LOCATION_NAME, dbo.JOB_LOCATIONS_V.LOCATION_TYPE_ID, dbo.JOB_LOCATIONS_V.location_type_code, 
                      dbo.JOB_LOCATIONS_V.location_type_name, dbo.JOB_LOCATIONS_V.STREET1, dbo.JOB_LOCATIONS_V.STREET2, dbo.JOB_LOCATIONS_V.CITY, 
                      dbo.JOB_LOCATIONS_V.STATE, dbo.JOB_LOCATIONS_V.ZIP, dbo.ORGANIZATIONS.NAME, dbo.CUSTOMERS.EXT_DEALER_ID, 
                      dbo.CUSTOMERS.DEALER_NAME, dbo.JOB_LOCATIONS_V.DATE_CREATED
FROM         dbo.JOB_LOCATIONS_V INNER JOIN
                      dbo.CUSTOMERS ON dbo.JOB_LOCATIONS_V.CUSTOMER_ID = dbo.CUSTOMERS.CUSTOMER_ID INNER JOIN
                      dbo.ORGANIZATIONS ON dbo.CUSTOMERS.ORGANIZATION_ID = dbo.ORGANIZATIONS.ORGANIZATION_ID
WHERE     (dbo.CUSTOMERS.EXT_DEALER_ID = '10001') AND (dbo.CUSTOMERS.ACTIVE_FLAG = 'y') OR
                      (dbo.CUSTOMERS.EXT_DEALER_ID = '10875') OR
                      (dbo.CUSTOMERS.EXT_DEALER_ID = '10002') OR
                      (dbo.CUSTOMERS.EXT_DEALER_ID = '10003') OR
                      (dbo.CUSTOMERS.EXT_DEALER_ID = '10000')
GO
/****** Object:  View [dbo].[crystal_SCH_ACT_1_V]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[crystal_SCH_ACT_1_V]
AS
SELECT     dbo.SCH_RESOURCE_DATES_V.SCH_RESOURCE_ID, dbo.SCH_RESOURCE_DATES_V.RESOURCE_ID, dbo.RESOURCES_V.resource_name, 
                      dbo.SCH_RESOURCE_DATES_V.JOB_ID, dbo.JOBS.JOB_NO, dbo.SCH_RESOURCE_DATES_V.SERVICE_ID, 
                      dbo.SCH_RESOURCE_DATES_V.RES_START_DATE, dbo.SCH_RESOURCE_DATES_V.RES_END_DATE, 
                      dbo.SCH_RESOURCE_DATES_V.exploded_date
FROM         dbo.SCH_RESOURCE_DATES_V INNER JOIN
                      dbo.RESOURCES_V ON dbo.SCH_RESOURCE_DATES_V.RESOURCE_ID = dbo.RESOURCES_V.RESOURCE_ID INNER JOIN
                      dbo.JOBS ON dbo.SCH_RESOURCE_DATES_V.JOB_ID = dbo.JOBS.JOB_ID
WHERE     (dbo.RESOURCES_V.resource_name IS NOT NULL)
GO
/****** Object:  View [dbo].[UNVERIFIED_HRS_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[UNVERIFIED_HRS_V]
AS
SELECT     dbo.TIME_CAPTURE_V.ORGANIZATION_ID, dbo.TIME_CAPTURE_V.TC_JOB_ID, dbo.TIME_CAPTURE_V.TC_SERVICE_ID, 
                      dbo.TIME_CAPTURE_V.SERVICE_LINE_ID, dbo.TIME_CAPTURE_V.TC_JOB_NO, dbo.TIME_CAPTURE_V.TC_SERVICE_NO, 
                      dbo.TIME_CAPTURE_V.TC_SERVICE_LINE_NO, dbo.JOBS_V.JOB_NAME, dbo.JOBS_V.FOREMAN_RESOURCE_ID, 
                      dbo.JOBS_V.foreman_resource_name, dbo.TIME_CAPTURE_V.SERVICE_LINE_DATE, dbo.TIME_CAPTURE_V.STATUS_ID, 
                      dbo.TIME_CAPTURE_V.status_name, dbo.TIME_CAPTURE_V.RESOURCE_ID, dbo.RESOURCES_V.USER_ID, dbo.RESOURCES_V.EXT_EMPLOYEE_ID, 
                      dbo.RESOURCES_V.user_full_name AS employee_name, dbo.TIME_CAPTURE_V.ITEM_NAME, dbo.TIME_CAPTURE_V.PAYROLL_QTY, 
                      dbo.TIME_CAPTURE_V.PAYROLL_TOTAL, dbo.TIME_CAPTURE_V.EXPENSE_QTY, dbo.TIME_CAPTURE_V.EXPENSE_RATE, 
                      dbo.TIME_CAPTURE_V.EXPENSE_TOTAL, dbo.TIME_CAPTURE_V.TC_TOTAL, dbo.TIME_CAPTURE_V.BILL_HOURLY_QTY, 
                      dbo.TIME_CAPTURE_V.BILL_HOURLY_RATE, dbo.TIME_CAPTURE_V.BILL_HOURLY_TOTAL, dbo.TIME_CAPTURE_V.BILL_EXP_QTY, 
                      dbo.TIME_CAPTURE_V.BILL_EXP_RATE, dbo.TIME_CAPTURE_V.BILL_EXP_TOTAL, dbo.TIME_CAPTURE_V.BILL_RATE, 
                      dbo.TIME_CAPTURE_V.BILL_TOTAL, dbo.TIME_CAPTURE_V.EXT_PAY_CODE
FROM         dbo.TIME_CAPTURE_V LEFT OUTER JOIN
                      dbo.RESOURCES_V ON dbo.TIME_CAPTURE_V.RESOURCE_ID = dbo.RESOURCES_V.RESOURCE_ID LEFT OUTER JOIN
                      dbo.JOBS_V ON dbo.TIME_CAPTURE_V.TC_JOB_ID = dbo.JOBS_V.JOB_ID
WHERE     (dbo.TIME_CAPTURE_V.STATUS_ID < 2)
GO
/****** Object:  View [dbo].[CHANGED_HRS_V]    Script Date: 05/03/2010 14:18:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[CHANGED_HRS_V]
AS
SELECT     dbo.BILLING_V.ORGANIZATION_ID, dbo.BILLING_V.BILL_JOB_ID, dbo.BILLING_V.BILL_JOB_NO, dbo.JOBS_V.JOB_NAME, 
                      dbo.JOBS_V.FOREMAN_RESOURCE_ID, dbo.JOBS_V.foreman_resource_name, dbo.BILLING_V.BILL_SERVICE_ID, dbo.BILLING_V.BILL_SERVICE_NO, 
                      dbo.BILLING_V.SERVICE_LINE_ID, dbo.BILLING_V.BILL_SERVICE_LINE_NO, dbo.BILLING_V.SERVICE_LINE_DATE, 
                      dbo.BILLING_V.SERVICE_LINE_DATE_VARCHAR, dbo.BILLING_V.STATUS_ID, dbo.BILLING_V.status_name, dbo.BILLING_V.RESOURCE_ID, 
                      dbo.RESOURCES_V.USER_ID, dbo.RESOURCES_V.EXT_EMPLOYEE_ID, dbo.RESOURCES_V.user_full_name AS employee_name, dbo.BILLING_V.POOLED_FLAG,
                      dbo.BILLING_V.ITEM_NAME, dbo.BILLING_V.PAYROLL_QTY, dbo.BILLING_V.BILL_HOURLY_QTY, dbo.BILLING_V.BILL_HOURLY_RATE, 
                      ISNULL(dbo.BILLING_V.PAYROLL_QTY, 0) - ISNULL(dbo.BILLING_V.BILL_HOURLY_QTY, 0) AS hours_difference
FROM         dbo.BILLING_V LEFT OUTER JOIN
                      dbo.RESOURCES_V ON dbo.BILLING_V.RESOURCE_ID = dbo.RESOURCES_V.RESOURCE_ID LEFT OUTER JOIN
                      dbo.JOBS_V ON dbo.BILLING_V.BILL_JOB_ID = dbo.JOBS_V.JOB_ID
WHERE     (ISNULL(dbo.BILLING_V.PAYROLL_QTY, 0) - ISNULL(dbo.BILLING_V.BILL_HOURLY_QTY, 0) <> 0)
GO
/****** Object:  View [dbo].[SCH_RESOURCE_ESTIMATES_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[SCH_RESOURCE_ESTIMATES_V]
AS
SELECT     dbo.JOBS_V.ORGANIZATION_ID, dbo.JOBS_V.JOB_ID, dbo.JOBS_V.JOB_NO, dbo.JOBS_V.JOB_NAME, dbo.JOBS_V.JOB_TYPE_ID, 
                      dbo.JOBS_V.job_type_code, dbo.JOBS_V.job_type_name, dbo.JOBS_V.JOB_STATUS_TYPE_ID, dbo.JOBS_V.job_status_type_code, 
                      dbo.JOBS_V.job_status_type_name, dbo.RESOURCE_ESTIMATES_V.RESOURCE_EST_ID, dbo.RESOURCE_ESTIMATES_V.SERVICE_ID, 
                      dbo.RESOURCE_ESTIMATES_V.SERVICE_NO, dbo.RESOURCE_ESTIMATES_V.JOB_ITEM_RATE_ID, dbo.RESOURCE_ESTIMATES_V.ITEM_ID, 
                      dbo.RESOURCE_ESTIMATES_V.item_name, dbo.RESOURCE_ESTIMATES_V.item_desc, dbo.RESOURCE_ESTIMATES_V.ITEM_TYPE_ID, 
                      dbo.RESOURCE_ESTIMATES_V.item_type_code, dbo.RESOURCE_ESTIMATES_V.item_type_name, 
                      dbo.RESOURCE_ESTIMATES_V.ITEM_STATUS_TYPE_ID, dbo.RESOURCE_ESTIMATES_V.RATE, dbo.RESOURCE_ESTIMATES_V.RESOURCE_TYPE_ID, 
                      dbo.RESOURCE_ESTIMATES_V.UNIT_QTY, dbo.RESOURCE_ESTIMATES_V.TIME_UOM_TYPE_ID, 
                      dbo.RESOURCE_ESTIMATES_V.time_uom_type_code, dbo.RESOURCE_ESTIMATES_V.time_uom_type_name, 
                      dbo.RESOURCE_ESTIMATES_V.multiplier, dbo.RESOURCE_ESTIMATES_V.TIME_QTY, dbo.RESOURCE_ESTIMATES_V.resource_type_code, 
                      dbo.RESOURCE_ESTIMATES_V.resource_type_name, dbo.RESOURCE_ESTIMATES_V.TOTAL_HOURS, dbo.RESOURCE_ESTIMATES_V.total_dollars, 
                      dbo.RESOURCE_ESTIMATES_V.START_DATE, dbo.RESOURCE_ESTIMATES_V.DATE_CREATED, dbo.RESOURCE_ESTIMATES_V.CREATED_BY, 
                      dbo.RESOURCE_ESTIMATES_V.created_by_name, dbo.RESOURCE_ESTIMATES_V.DATE_MODIFIED, dbo.RESOURCE_ESTIMATES_V.MODIFIED_BY, 
                      dbo.RESOURCE_ESTIMATES_V.modified_by_name
FROM         dbo.JOBS_V LEFT OUTER JOIN
                      dbo.RESOURCE_ESTIMATES_V ON dbo.JOBS_V.JOB_ID = dbo.RESOURCE_ESTIMATES_V.JOB_ID
GO
/****** Object:  View [dbo].[PROJECT_REQUESTS_V]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  VIEW [dbo].[PROJECT_REQUESTS_V]
AS
SELECT     dbo.PROJECTS_V.PROJECT_ID, dbo.PROJECTS_V.PROJECT_NO, dbo.REQUESTS_V.REQUEST_NO, dbo.REQUESTS_V.VERSION_NO, 
	dbo.REQUESTS_V.max_version_no, dbo.PROJECTS_V.PROJECT_TYPE_ID, dbo.PROJECTS_V.project_type_code, 
	dbo.PROJECTS_V.project_type_name, dbo.PROJECTS_V.PROJECT_STATUS_TYPE_ID, dbo.PROJECTS_V.project_status_type_code, 
	dbo.PROJECTS_V.project_status_type_name, dbo.PROJECTS_V.CUSTOMER_ID, dbo.PROJECTS_V.PARENT_CUSTOMER_ID, dbo.PROJECTS_V.ORGANIZATION_ID, 
	dbo.PROJECTS_V.EXT_DEALER_ID, dbo.PROJECTS_V.DEALER_NAME, dbo.PROJECTS_V.EXT_CUSTOMER_ID, dbo.PROJECTS_V.CUSTOMER_NAME, 
	dbo.PROJECTS_V.JOB_NAME, dbo.PROJECTS_V.DATE_CREATED, dbo.PROJECTS_V.CREATED_BY, dbo.PROJECTS_V.created_by_name, 
	dbo.REQUESTS_V.REQUEST_ID, dbo.REQUESTS_V.REQUEST_TYPE_ID, dbo.REQUESTS_V.request_type_code, 
	dbo.REQUESTS_V.request_type_name, dbo.REQUESTS_V.REQUEST_STATUS_TYPE_ID, dbo.REQUESTS_V.request_status_type_code, 
	dbo.REQUESTS_V.request_status_type_name, dbo.REQUESTS_V.CSC_WO_FIELD_FLAG,
	dbo.REQUESTS_V.est_start_date_varchar, dbo.REQUESTS_V.QUOTE_REQUEST_ID, 
	dbo.REQUESTS_V.IS_QUOTED, dbo.REQUESTS_V.A_D_DESIGNER_CONTACT_ID, dbo.REQUESTS_V.GEN_CONTRACTOR_CONTACT_ID, 
	dbo.REQUESTS_V.ELECTRICIAN_CONTACT_ID, dbo.REQUESTS_V.DATA_PHONE_CONTACT_ID, dbo.REQUESTS_V.CARPET_LAYER_CONTACT_ID, 
	dbo.REQUESTS_V.BLDG_MGR_CONTACT_ID, dbo.REQUESTS_V.SECURITY_CONTACT_ID, dbo.REQUESTS_V.MOVER_CONTACT_ID, 
	dbo.REQUESTS_V.OTHER_CONTACT_ID, dbo.REQUESTS_V.FURNITURE1_CONTACT_ID, dbo.REQUESTS_V.FURNITURE2_CONTACT_ID
FROM         dbo.PROJECTS_V LEFT OUTER JOIN
                      dbo.REQUESTS_V ON dbo.PROJECTS_V.PROJECT_ID = dbo.REQUESTS_V.PROJECT_ID
GO
/****** Object:  View [dbo].[crystal_Job_time_by_job_v]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[crystal_Job_time_by_job_v]
AS
SELECT     ISNULL(dbo.TIME_CAPTURE_V.PAYROLL_QTY, 0) - ISNULL(dbo.TIME_CAPTURE_V.BILL_HOURLY_QTY, 0) AS hours_difference, 
                      CAST(dbo.jobs_v.job_no AS VARCHAR) AS job_no_varchar, dbo.jobs_v.job_id, dbo.jobs_v.project_id, dbo.TIME_CAPTURE_V.ORGANIZATION_ID, 
                      dbo.TIME_CAPTURE_V.TC_JOB_NO, dbo.TIME_CAPTURE_V.TC_SERVICE_NO, dbo.TIME_CAPTURE_V.TC_SERVICE_LINE_NO, 
                      dbo.TIME_CAPTURE_V.TC_JOB_ID, dbo.TIME_CAPTURE_V.TC_SERVICE_ID, dbo.TIME_CAPTURE_V.PH_SERVICE_ID, 
                      dbo.TIME_CAPTURE_V.SERVICE_LINE_ID, dbo.TIME_CAPTURE_V.SERVICE_LINE_DATE, dbo.TIME_CAPTURE_V.STATUS_ID, 
                      dbo.TIME_CAPTURE_V.status_name, dbo.TIME_CAPTURE_V.RESOURCE_ID, dbo.TIME_CAPTURE_V.ITEM_ID, dbo.TIME_CAPTURE_V.TC_QTY, 
                      dbo.TIME_CAPTURE_V.TC_RATE, dbo.TIME_CAPTURE_V.tc_total, dbo.TIME_CAPTURE_V.EXT_PAY_CODE, dbo.jobs_v.customer_name, 
                      dbo.jobs_v.job_name, dbo.jobs_v.end_user_name
FROM         dbo.jobs_v RIGHT OUTER JOIN
                      dbo.TIME_CAPTURE_V ON dbo.jobs_v.job_id = dbo.TIME_CAPTURE_V.TC_JOB_ID
GO
/****** Object:  View [dbo].[crystal_JOB_COSTING_TAB_V]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[crystal_JOB_COSTING_TAB_V]
AS
SELECT     dbo.SERVICE_LINES.SERVICE_LINE_ID, dbo.SERVICE_LINES.TC_JOB_ID, dbo.SERVICE_LINES.TC_SERVICE_ID, dbo.SERVICE_LINES.BILL_JOB_ID, 
                      dbo.SERVICE_LINES.BILL_SERVICE_ID, dbo.SERVICE_LINES.ITEM_ID, dbo.SERVICE_LINES.ITEM_NAME, dbo.SERVICE_LINES.ITEM_TYPE_CODE, 
                      dbo.SERVICE_LINES.TC_QTY, dbo.SERVICE_LINES.TC_RATE, dbo.SERVICE_LINES.tc_total, dbo.ITEMS.COST_PER_UOM, 
                      dbo.ITEMS.COLUMN_POSITION, dbo.SERVICE_LINES.ENTRY_METHOD, dbo.SERVICE_LINES.TC_JOB_NO, 
                      dbo.SERVICE_LINES.POSTED_FROM_INVOICE_ID, dbo.SERVICE_LINES.ORGANIZATION_ID, dbo.SERVICE_LINES.TC_SERVICE_NO, 
                      dbo.SERVICE_LINES.SERVICE_LINE_DATE, dbo.SERVICE_LINES.STATUS_ID, dbo.CONTACTS.CONTACT_NAME, 
                      dbo.invoice_pre_total_v.custom_line_total, dbo.invoice_pre_total_v.bill_total, dbo.JOBS.JOB_STATUS_TYPE_ID, 
                      dbo.billing_v.bill_total AS Billing_Total, dbo.INVOICES.DATE_SENT, dbo.INVOICE_LINES.UNIT_PRICE, dbo.INVOICE_LINES.QTY, 
                      dbo.INVOICE_LINES.EXTENDED_PRICE AS Invoice_Total, dbo.INVOICE_LINES.INVOICE_ID
FROM         dbo.SERVICE_LINES INNER JOIN
                      dbo.ITEMS ON dbo.SERVICE_LINES.ITEM_ID = dbo.ITEMS.ITEM_ID INNER JOIN
                      dbo.JOBS ON dbo.SERVICE_LINES.TC_JOB_NO = dbo.JOBS.JOB_NO INNER JOIN
                      dbo.billing_v ON dbo.SERVICE_LINES.SERVICE_LINE_ID = dbo.billing_v.service_line_id INNER JOIN
                      dbo.INVOICES ON dbo.SERVICE_LINES.TC_JOB_ID = dbo.INVOICES.JOB_ID INNER JOIN
                      dbo.INVOICE_LINES ON dbo.INVOICES.INVOICE_ID = dbo.INVOICE_LINES.INVOICE_ID LEFT OUTER JOIN
                      dbo.invoice_pre_total_v ON dbo.SERVICE_LINES.TC_SERVICE_ID = dbo.invoice_pre_total_v.service_id FULL OUTER JOIN
                      dbo.CONTACTS ON dbo.JOBS.A_M_SALES_CONTACT_ID = dbo.CONTACTS.CONTACT_ID
WHERE     (dbo.SERVICE_LINES.INTERNAL_REQ_FLAG = 'N') AND (dbo.JOBS.JOB_STATUS_TYPE_ID <> 115) AND (dbo.SERVICE_LINES.STATUS_ID >= 3)
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[6] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "SERVICE_LINES"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 276
            End
            DisplayFlags = 280
            TopColumn = 24
         End
         Begin Table = "ITEMS"
            Begin Extent = 
               Top = 6
               Left = 314
               Bottom = 114
               Right = 516
            End
            DisplayFlags = 280
            TopColumn = 17
         End
         Begin Table = "JOBS"
            Begin Extent = 
               Top = 6
               Left = 554
               Bottom = 199
               Right = 779
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "billing_v"
            Begin Extent = 
               Top = 184
               Left = 536
               Bottom = 345
               Right = 757
            End
            DisplayFlags = 280
            TopColumn = 14
         End
         Begin Table = "invoice_pre_total_v"
            Begin Extent = 
               Top = 154
               Left = 8
               Bottom = 262
               Right = 219
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "CONTACTS"
            Begin Extent = 
               Top = 252
               Left = 273
               Bottom = 360
               Right = 472
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "INVOICES"
            Begin Extent = 
               Top = 127
               Left = 50
               Bottom = 235
               Right = 267
            End
            Dis' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'crystal_JOB_COSTING_TAB_V'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'playFlags = 280
            TopColumn = 0
         End
         Begin Table = "INVOICE_LINES"
            Begin Extent = 
               Top = 122
               Left = 320
               Bottom = 230
               Right = 517
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 31
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 2280
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 990
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1830
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'crystal_JOB_COSTING_TAB_V'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'crystal_JOB_COSTING_TAB_V'
GO
/****** Object:  View [dbo].[USER_FUNCTION_RIGHTS_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[USER_FUNCTION_RIGHTS_V]
AS
SELECT     dbo.USERS.USER_ID, dbo.USERS.FIRST_NAME + ' ' + dbo.USERS.LAST_NAME AS user_name, dbo.ROLE_FUNCTION_RIGHTS_ALL_V.ROLE_ID, 
                      dbo.ROLE_FUNCTION_RIGHTS_ALL_V.role_name, dbo.ROLE_FUNCTION_RIGHTS_ALL_V.FUNCTION_ID, 
                      dbo.ROLE_FUNCTION_RIGHTS_ALL_V.function_name, dbo.ROLE_FUNCTION_RIGHTS_ALL_V.function_code, 
                      dbo.ROLE_FUNCTION_RIGHTS_ALL_V.function_desc, dbo.ROLE_FUNCTION_RIGHTS_ALL_V.FUNCTION_GROUP_ID, 
                      dbo.ROLE_FUNCTION_RIGHTS_ALL_V.function_group_code, dbo.ROLE_FUNCTION_RIGHTS_ALL_V.function_group_name, 
                      dbo.ROLE_FUNCTION_RIGHTS_ALL_V.TEMPLATE_ID, dbo.ROLE_FUNCTION_RIGHTS_ALL_V.SEQUENCE_NO, 
                      dbo.ROLE_FUNCTION_RIGHTS_ALL_V.IS_NAV_FUNCTION, dbo.ROLE_FUNCTION_RIGHTS_ALL_V.IS_MENU_FUNCTION, 
                      dbo.ROLE_FUNCTION_RIGHTS_ALL_V.TARGET, dbo.ROLE_FUNCTION_RIGHTS_ALL_V.ROLE_FUNCTION_RIGHT_ID, 
                      dbo.ROLE_FUNCTION_RIGHTS_ALL_V.RIGHT_TYPE_ID, dbo.ROLE_FUNCTION_RIGHTS_ALL_V.right_type_code, 
                      dbo.ROLE_FUNCTION_RIGHTS_ALL_V.right_type_name, dbo.ROLE_FUNCTION_RIGHTS_ALL_V.right_type_desc, 
                      dbo.ROLE_FUNCTION_RIGHTS_ALL_V.function_date_created, dbo.ROLE_FUNCTION_RIGHTS_ALL_V.function_created_by, 
                      dbo.ROLE_FUNCTION_RIGHTS_ALL_V.function_date_modified, dbo.ROLE_FUNCTION_RIGHTS_ALL_V.function_modified_by, 
                      dbo.ROLE_FUNCTION_RIGHTS_ALL_V.right_updatable_flag, dbo.ROLE_FUNCTION_RIGHTS_ALL_V.has_right, 
                      dbo.USERS.ACTIVE_FLAG AS user_active_flag, TEMPLATES_1.TEMPLATE_NAME, dbo.ROLE_FUNCTION_RIGHTS_ALL_V.LOCATION
FROM         dbo.TEMPLATES TEMPLATES_1 RIGHT OUTER JOIN
                      dbo.ROLE_FUNCTION_RIGHTS_ALL_V RIGHT OUTER JOIN
                      dbo.USER_ROLES ON dbo.ROLE_FUNCTION_RIGHTS_ALL_V.ROLE_ID = dbo.USER_ROLES.ROLE_ID RIGHT OUTER JOIN
                      dbo.USERS ON dbo.USER_ROLES.USER_ID = dbo.USERS.USER_ID ON 
                      TEMPLATES_1.TEMPLATE_ID = dbo.ROLE_FUNCTION_RIGHTS_ALL_V.TEMPLATE_ID
WHERE     (dbo.USERS.ACTIVE_FLAG = 'Y')
GO
/****** Object:  View [dbo].[USER_ORG_FUNCTION_RIGHTS_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[USER_ORG_FUNCTION_RIGHTS_V]
AS
SELECT     dbo.USERS.USER_ID, dbo.USERS.FIRST_NAME + ' ' + dbo.USERS.LAST_NAME AS user_name, dbo.ROLE_FUNCTION_RIGHTS_ALL_V.ROLE_ID, 
                      dbo.ROLE_FUNCTION_RIGHTS_ALL_V.role_name, dbo.ROLE_FUNCTION_RIGHTS_ALL_V.FUNCTION_ID, 
                      dbo.ROLE_FUNCTION_RIGHTS_ALL_V.function_name, dbo.ROLE_FUNCTION_RIGHTS_ALL_V.function_code, 
                      dbo.ROLE_FUNCTION_RIGHTS_ALL_V.function_desc, dbo.ROLE_FUNCTION_RIGHTS_ALL_V.FUNCTION_GROUP_ID, 
                      dbo.ROLE_FUNCTION_RIGHTS_ALL_V.function_group_code, dbo.ROLE_FUNCTION_RIGHTS_ALL_V.function_group_name, 
                      dbo.ROLE_FUNCTION_RIGHTS_ALL_V.TEMPLATE_ID, dbo.ROLE_FUNCTION_RIGHTS_ALL_V.SEQUENCE_NO, 
                      dbo.ROLE_FUNCTION_RIGHTS_ALL_V.IS_NAV_FUNCTION, dbo.ROLE_FUNCTION_RIGHTS_ALL_V.IS_MENU_FUNCTION, 
                      dbo.ROLE_FUNCTION_RIGHTS_ALL_V.TARGET, dbo.ROLE_FUNCTION_RIGHTS_ALL_V.ROLE_FUNCTION_RIGHT_ID, 
                      dbo.ROLE_FUNCTION_RIGHTS_ALL_V.RIGHT_TYPE_ID, dbo.ROLE_FUNCTION_RIGHTS_ALL_V.right_type_code, 
                      dbo.ROLE_FUNCTION_RIGHTS_ALL_V.right_type_name, dbo.ROLE_FUNCTION_RIGHTS_ALL_V.right_type_desc, 
                      dbo.ROLE_FUNCTION_RIGHTS_ALL_V.function_date_created, dbo.ROLE_FUNCTION_RIGHTS_ALL_V.function_created_by, 
                      dbo.ROLE_FUNCTION_RIGHTS_ALL_V.function_date_modified, dbo.ROLE_FUNCTION_RIGHTS_ALL_V.function_modified_by, 
                      dbo.ROLE_FUNCTION_RIGHTS_ALL_V.right_updatable_flag, dbo.ROLE_FUNCTION_RIGHTS_ALL_V.has_right, 
                      dbo.USERS.ACTIVE_FLAG AS user_active_flag, TEMPLATES_1.TEMPLATE_NAME, dbo.ROLE_FUNCTION_RIGHTS_ALL_V.LOCATION, 
                      dbo.USER_ORGANIZATIONS.ORGANIZATION_ID
FROM         dbo.ROLE_FUNCTION_RIGHTS_ALL_V RIGHT OUTER JOIN
                      dbo.USER_ROLES ON dbo.ROLE_FUNCTION_RIGHTS_ALL_V.ROLE_ID = dbo.USER_ROLES.ROLE_ID RIGHT OUTER JOIN
                      dbo.USER_ORGANIZATIONS RIGHT OUTER JOIN
                      dbo.USERS ON dbo.USER_ORGANIZATIONS.USER_ID = dbo.USERS.USER_ID ON 
                      dbo.USER_ROLES.USER_ID = dbo.USERS.USER_ID LEFT OUTER JOIN
                      dbo.TEMPLATES TEMPLATES_1 ON dbo.ROLE_FUNCTION_RIGHTS_ALL_V.TEMPLATE_ID = TEMPLATES_1.TEMPLATE_ID
WHERE     (dbo.USERS.ACTIVE_FLAG = 'Y')
GO
/****** Object:  View [dbo].[crystal_JOB_CST_COMIS_ECMS_V]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[crystal_JOB_CST_COMIS_ECMS_V]
AS
SELECT     dbo.SERVICE_LINES.SERVICE_LINE_ID, dbo.SERVICE_LINES.TC_JOB_ID, dbo.SERVICE_LINES.TC_SERVICE_ID, dbo.SERVICE_LINES.BILL_JOB_ID, 
                      dbo.SERVICE_LINES.BILL_SERVICE_ID, dbo.SERVICE_LINES.ITEM_ID, dbo.SERVICE_LINES.ITEM_NAME, dbo.SERVICE_LINES.ITEM_TYPE_CODE, 
                      dbo.SERVICE_LINES.TC_QTY, dbo.SERVICE_LINES.TC_RATE, dbo.SERVICE_LINES.tc_total, dbo.ITEMS.COST_PER_UOM, 
                      dbo.ITEMS.COLUMN_POSITION, dbo.SERVICE_LINES.ENTRY_METHOD, dbo.SERVICE_LINES.TC_JOB_NO, dbo.SERVICE_LINES.INVOICE_ID, 
                      dbo.SERVICE_LINES.POSTED_FROM_INVOICE_ID, dbo.SERVICE_LINES.ORGANIZATION_ID, dbo.SERVICE_LINES.TC_SERVICE_NO, 
                      dbo.SERVICE_LINES.SERVICE_LINE_DATE, dbo.SERVICE_LINES.STATUS_ID, dbo.CONTACTS.CONTACT_NAME, 
                      dbo.invoice_pre_total_v.custom_line_total, dbo.invoice_pre_total_v.bill_total
FROM         dbo.SERVICE_LINES INNER JOIN
                      dbo.ITEMS ON dbo.SERVICE_LINES.ITEM_ID = dbo.ITEMS.ITEM_ID INNER JOIN
                      dbo.JOBS ON dbo.SERVICE_LINES.TC_JOB_NO = dbo.JOBS.JOB_NO LEFT OUTER JOIN
                      dbo.invoice_pre_total_v ON dbo.SERVICE_LINES.TC_SERVICE_ID = dbo.invoice_pre_total_v.service_id FULL OUTER JOIN
                      dbo.CONTACTS ON dbo.JOBS.A_M_SALES_CONTACT_ID = dbo.CONTACTS.CONTACT_ID
WHERE     (dbo.SERVICE_LINES.STATUS_ID >= 3) AND (dbo.SERVICE_LINES.INTERNAL_REQ_FLAG = 'N') AND (dbo.SERVICE_LINES.ORGANIZATION_ID = 14)
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[10] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "SERVICE_LINES"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 276
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ITEMS"
            Begin Extent = 
               Top = 7
               Left = 503
               Bottom = 115
               Right = 705
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "JOBS"
            Begin Extent = 
               Top = 114
               Left = 22
               Bottom = 222
               Right = 247
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "invoice_pre_total_v"
            Begin Extent = 
               Top = 119
               Left = 355
               Bottom = 227
               Right = 566
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CONTACTS"
            Begin Extent = 
               Top = 8
               Left = 299
               Bottom = 116
               Right = 498
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 26
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
  ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'crystal_JOB_CST_COMIS_ECMS_V'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'       Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 2115
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'crystal_JOB_CST_COMIS_ECMS_V'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'crystal_JOB_CST_COMIS_ECMS_V'
GO
/****** Object:  View [dbo].[QUOTE_MAIL_V]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[QUOTE_MAIL_V]
AS
SELECT dbo.PROJECT_QUOTES_V.record_id
, ISNULL(sales.CONTACT_NAME, 'N/A') AS sales_name
, ISNULL(sales_sup.CONTACT_NAME, 'N/A') AS sales_sup_name
, ISNULL(designer.CONTACT_NAME, 'N/A') AS designer_name
, ISNULL(proj_mgr.CONTACT_NAME, 'N/A') AS proj_mgr_name
, ISNULL(am.CONTACT_NAME, 'N/A') AS am_name
FROM  dbo.CONTACTS proj_mgr RIGHT OUTER JOIN  
                      dbo.PROJECT_QUOTES_V LEFT OUTER JOIN  
                      dbo.CONTACTS am ON dbo.PROJECT_QUOTES_V.a_m_contact_id = am.CONTACT_ID LEFT OUTER JOIN  
                      dbo.CONTACTS designer ON dbo.PROJECT_QUOTES_V.d_designer_contact_id = designer.CONTACT_ID ON   
                      proj_mgr.CONTACT_ID = dbo.PROJECT_QUOTES_V.d_proj_mgr_contact_id LEFT OUTER JOIN  
                      dbo.CONTACTS sales_sup ON dbo.PROJECT_QUOTES_V.d_sales_sup_contact_id = sales_sup.CONTACT_ID
                      LEFT OUTER JOIN dbo.CONTACTS sales ON dbo.PROJECT_QUOTES_V.d_sales_rep_contact_id = sales.CONTACT_ID
GO
/****** Object:  View [dbo].[JOB_TIME_BY_EMP_V]    Script Date: 05/03/2010 14:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[JOB_TIME_BY_EMP_V]
AS
SELECT dbo.TIME_CAPTURE_V.ORGANIZATION_ID, 
       dbo.TIME_CAPTURE_V.TC_JOB_NO, 
       dbo.TIME_CAPTURE_V.TC_SERVICE_NO, 
       dbo.TIME_CAPTURE_V.TC_SERVICE_LINE_NO, 
       dbo.TIME_CAPTURE_V.TC_JOB_ID, 
       dbo.TIME_CAPTURE_V.TC_SERVICE_ID, 
       dbo.TIME_CAPTURE_V.SERVICE_LINE_ID, 
       dbo.JOBS_V.JOB_NAME, 
       dbo.JOBS_V.FOREMAN_RESOURCE_ID, 
       dbo.JOBS_V.foreman_resource_name, 
       dbo.TIME_CAPTURE_V.SERVICE_LINE_DATE, 
       dbo.TIME_CAPTURE_V.STATUS_ID, 
       dbo.TIME_CAPTURE_V.status_name, 
       dbo.TIME_CAPTURE_V.RESOURCE_ID, 
       dbo.RESOURCES_V.USER_ID, 
       dbo.RESOURCES_V.resource_name, 
       dbo.RESOURCES_V.user_full_name AS employee_name, 
       dbo.RESOURCES_V.EXT_EMPLOYEE_ID, 
       dbo.TIME_CAPTURE_V.ITEM_NAME, 
       dbo.TIME_CAPTURE_V.PAYROLL_QTY, 
       dbo.TIME_CAPTURE_V.PAYROLL_RATE, 
       dbo.TIME_CAPTURE_V.PAYROLL_TOTAL, 
       dbo.TIME_CAPTURE_V.EXPENSE_QTY, 
       dbo.TIME_CAPTURE_V.EXPENSE_RATE, 
       dbo.TIME_CAPTURE_V.EXPENSE_TOTAL, 
       dbo.TIME_CAPTURE_V.TC_QTY, 
       dbo.TIME_CAPTURE_V.TC_RATE, 
       dbo.TIME_CAPTURE_V.TC_TOTAL, 
       dbo.TIME_CAPTURE_V.BILL_HOURLY_QTY, 
       dbo.TIME_CAPTURE_V.BILL_HOURLY_RATE, 
       dbo.TIME_CAPTURE_V.BILL_HOURLY_TOTAL, 
       dbo.TIME_CAPTURE_V.BILL_EXP_QTY, 
       dbo.TIME_CAPTURE_V.BILL_EXP_RATE, 
       dbo.TIME_CAPTURE_V.BILL_EXP_TOTAL, 
       dbo.TIME_CAPTURE_V.BILL_QTY,  
       dbo.TIME_CAPTURE_V.BILL_RATE, 
       dbo.TIME_CAPTURE_V.BILL_TOTAL, 
       dbo.TIME_CAPTURE_V.PH_SERVICE_ID, 
       dbo.TIME_CAPTURE_V.EXT_PAY_CODE, 
       dbo.TIME_CAPTURE_V.service_no,
       ISNULL(dbo.TIME_CAPTURE_V.PAYROLL_QTY, 0) - ISNULL(dbo.TIME_CAPTURE_V.BILL_HOURLY_QTY, 0) AS hours_difference, 
       MAX((CASE WHEN SERVICE_LINES_SCHD_V.SERVICE_LINE_ID IS NULL THEN 'N' ELSE 'Y' END)) scheduled_flag
  FROM dbo.SERVICE_LINES_SCHD_V RIGHT OUTER JOIN
       dbo.TIME_CAPTURE_V ON dbo.SERVICE_LINES_SCHD_V.SERVICE_LINE_ID = dbo.TIME_CAPTURE_V.SERVICE_LINE_ID LEFT OUTER JOIN
       dbo.RESOURCES_V ON dbo.TIME_CAPTURE_V.RESOURCE_ID = dbo.RESOURCES_V.RESOURCE_ID LEFT OUTER JOIN
       dbo.JOBS_V ON dbo.TIME_CAPTURE_V.TC_JOB_ID = dbo.JOBS_V.JOB_ID
GROUP BY dbo.TIME_CAPTURE_V.ORGANIZATION_ID, dbo.TIME_CAPTURE_V.TC_JOB_NO, dbo.TIME_CAPTURE_V.TC_SERVICE_NO, 
         dbo.TIME_CAPTURE_V.TC_SERVICE_LINE_NO, dbo.TIME_CAPTURE_V.TC_JOB_ID, dbo.TIME_CAPTURE_V.TC_SERVICE_ID, 
         dbo.TIME_CAPTURE_V.SERVICE_LINE_ID, dbo.JOBS_V.JOB_NAME, dbo.JOBS_V.FOREMAN_RESOURCE_ID, dbo.JOBS_V.foreman_resource_name, 
         dbo.TIME_CAPTURE_V.SERVICE_LINE_DATE, dbo.TIME_CAPTURE_V.STATUS_ID, dbo.TIME_CAPTURE_V.status_name, 
         dbo.TIME_CAPTURE_V.RESOURCE_ID, dbo.RESOURCES_V.USER_ID, dbo.RESOURCES_V.resource_name, dbo.RESOURCES_V.user_full_name, 
         dbo.RESOURCES_V.EXT_EMPLOYEE_ID,
         dbo.TIME_CAPTURE_V.ITEM_NAME, dbo.TIME_CAPTURE_V.PAYROLL_QTY, 
         dbo.TIME_CAPTURE_V.PAYROLL_RATE, dbo.TIME_CAPTURE_V.PAYROLL_TOTAL, dbo.TIME_CAPTURE_V.EXPENSE_QTY, 
         dbo.TIME_CAPTURE_V.EXPENSE_RATE, dbo.TIME_CAPTURE_V.EXPENSE_TOTAL, dbo.TIME_CAPTURE_V.TC_QTY, dbo.TIME_CAPTURE_V.TC_RATE, 
         dbo.TIME_CAPTURE_V.TC_TOTAL, dbo.TIME_CAPTURE_V.BILL_HOURLY_QTY, dbo.TIME_CAPTURE_V.BILL_HOURLY_RATE, 
         dbo.TIME_CAPTURE_V.BILL_HOURLY_TOTAL, dbo.TIME_CAPTURE_V.BILL_EXP_QTY, dbo.TIME_CAPTURE_V.BILL_EXP_RATE, 
         dbo.TIME_CAPTURE_V.BILL_EXP_TOTAL, dbo.TIME_CAPTURE_V.BILL_QTY,dbo.TIME_CAPTURE_V.BILL_RATE, dbo.TIME_CAPTURE_V.BILL_TOTAL, 
         dbo.TIME_CAPTURE_V.PH_SERVICE_ID, dbo.TIME_CAPTURE_V.EXT_PAY_CODE,
         dbo.TIME_CAPTURE_V.service_no, ISNULL(dbo.TIME_CAPTURE_V.PAYROLL_QTY, 0) - ISNULL(dbo.TIME_CAPTURE_V.BILL_HOURLY_QTY, 0)
HAVING   (NOT (dbo.TIME_CAPTURE_V.PAYROLL_QTY IS NULL))
GO
/****** Object:  View [dbo].[crystal_csc_routing_ticket_v]    Script Date: 05/03/2010 14:18:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[crystal_csc_routing_ticket_v]
AS
SELECT     dbo.REQUESTS.PROJECT_ID, dbo.PROJECTS.PROJECT_NO, dbo.REQUESTS.REQUEST_NO, dbo.REQUESTS.PRIORITY_TYPE_ID, 
                      LOOKUPS_1.NAME AS PRIORITY, dbo.REQUESTS.CUSTOMER_PO_NO, dbo.REQUESTS.LEVEL_TYPE_ID, 
                      dbo.REQUEST_VENDORS.VENDOR_CONTACT_ID, dbo.CONTACTS.CONTACT_NAME AS VENDOR_NAME, dbo.REQUEST_VENDORS.EMAILED_DATE, 
                      dbo.REQUEST_VENDORS.SCH_START_DATE, dbo.REQUEST_VENDORS.SCH_START_TIME, dbo.REQUEST_VENDORS.SCH_END_DATE, 
                      dbo.REQUEST_VENDORS.ACT_START_DATE, dbo.REQUEST_VENDORS.ACT_START_TIME, dbo.REQUEST_VENDORS.ACT_END_DATE, 
                      dbo.REQUESTS.EST_START_DATE, dbo.REQUEST_VENDORS.ESTIMATED_COST, dbo.REQUEST_VENDORS.TOTAL_COST, 
                      dbo.REQUEST_VENDORS.INVOICE_DATE, dbo.REQUEST_VENDORS.INVOICE_NUMBERS, dbo.REQUEST_VENDORS.VISIT_COUNT, 
                      dbo.REQUEST_VENDORS.COMPLETE_FLAG, dbo.REQUEST_VENDORS.INVOICED_FLAG, dbo.PROJECTS.JOB_NAME, LOOKUPS_1.NAME AS ACTIVITY, 
                      dbo.REQUESTS.QTY1, LOOKUPS_2.NAME AS CATEGORY, dbo.REQUESTS.CUST_COL_1, dbo.REQUESTS.CUST_COL_2, dbo.REQUESTS.CUST_COL_3, 
                      dbo.REQUESTS.CUST_COL_4, dbo.REQUESTS.CUST_COL_5, dbo.REQUESTS.CUST_COL_6, dbo.REQUESTS.CUST_COL_7, 
                      dbo.REQUESTS.CUST_COL_8, dbo.REQUESTS.CUST_COL_9, dbo.REQUESTS.CUST_COL_10
FROM         dbo.REQUEST_VENDORS INNER JOIN
                      dbo.REQUESTS ON dbo.REQUEST_VENDORS.REQUEST_ID = dbo.REQUESTS.REQUEST_ID INNER JOIN
                      dbo.CONTACTS ON dbo.REQUEST_VENDORS.VENDOR_CONTACT_ID = dbo.CONTACTS.CONTACT_ID INNER JOIN
                      dbo.PROJECTS ON dbo.REQUESTS.PROJECT_ID = dbo.PROJECTS.PROJECT_ID INNER JOIN
                      dbo.LOOKUPS LOOKUPS_1 ON dbo.REQUESTS.ACTIVITY_TYPE_ID1 = LOOKUPS_1.LOOKUP_ID INNER JOIN
                      dbo.LOOKUPS LOOKUPS_2 ON dbo.REQUESTS.ACTIVITY_CAT_TYPE_ID1 = LOOKUPS_2.LOOKUP_ID INNER JOIN
                      dbo.SCH_RESOURCES_ALL_V ON dbo.REQUESTS.PROJECT_ID = dbo.SCH_RESOURCES_ALL_V.JOB_ID LEFT OUTER JOIN
                      dbo.LOOKUPS LOOKUPS_3 ON dbo.REQUESTS.PRIORITY_TYPE_ID = LOOKUPS_3.LOOKUP_ID
GO
/****** Object:  View [dbo].[SERVICE_ACCOUNT_REPORT_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[SERVICE_ACCOUNT_REPORT_V]
AS
SELECT     job_id, job_no, job_name, job_no_name, DESCRIPTION, req_po_no, job_type_id, job_type_code, job_type_name, job_status_type_id, 
                      job_status_type_code, job_status_type_name, job_status_seq_no, customer_id, organization_id, dealer_name, ext_dealer_id, customer_name, 
                      JOB_LOCATION_NAME, ext_customer_id, INVOICE_ID, Invoice_Desc, PO_NO, EST_START_DATE, SCH_START_DATE, SERVICE_LINE_DATE, 
                      invoice_status_id, invoice_status_code, invoice_status_name, SERVICE_ID, SERVICE_NO, TC_SERVICE_LINE_NO, RESOURCE_TYPE_ID, 
                      resource_type_code, resource_type_name, res_cat_type_id, res_cat_type_code, res_cat_type_name, ITEM_ID, item_name, ITEM_TYPE_ID, 
                      item_type_name, item_type_code, BILLABLE_FLAG, TAXABLE_FLAG, bill_total, EXT_PAY_CODE, SL_BILLABLE_FLAG, hourly_rate, expense_rate, 
                      BILL_QTY, CUST_COL_1, CUST_COL_2, CUST_COL_3, CUST_COL_4, CUST_COL_5, CUST_COL_6, CUST_COL_7, CUST_COL_8, CUST_COL_9, 
                      CUST_COL_10, SUM(other_rate) AS other_rate, SUM(other_qty) AS other_qty, SUM(other_total) AS other_total, SUM(baggies_rate) AS baggies_rate, 
                      SUM(baggies_qty) AS baggies_qty, SUM(baggies_total) AS baggies_total, SUM(boxes_rate) AS boxes_rate, SUM(boxes_qty) AS boxes_qty, 
                      SUM(boxes_total) AS boxes_total, SUM(EquipRental_rate) AS EquipRental_rate, SUM(EquipRental_qty) AS EquipRental_qty, SUM(EquipRental_total) 
                      AS EquipRental_total, SUM(keys_rate) AS keys_rate, SUM(keys_qty) AS keys_qty, SUM(keys_total) AS keys_total, SUM(labels_rate) AS labels_rate, 
                      SUM(labels_qty) AS labels_qty, SUM(labels_total) AS labels_total, SUM(tape_rate) AS tape_rate, SUM(tape_qty) AS tape_qty, SUM(tape_total) 
                      AS tape_total, SUM(supplies_rate) AS supplies_rate, SUM(supplies_qty) AS supplies_qty, SUM(supplies_total) AS supplies_total, SUM(trash_rate) 
                      AS trash_rate, SUM(trash_qty) AS trash_qty, SUM(trash_total) AS trash_total, SUM(custom_reg_rate) AS custom_reg_rate, SUM(custom_reg_qty) 
                      AS custom_reg_qty, SUM(custom_reg_total) AS custom_reg_total, SUM(custom_ot_rate) AS custom_ot_rate, SUM(custom_ot_qty) AS custom_ot_qty, 
                      SUM(custom_ot_total) AS custom_ot_total, SUM(delivery_reg_rate) AS delivery_reg_rate, SUM(delivery_reg_qty) AS delivery_reg_qty, 
                      SUM(delivery_reg_total) AS delivery_reg_total, SUM(delivery_ot_rate) AS delivery_ot_rate, SUM(delivery_ot_qty) AS delivery_ot_qty, 
                      SUM(delivery_ot_total) AS delivery_ot_total, SUM(driver_reg_rate) AS Driver_reg_rate, SUM(driver_reg_qty) AS Driver_reg_qty, SUM(driver_reg_total) 
                      AS Driver_reg_total, SUM(driver_ot_rate) AS Driver_ot_rate, SUM(driver_ot_qty) AS Driver_ot_qty, SUM(driver_ot_total) AS Driver_ot_total, 
                      SUM(truck_rate) AS truck_rate, SUM(truck_qty) AS truck_qty, SUM(truck_total) AS truck_total, SUM(van_rate) AS van_rate, SUM(van_qty) AS van_qty, 
                      SUM(van_total) AS van_total, SUM(MileageInTown_rate) AS MileageInTown_rate, SUM(MileageInTown_qty) AS MileageInTown_qty, 
                      SUM(MileageInTown_total) AS MileageInTown_total, SUM(MileageOutTown_rate) AS MileageOutTown_rate, SUM(MileageOutTown_qty) 
                      AS MileageOutTown_qty, SUM(MileageOutTown_total) AS MileageOutTown_total, SUM(installer_reg_rate) AS installer_reg_rate, SUM(installer_reg_qty) 
                      AS installer_reg_qty, SUM(installer_reg_total) AS installer_reg_total, SUM(installer_ot_rate) AS installer_ot_rate, SUM(installer_ot_qty) 
                      AS installer_ot_qty, SUM(installer_ot_total) AS installer_ot_total, SUM(sub_reg_rate) AS sub_reg_rate, SUM(sub_reg_qty) AS sub_reg_qty, 
                      SUM(sub_reg_total) AS sub_reg_total, SUM(sub_ot_rate) AS sub_ot_rate, SUM(sub_ot_qty) AS sub_ot_qty, SUM(sub_ot_total) AS sub_ot_total, 
                      SUM(sub_exp_rate) AS sub_exp_rate, SUM(sub_exp_qty) AS sub_exp_qty, SUM(sub_exp_total) AS sub_exp_total, SUM(GenLabor_reg_rate) 
                      AS GenLabor_reg_rate, SUM(GenLabor_reg_qty) AS GenLabor_reg_qty, SUM(GenLabor_reg_total) AS GenLabor_reg_total, SUM(GenLabor_ot_rate) 
                      AS GenLabor_ot_rate, SUM(GenLabor_ot_qty) AS GenLabor_ot_qty, SUM(GenLabor_ot_total) AS GenLabor_ot_total, SUM(Mover_Reg_Hrs_rate) 
                      AS mover_reg_hrs_rate, SUM(Mover_Reg_Hrs_qty) AS mover_reg_hrs_qty, SUM(Mover_Reg_Hrs_total) AS mover_reg_hrs_total, 
                      SUM(Mover_OT_Hrs_rate) AS mover_ot_hrs_rate, SUM(Mover_OT_Hrs_qty) AS mover_ot_hrs_qty, SUM(Mover_OT_Hrs_total) AS mover_ot_hrs_total, 
                      SUM(pc_fab_reg_rate) AS pc_fab_reg_rate, SUM(pc_fab_reg_qty) AS pc_fab_reg_qty, SUM(pc_fab_reg_total) AS pc_fab_reg_total, SUM(pc_fab_ot_rate) 
                      AS pc_fab_ot_rate, SUM(pc_fab_ot_qty) AS pc_fab_ot_qty, SUM(pc_fab_ot_total) AS pc_fab_ot_total, SUM(Foreman_reg_rate) AS Foreman_reg_rate, 
                      SUM(Foreman_reg_qty) AS Foreman_reg_qty, SUM(Foreman_reg_total) AS Foreman_reg_total, SUM(Foreman_ot_rate) AS Foreman_ot_rate, 
                      SUM(Foreman_ot_qty) AS Foreman_ot_qty, SUM(Foreman_ot_total) AS Foreman_ot_total, SUM(lead_reg_rate) AS lead_reg_rate, SUM(lead_reg_qty) 
                      AS lead_reg_qty, SUM(lead_reg_total) AS lead_reg_total, SUM(lead_ot_rate) AS lead_ot_rate, SUM(lead_ot_qty) AS lead_ot_qty, SUM(lead_ot_total) 
                      AS lead_ot_total, SUM(ac_reg_rate) AS ac_reg_rate, SUM(ac_reg_qty) AS ac_reg_qty, SUM(ac_reg_total) AS ac_reg_total, SUM(ac_ot_rate) 
                      AS ac_ot_rate, SUM(ac_ot_qty) AS ac_ot_qty, SUM(ac_ot_total) AS ac_ot_total, SUM(am_reg_rate) AS am_reg_rate, SUM(am_reg_qty) AS am_reg_qty, 
                      SUM(am_reg_total) AS am_reg_total, SUM(am_ot_rate) AS am_ot_rate, SUM(am_ot_qty) AS am_ot_qty, SUM(am_ot_total) AS am_ot_total, 
                      SUM(mac_reg_rate) AS mac_reg_rate, SUM(mac_reg_qty) AS mac_reg_qty, SUM(mac_reg_total) AS mac_reg_total, SUM(mac_ot_rate) AS mac_ot_rate, 
                      SUM(mac_ot_qty) AS mac_ot_qty, SUM(mac_ot_total) AS mac_ot_total, SUM(mps_reg_rate) AS mps_reg_rate, SUM(mps_reg_qty) AS mps_reg_qty, 
                      SUM(mps_reg_total) AS mps_reg_total, SUM(mps_ot_rate) AS mps_ot_rate, SUM(mps_ot_qty) AS mps_ot_qty, SUM(mps_ot_total) AS mps_ot_total, 
                      SUM(ps_reg_rate) AS ps_reg_rate, SUM(ps_reg_qty) AS ps_reg_qty, SUM(ps_reg_total) AS ps_reg_total, SUM(ps_ot_rate) AS ps_ot_rate, 
                      SUM(ps_ot_qty) AS ps_ot_qty, SUM(ps_ot_total) AS ps_ot_total, SUM(campfurnmgr_reg_rate) AS campfurnmgr_reg_rate, SUM(campfurnmgr_reg_qty) 
                      AS campfurnmgr_reg_qty, SUM(campfurnmgr_reg_total) AS campfurnmgr_reg_total, SUM(campfurnmgr_ot_rate) AS campfurnmgr_ot_rate, 
                      SUM(campfurnmgr_ot_qty) AS campfurnmgr_ot_qty, SUM(campfurnmgr_ot_total) AS campfurnmgr_ot_total, SUM(EquMovLabor_reg_rate) 
                      AS EquMovLabor_reg_rate, SUM(EquMovLabor_reg_qty) AS EquMovLabor_reg_qty, SUM(EquMovLabor_reg_total) AS EquMovLabor_reg_total, 
                      SUM(EquMovLabor_ot_rate) AS EquMovLabor_ot_rate, SUM(EquMovLabor_ot_qty) AS EquMovLabor_ot_qty, SUM(EquMovLabor_ot_total) 
                      AS EquMovLabor_ot_total, SUM(OfficeEquMgr_reg_rate) AS OfficeEquMgr_reg_rate, SUM(OfficeEquMgr_reg_qty) AS OfficeEquMgr_reg_qty, 
                      SUM(OfficeEquMgr_reg_total) AS OfficeEquMgr_reg_total, SUM(OfficeEquMgr_ot_rate) AS OfficeEquMgr_ot_rate, SUM(OfficeEquMgr_ot_qty) 
                      AS OfficeEquMgr_ot_qty, SUM(OfficeEquMgr_ot_total) AS OfficeEquMgr_ot_total, SUM(pc_coord_reg_rate) AS pc_coord_reg_rate, 
                      SUM(pc_coord_reg_qty) AS pc_coord_reg_qty, SUM(pc_coord_reg_total) AS pc_coord_reg_total, SUM(pc_coord_ot_rate) AS pc_coord_ot_rate, 
                      SUM(pc_coord_ot_qty) AS pc_coord_ot_qty, SUM(pc_coord_ot_total) AS pc_coord_ot_total, SUM(pc_mover_reg_rate) AS pc_mover_reg_rate, 
                      SUM(pc_mover_reg_qty) AS pc_mover_reg_qty, SUM(pc_mover_reg_total) AS pc_mover_reg_total, SUM(pc_mover_ot_rate) AS pc_mover_ot_rate, 
                      SUM(pc_mover_ot_qty) AS pc_mover_ot_qty, SUM(pc_mover_ot_total) AS pc_mover_ot_total, SUM(ProjMgr_reg_rate) AS ProjMgr_reg_rate, 
                      SUM(ProjMgr_reg_qty) AS ProjMgr_reg_qty, SUM(ProjMgr_reg_total) AS ProjMgr_reg_total, SUM(ProjMgr_ot_rate) AS ProjMgr_ot_rate, 
                      SUM(ProjMgr_ot_qty) AS ProjMgr_ot_qty, SUM(ProjMgr_ot_total) AS ProjMgr_ot_total, SUM(ProjCoor_reg_rate) AS ProjCoor_reg_rate, 
                      SUM(ProjCoor_reg_qty) AS ProjCoor_reg_qty, SUM(ProjCoor_reg_total) AS ProjCoor_reg_total, SUM(ProjCoor_ot_rate) AS ProjCoor_ot_rate, 
                      SUM(ProjCoor_ot_qty) AS ProjCoor_ot_qty, SUM(ProjCoor_ot_total) AS ProjCoor_ot_total, SUM(regProjMgr_reg_rate) AS regProjMgr_reg_rate, 
                      SUM(regProjMgr_reg_qty) AS regProjMgr_reg_qty, SUM(regProjMgr_reg_total) AS regProjMgr_reg_total, SUM(regProjMgr_ot_rate) 
                      AS regProjMgr_ot_rate, SUM(regProjMgr_ot_qty) AS regProjMgr_ot_qty, SUM(regProjMgr_ot_total) AS regProjMgr_ot_total, SUM(AssetHdlr_reg_rate) 
                      AS AssetHdlr_reg_rate, SUM(AssetHdlr_reg_qty) AS AssetHdlr_reg_qty, SUM(AssetHdlr_reg_total) AS AssetHdlr_reg_total, SUM(AssetHdlr_ot_rate) 
                      AS AssetHdlr_ot_rate, SUM(AssetHdlr_ot_qty) AS AssetHdlr_ot_qty, SUM(AssetHdlr_ot_total) AS AssetHdlr_ot_total, SUM(am_spec_reg_rate) 
                      AS am_spec_reg_rate, SUM(am_spec_reg_qty) AS am_spec_reg_qty, SUM(am_spec_reg_total) AS am_spec_reg_total, SUM(am_spec_ot_rate) 
                      AS am_spec_ot_rate, SUM(am_spec_ot_qty) AS am_spec_ot_qty, SUM(am_spec_ot_total) AS am_spec_ot_total, SUM(whse_reg_rate) 
                      AS whse_reg_rate, SUM(whse_reg_qty) AS whse_reg_qty, SUM(whse_reg_total) AS whse_reg_total, SUM(whse_ot_rate) AS whse_ot_rate, 
                      SUM(whse_ot_qty) AS whse_ot_qty, SUM(whse_ot_total) AS whse_ot_total, SUM(WhseSup_reg_rate) AS WhseSup_reg_rate, SUM(WhseSup_reg_qty) 
                      AS WhseSup_reg_qty, SUM(WhseSup_reg_total) AS WhseSup_reg_total, SUM(WhseSup_ot_rate) AS WhseSup_ot_rate, SUM(WhseSup_ot_qty) 
                      AS WhseSup_ot_qty, SUM(WhseSup_ot_total) AS WhseSup_ot_total, SUM(PieceCountIn_rate) AS PieceCountIn_rate, SUM(PieceCountIn_qty) 
                      AS PieceCountIn_qty, SUM(PieceCountIn_total) AS PieceCountIn_total, SUM(PieceCountOut_rate) AS PieceCountOut_rate, SUM(PieceCountOut_qty) 
                      AS PieceCountOut_qty, SUM(PieceCountOut_total) AS PieceCountOut_total, SUM(Freight_rate) AS freight_rate, SUM(Freight_qty) AS freight_qty, 
                      SUM(Freight_total) AS freight_total, SUM(perdiem) AS perdiem, SUM(lodging) AS lodging, SUM(travel_reg_rate) AS travel_reg_rate, SUM(travel_reg_qty) 
                      AS travel_reg_qty, SUM(travel_reg_total) AS travel_reg_total, SUM(travel_ot_rate) AS travel_ot_rate, SUM(travel_ot_qty) AS travel_ot_qty, 
                      SUM(travel_ot_total) AS travel_ot_total
FROM         dbo.SERVICE_ACCOUNT_REPORT_TEMP
GROUP BY job_id, job_no, job_name, job_no_name, DESCRIPTION, req_po_no, job_type_id, job_type_code, job_type_name, job_status_type_id, 
                      job_status_type_code, job_status_type_name, job_status_seq_no, customer_id, organization_id, dealer_name, ext_dealer_id, customer_name, 
                      ext_customer_id, INVOICE_ID, PO_NO, invoice_status_id, invoice_status_code, invoice_status_name, SERVICE_ID, SERVICE_NO, 
                      TC_SERVICE_LINE_NO, RESOURCE_TYPE_ID, resource_type_code, resource_type_name, res_cat_type_id, res_cat_type_code, res_cat_type_name, 
                      ITEM_ID, item_name, ITEM_TYPE_ID, item_type_name, item_type_code, BILLABLE_FLAG, EXT_PAY_CODE, SL_BILLABLE_FLAG, TAXABLE_FLAG, 
                      bill_total, hourly_rate, expense_rate, BILL_QTY, col1, col1_enabled, CUST_COL_1, col2, col2_enabled, CUST_COL_2, col3, col3_enabled, 
                      CUST_COL_3, col4, col4_enabled, CUST_COL_4, col5, col5_enabled, CUST_COL_5, col6, col6_enabled, CUST_COL_6, col7, col7_enabled, 
                      CUST_COL_7, col8, col8_enabled, CUST_COL_8, col9, col9_enabled, CUST_COL_9, col10, col10_enabled, CUST_COL_10, Invoice_Desc, 
                      EST_START_DATE, SCH_START_DATE, SERVICE_LINE_DATE, JOB_LOCATION_NAME
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4[30] 2[40] 3) )"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2[66] 3) )"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2) )"
      End
      ActivePaneConfig = 14
   End
   Begin DiagramPane = 
      PaneHidden = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "SERVICE_ACCOUNT_REPORT_TEMP"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 251
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      PaneHidden = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      PaneHidden = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'SERVICE_ACCOUNT_REPORT_V'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'SERVICE_ACCOUNT_REPORT_V'
GO

/****** Object:  View [dbo].[SERVICE_ACCOUNT_REPORT_NUMBERS]    Script Date: 05/03/2010 14:18:09 ******/
-- SET ANSI_NULLS ON
-- GO
-- SET QUOTED_IDENTIFIER OFF
-- GO
-- CREATE VIEW [dbo].[SERVICE_ACCOUNT_REPORT_NUMBERS]
-- AS
-- SELECT     JOB_ID, JOB_NO, JOB_NAME, JOB_NO_NAME, DESCRIPTION, req_po_no, JOB_TYPE_ID, job_type_code, job_type_name, JOB_STATUS_TYPE_ID,
--                       job_status_type_code, job_status_type_name, job_status_seq_no, CUSTOMER_ID, ORGANIZATION_ID, DEALER_NAME, EXT_DEALER_ID,
--                       CUSTOMER_NAME, job_location_name, EXT_CUSTOMER_ID, INVOICE_ID, Invoice_Desc, PO_NO, EST_START_DATE, SERVICE_LINE_DATE,
--                       invoice_status_id, invoice_status_code, invoice_status_name, SERVICE_ID, SERVICE_NO, TC_SERVICE_LINE_NO, RESOURCE_TYPE_ID,
--                       resource_type_code, resource_type_name, res_cat_type_id, res_cat_type_code, res_cat_type_name, ITEM_ID, item_name, ITEM_TYPE_ID,
--                       item_type_name, item_type_code, BILLABLE_FLAG, taxable_flag, bill_total, EXT_PAY_CODE, SL_BILLABLE_FLAG, hourly_rate, expense_rate,
--                       BILL_QTY, col1, col1_enabled, CUST_COL_1, col2, col2_enabled, CUST_COL_2, col3, col3_enabled, CUST_COL_3, col4, col4_enabled, CUST_COL_4,
--                       col5, col5_enabled, CUST_COL_5, col6, col6_enabled, CUST_COL_6, col7, col7_enabled, CUST_COL_7, col8, col8_enabled, CUST_COL_8, col9,
--                       col9_enabled, CUST_COL_9, col10, col10_enabled, CUST_COL_10, SUM(other_rate) AS other_rate, SUM(other_qty) AS other_qty, SUM(other_total)
--                       AS other_total, SUM(baggies_rate) AS baggies_rate, SUM(baggies_qty) AS baggies_qty, SUM(baggies_total) AS baggies_total, SUM(boxes_rate)
--                       AS boxes_rate, SUM(boxes_qty) AS boxes_qty, SUM(boxes_total) AS boxes_total, SUM(EquipRental_rate) AS EquipRental_rate, SUM(EquipRental_qty)
--                       AS EquipRental_qty, SUM(EquipRental_total) AS EquipRental_total, SUM(fasteners_rate) AS fasteners_rate, SUM(fasteners_qty) AS fasteners_qty,
--                       SUM(fasteners_total) AS fasteners_total, SUM(labels_rate) AS labels_rate, SUM(labels_qty) AS labels_qty, SUM(labels_total) AS labels_total,
--                       SUM(MileageInTown_rate) AS MileageInTown_rate, SUM(MileageInTown_qty) AS MileageInTown_qty, SUM(MileageInTown_total)
--                       AS MileageInTown_total, SUM(MiscHardware_rate) AS MiscHardware_rate, SUM(MiscHardware_qty) AS MiscHardware_qty, SUM(MiscHardware_total)
--                       AS MiscHardware_total, SUM(PieceCountIn_rate) AS PieceCountIn_rate, SUM(PieceCountIn_qty) AS PieceCountIn_qty, SUM(PieceCountIn_total)
--                       AS PieceCountIn_total, SUM(PieceCountOut_rate) AS PieceCountOut_rate, SUM(PieceCountOut_qty) AS PieceCountOut_qty, SUM(PieceCountOut_total)
--                       AS PieceCountOut_total, SUM(supplies_rate) AS supplies_rate, SUM(supplies_qty) AS supplies_qty, SUM(supplies_total) AS supplies_total,
--                       SUM(tape_rate) AS tape_rate, SUM(tape_qty) AS tape_qty, SUM(tape_total) AS tape_total, SUM(trash_rate) AS trash_rate, SUM(trash_qty) AS trash_qty,
--                       SUM(trash_total) AS trash_total, SUM(dollies_rate) AS dollies_rate, SUM(dollies_qty) AS dollies_qty, SUM(dollies_total) AS dollies_total,
--                       SUM(bookcarts_rate) AS bookcarts_rate, SUM(bookcarts_qty) AS bookcarts_qty, SUM(bookcarts_total) AS bookcarts_total, SUM(truck_rate)
--                       AS truck_rate, SUM(truck_qty) AS truck_qty, SUM(truck_total) AS truck_total, SUM(van_rate) AS van_rate, SUM(van_qty) AS van_qty, SUM(van_total)
--                       AS van_total, SUM(perdiem) AS perdiem, SUM(lodging) AS lodging, SUM(ac_reg_rate) AS ac_reg_rate, SUM(ac_reg_qty) AS ac_reg_qty,
--                       SUM(ac_reg_total) AS ac_reg_total, SUM(ac_ot_rate) AS ac_ot_rate, SUM(ac_ot_qty) AS ac_ot_qty, SUM(ac_ot_total) AS ac_ot_total, SUM(am_reg_rate)
--                       AS am_reg_rate, SUM(am_reg_qty) AS am_reg_qty, SUM(am_reg_total) AS am_reg_total, SUM(am_ot_rate) AS am_ot_rate, SUM(am_ot_qty)
--                       AS am_ot_qty, SUM(am_ot_total) AS am_ot_total, SUM(am_spec_reg_rate) AS am_spec_reg_rate, SUM(am_spec_reg_qty) AS am_spec_reg_qty,
--                       SUM(am_spec_reg_total) AS am_spec_reg_total, SUM(am_spec_ot_rate) AS am_spec_ot_rate, SUM(am_spec_ot_qty) AS am_spec_ot_qty,
--                       SUM(am_spec_ot_total) AS am_spec_ot_total, SUM(AssetHdlr_reg_rate) AS AssetHdlr_reg_rate, SUM(AssetHdlr_reg_qty) AS AssetHdlr_reg_qty,
--                       SUM(AssetHdlr_reg_total) AS AssetHdlr_reg_total, SUM(AssetHdlr_ot_rate) AS AssetHdlr_ot_rate, SUM(AssetHdlr_ot_qty) AS AssetHdlr_ot_qty,
--                       SUM(AssetHdlr_ot_total) AS AssetHdlr_ot_total, SUM(campfurnmgr_reg_rate) AS campfurnmgr_reg_rate, SUM(campfurnmgr_reg_qty)
--                       AS campfurnmgr_reg_qty, SUM(campfurnmgr_reg_total) AS campfurnmgr_reg_total, SUM(campfurnmgr_ot_rate) AS campfurnmgr_ot_rate,
--                       SUM(campfurnmgr_ot_qty) AS campfurnmgr_ot_qty, SUM(campfurnmgr_ot_total) AS campfurnmgr_ot_total, SUM(custom_reg_rate) AS custom_reg_rate,
--                       SUM(custom_reg_qty) AS custom_reg_qty, SUM(custom_reg_total) AS custom_reg_total, SUM(custom_ot_rate) AS custom_ot_rate,
--                       SUM(custom_ot_qty) AS custom_ot_qty, SUM(custom_ot_total) AS custom_ot_total, SUM(delivery_reg_rate) AS delivery_reg_rate,
--                       SUM(delivery_reg_qty) AS delivery_reg_qty, SUM(delivery_reg_total) AS delivery_reg_total, SUM(delivery_ot_rate) AS delivery_ot_rate,
--                       SUM(delivery_ot_qty) AS delivery_ot_qty, SUM(delivery_ot_total) AS delivery_ot_total, SUM(driver_reg_rate) AS Driver_reg_rate, SUM(driver_reg_qty)
--                       AS Driver_reg_qty, SUM(driver_reg_total) AS Driver_reg_total, SUM(driver_ot_rate) AS Driver_ot_rate, SUM(driver_ot_qty) AS Driver_ot_qty,
--                       SUM(driver_ot_total) AS Driver_ot_total, SUM(Foreman_reg_rate) AS Foreman_reg_rate, SUM(Foreman_reg_qty) AS Foreman_reg_qty,
--                       SUM(Foreman_reg_total) AS Foreman_reg_total, SUM(Foreman_ot_rate) AS Foreman_ot_rate, SUM(Foreman_ot_qty) AS Foreman_ot_qty,
--                       SUM(Foreman_ot_total) AS Foreman_ot_total, SUM(GenLabor_reg_rate) AS GenLabor_reg_rate, SUM(GenLabor_reg_qty) AS GenLabor_reg_qty,
--                       SUM(GenLabor_reg_total) AS GenLabor_reg_total, SUM(GenLabor_ot_rate) AS GenLabor_ot_rate, SUM(GenLabor_ot_qty) AS GenLabor_ot_qty,
--                       SUM(GenLabor_ot_total) AS GenLabor_ot_total, SUM(installer_reg_rate) AS installer_reg_rate, SUM(installer_reg_qty) AS installer_reg_qty,
--                       SUM(installer_reg_total) AS installer_reg_total, SUM(installer_ot_rate) AS installer_ot_rate, SUM(installer_ot_qty) AS installer_ot_qty,
--                       SUM(installer_ot_total) AS installer_ot_total, SUM(lead_reg_rate) AS lead_reg_rate, SUM(lead_reg_qty) AS lead_reg_qty, SUM(lead_reg_total)
--                       AS lead_reg_total, SUM(lead_ot_rate) AS lead_ot_rate, SUM(lead_ot_qty) AS lead_ot_qty, SUM(lead_ot_total) AS lead_ot_total, SUM(mac_reg_rate)
--                       AS mac_reg_rate, SUM(mac_reg_qty) AS mac_reg_qty, SUM(mac_reg_total) AS mac_reg_total, SUM(mac_ot_rate) AS mac_ot_rate, SUM(mac_ot_qty)
--                       AS mac_ot_qty, SUM(mac_ot_total) AS mac_ot_total, SUM(mps_reg_rate) AS mps_reg_rate, SUM(mps_reg_qty) AS mps_reg_qty, SUM(mps_reg_total)
--                       AS mps_reg_total, SUM(mps_ot_rate) AS mps_ot_rate, SUM(mps_ot_qty) AS mps_ot_qty, SUM(mps_ot_total) AS mps_ot_total,
--                       SUM(Mover_Reg_Hrs_rate) AS mover_reg_hrs_rate, SUM(Mover_Reg_Hrs_qty) AS mover_reg_hrs_qty, SUM(Mover_Reg_Hrs_total)
--                       AS mover_reg_hrs_total, SUM(Mover_OT_Hrs_rate) AS mover_ot_hrs_rate, SUM(Mover_OT_Hrs_qty) AS mover_ot_hrs_qty, SUM(Mover_OT_Hrs_total)
--                       AS mover_ot_hrs_total, SUM(pc_fab_reg_rate) AS pc_fab_reg_rate, SUM(pc_fab_reg_qty) AS pc_fab_reg_qty, SUM(pc_fab_reg_total)
--                       AS pc_fab_reg_total, SUM(pc_fab_ot_rate) AS pc_fab_ot_rate, SUM(pc_fab_ot_qty) AS pc_fab_ot_qty, SUM(pc_fab_ot_total) AS pc_fab_ot_total,
--                       SUM(pc_coord_reg_rate) AS pc_coord_reg_rate, SUM(pc_coord_reg_qty) AS pc_coord_reg_qty, SUM(pc_coord_reg_total) AS pc_coord_reg_total,
--                       SUM(pc_coord_ot_rate) AS pc_coord_ot_rate, SUM(pc_coord_ot_qty) AS pc_coord_ot_qty, SUM(pc_coord_ot_total) AS pc_coord_ot_total,
--                       SUM(pc_mover_reg_rate) AS pc_mover_reg_rate, SUM(pc_mover_reg_qty) AS pc_mover_reg_qty, SUM(pc_mover_reg_total) AS pc_mover_reg_total,
--                       SUM(pc_mover_ot_rate) AS pc_mover_ot_rate, SUM(pc_mover_ot_qty) AS pc_mover_ot_qty, SUM(pc_mover_ot_total) AS pc_mover_ot_total,
--                       SUM(ProjMgr_reg_rate) AS ProjMgr_reg_rate, SUM(ProjMgr_reg_qty) AS ProjMgr_reg_qty, SUM(ProjMgr_reg_total) AS ProjMgr_reg_total,
--                       SUM(ProjMgr_ot_rate) AS ProjMgr_ot_rate, SUM(ProjMgr_ot_qty) AS ProjMgr_ot_qty, SUM(ProjMgr_ot_total) AS ProjMgr_ot_total, SUM(ps_reg_rate)
--                       AS ps_reg_rate, SUM(ps_reg_qty) AS ps_reg_qty, SUM(ps_reg_total) AS ps_reg_total, SUM(ps_ot_rate) AS ps_ot_rate, SUM(ps_ot_qty) AS ps_ot_qty,
--                       SUM(ps_ot_total) AS ps_ot_total, SUM(regProjMgr_reg_rate) AS regProjMgr_reg_rate, SUM(regProjMgr_reg_qty) AS regProjMgr_reg_qty,
--                       SUM(regProjMgr_reg_total) AS regProjMgr_reg_total, SUM(regProjMgr_ot_rate) AS regProjMgr_ot_rate, SUM(regProjMgr_ot_qty) AS regProjMgr_ot_qty,
--                       SUM(regProjMgr_ot_total) AS regProjMgr_ot_total, SUM(sub_reg_rate) AS sub_reg_rate, SUM(sub_reg_qty) AS sub_reg_qty, SUM(sub_reg_total)
--                       AS sub_reg_total, SUM(sub_ot_rate) AS sub_ot_rate, SUM(sub_ot_qty) AS sub_ot_qty, SUM(sub_ot_total) AS sub_ot_total, SUM(sub_exp_rate)
--                       AS sub_exp_rate, SUM(sub_exp_qty) AS sub_exp_qty, SUM(sub_exp_total) AS sub_exp_total, SUM(whse_reg_rate) AS whse_reg_rate,
--                       SUM(whse_reg_qty) AS whse_reg_qty, SUM(whse_reg_total) AS whse_reg_total, SUM(whse_ot_rate) AS whse_ot_rate, SUM(whse_ot_qty)
--                       AS whse_ot_qty, SUM(whse_ot_total) AS whse_ot_total, SUM(WhseSup_reg_rate) AS WhseSup_reg_rate, SUM(WhseSup_reg_qty)
--                       AS WhseSup_reg_qty, SUM(WhseSup_reg_total) AS WhseSup_reg_total, SUM(WhseSup_ot_rate) AS WhseSup_ot_rate, SUM(WhseSup_ot_qty)
--                       AS WhseSup_ot_qty, SUM(WhseSup_ot_total) AS WhseSup_ot_total, SUM(xerox_reg_rate) AS xerox_reg_rate, SUM(xerox_reg_qty) AS xerox_reg_qty,
--                       SUM(xerox_reg_total) AS xerox_reg_total, SUM(xerox_ot_rate) AS xerox_ot_rate, SUM(xerox_ot_qty) AS xerox_ot_qty, SUM(xerox_ot_total)
--                       AS xerox_ot_total
-- FROM         dbo.SERVICE_ACCOUNT_REPORT_V
-- GROUP BY JOB_ID, JOB_NO, JOB_NAME, JOB_NO_NAME, DESCRIPTION, req_po_no, JOB_TYPE_ID, job_type_code, job_type_name, JOB_STATUS_TYPE_ID,
--                       job_status_type_code, job_status_type_name, job_status_seq_no, CUSTOMER_ID, ORGANIZATION_ID, DEALER_NAME, EXT_DEALER_ID,
--                       CUSTOMER_NAME, EXT_CUSTOMER_ID, INVOICE_ID, PO_NO, invoice_status_id, invoice_status_code, invoice_status_name, SERVICE_ID,
--                       SERVICE_NO, TC_SERVICE_LINE_NO, RESOURCE_TYPE_ID, resource_type_code, resource_type_name, res_cat_type_id, res_cat_type_code,
--                       res_cat_type_name, ITEM_ID, item_name, ITEM_TYPE_ID, item_type_name, item_type_code, BILLABLE_FLAG, EXT_PAY_CODE, SL_BILLABLE_FLAG,
--                       taxable_flag, bill_total, hourly_rate, expense_rate, BILL_QTY, col1, col1_enabled, CUST_COL_1, col2, col2_enabled, CUST_COL_2, col3, col3_enabled,
--                        CUST_COL_3, col4, col4_enabled, CUST_COL_4, col5, col5_enabled, CUST_COL_5, col6, col6_enabled, CUST_COL_6, col7, col7_enabled,
--                       CUST_COL_7, col8, col8_enabled, CUST_COL_8, col9, col9_enabled, CUST_COL_9, col10, col10_enabled, CUST_COL_10, Invoice_Desc,
--                       EST_START_DATE, SERVICE_LINE_DATE, job_location_name
-- GO

/***** Object:  View [dbo].[crystal_SCHEDULE_VS_ACTUAL_V]    Script Date: 05/03/2010 14:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[crystal_SCHEDULE_VS_ACTUAL_V]
AS
SELECT     dbo.crystal_SCH_ACT_1_V.RESOURCE_ID, dbo.crystal_SCH_ACT_1_V.resource_name, dbo.crystal_SCH_ACT_1_V.JOB_ID, 
                      dbo.crystal_SCH_ACT_1_V.JOB_NO, dbo.crystal_SCH_ACT_1_V.exploded_date, dbo.crystal_SCH_ACT_2_V.SERVICE_LINE_ID, 
                      dbo.crystal_SCH_ACT_2_V.SERVICE_LINE_DATE, dbo.crystal_SCH_ACT_2_V.ITEM_NAME, dbo.crystal_SCH_ACT_2_V.TC_QTY, 
                      dbo.crystal_SCH_ACT_2_V.OVERRIDE_DATE, dbo.crystal_SCH_ACT_2_V.VERIFIED_DATE, dbo.crystal_SCH_ACT_2_V.VERIFIED_BY
FROM         dbo.crystal_SCH_ACT_1_V LEFT OUTER JOIN
                      dbo.crystal_SCH_ACT_2_V ON dbo.crystal_SCH_ACT_1_V.RESOURCE_ID = dbo.crystal_SCH_ACT_2_V.RESOURCE_ID AND 
                      dbo.crystal_SCH_ACT_1_V.exploded_date = dbo.crystal_SCH_ACT_2_V.SERVICE_LINE_DATE AND 
                      dbo.crystal_SCH_ACT_1_V.JOB_NO = dbo.crystal_SCH_ACT_2_V.TC_JOB_NO
GO
/****** Object:  View [dbo].[JOB_PROGRESS_2_V]    Script Date: 05/03/2010 14:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[JOB_PROGRESS_2_V]
AS
SELECT     ORGANIZATION_ID, PROJECT_ID, PROJECT_NO, CUSTOMER_ID, PARENT_CUSTOMER_ID, CUSTOMER_NAME, JOB_NAME, install_foreman, 
                      JOB_STATUS_TYPE_ID, job_status_type_code, job_status_type_name, min_start_date, max_end_date, CAST(DATEDIFF([hour], min_start_date, 
                      max_end_date + 1) AS numeric) AS duration, GETDATE() AS cur_date, CAST(DATEDIFF([hour], GETDATE(), max_end_date + 1) AS numeric) 
                      AS cur_duration_left, PERCENT_COMPLETE, punchlist_count, EXT_DEALER_ID, DEALER_NAME, project_status_type_code
FROM         dbo.JOB_PROGRESS_1_V
GO
/****** Object:  View [dbo].[SERVICE_ACCOUNT_REPORT_V_AZ]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[SERVICE_ACCOUNT_REPORT_V_AZ]
AS
SELECT     job_id, job_no, job_name, job_no_name, DESCRIPTION, req_po_no, job_type_id, job_type_code, job_type_name, job_status_type_id, 
                      job_status_type_code, job_status_type_name, job_status_seq_no, customer_id, organization_id, dealer_name, ext_dealer_id, customer_name, 
                      JOB_LOCATION_NAME, ext_customer_id, INVOICE_ID, Invoice_Desc, PO_NO, EST_START_DATE, SCH_START_DATE, SERVICE_LINE_DATE, 
                      invoice_status_id, invoice_status_code, invoice_status_name, SERVICE_ID, SERVICE_NO, TC_SERVICE_LINE_NO, RESOURCE_TYPE_ID, 
                      resource_type_code, resource_type_name, res_cat_type_id, res_cat_type_code, res_cat_type_name, ITEM_ID, item_name, ITEM_TYPE_ID, 
                      item_type_name, item_type_code, BILLABLE_FLAG, TAXABLE_FLAG, bill_total, EXT_PAY_CODE, SL_BILLABLE_FLAG, hourly_rate, expense_rate, 
                      BILL_QTY, CUST_COL_1, CUST_COL_2, CUST_COL_3, CUST_COL_4, CUST_COL_5, CUST_COL_6, CUST_COL_7, CUST_COL_8, CUST_COL_9, 
                      CUST_COL_10, SUM(other_rate) AS other_rate, SUM(other_qty) AS other_qty, SUM(other_total) AS other_total, SUM(baggies_rate) AS baggies_rate, 
                      SUM(baggies_qty) AS baggies_qty, SUM(baggies_total) AS baggies_total, SUM(boxes_rate) AS boxes_rate, SUM(boxes_qty) AS boxes_qty, 
                      SUM(boxes_total) AS boxes_total, SUM(EquipRental_rate) AS EquipRental_rate, SUM(EquipRental_qty) AS EquipRental_qty, SUM(EquipRental_total) 
                      AS EquipRental_total, SUM(keys_rate) AS keys_rate, SUM(keys_qty) AS keys_qty, SUM(keys_total) AS keys_total, SUM(labels_rate) AS labels_rate, 
                      SUM(labels_qty) AS labels_qty, SUM(labels_total) AS labels_total, SUM(tape_rate) AS tape_rate, SUM(tape_qty) AS tape_qty, SUM(tape_total) 
                      AS tape_total, SUM(supplies_rate) AS supplies_rate, SUM(supplies_qty) AS supplies_qty, SUM(supplies_total) AS supplies_total, SUM(trash_rate) 
                      AS trash_rate, SUM(trash_qty) AS trash_qty, SUM(trash_total) AS trash_total, SUM(custom_reg_rate) AS custom_reg_rate, SUM(custom_reg_qty) 
                      AS custom_reg_qty, SUM(custom_reg_total) AS custom_reg_total, SUM(custom_ot_rate) AS custom_ot_rate, SUM(custom_ot_qty) AS custom_ot_qty, 
                      SUM(custom_ot_total) AS custom_ot_total, SUM(delivery_reg_rate) AS delivery_reg_rate, SUM(delivery_reg_qty) AS delivery_reg_qty, 
                      SUM(delivery_reg_total) AS delivery_reg_total, SUM(delivery_ot_rate) AS delivery_ot_rate, SUM(delivery_ot_qty) AS delivery_ot_qty, 
                      SUM(delivery_ot_total) AS delivery_ot_total, SUM(driver_reg_rate) AS Driver_reg_rate, SUM(driver_reg_qty) AS Driver_reg_qty, SUM(driver_reg_total) 
                      AS Driver_reg_total, SUM(driver_ot_rate) AS Driver_ot_rate, SUM(driver_ot_qty) AS Driver_ot_qty, SUM(driver_ot_total) AS Driver_ot_total, 
                      SUM(truck_rate) AS truck_rate, SUM(truck_qty) AS truck_qty, SUM(truck_total) AS truck_total, SUM(van_rate) AS van_rate, SUM(van_qty) AS van_qty, 
                      SUM(van_total) AS van_total, SUM(MileageInTown_rate) AS MileageInTown_rate, SUM(MileageInTown_qty) AS MileageInTown_qty, 
                      SUM(MileageInTown_total) AS MileageInTown_total, SUM(MileageOutTown_rate) AS MileageOutTown_rate, SUM(MileageOutTown_qty) 
                      AS MileageOutTown_qty, SUM(MileageOutTown_total) AS MileageOutTown_total, SUM(installer_reg_rate) AS installer_reg_rate, SUM(installer_reg_qty) 
                      AS installer_reg_qty, SUM(installer_reg_total) AS installer_reg_total, SUM(installer_ot_rate) AS installer_ot_rate, SUM(installer_ot_qty) 
                      AS installer_ot_qty, SUM(installer_ot_total) AS installer_ot_total, SUM(sub_reg_rate) AS sub_reg_rate, SUM(sub_reg_qty) AS sub_reg_qty, 
                      SUM(sub_reg_total) AS sub_reg_total, SUM(sub_ot_rate) AS sub_ot_rate, SUM(sub_ot_qty) AS sub_ot_qty, SUM(sub_ot_total) AS sub_ot_total, 
                      SUM(sub_exp_rate) AS sub_exp_rate, SUM(sub_exp_qty) AS sub_exp_qty, SUM(sub_exp_total) AS sub_exp_total, SUM(GenLabor_reg_rate) 
                      AS GenLabor_reg_rate, SUM(GenLabor_reg_qty) AS GenLabor_reg_qty, SUM(GenLabor_reg_total) AS GenLabor_reg_total, SUM(GenLabor_ot_rate) 
                      AS GenLabor_ot_rate, SUM(GenLabor_ot_qty) AS GenLabor_ot_qty, SUM(GenLabor_ot_total) AS GenLabor_ot_total, SUM(Mover_Reg_Hrs_rate) 
                      AS mover_reg_hrs_rate, SUM(Mover_Reg_Hrs_qty) AS mover_reg_hrs_qty, SUM(Mover_Reg_Hrs_total) AS mover_reg_hrs_total, 
                      SUM(Mover_OT_Hrs_rate) AS mover_ot_hrs_rate, SUM(Mover_OT_Hrs_qty) AS mover_ot_hrs_qty, SUM(Mover_OT_Hrs_total) AS mover_ot_hrs_total, 
                      SUM(pc_fab_reg_rate) AS pc_fab_reg_rate, SUM(pc_fab_reg_qty) AS pc_fab_reg_qty, SUM(pc_fab_reg_total) AS pc_fab_reg_total, SUM(pc_fab_ot_rate) 
                      AS pc_fab_ot_rate, SUM(pc_fab_ot_qty) AS pc_fab_ot_qty, SUM(pc_fab_ot_total) AS pc_fab_ot_total, SUM(Foreman_reg_rate) AS Foreman_reg_rate, 
                      SUM(Foreman_reg_qty) AS Foreman_reg_qty, SUM(Foreman_reg_total) AS Foreman_reg_total, SUM(Foreman_ot_rate) AS Foreman_ot_rate, 
                      SUM(Foreman_ot_qty) AS Foreman_ot_qty, SUM(Foreman_ot_total) AS Foreman_ot_total, SUM(lead_reg_rate) AS lead_reg_rate, SUM(lead_reg_qty) 
                      AS lead_reg_qty, SUM(lead_reg_total) AS lead_reg_total, SUM(lead_ot_rate) AS lead_ot_rate, SUM(lead_ot_qty) AS lead_ot_qty, SUM(lead_ot_total) 
                      AS lead_ot_total, SUM(ac_reg_rate) AS ac_reg_rate, SUM(ac_reg_qty) AS ac_reg_qty, SUM(ac_reg_total) AS ac_reg_total, SUM(ac_ot_rate) 
                      AS ac_ot_rate, SUM(ac_ot_qty) AS ac_ot_qty, SUM(ac_ot_total) AS ac_ot_total, SUM(am_reg_rate) AS am_reg_rate, SUM(am_reg_qty) AS am_reg_qty, 
                      SUM(am_reg_total) AS am_reg_total, SUM(am_ot_rate) AS am_ot_rate, SUM(am_ot_qty) AS am_ot_qty, SUM(am_ot_total) AS am_ot_total, 
                      SUM(mac_reg_rate) AS mac_reg_rate, SUM(mac_reg_qty) AS mac_reg_qty, SUM(mac_reg_total) AS mac_reg_total, SUM(mac_ot_rate) AS mac_ot_rate, 
                      SUM(mac_ot_qty) AS mac_ot_qty, SUM(mac_ot_total) AS mac_ot_total, SUM(mps_reg_rate) AS mps_reg_rate, SUM(mps_reg_qty) AS mps_reg_qty, 
                      SUM(mps_reg_total) AS mps_reg_total, SUM(mps_ot_rate) AS mps_ot_rate, SUM(mps_ot_qty) AS mps_ot_qty, SUM(mps_ot_total) AS mps_ot_total, 
                      SUM(ps_reg_rate) AS ps_reg_rate, SUM(ps_reg_qty) AS ps_reg_qty, SUM(ps_reg_total) AS ps_reg_total, SUM(ps_ot_rate) AS ps_ot_rate, 
                      SUM(ps_ot_qty) AS ps_ot_qty, SUM(ps_ot_total) AS ps_ot_total, SUM(campfurnmgr_reg_rate) AS campfurnmgr_reg_rate, SUM(campfurnmgr_reg_qty) 
                      AS campfurnmgr_reg_qty, SUM(campfurnmgr_reg_total) AS campfurnmgr_reg_total, SUM(campfurnmgr_ot_rate) AS campfurnmgr_ot_rate, 
                      SUM(campfurnmgr_ot_qty) AS campfurnmgr_ot_qty, SUM(campfurnmgr_ot_total) AS campfurnmgr_ot_total, SUM(EquMovLabor_reg_rate) 
                      AS EquMovLabor_reg_rate, SUM(EquMovLabor_reg_qty) AS EquMovLabor_reg_qty, SUM(EquMovLabor_reg_total) AS EquMovLabor_reg_total, 
                      SUM(EquMovLabor_ot_rate) AS EquMovLabor_ot_rate, SUM(EquMovLabor_ot_qty) AS EquMovLabor_ot_qty, SUM(EquMovLabor_ot_total) 
                      AS EquMovLabor_ot_total, SUM(OfficeEquMgr_reg_rate) AS OfficeEquMgr_reg_rate, SUM(OfficeEquMgr_reg_qty) AS OfficeEquMgr_reg_qty, 
                      SUM(OfficeEquMgr_reg_total) AS OfficeEquMgr_reg_total, SUM(OfficeEquMgr_ot_rate) AS OfficeEquMgr_ot_rate, SUM(OfficeEquMgr_ot_qty) 
                      AS OfficeEquMgr_ot_qty, SUM(OfficeEquMgr_ot_total) AS OfficeEquMgr_ot_total, SUM(pc_coord_reg_rate) AS pc_coord_reg_rate, 
                      SUM(pc_coord_reg_qty) AS pc_coord_reg_qty, SUM(pc_coord_reg_total) AS pc_coord_reg_total, SUM(pc_coord_ot_rate) AS pc_coord_ot_rate, 
                      SUM(pc_coord_ot_qty) AS pc_coord_ot_qty, SUM(pc_coord_ot_total) AS pc_coord_ot_total, SUM(pc_mover_reg_rate) AS pc_mover_reg_rate, 
                      SUM(pc_mover_reg_qty) AS pc_mover_reg_qty, SUM(pc_mover_reg_total) AS pc_mover_reg_total, SUM(pc_mover_ot_rate) AS pc_mover_ot_rate, 
                      SUM(pc_mover_ot_qty) AS pc_mover_ot_qty, SUM(pc_mover_ot_total) AS pc_mover_ot_total, SUM(ProjMgr_reg_rate) AS ProjMgr_reg_rate, 
                      SUM(ProjMgr_reg_qty) AS ProjMgr_reg_qty, SUM(ProjMgr_reg_total) AS ProjMgr_reg_total, SUM(ProjMgr_ot_rate) AS ProjMgr_ot_rate, 
                      SUM(ProjMgr_ot_qty) AS ProjMgr_ot_qty, SUM(ProjMgr_ot_total) AS ProjMgr_ot_total, SUM(ProjCoor_reg_rate) AS ProjCoor_reg_rate, 
                      SUM(ProjCoor_reg_qty) AS ProjCoor_reg_qty, SUM(ProjCoor_reg_total) AS ProjCoor_reg_total, SUM(ProjCoor_ot_rate) AS ProjCoor_ot_rate, 
                      SUM(ProjCoor_ot_qty) AS ProjCoor_ot_qty, SUM(ProjCoor_ot_total) AS ProjCoor_ot_total, SUM(regProjMgr_reg_rate) AS regProjMgr_reg_rate, 
                      SUM(regProjMgr_reg_qty) AS regProjMgr_reg_qty, SUM(regProjMgr_reg_total) AS regProjMgr_reg_total, SUM(regProjMgr_ot_rate) 
                      AS regProjMgr_ot_rate, SUM(regProjMgr_ot_qty) AS regProjMgr_ot_qty, SUM(regProjMgr_ot_total) AS regProjMgr_ot_total, SUM(AssetHdlr_reg_rate) 
                      AS AssetHdlr_reg_rate, SUM(AssetHdlr_reg_qty) AS AssetHdlr_reg_qty, SUM(AssetHdlr_reg_total) AS AssetHdlr_reg_total, SUM(AssetHdlr_ot_rate) 
                      AS AssetHdlr_ot_rate, SUM(AssetHdlr_ot_qty) AS AssetHdlr_ot_qty, SUM(AssetHdlr_ot_total) AS AssetHdlr_ot_total, SUM(am_spec_reg_rate) 
                      AS am_spec_reg_rate, SUM(am_spec_reg_qty) AS am_spec_reg_qty, SUM(am_spec_reg_total) AS am_spec_reg_total, SUM(am_spec_ot_rate) 
                      AS am_spec_ot_rate, SUM(am_spec_ot_qty) AS am_spec_ot_qty, SUM(am_spec_ot_total) AS am_spec_ot_total, SUM(whse_reg_rate) 
                      AS whse_reg_rate, SUM(whse_reg_qty) AS whse_reg_qty, SUM(whse_reg_total) AS whse_reg_total, SUM(whse_ot_rate) AS whse_ot_rate, 
                      SUM(whse_ot_qty) AS whse_ot_qty, SUM(whse_ot_total) AS whse_ot_total, SUM(WhseSup_reg_rate) AS WhseSup_reg_rate, SUM(WhseSup_reg_qty) 
                      AS WhseSup_reg_qty, SUM(WhseSup_reg_total) AS WhseSup_reg_total, SUM(WhseSup_ot_rate) AS WhseSup_ot_rate, SUM(WhseSup_ot_qty) 
                      AS WhseSup_ot_qty, SUM(WhseSup_ot_total) AS WhseSup_ot_total, SUM(PieceCountIn_rate) AS PieceCountIn_rate, SUM(PieceCountIn_qty) 
                      AS PieceCountIn_qty, SUM(PieceCountIn_total) AS PieceCountIn_total, SUM(PieceCountOut_rate) AS PieceCountOut_rate, SUM(PieceCountOut_qty) 
                      AS PieceCountOut_qty, SUM(PieceCountOut_total) AS PieceCountOut_total, SUM(Freight_rate) AS freight_rate, SUM(Freight_qty) AS freight_qty, 
                      SUM(Freight_total) AS freight_total, SUM(perdiem) AS perdiem, SUM(lodging) AS lodging, SUM(travel_reg_rate) AS travel_reg_rate, SUM(travel_reg_qty) 
                      AS travel_reg_qty, SUM(travel_reg_total) AS travel_reg_total, SUM(travel_ot_rate) AS travel_ot_rate, SUM(travel_ot_qty) AS travel_ot_qty, 
                      SUM(travel_ot_total) AS travel_ot_total
FROM         dbo.SERVICE_ACCT_RPT_TEMP_V_AZ
GROUP BY job_id, job_no, job_name, job_no_name, DESCRIPTION, req_po_no, job_type_id, job_type_code, job_type_name, job_status_type_id, 
                      job_status_type_code, job_status_type_name, job_status_seq_no, customer_id, organization_id, dealer_name, ext_dealer_id, customer_name, 
                      ext_customer_id, INVOICE_ID, PO_NO, invoice_status_id, invoice_status_code, invoice_status_name, SERVICE_ID, SERVICE_NO, 
                      TC_SERVICE_LINE_NO, RESOURCE_TYPE_ID, resource_type_code, resource_type_name, res_cat_type_id, res_cat_type_code, res_cat_type_name, 
                      ITEM_ID, item_name, ITEM_TYPE_ID, item_type_name, item_type_code, BILLABLE_FLAG, EXT_PAY_CODE, SL_BILLABLE_FLAG, TAXABLE_FLAG, 
                      bill_total, hourly_rate, expense_rate, BILL_QTY, col1, col1_enabled, CUST_COL_1, col2, col2_enabled, CUST_COL_2, col3, col3_enabled, 
                      CUST_COL_3, col4, col4_enabled, CUST_COL_4, col5, col5_enabled, CUST_COL_5, col6, col6_enabled, CUST_COL_6, col7, col7_enabled, 
                      CUST_COL_7, col8, col8_enabled, CUST_COL_8, col9, col9_enabled, CUST_COL_9, col10, col10_enabled, CUST_COL_10, Invoice_Desc, 
                      EST_START_DATE, SCH_START_DATE, SERVICE_LINE_DATE, JOB_LOCATION_NAME
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4[30] 2[40] 3) )"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2[66] 3) )"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2) )"
      End
      ActivePaneConfig = 5
   End
   Begin DiagramPane = 
      PaneHidden = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "SERVICE_ACCT_RPT_TEMP_V_AZ"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 251
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      PaneHidden = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'SERVICE_ACCOUNT_REPORT_V_AZ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'SERVICE_ACCOUNT_REPORT_V_AZ'
GO
/****** Object:  View [dbo].[SCH_RESOURCES_ALL_JOBS_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[SCH_RESOURCES_ALL_JOBS_V]
AS
SELECT     dbo.SCH_RESOURCES_V.res_sch_id, dbo.SCH_RESOURCES_V.ORGANIZATION_ID, dbo.JOBS.JOB_ID, dbo.JOBS.JOB_NO, 
                      dbo.SCH_RESOURCES_V.SERVICE_ID, dbo.SCH_RESOURCES_V.SERVICE_NO, dbo.SCH_RESOURCES_V.HIDDEN_SERVICE_ID, 
                      dbo.SCH_RESOURCES_V.SCH_RESOURCE_ID, dbo.SCH_RESOURCES_V.RESOURCE_ID, dbo.SCH_RESOURCES_V.resource_name, 
                      dbo.SCH_RESOURCES_V.RES_STATUS_TYPE_ID, dbo.SCH_RESOURCES_V.res_status_type_code, dbo.SCH_RESOURCES_V.res_status_type_name, 
                      dbo.SCH_RESOURCES_V.REASON_TYPE_ID, dbo.SCH_RESOURCES_V.reason_type_code, dbo.SCH_RESOURCES_V.reason_type_name, 
                      dbo.SCH_RESOURCES_V.RES_CATEGORY_TYPE_ID, dbo.SCH_RESOURCES_V.res_cat_type_code, dbo.SCH_RESOURCES_V.res_cat_type_name, 
                      dbo.SCH_RESOURCES_V.RESOURCE_TYPE_ID, dbo.SCH_RESOURCES_V.resource_type_code, dbo.SCH_RESOURCES_V.resource_type_name, 
                      dbo.SCH_RESOURCES_V.UNIQUE_FLAG, dbo.SCH_RESOURCES_V.NOTES, dbo.SCH_RESOURCES_V.PIN, dbo.SCH_RESOURCES_V.FOREMAN_FLAG, 
                      dbo.SCH_RESOURCES_V.ACTIVE_FLAG, dbo.SCH_RESOURCES_V.EXT_VENDOR_ID, dbo.SCH_RESOURCES_V.employment_type_name, 
                      dbo.SCH_RESOURCES_V.employment_type_code, dbo.SCH_RESOURCES_V.EMPLOYMENT_TYPE_ID, dbo.SCH_RESOURCES_V.USER_ID, 
                      dbo.SCH_RESOURCES_V.user_full_name, dbo.SCH_RESOURCES_V.user_contact_id, dbo.SCH_RESOURCES_V.user_contact_name, 
                      dbo.SCH_RESOURCES_V.res_modified_by_name, dbo.SCH_RESOURCES_V.res_modified_by, dbo.SCH_RESOURCES_V.res_date_modified, 
                      dbo.SCH_RESOURCES_V.res_created_by_name, dbo.SCH_RESOURCES_V.res_created_by, dbo.SCH_RESOURCES_V.res_date_created, 
                      dbo.SCH_RESOURCES_V.sch_foreman_flag, dbo.SCH_RESOURCES_V.RES_START_DATE, dbo.SCH_RESOURCES_V.RES_START_TIME, 
                      dbo.SCH_RESOURCES_V.RES_END_DATE, dbo.SCH_RESOURCES_V.DATE_CONFIRMED, dbo.SCH_RESOURCES_V.RESOURCE_QTY, 
                      dbo.SCH_RESOURCES_V.SCH_NOTES, dbo.SCH_RESOURCES_V.sch_date_created, dbo.SCH_RESOURCES_V.sch_created_by, 
                      dbo.SCH_RESOURCES_V.sch_created_by_name, dbo.SCH_RESOURCES_V.sch_date_modified, dbo.SCH_RESOURCES_V.sch_modified_by, 
                      dbo.SCH_RESOURCES_V.sch_modified_by_name, dbo.SCH_RESOURCES_V.RES_END_TIME, dbo.SCH_RESOURCES_V.WEEKEND_FLAG, 
                      dbo.SCH_RESOURCES_V.report_to_name, dbo.SCH_RESOURCES_V.unconfirmed_flag, dbo.SCH_RESOURCES_V.FOREMAN_RESOURCE_ID, 
                      dbo.SCH_RESOURCES_V.actual_service_id, dbo.SCH_RESOURCES_V.WEEKEND_SCH_RESOURCE_ID, dbo.SCH_RESOURCES_V.JOB_TYPE_ID, 
                      dbo.SCH_RESOURCES_V.job_type_code, dbo.SCH_RESOURCES_V.job_type_name, dbo.SCH_RESOURCES_V.foreman_resource_name, 
                      dbo.SCH_RESOURCES_V.foreman_user_id, dbo.SCH_RESOURCES_V.DATE_TYPE_ID, dbo.SCH_RESOURCES_V.SERV_STATUS_TYPE_ID, 
                      dbo.SCH_RESOURCES_V.serv_status_type_code, dbo.SCH_RESOURCES_V.serv_status_type_name, 
                      dbo.SCH_RESOURCES_V.serv_status_type_seq_no, dbo.SCH_RESOURCES_V.SEND_TO_PDA_FLAG
FROM         dbo.JOBS LEFT OUTER JOIN
                      dbo.SCH_RESOURCES_V ON dbo.JOBS.JOB_ID = dbo.SCH_RESOURCES_V.JOB_ID
GO
/****** Object:  View [dbo].[SCH_EMAIL_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[SCH_EMAIL_V]
AS
SELECT     TOP 100 PERCENT today.ORGANIZATION_ID, today.RESOURCE_ID, today.resource_name, today.sch_foreman_flag, dbo.CONTACTS.EMAIL, 
                      today.JOB_ID, TODAYS_JOBS.JOB_NO, TODAYS_JOBS.JOB_NAME, TODAYS_JOBS.CUSTOMER_NAME, CONVERT(VARCHAR(12), 
                      today.RES_START_DATE, 101) AS res_start_date, ISNULL(CONVERT(VARCHAR(12), today.RES_END_DATE, 101), CONVERT(VARCHAR(12), GETDATE(), 
                      101)) AS res_end_date, tomorrow.JOB_ID AS new_job_id, TOMORROWS_JOBS.JOB_NO AS new_job_no, 
                      TOMORROWS_JOBS.JOB_NAME AS new_job_name, TOMORROWS_JOBS.CUSTOMER_NAME AS new_customer_name, 
                      TOMORROWS_JOBS.foreman_resource_name AS new_foreman_resource_name, dbo.SERVICES.SERVICE_ID AS new_service_id, 
                      tomorrow.SERVICE_NO AS new_service_no, tomorrow.report_to_name AS report_to_type_name, CONVERT(VARCHAR(12), tomorrow.RES_START_DATE, 
                      101) AS new_res_start_date, ISNULL(CONVERT(VARCHAR(12), tomorrow.RES_END_DATE, 101), CONVERT(VARCHAR(12), DATEADD(day, 1, GETDATE()), 
                      101)) AS new_res_end_date, tomorrow.RES_START_TIME AS new_res_start_time, dbo.JOB_LOCATIONS.JOB_LOCATION_NAME, 
                      dbo.JOB_LOCATIONS.STREET1, dbo.JOB_LOCATIONS.STREET2, dbo.JOB_LOCATIONS.STREET3, dbo.JOB_LOCATIONS.CITY, 
                      dbo.JOB_LOCATIONS.STATE, dbo.JOB_LOCATIONS.ZIP
FROM         dbo.CONTACTS RIGHT OUTER JOIN
                      dbo.JOB_LOCATIONS RIGHT OUTER JOIN
                      dbo.SERVICES ON dbo.JOB_LOCATIONS.JOB_LOCATION_ID = dbo.SERVICES.JOB_LOCATION_ID RIGHT OUTER JOIN
                      dbo.SCH_RESOURCES_V tomorrow RIGHT OUTER JOIN
                      dbo.SCH_RESOURCES_V today ON tomorrow.JOB_ID <> today.JOB_ID AND tomorrow.RESOURCE_ID = today.RESOURCE_ID LEFT OUTER JOIN
                      dbo.JOBS_V TOMORROWS_JOBS ON tomorrow.JOB_ID = TOMORROWS_JOBS.JOB_ID ON 
                      dbo.SERVICES.SERVICE_ID = tomorrow.actual_service_id ON dbo.CONTACTS.CONTACT_ID = today.user_contact_id LEFT OUTER JOIN
                      dbo.JOBS_V TODAYS_JOBS ON today.JOB_ID = TODAYS_JOBS.JOB_ID
WHERE     (CONVERT(VARCHAR(12), today.RES_START_DATE, 101) <= CAST(CONVERT(VARCHAR(12), GETDATE(), 101) AS DATETIME)) AND 
                      (ISNULL(CONVERT(VARCHAR(12), today.RES_END_DATE, 101), CONVERT(VARCHAR(12), GETDATE(), 101)) >= CAST(CONVERT(VARCHAR(12), GETDATE(),
                       101) AS DATETIME)) AND (CONVERT(VARCHAR(12), tomorrow.RES_START_DATE, 101) <= CAST(CONVERT(VARCHAR(12), DATEADD(day, 1, GETDATE()), 
                      101) AS DATETIME)) AND (ISNULL(CONVERT(VARCHAR(12), tomorrow.RES_END_DATE, 101), CONVERT(VARCHAR(12), DATEADD(day, 1, GETDATE()), 
                      101)) >= CAST(CONVERT(VARCHAR(12), DATEADD(day, 1, GETDATE()), 101) AS DATETIME)) AND (today.JOB_ID IS NOT NULL) OR
                      (CONVERT(VARCHAR(12), today.RES_START_DATE, 101) <= CAST(CONVERT(VARCHAR(12), GETDATE(), 101) AS DATETIME)) AND 
                      (ISNULL(CONVERT(VARCHAR(12), today.RES_END_DATE, 101), CONVERT(VARCHAR(12), GETDATE(), 101)) >= CAST(CONVERT(VARCHAR(12), GETDATE(),
                       101) AS DATETIME)) AND (ISNULL(CONVERT(VARCHAR(12), tomorrow.RES_END_DATE, 101), CONVERT(VARCHAR(12), DATEADD(day, 1, GETDATE()), 
                      101)) >= CAST(CONVERT(VARCHAR(12), DATEADD(day, 1, GETDATE()), 101) AS DATETIME)) AND (today.JOB_ID IS NOT NULL) AND 
                      (tomorrow.RES_START_DATE IS NULL)
GO
/****** Object:  View [dbo].[RESOURCE_ITEM_RATES_V]    Script Date: 05/03/2010 14:18:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[RESOURCE_ITEM_RATES_V]  
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
GO
/****** Object:  View [dbo].[PKT_ITEMS_V]    Script Date: 05/03/2010 14:18:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[PKT_ITEMS_V]
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
GO
