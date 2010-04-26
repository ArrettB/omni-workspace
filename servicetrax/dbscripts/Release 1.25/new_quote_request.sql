ALTER TABLE projects ADD end_user_id NUMERIC(18,0)
GO

ALTER TABLE projects ADD CONSTRAINT fk_project_end_user FOREIGN KEY (end_user_id) REFERENCES customers (customer_id)
GO

ALTER TABLE requests ADD other_delivery_type_id NUMERIC(18,0)
GO

ALTER TABLE requests ADD CONSTRAINT fk_request_other_delivery_type FOREIGN KEY (other_delivery_type_id) REFERENCES lookups (lookup_id)
GO

ALTER TABLE requests ADD customer_costing_type_id NUMERIC(18,0)
GO

ALTER TABLE requests ADD CONSTRAINT fk_request_customer_costing_type FOREIGN KEY (customer_costing_type_id) REFERENCES lookups (lookup_id)
GO

ALTER TABLE requests ADD customer_contact2_id NUMERIC(18,0)
GO

ALTER TABLE requests ADD customer_contact3_id NUMERIC(18,0)
GO

ALTER TABLE requests ADD customer_contact4_id NUMERIC(18,0)
GO

ALTER TABLE requests ADD job_location_contact_id NUMERIC(18,0)
GO

ALTER TABLE requests ADD CONSTRAINT fk_request_customer_contact2 FOREIGN KEY (customer_contact2_id) REFERENCES contacts (contact_id)
GO

ALTER TABLE requests ADD CONSTRAINT fk_request_customer_contact3 FOREIGN KEY (customer_contact3_id) REFERENCES contacts (contact_id)
GO

ALTER TABLE requests ADD CONSTRAINT fk_request_customer_contact4 FOREIGN KEY (customer_contact4_id) REFERENCES contacts (contact_id)
GO

ALTER TABLE requests ADD CONSTRAINT fk_request_job_loc_contact FOREIGN KEY (job_location_contact_id) REFERENCES contacts (contact_id)
GO

ALTER TABLE requests ADD system_furniture_line_type_id NUMERIC(18,0)
GO

ALTER TABLE requests ADD CONSTRAINT fk_request_sys_furn_line_type FOREIGN KEY (system_furniture_line_type_id) REFERENCES lookups (lookup_id)
GO

ALTER TABLE requests ADD other_furniture_type_id NUMERIC(18,0)
GO

ALTER TABLE requests ADD CONSTRAINT fk_request_other_furn_type FOREIGN KEY (other_furniture_type_id) REFERENCES lookups (lookup_id)
GO

ALTER TABLE requests ADD schedule_with_client_flag VARCHAR(1)
GO

ALTER TABLE requests ALTER COLUMN description VARCHAR(1000)
GO

ALTER TABLE requests ADD order_type_id NUMERIC(18,0)
GO

ALTER TABLE requests ADD CONSTRAINT fk_request_order_type FOREIGN KEY (order_type_id) REFERENCES lookups (lookup_id)
GO

ALTER TABLE requests ADD is_stair_carry_required VARCHAR(1)
GO

ALTER TABLE requests ADD days_to_complete NUMERIC(5,0)
GO

ALTER TABLE customers ADD customer_type_id NUMERIC(18,0)
GO

ALTER TABLE customers ADD CONSTRAINT fk_customer_customer_type FOREIGN KEY (customer_type_id) REFERENCES lookups (lookup_id)
GO

ALTER TABLE customers ADD end_user_parent_id NUMERIC(18,0)
GO

ALTER TABLE customers ADD CONSTRAINT fk_customer_end_user_parent FOREIGN KEY (end_user_parent_id) REFERENCES customers (customer_id)
GO

ALTER TABLE customers ADD street1 VARCHAR(100)
GO

ALTER TABLE customers ADD street2 VARCHAR(100)
GO

ALTER TABLE customers ADD city VARCHAR(50)
GO

ALTER TABLE customers ADD county VARCHAR(50)
GO

ALTER TABLE customers ADD state VARCHAR(2)
GO

ALTER TABLE customers ADD zip VARCHAR(10)
GO

ALTER TABLE customers ADD country VARCHAR(50)
GO

ALTER TABLE job_locations ADD active_flag varchar(1) default 'Y'
GO

UPDATE job_locations SET active_flag='Y' WHERE active_flag IS NULL
GO

ALTER TABLE job_locations ADD county VARCHAR(50)
GO

ALTER TABLE jobs ADD end_user_id NUMERIC(18,0)
GO

ALTER TABLE jobs ADD CONSTRAINT fk_job_end_user FOREIGN KEY (end_user_id) REFERENCES customers (customer_id)
GO

ALTER TABLE services ALTER COLUMN description VARCHAR(1000)
GO

CREATE TABLE job_location_contacts(
job_location_contact_id numeric(18, 0) IDENTITY(1,1) NOT NULL,
job_location_id NUMERIC(18, 0) NOT NULL,
contact_id NUMERIC(18, 0) NOT NULL,
created_by NUMERIC(18, 0) NOT NULL,
date_created DATETIME DEFAULT getdate() NOT NULL,
modified_by NUMERIC(18, 0),
date_modified DATETIME)
GO

ALTER TABLE job_location_contacts ADD CONSTRAINT PK_job_location_contacts PRIMARY KEY (job_location_contact_id)
GO

ALTER TABLE job_location_contacts ADD CONSTRAINT FK_jlc_job_location FOREIGN KEY (job_location_id) REFERENCES job_locations (job_location_id)
GO

ALTER TABLE job_location_contacts ADD CONSTRAINT FK_jlc_contact FOREIGN KEY (contact_id) REFERENCES contacts (contact_id)
GO

ALTER TABLE job_location_contacts ADD CONSTRAINT UK_jlc_1 UNIQUE (job_location_id, contact_id)
GO

CREATE TABLE quotes_mapping (
	[NAME] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[VALUE] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GROUP] [int] NULL
)
GO


TRUNCATE TABLE QUOTES_MAPPING
GO

INSERT INTO [QUOTES_MAPPING]([NAME], [VALUE], [GROUP])VALUES('Minneapolis', 'A&M MN', 1)
INSERT INTO [QUOTES_MAPPING]([NAME], [VALUE], [GROUP])VALUES('Wisconsin', 'A&M WI', 1)
INSERT INTO [QUOTES_MAPPING]([NAME], [VALUE], [GROUP])VALUES('Georgia', 'AIA', 1)
INSERT INTO [QUOTES_MAPPING]([NAME], [VALUE], [GROUP])VALUES('Illinois', 'CI IL', 1)
INSERT INTO [QUOTES_MAPPING]([NAME], [VALUE], [GROUP])VALUES('Plymouth', 'CI MN', 1)
INSERT INTO [QUOTES_MAPPING]([NAME], [VALUE], [GROUP])VALUES('Milwaukee', 'CI WI', 1)
INSERT INTO [QUOTES_MAPPING]([NAME], [VALUE], [GROUP])VALUES('Washington', 'ECMS', 1)
INSERT INTO [QUOTES_MAPPING]([NAME], [VALUE], [GROUP])VALUES('ICS', 'ICS', 1)
INSERT INTO [QUOTES_MAPPING]([NAME], [VALUE], [GROUP])VALUES('', 'N', 2)
INSERT INTO [QUOTES_MAPPING]([NAME], [VALUE], [GROUP])VALUES('Direct', 'Y', 2)
INSERT INTO [QUOTES_MAPPING]([NAME], [VALUE], [GROUP])VALUES('Omni Receive and Delivery', 'N', 2)
INSERT INTO [QUOTES_MAPPING]([NAME], [VALUE], [GROUP])VALUES('On Site', 'Y', 2)
INSERT INTO [QUOTES_MAPPING]([NAME], [VALUE], [GROUP])VALUES('N/A', 'Y', 2)
INSERT INTO [QUOTES_MAPPING]([NAME], [VALUE], [GROUP])VALUES('', 'No Dock Access with Elevator', 3)
INSERT INTO [QUOTES_MAPPING]([NAME], [VALUE], [GROUP])VALUES('No', 'No Dock Access with Elevator', 3)
INSERT INTO [QUOTES_MAPPING]([NAME], [VALUE], [GROUP])VALUES('Yes - Both', 'Dock Access with Elevator', 3)
INSERT INTO [QUOTES_MAPPING]([NAME], [VALUE], [GROUP])VALUES('Yes - Freight', 'Dock Access with Elevator', 3)
INSERT INTO [QUOTES_MAPPING]([NAME], [VALUE], [GROUP])VALUES('Yes - Passenger', 'Dock Access with Elevator', 3)
GO

ALTER TABLE [QUOTES] ADD
	[VERSION] [int] NULL,
	[SUB_VERSION] [int] NULL,
	[SYSTEMS_SHIPPING_METHOD] [varchar] (50) NULL,
	[CASEGOODS_SHIPPING_METHOD] [varchar] (50) NULL,
	[SELECT_JOB_SITE_MOVE-STAGE_ENVIRONMENT] [varchar] (50) NULL,
	[SYSTEM_TYPICAL_LINE-TYPICAL1] [varchar] (50) NULL,
	[TYPICAL1_WORKSTATION_COUNT] [varchar] (50) NULL,
	[OMNI_BILL_STD_HOURS_DISCOUNTED_BILL_RATE] [varchar] (50) NULL,
	[NET_EFFECTIVE_BILLING_RATE_PER_HOUR] [varchar] (50) NULL,
	[ROC_OMNI_DISCOUNTED_HOURS-RECEIVE] [varchar] (20) NULL,
	[ROC_OMNI_DISCOUNTED_HOURS-RELOAD] [varchar] (20) NULL,
	[ROC_OMNI_DISCOUNTED_HOURS-TRUCK] [varchar] (20) NULL,
	[ROC_OMNI_DISCOUNTED_HOURS-DRIVER] [varchar] (20) NULL,
	[ROC_OMNI_DISCOUNTED_HOURS-UNLOAD] [varchar] (20) NULL,
	[ROC_OMNI_DISCOUNTED_HOURS-MOVE_STAGE] [varchar] (20) NULL,
	[ROC_OMNI_DISCOUNTED_HOURS-INSTALL] [varchar] (20) NULL,
	[ROC_OMNI_DISCOUNTED_HOURS-ELECTRICAL] [varchar] (20) NULL,
	[ROC_OMNI_DISCOUNTED_HOURS-TOTAL] [varchar] (20) NULL,
	[ROC_INDUSTRY_STD_BILL-RECEIVE] [varchar] (20) NULL,
	[ROC_INDUSTRY_STD_BILL-RELOAD] [varchar] (20) NULL,
	[ROC_INDUSTRY_STD_BILL-TRUCK] [varchar] (20) NULL,
	[ROC_INDUSTRY_STD_BILL-DRIVER] [varchar] (20) NULL,
	[ROC_INDUSTRY_STD_BILL-UNLOAD] [varchar] (20) NULL,
	[ROC_INDUSTRY_STD_BILL-MOVE_STAGE] [varchar] (20) NULL,
	[ROC_INDUSTRY_STD_BILL-INSTALL] [varchar] (20) NULL,
	[ROC_INDUSTRY_STD_BILL-ELECTRICAL] [varchar] (20) NULL,
	[ROC_INDUSTRY_STD_BILL-TOTAL] [varchar] (20) NULL,
	[ROC_OMNI_DIRECT_COST-RECEIVE] [varchar] (20) NULL,
	[ROC_OMNI_DIRECT_COST-RELOAD] [varchar] (20) NULL,
	[ROC_OMNI_DIRECT_COST-TRUCK] [varchar] (20) NULL,
	[ROC_OMNI_DIRECT_COST-DRIVER] [varchar] (20) NULL,
	[ROC_OMNI_DIRECT_COST-UNLOAD] [varchar] (20) NULL,
	[ROC_OMNI_DIRECT_COST-MOVE-STAGE] [varchar] (20) NULL,
	[ROC_OMNI_DIRECT_COST-INSTALL] [varchar] (20) NULL,
	[ROC_OMNI_DIRECT_COST-ELECTRICAL] [varchar] (20) NULL,
	[ROC_OMNI_DIRECT_COST-TOTAL] [varchar] (20) NULL,
	[IND_INDUSTRY_STD_HOURS-RECEIVE] [varchar] (20) NULL,
	[IND_INDUSTRY_STD_HOURS-RELOAD] [varchar] (20) NULL,
	[IND_INDUSTRY_STD_HOURS-TRUCK] [varchar] (20) NULL,
	[IND_INDUSTRY_STD_HOURS-DRIVER] [varchar] (20) NULL,
	[IND_INDUSTRY_STD_HOURS-UNLOAD] [varchar] (20) NULL,
	[IND_INDUSTRY_STD_HOURS-MOVE_STAGE] [varchar] (20) NULL,
	[IND_INDUSTRY_STD_HOURS-INSTALL] [varchar] (20) NULL,
	[IND_INDUSTRY_STD_HOURS-ELECTRICAL] [varchar] (20) NULL,
	[IND_INDUSTRY_STD_HOURS-TOTAL] [varchar] (20) NULL,
	[IND_OMNI_DISCOUNTED_HOURS-RECEIVE] [varchar] (20) NULL,
	[IND_OMNI_DISCOUNTED_HOURS-RELOAD] [varchar] (20) NULL,
	[IND_OMNI_DISCOUNTED_HOURS-TRUCK] [varchar] (20) NULL,
	[IND_OMNI_DISCOUNTED_HOURS-DRIVER] [varchar] (20) NULL,
	[IND_OMNI_DISCOUNTED_HOURS-UNLOAD] [varchar] (20) NULL,
	[IND_OMNI_DISCOUNTED_HOURS-MOVE_STAGE] [varchar] (20) NULL,
	[IND_OMNI_DISCOUNTED_HOURS-INSTALL] [varchar] (20) NULL,
	[IND_OMNI_DISCOUNTED_HOURS-ELECTRICAL] [varchar] (20) NULL,
	[IND_OMNI_DISCOUNTED_HOURS-TOTAL] [varchar] (20) NULL,
	[IND_INDUSTRY_STD_BILL-RECEIVE] [varchar] (20) NULL,
	[IND_INDUSTRY_STD_BILL-RELOAD] [varchar] (20) NULL,
	[IND_INDUSTRY_STD_BILL-TRUCK] [varchar] (20) NULL,
	[IND_INDUSTRY_STD_BILL-DRIVER] [varchar] (20) NULL,
	[IND_INDUSTRY_STD_BILL-UNLOAD] [varchar] (20) NULL,
	[IND_INDUSTRY_STD_BILL-MOVE_STAGE] [varchar] (20) NULL,
	[IND_INDUSTRY_STD_BILL-INSTALL] [varchar] (20) NULL,
	[IND_INDUSTRY_STD_BILL-ELECTRICAL] [varchar] (20) NULL,
	[IND_INDUSTRY_STD_BILL-TOTAL] [varchar] (20) NULL,
	[IND_OMNI_DISCOUNTED_BILL-RECEIVE] [varchar] (20) NULL,
	[IND_OMNI_DISCOUNTED_BILL-RELOAD] [varchar] (20) NULL,
	[IND_OMNI_DISCOUNTED_BILL-TRUCK] [varchar] (20) NULL,
	[IND_OMNI_DISCOUNTED_BILL-DRIVER] [varchar] (20) NULL,
	[IND_OMNI_DISCOUNTED_BILL-UNLOAD] [varchar] (20)   NULL,
	[IND_OMNI_DISCOUNTED_BILL-MOVE_STAGE] [varchar] (20) NULL,
	[IND_OMNI_DISCOUNTED_BILL-INSTALL] [varchar] (20) NULL,
	[IND_OMNI_DISCOUNTED_BILL-ELECTRICAL] [varchar] (20) NULL,
	[IND_OMNI_DISCOUNTED_BILL-TOTAL] [varchar] (20) NULL,
	[IND_OMNI_DIRECT_COST-RECEIVE] [varchar] (20) NULL,
	[IND_OMNI_DIRECT_COST-RELOAD] [varchar] (20) NULL,
	[IND_OMNI_DIRECT_COST-TRUCK] [varchar] (20) NULL,
	[IND_OMNI_DIRECT_COST-DRIVER] [varchar] (20) NULL,
	[IND_OMNI_DIRECT_COST-UNLOAD] [varchar] (20) NULL,
	[IND_OMNI_DIRECT_COST-MOVE_STAGE] [varchar] (20) NULL,
	[IND_OMNI_DIRECT_COST-INSTALL] [varchar] (20) NULL,
	[IND_OMNI_DIRECT_COST-ELECTRICAL] [varchar] (20) NULL,
	[IND_OMNI_DIRECT_COST-TOTAL] [varchar] (20) NULL,
	[T1_TYPICAL] [varchar] (100) NULL,
	[T1_WORKSTATION_COUNT] [varchar] (20) NULL,
	[T1_DOMINANT_WORKSTATION] [varchar] (20) NULL,
	[T1_BELTLINE_POWER] [varchar] (20) NULL,
	[T1_PANELS_NON-POWERED] [varchar] (20) NULL,
	[T1_PANELS_POWERED] [varchar] (20) NULL,
	[T1_TILES] [varchar] (20) NULL,
	[T1_STACK-ON_FRAME_FABRIC] [varchar] (20) NULL,
	[T1_STACK-ON_FRAME_GLASS] [varchar] (20) NULL,
	[T1_WORKSURFACES] [varchar] (20) NULL,
	[T1_OVERHEADS] [varchar] (20) NULL,
	[T1_PEDESTALS] [varchar] (20) NULL,
	[T1_TASKLIGHTS] [varchar] (20) NULL,
	[T1_KEYBOARD_TRAYS] [varchar] (20) NULL,
	[T1_WALLTRACK] [varchar] (20) NULL,
	[T1_DOORS] [varchar] (20) NULL,
	[T1_ACCESSORIES] [varchar] (20) NULL,
	[T2_TYPICAL] [varchar] (100) NULL,
	[T2_WORKSTATION_COUNT] [varchar] (20) NULL,
	[T2_DOMINANT_WORKSTATION] [varchar] (20) NULL,
	[T2_BELTLINE_POWER] [varchar] (20) NULL,
	[T2_PANELS_NON-POWERED] [varchar] (20) NULL,
	[T2_PANELS-POWERED] [varchar] (20) NULL,
	[T2_TILES] [varchar] (20) NULL,
	[T2_STACK-ON_FRAME_FABRIC] [varchar] (20) NULL,
	[T2_STACK-ON_FRAME_GLASS] [varchar] (20) NULL,
	[T2_WORKSURFACES] [varchar] (20) NULL,
	[T2_OVERHEADS] [varchar] (20) NULL,
	[T2_PEDESTALS] [varchar] (20) NULL,
	[T2_TASKLIGHTS] [varchar] (20) NULL,
	[T2_KEYBOARD_TRAYS] [varchar] (20) NULL,
	[T2_WALLTRACK] [varchar] (20) NULL,
	[T2_DOORS] [varchar] (20) NULL,
	[T2_ACCESSORIES] [varchar] (20) NULL,
	[T3_TYPICAL] [varchar] (100) NULL,
	[T3_WORKSTATION_COUNT] [varchar] (20) NULL,
	[T3_DOMINANT_WORKSTATION] [varchar] (20) NULL,
	[T3_BELTLINE_POWER] [varchar] (20) NULL,
	[T3_PANELS_NON-POWERED] [varchar] (20) NULL,
	[T3_PANELS-POWERED] [varchar] (20) NULL,
	[T3_TILES] [varchar] (20) NULL,
	[T3_STACK-ON_FRAME_FABRIC] [varchar] (20) NULL,
	[T3_STACK-ON_FRAME_GLASS] [varchar] (20) NULL,
	[T3_WORKSURFACES] [varchar] (20) NULL,
	[T3_OVERHEADS] [varchar] (20) NULL,
	[T3_PEDESTALS] [varchar] (20) NULL,
	[T3_TASKLIGHTS] [varchar] (20) NULL,
	[T3_KEYBOARD_TRAYS] [varchar] (20) NULL,
	[T3_WALLTRACK] [varchar] (20) NULL,
	[T3_DOORS] [varchar] (20) NULL,
	[T3_ACCESSORIES] [varchar] (20) NULL,
	[T4_TYPICAL] [varchar] (100) NULL,
	[T4_WORKSTATION_COUNT] [varchar] (20) NULL,
	[T4_DOMINANT_WORKSTATION] [varchar] (20) NULL,
	[T4_BELTLINE_POWER] [varchar] (20) NULL,
	[T4_PANELS_NON-POWERED] [varchar] (20) NULL,
	[T4_PANELS_POWERED] [varchar] (20) NULL,
	[T4_TILES] [varchar] (20) NULL,
	[T4_STACK-ON_FRAME_FABRIC] [varchar] (20) NULL,
	[T4_STACK-ON_FRAME_GLASS] [varchar] (20) NULL,
	[T4_WORKSURFACES] [varchar] (20) NULL,
	[T4_OVERHEADS] [varchar] (20) NULL,
	[T4_PEDESTALS] [varchar] (20) NULL,
	[T4_TASKLIGHTS] [varchar] (20) NULL,
	[T4_KEYBOARD_TRAYS] [varchar] (20) NULL,
	[T4_WALLTRACK] [varchar] (20) NULL,
	[T4_DOORS] [varchar] (20) NULL,
	[T4_ACCESSORIES] [varchar] (20) NULL,
	[T5_TYPICAL] [varchar] (100) NULL,
	[T5_WORKSTATION_COUNT] [varchar] (20) NULL,
	[T5_DOMINANT_WORKSTATION] [varchar] (20) NULL,
	[T5_BELTLINE_POWER] [varchar] (20) NULL,
	[T5_PANELS_NON-POWERED] [varchar] (20) NULL,
	[T5_PANELS_POWERED] [varchar] (20) NULL,
	[T5_TILES] [varchar] (20) NULL,
	[T5_STACK-ON_FRAME_FABRIC] [varchar] (20) NULL,
	[T5_STACK-ON_FRAME_GLASS] [varchar] (20) NULL,
	[T5_WORKSURFACES] [varchar] (20) NULL,
	[T5_OVERHEADS] [varchar] (20) NULL,
	[T5_PEDESTALS] [varchar] (20) NULL,
	[T5_TASKLIGHTS] [varchar] (20) NULL,
	[T5_KEYBOARD_TRAYS] [varchar] (20) NULL,
	[T5_WALLTRACK] [varchar] (20) NULL,
	[T5_DOORS] [varchar] (20) NULL,
	[T5_ACCESSORIES] [varchar] (20) NULL,
	[T6_TYPICAL] [varchar] (100) NULL,
	[T6_WORKSTATION_COUNT] [varchar] (20) NULL,
	[T6_DOMINANT_WORKSTATION] [varchar] (20) NULL,
	[T6_BELTLINE_POWER] [varchar] (20) NULL,
	[T6_PANELS_NON-POWERED] [varchar] (20) NULL,
	[T6_PANELS_POWERED] [varchar] (20) NULL,
	[T6_TILES] [varchar] (20) NULL,
	[T6_STACK-ON_FRAME_FABRIC] [varchar] (20) NULL,
	[T6_STACK-ON_FRAME_GLASS] [varchar] (20) NULL,
	[T6_WORKSURFACES] [varchar] (20) NULL,
	[T6_OVERHEADS] [varchar] (20) NULL, 
	[T6_PEDESTALS] [varchar] (20) NULL,
	[T6_TASKLIGHTS] [varchar] (20) NULL,
	[T6_KEYBOARD_TRAYS] [varchar] (20) NULL,
	[T6_WALLTRACK] [varchar] (20) NULL,
	[T6_DOORS] [varchar] (20) NULL,
	[T6_ACCESSORIES] [varchar] (20) NULL,
	[OTHER_FURNITURE_1] [varchar] (100) NULL,
	[OTHER_FURNITURE_COUNT_1] [varchar] (20) NULL,
	[OTHER_FURNITURE_2] [varchar] (100) NULL,
	[OTHER_FURNITURE_COUNT_2] [varchar] (20) NULL,
	[OTHER_FURNITURE_3] [varchar] (100) NULL,
	[OTHER_FURNITURE_COUNT_3] [varchar] (20) NULL,
	[OTHER_FURNITURE_4] [varchar] (100) NULL,
	[OTHER_FURNITURE_COUNT_4] [varchar] (20) NULL,
	[OTHER_FURNITURE_5] [varchar] (100) NULL,
	[OTHER_FURNITURE_COUNT_5] [varchar] (20) NULL,
	[OTHER_FURNITURE_6] [varchar] (100) NULL,
	[OTHER_FURNITURE_COUNT_6] [varchar] (20) NULL,
	[OTHER_FURNITURE_7] [varchar] (100) NULL,
	[OTHER_FURNITURE_COUNT_7] [varchar] (20) NULL,
	[OTHER_FURNITURE_8] [varchar] (100) NULL,
	[OTHER_FURNITURE_COUNT_8] [varchar] (20) NULL,
	[OTHER_FURNITURE_9] [varchar] (100) NULL,
	[OTHER_FURNITURE_COUNT_9] [varchar] (20) NULL,
	[OTHER_FURNITURE_10] [varchar] (100) NULL,
	[OTHER_FURNITURE_COUNT_10] [varchar] (20) NULL,
	[SPECIFY_SERVICES_1] [varchar] (20) NULL,
	[SPECIFY_SERVICES_2] [varchar] (20) NULL,
	[SPECIFY_SERVICES_3] [varchar] (20) NULL,
	[SPECIFY_SERVICES_4] [varchar] (20) NULL,
	[SPECIFY_SERVICES_5] [varchar] (20) NULL,
	[SPECIFY_SERVICES_6] [varchar] (20) NULL,
	[SPECIFY_SERVICES_7] [varchar] (20) NULL,
	[SPECIFY_SERVICES_BILL_1] [varchar] (20) NULL,
	[SPECIFY_SERVICES_BILL_2] [varchar] (20) NULL,
	[SPECIFY_SERVICES_BILL_3] [varchar] (20) NULL,
	[SPECIFY_SERVICES_BILL_4] [varchar] (20) NULL,
	[SPECIFY_SERVICES_BILL_5] [varchar] (20) NULL,
	[SPECIFY_SERVICES_BILL_6] [varchar] (20) NULL,
	[SPECIFY_SERVICES_BILL_7] [varchar] (20) NULL,
	[TYPICAL_PRICE_1] [varchar] (20) NULL,
	[TYPICAL_PRICE_2] [varchar] (20) NULL,
	[TYPICAL_PRICE_3] [varchar] (20) NULL,
	[TYPICAL_PRICE_4] [varchar] (20) NULL,
	[TYPICAL_PRICE_5] [varchar] (20) NULL,
	[TYPICAL_PRICE_6] [varchar] (20) NULL,
	[TYPICAL_EXTENDED_PRICE_1] [varchar] (20) NULL,
	[TYPICAL_EXTENDED_PRICE_2] [varchar] (20) NULL,
	[TYPICAL_EXTENDED_PRICE_3] [varchar] (20) NULL,
	[TYPICAL_EXTENDED_PRICE_4] [varchar] (20) NULL,
	[TYPICAL_EXTENDED_PRICE_5] [varchar] (20) NULL,
	[TYPICAL_EXTENDED_PRICE_6] [varchar] (20) NULL,
	[TOTAL-PANELS_NON-POWERED] [varchar] (10) NULL,
	[TOTAL-PANELS_POWERED] [varchar] (10) NULL,
	[TOTAL-BELTLINE_POWER] [varchar] (10) NULL,
	[TOTAL-TILES] [varchar] (10) NULL,
	[TOTAL-STACK_FABRIC] [varchar] (10) NULL,
	[TOTAL-STACK_GLASS] [varchar] (10) NULL,
	[TOTAL-WORKSURFACES] [varchar] (10) NULL,
	[TOTAL-OVERHEADS] [varchar] (10) NULL,
	[TOTAL-PEDESTALS] [varchar] (10) NULL,
	[TOTAL-TASKLIGHTS] [varchar] (10) NULL,
	[TOTAL-KEYBOARD_TRAYS] [varchar] (10) NULL,
	[TOTAL-WALLTRACKS] [varchar] (10) NULL,
	[TOTAL-DOORS] [varchar] (10) NULL,
	[TOTAL-ACCESSORIES] [varchar] (10) NULL
GO

CREATE TABLE countries (code varchar(2) not null, name varchar(100) not null)
GO

ALTER TABLE countries ADD CONSTRAINT countries_pk PRIMARY KEY (code)
GO

INSERT INTO countries VALUES ('US', 'United States')
INSERT INTO countries VALUES ('CA', 'Canada')
GO

CREATE TABLE states (code varchar(2) not null, country_code varchar(2) not null, name varchar(100) not null)
GO

ALTER TABLE states ADD CONSTRAINT states_pk PRIMARY KEY (code,country_code)
GO

ALTER TABLE states ADD CONSTRAINT fk_states_country FOREIGN KEY (country_code) REFERENCES countries (code)
GO

INSERT INTO states (code,name,country_code) VALUES ('AK','Alaska','US')
INSERT INTO states (code,name,country_code) VALUES ('AL','Alabama','US')
INSERT INTO states (code,name,country_code) VALUES ('AR','Arkansas','US')
INSERT INTO states (code,name,country_code) VALUES ('AZ','Arizona','US')		      
INSERT INTO states (code,name,country_code) VALUES ('CA','California','US')		      
INSERT INTO states (code,name,country_code) VALUES ('CO','Colorado','US')		      
INSERT INTO states (code,name,country_code) VALUES ('CT','Connecticut','US')		      
INSERT INTO states (code,name,country_code) VALUES ('DC','District of Columbia','US')		      
INSERT INTO states (code,name,country_code) VALUES ('DE','Delaware','US')		      
INSERT INTO states (code,name,country_code) VALUES ('FL','Florida','US')		      
INSERT INTO states (code,name,country_code) VALUES ('GA','Georgia','US')		      
INSERT INTO states (code,name,country_code) VALUES ('HI','Hawaii','US')		      
INSERT INTO states (code,name,country_code) VALUES ('IA','Iowa','US')		      
INSERT INTO states (code,name,country_code) VALUES ('ID','Idaho','US')		      
INSERT INTO states (code,name,country_code) VALUES ('IL','Illinois','US')		      
INSERT INTO states (code,name,country_code) VALUES ('IN','Indiana','US')		      
INSERT INTO states (code,name,country_code) VALUES ('KS','Kansas','US')		      
INSERT INTO states (code,name,country_code) VALUES ('KY','Kentucky','US')		      
INSERT INTO states (code,name,country_code) VALUES ('LA','Louisiana','US')		      
INSERT INTO states (code,name,country_code) VALUES ('MA','Massachusetts','US')		      
INSERT INTO states (code,name,country_code) VALUES ('MD','Maryland','US')		      
INSERT INTO states (code,name,country_code) VALUES ('ME','Maine','US')		      
INSERT INTO states (code,name,country_code) VALUES ('MI','Michigan','US')		      
INSERT INTO states (code,name,country_code) VALUES ('MN','Minnesota','US')		      
INSERT INTO states (code,name,country_code) VALUES ('MO','Missouri','US')		      
INSERT INTO states (code,name,country_code) VALUES ('MS','Mississippi','US')		      
INSERT INTO states (code,name,country_code) VALUES ('MT','Montana','US')		      
INSERT INTO states (code,name,country_code) VALUES ('NC','North Carolina','US')		      
INSERT INTO states (code,name,country_code) VALUES ('ND','North Dakota','US')		      
INSERT INTO states (code,name,country_code) VALUES ('NE','Nebraska','US')		      
INSERT INTO states (code,name,country_code) VALUES ('NH','New Hampshire','US')		      
INSERT INTO states (code,name,country_code) VALUES ('NJ','New Jersey','US')		      
INSERT INTO states (code,name,country_code) VALUES ('NM','New Mexico','US')		      
INSERT INTO states (code,name,country_code) VALUES ('NV','Nevada','US')		      
INSERT INTO states (code,name,country_code) VALUES ('NY','New York','US')		      
INSERT INTO states (code,name,country_code) VALUES ('OH','Ohio','US')		      
INSERT INTO states (code,name,country_code) VALUES ('OK','Oklahoma','US')		      
INSERT INTO states (code,name,country_code) VALUES ('OR','Oregon','US')		      
INSERT INTO states (code,name,country_code) VALUES ('PA','Pennsylvania','US')		      
INSERT INTO states (code,name,country_code) VALUES ('RI','Rhode Island','US')		      
INSERT INTO states (code,name,country_code) VALUES ('SC','South Carolina','US')		      
INSERT INTO states (code,name,country_code) VALUES ('SD','South Dakota','US')		      
INSERT INTO states (code,name,country_code) VALUES ('TN','Tennessee','US')		      
INSERT INTO states (code,name,country_code) VALUES ('TX','Texas','US')		      
INSERT INTO states (code,name,country_code) VALUES ('UT','Utah','US')		      
INSERT INTO states (code,name,country_code) VALUES ('VA','Virginia','US')		      
INSERT INTO states (code,name,country_code) VALUES ('VI','Virgin Islands','US')		      
INSERT INTO states (code,name,country_code) VALUES ('WA','Washington','US')		      
INSERT INTO states (code,name,country_code) VALUES ('WI','Wisconsin','US')		      
INSERT INTO states (code,name,country_code) VALUES ('WV','West Virginia','US')		      
INSERT INTO states (code,name,country_code) VALUES ('WY','Wyoming','US')		      
INSERT INTO states (code,name,country_code) VALUES ('AB','Alberta','CA')		      
INSERT INTO states (code,name,country_code) VALUES ('BC','British Columbia','CA')		      
INSERT INTO states (code,name,country_code) VALUES ('MB','Manitoba','CA')		      
INSERT INTO states (code,name,country_code) VALUES ('NB','New Brunswick','CA')		      
INSERT INTO states (code,name,country_code) VALUES ('NL','New Foundland','CA')		      
INSERT INTO states (code,name,country_code) VALUES ('NT','Northwest Territory','CA')		      
INSERT INTO states (code,name,country_code) VALUES ('NS','Nova Scotia','CA')		      
INSERT INTO states (code,name,country_code) VALUES ('NU','Nunavut','CA')		      
INSERT INTO states (code,name,country_code) VALUES ('ON','Ontario','CA')		      
INSERT INTO states (code,name,country_code) VALUES ('PE','Prince Edward Island','CA')		      
INSERT INTO states (code,name,country_code) VALUES ('QC','Quebec','CA')		      
INSERT INTO states (code,name,country_code) VALUES ('SK','Saskatchewan','CA')		      
INSERT INTO states (code,name,country_code) VALUES ('YT','Yukon Territory','CA')		      
GO

ALTER TABLE [dbo].[CUSTOMERS] DROP CONSTRAINT [DF__customers__VIEW___3541D3D0]
GO

ALTER TABLE customers ADD CONSTRAINT df_customer_view_schedule_flag DEFAULT ('Y') FOR view_schedule_flag
GO

DELETE FROM role_function_rights
WHERE function_id = (SELECT function_id FROM functions WHERE code = 'enet/req/q_edit')
AND right_type_id = (SELECT right_type_id FROM right_types WHERE code = 'insert')
AND role_id IN (SELECT role_id FROM roles 
WHERE code in ('dealer_sort', 'dealer-csc', 'dealer_users-single_dealer-no_cust_add'))
GO


CREATE INDEX [IX_REQUEST_QR] ON [dbo].[REQUESTS] ([QUOTE_REQUEST_ID])
GO

CREATE INDEX IX_project_end_user ON projects (end_user_id)
GO

CREATE UNIQUE INDEX IX_project_p_eu ON projects (project_id,end_user_id)
GO

CREATE UNIQUE INDEX IX_customer_cust_eu_parent ON customers (customer_id,end_user_parent_id)
GO
 