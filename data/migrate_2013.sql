/**
 * Add the table for calendars for the JOB_LOCATION
 * Add a column for the calendar ID for JOB_LOCATION
 */
/*
 * Alter the requests table and add the foreign key
 */
ALTER TABLE [dbo].[JOB_LOCATIONS]
   ADD [JOB_LOCATION_CALENDAR_ID]  [NUMERIC](18,0)
GO

CREATE TABLE [JOB_LOCATION_CALENDARS] (
    [CALENDAR_ID] NUMERIC(18) IDENTITY(1,1) NOT NULL,
    [CODE] VARCHAR(50) NOT NULL, --  MN010
    [DESCRIPTION] VARCHAR(20) NOT NULL,   -- Whitewater
    [EMAIL_ADDRESS] VARCHAR(250) NOT NULL,  -- email account for the calendar entry
    [PASSWORD] VARCHAR(100) NOT NULL,   -- password for the email account
    CONSTRAINT [PK_JOB_LOC_CALENDAR] PRIMARY KEY ([CALENDAR_ID])
)
GO

INSERT INTO JOB_LOCATION_CALENDARS (CODE, DESCRIPTION, EMAIL_ADDRESS, PASSWORD) VALUES ('WI080', 'Eau Claire', 'eauclaireuhg@omniworkspace.com', 'teamuhg')
GO
INSERT INTO JOB_LOCATION_CALENDARS (CODE, DESCRIPTION, EMAIL_ADDRESS, PASSWORD) VALUES ('MN002', 'Eden Prairie-Tech', 'optumuhg@omniworkspace.com', 'teamuhg')
GO
INSERT INTO JOB_LOCATION_CALENDARS (CODE, DESCRIPTION, EMAIL_ADDRESS, PASSWORD) VALUES ('MN051', 'Optum', 'optumuhg@omniworkspace.com', 'teamuhg')
GO
INSERT INTO JOB_LOCATION_CALENDARS (CODE, DESCRIPTION, EMAIL_ADDRESS, PASSWORD) VALUES ('MN038', 'Valley View', 'optumuhg@omniworkspace.com', 'teamuhg')
GO
INSERT INTO JOB_LOCATION_CALENDARS (CODE, DESCRIPTION, EMAIL_ADDRESS, PASSWORD) VALUES ('MN022', 'Whitewater 2', 'shadyoakuhg@omniworkspace.com', 'teamuhg')
GO
INSERT INTO JOB_LOCATION_CALENDARS (CODE, DESCRIPTION, EMAIL_ADDRESS, PASSWORD) VALUES ('MN045', 'Marketpointe', 'shadyoakuhg@omniworkspace.com', 'teamuhg')
GO
INSERT INTO JOB_LOCATION_CALENDARS (CODE, DESCRIPTION, EMAIL_ADDRESS, PASSWORD) VALUES ('MN010', 'G.V.', 'goldenvalleyuhg@omniworkspace.com', 'teamuhg')
GO
INSERT INTO JOB_LOCATION_CALENDARS (CODE, DESCRIPTION, EMAIL_ADDRESS, PASSWORD) VALUES ('MN013', 'Plymouth', 'goldenvalleyuhg@omniworkspace.com', 'teamuhg')
GO
INSERT INTO JOB_LOCATION_CALENDARS (CODE, DESCRIPTION, EMAIL_ADDRESS, PASSWORD) VALUES ('MN030', 'Metropointe', 'goldenvalleyuhg@omniworkspace.com', 'teamuhg')
GO
INSERT INTO JOB_LOCATION_CALENDARS (CODE, DESCRIPTION, EMAIL_ADDRESS, PASSWORD) VALUES ('MN009', 'OTC', 'goldenvalleyuhg@omniworkspace.com', 'teamuhg')
GO
INSERT INTO JOB_LOCATION_CALENDARS (CODE, DESCRIPTION, EMAIL_ADDRESS, PASSWORD) VALUES ('MN008', 'Opus', '99uhg@omniworkspace.com', 'teamuhg')
GO
INSERT INTO JOB_LOCATION_CALENDARS (CODE, DESCRIPTION, EMAIL_ADDRESS, PASSWORD) VALUES ('MN005', 'Brenwood', '99uhg@omniworkspace.com', 'teamuhg')
GO
INSERT INTO JOB_LOCATION_CALENDARS (CODE, DESCRIPTION, EMAIL_ADDRESS, PASSWORD) VALUES ('MN082', 'G & K', '99uhg@omniworkspace.com', 'teamuhg')
GO
INSERT INTO JOB_LOCATION_CALENDARS (CODE, DESCRIPTION, EMAIL_ADDRESS, PASSWORD) VALUES ('MN006', '9800', '98uhg@omniworkspace.com', 'teamuhg')
GO
INSERT INTO JOB_LOCATION_CALENDARS (CODE, DESCRIPTION, EMAIL_ADDRESS, PASSWORD) VALUES ('MN004', 'Whitewater 2', '97uhg@omniworkspace.com', 'teamuhg')
GO
INSERT INTO JOB_LOCATION_CALENDARS (CODE, DESCRIPTION, EMAIL_ADDRESS, PASSWORD) VALUES ('MN017', '9700', '97uhg@omniworkspace.com', 'teamuhg')
GO
INSERT INTO JOB_LOCATION_CALENDARS (CODE, DESCRIPTION, EMAIL_ADDRESS, PASSWORD) VALUES ('*MN*', 'ALL MN SITES', 'truckmoves@omniworkspace.com', 'teamuhg')
GO
INSERT INTO JOB_LOCATION_CALENDARS (CODE, DESCRIPTION, EMAIL_ADDRESS, PASSWORD) VALUES ('MN011', 'Chaska', 'truckmoves@omniworkspace.com', 'teamuhg')
GO
INSERT INTO JOB_LOCATION_CALENDARS (CODE, DESCRIPTION, EMAIL_ADDRESS, PASSWORD) VALUES ('MN039', 'Foss Swim', 'truckmoves@omniworkspace.com', 'teamuhg')
GO
INSERT INTO JOB_LOCATION_CALENDARS (CODE, DESCRIPTION, EMAIL_ADDRESS, PASSWORD) VALUES ('MN053', 'Elk River', 'truckmoves@omniworkspace.com', 'teamuhg')
GO
INSERT INTO JOB_LOCATION_CALENDARS (CODE, DESCRIPTION, EMAIL_ADDRESS, PASSWORD) VALUES ('MN990', 'Home Office', 'truckmoves@omniworkspace.com', 'teamuhg')
GO
INSERT INTO JOB_LOCATION_CALENDARS (CODE, DESCRIPTION, EMAIL_ADDRESS, PASSWORD) VALUES ('MN015', 'Duluth', 'michaelmunsterman@uhg.com', 'teamuhg')
GO
INSERT INTO JOB_LOCATION_CALENDARS (CODE, DESCRIPTION, EMAIL_ADDRESS, PASSWORD) VALUES ('MN020', 'International Falls', 'michaelmunsterman@uhg.com', 'teamuhg')
GO
