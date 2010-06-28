/* ---------------------------------------------------------------------- */
/* Add table "HOTSHEETS"                                                  */
/* ---------------------------------------------------------------------- */

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HOTSHEETS] (
    [HOTSHEET_ID] NUMERIC(18) IDENTITY(1,1) NOT NULL,
    [HOTSHEET_NO] INTEGER NOT NULL,
    [HOTSHEET_IDENTIFIER] VARCHAR(100) NOT NULL,
    [JOB_LOCATION_CONTACT_ID] NUMERIC(18) NOT NULL,
    [REQUEST_ID] NUMERIC(18) NOT NULL,
    [REQUEST_TYPE_ID] NUMERIC(18) NOT NULL,
    [PROJECT_ID] NUMERIC(18) NOT NULL,
    [END_USER_ID] NUMERIC(18) NOT NULL,
    [CUSTOMER_ID] NUMERIC(18) NOT NULL,
    [ORIGIN_ADDRESS_ID] NUMERIC(18) NOT NULL,
    [JOB_LOCATION_ADDRESS_ID] NUMERIC(18) NOT NULL,
    [EXT_CUSTOMER_ID] CHAR (15) NOT NULL,
    [PROJECT_NAME] VARCHAR(100) NOT NULL,
    [CUSTOMER_NAME] VARCHAR(100) NOT NULL,
    [END_USER_NAME] VARCHAR(100) NOT NULL,
    [DEALER_PO_NUMBER] VARCHAR(512),
    [JOB_DATE] DATETIME NOT NULL,
    [JOB_START_TIME] INTEGER NOT NULL,
    [WHSE_START_TIME] INTEGER NOT NULL,
    [JOB_LENGTH] INTEGER NOT NULL,
    [SPECIAL_INSTRUCTIONS] VARCHAR(1000),
    [REQUEST_CREATED_DATE] DATETIME,
    [REQUEST_CREATED_NAME] VARCHAR(100),
    [REQUEST_MODIFIED_DATE] DATETIME,
    [REQUEST_MODIFIED_NAME] VARCHAR(100),
    [DATE_CREATED] DATETIME NOT NULL,
    [CREATED_BY] NUMERIC(18) NOT NULL,
    [DATE_MODIFIED] DATETIME,
    [MODIFIED_BY] NUMERIC(18),
    [BL_CHRG] VARCHAR(1),
    [ORIGIN_CONTACT_ID] NUMERIC(18),
    [ORIGIN_CONTACT_NAME] VARCHAR(100) NOT NULL,
    [ORIGIN_CONTACT_PHONE] VARCHAR(100) NOT NULL
    CONSTRAINT [PK_HOTSHEETS] PRIMARY KEY ([HOTSHEET_ID])
)
GO


ALTER TABLE [HOTSHEETS] ADD CONSTRAINT [JOB_LOCATION_CONTACT_HOTSHEETS]
    FOREIGN KEY ([JOB_LOCATION_CONTACT_ID]) REFERENCES [CONTACTS] ([CONTACT_ID])
GO

ALTER TABLE [HOTSHEETS] ADD CONSTRAINT [REQUESTS_HOTSHEETS]
    FOREIGN KEY ([REQUEST_ID]) REFERENCES [REQUESTS] ([REQUEST_ID])
GO

ALTER TABLE [HOTSHEETS] ADD CONSTRAINT [PROJECTS_HOTSHEETS]
    FOREIGN KEY ([PROJECT_ID]) REFERENCES [PROJECTS] ([PROJECT_ID])
GO

ALTER TABLE [HOTSHEETS] ADD CONSTRAINT [FK_LOOKUPS_REQUEST_TYPE_HOTSHEETS]
    FOREIGN KEY ([REQUEST_TYPE_ID]) REFERENCES [LOOKUPS] ([LOOKUP_ID])
GO

