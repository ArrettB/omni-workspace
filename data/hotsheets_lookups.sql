/*
 * SQL script to create the HOTSHEET_DETAILS lookup types and LOOKUPS entries
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
        83,
        'hotsheet_detail_type',
        'Hotsheet Detail',
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
    ( 83, 'service_van_qty', 'Service Van Quantity', 1, 'Y', 'Y', CURRENT_TIMESTAMP, 2 )
GO
INSERT INTO dbo.LOOKUPS ( LOOKUP_TYPE_ID, CODE, NAME, SEQUENCE_NO, ACTIVE_FLAG, UPDATABLE_FLAG, DATE_CREATED,CREATED_BY) VALUES
    ( 83, 'bobtail_qty', 'Bobtail Quantity', 2, 'Y', 'Y', CURRENT_TIMESTAMP, 2 )
GO
INSERT INTO dbo.LOOKUPS ( LOOKUP_TYPE_ID, CODE, NAME, SEQUENCE_NO, ACTIVE_FLAG, UPDATABLE_FLAG, DATE_CREATED,CREATED_BY) VALUES
    ( 83, 'box_van_qty', 'Box Van Quantity', 3, 'Y', 'Y', CURRENT_TIMESTAMP, 2 )
GO
INSERT INTO dbo.LOOKUPS ( LOOKUP_TYPE_ID, CODE, NAME, SEQUENCE_NO, ACTIVE_FLAG, UPDATABLE_FLAG, DATE_CREATED,CREATED_BY) VALUES
    ( 83, 'tractor_qty', 'Tractor Quantity', 4, 'Y', 'Y', CURRENT_TIMESTAMP, 2 )
GO
INSERT INTO dbo.LOOKUPS ( LOOKUP_TYPE_ID, CODE, NAME, SEQUENCE_NO, ACTIVE_FLAG, UPDATABLE_FLAG, DATE_CREATED,CREATED_BY) VALUES
    ( 83, 'trailer_qty', 'Trailer Quantity', 5, 'Y', 'Y', CURRENT_TIMESTAMP, 2 )
GO
INSERT INTO dbo.LOOKUPS ( LOOKUP_TYPE_ID, CODE, NAME, SEQUENCE_NO, ACTIVE_FLAG, UPDATABLE_FLAG, DATE_CREATED,CREATED_BY) VALUES
    ( 83, 'lead_qty', 'Lead Quantity', 6, 'Y', 'Y', CURRENT_TIMESTAMP, 2 )
GO
INSERT INTO dbo.LOOKUPS ( LOOKUP_TYPE_ID, CODE, NAME, SEQUENCE_NO, ACTIVE_FLAG, UPDATABLE_FLAG, DATE_CREATED,CREATED_BY) VALUES
    ( 83, 'driver_qty', 'Driver Quantity', 7, 'Y', 'Y', CURRENT_TIMESTAMP, 2 )
GO
INSERT INTO dbo.LOOKUPS ( LOOKUP_TYPE_ID, CODE, NAME, SEQUENCE_NO, ACTIVE_FLAG, UPDATABLE_FLAG, DATE_CREATED,CREATED_BY) VALUES
    ( 83, 'installer_qty', 'Installer Quantity', 8, 'Y', 'Y', CURRENT_TIMESTAMP, 2 )
GO
INSERT INTO dbo.LOOKUPS ( LOOKUP_TYPE_ID, CODE, NAME, SEQUENCE_NO, ACTIVE_FLAG, UPDATABLE_FLAG, DATE_CREATED,CREATED_BY) VALUES
    ( 83, 'mover_qty', 'Mover Quantity', 9, 'Y', 'Y', CURRENT_TIMESTAMP, 2 )
GO

INSERT INTO dbo.LOOKUPS ( LOOKUP_TYPE_ID, CODE, NAME, SEQUENCE_NO, ACTIVE_FLAG, UPDATABLE_FLAG, DATE_CREATED,CREATED_BY) VALUES
    ( 83, 'custom_equipment_1', 'Custom One', 10, 'Y', 'Y', CURRENT_TIMESTAMP, 2 )
GO
INSERT INTO dbo.LOOKUPS ( LOOKUP_TYPE_ID, CODE, NAME, SEQUENCE_NO, ACTIVE_FLAG, UPDATABLE_FLAG, DATE_CREATED,CREATED_BY) VALUES
    ( 83, 'custom_equipment_1_qty', 'Custom Equipment 1 Qty', 11, 'Y', 'Y', CURRENT_TIMESTAMP, 2 )
GO
INSERT INTO dbo.LOOKUPS ( LOOKUP_TYPE_ID, CODE, NAME, SEQUENCE_NO, ACTIVE_FLAG, UPDATABLE_FLAG, DATE_CREATED,CREATED_BY) VALUES
    ( 83, 'custom_equipment_2', 'Custom Two', 12, 'Y', 'Y', CURRENT_TIMESTAMP, 2 )
GO
INSERT INTO dbo.LOOKUPS ( LOOKUP_TYPE_ID, CODE, NAME, SEQUENCE_NO, ACTIVE_FLAG, UPDATABLE_FLAG, DATE_CREATED,CREATED_BY) VALUES
    ( 83, 'custom_equipment_2_qty', 'Custom Equipment 2 Qty', 13, 'Y', 'Y', CURRENT_TIMESTAMP, 2 )
GO
INSERT INTO dbo.LOOKUPS ( LOOKUP_TYPE_ID, CODE, NAME, SEQUENCE_NO, ACTIVE_FLAG, UPDATABLE_FLAG, DATE_CREATED,CREATED_BY) VALUES
    ( 83, 'custom_equipment_3', 'Custom Three', 14, 'Y', 'Y', CURRENT_TIMESTAMP, 2 )
GO
INSERT INTO dbo.LOOKUPS ( LOOKUP_TYPE_ID, CODE, NAME, SEQUENCE_NO, ACTIVE_FLAG, UPDATABLE_FLAG, DATE_CREATED,CREATED_BY) VALUES
    ( 83, 'custom_equipment_3_qty', 'Custom Equipment 3 Qty', 15, 'Y', 'Y', CURRENT_TIMESTAMP, 2 )
GO
INSERT INTO dbo.LOOKUPS ( LOOKUP_TYPE_ID, CODE, NAME, SEQUENCE_NO, ACTIVE_FLAG, UPDATABLE_FLAG, DATE_CREATED,CREATED_BY) VALUES
    ( 83, 'custom_equipment_4', 'Custom Four', 16, 'Y', 'Y', CURRENT_TIMESTAMP, 2 )
GO
INSERT INTO dbo.LOOKUPS ( LOOKUP_TYPE_ID, CODE, NAME, SEQUENCE_NO, ACTIVE_FLAG, UPDATABLE_FLAG, DATE_CREATED,CREATED_BY) VALUES
    ( 83, 'custom_equipment_4_qty', 'Custom Equipment 4 Qty', 17, 'Y', 'Y', CURRENT_TIMESTAMP, 2 )
GO

INSERT INTO dbo.LOOKUPS ( LOOKUP_TYPE_ID, CODE, NAME, SEQUENCE_NO, ACTIVE_FLAG, UPDATABLE_FLAG, DATE_CREATED,CREATED_BY) VALUES
    ( 83, 'custom_equipment_A', 'Custom A', 18, 'Y', 'Y', CURRENT_TIMESTAMP, 2 )
GO
INSERT INTO dbo.LOOKUPS ( LOOKUP_TYPE_ID, CODE, NAME, SEQUENCE_NO, ACTIVE_FLAG, UPDATABLE_FLAG, DATE_CREATED,CREATED_BY) VALUES
    ( 83, 'custom_equipment_A_qty', 'Custom Equipment A Qty', 19, 'Y', 'Y', CURRENT_TIMESTAMP, 2 )
GO
INSERT INTO dbo.LOOKUPS ( LOOKUP_TYPE_ID, CODE, NAME, SEQUENCE_NO, ACTIVE_FLAG, UPDATABLE_FLAG, DATE_CREATED,CREATED_BY) VALUES
    ( 83, 'custom_equipment_B', 'Custom B', 20, 'Y', 'Y', CURRENT_TIMESTAMP, 2 )
GO
INSERT INTO dbo.LOOKUPS ( LOOKUP_TYPE_ID, CODE, NAME, SEQUENCE_NO, ACTIVE_FLAG, UPDATABLE_FLAG, DATE_CREATED,CREATED_BY) VALUES
    ( 83, 'custom_equipment_B_qty', 'Custom Equipment B Qty', 21, 'Y', 'Y', CURRENT_TIMESTAMP, 2 )
GO
INSERT INTO dbo.LOOKUPS ( LOOKUP_TYPE_ID, CODE, NAME, SEQUENCE_NO, ACTIVE_FLAG, UPDATABLE_FLAG, DATE_CREATED,CREATED_BY) VALUES
    ( 83, 'custom_equipment_C', 'Custom C', 22, 'Y', 'Y', CURRENT_TIMESTAMP, 2 )
GO
INSERT INTO dbo.LOOKUPS ( LOOKUP_TYPE_ID, CODE, NAME, SEQUENCE_NO, ACTIVE_FLAG, UPDATABLE_FLAG, DATE_CREATED,CREATED_BY) VALUES
    ( 83, 'custom_equipment_C_qty', 'Custom Equipment C Qty', 23, 'Y', 'Y', CURRENT_TIMESTAMP, 2 )
GO
INSERT INTO dbo.LOOKUPS ( LOOKUP_TYPE_ID, CODE, NAME, SEQUENCE_NO, ACTIVE_FLAG, UPDATABLE_FLAG, DATE_CREATED,CREATED_BY) VALUES
    ( 83, 'custom_equipment_D', 'Custom D', 24, 'Y', 'Y', CURRENT_TIMESTAMP, 2 )
GO
INSERT INTO dbo.LOOKUPS ( LOOKUP_TYPE_ID, CODE, NAME, SEQUENCE_NO, ACTIVE_FLAG, UPDATABLE_FLAG, DATE_CREATED,CREATED_BY) VALUES
    ( 83, 'custom_equipment_D_qty', 'Custom Equipment D Qty', 25, 'Y', 'Y', CURRENT_TIMESTAMP, 2 )
GO
INSERT INTO dbo.LOOKUPS ( LOOKUP_TYPE_ID, CODE, NAME, SEQUENCE_NO, ACTIVE_FLAG, UPDATABLE_FLAG, DATE_CREATED,CREATED_BY) VALUES
    ( 83, 'custom_equipment_E', 'Custom E', 26, 'Y', 'Y', CURRENT_TIMESTAMP, 2 )
GO
INSERT INTO dbo.LOOKUPS ( LOOKUP_TYPE_ID, CODE, NAME, SEQUENCE_NO, ACTIVE_FLAG, UPDATABLE_FLAG, DATE_CREATED,CREATED_BY) VALUES
    ( 83, 'custom_equipment_E_qty', 'Custom Equipment E Qty', 27, 'Y', 'Y', CURRENT_TIMESTAMP, 2 )
GO
INSERT INTO dbo.LOOKUPS ( LOOKUP_TYPE_ID, CODE, NAME, SEQUENCE_NO, ACTIVE_FLAG, UPDATABLE_FLAG, DATE_CREATED,CREATED_BY) VALUES
    ( 83, 'custom_equipment_F', 'Custom F', 28, 'Y', 'Y', CURRENT_TIMESTAMP, 2 )
GO
INSERT INTO dbo.LOOKUPS ( LOOKUP_TYPE_ID, CODE, NAME, SEQUENCE_NO, ACTIVE_FLAG, UPDATABLE_FLAG, DATE_CREATED,CREATED_BY) VALUES
    ( 83, 'custom_equipment_F_qty', 'Custom Equipment F Qty', 29, 'Y', 'Y', CURRENT_TIMESTAMP, 2 )
GO
INSERT INTO dbo.LOOKUPS ( LOOKUP_TYPE_ID, CODE, NAME, SEQUENCE_NO, ACTIVE_FLAG, UPDATABLE_FLAG, DATE_CREATED,CREATED_BY) VALUES
    ( 83, 'custom_equipment_G', 'Custom G', 30, 'Y', 'Y', CURRENT_TIMESTAMP, 2 )
GO
INSERT INTO dbo.LOOKUPS ( LOOKUP_TYPE_ID, CODE, NAME, SEQUENCE_NO, ACTIVE_FLAG, UPDATABLE_FLAG, DATE_CREATED,CREATED_BY) VALUES
    ( 83, 'custom_equipment_G_qty', 'Custom Equipment G Qty', 31, 'Y', 'Y', CURRENT_TIMESTAMP, 2 )
GO
INSERT INTO dbo.LOOKUPS ( LOOKUP_TYPE_ID, CODE, NAME, SEQUENCE_NO, ACTIVE_FLAG, UPDATABLE_FLAG, DATE_CREATED,CREATED_BY) VALUES
    ( 83, 'custom_equipment_H', 'Custom H', 32, 'Y', 'Y', CURRENT_TIMESTAMP, 2 )
GO
INSERT INTO dbo.LOOKUPS ( LOOKUP_TYPE_ID, CODE, NAME, SEQUENCE_NO, ACTIVE_FLAG, UPDATABLE_FLAG, DATE_CREATED,CREATED_BY) VALUES
    ( 83, 'custom_equipment_H_qty', 'Custom Equipment H Qty', 33, 'Y', 'Y', CURRENT_TIMESTAMP, 2 )
GO
INSERT INTO dbo.LOOKUPS ( LOOKUP_TYPE_ID, CODE, NAME, SEQUENCE_NO, ACTIVE_FLAG, UPDATABLE_FLAG, DATE_CREATED,CREATED_BY) VALUES
    ( 83, 'custom_equipment_I', 'Custom I', 34, 'Y', 'Y', CURRENT_TIMESTAMP, 2 )
GO
INSERT INTO dbo.LOOKUPS ( LOOKUP_TYPE_ID, CODE, NAME, SEQUENCE_NO, ACTIVE_FLAG, UPDATABLE_FLAG, DATE_CREATED,CREATED_BY) VALUES
    ( 83, 'custom_equipment_I_qty', 'Custom Equipment I Qty', 35, 'Y', 'Y', CURRENT_TIMESTAMP, 2 )
GO
INSERT INTO dbo.LOOKUPS ( LOOKUP_TYPE_ID, CODE, NAME, SEQUENCE_NO, ACTIVE_FLAG, UPDATABLE_FLAG, DATE_CREATED,CREATED_BY) VALUES
    ( 83, 'custom_equipment_J', 'Custom J', 36, 'Y', 'Y', CURRENT_TIMESTAMP, 2 )
GO
INSERT INTO dbo.LOOKUPS ( LOOKUP_TYPE_ID, CODE, NAME, SEQUENCE_NO, ACTIVE_FLAG, UPDATABLE_FLAG, DATE_CREATED,CREATED_BY) VALUES
    ( 83, 'custom_equipment_J_qty', 'Custom Equipment J Qty', 37, 'Y', 'Y', CURRENT_TIMESTAMP, 2 )
GO
INSERT INTO dbo.LOOKUPS ( LOOKUP_TYPE_ID, CODE, NAME, SEQUENCE_NO, ACTIVE_FLAG, UPDATABLE_FLAG, DATE_CREATED,CREATED_BY) VALUES
    ( 83, 'custom_equipment_K', 'Custom K', 38, 'Y', 'Y', CURRENT_TIMESTAMP, 2 )
GO
INSERT INTO dbo.LOOKUPS ( LOOKUP_TYPE_ID, CODE, NAME, SEQUENCE_NO, ACTIVE_FLAG, UPDATABLE_FLAG, DATE_CREATED,CREATED_BY) VALUES
    ( 83, 'custom_equipment_K_qty', 'Custom Equipment K Qty', 39, 'Y', 'Y', CURRENT_TIMESTAMP, 2 )
GO
INSERT INTO dbo.LOOKUPS ( LOOKUP_TYPE_ID, CODE, NAME, SEQUENCE_NO, ACTIVE_FLAG, UPDATABLE_FLAG, DATE_CREATED,CREATED_BY) VALUES
    ( 83, 'custom_equipment_L', 'Custom L', 40, 'Y', 'Y', CURRENT_TIMESTAMP, 2 )
GO
INSERT INTO dbo.LOOKUPS ( LOOKUP_TYPE_ID, CODE, NAME, SEQUENCE_NO, ACTIVE_FLAG, UPDATABLE_FLAG, DATE_CREATED,CREATED_BY) VALUES
    ( 83, 'custom_equipment_L_qty', 'Custom Equipment L Qty', 41, 'Y', 'Y', CURRENT_TIMESTAMP, 2 )
GO
