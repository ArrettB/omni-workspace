INSERT INTO templates
(template_name)
values
('mnt/item_costing.html')
go

INSERT INTO template_locations
(location, level_1_template)
(SELECT 'item_cost_edit', t.template_id
FROM templates t
WHERE t.template_name = 'mnt/item_costing.html')
go

INSERT INTO functions
(function_group_id, template_id, name, code, description, template_location_id, is_nav_function, is_menu_function, date_created, created_by)
(SELECT fg.function_group_id, t.template_id, 'Item Costing', 'mnt/item_costing', 'Manage item costing values', tl.template_location_id, 'N', 'Y', CURRENT_TIMESTAMP, 1
FROM function_groups fg, templates t, template_locations tl
WHERE fg.code = 'MAINT'
AND t.template_name = 'mnt/item_costing.html'
AND tl.location = 'item_cost_edit')
go

ALTER TABLE items
ADD COST_PER_UOM numeric(18,2)
go

ALTER TABLE items
ADD PERCENT_MARGIN numeric(3)
go

drop view dbo.items_v
go

CREATE VIEW dbo.ITEMS_V    
AS    
SELECT     dbo.ITEMS.ORGANIZATION_ID, dbo.ITEMS.ITEM_ID, dbo.ITEMS.NAME, dbo.ITEMS.DESCRIPTION, dbo.ITEMS.EXT_ITEM_ID,     
                      dbo.ITEMS.ITEM_TYPE_ID, ITEM_TYPE.CODE AS item_type_code, ITEM_TYPE.NAME AS item_type_name, dbo.ITEMS.ITEM_STATUS_TYPE_ID,     
                      STATUS_TYPE.CODE AS item_status_type_code, STATUS_TYPE.NAME AS item_status_type_name, dbo.ITEMS.CODE, dbo.ITEMS.BILLABLE_FLAG,     
                      dbo.ITEMS.SEQUENCE_NO, dbo.ITEMS.EXPENSE_EXPORT_CODE, dbo.ITEMS.job_type_id,
                      dbo.ITEMS.COST_PER_UOM, dbo.ITEMS.PERCENT_MARGIN,
                      dbo.ITEMS.CREATED_BY, dbo.ITEMS.DATE_CREATED, CREATE_USER.FIRST_NAME + ' ' + CREATE_USER.LAST_NAME AS created_by_name,
                      dbo.ITEMS.DATE_MODIFIED, dbo.ITEMS.MODIFIED_BY,
                      MOD_USER.FIRST_NAME + ' ' + MOD_USER.LAST_NAME AS modified_by_name    
FROM         dbo.LOOKUPS ITEM_TYPE RIGHT OUTER JOIN    
                      dbo.LOOKUPS STATUS_TYPE RIGHT OUTER JOIN    
                      dbo.ITEMS LEFT OUTER JOIN    
                      dbo.USERS MOD_USER ON dbo.ITEMS.MODIFIED_BY = MOD_USER.USER_ID LEFT OUTER JOIN    
                      dbo.USERS CREATE_USER ON dbo.ITEMS.CREATED_BY = CREATE_USER.USER_ID ON     
                      STATUS_TYPE.LOOKUP_ID = dbo.ITEMS.ITEM_STATUS_TYPE_ID ON ITEM_TYPE.LOOKUP_ID = dbo.ITEMS.ITEM_TYPE_ID    
go
  
CREATE TABLE dbo.[ITEM_COSTING_HISTORY] (
	[ITEM_COSTING_HISTORY_ID] [numeric](18, 0) IDENTITY (1, 1) NOT NULL ,
	[ITEM_ID] [numeric](18, 0) NOT NULL ,
	[COST_PER_UOM] [numeric](18, 2) NULL ,
	[PERCENT_MARGIN] [numeric](3) NULL ,
	[CREATED_BY] [varchar](50) NOT NULL ,
	[DATE_CREATED] [datetime] NOT NULL ,
	CONSTRAINT [PK_ITEM_COSTING_HISTORY] PRIMARY KEY  CLUSTERED 
	(
		[item_costing_history_id]
	)  ON [PRIMARY] ,
	CONSTRAINT [FK_ITEMS_ITEM_ID] FOREIGN KEY 
	(
		[ITEM_ID]
	) REFERENCES [ITEMS] (
		[ITEM_ID]
	),
)
GO


INSERT INTO templates
(template_name)
VALUES
('job/job_costing.html')
go

INSERT INTO tabs
(template_id, name, sequence, type_code, default_tab, table_id, parent_tab_id, tab_level)
(SELECT t.template_id, 'Job Costing', 6, 'JOB', 'N', 'job_costing_report', 10, 2
FROM templates t
WHERE t.template_name = 'job/job_costing.html')
go

INSERT INTO template_locations
(location, level_1_tab, level_1_template, level_2_tab, level_2_template)
(SELECT 'job_costing_report', 10, 1, ta.tab_id, t.template_id
FROM templates t, tabs ta
WHERE t.template_name = 'job/job_costing.html'
AND ta.type_code = 'JOB'
AND ta.table_id = 'job_costing_report')
go

INSERT INTO functions
(function_group_id, template_id, name, code, description, template_location_id, is_nav_function, is_menu_function, date_created, created_by)
(SELECT fg.function_group_id, t.template_id, 'Job Costing Report', 'job/job_costing', 'Show job costing report', tl.template_location_id, 'N', 'N', CURRENT_TIMESTAMP, 1
FROM function_groups fg, templates t, template_locations tl
WHERE fg.code = 'tabs'
AND t.template_name = 'job/job_costing.html'
AND tl.location = 'job_costing_report')
go

update function_right_types
set updatable_flag = 'N'
where right_type_id in (select right_type_id from right_types where code <> 'view')
AND function_id in (select function_id from functions
where code = 'job/job_costing')
go


ALTER TABLE service_lines
add EXT_ID varchar(25)
go

CREATE INDEX IX_SERVICE_LINES_EXT_ID ON service_lines (ext_id)
go


ALTER TABLE items
add COLUMN_POSITION varchar(13)
CONSTRAINT ITEMS_COLUMN_POSITION_CHECK CHECK (COLUMN_POSITION IN ('subcontractor', 'material'))
go


CREATE VIEW dbo.JOB_COSTING_V
AS
SELECT     dbo.SERVICE_LINES.TC_JOB_ID, dbo.SERVICE_LINES.TC_SERVICE_ID, dbo.SERVICE_LINES.BILL_JOB_ID, dbo.SERVICE_LINES.BILL_SERVICE_ID, 
                      dbo.SERVICE_LINES.ITEM_ID, dbo.SERVICE_LINES.ITEM_NAME, dbo.SERVICE_LINES.ITEM_TYPE_CODE, dbo.SERVICE_LINES.TC_QTY, 
                      dbo.SERVICE_LINES.TC_RATE, dbo.SERVICE_LINES.TC_TOTAL, dbo.ITEMS.COST_PER_UOM, dbo.ITEMS.COLUMN_POSITION, 
                      dbo.SERVICE_LINES.ENTRY_METHOD
FROM         dbo.SERVICE_LINES INNER JOIN
                      dbo.ITEMS ON dbo.SERVICE_LINES.ITEM_ID = dbo.ITEMS.ITEM_ID
WHERE     (dbo.SERVICE_LINES.STATUS_ID >= 3) AND (dbo.SERVICE_LINES.INTERNAL_REQ_FLAG = 'N')
go

INSERT INTO functions
(function_group_id, name, code, description, is_nav_function, is_menu_function, date_created, created_by)
(SELECT fg.function_group_id, 'Load Miscellaneous Expenses', 'time/load_misc_expenses', 'Load miscellaneous expenses from Great Plains', 'N', 'N', CURRENT_TIMESTAMP, 1
FROM function_groups fg
WHERE fg.code = 'time')
go

update function_right_types
set updatable_flag = 'N'
where right_type_id in (select right_type_id from right_types where code IN ('update', 'delete'))
AND function_id in (select function_id from functions
where code = 'time/load_misc_expenses')
go


update functions
set name = 'Time Capture Edit'
, date_modified = getdate()
, modified_by = 1
where code = 'time/tc_edit'
go

