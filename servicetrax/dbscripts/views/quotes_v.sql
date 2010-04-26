
CREATE VIEW quotes_v
AS
SELECT c.organization_id, 
       q.quote_id,
       q.quote_no, 
       CAST(p.project_no AS VARCHAR) + '-' + CAST(q.quote_no AS VARCHAR) AS project_quote_no, 
       r.project_id, 
       p.project_no, 
       q.request_id, 
       q.request_type_id, 
       request_type.code AS request_type_code, 
       request_type.name AS request_type_name, 
       c.ext_dealer_id, 
       c.customer_name, 
       p.job_name,
       q.is_sent, 
       q.quote_type_id, 
       quote_type.code AS quote_type_code, 
       quote_type.name AS quote_type_name, 
       q.quote_status_type_id, 
       quote_status_type.code AS quote_status_type_code, 
       quote_status_type.name AS quote_status_type_name, 
       q.quoted_by_user_id, 
       q.date_quoted, 
       quoted_by.first_name + ' ' + quoted_by.last_name AS quoted_by_user_name, 
       q.description, 
       q.quote_total, 
       q.extra_conditions, 
       q.date_created, 
       q.created_by, 
       q.date_modified, 
       q.modified_by, 
       quoted_by_contact.phone_work AS quoted_by_phone, 
       quoted_by_contact.contact_name AS quoted_by_name, 
       dealer_sales_rep_contact.contact_name AS sales_rep_contact_name, 
       time_uom.name AS duration_name, 
       r.duration_qty, 
       q.warehouse_fee_flag, 
       request_type.sequence_no AS request_type_sequence_no, 
       o.ext_direct_dealer_id, 
       q.taxable_flag, 
       q.taxable_amount,
       q.version
  FROM dbo.customers c LEFT OUTER JOIN
       dbo.organizations o ON c.organization_id = o.organization_id RIGHT OUTER JOIN
       dbo.projects p RIGHT OUTER JOIN
       dbo.contacts quoted_by_contact RIGHT OUTER JOIN
       dbo.users quoted_by ON quoted_by_contact.contact_id = quoted_by.contact_id RIGHT OUTER JOIN
       dbo.lookups quote_type RIGHT OUTER JOIN
       dbo.lookups quote_status_type RIGHT OUTER JOIN
       dbo.quotes q LEFT OUTER JOIN
       dbo.lookups request_type ON q.request_type_id = request_type.lookup_id 
                                ON quote_status_type.lookup_id = q.quote_status_type_id 
                                ON quote_type.lookup_id = q.quote_type_id 
                                ON quoted_by.user_id = q.quoted_by_user_id LEFT OUTER JOIN
       dbo.lookups time_uom RIGHT OUTER JOIN
       dbo.contacts dealer_sales_rep_contact RIGHT OUTER JOIN
       dbo.requests r ON dealer_sales_rep_contact.contact_id = r.d_sales_rep_contact_id 
		      ON time_uom.lookup_id = r.duration_time_uom_type_id 
		      ON q.request_id = r.request_id 
		      ON p.project_id = r.project_id 
		      ON c.customer_id = p.customer_id

