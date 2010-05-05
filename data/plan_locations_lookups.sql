/*
 * SQL script to create the Plan Locations lookup types and LOOKUPS entries
 *
 * Created by Dave Andreasen - Kettle River Consulting
 */
SET IDENTITY_INSERT LOOKUP_TYPES on
INSERT
INTO
    dbo.LOOKUP_TYPES
    (
        LOOKUP_TYPE_ID,
        CODE,
        NAME,
        ACTIVE_FLAG,
        UPDATABLE_FLAG,
        PARENT_TYPE_ID,
        DATE_CREATED,
        CREATED_BY
    )
    VALUES
    (
        84,
        'plan_locations_type',
        'Plan Locations',
        'Y',
        'Y',
        NULL,
        CURRENT_TIMESTAMP,
        2
    )
GO
SET IDENTITY_INSERT LOOKUP_TYPES off

/*
 * LOOKUPS
 */
INSERT INTO dbo.LOOKUPS ( LOOKUP_TYPE_ID, CODE, NAME, SEQUENCE_NO, ACTIVE_FLAG, UPDATABLE_FLAG, DATE_CREATED,CREATED_BY) VALUES
    ( 84, 'location_other', 'Other (please specify in scope of work)', 1, 'Y', 'Y', CURRENT_TIMESTAMP, 2 )
GO
INSERT INTO dbo.LOOKUPS ( LOOKUP_TYPE_ID, CODE, NAME, SEQUENCE_NO, ACTIVE_FLAG, UPDATABLE_FLAG, DATE_CREATED,CREATED_BY) VALUES
    ( 84, 'attached_to_st', 'Attached to ST', 2, 'Y', 'Y', CURRENT_TIMESTAMP, 2 )
GO
INSERT INTO dbo.LOOKUPS ( LOOKUP_TYPE_ID, CODE, NAME, SEQUENCE_NO, ACTIVE_FLAG, UPDATABLE_FLAG, DATE_CREATED,CREATED_BY) VALUES
    ( 84, 'give_to_idm', 'Given to IDM', 3, 'Y', 'Y', CURRENT_TIMESTAMP, 2 )
GO
INSERT INTO dbo.LOOKUPS ( LOOKUP_TYPE_ID, CODE, NAME, SEQUENCE_NO, ACTIVE_FLAG, UPDATABLE_FLAG, DATE_CREATED,CREATED_BY) VALUES
    ( 84, 'sent_via_oss', 'Sent via OSS', 4, 'Y', 'Y', CURRENT_TIMESTAMP, 2 )
GO
INSERT INTO dbo.LOOKUPS ( LOOKUP_TYPE_ID, CODE, NAME, SEQUENCE_NO, ACTIVE_FLAG, UPDATABLE_FLAG, DATE_CREATED,CREATED_BY) VALUES
    ( 84, 'no_drawing', 'No drawing provided', 5, 'Y', 'Y', CURRENT_TIMESTAMP, 2 )
GO
