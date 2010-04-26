INSERT INTO lookup_types
(code, name, active_flag, updatable_flag, created_by, date_created)
VALUES
('product_disposition_type', 'Product Disposition', 'Y', 'Y', 1, CURRENT_TIMESTAMP)
go
	 
	 

INSERT INTO lookups
(code, name, active_flag, updatable_flag, sequence_no, lookup_type_id, created_by, date_created)
(SELECT 'none', 'None', 'Y', 'Y', 1, lt.lookup_type_id, 1, CURRENT_TIMESTAMP
FROM lookup_types lt
WHERE lt.code = 'product_disposition_type')
go
	 
INSERT INTO lookups
(code, name, active_flag, updatable_flag, sequence_no, lookup_type_id, created_by, date_created)
(SELECT 'broker', 'Broker', 'Y', 'Y', 1, lt.lookup_type_id, 2, CURRENT_TIMESTAMP
FROM lookup_types lt
WHERE lt.code = 'product_disposition_type')
go

INSERT INTO lookups
(code, name, active_flag, updatable_flag, sequence_no, lookup_type_id, created_by, date_created)
(SELECT 'dispose', 'Dispose', 'Y', 'Y', 1, lt.lookup_type_id, 3, CURRENT_TIMESTAMP
FROM lookup_types lt
WHERE lt.code = 'product_disposition_type')
go

INSERT INTO lookups
(code, name, active_flag, updatable_flag, sequence_no, lookup_type_id, created_by, date_created)
(SELECT 'return_to_stock', 'Return to stock', 'Y', 'Y', 4, lt.lookup_type_id, 1, CURRENT_TIMESTAMP
FROM lookup_types lt
WHERE lt.code = 'product_disposition_type')
go

INSERT INTO lookups
(code, name, active_flag, updatable_flag, sequence_no, lookup_type_id, created_by, date_created)
(SELECT 'return_to_warehouse', 'Return to warehouse', 'Y', 'Y', 5, lt.lookup_type_id, 1, CURRENT_TIMESTAMP
FROM lookup_types lt
WHERE lt.code = 'product_disposition_type')
go

INSERT INTO lookups
(code, name, active_flag, updatable_flag, sequence_no, lookup_type_id, created_by, date_created)
(SELECT 'store_onsite', 'Store onsite', 'Y', 'Y', 6, lt.lookup_type_id, 1, CURRENT_TIMESTAMP
FROM lookup_types lt
WHERE lt.code = 'product_disposition_type')
go


CREATE VIEW dbo.PRODUCT_DISPOSITION_V  
AS  
SELECT     LOOKUP_TYPE_ID, type_code, type_name, type_active_flag, type_date_created, type_created_by, type_created_by_name, type_date_modified,   
                      type_modified_by, type_modified_by_name, LOOKUP_ID, lookup_code, lookup_name, lookup_active_flag, SEQUENCE_NO, EXT_ID,   
                      lookup_date_created, lookup_created_by, lookup_created_by_name, lookup_date_modified, lookup_modified_by, lookup_modified_by_name  
FROM         dbo.LOOKUPS_V  
WHERE     (type_code = 'product_disposition_type') AND (lookup_active_flag <> 'N') AND (type_active_flag <> 'N')  
go


ALTER TABLE requests
 ADD PROD_DISP_FLAG varchar(1) DEFAULT 'N' NULL
 CONSTRAINT PROD_DISP_YN CHECK (PROD_DISP_FLAG = 'Y' OR PROD_DISP_FLAG = 'N')
go
ALTER TABLE requests
ADD PROD_DISP_ID numeric(18) NULL
go

ALTER TABLE requests
ADD CONSTRAINT FK_REQUESTS_PROD_DIST FOREIGN KEY
(prod_disp_id) REFERENCES lookups (lookup_id)
go
