2008-1-30
	(1) INSERT INTO functions (function_group_id,name,code,is_nav_function,is_menu_function,date_created,created_by)
		SELECT function_group_id,'Create End User','enet/req/end_user_edit','N','N',getdate(),1
		  FROM function_groups
		 WHERE code='enet';
	(2) update job_services_v:

2008-1-31
	(1) Updated Georgia end user: using sp_aia_end_user.sql
	(2) Updated extranet_email_v2: added is_new
	(3) Created users_vq
2008-2-12
	(1) updated bill_jobs_v:replace dealer_name with end_user_name
	(2) updated invoice_pre_total_v: added end_user_name
	(3) updated invoice_post_totla_v: added end_user_name
2008-2-13
	(1) updated extranet_email_v2:lightup
	(2) Created project_quotes_v
	(3) Created quote_mail_v
	(4) Created request_mail_v
2008-2-15
	(1) DROP INDEX users.ix_user_active_flags
2008-2-28
	(1) created extranet_email_none_quote_v
	(2) created extranet_email_quote_v
2008-3-4
	(1) updated sp_estimator: added created_by_userand modified_by_user
2008-3-11
	(1) created db script, update_furniture_line_types.sql:update furniture line types
2008-3-12
	(1) insert into quotes_mapping(name,value,[group]) values ('National Services','NTLSV',1)
2008-3-13
	(1) updates versions_copy_v: version_no
2008-4-2
	(1) jobs_with_costs_v: replaced dealer with end user; replaced bill_qty with tc_qty
	(2) jobs_with_posted_costs_v: replaced dealer with end user
2008-4-8
	(1) updated quotes_mapping: UPDATE quotes_mapping SET value='Omni National Services' WHERE [name]='National Services' AND [group]=1
	(2) UPDATE quotes_mapping SET [name]='Illinois' WHERE value='Omni National Services'  AND [group]=1
2008-4-15
	(1) UPDATE quotes_mapping SET [name]='National Services',value='CI IL' WHERE [name]='Illinois' AND value='Omni National Services' AND [group]=1
2008-4-21
	(1) updated quick_project_v: Added end_user_name; removed ext_dealer_id, dealer_name, parent_customer_id
	(2) updated job_progress_v: adde end_user, removed dealer
	(3) updated invoices_extranet_v: adde end_user, removed dealer
	(4) ANM320.sql
2008-4-29
	(1) cleanup: alter table customers drop column customer_id_8
2008-5-15
	(1) updated invoices_extranet_v.sql:ext_delaer_id,dealer_name
2008-5-26
	(1) ANM360.sql: updated quotes table added columns.
2008-5-19
	(1) added bill_service_id to invoice_lines:
	   ALTER TABLE invoice_lines ADD bill_service_id NUMERIC(18,0)
	   GO
	   
	   ALTER TABLE invoice_lines ADD CONSTRAINT fk_il_bill_service_id FOREIGN KEY (bill_service_id) REFERENCES services (service_id)
           GO
2008-5-28
	(1) updated job_time_by_job_v.sql (ANM-358):added end user
2008-5-29
	(1) updated extranet_email_v2.sql (ANM-75):added end user name and description
	(2) updated extranet_email_quote_v.sql (ANM-75):added end user name and replace r.desc with q.desc
2008-6-4
	(1) updated quotes table, alter columns' size (ANM-367)
2008-6-16
	(1) contains_invoice_tracking_v (ANM-372) removed space before *.
	(2) Tony Scalse setup in test: INSERT INTO user_customers(user_id,customer_id) VALUES (2503,577); 
	(3) (Tony Scalse) Update quick_request_vendors_v.sql: added end user and updated customer
	(4) (Tony Scalse) Updated quick_quote_requests_v2.sql: added end_user_id and updated customer_id
	(5) () Updated quick_quotes_v.sql: added end_user_id and updated customer_id
	(6) () Updated quick_project_v.sql: added end_user_id and updated customer_id
	(7) () Updated quick_requests_v2.sql:updated end_user_id (not necessary)
2008-6-18 
	(1) Updated projects_all_requests_v:added end_user_id (ANM-373)
	(2) Update workorder_progress_v.sql: (ANM-373)
	(3) updated request_vendor_totals_v.sql: (ANM-373)
2008-8-4
	(1) A&M 379: updated extranet_email_quote_v.sql and extranet_email_none_quote_v.sql added is_new
	(2) A&M 280: updated invoice_lines_v: added bill_service_id and service_line_id 
2008-8-14
	(1) updated invoice_lines_v: removed service_line_id