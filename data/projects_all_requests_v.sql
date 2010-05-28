/* 
 * Recreate this view to have the hot sheets information.
 */
DROP VIEW [dbo].[projects_all_requests_v]
GO

CREATE VIEW [dbo].[projects_all_requests_v]
AS
SELECT p_v.project_id,
       p_v.project_no,
       r.request_id,
       r.request_no,
       q_v.quote_id,
       q_v.quote_no,
       CONVERT(VARCHAR, p_v.project_no) + '-' + CONVERT(VARCHAR, r.request_no) + '.' + CONVERT(VARCHAR, r.version_no) AS record_no,
       r.request_id AS record_id,
       r.request_no AS record_seq_no,
       r.version_no,
       dbo.versions_max_no_v.max_version_no,
       r.request_type_id AS record_type_id,
       request_type.code AS record_type_code,
       request_type.name AS record_type_name,
       request_type.sequence_no AS record_type_seq_no,
       r.request_status_type_id AS record_status_type_id,
       request_status_type.code AS record_status_type_code,
       request_status_type.name AS record_status_type_name,
       r.is_sent AS record_is_sent,
       ISNULL(r.date_modified, r.date_created) AS record_last_modified,
       r.date_created AS record_created,
       r.date_modified AS record_modified,
       p_v.project_status_type_id,
       p_v.project_status_type_code,
       p_v.project_status_type_name,
       p_v.parent_customer_id,
       p_v.organization_id,
       p_v.ext_dealer_id,
       p_v.dealer_name,
       p_v.ext_customer_id,
       p_v.customer_id,
       p_v.customer_name,
       p_v.end_user_id,
       p_v.end_user_name,
       p_v.refusal_email_info,
       p_v.survey_location,
       p_v.job_name,
       r.quote_request_id,
       r.request_type_id,
       request_type.code AS request_type_code,
       request_type.name AS request_type_name,
       r.request_status_type_id,
       request_status_type.code AS request_status_type_code,
       request_status_type.name AS request_status_type_name,
       r.is_sent AS request_is_sent,
       r.dealer_po_no,
       r.customer_po_no,
       r.dealer_project_no,
       r.design_project_no,
       r.est_start_date,
       CONVERT(VARCHAR(12), r.est_start_date, 101) AS est_start_date_varchar,
       r.a_m_contact_id,
       r.a_m_sales_contact_id,
       r.customer_contact_id,
       r.customer_contact2_id,
       r.customer_contact3_id,
       r.customer_contact4_id,
       r.d_sales_rep_contact_id,
       r.d_sales_sup_contact_id,
       r.d_designer_contact_id,
       r.d_proj_mgr_contact_id,
       r.a_m_install_sup_contact_id,
       r.a_d_designer_contact_id,
       r.gen_contractor_contact_id,
       r.electrician_contact_id,
       r.data_phone_contact_id,
       r.phone_contact_id,
       r.carpet_layer_contact_id,
       r.bldg_mgr_contact_id,
       r.security_contact_id,
       r.mover_contact_id,
       r.other_contact_id,
       r.furniture1_contact_id,
       r.furniture2_contact_id,
       r.is_quoted,
       r.description,
       r.approver_contact_id,
       r.alt_customer_contact_id,
       q_v.is_sent AS quote_is_sent,
       q_v.quote_type_id,
       q_v.quote_type_code,
       q_v.quote_type_name,
       q_v.quote_status_type_id,
       q_v.quote_status_type_code,
       q_v.quote_status_type_name,
       q_v.date_quoted,
       q_v.quote_total,
       q_v.quoted_by_user_id,
       q_v.quoted_by_user_name,
       p_v.is_new
  FROM dbo.projects_v2 p_v LEFT OUTER JOIN
       dbo.requests r ON p_v.project_id = r.project_id LEFT OUTER JOIN
       dbo.lookups request_type ON r.request_type_id = request_type.lookup_id LEFT OUTER JOIN
       dbo.lookups request_status_type ON r.request_status_type_id = request_status_type.lookup_id LEFT OUTER JOIN
       dbo.quotes_v q_v ON r.request_id = q_v.request_id  LEFT OUTER JOIN
       dbo.versions_max_no_v ON r.request_no = dbo.versions_max_no_v.request_no AND r.project_id = dbo.versions_max_no_v.project_id
UNION
SELECT p_v.project_id,
       p_v.project_no,
       r.request_id,
       r.request_no,
       q_v.quote_id,
       q_v.quote_no,
       CONVERT(VARCHAR, p_v.project_no) + '-' + CONVERT(VARCHAR, q_v.quote_no) + '.' + ISNULL(CONVERT(VARCHAR, q_v.version),' ') AS record_no,
       q_v.quote_id record_id,
       q_v.quote_no AS record_seq_no,
       1 version_no,
       1 max_version_no,
       q_v.request_type_id AS record_type_id,
       q_v.request_type_code AS record_type_code,
       q_v.request_type_name AS record_type_name,
       q_v.request_type_sequence_no AS record_type_seq_no,
       q_v.quote_status_type_id record_status_type_id,
       q_v.quote_status_type_code AS record_status_type_code,
       q_v.quote_status_type_name AS record_status_type_name,
       q_v.is_sent AS record_is_sent,
       ISNULL(q_v.date_modified, q_v.date_created) AS record_date,
       q_v.date_created AS record_created,
       q_v.date_modified AS record_modified,
       p_v.project_status_type_id,
       p_v.project_status_type_code,
       p_v.project_status_type_name,
       p_v.parent_customer_id,
       p_v.organization_id,
       p_v.ext_dealer_id,
       p_v.dealer_name,
       p_v.ext_customer_id,
       p_v.customer_id,
       p_v.customer_name,
       p_v.end_user_id,
       p_v.end_user_name,
       p_v.refusal_email_info,
       p_v.survey_location,
       p_v.job_name,
       r.quote_request_id,
       r.request_type_id,
       request_type.code AS request_type_code,
       request_type.name AS request_type_name,
       r.request_status_type_id,
       request_status_type.code AS request_status_type_code,
       request_status_type.name AS request_status_type_name,
       r.is_sent AS request_is_sent,
       r.dealer_po_no,
       r.customer_po_no,
       r.dealer_project_no,
       r.design_project_no,
       r.est_start_date,
       CONVERT(VARCHAR(12), r.est_start_date, 101) AS est_start_date_varchar,
       r.a_m_contact_id,
       r.a_m_sales_contact_id,
       r.customer_contact_id,
       r.customer_contact2_id,
       r.customer_contact3_id,
       r.customer_contact4_id,
       r.d_sales_rep_contact_id,
       r.d_sales_sup_contact_id,
       r.d_designer_contact_id,
       r.d_proj_mgr_contact_id,
       r.a_m_install_sup_contact_id,
       r.a_d_designer_contact_id,
       r.gen_contractor_contact_id,
       r.electrician_contact_id,
       r.data_phone_contact_id,
       r.phone_contact_id,
       r.carpet_layer_contact_id,
       r.bldg_mgr_contact_id,
       r.security_contact_id,
       r.mover_contact_id,
       r.other_contact_id,
       r.furniture1_contact_id,
       r.furniture2_contact_id,
       r.is_quoted,
       r.description,
       r.approver_contact_id,
       r.alt_customer_contact_id,
       q_v.is_sent AS quote_is_sent,
       q_v.quote_type_id,
       q_v.quote_type_code,
       q_v.quote_type_name,
       q_v.quote_status_type_id,
       q_v.quote_status_type_code,
       q_v.quote_status_type_name,
       q_v.date_quoted,
       q_v.quote_total,
       q_v.quoted_by_user_id,
       q_v.quoted_by_user_name,
       p_v.is_new
  FROM dbo.projects_v2 p_v INNER JOIN
       dbo.requests r ON p_v.project_id = r.project_id INNER JOIN
       dbo.lookups request_type ON r.request_type_id = request_type.lookup_id INNER JOIN
       dbo.lookups request_status_type ON r.request_status_type_id = request_status_type.lookup_id INNER JOIN
       dbo.quotes_v q_v  ON r.request_id = q_v.request_id
 WHERE quote_id IS NOT NULL
UNION
SELECT p_v.project_id,
       p_v.project_no,
       r.request_id,
       r.request_no,
       q_v.quote_id,
       q_v.quote_no,
       CONVERT(VARCHAR, p_v.project_no) + '-' + CONVERT(VARCHAR, r.request_no) + '.' + CONVERT(VARCHAR, r.version_no) + 'HS' + CONVERT(VARCHAR, h.hotsheet_no) AS record_no,
       r.request_id AS record_id,
       r.request_no AS record_seq_no,
       r.version_no,
       dbo.versions_max_no_v.max_version_no,
       h.request_type_id AS record_type_id,
       request_type.code AS record_type_code,
       request_type.name AS record_type_name,
       request_type.sequence_no AS record_type_seq_no,
       r.request_status_type_id AS record_status_type_id,
       request_status_type.code AS record_status_type_code,
       request_status_type.name AS record_status_type_name,
       r.is_sent AS record_is_sent,
       ISNULL(h.date_modified, h.date_created) AS record_last_modified,
       h.date_created AS record_created,
       h.date_modified AS record_modified,
       p_v.project_status_type_id,
       p_v.project_status_type_code,
       p_v.project_status_type_name,
       p_v.parent_customer_id,
       p_v.organization_id,
       p_v.ext_dealer_id,
       p_v.dealer_name,
       p_v.ext_customer_id,
       p_v.customer_id,
       p_v.customer_name,
       p_v.end_user_id,
       p_v.end_user_name,
       p_v.refusal_email_info,
       p_v.survey_location,
       p_v.job_name,
       r.quote_request_id,
       r.request_type_id,
       request_type.code AS request_type_code,
       request_type.name AS request_type_name,
       r.request_status_type_id,
       request_status_type.code AS request_status_type_code,
       request_status_type.name AS request_status_type_name,
       r.is_sent AS request_is_sent,
       r.dealer_po_no,
       r.customer_po_no,
       r.dealer_project_no,
       r.design_project_no,
       r.est_start_date,
       CONVERT(VARCHAR(12), r.est_start_date, 101) AS est_start_date_varchar,
       r.a_m_contact_id,
       r.a_m_sales_contact_id,
       r.customer_contact_id,
       r.customer_contact2_id,
       r.customer_contact3_id,
       r.customer_contact4_id,
       r.d_sales_rep_contact_id,
       r.d_sales_sup_contact_id,
       r.d_designer_contact_id,
       r.d_proj_mgr_contact_id,
       r.a_m_install_sup_contact_id,
       r.a_d_designer_contact_id,
       r.gen_contractor_contact_id,
       r.electrician_contact_id,
       r.data_phone_contact_id,
       r.phone_contact_id,
       r.carpet_layer_contact_id,
       r.bldg_mgr_contact_id,
       r.security_contact_id,
       r.mover_contact_id,
       r.other_contact_id,
       r.furniture1_contact_id,
       r.furniture2_contact_id,
       r.is_quoted,
       r.description,
       r.approver_contact_id,
       r.alt_customer_contact_id,
       q_v.is_sent AS quote_is_sent,
       q_v.quote_type_id,
       q_v.quote_type_code,
       q_v.quote_type_name,
       q_v.quote_status_type_id,
       q_v.quote_status_type_code,
       q_v.quote_status_type_name,
       q_v.date_quoted,
       q_v.quote_total,
       q_v.quoted_by_user_id,
       q_v.quoted_by_user_name,
       p_v.is_new
FROM dbo.projects_v2 p_v LEFT OUTER JOIN
       dbo.hotsheets h ON p_v.project_id = h.project_id LEFT OUTER JOIN
       dbo.requests r ON p_v.project_id = r.project_id LEFT OUTER JOIN
       dbo.lookups request_type ON h.request_type_id = request_type.lookup_id LEFT OUTER JOIN
       dbo.lookups request_status_type ON r.request_status_type_id = request_status_type.lookup_id LEFT OUTER JOIN
       dbo.quotes_v q_v ON r.request_id = q_v.request_id  LEFT OUTER JOIN
       dbo.versions_max_no_v ON r.request_no = dbo.versions_max_no_v.request_no AND r.project_id = dbo.versions_max_no_v.project_id
GO
