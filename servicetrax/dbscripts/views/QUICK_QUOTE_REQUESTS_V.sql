

create   VIEW dbo.QUICK_QUOTE_REQUESTS_V 
as
SELECT     dbo.quick_requests_v.*, dbo.CONTACTS.CONTACT_NAME AS A_M_CONTACT_NAME, CASE WHEN EXISTS
                          (SELECT     r.request_id
                            FROM          requests r
                            WHERE      quote_request_id = quick_requests_v.request_id) THEN 'Y' ELSE 'N' END AS HAS_SERVICE_REQUEST
FROM         dbo.quick_requests_v LEFT OUTER JOIN
                      dbo.CONTACTS ON dbo.quick_requests_v.A_M_CONTACT_ID = dbo.CONTACTS.CONTACT_ID



