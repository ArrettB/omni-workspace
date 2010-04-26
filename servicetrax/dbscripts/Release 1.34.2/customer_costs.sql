UPDATE requests SET cost_to_cust_type_id = (SELECT lookup_id FROM yes_no_type_v WHERE yes_no_type_code = 'Y') where cost_to_cust_type_id is null and customer_costing_type_id = (SELECT whf.lookup_id FROM LOOKUPS_V whf
	WHERE whf.type_code = 'customer_costing_type'
     AND whf.lookup_code = 'to_customer')
go
UPDATE requests SET cost_to_vend_type_id = (SELECT lookup_id FROM yes_no_type_v WHERE yes_no_type_code = 'Y') where cost_to_vend_type_id is null and customer_costing_type_id= (SELECT whf.lookup_id FROM LOOKUPS_V whf
	WHERE whf.type_code = 'customer_costing_type'
     AND whf.lookup_code = 'to_vendor')
go
UPDATE requests SET cost_to_job_type_id = (SELECT lookup_id FROM yes_no_type_v WHERE yes_no_type_code = 'Y') where cost_to_job_type_id is null and customer_costing_type_id = (SELECT whf.lookup_id FROM LOOKUPS_V whf
	WHERE whf.type_code = 'customer_costing_type'
     AND whf.lookup_code = 'to_job')
go
UPDATE requests SET warehouse_fee_type_id = (SELECT lookup_id FROM yes_no_type_v WHERE yes_no_type_code = 'Y') where warehouse_fee_type_id is null and customer_costing_type_id = (SELECT whf.lookup_id FROM LOOKUPS_V whf
	WHERE whf.type_code = 'customer_costing_type'
     AND whf.lookup_code = 'warehouse_feet')
go



UPDATE requests SET cost_to_cust_type_id = (SELECT lookup_id FROM yes_no_type_v WHERE yes_no_type_code = 'n') where cost_to_cust_type_id is null and customer_costing_type_id IS NOT NULL
go
UPDATE requests SET cost_to_vend_type_id = (SELECT lookup_id FROM yes_no_type_v WHERE yes_no_type_code = 'n') where cost_to_vend_type_id is null and customer_costing_type_id IS NOT NULL
go
UPDATE requests SET cost_to_job_type_id = (SELECT lookup_id FROM yes_no_type_v WHERE yes_no_type_code = 'n') where cost_to_job_type_id is null and customer_costing_type_id IS NOT NULL
go
UPDATE requests SET warehouse_fee_type_id = (SELECT lookup_id FROM yes_no_type_v WHERE yes_no_type_code = 'n') where warehouse_fee_type_id is null and customer_costing_type_id IS NOT NULL
go

