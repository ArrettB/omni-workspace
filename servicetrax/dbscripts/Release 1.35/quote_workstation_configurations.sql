CREATE TABLE dbo.QUOTE_WORKSTATION_CONFIGURATIONS (
QUOTE_WORKSTATION_CONFIGURATION_ID NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
QUOTE_ID [NUMERIC](18, 0) NOT NULL,
SET_NUMBER NUMERIC(18,0) NOT NULL,
	[TYPICAL] [VARCHAR](100) NULL,
	[WORKSTATION_COUNT] [VARCHAR](20) NULL,
	[DOMINANT_WORKSTATION] [VARCHAR](20) NULL,
	[BELTLINE_POWER] [VARCHAR](20) NULL,
	[PANELS_NON-POWERED] [VARCHAR](20) NULL,
	[PANELS_POWERED] [VARCHAR](20) NULL,
	[TILES] [VARCHAR](20) NULL,
	[STACK-ON_FRAME_FABRIC] [VARCHAR](20) NULL,
	[STACK-ON_FRAME_GLASS] [VARCHAR](20) NULL,
	[WORKSURFACES] [VARCHAR](20) NULL,
	[OVERHEADS] [VARCHAR](20) NULL,
	[PEDESTALS] [VARCHAR](20) NULL,
	[TASKLIGHTS] [VARCHAR](20) NULL,
	[KEYBOARD_TRAYS] [VARCHAR](20) NULL,
	[WALLTRACK] [VARCHAR](20) NULL,
	[DOORS] [VARCHAR](20) NULL,
	[ACCESSORIES] [VARCHAR](20) NULL,
	[TYPICAL_PRICE] [VARCHAR](20) NULL,
	[TYPICAL_EXTENDED_PRICE] [VARCHAR](20) NULL,
	[DATE_CREATED] [DATETIME] NOT NULL,
	[CREATED_BY] [NUMERIC](18, 0) NOT NULL,
	[DATE_MODIFIED] [DATETIME] NULL,
	[MODIFIED_BY] [NUMERIC](18, 0) NULL,
	 CONSTRAINT PK_QUOTE_WORKSTATION_CONFIGURATIONS PRIMARY KEY CLUSTERED 
	(
		[QUOTE_WORKSTATION_CONFIGURATION_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)
)
GO

ALTER TABLE [dbo].[QUOTE_WORKSTATION_CONFIGURATIONS]  WITH NOCHECK ADD  CONSTRAINT [FK_QWC_QUOTES] FOREIGN KEY([QUOTE_ID])
REFERENCES [dbo].[QUOTES] ([QUOTE_ID])
GO

ALTER TABLE [dbo].[QUOTE_WORKSTATION_CONFIGURATIONS] CHECK CONSTRAINT [FK_QWC_QUOTES]
GO

ALTER TABLE [dbo].[QUOTE_WORKSTATION_CONFIGURATIONS]  WITH NOCHECK ADD  CONSTRAINT [FK_QWC_USERS_C] FOREIGN KEY([CREATED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[QUOTE_WORKSTATION_CONFIGURATIONS] CHECK CONSTRAINT [FK_QWC_USERS_C]
GO
ALTER TABLE [dbo].[QUOTE_WORKSTATION_CONFIGURATIONS]  WITH NOCHECK ADD  CONSTRAINT [FK_QWC_USERS_M] FOREIGN KEY([MODIFIED_BY])
REFERENCES [dbo].[USERS] ([USER_ID])
GO
ALTER TABLE [dbo].[QUOTE_WORKSTATION_CONFIGURATIONS] CHECK CONSTRAINT [FK_QWC_USERS_M]
GO

INSERT INTO [QUOTE_WORKSTATION_CONFIGURATIONS]
           ([QUOTE_ID]
           ,[SET_NUMBER]
           ,[TYPICAL]
           ,[WORKSTATION_COUNT]
           ,[DOMINANT_WORKSTATION]
           ,[BELTLINE_POWER]
           ,[PANELS_NON-POWERED]
           ,[PANELS_POWERED]
           ,[TILES]
           ,[STACK-ON_FRAME_FABRIC]
           ,[STACK-ON_FRAME_GLASS]
           ,[WORKSURFACES]
           ,[OVERHEADS]
           ,[PEDESTALS]
           ,[TASKLIGHTS]
           ,[KEYBOARD_TRAYS]
           ,[WALLTRACK]
           ,[DOORS]
           ,[ACCESSORIES]
           ,[TYPICAL_PRICE]
           ,[TYPICAL_EXTENDED_PRICE]
           ,[DATE_CREATED]
           ,[CREATED_BY]
           ,[DATE_MODIFIED]
           ,[MODIFIED_BY])
           (SELECT [quote_id]
           , 1
      ,[t1_typical]
      ,[t1_workstation_count]
      ,[t1_dominant_workstation]
      ,[t1_beltline_power]
      ,[t1_panels_non-powered]
      ,[t1_panels_powered]
      ,[t1_tiles]
      ,[t1_stack-on_frame_fabric]
      ,[t1_stack-on_frame_glass]
      ,[t1_worksurfaces]
      ,[t1_overheads]
      ,[t1_pedestals]
      ,[t1_tasklights]
      ,[t1_keyboard_trays]
      ,[t1_walltrack]
      ,[t1_doors]
      ,[t1_accessories]
      ,[typical_price_1]
      ,[typical_extended_price_1]
      ,[date_created]
      ,[created_by]
      ,[date_modified]
      ,[modified_by]
  FROM [ims_new].[dbo].[QUOTES]
  where t1_typical is not null and LEN(T1_TYPICAL) > 0)
GO

INSERT INTO [QUOTE_WORKSTATION_CONFIGURATIONS]
           ([QUOTE_ID]
           ,[SET_NUMBER]
           ,[TYPICAL]
           ,[WORKSTATION_COUNT]
           ,[DOMINANT_WORKSTATION]
           ,[BELTLINE_POWER]
           ,[PANELS_NON-POWERED]
           ,[PANELS_POWERED]
           ,[TILES]
           ,[STACK-ON_FRAME_FABRIC]
           ,[STACK-ON_FRAME_GLASS]
           ,[WORKSURFACES]
           ,[OVERHEADS]
           ,[PEDESTALS]
           ,[TASKLIGHTS]
           ,[KEYBOARD_TRAYS]
           ,[WALLTRACK]
           ,[DOORS]
           ,[ACCESSORIES]
           ,[TYPICAL_PRICE]
           ,[TYPICAL_EXTENDED_PRICE]
           ,[DATE_CREATED]
           ,[CREATED_BY]
           ,[DATE_MODIFIED]
           ,[MODIFIED_BY])
           (SELECT [quote_id]
           , 2
      ,[t2_typical]
      ,[t2_workstation_count]
      ,[t2_dominant_workstation]
      ,[t2_beltline_power]
      ,[t2_panels_non-powered]
      ,[t2_panels-powered]
      ,[t2_tiles]
      ,[t2_stack-on_frame_fabric]
      ,[t2_stack-on_frame_glass]
      ,[t2_worksurfaces]
      ,[t2_overheads]
      ,[t2_pedestals]
      ,[t2_tasklights]
      ,[t2_keyboard_trays]
      ,[t2_walltrack]
      ,[t2_doors]
      ,[t2_accessories]
      ,[typical_price_2]
      ,[typical_extended_price_2]
      ,[date_created]
      ,[created_by]
      ,[date_modified]
      ,[modified_by]
  FROM [ims_new].[dbo].[QUOTES]
  where t2_typical is not null and LEN(T2_TYPICAL) > 0)
GO


INSERT INTO [QUOTE_WORKSTATION_CONFIGURATIONS]
           ([QUOTE_ID]
           ,[SET_NUMBER]
           ,[TYPICAL]
           ,[WORKSTATION_COUNT]
           ,[DOMINANT_WORKSTATION]
           ,[BELTLINE_POWER]
           ,[PANELS_NON-POWERED]
           ,[PANELS_POWERED]
           ,[TILES]
           ,[STACK-ON_FRAME_FABRIC]
           ,[STACK-ON_FRAME_GLASS]
           ,[WORKSURFACES]
           ,[OVERHEADS]
           ,[PEDESTALS]
           ,[TASKLIGHTS]
           ,[KEYBOARD_TRAYS]
           ,[WALLTRACK]
           ,[DOORS]
           ,[ACCESSORIES]
           ,[TYPICAL_PRICE]
           ,[TYPICAL_EXTENDED_PRICE]
           ,[DATE_CREATED]
           ,[CREATED_BY]
           ,[DATE_MODIFIED]
           ,[MODIFIED_BY])
           (SELECT [quote_id]
           , 3
      ,[t3_typical]
      ,[t3_workstation_count]
      ,[t3_dominant_workstation]
      ,[t3_beltline_power]
      ,[t3_panels_non-powered]
      ,[t3_panels-powered]
      ,[t3_tiles]
      ,[t3_stack-on_frame_fabric]
      ,[t3_stack-on_frame_glass]
      ,[t3_worksurfaces]
      ,[t3_overheads]
      ,[t3_pedestals]
      ,[t3_tasklights]
      ,[t3_keyboard_trays]
      ,[t3_walltrack]
      ,[t3_doors]
      ,[t3_accessories]
      ,[typical_price_3]
      ,[typical_extended_price_3]
      ,[date_created]
      ,[created_by]
      ,[date_modified]
      ,[modified_by]
  FROM [ims_new].[dbo].[QUOTES]
  where t3_typical is not null and LEN(T3_TYPICAL) > 0)
GO


INSERT INTO [QUOTE_WORKSTATION_CONFIGURATIONS]
           ([QUOTE_ID]
           ,[SET_NUMBER]
           ,[TYPICAL]
           ,[WORKSTATION_COUNT]
           ,[DOMINANT_WORKSTATION]
           ,[BELTLINE_POWER]
           ,[PANELS_NON-POWERED]
           ,[PANELS_POWERED]
           ,[TILES]
           ,[STACK-ON_FRAME_FABRIC]
           ,[STACK-ON_FRAME_GLASS]
           ,[WORKSURFACES]
           ,[OVERHEADS]
           ,[PEDESTALS]
           ,[TASKLIGHTS]
           ,[KEYBOARD_TRAYS]
           ,[WALLTRACK]
           ,[DOORS]
           ,[ACCESSORIES]
           ,[TYPICAL_PRICE]
           ,[TYPICAL_EXTENDED_PRICE]
           ,[DATE_CREATED]
           ,[CREATED_BY]
           ,[DATE_MODIFIED]
           ,[MODIFIED_BY])
           (SELECT [quote_id]
           , 4
      ,[t4_typical]
      ,[t4_workstation_count]
      ,[t4_dominant_workstation]
      ,[t4_beltline_power]
      ,[t4_panels_non-powered]
      ,[t4_panels_powered]
      ,[t4_tiles]
      ,[t4_stack-on_frame_fabric]
      ,[t4_stack-on_frame_glass]
      ,[t4_worksurfaces]
      ,[t4_overheads]
      ,[t4_pedestals]
      ,[t4_tasklights]
      ,[t4_keyboard_trays]
      ,[t4_walltrack]
      ,[t4_doors]
      ,[t4_accessories]
      ,[typical_price_4]
      ,[typical_extended_price_4]
      ,[date_created]
      ,[created_by]
      ,[date_modified]
      ,[modified_by]
  FROM [ims_new].[dbo].[QUOTES]
  where t4_typical is not null and LEN(T4_TYPICAL) > 0)
GO


INSERT INTO [QUOTE_WORKSTATION_CONFIGURATIONS]
           ([QUOTE_ID]
           ,[SET_NUMBER]
           ,[TYPICAL]
           ,[WORKSTATION_COUNT]
           ,[DOMINANT_WORKSTATION]
           ,[BELTLINE_POWER]
           ,[PANELS_NON-POWERED]
           ,[PANELS_POWERED]
           ,[TILES]
           ,[STACK-ON_FRAME_FABRIC]
           ,[STACK-ON_FRAME_GLASS]
           ,[WORKSURFACES]
           ,[OVERHEADS]
           ,[PEDESTALS]
           ,[TASKLIGHTS]
           ,[KEYBOARD_TRAYS]
           ,[WALLTRACK]
           ,[DOORS]
           ,[ACCESSORIES]
           ,[TYPICAL_PRICE]
           ,[TYPICAL_EXTENDED_PRICE]
           ,[DATE_CREATED]
           ,[CREATED_BY]
           ,[DATE_MODIFIED]
           ,[MODIFIED_BY])
           (SELECT [quote_id]
           , 5
      ,[t5_typical]
      ,[t5_workstation_count]
      ,[t5_dominant_workstation]
      ,[t5_beltline_power]
      ,[t5_panels_non-powered]
      ,[t5_panels_powered]
      ,[t5_tiles]
      ,[t5_stack-on_frame_fabric]
      ,[t5_stack-on_frame_glass]
      ,[t5_worksurfaces]
      ,[t5_overheads]
      ,[t5_pedestals]
      ,[t5_tasklights]
      ,[t5_keyboard_trays]
      ,[t5_walltrack]
      ,[t5_doors]
      ,[t5_accessories]
      ,[typical_price_5]
      ,[typical_extended_price_5]
      ,[date_created]
      ,[created_by]
      ,[date_modified]
      ,[modified_by]
  FROM [ims_new].[dbo].[QUOTES]
  where t5_typical is not null and LEN(T5_TYPICAL) > 0)
GO


INSERT INTO [QUOTE_WORKSTATION_CONFIGURATIONS]
           ([QUOTE_ID]
           ,[SET_NUMBER]
           ,[TYPICAL]
           ,[WORKSTATION_COUNT]
           ,[DOMINANT_WORKSTATION]
           ,[BELTLINE_POWER]
           ,[PANELS_NON-POWERED]
           ,[PANELS_POWERED]
           ,[TILES]
           ,[STACK-ON_FRAME_FABRIC]
           ,[STACK-ON_FRAME_GLASS]
           ,[WORKSURFACES]
           ,[OVERHEADS]
           ,[PEDESTALS]
           ,[TASKLIGHTS]
           ,[KEYBOARD_TRAYS]
           ,[WALLTRACK]
           ,[DOORS]
           ,[ACCESSORIES]
           ,[TYPICAL_PRICE]
           ,[TYPICAL_EXTENDED_PRICE]
           ,[DATE_CREATED]
           ,[CREATED_BY]
           ,[DATE_MODIFIED]
           ,[MODIFIED_BY])
           (SELECT [quote_id]
           , 6
      ,[t6_typical]
      ,[t6_workstation_count]
      ,[t6_dominant_workstation]
      ,[t6_beltline_power]
      ,[t6_panels_non-powered]
      ,[t6_panels_powered]
      ,[t6_tiles]
      ,[t6_stack-on_frame_fabric]
      ,[t6_stack-on_frame_glass]
      ,[t6_worksurfaces]
      ,[t6_overheads]
      ,[t6_pedestals]
      ,[t6_tasklights]
      ,[t6_keyboard_trays]
      ,[t6_walltrack]
      ,[t6_doors]
      ,[t6_accessories]
      ,[typical_price_6]
      ,[typical_extended_price_6]
      ,[date_created]
      ,[created_by]
      ,[date_modified]
      ,[modified_by]
  FROM [ims_new].[dbo].[QUOTES]
  where t6_typical is not null and LEN(T6_TYPICAL) > 0)
GO


ALTER TABLE dbo.QUOTES
	DROP COLUMN t1_typical, t1_workstation_count, t1_dominant_workstation, t1_beltline_power, [t1_panels_non-powered], t1_panels_powered, t1_tiles, [t1_stack-on_frame_fabric], [t1_stack-on_frame_glass], t1_worksurfaces, t1_overheads, t1_pedestals, t1_tasklights, t1_keyboard_trays, t1_walltrack, t1_doors, t1_accessories, t2_typical, t2_workstation_count, t2_dominant_workstation, t2_beltline_power, [t2_panels_non-powered], [t2_panels-powered], t2_tiles, [t2_stack-on_frame_fabric], [t2_stack-on_frame_glass], t2_worksurfaces, t2_overheads, t2_pedestals, t2_tasklights, t2_keyboard_trays, t2_walltrack, t2_doors, t2_accessories, t3_typical, t3_workstation_count, t3_dominant_workstation, t3_beltline_power, [t3_panels_non-powered], [t3_panels-powered], t3_tiles, [t3_stack-on_frame_fabric], [t3_stack-on_frame_glass], t3_worksurfaces, t3_overheads, t3_pedestals, t3_tasklights, t3_keyboard_trays, t3_walltrack, t3_doors, t3_accessories, t4_typical, t4_workstation_count, t4_dominant_workstation, t4_beltline_power, [t4_panels_non-powered], t4_panels_powered, t4_tiles, [t4_stack-on_frame_fabric], [t4_stack-on_frame_glass], t4_worksurfaces, t4_overheads, t4_pedestals, t4_tasklights, t4_keyboard_trays, t4_walltrack, t4_doors, t4_accessories, t5_typical, t5_workstation_count, t5_dominant_workstation, t5_beltline_power, [t5_panels_non-powered], t5_panels_powered, t5_tiles, [t5_stack-on_frame_fabric], [t5_stack-on_frame_glass], t5_worksurfaces, t5_overheads, t5_pedestals, t5_tasklights, t5_keyboard_trays, t5_walltrack, t5_doors, t5_accessories, t6_typical, t6_workstation_count, t6_dominant_workstation, t6_beltline_power, [t6_panels_non-powered], t6_panels_powered, t6_tiles, [t6_stack-on_frame_fabric], [t6_stack-on_frame_glass], t6_worksurfaces, t6_overheads, t6_pedestals, t6_tasklights, t6_keyboard_trays, t6_walltrack, t6_doors, t6_accessories, typical_price_1, typical_price_2, typical_price_3, typical_price_4, typical_price_5, typical_price_6, typical_extended_price_1, typical_extended_price_2, typical_extended_price_3, typical_extended_price_4, typical_extended_price_5, typical_extended_price_6
GO

