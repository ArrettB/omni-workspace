INSERT INTO lookup_types (code,name,active_flag,updatable_flag,date_created,created_by)
VALUES ('po_status_type','PO Status Type','Y','Y',getdate(),1)
GO

INSERT INTO lookups (lookup_type_id,code,name,sequence_no,active_flag,updatable_flag,date_created,created_by)
SELECT lookup_type_id,'new','New',10,'Y','Y',getdate(),1  FROM lookup_types WHERE code='po_status_type'
INSERT INTO lookups (lookup_type_id,code,name,sequence_no,active_flag,updatable_flag,date_created,created_by)
SELECT lookup_type_id,'released','Released',20,'Y','Y',getdate(),1  FROM lookup_types WHERE code='po_status_type'
INSERT INTO lookups (lookup_type_id,code,name,sequence_no,active_flag,updatable_flag,date_created,created_by)
SELECT lookup_type_id,'received','Received',30,'Y','Y',getdate(),1  FROM lookup_types WHERE code='po_status_type'
INSERT INTO lookups (lookup_type_id,code,name,sequence_no,active_flag,updatable_flag,date_created,created_by)
SELECT lookup_type_id,'canceled','Canceled',40,'Y','Y',getdate(),1  FROM lookup_types WHERE code='po_status_type'
GO

CREATE TABLE purchase_orders(
po_id int IDENTITY(1,1) primary key not null,
po_no int not null,
request_id numeric(18,0) not null,
ext_po_id char(17),
po_status_id numeric(18,0) not null,
ext_vendor_id char(15) not null,
vendor_name varchar(65) not null,
ext_vendor_address_id char(15) not null,
billing_type_id numeric(18,0) not null,
item_id numeric(18,0) not null,
po_total numeric(18,2),
description varchar(1000),
date_released datetime,
date_received datetime,
date_canceled datetime,
created_by numeric(18,0) not null,
date_created datetime not null,
modified_by numeric(18,0),
date_modified datetime)
GO

ALTER TABLE purchase_orders ADD CONSTRAINT fk_po_request_id FOREIGN KEY (request_id) REFERENCES requests (request_id)
GO

ALTER TABLE purchase_orders ADD CONSTRAINT fk_po_status_id FOREIGN KEY (po_status_id) REFERENCES lookups (lookup_id)
GO

ALTER TABLE purchase_orders ADD CONSTRAINT fk_po_billing_type_id FOREIGN KEY (billing_type_id) REFERENCES lookups (lookup_id)
GO

ALTER TABLE purchase_orders ADD CONSTRAINT fk_po_item_id FOREIGN KEY (item_id) REFERENCES items (item_id)
GO

INSERT INTO templates (template_name) VALUES ('enet/po/po_detail.html')
GO

INSERT INTO functions (function_group_id,
                       template_id,
                       name,
                       code,
                       description,
                       sequence_no,
                       is_nav_function,
                       is_menu_function,
                       date_created,
                       created_by)
SELECT fg.function_group_id,
       t.template_id,
       'Po Detail',
       'enet/po/po_detail',
       'PO Detail',
       null,
       'N',
       'N',
       getdate(),
       1
  FROM function_groups fg,
       templates t 
 WHERE fg.code='enet'
   AND t.template_name='enet/po/po_detail.html'
GO

INSERT INTO function_right_types (function_id,
                                  right_type_id,
                                  updatable_flag,
                                  date_created,
                                  created_by)
SELECT f.function_id,
       rt.right_type_id,
       'Y',
       getdate(),
       1 
  FROM functions f, 
       right_types rt
WHERE f.code='enet/po/po_detail'
GO




DROP VIEW bill_jobs_v
GO

CREATE VIEW bill_jobs_v
AS
SELECT j.billing_user_id, 
       sl.bill_job_no, 
       sl.bill_job_id, 
       CASE WHEN customer_type.code = 'end_user' THEN eu_parent.customer_name ELSE c.customer_name END customer_name,
       CASE WHEN customer_type.code = 'end_user' THEN c.customer_name ELSE eu.customer_name END end_user_name,
       c.ext_dealer_id, 
       u.first_name + ' ' + u.last_name AS billing_user_name, 
       jl.name AS job_status_type_name, 
       j.job_name, 
       sl.organization_id, 
       CONVERT(varchar, MAX(s.est_end_date), 1) AS max_est_end_date_varchar,	
       SUM(CASE WHEN sl.billable_flag = 'Y'THEN sl.bill_total ELSE 0 END) billable_total, 
       SUM(CASE WHEN sl.billable_flag = 'N' THEN sl.bill_total ELSE 0 END) non_billable_total,
       (SELECT ISNULL(SUM(il.extended_price),0) 
	      FROM invoices i inner join invoice_lines il ON i.invoice_id = il.invoice_id
	     WHERE i.job_id = sl.bill_job_id) AS  invoiced_total,
       (SELECT COUNT(po.po_id) FROM purchase_orders po INNER JOIN 
                                    requests r ON po.request_id=r.request_id
         WHERE r.project_id=j.project_id) po_count,
       (SELECT COUNT(po.po_id) FROM purchase_orders po INNER JOIN 
                                    requests r ON po.request_id=r.request_id INNER JOIN
                                    lookups l ON po.po_status_id=l.lookup_id
         WHERE r.project_id=j.project_id AND l.code = 'received') received_po_count
  FROM dbo.service_lines sl INNER JOIN
       dbo.services s ON sl.bill_service_id = s.service_id INNER JOIN 
       dbo.jobs j ON sl.bill_job_id = j.job_id INNER JOIN 
       dbo.customers c ON j.customer_id = c.customer_id INNER JOIN 
       dbo.lookups jl ON j.job_status_type_id = jl.lookup_id INNER JOIN
       dbo.lookups customer_type ON c.customer_type_id = customer_type.lookup_id LEFT OUTER JOIN
       dbo.customers eu ON j.end_user_id = eu.customer_id LEFT OUTER JOIN 
       dbo.invoices i ON sl.invoice_id = i.invoice_id LEFT OUTER JOIN 
       dbo.users u ON j.billing_user_id = u.user_id LEFT OUTER JOIN 
       dbo.customers eu_parent ON c.end_user_parent_id = eu_parent.customer_id
 WHERE sl.status_id = 4
   AND sl.internal_req_flag = 'N'
   AND (i.status_id = 1 OR i.status_id IS NULL) 
GROUP BY j.billing_user_id, 
         sl.bill_job_no, 
         sl.bill_job_id, 
         CASE WHEN customer_type.code = 'end_user' THEN eu_parent.customer_name ELSE c.customer_name END,
         CASE WHEN customer_type.code = 'end_user' THEN c.customer_name ELSE eu.customer_name END,
         u.first_name, 
         u.last_name, 
         jl.name, 
         j.job_name, 
         sl.organization_id, 
         c.ext_dealer_id,
         j.project_id
GO

DROP VIEW sch_job_list_v
GO

CREATE VIEW sch_job_list_v 
AS
SELECT CAST(j.job_id AS varchar(30)) + ':' + ISNULL(CAST(s.service_id AS varchar(30)), '') AS job_service_id,
       j.job_id,
       j.job_no,
       j.job_name,
       s.service_id,
       s.service_no, 
       s.request_id,
       c.organization_id,     
       c.ext_dealer_id,
       c.dealer_name,
       j.customer_id,
       c.customer_name,
       j.job_type_id,
       job_type.code job_type_code,
       substring(job_type.name,1,1) job_type_name, 
       j.job_status_type_id,
       job_status_type.code job_status_type_code,
       substring(job_status_type.name,1,8) job_status_type_name,
       s.serv_status_type_id,
       serv_status_type.code serv_status_type_code, 
       serv_status_type.name serv_status_type_name,
       s.schedule_type_id,
       schedule_type.code schedule_type_code,
       schedule_type.name schedule_type_name, 
       s.service_type_id,
       service_type.code service_type_code,
       service_type.name service_type_name,
       s.est_start_date,
       s.est_start_time,
       s.est_end_date,
       s.watch_flag,
       CASE s.weekend_flag WHEN 'Y' THEN 'Yes' WHEN 'N' THEN 'No' ELSE 'N/A' END AS weekend_flag_name,
       s.po_no,
       res.user_id foreman_user_id,
       foreman.first_name + ' ' + foreman.last_name AS foreman_user_name,
       eu.customer_name end_user_name,
       jl.job_location_name,
       (SELECT TOP 1 contact_name + ' - ' + dbo.sp_contact_phone(contact_id) FROM contacts WHERE contact_id=r.customer_contact_id) customer_contact,
       (SELECT TOP 1 contact_name + ' - ' + dbo.sp_contact_phone(contact_id) FROM contacts WHERE contact_id =r.job_location_contact_id) job_location_contact,
       ISNULL(r.schedule_with_client_flag,'N') schedule_with,
       q.[roc_omni_discounted_hours-total] est_hours
  FROM jobs j INNER JOIN
       lookups job_type ON j.job_type_id = job_type.lookup_id INNER JOIN
       lookups job_status_type ON j.job_status_type_id = job_status_type.lookup_id INNER JOIN
       customers c ON j.customer_id = c.customer_id LEFT OUTER JOIN
       users billing_user ON j.billing_user_id = billing_user.user_ID LEFT OUTER JOIN
       resources res ON j.foreman_resource_id = res.resource_id LEFT OUTER JOIN
       users foreman ON res.user_id = foreman.user_id LEFT OUTER JOIN
       services s ON j.job_id = s.job_id LEFT OUTER JOIN
       lookups serv_status_type ON s.serv_status_type_id = serv_status_type.lookup_id LEFT OUTER JOIN
       lookups schedule_type ON s.schedule_type_id = schedule_type.lookup_id LEFT OUTER JOIN
       lookups service_type ON s.service_type_id = service_type.lookup_id LEFT OUTER JOIN
       job_locations jl ON s.job_location_id = jl.job_location_id LEFT OUTER JOIN
       requests r ON s.request_id=r.request_id LEFT OUTER JOIN 
       projects p ON j.project_id = p.project_id LEFT OUTER JOIN
       customers eu ON p.end_user_id = eu.customer_id LEFT OUTER JOIN
       quotes q ON s.quote_id = q.quote_id
GO

DROP VIEW vendors_v
GO


CREATE VIEW vendors_v 
AS
SELECT o.organization_id, tmp.ext_vendor_id, tmp.vendor_name
  FROM organizations o INNER JOIN
       (SELECT RTRIM(vendorid) ext_vendor_id, RTRIM(vendname) vendor_name, 'Minneapolis' org_name
          FROM ambim.dbo.pm00200
         WHERE vendstts <> 2 AND vendorid NOT LIKE 'old%'
       UNION
        SELECT RTRIM(vendorid) ext_vendor_id, RTRIM(vendname) vendor_name, 'Wisconsin' org_name
          FROM ammad.dbo.pm00200
         WHERE vendstts <> 2 AND vendorid NOT LIKE 'old%'
       UNION
        SELECT RTRIM(vendorid) ext_vendor_id, RTRIM(vendname) vendor_name, 'Georgia' org_name
          FROM aia.dbo.pm00200
         WHERE vendstts <> 2 AND vendorid NOT LIKE 'old%'
       UNION
        SELECT RTRIM(vendorid) ext_vendor_id, RTRIM(vendname) vendor_name, 'Milwaukee' org_name
          FROM ciinc.dbo.pm00200
         WHERE vendstts <> 2 AND vendorid NOT LIKE 'old%'
       UNION
        SELECT RTRIM(vendorid) ext_vendor_id, RTRIM(vendname) vendor_name, 'Illinois' org_name
          FROM cillc.dbo.pm00200
         WHERE vendstts <> 2 AND vendorid NOT LIKE 'old%'
       UNION
        SELECT RTRIM(vendorid) ext_vendor_id, RTRIM(vendname) vendor_name, 'ICS' org_name
          FROM ics.dbo.pm00200
         WHERE vendstts <> 2 AND vendorid NOT LIKE 'old%'
       UNION
        SELECT RTRIM(vendorid) ext_vendor_id, RTRIM(vendname) vendor_name, 'Plymouth' org_name
          FROM cimn.dbo.pm00200
         WHERE vendstts <> 2 AND vendorid NOT LIKE 'old%'
       UNION
        SELECT RTRIM(vendorid) ext_vendor_id, RTRIM(vendname) vendor_name, 'National Services' org_name
          FROM ntlsv.dbo.pm00200
         WHERE vendstts <> 2 AND vendorid NOT LIKE 'old%'
        ) tmp ON o.name = tmp.org_name
GO