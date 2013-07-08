/*
 * Update the job locations for the proper calendar ID
 */
--INSERT INTO JOB_LOCATION_CALENDARS (CODE, DESCRIPTION, EMAIL_ADDRESS, PASSWORD) VALUES ('WI080', 'Eau Claire', 'eauclaire@omniworkspace.com', 'teamuhg')
UPDATE JOB_LOCATIONS
   SET JOB_LOCATION_CALENDAR_ID = ( SELECT JLC.CALENDAR_ID FROM JOB_LOCATION_CALENDARS JLC WHERE CODE = 'WI080')
 WHERE JOB_LOCATIONS.JOB_LOCATION_NAME LIKE 'WI080%'
   AND JOB_LOCATIONS.CUSTOMER_ID = 2866
   AND JOB_LOCATIONS.JOB_LOCATION_CALENDAR_ID IS NULL;

--INSERT INTO JOB_LOCATION_CALENDARS (CODE, DESCRIPTION, EMAIL_ADDRESS, PASSWORD) VALUES ('MN002', 'Eden Prairie-Tech', 'optumuhg@omniworkspace.com', 'teamuhg')
UPDATE JOB_LOCATIONS
   SET JOB_LOCATION_CALENDAR_ID = ( SELECT JLC.CALENDAR_ID FROM JOB_LOCATION_CALENDARS JLC WHERE CODE = 'MN002')
 WHERE JOB_LOCATIONS.JOB_LOCATION_NAME LIKE 'MN002%'
   AND JOB_LOCATIONS.CUSTOMER_ID = 2866
   AND JOB_LOCATIONS.JOB_LOCATION_CALENDAR_ID IS NULL;

--INSERT INTO JOB_LOCATION_CALENDARS (CODE, DESCRIPTION, EMAIL_ADDRESS, PASSWORD) VALUES ('MN051', 'Optum', 'optumuhg@omniworkspace.com', 'teamuhg')
UPDATE JOB_LOCATIONS
   SET JOB_LOCATION_CALENDAR_ID = ( SELECT JLC.CALENDAR_ID FROM JOB_LOCATION_CALENDARS JLC WHERE CODE = 'MN051')
 WHERE JOB_LOCATIONS.JOB_LOCATION_NAME LIKE 'MN051%'
   AND JOB_LOCATIONS.CUSTOMER_ID = 2866
   AND JOB_LOCATIONS.JOB_LOCATION_CALENDAR_ID IS NULL;

--INSERT INTO JOB_LOCATION_CALENDARS (CODE, DESCRIPTION, EMAIL_ADDRESS, PASSWORD) VALUES ('MN038', 'Valley View', 'optumuhg@omniworkspace.com', 'teamuhg')
UPDATE JOB_LOCATIONS
   SET JOB_LOCATION_CALENDAR_ID = ( SELECT JLC.CALENDAR_ID FROM JOB_LOCATION_CALENDARS JLC WHERE CODE = 'MN038')
 WHERE JOB_LOCATIONS.JOB_LOCATION_NAME LIKE 'MN038%'
   AND JOB_LOCATIONS.CUSTOMER_ID = 2866
   AND JOB_LOCATIONS.JOB_LOCATION_CALENDAR_ID IS NULL;

--INSERT INTO JOB_LOCATION_CALENDARS (CODE, DESCRIPTION, EMAIL_ADDRESS, PASSWORD) VALUES ('MN022', 'Whitewater 2', 'shadyoakuhg@omniworkspace.com', 'teamuhg')
UPDATE JOB_LOCATIONS
   SET JOB_LOCATION_CALENDAR_ID = ( SELECT JLC.CALENDAR_ID FROM JOB_LOCATION_CALENDARS JLC WHERE CODE = 'MN022')
 WHERE JOB_LOCATIONS.JOB_LOCATION_NAME LIKE 'MN022%'
   AND JOB_LOCATIONS.CUSTOMER_ID = 2866
   AND JOB_LOCATIONS.JOB_LOCATION_CALENDAR_ID IS NULL;

--INSERT INTO JOB_LOCATION_CALENDARS (CODE, DESCRIPTION, EMAIL_ADDRESS, PASSWORD) VALUES ('MN045', 'Marketpointe', 'shadyoakuhg@omniworkspace.com', 'teamuhg')
UPDATE JOB_LOCATIONS
   SET JOB_LOCATION_CALENDAR_ID = ( SELECT JLC.CALENDAR_ID FROM JOB_LOCATION_CALENDARS JLC WHERE CODE = 'MN045')
 WHERE JOB_LOCATIONS.JOB_LOCATION_NAME LIKE 'MN045%'
   AND JOB_LOCATIONS.CUSTOMER_ID = 2866
   AND JOB_LOCATIONS.JOB_LOCATION_CALENDAR_ID IS NULL;

--INSERT INTO JOB_LOCATION_CALENDARS (CODE, DESCRIPTION, EMAIL_ADDRESS, PASSWORD) VALUES ('MN010', 'G.V.', 'goldenvalleyuhg@omniworkspace.com', 'teamuhg')
UPDATE JOB_LOCATIONS
   SET JOB_LOCATION_CALENDAR_ID = ( SELECT JLC.CALENDAR_ID FROM JOB_LOCATION_CALENDARS JLC WHERE CODE = 'MN010')
 WHERE JOB_LOCATIONS.JOB_LOCATION_NAME LIKE 'MN010%'
   AND JOB_LOCATIONS.CUSTOMER_ID = 2866
   AND JOB_LOCATIONS.JOB_LOCATION_CALENDAR_ID IS NULL;

--INSERT INTO JOB_LOCATION_CALENDARS (CODE, DESCRIPTION, EMAIL_ADDRESS, PASSWORD) VALUES ('MN013', 'Plymouth', 'goldenvalleyuhg@omniworkspace.com', 'teamuhg')
UPDATE JOB_LOCATIONS
   SET JOB_LOCATION_CALENDAR_ID = ( SELECT JLC.CALENDAR_ID FROM JOB_LOCATION_CALENDARS JLC WHERE CODE = 'MN013')
 WHERE JOB_LOCATIONS.JOB_LOCATION_NAME LIKE 'MN013%'
   AND JOB_LOCATIONS.CUSTOMER_ID = 2866
   AND JOB_LOCATIONS.JOB_LOCATION_CALENDAR_ID IS NULL;

--INSERT INTO JOB_LOCATION_CALENDARS (CODE, DESCRIPTION, EMAIL_ADDRESS, PASSWORD) VALUES ('MN030', 'Metropointe', 'goldenvalleyuhg@omniworkspace.com', 'teamuhg')
UPDATE JOB_LOCATIONS
   SET JOB_LOCATION_CALENDAR_ID = ( SELECT JLC.CALENDAR_ID FROM JOB_LOCATION_CALENDARS JLC WHERE CODE = 'MN030')
 WHERE JOB_LOCATIONS.JOB_LOCATION_NAME LIKE 'MN030%'
   AND JOB_LOCATIONS.CUSTOMER_ID = 2866
   AND JOB_LOCATIONS.JOB_LOCATION_CALENDAR_ID IS NULL;

--INSERT INTO JOB_LOCATION_CALENDARS (CODE, DESCRIPTION, EMAIL_ADDRESS, PASSWORD) VALUES ('MN009', 'OTC', 'goldenvalleyuhg@omniworkspace.com', 'teamuhg')
UPDATE JOB_LOCATIONS
   SET JOB_LOCATION_CALENDAR_ID = ( SELECT JLC.CALENDAR_ID FROM JOB_LOCATION_CALENDARS JLC WHERE CODE = 'MN009')
 WHERE JOB_LOCATIONS.JOB_LOCATION_NAME LIKE 'MN009%'
   AND JOB_LOCATIONS.CUSTOMER_ID = 2866
   AND JOB_LOCATIONS.JOB_LOCATION_CALENDAR_ID IS NULL;

--INSERT INTO JOB_LOCATION_CALENDARS (CODE, DESCRIPTION, EMAIL_ADDRESS, PASSWORD) VALUES ('MN008', 'Opus', '99uhg@omniworkspace.com', 'teamuhg')
UPDATE JOB_LOCATIONS
   SET JOB_LOCATION_CALENDAR_ID = ( SELECT JLC.CALENDAR_ID FROM JOB_LOCATION_CALENDARS JLC WHERE CODE = 'MN008')
 WHERE JOB_LOCATIONS.JOB_LOCATION_NAME LIKE 'MN008%'
   AND JOB_LOCATIONS.CUSTOMER_ID = 2866
   AND JOB_LOCATIONS.JOB_LOCATION_CALENDAR_ID IS NULL;

--INSERT INTO JOB_LOCATION_CALENDARS (CODE, DESCRIPTION, EMAIL_ADDRESS, PASSWORD) VALUES ('MN005', 'Brenwood', '99uhg@omniworkspace.com', 'teamuhg')
UPDATE JOB_LOCATIONS
   SET JOB_LOCATION_CALENDAR_ID = ( SELECT JLC.CALENDAR_ID FROM JOB_LOCATION_CALENDARS JLC WHERE CODE = 'MN005')
 WHERE JOB_LOCATIONS.JOB_LOCATION_NAME LIKE 'MN005%'
   AND JOB_LOCATIONS.CUSTOMER_ID = 2866
   AND JOB_LOCATIONS.JOB_LOCATION_CALENDAR_ID IS NULL;

--INSERT INTO JOB_LOCATION_CALENDARS (CODE, DESCRIPTION, EMAIL_ADDRESS, PASSWORD) VALUES ('MN082', 'G & K', '99uhg@omniworkspace.com', 'teamuhg')
UPDATE JOB_LOCATIONS
   SET JOB_LOCATION_CALENDAR_ID = ( SELECT JLC.CALENDAR_ID FROM JOB_LOCATION_CALENDARS JLC WHERE CODE = 'MN082')
 WHERE JOB_LOCATIONS.JOB_LOCATION_NAME LIKE 'MN082%'
   AND JOB_LOCATIONS.CUSTOMER_ID = 2866
   AND JOB_LOCATIONS.JOB_LOCATION_CALENDAR_ID IS NULL;

--INSERT INTO JOB_LOCATION_CALENDARS (CODE, DESCRIPTION, EMAIL_ADDRESS, PASSWORD) VALUES ('MN006', '9800', '98uhg@omniworkspace.com', 'teamuhg')
UPDATE JOB_LOCATIONS
   SET JOB_LOCATION_CALENDAR_ID = ( SELECT JLC.CALENDAR_ID FROM JOB_LOCATION_CALENDARS JLC WHERE CODE = 'MN006')
 WHERE JOB_LOCATIONS.JOB_LOCATION_NAME LIKE 'MN006%'
   AND JOB_LOCATIONS.CUSTOMER_ID = 2866
   AND JOB_LOCATIONS.JOB_LOCATION_CALENDAR_ID IS NULL;

--INSERT INTO JOB_LOCATION_CALENDARS (CODE, DESCRIPTION, EMAIL_ADDRESS, PASSWORD) VALUES ('MN004', 'Whitewater 2', '97uhg@omniworkspace.com', 'teamuhg')
UPDATE JOB_LOCATIONS
   SET JOB_LOCATION_CALENDAR_ID = ( SELECT JLC.CALENDAR_ID FROM JOB_LOCATION_CALENDARS JLC WHERE CODE = 'MN004')
 WHERE JOB_LOCATIONS.JOB_LOCATION_NAME LIKE 'MN004%'
   AND JOB_LOCATIONS.CUSTOMER_ID = 2866
   AND JOB_LOCATIONS.JOB_LOCATION_CALENDAR_ID IS NULL;

--INSERT INTO JOB_LOCATION_CALENDARS (CODE, DESCRIPTION, EMAIL_ADDRESS, PASSWORD) VALUES ('MN017', '9700', '97uhg@omniworkspace.com', 'teamuhg')
UPDATE JOB_LOCATIONS
   SET JOB_LOCATION_CALENDAR_ID = ( SELECT JLC.CALENDAR_ID FROM JOB_LOCATION_CALENDARS JLC WHERE CODE = 'MN017')
 WHERE JOB_LOCATIONS.JOB_LOCATION_NAME LIKE 'MN017%'
   AND JOB_LOCATIONS.CUSTOMER_ID = 2866
   AND JOB_LOCATIONS.JOB_LOCATION_CALENDAR_ID IS NULL;

--INSERT INTO JOB_LOCATION_CALENDARS (CODE, DESCRIPTION, EMAIL_ADDRESS, PASSWORD) VALUES ('*MN*', 'ALL MN SITES', 'truckmoves@omniworkspace.com', 'teamuhg')
UPDATE JOB_LOCATIONS
   SET JOB_LOCATION_CALENDAR_ID = ( SELECT JLC.CALENDAR_ID FROM JOB_LOCATION_CALENDARS JLC WHERE CODE = '*MN*')
 WHERE JOB_LOCATIONS.JOB_LOCATION_NAME LIKE '*MN*%'
   AND JOB_LOCATIONS.CUSTOMER_ID = 2866
   AND JOB_LOCATIONS.JOB_LOCATION_CALENDAR_ID IS NULL;

--INSERT INTO JOB_LOCATION_CALENDARS (CODE, DESCRIPTION, EMAIL_ADDRESS, PASSWORD) VALUES ('MN011', 'Chaska', 'truckmoves@omniworkspace.com', 'teamuhg')
UPDATE JOB_LOCATIONS
   SET JOB_LOCATION_CALENDAR_ID = ( SELECT JLC.CALENDAR_ID FROM JOB_LOCATION_CALENDARS JLC WHERE CODE = 'MN011')
 WHERE JOB_LOCATIONS.JOB_LOCATION_NAME LIKE 'MN011%'
   AND JOB_LOCATIONS.CUSTOMER_ID = 2866
   AND JOB_LOCATIONS.JOB_LOCATION_CALENDAR_ID IS NULL;

--INSERT INTO JOB_LOCATION_CALENDARS (CODE, DESCRIPTION, EMAIL_ADDRESS, PASSWORD) VALUES ('MN039', 'Foss Swim', 'truckmoves@omniworkspace.com', 'teamuhg')
UPDATE JOB_LOCATIONS
   SET JOB_LOCATION_CALENDAR_ID = ( SELECT JLC.CALENDAR_ID FROM JOB_LOCATION_CALENDARS JLC WHERE CODE = 'MN039')
 WHERE JOB_LOCATIONS.JOB_LOCATION_NAME LIKE 'MN039%'
   AND JOB_LOCATIONS.CUSTOMER_ID = 2866
   AND JOB_LOCATIONS.JOB_LOCATION_CALENDAR_ID IS NULL;

--INSERT INTO JOB_LOCATION_CALENDARS (CODE, DESCRIPTION, EMAIL_ADDRESS, PASSWORD) VALUES ('MN053', 'Elk River', 'truckmoves@omniworkspace.com', 'teamuhg')
UPDATE JOB_LOCATIONS
   SET JOB_LOCATION_CALENDAR_ID = ( SELECT JLC.CALENDAR_ID FROM JOB_LOCATION_CALENDARS JLC WHERE CODE = 'MN053')
 WHERE JOB_LOCATIONS.JOB_LOCATION_NAME LIKE 'MN053%'
   AND JOB_LOCATIONS.CUSTOMER_ID = 2866
   AND JOB_LOCATIONS.JOB_LOCATION_CALENDAR_ID IS NULL;

--INSERT INTO JOB_LOCATION_CALENDARS (CODE, DESCRIPTION, EMAIL_ADDRESS, PASSWORD) VALUES ('MN990', 'Home Office', 'truckmoves@omniworkspace.com', 'teamuhg')
UPDATE JOB_LOCATIONS
   SET JOB_LOCATION_CALENDAR_ID = ( SELECT JLC.CALENDAR_ID FROM JOB_LOCATION_CALENDARS JLC WHERE CODE = 'MN990')
 WHERE JOB_LOCATIONS.JOB_LOCATION_NAME LIKE 'MN990%'
   AND JOB_LOCATIONS.CUSTOMER_ID = 2866
   AND JOB_LOCATIONS.JOB_LOCATION_CALENDAR_ID IS NULL;

--INSERT INTO JOB_LOCATION_CALENDARS (CODE, DESCRIPTION, EMAIL_ADDRESS, PASSWORD) VALUES ('MN015', 'Duluth', 'michaelmunsterman@uhg.com', 'teamuhg')
UPDATE JOB_LOCATIONS
   SET JOB_LOCATION_CALENDAR_ID = ( SELECT JLC.CALENDAR_ID FROM JOB_LOCATION_CALENDARS JLC WHERE CODE = 'MN015')
 WHERE JOB_LOCATIONS.JOB_LOCATION_NAME LIKE 'MN015%'
   AND JOB_LOCATIONS.CUSTOMER_ID = 2866
   AND JOB_LOCATIONS.JOB_LOCATION_CALENDAR_ID IS NULL;

--INSERT INTO JOB_LOCATION_CALENDARS (CODE, DESCRIPTION, EMAIL_ADDRESS, PASSWORD) VALUES ('MN020', 'International Falls', 'michaelmunsterman@uhg.com', 'teamuhg')
UPDATE JOB_LOCATIONS
   SET JOB_LOCATION_CALENDAR_ID = ( SELECT JLC.CALENDAR_ID FROM JOB_LOCATION_CALENDARS JLC WHERE CODE = 'MN020')
 WHERE JOB_LOCATIONS.JOB_LOCATION_NAME LIKE 'MN020%'
   AND JOB_LOCATIONS.CUSTOMER_ID = 2866
   AND JOB_LOCATIONS.JOB_LOCATION_CALENDAR_ID IS NULL;