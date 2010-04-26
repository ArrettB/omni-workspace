


CREATE VIEW dbo.PKT_CONTACTS_V
AS
SELECT     customer.CONTACT_NAME AS customer_name, customer.PHONE_CELL AS customer_cell, customer.PHONE_WORK AS customer_work, 
                      dealer_sr.CONTACT_NAME AS dealer_sr_name, dealer_sr.PHONE_CELL AS dealer_sr_cell, dealer_sr.PHONE_WORK AS dealer_sr_work, 
                      dealer_ss.CONTACT_NAME AS dealer_ss_name, dealer_ss.PHONE_CELL AS dealer_ss_cell, dealer_ss.PHONE_WORK AS dealer_ss_work, 
                      am.CONTACT_NAME AS am_name, am.PHONE_CELL AS am_cell, am.PHONE_WORK AS am_work, approver.CONTACT_NAME AS approver_name, 
                      approver.PHONE_CELL AS approver_cell, approver.PHONE_WORK AS approver_work, dbo.SERVICES.SERVICE_ID
FROM         dbo.REQUESTS LEFT OUTER JOIN
                      dbo.SERVICES ON dbo.REQUESTS.REQUEST_ID = dbo.SERVICES.REQUEST_ID LEFT OUTER JOIN
                      dbo.CONTACTS approver ON dbo.REQUESTS.A_M_CONTACT_ID = approver.CONTACT_ID LEFT OUTER JOIN
                      dbo.CONTACTS dealer_ss ON ISNULL(dbo.REQUESTS.D_SALES_SUP_CONTACT_ID, dbo.SERVICES.SUPPORT_CONTACT_ID) 
                      = dealer_ss.CONTACT_ID LEFT OUTER JOIN
                      dbo.CONTACTS am ON dbo.REQUESTS.A_M_CONTACT_ID = am.CONTACT_ID LEFT OUTER JOIN
                      dbo.CONTACTS dealer_sr ON ISNULL(dbo.REQUESTS.D_SALES_REP_CONTACT_ID, dbo.SERVICES.SALES_CONTACT_ID) 
                      = dealer_sr.CONTACT_ID LEFT OUTER JOIN
                      dbo.CONTACTS customer ON ISNULL(dbo.REQUESTS.CUSTOMER_CONTACT_ID, dbo.SERVICES.CUSTOMER_CONTACT_ID) = customer.CONTACT_ID



