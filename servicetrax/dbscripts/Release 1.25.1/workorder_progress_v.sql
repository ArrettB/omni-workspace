DROP VIEW workorder_progress_v
GO

CREATE VIEW workorder_progress_v
AS
SELECT organization_id, 
       project_id, 
       request_id, 
       project_no, 
       request_no, 
       workorder_no, 
       project_status_type_id, 
       project_status_type_code,
       project_status_type_name, 
       request_status_type_id, 
       request_status_type_code, 
       request_status_type_name, 
       approved_seq_no, 
       request_seq_no, 
       request_type_id, 
       request_type_code, 
       request_type_name, 
       ext_dealer_id, 
       dealer_name, 
       customer_id, 
       parent_customer_id, 
       customer_name, 
       end_user_id,
       end_user_name,
       job_name, 
       dealer_po_no, 
       customer_po_no, 
       priority,
       sum_estimated_cost,
       sum_total_cost, 
       sum_visit_count,
       date_created, 
       created_by,
       created_by_name,
       date_modified,
       modified_by,
       modified_by_name,
       vendor_count, 
       punchlist_flag, 
       vendor_complete_count,
       min_invoice_date,
       ISNULL(min_act_start_date, ISNULL(min_sch_start_date, min_est_start_date)) AS min_start_date, 
       ISNULL(max_act_end_date, ISNULL(max_sch_end_date, max_est_end_date)) AS max_end_date, 
       GETDATE() AS cur_date, 
       CAST(DATEDIFF(hour, GETDATE(), ISNULL(max_act_end_date, ISNULL(max_sch_end_date, max_est_end_date)) + 1) AS numeric) AS cur_duration_left, 
       CASE CAST(DATEDIFF(hour, ISNULL(min_act_start_date, ISNULL(min_sch_start_date, min_est_start_date)), ISNULL(max_act_end_date, ISNULL(max_sch_end_date, max_est_end_date)) + 1) AS numeric) 
         WHEN 0 THEN NULL 
         ELSE CAST(DATEDIFF(hour, ISNULL(min_act_start_date, ISNULL(min_sch_start_date, min_est_start_date)), ISNULL(max_act_end_date, ISNULL(max_sch_end_date, max_est_end_date)) + 1) AS numeric) 
         END AS duration
  FROM dbo.REQUEST_VENDOR_TOTALS_V
GO