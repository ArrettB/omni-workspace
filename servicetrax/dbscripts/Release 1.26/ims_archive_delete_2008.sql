DELETE FROM checklist_data WHERE checklist_id IN (SELECT checklist_id FROM checklists WHERE request_id IN (SELECT request_id FROM requests WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006')))
GO

DELETE FROM checklists WHERE checklist_id IN (SELECT checklist_id FROM checklists WHERE request_id IN (SELECT request_id FROM requests WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006')))
GO


DELETE FROM serv_inv_lines 
 WHERE service_line_id IN (SELECT service_line_id FROM service_lines 
                            WHERE tc_job_id IN (SELECT job_id FROM jobs WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006')))
GO
DELETE FROM serv_inv_lines 
 WHERE service_line_id IN (SELECT service_line_id FROM service_lines 
                            WHERE bill_job_id IN (SELECT job_id FROM jobs WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006')))
GO
DELETE FROM serv_inv_lines 
 WHERE service_line_id IN (SELECT service_line_id FROM service_lines 
                            WHERE tc_service_id IN (SELECT service_id FROM services WHERE job_id IN (SELECT job_id FROM jobs WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006')) OR request_id IN (SELECT request_id FROM requests WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006'))))
GO
DELETE FROM serv_inv_lines 
 WHERE service_line_id IN (SELECT service_line_id FROM service_lines 
                            WHERE bill_service_id IN (SELECT service_id FROM services WHERE job_id IN (SELECT job_id FROM jobs WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006')) OR request_id IN (SELECT request_id FROM requests WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006'))))
GO
DELETE FROM serv_inv_lines 
 WHERE service_line_id IN (SELECT service_line_id FROM service_lines 
                            WHERE invoice_id IN (SELECT invoice_id FROM invoices WHERE job_id IN (SELECT job_id FROM jobs WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006'))))
GO
DELETE FROM serv_inv_lines 
 WHERE service_line_id IN (SELECT service_line_id FROM service_lines 
                            WHERE ph_service_id IN (SELECT service_id FROM services WHERE job_id IN (SELECT job_id FROM jobs WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006')) OR request_id IN (SELECT request_id FROM requests WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006'))))
GO
DELETE FROM serv_inv_lines 
 WHERE invoice_line_id IN (SELECT invoice_line_id FROM invoice_lines 
                            WHERE invoice_id IN (SELECT invoice_id FROM invoices WHERE job_id IN (SELECT job_id FROM jobs WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006')))) 
GO


DELETE FROM invoice_tracking WHERE invoice_id IN (SELECT invoice_id FROM invoices WHERE job_id IN (SELECT job_id FROM jobs WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006')))
GO

ALTER TABLE invoice_lines DISABLE TRIGGER del_inv_line_no
GO
DELETE FROM invoice_lines WHERE invoice_id IN (SELECT invoice_id FROM invoices WHERE job_id IN (SELECT job_id FROM jobs WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006')))
                             OR bill_service_id IN (SELECT service_id FROM services WHERE job_id IN (SELECT job_id FROM jobs WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006')) OR request_id IN (SELECT request_id FROM requests WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006')))
GO
ALTER TABLE invoice_lines ENABLE TRIGGER del_inv_line_no
GO



ALTER TABLE payroll_batch_lines DISABLE TRIGGER del_payroll_batch_line
GO
DELETE FROM payroll_batch_lines 
 WHERE service_line_id IN (SELECT service_line_id FROM service_lines 
                            WHERE tc_job_id IN (SELECT job_id FROM jobs WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006')))
GO
DELETE FROM payroll_batch_lines 
 WHERE service_line_id IN (SELECT service_line_id FROM service_lines 
                            WHERE bill_job_id IN (SELECT job_id FROM jobs WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006')))
GO
DELETE FROM payroll_batch_lines 
 WHERE service_line_id IN (SELECT service_line_id FROM service_lines 
                            WHERE tc_service_id IN (SELECT service_id FROM services WHERE job_id IN (SELECT job_id FROM jobs WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006')) OR request_id IN (SELECT request_id FROM requests WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006'))))
GO
DELETE FROM payroll_batch_lines 
 WHERE service_line_id IN (SELECT service_line_id FROM service_lines 
                            WHERE bill_service_id IN (SELECT service_id FROM services WHERE job_id IN (SELECT job_id FROM jobs WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006')) OR request_id IN (SELECT request_id FROM requests WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006'))))
GO
DELETE FROM payroll_batch_lines 
 WHERE service_line_id IN (SELECT service_line_id FROM service_lines 
                            WHERE invoice_id IN (SELECT invoice_id FROM invoices WHERE job_id IN (SELECT job_id FROM jobs WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006'))))
GO
ALTER TABLE payroll_batch_lines ENABLE TRIGGER del_payroll_batch_line
GO


ALTER TABLE payroll_batches DISABLE TRIGGER del_batch
GO
DELETE FROM payroll_batches 
  WHERE int_batch_id IN (SELECT int_batch_id FROM payroll_batch_lines 
                          WHERE service_line_id IN (SELECT service_line_id FROM service_lines 
                                                     WHERE tc_job_id IN (SELECT job_id FROM jobs WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006'))))                                                
GO
DELETE FROM payroll_batches 
  WHERE int_batch_id IN (SELECT int_batch_id FROM payroll_batch_lines 
                          WHERE service_line_id IN (SELECT service_line_id FROM service_lines 
                                                     WHERE bill_job_id IN (SELECT job_id FROM jobs WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006'))))
GO
DELETE FROM payroll_batches 
  WHERE int_batch_id IN (SELECT int_batch_id FROM payroll_batch_lines 
                          WHERE service_line_id IN (SELECT service_line_id FROM service_lines 
                                                     WHERE tc_service_id IN (SELECT service_id FROM services WHERE job_id IN (SELECT job_id FROM jobs WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006')) OR request_id IN (SELECT request_id FROM requests WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006')))))
GO
DELETE FROM payroll_batches 
  WHERE int_batch_id IN (SELECT int_batch_id FROM payroll_batch_lines 
                          WHERE service_line_id IN (SELECT service_line_id FROM service_lines 
                                                     WHERE bill_service_id IN (SELECT service_id FROM services WHERE job_id IN (SELECT job_id FROM jobs WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006')) OR request_id IN (SELECT request_id FROM requests WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006')))))
GO
DELETE FROM payroll_batches 
  WHERE int_batch_id IN (SELECT int_batch_id FROM payroll_batch_lines 
                          WHERE service_line_id IN (SELECT service_line_id FROM service_lines 
                                                     WHERE invoice_id IN (SELECT invoice_id FROM invoices WHERE job_id IN (SELECT job_id FROM jobs WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006')))))
GO
ALTER TABLE payroll_batches ENABLE TRIGGER del_batch
GO


ALTER TABLE service_lines DISABLE TRIGGER ud_ph_trig
GO
ALTER INDEX ix_service_lines_ext_id ON service_lines DISABLE
GO
ALTER INDEX ix_sl_bill ON service_lines DISABLE
GO
ALTER INDEX ix_sl_bill_services ON service_lines DISABLE
GO
ALTER INDEX ix_sl_invoices ON service_lines DISABLE
GO
ALTER INDEX ix_sl_items ON service_lines DISABLE
GO
ALTER INDEX ix_sl_resources ON service_lines DISABLE
GO
ALTER INDEX ix_sl_services ON service_lines DISABLE
GO
ALTER INDEX ix_sl_tcjobid_phsid ON service_lines DISABLE
GO

DELETE FROM service_lines 
 WHERE tc_job_id IN (SELECT job_id FROM jobs WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006'))
GO
DELETE FROM service_lines 
 WHERE bill_job_id IN (SELECT job_id FROM jobs WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006'))
GO
DELETE FROM service_lines 
 WHERE tc_service_id IN (SELECT service_id FROM services WHERE job_id IN (SELECT job_id FROM jobs WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006')) OR request_id IN (SELECT request_id FROM requests WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006')))
GO
DELETE FROM service_lines 
 WHERE bill_service_id IN (SELECT service_id FROM services WHERE job_id IN (SELECT job_id FROM jobs WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006')) OR request_id IN (SELECT request_id FROM requests WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006')))
GO

DELETE FROM service_lines 
 WHERE ph_service_id IN (SELECT service_id FROM services WHERE job_id IN (SELECT job_id FROM jobs WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006')) OR request_id IN (SELECT request_id FROM requests WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006')))
GO

DELETE FROM service_lines 
 WHERE invoice_id IN (SELECT invoice_id FROM invoices WHERE job_id IN (SELECT job_id FROM jobs WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006')))
GO

ALTER INDEX ix_service_lines_ext_id ON service_lines REBUILD
GO
ALTER INDEX ix_sl_bill ON service_lines REBUILD
GO
ALTER INDEX ix_sl_bill_services ON service_lines REBUILD
GO
ALTER INDEX ix_sl_invoices ON service_lines REBUILD
GO
ALTER INDEX ix_sl_items ON service_lines REBUILD
GO
ALTER INDEX ix_sl_resources ON service_lines REBUILD
GO
ALTER INDEX ix_sl_services ON service_lines REBUILD
GO
ALTER INDEX ix_sl_tcjobid_phsid ON service_lines REBUILD
GO
ALTER TABLE service_lines ENABLE TRIGGER ud_ph_trig
GO


/* invoices */
ALTER TABLE invoices DISABLE TRIGGER del_unassign_lines
GO
ALTER INDEX ix_i_batch_status ON invoices DISABLE
GO
ALTER INDEX ix_i_jobs ON invoices DISABLE
GO
ALTER INDEX ix_i_status ON invoices DISABLE
GO
DELETE FROM invoices WHERE job_id IN (SELECT job_id FROM jobs WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006'))
GO
ALTER INDEX ix_i_batch_status ON invoices REBUILD
GO
ALTER INDEX ix_i_jobs ON invoices REBUILD
GO
ALTER INDEX ix_i_status ON invoices REBUILD
GO
ALTER TABLE invoices ENABLE TRIGGER del_unassign_lines
GO


ALTER TABLE job_distributions DISABLE TRIGGER del_job_distributions
GO
ALTER INDEX ix_jd_users ON job_distributions DISABLE
GO
ALTER INDEX ix_jd_jobs ON job_distributions DISABLE
GO
DELETE FROM job_distributions WHERE job_id IN (SELECT job_id FROM jobs WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006'))
GO
ALTER INDEX ix_jd_users ON job_distributions REBUILD
GO
ALTER INDEX ix_jd_jobs ON job_distributions REBUILD
GO
ALTER TABLE job_distributions ENABLE TRIGGER del_job_distributions
GO


ALTER INDEX ix_jir_items ON job_item_rates DISABLE
GO
ALTER INDEX ix_jir_job_items ON job_item_rates DISABLE
GO
ALTER INDEX jir_ext_rate_id ON job_item_rates DISABLE
GO
DELETE FROM job_item_rates WHERE job_id IN (SELECT job_id FROM jobs WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2005'))
GO
DELETE FROM job_item_rates WHERE job_id IN (SELECT job_id FROM jobs WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '6/1/2005'))
GO
DELETE FROM job_item_rates WHERE job_id IN (SELECT job_id FROM jobs WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '8/15/2005'))
GO
DELETE FROM job_item_rates WHERE job_id IN (SELECT job_id FROM jobs WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '10/1/2005'))
GO
DELETE FROM job_item_rates WHERE job_id IN (SELECT job_id FROM jobs WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '11/1/2005'))
GO
DELETE FROM job_item_rates WHERE job_id IN (SELECT job_id FROM jobs WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '12/1/2005'))
GO
DELETE FROM job_item_rates WHERE job_id IN (SELECT job_id FROM jobs WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006'))
GO
DELETE FROM job_item_rates WHERE job_id IN (SELECT job_id FROM jobs WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '2/1/2006'))
GO
DELETE FROM job_item_rates WHERE job_id IN (SELECT job_id FROM jobs WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '3/15/2006'))
GO
DELETE FROM job_item_rates WHERE job_id IN (SELECT job_id FROM jobs WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '4/1/2006'))
GO
DELETE FROM job_item_rates WHERE job_id IN (SELECT job_id FROM jobs WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '5/1/2006'))
GO
DELETE FROM job_item_rates WHERE job_id IN (SELECT job_id FROM jobs WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '6/1/2006'))
GO
DELETE FROM job_item_rates WHERE job_id IN (SELECT job_id FROM jobs WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '7/1/2006'))
GO
DELETE FROM job_item_rates WHERE job_id IN (SELECT job_id FROM jobs WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '8/1/2006'))
GO
DELETE FROM job_item_rates WHERE job_id IN (SELECT job_id FROM jobs WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '9/15/2006'))
GO
DELETE FROM job_item_rates WHERE job_id IN (SELECT job_id FROM jobs WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '10/1/2006'))
GO
DELETE FROM job_item_rates WHERE job_id IN (SELECT job_id FROM jobs WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '11/1/2006'))
GO
DELETE FROM job_item_rates WHERE job_id IN (SELECT job_id FROM jobs WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '12/1/2006'))
GO
DELETE FROM job_item_rates WHERE job_id IN (SELECT job_id FROM jobs WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006'))
GO
ALTER INDEX ix_jir_items ON job_item_rates REBUILD
GO
ALTER INDEX ix_jir_job_items ON job_item_rates REBUILD
GO
ALTER INDEX jir_ext_rate_id ON job_item_rates REBUILD
GO


DELETE FROM pda_roster_changes WHERE job_id IN (SELECT job_id FROM jobs WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006'))
GO


ALTER INDEX idx_job_no ON unbilled_report_dailydatacapture DISABLE
GO
ALTER INDEX ix_billinguserid ON unbilled_report_dailydatacapture DISABLE
GO
ALTER INDEX ix_customer_name ON unbilled_report_dailydatacapture DISABLE
GO
ALTER INDEX ix_datereportrun ON unbilled_report_dailydatacapture DISABLE
GO
ALTER INDEX ix_ext_dealer_id ON unbilled_report_dailydatacapture DISABLE
GO
ALTER INDEX ix_orgid ON unbilled_report_dailydatacapture DISABLE
GO
ALTER INDEX ix_orgid_custname_daterun ON unbilled_report_dailydatacapture DISABLE
GO
DELETE FROM unbilled_report_dailydatacapture WHERE bill_job_id IN (SELECT job_id FROM jobs WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006'))
GO
ALTER INDEX idx_job_no ON unbilled_report_dailydatacapture REBUILD
GO
ALTER INDEX ix_billinguserid ON unbilled_report_dailydatacapture REBUILD
GO
ALTER INDEX ix_customer_name ON unbilled_report_dailydatacapture REBUILD
GO
ALTER INDEX ix_datereportrun ON unbilled_report_dailydatacapture REBUILD
GO
ALTER INDEX ix_ext_dealer_id ON unbilled_report_dailydatacapture REBUILD
GO
ALTER INDEX ix_orgid ON unbilled_report_dailydatacapture REBUILD
GO
ALTER INDEX ix_orgid_custname_daterun ON unbilled_report_dailydatacapture REBUILD
GO


ALTER INDEX ix_tracking_jobs ON tracking DISABLE
GO
ALTER INDEX ix_tracking_services ON tracking DISABLE
GO
DELETE FROM tracking WHERE job_id IN (SELECT job_id FROM jobs WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006'))
                        OR service_id IN (SELECT service_id FROM services WHERE job_id IN (SELECT job_id FROM jobs WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006')) OR request_id IN (SELECT request_id FROM requests WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006')))
GO
ALTER INDEX ix_tracking_jobs ON tracking REBUILD
GO
ALTER INDEX ix_tracking_services ON tracking REBUILD
GO


DELETE FROM resource_estimates WHERE job_id IN (SELECT job_id FROM jobs WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006'))
                                  OR service_id IN (SELECT service_id FROM services WHERE job_id IN (SELECT job_id FROM jobs WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006')) OR request_id IN (SELECT request_id FROM requests WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006')))
GO


DELETE FROM sch_resources WHERE job_id IN (SELECT job_id FROM jobs WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006'))
                             OR service_id IN (SELECT service_id FROM services WHERE job_id IN (SELECT job_id FROM jobs WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006')) OR request_id IN (SELECT request_id FROM requests WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006')))
GO

DELETE FROM pooled_hours_calc WHERE service_id IN (SELECT service_id FROM services WHERE job_id IN (SELECT job_id FROM jobs WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006')) OR request_id IN (SELECT request_id FROM requests WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006')))
GO

DELETE FROM service_tasks WHERE service_id IN (SELECT service_id FROM services WHERE job_id IN (SELECT job_id FROM jobs WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006')) OR request_id IN (SELECT request_id FROM requests WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006')))
GO

DELETE FROM custom_cols 
 WHERE service_id IN (SELECT service_id FROM services 
                       WHERE job_id IN (SELECT job_id FROM jobs WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006'))                    
                          OR request_id IN (SELECT request_id FROM requests WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006')))
GO
DELETE FROM custom_cols 
 WHERE request_id IN (SELECT request_id FROM requests WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006'))
GO

/* services */
DELETE FROM services 
 WHERE job_id IN (SELECT job_id FROM jobs WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006'))
GO
DELETE FROM services 
 WHERE request_id IN (SELECT request_id FROM requests WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006'))
GO


DELETE FROM quote_conditions WHERE quote_id IN (SELECT quote_id FROM quotes WHERE request_id IN (SELECT request_id FROM requests WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006')))
GO
DELETE FROM quotes WHERE request_id IN (SELECT request_id FROM requests WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006'))
GO
DELETE FROM request_documents WHERE request_id IN (SELECT request_id FROM requests WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006'))
GO
DELETE FROM request_vendors WHERE request_id IN (SELECT request_id FROM requests WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006'))
GO
DELETE FROM project_notes WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006')
GO
DELETE FROM punchlist_issues 
 WHERE punchlist_id IN (SELECT punchlist_id FROM punchlists 
                         WHERE request_id IN (SELECT request_id FROM requests WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006')))
GO
DELETE FROM punchlists WHERE request_id IN (SELECT request_id FROM requests WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006'))
GO
DELETE FROM documents WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006')
GO

/* jobs */
ALTER INDEX ix_job_billing_users ON jobs DISABLE
GO
ALTER INDEX ix_job_customers ON jobs DISABLE
GO
ALTER INDEX ix_job_types ON jobs DISABLE
GO
DELETE FROM jobs WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006')
GO
ALTER INDEX ix_job_billing_users ON jobs REBUILD
GO
ALTER INDEX ix_job_customers ON jobs REBUILD
GO
ALTER INDEX ix_job_types ON jobs REBUILD
GO

/* requests */
ALTER INDEX ix_request_qr ON requests DISABLE
GO
ALTER INDEX ix_request_types ON requests DISABLE
GO
ALTER INDEX ix_request_version_no ON requests DISABLE
GO
ALTER INDEX ix_requests_jlc ON requests DISABLE
GO
ALTER INDEX ix_requests_no ON requests DISABLE
GO
ALTER INDEX ncx_product_request_version ON requests DISABLE
GO
DELETE FROM requests 
 WHERE quote_request_id IN (SELECT request_id FROM requests WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006'))
GO
DELETE FROM requests WHERE project_id IN (SELECT project_id FROM projects WHERE date_created < '1/1/2006')
GO
ALTER INDEX ix_request_qr ON requests REBUILD
GO
ALTER INDEX ix_request_types ON requests REBUILD
GO
ALTER INDEX ix_request_version_no ON requests REBUILD
GO
ALTER INDEX ix_requests_jlc ON requests REBUILD
GO
ALTER INDEX ix_requests_no ON requests REBUILD
GO
ALTER INDEX ncx_product_request_version ON requests REBUILD
GO

/* projects */
ALTER INDEX ix_project_customers ON projects DISABLE
GO
ALTER INDEX ix_project_end_user ON projects DISABLE
GO
ALTER INDEX ix_project_p_eu ON projects DISABLE
GO
ALTER INDEX ix_project_status_type_id ON projects DISABLE
GO
ALTER INDEX ix_projects_no ON projects DISABLE
GO
DELETE FROM projects WHERE date_created < '1/1/2006'
GO
ALTER INDEX ix_project_customers ON projects REBUILD
GO
ALTER INDEX ix_project_end_user ON projects REBUILD
GO
ALTER INDEX ix_project_p_eu ON projects REBUILD
GO
ALTER INDEX ix_project_status_type_id ON projects REBUILD
GO
ALTER INDEX ix_projects_no ON projects REBUILD
GO