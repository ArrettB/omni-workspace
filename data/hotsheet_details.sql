/* ---------------------------------------------------------------------- */
/* Add table "HOTSHEET_DETAILS"                                           */
/* ---------------------------------------------------------------------- */
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HOTSHEET_DETAILS] (
    [HOTSHEET_ID] NUMERIC(18) NOT NULL,
    [HOTSHEET_DETAIL_LOOKUP_ID] NUMERIC(18) NOT NULL,
    [ATTRIBUTE_VALUE] INTEGER,
    [CREATED_BY] NUMERIC(18) NOT NULL,
    [DATE_CREATED] DATETIME NOT NULL,
    [DATE_MODIFIED] DATETIME NOT NULL,
    [MODIFIED_BY] NUMERIC(18) NOT NULL,
    CONSTRAINT [PK_HOTSHEET_DETAILS] PRIMARY KEY ([HOTSHEET_ID], [HOTSHEET_DETAIL_LOOKUP_ID])
)
GO


ALTER TABLE [HOTSHEET_DETAILS] ADD CONSTRAINT [HOTSHEETS_HOTSHEET_DETAILS] 
    FOREIGN KEY ([HOTSHEET_ID]) REFERENCES [HOTSHEETS] ([HOTSHEET_ID])
GO

ALTER TABLE [HOTSHEET_DETAILS] ADD CONSTRAINT [LOOKUPS_HOTSHEET_DETAILS] 
    FOREIGN KEY ([HOTSHEET_DETAIL_LOOKUP_ID]) REFERENCES [LOOKUPS] ([LOOKUP_ID])
GO
