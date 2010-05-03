/* ---------------------------------------------------------------------- */
/* Script generated with: DeZign for Databases v4.1.3                     */
/* Target DBMS:           MS SQL Server 2005                              */
/* Project file:          servicetrax_2010.dez                            */
/* Project name:                                                          */
/* Author:                                                                */
/* Script type:           Database creation script                        */
/* Created on:            2010-05-03 12:21                                */
/* ---------------------------------------------------------------------- */


/* ---------------------------------------------------------------------- */
/* Tables                                                                 */
/* ---------------------------------------------------------------------- */

/* ---------------------------------------------------------------------- */
/* Add table "z_resource_items"                                           */
/* ---------------------------------------------------------------------- */

CREATE TABLE [z_resource_items] (
    [RESOURCE_ITEM_ID] NUMERIC(18) NOT NULL,
    [ITEM_ID] NUMERIC(18) NOT NULL,
    [RESOURCE_ID] NUMERIC(18) NOT NULL,
    [DEFAULT_ITEM_FLAG] VARCHAR(1) NOT NULL,
    [MAX_AMOUNT] NUMERIC(10,2),
    [DATE_CREATED] DATETIME NOT NULL,
    [CREATED_BY] NUMERIC(18) NOT NULL,
    [DATE_MODIFIED] DATETIME,
    [MODIFIED_BY] NUMERIC(18)
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "PDA_RESOURCE_SORT"                                          */
/* ---------------------------------------------------------------------- */

CREATE TABLE [PDA_RESOURCE_SORT] (
    [row_number] INTEGER IDENTITY(1,1) NOT NULL,
    [resource_id] NUMERIC(9)
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "z_resource_type_items"                                      */
/* ---------------------------------------------------------------------- */

CREATE TABLE [z_resource_type_items] (
    [RES_TYPE_ITEM_ID] NUMERIC(18) NOT NULL,
    [RESOURCE_TYPE_ID] NUMERIC(18) NOT NULL,
    [ITEM_ID] NUMERIC(18) NOT NULL,
    [DEFAULT_ITEM_FLAG] VARCHAR(1) NOT NULL,
    [DATE_CREATED] DATETIME NOT NULL,
    [CREATED_BY] NUMERIC(18) NOT NULL,
    [DATE_MODIFIED] DATETIME,
    [MODIFIED_BY] NUMERIC(18)
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "TABS"                                                       */
/* ---------------------------------------------------------------------- */

CREATE TABLE [TABS] (
    [TAB_ID] NUMERIC(18) IDENTITY(32,1) NOT NULL,
    [TEMPLATE_ID] NUMERIC(18) NOT NULL,
    [NAME] VARCHAR(50) NOT NULL,
    [SEQUENCE] NUMERIC(18) NOT NULL,
    [TYPE_CODE] VARCHAR(30) NOT NULL,
    [DEFAULT_TAB] VARCHAR(1) NOT NULL,
    [TABLE_ID] VARCHAR(50) NOT NULL,
    [PARENT_TAB_ID] NUMERIC(18),
    [TAB_LEVEL] NUMERIC(18),
    CONSTRAINT [PK_TABS_DEV_2] PRIMARY KEY ([TAB_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "TEMPLATES"                                                  */
/* ---------------------------------------------------------------------- */

CREATE TABLE [TEMPLATES] (
    [TEMPLATE_ID] NUMERIC(18) IDENTITY(73,1) NOT NULL,
    [TEMPLATE_NAME] VARCHAR(50) NOT NULL,
    CONSTRAINT [PK_TEMPLATES] PRIMARY KEY ([TEMPLATE_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "UNBILLED_REPORT_DAILYDATACAPTURE"                           */
/* ---------------------------------------------------------------------- */

CREATE TABLE [UNBILLED_REPORT_DAILYDATACAPTURE] (
    [RECORDID] INTEGER IDENTITY(1,1) NOT NULL,
    [ORGANIZATION_ID] NUMERIC(19),
    [BILL_JOB_NO] NUMERIC(19),
    [BILL_JOB_ID] NUMERIC(19),
    [job_status_type_name] VARCHAR(255),
    [job_name] VARCHAR(255),
    [BILLING_USER_ID] NUMERIC(19,5),
    [EXT_DEALER_ID] CHAR(255),
    [DEALER_NAME] VARCHAR(255),
    [CUSTOMER_NAME] VARCHAR(255),
    [job_owner] VARCHAR(500),
    [max_est_end_date] DATETIME,
    [max_est_end_date_varchar] VARCHAR(255),
    [billable_total] NUMERIC(19,5),
    [non_billable_total] NUMERIC(19,5),
    [PO_NO] VARCHAR(100),
    [PooledTotal] NUMERIC(19,5),
    [UnbilledOpsInvoicesTotal] NUMERIC(19,5),
    [NAME] VARCHAR(500),
    [DATEREPORTRUN] SMALLDATETIME,
    [USER_ID] NUMERIC(18),
    CONSTRAINT [PK_UNBILLED_REPORT_DAILYDATACAPTURE] PRIMARY KEY ([RECORDID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "EMAILS"                                                     */
/* ---------------------------------------------------------------------- */

CREATE TABLE [EMAILS] (
    [EMAIL_ID] NUMERIC(18) IDENTITY(1,1) NOT NULL,
    [PROJECT_ID] NUMERIC(18),
    [REQUEST_ID] NUMERIC(18),
    [QUOTE_ID] NUMERIC(18),
    [EMAIL_SENT_FLAG] VARCHAR(1) CONSTRAINT [DEF_EMAILS_EMAIL_SENT_FLAG] DEFAULT '(' NOT NULL,
    [FROM_EMAIL] VARCHAR(100),
    [TO_CONTACT_ID] NUMERIC(18),
    [TO_EMAIL] VARCHAR(100),
    [SUBJECT] VARCHAR(100),
    [BODY] VARCHAR(2000),
    [DATE_CREATED] DATETIME CONSTRAINT [DEF_EMAILS_DATE_CREATED] DEFAULT '(' NOT NULL,
    [CREATED_BY] NUMERIC(18) NOT NULL,
    [DATE_MODIFIED] DATETIME,
    [MODIFIED_BY] NUMERIC(18),
    CONSTRAINT [PK_EMAILS] PRIMARY KEY ([EMAIL_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "XREF_PDS"                                                   */
/* ---------------------------------------------------------------------- */

CREATE TABLE [XREF_PDS] (
    [XREF_PDS_ID] NUMERIC(18) IDENTITY(1,1) NOT NULL,
    [SERVICE_ID] NUMERIC(18) NOT NULL,
    [REP_ID] NUMERIC(18) NOT NULL,
    [PALM_USER_ID] NUMERIC(18) NOT NULL,
    CONSTRAINT [PK_XREF_PDS] PRIMARY KEY ([XREF_PDS_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "FUNCTION_GROUPS"                                            */
/* ---------------------------------------------------------------------- */

CREATE TABLE [FUNCTION_GROUPS] (
    [FUNCTION_GROUP_ID] NUMERIC(18) IDENTITY(1,1) NOT NULL,
    [NAME] VARCHAR(50) NOT NULL,
    [CODE] VARCHAR(50),
    CONSTRAINT [PK_FUNCTION_GROUPS] PRIMARY KEY ([FUNCTION_GROUP_ID]),
    CONSTRAINT [UK_FG_CODE] UNIQUE ([CODE])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "INVOICE_STATUSES"                                           */
/* ---------------------------------------------------------------------- */

CREATE TABLE [INVOICE_STATUSES] (
    [STATUS_ID] NUMERIC(18) NOT NULL,
    [CODE] VARCHAR(10) NOT NULL,
    [NAME] VARCHAR(50) NOT NULL,
    CONSTRAINT [PK_INVOICE_STATUSES] PRIMARY KEY ([STATUS_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "SEQUENCES"                                                  */
/* ---------------------------------------------------------------------- */

CREATE TABLE [SEQUENCES] (
    [SEQUENCE_ID] NUMERIC(18) IDENTITY(1,1) NOT NULL,
    [SEQ_NAME] VARCHAR(50) NOT NULL,
    [NEXT_VAL] NUMERIC(18) NOT NULL
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "SERVICE_LINE_STATUSES"                                      */
/* ---------------------------------------------------------------------- */

CREATE TABLE [SERVICE_LINE_STATUSES] (
    [STATUS_ID] NUMERIC(18) NOT NULL,
    [CODE] VARCHAR(15) NOT NULL,
    [NAME] VARCHAR(50) NOT NULL,
    CONSTRAINT [PK_SERVICE_LINE_STATUSES] PRIMARY KEY ([STATUS_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "SERVICE_STATUSES"                                           */
/* ---------------------------------------------------------------------- */

CREATE TABLE [SERVICE_STATUSES] (
    [STATUS_ID] NUMERIC(18) IDENTITY(1,1) NOT NULL,
    [CODE] VARCHAR(10) NOT NULL,
    [NAME] VARCHAR(50) NOT NULL,
    CONSTRAINT [PK_SERVICE_STATUSES] PRIMARY KEY ([STATUS_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "CUSTOMERSBUDGET"                                            */
/* ---------------------------------------------------------------------- */

CREATE TABLE [CUSTOMERSBUDGET] (
    [CUSTOMER_ID] NUMERIC(18) NOT NULL,
    [YEAR] INTEGER NOT NULL,
    [BUDGET] NUMERIC(19,5),
    CONSTRAINT [PK_CUSTOMERSBUDGET] PRIMARY KEY ([CUSTOMER_ID], [YEAR])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "XREF_ITEMS"                                                 */
/* ---------------------------------------------------------------------- */

CREATE TABLE [XREF_ITEMS] (
    [XREF_ITEM_ID] NUMERIC(18) IDENTITY(1,1) NOT NULL,
    [ITEM_ID] NUMERIC(18) NOT NULL,
    [REP_ID] NUMERIC(18) NOT NULL,
    [PALM_USER_ID] NUMERIC(18) NOT NULL,
    CONSTRAINT [PK_XREF_ITEMS] PRIMARY KEY ([XREF_ITEM_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "XREF_JOBS"                                                  */
/* ---------------------------------------------------------------------- */

CREATE TABLE [XREF_JOBS] (
    [XREF_JOB_ID] NUMERIC(18) IDENTITY(1,1) NOT NULL,
    [JOB_ID] NUMERIC(18) NOT NULL,
    [REP_ID] NUMERIC(18) NOT NULL,
    [PALM_USER_ID] NUMERIC(18) NOT NULL,
    CONSTRAINT [PK_XREF_JOBS] PRIMARY KEY ([XREF_JOB_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "XREF_NOTES"                                                 */
/* ---------------------------------------------------------------------- */

CREATE TABLE [XREF_NOTES] (
    [XREF_NOTE_ID] NUMERIC(18) IDENTITY(1,1) NOT NULL,
    [NOTE_ID] NUMERIC(18) NOT NULL,
    [REP_ID] NUMERIC(18) NOT NULL,
    [PALM_USER_ID] NUMERIC(18) NOT NULL
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "CONDITIONS"                                                 */
/* ---------------------------------------------------------------------- */

CREATE TABLE [CONDITIONS] (
    [CONDITION_ID] NUMERIC(18) IDENTITY(1,1) NOT NULL,
    [NAME] VARCHAR(250) NOT NULL,
    [ACTIVE_FLAG] VARCHAR(1),
    [SEQUENCE_NO] NUMERIC(18),
    [DATE_CREATED] DATETIME NOT NULL,
    [CREATED_BY] NUMERIC(18) NOT NULL,
    [DATE_MODIFIED] DATETIME,
    [MODIFIED_BY] NUMERIC(18),
    CONSTRAINT [PK_CONDITIONS] PRIMARY KEY ([CONDITION_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "XREF_REASONS"                                               */
/* ---------------------------------------------------------------------- */

CREATE TABLE [XREF_REASONS] (
    [XREF_REASON_ID] NUMERIC(18) IDENTITY(1,1) NOT NULL,
    [REASON_ID] NUMERIC(18) NOT NULL,
    [REP_ID] NUMERIC(18) NOT NULL,
    [PALM_USER_ID] NUMERIC(18) NOT NULL,
    CONSTRAINT [PK_XREF_REASONS] PRIMARY KEY ([XREF_REASON_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "quotes_mapping"                                             */
/* ---------------------------------------------------------------------- */

CREATE TABLE [quotes_mapping] (
    [NAME] VARCHAR(50),
    [VALUE] VARCHAR(50),
    [MAPPING_GROUP] INTEGER
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "XREF_RESOURCES"                                             */
/* ---------------------------------------------------------------------- */

CREATE TABLE [XREF_RESOURCES] (
    [XREF_RES_ID] NUMERIC(18) IDENTITY(1,1) NOT NULL,
    [RESOURCE_ID] NUMERIC(18) NOT NULL,
    [REP_ID] NUMERIC(18) NOT NULL,
    [PALM_USER_ID] NUMERIC(18) NOT NULL,
    CONSTRAINT [PK_XREF_RESOURCES] PRIMARY KEY ([XREF_RES_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "XREF_SERVICES"                                              */
/* ---------------------------------------------------------------------- */

CREATE TABLE [XREF_SERVICES] (
    [XREF_SERVICE_ID] NUMERIC(18) IDENTITY(1,1) NOT NULL,
    [SERVICE_ID] NUMERIC(18) NOT NULL,
    [REP_ID] NUMERIC(18) NOT NULL,
    [PALM_USER_ID] NUMERIC(18) NOT NULL,
    CONSTRAINT [PK_XREF_SERVICES] PRIMARY KEY ([XREF_SERVICE_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "XREF_SCHED_RESOURCES"                                       */
/* ---------------------------------------------------------------------- */

CREATE TABLE [XREF_SCHED_RESOURCES] (
    [XREF_SCHED_RESOURCE_ID] NUMERIC(18) IDENTITY(1,1) NOT NULL,
    [SCHED_RESOURCE_ID] NUMERIC(18) NOT NULL,
    [REP_ID] NUMERIC(18) NOT NULL,
    [PALM_USER_ID] NUMERIC(18) NOT NULL
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "CONSTRAINT_NAMES"                                           */
/* ---------------------------------------------------------------------- */

CREATE TABLE [CONSTRAINT_NAMES] (
    [NAME] VARCHAR(255),
    [FIELD] VARCHAR(255),
    [DESCRIPTION] VARCHAR(255)
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "countries"                                                  */
/* ---------------------------------------------------------------------- */

CREATE TABLE [countries] (
    [code] VARCHAR(2) NOT NULL,
    [name] VARCHAR(100) NOT NULL,
    CONSTRAINT [countries_pk] PRIMARY KEY ([code])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "XREF_TIME"                                                  */
/* ---------------------------------------------------------------------- */

CREATE TABLE [XREF_TIME] (
    [XREF_TIME_ID] NUMERIC(18) IDENTITY(1,1) NOT NULL,
    [TIME_ID] NUMERIC(18) NOT NULL,
    [REP_ID] NUMERIC(18) NOT NULL,
    [PALM_USER_ID] NUMERIC(18) NOT NULL,
    CONSTRAINT [PK_XREF_TIME] PRIMARY KEY ([XREF_TIME_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "FORMATS"                                                    */
/* ---------------------------------------------------------------------- */

CREATE TABLE [FORMATS] (
    [FORMAT_ID] NUMERIC(18) IDENTITY(7,1) NOT NULL,
    [NAME] VARCHAR(30) NOT NULL,
    [EXTENSION] VARCHAR(5) NOT NULL,
    [DESCRIPTION] VARCHAR(50) NOT NULL,
    [DATE_CREATED] DATETIME NOT NULL,
    [CREATED_BY] NUMERIC(18) NOT NULL,
    [DATE_MODIFIED] DATETIME,
    [MODIFIED_BY] NUMERIC(18),
    CONSTRAINT [PK_FORMATS] PRIMARY KEY ([FORMAT_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "EXPENSES_BATCH_LINES"                                       */
/* ---------------------------------------------------------------------- */

CREATE TABLE [EXPENSES_BATCH_LINES] (
    [SERVICE_LINE_ID] NUMERIC(18) NOT NULL,
    [INT_BATCH_ID] NUMERIC(18) NOT NULL,
    [EXPENSE_QTY] NUMERIC(18,2),
    [EXPENSE_RATE] NUMERIC(18,2),
    [EXPENSE_TOTAL] NUMERIC(18,2),
    [EXT_ITEM_ID] VARCHAR(30),
    [EXPENSE_EXPORT_CODE] VARCHAR(10),
    [EXT_EMPLOYEE_ID] VARCHAR(15),
    CONSTRAINT [PK_EXPENSES_BATCH_LINES] PRIMARY KEY ([SERVICE_LINE_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "PDA_ROSTER_CHANGES"                                         */
/* ---------------------------------------------------------------------- */

CREATE TABLE [PDA_ROSTER_CHANGES] (
    [PDA_ROSTER_CHANGE_ID] NUMERIC(18) IDENTITY(1,1) NOT NULL,
    [RESOURCE_ID] NUMERIC(18) NOT NULL,
    [JOB_ID] NUMERIC(18) NOT NULL,
    [DATE_CREATED] DATETIME NOT NULL,
    [CREATED_BY] NUMERIC(18) NOT NULL
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "EXPENSES_BATCHES"                                           */
/* ---------------------------------------------------------------------- */

CREATE TABLE [EXPENSES_BATCHES] (
    [INT_BATCH_ID] NUMERIC(18) IDENTITY(1,1) NOT NULL,
    [EXT_BATCH_ID] VARCHAR(15) NOT NULL,
    [ORGANIZATION_ID] NUMERIC(18) NOT NULL,
    [BEGIN_DATE] DATETIME NOT NULL,
    [END_DATE] DATETIME NOT NULL,
    [EXPENSES_BATCH_STATUS_TYPE_ID] NUMERIC(18),
    [DATE_CREATED] DATETIME,
    [CREATED_BY] NUMERIC(18),
    CONSTRAINT [PK_EXPENSES_BATCHES] PRIMARY KEY ([INT_BATCH_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "ottInvHeaderTEMP_Madison"                                   */
/* ---------------------------------------------------------------------- */

CREATE TABLE [ottInvHeaderTEMP_Madison] (
    [INVOICE_ID] NUMERIC(18) NOT NULL,
    [JOB_NO] NUMERIC(18),
    [BILLING_USER_NAME] VARCHAR(401),
    [DOCUMENT_NO] VARCHAR(30),
    [EXT_BATCH_ID] VARCHAR(15)
)
 ON [PRIMARY]
SET ANSI_PADDING OFF
ALTER TABLE [dbo].[ottInvHeaderTEMP_Madison] ADD [DESCRIPTION] [varchar](500) NULL
SET ANSI_PADDING ON
ALTER TABLE [dbo].[ottInvHeaderTEMP_Madison] ADD [PO_NO] [varchar](200) NULL
ALTER TABLE [dbo].[ottInvHeaderTEMP_Madison] ADD [EXT_BILL_CUST_ID] [varchar](15) NULL
ALTER TABLE [dbo].[ottInvHeaderTEMP_Madison] ADD [SALES_REPS] [varchar](100) NULL
ALTER TABLE [dbo].[ottInvHeaderTEMP_Madison] ADD [start_date] [datetime] NULL
ALTER TABLE [dbo].[ottInvHeaderTEMP_Madison] ADD [end_date] [datetime] NULL
ALTER TABLE [dbo].[ottInvHeaderTEMP_Madison] ADD [NAME] [varchar](100) NOT NULL
SET ANSI_PADDING OFF
ALTER TABLE [dbo].[ottInvHeaderTEMP_Madison] ADD [JOB_NAME] [varchar](100) NULL
ALTER TABLE [dbo].[ottInvHeaderTEMP_Madison] ADD [CUSTOMER_NAME] [varchar](65) NULL
SET ANSI_PADDING ON
ALTER TABLE [dbo].[ottInvHeaderTEMP_Madison] ADD [JOB_TYPE_CODE] [varchar](30) NULL
ALTER TABLE [dbo].[ottInvHeaderTEMP_Madison] ADD [COST_CODES] [varchar](50) NULL
GO

/* ---------------------------------------------------------------------- */
/* Add table "ottInvLineTEMP_Madison"                                     */
/* ---------------------------------------------------------------------- */

CREATE TABLE [ottInvLineTEMP_Madison] (
    [INVOICE_ID] NUMERIC(18),
    [UNIT_PRICE] NUMERIC(20,2),
    [QTY] NUMERIC(18,2),
    [LINE_DESC] TEXT,
    [EXT_ITEM_ID] VARCHAR(30)
)
 ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "USERS_CRYSTAL"                                              */
/* ---------------------------------------------------------------------- */

CREATE TABLE [USERS_CRYSTAL] (
    [login] VARCHAR(25) NOT NULL,
    [password] VARCHAR(25) NOT NULL,
    [company] VARCHAR(50),
    CONSTRAINT [PK_Users1] PRIMARY KEY ([login])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "TEMPLATE_LOCATIONS"                                         */
/* ---------------------------------------------------------------------- */

CREATE TABLE [TEMPLATE_LOCATIONS] (
    [TEMPLATE_LOCATION_ID] NUMERIC(18) IDENTITY(43,1) NOT NULL,
    [LOCATION] VARCHAR(50),
    [TARGET] VARCHAR(50),
    [LEVEL_1_TAB] NUMERIC(18),
    [LEVEL_1_TEMPLATE] NUMERIC(18),
    [LEVEL_2_TAB] NUMERIC(18),
    [LEVEL_2_TEMPLATE] NUMERIC(18),
    [LEVEL_3_TAB] NUMERIC(18),
    [LEVEL_3_TEMPLATE] NUMERIC(18),
    CONSTRAINT [PK_TEMPLATE_LOCATIONS] PRIMARY KEY ([TEMPLATE_LOCATION_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "GREAT_PLAINS_TABLES"                                        */
/* ---------------------------------------------------------------------- */

CREATE TABLE [GREAT_PLAINS_TABLES] (
    [TABLE_ID] NUMERIC(18) IDENTITY(2,1) NOT NULL,
    [TABLE_NAME] VARCHAR(50) NOT NULL,
    [GP_PHYSICAL_NAME] VARCHAR(50) NOT NULL,
    [GP_DISPLAY_NAME] VARCHAR(50) NOT NULL,
    CONSTRAINT [PK_GREAT_PLAINS_TABLES] PRIMARY KEY ([TABLE_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "AUTHENTICATION_KEYS"                                        */
/* ---------------------------------------------------------------------- */

CREATE TABLE [AUTHENTICATION_KEYS] (
    [authentication_key_id] NUMERIC(18) IDENTITY(1,1) NOT NULL,
    [auth] VARCHAR(50) NOT NULL,
    [user_id] NUMERIC(18) NOT NULL,
    [organization_id] NUMERIC(18) NOT NULL,
    [expire_date] DATETIME NOT NULL,
    CONSTRAINT [PK_AUTHENTICATION_KEYS] PRIMARY KEY ([authentication_key_id])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "ottInvHeaderTEMP"                                           */
/* ---------------------------------------------------------------------- */

CREATE TABLE [ottInvHeaderTEMP] (
    [INVOICE_ID] NUMERIC(18) NOT NULL,
    [JOB_NO] NUMERIC(18),
    [BILLING_USER_NAME] VARCHAR(401),
    [DOCUMENT_NO] VARCHAR(30),
    [EXT_BATCH_ID] VARCHAR(15)
)
 ON [PRIMARY]
SET ANSI_PADDING OFF
ALTER TABLE [dbo].[ottInvHeaderTEMP] ADD [DESCRIPTION] [varchar](500) NULL
SET ANSI_PADDING ON
ALTER TABLE [dbo].[ottInvHeaderTEMP] ADD [PO_NO] [varchar](200) NULL
SET ANSI_PADDING OFF
ALTER TABLE [dbo].[ottInvHeaderTEMP] ADD [EXT_BILL_CUST_ID] [varchar](15) NULL
SET ANSI_PADDING ON
ALTER TABLE [dbo].[ottInvHeaderTEMP] ADD [SALES_REPS] [varchar](100) NULL
ALTER TABLE [dbo].[ottInvHeaderTEMP] ADD [start_date] [datetime] NULL
ALTER TABLE [dbo].[ottInvHeaderTEMP] ADD [end_date] [datetime] NULL
ALTER TABLE [dbo].[ottInvHeaderTEMP] ADD [NAME] [varchar](100) NOT NULL
SET ANSI_PADDING OFF
ALTER TABLE [dbo].[ottInvHeaderTEMP] ADD [JOB_NAME] [varchar](100) NULL
ALTER TABLE [dbo].[ottInvHeaderTEMP] ADD [CUSTOMER_NAME] [varchar](65) NULL
SET ANSI_PADDING ON
ALTER TABLE [dbo].[ottInvHeaderTEMP] ADD [JOB_TYPE_CODE] [varchar](30) NULL
ALTER TABLE [dbo].[ottInvHeaderTEMP] ADD [COST_CODES] [varchar](50) NULL
GO

/* ---------------------------------------------------------------------- */
/* Add table "ottInvLineTEMP"                                             */
/* ---------------------------------------------------------------------- */

CREATE TABLE [ottInvLineTEMP] (
    [INVOICE_ID] NUMERIC(18),
    [UNIT_PRICE] NUMERIC(20,2),
    [QTY] NUMERIC(18,2),
    [LINE_DESC] TEXT,
    [EXT_ITEM_ID] VARCHAR(30)
)
 ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "ottInvTaxesTEMP"                                            */
/* ---------------------------------------------------------------------- */

CREATE TABLE [ottInvTaxesTEMP] (
    [INVOICE_ID] NUMERIC(18) NOT NULL,
    [Total_tax] NUMERIC(38,6)
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "ottInvHeaderTEMP_ALL"                                       */
/* ---------------------------------------------------------------------- */

CREATE TABLE [ottInvHeaderTEMP_ALL] (
    [organization_id] NUMERIC(18),
    [INVOICE_ID] NUMERIC(18) NOT NULL,
    [JOB_NO] NUMERIC(18),
    [BILLING_USER_NAME] VARCHAR(401),
    [DOCUMENT_NO] VARCHAR(30),
    [EXT_BATCH_ID] VARCHAR(15),
    [DESCRIPTION] VARCHAR(500),
    [PO_NO] VARCHAR(200),
    [EXT_BILL_CUST_ID] VARCHAR(15),
    [SALES_REPS] VARCHAR(100),
    [start_date] DATETIME,
    [end_date] DATETIME,
    [NAME] VARCHAR(100) NOT NULL,
    [JOB_NAME] VARCHAR(100),
    [CUSTOMER_NAME] VARCHAR(65),
    [JOB_TYPE_CODE] VARCHAR(30),
    [COST_CODES] VARCHAR(50)
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "ottInvLineTEMP_ALL"                                         */
/* ---------------------------------------------------------------------- */

CREATE TABLE [ottInvLineTEMP_ALL] (
    [organization_id] NUMERIC(18),
    [INVOICE_LINE_ID] NUMERIC(18),
    [INVOICE_ID] NUMERIC(18),
    [UNIT_PRICE] NUMERIC(20,2),
    [QTY] NUMERIC(18,2),
    [LINE_DESC] TEXT,
    [EXT_ITEM_ID] VARCHAR(30)
)
 ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "ottInvTaxesTEMP_ALL"                                        */
/* ---------------------------------------------------------------------- */

CREATE TABLE [ottInvTaxesTEMP_ALL] (
    [organization_id] NUMERIC(18),
    [INVOICE_ID] NUMERIC(18) NOT NULL,
    [Total_tax] NUMERIC(38,6)
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "INVOICE_BATCH_STATUSES"                                     */
/* ---------------------------------------------------------------------- */

CREATE TABLE [INVOICE_BATCH_STATUSES] (
    [STATUS_ID] NUMERIC(18) NOT NULL,
    [CODE] VARCHAR(10) NOT NULL,
    [NAME] VARCHAR(50) NOT NULL,
    CONSTRAINT [PK_INVOICE_BATCH_STATUSES] PRIMARY KEY ([STATUS_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "ITEMS_REPORTING_TYPE"                                       */
/* ---------------------------------------------------------------------- */

CREATE TABLE [ITEMS_REPORTING_TYPE] (
    [ITEMS_REPORTING_TYPE_ID] INTEGER IDENTITY(1,1) NOT NULL,
    [ITEM_NAME] VARCHAR(200) NOT NULL,
    [REPORTING_TYPE] VARCHAR(200),
    CONSTRAINT [PK_ITEMS_REPORTING_TYPE] PRIMARY KEY ([ITEM_NAME])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "NUMBERS"                                                    */
/* ---------------------------------------------------------------------- */

CREATE TABLE [NUMBERS] (
    [number] NUMERIC(18) NOT NULL,
    CONSTRAINT [PK_Table1] PRIMARY KEY ([number])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "ORG_GP_TABLES"                                              */
/* ---------------------------------------------------------------------- */

CREATE TABLE [ORG_GP_TABLES] (
    [ORG_TABLE_ID] NUMERIC(18) IDENTITY(7,1) NOT NULL,
    [TABLE_ID] NUMERIC(18) NOT NULL,
    [ORG_ID] NUMERIC(18) NOT NULL,
    [VIEW_NAME] VARCHAR(50) NOT NULL,
    CONSTRAINT [PK_ORG_GP_TABLES] PRIMARY KEY ([ORG_TABLE_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "ROLE_FUNCTION_RIGHTS"                                       */
/* ---------------------------------------------------------------------- */

CREATE TABLE [ROLE_FUNCTION_RIGHTS] (
    [ROLE_FUNCTION_RIGHT_ID] NUMERIC(18) IDENTITY(29640,1) NOT NULL,
    [ROLE_ID] NUMERIC(18) NOT NULL,
    [FUNCTION_ID] NUMERIC(18) NOT NULL,
    [RIGHT_TYPE_ID] NUMERIC(18),
    [DATE_CREATED] DATETIME NOT NULL,
    [CREATED_BY] NUMERIC(18) NOT NULL,
    [DATE_MODIFIED] DATETIME,
    [MODIFIED_BY] NUMERIC(18),
    CONSTRAINT [PK_ROLE_FUNCTION_RIGHTS] PRIMARY KEY ([ROLE_FUNCTION_RIGHT_ID]),
    CONSTRAINT [UK_RFR] UNIQUE ([ROLE_ID], [FUNCTION_ID], [RIGHT_TYPE_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "USER_ROLES"                                                 */
/* ---------------------------------------------------------------------- */

CREATE TABLE [USER_ROLES] (
    [USER_ID] NUMERIC(18) NOT NULL,
    [ROLE_ID] NUMERIC(18) NOT NULL,
    [DATE_CREATED] DATETIME NOT NULL,
    [CREATED_BY] NUMERIC(18) NOT NULL,
    [DATE_MODIFIED] DATETIME,
    [MODIFIED_BY] NUMERIC(18),
    CONSTRAINT [PK_USER_ROLES] PRIMARY KEY ([USER_ID], [ROLE_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "LOOKUPS"                                                    */
/* ---------------------------------------------------------------------- */

CREATE TABLE [LOOKUPS] (
    [LOOKUP_ID] NUMERIC(18) IDENTITY(446,1) NOT NULL,
    [LOOKUP_TYPE_ID] NUMERIC(18) NOT NULL,
    [CODE] VARCHAR(30) NOT NULL,
    [NAME] VARCHAR(100) NOT NULL,
    [SEQUENCE_NO] NUMERIC(18) NOT NULL,
    [ACTIVE_FLAG] VARCHAR(1) NOT NULL,
    [UPDATABLE_FLAG] VARCHAR(1) NOT NULL,
    [PARENT_LOOKUP_ID] NUMERIC(18),
    [EXT_ID] VARCHAR(50),
    [ATTRIBUTE1] VARCHAR(100),
    [ATTRIBUTE2] VARCHAR(100),
    [ATTRIBUTE3] VARCHAR(100),
    [DATE_CREATED] DATETIME NOT NULL,
    [CREATED_BY] NUMERIC(18) NOT NULL,
    [DATE_MODIFIED] DATETIME,
    [MODIFIED_BY] NUMERIC(18),
    CONSTRAINT [PK_LOOKUPS] PRIMARY KEY ([LOOKUP_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "INVOICE_LINES"                                              */
/* ---------------------------------------------------------------------- */

CREATE TABLE [INVOICE_LINES] (
    [INVOICE_LINE_ID] NUMERIC(18) IDENTITY(1,1) NOT NULL,
    [INVOICE_ID] NUMERIC(18) NOT NULL,
    [ITEM_ID] NUMERIC(18),
    [INVOICE_LINE_NO] NUMERIC(18),
    [INVOICE_LINE_TYPE_ID] NUMERIC(18) CONSTRAINT [DEF_INVOICE_LINES_INVOICE_LINE_TYPE_ID] DEFAULT (,
    [DESCRIPTION] TEXT,
    [UNIT_PRICE] NUMERIC(20,2) NOT NULL,
    [QTY] NUMERIC(18,2) NOT NULL,
    [EXTENDED_PRICE] VARCHAR(isnull),
    [PO_NO] VARCHAR(100),
    [TAXABLE_FLAG] VARCHAR(1),
    [DATE_CREATED] DATETIME NOT NULL,
    [CREATED_BY] NUMERIC(18),
    [DATE_MODIFIED] DATETIME,
    [MODIFIED_BY] NUMERIC(18),
    [bill_service_id] NUMERIC(18),
    CONSTRAINT [IL_PK] PRIMARY KEY ([INVOICE_LINE_ID])
)
 ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "INVOICE_TRACKING"                                           */
/* ---------------------------------------------------------------------- */

CREATE TABLE [INVOICE_TRACKING] (
    [INVOICE_TRACKING_ID] NUMERIC(18) IDENTITY(1,1) NOT NULL,
    [INVOICE_ID] NUMERIC(18) NOT NULL,
    [INVOICE_TRACKING_TYPE_ID] NUMERIC(18) NOT NULL,
    [TO_CONTACT_ID] NUMERIC(18),
    [FROM_USER_ID] NUMERIC(18),
    [NOTES] VARCHAR(240),
    [NEW_STATUS_ID] NUMERIC(18),
    [OLD_STATUS_ID] NUMERIC(18),
    [EMAIL_SENT_FLAG] CHAR(1),
    [CREATED_BY] NUMERIC(18) NOT NULL,
    [DATE_CREATED] DATETIME NOT NULL,
    [MODIFIED_BY] NUMERIC(18),
    [DATE_MODIFIED] DATETIME,
    CONSTRAINT [PK_INVOICE_TRACKING] PRIMARY KEY ([INVOICE_TRACKING_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "SERVICE_LINES"                                              */
/* ---------------------------------------------------------------------- */

CREATE TABLE [SERVICE_LINES] (
    [ORGANIZATION_ID] NUMERIC(18),
    [SERVICE_LINE_ID] NUMERIC(18) IDENTITY(1,1) NOT NULL,
    [TC_JOB_NO] NUMERIC(18),
    [TC_SERVICE_NO] NUMERIC(18),
    [TC_SERVICE_LINE_NO] NUMERIC(18),
    [BILL_JOB_NO] NUMERIC(18),
    [BILL_SERVICE_NO] NUMERIC(18),
    [BILL_SERVICE_LINE_NO] NUMERIC(18),
    [SERVICE_LINE_DATE] DATETIME,
    [SERVICE_LINE_DATE_VARCHAR] VARCHAR(convert),
    [STATUS_ID] NUMERIC(18),
    [EXPORTED_FLAG] VARCHAR(case),
    [BILLED_FLAG] VARCHAR(case) NOT NULL,
    [POSTED_FLAG] VARCHAR(case),
    [POOLED_FLAG] VARCHAR(1) CONSTRAINT [DEF_SERVICE_LINES_POOLED_FLAG] DEFAULT '(',
    [TC_JOB_ID] NUMERIC(18),
    [TC_SERVICE_ID] NUMERIC(18),
    [BILL_JOB_ID] NUMERIC(18),
    [BILL_SERVICE_ID] NUMERIC(18),
    [PH_SERVICE_ID] NUMERIC(18),
    [RESOURCE_ID] NUMERIC(18),
    [RESOURCE_NAME] VARCHAR(200),
    [ITEM_ID] NUMERIC(18),
    [ITEM_NAME] VARCHAR(200),
    [ITEM_TYPE_CODE] VARCHAR(50),
    [INVOICE_ID] NUMERIC(18),
    [POSTED_FROM_INVOICE_ID] NUMERIC(18),
    [TAXABLE_FLAG] VARCHAR(1) CONSTRAINT [DEF_SERVICE_LINES_TAXABLE_FLAG] DEFAULT '(',
    [BILLABLE_FLAG] VARCHAR(1),
    [TC_QTY] NUMERIC(18,2) CONSTRAINT [DEF_SERVICE_LINES_TC_QTY] DEFAULT (,
    [TC_RATE] NUMERIC(11,3) CONSTRAINT [DEF_SERVICE_LINES_TC_RATE] DEFAULT (,
    [PAYROLL_QTY] NUMERIC(18,2) CONSTRAINT [DEF_SERVICE_LINES_PAYROLL_QTY] DEFAULT (,
    [PAYROLL_RATE] NUMERIC(11,3) CONSTRAINT [DEF_SERVICE_LINES_PAYROLL_RATE] DEFAULT (,
    [EXT_PAY_CODE] CHAR(7),
    [PAYROLL_EXPORTED_FLAG] VARCHAR(1) CONSTRAINT [DEF_SERVICE_LINES_PAYROLL_EXPORTED_FLAG] DEFAULT '(',
    [EXPENSE_QTY] NUMERIC(18,2) CONSTRAINT [DEF_SERVICE_LINES_EXPENSE_QTY] DEFAULT (,
    [EXPENSE_RATE] NUMERIC(11,3) CONSTRAINT [DEF_SERVICE_LINES_EXPENSE_RATE] DEFAULT (,
    [EXPENSES_EXPORTED_FLAG] VARCHAR(1) CONSTRAINT [DEF_SERVICE_LINES_EXPENSES_EXPORTED_FLAG] DEFAULT '(',
    [BILL_QTY] NUMERIC(18,2) CONSTRAINT [DEF_SERVICE_LINES_BILL_QTY] DEFAULT (,
    [BILL_RATE] NUMERIC(11,3) CONSTRAINT [DEF_SERVICE_LINES_BILL_RATE] DEFAULT (,
    [BILL_HOURLY_QTY] NUMERIC(18,2) CONSTRAINT [DEF_SERVICE_LINES_BILL_HOURLY_QTY] DEFAULT (,
    [BILL_HOURLY_RATE] NUMERIC(11,3) CONSTRAINT [DEF_SERVICE_LINES_BILL_HOURLY_RATE] DEFAULT (,
    [BILL_EXP_QTY] NUMERIC(18,2) CONSTRAINT [DEF_SERVICE_LINES_BILL_EXP_QTY] DEFAULT (,
    [BILL_EXP_RATE] NUMERIC(11,3) CONSTRAINT [DEF_SERVICE_LINES_BILL_EXP_RATE] DEFAULT (,
    [ALLOCATED_QTY] NUMERIC(18,2) CONSTRAINT [DEF_SERVICE_LINES_ALLOCATED_QTY] DEFAULT (,
    [INTERNAL_REQ_FLAG] VARCHAR(1) CONSTRAINT [DEF_SERVICE_LINES_INTERNAL_REQ_FLAG] DEFAULT '(',
    [PARTIALLY_ALLOCATED_FLAG] VARCHAR(case),
    [FULLY_ALLOCATED_FLAG] VARCHAR(case),
    [PALM_REP_ID] NUMERIC(18),
    [ENTERED_DATE] DATETIME CONSTRAINT [DEF_SERVICE_LINES_ENTERED_DATE] DEFAULT '(',
    [ENTERED_BY] NUMERIC(18),
    [ENTRY_METHOD] VARCHAR(20) CONSTRAINT [DEF_SERVICE_LINES_ENTRY_METHOD] DEFAULT '(',
    [OVERRIDE_DATE] DATETIME,
    [OVERRIDE_BY] NUMERIC(18),
    [OVERRIDE_REASON] NUMERIC(18),
    [VERIFIED_DATE] DATETIME,
    [VERIFIED_BY] NUMERIC(18),
    [DATE_CREATED] DATETIME CONSTRAINT [DEF_SERVICE_LINES_DATE_CREATED] DEFAULT '(' NOT NULL,
    [CREATED_BY] NUMERIC(18) NOT NULL,
    [DATE_MODIFIED] DATETIME,
    [MODIFIED_BY] NUMERIC(18),
    [SERVICE_LINE_WEEK] VARCHAR(dateadd),
    [SERVICE_LINE_WEEK_VARCHAR] VARCHAR(convert),
    [EXT_ID] VARCHAR(25),
    [tc_total] VARCHAR(isnull),
    [payroll_total] VARCHAR(isnull),
    [expense_total] VARCHAR(isnull),
    [bill_total] VARCHAR(isnull),
    [bill_hourly_total] VARCHAR(isnull),
    [bill_exp_total] VARCHAR(isnull),
    [INVOICE_POST_DATE] DATETIME,
    [posted_by] NUMERIC(18),
    CONSTRAINT [PK_SERVICE_LINES] PRIMARY KEY ([SERVICE_LINE_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "POOLED_HOURS_CALC"                                          */
/* ---------------------------------------------------------------------- */

CREATE TABLE [POOLED_HOURS_CALC] (
    [SERVICE_ID] NUMERIC(18) NOT NULL,
    [ITEM_ID] NUMERIC(18) NOT NULL,
    [RATE] NUMERIC(18,3) NOT NULL,
    [QTY_POOLED] NUMERIC(18,2) NOT NULL,
    [QTY_DIST] NUMERIC(18,2) NOT NULL,
    CONSTRAINT [PK_POOLED_HOURS_CALC] PRIMARY KEY ([SERVICE_ID], [ITEM_ID], [RATE])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "SCH_RESOURCES"                                              */
/* ---------------------------------------------------------------------- */

CREATE TABLE [SCH_RESOURCES] (
    [SCH_RESOURCE_ID] NUMERIC(18) IDENTITY(1,1) NOT NULL,
    [WEEKEND_SCH_RESOURCE_ID] NUMERIC(18),
    [JOB_ID] NUMERIC(18),
    [SERVICE_ID] NUMERIC(18),
    [HIDDEN_SERVICE_ID] NUMERIC(18),
    [RESOURCE_ID] NUMERIC(18) NOT NULL,
    [RES_STATUS_TYPE_ID] NUMERIC(18),
    [REASON_TYPE_ID] NUMERIC(18),
    [FOREMAN_FLAG] VARCHAR(1),
    [DATE_TYPE_ID] NUMERIC(18),
    [RES_START_DATE] DATETIME NOT NULL,
    [RES_START_TIME] DATETIME,
    [RES_END_DATE] DATETIME,
    [RES_END_TIME] DATETIME,
    [DATE_CONFIRMED] DATETIME,
    [RESOURCE_QTY] NUMERIC(18),
    [EST_HOURS] NUMERIC(18),
    [SCH_NOTES] VARCHAR(200),
    [WEEKEND_FLAG] VARCHAR(1),
    [REPORT_TO_TYPE_ID] NUMERIC(18),
    [SEND_TO_PDA_FLAG] VARCHAR(1),
    [DATE_CREATED] DATETIME NOT NULL,
    [CREATED_BY] NUMERIC(18) NOT NULL,
    [DATE_MODIFIED] DATETIME,
    [MODIFIED_BY] NUMERIC(18),
    CONSTRAINT [PK_SCH_RESOURCES] PRIMARY KEY ([SCH_RESOURCE_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "TRACKING"                                                   */
/* ---------------------------------------------------------------------- */

CREATE TABLE [TRACKING] (
    [TRACKING_ID] NUMERIC(18) IDENTITY(1,1) NOT NULL,
    [JOB_ID] NUMERIC(18) NOT NULL,
    [SERVICE_ID] NUMERIC(18),
    [TRACKING_TYPE_ID] NUMERIC(18) NOT NULL,
    [TO_CONTACT_ID] NUMERIC(18),
    [FROM_USER_ID] NUMERIC(18),
    [NOTES] VARCHAR(500),
    [NEW_STATUS_ID] NUMERIC(18),
    [OLD_STATUS_ID] NUMERIC(18),
    [PALM_REP_ID] NUMERIC(18),
    [EMAIL_SENT_FLAG] CHAR(1) CONSTRAINT [DEF_TRACKING_EMAIL_SENT_FLAG] DEFAULT '(' NOT NULL,
    [DATE_CREATED] DATETIME NOT NULL,
    [CREATED_BY] NUMERIC(18) NOT NULL,
    [DATE_MODIFIED] DATETIME,
    [MODIFIED_BY] NUMERIC(18),
    CONSTRAINT [PK_TRACKING] PRIMARY KEY ([TRACKING_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "SERVICE_TASKS"                                              */
/* ---------------------------------------------------------------------- */

CREATE TABLE [SERVICE_TASKS] (
    [SERVICE_TASK_ID] NUMERIC(10) IDENTITY(1,1) NOT NULL,
    [SERVICE_ID] NUMERIC(18) NOT NULL,
    [PHASE] VARCHAR(50) NOT NULL,
    [PHASE_NO] NUMERIC(18) NOT NULL,
    [PHASE_TYPE_ID] NUMERIC(18) NOT NULL,
    [SEQUENCE_NO] NUMERIC(18) NOT NULL,
    [SUB_ACT_TYPE_ID] NUMERIC(18) NOT NULL,
    [VENDOR_RESPONSIBLE] VARCHAR(50),
    [DESCRIPTION] VARCHAR(500),
    [DATE_CREATED] DATETIME NOT NULL,
    [CREATED_BY] NUMERIC(18) NOT NULL,
    [DATE_MODIFIED] DATETIME,
    [MODIFIED_BY] NUMERIC(18),
    CONSTRAINT [PK_SERVICE_TASKS] PRIMARY KEY ([SERVICE_TASK_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "RESOURCE_ESTIMATES"                                         */
/* ---------------------------------------------------------------------- */

CREATE TABLE [RESOURCE_ESTIMATES] (
    [RESOURCE_EST_ID] NUMERIC(18) IDENTITY(1,1) NOT NULL,
    [JOB_ID] NUMERIC(18) NOT NULL,
    [SERVICE_ID] NUMERIC(18),
    [RESOURCE_TYPE_ID] NUMERIC(18) NOT NULL,
    [JOB_ITEM_RATE_ID] NUMERIC(18),
    [UNIT_QTY] NUMERIC(18),
    [TIME_UOM_TYPE_ID] NUMERIC(18) NOT NULL,
    [TIME_QTY] NUMERIC(18),
    [START_DATE] DATETIME,
    [TOTAL_HOURS] NUMERIC(18),
    [DATE_CREATED] DATETIME NOT NULL,
    [CREATED_BY] NUMERIC(18) NOT NULL,
    [DATE_MODIFIED] DATETIME,
    [MODIFIED_BY] NUMERIC(18),
    CONSTRAINT [PK_RESOURCE_ESTIMATES] PRIMARY KEY ([RESOURCE_EST_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "QUOTE_STANDARD_CONDITIONS"                                  */
/* ---------------------------------------------------------------------- */

CREATE TABLE [QUOTE_STANDARD_CONDITIONS] (
    [QUOTE_STANDARD_CONDITION_ID] NUMERIC(18) IDENTITY(1,1) NOT NULL,
    [QUOTE_ID] NUMERIC(18) NOT NULL,
    [STANDARD_CONDITION_ID] NUMERIC(18) NOT NULL,
    [DATE_CREATED] DATETIME NOT NULL,
    [CREATED_BY] NUMERIC(18) NOT NULL,
    [DATE_MODIFIED] DATETIME,
    [MODIFIED_BY] NUMERIC(18),
    CONSTRAINT [PK_QUOTE_STANDARD_CONDITIONS] PRIMARY KEY ([QUOTE_STANDARD_CONDITION_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "FUNCTIONS"                                                  */
/* ---------------------------------------------------------------------- */

CREATE TABLE [FUNCTIONS] (
    [FUNCTION_ID] NUMERIC(18) IDENTITY(120,1) NOT NULL,
    [FUNCTION_GROUP_ID] NUMERIC(18) CONSTRAINT [DEF_FUNCTIONS_FUNCTION_GROUP_ID] DEFAULT ( NOT NULL,
    [TEMPLATE_ID] NUMERIC(18),
    [TARGET] VARCHAR(50),
    [NAME] VARCHAR(200) NOT NULL,
    [CODE] VARCHAR(50),
    [DESCRIPTION] VARCHAR(1000),
    [TEMPLATE_LOCATION_ID] NUMERIC(18),
    [SEQUENCE_NO] NUMERIC(18),
    [IS_NAV_FUNCTION] VARCHAR(1),
    [IS_MENU_FUNCTION] VARCHAR(1),
    [DATE_CREATED] DATETIME NOT NULL,
    [CREATED_BY] NUMERIC(18) NOT NULL,
    [DATE_MODIFIED] DATETIME,
    [MODIFIED_BY] NUMERIC(18),
    CONSTRAINT [FU_PK] PRIMARY KEY ([FUNCTION_ID]),
    CONSTRAINT [UK_FU_CODE] UNIQUE ([CODE])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "PUNCHLISTS"                                                 */
/* ---------------------------------------------------------------------- */

CREATE TABLE [PUNCHLISTS] (
    [PUNCHLIST_ID] NUMERIC(18) IDENTITY(1,1) NOT NULL,
    [PROJECT_ID] NUMERIC(18) NOT NULL,
    [WALKTHROUGH_DATE] DATETIME,
    [PRINT_LOCATION] VARCHAR(50),
    [CREATED_BY] NUMERIC(18) NOT NULL,
    [DATE_CREATED] DATETIME NOT NULL,
    [MODIFIED_BY] NUMERIC(18),
    [DATE_MODIFIED] DATETIME,
    [request_id] NUMERIC(18) NOT NULL,
    CONSTRAINT [PK_PUNCHLISTS] PRIMARY KEY ([PUNCHLIST_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "purchase_orders"                                            */
/* ---------------------------------------------------------------------- */

CREATE TABLE [purchase_orders] (
    [po_id] INTEGER IDENTITY(1,1) NOT NULL,
    [po_no] INTEGER NOT NULL,
    [request_id] NUMERIC(18) NOT NULL,
    [ext_po_id] CHAR(17),
    [po_status_id] NUMERIC(18) NOT NULL,
    [ext_vendor_id] CHAR(15) NOT NULL,
    [vendor_name] VARCHAR(65) NOT NULL,
    [ext_vendor_address_id] CHAR(15) NOT NULL,
    [billing_type_id] NUMERIC(18) NOT NULL,
    [item_id] NUMERIC(18) NOT NULL,
    [po_total] NUMERIC(18,2),
    [description] VARCHAR(1000),
    [date_released] DATETIME,
    [date_received] DATETIME,
    [date_canceled] DATETIME,
    [created_by] NUMERIC(18) NOT NULL,
    [date_created] DATETIME NOT NULL,
    [modified_by] NUMERIC(18),
    [date_modified] DATETIME,
    CONSTRAINT [PK_purchase_orders] PRIMARY KEY ([po_id])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "SERVICES"                                                   */
/* ---------------------------------------------------------------------- */

CREATE TABLE [SERVICES] (
    [SERVICE_ID] NUMERIC(18) IDENTITY(1,1) NOT NULL,
    [JOB_ID] NUMERIC(18) NOT NULL,
    [JOB_LOCATION_ID] NUMERIC(18),
    [REQUEST_ID] NUMERIC(18),
    [QUOTE_ID] NUMERIC(18),
    [SERVICE_NO] NUMERIC(18),
    [SERVICE_TYPE_ID] NUMERIC(18) NOT NULL,
    [SERV_STATUS_TYPE_ID] NUMERIC(18) NOT NULL,
    [DESCRIPTION] VARCHAR(1000),
    [INTERNAL_REQ_FLAG] VARCHAR(1) NOT NULL,
    [REPORT_TO_LOC_ID] NUMERIC(18),
    [CUSTOMER_REF_NO] VARCHAR(240),
    [CUSTOMER_CONTACT_ID] NUMERIC(18),
    [IDM_CONTACT_ID] NUMERIC(18),
    [SALES_CONTACT_ID] NUMERIC(18),
    [SUPPORT_CONTACT_ID] NUMERIC(18),
    [DESIGNER_CONTACT_ID] NUMERIC(18),
    [PROJECT_MGR_CONTACT_ID] NUMERIC(18),
    [PO_NO] VARCHAR(100),
    [BILLING_TYPE_ID] NUMERIC(18),
    [ORDERED_BY] NUMERIC(18),
    [ORDERED_DATE] DATETIME,
    [SCHEDULE_TYPE_ID] NUMERIC(18) NOT NULL,
    [EST_START_DATE] DATETIME,
    [EST_START_TIME] DATETIME,
    [EST_END_DATE] DATETIME,
    [TRUCK_SHIP_DATE] DATETIME,
    [TRUCK_ARRIVAL_DATE] DATETIME,
    [PRODUCT_SETUP_DESC] VARCHAR(1000),
    [DELIVERY_TYPE_ID] NUMERIC(18) NOT NULL,
    [WAREHOUSE_LOC] VARCHAR(60),
    [PRI_FURN_TYPE_ID] NUMERIC(18),
    [PRI_FURN_LINE_TYPE_ID] NUMERIC(18),
    [SEC_FURN_TYPE_ID] NUMERIC(18),
    [SEC_FURN_LINE_TYPE_ID] NUMERIC(18),
    [NUM_STATIONS] VARCHAR(30),
    [PRODUCT_QTY] VARCHAR(30),
    [WOOD_PRODUCT_TYPE_ID] NUMERIC(18),
    [BLUEPRINT_LOCATION] VARCHAR(100),
    [PUNCHLIST_TYPE_ID] NUMERIC(18),
    [QUOTE_TOTAL] NUMERIC(18),
    [HEAD_VAL_FLAG] CHAR(1),
    [LOC_VAL_FLAG] CHAR(1),
    [PROD_VAL_FLAG] CHAR(1),
    [SCH_VAL_FLAG] CHAR(1),
    [TASK_VAL_FLAG] CHAR(1),
    [RES_VAL_FLAG] CHAR(1),
    [CUST_VAL_FLAG] CHAR(1),
    [BILL_VAL_FLAG] CHAR(1),
    [CUST_COL_1] VARCHAR(200),
    [CUST_COL_2] VARCHAR(200),
    [CUST_COL_3] VARCHAR(200),
    [CUST_COL_4] VARCHAR(200),
    [CUST_COL_5] VARCHAR(200),
    [CUST_COL_6] VARCHAR(200),
    [CUST_COL_7] VARCHAR(200),
    [CUST_COL_8] VARCHAR(200),
    [CUST_COL_9] VARCHAR(200),
    [CUST_COL_10] VARCHAR(200),
    [TAXABLE_FLAG] VARCHAR(1),
    [WATCH_FLAG] VARCHAR(1),
    [WEEKEND_FLAG] VARCHAR(1),
    [MISC] VARCHAR(200),
    [DATE_CREATED] DATETIME NOT NULL,
    [CREATED_BY] NUMERIC(18) NOT NULL,
    [DATE_MODIFIED] DATETIME,
    [MODIFIED_BY] NUMERIC(18),
    [SCH_START_DATE] DATETIME,
    [SCH_START_TIME] DATETIME,
    [SCH_END_DATE] DATETIME,
    [ACT_START_DATE] DATETIME,
    [ACT_START_TIME] DATETIME,
    [ACT_END_DATE] DATETIME,
    [PRIORITY_TYPE_ID] NUMERIC(18),
    [VERSION_NO] NUMERIC(18),
    [customer_contact2_id] NUMERIC(18),
    [customer_contact3_id] NUMERIC(18),
    [customer_contact4_id] NUMERIC(18),
    [job_location_contact_id] NUMERIC(18),
    CONSTRAINT [PK_SERVICES] PRIMARY KEY ([SERVICE_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "CHECKLISTS"                                                 */
/* ---------------------------------------------------------------------- */

CREATE TABLE [CHECKLISTS] (
    [CHECKLIST_ID] NUMERIC(18) IDENTITY(1,1) NOT NULL,
    [REQUEST_ID] NUMERIC(18) NOT NULL,
    [NUM_STATIONS] NUMERIC(18),
    [DATE_CREATED] DATETIME NOT NULL,
    [CREATED_BY] NUMERIC(18) NOT NULL,
    [DATE_MODIFIED] DATETIME,
    [MODIFIED_BY] NUMERIC(18),
    CONSTRAINT [PK_CHECKLISTS] PRIMARY KEY ([CHECKLIST_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "QUOTES"                                                     */
/* ---------------------------------------------------------------------- */

CREATE TABLE [QUOTES] (
    [quote_id] NUMERIC(18) IDENTITY(1,1) NOT NULL,
    [request_id] NUMERIC(18) NOT NULL,
    [version] INTEGER,
    [sub_version] INTEGER,
    [is_sent] VARCHAR(1) NOT NULL,
    [request_type_id] NUMERIC(18) NOT NULL,
    [quote_no] NUMERIC(18) NOT NULL,
    [quote_type_id] NUMERIC(18) NOT NULL,
    [quote_status_type_id] NUMERIC(18) NOT NULL,
    [quoted_by_user_id] NUMERIC(18),
    [quoters_title] VARCHAR(100),
    [estimator_comments] VARCHAR(250),
    [description] VARCHAR(2000),
    [quote_total] NUMERIC(18,2),
    [taxable_flag] VARCHAR(1) CONSTRAINT [DEF_QUOTES_taxable_flag] DEFAULT '(',
    [taxable_amount] NUMERIC(18,2),
    [warehouse_fee_flag] VARCHAR(1),
    [date_quoted] DATETIME,
    [date_printed] DATETIME,
    [systems_shipping_method] VARCHAR(50),
    [casegoods_shipping_method] VARCHAR(50),
    [select_job_site_move-stage_environment] VARCHAR(50),
    [omni_bill_std_hours_discounted_bill_rate] VARCHAR(50),
    [net_effective_billing_rate_per_hour] VARCHAR(50),
    [roc_omni_discounted_hours-receive] VARCHAR(20),
    [roc_omni_discounted_hours-reload] VARCHAR(20),
    [roc_omni_discounted_hours-truck] VARCHAR(20),
    [roc_omni_discounted_hours-driver] VARCHAR(20),
    [roc_omni_discounted_hours-unload] VARCHAR(20),
    [roc_omni_discounted_hours-move_stage] VARCHAR(20),
    [roc_omni_discounted_hours-install] VARCHAR(20),
    [roc_omni_discounted_hours-electrical] VARCHAR(20),
    [roc_omni_discounted_hours-total] VARCHAR(20),
    [roc_industry_std_bill-receive] VARCHAR(20),
    [roc_industry_std_bill-reload] VARCHAR(20),
    [roc_industry_std_bill-truck] VARCHAR(20),
    [roc_industry_std_bill-driver] VARCHAR(20),
    [roc_industry_std_bill-unload] VARCHAR(20),
    [roc_industry_std_bill-move_stage] VARCHAR(20),
    [roc_industry_std_bill-install] VARCHAR(20),
    [roc_industry_std_bill-electrical] VARCHAR(20),
    [roc_industry_std_bill-total] VARCHAR(20),
    [roc_omni_direct_cost-receive] VARCHAR(20),
    [roc_omni_direct_cost-reload] VARCHAR(20),
    [roc_omni_direct_cost-truck] VARCHAR(20),
    [roc_omni_direct_cost-driver] VARCHAR(20),
    [roc_omni_direct_cost-unload] VARCHAR(20),
    [roc_omni_direct_cost-move-stage] VARCHAR(20),
    [roc_omni_direct_cost-install] VARCHAR(20),
    [roc_omni_direct_cost-electrical] VARCHAR(20),
    [roc_omni_direct_cost-total] VARCHAR(20),
    [ind_industry_std_hours-receive] VARCHAR(20),
    [ind_industry_std_hours-reload] VARCHAR(20),
    [ind_industry_std_hours-truck] VARCHAR(20),
    [ind_industry_std_hours-driver] VARCHAR(20),
    [ind_industry_std_hours-unload] VARCHAR(20),
    [ind_industry_std_hours-move_stage] VARCHAR(20),
    [ind_industry_std_hours-install] VARCHAR(20),
    [ind_industry_std_hours-electrical] VARCHAR(20),
    [ind_industry_std_hours-total] VARCHAR(20),
    [ind_omni_discounted_hours-receive] VARCHAR(20),
    [ind_omni_discounted_hours-reload] VARCHAR(20),
    [ind_omni_discounted_hours-truck] VARCHAR(20),
    [ind_omni_discounted_hours-driver] VARCHAR(20),
    [ind_omni_discounted_hours-unload] VARCHAR(20),
    [ind_omni_discounted_hours-move_stage] VARCHAR(20),
    [ind_omni_discounted_hours-install] VARCHAR(20),
    [ind_omni_discounted_hours-electrical] VARCHAR(20),
    [ind_omni_discounted_hours-total] VARCHAR(20),
    [ind_industry_std_bill-receive] VARCHAR(20),
    [ind_industry_std_bill-reload] VARCHAR(20),
    [ind_industry_std_bill-truck] VARCHAR(20),
    [ind_industry_std_bill-driver] VARCHAR(20),
    [ind_industry_std_bill-unload] VARCHAR(20),
    [ind_industry_std_bill-move_stage] VARCHAR(20),
    [ind_industry_std_bill-install] VARCHAR(20),
    [ind_industry_std_bill-electrical] VARCHAR(20),
    [ind_industry_std_bill-total] VARCHAR(20),
    [ind_omni_discounted_bill-receive] VARCHAR(20),
    [ind_omni_discounted_bill-reload] VARCHAR(20),
    [ind_omni_discounted_bill-truck] VARCHAR(20),
    [ind_omni_discounted_bill-driver] VARCHAR(20),
    [ind_omni_discounted_bill-unload] VARCHAR(20),
    [ind_omni_discounted_bill-move_stage] VARCHAR(20),
    [ind_omni_discounted_bill-install] VARCHAR(20),
    [ind_omni_discounted_bill-electrical] VARCHAR(20),
    [ind_omni_discounted_bill-total] VARCHAR(20),
    [ind_omni_direct_cost-receive] VARCHAR(20),
    [ind_omni_direct_cost-reload] VARCHAR(20),
    [ind_omni_direct_cost-truck] VARCHAR(20),
    [ind_omni_direct_cost-driver] VARCHAR(20),
    [ind_omni_direct_cost-unload] VARCHAR(20),
    [ind_omni_direct_cost-move_stage] VARCHAR(20),
    [ind_omni_direct_cost-install] VARCHAR(20),
    [ind_omni_direct_cost-electrical] VARCHAR(20),
    [ind_omni_direct_cost-total] VARCHAR(20),
    [total-panels_non-powered] VARCHAR(10),
    [total-panels_powered] VARCHAR(10),
    [total-beltline_power] VARCHAR(10),
    [total-tiles] VARCHAR(10),
    [total-stack_fabric] VARCHAR(10),
    [total-stack_glass] VARCHAR(10),
    [total-worksurfaces] VARCHAR(10),
    [total-overheads] VARCHAR(10),
    [total-pedestals] VARCHAR(10),
    [total-tasklights] VARCHAR(10),
    [total-keyboard_trays] VARCHAR(10),
    [total-walltracks] VARCHAR(10),
    [total-doors] VARCHAR(10),
    [total-accessories] VARCHAR(10),
    [date_created] DATETIME NOT NULL,
    [created_by] NUMERIC(18) NOT NULL,
    [date_modified] DATETIME,
    [modified_by] NUMERIC(18),
    [extra_conditions] VARCHAR(1000),
    CONSTRAINT [PK_QUOTES] PRIMARY KEY ([quote_id])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "REQUEST_VENDORS"                                            */
/* ---------------------------------------------------------------------- */

CREATE TABLE [REQUEST_VENDORS] (
    [REQUEST_VENDOR_ID] NUMERIC(18) IDENTITY(1,1) NOT NULL,
    [REQUEST_ID] NUMERIC(18),
    [VENDOR_CONTACT_ID] NUMERIC(18) NOT NULL,
    [SCH_START_DATE] DATETIME,
    [SCH_START_TIME] DATETIME,
    [SCH_END_DATE] DATETIME,
    [ACT_START_DATE] DATETIME,
    [ACT_START_TIME] DATETIME,
    [ACT_END_DATE] DATETIME,
    [ESTIMATED_COST] NUMERIC(18,2) CONSTRAINT [DEF_REQUEST_VENDORS_ESTIMATED_COST] DEFAULT (,
    [TOTAL_COST] NUMERIC(18,2) CONSTRAINT [DEF_REQUEST_VENDORS_TOTAL_COST] DEFAULT (,
    [INVOICE_DATE] DATETIME,
    [INVOICE_NUMBERS] VARCHAR(1000),
    [VISIT_COUNT] INTEGER,
    [COMPLETE_FLAG] VARCHAR(1),
    [INVOICED_FLAG] VARCHAR(1),
    [VENDOR_NOTES] VARCHAR(500),
    [EMAILED_DATE] DATETIME,
    [DATE_CREATED] DATETIME NOT NULL,
    [CREATED_BY] NUMERIC(18) NOT NULL,
    [DATE_MODIFIED] DATETIME,
    [MODIFIED_BY] NUMERIC(18),
    CONSTRAINT [PK_REQUEST_VENDORS] PRIMARY KEY ([REQUEST_VENDOR_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "REQUEST_DOCUMENTS"                                          */
/* ---------------------------------------------------------------------- */

CREATE TABLE [REQUEST_DOCUMENTS] (
    [request_document_id] NUMERIC(18) IDENTITY(1,1) NOT NULL,
    [request_id] NUMERIC(18) NOT NULL,
    [name] VARCHAR(50) NOT NULL,
    [description] VARCHAR(100),
    [created_by] NUMERIC(18) NOT NULL,
    [date_created] DATETIME NOT NULL,
    [modified_by] NUMERIC(18),
    [date_modified] DATETIME,
    CONSTRAINT [PK_REQUEST_DOCUMENTS] PRIMARY KEY ([request_document_id]),
    CONSTRAINT [IX_REQUEST_DOCUMENTS] UNIQUE ([request_id], [name])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "CUSTOM_COLS"                                                */
/* ---------------------------------------------------------------------- */

CREATE TABLE [CUSTOM_COLS] (
    [CUSTOM_COL_ID] NUMERIC(18) IDENTITY(1,1) NOT NULL,
    [CUSTOM_CUST_COL_ID] NUMERIC(18) NOT NULL,
    [REQUEST_ID] NUMERIC(18),
    [SERVICE_ID] NUMERIC(18),
    [COL_VALUE] VARCHAR(500),
    [COL_TITLE] VARCHAR(25) NOT NULL,
    [COL_SEQUENCE] NUMERIC(18) NOT NULL,
    [ACTIVE_FLAG] VARCHAR(1) NOT NULL,
    [IS_MANDATORY] VARCHAR(1) NOT NULL,
    [IS_DROPLIST] VARCHAR(1) NOT NULL,
    [CREATED_BY] NUMERIC(18) NOT NULL,
    [DATE_CREATED] DATETIME CONSTRAINT [DEF_CUSTOM_COLS_DATE_CREATED] DEFAULT '(' NOT NULL,
    [MODIFIED_BY] NUMERIC(18),
    [DATE_MODIFIED] DATETIME,
    CONSTRAINT [PK_CUSTOM_COLS] PRIMARY KEY ([CUSTOM_COL_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "SERV_INV_LINES"                                             */
/* ---------------------------------------------------------------------- */

CREATE TABLE [SERV_INV_LINES] (
    [SERVICE_LINE_ID] NUMERIC(18) NOT NULL,
    [INVOICE_LINE_ID] NUMERIC(18) NOT NULL,
    CONSTRAINT [PK_SERVICE_INVOICE_LINES] PRIMARY KEY ([SERVICE_LINE_ID], [INVOICE_LINE_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "PAYROLL_BATCH_LINES"                                        */
/* ---------------------------------------------------------------------- */

CREATE TABLE [PAYROLL_BATCH_LINES] (
    [SERVICE_LINE_ID] NUMERIC(18) NOT NULL,
    [INT_BATCH_ID] NUMERIC(18) NOT NULL,
    [PAYROLL_QTY] NUMERIC(18,2),
    [PAYROLL_RATE] NUMERIC(18,2),
    [PAYROLL_TOTAL] NUMERIC(18,2),
    [EXT_ITEM_ID] VARCHAR(30),
    [EXT_EMPLOYEE_ID] VARCHAR(15),
    [EXT_PAY_CODE] CHAR(7),
    CONSTRAINT [PK_PAYROLL_LINES] PRIMARY KEY ([SERVICE_LINE_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "CHECKLIST_DATA"                                             */
/* ---------------------------------------------------------------------- */

CREATE TABLE [CHECKLIST_DATA] (
    [CHECKLIST_DATA_ID] NUMERIC(18) IDENTITY(1,1) NOT NULL,
    [CHECKLIST_ID] NUMERIC(18) NOT NULL,
    [DATA_NAME] VARCHAR(50) NOT NULL,
    [DATA_VALUE] VARCHAR(50) NOT NULL,
    [NUM_STATIONS] NUMERIC(18),
    CONSTRAINT [PK_CHECKLIST_DATA] PRIMARY KEY ([CHECKLIST_DATA_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "QUOTE_OTHER_FURNITURE_AD_HOC"                               */
/* ---------------------------------------------------------------------- */

CREATE TABLE [QUOTE_OTHER_FURNITURE_AD_HOC] (
    [QUOTE_OTHER_FURNITURE_AD_HOC_ID] NUMERIC(18) IDENTITY(1,1) NOT NULL,
    [QUOTE_ID] NUMERIC(18) NOT NULL,
    [SET_NUMBER] NUMERIC(18) NOT NULL,
    [DESCRIPTION] VARCHAR(150) NOT NULL,
    [BILL] VARCHAR(20),
    [DATE_CREATED] DATETIME NOT NULL,
    [CREATED_BY] NUMERIC(18) NOT NULL,
    [DATE_MODIFIED] DATETIME,
    [MODIFIED_BY] NUMERIC(18),
    CONSTRAINT [PK_QUOTE_OTHER_FURNITURE_AD_HOC] PRIMARY KEY ([QUOTE_OTHER_FURNITURE_AD_HOC_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "QUOTE_SPECIFY_OTHER_SERVICES"                               */
/* ---------------------------------------------------------------------- */

CREATE TABLE [QUOTE_SPECIFY_OTHER_SERVICES] (
    [QUOTE_SPECIFY_OTHER_SERVICE_ID] NUMERIC(18) IDENTITY(1,1) NOT NULL,
    [QUOTE_ID] NUMERIC(18) NOT NULL,
    [SET_NUMBER] NUMERIC(18) NOT NULL,
    [SPECIFY_SERVICE] VARCHAR(30) NOT NULL,
    [BILL] VARCHAR(20),
    [DATE_CREATED] DATETIME NOT NULL,
    [CREATED_BY] NUMERIC(18) NOT NULL,
    [DATE_MODIFIED] DATETIME,
    [MODIFIED_BY] NUMERIC(18),
    CONSTRAINT [PK_QUOTE_SPECIFY_OTHER_SERVICES] PRIMARY KEY ([QUOTE_SPECIFY_OTHER_SERVICE_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "QUOTE_OTHER_FURNITURE"                                      */
/* ---------------------------------------------------------------------- */

CREATE TABLE [QUOTE_OTHER_FURNITURE] (
    [QUOTE_OTHER_FURNITURE_ID] NUMERIC(18) IDENTITY(1,1) NOT NULL,
    [QUOTE_ID] NUMERIC(18) NOT NULL,
    [SET_NUMBER] NUMERIC(18) NOT NULL,
    [DESCRIPTION] VARCHAR(100) NOT NULL,
    [QTY] VARCHAR(20),
    [DATE_CREATED] DATETIME NOT NULL,
    [CREATED_BY] NUMERIC(18) NOT NULL,
    [DATE_MODIFIED] DATETIME,
    [MODIFIED_BY] NUMERIC(18),
    CONSTRAINT [PK_QUOTE_OTHER_FURNITURE] PRIMARY KEY ([QUOTE_OTHER_FURNITURE_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "QUOTE_WORKSTATION_CONFIGURATIONS"                           */
/* ---------------------------------------------------------------------- */

CREATE TABLE [QUOTE_WORKSTATION_CONFIGURATIONS] (
    [QUOTE_WORKSTATION_CONFIGURATION_ID] NUMERIC(18) IDENTITY(1,1) NOT NULL,
    [QUOTE_ID] NUMERIC(18) NOT NULL,
    [SET_NUMBER] NUMERIC(18) NOT NULL,
    [TYPICAL] VARCHAR(100),
    [WORKSTATION_COUNT] VARCHAR(20),
    [DOMINANT_WORKSTATION] VARCHAR(20),
    [BELTLINE_POWER] VARCHAR(20),
    [PANELS_NON-POWERED] VARCHAR(20),
    [PANELS_POWERED] VARCHAR(20),
    [TILES] VARCHAR(20),
    [STACK-ON_FRAME_FABRIC] VARCHAR(20),
    [STACK-ON_FRAME_GLASS] VARCHAR(20),
    [WORKSURFACES] VARCHAR(20),
    [OVERHEADS] VARCHAR(20),
    [PEDESTALS] VARCHAR(20),
    [TASKLIGHTS] VARCHAR(20),
    [KEYBOARD_TRAYS] VARCHAR(20),
    [WALLTRACK] VARCHAR(20),
    [DOORS] VARCHAR(20),
    [ACCESSORIES] VARCHAR(20),
    [TYPICAL_PRICE] VARCHAR(20),
    [TYPICAL_EXTENDED_PRICE] VARCHAR(20),
    [DATE_CREATED] DATETIME NOT NULL,
    [CREATED_BY] NUMERIC(18) NOT NULL,
    [DATE_MODIFIED] DATETIME,
    [MODIFIED_BY] NUMERIC(18),
    CONSTRAINT [PK_QUOTE_WORKSTATION_CONFIGURATIONS] PRIMARY KEY ([QUOTE_WORKSTATION_CONFIGURATION_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "ROLES"                                                      */
/* ---------------------------------------------------------------------- */

CREATE TABLE [ROLES] (
    [ROLE_ID] NUMERIC(18) IDENTITY(10,1) NOT NULL,
    [NAME] VARCHAR(100) NOT NULL,
    [CODE] VARCHAR(100) NOT NULL,
    [DATE_CREATED] DATETIME NOT NULL,
    [CREATED_BY] NUMERIC(18) NOT NULL,
    [DATE_MODIFIED] DATETIME,
    [MODIFIED_BY] NUMERIC(18),
    CONSTRAINT [PK_ROLES] PRIMARY KEY ([ROLE_ID]),
    CONSTRAINT [UK_RO_CODE] UNIQUE ([CODE])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "LOOKUP_TYPES"                                               */
/* ---------------------------------------------------------------------- */

CREATE TABLE [LOOKUP_TYPES] (
    [LOOKUP_TYPE_ID] NUMERIC(18) IDENTITY(1,1) NOT NULL,
    [CODE] VARCHAR(30),
    [NAME] VARCHAR(100),
    [ACTIVE_FLAG] VARCHAR(1) NOT NULL,
    [UPDATABLE_FLAG] VARCHAR(1) NOT NULL,
    [PARENT_TYPE_ID] NUMERIC(18),
    [DATE_CREATED] DATETIME NOT NULL,
    [CREATED_BY] NUMERIC(18) NOT NULL,
    [DATE_MODIFIED] DATETIME,
    [MODIFIED_BY] NUMERIC(18),
    CONSTRAINT [PK_LOOKUP_TYPES] PRIMARY KEY ([LOOKUP_TYPE_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "PUNCHLIST_ISSUES"                                           */
/* ---------------------------------------------------------------------- */

CREATE TABLE [PUNCHLIST_ISSUES] (
    [PUNCHLIST_ISSUE_ID] NUMERIC(18) IDENTITY(1,1) NOT NULL,
    [PUNCHLIST_ID] NUMERIC(18) NOT NULL,
    [STATUS_ID] NUMERIC(18) NOT NULL,
    [ISSUE_NO] NUMERIC(18) NOT NULL,
    [STATION_AREA] VARCHAR(50),
    [ROOT_CAUSE_ID] NUMERIC(18),
    [PROBLEM_DESC] VARCHAR(300),
    [COMPLETE_DATE] DATETIME,
    [SOLUTION_BY] VARCHAR(50),
    [SOLUTION_DESC] VARCHAR(300),
    [SOLUTION_DATE] DATETIME,
    [INSTALL_DESC] VARCHAR(300),
    [INSTALL_DATE] DATETIME,
    [ORDER_NO] VARCHAR(20),
    [SHIP_DATE] DATETIME,
    [DATE_CREATED] DATETIME NOT NULL,
    [CREATED_BY] NUMERIC(18) NOT NULL,
    [DATE_MODIFIED] DATETIME,
    [MODIFIED_BY] NUMERIC(18),
    CONSTRAINT [PK_PUNCHLIST_ISSUES] PRIMARY KEY ([PUNCHLIST_ISSUE_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "USER_VENDORS"                                               */
/* ---------------------------------------------------------------------- */

CREATE TABLE [USER_VENDORS] (
    [user_vendor_id] NUMERIC(18) IDENTITY(1,1) NOT NULL,
    [user_id] NUMERIC(18) NOT NULL,
    [customer_id] NUMERIC(18) NOT NULL,
    CONSTRAINT [PK_USER_VENDORS] PRIMARY KEY ([user_vendor_id])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "REQUESTS"                                                   */
/* ---------------------------------------------------------------------- */

CREATE TABLE [REQUESTS] (
    [REQUEST_ID] NUMERIC(18) IDENTITY(1,1) NOT NULL,
    [PROJECT_ID] NUMERIC(18) NOT NULL,
    [REQUEST_NO] NUMERIC(18) NOT NULL,
    [VERSION_NO] NUMERIC(18) NOT NULL,
    [REQUEST_TYPE_ID] NUMERIC(18) NOT NULL,
    [REQUEST_STATUS_TYPE_ID] NUMERIC(18) NOT NULL,
    [IS_SENT] VARCHAR(1) NOT NULL,
    [IS_SENT_DATE] DATETIME,
    [IS_QUOTED] VARCHAR(1),
    [QUOTE_REQUEST_ID] NUMERIC(18),
    [DEALER_CUST_ID] VARCHAR(50),
    [CUSTOMER_PO_NO] VARCHAR(50),
    [DEALER_PO_NO] VARCHAR(50),
    [DEALER_PO_LINE_NO] NUMERIC(18),
    [DEALER_PROJECT_NO] VARCHAR(50),
    [DESIGN_PROJECT_NO] VARCHAR(50),
    [PROJECT_VOLUME] NUMERIC(18),
    [ACCOUNT_TYPE_ID] NUMERIC(18),
    [QUOTE_TYPE_ID] NUMERIC(18),
    [QUOTE_NEEDED_BY] DATETIME,
    [JOB_LOCATION_ID] NUMERIC(18),
    [CUSTOMER_CONTACT_ID] NUMERIC(18),
    [ALT_CUSTOMER_CONTACT_ID] NUMERIC(18),
    [D_SALES_REP_CONTACT_ID] NUMERIC(18),
    [D_SALES_SUP_CONTACT_ID] NUMERIC(18),
    [D_PROJ_MGR_CONTACT_ID] NUMERIC(18),
    [D_DESIGNER_CONTACT_ID] NUMERIC(18),
    [A_M_CONTACT_ID] NUMERIC(18),
    [A_M_INSTALL_SUP_CONTACT_ID] NUMERIC(18),
    [A_D_DESIGNER_CONTACT_ID] NUMERIC(18),
    [GEN_CONTRACTOR_CONTACT_ID] NUMERIC(18),
    [ELECTRICIAN_CONTACT_ID] NUMERIC(18),
    [DATA_PHONE_CONTACT_ID] NUMERIC(18),
    [CARPET_LAYER_CONTACT_ID] NUMERIC(18),
    [BLDG_MGR_CONTACT_ID] NUMERIC(18),
    [SECURITY_CONTACT_ID] NUMERIC(18),
    [MOVER_CONTACT_ID] NUMERIC(18),
    [OTHER_CONTACT_ID] NUMERIC(18),
    [PRI_FURN_TYPE_ID] NUMERIC(18),
    [PRI_FURN_LINE_TYPE_ID] NUMERIC(18),
    [SEC_FURN_TYPE_ID] NUMERIC(18),
    [SEC_FURN_LINE_TYPE_ID] NUMERIC(18),
    [CASE_FURN_TYPE_ID] NUMERIC(18),
    [CASE_FURN_LINE_TYPE_ID] NUMERIC(18),
    [WOOD_PRODUCT_TYPE_ID] NUMERIC(18),
    [WAREHOUSE_LOC] VARCHAR(60),
    [FURN_PLAN_TYPE_ID] NUMERIC(18),
    [PLAN_LOCATION] VARCHAR(30),
    [FURN_SPEC_TYPE_ID] NUMERIC(18),
    [WORKSTATION_TYPICAL_TYPE_ID] NUMERIC(18),
    [POWER_TYPE] VARCHAR(30),
    [PUNCHLIST_ITEM_TYPE_ID] NUMERIC(18),
    [PUNCHLIST_LINE] VARCHAR(50),
    [WALL_MOUNT_TYPE_ID] NUMERIC(18),
    [INIT_PROJ_TEAM_MTG_DATE] DATETIME,
    [DESIGN_PRESENTATION_DATE] DATETIME,
    [DESIGN_COMPLETION_DATE] DATETIME,
    [SPEC_CHECK_CMPL_DATE] DATETIME,
    [DEALER_ORDER_PLACED_DATE] DATETIME,
    [INT_PRE_INSTALL_MTG_DATE] DATETIME,
    [EXT_PRE_INSTALL_MTG_DATE] DATETIME,
    [DEALER_INSTALL_PLAN_DATE] DATETIME,
    [MFG_SHIP_DATE] DATETIME,
    [PROD_DEL_TO_WH_DATE] DATETIME,
    [TRUCK_ARRIVAL_TIME] DATETIME,
    [CONSTRUCT_COMPLETE_DATE] DATETIME,
    [ELECTRICAL_COMPLETE_DATE] DATETIME,
    [CABLE_COMPLETE_DATE] DATETIME,
    [CARPET_COMPLETE_DATE] DATETIME,
    [SITE_VISIT_REQ_TYPE_ID] NUMERIC(18),
    [SITE_VISIT_DATE] DATETIME,
    [PRODUCT_DEL_TO_SITE_DATE] DATETIME,
    [SCHEDULE_TYPE_ID] NUMERIC(18),
    [EST_START_DATE] DATETIME,
    [EST_START_TIME] DATETIME,
    [EST_END_DATE] DATETIME,
    [DAYS_TO_COMPLETE] NUMERIC(5),
    [MOVE_IN_DATE] DATETIME,
    [PUNCHLIST_COMPLETE_DATE] DATETIME,
    [COORD_PHONE_DATA_TYPE_ID] NUMERIC(18),
    [COORD_WALL_COVR_TYPE_ID] NUMERIC(18),
    [COORD_FLOOR_COVR_TYPE_ID] NUMERIC(18),
    [COORD_ELECTRICAL_TYPE_ID] NUMERIC(18),
    [COORD_MOVER_TYPE_ID] NUMERIC(18),
    [ACTIVITY_TYPE_ID1] NUMERIC(18),
    [QTY1] NUMERIC(18),
    [ACTIVITY_CAT_TYPE_ID1] NUMERIC(18),
    [ACTIVITY_TYPE_ID2] NUMERIC(18),
    [QTY2] NUMERIC(18),
    [ACTIVITY_CAT_TYPE_ID2] NUMERIC(18),
    [ACTIVITY_TYPE_ID3] NUMERIC(18),
    [QTY3] NUMERIC(18),
    [ACTIVITY_CAT_TYPE_ID3] NUMERIC(18),
    [ACTIVITY_TYPE_ID4] NUMERIC(18),
    [QTY4] NUMERIC(18),
    [ACTIVITY_CAT_TYPE_ID4] NUMERIC(18),
    [ACTIVITY_TYPE_ID5] NUMERIC(18),
    [QTY5] NUMERIC(18),
    [ACTIVITY_CAT_TYPE_ID5] NUMERIC(18),
    [ACTIVITY_TYPE_ID6] NUMERIC(18),
    [QTY6] NUMERIC(18),
    [ACTIVITY_CAT_TYPE_ID6] NUMERIC(18),
    [ACTIVITY_TYPE_ID7] NUMERIC(18),
    [QTY7] NUMERIC(18),
    [ACTIVITY_CAT_TYPE_ID7] NUMERIC(18),
    [ACTIVITY_TYPE_ID8] NUMERIC(18),
    [QTY8] NUMERIC(18),
    [ACTIVITY_CAT_TYPE_ID8] NUMERIC(18),
    [ACTIVITY_TYPE_ID9] NUMERIC(18),
    [QTY9] NUMERIC(18),
    [ACTIVITY_CAT_TYPE_ID9] NUMERIC(18),
    [ACTIVITY_TYPE_ID10] NUMERIC(18),
    [QTY10] NUMERIC(18),
    [ACTIVITY_CAT_TYPE_ID10] NUMERIC(18),
    [DESCRIPTION] VARCHAR(1000),
    [APPROVAL_REQ_TYPE_ID] NUMERIC(18),
    [WHO_CAN_APPROVE_NAME] VARCHAR(60),
    [WHO_CAN_APPROVE_PHONE] VARCHAR(50),
    [REGULAR_HOURS_TYPE_ID] NUMERIC(18),
    [EVENING_HOURS_TYPE_ID] NUMERIC(18),
    [WEEKEND_HOURS_TYPE_ID] NUMERIC(18),
    [UNION_LABOR_REQ_TYPE_ID] NUMERIC(18),
    [COST_TO_CUST_TYPE_ID] NUMERIC(18),
    [COST_TO_VEND_TYPE_ID] NUMERIC(18),
    [COST_TO_JOB_TYPE_ID] NUMERIC(18),
    [WAREHOUSE_FEE_TYPE_ID] NUMERIC(18),
    [TAXABLE_FLAG] VARCHAR(1),
    [DURATION_TIME_UOM_TYPE_ID] NUMERIC(18),
    [DURATION_QTY] NUMERIC(18),
    [PHASED_INSTALL_TYPE_ID] NUMERIC(18),
    [LOADING_DOCK_TYPE_ID] NUMERIC(18),
    [DOCK_AVAILABLE_TIME] VARCHAR(30),
    [DOCK_RESERV_REQ_TYPE_ID] NUMERIC(18),
    [SEMI_ACCESS_TYPE_ID] NUMERIC(18),
    [DOCK_HEIGHT] VARCHAR(20),
    [ELEVATOR_AVAIL_TYPE_ID] NUMERIC(18),
    [ELEVATOR_AVAIL_TIME] VARCHAR(30),
    [ELEVATOR_RESERV_REQ_TYPE_ID] NUMERIC(18),
    [STAIR_CARRY_TYPE_ID] NUMERIC(18),
    [STAIR_CARRY_FLIGHTS] NUMERIC(18),
    [STAIR_CARRY_STAIRS] NUMERIC(18),
    [SMALLEST_DOOR_ELEV_WIDTH] VARCHAR(20),
    [FLOOR_PROTECTION_TYPE_ID] NUMERIC(18),
    [WALL_PROTECTION_TYPE_ID] NUMERIC(18),
    [DOORWAY_PROT_TYPE_ID] NUMERIC(18),
    [WALKBOARD_TYPE_ID] NUMERIC(18),
    [STAGING_AREA_TYPE_ID] NUMERIC(18),
    [DUMPSTER_TYPE_ID] NUMERIC(18),
    [NEW_SITE_TYPE_ID] NUMERIC(18),
    [OCCUPIED_SITE_TYPE_ID] NUMERIC(18),
    [OTHER_CONDITIONS] VARCHAR(1000),
    [P_CARD_NUMBER] VARCHAR(20),
    [FURNITURE1_CONTACT_ID] NUMERIC(18),
    [FURNITURE2_CONTACT_ID] NUMERIC(18),
    [APPROVER_CONTACT_ID] NUMERIC(18),
    [PHONE_CONTACT_ID] NUMERIC(18),
    [FLOOR_NUMBER_TYPE_ID] NUMERIC(18),
    [PRIORITY_TYPE_ID] NUMERIC(18),
    [LEVEL_TYPE_ID] NUMERIC(18),
    [FURN_REQ_TYPE_ID] NUMERIC(18),
    [CUST_CONTACT_MOD_DATE] DATETIME,
    [JOB_LOCATION_MOD_DATE] DATETIME,
    [CUST_COL_1] VARCHAR(200),
    [CUST_COL_2] VARCHAR(200),
    [CUST_COL_3] VARCHAR(200),
    [CUST_COL_4] VARCHAR(200),
    [CUST_COL_5] VARCHAR(200),
    [CUST_COL_6] VARCHAR(200),
    [CUST_COL_7] VARCHAR(200),
    [CUST_COL_8] VARCHAR(200),
    [CUST_COL_9] VARCHAR(200),
    [CUST_COL_10] VARCHAR(200),
    [IS_COPY] VARCHAR(1) CONSTRAINT [DEF_REQUESTS_IS_COPY] DEFAULT '(',
    [IS_SURVEYED] VARCHAR(1) CONSTRAINT [DEF_REQUESTS_IS_SURVEYED] DEFAULT '(',
    [FURNITURE_TYPE] VARCHAR(100),
    [FURNITURE_QTY] NUMERIC(18),
    [PROD_DISP_FLAG] VARCHAR(1) CONSTRAINT [DEF_REQUESTS_PROD_DISP_FLAG] DEFAULT '(',
    [PROD_DISP_ID] NUMERIC(18),
    [A_M_SALES_CONTACT_ID] NUMERIC(18),
    [WORK_ORDER_RECEIVED_DATE] DATETIME,
    [CSC_WO_FIELD_FLAG] VARCHAR(1) CONSTRAINT [DEF_REQUESTS_CSC_WO_FIELD_FLAG] DEFAULT '(' NOT NULL,
    [CUSTOMER_COSTING_TYPE_ID] NUMERIC(18),
    [CUSTOMER_CONTACT2_ID] NUMERIC(18),
    [CUSTOMER_CONTACT3_ID] NUMERIC(18),
    [CUSTOMER_CONTACT4_ID] NUMERIC(18),
    [JOB_LOCATION_CONTACT_ID] NUMERIC(18),
    [SYSTEM_FURNITURE_LINE_TYPE_ID] NUMERIC(18),
    [DELIVERY_TYPE_ID] NUMERIC(18),
    [OTHER_FURNITURE_TYPE_ID] NUMERIC(18),
    [OTHER_DELIVERY_TYPE_ID] NUMERIC(18),
    [OTHER_FURNITURE_DESC] VARCHAR(150),
    [SCHEDULE_WITH_CLIENT_FLAG] VARCHAR(1),
    [ORDER_TYPE_ID] NUMERIC(18),
    [IS_STAIR_CARRY_REQUIRED] VARCHAR(1),
    [DATE_CREATED] DATETIME NOT NULL,
    [CREATED_BY] NUMERIC(18) NOT NULL,
    [DATE_MODIFIED] DATETIME,
    [MODIFIED_BY] NUMERIC(18),
    CONSTRAINT [PK_REQUESTS] PRIMARY KEY ([REQUEST_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "STANDARD_CONDITIONS"                                        */
/* ---------------------------------------------------------------------- */

CREATE TABLE [STANDARD_CONDITIONS] (
    [standard_condition_id] NUMERIC(18) IDENTITY(1,1) NOT NULL,
    [name] VARCHAR(400) NOT NULL,
    [active_flag] VARCHAR(1) CONSTRAINT [DEF_STANDARD_CONDITIONS_active_flag] DEFAULT '(' NOT NULL,
    [sequence_no] NUMERIC(2) NOT NULL,
    [date_created] DATETIME NOT NULL,
    [created_by] NUMERIC(18) NOT NULL,
    [date_modified] DATETIME,
    [modified_by] NUMERIC(18),
    CONSTRAINT [PK_STANDARD_CONDITIONS] PRIMARY KEY ([standard_condition_id])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "USER_CUSTOMERS"                                             */
/* ---------------------------------------------------------------------- */

CREATE TABLE [USER_CUSTOMERS] (
    [user_customer_id] NUMERIC(18) IDENTITY(1,1) NOT NULL,
    [user_id] NUMERIC(18) NOT NULL,
    [customer_id] NUMERIC(18) NOT NULL,
    CONSTRAINT [PK_USER_CUSTOMERS] PRIMARY KEY ([user_customer_id]),
    CONSTRAINT [IX_USER_CUSTOMERS] UNIQUE ([user_id], [customer_id])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "RESOURCES"                                                  */
/* ---------------------------------------------------------------------- */

CREATE TABLE [RESOURCES] (
    [RESOURCE_ID] NUMERIC(18) IDENTITY(1,1) NOT NULL,
    [ORGANIZATION_ID] NUMERIC(18) NOT NULL,
    [NAME] VARCHAR(200) NOT NULL,
    [RES_CATEGORY_TYPE_ID] NUMERIC(18) NOT NULL,
    [RESOURCE_TYPE_ID] NUMERIC(18) NOT NULL,
    [USER_ID] NUMERIC(18) NOT NULL,
    [ATTACHED_FLAG] VARCHAR(1),
    [VENDOR_NAME] VARCHAR(50),
    [EXT_VENDOR_ID] VARCHAR(30),
    [ACTIVE_FLAG] VARCHAR(1) NOT NULL,
    [FOREMAN_FLAG] VARCHAR(1) NOT NULL,
    [NOTES] VARCHAR(500),
    [SORT_ORDER] NUMERIC(18),
    [DATE_CREATED] DATETIME NOT NULL,
    [CREATED_BY] NUMERIC(18) NOT NULL,
    [DATE_MODIFIED] DATETIME,
    [MODIFIED_BY] NUMERIC(18),
    [QP3_TEAM] VARCHAR(50),
    CONSTRAINT [PK_RESOURCES] PRIMARY KEY ([RESOURCE_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "PAYROLL_BATCHES"                                            */
/* ---------------------------------------------------------------------- */

CREATE TABLE [PAYROLL_BATCHES] (
    [INT_BATCH_ID] NUMERIC(18) IDENTITY(1,1) NOT NULL,
    [EXT_BATCH_ID] VARCHAR(15) NOT NULL,
    [ORGANIZATION_ID] NUMERIC(18) NOT NULL,
    [BEGIN_DATE] DATETIME NOT NULL,
    [END_DATE] DATETIME NOT NULL,
    [PAYROLL_BATCH_STATUS_TYPE_ID] NUMERIC(18),
    [DATE_CREATED] DATETIME,
    [CREATED_BY] NUMERIC(18),
    CONSTRAINT [PK_PAYROLL_BATCHES] PRIMARY KEY ([INT_BATCH_ID]),
    CONSTRAINT [UK_PAYROLL_BATCHES] UNIQUE ([EXT_BATCH_ID], [ORGANIZATION_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "RESOURCE_TYPES"                                             */
/* ---------------------------------------------------------------------- */

CREATE TABLE [RESOURCE_TYPES] (
    [RESOURCE_TYPE_ID] NUMERIC(18) IDENTITY(1,1) NOT NULL,
    [CODE] VARCHAR(20) NOT NULL,
    [NAME] VARCHAR(50) NOT NULL,
    [DEF_TIME_UOM_TYPE_ID] NUMERIC(18),
    [DEF_RES_CAT_TYPE_ID] NUMERIC(18),
    [ESTIMATE_HOURS_FLAG] VARCHAR(50) NOT NULL,
    [UNIQUE_FLAG] VARCHAR(1) NOT NULL,
    [SEQUENCE_NO] NUMERIC(18),
    [DATE_CREATED] DATETIME NOT NULL,
    [CREATED_BY] NUMERIC(18) NOT NULL,
    [DATE_MODIFIED] DATETIME,
    [MODIFIED_BY] NUMERIC(18),
    CONSTRAINT [PK_RESOURCE_TYPES] PRIMARY KEY ([RESOURCE_TYPE_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "RESOURCE_TYPE_ITEMS"                                        */
/* ---------------------------------------------------------------------- */

CREATE TABLE [RESOURCE_TYPE_ITEMS] (
    [RES_TYPE_ITEM_ID] NUMERIC(18) IDENTITY(14,1) NOT NULL,
    [RESOURCE_TYPE_ID] NUMERIC(18) NOT NULL,
    [ITEM_ID] NUMERIC(18) NOT NULL,
    [DEFAULT_ITEM_FLAG] VARCHAR(1) NOT NULL,
    [DATE_CREATED] DATETIME NOT NULL,
    [CREATED_BY] NUMERIC(18) NOT NULL,
    [DATE_MODIFIED] DATETIME,
    [MODIFIED_BY] NUMERIC(18),
    CONSTRAINT [PK_RESOURCE_TYPE_ITEMS] PRIMARY KEY ([RES_TYPE_ITEM_ID]),
    CONSTRAINT [IX_RTI_RESOURCE_TYPE_ITEMS] UNIQUE ([RESOURCE_TYPE_ID], [ITEM_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "RIGHT_TYPES"                                                */
/* ---------------------------------------------------------------------- */

CREATE TABLE [RIGHT_TYPES] (
    [RIGHT_TYPE_ID] NUMERIC(18) IDENTITY(5,1) NOT NULL,
    [CODE] VARCHAR(50) NOT NULL,
    [NAME] VARCHAR(50) NOT NULL,
    [DESCRIPTION] VARCHAR(200),
    [CREATED_BY] NUMERIC(18) NOT NULL,
    [DATE_CREATED] DATETIME NOT NULL,
    [MODIFIED_BY] NUMERIC(18),
    [DATE_MODIFIED] DATETIME,
    CONSTRAINT [PK_RIGHT_TYPES] PRIMARY KEY ([RIGHT_TYPE_ID]),
    CONSTRAINT [UK_RT_CODE] UNIQUE ([CODE])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "QUOTE_CONDITIONS"                                           */
/* ---------------------------------------------------------------------- */

CREATE TABLE [QUOTE_CONDITIONS] (
    [QUOTE_CONDITION_ID] NUMERIC(18) IDENTITY(1,1) NOT NULL,
    [QUOTE_ID] NUMERIC(18) NOT NULL,
    [CONDITION_ID] NUMERIC(18) NOT NULL,
    [USE_FLAG] CHAR(1) NOT NULL,
    [DATE_CREATED] DATETIME,
    [CREATED_BY] NUMERIC(18),
    [DATE_MODIFIED] DATETIME,
    [MODIFIED_BY] NUMERIC(18),
    CONSTRAINT [PK_QUOTE_CONDITIONS] PRIMARY KEY ([QUOTE_CONDITION_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "JOB_LOCATIONS"                                              */
/* ---------------------------------------------------------------------- */

CREATE TABLE [JOB_LOCATIONS] (
    [JOB_LOCATION_ID] NUMERIC(18) IDENTITY(1,1) NOT NULL,
    [CUSTOMER_ID] NUMERIC(18) NOT NULL,
    [JOB_LOCATION_NAME] VARCHAR(50) NOT NULL,
    [LOCATION_TYPE_ID] NUMERIC(18) NOT NULL,
    [EXT_ADDRESS_ID] VARCHAR(30),
    [STREET1] VARCHAR(100),
    [STREET2] VARCHAR(100),
    [STREET3] VARCHAR(100),
    [CITY] VARCHAR(50),
    [STATE] VARCHAR(2),
    [ZIP] VARCHAR(10),
    [COUNTRY] VARCHAR(100),
    [DIRECTIONS] VARCHAR(500),
    [JOB_LOC_CONTACT_ID] NUMERIC(18),
    [BLDG_MGMT_CONTACT_ID] NUMERIC(18),
    [LOADING_DOCK_TYPE_ID] NUMERIC(18),
    [DOCK_AVAILABLE_TIME] VARCHAR(30),
    [DOCK_RESERV_REQ_TYPE_ID] NUMERIC(18),
    [SEMI_ACCESS_TYPE_ID] NUMERIC(18),
    [DOCK_HEIGHT] VARCHAR(20),
    [ELEVATOR_AVAIL_TYPE_ID] NUMERIC(18),
    [ELEVATOR_RESERV_REQ_TYPE_ID] NUMERIC(18),
    [FLOOR_PROTECTION_TYPE_ID] NUMERIC(18),
    [WALL_PROTECTION_TYPE_ID] NUMERIC(18),
    [DOORWAY_PROT_TYPE_ID] NUMERIC(18),
    [STAIR_CARRY_TYPE_ID] NUMERIC(18),
    [STAIR_CARRY_FLIGHTS] NUMERIC(18),
    [STAIR_CARRY_STAIRS] VARCHAR(15),
    [SMALLEST_DOOR_ELEV_WIDTH] VARCHAR(20),
    [MULTI_LEVEL_TYPE_ID] NUMERIC(18),
    [SECURITY_TYPE_ID] NUMERIC(18),
    [DATE_CREATED] DATETIME NOT NULL,
    [CREATED_BY] NUMERIC(18) NOT NULL,
    [DATE_MODIFIED] DATETIME,
    [MODIFIED_BY] NUMERIC(18),
    [active_flag] VARCHAR(1) CONSTRAINT [DEF_JOB_LOCATIONS_active_flag] DEFAULT '(',
    [county] VARCHAR(50),
    CONSTRAINT [PK_JOB_LOCATIONS] PRIMARY KEY ([JOB_LOCATION_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "USER_JOB_TYPES"                                             */
/* ---------------------------------------------------------------------- */

CREATE TABLE [USER_JOB_TYPES] (
    [USER_JOB_TYPE_ID] NUMERIC(18) IDENTITY(1,1) NOT NULL,
    [USER_ID] NUMERIC(18) NOT NULL,
    [LOOKUP_ID] NUMERIC(18) NOT NULL,
    [CREATED_BY] NUMERIC(18) NOT NULL,
    [DATE_CREATED] DATETIME CONSTRAINT [DEF_USER_JOB_TYPES_DATE_CREATED] DEFAULT '(' NOT NULL,
    CONSTRAINT [PK_USER_JOB_TYPES] PRIMARY KEY ([USER_JOB_TYPE_ID]),
    CONSTRAINT [UK_USER_JOB_TYPES] UNIQUE ([USER_ID], [LOOKUP_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "RESOURCE_ITEMS"                                             */
/* ---------------------------------------------------------------------- */

CREATE TABLE [RESOURCE_ITEMS] (
    [RESOURCE_ITEM_ID] NUMERIC(18) IDENTITY(1,1) NOT NULL,
    [ITEM_ID] NUMERIC(18) NOT NULL,
    [RESOURCE_ID] NUMERIC(18) NOT NULL,
    [DEFAULT_ITEM_FLAG] VARCHAR(1) NOT NULL,
    [MAX_AMOUNT] NUMERIC(10,2),
    [DATE_CREATED] DATETIME NOT NULL,
    [CREATED_BY] NUMERIC(18) NOT NULL,
    [DATE_MODIFIED] DATETIME,
    [MODIFIED_BY] NUMERIC(18),
    CONSTRAINT [PK_RESOURCE_ITEMS] PRIMARY KEY ([RESOURCE_ITEM_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "USER_ORGANIZATIONS"                                         */
/* ---------------------------------------------------------------------- */

CREATE TABLE [USER_ORGANIZATIONS] (
    [USER_ID] NUMERIC(18) NOT NULL,
    [ORGANIZATION_ID] NUMERIC(18) NOT NULL,
    [DATE_CREATED] DATETIME NOT NULL,
    [CREATED_BY] NUMERIC(18) NOT NULL,
    [DATE_MODIFIED] DATETIME,
    [MODIFIED_BY] NUMERIC(18),
    CONSTRAINT [PK_USER_ORGANIZATIONS] PRIMARY KEY ([USER_ID], [ORGANIZATION_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "PROJECT_NOTES"                                              */
/* ---------------------------------------------------------------------- */

CREATE TABLE [PROJECT_NOTES] (
    [PROJECT_NOTE_ID] NUMERIC(18) IDENTITY(1,1) NOT NULL,
    [PROJECT_ID] NUMERIC(18) NOT NULL,
    [NOTE] VARCHAR(500) NOT NULL,
    [DATE_CREATED] DATETIME NOT NULL,
    [CREATED_BY] NUMERIC(18) NOT NULL,
    [DATE_MODIFIED] DATETIME,
    [MODIFIED_BY] NUMERIC(18),
    CONSTRAINT [PK_PROJECT_NOTES] PRIMARY KEY ([PROJECT_NOTE_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "JOBS"                                                       */
/* ---------------------------------------------------------------------- */

CREATE TABLE [JOBS] (
    [JOB_ID] NUMERIC(18) IDENTITY(1,1) NOT NULL,
    [PROJECT_ID] NUMERIC(18),
    [JOB_NO] NUMERIC(18),
    [JOB_NAME] VARCHAR(100),
    [JOB_TYPE_ID] NUMERIC(18) NOT NULL,
    [JOB_STATUS_TYPE_ID] NUMERIC(18) NOT NULL,
    [CUSTOMER_ID] NUMERIC(18) NOT NULL,
    [EXT_PRICE_LEVEL_ID] VARCHAR(11),
    [BILLING_USER_ID] NUMERIC(18),
    [FOREMAN_RESOURCE_ID] NUMERIC(18),
    [WATCH_FLAG] VARCHAR(1),
    [VIEW_SCHEDULE_FLAG] VARCHAR(1) CONSTRAINT [DEF_JOBS_VIEW_SCHEDULE_FLAG] DEFAULT '(' NOT NULL,
    [CREATED_BY] NUMERIC(18) NOT NULL,
    [DATE_CREATED] DATETIME NOT NULL,
    [MODIFIED_BY] NUMERIC(18),
    [DATE_MODIFIED] DATETIME,
    [SPREADSHEET_BILLING_FLAG] VARCHAR(1) CONSTRAINT [DEF_JOBS_SPREADSHEET_BILLING_FLAG] DEFAULT '(' NOT NULL,
    [A_M_SALES_CONTACT_ID] NUMERIC(18),
    [end_user_id] NUMERIC(18),
    CONSTRAINT [PK_JOBS] PRIMARY KEY ([JOB_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "ORGANIZATIONS"                                              */
/* ---------------------------------------------------------------------- */

CREATE TABLE [ORGANIZATIONS] (
    [ORGANIZATION_ID] NUMERIC(18) IDENTITY(5,1) NOT NULL,
    [NAME] VARCHAR(100) NOT NULL,
    [CODE] VARCHAR(50),
    [RESOURCE_NAME] VARCHAR(20) NOT NULL,
    [DB_PREFIX] VARCHAR(30) NOT NULL,
    [PR_INTEGRATION_NAME] VARCHAR(100),
    [INV_INTEGRATION_NAME] VARCHAR(100),
    [EXT_DIRECT_DEALER_ID] CHAR(15),
    [PAY_CODE_TABLE] VARCHAR(50) NOT NULL,
    [PDA_ITEM_PAYCODES_TABLE] VARCHAR(50) NOT NULL,
    [SEQUENCE_NO] NUMERIC(18) NOT NULL,
    [DATE_CREATED] DATETIME CONSTRAINT [DEF_ORGANIZATIONS_DATE_CREATED] DEFAULT '(' NOT NULL,
    [CREATED_BY] NUMERIC(18) NOT NULL,
    [DATE_MODIFIED] DATETIME,
    [MODIFIED_BY] NUMERIC(18),
    [SCHEDULER_CONTACT_ID] NUMERIC(18),
    [EXT_DCI_DEALER_ID] CHAR(15),
    [DEFAULT_SITE] VARCHAR(10),
    [INVOICE_SUFFIX] VARCHAR(6),
    [COMMENT_ID] VARCHAR(15),
    CONSTRAINT [PK_ORGANIZATIONS] PRIMARY KEY ([ORGANIZATION_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "PROJECTS"                                                   */
/* ---------------------------------------------------------------------- */

CREATE TABLE [PROJECTS] (
    [PROJECT_ID] NUMERIC(18) IDENTITY(1,1) NOT NULL,
    [PROJECT_NO] NUMERIC(18) NOT NULL,
    [CUSTOMER_ID] NUMERIC(18) NOT NULL,
    [JOB_NAME] VARCHAR(50),
    [PROJECT_TYPE_ID] NUMERIC(18) NOT NULL,
    [PROJECT_STATUS_TYPE_ID] NUMERIC(18) NOT NULL,
    [PERCENT_COMPLETE] NUMERIC(10,5),
    [END_USER_ID] NUMERIC(18),
    [IS_NEW] VARCHAR(1) CONSTRAINT [DEF_PROJECTS_IS_NEW] DEFAULT '(',
    [DATE_CREATED] DATETIME NOT NULL,
    [CREATED_BY] NUMERIC(18) NOT NULL,
    [DATE_MODIFIED] DATETIME,
    [MODIFIED_BY] NUMERIC(18),
    CONSTRAINT [PK_PROJECTS] PRIMARY KEY ([PROJECT_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "USER_APPROVERS"                                             */
/* ---------------------------------------------------------------------- */

CREATE TABLE [USER_APPROVERS] (
    [user_approver_id] NUMERIC(18) IDENTITY(1,1) NOT NULL,
    [user_id] NUMERIC(18) NOT NULL,
    [customer_id] NUMERIC(18) NOT NULL,
    CONSTRAINT [PK_USER_APPROVERS] PRIMARY KEY ([user_approver_id])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "INVOICES"                                                   */
/* ---------------------------------------------------------------------- */

CREATE TABLE [INVOICES] (
    [INVOICE_ID] NUMERIC(18) IDENTITY(46000,1) NOT NULL,
    [ORGANIZATION_ID] NUMERIC(18),
    [PO_NO] VARCHAR(200),
    [INVOICE_TYPE_ID] NUMERIC(18) NOT NULL,
    [BILLING_TYPE_ID] NUMERIC(18),
    [EXT_BATCH_ID] VARCHAR(15),
    [BATCH_STATUS_ID] NUMERIC(18) CONSTRAINT [DEF_INVOICES_BATCH_STATUS_ID] DEFAULT (,
    [ASSIGNED_TO_USER_ID] NUMERIC(18),
    [INVOICE_FORMAT_TYPE_ID] NUMERIC(18),
    [EXT_INVOICE_ID] VARCHAR(30),
    [STATUS_ID] NUMERIC(18) NOT NULL,
    [JOB_ID] NUMERIC(18) NOT NULL,
    [DESCRIPTION] VARCHAR(500),
    [GP_DESCRIPTION] VARCHAR(500),
    [COST_CODES] VARCHAR(50),
    [START_DATE] DATETIME,
    [END_DATE] DATETIME,
    [BILL_CUSTOMER_ID] NUMERIC(18),
    [EXT_BILL_CUST_ID] VARCHAR(15),
    [SALES_REPS] VARCHAR(50),
    [DATE_SENT] DATETIME,
    [DATE_CREATED] DATETIME NOT NULL,
    [CREATED_BY] NUMERIC(18) NOT NULL,
    [DATE_MODIFIED] DATETIME,
    [MODIFIED_BY] NUMERIC(18),
    [batch_error_message] VARCHAR(255),
    [USER_ID] NUMERIC(18),
    CONSTRAINT [INV_PK] PRIMARY KEY ([INVOICE_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "user_customer_end_users"                                    */
/* ---------------------------------------------------------------------- */

CREATE TABLE [user_customer_end_users] (
    [user_customer_end_user_id] INTEGER IDENTITY(1,1) NOT NULL,
    [user_customer_id] NUMERIC(18) NOT NULL,
    [customer_id] NUMERIC(18) NOT NULL,
    CONSTRAINT [PK_user_customer_end_users] PRIMARY KEY ([user_customer_end_user_id])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "FUNCTION_RIGHT_TYPES"                                       */
/* ---------------------------------------------------------------------- */

CREATE TABLE [FUNCTION_RIGHT_TYPES] (
    [FUNCTION_RIGHT_TYPE_ID] NUMERIC(18) IDENTITY(2639447,1) NOT NULL,
    [FUNCTION_ID] NUMERIC(18),
    [RIGHT_TYPE_ID] NUMERIC(18),
    [UPDATABLE_FLAG] VARCHAR(1),
    [DATE_CREATED] DATETIME,
    [CREATED_BY] NUMERIC(18),
    [DATE_MODIFIED] DATETIME,
    [MODIFIED_BY] NUMERIC(18),
    CONSTRAINT [PK_FUNCTION_RIGHT_TYPES] PRIMARY KEY ([FUNCTION_RIGHT_TYPE_ID]),
    CONSTRAINT [UK_FUNCTION_RIGHT_TYPES] UNIQUE ([FUNCTION_ID], [RIGHT_TYPE_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "CUSTOMERS"                                                  */
/* ---------------------------------------------------------------------- */

CREATE TABLE [CUSTOMERS] (
    [CUSTOMER_ID] NUMERIC(18) IDENTITY(1,1) NOT NULL,
    [ORGANIZATION_ID] NUMERIC(18) NOT NULL,
    [EXT_DEALER_ID] CHAR(15) NOT NULL,
    [DEALER_NAME] VARCHAR(65),
    [EXT_CUSTOMER_ID] CHAR(15),
    [CUSTOMER_NAME] VARCHAR(65) NOT NULL,
    [ACTIVE_FLAG] VARCHAR(1) NOT NULL,
    [DATE_CREATED] DATETIME NOT NULL,
    [CREATED_BY] NUMERIC(18) NOT NULL,
    [DATE_MODIFIED] DATETIME,
    [MODIFIED_BY] NUMERIC(18),
    [A_M_FURNITURE1_CONTACT_ID] NUMERIC(18),
    [PARENT_CUSTOMER_ID] NUMERIC(18),
    [SURVEY_FREQUENCY] NUMERIC(18),
    [SURVEY_LAST_COUNT] NUMERIC(18),
    [SURVEY_LOCATION] VARCHAR(50),
    [REFUSAL_EMAIL_INFO] VARCHAR(500),
    [customer_type_id] NUMERIC(18),
    [end_user_parent_id] NUMERIC(18),
    [street1] VARCHAR(100),
    [street2] VARCHAR(100),
    [city] VARCHAR(50),
    [county] VARCHAR(50),
    [state] VARCHAR(2),
    [zip] VARCHAR(10),
    [country] VARCHAR(50),
    CONSTRAINT [PK_CUSTOMERS] PRIMARY KEY ([CUSTOMER_ID]),
    CONSTRAINT [IX_DEALER_CUSTOMERS] UNIQUE ([EXT_DEALER_ID], [CUSTOMER_ID]),
    CONSTRAINT [IX_ORG_CUSTOMERS] UNIQUE ([ORGANIZATION_ID], [CUSTOMER_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "ITEMS"                                                      */
/* ---------------------------------------------------------------------- */

CREATE TABLE [ITEMS] (
    [ITEM_ID] NUMERIC(18) IDENTITY(1,1) NOT NULL,
    [ORGANIZATION_ID] NUMERIC(18),
    [NAME] VARCHAR(200) NOT NULL,
    [CODE] VARCHAR(10),
    [DESCRIPTION] VARCHAR(100),
    [EXT_ITEM_ID] VARCHAR(30) NOT NULL,
    [ITEM_TYPE_ID] NUMERIC(18),
    [ITEM_STATUS_TYPE_ID] NUMERIC(18),
    [BILLABLE_FLAG] VARCHAR(1) NOT NULL,
    [SEQUENCE_NO] NUMERIC(18),
    [EXPENSE_EXPORT_CODE] VARCHAR(10),
    [DATE_CREATED] DATETIME NOT NULL,
    [CREATED_BY] NUMERIC(18) NOT NULL,
    [DATE_MODIFIED] DATETIME,
    [MODIFIED_BY] NUMERIC(18),
    [JOB_TYPE_ID] NUMERIC(18),
    [COST_PER_UOM] NUMERIC(18,2),
    [PERCENT_MARGIN] NUMERIC(3),
    [COLUMN_POSITION] VARCHAR(13),
    [allow_expense_entry] VARCHAR(1),
    [item_category_type_id] NUMERIC(18),
    CONSTRAINT [I_PK] PRIMARY KEY ([ITEM_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "CONTACTS"                                                   */
/* ---------------------------------------------------------------------- */

CREATE TABLE [CONTACTS] (
    [CONTACT_ID] NUMERIC(18) IDENTITY(2095,1) NOT NULL,
    [CONTACT_NAME] VARCHAR(100) NOT NULL,
    [ORGANIZATION_ID] NUMERIC(18) NOT NULL,
    [EXT_DEALER_ID] VARCHAR(15) NOT NULL,
    [CUSTOMER_ID] NUMERIC(18),
    [CONTACT_TYPE_ID] NUMERIC(18),
    [CONT_STATUS_TYPE_ID] NUMERIC(18) NOT NULL,
    [PHONE_WORK] VARCHAR(50),
    [PHONE_CELL] VARCHAR(50),
    [PHONE_HOME] VARCHAR(50),
    [EMAIL] VARCHAR(100),
    [EMAIL_PHONE] VARCHAR(100),
    [STREET1] VARCHAR(50),
    [STREET2] VARCHAR(50),
    [STREET3] VARCHAR(50),
    [CITY] VARCHAR(50),
    [STATE] CHAR(2),
    [ZIP] VARCHAR(10),
    [NOTES] VARCHAR(500),
    [DATE_CREATED] DATETIME NOT NULL,
    [CREATED_BY] NUMERIC(18) NOT NULL,
    [DATE_MODIFIED] DATETIME,
    [MODIFIED_BY] NUMERIC(18),
    [contact_id_8] NUMERIC(18),
    CONSTRAINT [PK_CONTACTS] PRIMARY KEY ([CONTACT_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "JOB_ITEM_RATES"                                             */
/* ---------------------------------------------------------------------- */

CREATE TABLE [JOB_ITEM_RATES] (
    [JOB_ITEM_RATE_ID] NUMERIC(18) IDENTITY(1,1) NOT NULL,
    [JOB_ID] NUMERIC(18) NOT NULL,
    [ITEM_ID] NUMERIC(18) NOT NULL,
    [RATE] NUMERIC(11,3),
    [EXT_RATE_ID] CHAR(30) NOT NULL,
    [UOM_TYPE_ID] NUMERIC(18),
    [EXT_UOM_NAME] VARCHAR(50),
    [DATE_CREATED] DATETIME NOT NULL,
    [CREATED_BY] NUMERIC(18) NOT NULL,
    [DATE_MODIFIED] DATETIME,
    [MODIFIED_BY] NUMERIC(18),
    CONSTRAINT [PK_JOB_ITEM_RATES] PRIMARY KEY ([JOB_ITEM_RATE_ID]),
    CONSTRAINT [IX_JIR_JOB_ITEMS] UNIQUE ([JOB_ID], [ITEM_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "CONTACT_GROUPS"                                             */
/* ---------------------------------------------------------------------- */

CREATE TABLE [CONTACT_GROUPS] (
    [CONTACT_GROUP_ID] NUMERIC(18) IDENTITY(1,1) NOT NULL,
    [CONTACT_ID] NUMERIC(18),
    [CONTACT_TYPE_ID] NUMERIC(18),
    [DATE_CREATED] DATETIME,
    [CREATED_BY] NUMERIC(18),
    [DATE_MODIFIED] DATETIME,
    [MODIFIED_BY] NUMERIC(18),
    CONSTRAINT [PK_CONTACT_GROUPS] PRIMARY KEY ([CONTACT_GROUP_ID]),
    CONSTRAINT [IX_CONTACT_GROUPS] UNIQUE ([CONTACT_ID], [CONTACT_TYPE_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "USERS"                                                      */
/* ---------------------------------------------------------------------- */

CREATE TABLE [USERS] (
    [USER_ID] NUMERIC(18) IDENTITY(594,1) NOT NULL,
    [EXT_EMPLOYEE_ID] VARCHAR(15),
    [CONTACT_ID] NUMERIC(18),
    [EMPLOYMENT_TYPE_ID] NUMERIC(18) NOT NULL,
    [EXT_DEALER_ID] VARCHAR(15) NOT NULL,
    [DEALER_NAME] VARCHAR(65),
    [VENDOR_CONTACT_ID] NUMERIC(18),
    [USER_TYPE_ID] NUMERIC(18),
    [FIRST_NAME] VARCHAR(200) NOT NULL,
    [LAST_NAME] VARCHAR(200) NOT NULL,
    [LOGIN] VARCHAR(200) NOT NULL,
    [PASSWORD] VARCHAR(20) NOT NULL,
    [LAST_LOGIN] DATETIME,
    [PIN] VARCHAR(10),
    [ACTIVE_FLAG] VARCHAR(240) NOT NULL,
    [IMOBILE_LOGIN] VARCHAR(20),
    [LAST_SYNCH_DATE] DATETIME,
    [DATE_CREATED] DATETIME NOT NULL,
    [CREATED_BY] NUMERIC(18) NOT NULL,
    [DATE_MODIFIED] DATETIME,
    [MODIFIED_BY] NUMERIC(18),
    [FULL_NAME] VARCHAR(400),
    [QP3] VARCHAR(50),
    [ORGANIZATION_ID] NUMERIC(18),
    CONSTRAINT [PK_USERS] PRIMARY KEY ([USER_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "states"                                                     */
/* ---------------------------------------------------------------------- */

CREATE TABLE [states] (
    [code] VARCHAR(2) NOT NULL,
    [country_code] VARCHAR(2) NOT NULL,
    [name] VARCHAR(100) NOT NULL,
    CONSTRAINT [states_pk] PRIMARY KEY ([code], [country_code])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "job_location_contacts"                                      */
/* ---------------------------------------------------------------------- */

CREATE TABLE [job_location_contacts] (
    [job_location_contact_id] NUMERIC(18) IDENTITY(1,1) NOT NULL,
    [job_location_id] NUMERIC(18) NOT NULL,
    [contact_id] NUMERIC(18) NOT NULL,
    [created_by] NUMERIC(18) NOT NULL,
    [date_created] DATETIME CONSTRAINT [DEF_job_location_contacts_date_created] DEFAULT '(' NOT NULL,
    [modified_by] NUMERIC(18),
    [date_modified] DATETIME,
    CONSTRAINT [PK_job_location_contacts] PRIMARY KEY ([job_location_contact_id]),
    CONSTRAINT [UK_jlc_1] UNIQUE ([job_location_id], [contact_id])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "DOCUMENTS"                                                  */
/* ---------------------------------------------------------------------- */

CREATE TABLE [DOCUMENTS] (
    [DOCUMENT_ID] NUMERIC(18) IDENTITY(1,1) NOT NULL,
    [PROJECT_ID] NUMERIC(18) NOT NULL,
    [FORMAT_ID] NUMERIC(18) NOT NULL,
    [NAME] VARCHAR(50) NOT NULL,
    [CODE] VARCHAR(20),
    [LOCKED_BY] NUMERIC(18),
    [DATE_LOCKED] DATETIME,
    [CREATED_BY] NUMERIC(18) NOT NULL,
    [DATE_CREATED] DATETIME NOT NULL,
    [MODIFIED_BY] NUMERIC(18),
    [DATE_MODIFIED] DATETIME,
    CONSTRAINT [PK_DOCUMENTS] PRIMARY KEY ([DOCUMENT_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "VERSIONS"                                                   */
/* ---------------------------------------------------------------------- */

CREATE TABLE [VERSIONS] (
    [VERSION_ID] NUMERIC(18) IDENTITY(1,1) NOT NULL,
    [DOCUMENT_ID] NUMERIC(18) NOT NULL,
    [CODE] VARCHAR(20) NOT NULL,
    [COMMENTS] VARCHAR(200),
    [NUM_DOWNLOADS] NUMERIC(18) CONSTRAINT [DEF_VERSIONS_NUM_DOWNLOADS] DEFAULT ( NOT NULL,
    [CREATED_BY] NUMERIC(18) NOT NULL,
    [DATE_CREATED] DATETIME NOT NULL,
    [MODIFIED_BY] NUMERIC(18),
    [DATE_MODIFIED] DATETIME,
    CONSTRAINT [PK_VERSIONS] PRIMARY KEY ([VERSION_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "CUSTOM_CUST_COLUMNS"                                        */
/* ---------------------------------------------------------------------- */

CREATE TABLE [CUSTOM_CUST_COLUMNS] (
    [CUSTOM_CUST_COL_ID] NUMERIC(18) IDENTITY(1,1) NOT NULL,
    [CUSTOMER_ID] NUMERIC(18) NOT NULL,
    [COLUMN_DESC] VARCHAR(25) NOT NULL,
    [COL_SEQUENCE] INTEGER NOT NULL,
    [ACTIVE_FLAG] VARCHAR(1) NOT NULL,
    [CREATED_BY] NUMERIC(18) NOT NULL,
    [DATE_CREATED] DATETIME NOT NULL,
    [MODIFIED_BY] NUMERIC(18),
    [DATE_MODIFIED] DATETIME,
    [IS_DROPLIST] VARCHAR(1) CONSTRAINT [DEF_CUSTOM_CUST_COLUMNS_IS_DROPLIST] DEFAULT '(' NOT NULL,
    [IS_MANDATORY] VARCHAR(1) CONSTRAINT [DEF_CUSTOM_CUST_COLUMNS_IS_MANDATORY] DEFAULT '(' NOT NULL,
    CONSTRAINT [PK_CUSTOM_CUST_COLUMNS] PRIMARY KEY ([CUSTOM_CUST_COL_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "JOB_DISTRIBUTIONS"                                          */
/* ---------------------------------------------------------------------- */

CREATE TABLE [JOB_DISTRIBUTIONS] (
    [JOB_DISTRIBUTION_ID] NUMERIC(18) IDENTITY(1,1) NOT NULL,
    [JOB_ID] NUMERIC(18) NOT NULL,
    [USER_ID] NUMERIC(18) NOT NULL,
    [SCH_RESOURCE_ID] NUMERIC(18),
    [REMOVE_DATE] DATETIME,
    [CREATED_BY] NUMERIC(18) NOT NULL,
    [DATE_CREATED] DATETIME NOT NULL,
    [MODIFIED_BY] NUMERIC(18),
    [DATE_MODIFIED] DATETIME,
    CONSTRAINT [PK_JOB_DISTRIBUTIONS] PRIMARY KEY ([JOB_DISTRIBUTION_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "CUSTOM_COL_LISTS"                                           */
/* ---------------------------------------------------------------------- */

CREATE TABLE [CUSTOM_COL_LISTS] (
    [CUSTOM_COL_LIST_ID] NUMERIC(18) IDENTITY(1,1) NOT NULL,
    [CUSTOM_CUST_COL_ID] NUMERIC(18) NOT NULL,
    [SEQUENCE] NUMERIC(18) NOT NULL,
    [LIST_VALUE] VARCHAR(50) NOT NULL,
    [ACTIVE_FLAG] VARCHAR(1) CONSTRAINT [DEF_CUSTOM_COL_LISTS_ACTIVE_FLAG] DEFAULT '(' NOT NULL,
    CONSTRAINT [PK_CUSTOM_COL_LISTS] PRIMARY KEY ([CUSTOM_COL_LIST_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "ITEM_COSTING_HISTORY"                                       */
/* ---------------------------------------------------------------------- */

CREATE TABLE [ITEM_COSTING_HISTORY] (
    [ITEM_COSTING_HISTORY_ID] NUMERIC(18) IDENTITY(1,1) NOT NULL,
    [ITEM_ID] NUMERIC(18) NOT NULL,
    [COST_PER_UOM] NUMERIC(18,2),
    [PERCENT_MARGIN] NUMERIC(3),
    [CREATED_BY] VARCHAR(50) NOT NULL,
    [DATE_CREATED] DATETIME NOT NULL,
    CONSTRAINT [PK_ITEM_COSTING_HISTORY] PRIMARY KEY ([ITEM_COSTING_HISTORY_ID])
)
 ON [PRIMARY]
GO

/* ---------------------------------------------------------------------- */
/* Add table "HOTSHEETS"                                                  */
/* ---------------------------------------------------------------------- */

CREATE TABLE [HOTSHEETS] (
    [HOTSHEET_ID] NUMERIC(18) NOT NULL,
    [JOB_LOCATION_ID] NUMERIC(18) NOT NULL,
    [REQUEST_ID] NUMERIC(18),
    CONSTRAINT [PK_HOTSHEETS] PRIMARY KEY ([HOTSHEET_ID])
)
GO

/* ---------------------------------------------------------------------- */
/* Add table "HOTSHEET_DETAILS"                                           */
/* ---------------------------------------------------------------------- */

CREATE TABLE [HOTSHEET_DETAILS] (
    [ATTRIBUTE_TYPE] VARCHAR(40) NOT NULL,
    [ATTRIBUTE_VALUE] INTEGER,
    [HOTSHEET_ID] NUMERIC(18) NOT NULL,
    CONSTRAINT [PK_HOTSHEET_DETAILS] PRIMARY KEY ([ATTRIBUTE_TYPE], [HOTSHEET_ID])
)
GO

/* ---------------------------------------------------------------------- */
/* Foreign key constraints                                                */
/* ---------------------------------------------------------------------- */

ALTER TABLE [z_resource_items] ADD CONSTRAINT [RESOURCES_z_resource_items] 
    FOREIGN KEY ([RESOURCE_ID]) REFERENCES [RESOURCES] ([RESOURCE_ID])
GO

ALTER TABLE [z_resource_items] ADD CONSTRAINT [RESOURCE_ITEMS_z_resource_items] 
    FOREIGN KEY ([RESOURCE_ITEM_ID]) REFERENCES [RESOURCE_ITEMS] ([RESOURCE_ITEM_ID])
GO

ALTER TABLE [z_resource_items] ADD CONSTRAINT [ITEMS_z_resource_items] 
    FOREIGN KEY ([RESOURCE_ITEM_ID]) REFERENCES [ITEMS] ([ITEM_ID])
GO

ALTER TABLE [PDA_RESOURCE_SORT] ADD CONSTRAINT [NUMBERS_PDA_RESOURCE_SORT] 
    FOREIGN KEY ([row_number]) REFERENCES [NUMBERS] ([number])
GO

ALTER TABLE [PDA_RESOURCE_SORT] ADD CONSTRAINT [RESOURCES_PDA_RESOURCE_SORT] 
    FOREIGN KEY ([resource_id]) REFERENCES [RESOURCES] ([RESOURCE_ID])
GO

ALTER TABLE [z_resource_type_items] ADD CONSTRAINT [RESOURCE_ESTIMATES_z_resource_type_items] 
    FOREIGN KEY ([RESOURCE_TYPE_ID]) REFERENCES [RESOURCE_ESTIMATES] ([RESOURCE_EST_ID])
GO

ALTER TABLE [z_resource_type_items] ADD CONSTRAINT [RESOURCE_TYPES_z_resource_type_items] 
    FOREIGN KEY ([RESOURCE_TYPE_ID]) REFERENCES [RESOURCE_TYPES] ([RESOURCE_TYPE_ID])
GO

ALTER TABLE [z_resource_type_items] ADD CONSTRAINT [RESOURCE_TYPE_ITEMS_z_resource_type_items] 
    FOREIGN KEY ([RES_TYPE_ITEM_ID]) REFERENCES [RESOURCE_TYPE_ITEMS] ([RES_TYPE_ITEM_ID])
GO

ALTER TABLE [z_resource_type_items] ADD CONSTRAINT [ITEMS_z_resource_type_items] 
    FOREIGN KEY ([RES_TYPE_ITEM_ID]) REFERENCES [ITEMS] ([ITEM_ID])
GO

ALTER TABLE [TABS] ADD CONSTRAINT [TEMPLATES_TABS] 
    FOREIGN KEY ([TEMPLATE_ID]) REFERENCES [TEMPLATES] ([TEMPLATE_ID])
GO

ALTER TABLE [TABS] ADD CONSTRAINT [GREAT_PLAINS_TABLES_TABS] 
    FOREIGN KEY ([TABLE_ID]) REFERENCES [GREAT_PLAINS_TABLES] ([TABLE_ID])
GO

ALTER TABLE [UNBILLED_REPORT_DAILYDATACAPTURE] ADD CONSTRAINT [USER_ORGANIZATIONS_UNBILLED_REPORT_DAILYDATACAPTURE] 
    FOREIGN KEY ([ORGANIZATION_ID], [USER_ID]) REFERENCES [USER_ORGANIZATIONS] ([ORGANIZATION_ID],[USER_ID])
GO

ALTER TABLE [UNBILLED_REPORT_DAILYDATACAPTURE] ADD CONSTRAINT [JOBS_UNBILLED_REPORT_DAILYDATACAPTURE] 
    FOREIGN KEY ([BILL_JOB_ID]) REFERENCES [JOBS] ([JOB_ID])
GO

ALTER TABLE [UNBILLED_REPORT_DAILYDATACAPTURE] ADD CONSTRAINT [ORGANIZATIONS_UNBILLED_REPORT_DAILYDATACAPTURE] 
    FOREIGN KEY ([ORGANIZATION_ID]) REFERENCES [ORGANIZATIONS] ([ORGANIZATION_ID])
GO

ALTER TABLE [UNBILLED_REPORT_DAILYDATACAPTURE] ADD CONSTRAINT [INVOICES_UNBILLED_REPORT_DAILYDATACAPTURE] 
    FOREIGN KEY ([UnbilledOpsInvoicesTotal]) REFERENCES [INVOICES] ([INVOICE_ID])
GO

ALTER TABLE [UNBILLED_REPORT_DAILYDATACAPTURE] ADD CONSTRAINT [USERS_UNBILLED_REPORT_DAILYDATACAPTURE] 
    FOREIGN KEY ([BILLING_USER_ID]) REFERENCES [USERS] ([USER_ID])
GO

ALTER TABLE [EMAILS] ADD CONSTRAINT [QUOTES_EMAILS] 
    FOREIGN KEY ([QUOTE_ID]) REFERENCES [QUOTES] ([quote_id])
GO

ALTER TABLE [EMAILS] ADD CONSTRAINT [REQUESTS_EMAILS] 
    FOREIGN KEY ([REQUEST_ID]) REFERENCES [REQUESTS] ([REQUEST_ID])
GO

ALTER TABLE [EMAILS] ADD CONSTRAINT [PROJECTS_EMAILS] 
    FOREIGN KEY ([PROJECT_ID]) REFERENCES [PROJECTS] ([PROJECT_ID])
GO

ALTER TABLE [EMAILS] ADD CONSTRAINT [CONTACTS_EMAILS] 
    FOREIGN KEY ([TO_CONTACT_ID]) REFERENCES [CONTACTS] ([CONTACT_ID])
GO

ALTER TABLE [XREF_PDS] ADD CONSTRAINT [SERVICES_XREF_PDS] 
    FOREIGN KEY ([SERVICE_ID]) REFERENCES [SERVICES] ([SERVICE_ID])
GO

ALTER TABLE [XREF_PDS] ADD CONSTRAINT [USERS_XREF_PDS] 
    FOREIGN KEY ([PALM_USER_ID]) REFERENCES [USERS] ([USER_ID])
GO

ALTER TABLE [FUNCTION_GROUPS] ADD CONSTRAINT [countries_FUNCTION_GROUPS] 
    FOREIGN KEY ([CODE]) REFERENCES [countries] ([code])
GO

ALTER TABLE [INVOICE_STATUSES] ADD CONSTRAINT [countries_INVOICE_STATUSES] 
    FOREIGN KEY ([CODE]) REFERENCES [countries] ([code])
GO

ALTER TABLE [SERVICE_LINE_STATUSES] ADD CONSTRAINT [countries_SERVICE_LINE_STATUSES] 
    FOREIGN KEY ([CODE]) REFERENCES [countries] ([code])
GO

ALTER TABLE [SERVICE_STATUSES] ADD CONSTRAINT [countries_SERVICE_STATUSES] 
    FOREIGN KEY ([CODE]) REFERENCES [countries] ([code])
GO

ALTER TABLE [XREF_ITEMS] ADD CONSTRAINT [ITEMS_XREF_ITEMS] 
    FOREIGN KEY ([ITEM_ID]) REFERENCES [ITEMS] ([ITEM_ID])
GO

ALTER TABLE [XREF_ITEMS] ADD CONSTRAINT [USERS_XREF_ITEMS] 
    FOREIGN KEY ([PALM_USER_ID]) REFERENCES [USERS] ([USER_ID])
GO

ALTER TABLE [XREF_JOBS] ADD CONSTRAINT [JOBS_XREF_JOBS] 
    FOREIGN KEY ([JOB_ID]) REFERENCES [JOBS] ([JOB_ID])
GO

ALTER TABLE [XREF_JOBS] ADD CONSTRAINT [USERS_XREF_JOBS] 
    FOREIGN KEY ([PALM_USER_ID]) REFERENCES [USERS] ([USER_ID])
GO

ALTER TABLE [XREF_NOTES] ADD CONSTRAINT [USERS_XREF_NOTES] 
    FOREIGN KEY ([PALM_USER_ID]) REFERENCES [USERS] ([USER_ID])
GO

ALTER TABLE [XREF_REASONS] ADD CONSTRAINT [USERS_XREF_REASONS] 
    FOREIGN KEY ([PALM_USER_ID]) REFERENCES [USERS] ([USER_ID])
GO

ALTER TABLE [XREF_RESOURCES] ADD CONSTRAINT [RESOURCES_XREF_RESOURCES] 
    FOREIGN KEY ([RESOURCE_ID]) REFERENCES [RESOURCES] ([RESOURCE_ID])
GO

ALTER TABLE [XREF_RESOURCES] ADD CONSTRAINT [USERS_XREF_RESOURCES] 
    FOREIGN KEY ([PALM_USER_ID]) REFERENCES [USERS] ([USER_ID])
GO

ALTER TABLE [XREF_SERVICES] ADD CONSTRAINT [SERVICES_XREF_SERVICES] 
    FOREIGN KEY ([SERVICE_ID]) REFERENCES [SERVICES] ([SERVICE_ID])
GO

ALTER TABLE [XREF_SERVICES] ADD CONSTRAINT [USERS_XREF_SERVICES] 
    FOREIGN KEY ([PALM_USER_ID]) REFERENCES [USERS] ([USER_ID])
GO

ALTER TABLE [XREF_SCHED_RESOURCES] ADD CONSTRAINT [SCH_RESOURCES_XREF_SCHED_RESOURCES] 
    FOREIGN KEY ([SCHED_RESOURCE_ID]) REFERENCES [SCH_RESOURCES] ([SCH_RESOURCE_ID])
GO

ALTER TABLE [XREF_SCHED_RESOURCES] ADD CONSTRAINT [RESOURCES_XREF_SCHED_RESOURCES] 
    FOREIGN KEY ([XREF_SCHED_RESOURCE_ID]) REFERENCES [RESOURCES] ([RESOURCE_ID])
GO

ALTER TABLE [XREF_SCHED_RESOURCES] ADD CONSTRAINT [USERS_XREF_SCHED_RESOURCES] 
    FOREIGN KEY ([PALM_USER_ID]) REFERENCES [USERS] ([USER_ID])
GO

ALTER TABLE [XREF_TIME] ADD CONSTRAINT [USERS_XREF_TIME] 
    FOREIGN KEY ([PALM_USER_ID]) REFERENCES [USERS] ([USER_ID])
GO

ALTER TABLE [EXPENSES_BATCH_LINES] ADD CONSTRAINT [EXPENSES_BATCHES_EXPENSES_BATCH_LINES] 
    FOREIGN KEY ([INT_BATCH_ID]) REFERENCES [EXPENSES_BATCHES] ([INT_BATCH_ID])
GO

ALTER TABLE [EXPENSES_BATCH_LINES] ADD CONSTRAINT [PAYROLL_BATCHES_EXPENSES_BATCH_LINES] 
    FOREIGN KEY ([INT_BATCH_ID]) REFERENCES [PAYROLL_BATCHES] ([INT_BATCH_ID])
GO

ALTER TABLE [EXPENSES_BATCH_LINES] ADD CONSTRAINT [ITEMS_EXPENSES_BATCH_LINES] 
    FOREIGN KEY ([EXT_ITEM_ID]) REFERENCES [ITEMS] ([ITEM_ID])
GO

ALTER TABLE [PDA_ROSTER_CHANGES] ADD CONSTRAINT [RESOURCES_PDA_ROSTER_CHANGES] 
    FOREIGN KEY ([RESOURCE_ID]) REFERENCES [RESOURCES] ([RESOURCE_ID])
GO

ALTER TABLE [PDA_ROSTER_CHANGES] ADD CONSTRAINT [JOBS_PDA_ROSTER_CHANGES] 
    FOREIGN KEY ([JOB_ID]) REFERENCES [JOBS] ([JOB_ID])
GO

ALTER TABLE [EXPENSES_BATCHES] ADD CONSTRAINT [PAYROLL_BATCHES_EXPENSES_BATCHES] 
    FOREIGN KEY ([EXT_BATCH_ID]) REFERENCES [PAYROLL_BATCHES] ([INT_BATCH_ID])
GO

ALTER TABLE [EXPENSES_BATCHES] ADD CONSTRAINT [ORGANIZATIONS_EXPENSES_BATCHES] 
    FOREIGN KEY ([ORGANIZATION_ID]) REFERENCES [ORGANIZATIONS] ([ORGANIZATION_ID])
GO

ALTER TABLE [ottInvHeaderTEMP_Madison] ADD CONSTRAINT [EXPENSES_BATCHES_ottInvHeaderTEMP_Madison] 
    FOREIGN KEY ([EXT_BATCH_ID]) REFERENCES [EXPENSES_BATCHES] ([INT_BATCH_ID])
GO

ALTER TABLE [ottInvHeaderTEMP_Madison] ADD CONSTRAINT [PAYROLL_BATCHES_ottInvHeaderTEMP_Madison] 
    FOREIGN KEY ([EXT_BATCH_ID]) REFERENCES [PAYROLL_BATCHES] ([INT_BATCH_ID])
GO

ALTER TABLE [ottInvHeaderTEMP_Madison] ADD CONSTRAINT [INVOICES_ottInvHeaderTEMP_Madison] 
    FOREIGN KEY ([INVOICE_ID]) REFERENCES [INVOICES] ([INVOICE_ID])
GO

ALTER TABLE [ottInvHeaderTEMP_Madison] ADD CONSTRAINT [DOCUMENTS_ottInvHeaderTEMP_Madison] 
    FOREIGN KEY ([DOCUMENT_NO]) REFERENCES [DOCUMENTS] ([DOCUMENT_ID])
GO

ALTER TABLE [ottInvLineTEMP_Madison] ADD CONSTRAINT [INVOICES_ottInvLineTEMP_Madison] 
    FOREIGN KEY ([INVOICE_ID]) REFERENCES [INVOICES] ([INVOICE_ID])
GO

ALTER TABLE [ottInvLineTEMP_Madison] ADD CONSTRAINT [ITEMS_ottInvLineTEMP_Madison] 
    FOREIGN KEY ([EXT_ITEM_ID]) REFERENCES [ITEMS] ([ITEM_ID])
GO

ALTER TABLE [AUTHENTICATION_KEYS] ADD CONSTRAINT [ORGANIZATIONS_AUTHENTICATION_KEYS] 
    FOREIGN KEY ([organization_id]) REFERENCES [ORGANIZATIONS] ([ORGANIZATION_ID])
GO

ALTER TABLE [AUTHENTICATION_KEYS] ADD CONSTRAINT [USERS_AUTHENTICATION_KEYS] 
    FOREIGN KEY ([user_id]) REFERENCES [USERS] ([USER_ID])
GO

ALTER TABLE [ottInvHeaderTEMP] ADD CONSTRAINT [EXPENSES_BATCHES_ottInvHeaderTEMP] 
    FOREIGN KEY ([EXT_BATCH_ID]) REFERENCES [EXPENSES_BATCHES] ([INT_BATCH_ID])
GO

ALTER TABLE [ottInvHeaderTEMP] ADD CONSTRAINT [PAYROLL_BATCHES_ottInvHeaderTEMP] 
    FOREIGN KEY ([EXT_BATCH_ID]) REFERENCES [PAYROLL_BATCHES] ([INT_BATCH_ID])
GO

ALTER TABLE [ottInvHeaderTEMP] ADD CONSTRAINT [INVOICES_ottInvHeaderTEMP] 
    FOREIGN KEY ([INVOICE_ID]) REFERENCES [INVOICES] ([INVOICE_ID])
GO

ALTER TABLE [ottInvHeaderTEMP] ADD CONSTRAINT [DOCUMENTS_ottInvHeaderTEMP] 
    FOREIGN KEY ([DOCUMENT_NO]) REFERENCES [DOCUMENTS] ([DOCUMENT_ID])
GO

ALTER TABLE [ottInvLineTEMP] ADD CONSTRAINT [INVOICES_ottInvLineTEMP] 
    FOREIGN KEY ([INVOICE_ID]) REFERENCES [INVOICES] ([INVOICE_ID])
GO

ALTER TABLE [ottInvLineTEMP] ADD CONSTRAINT [ITEMS_ottInvLineTEMP] 
    FOREIGN KEY ([EXT_ITEM_ID]) REFERENCES [ITEMS] ([ITEM_ID])
GO

ALTER TABLE [ottInvTaxesTEMP] ADD CONSTRAINT [INVOICES_ottInvTaxesTEMP] 
    FOREIGN KEY ([INVOICE_ID]) REFERENCES [INVOICES] ([INVOICE_ID])
GO

ALTER TABLE [ottInvHeaderTEMP_ALL] ADD CONSTRAINT [EXPENSES_BATCHES_ottInvHeaderTEMP_ALL] 
    FOREIGN KEY ([EXT_BATCH_ID]) REFERENCES [EXPENSES_BATCHES] ([INT_BATCH_ID])
GO

ALTER TABLE [ottInvHeaderTEMP_ALL] ADD CONSTRAINT [PAYROLL_BATCHES_ottInvHeaderTEMP_ALL] 
    FOREIGN KEY ([EXT_BATCH_ID]) REFERENCES [PAYROLL_BATCHES] ([INT_BATCH_ID])
GO

ALTER TABLE [ottInvHeaderTEMP_ALL] ADD CONSTRAINT [ORGANIZATIONS_ottInvHeaderTEMP_ALL] 
    FOREIGN KEY ([organization_id]) REFERENCES [ORGANIZATIONS] ([ORGANIZATION_ID])
GO

ALTER TABLE [ottInvHeaderTEMP_ALL] ADD CONSTRAINT [INVOICES_ottInvHeaderTEMP_ALL] 
    FOREIGN KEY ([INVOICE_ID]) REFERENCES [INVOICES] ([INVOICE_ID])
GO

ALTER TABLE [ottInvHeaderTEMP_ALL] ADD CONSTRAINT [DOCUMENTS_ottInvHeaderTEMP_ALL] 
    FOREIGN KEY ([DOCUMENT_NO]) REFERENCES [DOCUMENTS] ([DOCUMENT_ID])
GO

ALTER TABLE [ottInvLineTEMP_ALL] ADD CONSTRAINT [INVOICE_LINES_ottInvLineTEMP_ALL] 
    FOREIGN KEY ([INVOICE_LINE_ID]) REFERENCES [INVOICE_LINES] ([INVOICE_LINE_ID])
GO

ALTER TABLE [ottInvLineTEMP_ALL] ADD CONSTRAINT [ORGANIZATIONS_ottInvLineTEMP_ALL] 
    FOREIGN KEY ([organization_id]) REFERENCES [ORGANIZATIONS] ([ORGANIZATION_ID])
GO

ALTER TABLE [ottInvLineTEMP_ALL] ADD CONSTRAINT [INVOICES_ottInvLineTEMP_ALL] 
    FOREIGN KEY ([INVOICE_ID]) REFERENCES [INVOICES] ([INVOICE_ID])
GO

ALTER TABLE [ottInvLineTEMP_ALL] ADD CONSTRAINT [ITEMS_ottInvLineTEMP_ALL] 
    FOREIGN KEY ([EXT_ITEM_ID]) REFERENCES [ITEMS] ([ITEM_ID])
GO

ALTER TABLE [ottInvTaxesTEMP_ALL] ADD CONSTRAINT [ORGANIZATIONS_ottInvTaxesTEMP_ALL] 
    FOREIGN KEY ([organization_id]) REFERENCES [ORGANIZATIONS] ([ORGANIZATION_ID])
GO

ALTER TABLE [ottInvTaxesTEMP_ALL] ADD CONSTRAINT [INVOICES_ottInvTaxesTEMP_ALL] 
    FOREIGN KEY ([INVOICE_ID]) REFERENCES [INVOICES] ([INVOICE_ID])
GO

ALTER TABLE [INVOICE_BATCH_STATUSES] ADD CONSTRAINT [countries_INVOICE_BATCH_STATUSES] 
    FOREIGN KEY ([CODE]) REFERENCES [countries] ([code])
GO

ALTER TABLE [ITEMS_REPORTING_TYPE] ADD CONSTRAINT [ITEMS_ITEMS_REPORTING_TYPE] 
    FOREIGN KEY ([ITEMS_REPORTING_TYPE_ID]) REFERENCES [ITEMS] ([ITEM_ID])
GO

ALTER TABLE [ORG_GP_TABLES] ADD CONSTRAINT [GREAT_PLAINS_TABLES_ORG_GP_TABLES] 
    FOREIGN KEY ([TABLE_ID]) REFERENCES [GREAT_PLAINS_TABLES] ([TABLE_ID])
GO

ALTER TABLE [ROLE_FUNCTION_RIGHTS] ADD CONSTRAINT [FUNCTIONS_ROLE_FUNCTION_RIGHTS] 
    FOREIGN KEY ([FUNCTION_ID]) REFERENCES [FUNCTIONS] ([FUNCTION_ID])
GO

ALTER TABLE [ROLE_FUNCTION_RIGHTS] ADD CONSTRAINT [ROLES_ROLE_FUNCTION_RIGHTS] 
    FOREIGN KEY ([ROLE_ID]) REFERENCES [ROLES] ([ROLE_ID])
GO

ALTER TABLE [ROLE_FUNCTION_RIGHTS] ADD CONSTRAINT [RIGHT_TYPES_ROLE_FUNCTION_RIGHTS] 
    FOREIGN KEY ([RIGHT_TYPE_ID]) REFERENCES [RIGHT_TYPES] ([RIGHT_TYPE_ID])
GO

ALTER TABLE [USER_ROLES] ADD CONSTRAINT [USERS_USER_ROLES] 
    FOREIGN KEY ([USER_ID]) REFERENCES [USERS] ([USER_ID])
GO

ALTER TABLE [USER_ROLES] ADD CONSTRAINT [ROLES_USER_ROLES] 
    FOREIGN KEY ([ROLE_ID]) REFERENCES [ROLES] ([ROLE_ID])
GO

ALTER TABLE [LOOKUPS] ADD CONSTRAINT [countries_LOOKUPS] 
    FOREIGN KEY ([CODE]) REFERENCES [countries] ([code])
GO

ALTER TABLE [LOOKUPS] ADD CONSTRAINT [LOOKUP_TYPES_LOOKUPS] 
    FOREIGN KEY ([LOOKUP_TYPE_ID]) REFERENCES [LOOKUP_TYPES] ([LOOKUP_TYPE_ID])
GO

ALTER TABLE [INVOICE_LINES] ADD CONSTRAINT [SERVICES_INVOICE_LINES] 
    FOREIGN KEY ([bill_service_id]) REFERENCES [SERVICES] ([SERVICE_ID])
GO

ALTER TABLE [INVOICE_LINES] ADD CONSTRAINT [INVOICES_INVOICE_LINES] 
    FOREIGN KEY ([INVOICE_ID]) REFERENCES [INVOICES] ([INVOICE_ID])
GO

ALTER TABLE [INVOICE_LINES] ADD CONSTRAINT [ITEMS_INVOICE_LINES] 
    FOREIGN KEY ([ITEM_ID]) REFERENCES [ITEMS] ([ITEM_ID])
GO

ALTER TABLE [INVOICE_TRACKING] ADD CONSTRAINT [INVOICE_STATUSES_INVOICE_TRACKING] 
    FOREIGN KEY ([NEW_STATUS_ID]) REFERENCES [INVOICE_STATUSES] ([STATUS_ID])
GO

ALTER TABLE [INVOICE_TRACKING] ADD CONSTRAINT [SERVICE_LINE_STATUSES_INVOICE_TRACKING] 
    FOREIGN KEY ([NEW_STATUS_ID]) REFERENCES [SERVICE_LINE_STATUSES] ([STATUS_ID])
GO

ALTER TABLE [INVOICE_TRACKING] ADD CONSTRAINT [SERVICE_STATUSES_INVOICE_TRACKING] 
    FOREIGN KEY ([NEW_STATUS_ID]) REFERENCES [SERVICE_STATUSES] ([STATUS_ID])
GO

ALTER TABLE [INVOICE_TRACKING] ADD CONSTRAINT [INVOICE_BATCH_STATUSES_INVOICE_TRACKING] 
    FOREIGN KEY ([NEW_STATUS_ID]) REFERENCES [INVOICE_BATCH_STATUSES] ([STATUS_ID])
GO

ALTER TABLE [INVOICE_TRACKING] ADD CONSTRAINT [TRACKING_INVOICE_TRACKING] 
    FOREIGN KEY ([INVOICE_TRACKING_TYPE_ID]) REFERENCES [TRACKING] ([TRACKING_ID])
GO

ALTER TABLE [INVOICE_TRACKING] ADD CONSTRAINT [INVOICES_INVOICE_TRACKING] 
    FOREIGN KEY ([INVOICE_ID]) REFERENCES [INVOICES] ([INVOICE_ID])
GO

ALTER TABLE [INVOICE_TRACKING] ADD CONSTRAINT [CONTACTS_INVOICE_TRACKING] 
    FOREIGN KEY ([TO_CONTACT_ID]) REFERENCES [CONTACTS] ([CONTACT_ID])
GO

ALTER TABLE [INVOICE_TRACKING] ADD CONSTRAINT [USERS_INVOICE_TRACKING] 
    FOREIGN KEY ([FROM_USER_ID]) REFERENCES [USERS] ([USER_ID])
GO

ALTER TABLE [SERVICE_LINES] ADD CONSTRAINT [INVOICE_STATUSES_SERVICE_LINES] 
    FOREIGN KEY ([STATUS_ID]) REFERENCES [INVOICE_STATUSES] ([STATUS_ID])
GO

ALTER TABLE [SERVICE_LINES] ADD CONSTRAINT [SERVICE_LINE_STATUSES_SERVICE_LINES] 
    FOREIGN KEY ([STATUS_ID]) REFERENCES [SERVICE_LINE_STATUSES] ([STATUS_ID])
GO

ALTER TABLE [SERVICE_LINES] ADD CONSTRAINT [SERVICE_STATUSES_SERVICE_LINES] 
    FOREIGN KEY ([STATUS_ID]) REFERENCES [SERVICE_STATUSES] ([STATUS_ID])
GO

ALTER TABLE [SERVICE_LINES] ADD CONSTRAINT [INVOICE_BATCH_STATUSES_SERVICE_LINES] 
    FOREIGN KEY ([STATUS_ID]) REFERENCES [INVOICE_BATCH_STATUSES] ([STATUS_ID])
GO

ALTER TABLE [SERVICE_LINES] ADD CONSTRAINT [ITEMS_REPORTING_TYPE_SERVICE_LINES] 
    FOREIGN KEY ([ITEM_NAME]) REFERENCES [ITEMS_REPORTING_TYPE] ([ITEM_NAME])
GO

ALTER TABLE [SERVICE_LINES] ADD CONSTRAINT [SERVICES_SERVICE_LINES] 
    FOREIGN KEY ([TC_SERVICE_ID]) REFERENCES [SERVICES] ([SERVICE_ID])
GO

ALTER TABLE [SERVICE_LINES] ADD CONSTRAINT [RESOURCES_SERVICE_LINES] 
    FOREIGN KEY ([RESOURCE_ID]) REFERENCES [RESOURCES] ([RESOURCE_ID])
GO

ALTER TABLE [SERVICE_LINES] ADD CONSTRAINT [JOBS_SERVICE_LINES] 
    FOREIGN KEY ([TC_JOB_ID]) REFERENCES [JOBS] ([JOB_ID])
GO

ALTER TABLE [SERVICE_LINES] ADD CONSTRAINT [ORGANIZATIONS_SERVICE_LINES] 
    FOREIGN KEY ([ORGANIZATION_ID]) REFERENCES [ORGANIZATIONS] ([ORGANIZATION_ID])
GO

ALTER TABLE [SERVICE_LINES] ADD CONSTRAINT [INVOICES_SERVICE_LINES] 
    FOREIGN KEY ([INVOICE_ID]) REFERENCES [INVOICES] ([INVOICE_ID])
GO

ALTER TABLE [SERVICE_LINES] ADD CONSTRAINT [ITEMS_SERVICE_LINES] 
    FOREIGN KEY ([ITEM_ID]) REFERENCES [ITEMS] ([ITEM_ID])
GO

ALTER TABLE [SCH_RESOURCES] ADD CONSTRAINT [SERVICES_SCH_RESOURCES] 
    FOREIGN KEY ([SERVICE_ID]) REFERENCES [SERVICES] ([SERVICE_ID])
GO

ALTER TABLE [SCH_RESOURCES] ADD CONSTRAINT [RESOURCES_SCH_RESOURCES] 
    FOREIGN KEY ([WEEKEND_SCH_RESOURCE_ID]) REFERENCES [RESOURCES] ([RESOURCE_ID])
GO

ALTER TABLE [SCH_RESOURCES] ADD CONSTRAINT [JOBS_SCH_RESOURCES] 
    FOREIGN KEY ([JOB_ID]) REFERENCES [JOBS] ([JOB_ID])
GO

ALTER TABLE [TRACKING] ADD CONSTRAINT [INVOICE_STATUSES_TRACKING] 
    FOREIGN KEY ([NEW_STATUS_ID]) REFERENCES [INVOICE_STATUSES] ([STATUS_ID])
GO

ALTER TABLE [TRACKING] ADD CONSTRAINT [SERVICE_LINE_STATUSES_TRACKING] 
    FOREIGN KEY ([NEW_STATUS_ID]) REFERENCES [SERVICE_LINE_STATUSES] ([STATUS_ID])
GO

ALTER TABLE [TRACKING] ADD CONSTRAINT [SERVICE_STATUSES_TRACKING] 
    FOREIGN KEY ([NEW_STATUS_ID]) REFERENCES [SERVICE_STATUSES] ([STATUS_ID])
GO

ALTER TABLE [TRACKING] ADD CONSTRAINT [INVOICE_BATCH_STATUSES_TRACKING] 
    FOREIGN KEY ([NEW_STATUS_ID]) REFERENCES [INVOICE_BATCH_STATUSES] ([STATUS_ID])
GO

ALTER TABLE [TRACKING] ADD CONSTRAINT [SERVICES_TRACKING] 
    FOREIGN KEY ([SERVICE_ID]) REFERENCES [SERVICES] ([SERVICE_ID])
GO

ALTER TABLE [TRACKING] ADD CONSTRAINT [JOBS_TRACKING] 
    FOREIGN KEY ([JOB_ID]) REFERENCES [JOBS] ([JOB_ID])
GO

ALTER TABLE [TRACKING] ADD CONSTRAINT [CONTACTS_TRACKING] 
    FOREIGN KEY ([TO_CONTACT_ID]) REFERENCES [CONTACTS] ([CONTACT_ID])
GO

ALTER TABLE [TRACKING] ADD CONSTRAINT [USERS_TRACKING] 
    FOREIGN KEY ([FROM_USER_ID]) REFERENCES [USERS] ([USER_ID])
GO

ALTER TABLE [SERVICE_TASKS] ADD CONSTRAINT [SERVICES_SERVICE_TASKS] 
    FOREIGN KEY ([SERVICE_ID]) REFERENCES [SERVICES] ([SERVICE_ID])
GO

ALTER TABLE [RESOURCE_ESTIMATES] ADD CONSTRAINT [SERVICES_RESOURCE_ESTIMATES] 
    FOREIGN KEY ([SERVICE_ID]) REFERENCES [SERVICES] ([SERVICE_ID])
GO

ALTER TABLE [RESOURCE_ESTIMATES] ADD CONSTRAINT [RESOURCE_TYPES_RESOURCE_ESTIMATES] 
    FOREIGN KEY ([RESOURCE_TYPE_ID]) REFERENCES [RESOURCE_TYPES] ([RESOURCE_TYPE_ID])
GO

ALTER TABLE [RESOURCE_ESTIMATES] ADD CONSTRAINT [JOBS_RESOURCE_ESTIMATES] 
    FOREIGN KEY ([JOB_ID]) REFERENCES [JOBS] ([JOB_ID])
GO

ALTER TABLE [RESOURCE_ESTIMATES] ADD CONSTRAINT [JOB_ITEM_RATES_RESOURCE_ESTIMATES] 
    FOREIGN KEY ([JOB_ITEM_RATE_ID]) REFERENCES [JOB_ITEM_RATES] ([JOB_ITEM_RATE_ID])
GO

ALTER TABLE [QUOTE_STANDARD_CONDITIONS] ADD CONSTRAINT [QUOTES_QUOTE_STANDARD_CONDITIONS] 
    FOREIGN KEY ([QUOTE_ID]) REFERENCES [QUOTES] ([quote_id])
GO

ALTER TABLE [QUOTE_STANDARD_CONDITIONS] ADD CONSTRAINT [STANDARD_CONDITIONS_QUOTE_STANDARD_CONDITIONS] 
    FOREIGN KEY ([STANDARD_CONDITION_ID]) REFERENCES [STANDARD_CONDITIONS] ([standard_condition_id])
GO

ALTER TABLE [FUNCTIONS] ADD CONSTRAINT [TEMPLATES_FUNCTIONS] 
    FOREIGN KEY ([TEMPLATE_ID]) REFERENCES [TEMPLATES] ([TEMPLATE_ID])
GO

ALTER TABLE [FUNCTIONS] ADD CONSTRAINT [FUNCTION_GROUPS_FUNCTIONS] 
    FOREIGN KEY ([FUNCTION_GROUP_ID]) REFERENCES [FUNCTION_GROUPS] ([FUNCTION_GROUP_ID])
GO

ALTER TABLE [FUNCTIONS] ADD CONSTRAINT [countries_FUNCTIONS] 
    FOREIGN KEY ([CODE]) REFERENCES [countries] ([code])
GO

ALTER TABLE [FUNCTIONS] ADD CONSTRAINT [TEMPLATE_LOCATIONS_FUNCTIONS] 
    FOREIGN KEY ([TEMPLATE_LOCATION_ID]) REFERENCES [TEMPLATE_LOCATIONS] ([TEMPLATE_LOCATION_ID])
GO

ALTER TABLE [PUNCHLISTS] ADD CONSTRAINT [REQUESTS_PUNCHLISTS] 
    FOREIGN KEY ([request_id]) REFERENCES [REQUESTS] ([REQUEST_ID])
GO

ALTER TABLE [PUNCHLISTS] ADD CONSTRAINT [PROJECTS_PUNCHLISTS] 
    FOREIGN KEY ([PROJECT_ID]) REFERENCES [PROJECTS] ([PROJECT_ID])
GO

ALTER TABLE [purchase_orders] ADD CONSTRAINT [INVOICE_STATUSES_purchase_orders] 
    FOREIGN KEY ([po_status_id]) REFERENCES [INVOICE_STATUSES] ([STATUS_ID])
GO

ALTER TABLE [purchase_orders] ADD CONSTRAINT [SERVICE_LINE_STATUSES_purchase_orders] 
    FOREIGN KEY ([po_status_id]) REFERENCES [SERVICE_LINE_STATUSES] ([STATUS_ID])
GO

ALTER TABLE [purchase_orders] ADD CONSTRAINT [SERVICE_STATUSES_purchase_orders] 
    FOREIGN KEY ([po_status_id]) REFERENCES [SERVICE_STATUSES] ([STATUS_ID])
GO

ALTER TABLE [purchase_orders] ADD CONSTRAINT [INVOICE_BATCH_STATUSES_purchase_orders] 
    FOREIGN KEY ([po_status_id]) REFERENCES [INVOICE_BATCH_STATUSES] ([STATUS_ID])
GO

ALTER TABLE [purchase_orders] ADD CONSTRAINT [REQUESTS_purchase_orders] 
    FOREIGN KEY ([request_id]) REFERENCES [REQUESTS] ([REQUEST_ID])
GO

ALTER TABLE [purchase_orders] ADD CONSTRAINT [ITEMS_purchase_orders] 
    FOREIGN KEY ([item_id]) REFERENCES [ITEMS] ([ITEM_ID])
GO

ALTER TABLE [SERVICES] ADD CONSTRAINT [SERVICE_TASKS_SERVICES] 
    FOREIGN KEY ([SERVICE_TYPE_ID]) REFERENCES [SERVICE_TASKS] ([SERVICE_TASK_ID])
GO

ALTER TABLE [SERVICES] ADD CONSTRAINT [QUOTES_SERVICES] 
    FOREIGN KEY ([QUOTE_ID]) REFERENCES [QUOTES] ([quote_id])
GO

ALTER TABLE [SERVICES] ADD CONSTRAINT [REQUESTS_SERVICES] 
    FOREIGN KEY ([REQUEST_ID]) REFERENCES [REQUESTS] ([REQUEST_ID])
GO

ALTER TABLE [SERVICES] ADD CONSTRAINT [JOB_LOCATIONS_SERVICES] 
    FOREIGN KEY ([JOB_LOCATION_ID]) REFERENCES [JOB_LOCATIONS] ([JOB_LOCATION_ID])
GO

ALTER TABLE [SERVICES] ADD CONSTRAINT [JOBS_SERVICES] 
    FOREIGN KEY ([JOB_ID]) REFERENCES [JOBS] ([JOB_ID])
GO

ALTER TABLE [SERVICES] ADD CONSTRAINT [CONTACTS_SERVICES] 
    FOREIGN KEY ([CUSTOMER_CONTACT_ID]) REFERENCES [CONTACTS] ([CONTACT_ID])
GO

ALTER TABLE [SERVICES] ADD CONSTRAINT [job_location_contacts_SERVICES] 
    FOREIGN KEY ([job_location_contact_id]) REFERENCES [job_location_contacts] ([job_location_contact_id])
GO

ALTER TABLE [SERVICES] ADD CONSTRAINT [VERSIONS_SERVICES] 
    FOREIGN KEY ([VERSION_NO]) REFERENCES [VERSIONS] ([VERSION_ID])
GO

ALTER TABLE [CHECKLISTS] ADD CONSTRAINT [REQUESTS_CHECKLISTS] 
    FOREIGN KEY ([REQUEST_ID]) REFERENCES [REQUESTS] ([REQUEST_ID])
GO

ALTER TABLE [QUOTES] ADD CONSTRAINT [REQUESTS_QUOTES] 
    FOREIGN KEY ([request_id]) REFERENCES [REQUESTS] ([REQUEST_ID])
GO

ALTER TABLE [QUOTES] ADD CONSTRAINT [USERS_QUOTES] 
    FOREIGN KEY ([quoted_by_user_id]) REFERENCES [USERS] ([USER_ID])
GO

ALTER TABLE [REQUEST_VENDORS] ADD CONSTRAINT [NUMBERS_REQUEST_VENDORS] 
    FOREIGN KEY ([INVOICE_NUMBERS]) REFERENCES [NUMBERS] ([number])
GO

ALTER TABLE [REQUEST_VENDORS] ADD CONSTRAINT [REQUESTS_REQUEST_VENDORS] 
    FOREIGN KEY ([REQUEST_ID]) REFERENCES [REQUESTS] ([REQUEST_ID])
GO

ALTER TABLE [REQUEST_VENDORS] ADD CONSTRAINT [CONTACTS_REQUEST_VENDORS] 
    FOREIGN KEY ([VENDOR_CONTACT_ID]) REFERENCES [CONTACTS] ([CONTACT_ID])
GO

ALTER TABLE [REQUEST_DOCUMENTS] ADD CONSTRAINT [REQUESTS_REQUEST_DOCUMENTS] 
    FOREIGN KEY ([request_id]) REFERENCES [REQUESTS] ([REQUEST_ID])
GO

ALTER TABLE [CUSTOM_COLS] ADD CONSTRAINT [SERVICES_CUSTOM_COLS] 
    FOREIGN KEY ([SERVICE_ID]) REFERENCES [SERVICES] ([SERVICE_ID])
GO

ALTER TABLE [CUSTOM_COLS] ADD CONSTRAINT [REQUESTS_CUSTOM_COLS] 
    FOREIGN KEY ([REQUEST_ID]) REFERENCES [REQUESTS] ([REQUEST_ID])
GO

ALTER TABLE [CUSTOM_COLS] ADD CONSTRAINT [CUSTOM_CUST_COLUMNS_CUSTOM_COLS] 
    FOREIGN KEY ([CUSTOM_CUST_COL_ID]) REFERENCES [CUSTOM_CUST_COLUMNS] ([CUSTOM_CUST_COL_ID])
GO

ALTER TABLE [PAYROLL_BATCH_LINES] ADD CONSTRAINT [EXPENSES_BATCHES_PAYROLL_BATCH_LINES] 
    FOREIGN KEY ([INT_BATCH_ID]) REFERENCES [EXPENSES_BATCHES] ([INT_BATCH_ID])
GO

ALTER TABLE [PAYROLL_BATCH_LINES] ADD CONSTRAINT [PAYROLL_BATCHES_PAYROLL_BATCH_LINES] 
    FOREIGN KEY ([INT_BATCH_ID]) REFERENCES [PAYROLL_BATCHES] ([INT_BATCH_ID])
GO

ALTER TABLE [PAYROLL_BATCH_LINES] ADD CONSTRAINT [ITEMS_PAYROLL_BATCH_LINES] 
    FOREIGN KEY ([EXT_ITEM_ID]) REFERENCES [ITEMS] ([ITEM_ID])
GO

ALTER TABLE [CHECKLIST_DATA] ADD CONSTRAINT [CHECKLISTS_CHECKLIST_DATA] 
    FOREIGN KEY ([CHECKLIST_ID]) REFERENCES [CHECKLISTS] ([CHECKLIST_ID])
GO

ALTER TABLE [QUOTE_OTHER_FURNITURE_AD_HOC] ADD CONSTRAINT [NUMBERS_QUOTE_OTHER_FURNITURE_AD_HOC] 
    FOREIGN KEY ([SET_NUMBER]) REFERENCES [NUMBERS] ([number])
GO

ALTER TABLE [QUOTE_OTHER_FURNITURE_AD_HOC] ADD CONSTRAINT [QUOTES_QUOTE_OTHER_FURNITURE_AD_HOC] 
    FOREIGN KEY ([QUOTE_ID]) REFERENCES [QUOTES] ([quote_id])
GO

ALTER TABLE [QUOTE_SPECIFY_OTHER_SERVICES] ADD CONSTRAINT [NUMBERS_QUOTE_SPECIFY_OTHER_SERVICES] 
    FOREIGN KEY ([SET_NUMBER]) REFERENCES [NUMBERS] ([number])
GO

ALTER TABLE [QUOTE_SPECIFY_OTHER_SERVICES] ADD CONSTRAINT [QUOTES_QUOTE_SPECIFY_OTHER_SERVICES] 
    FOREIGN KEY ([QUOTE_ID]) REFERENCES [QUOTES] ([quote_id])
GO

ALTER TABLE [QUOTE_OTHER_FURNITURE] ADD CONSTRAINT [NUMBERS_QUOTE_OTHER_FURNITURE] 
    FOREIGN KEY ([SET_NUMBER]) REFERENCES [NUMBERS] ([number])
GO

ALTER TABLE [QUOTE_OTHER_FURNITURE] ADD CONSTRAINT [QUOTES_QUOTE_OTHER_FURNITURE] 
    FOREIGN KEY ([QUOTE_ID]) REFERENCES [QUOTES] ([quote_id])
GO

ALTER TABLE [QUOTE_WORKSTATION_CONFIGURATIONS] ADD CONSTRAINT [NUMBERS_QUOTE_WORKSTATION_CONFIGURATIONS] 
    FOREIGN KEY ([SET_NUMBER]) REFERENCES [NUMBERS] ([number])
GO

ALTER TABLE [QUOTE_WORKSTATION_CONFIGURATIONS] ADD CONSTRAINT [QUOTES_QUOTE_WORKSTATION_CONFIGURATIONS] 
    FOREIGN KEY ([QUOTE_ID]) REFERENCES [QUOTES] ([quote_id])
GO

ALTER TABLE [ROLES] ADD CONSTRAINT [countries_ROLES] 
    FOREIGN KEY ([CODE]) REFERENCES [countries] ([code])
GO

ALTER TABLE [LOOKUP_TYPES] ADD CONSTRAINT [countries_LOOKUP_TYPES] 
    FOREIGN KEY ([CODE]) REFERENCES [countries] ([code])
GO

ALTER TABLE [PUNCHLIST_ISSUES] ADD CONSTRAINT [INVOICE_STATUSES_PUNCHLIST_ISSUES] 
    FOREIGN KEY ([STATUS_ID]) REFERENCES [INVOICE_STATUSES] ([STATUS_ID])
GO

ALTER TABLE [PUNCHLIST_ISSUES] ADD CONSTRAINT [SERVICE_LINE_STATUSES_PUNCHLIST_ISSUES] 
    FOREIGN KEY ([STATUS_ID]) REFERENCES [SERVICE_LINE_STATUSES] ([STATUS_ID])
GO

ALTER TABLE [PUNCHLIST_ISSUES] ADD CONSTRAINT [SERVICE_STATUSES_PUNCHLIST_ISSUES] 
    FOREIGN KEY ([STATUS_ID]) REFERENCES [SERVICE_STATUSES] ([STATUS_ID])
GO

ALTER TABLE [PUNCHLIST_ISSUES] ADD CONSTRAINT [INVOICE_BATCH_STATUSES_PUNCHLIST_ISSUES] 
    FOREIGN KEY ([STATUS_ID]) REFERENCES [INVOICE_BATCH_STATUSES] ([STATUS_ID])
GO

ALTER TABLE [PUNCHLIST_ISSUES] ADD CONSTRAINT [PUNCHLISTS_PUNCHLIST_ISSUES] 
    FOREIGN KEY ([PUNCHLIST_ID]) REFERENCES [PUNCHLISTS] ([PUNCHLIST_ID])
GO

ALTER TABLE [USER_VENDORS] ADD CONSTRAINT [CUSTOMERS_USER_VENDORS] 
    FOREIGN KEY ([customer_id]) REFERENCES [CUSTOMERS] ([CUSTOMER_ID])
GO

ALTER TABLE [USER_VENDORS] ADD CONSTRAINT [USERS_USER_VENDORS] 
    FOREIGN KEY ([user_id]) REFERENCES [USERS] ([USER_ID])
GO

ALTER TABLE [REQUESTS] ADD CONSTRAINT [CONDITIONS_REQUESTS] 
    FOREIGN KEY ([OTHER_CONDITIONS]) REFERENCES [CONDITIONS] ([CONDITION_ID])
GO

ALTER TABLE [REQUESTS] ADD CONSTRAINT [NUMBERS_REQUESTS] 
    FOREIGN KEY ([P_CARD_NUMBER]) REFERENCES [NUMBERS] ([number])
GO

ALTER TABLE [REQUESTS] ADD CONSTRAINT [JOB_LOCATIONS_REQUESTS] 
    FOREIGN KEY ([JOB_LOCATION_ID]) REFERENCES [JOB_LOCATIONS] ([JOB_LOCATION_ID])
GO

ALTER TABLE [REQUESTS] ADD CONSTRAINT [PROJECTS_REQUESTS] 
    FOREIGN KEY ([PROJECT_ID]) REFERENCES [PROJECTS] ([PROJECT_ID])
GO

ALTER TABLE [REQUESTS] ADD CONSTRAINT [CONTACTS_REQUESTS] 
    FOREIGN KEY ([CUSTOMER_CONTACT_ID]) REFERENCES [CONTACTS] ([CONTACT_ID])
GO

ALTER TABLE [REQUESTS] ADD CONSTRAINT [job_location_contacts_REQUESTS] 
    FOREIGN KEY ([JOB_LOCATION_CONTACT_ID]) REFERENCES [job_location_contacts] ([job_location_contact_id])
GO

ALTER TABLE [REQUESTS] ADD CONSTRAINT [VERSIONS_REQUESTS] 
    FOREIGN KEY ([VERSION_NO]) REFERENCES [VERSIONS] ([VERSION_ID])
GO

ALTER TABLE [USER_CUSTOMERS] ADD CONSTRAINT [CUSTOMERS_USER_CUSTOMERS] 
    FOREIGN KEY ([customer_id]) REFERENCES [CUSTOMERS] ([CUSTOMER_ID])
GO

ALTER TABLE [USER_CUSTOMERS] ADD CONSTRAINT [USERS_USER_CUSTOMERS] 
    FOREIGN KEY ([user_id]) REFERENCES [USERS] ([USER_ID])
GO

ALTER TABLE [RESOURCES] ADD CONSTRAINT [RESOURCE_ESTIMATES_RESOURCES] 
    FOREIGN KEY ([RESOURCE_TYPE_ID]) REFERENCES [RESOURCE_ESTIMATES] ([RESOURCE_EST_ID])
GO

ALTER TABLE [RESOURCES] ADD CONSTRAINT [RESOURCE_TYPES_RESOURCES] 
    FOREIGN KEY ([RESOURCE_TYPE_ID]) REFERENCES [RESOURCE_TYPES] ([RESOURCE_TYPE_ID])
GO

ALTER TABLE [RESOURCES] ADD CONSTRAINT [USER_ORGANIZATIONS_RESOURCES] 
    FOREIGN KEY ([ORGANIZATION_ID], [USER_ID]) REFERENCES [USER_ORGANIZATIONS] ([ORGANIZATION_ID],[USER_ID])
GO

ALTER TABLE [RESOURCES] ADD CONSTRAINT [ORGANIZATIONS_RESOURCES] 
    FOREIGN KEY ([ORGANIZATION_ID]) REFERENCES [ORGANIZATIONS] ([ORGANIZATION_ID])
GO

ALTER TABLE [RESOURCES] ADD CONSTRAINT [USERS_RESOURCES] 
    FOREIGN KEY ([USER_ID]) REFERENCES [USERS] ([USER_ID])
GO

ALTER TABLE [PAYROLL_BATCHES] ADD CONSTRAINT [EXPENSES_BATCHES_PAYROLL_BATCHES] 
    FOREIGN KEY ([EXT_BATCH_ID]) REFERENCES [EXPENSES_BATCHES] ([INT_BATCH_ID])
GO

ALTER TABLE [PAYROLL_BATCHES] ADD CONSTRAINT [ORGANIZATIONS_PAYROLL_BATCHES] 
    FOREIGN KEY ([ORGANIZATION_ID]) REFERENCES [ORGANIZATIONS] ([ORGANIZATION_ID])
GO

ALTER TABLE [RESOURCE_TYPES] ADD CONSTRAINT [countries_RESOURCE_TYPES] 
    FOREIGN KEY ([CODE]) REFERENCES [countries] ([code])
GO

ALTER TABLE [RESOURCE_TYPE_ITEMS] ADD CONSTRAINT [RESOURCE_ESTIMATES_RESOURCE_TYPE_ITEMS] 
    FOREIGN KEY ([RESOURCE_TYPE_ID]) REFERENCES [RESOURCE_ESTIMATES] ([RESOURCE_EST_ID])
GO

ALTER TABLE [RESOURCE_TYPE_ITEMS] ADD CONSTRAINT [RESOURCE_TYPES_RESOURCE_TYPE_ITEMS] 
    FOREIGN KEY ([RESOURCE_TYPE_ID]) REFERENCES [RESOURCE_TYPES] ([RESOURCE_TYPE_ID])
GO

ALTER TABLE [RESOURCE_TYPE_ITEMS] ADD CONSTRAINT [ITEMS_RESOURCE_TYPE_ITEMS] 
    FOREIGN KEY ([ITEM_ID]) REFERENCES [ITEMS] ([ITEM_ID])
GO

ALTER TABLE [RIGHT_TYPES] ADD CONSTRAINT [countries_RIGHT_TYPES] 
    FOREIGN KEY ([CODE]) REFERENCES [countries] ([code])
GO

ALTER TABLE [QUOTE_CONDITIONS] ADD CONSTRAINT [CONDITIONS_QUOTE_CONDITIONS] 
    FOREIGN KEY ([CONDITION_ID]) REFERENCES [CONDITIONS] ([CONDITION_ID])
GO

ALTER TABLE [QUOTE_CONDITIONS] ADD CONSTRAINT [QUOTES_QUOTE_CONDITIONS] 
    FOREIGN KEY ([QUOTE_ID]) REFERENCES [QUOTES] ([quote_id])
GO

ALTER TABLE [JOB_LOCATIONS] ADD CONSTRAINT [CUSTOMERS_JOB_LOCATIONS] 
    FOREIGN KEY ([CUSTOMER_ID]) REFERENCES [CUSTOMERS] ([CUSTOMER_ID])
GO

ALTER TABLE [JOB_LOCATIONS] ADD CONSTRAINT [CONTACTS_JOB_LOCATIONS] 
    FOREIGN KEY ([JOB_LOC_CONTACT_ID]) REFERENCES [CONTACTS] ([CONTACT_ID])
GO

ALTER TABLE [USER_JOB_TYPES] ADD CONSTRAINT [LOOKUPS_USER_JOB_TYPES] 
    FOREIGN KEY ([LOOKUP_ID]) REFERENCES [LOOKUPS] ([LOOKUP_ID])
GO

ALTER TABLE [USER_JOB_TYPES] ADD CONSTRAINT [USERS_USER_JOB_TYPES] 
    FOREIGN KEY ([USER_ID]) REFERENCES [USERS] ([USER_ID])
GO

ALTER TABLE [RESOURCE_ITEMS] ADD CONSTRAINT [RESOURCES_RESOURCE_ITEMS] 
    FOREIGN KEY ([RESOURCE_ID]) REFERENCES [RESOURCES] ([RESOURCE_ID])
GO

ALTER TABLE [RESOURCE_ITEMS] ADD CONSTRAINT [ITEMS_RESOURCE_ITEMS] 
    FOREIGN KEY ([ITEM_ID]) REFERENCES [ITEMS] ([ITEM_ID])
GO

ALTER TABLE [USER_ORGANIZATIONS] ADD CONSTRAINT [USERS_USER_ORGANIZATIONS] 
    FOREIGN KEY ([USER_ID]) REFERENCES [USERS] ([USER_ID])
GO

ALTER TABLE [USER_ORGANIZATIONS] ADD CONSTRAINT [ORGANIZATIONS_USER_ORGANIZATIONS] 
    FOREIGN KEY ([ORGANIZATION_ID]) REFERENCES [ORGANIZATIONS] ([ORGANIZATION_ID])
GO

ALTER TABLE [PROJECT_NOTES] ADD CONSTRAINT [PROJECTS_PROJECT_NOTES] 
    FOREIGN KEY ([PROJECT_ID]) REFERENCES [PROJECTS] ([PROJECT_ID])
GO

ALTER TABLE [JOBS] ADD CONSTRAINT [RESOURCES_JOBS] 
    FOREIGN KEY ([FOREMAN_RESOURCE_ID]) REFERENCES [RESOURCES] ([RESOURCE_ID])
GO

ALTER TABLE [JOBS] ADD CONSTRAINT [PROJECTS_JOBS] 
    FOREIGN KEY ([PROJECT_ID]) REFERENCES [PROJECTS] ([PROJECT_ID])
GO

ALTER TABLE [JOBS] ADD CONSTRAINT [CUSTOMERS_JOBS] 
    FOREIGN KEY ([CUSTOMER_ID]) REFERENCES [CUSTOMERS] ([CUSTOMER_ID])
GO

ALTER TABLE [JOBS] ADD CONSTRAINT [CONTACTS_JOBS] 
    FOREIGN KEY ([A_M_SALES_CONTACT_ID]) REFERENCES [CONTACTS] ([CONTACT_ID])
GO

ALTER TABLE [JOBS] ADD CONSTRAINT [USERS_JOBS] 
    FOREIGN KEY ([BILLING_USER_ID]) REFERENCES [USERS] ([USER_ID])
GO

ALTER TABLE [ORGANIZATIONS] ADD CONSTRAINT [countries_ORGANIZATIONS] 
    FOREIGN KEY ([CODE]) REFERENCES [countries] ([code])
GO

ALTER TABLE [ORGANIZATIONS] ADD CONSTRAINT [CONTACTS_ORGANIZATIONS] 
    FOREIGN KEY ([SCHEDULER_CONTACT_ID]) REFERENCES [CONTACTS] ([CONTACT_ID])
GO

ALTER TABLE [PROJECTS] ADD CONSTRAINT [CUSTOMERS_PROJECTS] 
    FOREIGN KEY ([CUSTOMER_ID]) REFERENCES [CUSTOMERS] ([CUSTOMER_ID])
GO

ALTER TABLE [PROJECTS] ADD CONSTRAINT [USERS_PROJECTS] 
    FOREIGN KEY ([END_USER_ID]) REFERENCES [USERS] ([USER_ID])
GO

ALTER TABLE [USER_APPROVERS] ADD CONSTRAINT [CUSTOMERS_USER_APPROVERS] 
    FOREIGN KEY ([customer_id]) REFERENCES [CUSTOMERS] ([CUSTOMER_ID])
GO

ALTER TABLE [USER_APPROVERS] ADD CONSTRAINT [USERS_USER_APPROVERS] 
    FOREIGN KEY ([user_id]) REFERENCES [USERS] ([USER_ID])
GO

ALTER TABLE [INVOICES] ADD CONSTRAINT [INVOICE_STATUSES_INVOICES] 
    FOREIGN KEY ([BATCH_STATUS_ID]) REFERENCES [INVOICE_STATUSES] ([STATUS_ID])
GO

ALTER TABLE [INVOICES] ADD CONSTRAINT [SERVICE_LINE_STATUSES_INVOICES] 
    FOREIGN KEY ([BATCH_STATUS_ID]) REFERENCES [SERVICE_LINE_STATUSES] ([STATUS_ID])
GO

ALTER TABLE [INVOICES] ADD CONSTRAINT [SERVICE_STATUSES_INVOICES] 
    FOREIGN KEY ([BATCH_STATUS_ID]) REFERENCES [SERVICE_STATUSES] ([STATUS_ID])
GO

ALTER TABLE [INVOICES] ADD CONSTRAINT [INVOICE_BATCH_STATUSES_INVOICES] 
    FOREIGN KEY ([BATCH_STATUS_ID]) REFERENCES [INVOICE_BATCH_STATUSES] ([STATUS_ID])
GO

ALTER TABLE [INVOICES] ADD CONSTRAINT [USER_ORGANIZATIONS_INVOICES] 
    FOREIGN KEY ([ORGANIZATION_ID], [USER_ID]) REFERENCES [USER_ORGANIZATIONS] ([ORGANIZATION_ID],[USER_ID])
GO

ALTER TABLE [INVOICES] ADD CONSTRAINT [JOBS_INVOICES] 
    FOREIGN KEY ([JOB_ID]) REFERENCES [JOBS] ([JOB_ID])
GO

ALTER TABLE [INVOICES] ADD CONSTRAINT [ORGANIZATIONS_INVOICES] 
    FOREIGN KEY ([ORGANIZATION_ID]) REFERENCES [ORGANIZATIONS] ([ORGANIZATION_ID])
GO

ALTER TABLE [INVOICES] ADD CONSTRAINT [CUSTOMERS_INVOICES] 
    FOREIGN KEY ([BILL_CUSTOMER_ID]) REFERENCES [CUSTOMERS] ([CUSTOMER_ID])
GO

ALTER TABLE [INVOICES] ADD CONSTRAINT [USERS_INVOICES] 
    FOREIGN KEY ([ASSIGNED_TO_USER_ID]) REFERENCES [USERS] ([USER_ID])
GO

ALTER TABLE [user_customer_end_users] ADD CONSTRAINT [USER_CUSTOMERS_user_customer_end_users] 
    FOREIGN KEY ([user_customer_id]) REFERENCES [USER_CUSTOMERS] ([user_customer_id])
GO

ALTER TABLE [user_customer_end_users] ADD CONSTRAINT [CUSTOMERS_user_customer_end_users] 
    FOREIGN KEY ([user_customer_id]) REFERENCES [CUSTOMERS] ([CUSTOMER_ID])
GO

ALTER TABLE [FUNCTION_RIGHT_TYPES] ADD CONSTRAINT [FUNCTIONS_FUNCTION_RIGHT_TYPES] 
    FOREIGN KEY ([FUNCTION_ID]) REFERENCES [FUNCTIONS] ([FUNCTION_ID])
GO

ALTER TABLE [FUNCTION_RIGHT_TYPES] ADD CONSTRAINT [RIGHT_TYPES_FUNCTION_RIGHT_TYPES] 
    FOREIGN KEY ([RIGHT_TYPE_ID]) REFERENCES [RIGHT_TYPES] ([RIGHT_TYPE_ID])
GO

ALTER TABLE [CUSTOMERS] ADD CONSTRAINT [ORGANIZATIONS_CUSTOMERS] 
    FOREIGN KEY ([ORGANIZATION_ID]) REFERENCES [ORGANIZATIONS] ([ORGANIZATION_ID])
GO

ALTER TABLE [CUSTOMERS] ADD CONSTRAINT [CONTACTS_CUSTOMERS] 
    FOREIGN KEY ([A_M_FURNITURE1_CONTACT_ID]) REFERENCES [CONTACTS] ([CONTACT_ID])
GO

ALTER TABLE [ITEMS] ADD CONSTRAINT [countries_ITEMS] 
    FOREIGN KEY ([CODE]) REFERENCES [countries] ([code])
GO

ALTER TABLE [ITEMS] ADD CONSTRAINT [ORGANIZATIONS_ITEMS] 
    FOREIGN KEY ([ORGANIZATION_ID]) REFERENCES [ORGANIZATIONS] ([ORGANIZATION_ID])
GO

ALTER TABLE [CONTACTS] ADD CONSTRAINT [ORGANIZATIONS_CONTACTS] 
    FOREIGN KEY ([ORGANIZATION_ID]) REFERENCES [ORGANIZATIONS] ([ORGANIZATION_ID])
GO

ALTER TABLE [CONTACTS] ADD CONSTRAINT [CUSTOMERS_CONTACTS] 
    FOREIGN KEY ([CUSTOMER_ID]) REFERENCES [CUSTOMERS] ([CUSTOMER_ID])
GO

ALTER TABLE [JOB_ITEM_RATES] ADD CONSTRAINT [JOBS_JOB_ITEM_RATES] 
    FOREIGN KEY ([JOB_ID]) REFERENCES [JOBS] ([JOB_ID])
GO

ALTER TABLE [JOB_ITEM_RATES] ADD CONSTRAINT [ITEMS_JOB_ITEM_RATES] 
    FOREIGN KEY ([ITEM_ID]) REFERENCES [ITEMS] ([ITEM_ID])
GO

ALTER TABLE [CONTACT_GROUPS] ADD CONSTRAINT [CONTACTS_CONTACT_GROUPS] 
    FOREIGN KEY ([CONTACT_ID]) REFERENCES [CONTACTS] ([CONTACT_ID])
GO

ALTER TABLE [USERS] ADD CONSTRAINT [USERS_CRYSTAL_USERS] 
    FOREIGN KEY ([LOGIN]) REFERENCES [USERS_CRYSTAL] ([login])
GO

ALTER TABLE [USERS] ADD CONSTRAINT [CONTACTS_USERS] 
    FOREIGN KEY ([CONTACT_ID]) REFERENCES [CONTACTS] ([CONTACT_ID])
GO

ALTER TABLE [job_location_contacts] ADD CONSTRAINT [JOB_LOCATIONS_job_location_contacts] 
    FOREIGN KEY ([job_location_id]) REFERENCES [JOB_LOCATIONS] ([JOB_LOCATION_ID])
GO

ALTER TABLE [job_location_contacts] ADD CONSTRAINT [CONTACTS_job_location_contacts] 
    FOREIGN KEY ([contact_id]) REFERENCES [CONTACTS] ([CONTACT_ID])
GO

ALTER TABLE [DOCUMENTS] ADD CONSTRAINT [countries_DOCUMENTS] 
    FOREIGN KEY ([CODE]) REFERENCES [countries] ([code])
GO

ALTER TABLE [DOCUMENTS] ADD CONSTRAINT [FORMATS_DOCUMENTS] 
    FOREIGN KEY ([FORMAT_ID]) REFERENCES [FORMATS] ([FORMAT_ID])
GO

ALTER TABLE [DOCUMENTS] ADD CONSTRAINT [PROJECTS_DOCUMENTS] 
    FOREIGN KEY ([PROJECT_ID]) REFERENCES [PROJECTS] ([PROJECT_ID])
GO

ALTER TABLE [VERSIONS] ADD CONSTRAINT [countries_VERSIONS] 
    FOREIGN KEY ([CODE]) REFERENCES [countries] ([code])
GO

ALTER TABLE [VERSIONS] ADD CONSTRAINT [DOCUMENTS_VERSIONS] 
    FOREIGN KEY ([DOCUMENT_ID]) REFERENCES [DOCUMENTS] ([DOCUMENT_ID])
GO

ALTER TABLE [CUSTOM_CUST_COLUMNS] ADD CONSTRAINT [CUSTOMERS_CUSTOM_CUST_COLUMNS] 
    FOREIGN KEY ([CUSTOMER_ID]) REFERENCES [CUSTOMERS] ([CUSTOMER_ID])
GO

ALTER TABLE [JOB_DISTRIBUTIONS] ADD CONSTRAINT [SCH_RESOURCES_JOB_DISTRIBUTIONS] 
    FOREIGN KEY ([SCH_RESOURCE_ID]) REFERENCES [SCH_RESOURCES] ([SCH_RESOURCE_ID])
GO

ALTER TABLE [JOB_DISTRIBUTIONS] ADD CONSTRAINT [RESOURCES_JOB_DISTRIBUTIONS] 
    FOREIGN KEY ([SCH_RESOURCE_ID]) REFERENCES [RESOURCES] ([RESOURCE_ID])
GO

ALTER TABLE [JOB_DISTRIBUTIONS] ADD CONSTRAINT [JOBS_JOB_DISTRIBUTIONS] 
    FOREIGN KEY ([JOB_ID]) REFERENCES [JOBS] ([JOB_ID])
GO

ALTER TABLE [JOB_DISTRIBUTIONS] ADD CONSTRAINT [USERS_JOB_DISTRIBUTIONS] 
    FOREIGN KEY ([USER_ID]) REFERENCES [USERS] ([USER_ID])
GO

ALTER TABLE [CUSTOM_COL_LISTS] ADD CONSTRAINT [CUSTOM_CUST_COLUMNS_CUSTOM_COL_LISTS] 
    FOREIGN KEY ([CUSTOM_CUST_COL_ID]) REFERENCES [CUSTOM_CUST_COLUMNS] ([CUSTOM_CUST_COL_ID])
GO

ALTER TABLE [ITEM_COSTING_HISTORY] ADD CONSTRAINT [ITEMS_ITEM_COSTING_HISTORY] 
    FOREIGN KEY ([ITEM_ID]) REFERENCES [ITEMS] ([ITEM_ID])
GO

ALTER TABLE [HOTSHEETS] ADD CONSTRAINT [REQUESTS_HOTSHEETS] 
    FOREIGN KEY ([REQUEST_ID]) REFERENCES [REQUESTS] ([REQUEST_ID])
GO

ALTER TABLE [HOTSHEET_DETAILS] ADD CONSTRAINT [HOTSHEETS_HOTSHEET_DETAILS] 
    FOREIGN KEY ([HOTSHEET_ID]) REFERENCES [HOTSHEETS] ([HOTSHEET_ID])
GO

/* ---------------------------------------------------------------------- */
/* Views                                                                  */
/* ---------------------------------------------------------------------- */

CREATE VIEW [dbo].[TEMPLATE_LOCATIONS_2_V]
AS
SELECT     dbo.TEMPLATE_LOCATIONS.LOCATION, TEMPLATES_1.TEMPLATE_NAME, TEMPLATES1.TEMPLATE_NAME AS TAB_NAME
FROM         dbo.TABS INNER JOIN
                      dbo.TEMPLATES TEMPLATES1 ON dbo.TABS.TEMPLATE_ID = TEMPLATES1.TEMPLATE_ID INNER JOIN
                      dbo.TEMPLATES TEMPLATES_1 INNER JOIN
                      dbo.TEMPLATE_LOCATIONS ON TEMPLATES_1.TEMPLATE_ID = dbo.TEMPLATE_LOCATIONS.LEVEL_2_TEMPLATE ON 
                      dbo.TABS.TAB_ID = dbo.TEMPLATE_LOCATIONS.LEVEL_2_TAB
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

CREATE VIEW [dbo].[TRACKING_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'tracking_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
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

CREATE VIEW [dbo].[WOOD_PRODUCT_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'wood_product_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO

CREATE VIEW [dbo].[YES_NO_TYPE_V]
AS
SELECT     dbo.LOOKUPS.LOOKUP_ID, dbo.LOOKUPS.CODE AS yes_no_type_code, dbo.LOOKUPS.NAME, dbo.LOOKUP_TYPES.CODE AS Lookup_type_code, 
                      dbo.LOOKUPS.SEQUENCE_NO, dbo.LOOKUPS.ACTIVE_FLAG, dbo.LOOKUP_TYPES.ACTIVE_FLAG AS TYPE_ACTIVE_FLAG
FROM         dbo.LOOKUP_TYPES INNER JOIN
                      dbo.LOOKUPS ON dbo.LOOKUP_TYPES.LOOKUP_TYPE_ID = dbo.LOOKUPS.LOOKUP_TYPE_ID
WHERE     (dbo.LOOKUP_TYPES.CODE = 'yes_no_type') AND (dbo.LOOKUPS.ACTIVE_FLAG = 'Y') AND (dbo.LOOKUP_TYPES.ACTIVE_FLAG = 'Y')
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

CREATE  VIEW [dbo].[GP_AIA_PAY_CODE_V]
AS
SELECT     *
FROM         AIA.dbo.UPR40600
WHERE     (PAYRCORD IN ('1', '2', '3', '4', '8', '16')) AND (INACTIVE = 0)
GO

CREATE VIEW [dbo].[PDA_REASONS_V] AS SELECT dbo.LOOKUPS.LOOKUP_ID AS reason_id, SUBSTRING(dbo.LOOKUPS.NAME, 0, 20) AS reason FROM dbo.LOOKUPS INNER JOIN dbo.LOOKUP_TYPES ON dbo.LOOKUPS.LOOKUP_TYPE_ID = dbo.LOOKUP_TYPES.LOOKUP_TYPE_ID WHERE (dbo.LOOKUP_TYPES.CODE = 'override_reason_type') AND (dbo.LOOKUP_TYPES.ACTIVE_FLAG = 'Y')
GO

CREATE VIEW [dbo].[Taxes_V]
AS
SELECT     TOP 100 PERCENT AMBIM.dbo.IV00101.ITEMNMBR, AMBIM.dbo.IV00101.TAXOPTNS, AMBIM.dbo.RM00101.CUSTNMBR, 
                      AMBIM.dbo.RM00101.TAXSCHID, dbo.INVOICES.INVOICE_ID, dbo.INVOICE_LINES_V.ext_item_id, dbo.INVOICE_LINES_V.UNIT_PRICE, 
                      dbo.INVOICE_LINES_V.QTY, dbo.INVOICE_LINES_V.UNIT_PRICE * dbo.INVOICE_LINES_V.QTY AS Total_line, 
                      dbo.INVOICE_LINES_V.UNIT_PRICE * dbo.INVOICE_LINES_V.QTY * .07 AS line_tax, dbo.INVOICES.ORGANIZATION_ID
FROM         dbo.INVOICES INNER JOIN
                      AMBIM.dbo.RM00101 ON CAST(dbo.INVOICES.EXT_BILL_CUST_ID AS char(15)) = AMBIM.dbo.RM00101.CUSTNMBR INNER JOIN
                      AMBIM.dbo.IV00101 INNER JOIN
                      dbo.INVOICE_LINES_V ON AMBIM.dbo.IV00101.ITEMNMBR = CAST(dbo.INVOICE_LINES_V.ext_item_id AS char(31)) ON 
                      dbo.INVOICES.INVOICE_ID = dbo.INVOICE_LINES_V.INVOICE_ID
WHERE     (dbo.INVOICES.ORGANIZATION_ID = 2) AND (AMBIM.dbo.RM00101.TAXSCHID <> 'EXEMPT')
ORDER BY dbo.INVOICES.INVOICE_ID
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

CREATE  VIEW [dbo].[GP_CIINC_PAY_CODE_V]
AS
SELECT     *
FROM         CIINC.dbo.UPR40600
WHERE     (PAYRCORD IN ('1', '2', '3', '4', '8', '16')) AND (INACTIVE = 0)
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

CREATE  VIEW [dbo].[GP_CILLC_PAY_CODE_V]
AS
SELECT     *
FROM         CILLC.dbo.UPR40600
WHERE     (PAYRCORD IN ('1', '2', '3', '4', '8', '16')) AND (INACTIVE = 0)
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

CREATE VIEW [dbo].[GP_CIMN_PAY_CODE_V]
AS
SELECT     *
FROM         CIMN.dbo.UPR40600
WHERE     (PAYRCORD IN ('1', '2', '3', '4', '8', '16')) AND (INACTIVE = 0)
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

CREATE VIEW [dbo].[Taxes_V_Sum]
AS
SELECT     TOP 100 PERCENT INVOICE_ID, SUM(line_tax) AS Total_tax
FROM         dbo.Taxes_V
WHERE     (TAXOPTNS = 1)
GROUP BY INVOICE_ID
ORDER BY INVOICE_ID
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

CREATE VIEW [dbo].[JOBS_V_jerry]
AS
SELECT     JOB_ID, PROJECT_ID, JOB_NO, JOB_NAME, DATE_CREATED
FROM         dbo.JOBS
WHERE     (DATE_CREATED > '12/31/2007')
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

CREATE VIEW [dbo].[JOB_SEARCH_V]
AS
SELECT     jobs_1.ORGANIZATION_ID, jobs_1.JOB_NO, jobs_1.JOB_ID, jobs_1.JOB_NAME, s.SERVICE_ID, s.SERVICE_NO, jobs_1.CUSTOMER_NAME, 
                      jobs_1.CUSTOMER_ID, jl.JOB_LOCATION_NAME, jobs_1.JOB_STATUS_TYPE_ID, jobs_1.JOB_TYPE_ID, jobs_1.DATE_CREATED, s.service_no_desc, 
                      s.serv_status_type_name
FROM         dbo.JOBS_V jobs_1 LEFT OUTER JOIN
                      dbo.SERVICES_V s ON jobs_1.JOB_ID = s.JOB_ID LEFT OUTER JOIN
                      dbo.JOB_LOCATIONS jl ON s.JOB_LOCATION_ID = jl.JOB_LOCATION_ID
GO

CREATE VIEW [dbo].[CUSTOMER_CONTACTS_V]
AS
SELECT     dbo.CONTACTS.*
FROM         dbo.CONTACTS LEFT OUTER JOIN
                      dbo.LOOKUPS ON dbo.CONTACTS.CONTACT_TYPE_ID = dbo.LOOKUPS.LOOKUP_ID
WHERE     (dbo.LOOKUPS.CODE = 'customer')
GO

CREATE VIEW [dbo].[VAR_JOB_QUOTED_V]
AS
SELECT     dbo.JOBS.JOB_ID, SUM(ISNULL(dbo.SERVICES.QUOTE_TOTAL, 0)) AS sum_quote
FROM         dbo.JOBS INNER JOIN
                      dbo.SERVICES ON dbo.JOBS.JOB_ID = dbo.SERVICES.JOB_ID
GROUP BY dbo.JOBS.JOB_ID
GO

CREATE VIEW [dbo].[DATE_OFFSETS_V]
AS
SELECT    cast( (cast(datepart(mm,getDATE()) as varchar(2))+'/'+cast(datepart(dd,getDATE()) as varchar(2))+'/'+cast(datepart(yyyy,getDATE()) as varchar(4))) as datetime) todays_date,
1 AS tomorrows_offset, - 1 AS yesterdays_offset, 6 - DATEPART(dw, GETDATE()) AS fridays_offset, 7 - DATEPART(dw, GETDATE()) AS saturdays_offset, 
                      (CASE (8 - DATEPART(dw, GETDATE())) WHEN 7 THEN 0 ELSE (8 - DATEPART(dw, GETDATE())) END) AS sundays_offset, 6 - DATEPART(dw, GETDATE()) 
                      - 7 AS last_fridays_offset, 7 - DATEPART(dw, GETDATE()) - 7 AS last_saturdays_offset, (CASE (8 - DATEPART(dw, GETDATE())) 
                      WHEN 7 THEN 0 ELSE (8 - DATEPART(dw, GETDATE())) END) - 7 AS last_sundays_offset,Datepart(wk, GETDATE() ) % 2 even_odd_week
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

CREATE VIEW [dbo].[crystal_UNBILLED_OPS_V2]
AS
SELECT     TOP 100 PERCENT billing_user_id, bill_job_no, bill_job_id, non_billable_total, billable_total, dealer_name, customer_name, 
                      max_est_end_date_varchar, billing_user_name, job_status_type_name, job_name, organization_id
FROM         dbo.BILL_JOBS_V
WHERE     (organization_id = 2) AND (job_status_type_name = 'invoiced')
GO

CREATE VIEW [dbo].[GP_ECMS_PAY_CODE_V]
AS
SELECT     *
FROM         ECMS.dbo.UPR40600
WHERE     (PAYRCORD IN ('1', '2', '3', '4', '8')) AND (INACTIVE = 0)
GO

CREATE  VIEW [dbo].[GP_MPLS_PAY_CODE_V]
AS
SELECT     *
FROM         AMBIM.dbo.UPR40600
WHERE     (PAYRCORD IN ('1', '2', '3', '4', '8', '16')) AND (INACTIVE = 0)
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

CREATE VIEW [dbo].[INVOICE_FORMAT_TYPES_V]
AS
SELECT     dbo.LOOKUPS.LOOKUP_ID, dbo.LOOKUPS.CODE AS invoice_type_code, dbo.LOOKUPS.NAME, dbo.LOOKUP_TYPES.CODE AS Lookup_type_code, 
                      dbo.LOOKUPS.SEQUENCE_NO
FROM         dbo.LOOKUP_TYPES INNER JOIN
                      dbo.LOOKUPS ON dbo.LOOKUP_TYPES.LOOKUP_TYPE_ID = dbo.LOOKUPS.LOOKUP_TYPE_ID
WHERE     (dbo.LOOKUP_TYPES.CODE = 'invoice_format_type') AND (dbo.LOOKUPS.ACTIVE_FLAG <> 'N') AND (dbo.LOOKUP_TYPES.ACTIVE_FLAG <> 'N')
GO

CREATE VIEW [dbo].[ROOT_CAUSES_V]
AS
SELECT     dbo.LOOKUPS.LOOKUP_ID AS root_cause_id, dbo.LOOKUPS.NAME, dbo.LOOKUPS.ATTRIBUTE1 AS cause_number
FROM         dbo.LOOKUP_TYPES INNER JOIN
                      dbo.LOOKUPS ON dbo.LOOKUP_TYPES.LOOKUP_TYPE_ID = dbo.LOOKUPS.LOOKUP_TYPE_ID
WHERE     (dbo.LOOKUP_TYPES.CODE = 'root_cause_types') AND (dbo.LOOKUPS.ACTIVE_FLAG <> 'N') AND (dbo.LOOKUP_TYPES.ACTIVE_FLAG <> 'N')
GO

CREATE VIEW [dbo].[SYS_TABLES_V]
AS
SELECT     id AS table_id, name AS table_name
FROM         dbo.sysobjects [Table]
WHERE     (xtype = 'U')
GO

CREATE VIEW [dbo].[INVOICE_LINE_TYPES_V]
AS
SELECT     dbo.LOOKUPS.LOOKUP_ID, dbo.LOOKUPS.CODE AS invoice_type_code, dbo.LOOKUPS.NAME, dbo.LOOKUP_TYPES.CODE AS Lookup_type_code, 
                      dbo.LOOKUPS.SEQUENCE_NO
FROM         dbo.LOOKUP_TYPES INNER JOIN
                      dbo.LOOKUPS ON dbo.LOOKUP_TYPES.LOOKUP_TYPE_ID = dbo.LOOKUPS.LOOKUP_TYPE_ID
WHERE     (dbo.LOOKUP_TYPES.CODE = 'invoice_line_type') AND (dbo.LOOKUPS.ACTIVE_FLAG <> 'N') AND (dbo.LOOKUP_TYPES.ACTIVE_FLAG <> 'N')
GO

CREATE VIEW [dbo].[INVOICE_TYPES_V]
AS
SELECT     dbo.LOOKUPS.LOOKUP_ID, dbo.LOOKUPS.CODE AS invoice_type_code, dbo.LOOKUPS.NAME, dbo.LOOKUP_TYPES.CODE AS Lookup_type_code, 
                      dbo.LOOKUPS.SEQUENCE_NO
FROM         dbo.LOOKUP_TYPES INNER JOIN
                      dbo.LOOKUPS ON dbo.LOOKUP_TYPES.LOOKUP_TYPE_ID = dbo.LOOKUPS.LOOKUP_TYPE_ID
WHERE     (dbo.LOOKUP_TYPES.CODE = 'invoice_type') AND (dbo.LOOKUPS.ACTIVE_FLAG <> 'N') AND (dbo.LOOKUP_TYPES.ACTIVE_FLAG <> 'N')
GO

CREATE VIEW [dbo].[YES_NO_NONE_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'yes_no_none_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO

CREATE VIEW [dbo].[SERV_REQ_STATUS_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'serv_req_status_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO

CREATE VIEW [dbo].[WALL_MOUNT_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'wall_mount_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
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

CREATE VIEW [dbo].[SERVICE_ACCOUNT_REPORT_NUMBERS]
AS
SELECT     JOB_ID, JOB_NO, JOB_NAME, JOB_NO_NAME, DESCRIPTION, req_po_no, JOB_TYPE_ID, job_type_code, job_type_name, JOB_STATUS_TYPE_ID, 
                      job_status_type_code, job_status_type_name, job_status_seq_no, CUSTOMER_ID, ORGANIZATION_ID, DEALER_NAME, EXT_DEALER_ID, 
                      CUSTOMER_NAME, job_location_name, EXT_CUSTOMER_ID, INVOICE_ID, Invoice_Desc, PO_NO, EST_START_DATE, SERVICE_LINE_DATE, 
                      invoice_status_id, invoice_status_code, invoice_status_name, SERVICE_ID, SERVICE_NO, TC_SERVICE_LINE_NO, RESOURCE_TYPE_ID, 
                      resource_type_code, resource_type_name, res_cat_type_id, res_cat_type_code, res_cat_type_name, ITEM_ID, item_name, ITEM_TYPE_ID, 
                      item_type_name, item_type_code, BILLABLE_FLAG, taxable_flag, bill_total, EXT_PAY_CODE, SL_BILLABLE_FLAG, hourly_rate, expense_rate, 
                      BILL_QTY, col1, col1_enabled, CUST_COL_1, col2, col2_enabled, CUST_COL_2, col3, col3_enabled, CUST_COL_3, col4, col4_enabled, CUST_COL_4, 
                      col5, col5_enabled, CUST_COL_5, col6, col6_enabled, CUST_COL_6, col7, col7_enabled, CUST_COL_7, col8, col8_enabled, CUST_COL_8, col9, 
                      col9_enabled, CUST_COL_9, col10, col10_enabled, CUST_COL_10, SUM(other_rate) AS other_rate, SUM(other_qty) AS other_qty, SUM(other_total) 
                      AS other_total, SUM(baggies_rate) AS baggies_rate, SUM(baggies_qty) AS baggies_qty, SUM(baggies_total) AS baggies_total, SUM(boxes_rate) 
                      AS boxes_rate, SUM(boxes_qty) AS boxes_qty, SUM(boxes_total) AS boxes_total, SUM(EquipRental_rate) AS EquipRental_rate, SUM(EquipRental_qty) 
                      AS EquipRental_qty, SUM(EquipRental_total) AS EquipRental_total, SUM(fasteners_rate) AS fasteners_rate, SUM(fasteners_qty) AS fasteners_qty, 
                      SUM(fasteners_total) AS fasteners_total, SUM(labels_rate) AS labels_rate, SUM(labels_qty) AS labels_qty, SUM(labels_total) AS labels_total, 
                      SUM(MileageInTown_rate) AS MileageInTown_rate, SUM(MileageInTown_qty) AS MileageInTown_qty, SUM(MileageInTown_total) 
                      AS MileageInTown_total, SUM(MiscHardware_rate) AS MiscHardware_rate, SUM(MiscHardware_qty) AS MiscHardware_qty, SUM(MiscHardware_total) 
                      AS MiscHardware_total, SUM(PieceCountIn_rate) AS PieceCountIn_rate, SUM(PieceCountIn_qty) AS PieceCountIn_qty, SUM(PieceCountIn_total) 
                      AS PieceCountIn_total, SUM(PieceCountOut_rate) AS PieceCountOut_rate, SUM(PieceCountOut_qty) AS PieceCountOut_qty, SUM(PieceCountOut_total) 
                      AS PieceCountOut_total, SUM(supplies_rate) AS supplies_rate, SUM(supplies_qty) AS supplies_qty, SUM(supplies_total) AS supplies_total, 
                      SUM(tape_rate) AS tape_rate, SUM(tape_qty) AS tape_qty, SUM(tape_total) AS tape_total, SUM(trash_rate) AS trash_rate, SUM(trash_qty) AS trash_qty, 
                      SUM(trash_total) AS trash_total, SUM(dollies_rate) AS dollies_rate, SUM(dollies_qty) AS dollies_qty, SUM(dollies_total) AS dollies_total, 
                      SUM(bookcarts_rate) AS bookcarts_rate, SUM(bookcarts_qty) AS bookcarts_qty, SUM(bookcarts_total) AS bookcarts_total, SUM(truck_rate) 
                      AS truck_rate, SUM(truck_qty) AS truck_qty, SUM(truck_total) AS truck_total, SUM(van_rate) AS van_rate, SUM(van_qty) AS van_qty, SUM(van_total) 
                      AS van_total, SUM(perdiem) AS perdiem, SUM(lodging) AS lodging, SUM(ac_reg_rate) AS ac_reg_rate, SUM(ac_reg_qty) AS ac_reg_qty, 
                      SUM(ac_reg_total) AS ac_reg_total, SUM(ac_ot_rate) AS ac_ot_rate, SUM(ac_ot_qty) AS ac_ot_qty, SUM(ac_ot_total) AS ac_ot_total, SUM(am_reg_rate) 
                      AS am_reg_rate, SUM(am_reg_qty) AS am_reg_qty, SUM(am_reg_total) AS am_reg_total, SUM(am_ot_rate) AS am_ot_rate, SUM(am_ot_qty) 
                      AS am_ot_qty, SUM(am_ot_total) AS am_ot_total, SUM(am_spec_reg_rate) AS am_spec_reg_rate, SUM(am_spec_reg_qty) AS am_spec_reg_qty, 
                      SUM(am_spec_reg_total) AS am_spec_reg_total, SUM(am_spec_ot_rate) AS am_spec_ot_rate, SUM(am_spec_ot_qty) AS am_spec_ot_qty, 
                      SUM(am_spec_ot_total) AS am_spec_ot_total, SUM(AssetHdlr_reg_rate) AS AssetHdlr_reg_rate, SUM(AssetHdlr_reg_qty) AS AssetHdlr_reg_qty, 
                      SUM(AssetHdlr_reg_total) AS AssetHdlr_reg_total, SUM(AssetHdlr_ot_rate) AS AssetHdlr_ot_rate, SUM(AssetHdlr_ot_qty) AS AssetHdlr_ot_qty, 
                      SUM(AssetHdlr_ot_total) AS AssetHdlr_ot_total, SUM(campfurnmgr_reg_rate) AS campfurnmgr_reg_rate, SUM(campfurnmgr_reg_qty) 
                      AS campfurnmgr_reg_qty, SUM(campfurnmgr_reg_total) AS campfurnmgr_reg_total, SUM(campfurnmgr_ot_rate) AS campfurnmgr_ot_rate, 
                      SUM(campfurnmgr_ot_qty) AS campfurnmgr_ot_qty, SUM(campfurnmgr_ot_total) AS campfurnmgr_ot_total, SUM(custom_reg_rate) AS custom_reg_rate, 
                      SUM(custom_reg_qty) AS custom_reg_qty, SUM(custom_reg_total) AS custom_reg_total, SUM(custom_ot_rate) AS custom_ot_rate, 
                      SUM(custom_ot_qty) AS custom_ot_qty, SUM(custom_ot_total) AS custom_ot_total, SUM(delivery_reg_rate) AS delivery_reg_rate, 
                      SUM(delivery_reg_qty) AS delivery_reg_qty, SUM(delivery_reg_total) AS delivery_reg_total, SUM(delivery_ot_rate) AS delivery_ot_rate, 
                      SUM(delivery_ot_qty) AS delivery_ot_qty, SUM(delivery_ot_total) AS delivery_ot_total, SUM(driver_reg_rate) AS Driver_reg_rate, SUM(driver_reg_qty) 
                      AS Driver_reg_qty, SUM(driver_reg_total) AS Driver_reg_total, SUM(driver_ot_rate) AS Driver_ot_rate, SUM(driver_ot_qty) AS Driver_ot_qty, 
                      SUM(driver_ot_total) AS Driver_ot_total, SUM(Foreman_reg_rate) AS Foreman_reg_rate, SUM(Foreman_reg_qty) AS Foreman_reg_qty, 
                      SUM(Foreman_reg_total) AS Foreman_reg_total, SUM(Foreman_ot_rate) AS Foreman_ot_rate, SUM(Foreman_ot_qty) AS Foreman_ot_qty, 
                      SUM(Foreman_ot_total) AS Foreman_ot_total, SUM(GenLabor_reg_rate) AS GenLabor_reg_rate, SUM(GenLabor_reg_qty) AS GenLabor_reg_qty, 
                      SUM(GenLabor_reg_total) AS GenLabor_reg_total, SUM(GenLabor_ot_rate) AS GenLabor_ot_rate, SUM(GenLabor_ot_qty) AS GenLabor_ot_qty, 
                      SUM(GenLabor_ot_total) AS GenLabor_ot_total, SUM(installer_reg_rate) AS installer_reg_rate, SUM(installer_reg_qty) AS installer_reg_qty, 
                      SUM(installer_reg_total) AS installer_reg_total, SUM(installer_ot_rate) AS installer_ot_rate, SUM(installer_ot_qty) AS installer_ot_qty, 
                      SUM(installer_ot_total) AS installer_ot_total, SUM(lead_reg_rate) AS lead_reg_rate, SUM(lead_reg_qty) AS lead_reg_qty, SUM(lead_reg_total) 
                      AS lead_reg_total, SUM(lead_ot_rate) AS lead_ot_rate, SUM(lead_ot_qty) AS lead_ot_qty, SUM(lead_ot_total) AS lead_ot_total, SUM(mac_reg_rate) 
                      AS mac_reg_rate, SUM(mac_reg_qty) AS mac_reg_qty, SUM(mac_reg_total) AS mac_reg_total, SUM(mac_ot_rate) AS mac_ot_rate, SUM(mac_ot_qty) 
                      AS mac_ot_qty, SUM(mac_ot_total) AS mac_ot_total, SUM(mps_reg_rate) AS mps_reg_rate, SUM(mps_reg_qty) AS mps_reg_qty, SUM(mps_reg_total) 
                      AS mps_reg_total, SUM(mps_ot_rate) AS mps_ot_rate, SUM(mps_ot_qty) AS mps_ot_qty, SUM(mps_ot_total) AS mps_ot_total, 
                      SUM(Mover_Reg_Hrs_rate) AS mover_reg_hrs_rate, SUM(Mover_Reg_Hrs_qty) AS mover_reg_hrs_qty, SUM(Mover_Reg_Hrs_total) 
                      AS mover_reg_hrs_total, SUM(Mover_OT_Hrs_rate) AS mover_ot_hrs_rate, SUM(Mover_OT_Hrs_qty) AS mover_ot_hrs_qty, SUM(Mover_OT_Hrs_total) 
                      AS mover_ot_hrs_total, SUM(pc_fab_reg_rate) AS pc_fab_reg_rate, SUM(pc_fab_reg_qty) AS pc_fab_reg_qty, SUM(pc_fab_reg_total) 
                      AS pc_fab_reg_total, SUM(pc_fab_ot_rate) AS pc_fab_ot_rate, SUM(pc_fab_ot_qty) AS pc_fab_ot_qty, SUM(pc_fab_ot_total) AS pc_fab_ot_total, 
                      SUM(pc_coord_reg_rate) AS pc_coord_reg_rate, SUM(pc_coord_reg_qty) AS pc_coord_reg_qty, SUM(pc_coord_reg_total) AS pc_coord_reg_total, 
                      SUM(pc_coord_ot_rate) AS pc_coord_ot_rate, SUM(pc_coord_ot_qty) AS pc_coord_ot_qty, SUM(pc_coord_ot_total) AS pc_coord_ot_total, 
                      SUM(pc_mover_reg_rate) AS pc_mover_reg_rate, SUM(pc_mover_reg_qty) AS pc_mover_reg_qty, SUM(pc_mover_reg_total) AS pc_mover_reg_total, 
                      SUM(pc_mover_ot_rate) AS pc_mover_ot_rate, SUM(pc_mover_ot_qty) AS pc_mover_ot_qty, SUM(pc_mover_ot_total) AS pc_mover_ot_total, 
                      SUM(ProjMgr_reg_rate) AS ProjMgr_reg_rate, SUM(ProjMgr_reg_qty) AS ProjMgr_reg_qty, SUM(ProjMgr_reg_total) AS ProjMgr_reg_total, 
                      SUM(ProjMgr_ot_rate) AS ProjMgr_ot_rate, SUM(ProjMgr_ot_qty) AS ProjMgr_ot_qty, SUM(ProjMgr_ot_total) AS ProjMgr_ot_total, SUM(ps_reg_rate) 
                      AS ps_reg_rate, SUM(ps_reg_qty) AS ps_reg_qty, SUM(ps_reg_total) AS ps_reg_total, SUM(ps_ot_rate) AS ps_ot_rate, SUM(ps_ot_qty) AS ps_ot_qty, 
                      SUM(ps_ot_total) AS ps_ot_total, SUM(regProjMgr_reg_rate) AS regProjMgr_reg_rate, SUM(regProjMgr_reg_qty) AS regProjMgr_reg_qty, 
                      SUM(regProjMgr_reg_total) AS regProjMgr_reg_total, SUM(regProjMgr_ot_rate) AS regProjMgr_ot_rate, SUM(regProjMgr_ot_qty) AS regProjMgr_ot_qty, 
                      SUM(regProjMgr_ot_total) AS regProjMgr_ot_total, SUM(sub_reg_rate) AS sub_reg_rate, SUM(sub_reg_qty) AS sub_reg_qty, SUM(sub_reg_total) 
                      AS sub_reg_total, SUM(sub_ot_rate) AS sub_ot_rate, SUM(sub_ot_qty) AS sub_ot_qty, SUM(sub_ot_total) AS sub_ot_total, SUM(sub_exp_rate) 
                      AS sub_exp_rate, SUM(sub_exp_qty) AS sub_exp_qty, SUM(sub_exp_total) AS sub_exp_total, SUM(whse_reg_rate) AS whse_reg_rate, 
                      SUM(whse_reg_qty) AS whse_reg_qty, SUM(whse_reg_total) AS whse_reg_total, SUM(whse_ot_rate) AS whse_ot_rate, SUM(whse_ot_qty) 
                      AS whse_ot_qty, SUM(whse_ot_total) AS whse_ot_total, SUM(WhseSup_reg_rate) AS WhseSup_reg_rate, SUM(WhseSup_reg_qty) 
                      AS WhseSup_reg_qty, SUM(WhseSup_reg_total) AS WhseSup_reg_total, SUM(WhseSup_ot_rate) AS WhseSup_ot_rate, SUM(WhseSup_ot_qty) 
                      AS WhseSup_ot_qty, SUM(WhseSup_ot_total) AS WhseSup_ot_total, SUM(xerox_reg_rate) AS xerox_reg_rate, SUM(xerox_reg_qty) AS xerox_reg_qty, 
                      SUM(xerox_reg_total) AS xerox_reg_total, SUM(xerox_ot_rate) AS xerox_ot_rate, SUM(xerox_ot_qty) AS xerox_ot_qty, SUM(xerox_ot_total) 
                      AS xerox_ot_total
FROM         dbo.SERVICE_ACCOUNT_REPORT_V
GROUP BY JOB_ID, JOB_NO, JOB_NAME, JOB_NO_NAME, DESCRIPTION, req_po_no, JOB_TYPE_ID, job_type_code, job_type_name, JOB_STATUS_TYPE_ID, 
                      job_status_type_code, job_status_type_name, job_status_seq_no, CUSTOMER_ID, ORGANIZATION_ID, DEALER_NAME, EXT_DEALER_ID, 
                      CUSTOMER_NAME, EXT_CUSTOMER_ID, INVOICE_ID, PO_NO, invoice_status_id, invoice_status_code, invoice_status_name, SERVICE_ID, 
                      SERVICE_NO, TC_SERVICE_LINE_NO, RESOURCE_TYPE_ID, resource_type_code, resource_type_name, res_cat_type_id, res_cat_type_code, 
                      res_cat_type_name, ITEM_ID, item_name, ITEM_TYPE_ID, item_type_name, item_type_code, BILLABLE_FLAG, EXT_PAY_CODE, SL_BILLABLE_FLAG, 
                      taxable_flag, bill_total, hourly_rate, expense_rate, BILL_QTY, col1, col1_enabled, CUST_COL_1, col2, col2_enabled, CUST_COL_2, col3, col3_enabled,
                       CUST_COL_3, col4, col4_enabled, CUST_COL_4, col5, col5_enabled, CUST_COL_5, col6, col6_enabled, CUST_COL_6, col7, col7_enabled, 
                      CUST_COL_7, col8, col8_enabled, CUST_COL_8, col9, col9_enabled, CUST_COL_9, col10, col10_enabled, CUST_COL_10, Invoice_Desc, 
                      EST_START_DATE, SERVICE_LINE_DATE, job_location_name
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

CREATE VIEW [dbo].[GP_NTLSV_PAY_CODE_V]
AS
SELECT     *
FROM         NTLSV.dbo.UPR40600
WHERE     (PAYRCORD IN ('1', '2', '3', '4', '8', '16')) AND (INACTIVE = 0)
GO

CREATE VIEW [dbo].[SERVICE_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'service_type ') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO

CREATE VIEW [dbo].[YES_NO_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'yes_no_type') AND (type_active_flag = 'Y') AND (lookup_active_flag = 'Y')
GO

CREATE view [dbo].[CRYSTAL_CUSTOMER_INVOICE_INTERCOMPANY]
as
SELECT     'AMBIM' AS COMPANY, AMBIM.dbo.SOP30200.SOPTYPE, AMBIM.dbo.SOP30200.SOPNUMBE, AMBIM.dbo.RM00101.CUSTNMBR, AMBIM.dbo.RM00101.CUSTNAME, AMBIM.dbo.RM00101.CUSTCLAS, 
                      AMBIM.dbo.SOP30200.DOCID, AMBIM.dbo.SOP30200.DOCDATE, AMBIM.dbo.SOP30200.GLPOSTDT, AMBIM.dbo.SOP30200.ORIGTYPE, AMBIM.dbo.SOP30200.ORIGNUMB, AMBIM.dbo.SOP30200.CSTPONBR, 
                      case AMBIM.dbo.SOP30200.SOPTYPE WHEN 3 THEN AMBIM.dbo.SOP30200.DOCAMNT WHEN 4 THEN AMBIM.dbo.SOP30200.DOCAMNT * -1 END DOCAMNT
FROM         AMBIM.dbo.SOP30200 LEFT OUTER JOIN
                      AMBIM.dbo.RM00101 ON AMBIM.dbo.SOP30200.CUSTNMBR = AMBIM.dbo.RM00101.CUSTNMBR
GROUP BY AMBIM.dbo.SOP30200.SOPTYPE, AMBIM.dbo.SOP30200.SOPNUMBE, AMBIM.dbo.RM00101.CUSTNMBR, AMBIM.dbo.RM00101.CUSTNAME, AMBIM.dbo.RM00101.CUSTCLAS, AMBIM.dbo.SOP30200.DOCID, 
         AMBIM.dbo.SOP30200.DOCDATE, AMBIM.dbo.SOP30200.GLPOSTDT, AMBIM.dbo.SOP30200.ORIGTYPE, AMBIM.dbo.SOP30200.ORIGNUMB, AMBIM.dbo.SOP30200.CSTPONBR, AMBIM.dbo.SOP30200.DOCAMNT,
     AMBIM.dbo.SOP30200.VOIDSTTS
HAVING      (AMBIM.dbo.SOP30200.SOPTYPE IN (3,4)) and AMBIM.dbo.SOP30200.VOIDSTTS in (0)
union
SELECT     'AIA' AS COMPANY, AIA.dbo.SOP30200.SOPTYPE, AIA.dbo.SOP30200.SOPNUMBE, AIA.dbo.RM00101.CUSTNMBR, AIA.dbo.RM00101.CUSTNAME, AIA.dbo.RM00101.CUSTCLAS, 
                      AIA.dbo.SOP30200.DOCID, AIA.dbo.SOP30200.DOCDATE, AIA.dbo.SOP30200.GLPOSTDT, AIA.dbo.SOP30200.ORIGTYPE, AIA.dbo.SOP30200.ORIGNUMB, AIA.dbo.SOP30200.CSTPONBR, 
                      case AIA.dbo.SOP30200.SOPTYPE WHEN 3 THEN AIA.dbo.SOP30200.DOCAMNT WHEN 4 THEN AIA.dbo.SOP30200.DOCAMNT * -1 END DOCAMNT
FROM         AIA.dbo.SOP30200 LEFT OUTER JOIN
                      AIA.dbo.RM00101 ON AIA.dbo.SOP30200.CUSTNMBR = AIA.dbo.RM00101.CUSTNMBR
GROUP BY AIA.dbo.SOP30200.SOPTYPE, AIA.dbo.SOP30200.SOPNUMBE, AIA.dbo.RM00101.CUSTNMBR, AIA.dbo.RM00101.CUSTNAME, AIA.dbo.RM00101.CUSTCLAS, AIA.dbo.SOP30200.DOCID, 
         AIA.dbo.SOP30200.DOCDATE, AIA.dbo.SOP30200.GLPOSTDT, AIA.dbo.SOP30200.ORIGTYPE, AIA.dbo.SOP30200.ORIGNUMB, AIA.dbo.SOP30200.CSTPONBR, AIA.dbo.SOP30200.DOCAMNT,
     AIA.dbo.SOP30200.VOIDSTTS
HAVING      (AIA.dbo.SOP30200.SOPTYPE IN (3,4)) and AIA.dbo.SOP30200.VOIDSTTS in (0)
union
SELECT     'AMCOR' AS COMPANY, AMCOR.dbo.SOP30200.SOPTYPE, AMCOR.dbo.SOP30200.SOPNUMBE, AMCOR.dbo.RM00101.CUSTNMBR, AMCOR.dbo.RM00101.CUSTNAME, AMCOR.dbo.RM00101.CUSTCLAS, 
                      AMCOR.dbo.SOP30200.DOCID, AMCOR.dbo.SOP30200.DOCDATE, AMCOR.dbo.SOP30200.GLPOSTDT, AMCOR.dbo.SOP30200.ORIGTYPE, AMCOR.dbo.SOP30200.ORIGNUMB, AMCOR.dbo.SOP30200.CSTPONBR, 
                      case AMCOR.dbo.SOP30200.SOPTYPE WHEN 3 THEN AMCOR.dbo.SOP30200.DOCAMNT WHEN 4 THEN AMCOR.dbo.SOP30200.DOCAMNT * -1 END DOCAMNT
FROM         AMCOR.dbo.SOP30200 LEFT OUTER JOIN
                      AMCOR.dbo.RM00101 ON AMCOR.dbo.SOP30200.CUSTNMBR = AMCOR.dbo.RM00101.CUSTNMBR
GROUP BY AMCOR.dbo.SOP30200.SOPTYPE, AMCOR.dbo.SOP30200.SOPNUMBE, AMCOR.dbo.RM00101.CUSTNMBR, AMCOR.dbo.RM00101.CUSTNAME, AMCOR.dbo.RM00101.CUSTCLAS, AMCOR.dbo.SOP30200.DOCID, 
         AMCOR.dbo.SOP30200.DOCDATE, AMCOR.dbo.SOP30200.GLPOSTDT, AMCOR.dbo.SOP30200.ORIGTYPE, AMCOR.dbo.SOP30200.ORIGNUMB, AMCOR.dbo.SOP30200.CSTPONBR, AMCOR.dbo.SOP30200.DOCAMNT,
     AMCOR.dbo.SOP30200.VOIDSTTS
HAVING      (AMCOR.dbo.SOP30200.SOPTYPE IN (3,4)) and AMCOR.dbo.SOP30200.VOIDSTTS in (0)
UNION
SELECT     'AMMAD' AS COMPANY, AMMAD.dbo.SOP30200.SOPTYPE, AMMAD.dbo.SOP30200.SOPNUMBE, AMMAD.dbo.RM00101.CUSTNMBR, AMMAD.dbo.RM00101.CUSTNAME, AMMAD.dbo.RM00101.CUSTCLAS, 
                      AMMAD.dbo.SOP30200.DOCID, AMMAD.dbo.SOP30200.DOCDATE, AMMAD.dbo.SOP30200.GLPOSTDT, AMMAD.dbo.SOP30200.ORIGTYPE, AMMAD.dbo.SOP30200.ORIGNUMB, AMMAD.dbo.SOP30200.CSTPONBR, 
                      case AMMAD.dbo.SOP30200.SOPTYPE WHEN 3 THEN AMMAD.dbo.SOP30200.DOCAMNT WHEN 4 THEN AMMAD.dbo.SOP30200.DOCAMNT * -1 END DOCAMNT
FROM         AMMAD.dbo.SOP30200 LEFT OUTER JOIN
                      AMMAD.dbo.RM00101 ON AMMAD.dbo.SOP30200.CUSTNMBR = AMMAD.dbo.RM00101.CUSTNMBR
GROUP BY AMMAD.dbo.SOP30200.SOPTYPE, AMMAD.dbo.SOP30200.SOPNUMBE, AMMAD.dbo.RM00101.CUSTNMBR, AMMAD.dbo.RM00101.CUSTNAME, AMMAD.dbo.RM00101.CUSTCLAS, AMMAD.dbo.SOP30200.DOCID, 
         AMMAD.dbo.SOP30200.DOCDATE, AMMAD.dbo.SOP30200.GLPOSTDT, AMMAD.dbo.SOP30200.ORIGTYPE, AMMAD.dbo.SOP30200.ORIGNUMB, AMMAD.dbo.SOP30200.CSTPONBR, AMMAD.dbo.SOP30200.DOCAMNT,
     AMMAD.dbo.SOP30200.VOIDSTTS
HAVING      (AMMAD.dbo.SOP30200.SOPTYPE IN (3,4)) and AMMAD.dbo.SOP30200.VOIDSTTS in (0)
UNION
SELECT     'CIINC' AS COMPANY, CIINC.dbo.SOP30200.SOPTYPE, CIINC.dbo.SOP30200.SOPNUMBE, CIINC.dbo.RM00101.CUSTNMBR, CIINC.dbo.RM00101.CUSTNAME, CIINC.dbo.RM00101.CUSTCLAS, 
                      CIINC.dbo.SOP30200.DOCID, CIINC.dbo.SOP30200.DOCDATE, CIINC.dbo.SOP30200.GLPOSTDT, CIINC.dbo.SOP30200.ORIGTYPE, CIINC.dbo.SOP30200.ORIGNUMB, CIINC.dbo.SOP30200.CSTPONBR, 
                      case CIINC.dbo.SOP30200.SOPTYPE WHEN 3 THEN CIINC.dbo.SOP30200.DOCAMNT WHEN 4 THEN CIINC.dbo.SOP30200.DOCAMNT * -1 END DOCAMNT
FROM         CIINC.dbo.SOP30200 LEFT OUTER JOIN
                      CIINC.dbo.RM00101 ON CIINC.dbo.SOP30200.CUSTNMBR = CIINC.dbo.RM00101.CUSTNMBR
GROUP BY CIINC.dbo.SOP30200.SOPTYPE, CIINC.dbo.SOP30200.SOPNUMBE, CIINC.dbo.RM00101.CUSTNMBR, CIINC.dbo.RM00101.CUSTNAME, CIINC.dbo.RM00101.CUSTCLAS, CIINC.dbo.SOP30200.DOCID, 
         CIINC.dbo.SOP30200.DOCDATE, CIINC.dbo.SOP30200.GLPOSTDT, CIINC.dbo.SOP30200.ORIGTYPE, CIINC.dbo.SOP30200.ORIGNUMB, CIINC.dbo.SOP30200.CSTPONBR, CIINC.dbo.SOP30200.DOCAMNT,
     CIINC.dbo.SOP30200.VOIDSTTS
HAVING      (CIINC.dbo.SOP30200.SOPTYPE IN (3,4)) and CIINC.dbo.SOP30200.VOIDSTTS in (0)
UNION
SELECT     'CILLC' AS COMPANY, CILLC.dbo.SOP30200.SOPTYPE, CILLC.dbo.SOP30200.SOPNUMBE, CILLC.dbo.RM00101.CUSTNMBR, CILLC.dbo.RM00101.CUSTNAME, CILLC.dbo.RM00101.CUSTCLAS, 
                      CILLC.dbo.SOP30200.DOCID, CILLC.dbo.SOP30200.DOCDATE, CILLC.dbo.SOP30200.GLPOSTDT, CILLC.dbo.SOP30200.ORIGTYPE, CILLC.dbo.SOP30200.ORIGNUMB, CILLC.dbo.SOP30200.CSTPONBR, 
                      case CILLC.dbo.SOP30200.SOPTYPE WHEN 3 THEN CILLC.dbo.SOP30200.DOCAMNT WHEN 4 THEN CILLC.dbo.SOP30200.DOCAMNT * -1 END DOCAMNT
FROM         CILLC.dbo.SOP30200 LEFT OUTER JOIN
                      CILLC.dbo.RM00101 ON CILLC.dbo.SOP30200.CUSTNMBR = CILLC.dbo.RM00101.CUSTNMBR
GROUP BY CILLC.dbo.SOP30200.SOPTYPE, CILLC.dbo.SOP30200.SOPNUMBE, CILLC.dbo.RM00101.CUSTNMBR, CILLC.dbo.RM00101.CUSTNAME, CILLC.dbo.RM00101.CUSTCLAS, CILLC.dbo.SOP30200.DOCID, 
         CILLC.dbo.SOP30200.DOCDATE, CILLC.dbo.SOP30200.GLPOSTDT, CILLC.dbo.SOP30200.ORIGTYPE, CILLC.dbo.SOP30200.ORIGNUMB, CILLC.dbo.SOP30200.CSTPONBR, CILLC.dbo.SOP30200.DOCAMNT,
     CILLC.dbo.SOP30200.VOIDSTTS
HAVING      (CILLC.dbo.SOP30200.SOPTYPE IN (3,4)) and CILLC.dbo.SOP30200.VOIDSTTS in (0)
UNION
SELECT     'CIMN' AS COMPANY, CIMN.dbo.SOP30200.SOPTYPE, CIMN.dbo.SOP30200.SOPNUMBE, CIMN.dbo.RM00101.CUSTNMBR, CIMN.dbo.RM00101.CUSTNAME, CIMN.dbo.RM00101.CUSTCLAS, 
                      CIMN.dbo.SOP30200.DOCID, CIMN.dbo.SOP30200.DOCDATE, CIMN.dbo.SOP30200.GLPOSTDT, CIMN.dbo.SOP30200.ORIGTYPE, CIMN.dbo.SOP30200.ORIGNUMB, CIMN.dbo.SOP30200.CSTPONBR, 
                      case CIMN.dbo.SOP30200.SOPTYPE WHEN 3 THEN CIMN.dbo.SOP30200.DOCAMNT WHEN 4 THEN CIMN.dbo.SOP30200.DOCAMNT * -1 END DOCAMNT
FROM         CIMN.dbo.SOP30200 LEFT OUTER JOIN
                      CIMN.dbo.RM00101 ON CIMN.dbo.SOP30200.CUSTNMBR = CIMN.dbo.RM00101.CUSTNMBR
GROUP BY CIMN.dbo.SOP30200.SOPTYPE, CIMN.dbo.SOP30200.SOPNUMBE, CIMN.dbo.RM00101.CUSTNMBR, CIMN.dbo.RM00101.CUSTNAME, CIMN.dbo.RM00101.CUSTCLAS, CIMN.dbo.SOP30200.DOCID, 
         CIMN.dbo.SOP30200.DOCDATE, CIMN.dbo.SOP30200.GLPOSTDT, CIMN.dbo.SOP30200.ORIGTYPE, CIMN.dbo.SOP30200.ORIGNUMB, CIMN.dbo.SOP30200.CSTPONBR, CIMN.dbo.SOP30200.DOCAMNT,
     CIMN.dbo.SOP30200.VOIDSTTS
HAVING      (CIMN.dbo.SOP30200.SOPTYPE IN (3,4)) and CIMN.dbo.SOP30200.VOIDSTTS in (0)
UNION
SELECT     'ECMS' AS COMPANY, ECMS.dbo.SOP30200.SOPTYPE, ECMS.dbo.SOP30200.SOPNUMBE, ECMS.dbo.RM00101.CUSTNMBR, ECMS.dbo.RM00101.CUSTNAME, ECMS.dbo.RM00101.CUSTCLAS, 
                      ECMS.dbo.SOP30200.DOCID, ECMS.dbo.SOP30200.DOCDATE, ECMS.dbo.SOP30200.GLPOSTDT, ECMS.dbo.SOP30200.ORIGTYPE, ECMS.dbo.SOP30200.ORIGNUMB, ECMS.dbo.SOP30200.CSTPONBR, 
                      case ECMS.dbo.SOP30200.SOPTYPE WHEN 3 THEN ECMS.dbo.SOP30200.DOCAMNT WHEN 4 THEN ECMS.dbo.SOP30200.DOCAMNT * -1 END DOCAMNT
FROM         ECMS.dbo.SOP30200 LEFT OUTER JOIN
                      ECMS.dbo.RM00101 ON ECMS.dbo.SOP30200.CUSTNMBR = ECMS.dbo.RM00101.CUSTNMBR
GROUP BY ECMS.dbo.SOP30200.SOPTYPE, ECMS.dbo.SOP30200.SOPNUMBE, ECMS.dbo.RM00101.CUSTNMBR, ECMS.dbo.RM00101.CUSTNAME, ECMS.dbo.RM00101.CUSTCLAS, ECMS.dbo.SOP30200.DOCID, 
         ECMS.dbo.SOP30200.DOCDATE, ECMS.dbo.SOP30200.GLPOSTDT, ECMS.dbo.SOP30200.ORIGTYPE, ECMS.dbo.SOP30200.ORIGNUMB, ECMS.dbo.SOP30200.CSTPONBR, ECMS.dbo.SOP30200.DOCAMNT,
     ECMS.dbo.SOP30200.VOIDSTTS
HAVING      (ECMS.dbo.SOP30200.SOPTYPE IN (3,4)) and ECMS.dbo.SOP30200.VOIDSTTS in (0)
UNION
SELECT     'ICS' AS COMPANY, ICS.dbo.SOP30200.SOPTYPE, ICS.dbo.SOP30200.SOPNUMBE, ICS.dbo.RM00101.CUSTNMBR, ICS.dbo.RM00101.CUSTNAME, ICS.dbo.RM00101.CUSTCLAS, 
                      ICS.dbo.SOP30200.DOCID, ICS.dbo.SOP30200.DOCDATE, ICS.dbo.SOP30200.GLPOSTDT, ICS.dbo.SOP30200.ORIGTYPE, ICS.dbo.SOP30200.ORIGNUMB, ICS.dbo.SOP30200.CSTPONBR, 
                      case ICS.dbo.SOP30200.SOPTYPE WHEN 3 THEN ICS.dbo.SOP30200.DOCAMNT WHEN 4 THEN ICS.dbo.SOP30200.DOCAMNT * -1 END DOCAMNT
FROM         ICS.dbo.SOP30200 LEFT OUTER JOIN
                      ICS.dbo.RM00101 ON ICS.dbo.SOP30200.CUSTNMBR = ICS.dbo.RM00101.CUSTNMBR
GROUP BY ICS.dbo.SOP30200.SOPTYPE, ICS.dbo.SOP30200.SOPNUMBE, ICS.dbo.RM00101.CUSTNMBR, ICS.dbo.RM00101.CUSTNAME, ICS.dbo.RM00101.CUSTCLAS, ICS.dbo.SOP30200.DOCID, 
         ICS.dbo.SOP30200.DOCDATE, ICS.dbo.SOP30200.GLPOSTDT, ICS.dbo.SOP30200.ORIGTYPE, ICS.dbo.SOP30200.ORIGNUMB, ICS.dbo.SOP30200.CSTPONBR, ICS.dbo.SOP30200.DOCAMNT,
     ICS.dbo.SOP30200.VOIDSTTS
HAVING      (ICS.dbo.SOP30200.SOPTYPE IN (3,4)) and ICS.dbo.SOP30200.VOIDSTTS in (0)
UNION
SELECT     'INTRA' AS COMPANY, INTRA.dbo.SOP30200.SOPTYPE, INTRA.dbo.SOP30200.SOPNUMBE, INTRA.dbo.RM00101.CUSTNMBR, INTRA.dbo.RM00101.CUSTNAME, INTRA.dbo.RM00101.CUSTCLAS, 
                      INTRA.dbo.SOP30200.DOCID, INTRA.dbo.SOP30200.DOCDATE, INTRA.dbo.SOP30200.GLPOSTDT, INTRA.dbo.SOP30200.ORIGTYPE, INTRA.dbo.SOP30200.ORIGNUMB, INTRA.dbo.SOP30200.CSTPONBR, 
                      case INTRA.dbo.SOP30200.SOPTYPE WHEN 3 THEN INTRA.dbo.SOP30200.DOCAMNT WHEN 4 THEN INTRA.dbo.SOP30200.DOCAMNT * -1 END DOCAMNT
FROM         INTRA.dbo.SOP30200 LEFT OUTER JOIN
                      INTRA.dbo.RM00101 ON INTRA.dbo.SOP30200.CUSTNMBR = INTRA.dbo.RM00101.CUSTNMBR
GROUP BY INTRA.dbo.SOP30200.SOPTYPE, INTRA.dbo.SOP30200.SOPNUMBE, INTRA.dbo.RM00101.CUSTNMBR, INTRA.dbo.RM00101.CUSTNAME, INTRA.dbo.RM00101.CUSTCLAS, INTRA.dbo.SOP30200.DOCID, 
         INTRA.dbo.SOP30200.DOCDATE, INTRA.dbo.SOP30200.GLPOSTDT, INTRA.dbo.SOP30200.ORIGTYPE, INTRA.dbo.SOP30200.ORIGNUMB, INTRA.dbo.SOP30200.CSTPONBR, INTRA.dbo.SOP30200.DOCAMNT,
     INTRA.dbo.SOP30200.VOIDSTTS
HAVING      (INTRA.dbo.SOP30200.SOPTYPE IN (3,4)) and INTRA.dbo.SOP30200.VOIDSTTS in (0)
UNION
SELECT     'IT' AS COMPANY, IT.dbo.SOP30200.SOPTYPE, IT.dbo.SOP30200.SOPNUMBE, IT.dbo.RM00101.CUSTNMBR, IT.dbo.RM00101.CUSTNAME, IT.dbo.RM00101.CUSTCLAS, 
                      IT.dbo.SOP30200.DOCID, IT.dbo.SOP30200.DOCDATE, IT.dbo.SOP30200.GLPOSTDT, IT.dbo.SOP30200.ORIGTYPE, IT.dbo.SOP30200.ORIGNUMB, IT.dbo.SOP30200.CSTPONBR, 
                      case IT.dbo.SOP30200.SOPTYPE WHEN 3 THEN IT.dbo.SOP30200.DOCAMNT WHEN 4 THEN IT.dbo.SOP30200.DOCAMNT * -1 END DOCAMNT
FROM         IT.dbo.SOP30200 LEFT OUTER JOIN
                      IT.dbo.RM00101 ON IT.dbo.SOP30200.CUSTNMBR = IT.dbo.RM00101.CUSTNMBR
GROUP BY IT.dbo.SOP30200.SOPTYPE, IT.dbo.SOP30200.SOPNUMBE, IT.dbo.RM00101.CUSTNMBR, IT.dbo.RM00101.CUSTNAME, IT.dbo.RM00101.CUSTCLAS, IT.dbo.SOP30200.DOCID, 
         IT.dbo.SOP30200.DOCDATE, IT.dbo.SOP30200.GLPOSTDT, IT.dbo.SOP30200.ORIGTYPE, IT.dbo.SOP30200.ORIGNUMB, IT.dbo.SOP30200.CSTPONBR, IT.dbo.SOP30200.DOCAMNT,
     IT.dbo.SOP30200.VOIDSTTS
HAVING      (IT.dbo.SOP30200.SOPTYPE IN (3,4)) and IT.dbo.SOP30200.VOIDSTTS in (0)
UNION
SELECT     'OMNI' AS COMPANY, OMNI.dbo.SOP30200.SOPTYPE, OMNI.dbo.SOP30200.SOPNUMBE, OMNI.dbo.RM00101.CUSTNMBR, OMNI.dbo.RM00101.CUSTNAME, OMNI.dbo.RM00101.CUSTCLAS, 
                      OMNI.dbo.SOP30200.DOCID, OMNI.dbo.SOP30200.DOCDATE, OMNI.dbo.SOP30200.GLPOSTDT, OMNI.dbo.SOP30200.ORIGTYPE, OMNI.dbo.SOP30200.ORIGNUMB, OMNI.dbo.SOP30200.CSTPONBR, 
                      case OMNI.dbo.SOP30200.SOPTYPE WHEN 3 THEN OMNI.dbo.SOP30200.DOCAMNT WHEN 4 THEN OMNI.dbo.SOP30200.DOCAMNT * -1 END DOCAMNT
FROM         OMNI.dbo.SOP30200 LEFT OUTER JOIN
                      OMNI.dbo.RM00101 ON OMNI.dbo.SOP30200.CUSTNMBR = OMNI.dbo.RM00101.CUSTNMBR
GROUP BY OMNI.dbo.SOP30200.SOPTYPE, OMNI.dbo.SOP30200.SOPNUMBE, OMNI.dbo.RM00101.CUSTNMBR, OMNI.dbo.RM00101.CUSTNAME, OMNI.dbo.RM00101.CUSTCLAS, OMNI.dbo.SOP30200.DOCID, 
         OMNI.dbo.SOP30200.DOCDATE, OMNI.dbo.SOP30200.GLPOSTDT, OMNI.dbo.SOP30200.ORIGTYPE, OMNI.dbo.SOP30200.ORIGNUMB, OMNI.dbo.SOP30200.CSTPONBR, OMNI.dbo.SOP30200.DOCAMNT,
     OMNI.dbo.SOP30200.VOIDSTTS
HAVING      (OMNI.dbo.SOP30200.SOPTYPE IN (3,4)) and OMNI.dbo.SOP30200.VOIDSTTS in (0)
UNION
SELECT     'RVM' AS COMPANY, RVM.dbo.SOP30200.SOPTYPE, RVM.dbo.SOP30200.SOPNUMBE, RVM.dbo.RM00101.CUSTNMBR, RVM.dbo.RM00101.CUSTNAME, RVM.dbo.RM00101.CUSTCLAS, 
                      RVM.dbo.SOP30200.DOCID, RVM.dbo.SOP30200.DOCDATE, RVM.dbo.SOP30200.GLPOSTDT, RVM.dbo.SOP30200.ORIGTYPE, RVM.dbo.SOP30200.ORIGNUMB, RVM.dbo.SOP30200.CSTPONBR, 
                      case RVM.dbo.SOP30200.SOPTYPE WHEN 3 THEN RVM.dbo.SOP30200.DOCAMNT WHEN 4 THEN RVM.dbo.SOP30200.DOCAMNT * -1 END DOCAMNT
FROM         RVM.dbo.SOP30200 LEFT OUTER JOIN
                      RVM.dbo.RM00101 ON RVM.dbo.SOP30200.CUSTNMBR = RVM.dbo.RM00101.CUSTNMBR
GROUP BY RVM.dbo.SOP30200.SOPTYPE, RVM.dbo.SOP30200.SOPNUMBE, RVM.dbo.RM00101.CUSTNMBR, RVM.dbo.RM00101.CUSTNAME, RVM.dbo.RM00101.CUSTCLAS, RVM.dbo.SOP30200.DOCID, 
         RVM.dbo.SOP30200.DOCDATE, RVM.dbo.SOP30200.GLPOSTDT, RVM.dbo.SOP30200.ORIGTYPE, RVM.dbo.SOP30200.ORIGNUMB, RVM.dbo.SOP30200.CSTPONBR, RVM.dbo.SOP30200.DOCAMNT,
     RVM.dbo.SOP30200.VOIDSTTS
HAVING      (RVM.dbo.SOP30200.SOPTYPE IN (3,4)) and RVM.dbo.SOP30200.VOIDSTTS in (0)
UNION
SELECT     'ntlsv' AS COMPANY, ntlsv.dbo.SOP30200.SOPTYPE, ntlsv.dbo.SOP30200.SOPNUMBE, ntlsv.dbo.RM00101.CUSTNMBR, ntlsv.dbo.RM00101.CUSTNAME, ntlsv.dbo.RM00101.CUSTCLAS, 
                      ntlsv.dbo.SOP30200.DOCID, ntlsv.dbo.SOP30200.DOCDATE, ntlsv.dbo.SOP30200.GLPOSTDT, ntlsv.dbo.SOP30200.ORIGTYPE, ntlsv.dbo.SOP30200.ORIGNUMB, ntlsv.dbo.SOP30200.CSTPONBR, 
                      case ntlsv.dbo.SOP30200.SOPTYPE WHEN 3 THEN ntlsv.dbo.SOP30200.DOCAMNT WHEN 4 THEN ntlsv.dbo.SOP30200.DOCAMNT * -1 END DOCAMNT
FROM         ntlsv.dbo.SOP30200 LEFT OUTER JOIN
                      ntlsv.dbo.RM00101 ON ntlsv.dbo.SOP30200.CUSTNMBR = ntlsv.dbo.RM00101.CUSTNMBR
GROUP BY ntlsv.dbo.SOP30200.SOPTYPE, ntlsv.dbo.SOP30200.SOPNUMBE, ntlsv.dbo.RM00101.CUSTNMBR, ntlsv.dbo.RM00101.CUSTNAME, ntlsv.dbo.RM00101.CUSTCLAS, ntlsv.dbo.SOP30200.DOCID, 
         ntlsv.dbo.SOP30200.DOCDATE, ntlsv.dbo.SOP30200.GLPOSTDT, ntlsv.dbo.SOP30200.ORIGTYPE, ntlsv.dbo.SOP30200.ORIGNUMB, ntlsv.dbo.SOP30200.CSTPONBR, ntlsv.dbo.SOP30200.DOCAMNT,
     ntlsv.dbo.SOP30200.VOIDSTTS
HAVING      (ntlsv.dbo.SOP30200.SOPTYPE IN (3,4)) and ntlsv.dbo.SOP30200.VOIDSTTS in (0)
GO

CREATE view [dbo].[CRYSTAL_CUSTOMER_INVOICE_INTERCOMPANY_DISTRIBUTIONS]
as
SELECT     'AMBIM' as COMPANY,AMBIM.dbo.SOP30200.SOPTYPE, AMBIM.dbo.SOP30200.SOPNUMBE, AMBIM.dbo.RM00101.CUSTNMBR, AMBIM.dbo.RM00101.CUSTNAME, 
                      AMBIM.dbo.RM00101.CUSTCLAS, AMBIM.dbo.SOP30200.DOCID, AMBIM.dbo.SOP30200.DOCDATE, AMBIM.dbo.SOP30200.GLPOSTDT, 
                      AMBIM.dbo.SOP30200.ORIGTYPE, AMBIM.dbo.SOP30200.ORIGNUMB, AMBIM.dbo.SOP30200.CSTPONBR, AMBIM.dbo.SOP30200.DOCAMNT, 
                      AMBIM.dbo.SOP10102.ACTINDX, AMBIM.dbo.SOP10102.DEBITAMT, AMBIM.dbo.SOP10102.ORDBTAMT, AMBIM.dbo.SOP10102.CRDTAMNT, 
                      AMBIM.dbo.SOP10102.ORCRDAMT, LEFT(ISNULL(RTRIM(AMBIM.dbo.GL00100.ACTNUMBR_1), '') 
                      + '-' + ISNULL(RTRIM(AMBIM.dbo.GL00100.ACTNUMBR_2), '') + '-' + ISNULL(RTRIM(AMBIM.dbo.GL00100.ACTNUMBR_3), '') 
                      + '-' + ISNULL(RTRIM(AMBIM.dbo.GL00100.ACTNUMBR_4), '') + '-' + ISNULL(RTRIM(AMBIM.dbo.GL00100.ACTNUMBR_5), ''), 13) AS ACTNUM
FROM         AMBIM.dbo.SOP30200 INNER JOIN
                      AMBIM.dbo.SOP10102 ON AMBIM.dbo.SOP30200.SOPTYPE = AMBIM.dbo.SOP10102.SOPTYPE AND 
                      AMBIM.dbo.SOP30200.SOPNUMBE = AMBIM.dbo.SOP10102.SOPNUMBE INNER JOIN
                      AMBIM.dbo.GL00100 ON AMBIM.dbo.SOP10102.ACTINDX = AMBIM.dbo.GL00100.ACTINDX LEFT OUTER JOIN
                      AMBIM.dbo.RM00101 ON AMBIM.dbo.SOP30200.CUSTNMBR = AMBIM.dbo.RM00101.CUSTNMBR
GROUP BY AMBIM.dbo.SOP30200.SOPTYPE, AMBIM.dbo.SOP30200.SOPNUMBE, AMBIM.dbo.RM00101.CUSTNMBR, AMBIM.dbo.RM00101.CUSTNAME, 
                      AMBIM.dbo.RM00101.CUSTCLAS, AMBIM.dbo.SOP30200.DOCID, AMBIM.dbo.SOP30200.DOCDATE, AMBIM.dbo.SOP30200.GLPOSTDT, 
                      AMBIM.dbo.SOP30200.ORIGTYPE, AMBIM.dbo.SOP30200.ORIGNUMB, AMBIM.dbo.SOP30200.CSTPONBR, AMBIM.dbo.SOP30200.DOCAMNT, 
                      AMBIM.dbo.SOP10102.ACTINDX, AMBIM.dbo.SOP10102.DEBITAMT, AMBIM.dbo.SOP10102.ORDBTAMT, AMBIM.dbo.SOP10102.CRDTAMNT, 
                      AMBIM.dbo.SOP10102.ORCRDAMT, AMBIM.dbo.GL00100.ACTNUMBR_1, AMBIM.dbo.GL00100.ACTNUMBR_2, AMBIM.dbo.GL00100.ACTNUMBR_3, 
                      AMBIM.dbo.GL00100.ACTNUMBR_4, AMBIM.dbo.GL00100.ACTNUMBR_5,AMBIM.dbo.SOP30200.VOIDSTTS
HAVING      (AMBIM.dbo.SOP30200.SOPTYPE IN (3,4)) and AMBIM.dbo.SOP30200.VOIDSTTS in (0)
union
SELECT     'AIA' as COMPANY,AIA.dbo.SOP30200.SOPTYPE, AIA.dbo.SOP30200.SOPNUMBE, AIA.dbo.RM00101.CUSTNMBR, AIA.dbo.RM00101.CUSTNAME, 
                      AIA.dbo.RM00101.CUSTCLAS, AIA.dbo.SOP30200.DOCID, AIA.dbo.SOP30200.DOCDATE, AIA.dbo.SOP30200.GLPOSTDT, 
                      AIA.dbo.SOP30200.ORIGTYPE, AIA.dbo.SOP30200.ORIGNUMB, AIA.dbo.SOP30200.CSTPONBR, AIA.dbo.SOP30200.DOCAMNT, 
                      AIA.dbo.SOP10102.ACTINDX, AIA.dbo.SOP10102.DEBITAMT, AIA.dbo.SOP10102.ORDBTAMT, AIA.dbo.SOP10102.CRDTAMNT, 
                      AIA.dbo.SOP10102.ORCRDAMT, LEFT(ISNULL(RTRIM(AIA.dbo.GL00100.ACTNUMBR_1), '') 
                      + '-' + ISNULL(RTRIM(AIA.dbo.GL00100.ACTNUMBR_2), '') + '-' + ISNULL(RTRIM(AIA.dbo.GL00100.ACTNUMBR_3), '') 
                      + '-' + ISNULL(RTRIM(AIA.dbo.GL00100.ACTNUMBR_4), '') + '-' + ISNULL(RTRIM(AIA.dbo.GL00100.ACTNUMBR_5), ''), 13) AS ACTNUM
FROM         AIA.dbo.SOP30200 INNER JOIN
                      AIA.dbo.SOP10102 ON AIA.dbo.SOP30200.SOPTYPE = AIA.dbo.SOP10102.SOPTYPE AND 
                      AIA.dbo.SOP30200.SOPNUMBE = AIA.dbo.SOP10102.SOPNUMBE INNER JOIN
                      AIA.dbo.GL00100 ON AIA.dbo.SOP10102.ACTINDX = AIA.dbo.GL00100.ACTINDX LEFT OUTER JOIN
                      AIA.dbo.RM00101 ON AIA.dbo.SOP30200.CUSTNMBR = AIA.dbo.RM00101.CUSTNMBR
GROUP BY AIA.dbo.SOP30200.SOPTYPE, AIA.dbo.SOP30200.SOPNUMBE, AIA.dbo.RM00101.CUSTNMBR, AIA.dbo.RM00101.CUSTNAME, 
                      AIA.dbo.RM00101.CUSTCLAS, AIA.dbo.SOP30200.DOCID, AIA.dbo.SOP30200.DOCDATE, AIA.dbo.SOP30200.GLPOSTDT, 
                      AIA.dbo.SOP30200.ORIGTYPE, AIA.dbo.SOP30200.ORIGNUMB, AIA.dbo.SOP30200.CSTPONBR, AIA.dbo.SOP30200.DOCAMNT, 
                      AIA.dbo.SOP10102.ACTINDX, AIA.dbo.SOP10102.DEBITAMT, AIA.dbo.SOP10102.ORDBTAMT, AIA.dbo.SOP10102.CRDTAMNT, 
                      AIA.dbo.SOP10102.ORCRDAMT, AIA.dbo.GL00100.ACTNUMBR_1, AIA.dbo.GL00100.ACTNUMBR_2, AIA.dbo.GL00100.ACTNUMBR_3, 
                      AIA.dbo.GL00100.ACTNUMBR_4, AIA.dbo.GL00100.ACTNUMBR_5,AIA.dbo.SOP30200.VOIDSTTS
HAVING      (AIA.dbo.SOP30200.SOPTYPE IN (3,4)) and AIA.dbo.SOP30200.VOIDSTTS in (0) 
union
SELECT     'AMCOR' as COMPANY,AMCOR.dbo.SOP30200.SOPTYPE, AMCOR.dbo.SOP30200.SOPNUMBE, AMCOR.dbo.RM00101.CUSTNMBR, AMCOR.dbo.RM00101.CUSTNAME, 
                      AMCOR.dbo.RM00101.CUSTCLAS, AMCOR.dbo.SOP30200.DOCID, AMCOR.dbo.SOP30200.DOCDATE, AMCOR.dbo.SOP30200.GLPOSTDT, 
                      AMCOR.dbo.SOP30200.ORIGTYPE, AMCOR.dbo.SOP30200.ORIGNUMB, AMCOR.dbo.SOP30200.CSTPONBR, AMCOR.dbo.SOP30200.DOCAMNT, 
                      AMCOR.dbo.SOP10102.ACTINDX, AMCOR.dbo.SOP10102.DEBITAMT, AMCOR.dbo.SOP10102.ORDBTAMT, AMCOR.dbo.SOP10102.CRDTAMNT, 
                      AMCOR.dbo.SOP10102.ORCRDAMT, LEFT(ISNULL(RTRIM(AMCOR.dbo.GL00100.ACTNUMBR_1), '') 
                      + '-' + ISNULL(RTRIM(AMCOR.dbo.GL00100.ACTNUMBR_2), '') + '-' + ISNULL(RTRIM(AMCOR.dbo.GL00100.ACTNUMBR_3), '') 
                      + '-' + ISNULL(RTRIM(AMCOR.dbo.GL00100.ACTNUMBR_4), '') + '-' + ISNULL(RTRIM(AMCOR.dbo.GL00100.ACTNUMBR_5), ''), 13) AS ACTNUM
FROM         AMCOR.dbo.SOP30200 INNER JOIN
                      AMCOR.dbo.SOP10102 ON AMCOR.dbo.SOP30200.SOPTYPE = AMCOR.dbo.SOP10102.SOPTYPE AND 
                      AMCOR.dbo.SOP30200.SOPNUMBE = AMCOR.dbo.SOP10102.SOPNUMBE INNER JOIN
                      AMCOR.dbo.GL00100 ON AMCOR.dbo.SOP10102.ACTINDX = AMCOR.dbo.GL00100.ACTINDX LEFT OUTER JOIN
                      AMCOR.dbo.RM00101 ON AMCOR.dbo.SOP30200.CUSTNMBR = AMCOR.dbo.RM00101.CUSTNMBR
GROUP BY AMCOR.dbo.SOP30200.SOPTYPE, AMCOR.dbo.SOP30200.SOPNUMBE, AMCOR.dbo.RM00101.CUSTNMBR, AMCOR.dbo.RM00101.CUSTNAME, 
                      AMCOR.dbo.RM00101.CUSTCLAS, AMCOR.dbo.SOP30200.DOCID, AMCOR.dbo.SOP30200.DOCDATE, AMCOR.dbo.SOP30200.GLPOSTDT, 
                      AMCOR.dbo.SOP30200.ORIGTYPE, AMCOR.dbo.SOP30200.ORIGNUMB, AMCOR.dbo.SOP30200.CSTPONBR, AMCOR.dbo.SOP30200.DOCAMNT, 
                      AMCOR.dbo.SOP10102.ACTINDX, AMCOR.dbo.SOP10102.DEBITAMT, AMCOR.dbo.SOP10102.ORDBTAMT, AMCOR.dbo.SOP10102.CRDTAMNT, 
                      AMCOR.dbo.SOP10102.ORCRDAMT, AMCOR.dbo.GL00100.ACTNUMBR_1, AMCOR.dbo.GL00100.ACTNUMBR_2, AMCOR.dbo.GL00100.ACTNUMBR_3, 
                      AMCOR.dbo.GL00100.ACTNUMBR_4, AMCOR.dbo.GL00100.ACTNUMBR_5,AMCOR.dbo.SOP30200.VOIDSTTS
HAVING      (AMCOR.dbo.SOP30200.SOPTYPE IN (3,4)) and AMCOR.dbo.SOP30200.VOIDSTTS in (0)
UNION
SELECT     'AMMAD' as COMPANY,AMMAD.dbo.SOP30200.SOPTYPE, AMMAD.dbo.SOP30200.SOPNUMBE, AMMAD.dbo.RM00101.CUSTNMBR, AMMAD.dbo.RM00101.CUSTNAME, 
                      AMMAD.dbo.RM00101.CUSTCLAS, AMMAD.dbo.SOP30200.DOCID, AMMAD.dbo.SOP30200.DOCDATE, AMMAD.dbo.SOP30200.GLPOSTDT, 
                      AMMAD.dbo.SOP30200.ORIGTYPE, AMMAD.dbo.SOP30200.ORIGNUMB, AMMAD.dbo.SOP30200.CSTPONBR, AMMAD.dbo.SOP30200.DOCAMNT, 
                      AMMAD.dbo.SOP10102.ACTINDX, AMMAD.dbo.SOP10102.DEBITAMT, AMMAD.dbo.SOP10102.ORDBTAMT, AMMAD.dbo.SOP10102.CRDTAMNT, 
                      AMMAD.dbo.SOP10102.ORCRDAMT, LEFT(ISNULL(RTRIM(AMMAD.dbo.GL00100.ACTNUMBR_1), '') 
                      + '-' + ISNULL(RTRIM(AMMAD.dbo.GL00100.ACTNUMBR_2), '') + '-' + ISNULL(RTRIM(AMMAD.dbo.GL00100.ACTNUMBR_3), '') 
                      + '-' + ISNULL(RTRIM(AMMAD.dbo.GL00100.ACTNUMBR_4), '') + '-' + ISNULL(RTRIM(AMMAD.dbo.GL00100.ACTNUMBR_5), ''), 13) AS ACTNUM
FROM         AMMAD.dbo.SOP30200 INNER JOIN
                      AMMAD.dbo.SOP10102 ON AMMAD.dbo.SOP30200.SOPTYPE = AMMAD.dbo.SOP10102.SOPTYPE AND 
                      AMMAD.dbo.SOP30200.SOPNUMBE = AMMAD.dbo.SOP10102.SOPNUMBE INNER JOIN
                      AMMAD.dbo.GL00100 ON AMMAD.dbo.SOP10102.ACTINDX = AMMAD.dbo.GL00100.ACTINDX LEFT OUTER JOIN
                      AMMAD.dbo.RM00101 ON AMMAD.dbo.SOP30200.CUSTNMBR = AMMAD.dbo.RM00101.CUSTNMBR
GROUP BY AMMAD.dbo.SOP30200.SOPTYPE, AMMAD.dbo.SOP30200.SOPNUMBE, AMMAD.dbo.RM00101.CUSTNMBR, AMMAD.dbo.RM00101.CUSTNAME, 
                      AMMAD.dbo.RM00101.CUSTCLAS, AMMAD.dbo.SOP30200.DOCID, AMMAD.dbo.SOP30200.DOCDATE, AMMAD.dbo.SOP30200.GLPOSTDT, 
                      AMMAD.dbo.SOP30200.ORIGTYPE, AMMAD.dbo.SOP30200.ORIGNUMB, AMMAD.dbo.SOP30200.CSTPONBR, AMMAD.dbo.SOP30200.DOCAMNT, 
                      AMMAD.dbo.SOP10102.ACTINDX, AMMAD.dbo.SOP10102.DEBITAMT, AMMAD.dbo.SOP10102.ORDBTAMT, AMMAD.dbo.SOP10102.CRDTAMNT, 
                      AMMAD.dbo.SOP10102.ORCRDAMT, AMMAD.dbo.GL00100.ACTNUMBR_1, AMMAD.dbo.GL00100.ACTNUMBR_2, AMMAD.dbo.GL00100.ACTNUMBR_3, 
                      AMMAD.dbo.GL00100.ACTNUMBR_4, AMMAD.dbo.GL00100.ACTNUMBR_5,AMMAD.dbo.SOP30200.VOIDSTTS
HAVING      (AMMAD.dbo.SOP30200.SOPTYPE IN (3,4)) and AMMAD.dbo.SOP30200.VOIDSTTS in (0)
UNION
SELECT     'CIINC' as COMPANY,CIINC.dbo.SOP30200.SOPTYPE, CIINC.dbo.SOP30200.SOPNUMBE, CIINC.dbo.RM00101.CUSTNMBR, CIINC.dbo.RM00101.CUSTNAME, 
                      CIINC.dbo.RM00101.CUSTCLAS, CIINC.dbo.SOP30200.DOCID, CIINC.dbo.SOP30200.DOCDATE, CIINC.dbo.SOP30200.GLPOSTDT, 
                      CIINC.dbo.SOP30200.ORIGTYPE, CIINC.dbo.SOP30200.ORIGNUMB, CIINC.dbo.SOP30200.CSTPONBR, CIINC.dbo.SOP30200.DOCAMNT, 
                      CIINC.dbo.SOP10102.ACTINDX, CIINC.dbo.SOP10102.DEBITAMT, CIINC.dbo.SOP10102.ORDBTAMT, CIINC.dbo.SOP10102.CRDTAMNT, 
                      CIINC.dbo.SOP10102.ORCRDAMT, LEFT(ISNULL(RTRIM(CIINC.dbo.GL00100.ACTNUMBR_1), '') 
                      + '-' + ISNULL(RTRIM(CIINC.dbo.GL00100.ACTNUMBR_2), '') + '-' + ISNULL(RTRIM(CIINC.dbo.GL00100.ACTNUMBR_3), '') 
                      + '-' + ISNULL(RTRIM(CIINC.dbo.GL00100.ACTNUMBR_4), '') + '-' + ISNULL(RTRIM(CIINC.dbo.GL00100.ACTNUMBR_5), ''), 13) AS ACTNUM
FROM         CIINC.dbo.SOP30200 INNER JOIN
                      CIINC.dbo.SOP10102 ON CIINC.dbo.SOP30200.SOPTYPE = CIINC.dbo.SOP10102.SOPTYPE AND 
                      CIINC.dbo.SOP30200.SOPNUMBE = CIINC.dbo.SOP10102.SOPNUMBE INNER JOIN
                      CIINC.dbo.GL00100 ON CIINC.dbo.SOP10102.ACTINDX = CIINC.dbo.GL00100.ACTINDX LEFT OUTER JOIN
                      CIINC.dbo.RM00101 ON CIINC.dbo.SOP30200.CUSTNMBR = CIINC.dbo.RM00101.CUSTNMBR
GROUP BY CIINC.dbo.SOP30200.SOPTYPE, CIINC.dbo.SOP30200.SOPNUMBE, CIINC.dbo.RM00101.CUSTNMBR, CIINC.dbo.RM00101.CUSTNAME, 
                      CIINC.dbo.RM00101.CUSTCLAS, CIINC.dbo.SOP30200.DOCID, CIINC.dbo.SOP30200.DOCDATE, CIINC.dbo.SOP30200.GLPOSTDT, 
                      CIINC.dbo.SOP30200.ORIGTYPE, CIINC.dbo.SOP30200.ORIGNUMB, CIINC.dbo.SOP30200.CSTPONBR, CIINC.dbo.SOP30200.DOCAMNT, 
                      CIINC.dbo.SOP10102.ACTINDX, CIINC.dbo.SOP10102.DEBITAMT, CIINC.dbo.SOP10102.ORDBTAMT, CIINC.dbo.SOP10102.CRDTAMNT, 
                      CIINC.dbo.SOP10102.ORCRDAMT, CIINC.dbo.GL00100.ACTNUMBR_1, CIINC.dbo.GL00100.ACTNUMBR_2, CIINC.dbo.GL00100.ACTNUMBR_3, 
                      CIINC.dbo.GL00100.ACTNUMBR_4, CIINC.dbo.GL00100.ACTNUMBR_5,CIINC.dbo.SOP30200.VOIDSTTS
HAVING      (CIINC.dbo.SOP30200.SOPTYPE IN (3,4)) and CIINC.dbo.SOP30200.VOIDSTTS in (0)
UNION
SELECT     'CILLC' as COMPANY,CILLC.dbo.SOP30200.SOPTYPE, CILLC.dbo.SOP30200.SOPNUMBE, CILLC.dbo.RM00101.CUSTNMBR, CILLC.dbo.RM00101.CUSTNAME, 
                      CILLC.dbo.RM00101.CUSTCLAS, CILLC.dbo.SOP30200.DOCID, CILLC.dbo.SOP30200.DOCDATE, CILLC.dbo.SOP30200.GLPOSTDT, 
                      CILLC.dbo.SOP30200.ORIGTYPE, CILLC.dbo.SOP30200.ORIGNUMB, CILLC.dbo.SOP30200.CSTPONBR, CILLC.dbo.SOP30200.DOCAMNT, 
                      CILLC.dbo.SOP10102.ACTINDX, CILLC.dbo.SOP10102.DEBITAMT, CILLC.dbo.SOP10102.ORDBTAMT, CILLC.dbo.SOP10102.CRDTAMNT, 
                      CILLC.dbo.SOP10102.ORCRDAMT, LEFT(ISNULL(RTRIM(CILLC.dbo.GL00100.ACTNUMBR_1), '') 
                      + '-' + ISNULL(RTRIM(CILLC.dbo.GL00100.ACTNUMBR_2), '') + '-' + ISNULL(RTRIM(CILLC.dbo.GL00100.ACTNUMBR_3), '') 
                      + '-' + ISNULL(RTRIM(CILLC.dbo.GL00100.ACTNUMBR_4), '') + '-' + ISNULL(RTRIM(CILLC.dbo.GL00100.ACTNUMBR_5), ''), 13) AS ACTNUM
FROM         CILLC.dbo.SOP30200 INNER JOIN
                      CILLC.dbo.SOP10102 ON CILLC.dbo.SOP30200.SOPTYPE = CILLC.dbo.SOP10102.SOPTYPE AND 
                      CILLC.dbo.SOP30200.SOPNUMBE = CILLC.dbo.SOP10102.SOPNUMBE INNER JOIN
                      CILLC.dbo.GL00100 ON CILLC.dbo.SOP10102.ACTINDX = CILLC.dbo.GL00100.ACTINDX LEFT OUTER JOIN
                      CILLC.dbo.RM00101 ON CILLC.dbo.SOP30200.CUSTNMBR = CILLC.dbo.RM00101.CUSTNMBR
GROUP BY CILLC.dbo.SOP30200.SOPTYPE, CILLC.dbo.SOP30200.SOPNUMBE, CILLC.dbo.RM00101.CUSTNMBR, CILLC.dbo.RM00101.CUSTNAME, 
                      CILLC.dbo.RM00101.CUSTCLAS, CILLC.dbo.SOP30200.DOCID, CILLC.dbo.SOP30200.DOCDATE, CILLC.dbo.SOP30200.GLPOSTDT, 
                      CILLC.dbo.SOP30200.ORIGTYPE, CILLC.dbo.SOP30200.ORIGNUMB, CILLC.dbo.SOP30200.CSTPONBR, CILLC.dbo.SOP30200.DOCAMNT, 
                      CILLC.dbo.SOP10102.ACTINDX, CILLC.dbo.SOP10102.DEBITAMT, CILLC.dbo.SOP10102.ORDBTAMT, CILLC.dbo.SOP10102.CRDTAMNT, 
                      CILLC.dbo.SOP10102.ORCRDAMT, CILLC.dbo.GL00100.ACTNUMBR_1, CILLC.dbo.GL00100.ACTNUMBR_2, CILLC.dbo.GL00100.ACTNUMBR_3, 
                      CILLC.dbo.GL00100.ACTNUMBR_4, CILLC.dbo.GL00100.ACTNUMBR_5,CILLC.dbo.SOP30200.VOIDSTTS
HAVING      (CILLC.dbo.SOP30200.SOPTYPE IN (3,4)) and CILLC.dbo.SOP30200.VOIDSTTS in (0)
UNION
SELECT     'CIMN' as COMPANY,CIMN.dbo.SOP30200.SOPTYPE, CIMN.dbo.SOP30200.SOPNUMBE, CIMN.dbo.RM00101.CUSTNMBR, CIMN.dbo.RM00101.CUSTNAME, 
                      CIMN.dbo.RM00101.CUSTCLAS, CIMN.dbo.SOP30200.DOCID, CIMN.dbo.SOP30200.DOCDATE, CIMN.dbo.SOP30200.GLPOSTDT, 
                      CIMN.dbo.SOP30200.ORIGTYPE, CIMN.dbo.SOP30200.ORIGNUMB, CIMN.dbo.SOP30200.CSTPONBR, CIMN.dbo.SOP30200.DOCAMNT, 
                      CIMN.dbo.SOP10102.ACTINDX, CIMN.dbo.SOP10102.DEBITAMT, CIMN.dbo.SOP10102.ORDBTAMT, CIMN.dbo.SOP10102.CRDTAMNT, 
                      CIMN.dbo.SOP10102.ORCRDAMT, LEFT(ISNULL(RTRIM(CIMN.dbo.GL00100.ACTNUMBR_1), '') 
                      + '-' + ISNULL(RTRIM(CIMN.dbo.GL00100.ACTNUMBR_2), '') + '-' + ISNULL(RTRIM(CIMN.dbo.GL00100.ACTNUMBR_3), '') 
                      + '-' + ISNULL(RTRIM(CIMN.dbo.GL00100.ACTNUMBR_4), '') + '-' + ISNULL(RTRIM(CIMN.dbo.GL00100.ACTNUMBR_5), ''), 13) AS ACTNUM
FROM         CIMN.dbo.SOP30200 INNER JOIN
                      CIMN.dbo.SOP10102 ON CIMN.dbo.SOP30200.SOPTYPE = CIMN.dbo.SOP10102.SOPTYPE AND 
                      CIMN.dbo.SOP30200.SOPNUMBE = CIMN.dbo.SOP10102.SOPNUMBE INNER JOIN
                      CIMN.dbo.GL00100 ON CIMN.dbo.SOP10102.ACTINDX = CIMN.dbo.GL00100.ACTINDX LEFT OUTER JOIN
                      CIMN.dbo.RM00101 ON CIMN.dbo.SOP30200.CUSTNMBR = CIMN.dbo.RM00101.CUSTNMBR
GROUP BY CIMN.dbo.SOP30200.SOPTYPE, CIMN.dbo.SOP30200.SOPNUMBE, CIMN.dbo.RM00101.CUSTNMBR, CIMN.dbo.RM00101.CUSTNAME, 
                      CIMN.dbo.RM00101.CUSTCLAS, CIMN.dbo.SOP30200.DOCID, CIMN.dbo.SOP30200.DOCDATE, CIMN.dbo.SOP30200.GLPOSTDT, 
                      CIMN.dbo.SOP30200.ORIGTYPE, CIMN.dbo.SOP30200.ORIGNUMB, CIMN.dbo.SOP30200.CSTPONBR, CIMN.dbo.SOP30200.DOCAMNT, 
                      CIMN.dbo.SOP10102.ACTINDX, CIMN.dbo.SOP10102.DEBITAMT, CIMN.dbo.SOP10102.ORDBTAMT, CIMN.dbo.SOP10102.CRDTAMNT, 
                      CIMN.dbo.SOP10102.ORCRDAMT, CIMN.dbo.GL00100.ACTNUMBR_1, CIMN.dbo.GL00100.ACTNUMBR_2, CIMN.dbo.GL00100.ACTNUMBR_3, 
                      CIMN.dbo.GL00100.ACTNUMBR_4, CIMN.dbo.GL00100.ACTNUMBR_5,CIMN.dbo.SOP30200.VOIDSTTS
HAVING      (CIMN.dbo.SOP30200.SOPTYPE IN (3,4)) and CIMN.dbo.SOP30200.VOIDSTTS in (0)
UNION
SELECT     'ECMS' as COMPANY,ECMS.dbo.SOP30200.SOPTYPE, ECMS.dbo.SOP30200.SOPNUMBE, ECMS.dbo.RM00101.CUSTNMBR, ECMS.dbo.RM00101.CUSTNAME, 
                      ECMS.dbo.RM00101.CUSTCLAS, ECMS.dbo.SOP30200.DOCID, ECMS.dbo.SOP30200.DOCDATE, ECMS.dbo.SOP30200.GLPOSTDT, 
                      ECMS.dbo.SOP30200.ORIGTYPE, ECMS.dbo.SOP30200.ORIGNUMB, ECMS.dbo.SOP30200.CSTPONBR, ECMS.dbo.SOP30200.DOCAMNT, 
                      ECMS.dbo.SOP10102.ACTINDX, ECMS.dbo.SOP10102.DEBITAMT, ECMS.dbo.SOP10102.ORDBTAMT, ECMS.dbo.SOP10102.CRDTAMNT, 
                      ECMS.dbo.SOP10102.ORCRDAMT, LEFT(ISNULL(RTRIM(ECMS.dbo.GL00100.ACTNUMBR_1), '') 
                      + '-' + ISNULL(RTRIM(ECMS.dbo.GL00100.ACTNUMBR_2), '') + '-' + ISNULL(RTRIM(ECMS.dbo.GL00100.ACTNUMBR_3), '') 
                      + '-' + ISNULL(RTRIM(ECMS.dbo.GL00100.ACTNUMBR_4), '') + '-' + ISNULL(RTRIM(ECMS.dbo.GL00100.ACTNUMBR_5), ''), 13) AS ACTNUM
FROM         ECMS.dbo.SOP30200 INNER JOIN
                      ECMS.dbo.SOP10102 ON ECMS.dbo.SOP30200.SOPTYPE = ECMS.dbo.SOP10102.SOPTYPE AND 
                      ECMS.dbo.SOP30200.SOPNUMBE = ECMS.dbo.SOP10102.SOPNUMBE INNER JOIN
                      ECMS.dbo.GL00100 ON ECMS.dbo.SOP10102.ACTINDX = ECMS.dbo.GL00100.ACTINDX LEFT OUTER JOIN
                      ECMS.dbo.RM00101 ON ECMS.dbo.SOP30200.CUSTNMBR = ECMS.dbo.RM00101.CUSTNMBR
GROUP BY ECMS.dbo.SOP30200.SOPTYPE, ECMS.dbo.SOP30200.SOPNUMBE, ECMS.dbo.RM00101.CUSTNMBR, ECMS.dbo.RM00101.CUSTNAME, 
                      ECMS.dbo.RM00101.CUSTCLAS, ECMS.dbo.SOP30200.DOCID, ECMS.dbo.SOP30200.DOCDATE, ECMS.dbo.SOP30200.GLPOSTDT, 
                      ECMS.dbo.SOP30200.ORIGTYPE, ECMS.dbo.SOP30200.ORIGNUMB, ECMS.dbo.SOP30200.CSTPONBR, ECMS.dbo.SOP30200.DOCAMNT, 
                      ECMS.dbo.SOP10102.ACTINDX, ECMS.dbo.SOP10102.DEBITAMT, ECMS.dbo.SOP10102.ORDBTAMT, ECMS.dbo.SOP10102.CRDTAMNT, 
                      ECMS.dbo.SOP10102.ORCRDAMT, ECMS.dbo.GL00100.ACTNUMBR_1, ECMS.dbo.GL00100.ACTNUMBR_2, ECMS.dbo.GL00100.ACTNUMBR_3, 
                      ECMS.dbo.GL00100.ACTNUMBR_4, ECMS.dbo.GL00100.ACTNUMBR_5,ECMS.dbo.SOP30200.VOIDSTTS
HAVING      (ECMS.dbo.SOP30200.SOPTYPE IN (3,4)) and ECMS.dbo.SOP30200.VOIDSTTS in (0)
UNION
SELECT     'ICS' as COMPANY,ICS.dbo.SOP30200.SOPTYPE, ICS.dbo.SOP30200.SOPNUMBE, ICS.dbo.RM00101.CUSTNMBR, ICS.dbo.RM00101.CUSTNAME, 
                      ICS.dbo.RM00101.CUSTCLAS, ICS.dbo.SOP30200.DOCID, ICS.dbo.SOP30200.DOCDATE, ICS.dbo.SOP30200.GLPOSTDT, 
                      ICS.dbo.SOP30200.ORIGTYPE, ICS.dbo.SOP30200.ORIGNUMB, ICS.dbo.SOP30200.CSTPONBR, ICS.dbo.SOP30200.DOCAMNT, 
                      ICS.dbo.SOP10102.ACTINDX, ICS.dbo.SOP10102.DEBITAMT, ICS.dbo.SOP10102.ORDBTAMT, ICS.dbo.SOP10102.CRDTAMNT, 
                      ICS.dbo.SOP10102.ORCRDAMT, LEFT(ISNULL(RTRIM(ICS.dbo.GL00100.ACTNUMBR_1), '') 
                      + '-' + ISNULL(RTRIM(ICS.dbo.GL00100.ACTNUMBR_2), '') + '-' + ISNULL(RTRIM(ICS.dbo.GL00100.ACTNUMBR_3), '') 
                      + '-' + ISNULL(RTRIM(ICS.dbo.GL00100.ACTNUMBR_4), '') + '-' + ISNULL(RTRIM(ICS.dbo.GL00100.ACTNUMBR_5), ''), 13) AS ACTNUM
FROM         ICS.dbo.SOP30200 INNER JOIN
                      ICS.dbo.SOP10102 ON ICS.dbo.SOP30200.SOPTYPE = ICS.dbo.SOP10102.SOPTYPE AND 
                      ICS.dbo.SOP30200.SOPNUMBE = ICS.dbo.SOP10102.SOPNUMBE INNER JOIN
                      ICS.dbo.GL00100 ON ICS.dbo.SOP10102.ACTINDX = ICS.dbo.GL00100.ACTINDX LEFT OUTER JOIN
                      ICS.dbo.RM00101 ON ICS.dbo.SOP30200.CUSTNMBR = ICS.dbo.RM00101.CUSTNMBR
GROUP BY ICS.dbo.SOP30200.SOPTYPE, ICS.dbo.SOP30200.SOPNUMBE, ICS.dbo.RM00101.CUSTNMBR, ICS.dbo.RM00101.CUSTNAME, 
                      ICS.dbo.RM00101.CUSTCLAS, ICS.dbo.SOP30200.DOCID, ICS.dbo.SOP30200.DOCDATE, ICS.dbo.SOP30200.GLPOSTDT, 
                      ICS.dbo.SOP30200.ORIGTYPE, ICS.dbo.SOP30200.ORIGNUMB, ICS.dbo.SOP30200.CSTPONBR, ICS.dbo.SOP30200.DOCAMNT, 
                      ICS.dbo.SOP10102.ACTINDX, ICS.dbo.SOP10102.DEBITAMT, ICS.dbo.SOP10102.ORDBTAMT, ICS.dbo.SOP10102.CRDTAMNT, 
                      ICS.dbo.SOP10102.ORCRDAMT, ICS.dbo.GL00100.ACTNUMBR_1, ICS.dbo.GL00100.ACTNUMBR_2, ICS.dbo.GL00100.ACTNUMBR_3, 
                      ICS.dbo.GL00100.ACTNUMBR_4, ICS.dbo.GL00100.ACTNUMBR_5,ICS.dbo.SOP30200.VOIDSTTS
HAVING      (ICS.dbo.SOP30200.SOPTYPE IN (3,4)) and ICS.dbo.SOP30200.VOIDSTTS in (0)
UNION
SELECT     'INTRA' as COMPANY,INTRA.dbo.SOP30200.SOPTYPE, INTRA.dbo.SOP30200.SOPNUMBE, INTRA.dbo.RM00101.CUSTNMBR, INTRA.dbo.RM00101.CUSTNAME, 
                      INTRA.dbo.RM00101.CUSTCLAS, INTRA.dbo.SOP30200.DOCID, INTRA.dbo.SOP30200.DOCDATE, INTRA.dbo.SOP30200.GLPOSTDT, 
                      INTRA.dbo.SOP30200.ORIGTYPE, INTRA.dbo.SOP30200.ORIGNUMB, INTRA.dbo.SOP30200.CSTPONBR, INTRA.dbo.SOP30200.DOCAMNT, 
                      INTRA.dbo.SOP10102.ACTINDX, INTRA.dbo.SOP10102.DEBITAMT, INTRA.dbo.SOP10102.ORDBTAMT, INTRA.dbo.SOP10102.CRDTAMNT, 
                      INTRA.dbo.SOP10102.ORCRDAMT, LEFT(ISNULL(RTRIM(INTRA.dbo.GL00100.ACTNUMBR_1), '') 
                      + '-' + ISNULL(RTRIM(INTRA.dbo.GL00100.ACTNUMBR_2), '') + '-' + ISNULL(RTRIM(INTRA.dbo.GL00100.ACTNUMBR_3), '') 
                      + '-' + ISNULL(RTRIM(INTRA.dbo.GL00100.ACTNUMBR_4), '') + '-' + ISNULL(RTRIM(INTRA.dbo.GL00100.ACTNUMBR_5), ''), 13) AS ACTNUM
FROM         INTRA.dbo.SOP30200 INNER JOIN
                      INTRA.dbo.SOP10102 ON INTRA.dbo.SOP30200.SOPTYPE = INTRA.dbo.SOP10102.SOPTYPE AND 
                      INTRA.dbo.SOP30200.SOPNUMBE = INTRA.dbo.SOP10102.SOPNUMBE INNER JOIN
                      INTRA.dbo.GL00100 ON INTRA.dbo.SOP10102.ACTINDX = INTRA.dbo.GL00100.ACTINDX LEFT OUTER JOIN
                      INTRA.dbo.RM00101 ON INTRA.dbo.SOP30200.CUSTNMBR = INTRA.dbo.RM00101.CUSTNMBR
GROUP BY INTRA.dbo.SOP30200.SOPTYPE, INTRA.dbo.SOP30200.SOPNUMBE, INTRA.dbo.RM00101.CUSTNMBR, INTRA.dbo.RM00101.CUSTNAME, 
                      INTRA.dbo.RM00101.CUSTCLAS, INTRA.dbo.SOP30200.DOCID, INTRA.dbo.SOP30200.DOCDATE, INTRA.dbo.SOP30200.GLPOSTDT, 
                      INTRA.dbo.SOP30200.ORIGTYPE, INTRA.dbo.SOP30200.ORIGNUMB, INTRA.dbo.SOP30200.CSTPONBR, INTRA.dbo.SOP30200.DOCAMNT, 
                      INTRA.dbo.SOP10102.ACTINDX, INTRA.dbo.SOP10102.DEBITAMT, INTRA.dbo.SOP10102.ORDBTAMT, INTRA.dbo.SOP10102.CRDTAMNT, 
                      INTRA.dbo.SOP10102.ORCRDAMT, INTRA.dbo.GL00100.ACTNUMBR_1, INTRA.dbo.GL00100.ACTNUMBR_2, INTRA.dbo.GL00100.ACTNUMBR_3, 
                      INTRA.dbo.GL00100.ACTNUMBR_4, INTRA.dbo.GL00100.ACTNUMBR_5,INTRA.dbo.SOP30200.VOIDSTTS
HAVING      (INTRA.dbo.SOP30200.SOPTYPE IN (3,4)) and INTRA.dbo.SOP30200.VOIDSTTS in (0)
UNION
SELECT     'IT' as COMPANY,IT.dbo.SOP30200.SOPTYPE, IT.dbo.SOP30200.SOPNUMBE, IT.dbo.RM00101.CUSTNMBR, IT.dbo.RM00101.CUSTNAME, 
                      IT.dbo.RM00101.CUSTCLAS, IT.dbo.SOP30200.DOCID, IT.dbo.SOP30200.DOCDATE, IT.dbo.SOP30200.GLPOSTDT, 
                      IT.dbo.SOP30200.ORIGTYPE, IT.dbo.SOP30200.ORIGNUMB, IT.dbo.SOP30200.CSTPONBR, IT.dbo.SOP30200.DOCAMNT, 
                      IT.dbo.SOP10102.ACTINDX, IT.dbo.SOP10102.DEBITAMT, IT.dbo.SOP10102.ORDBTAMT, IT.dbo.SOP10102.CRDTAMNT, 
                      IT.dbo.SOP10102.ORCRDAMT, LEFT(ISNULL(RTRIM(IT.dbo.GL00100.ACTNUMBR_1), '') 
                      + '-' + ISNULL(RTRIM(IT.dbo.GL00100.ACTNUMBR_2), '') + '-' + ISNULL(RTRIM(IT.dbo.GL00100.ACTNUMBR_3), '') 
                      + '-' + ISNULL(RTRIM(IT.dbo.GL00100.ACTNUMBR_4), '') + '-' + ISNULL(RTRIM(IT.dbo.GL00100.ACTNUMBR_5), ''), 13) AS ACTNUM
FROM         IT.dbo.SOP30200 INNER JOIN
                      IT.dbo.SOP10102 ON IT.dbo.SOP30200.SOPTYPE = IT.dbo.SOP10102.SOPTYPE AND 
                      IT.dbo.SOP30200.SOPNUMBE = IT.dbo.SOP10102.SOPNUMBE INNER JOIN
                      IT.dbo.GL00100 ON IT.dbo.SOP10102.ACTINDX = IT.dbo.GL00100.ACTINDX LEFT OUTER JOIN
                      IT.dbo.RM00101 ON IT.dbo.SOP30200.CUSTNMBR = IT.dbo.RM00101.CUSTNMBR
GROUP BY IT.dbo.SOP30200.SOPTYPE, IT.dbo.SOP30200.SOPNUMBE, IT.dbo.RM00101.CUSTNMBR, IT.dbo.RM00101.CUSTNAME, 
                      IT.dbo.RM00101.CUSTCLAS, IT.dbo.SOP30200.DOCID, IT.dbo.SOP30200.DOCDATE, IT.dbo.SOP30200.GLPOSTDT, 
                      IT.dbo.SOP30200.ORIGTYPE, IT.dbo.SOP30200.ORIGNUMB, IT.dbo.SOP30200.CSTPONBR, IT.dbo.SOP30200.DOCAMNT, 
                      IT.dbo.SOP10102.ACTINDX, IT.dbo.SOP10102.DEBITAMT, IT.dbo.SOP10102.ORDBTAMT, IT.dbo.SOP10102.CRDTAMNT, 
                      IT.dbo.SOP10102.ORCRDAMT, IT.dbo.GL00100.ACTNUMBR_1, IT.dbo.GL00100.ACTNUMBR_2, IT.dbo.GL00100.ACTNUMBR_3, 
IT.dbo.GL00100.ACTNUMBR_4, IT.dbo.GL00100.ACTNUMBR_5,IT.dbo.SOP30200.VOIDSTTS
HAVING      (IT.dbo.SOP30200.SOPTYPE IN (3,4)) and IT.dbo.SOP30200.VOIDSTTS in (0)
UNION
SELECT     'OMNI' as COMPANY,OMNI.dbo.SOP30200.SOPTYPE, OMNI.dbo.SOP30200.SOPNUMBE, OMNI.dbo.RM00101.CUSTNMBR, OMNI.dbo.RM00101.CUSTNAME, 
                      OMNI.dbo.RM00101.CUSTCLAS, OMNI.dbo.SOP30200.DOCID, OMNI.dbo.SOP30200.DOCDATE, OMNI.dbo.SOP30200.GLPOSTDT, 
                      OMNI.dbo.SOP30200.ORIGTYPE, OMNI.dbo.SOP30200.ORIGNUMB, OMNI.dbo.SOP30200.CSTPONBR, OMNI.dbo.SOP30200.DOCAMNT, 
                      OMNI.dbo.SOP10102.ACTINDX, OMNI.dbo.SOP10102.DEBITAMT, OMNI.dbo.SOP10102.ORDBTAMT, OMNI.dbo.SOP10102.CRDTAMNT, 
                      OMNI.dbo.SOP10102.ORCRDAMT, LEFT(ISNULL(RTRIM(OMNI.dbo.GL00100.ACTNUMBR_1), '') 
                      + '-' + ISNULL(RTRIM(OMNI.dbo.GL00100.ACTNUMBR_2), '') + '-' + ISNULL(RTRIM(OMNI.dbo.GL00100.ACTNUMBR_3), '') 
                      + '-' + ISNULL(RTRIM(OMNI.dbo.GL00100.ACTNUMBR_4), '') + '-' + ISNULL(RTRIM(OMNI.dbo.GL00100.ACTNUMBR_5), ''), 13) AS ACTNUM
FROM         OMNI.dbo.SOP30200 INNER JOIN
                      OMNI.dbo.SOP10102 ON OMNI.dbo.SOP30200.SOPTYPE = OMNI.dbo.SOP10102.SOPTYPE AND 
                      OMNI.dbo.SOP30200.SOPNUMBE = OMNI.dbo.SOP10102.SOPNUMBE INNER JOIN
                      OMNI.dbo.GL00100 ON OMNI.dbo.SOP10102.ACTINDX = OMNI.dbo.GL00100.ACTINDX LEFT OUTER JOIN
                      OMNI.dbo.RM00101 ON OMNI.dbo.SOP30200.CUSTNMBR = OMNI.dbo.RM00101.CUSTNMBR
GROUP BY OMNI.dbo.SOP30200.SOPTYPE, OMNI.dbo.SOP30200.SOPNUMBE, OMNI.dbo.RM00101.CUSTNMBR, OMNI.dbo.RM00101.CUSTNAME, 
                      OMNI.dbo.RM00101.CUSTCLAS, OMNI.dbo.SOP30200.DOCID, OMNI.dbo.SOP30200.DOCDATE, OMNI.dbo.SOP30200.GLPOSTDT, 
                      OMNI.dbo.SOP30200.ORIGTYPE, OMNI.dbo.SOP30200.ORIGNUMB, OMNI.dbo.SOP30200.CSTPONBR, OMNI.dbo.SOP30200.DOCAMNT, 
                      OMNI.dbo.SOP10102.ACTINDX, OMNI.dbo.SOP10102.DEBITAMT, OMNI.dbo.SOP10102.ORDBTAMT, OMNI.dbo.SOP10102.CRDTAMNT, 
                      OMNI.dbo.SOP10102.ORCRDAMT, OMNI.dbo.GL00100.ACTNUMBR_1, OMNI.dbo.GL00100.ACTNUMBR_2, OMNI.dbo.GL00100.ACTNUMBR_3, 
                      OMNI.dbo.GL00100.ACTNUMBR_4, OMNI.dbo.GL00100.ACTNUMBR_5,OMNI.dbo.SOP30200.VOIDSTTS
HAVING      (OMNI.dbo.SOP30200.SOPTYPE IN (3,4)) and OMNI.dbo.SOP30200.VOIDSTTS in (0)
UNION
SELECT     'RVM' as COMPANY,RVM.dbo.SOP30200.SOPTYPE, RVM.dbo.SOP30200.SOPNUMBE, RVM.dbo.RM00101.CUSTNMBR, RVM.dbo.RM00101.CUSTNAME, 
                      RVM.dbo.RM00101.CUSTCLAS, RVM.dbo.SOP30200.DOCID, RVM.dbo.SOP30200.DOCDATE, RVM.dbo.SOP30200.GLPOSTDT, 
                      RVM.dbo.SOP30200.ORIGTYPE, RVM.dbo.SOP30200.ORIGNUMB, RVM.dbo.SOP30200.CSTPONBR, RVM.dbo.SOP30200.DOCAMNT, 
                      RVM.dbo.SOP10102.ACTINDX, RVM.dbo.SOP10102.DEBITAMT, RVM.dbo.SOP10102.ORDBTAMT, RVM.dbo.SOP10102.CRDTAMNT, 
                      RVM.dbo.SOP10102.ORCRDAMT, LEFT(ISNULL(RTRIM(RVM.dbo.GL00100.ACTNUMBR_1), '') 
                      + '-' + ISNULL(RTRIM(RVM.dbo.GL00100.ACTNUMBR_2), '') + '-' + ISNULL(RTRIM(RVM.dbo.GL00100.ACTNUMBR_3), '') 
                      + '-' + ISNULL(RTRIM(RVM.dbo.GL00100.ACTNUMBR_4), '') + '-' + ISNULL(RTRIM(RVM.dbo.GL00100.ACTNUMBR_5), ''), 13) AS ACTNUM
FROM         RVM.dbo.SOP30200 INNER JOIN
                      RVM.dbo.SOP10102 ON RVM.dbo.SOP30200.SOPTYPE = RVM.dbo.SOP10102.SOPTYPE AND 
                      RVM.dbo.SOP30200.SOPNUMBE = RVM.dbo.SOP10102.SOPNUMBE INNER JOIN
                      RVM.dbo.GL00100 ON RVM.dbo.SOP10102.ACTINDX = RVM.dbo.GL00100.ACTINDX LEFT OUTER JOIN
                      RVM.dbo.RM00101 ON RVM.dbo.SOP30200.CUSTNMBR = RVM.dbo.RM00101.CUSTNMBR
GROUP BY RVM.dbo.SOP30200.SOPTYPE, RVM.dbo.SOP30200.SOPNUMBE, RVM.dbo.RM00101.CUSTNMBR, RVM.dbo.RM00101.CUSTNAME, 
                      RVM.dbo.RM00101.CUSTCLAS, RVM.dbo.SOP30200.DOCID, RVM.dbo.SOP30200.DOCDATE, RVM.dbo.SOP30200.GLPOSTDT, 
                      RVM.dbo.SOP30200.ORIGTYPE, RVM.dbo.SOP30200.ORIGNUMB, RVM.dbo.SOP30200.CSTPONBR, RVM.dbo.SOP30200.DOCAMNT, 
                      RVM.dbo.SOP10102.ACTINDX, RVM.dbo.SOP10102.DEBITAMT, RVM.dbo.SOP10102.ORDBTAMT, RVM.dbo.SOP10102.CRDTAMNT, 
                      RVM.dbo.SOP10102.ORCRDAMT, RVM.dbo.GL00100.ACTNUMBR_1, RVM.dbo.GL00100.ACTNUMBR_2, RVM.dbo.GL00100.ACTNUMBR_3, 
                      RVM.dbo.GL00100.ACTNUMBR_4, RVM.dbo.GL00100.ACTNUMBR_5,RVM.dbo.SOP30200.VOIDSTTS
HAVING      (RVM.dbo.SOP30200.SOPTYPE IN (3,4)) and RVM.dbo.SOP30200.VOIDSTTS in (0)
UNION
SELECT     'NTLSV' AS COMPANY, NTLSV.dbo.SOP30200.SOPTYPE, NTLSV.dbo.SOP30200.SOPNUMBE, NTLSV.dbo.RM00101.CUSTNMBR, 
                      NTLSV.dbo.RM00101.CUSTNAME, NTLSV.dbo.RM00101.CUSTCLAS, NTLSV.dbo.SOP30200.DOCID, NTLSV.dbo.SOP30200.DOCDATE, 
                      NTLSV.dbo.SOP30200.GLPOSTDT, NTLSV.dbo.SOP30200.ORIGTYPE, NTLSV.dbo.SOP30200.ORIGNUMB, NTLSV.dbo.SOP30200.CSTPONBR, 
                      NTLSV.dbo.SOP30200.DOCAMNT, NTLSV.dbo.SOP10102.ACTINDX, NTLSV.dbo.SOP10102.DEBITAMT, NTLSV.dbo.SOP10102.ORDBTAMT, 
                      NTLSV.dbo.SOP10102.CRDTAMNT, NTLSV.dbo.SOP10102.ORCRDAMT, LEFT(ISNULL(RTRIM(NTLSV.dbo.GL00100.ACTNUMBR_1), '') 
                      + '-' + ISNULL(RTRIM(NTLSV.dbo.GL00100.ACTNUMBR_2), '') + '-' + ISNULL(RTRIM(NTLSV.dbo.GL00100.ACTNUMBR_3), '') 
                      + '-' + ISNULL(RTRIM(NTLSV.dbo.GL00100.ACTNUMBR_4), '') + '-' + ISNULL(RTRIM(NTLSV.dbo.GL00100.ACTNUMBR_5), ''), 13) AS ACTNUM
FROM         NTLSV.dbo.SOP30200 INNER JOIN
                      NTLSV.dbo.SOP10102 ON NTLSV.dbo.SOP30200.SOPTYPE = NTLSV.dbo.SOP10102.SOPTYPE AND 
                      NTLSV.dbo.SOP30200.SOPNUMBE = NTLSV.dbo.SOP10102.SOPNUMBE INNER JOIN
                      NTLSV.dbo.GL00100 ON NTLSV.dbo.SOP10102.ACTINDX = NTLSV.dbo.GL00100.ACTINDX LEFT OUTER JOIN
                      NTLSV.dbo.RM00101 ON NTLSV.dbo.SOP30200.CUSTNMBR = NTLSV.dbo.RM00101.CUSTNMBR
GROUP BY NTLSV.dbo.SOP30200.SOPTYPE, NTLSV.dbo.SOP30200.SOPNUMBE, NTLSV.dbo.RM00101.CUSTNMBR, NTLSV.dbo.RM00101.CUSTNAME, 
                      NTLSV.dbo.RM00101.CUSTCLAS, NTLSV.dbo.SOP30200.DOCID, NTLSV.dbo.SOP30200.DOCDATE, NTLSV.dbo.SOP30200.GLPOSTDT, 
                      NTLSV.dbo.SOP30200.ORIGTYPE, NTLSV.dbo.SOP30200.ORIGNUMB, NTLSV.dbo.SOP30200.CSTPONBR, NTLSV.dbo.SOP30200.DOCAMNT, 
                      NTLSV.dbo.SOP10102.ACTINDX, NTLSV.dbo.SOP10102.DEBITAMT, NTLSV.dbo.SOP10102.ORDBTAMT, NTLSV.dbo.SOP10102.CRDTAMNT, 
                      NTLSV.dbo.SOP10102.ORCRDAMT, NTLSV.dbo.GL00100.ACTNUMBR_1, NTLSV.dbo.GL00100.ACTNUMBR_2, NTLSV.dbo.GL00100.ACTNUMBR_3, 
                      NTLSV.dbo.GL00100.ACTNUMBR_4, NTLSV.dbo.GL00100.ACTNUMBR_5, NTLSV.dbo.SOP30200.VOIDSTTS
HAVING      (NTLSV.dbo.SOP30200.SOPTYPE IN (3, 4)) AND NTLSV.dbo.SOP30200.VOIDSTTS IN (0)
GO

CREATE VIEW [dbo].[GP_PHX_PAY_CODE_V]
AS
SELECT     *
FROM         PHX.dbo.UPR40600
WHERE     (PAYRCORD IN ('1', '2', '3', '4', '8', '16')) AND (INACTIVE = 0)
GO

CREATE  VIEW [dbo].[GP_IT_PAY_CODE_V]
AS
SELECT     *
FROM         IT.dbo.UPR40600
WHERE     (PAYRCORD IN ('1', '2', '3', '4', '8', '16')) AND (INACTIVE = 0)
GO

CREATE VIEW [dbo].[QUOTE_CONDITION_XJOIN]
AS
SELECT     dbo.QUOTES.QUOTE_ID, dbo.CONDITIONS.CONDITION_ID, dbo.CONDITIONS.NAME
FROM         dbo.CONDITIONS CROSS JOIN
                      dbo.QUOTES
GO

CREATE VIEW [dbo].[crystal_Job_Cost_V]
AS
SELECT     dbo.JOB_TIME_BY_EMP_V.ORGANIZATION_ID, dbo.JOB_TIME_BY_EMP_V.TC_JOB_NO, dbo.JOB_TIME_BY_EMP_V.JOB_NAME, 
                      dbo.JOB_TIME_BY_EMP_V.SERVICE_LINE_DATE, dbo.JOB_TIME_BY_EMP_V.resource_name, dbo.JOB_TIME_BY_EMP_V.EXT_EMPLOYEE_ID, 
                      dbo.JOB_TIME_BY_EMP_V.ITEM_NAME, dbo.JOB_TIME_BY_EMP_V.PAYROLL_QTY, dbo.JOB_TIME_BY_EMP_V.PAYROLL_RATE, 
                      dbo.JOB_TIME_BY_EMP_V.PAYROLL_TOTAL, AMBIM.dbo.UPR00400.PAYRTAMT, dbo.JOB_TIME_BY_EMP_V.SERVICE_LINE_ID, 
                      AMBIM.dbo.UPR00400.PAYRCORD
FROM         dbo.JOB_TIME_BY_EMP_V FULL OUTER JOIN
                      AMBIM.dbo.UPR00400 ON dbo.JOB_TIME_BY_EMP_V.EXT_EMPLOYEE_ID <= AMBIM.dbo.UPR00400.EMPLOYID
GO

CREATE VIEW [dbo].[REPORT_TO_TYPES_V]
AS
SELECT     TOP 100 PERCENT dbo.LOOKUPS.LOOKUP_ID, dbo.LOOKUPS.NAME, dbo.LOOKUPS.CODE, dbo.LOOKUPS.SEQUENCE_NO
FROM         dbo.LOOKUP_TYPES INNER JOIN
                      dbo.LOOKUPS ON dbo.LOOKUP_TYPES.LOOKUP_TYPE_ID = dbo.LOOKUPS.LOOKUP_TYPE_ID
WHERE     (dbo.LOOKUP_TYPES.CODE = 'report_type_type') AND (dbo.LOOKUPS.ACTIVE_FLAG <> 'N') AND (dbo.LOOKUP_TYPES.ACTIVE_FLAG <> 'N')
ORDER BY dbo.LOOKUPS.SEQUENCE_NO
GO

CREATE VIEW [dbo].[JOB_OWNER_IS_NULL_V]
AS
SELECT     JOB_ID, PROJECT_ID, JOB_NO, JOB_NAME, JOB_NO_NAME, JOB_TYPE_ID, JOB_STATUS_TYPE_ID, job_status_type_code, job_status_type_name, 
                      CUSTOMER_ID, ORGANIZATION_ID, DEALER_NAME, EXT_DEALER_ID, CUSTOMER_NAME, EXT_CUSTOMER_ID, foreman_resource_name, 
                      foreman_user_name, BILLING_USER_ID, billing_user_name, DATE_CREATED, DATE_MODIFIED
FROM         dbo.JOBS_V
WHERE     (BILLING_USER_ID IS NULL)
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

CREATE VIEW [dbo].[ROLES_V]
AS
SELECT     C_USER.FIRST_NAME + ' ' + C_USER.LAST_NAME AS created_by_name, M_USER.FIRST_NAME + ' ' + M_USER.LAST_NAME AS modified_by_name, 
                      dbo.ROLES.*
FROM         dbo.ROLES LEFT OUTER JOIN
                      dbo.USERS C_USER ON dbo.ROLES.CREATED_BY = C_USER.USER_ID LEFT OUTER JOIN
                      dbo.USERS M_USER ON dbo.ROLES.MODIFIED_BY = M_USER.USER_ID
GO

CREATE VIEW [dbo].[VERSIONS_MAX_NO_V]
AS
SELECT     dbo.PROJECTS.PROJECT_ID, dbo.PROJECTS.PROJECT_NO, dbo.REQUESTS.REQUEST_NO, MAX(dbo.REQUESTS.VERSION_NO) 
                      AS max_version_no
FROM         dbo.REQUESTS RIGHT OUTER JOIN
                      dbo.PROJECTS ON dbo.REQUESTS.PROJECT_ID = dbo.PROJECTS.PROJECT_ID
GROUP BY dbo.REQUESTS.REQUEST_NO, dbo.PROJECTS.PROJECT_ID, dbo.PROJECTS.PROJECT_NO
GO

CREATE VIEW [dbo].[SCHEDULE_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'schedule_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO

CREATE VIEW [dbo].[ICVERIFY_V]
AS
SELECT     JOB_ID, JOB_NO, CUSTOMER_NAME, INVOICE_ID, CAST(bill_total AS money) AS Bill_Total, CUST_COL_4
FROM         dbo.SERVICE_ACCOUNT_REPORT_TEMP
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

CREATE  VIEW [dbo].[GP_ICS_PAY_CODE_V]
AS
SELECT     *
FROM         ICS.dbo.UPR40600
WHERE     (PAYRCORD IN ('1', '2', '3', '4', '8', '16')) AND (INACTIVE = 0)
GO

CREATE  VIEW [dbo].[GP_MAD_PAY_CODE_V]
AS
SELECT     *
FROM         AMMAD.dbo.UPR40600
WHERE     (PAYRCORD IN ('1', '2', '3', '4', '8', '16')) AND (INACTIVE = 0)
GO

CREATE VIEW [dbo].[GP_ALABM_PAY_CODE_V]
AS
SELECT     *
FROM         ALABM.dbo.UPR40600
WHERE     (PAYRCORD IN ('1', '2', '3', '4', '8', '16')) AND (INACTIVE = 0)
GO

CREATE VIEW [dbo].[GP_MDWST_PAY_CODE_V]
AS
SELECT     *
FROM         MDWST.dbo.UPR40600
WHERE     (PAYRCORD IN ('1', '2', '3', '4', '8', '16')) AND (INACTIVE = 0)
GO

CREATE VIEW [dbo].[SERVICE_LINE_TYPES_V]
AS
SELECT     TOP 100 PERCENT dbo.LOOKUPS.LOOKUP_ID, dbo.LOOKUPS.CODE, dbo.LOOKUPS.NAME
FROM         dbo.LOOKUP_TYPES INNER JOIN
                      dbo.LOOKUPS ON dbo.LOOKUP_TYPES.LOOKUP_TYPE_ID = dbo.LOOKUPS.LOOKUP_TYPE_ID
WHERE     (dbo.LOOKUP_TYPES.CODE = 'service_line_type') AND (dbo.LOOKUPS.ACTIVE_FLAG <> 'N') AND (dbo.LOOKUP_TYPES.ACTIVE_FLAG <> 'N')
ORDER BY dbo.LOOKUPS.SEQUENCE_NO
GO

CREATE VIEW [dbo].[SERVICE_STATUS_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'service_status_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
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

CREATE VIEW [dbo].[SUB_ACTIVITY_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, lookup_date_created, 
                      lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'sub_activity_type')
GO

CREATE VIEW [dbo].[crystal_SYNCH_REPORT_V]
AS
SELECT     TOP 100 PERCENT FULL_NAME, IMOBILE_LOGIN, LAST_SYNCH_DATE, LAST_LOGIN AS LAST_SERVICETRAX_LOGIN
FROM         dbo.USERS
WHERE     (LAST_SYNCH_DATE IS NOT NULL) AND (ACTIVE_FLAG = 'Y') AND (IMOBILE_LOGIN IS NOT NULL)
ORDER BY FULL_NAME
GO

CREATE VIEW [dbo].[TABS_V]
AS
SELECT     dbo.TEMPLATES.TEMPLATE_NAME, dbo.TABS.NAME, dbo.TABS.SEQUENCE, dbo.TABS.TYPE_CODE, dbo.TABS.DEFAULT_TAB, 
                      dbo.TABS.TABLE_ID
FROM         dbo.TABS INNER JOIN
                      dbo.TEMPLATES ON dbo.TABS.TEMPLATE_ID = dbo.TEMPLATES.TEMPLATE_ID
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

CREATE VIEW [dbo].[PKT_REASONS_V]
AS
SELECT     dbo.LOOKUPS.LOOKUP_ID AS reason_id, SUBSTRING(dbo.LOOKUPS.NAME, 0, 20) AS reason
FROM         dbo.LOOKUPS INNER JOIN
                      dbo.LOOKUP_TYPES ON dbo.LOOKUPS.LOOKUP_TYPE_ID = dbo.LOOKUP_TYPES.LOOKUP_TYPE_ID
WHERE     (dbo.LOOKUP_TYPES.CODE = 'override_reason_type') AND (dbo.LOOKUP_TYPES.ACTIVE_FLAG = 'Y')
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

CREATE VIEW [dbo].[FAILED_INTEGRATIONS] AS

SELECT     INVOICES.INVOICE_ID, INVOICES.ORGANIZATION_ID, INVOICES.PO_NO, INVOICES.INVOICE_TYPE_ID, INVOICES.BILLING_TYPE_ID, 
                      INVOICES.EXT_BATCH_ID, INVOICES.BATCH_STATUS_ID, INVOICES.ASSIGNED_TO_USER_ID, INVOICES.INVOICE_FORMAT_TYPE_ID, 
                      INVOICES.EXT_INVOICE_ID, INVOICES.STATUS_ID, INVOICES.JOB_ID, INVOICES.DESCRIPTION, INVOICES.GP_DESCRIPTION, INVOICES.COST_CODES,
                       INVOICES.START_DATE, INVOICES.END_DATE, INVOICES.BILL_CUSTOMER_ID, INVOICES.EXT_BILL_CUST_ID, INVOICES.SALES_REPS, 
                      INVOICES.DATE_SENT, INVOICES.DATE_CREATED, INVOICES.CREATED_BY, INVOICES.DATE_MODIFIED, INVOICES.MODIFIED_BY,NAME
FROM         INVOICES 
inner join organizations on invoices.organization_id=organizations.organization_id
WHERE     (INVOICES.BATCH_STATUS_ID = '-1') AND cast(INVOICES.INVOICE_ID as varchar(10)) NOT IN (SELECT LEFT(SOPNUMBE,datalength(INVOICES.INVOICE_ID)) FROM AMBIM..SOP10200)
and cast(INVOICES.INVOICE_ID as varchar(10)) NOT IN (SELECT LEFT(SOPNUMBE,datalength(INVOICES.INVOICE_ID)) FROM AMBIM..SOP30200)
and INVOICES.ORGANIZATION_ID=2
OR
                      (dbo.INVOICES.BATCH_STATUS_ID = 1) AND (dbo.INVOICES.STATUS_ID = 4)
union all
SELECT     INVOICES.INVOICE_ID, INVOICES.ORGANIZATION_ID, INVOICES.PO_NO, INVOICES.INVOICE_TYPE_ID, INVOICES.BILLING_TYPE_ID, 
                      INVOICES.EXT_BATCH_ID, INVOICES.BATCH_STATUS_ID, INVOICES.ASSIGNED_TO_USER_ID, INVOICES.INVOICE_FORMAT_TYPE_ID, 
                      INVOICES.EXT_INVOICE_ID, INVOICES.STATUS_ID, INVOICES.JOB_ID, INVOICES.DESCRIPTION, INVOICES.GP_DESCRIPTION, INVOICES.COST_CODES,
                       INVOICES.START_DATE, INVOICES.END_DATE, INVOICES.BILL_CUSTOMER_ID, INVOICES.EXT_BILL_CUST_ID, INVOICES.SALES_REPS, 
                      INVOICES.DATE_SENT, INVOICES.DATE_CREATED, INVOICES.CREATED_BY, INVOICES.DATE_MODIFIED, INVOICES.MODIFIED_BY,NAME
FROM         INVOICES 
inner join organizations on invoices.organization_id=organizations.organization_id
WHERE     (INVOICES.BATCH_STATUS_ID = '-1') AND cast(INVOICES.INVOICE_ID as varchar(10)) NOT IN (SELECT LEFT(SOPNUMBE,datalength(INVOICES.INVOICE_ID)) FROM AMMAD..SOP10200)
and cast(INVOICES.INVOICE_ID as varchar(10)) NOT IN (SELECT LEFT(SOPNUMBE,datalength(INVOICES.INVOICE_ID)) FROM AMMAD..SOP30200)
and INVOICES.ORGANIZATION_ID=4
OR
                      (dbo.INVOICES.BATCH_STATUS_ID = 1)  AND (dbo.INVOICES.STATUS_ID = 4)
union all
SELECT     INVOICES.INVOICE_ID, INVOICES.ORGANIZATION_ID, INVOICES.PO_NO, INVOICES.INVOICE_TYPE_ID, INVOICES.BILLING_TYPE_ID, 
                      INVOICES.EXT_BATCH_ID, INVOICES.BATCH_STATUS_ID, INVOICES.ASSIGNED_TO_USER_ID, INVOICES.INVOICE_FORMAT_TYPE_ID, 
                      INVOICES.EXT_INVOICE_ID, INVOICES.STATUS_ID, INVOICES.JOB_ID, INVOICES.DESCRIPTION, INVOICES.GP_DESCRIPTION, INVOICES.COST_CODES,
                       INVOICES.START_DATE, INVOICES.END_DATE, INVOICES.BILL_CUSTOMER_ID, INVOICES.EXT_BILL_CUST_ID, INVOICES.SALES_REPS, 
                      INVOICES.DATE_SENT, INVOICES.DATE_CREATED, INVOICES.CREATED_BY, INVOICES.DATE_MODIFIED, INVOICES.MODIFIED_BY,NAME
FROM         INVOICES 
inner join organizations on invoices.organization_id=organizations.organization_id
WHERE     (INVOICES.BATCH_STATUS_ID = '-1') AND cast(INVOICES.INVOICE_ID as varchar(10)) NOT IN (SELECT LEFT(SOPNUMBE,datalength(INVOICES.INVOICE_ID)) FROM AIA..SOP10200)
and cast(INVOICES.INVOICE_ID as varchar(10)) NOT IN (SELECT LEFT(SOPNUMBE,datalength(INVOICES.INVOICE_ID)) FROM AIA..SOP30200)
and INVOICES.ORGANIZATION_ID=8
OR
                      (dbo.INVOICES.BATCH_STATUS_ID = 1)  AND (dbo.INVOICES.STATUS_ID = 4)
union all
SELECT     INVOICES.INVOICE_ID, INVOICES.ORGANIZATION_ID, INVOICES.PO_NO, INVOICES.INVOICE_TYPE_ID, INVOICES.BILLING_TYPE_ID, 
                      INVOICES.EXT_BATCH_ID, INVOICES.BATCH_STATUS_ID, INVOICES.ASSIGNED_TO_USER_ID, INVOICES.INVOICE_FORMAT_TYPE_ID, 
                      INVOICES.EXT_INVOICE_ID, INVOICES.STATUS_ID, INVOICES.JOB_ID, INVOICES.DESCRIPTION, INVOICES.GP_DESCRIPTION, INVOICES.COST_CODES,
                       INVOICES.START_DATE, INVOICES.END_DATE, INVOICES.BILL_CUSTOMER_ID, INVOICES.EXT_BILL_CUST_ID, INVOICES.SALES_REPS, 
                      INVOICES.DATE_SENT, INVOICES.DATE_CREATED, INVOICES.CREATED_BY, INVOICES.DATE_MODIFIED, INVOICES.MODIFIED_BY,NAME
FROM         INVOICES 
inner join organizations on invoices.organization_id=organizations.organization_id
WHERE     (INVOICES.BATCH_STATUS_ID = '-1') AND cast(INVOICES.INVOICE_ID as varchar(10)) NOT IN (SELECT LEFT(SOPNUMBE,datalength(INVOICES.INVOICE_ID)) FROM CIINC..SOP10200)
and cast(INVOICES.INVOICE_ID as varchar(10)) NOT IN (SELECT LEFT(SOPNUMBE,datalength(INVOICES.INVOICE_ID)) FROM CIINC..SOP30200)
and INVOICES.ORGANIZATION_ID=10
OR
                      (dbo.INVOICES.BATCH_STATUS_ID = 1)  AND (dbo.INVOICES.STATUS_ID = 4)
union all
SELECT     INVOICES.INVOICE_ID, INVOICES.ORGANIZATION_ID, INVOICES.PO_NO, INVOICES.INVOICE_TYPE_ID, INVOICES.BILLING_TYPE_ID, 
                      INVOICES.EXT_BATCH_ID, INVOICES.BATCH_STATUS_ID, INVOICES.ASSIGNED_TO_USER_ID, INVOICES.INVOICE_FORMAT_TYPE_ID, 
                      INVOICES.EXT_INVOICE_ID, INVOICES.STATUS_ID, INVOICES.JOB_ID, INVOICES.DESCRIPTION, INVOICES.GP_DESCRIPTION, INVOICES.COST_CODES,
                       INVOICES.START_DATE, INVOICES.END_DATE, INVOICES.BILL_CUSTOMER_ID, INVOICES.EXT_BILL_CUST_ID, INVOICES.SALES_REPS, 
                      INVOICES.DATE_SENT, INVOICES.DATE_CREATED, INVOICES.CREATED_BY, INVOICES.DATE_MODIFIED, INVOICES.MODIFIED_BY,NAME
FROM         INVOICES 
inner join organizations on invoices.organization_id=organizations.organization_id
WHERE     (INVOICES.BATCH_STATUS_ID = '-1') AND cast(INVOICES.INVOICE_ID as varchar(10)) NOT IN (SELECT LEFT(SOPNUMBE,datalength(INVOICES.INVOICE_ID)) FROM CILLC..SOP10200)
and cast(INVOICES.INVOICE_ID as varchar(10)) NOT IN (SELECT LEFT(SOPNUMBE,datalength(INVOICES.INVOICE_ID)) FROM CILLC..SOP30200)
and INVOICES.ORGANIZATION_ID=11
OR
                      (dbo.INVOICES.BATCH_STATUS_ID = 1)  AND (dbo.INVOICES.STATUS_ID = 4)
union all
SELECT     INVOICES.INVOICE_ID, INVOICES.ORGANIZATION_ID, INVOICES.PO_NO, INVOICES.INVOICE_TYPE_ID, INVOICES.BILLING_TYPE_ID, 
                      INVOICES.EXT_BATCH_ID, INVOICES.BATCH_STATUS_ID, INVOICES.ASSIGNED_TO_USER_ID, INVOICES.INVOICE_FORMAT_TYPE_ID, 
                      INVOICES.EXT_INVOICE_ID, INVOICES.STATUS_ID, INVOICES.JOB_ID, INVOICES.DESCRIPTION, INVOICES.GP_DESCRIPTION, INVOICES.COST_CODES,
                       INVOICES.START_DATE, INVOICES.END_DATE, INVOICES.BILL_CUSTOMER_ID, INVOICES.EXT_BILL_CUST_ID, INVOICES.SALES_REPS, 
                      INVOICES.DATE_SENT, INVOICES.DATE_CREATED, INVOICES.CREATED_BY, INVOICES.DATE_MODIFIED, INVOICES.MODIFIED_BY,NAME
FROM         INVOICES 
inner join organizations on invoices.organization_id=organizations.organization_id
WHERE     (INVOICES.BATCH_STATUS_ID = '-1') AND cast(INVOICES.INVOICE_ID as varchar(10)) NOT IN (SELECT LEFT(SOPNUMBE,datalength(INVOICES.INVOICE_ID)) FROM ICS..SOP10200)
and cast(INVOICES.INVOICE_ID as varchar(10)) NOT IN (SELECT LEFT(SOPNUMBE,datalength(INVOICES.INVOICE_ID)) FROM ICS..SOP30200)
and INVOICES.ORGANIZATION_ID=12
OR
                      (dbo.INVOICES.BATCH_STATUS_ID = 1)  AND (dbo.INVOICES.STATUS_ID = 4)
union all
SELECT     INVOICES.INVOICE_ID, INVOICES.ORGANIZATION_ID, INVOICES.PO_NO, INVOICES.INVOICE_TYPE_ID, INVOICES.BILLING_TYPE_ID, 
                      INVOICES.EXT_BATCH_ID, INVOICES.BATCH_STATUS_ID, INVOICES.ASSIGNED_TO_USER_ID, INVOICES.INVOICE_FORMAT_TYPE_ID, 
                      INVOICES.EXT_INVOICE_ID, INVOICES.STATUS_ID, INVOICES.JOB_ID, INVOICES.DESCRIPTION, INVOICES.GP_DESCRIPTION, INVOICES.COST_CODES,
                       INVOICES.START_DATE, INVOICES.END_DATE, INVOICES.BILL_CUSTOMER_ID, INVOICES.EXT_BILL_CUST_ID, INVOICES.SALES_REPS, 
                      INVOICES.DATE_SENT, INVOICES.DATE_CREATED, INVOICES.CREATED_BY, INVOICES.DATE_MODIFIED, INVOICES.MODIFIED_BY,NAME
FROM         INVOICES 
inner join organizations on invoices.organization_id=organizations.organization_id
WHERE     (INVOICES.BATCH_STATUS_ID = '-1') AND cast(INVOICES.INVOICE_ID as varchar(10)) NOT IN (SELECT LEFT(SOPNUMBE,datalength(INVOICES.INVOICE_ID)) FROM ECMS..SOP10200)
and cast(INVOICES.INVOICE_ID as varchar(10)) NOT IN (SELECT LEFT(SOPNUMBE,datalength(INVOICES.INVOICE_ID)) FROM ECMS..SOP30200)
and INVOICES.ORGANIZATION_ID=14
OR
                      (dbo.INVOICES.BATCH_STATUS_ID = 1)  AND (dbo.INVOICES.STATUS_ID = 4)
union all

SELECT     INVOICES.INVOICE_ID, INVOICES.ORGANIZATION_ID, INVOICES.PO_NO, INVOICES.INVOICE_TYPE_ID, INVOICES.BILLING_TYPE_ID, 
                      INVOICES.EXT_BATCH_ID, INVOICES.BATCH_STATUS_ID, INVOICES.ASSIGNED_TO_USER_ID, INVOICES.INVOICE_FORMAT_TYPE_ID, 
                      INVOICES.EXT_INVOICE_ID, INVOICES.STATUS_ID, INVOICES.JOB_ID, INVOICES.DESCRIPTION, INVOICES.GP_DESCRIPTION, INVOICES.COST_CODES,
                       INVOICES.START_DATE, INVOICES.END_DATE, INVOICES.BILL_CUSTOMER_ID, INVOICES.EXT_BILL_CUST_ID, INVOICES.SALES_REPS, 
                      INVOICES.DATE_SENT, INVOICES.DATE_CREATED, INVOICES.CREATED_BY, INVOICES.DATE_MODIFIED, INVOICES.MODIFIED_BY,NAME
FROM         INVOICES 
inner join organizations on invoices.organization_id=organizations.organization_id
WHERE     (INVOICES.BATCH_STATUS_ID = '-1') AND cast(INVOICES.INVOICE_ID as varchar(10)) NOT IN (SELECT LEFT(SOPNUMBE,datalength(INVOICES.INVOICE_ID)) FROM CIMN..SOP10200)
and cast(INVOICES.INVOICE_ID as varchar(10)) NOT IN (SELECT LEFT(SOPNUMBE,datalength(INVOICES.INVOICE_ID)) FROM CIMN..SOP30200)
and INVOICES.ORGANIZATION_ID=15
OR
                      (dbo.INVOICES.BATCH_STATUS_ID = 1) AND (dbo.INVOICES.STATUS_ID = 4)
GO

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

CREATE VIEW [dbo].[crystal_VAR_JOB_INVOICED_V]
AS
SELECT     TOP 100 PERCENT dbo.JOBS.JOB_ID, SUM(ISNULL(dbo.INVOICE_LINES.UNIT_PRICE, 0) * ISNULL(dbo.INVOICE_LINES.QTY, 0)) AS sum_inv, 
                      MIN(CAST(dbo.INVOICES.DATE_SENT AS datetime)) AS min_date_sent, MAX(dbo.INVOICES.DATE_SENT) AS max_date_sent, 
                      dbo.INVOICES.INVOICE_ID
FROM         dbo.JOBS RIGHT OUTER JOIN
                      dbo.INVOICE_LINES RIGHT OUTER JOIN
                      dbo.INVOICES ON dbo.INVOICE_LINES.INVOICE_ID = dbo.INVOICES.INVOICE_ID ON dbo.JOBS.JOB_ID = dbo.INVOICES.JOB_ID
WHERE     (dbo.INVOICES.STATUS_ID > 3)
GROUP BY dbo.JOBS.JOB_ID, dbo.INVOICES.INVOICE_ID
HAVING      (SUM(ISNULL(dbo.INVOICE_LINES.UNIT_PRICE, 0) * ISNULL(dbo.INVOICE_LINES.QTY, 0)) > 0)
ORDER BY dbo.JOBS.JOB_ID
GO

CREATE VIEW [dbo].[contains_invoice_tracking_v]
AS
SELECT i.invoice_id, 
       CASE inv_tracking.trk WHEN '*' THEN '*' ELSE '' END AS contains_tracking
  FROM dbo.INVOICES i LEFT OUTER JOIN
       (SELECT DISTINCT invoice_id, '*' trk
          FROM invoice_tracking) inv_tracking ON i.invoice_id = inv_tracking.invoice_id
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

CREATE VIEW [dbo].[INVOICE_JOB_LOCATIONS_V]
AS
SELECT     *, '' AS Addr1, '' AS Addr2, '' AS Addr3, '' AS City, '' AS State, '' AS Zip
FROM         dbo.INVOICES
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

CREATE VIEW [dbo].[invoices_arch]
AS
SELECT     INVOICE_ID, ORGANIZATION_ID, PO_NO, INVOICE_TYPE_ID, BILLING_TYPE_ID, EXT_BATCH_ID, BATCH_STATUS_ID, ASSIGNED_TO_USER_ID, 
                      INVOICE_FORMAT_TYPE_ID, EXT_INVOICE_ID, STATUS_ID, JOB_ID, DESCRIPTION, GP_DESCRIPTION, COST_CODES, START_DATE, END_DATE, 
                      BILL_CUSTOMER_ID, EXT_BILL_CUST_ID, SALES_REPS, DATE_SENT, DATE_CREATED, CREATED_BY, DATE_MODIFIED, MODIFIED_BY
FROM         dbo.INVOICES
WHERE     (BATCH_STATUS_ID = 3) AND (DATE_MODIFIED < CONVERT(DATETIME, '2002-09-01 00:00:00', 102))
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

CREATE VIEW [dbo].[crystal_QUOTES_OTHER_SERVICE_V]
AS
SELECT     QUOTE_ID, SPECIFY_SERVICE, BILL, DATE_CREATED
FROM         dbo.QUOTE_SPECIFY_OTHER_SERVICES
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

CREATE VIEW [dbo].[TEMPLATE_LOCATIONS_3_V]
AS
SELECT     dbo.TEMPLATE_LOCATIONS.LOCATION, TEMPLATES_1.TEMPLATE_NAME, TEMPLATES1.TEMPLATE_NAME AS TAB_NAME
FROM         dbo.TABS INNER JOIN
                      dbo.TEMPLATES TEMPLATES1 ON dbo.TABS.TEMPLATE_ID = TEMPLATES1.TEMPLATE_ID INNER JOIN
                      dbo.TEMPLATES TEMPLATES_1 INNER JOIN
                      dbo.TEMPLATE_LOCATIONS ON TEMPLATES_1.TEMPLATE_ID = dbo.TEMPLATE_LOCATIONS.LEVEL_3_TEMPLATE ON 
                      dbo.TABS.TAB_ID = dbo.TEMPLATE_LOCATIONS.LEVEL_3_TAB
 WHERE (dbo.TABS.TYPE_CODE = 'SERVICE')
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

CREATE VIEW [dbo].[UNBILLED_DATA_DAILY_CAPTURE_V]
AS
SELECT     RECORDID, ORGANIZATION_ID, BILL_JOB_NO, job_status_type_name, job_name, BILLING_USER_ID, EXT_DEALER_ID, DEALER_NAME, 
                      CUSTOMER_NAME, job_owner, max_est_end_date, max_est_end_date_varchar, billable_total, non_billable_total, PO_NO, PooledTotal, 
                      UnbilledOpsInvoicesTotal, NAME, DATEREPORTRUN
FROM         dbo.UNBILLED_REPORT_DAILYDATACAPTURE
WHERE     (ORGANIZATION_ID = 11) AND (DATEREPORTRUN > CONVERT(DATETIME, '2007-12-01 00:00:00', 102))
GO

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

CREATE VIEW [dbo].[crystal_QUOTES_OTHER_FURN_V]
AS
SELECT     QUOTE_ID, DESCRIPTION, BILL, DATE_CREATED
FROM         dbo.QUOTE_OTHER_FURNITURE_AD_HOC
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

CREATE VIEW [dbo].[VAR_JOB_ACT_HOURS_V]
AS
SELECT     dbo.JOBS.JOB_ID, SUM(ISNULL(dbo.SERVICE_LINES.PAYROLL_QTY, 0)) AS sum_payroll_qty, SUM(ISNULL(dbo.SERVICE_LINES.EXPENSE_QTY, 0)) 
                      AS sum_expense_qty
FROM         dbo.SERVICES LEFT OUTER JOIN
                      dbo.JOBS ON dbo.SERVICES.JOB_ID = dbo.JOBS.JOB_ID LEFT OUTER JOIN
                      dbo.SERVICE_LINES ON dbo.SERVICES.SERVICE_ID = dbo.SERVICE_LINES.TC_SERVICE_ID
GROUP BY dbo.JOBS.JOB_ID
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

CREATE VIEW [dbo].[TC_VERIFIED_V]
AS
SELECT     ORGANIZATION_ID, SERVICE_LINE_ID, TC_JOB_NO, TC_SERVICE_NO, TC_SERVICE_LINE_NO, SERVICE_LINE_DATE, STATUS_ID, TC_JOB_ID, 
                      TC_SERVICE_ID, RESOURCE_ID, RESOURCE_NAME, ITEM_ID, ITEM_NAME, TC_QTY, TC_RATE, TC_TOTAL, PALM_REP_ID, ENTERED_DATE, 
                      ENTERED_BY, ENTRY_METHOD, VERIFIED_DATE, VERIFIED_BY, DATE_CREATED, CREATED_BY, DATE_MODIFIED, MODIFIED_BY
FROM         dbo.SERVICE_LINES
WHERE     (VERIFIED_BY IS NULL) AND (DATE_CREATED > CONVERT(DATETIME, '2004-01-01 00:00:00', 102))
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

CREATE VIEW [dbo].[crystal_SCH_ACT_2_V]
AS
SELECT     TC_JOB_NO, TC_SERVICE_NO, SERVICE_LINE_DATE, RESOURCE_ID, RESOURCE_NAME, ITEM_NAME, TC_QTY, OVERRIDE_DATE, VERIFIED_DATE, 
                      VERIFIED_BY, SERVICE_LINE_ID, TC_SERVICE_ID
FROM         dbo.SERVICE_LINES
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

CREATE VIEW [dbo].[crystal_TIME_CAPTURE_V]
AS
SELECT     dbo.SERVICE_LINES.ORGANIZATION_ID, dbo.SERVICE_LINES.TC_JOB_NO, dbo.SERVICE_LINES.TC_SERVICE_NO, 
                      dbo.SERVICE_LINES.TC_SERVICE_LINE_NO, dbo.SERVICE_LINES.BILL_JOB_NO, dbo.SERVICE_LINES.BILL_SERVICE_NO, 
                      dbo.SERVICE_LINES.BILL_SERVICE_LINE_NO, dbo.JOBS_V.JOB_NAME, dbo.SERVICE_LINES.RESOURCE_NAME, dbo.SERVICE_LINES.ITEM_NAME, 
                      dbo.JOBS_V.billing_user_name, dbo.JOBS_V.foreman_resource_name, dbo.SERVICE_LINES.TC_JOB_ID, dbo.SERVICE_LINES.TC_SERVICE_ID, 
                      dbo.SERVICE_LINES.BILL_JOB_ID, dbo.SERVICE_LINES.BILL_SERVICE_ID, dbo.SERVICE_LINES.PH_SERVICE_ID, 
                      dbo.SERVICE_LINES.SERVICE_LINE_ID, CAST(dbo.SERVICES.JOB_ID AS varchar) + '-' + CAST(dbo.SERVICE_LINES.ITEM_ID AS varchar) 
                      + '-' + CAST(dbo.SERVICE_LINES.STATUS_ID AS varchar) AS job_item_status_id, CAST(dbo.SERVICE_LINES.TC_SERVICE_ID AS varchar) 
                      + '-' + CAST(dbo.SERVICE_LINES.STATUS_ID AS varchar) AS service_status_id, CAST(dbo.SERVICES.SERVICE_ID AS varchar) 
                      + '-' + CAST(dbo.SERVICE_LINES.ITEM_ID AS varchar) + '-' + CAST(dbo.SERVICE_LINES.STATUS_ID AS varchar) AS service_item_status_id, 
                      dbo.JOBS_V.BILLING_USER_ID, dbo.JOBS_V.foreman_user_id, CAST(dbo.SERVICE_LINES.SERVICE_LINE_DATE AS datetime) 
                      AS SERVICE_LINE_DATE, dbo.SERVICE_LINES.SERVICE_LINE_DATE_VARCHAR, CAST(dbo.SERVICE_LINES.SERVICE_LINE_WEEK AS DATETIME) 
                      AS SERVICE_LINE_WEEK, dbo.SERVICE_LINES.SERVICE_LINE_WEEK_VARCHAR, dbo.JOBS_V.job_status_type_code, 
                      dbo.JOBS_V.job_status_type_name, SERV_STATUS_TYPES.CODE AS serv_status_type_code, 
                      SERV_STATUS_TYPES.NAME AS serv_status_type_name, dbo.SERVICE_LINES.STATUS_ID, dbo.SERVICE_LINE_STATUSES.NAME AS status_name, 
                      dbo.SERVICE_LINES.EXPORTED_FLAG, dbo.SERVICE_LINES.BILLED_FLAG, dbo.SERVICE_LINES.POSTED_FLAG, 
                      dbo.SERVICE_LINES.POOLED_FLAG, dbo.SERVICE_LINES.RESOURCE_ID, dbo.SERVICE_LINES.ITEM_ID, dbo.SERVICE_LINES.ITEM_TYPE_CODE, 
                      dbo.SERVICE_LINES.BILLABLE_FLAG, dbo.SERVICE_LINES.TC_QTY, dbo.SERVICE_LINES.TC_RATE, dbo.SERVICE_LINES.TC_TOTAL, 
                      dbo.SERVICE_LINES.PAYROLL_QTY, dbo.SERVICE_LINES.PAYROLL_RATE, dbo.SERVICE_LINES.PAYROLL_TOTAL, 
                      dbo.SERVICE_LINES.EXT_PAY_CODE, dbo.SERVICE_LINES.EXPENSE_QTY, dbo.SERVICE_LINES.EXPENSE_RATE, 
                      dbo.SERVICE_LINES.EXPENSE_TOTAL, dbo.SERVICE_LINES.BILL_QTY, dbo.SERVICE_LINES.BILL_RATE, dbo.SERVICE_LINES.BILL_TOTAL, 
                      dbo.SERVICE_LINES.BILL_EXP_QTY, dbo.SERVICE_LINES.BILL_EXP_RATE, dbo.SERVICE_LINES.BILL_EXP_TOTAL, 
                      dbo.SERVICE_LINES.BILL_HOURLY_QTY, dbo.SERVICE_LINES.BILL_HOURLY_RATE, dbo.SERVICE_LINES.BILL_HOURLY_TOTAL, 
                      dbo.SERVICE_LINES.ALLOCATED_QTY, dbo.SERVICE_LINES.INTERNAL_REQ_FLAG, dbo.SERVICE_LINES.PARTIALLY_ALLOCATED_FLAG, 
                      dbo.SERVICE_LINES.FULLY_ALLOCATED_FLAG, dbo.SERVICE_LINES.PALM_REP_ID, CAST(dbo.SERVICE_LINES.ENTERED_DATE AS SMALLDATETIME(10)) AS DATE_ENTERED, 
                      dbo.SERVICE_LINES.ENTERED_BY, USERS_1.FULL_NAME AS entered_by_name, dbo.SERVICE_LINES.ENTRY_METHOD, 
                      dbo.SERVICE_LINES.OVERRIDE_DATE, dbo.SERVICE_LINES.OVERRIDE_BY, USERS_1.FULL_NAME AS override_by_name, 
                      dbo.SERVICE_LINES.OVERRIDE_REASON, dbo.SERVICE_LINES.VERIFIED_DATE, dbo.SERVICE_LINES.VERIFIED_BY, 
                      USERS_2.FULL_NAME AS verified_by_name, dbo.SERVICES.DESCRIPTION AS service_description, 
                      Convert(varchar, dbo.SERVICE_LINES.DATE_CREATED,101) as DATE_CREATED , dbo.SERVICE_LINES.CREATED_BY, 
                      USERS_3.FULL_NAME AS created_by_name, dbo.SERVICE_LINES.DATE_MODIFIED, dbo.SERVICE_LINES.MODIFIED_BY, 
                      USERS_4.FULL_NAME AS modified_by_name
FROM         dbo.LOOKUPS SERV_STATUS_TYPES RIGHT OUTER JOIN
                      dbo.JOBS_V RIGHT OUTER JOIN
                      dbo.SERVICES ON dbo.JOBS_V.JOB_ID = dbo.SERVICES.JOB_ID ON 
                      SERV_STATUS_TYPES.LOOKUP_ID = dbo.SERVICES.SERV_STATUS_TYPE_ID RIGHT OUTER JOIN
                      dbo.SERVICE_LINE_STATUSES RIGHT OUTER JOIN
                      dbo.USERS USERS_4 RIGHT OUTER JOIN
                      dbo.USERS USERS_5 RIGHT OUTER JOIN
                      dbo.USERS USERS_1 RIGHT OUTER JOIN
                      dbo.SERVICE_LINES ON USERS_1.USER_ID = dbo.SERVICE_LINES.OVERRIDE_BY ON 
                      USERS_5.USER_ID = dbo.SERVICE_LINES.ENTERED_BY LEFT OUTER JOIN
                      dbo.USERS USERS_2 ON dbo.SERVICE_LINES.VERIFIED_BY = USERS_2.USER_ID ON 
                      USERS_4.USER_ID = dbo.SERVICE_LINES.MODIFIED_BY LEFT OUTER JOIN
                      dbo.USERS USERS_3 ON dbo.SERVICE_LINES.CREATED_BY = USERS_3.USER_ID ON 
                      dbo.SERVICE_LINE_STATUSES.STATUS_ID = dbo.SERVICE_LINES.STATUS_ID ON 
                      dbo.SERVICES.SERVICE_ID = dbo.SERVICE_LINES.TC_SERVICE_ID
WHERE     (dbo.SERVICE_LINES.RESOURCE_NAME IS NOT NULL)
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

CREATE VIEW [dbo].[VAR_JOB_TIME_EXP_V]
AS
SELECT     TC_JOB_ID AS job_id, ISNULL(SUM(TC_QTY * TC_RATE), 0) AS sum_time_exp, ISNULL(SUM(PAYROLL_QTY * TC_RATE), 0) AS sum_time, 
                      ISNULL(SUM(EXPENSE_QTY * TC_RATE), 0) AS sum_exp
FROM         dbo.SERVICE_LINES
WHERE     (PH_SERVICE_ID IS NULL)
GROUP BY TC_JOB_ID
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

CREATE VIEW [dbo].[ITEMS_USAGE_V]
AS
SELECT     TOP 100 PERCENT ORGANIZATION_ID, TC_JOB_NO, TC_SERVICE_NO, TC_SERVICE_LINE_NO, SERVICE_LINE_DATE, STATUS_ID, RESOURCE_NAME,
                       ITEM_ID, ITEM_NAME, ITEM_TYPE_CODE, TC_QTY, EXPENSE_QTY, BILL_QTY, BILL_HOURLY_QTY, BILL_EXP_QTY, bill_hourly_total, 
                      bill_exp_total
FROM         dbo.SERVICE_LINES
ORDER BY ITEM_NAME
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

CREATE VIEW [dbo].[Expense_Report_for_Sandy]
AS
SELECT     ORGANIZATION_ID, SERVICE_LINE_ID, TC_JOB_NO, TC_SERVICE_NO, TC_SERVICE_LINE_NO, SERVICE_LINE_DATE, STATUS_ID, RESOURCE_NAME,
                       ITEM_NAME, ITEM_TYPE_CODE, TAXABLE_FLAG, BILLABLE_FLAG, EXPENSE_QTY, EXPENSE_RATE, EXPENSE_TOTAL
FROM         dbo.SERVICE_LINES
WHERE     (ITEM_TYPE_CODE = 'expense') AND (ORGANIZATION_ID = 2) AND (SERVICE_LINE_DATE >= CONVERT(DATETIME, '2005-09-18 00:00:00', 102))
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

CREATE VIEW [dbo].[QUICK_REQUEST_VENDORS_HELPER_V] as
SELECT     REQUEST_ID, COUNT(REQUEST_VENDOR_ID) AS VENDOR_COUNT, MIN(SCH_START_DATE) AS MIN_SCH_START_DATE, MIN(ACT_START_DATE) 
                      AS MIN_ACT_START_DATE, MAX(SCH_START_DATE) AS MAX_SCH_START_DATE, MAX(ACT_END_DATE) AS MAX_ACT_END_DATE, 
                      ISNULL(COUNT(CASE WHEN COMPLETE_FLAG = 'y' THEN 1 ELSE 0 END),0) AS VENDOR_COMPLETE_COUNT, 
                      ISNULL(COUNT(CASE WHEN invoiced_FLAG = 'y' THEN 1 ELSE 0 END),0) AS VENDOR_INVOICED_COUNT
FROM         dbo.REQUEST_VENDORS
GROUP BY REQUEST_ID
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

CREATE VIEW [dbo].[tcn_resources_v]
AS
SELECT     dbo.USERS.EXT_EMPLOYEE_ID AS employee_no, dbo.RESOURCES.NAME AS resource_name, dbo.RESOURCES.RESOURCE_ID, 
                      dbo.RESOURCES.ORGANIZATION_ID
FROM         dbo.USERS INNER JOIN
                      dbo.RESOURCES ON dbo.USERS.USER_ID = dbo.RESOURCES.USER_ID
WHERE     (dbo.RESOURCES.ACTIVE_FLAG = 'Y')
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

CREATE VIEW [dbo].[ACTIVE_USERS_COUNT_V]
AS
SELECT     USER_ID, CONTACT_ID, EMPLOYMENT_TYPE_ID, EXT_DEALER_ID, DEALER_NAME, CUSTOMER_ID, USER_TYPE_ID, FIRST_NAME, LAST_NAME, 
                      LOGIN, LAST_LOGIN, ACTIVE_FLAG, FULL_NAME
FROM         dbo.USERS
WHERE     (ACTIVE_FLAG = 'y') AND (LAST_LOGIN > CONVERT(DATETIME, '2004-01-01 00:00:00', 102))
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

CREATE VIEW [dbo].[USER_CONTACTS_V]
AS
SELECT     dbo.USERS.USER_ID, dbo.USERS.FIRST_NAME, dbo.USERS.LAST_NAME, dbo.USERS.ACTIVE_FLAG, dbo.CONTACTS.EMAIL, 
                      dbo.CONTACTS.ORGANIZATION_ID
FROM         dbo.USERS INNER JOIN
                      dbo.CONTACTS ON dbo.USERS.CONTACT_ID = dbo.CONTACTS.CONTACT_ID
WHERE     (dbo.USERS.ACTIVE_FLAG = 'y') AND (dbo.CONTACTS.EMAIL IS NOT NULL)
GO

CREATE VIEW [dbo].[pep_vendor_user_v]
AS
SELECT     TOP 100 PERCENT dbo.USERS.LAST_NAME, dbo.USERS.FULL_NAME, dbo.USERS.CUSTOMER_ID, dbo.USERS.VENDOR_CONTACT_ID, 
                      dbo.CUSTOMERS.CUSTOMER_NAME
FROM         dbo.USERS INNER JOIN
                      dbo.CUSTOMERS ON dbo.USERS.CUSTOMER_ID = dbo.CUSTOMERS.CUSTOMER_ID
ORDER BY dbo.USERS.LAST_NAME
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

CREATE VIEW [dbo].[USER_CUSTOMERS_V]
AS
SELECT     dbo.USER_CUSTOMERS.user_id, dbo.CUSTOMERS.CUSTOMER_ID
FROM         dbo.CUSTOMERS INNER JOIN
                      dbo.USER_CUSTOMERS ON dbo.CUSTOMERS.PARENT_CUSTOMER_ID = dbo.USER_CUSTOMERS.customer_id
UNION
SELECT     dbo.USER_CUSTOMERS.user_id, dbo.USER_CUSTOMERS.customer_id
FROM         dbo.USER_CUSTOMERS
GO

CREATE VIEW [dbo].[crystal_UNBILLED_OPS_AIA_V]
AS
SELECT     ORGANIZATION_ID, BILL_JOB_NO, BILL_JOB_ID, job_status_type_name, job_name, BILLING_USER_ID, EXT_DEALER_ID, DEALER_NAME, 
                      CUSTOMER_NAME, job_owner, max_est_end_date, max_est_end_date_varchar, billable_total, non_billable_total, PO_NO
FROM         dbo.crystal_UNBILLED_OPS_V
WHERE     (ORGANIZATION_ID = 8)
GO

CREATE VIEW [dbo].[SERVICE_LINE_PAYROLL_V]
AS
SELECT     dbo.CUSTOMERS.ORGANIZATION_ID, dbo.RESOURCES.RESOURCE_ID, dbo.SERVICES.JOB_ID, dbo.JOBS.JOB_NO, 
                      dbo.SERVICE_LINES.SERVICE_ID, dbo.SERVICES.SERVICE_NO, dbo.RESOURCES.NAME AS resource_name, 
                      dbo.RESOURCES.RES_CATEGORY_TYPE_ID, LOOKUPS_4.CODE AS res_cat_type_code, LOOKUPS_4.NAME AS res_cat_type_name, 
                      dbo.RESOURCES.RESOURCE_TYPE_ID, dbo.RESOURCES.USER_ID, dbo.RESOURCES.ACTIVE_FLAG, dbo.SERVICE_LINES.STATUS_ID, 
                      dbo.SERVICE_LINES.ITEM_ID, dbo.ITEMS.NAME AS item_name, dbo.SERVICE_LINES.EXT_PAY_CODE, LOOKUPS_3.CODE AS item_type_code, 
                      LOOKUPS_3.NAME AS item_type_name, dbo.RESOURCE_TYPES.CODE AS resource_type_code, 
                      dbo.RESOURCE_TYPES.NAME AS resource_type_name, dbo.SERVICE_LINES.QTY AS hours_qty, dbo.SERVICE_LINES.SERVICE_LINE_DATE, 
                      dbo.USERS.EXT_EMPLOYEE_ID, dbo.USERS.FIRST_NAME + ' ' + dbo.USERS.LAST_NAME AS employee_name, 
                      dbo.SERVICE_LINES.SERVICE_LINE_ID, dbo.SERVICE_LINES.SERVICE_LINE_NO, dbo.SERVICE_LINES.SERVICE_LINE_WEEK, 
                      dbo.PAYROLL_BATCHES.STATUS_ID AS batch_status_id, dbo.PAYROLL_BATCHES.INT_BATCH_ID, dbo.PAYROLL_BATCHES.EXT_BATCH_ID, 
                      dbo.PAYROLL_BATCHES.BEGIN_DATE, dbo.PAYROLL_BATCHES.END_DATE, dbo.PAYROLL_BATCH_STATUSES.CODE AS batch_status_code, 
                      dbo.PAYROLL_BATCH_STATUSES.NAME AS batch_status_name, dbo.JOBS.CUSTOMER_ID, dbo.ITEMS.EXT_ITEM_ID, CONVERT(varchar(12), 
                      dbo.PAYROLL_BATCHES.BEGIN_DATE, 101) AS begin_date_varchar, CONVERT(varchar(12), dbo.PAYROLL_BATCHES.END_DATE, 101) 
                      AS end_date_varchar, CONVERT(varchar(12), dbo.SERVICE_LINES.SERVICE_LINE_DATE, 101) AS service_line_date_varchar
FROM         dbo.SERVICES LEFT OUTER JOIN
                      dbo.CUSTOMERS RIGHT OUTER JOIN
                      dbo.JOBS ON dbo.CUSTOMERS.CUSTOMER_ID = dbo.JOBS.CUSTOMER_ID ON dbo.SERVICES.JOB_ID = dbo.JOBS.JOB_ID RIGHT OUTER JOIN
                      dbo.RESOURCES LEFT OUTER JOIN
                      dbo.USERS ON dbo.RESOURCES.USER_ID = dbo.USERS.USER_ID LEFT OUTER JOIN
                      dbo.SERVICE_LINES LEFT OUTER JOIN
                      dbo.PAYROLL_BATCH_LINES LEFT OUTER JOIN
                      dbo.PAYROLL_BATCH_STATUSES RIGHT OUTER JOIN
                      dbo.PAYROLL_BATCHES ON dbo.PAYROLL_BATCH_STATUSES.STATUS_ID = dbo.PAYROLL_BATCHES.STATUS_ID ON 
                      dbo.PAYROLL_BATCH_LINES.INT_BATCH_ID = dbo.PAYROLL_BATCHES.INT_BATCH_ID ON 
                      dbo.SERVICE_LINES.SERVICE_LINE_ID = dbo.PAYROLL_BATCH_LINES.SERVICE_LINE_ID ON 
                      dbo.RESOURCES.RESOURCE_ID = dbo.SERVICE_LINES.RESOURCE_ID LEFT OUTER JOIN
                      dbo.RESOURCE_TYPES ON dbo.RESOURCES.RESOURCE_TYPE_ID = dbo.RESOURCE_TYPES.RESOURCE_TYPE_ID LEFT OUTER JOIN
                      dbo.LOOKUPS LOOKUPS_4 ON dbo.RESOURCES.RES_CATEGORY_TYPE_ID = LOOKUPS_4.LOOKUP_ID ON 
                      dbo.SERVICES.SERVICE_ID = dbo.SERVICE_LINES.SERVICE_ID LEFT OUTER JOIN
                      dbo.ITEMS ON dbo.SERVICE_LINES.ITEM_ID = dbo.ITEMS.ITEM_ID LEFT OUTER JOIN
                      dbo.LOOKUPS LOOKUPS_3 ON dbo.ITEMS.ITEM_TYPE_ID = LOOKUPS_3.LOOKUP_ID
WHERE     (dbo.SERVICE_LINES.STATUS_ID > 1 OR
                      dbo.SERVICE_LINES.STATUS_ID IS NULL) AND (LOOKUPS_4.CODE = 'employee') AND (dbo.RESOURCES.ACTIVE_FLAG = 'Y') AND 
                      (LOOKUPS_3.CODE = 'hours' OR
                      LOOKUPS_3.CODE IS NULL)
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

CREATE VIEW [dbo].[PEP_RESOURCES_V]
AS
SELECT     RESOURCE_ID, ORGANIZATION_ID, NAME, USER_ID, ATTACHED_FLAG, ACTIVE_FLAG, FOREMAN_FLAG
FROM         dbo.RESOURCES
WHERE     (ORGANIZATION_ID = 2) AND (ACTIVE_FLAG = 'y') AND (USER_ID IS NULL)
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

CREATE VIEW [dbo].[SERVICE_LINE_EXPENSE_V]
AS
SELECT     dbo.RESOURCES.RESOURCE_ID, dbo.SERVICES.JOB_ID, dbo.JOBS.JOB_NO, dbo.SERVICE_LINES.SERVICE_ID, dbo.SERVICES.SERVICE_NO, 
                      dbo.RESOURCES.NAME AS resource_name, dbo.RESOURCES.RES_CATEGORY_TYPE_ID, LOOKUPS_4.CODE AS res_cat_type_code, 
                      LOOKUPS_4.NAME AS res_cat_type_name, dbo.RESOURCES.RESOURCE_TYPE_ID, dbo.RESOURCES.USER_ID, 
                      dbo.USERS.FIRST_NAME + ' ' + dbo.USERS.LAST_NAME AS user_name, dbo.RESOURCES.ACTIVE_FLAG, dbo.SERVICE_LINES.STATUS_ID, 
                      dbo.SERVICE_LINES.ITEM_ID, dbo.ITEMS.NAME AS item_name, dbo.SERVICE_LINES.EXT_PAY_CODE, ITEM_TYPE.CODE AS item_type_code, 
                      ITEM_TYPE.NAME AS item_type_name, dbo.RESOURCE_TYPES.CODE AS resource_type_code, 
                      dbo.RESOURCE_TYPES.NAME AS resource_type_name, dbo.SERVICE_LINES.QTY, dbo.SERVICE_LINES.SERVICE_LINE_DATE, DATEADD(day, 
                      7 - DATEPART(dw, dbo.SERVICE_LINES.SERVICE_LINE_DATE), dbo.SERVICE_LINES.SERVICE_LINE_DATE) AS service_line_week, 
                      dbo.USERS.FIRST_NAME + ' ' + dbo.USERS.LAST_NAME AS employee_name, dbo.SERVICE_LINES.RATE, dbo.CUSTOMERS.CUSTOMER_NAME, 
                      dbo.SERVICE_LINES.EXPENSES_EXPORTED_FLAG, dbo.USERS.EXT_EMPLOYEE_ID, dbo.SERVICE_LINES.RATE * dbo.SERVICE_LINES.QTY AS total, 
                      dbo.SERVICE_LINES.SERVICE_LINE_NO, dbo.SERVICE_LINES.SERVICE_LINE_ID, dbo.JOBS.JOB_NAME, dbo.JOBS.CUSTOMER_ID, 
                      dbo.CUSTOMERS.ORGANIZATION_ID, dbo.ORGANIZATIONS.CODE AS organization_code, ITEM_STATUS_TYPE.CODE AS item_status_type_code, 
                      ITEM_STATUS_TYPE.NAME AS item_status_type_name
FROM         dbo.LOOKUPS ITEM_STATUS_TYPE RIGHT OUTER JOIN
                      dbo.LOOKUPS ITEM_TYPE INNER JOIN
                      dbo.ITEMS INNER JOIN
                      dbo.JOBS INNER JOIN
                      dbo.SERVICES INNER JOIN
                      dbo.SERVICE_LINES ON dbo.SERVICES.SERVICE_ID = dbo.SERVICE_LINES.SERVICE_ID ON dbo.JOBS.JOB_ID = dbo.SERVICES.JOB_ID ON 
                      dbo.ITEMS.ITEM_ID = dbo.SERVICE_LINES.ITEM_ID ON ITEM_TYPE.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID ON 
                      ITEM_STATUS_TYPE.LOOKUP_ID = dbo.ITEMS.ITEM_STATUS_TYPE_ID RIGHT OUTER JOIN
                      dbo.USERS INNER JOIN
                      dbo.RESOURCE_TYPES INNER JOIN
                      dbo.RESOURCES ON dbo.RESOURCE_TYPES.RESOURCE_TYPE_ID = dbo.RESOURCES.RESOURCE_TYPE_ID INNER JOIN
                      dbo.LOOKUPS LOOKUPS_4 ON dbo.RESOURCES.RES_CATEGORY_TYPE_ID = LOOKUPS_4.LOOKUP_ID ON 
                      dbo.USERS.USER_ID = dbo.RESOURCES.USER_ID ON dbo.SERVICE_LINES.RESOURCE_ID = dbo.RESOURCES.RESOURCE_ID LEFT OUTER JOIN
                      dbo.CUSTOMERS ON dbo.JOBS.CUSTOMER_ID = dbo.CUSTOMERS.CUSTOMER_ID LEFT OUTER JOIN
                      dbo.ORGANIZATIONS ON dbo.CUSTOMERS.ORGANIZATION_ID = dbo.ORGANIZATIONS.ORGANIZATION_ID
WHERE     (dbo.SERVICE_LINES.STATUS_ID > 1 OR
                      dbo.SERVICE_LINES.STATUS_ID IS NULL) AND (dbo.RESOURCES.ACTIVE_FLAG = 'Y') AND (ITEM_TYPE.CODE = 'expense') AND 
                      (LOOKUPS_4.CODE = 'employee')
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

CREATE VIEW [dbo].[GP_ALABM_ITEM_PAYCODES_V]
AS
SELECT     ITEM_ID, item_name, pay_code, defaulted
FROM         (SELECT     GP_PAYCODES.PAYRCORD AS pay_code, dbo.ITEMS.NAME AS item_name, dbo.ITEMS.ITEM_ID, 'f' AS defaulted
                       FROM          dbo.LOOKUPS ITEM_TYPES INNER JOIN
                                              dbo.ITEMS ON ITEM_TYPES.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID INNER JOIN
                                              dbo.GP_ALABM_PAY_CODE_V GP_PAYCODES ON RIGHT(dbo.ITEMS.NAME, CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) - 1) 
                                              = RIGHT(GP_PAYCODES.DSCRIPTN, CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) - 1)
                       WHERE      (CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) > 0) AND (CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) > 0) AND 
                                              (ITEM_TYPES.CODE = 'hours') AND organization_id = 6
                       UNION
                       SELECT     '1' AS pay_code, dbo.ITEMS.NAME AS item_name, dbo.ITEMS.ITEM_ID, 't' AS defaulted
                       FROM         dbo.ITEMS INNER JOIN
                                             dbo.LOOKUPS item_types ON dbo.ITEMS.ITEM_TYPE_ID = item_types.LOOKUP_ID
                       WHERE     (item_types.CODE = 'hours') AND (dbo.ITEMS.ITEM_ID NOT IN
                                                 (SELECT     dbo.ITEMS.ITEM_ID
                                                   FROM          dbo.LOOKUPS ITEM_TYPES INNER JOIN
                                                                          dbo.ITEMS ON ITEM_TYPES.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID INNER JOIN
                                                                          dbo.GP_ALABM_PAY_CODE_V GP_PAYCODES ON RIGHT(dbo.ITEMS.NAME, CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) - 1) 
                                                                          = RIGHT(GP_PAYCODES.DSCRIPTN, CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) - 1)
                                                   WHERE      (CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) > 0) AND (CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) > 0) AND 
                                                                          (ITEM_TYPES.CODE = 'hours') AND dbo.items.organization_id = 6))) DERIVEDTBL
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

CREATE VIEW [dbo].[GP_MDWST_ITEM_PAYCODES_V]
AS
SELECT     ITEM_ID, item_name, pay_code, defaulted
FROM         (SELECT     GP_PAYCODES.PAYRCORD AS pay_code, dbo.ITEMS.NAME AS item_name, dbo.ITEMS.ITEM_ID, 'f' AS defaulted
                       FROM          dbo.LOOKUPS ITEM_TYPES INNER JOIN
                                              dbo.ITEMS ON ITEM_TYPES.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID INNER JOIN
                                              dbo.GP_MDWST_PAY_CODE_V GP_PAYCODES ON RIGHT(dbo.ITEMS.NAME, CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) - 1) 
                                              = RIGHT(GP_PAYCODES.DSCRIPTN, CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) - 1)
                       WHERE      (CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) > 0) AND (CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) > 0) AND 
                                              (ITEM_TYPES.CODE = 'hours') AND organization_id = 6
                       UNION
                       SELECT     '1' AS pay_code, dbo.ITEMS.NAME AS item_name, dbo.ITEMS.ITEM_ID, 't' AS defaulted
                       FROM         dbo.ITEMS INNER JOIN
                                             dbo.LOOKUPS item_types ON dbo.ITEMS.ITEM_TYPE_ID = item_types.LOOKUP_ID
                       WHERE     (item_types.CODE = 'hours') AND (dbo.ITEMS.ITEM_ID NOT IN
                                                 (SELECT     dbo.ITEMS.ITEM_ID
                                                   FROM          dbo.LOOKUPS ITEM_TYPES INNER JOIN
                                                                          dbo.ITEMS ON ITEM_TYPES.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID INNER JOIN
                                                                          dbo.GP_MDWST_PAY_CODE_V GP_PAYCODES ON RIGHT(dbo.ITEMS.NAME, CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) - 1) 
                                                                          = RIGHT(GP_PAYCODES.DSCRIPTN, CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) - 1)
                                                   WHERE      (CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) > 0) AND (CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) > 0) AND 
                                                                          (ITEM_TYPES.CODE = 'hours') AND dbo.items.organization_id = 6))) DERIVEDTBL
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

CREATE VIEW [dbo].[jobs_effective_customer_v]
AS
SELECT j.job_id,
 CASE WHEN customer_type.code = 'dealer' THEN j.end_user_id ELSE j.customer_id END effective_customer_id
FROM dbo.jobs j INNER JOIN dbo.customers c ON j.customer_id = c.customer_id
                INNER JOIN dbo.lookups customer_type ON c.customer_type_id = customer_type.lookup_id
GO

CREATE VIEW [dbo].[GP_ICS_ITEM_PAYCODES_V]
AS
SELECT     ITEM_ID, item_name, pay_code, defaulted
FROM         (SELECT     GP_PAYCODES.PAYRCORD AS pay_code, dbo.ITEMS.NAME AS item_name, dbo.ITEMS.ITEM_ID, 'f' AS defaulted
                       FROM          dbo.LOOKUPS ITEM_TYPES INNER JOIN
                                              dbo.ITEMS ON ITEM_TYPES.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID INNER JOIN
                                              dbo.GP_ICS_PAY_CODE_V GP_PAYCODES ON RIGHT(dbo.ITEMS.NAME, CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) - 1) 
                                              = RIGHT(GP_PAYCODES.DSCRIPTN, CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) - 1)
                       WHERE      (CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) > 0) AND (CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) > 0) AND 
                                              (ITEM_TYPES.CODE = 'hours')
                       UNION
                       SELECT     '1' AS pay_code, dbo.ITEMS.NAME AS item_name, dbo.ITEMS.ITEM_ID, 't' AS defaulted
                       FROM         dbo.ITEMS INNER JOIN
                                             dbo.LOOKUPS item_types ON dbo.ITEMS.ITEM_TYPE_ID = item_types.LOOKUP_ID
                       WHERE     (item_types.CODE = 'hours') AND (dbo.ITEMS.ITEM_ID NOT IN
                                                 (SELECT     dbo.ITEMS.ITEM_ID
                                                   FROM          dbo.LOOKUPS ITEM_TYPES INNER JOIN
                                                                          dbo.ITEMS ON ITEM_TYPES.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID INNER JOIN
                                                                          dbo.GP_ICS_PAY_CODE_V GP_PAYCODES ON RIGHT(dbo.ITEMS.NAME, CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) - 1) 
                                                                          = RIGHT(GP_PAYCODES.DSCRIPTN, CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) - 1)
                                                   WHERE      (CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) > 0) AND (CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) > 0) AND 
                                                                          (ITEM_TYPES.CODE = 'hours')))) DERIVEDTBL
GO

CREATE VIEW [dbo].[GP_MAD_ITEM_PAYCODES_V]
AS
SELECT     ITEM_ID, item_name, pay_code, defaulted
FROM         (SELECT     GP_PAYCODES.PAYRCORD AS pay_code, dbo.ITEMS.NAME AS item_name, dbo.ITEMS.ITEM_ID, 'f' AS defaulted
                       FROM          dbo.LOOKUPS ITEM_TYPES INNER JOIN
                                              dbo.ITEMS ON ITEM_TYPES.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID INNER JOIN
                                              dbo.GP_MAD_PAY_CODE_V GP_PAYCODES ON RIGHT(dbo.ITEMS.NAME, CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) - 1) 
                                              = RIGHT(GP_PAYCODES.DSCRIPTN, CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) - 1)
                       WHERE      (CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) > 0) AND (CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) > 0) AND 
                                              (ITEM_TYPES.CODE = 'hours') AND organization_id = 4
                       UNION
                       SELECT     '1' AS pay_code, dbo.ITEMS.NAME AS item_name, dbo.ITEMS.ITEM_ID, 't' AS defaulted
                       FROM         dbo.ITEMS INNER JOIN
                                             dbo.LOOKUPS item_types ON dbo.ITEMS.ITEM_TYPE_ID = item_types.LOOKUP_ID
                       WHERE     (item_types.CODE = 'hours') AND (dbo.ITEMS.ITEM_ID NOT IN
                                                 (SELECT     dbo.ITEMS.ITEM_ID
                                                   FROM          dbo.LOOKUPS ITEM_TYPES INNER JOIN
                                                                          dbo.ITEMS ON ITEM_TYPES.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID INNER JOIN
                                                                          dbo.GP_MAD_PAY_CODE_V GP_PAYCODES ON RIGHT(dbo.ITEMS.NAME, CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) - 1) 
                                                                          = RIGHT(GP_PAYCODES.DSCRIPTN, CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) - 1)
                                                   WHERE      (CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) > 0) AND (CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) > 0) AND 
                                                                          (ITEM_TYPES.CODE = 'hours') AND dbo.items.organization_id = 4))) DERIVEDTBL
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

CREATE VIEW [dbo].[GP_PHX_ITEM_PAYCODES_V]
AS
SELECT     ITEM_ID, item_name, pay_code, defaulted
FROM         (SELECT     GP_PAYCODES.PAYRCORD AS pay_code, dbo.ITEMS.NAME AS item_name, dbo.ITEMS.ITEM_ID, 'f' AS defaulted
                       FROM          dbo.LOOKUPS AS ITEM_TYPES INNER JOIN
                                              dbo.ITEMS ON ITEM_TYPES.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID INNER JOIN
                                              dbo.GP_PHX_PAY_CODE_V AS GP_PAYCODES ON RIGHT(dbo.ITEMS.NAME, CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) - 1) 
                                              = RIGHT(GP_PAYCODES.DSCRIPTN, CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) - 1)
                       WHERE      (CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) > 0) AND (CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) > 0) AND 
                                              (ITEM_TYPES.CODE = 'hours') AND (dbo.ITEMS.ORGANIZATION_ID = 20)
                       UNION
                       SELECT     '1' AS pay_code, ITEMS_2.NAME AS item_name, ITEMS_2.ITEM_ID, 't' AS defaulted
                       FROM         dbo.ITEMS AS ITEMS_2 INNER JOIN
                                             dbo.LOOKUPS AS item_types ON ITEMS_2.ITEM_TYPE_ID = item_types.LOOKUP_ID
                       WHERE     (item_types.CODE = 'hours') AND (ITEMS_2.ITEM_ID NOT IN
                                                 (SELECT     ITEMS_1.ITEM_ID
                                                   FROM          dbo.LOOKUPS AS ITEM_TYPES INNER JOIN
                                                                          dbo.ITEMS AS ITEMS_1 ON ITEM_TYPES.LOOKUP_ID = ITEMS_1.ITEM_TYPE_ID INNER JOIN
                                                                          dbo.GP_PHX_PAY_CODE_V AS GP_PAYCODES ON RIGHT(ITEMS_1.NAME, CHARINDEX('-', REVERSE(ITEMS_1.NAME)) - 1) 
                                                                          = RIGHT(GP_PAYCODES.DSCRIPTN, CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) - 1)
                                                   WHERE      (CHARINDEX('-', REVERSE(ITEMS_1.NAME)) > 0) AND (CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) > 0) AND 
                                                                          (ITEM_TYPES.CODE = 'hours') AND (ITEMS_1.ORGANIZATION_ID = 20)))) AS DERIVEDTBL
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

CREATE VIEW [dbo].[GP_IT_ITEM_PAYCODES_V]
AS
SELECT     ITEM_ID, item_name, pay_code, defaulted
FROM         (SELECT     GP_PAYCODES.PAYRCORD AS pay_code, dbo.ITEMS.NAME AS item_name, dbo.ITEMS.ITEM_ID, 'f' AS defaulted
                       FROM          dbo.LOOKUPS ITEM_TYPES INNER JOIN
                                              dbo.ITEMS ON ITEM_TYPES.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID INNER JOIN
                                              dbo.GP_IT_PAY_CODE_V GP_PAYCODES ON RIGHT(dbo.ITEMS.NAME, CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) - 1) 
                                              = RIGHT(GP_PAYCODES.DSCRIPTN, CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) - 1)
                       WHERE      (CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) > 0) AND (CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) > 0) AND 
                                              (ITEM_TYPES.CODE = 'hours')
                       UNION
                       SELECT     '1' AS pay_code, dbo.ITEMS.NAME AS item_name, dbo.ITEMS.ITEM_ID, 't' AS defaulted
                       FROM         dbo.ITEMS INNER JOIN
                                             dbo.LOOKUPS item_types ON dbo.ITEMS.ITEM_TYPE_ID = item_types.LOOKUP_ID
                       WHERE     (item_types.CODE = 'hours') AND (dbo.ITEMS.ITEM_ID NOT IN
                                                 (SELECT     dbo.ITEMS.ITEM_ID
                                                   FROM          dbo.LOOKUPS ITEM_TYPES INNER JOIN
                                                                          dbo.ITEMS ON ITEM_TYPES.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID INNER JOIN
                                                                          dbo.GP_IT_PAY_CODE_V GP_PAYCODES ON RIGHT(dbo.ITEMS.NAME, CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) - 1) 
                                                                          = RIGHT(GP_PAYCODES.DSCRIPTN, CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) - 1)
                                                   WHERE      (CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) > 0) AND (CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) > 0) AND 
                                                                          (ITEM_TYPES.CODE = 'hours')))) DERIVEDTBL
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

CREATE VIEW [dbo].[GP_NTLSV_ITEM_PAYCODES_V]
AS
SELECT     ITEM_ID, item_name, pay_code, defaulted
FROM         (SELECT     GP_PAYCODES.PAYRCORD AS pay_code, dbo.ITEMS.NAME AS item_name, dbo.ITEMS.ITEM_ID, 'f' AS defaulted
                       FROM          dbo.LOOKUPS ITEM_TYPES INNER JOIN
                                              dbo.ITEMS ON ITEM_TYPES.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID INNER JOIN
                                              dbo.GP_NTLSV_PAY_CODE_V GP_PAYCODES ON RIGHT(dbo.ITEMS.NAME, CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) - 1) 
                                              = RIGHT(GP_PAYCODES.DSCRIPTN, CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) - 1)
                       WHERE      (CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) > 0) AND (CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) > 0) AND 
                                              (ITEM_TYPES.CODE = 'hours') AND organization_id = 6
                       UNION
                       SELECT     '1' AS pay_code, dbo.ITEMS.NAME AS item_name, dbo.ITEMS.ITEM_ID, 't' AS defaulted
                       FROM         dbo.ITEMS INNER JOIN
                                             dbo.LOOKUPS item_types ON dbo.ITEMS.ITEM_TYPE_ID = item_types.LOOKUP_ID
                       WHERE     (item_types.CODE = 'hours') AND (dbo.ITEMS.ITEM_ID NOT IN
                                                 (SELECT     dbo.ITEMS.ITEM_ID
                                                   FROM          dbo.LOOKUPS ITEM_TYPES INNER JOIN
                                                                          dbo.ITEMS ON ITEM_TYPES.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID INNER JOIN
                                                                          dbo.GP_NTLSV_PAY_CODE_V GP_PAYCODES ON RIGHT(dbo.ITEMS.NAME, CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) - 1) 
                                                                          = RIGHT(GP_PAYCODES.DSCRIPTN, CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) - 1)
                                                   WHERE      (CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) > 0) AND (CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) > 0) AND 
                                                                          (ITEM_TYPES.CODE = 'hours') AND dbo.items.organization_id = 6))) DERIVEDTBL
GO

CREATE VIEW [dbo].[GP_MPLS_ITEM_PAYCODES_V]
AS
SELECT     ITEM_ID, item_name, pay_code, defaulted
FROM         (SELECT     GP_PAYCODES.PAYRCORD AS pay_code, dbo.ITEMS.NAME AS item_name, dbo.ITEMS.ITEM_ID, 'f' AS defaulted
                       FROM          dbo.LOOKUPS ITEM_TYPES INNER JOIN
                                              dbo.ITEMS ON ITEM_TYPES.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID INNER JOIN
                                              dbo.GP_MPLS_PAY_CODE_V GP_PAYCODES ON RIGHT(dbo.ITEMS.NAME, CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) - 1) 
                                              = RIGHT(GP_PAYCODES.DSCRIPTN, CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) - 1)
                       WHERE      (CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) > 0) AND (CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) > 0) AND 
                                              (ITEM_TYPES.CODE = 'hours')
                       UNION
                       SELECT     '1' AS pay_code, dbo.ITEMS.NAME AS item_name, dbo.ITEMS.ITEM_ID, 't' AS defaulted
                       FROM         dbo.ITEMS INNER JOIN
                                             dbo.LOOKUPS item_types ON dbo.ITEMS.ITEM_TYPE_ID = item_types.LOOKUP_ID
                       WHERE     (item_types.CODE = 'hours') AND (dbo.ITEMS.ITEM_ID NOT IN
                                                 (SELECT     dbo.ITEMS.ITEM_ID
                                                   FROM          dbo.LOOKUPS ITEM_TYPES INNER JOIN
                                                                          dbo.ITEMS ON ITEM_TYPES.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID INNER JOIN
                                                                          dbo.GP_MPLS_PAY_CODE_V GP_PAYCODES ON RIGHT(dbo.ITEMS.NAME, CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) - 1) 
                                                                          = RIGHT(GP_PAYCODES.DSCRIPTN, CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) - 1)
                                                   WHERE      (CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) > 0) AND (CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) > 0) AND 
                                                                          (ITEM_TYPES.CODE = 'hours')))) DERIVEDTBL
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

CREATE VIEW [dbo].[GP_CIMN_ITEM_PAYCODES_V]
AS
SELECT     ITEM_ID, item_name, pay_code, defaulted
FROM         (SELECT     GP_PAYCODES.PAYRCORD AS pay_code, dbo.ITEMS.NAME AS item_name, dbo.ITEMS.ITEM_ID, 'f' AS defaulted
                       FROM          dbo.LOOKUPS ITEM_TYPES INNER JOIN
                                              dbo.ITEMS ON ITEM_TYPES.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID INNER JOIN
                                              dbo.GP_CIMN_PAY_CODE_V GP_PAYCODES ON RIGHT(dbo.ITEMS.NAME, CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) - 1) 
                                              = RIGHT(GP_PAYCODES.DSCRIPTN, CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) - 1)
                       WHERE      (CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) > 0) AND (CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) > 0) AND 
                                              (ITEM_TYPES.CODE = 'hours') AND organization_id = 15
                       UNION
                       SELECT     '1' AS pay_code, dbo.ITEMS.NAME AS item_name, dbo.ITEMS.ITEM_ID, 't' AS defaulted
                       FROM         dbo.ITEMS INNER JOIN
                                             dbo.LOOKUPS item_types ON dbo.ITEMS.ITEM_TYPE_ID = item_types.LOOKUP_ID
                       WHERE     (item_types.CODE = 'hours') AND (dbo.ITEMS.ITEM_ID NOT IN
                                                 (SELECT     dbo.ITEMS.ITEM_ID
                                                   FROM          dbo.LOOKUPS ITEM_TYPES INNER JOIN
                                                                          dbo.ITEMS ON ITEM_TYPES.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID INNER JOIN
                                                                          dbo.GP_CIMN_PAY_CODE_V GP_PAYCODES ON RIGHT(dbo.ITEMS.NAME, CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) - 1) 
                                                                          = RIGHT(GP_PAYCODES.DSCRIPTN, CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) - 1)
                                                   WHERE      (CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) > 0) AND (CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) > 0) AND 
                                                                          (ITEM_TYPES.CODE = 'hours') AND dbo.items.organization_id = 15))) DERIVEDTBL
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

CREATE VIEW [dbo].[GP_ECMS_ITEM_PAYCODES_V]
AS
SELECT     ITEM_ID, item_name, pay_code, defaulted
FROM         (SELECT     GP_PAYCODES.PAYRCORD AS pay_code, dbo.ITEMS.NAME AS item_name, dbo.ITEMS.ITEM_ID, 'f' AS defaulted
                       FROM          dbo.LOOKUPS ITEM_TYPES INNER JOIN
                                              dbo.ITEMS ON ITEM_TYPES.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID INNER JOIN
                                              dbo.GP_ECMS_PAY_CODE_V GP_PAYCODES ON RIGHT(dbo.ITEMS.NAME, CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) - 1) 
                                              = RIGHT(GP_PAYCODES.DSCRIPTN, CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) - 1)
                       WHERE      (CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) > 0) AND (CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) > 0) AND 
                                              (ITEM_TYPES.CODE = 'hours')
                       UNION
                       SELECT     '1' AS pay_code, dbo.ITEMS.NAME AS item_name, dbo.ITEMS.ITEM_ID, 't' AS defaulted
                       FROM         dbo.ITEMS INNER JOIN
                                             dbo.LOOKUPS item_types ON dbo.ITEMS.ITEM_TYPE_ID = item_types.LOOKUP_ID
                       WHERE     (item_types.CODE = 'hours') AND (dbo.ITEMS.ITEM_ID NOT IN
                                                 (SELECT     dbo.ITEMS.ITEM_ID
                                                   FROM          dbo.LOOKUPS ITEM_TYPES INNER JOIN
                                                                          dbo.ITEMS ON ITEM_TYPES.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID INNER JOIN
                                                                          dbo.GP_ECMS_PAY_CODE_V GP_PAYCODES ON RIGHT(dbo.ITEMS.NAME, CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) - 1) 
                                                                          = RIGHT(GP_PAYCODES.DSCRIPTN, CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) - 1)
                                                   WHERE      (CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) > 0) AND (CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) > 0) AND 
                                                                          (ITEM_TYPES.CODE = 'hours')))) DERIVEDTBL
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

CREATE VIEW [dbo].[CONTACT_EMAILS_V]
AS
SELECT     dbo.CONTACTS.CONTACT_ID, dbo.CONTACTS.CONTACT_NAME, dbo.CONTACTS.CONT_STATUS_TYPE_ID, dbo.LOOKUPS.NAME AS Status, 
                      dbo.CONTACTS.EMAIL
FROM         dbo.CONTACTS INNER JOIN
                      dbo.LOOKUPS ON dbo.CONTACTS.CONT_STATUS_TYPE_ID = dbo.LOOKUPS.LOOKUP_ID
WHERE     (dbo.CONTACTS.CONT_STATUS_TYPE_ID = 128) AND (dbo.CONTACTS.EMAIL IS NOT NULL)
GO

CREATE VIEW [dbo].[GP_AIA_ITEM_PAYCODES_V]
AS
SELECT     ITEM_ID, item_name, pay_code, defaulted
FROM         (SELECT     GP_PAYCODES.PAYRCORD AS pay_code, dbo.ITEMS.NAME AS item_name, dbo.ITEMS.ITEM_ID, 'f' AS defaulted
                       FROM          dbo.LOOKUPS ITEM_TYPES INNER JOIN
                                              dbo.ITEMS ON ITEM_TYPES.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID INNER JOIN
                                              dbo.GP_AIA_PAY_CODE_V GP_PAYCODES ON RIGHT(dbo.ITEMS.NAME, CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) - 1) 
                                              = RIGHT(GP_PAYCODES.DSCRIPTN, CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) - 1)
                       WHERE      (CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) > 0) AND (CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) > 0) AND 
                                              (ITEM_TYPES.CODE = 'hours') AND organization_id = 6
                       UNION
                       SELECT     '1' AS pay_code, dbo.ITEMS.NAME AS item_name, dbo.ITEMS.ITEM_ID, 't' AS defaulted
                       FROM         dbo.ITEMS INNER JOIN
                                             dbo.LOOKUPS item_types ON dbo.ITEMS.ITEM_TYPE_ID = item_types.LOOKUP_ID
                       WHERE     (item_types.CODE = 'hours') AND (dbo.ITEMS.ITEM_ID NOT IN
                                                 (SELECT     dbo.ITEMS.ITEM_ID
                                                   FROM          dbo.LOOKUPS ITEM_TYPES INNER JOIN
                                                                          dbo.ITEMS ON ITEM_TYPES.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID INNER JOIN
                                                                          dbo.GP_AIA_PAY_CODE_V GP_PAYCODES ON RIGHT(dbo.ITEMS.NAME, CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) - 1) 
                                                                          = RIGHT(GP_PAYCODES.DSCRIPTN, CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) - 1)
                                                   WHERE      (CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) > 0) AND (CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) > 0) AND 
                                                                          (ITEM_TYPES.CODE = 'hours') AND dbo.items.organization_id = 6))) DERIVEDTBL
GO

CREATE VIEW [dbo].[GP_CIINC_ITEM_PAYCODES_V]
AS
SELECT     ITEM_ID, item_name, pay_code, defaulted
FROM         (SELECT     GP_PAYCODES.PAYRCORD AS pay_code, dbo.ITEMS.NAME AS item_name, dbo.ITEMS.ITEM_ID, 'f' AS defaulted
                       FROM          dbo.LOOKUPS ITEM_TYPES INNER JOIN
                                              dbo.ITEMS ON ITEM_TYPES.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID INNER JOIN
                                              dbo.GP_MPLS_PAY_CODE_V GP_PAYCODES ON RIGHT(dbo.ITEMS.NAME, CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) - 1) 
                                              = RIGHT(GP_PAYCODES.DSCRIPTN, CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) - 1)
                       WHERE      (CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) > 0) AND (CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) > 0) AND 
                                              (ITEM_TYPES.CODE = 'hours')
                       UNION
                       SELECT     '1' AS pay_code, dbo.ITEMS.NAME AS item_name, dbo.ITEMS.ITEM_ID, 't' AS defaulted
                       FROM         dbo.ITEMS INNER JOIN
                                             dbo.LOOKUPS item_types ON dbo.ITEMS.ITEM_TYPE_ID = item_types.LOOKUP_ID
                       WHERE     (item_types.CODE = 'hours') AND (dbo.ITEMS.ITEM_ID NOT IN
                                                 (SELECT     dbo.ITEMS.ITEM_ID
                                                   FROM          dbo.LOOKUPS ITEM_TYPES INNER JOIN
                                                                          dbo.ITEMS ON ITEM_TYPES.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID INNER JOIN
                                                                          dbo.GP_MPLS_PAY_CODE_V GP_PAYCODES ON RIGHT(dbo.ITEMS.NAME, CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) - 1) 
                                                                          = RIGHT(GP_PAYCODES.DSCRIPTN, CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) - 1)
                                                   WHERE      (CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) > 0) AND (CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) > 0) AND 
                                                                          (ITEM_TYPES.CODE = 'hours')))) DERIVEDTBL
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

CREATE VIEW [dbo].[GP_CILLC_ITEM_PAYCODES_V] AS
SELECT ITEM_ID, item_name, pay_code, defaulted
  FROM (SELECT GP_PAYCODES.PAYRCORD AS pay_code, dbo.ITEMS.NAME AS item_name, dbo.ITEMS.ITEM_ID, 'f' AS defaulted
          FROM dbo.LOOKUPS ITEM_TYPES INNER JOIN dbo.ITEMS ON ITEM_TYPES.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID 
                                      INNER JOIN dbo.GP_MPLS_PAY_CODE_V GP_PAYCODES ON RIGHT(dbo.ITEMS.NAME, CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) - 1) 
                                              = RIGHT(GP_PAYCODES.DSCRIPTN, CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) - 1)
         WHERE (CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) > 0) AND (CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) > 0) AND (ITEM_TYPES.CODE = 'hours')
       UNION
        SELECT '1' AS pay_code, dbo.ITEMS.NAME AS item_name, dbo.ITEMS.ITEM_ID, 't' AS defaulted
          FROM dbo.ITEMS INNER JOIN dbo.LOOKUPS item_types ON dbo.ITEMS.ITEM_TYPE_ID = item_types.LOOKUP_ID
         WHERE (item_types.CODE = 'hours') 
           AND (dbo.ITEMS.ITEM_ID NOT IN (SELECT dbo.ITEMS.ITEM_ID
                                            FROM dbo.LOOKUPS ITEM_TYPES INNER JOIN dbo.ITEMS ON ITEM_TYPES.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID
                                                                        INNER JOIN dbo.GP_MPLS_PAY_CODE_V GP_PAYCODES ON RIGHT(dbo.ITEMS.NAME, CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) - 1) 
                                                                          = RIGHT(GP_PAYCODES.DSCRIPTN, CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) - 1)
                                           WHERE (CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) > 0) AND (CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) > 0) 
                                             AND (ITEM_TYPES.CODE = 'hours')))
           AND RIGHT(dbo.ITEMS.NAME, CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) - 1) <> 'DT' 
       UNION
        SELECT '16' AS pay_code, dbo.ITEMS.NAME AS item_name, dbo.ITEMS.ITEM_ID, 't' AS defaulted
          FROM dbo.ITEMS INNER JOIN dbo.LOOKUPS item_types ON dbo.ITEMS.ITEM_TYPE_ID = item_types.LOOKUP_ID
         WHERE (item_types.CODE = 'hours') 
           AND (dbo.ITEMS.ITEM_ID NOT IN (SELECT dbo.ITEMS.ITEM_ID
                                            FROM dbo.LOOKUPS ITEM_TYPES INNER JOIN dbo.ITEMS ON ITEM_TYPES.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID
                                                                        INNER JOIN dbo.GP_MPLS_PAY_CODE_V GP_PAYCODES ON RIGHT(dbo.ITEMS.NAME, CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) - 1) 
                                                                          = RIGHT(GP_PAYCODES.DSCRIPTN, CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) - 1)
                                           WHERE (CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) > 0) AND (CHARINDEX('-', REVERSE(GP_PAYCODES.DSCRIPTN)) > 0) 
                                             AND (ITEM_TYPES.CODE = 'hours')))
           AND RIGHT(dbo.ITEMS.NAME, CHARINDEX('-', REVERSE(dbo.ITEMS.NAME)) - 1) = 'DT'       
        ) DERIVEDTBL
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

CREATE VIEW [dbo].[PDA_TIME_V] 
AS 
SELECT     dbo.SERVICE_LINE_STATUSES.CODE, dbo.SERVICE_LINES.CREATED_BY AS ims_user_id, dbo.SERVICE_LINES.ENTRY_METHOD, 

                      dbo.SERVICE_LINES.PALM_REP_ID AS rep_id 
FROM         dbo.SERVICE_LINES INNER JOIN 
                      dbo.SERVICE_LINE_STATUSES ON dbo.SERVICE_LINES.STATUS_ID = dbo.SERVICE_LINE_STATUSES.STATUS_ID 
WHERE     (dbo.SERVICE_LINES.ENTRY_METHOD = 'pda') AND (dbo.SERVICE_LINE_STATUSES.CODE = 'new')
GO

CREATE VIEW [dbo].[SERVICE_LINE_STATUSES_V]
AS
SELECT     STATUS_ID, CODE, NAME
FROM         dbo.SERVICE_LINE_STATUSES
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

CREATE VIEW [dbo].[INVOICE_LINES_arch_2004]
AS
SELECT     *
FROM         dbo.INVOICE_LINES
WHERE     (DATE_CREATED <= '9/1/2002')
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

CREATE VIEW [dbo].[DATES_V]
AS
SELECT      todays_date AS today,  (todays_date + tomorrows_offset) AS tomorrow, (todays_date + yesterdays_offset) AS yesterday, DATEADD(hh,16,(todays_date + fridays_offset)) AS this_friday, 
(todays_date + saturdays_offset) AS this_saturday, (todays_date + sundays_offset) AS this_sunday, DATEADD(hh,16,(todays_date + last_fridays_offset)) AS last_friday, 
(todays_date + last_saturdays_offset) AS last_saturday, (todays_date + last_sundays_offset) AS last_sunday, 
(case even_odd_week when 1 then 'Rotation B' else 'Rotation A' end) cur_rotation
FROM         dbo.DATE_OFFSETS_V
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

CREATE VIEW [dbo].[SYS_COLUMNS_V]
AS
SELECT     TOP 100 PERCENT dbo.SYS_TABLES_V.table_name, dbo.syscolumns.name AS column_name, dbo.systypes.name AS column_type, 
                      dbo.syscolumns.length, dbo.SYS_TABLES_V.table_id, dbo.syscolumns.id AS column_id
FROM         dbo.SYS_TABLES_V INNER JOIN
                      dbo.syscolumns ON dbo.SYS_TABLES_V.table_id = dbo.syscolumns.id INNER JOIN
                      dbo.systypes ON dbo.syscolumns.xtype = dbo.systypes.xtype
ORDER BY dbo.SYS_TABLES_V.table_name, dbo.syscolumns.colid
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

CREATE VIEW [dbo].[JOB_PAYCODE_VIEW_V] AS SELECT dbo.JOBS.JOB_ID, dbo.ORG_GP_TABLES.VIEW_NAME AS PAYCODE_VIEW_NAME 
FROM dbo.CUSTOMERS INNER JOIN dbo.JOBS ON dbo.CUSTOMERS.CUSTOMER_ID = dbo.JOBS.CUSTOMER_ID 
INNER JOIN dbo.ORGANIZATIONS ON dbo.CUSTOMERS.ORGANIZATION_ID = dbo.ORGANIZATIONS.Organization_ID 
INNER JOIN dbo.ORG_GP_TABLES ON dbo.ORGANIZATIONS.Organization_ID = dbo.ORG_GP_TABLES.ORG_ID 
INNER JOIN dbo.GREAT_PLAINS_TABLES ON dbo.ORG_GP_TABLES.TABLE_ID = dbo.GREAT_PLAINS_TABLES.TABLE_ID 
WHERE (dbo.GREAT_PLAINS_TABLES.TABLE_NAME = 'item_pay_codes_view')
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

CREATE VIEW [dbo].[SERV_LINE_STATUS_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'serv_line_status_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO

CREATE VIEW [dbo].[PUNCHLIST_ITEM_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'punchlist_item_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO

CREATE VIEW [dbo].[WORKORDER_STATUS_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'workorder_status_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO

CREATE VIEW [dbo].[PRIORITY_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'priority_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO

CREATE VIEW [dbo].[RESOURCE_CATEGORY_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'resource_category_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO

CREATE VIEW [dbo].[LEVEL_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'level_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO

CREATE VIEW [dbo].[REQ_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'service_type ') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO

CREATE VIEW [dbo].[SECURITY_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'security_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO

CREATE VIEW [dbo].[RESOURCE_STATUS_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'resource_status_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO

CREATE VIEW [dbo].[PHASE_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'phase_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO

CREATE VIEW [dbo].[MULTI_LEVEL_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'multi_level_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO

CREATE VIEW [dbo].[ELEVATOR_AVAILABLE_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'elevator_available_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO

CREATE VIEW [dbo].[APPROVAL_REQ_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'approval_req_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO

CREATE VIEW [dbo].[OVERRIDE_REASON_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'override_reason_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO

CREATE VIEW [dbo].[PRODUCT_DISPOSITION_V]  
AS  
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified,   
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID,   
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name  
FROM         dbo.LOOKUPS_V  
WHERE     (type_code = 'product_disposition_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO

CREATE VIEW [dbo].[NOTIFICATION_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'notification_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO

CREATE VIEW [dbo].[REQUEST_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'request_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO

CREATE VIEW [dbo].[ACCOUNT_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'account_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO

CREATE VIEW [dbo].[QUOTE_REQ_STATUS_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'quote_req_status_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO

CREATE VIEW [dbo].[QUOTE_STATUS_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'quote_status_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
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

CREATE VIEW [dbo].[DATE_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'date_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO

CREATE VIEW [dbo].[CUSTOMER_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'customer_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO

CREATE VIEW [dbo].[SCHEDULE_TYPES_ENET_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'schedule_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO

CREATE VIEW [dbo].[DELIVERY_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'delivery_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
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

CREATE VIEW [dbo].[EMPLOYMENT_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'employment_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO

CREATE VIEW [dbo].[FLOOR_PROTECTION_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'floor_prot_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO

CREATE VIEW [dbo].[ALERT_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'alert_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO

CREATE VIEW [dbo].[ACTIVITY_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'activity_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO

CREATE VIEW [dbo].[CONTACT_STATUS_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'contact_status_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO

CREATE VIEW [dbo].[BILLING_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'billing_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO

CREATE VIEW [dbo].[CONTACT_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'contact_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
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

CREATE VIEW [dbo].[INVOICE_TRACKING_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'tracking_type') AND (lookup_code <> 'pda_note') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO

CREATE VIEW [dbo].[FURNITURE_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'furniture_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO

CREATE VIEW [dbo].[ITEM_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'item_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO

CREATE VIEW [dbo].[JOB_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'job_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO

CREATE VIEW [dbo].[LOADING_DOCK_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'loading_dock_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO

CREATE VIEW [dbo].[JOB_STATUS_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'job_status_type ') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
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

CREATE VIEW [dbo].[ACTIVITY_CATEGORY_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'activity_category_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO

CREATE VIEW [dbo].[PROJECT_STATUS_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'project_status_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO

CREATE VIEW [dbo].[LOCATION_TYPES_V]
AS
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified, 
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID, 
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name
FROM         dbo.LOOKUPS_V
WHERE     (type_code = 'location_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
GO

CREATE VIEW [dbo].[LOOKUPS_QUICK_V]
AS
SELECT     TOP 100 PERCENT LOOKUP_TYPE_ID, type_name, SEQUENCE_NO, lookup_name, lookup_code, LOOKUP_ID
FROM         dbo.LOOKUPS_V
WHERE     (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')
ORDER BY type_name, SEQUENCE_NO
GO

CREATE VIEW [dbo].[PDA_SCHED_RES_V] AS SELECT dbo.SCH_RESOURCES_V.SCH_RESOURCE_ID AS sched_resource_id, dbo.SCH_RESOURCES_V.JOB_ID, dbo.SCH_RESOURCES_V.RESOURCE_ID, dbo.SCH_RESOURCES_V.resource_name AS name, dbo.PDA_JOBS_V.ims_user_id FROM dbo.SCH_RESOURCES_V INNER JOIN dbo.PDA_JOBS_V ON dbo.SCH_RESOURCES_V.JOB_ID = dbo.PDA_JOBS_V.JOB_ID WHERE (CONVERT(datetime, CONVERT(varchar, dbo.SCH_RESOURCES_V.RES_START_DATE, 101)) <= CONVERT(datetime, CONVERT(varchar, GETDATE(), 101))) AND (ISNULL(CONVERT(datetime, CONVERT(varchar, dbo.SCH_RESOURCES_V.RES_END_DATE, 101)), DATEADD(day, 1, CONVERT(datetime, CONVERT(varchar, GETDATE(), 101)))) >= CONVERT(datetime, CONVERT(varchar, GETDATE(), 101))) AND (dbo.PDA_JOBS_V.ims_user_id IS NOT NULL)
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

CREATE VIEW [dbo].[ITEMS_BY_JOB_TYPES_V]
(job_id, item_id)
AS
(SELECT j.job_id, i.item_id
FROM dbo.jobs j INNER JOIN dbo.items i ON j.job_type_id = i.job_type_id)
GO

CREATE VIEW [dbo].[vendors_v] 
AS
SELECT o.organization_id, tmp.ext_vendor_id, tmp.vendor_name
  FROM organizations o INNER JOIN
       (SELECT RTRIM(vendorid) ext_vendor_id, RTRIM(vendname) vendor_name, 'Minneapolis' org_name
          FROM ambim.dbo.pm00200
         WHERE vendstts <> 2 AND vendorid NOT LIKE 'old%'
       UNION
        SELECT RTRIM(vendorid) ext_vendor_id, RTRIM(vendname) vendor_name, 'Wisconsin' org_name
          FROM ammad.dbo.pm00200
         WHERE vendstts <> 2 AND vendorid NOT LIKE 'old%'
       UNION
        SELECT RTRIM(vendorid) ext_vendor_id, RTRIM(vendname) vendor_name, 'Georgia' org_name
          FROM aia.dbo.pm00200
         WHERE vendstts <> 2 AND vendorid NOT LIKE 'old%'
       UNION
        SELECT RTRIM(vendorid) ext_vendor_id, RTRIM(vendname) vendor_name, 'Milwaukee' org_name
          FROM ciinc.dbo.pm00200
         WHERE vendstts <> 2 AND vendorid NOT LIKE 'old%'
       UNION
        SELECT RTRIM(vendorid) ext_vendor_id, RTRIM(vendname) vendor_name, 'Illinois' org_name
          FROM cillc.dbo.pm00200
         WHERE vendstts <> 2 AND vendorid NOT LIKE 'old%'
       UNION
        SELECT RTRIM(vendorid) ext_vendor_id, RTRIM(vendname) vendor_name, 'ICS' org_name
          FROM ics.dbo.pm00200
         WHERE vendstts <> 2 AND vendorid NOT LIKE 'old%'
       UNION
        SELECT RTRIM(vendorid) ext_vendor_id, RTRIM(vendname) vendor_name, 'Plymouth' org_name
          FROM cimn.dbo.pm00200
         WHERE vendstts <> 2 AND vendorid NOT LIKE 'old%'
       UNION
        SELECT RTRIM(vendorid) ext_vendor_id, RTRIM(vendname) vendor_name, 'National Services' org_name
          FROM ntlsv.dbo.pm00200
         WHERE vendstts <> 2 AND vendorid NOT LIKE 'old%'
        ) tmp ON o.name = tmp.org_name
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

CREATE VIEW [dbo].[REQUEST_MAX_VERSION_V]
AS
SELECT     dbo.VERSIONS_MAX_NO_V.PROJECT_ID, dbo.VERSIONS_MAX_NO_V.PROJECT_NO, dbo.REQUESTS.REQUEST_ID, 
                      dbo.VERSIONS_MAX_NO_V.REQUEST_NO, dbo.REQUESTS.VERSION_NO, dbo.VERSIONS_MAX_NO_V.max_version_no
FROM         dbo.REQUESTS INNER JOIN
                      dbo.VERSIONS_MAX_NO_V ON dbo.REQUESTS.PROJECT_ID = dbo.VERSIONS_MAX_NO_V.PROJECT_ID AND 
                      dbo.REQUESTS.REQUEST_NO = dbo.VERSIONS_MAX_NO_V.REQUEST_NO AND 
                      dbo.REQUESTS.VERSION_NO = dbo.VERSIONS_MAX_NO_V.max_version_no
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

CREATE VIEW [dbo].[Contact_pkf_V]
AS
SELECT     CONTACT_ID, CONTACT_NAME, CUSTOMER_ID, CONTACT_TYPE_ID
FROM         dbo.CONTACTS
WHERE     (CUSTOMER_ID IS NULL) AND (CONTACT_TYPE_ID = 137)
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

CREATE VIEW [dbo].[PAYROLL_VERIFICATION_V]
AS
SELECT     pay.ORGANIZATION_ID, sl.RESOURCE_ID, pay.TC_JOB_ID AS JOB_ID, pay.TC_JOB_NO AS JOB_NO, pay.TC_SERVICE_ID AS SERVICE_ID, 
                      pay.TC_SERVICE_NO AS SERVICE_NO, pay.resource_name, dbo.RESOURCES_V.RES_CATEGORY_TYPE_ID, dbo.RESOURCES_V.res_cat_type_code, 
                      dbo.RESOURCES_V.res_cat_type_name, dbo.jobs_v.ext_customer_id, dbo.jobs_v.dealer_name, dbo.jobs_v.ext_dealer_id, sl.VERIFIED_DATE, 
                      sl.VERIFIED_BY, sl.PAYROLL_QTY AS hours_qty, sl.BILL_HOURLY_QTY AS hours_bill_qty, sl.BILL_HOURLY_RATE AS hours_bill_rate, 
                      pay.EXT_EMPLOYEE_ID, pay.employee_name, CONVERT(varchar(12), DATEADD(day, - 6, sl.SERVICE_LINE_WEEK), 101) AS begin_date, 
                      CONVERT(varchar(12), sl.SERVICE_LINE_WEEK, 101) AS end_date, pay.SERVICE_LINE_DATE, pay.ITEM_ID, pay.ITEM_NAME, pay.EXT_PAY_CODE, 
                      pay.ITEM_TYPE_CODE, dbo.ITEMS_V.item_type_name, sl.bill_hourly_total AS hours_bill_price, dbo.jobs_v.job_no_name, sl.ENTERED_DATE, 
                      sl.EXT_PAY_CODE AS EXT_PAYCODE, dbo.GP_MPLS_PAY_CODE_V.PAYRCORD, dbo.GP_MPLS_PAY_CODE_V.DSCRIPTN, sl.ENTERED_BY, 
                      sl.entered_by_name, dbo.USERS.USER_ID, dbo.USERS.FIRST_NAME, dbo.USERS.LAST_NAME, dbo.USERS.EXT_EMPLOYEE_ID AS EMP_ID, 
                      sl.verified_by_name, sl.ENTRY_METHOD, sl.TC_QTY, sl.TC_RATE, sl.tc_total, dbo.jobs_v.foreman_resource_name, sl.modified_by_name
FROM         dbo.USERS RIGHT OUTER JOIN
                      dbo.ITEMS_V RIGHT OUTER JOIN
                      dbo.PAYROLL_V AS pay ON dbo.ITEMS_V.ITEM_ID = pay.ITEM_ID LEFT OUTER JOIN
                      dbo.jobs_v ON pay.TC_JOB_ID = dbo.jobs_v.job_id LEFT OUTER JOIN
                      dbo.RESOURCES_V RIGHT OUTER JOIN
                      dbo.TIME_CAPTURE_V AS sl ON dbo.RESOURCES_V.RESOURCE_ID = sl.RESOURCE_ID ON pay.SERVICE_LINE_ID = sl.SERVICE_LINE_ID ON 
                      dbo.USERS.USER_ID = sl.ENTERED_BY LEFT OUTER JOIN
                      dbo.GP_MPLS_PAY_CODE_V ON sl.EXT_PAY_CODE = dbo.GP_MPLS_PAY_CODE_V.PAYRCORD
WHERE     (pay.PAYROLL_EXPORTED_FLAG = 'N') OR
                      (pay.PAYROLL_EXPORTED_FLAG = 'N')
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
WHERE     (sl.STATUS_ID > 3) AND (sl.INTERNAL_REQ_FLAG = 'N') AND (sl.ORGANIZATION_ID = 14)
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

CREATE VIEW [dbo].[PAYROLL_VERIFICATION_V_PATTY]
AS
SELECT     pay.ORGANIZATION_ID, sl.RESOURCE_ID, pay.TC_JOB_ID AS JOB_ID, pay.TC_JOB_NO AS JOB_NO, pay.TC_SERVICE_ID AS SERVICE_ID, 
                      pay.TC_SERVICE_NO AS SERVICE_NO, pay.resource_name, dbo.RESOURCES_V.RES_CATEGORY_TYPE_ID, dbo.RESOURCES_V.res_cat_type_code, 
                      dbo.RESOURCES_V.res_cat_type_name, dbo.JOBS_V.EXT_CUSTOMER_ID, dbo.JOBS_V.DEALER_NAME, dbo.JOBS_V.EXT_DEALER_ID, 
                      sl.VERIFIED_DATE, sl.VERIFIED_BY, sl.PAYROLL_QTY AS hours_qty, sl.BILL_HOURLY_QTY AS hours_bill_qty, 
                      sl.BILL_HOURLY_RATE AS hours_bill_rate, pay.EXT_EMPLOYEE_ID, pay.employee_name, CONVERT(varchar(12), DATEADD(day, - 6, 
                      sl.SERVICE_LINE_WEEK), 101) AS begin_date, CONVERT(varchar(12), sl.SERVICE_LINE_WEEK, 101) AS end_date, pay.SERVICE_LINE_DATE, 
                      pay.ITEM_ID, pay.ITEM_NAME, pay.EXT_PAY_CODE, pay.ITEM_TYPE_CODE, dbo.ITEMS_V.item_type_name, 
                      sl.BILL_HOURLY_TOTAL AS hours_bill_price, dbo.JOBS_V.JOB_NO_NAME, sl.ENTERED_DATE, sl.EXT_PAY_CODE AS EXT_PAYCODE, 
                      dbo.GP_MPLS_PAY_CODE_V.PAYRCORD, dbo.GP_MPLS_PAY_CODE_V.DSCRIPTN, sl.ENTERED_BY, sl.entered_by_name, dbo.USERS.USER_ID, 
                      dbo.USERS.FIRST_NAME, dbo.USERS.LAST_NAME, dbo.USERS.EXT_EMPLOYEE_ID AS EMP_ID, sl.verified_by_name, sl.ENTRY_METHOD, 
                      sl.TC_QTY, sl.TC_RATE, sl.TC_TOTAL
FROM         dbo.USERS RIGHT OUTER JOIN
                      dbo.ITEMS_V RIGHT OUTER JOIN
                      dbo.PAYROLL_V pay ON dbo.ITEMS_V.ITEM_ID = pay.ITEM_ID LEFT OUTER JOIN
                      dbo.JOBS_V ON pay.TC_JOB_ID = dbo.JOBS_V.JOB_ID LEFT OUTER JOIN
                      dbo.RESOURCES_V RIGHT OUTER JOIN
                      dbo.TIME_CAPTURE_V sl ON dbo.RESOURCES_V.RESOURCE_ID = sl.RESOURCE_ID ON pay.SERVICE_LINE_ID = sl.SERVICE_LINE_ID ON 
                      dbo.USERS.USER_ID = sl.ENTERED_BY LEFT OUTER JOIN
                      dbo.GP_MPLS_PAY_CODE_V ON sl.EXT_PAY_CODE = dbo.GP_MPLS_PAY_CODE_V.PAYRCORD
WHERE     (sl.VERIFIED_BY IS NOT NULL) OR
                      (sl.OVERRIDE_BY IS NOT NULL)
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

create   VIEW [dbo].[QUICK_QUOTE_REQUESTS_V] 
as
SELECT     dbo.quick_requests_v.*, dbo.CONTACTS.CONTACT_NAME AS A_M_CONTACT_NAME, CASE WHEN EXISTS
                          (SELECT     r.request_id
                            FROM          requests r
                            WHERE      quote_request_id = quick_requests_v.request_id) THEN 'Y' ELSE 'N' END AS HAS_SERVICE_REQUEST
FROM         dbo.quick_requests_v LEFT OUTER JOIN
                      dbo.CONTACTS ON dbo.quick_requests_v.A_M_CONTACT_ID = dbo.CONTACTS.CONTACT_ID
GO

CREATE VIEW [dbo].[crystal_VAR_REPORT_SUMMARY_V]
AS
SELECT     
 dbo.JOBS_V.ORGANIZATION_ID,
 dbo.JOBS_V.JOB_ID,
 dbo.JOBS_V.EXT_DEALER_ID,
 dbo.JOBS_V.CUSTOMER_ID,
 dbo.JOBS_V.CUSTOMER_NAME,
 dbo.JOBS_V.JOB_NO,
 dbo.JOBS_V.DEALER_NAME,
 dbo.JOBS_V.JOB_NAME,
 cast(dbo.JOBS_V.billing_user_name as varchar) as JOB_OWNER, 
 dbo.JOBS_V.JOB_TYPE_CODE,
 dbo.JOBS_V.FOREMAN_RESOURCE_ID,
 dbo.JOBS_V.BILLING_USER_ID, 
 cast (dbo.VAR_JOB_INVOICED_V.min_date_sent as smalldatetime (8)) as start_date,
 cast (dbo.VAR_JOB_INVOICED_V.max_date_sent as smalldatetime (8)) as end_date,
 dbo.VAR_JOB_INVOICED_V.sum_inv, 
 dbo.VAR_JOB_TIME_EXP_V.sum_time_exp, 
 dbo.VAR_JOB_TIME_EXP_V.sum_time, 
 dbo.VAR_JOB_TIME_EXP_V.sum_exp, 
 dbo.VAR_JOB_QUOTED_V.sum_quote, 
 dbo.VAR_JOB_ACT_HOURS_V.sum_payroll_qty, 
 dbo.VAR_JOB_EST_HOURS_V.sum_estimated_hours, 

 (CAST(ISNULL(dbo.VAR_JOB_INVOICED_V.sum_inv,0) AS money) - CAST(ISNULL(dbo.VAR_JOB_TIME_EXP_V.sum_time_exp,0) AS money)) AS sum_inv_var,
 (CASE ISNULL(dbo.VAR_JOB_INVOICED_V.sum_inv,0) WHEN 0 THEN 0 ELSE 
  (CAST(ISNULL(dbo.VAR_JOB_INVOICED_V.sum_inv,0) AS money) - CAST(ISNULL(dbo.VAR_JOB_TIME_EXP_V.sum_time_exp,0) AS money))
  / CAST(dbo.VAR_JOB_INVOICED_V.sum_inv AS MONEY) END) AS sum_inv_var_percent, 

 (CAST(dbo.VAR_JOB_QUOTED_V.sum_quote AS MONEY) - CAST(dbo.VAR_JOB_TIME_EXP_V.sum_time_exp AS MONEY)) AS sum_q_te_var,
 (CASE ISNULL(dbo.VAR_JOB_TIME_EXP_V.sum_time_exp,0) WHEN 0 THEN 0 ELSE 
  (CAST(dbo.VAR_JOB_QUOTED_V.sum_quote AS money) - CAST(dbo.VAR_JOB_TIME_EXP_V.sum_time_exp AS MONEY))
  / CAST(dbo.VAR_JOB_TIME_EXP_V.sum_time_exp AS MONEY) END) AS sum_q_te_var_percent, 

 (CAST(dbo.VAR_JOB_INVOICED_V.sum_inv AS MONEY) - CAST(dbo.VAR_JOB_QUOTED_V.sum_quote AS MONEY))  AS sum_inv_q_var,
 (CASE ISNULL(dbo.VAR_JOB_INVOICED_V.sum_inv,0) WHEN 0 THEN 0 ELSE 
  (CAST(dbo.VAR_JOB_INVOICED_V.sum_inv AS MONEY) - CAST(dbo.VAR_JOB_QUOTED_V.sum_quote AS MONEY)) 
  / CAST(dbo.VAR_JOB_INVOICED_V.sum_inv AS MONEY) END) AS sum_inv_q_var_percent, 

 CAST((CAST(ISNULL(dbo.VAR_JOB_EST_HOURS_V.sum_estimated_hours,0) as DECIMAL) - CAST(ISNULL(dbo.VAR_JOB_ACT_HOURS_V.sum_payroll_qty,0) AS DECIMAL)) as numeric(18,2)) AS sum_est_act_hours_var,
 (CASE ISNULL(dbo.VAR_JOB_ACT_HOURS_V.sum_payroll_qty,0) WHEN 0 THEN 0 ELSE 
  (CAST(ISNULL(dbo.VAR_JOB_EST_HOURS_V.sum_estimated_hours,0) AS DECIMAL)  - CAST(ISNULL(dbo.VAR_JOB_ACT_HOURS_V.sum_payroll_qty,0) AS DECIMAL))
  / CAST(dbo.VAR_JOB_ACT_HOURS_V.sum_payroll_qty AS DECIMAL) END) AS sum_est_act_hours_var_percent
  
FROM         dbo.VAR_JOB_QUOTED_V RIGHT OUTER JOIN
                      dbo.JOBS_V INNER JOIN
                      dbo.VAR_JOB_INVOICED_V ON dbo.JOBS_V.JOB_ID = dbo.VAR_JOB_INVOICED_V.JOB_ID LEFT OUTER JOIN
                      dbo.VAR_JOB_TIME_EXP_V ON dbo.JOBS_V.JOB_ID = dbo.VAR_JOB_TIME_EXP_V.JOB_ID ON 
                      dbo.VAR_JOB_QUOTED_V.JOB_ID = dbo.JOBS_V.JOB_ID LEFT OUTER JOIN
                      dbo.VAR_JOB_ACT_HOURS_V ON dbo.JOBS_V.JOB_ID = dbo.VAR_JOB_ACT_HOURS_V.JOB_ID LEFT OUTER JOIN
                      dbo.VAR_JOB_EST_HOURS_V ON dbo.JOBS_V.JOB_ID = dbo.VAR_JOB_EST_HOURS_V.JOB_ID
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

CREATE VIEW [dbo].[HOURS_BY_PAYCODE_V]
AS
SELECT     ORGANIZATION_ID, TC_JOB_ID, TC_JOB_NO, TC_SERVICE_ID, TC_SERVICE_NO, SERVICE_LINE_DATE, EXT_EMPLOYEE_ID, employee_name, 
                      PAYROLL_QTY, EXT_PAY_CODE, USER_ID
FROM         dbo.PAYROLL_V
WHERE     (ORGANIZATION_ID IS NOT NULL)
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

CREATE VIEW [dbo].[crystal_JOB_TIME_BY_JOB_WITH_GP_ACCTNUM_V]
AS
SELECT   'AMBIM' as COMPANYID,ISNULL(dbo.TIME_CAPTURE_V.PAYROLL_QTY, 0) - ISNULL(dbo.TIME_CAPTURE_V.BILL_HOURLY_QTY, 0) AS hours_difference, 
                      CAST(dbo.JOBS_V.JOB_NO AS VARCHAR) AS job_no_varchar, dbo.TIME_CAPTURE_V.ORGANIZATION_ID, dbo.TIME_CAPTURE_V.TC_JOB_NO, 
                      dbo.TIME_CAPTURE_V.TC_SERVICE_NO, dbo.TIME_CAPTURE_V.TC_SERVICE_LINE_NO, dbo.TIME_CAPTURE_V.ITEM_NAME, 
                      dbo.TIME_CAPTURE_V.TC_JOB_ID, dbo.TIME_CAPTURE_V.TC_SERVICE_ID, dbo.TIME_CAPTURE_V.PH_SERVICE_ID, 
                      dbo.TIME_CAPTURE_V.SERVICE_LINE_ID, dbo.TIME_CAPTURE_V.SERVICE_LINE_DATE, dbo.TIME_CAPTURE_V.STATUS_ID, 
                      dbo.TIME_CAPTURE_V.status_name, dbo.TIME_CAPTURE_V.RESOURCE_ID, dbo.TIME_CAPTURE_V.ITEM_ID, dbo.TIME_CAPTURE_V.TC_QTY, 
                      dbo.TIME_CAPTURE_V.TC_RATE, dbo.TIME_CAPTURE_V.TC_TOTAL, dbo.TIME_CAPTURE_V.PAYROLL_QTY, dbo.TIME_CAPTURE_V.EXT_PAY_CODE, 
                      dbo.RESOURCES_V.EXT_EMPLOYEE_ID, dbo.RESOURCES_V.USER_ID, dbo.JOBS_V.CUSTOMER_ID, dbo.JOBS_V.CUSTOMER_NAME, 
                      dbo.JOBS_V.FOREMAN_RESOURCE_ID, dbo.JOBS_V.foreman_resource_name, dbo.JOBS_V.JOB_NAME, dbo.RESOURCES_V.resource_name, 
                      dbo.RESOURCES_V.resource_type_name, dbo.RESOURCES_V.RESOURCE_TYPE_ID, dbo.JOBS_V.billing_user_name, left(isnull(rtrim(AMBIM..GL00100.ACTNUMBR_1),'') + '-' +isnull(rtrim(AMBIM..GL00100.ACTNUMBR_2),'') + 
 '-' + isnull(rtrim(AMBIM..GL00100.ACTNUMBR_3),'') + '-' + isnull(rtrim(AMBIM..GL00100.ACTNUMBR_4), '') + 
 '-' + isnull(rtrim(AMBIM..GL00100.ACTNUMBR_5),''),13) as ACTNUM
FROM         dbo.RESOURCES_V RIGHT OUTER JOIN
                      dbo.TIME_CAPTURE_V ON dbo.RESOURCES_V.RESOURCE_ID = dbo.TIME_CAPTURE_V.RESOURCE_ID LEFT OUTER JOIN
                      dbo.JOBS_V ON dbo.TIME_CAPTURE_V.TC_JOB_ID = dbo.JOBS_V.JOB_ID
inner join AMBIM..IV00101 on ITEM_NAME=AMBIM..IV00101.ITMSHNAM
inner join AMBIM..GL00100 on AMBIM..IV00101.IVSLSIDX = AMBIM..GL00100.ACTINDX
union all
SELECT   'AIA' as COMPANYID,ISNULL(dbo.TIME_CAPTURE_V.PAYROLL_QTY, 0) - ISNULL(dbo.TIME_CAPTURE_V.BILL_HOURLY_QTY, 0) AS hours_difference, 
                      CAST(dbo.JOBS_V.JOB_NO AS VARCHAR) AS job_no_varchar, dbo.TIME_CAPTURE_V.ORGANIZATION_ID, dbo.TIME_CAPTURE_V.TC_JOB_NO, 
                      dbo.TIME_CAPTURE_V.TC_SERVICE_NO, dbo.TIME_CAPTURE_V.TC_SERVICE_LINE_NO, dbo.TIME_CAPTURE_V.ITEM_NAME, 
                      dbo.TIME_CAPTURE_V.TC_JOB_ID, dbo.TIME_CAPTURE_V.TC_SERVICE_ID, dbo.TIME_CAPTURE_V.PH_SERVICE_ID, 
                      dbo.TIME_CAPTURE_V.SERVICE_LINE_ID, dbo.TIME_CAPTURE_V.SERVICE_LINE_DATE, dbo.TIME_CAPTURE_V.STATUS_ID, 
                      dbo.TIME_CAPTURE_V.status_name, dbo.TIME_CAPTURE_V.RESOURCE_ID, dbo.TIME_CAPTURE_V.ITEM_ID, dbo.TIME_CAPTURE_V.TC_QTY, 
                      dbo.TIME_CAPTURE_V.TC_RATE, dbo.TIME_CAPTURE_V.TC_TOTAL, dbo.TIME_CAPTURE_V.PAYROLL_QTY, dbo.TIME_CAPTURE_V.EXT_PAY_CODE, 
                      dbo.RESOURCES_V.EXT_EMPLOYEE_ID, dbo.RESOURCES_V.USER_ID, dbo.JOBS_V.CUSTOMER_ID, dbo.JOBS_V.CUSTOMER_NAME, 
                      dbo.JOBS_V.FOREMAN_RESOURCE_ID, dbo.JOBS_V.foreman_resource_name, dbo.JOBS_V.JOB_NAME, dbo.RESOURCES_V.resource_name, 
                      dbo.RESOURCES_V.resource_type_name, dbo.RESOURCES_V.RESOURCE_TYPE_ID, dbo.JOBS_V.billing_user_name, left(isnull(rtrim(AIA..GL00100.ACTNUMBR_1),'') + '-' +isnull(rtrim(AIA..GL00100.ACTNUMBR_2),'') + 
 '-' + isnull(rtrim(AIA..GL00100.ACTNUMBR_3),'') + '-' + isnull(rtrim(AIA..GL00100.ACTNUMBR_4), '') + 
 '-' + isnull(rtrim(AIA..GL00100.ACTNUMBR_5),''),13) as ACTNUM
FROM         dbo.RESOURCES_V RIGHT OUTER JOIN
                      dbo.TIME_CAPTURE_V ON dbo.RESOURCES_V.RESOURCE_ID = dbo.TIME_CAPTURE_V.RESOURCE_ID LEFT OUTER JOIN
                      dbo.JOBS_V ON dbo.TIME_CAPTURE_V.TC_JOB_ID = dbo.JOBS_V.JOB_ID
inner join AIA..IV00101 on ITEM_NAME=AIA..IV00101.ITMSHNAM
inner join AIA..GL00100 on AIA..IV00101.IVSLSIDX = AIA..GL00100.ACTINDX
union all
SELECT   'AMCOR' as COMPANYID,ISNULL(dbo.TIME_CAPTURE_V.PAYROLL_QTY, 0) - ISNULL(dbo.TIME_CAPTURE_V.BILL_HOURLY_QTY, 0) AS hours_difference, 
                      CAST(dbo.JOBS_V.JOB_NO AS VARCHAR) AS job_no_varchar, dbo.TIME_CAPTURE_V.ORGANIZATION_ID, dbo.TIME_CAPTURE_V.TC_JOB_NO, 
                      dbo.TIME_CAPTURE_V.TC_SERVICE_NO, dbo.TIME_CAPTURE_V.TC_SERVICE_LINE_NO, dbo.TIME_CAPTURE_V.ITEM_NAME, 
                      dbo.TIME_CAPTURE_V.TC_JOB_ID, dbo.TIME_CAPTURE_V.TC_SERVICE_ID, dbo.TIME_CAPTURE_V.PH_SERVICE_ID, 
                      dbo.TIME_CAPTURE_V.SERVICE_LINE_ID, dbo.TIME_CAPTURE_V.SERVICE_LINE_DATE, dbo.TIME_CAPTURE_V.STATUS_ID, 
                      dbo.TIME_CAPTURE_V.status_name, dbo.TIME_CAPTURE_V.RESOURCE_ID, dbo.TIME_CAPTURE_V.ITEM_ID, dbo.TIME_CAPTURE_V.TC_QTY, 
                      dbo.TIME_CAPTURE_V.TC_RATE, dbo.TIME_CAPTURE_V.TC_TOTAL, dbo.TIME_CAPTURE_V.PAYROLL_QTY, dbo.TIME_CAPTURE_V.EXT_PAY_CODE, 
                      dbo.RESOURCES_V.EXT_EMPLOYEE_ID, dbo.RESOURCES_V.USER_ID, dbo.JOBS_V.CUSTOMER_ID, dbo.JOBS_V.CUSTOMER_NAME, 
                      dbo.JOBS_V.FOREMAN_RESOURCE_ID, dbo.JOBS_V.foreman_resource_name, dbo.JOBS_V.JOB_NAME, dbo.RESOURCES_V.resource_name, 
                      dbo.RESOURCES_V.resource_type_name, dbo.RESOURCES_V.RESOURCE_TYPE_ID, dbo.JOBS_V.billing_user_name, left(isnull(rtrim(AMCOR..GL00100.ACTNUMBR_1),'') + '-' +isnull(rtrim(AMCOR..GL00100.ACTNUMBR_2),'') + 
 '-' + isnull(rtrim(AMCOR..GL00100.ACTNUMBR_3),'') + '-' + isnull(rtrim(AMCOR..GL00100.ACTNUMBR_4), '') + 
 '-' + isnull(rtrim(AMCOR..GL00100.ACTNUMBR_5),''),13) as ACTNUM
FROM         dbo.RESOURCES_V RIGHT OUTER JOIN
                      dbo.TIME_CAPTURE_V ON dbo.RESOURCES_V.RESOURCE_ID = dbo.TIME_CAPTURE_V.RESOURCE_ID LEFT OUTER JOIN
                      dbo.JOBS_V ON dbo.TIME_CAPTURE_V.TC_JOB_ID = dbo.JOBS_V.JOB_ID
inner join AMCOR..IV00101 on ITEM_NAME=AMCOR..IV00101.ITMSHNAM
inner join AMCOR..GL00100 on AMCOR..IV00101.IVSLSIDX = AMCOR..GL00100.ACTINDX  
union all
SELECT   'AMMAD' as COMPANYID,ISNULL(dbo.TIME_CAPTURE_V.PAYROLL_QTY, 0) - ISNULL(dbo.TIME_CAPTURE_V.BILL_HOURLY_QTY, 0) AS hours_difference, 
                      CAST(dbo.JOBS_V.JOB_NO AS VARCHAR) AS job_no_varchar, dbo.TIME_CAPTURE_V.ORGANIZATION_ID, dbo.TIME_CAPTURE_V.TC_JOB_NO, 
                      dbo.TIME_CAPTURE_V.TC_SERVICE_NO, dbo.TIME_CAPTURE_V.TC_SERVICE_LINE_NO, dbo.TIME_CAPTURE_V.ITEM_NAME, 
                      dbo.TIME_CAPTURE_V.TC_JOB_ID, dbo.TIME_CAPTURE_V.TC_SERVICE_ID, dbo.TIME_CAPTURE_V.PH_SERVICE_ID, 
                      dbo.TIME_CAPTURE_V.SERVICE_LINE_ID, dbo.TIME_CAPTURE_V.SERVICE_LINE_DATE, dbo.TIME_CAPTURE_V.STATUS_ID, 
                      dbo.TIME_CAPTURE_V.status_name, dbo.TIME_CAPTURE_V.RESOURCE_ID, dbo.TIME_CAPTURE_V.ITEM_ID, dbo.TIME_CAPTURE_V.TC_QTY, 
                      dbo.TIME_CAPTURE_V.TC_RATE, dbo.TIME_CAPTURE_V.TC_TOTAL, dbo.TIME_CAPTURE_V.PAYROLL_QTY, dbo.TIME_CAPTURE_V.EXT_PAY_CODE, 
                      dbo.RESOURCES_V.EXT_EMPLOYEE_ID, dbo.RESOURCES_V.USER_ID, dbo.JOBS_V.CUSTOMER_ID, dbo.JOBS_V.CUSTOMER_NAME, 
                      dbo.JOBS_V.FOREMAN_RESOURCE_ID, dbo.JOBS_V.foreman_resource_name, dbo.JOBS_V.JOB_NAME, dbo.RESOURCES_V.resource_name, 
                      dbo.RESOURCES_V.resource_type_name, dbo.RESOURCES_V.RESOURCE_TYPE_ID, dbo.JOBS_V.billing_user_name, left(isnull(rtrim(AMMAD..GL00100.ACTNUMBR_1),'') + '-' +isnull(rtrim(AMMAD..GL00100.ACTNUMBR_2),'') + 
 '-' + isnull(rtrim(AMMAD..GL00100.ACTNUMBR_3),'') + '-' + isnull(rtrim(AMMAD..GL00100.ACTNUMBR_4), '') + 
 '-' + isnull(rtrim(AMMAD..GL00100.ACTNUMBR_5),''),13) as ACTNUM
FROM         dbo.RESOURCES_V RIGHT OUTER JOIN
                      dbo.TIME_CAPTURE_V ON dbo.RESOURCES_V.RESOURCE_ID = dbo.TIME_CAPTURE_V.RESOURCE_ID LEFT OUTER JOIN
                      dbo.JOBS_V ON dbo.TIME_CAPTURE_V.TC_JOB_ID = dbo.JOBS_V.JOB_ID
inner join AMMAD..IV00101 on ITEM_NAME=AMMAD..IV00101.ITMSHNAM
inner join AMMAD..GL00100 on AMMAD..IV00101.IVSLSIDX = AMMAD..GL00100.ACTINDX
union all
SELECT   'CIINC' as COMPANYID,ISNULL(dbo.TIME_CAPTURE_V.PAYROLL_QTY, 0) - ISNULL(dbo.TIME_CAPTURE_V.BILL_HOURLY_QTY, 0) AS hours_difference, 
                      CAST(dbo.JOBS_V.JOB_NO AS VARCHAR) AS job_no_varchar, dbo.TIME_CAPTURE_V.ORGANIZATION_ID, dbo.TIME_CAPTURE_V.TC_JOB_NO, 
                      dbo.TIME_CAPTURE_V.TC_SERVICE_NO, dbo.TIME_CAPTURE_V.TC_SERVICE_LINE_NO, dbo.TIME_CAPTURE_V.ITEM_NAME, 
                      dbo.TIME_CAPTURE_V.TC_JOB_ID, dbo.TIME_CAPTURE_V.TC_SERVICE_ID, dbo.TIME_CAPTURE_V.PH_SERVICE_ID, 
                      dbo.TIME_CAPTURE_V.SERVICE_LINE_ID, dbo.TIME_CAPTURE_V.SERVICE_LINE_DATE, dbo.TIME_CAPTURE_V.STATUS_ID, 
                      dbo.TIME_CAPTURE_V.status_name, dbo.TIME_CAPTURE_V.RESOURCE_ID, dbo.TIME_CAPTURE_V.ITEM_ID, dbo.TIME_CAPTURE_V.TC_QTY, 
                      dbo.TIME_CAPTURE_V.TC_RATE, dbo.TIME_CAPTURE_V.TC_TOTAL, dbo.TIME_CAPTURE_V.PAYROLL_QTY, dbo.TIME_CAPTURE_V.EXT_PAY_CODE, 
                      dbo.RESOURCES_V.EXT_EMPLOYEE_ID, dbo.RESOURCES_V.USER_ID, dbo.JOBS_V.CUSTOMER_ID, dbo.JOBS_V.CUSTOMER_NAME, 
                      dbo.JOBS_V.FOREMAN_RESOURCE_ID, dbo.JOBS_V.foreman_resource_name, dbo.JOBS_V.JOB_NAME, dbo.RESOURCES_V.resource_name, 
                      dbo.RESOURCES_V.resource_type_name, dbo.RESOURCES_V.RESOURCE_TYPE_ID, dbo.JOBS_V.billing_user_name, left(isnull(rtrim(CIINC..GL00100.ACTNUMBR_1),'') + '-' +isnull(rtrim(CIINC..GL00100.ACTNUMBR_2),'') + 
 '-' + isnull(rtrim(CIINC..GL00100.ACTNUMBR_3),'') + '-' + isnull(rtrim(CIINC..GL00100.ACTNUMBR_4), '') + 
 '-' + isnull(rtrim(CIINC..GL00100.ACTNUMBR_5),''),13) as ACTNUM
FROM         dbo.RESOURCES_V RIGHT OUTER JOIN
                      dbo.TIME_CAPTURE_V ON dbo.RESOURCES_V.RESOURCE_ID = dbo.TIME_CAPTURE_V.RESOURCE_ID LEFT OUTER JOIN
                      dbo.JOBS_V ON dbo.TIME_CAPTURE_V.TC_JOB_ID = dbo.JOBS_V.JOB_ID
inner join CIINC..IV00101 on ITEM_NAME=CIINC..IV00101.ITMSHNAM
inner join CIINC..GL00100 on CIINC..IV00101.IVSLSIDX = CIINC..GL00100.ACTINDX
union all
SELECT   'CILLC' as COMPANYID,ISNULL(dbo.TIME_CAPTURE_V.PAYROLL_QTY, 0) - ISNULL(dbo.TIME_CAPTURE_V.BILL_HOURLY_QTY, 0) AS hours_difference, 
                      CAST(dbo.JOBS_V.JOB_NO AS VARCHAR) AS job_no_varchar, dbo.TIME_CAPTURE_V.ORGANIZATION_ID, dbo.TIME_CAPTURE_V.TC_JOB_NO, 
                      dbo.TIME_CAPTURE_V.TC_SERVICE_NO, dbo.TIME_CAPTURE_V.TC_SERVICE_LINE_NO, dbo.TIME_CAPTURE_V.ITEM_NAME, 
                      dbo.TIME_CAPTURE_V.TC_JOB_ID, dbo.TIME_CAPTURE_V.TC_SERVICE_ID, dbo.TIME_CAPTURE_V.PH_SERVICE_ID, 
                      dbo.TIME_CAPTURE_V.SERVICE_LINE_ID, dbo.TIME_CAPTURE_V.SERVICE_LINE_DATE, dbo.TIME_CAPTURE_V.STATUS_ID, 
                      dbo.TIME_CAPTURE_V.status_name, dbo.TIME_CAPTURE_V.RESOURCE_ID, dbo.TIME_CAPTURE_V.ITEM_ID, dbo.TIME_CAPTURE_V.TC_QTY, 
                      dbo.TIME_CAPTURE_V.TC_RATE, dbo.TIME_CAPTURE_V.TC_TOTAL, dbo.TIME_CAPTURE_V.PAYROLL_QTY, dbo.TIME_CAPTURE_V.EXT_PAY_CODE, 
                      dbo.RESOURCES_V.EXT_EMPLOYEE_ID, dbo.RESOURCES_V.USER_ID, dbo.JOBS_V.CUSTOMER_ID, dbo.JOBS_V.CUSTOMER_NAME, 
                      dbo.JOBS_V.FOREMAN_RESOURCE_ID, dbo.JOBS_V.foreman_resource_name, dbo.JOBS_V.JOB_NAME, dbo.RESOURCES_V.resource_name, 
                      dbo.RESOURCES_V.resource_type_name, dbo.RESOURCES_V.RESOURCE_TYPE_ID, dbo.JOBS_V.billing_user_name, left(isnull(rtrim(CILLC..GL00100.ACTNUMBR_1),'') + '-' +isnull(rtrim(CILLC..GL00100.ACTNUMBR_2),'') + 
 '-' + isnull(rtrim(CILLC..GL00100.ACTNUMBR_3),'') + '-' + isnull(rtrim(CILLC..GL00100.ACTNUMBR_4), '') + 
 '-' + isnull(rtrim(CILLC..GL00100.ACTNUMBR_5),''),13) as ACTNUM
FROM         dbo.RESOURCES_V RIGHT OUTER JOIN
                      dbo.TIME_CAPTURE_V ON dbo.RESOURCES_V.RESOURCE_ID = dbo.TIME_CAPTURE_V.RESOURCE_ID LEFT OUTER JOIN
                      dbo.JOBS_V ON dbo.TIME_CAPTURE_V.TC_JOB_ID = dbo.JOBS_V.JOB_ID
inner join CILLC..IV00101 on ITEM_NAME=CILLC..IV00101.ITMSHNAM
inner join CILLC..GL00100 on CILLC..IV00101.IVSLSIDX = CILLC..GL00100.ACTINDX
union all
SELECT   'ECMS' as COMPANYID,ISNULL(dbo.TIME_CAPTURE_V.PAYROLL_QTY, 0) - ISNULL(dbo.TIME_CAPTURE_V.BILL_HOURLY_QTY, 0) AS hours_difference, 
                      CAST(dbo.JOBS_V.JOB_NO AS VARCHAR) AS job_no_varchar, dbo.TIME_CAPTURE_V.ORGANIZATION_ID, dbo.TIME_CAPTURE_V.TC_JOB_NO, 
                      dbo.TIME_CAPTURE_V.TC_SERVICE_NO, dbo.TIME_CAPTURE_V.TC_SERVICE_LINE_NO, dbo.TIME_CAPTURE_V.ITEM_NAME, 
                      dbo.TIME_CAPTURE_V.TC_JOB_ID, dbo.TIME_CAPTURE_V.TC_SERVICE_ID, dbo.TIME_CAPTURE_V.PH_SERVICE_ID, 
                      dbo.TIME_CAPTURE_V.SERVICE_LINE_ID, dbo.TIME_CAPTURE_V.SERVICE_LINE_DATE, dbo.TIME_CAPTURE_V.STATUS_ID, 
                      dbo.TIME_CAPTURE_V.status_name, dbo.TIME_CAPTURE_V.RESOURCE_ID, dbo.TIME_CAPTURE_V.ITEM_ID, dbo.TIME_CAPTURE_V.TC_QTY, 
                      dbo.TIME_CAPTURE_V.TC_RATE, dbo.TIME_CAPTURE_V.TC_TOTAL, dbo.TIME_CAPTURE_V.PAYROLL_QTY, dbo.TIME_CAPTURE_V.EXT_PAY_CODE, 
                      dbo.RESOURCES_V.EXT_EMPLOYEE_ID, dbo.RESOURCES_V.USER_ID, dbo.JOBS_V.CUSTOMER_ID, dbo.JOBS_V.CUSTOMER_NAME, 
                      dbo.JOBS_V.FOREMAN_RESOURCE_ID, dbo.JOBS_V.foreman_resource_name, dbo.JOBS_V.JOB_NAME, dbo.RESOURCES_V.resource_name, 
                      dbo.RESOURCES_V.resource_type_name, dbo.RESOURCES_V.RESOURCE_TYPE_ID, dbo.JOBS_V.billing_user_name, left(isnull(rtrim(ECMS..GL00100.ACTNUMBR_1),'') + '-' +isnull(rtrim(ECMS..GL00100.ACTNUMBR_2),'') + 
 '-' + isnull(rtrim(ECMS..GL00100.ACTNUMBR_3),'') + '-' + isnull(rtrim(ECMS..GL00100.ACTNUMBR_4), '') + 
 '-' + isnull(rtrim(ECMS..GL00100.ACTNUMBR_5),''),13) as ACTNUM
FROM         dbo.RESOURCES_V RIGHT OUTER JOIN
                      dbo.TIME_CAPTURE_V ON dbo.RESOURCES_V.RESOURCE_ID = dbo.TIME_CAPTURE_V.RESOURCE_ID LEFT OUTER JOIN
                      dbo.JOBS_V ON dbo.TIME_CAPTURE_V.TC_JOB_ID = dbo.JOBS_V.JOB_ID
inner join ECMS..IV00101 on ITEM_NAME=ECMS..IV00101.ITMSHNAM
inner join ECMS..GL00100 on ECMS..IV00101.IVSLSIDX = ECMS..GL00100.ACTINDX
union all
SELECT   'ICS' as COMPANYID,ISNULL(dbo.TIME_CAPTURE_V.PAYROLL_QTY, 0) - ISNULL(dbo.TIME_CAPTURE_V.BILL_HOURLY_QTY, 0) AS hours_difference, 
                      CAST(dbo.JOBS_V.JOB_NO AS VARCHAR) AS job_no_varchar, dbo.TIME_CAPTURE_V.ORGANIZATION_ID, dbo.TIME_CAPTURE_V.TC_JOB_NO, 
                      dbo.TIME_CAPTURE_V.TC_SERVICE_NO, dbo.TIME_CAPTURE_V.TC_SERVICE_LINE_NO, dbo.TIME_CAPTURE_V.ITEM_NAME, 
                      dbo.TIME_CAPTURE_V.TC_JOB_ID, dbo.TIME_CAPTURE_V.TC_SERVICE_ID, dbo.TIME_CAPTURE_V.PH_SERVICE_ID, 
                      dbo.TIME_CAPTURE_V.SERVICE_LINE_ID, dbo.TIME_CAPTURE_V.SERVICE_LINE_DATE, dbo.TIME_CAPTURE_V.STATUS_ID, 
                      dbo.TIME_CAPTURE_V.status_name, dbo.TIME_CAPTURE_V.RESOURCE_ID, dbo.TIME_CAPTURE_V.ITEM_ID, dbo.TIME_CAPTURE_V.TC_QTY, 
                      dbo.TIME_CAPTURE_V.TC_RATE, dbo.TIME_CAPTURE_V.TC_TOTAL, dbo.TIME_CAPTURE_V.PAYROLL_QTY, dbo.TIME_CAPTURE_V.EXT_PAY_CODE, 
                      dbo.RESOURCES_V.EXT_EMPLOYEE_ID, dbo.RESOURCES_V.USER_ID, dbo.JOBS_V.CUSTOMER_ID, dbo.JOBS_V.CUSTOMER_NAME, 
                      dbo.JOBS_V.FOREMAN_RESOURCE_ID, dbo.JOBS_V.foreman_resource_name, dbo.JOBS_V.JOB_NAME, dbo.RESOURCES_V.resource_name, 
                      dbo.RESOURCES_V.resource_type_name, dbo.RESOURCES_V.RESOURCE_TYPE_ID, dbo.JOBS_V.billing_user_name, left(isnull(rtrim(ICS..GL00100.ACTNUMBR_1),'') + '-' +isnull(rtrim(ICS..GL00100.ACTNUMBR_2),'') + 
 '-' + isnull(rtrim(ICS..GL00100.ACTNUMBR_3),'') + '-' + isnull(rtrim(ICS..GL00100.ACTNUMBR_4), '') + 
 '-' + isnull(rtrim(ICS..GL00100.ACTNUMBR_5),''),13) as ACTNUM
FROM         dbo.RESOURCES_V RIGHT OUTER JOIN
                      dbo.TIME_CAPTURE_V ON dbo.RESOURCES_V.RESOURCE_ID = dbo.TIME_CAPTURE_V.RESOURCE_ID LEFT OUTER JOIN
                      dbo.JOBS_V ON dbo.TIME_CAPTURE_V.TC_JOB_ID = dbo.JOBS_V.JOB_ID
inner join ICS..IV00101 on ITEM_NAME=ICS..IV00101.ITMSHNAM
inner join ICS..GL00100 on ICS..IV00101.IVSLSIDX = ICS..GL00100.ACTINDX 
union all
SELECT   'INTRA' as COMPANYID,ISNULL(dbo.TIME_CAPTURE_V.PAYROLL_QTY, 0) - ISNULL(dbo.TIME_CAPTURE_V.BILL_HOURLY_QTY, 0) AS hours_difference, 
                      CAST(dbo.JOBS_V.JOB_NO AS VARCHAR) AS job_no_varchar, dbo.TIME_CAPTURE_V.ORGANIZATION_ID, dbo.TIME_CAPTURE_V.TC_JOB_NO, 
                      dbo.TIME_CAPTURE_V.TC_SERVICE_NO, dbo.TIME_CAPTURE_V.TC_SERVICE_LINE_NO, dbo.TIME_CAPTURE_V.ITEM_NAME, 
                      dbo.TIME_CAPTURE_V.TC_JOB_ID, dbo.TIME_CAPTURE_V.TC_SERVICE_ID, dbo.TIME_CAPTURE_V.PH_SERVICE_ID, 
                      dbo.TIME_CAPTURE_V.SERVICE_LINE_ID, dbo.TIME_CAPTURE_V.SERVICE_LINE_DATE, dbo.TIME_CAPTURE_V.STATUS_ID, 
                      dbo.TIME_CAPTURE_V.status_name, dbo.TIME_CAPTURE_V.RESOURCE_ID, dbo.TIME_CAPTURE_V.ITEM_ID, dbo.TIME_CAPTURE_V.TC_QTY, 
                      dbo.TIME_CAPTURE_V.TC_RATE, dbo.TIME_CAPTURE_V.TC_TOTAL, dbo.TIME_CAPTURE_V.PAYROLL_QTY, dbo.TIME_CAPTURE_V.EXT_PAY_CODE, 
                      dbo.RESOURCES_V.EXT_EMPLOYEE_ID, dbo.RESOURCES_V.USER_ID, dbo.JOBS_V.CUSTOMER_ID, dbo.JOBS_V.CUSTOMER_NAME, 
                      dbo.JOBS_V.FOREMAN_RESOURCE_ID, dbo.JOBS_V.foreman_resource_name, dbo.JOBS_V.JOB_NAME, dbo.RESOURCES_V.resource_name, 
                      dbo.RESOURCES_V.resource_type_name, dbo.RESOURCES_V.RESOURCE_TYPE_ID, dbo.JOBS_V.billing_user_name, left(isnull(rtrim(INTRA..GL00100.ACTNUMBR_1),'') + '-' +isnull(rtrim(INTRA..GL00100.ACTNUMBR_2),'') + 
 '-' + isnull(rtrim(INTRA..GL00100.ACTNUMBR_3),'') + '-' + isnull(rtrim(INTRA..GL00100.ACTNUMBR_4), '') + 
 '-' + isnull(rtrim(INTRA..GL00100.ACTNUMBR_5),''),13) as ACTNUM
FROM         dbo.RESOURCES_V RIGHT OUTER JOIN
                      dbo.TIME_CAPTURE_V ON dbo.RESOURCES_V.RESOURCE_ID = dbo.TIME_CAPTURE_V.RESOURCE_ID LEFT OUTER JOIN
                      dbo.JOBS_V ON dbo.TIME_CAPTURE_V.TC_JOB_ID = dbo.JOBS_V.JOB_ID
inner join INTRA..IV00101 on ITEM_NAME=INTRA..IV00101.ITMSHNAM
inner join INTRA..GL00100 on INTRA..IV00101.IVSLSIDX = INTRA..GL00100.ACTINDX  
union all
SELECT   'IT' as COMPANYID,ISNULL(dbo.TIME_CAPTURE_V.PAYROLL_QTY, 0) - ISNULL(dbo.TIME_CAPTURE_V.BILL_HOURLY_QTY, 0) AS hours_difference, 
                      CAST(dbo.JOBS_V.JOB_NO AS VARCHAR) AS job_no_varchar, dbo.TIME_CAPTURE_V.ORGANIZATION_ID, dbo.TIME_CAPTURE_V.TC_JOB_NO, 
                      dbo.TIME_CAPTURE_V.TC_SERVICE_NO, dbo.TIME_CAPTURE_V.TC_SERVICE_LINE_NO, dbo.TIME_CAPTURE_V.ITEM_NAME, 
                      dbo.TIME_CAPTURE_V.TC_JOB_ID, dbo.TIME_CAPTURE_V.TC_SERVICE_ID, dbo.TIME_CAPTURE_V.PH_SERVICE_ID, 
                      dbo.TIME_CAPTURE_V.SERVICE_LINE_ID, dbo.TIME_CAPTURE_V.SERVICE_LINE_DATE, dbo.TIME_CAPTURE_V.STATUS_ID, 
                      dbo.TIME_CAPTURE_V.status_name, dbo.TIME_CAPTURE_V.RESOURCE_ID, dbo.TIME_CAPTURE_V.ITEM_ID, dbo.TIME_CAPTURE_V.TC_QTY, 
                      dbo.TIME_CAPTURE_V.TC_RATE, dbo.TIME_CAPTURE_V.TC_TOTAL, dbo.TIME_CAPTURE_V.PAYROLL_QTY, dbo.TIME_CAPTURE_V.EXT_PAY_CODE, 
                      dbo.RESOURCES_V.EXT_EMPLOYEE_ID, dbo.RESOURCES_V.USER_ID, dbo.JOBS_V.CUSTOMER_ID, dbo.JOBS_V.CUSTOMER_NAME, 
                      dbo.JOBS_V.FOREMAN_RESOURCE_ID, dbo.JOBS_V.foreman_resource_name, dbo.JOBS_V.JOB_NAME, dbo.RESOURCES_V.resource_name, 
                      dbo.RESOURCES_V.resource_type_name, dbo.RESOURCES_V.RESOURCE_TYPE_ID, dbo.JOBS_V.billing_user_name, left(isnull(rtrim(IT..GL00100.ACTNUMBR_1),'') + '-' +isnull(rtrim(IT..GL00100.ACTNUMBR_2),'') + 
 '-' + isnull(rtrim(IT..GL00100.ACTNUMBR_3),'') + '-' + isnull(rtrim(IT..GL00100.ACTNUMBR_4), '') + 
 '-' + isnull(rtrim(IT..GL00100.ACTNUMBR_5),''),13) as ACTNUM
FROM         dbo.RESOURCES_V RIGHT OUTER JOIN
                      dbo.TIME_CAPTURE_V ON dbo.RESOURCES_V.RESOURCE_ID = dbo.TIME_CAPTURE_V.RESOURCE_ID LEFT OUTER JOIN
                      dbo.JOBS_V ON dbo.TIME_CAPTURE_V.TC_JOB_ID = dbo.JOBS_V.JOB_ID
inner join IT..IV00101 on ITEM_NAME=IT..IV00101.ITMSHNAM
inner join IT..GL00100 on IT..IV00101.IVSLSIDX = IT..GL00100.ACTINDX
union all
SELECT   'OMNI' as COMPANYID,ISNULL(dbo.TIME_CAPTURE_V.PAYROLL_QTY, 0) - ISNULL(dbo.TIME_CAPTURE_V.BILL_HOURLY_QTY, 0) AS hours_difference, 
                      CAST(dbo.JOBS_V.JOB_NO AS VARCHAR) AS job_no_varchar, dbo.TIME_CAPTURE_V.ORGANIZATION_ID, dbo.TIME_CAPTURE_V.TC_JOB_NO, 
                      dbo.TIME_CAPTURE_V.TC_SERVICE_NO, dbo.TIME_CAPTURE_V.TC_SERVICE_LINE_NO, dbo.TIME_CAPTURE_V.ITEM_NAME, 
                      dbo.TIME_CAPTURE_V.TC_JOB_ID, dbo.TIME_CAPTURE_V.TC_SERVICE_ID, dbo.TIME_CAPTURE_V.PH_SERVICE_ID, 
                      dbo.TIME_CAPTURE_V.SERVICE_LINE_ID, dbo.TIME_CAPTURE_V.SERVICE_LINE_DATE, dbo.TIME_CAPTURE_V.STATUS_ID, 
                      dbo.TIME_CAPTURE_V.status_name, dbo.TIME_CAPTURE_V.RESOURCE_ID, dbo.TIME_CAPTURE_V.ITEM_ID, dbo.TIME_CAPTURE_V.TC_QTY, 
                      dbo.TIME_CAPTURE_V.TC_RATE, dbo.TIME_CAPTURE_V.TC_TOTAL, dbo.TIME_CAPTURE_V.PAYROLL_QTY, dbo.TIME_CAPTURE_V.EXT_PAY_CODE, 
                      dbo.RESOURCES_V.EXT_EMPLOYEE_ID, dbo.RESOURCES_V.USER_ID, dbo.JOBS_V.CUSTOMER_ID, dbo.JOBS_V.CUSTOMER_NAME, 
                      dbo.JOBS_V.FOREMAN_RESOURCE_ID, dbo.JOBS_V.foreman_resource_name, dbo.JOBS_V.JOB_NAME, dbo.RESOURCES_V.resource_name, 
                      dbo.RESOURCES_V.resource_type_name, dbo.RESOURCES_V.RESOURCE_TYPE_ID, dbo.JOBS_V.billing_user_name, left(isnull(rtrim(OMNI..GL00100.ACTNUMBR_1),'') + '-' +isnull(rtrim(OMNI..GL00100.ACTNUMBR_2),'') + 
 '-' + isnull(rtrim(OMNI..GL00100.ACTNUMBR_3),'') + '-' + isnull(rtrim(OMNI..GL00100.ACTNUMBR_4), '') + 
 '-' + isnull(rtrim(OMNI..GL00100.ACTNUMBR_5),''),13) as ACTNUM
FROM         dbo.RESOURCES_V RIGHT OUTER JOIN
                      dbo.TIME_CAPTURE_V ON dbo.RESOURCES_V.RESOURCE_ID = dbo.TIME_CAPTURE_V.RESOURCE_ID LEFT OUTER JOIN
                      dbo.JOBS_V ON dbo.TIME_CAPTURE_V.TC_JOB_ID = dbo.JOBS_V.JOB_ID
inner join OMNI..IV00101 on ITEM_NAME=OMNI..IV00101.ITMSHNAM
inner join OMNI..GL00100 on OMNI..IV00101.IVSLSIDX = OMNI..GL00100.ACTINDX   
union all
SELECT   'RVM' as COMPANYID,ISNULL(dbo.TIME_CAPTURE_V.PAYROLL_QTY, 0) - ISNULL(dbo.TIME_CAPTURE_V.BILL_HOURLY_QTY, 0) AS hours_difference, 
                      CAST(dbo.JOBS_V.JOB_NO AS VARCHAR) AS job_no_varchar, dbo.TIME_CAPTURE_V.ORGANIZATION_ID, dbo.TIME_CAPTURE_V.TC_JOB_NO, 
                      dbo.TIME_CAPTURE_V.TC_SERVICE_NO, dbo.TIME_CAPTURE_V.TC_SERVICE_LINE_NO, dbo.TIME_CAPTURE_V.ITEM_NAME, 
                      dbo.TIME_CAPTURE_V.TC_JOB_ID, dbo.TIME_CAPTURE_V.TC_SERVICE_ID, dbo.TIME_CAPTURE_V.PH_SERVICE_ID, 
                      dbo.TIME_CAPTURE_V.SERVICE_LINE_ID, dbo.TIME_CAPTURE_V.SERVICE_LINE_DATE, dbo.TIME_CAPTURE_V.STATUS_ID, 
                      dbo.TIME_CAPTURE_V.status_name, dbo.TIME_CAPTURE_V.RESOURCE_ID, dbo.TIME_CAPTURE_V.ITEM_ID, dbo.TIME_CAPTURE_V.TC_QTY, 
                      dbo.TIME_CAPTURE_V.TC_RATE, dbo.TIME_CAPTURE_V.TC_TOTAL, dbo.TIME_CAPTURE_V.PAYROLL_QTY, dbo.TIME_CAPTURE_V.EXT_PAY_CODE, 
                      dbo.RESOURCES_V.EXT_EMPLOYEE_ID, dbo.RESOURCES_V.USER_ID, dbo.JOBS_V.CUSTOMER_ID, dbo.JOBS_V.CUSTOMER_NAME, 
                      dbo.JOBS_V.FOREMAN_RESOURCE_ID, dbo.JOBS_V.foreman_resource_name, dbo.JOBS_V.JOB_NAME, dbo.RESOURCES_V.resource_name, 
                      dbo.RESOURCES_V.resource_type_name, dbo.RESOURCES_V.RESOURCE_TYPE_ID, dbo.JOBS_V.billing_user_name, left(isnull(rtrim(RVM..GL00100.ACTNUMBR_1),'') + '-' +isnull(rtrim(RVM..GL00100.ACTNUMBR_2),'') + 
 '-' + isnull(rtrim(RVM..GL00100.ACTNUMBR_3),'') + '-' + isnull(rtrim(RVM..GL00100.ACTNUMBR_4), '') + 
 '-' + isnull(rtrim(RVM..GL00100.ACTNUMBR_5),''),13) as ACTNUM
FROM         dbo.RESOURCES_V RIGHT OUTER JOIN
                      dbo.TIME_CAPTURE_V ON dbo.RESOURCES_V.RESOURCE_ID = dbo.TIME_CAPTURE_V.RESOURCE_ID LEFT OUTER JOIN
                      dbo.JOBS_V ON dbo.TIME_CAPTURE_V.TC_JOB_ID = dbo.JOBS_V.JOB_ID
inner join RVM..IV00101 on ITEM_NAME=RVM..IV00101.ITMSHNAM
inner join RVM..GL00100 on RVM..IV00101.IVSLSIDX = RVM..GL00100.ACTINDX 
union all
SELECT   'TEST' as COMPANYID,ISNULL(dbo.TIME_CAPTURE_V.PAYROLL_QTY, 0) - ISNULL(dbo.TIME_CAPTURE_V.BILL_HOURLY_QTY, 0) AS hours_difference, 
                      CAST(dbo.JOBS_V.JOB_NO AS VARCHAR) AS job_no_varchar, dbo.TIME_CAPTURE_V.ORGANIZATION_ID, dbo.TIME_CAPTURE_V.TC_JOB_NO, 
                      dbo.TIME_CAPTURE_V.TC_SERVICE_NO, dbo.TIME_CAPTURE_V.TC_SERVICE_LINE_NO, dbo.TIME_CAPTURE_V.ITEM_NAME, 
                      dbo.TIME_CAPTURE_V.TC_JOB_ID, dbo.TIME_CAPTURE_V.TC_SERVICE_ID, dbo.TIME_CAPTURE_V.PH_SERVICE_ID, 
                      dbo.TIME_CAPTURE_V.SERVICE_LINE_ID, dbo.TIME_CAPTURE_V.SERVICE_LINE_DATE, dbo.TIME_CAPTURE_V.STATUS_ID, 
                      dbo.TIME_CAPTURE_V.status_name, dbo.TIME_CAPTURE_V.RESOURCE_ID, dbo.TIME_CAPTURE_V.ITEM_ID, dbo.TIME_CAPTURE_V.TC_QTY, 
                      dbo.TIME_CAPTURE_V.TC_RATE, dbo.TIME_CAPTURE_V.TC_TOTAL, dbo.TIME_CAPTURE_V.PAYROLL_QTY, dbo.TIME_CAPTURE_V.EXT_PAY_CODE, 
                      dbo.RESOURCES_V.EXT_EMPLOYEE_ID, dbo.RESOURCES_V.USER_ID, dbo.JOBS_V.CUSTOMER_ID, dbo.JOBS_V.CUSTOMER_NAME, 
                      dbo.JOBS_V.FOREMAN_RESOURCE_ID, dbo.JOBS_V.foreman_resource_name, dbo.JOBS_V.JOB_NAME, dbo.RESOURCES_V.resource_name, 
                      dbo.RESOURCES_V.resource_type_name, dbo.RESOURCES_V.RESOURCE_TYPE_ID, dbo.JOBS_V.billing_user_name, left(isnull(rtrim(TEST..GL00100.ACTNUMBR_1),'') + '-' +isnull(rtrim(TEST..GL00100.ACTNUMBR_2),'') + 
 '-' + isnull(rtrim(TEST..GL00100.ACTNUMBR_3),'') + '-' + isnull(rtrim(TEST..GL00100.ACTNUMBR_4), '') + 
 '-' + isnull(rtrim(TEST..GL00100.ACTNUMBR_5),''),13) as ACTNUM
FROM         dbo.RESOURCES_V RIGHT OUTER JOIN
                      dbo.TIME_CAPTURE_V ON dbo.RESOURCES_V.RESOURCE_ID = dbo.TIME_CAPTURE_V.RESOURCE_ID LEFT OUTER JOIN
                      dbo.JOBS_V ON dbo.TIME_CAPTURE_V.TC_JOB_ID = dbo.JOBS_V.JOB_ID
inner join TEST..IV00101 on ITEM_NAME=TEST..IV00101.ITMSHNAM
inner join TEST..GL00100 on TEST..IV00101.IVSLSIDX = TEST..GL00100.ACTINDX
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

CREATE VIEW [dbo].[JOB_PROGRESS_2_V]
AS
SELECT     ORGANIZATION_ID, PROJECT_ID, PROJECT_NO, CUSTOMER_ID, PARENT_CUSTOMER_ID, CUSTOMER_NAME, JOB_NAME, install_foreman, 
                      JOB_STATUS_TYPE_ID, job_status_type_code, job_status_type_name, min_start_date, max_end_date, CAST(DATEDIFF([hour], min_start_date, 
                      max_end_date + 1) AS numeric) AS duration, GETDATE() AS cur_date, CAST(DATEDIFF([hour], GETDATE(), max_end_date + 1) AS numeric) 
                      AS cur_duration_left, PERCENT_COMPLETE, punchlist_count, EXT_DEALER_ID, DEALER_NAME, project_status_type_code
FROM         dbo.JOB_PROGRESS_1_V
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
