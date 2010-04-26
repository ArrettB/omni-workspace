INSERT INTO lookup_types (code,name,active_flag,updatable_flag,date_created,created_by)
VALUES ('customer_costing_type','Customer Costing Type','Y','Y',getdate(),1)
INSERT INTO lookup_types (code,name,active_flag,updatable_flag,date_created,created_by)
VALUES ('order_type','Order Type','Y','Y',getdate(),1)
INSERT INTO lookup_types (code,name,active_flag,updatable_flag,date_created,created_by)
VALUES ('yes_no_na_type','Yes/No/NA Type','Y','Y',getdate(),1)
GO


UPDATE lookups set sequence_no=10 WHERE code='dealer' AND lookup_type_id = (SELECT lookup_type_id FROM lookup_types WHERE code='customer_type')
UPDATE lookups set sequence_no=60,active_flag='N' WHERE code='direct' AND lookup_type_id = (SELECT lookup_type_id FROM lookup_types WHERE code='customer_type')
UPDATE lookups set sequence_no=70,active_flag='N' WHERE code='network' AND lookup_type_id = (SELECT lookup_type_id FROM lookup_types WHERE code='customer_type')
GO
INSERT INTO lookups (lookup_type_id,code,name,sequence_no,active_flag,updatable_flag,date_created,created_by)
SELECT lookup_type_id,'commercial','Commercial',20,'Y','Y',getdate(),1  FROM lookup_types WHERE code='customer_type'
INSERT INTO lookups (lookup_type_id,code,name,sequence_no,active_flag,updatable_flag,date_created,created_by)
SELECT lookup_type_id,'corporate','Corporate',30,'Y','Y',getdate(),1  FROM lookup_types WHERE code='customer_type'
INSERT INTO lookups (lookup_type_id,code,name,sequence_no,active_flag,updatable_flag,date_created,created_by)
SELECT lookup_type_id,'government','Government',40,'Y','Y',getdate(),1  FROM lookup_types WHERE code='customer_type'
INSERT INTO lookups (lookup_type_id,code,name,sequence_no,active_flag,updatable_flag,date_created,created_by)
SELECT lookup_type_id,'end_user','End User',50,'Y','Y',getdate(),1  FROM lookup_types WHERE code='customer_type'
GO

INSERT INTO lookups (lookup_type_id,code,name,sequence_no,active_flag,updatable_flag,date_created,created_by)
SELECT lookup_type_id,'to_job','To Job',10,'Y','Y',getdate(),1  FROM lookup_types WHERE code='customer_costing_type'
INSERT INTO lookups (lookup_type_id,code,name,sequence_no,active_flag,updatable_flag,date_created,created_by)
SELECT lookup_type_id,'to_customer','To Customer',20,'Y','Y',getdate(),1  FROM lookup_types WHERE code='customer_costing_type'
INSERT INTO lookups (lookup_type_id,code,name,sequence_no,active_flag,updatable_flag,date_created,created_by)
SELECT lookup_type_id,'to_vendor','To Vendor',30,'Y','Y',getdate(),1  FROM lookup_types WHERE code='customer_costing_type'
INSERT INTO lookups (lookup_type_id,code,name,sequence_no,active_flag,updatable_flag,date_created,created_by)
SELECT lookup_type_id,'warehouse_feet','Warehouse Feet',40,'Y','Y',getdate(),1  FROM lookup_types WHERE code='customer_costing_type'
GO


UPDATE lookups set sequence_no=10 WHERE code='n_a' AND lookup_type_id = (SELECT lookup_type_id FROM lookup_types WHERE code='delivery_type')
UPDATE lookups set sequence_no=20 WHERE code='direct' AND lookup_type_id = (SELECT lookup_type_id FROM lookup_types WHERE code='delivery_type')
UPDATE lookups set sequence_no=50,active_flag='N' WHERE code='a_m' AND lookup_type_id = (SELECT lookup_type_id FROM lookup_types WHERE code='delivery_type')
UPDATE lookups set sequence_no=60,active_flag='N' WHERE code='dealer' AND lookup_type_id = (SELECT lookup_type_id FROM lookup_types WHERE code='delivery_type')
UPDATE lookups set sequence_no=70,active_flag='N' WHERE code='dealer_dealer' AND lookup_type_id = (SELECT lookup_type_id FROM lookup_types WHERE code='delivery_type')
UPDATE lookups set sequence_no=80,active_flag='N' WHERE code='direct_a_m' AND lookup_type_id = (SELECT lookup_type_id FROM lookup_types WHERE code='delivery_type')
UPDATE lookups set sequence_no=90,active_flag='N' WHERE code='direct_dealer_a_m' AND lookup_type_id = (SELECT lookup_type_id FROM lookup_types WHERE code='delivery_type')
UPDATE lookups set sequence_no=100,active_flag='N' WHERE code='dealer_a_m' AND lookup_type_id = (SELECT lookup_type_id FROM lookup_types WHERE code='delivery_type')
GO
INSERT INTO lookups (lookup_type_id,code,name,sequence_no,active_flag,updatable_flag,date_created,created_by)
SELECT lookup_type_id,'omni_receive_and_delivery','Omni Receive and Delivery',20,'Y','Y',getdate(),1  FROM lookup_types WHERE code='delivery_type'
INSERT INTO lookups (lookup_type_id,code,name,sequence_no,active_flag,updatable_flag,date_created,created_by)
SELECT lookup_type_id,'on_site','On Site',30,'Y','Y',getdate(),1  FROM lookup_types WHERE code='delivery_type'
GO


UPDATE lookups set sequence_no=40,active_flag='N' WHERE code='yes_both' AND lookup_type_id = (SELECT lookup_type_id FROM lookup_types WHERE code='elevator_available_type')
UPDATE lookups set sequence_no=50,active_flag='N' WHERE code='yes_freight' AND lookup_type_id = (SELECT lookup_type_id FROM lookup_types WHERE code='elevator_available_type')
UPDATE lookups set sequence_no=60,active_flag='N' WHERE code='yes_passenger' AND lookup_type_id = (SELECT lookup_type_id FROM lookup_types WHERE code='elevator_available_type')
UPDATE lookups set sequence_no=70,active_flag='N' WHERE code='no' AND lookup_type_id = (SELECT lookup_type_id FROM lookup_types WHERE code='elevator_available_type')
GO
INSERT INTO lookups (lookup_type_id,code,name,sequence_no,active_flag,updatable_flag,date_created,created_by)
SELECT lookup_type_id,'dock_access_with_elevator','Dock Access with Elevator',10,'Y','Y',getdate(),1  FROM lookup_types WHERE code='elevator_available_type'
INSERT INTO lookups (lookup_type_id,code,name,sequence_no,active_flag,updatable_flag,date_created,created_by)
SELECT lookup_type_id,'no_dock_access_with_elevator','No Dock Access with Elevator',20,'Y','Y',getdate(),1  FROM lookup_types WHERE code='elevator_available_type'
INSERT INTO lookups (lookup_type_id,code,name,sequence_no,active_flag,updatable_flag,date_created,created_by)
SELECT lookup_type_id,'other','Other',30,'Y','Y',getdate(),1  FROM lookup_types WHERE code='elevator_available_type'
GO


INSERT INTO lookups (lookup_type_id,code,name,sequence_no,active_flag,updatable_flag,attribute2,date_created,created_by)
SELECT lookup_type_id,'n_a','N/A',100,'Y','Y','system',getdate(),1  FROM lookup_types WHERE code='furniture_line_type'
GO


UPDATE lookups set sequence_no=20 WHERE code='no' AND lookup_type_id = (SELECT lookup_type_id FROM lookup_types WHERE code='wall_mount_type')
UPDATE lookups set sequence_no=30,active_flag='N' WHERE code='yes_both' AND lookup_type_id = (SELECT lookup_type_id FROM lookup_types WHERE code='wall_mount_type')
UPDATE lookups set sequence_no=40,active_flag='N' WHERE code='yes_drywall' AND lookup_type_id = (SELECT lookup_type_id FROM lookup_types WHERE code='wall_mount_type')
UPDATE lookups set sequence_no=50,active_flag='N' WHERE code='yes_masonry' AND lookup_type_id = (SELECT lookup_type_id FROM lookup_types WHERE code='wall_mount_type')
GO
INSERT INTO lookups (lookup_type_id,code,name,sequence_no,active_flag,updatable_flag,date_created,created_by)
SELECT lookup_type_id,'yes','Yes',10,'Y','Y',getdate(),1  FROM lookup_types WHERE code='wall_mount_type'
GO


INSERT INTO lookups (lookup_type_id,code,name,sequence_no,active_flag,updatable_flag,date_created,created_by)
SELECT lookup_type_id,'yes','Yes',10,'Y','Y',getdate(),1  FROM lookup_types WHERE code='yes_no_na_type'
INSERT INTO lookups (lookup_type_id,code,name,sequence_no,active_flag,updatable_flag,date_created,created_by)
SELECT lookup_type_id,'no','No',20,'Y','Y',getdate(),1  FROM lookup_types WHERE code='yes_no_na_type'
INSERT INTO lookups (lookup_type_id,code,name,sequence_no,active_flag,updatable_flag,date_created,created_by)
SELECT lookup_type_id,'n_a','N/A',30,'Y','Y',getdate(),1  FROM lookup_types WHERE code='yes_no_na_type'
GO


INSERT INTO lookups (lookup_type_id,code,name,sequence_no,active_flag,updatable_flag,date_created,created_by)
SELECT lookup_type_id,'original_order','Original Order',10,'Y','Y',getdate(),1  FROM lookup_types WHERE code='order_type'
INSERT INTO lookups (lookup_type_id,code,name,sequence_no,active_flag,updatable_flag,date_created,created_by)
SELECT lookup_type_id,'change_order','Change Order',20,'Y','Y',getdate(),1  FROM lookup_types WHERE code='order_type'
INSERT INTO lookups (lookup_type_id,code,name,sequence_no,active_flag,updatable_flag,date_created,created_by)
SELECT lookup_type_id,'punchlist_order','Punchlist Order',30,'Y','Y',getdate(),1  FROM lookup_types WHERE code='order_type'
GO

