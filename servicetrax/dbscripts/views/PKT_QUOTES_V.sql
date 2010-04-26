

CREATE VIEW dbo.PKT_QUOTES_V
AS
SELECT     dbo.QUOTES_V.QUOTE_ID, dbo.SERVICES.SERVICE_ID, dbo.REQUESTS.REQUEST_ID, dbo.QUOTES_V.QUOTE_NO, dbo.QUOTES_V.quote_type_name,
                       dbo.QUOTES_V.duration_name, dbo.QUOTES_V.DURATION_QTY, reg.NAME AS regular_name, weekend.NAME AS evenings_name, 
                      evening.NAME AS weekends_name, dbo.CONTACTS.CONTACT_NAME AS furniture
FROM         dbo.REQUESTS LEFT OUTER JOIN
                      dbo.QUOTES_V ON dbo.REQUESTS.REQUEST_ID = dbo.QUOTES_V.REQUEST_ID LEFT OUTER JOIN
                      dbo.CONTACTS ON dbo.REQUESTS.FURNITURE1_CONTACT_ID = dbo.CONTACTS.CONTACT_ID LEFT OUTER JOIN
                      dbo.LOOKUPS reg ON dbo.REQUESTS.REGULAR_HOURS_TYPE_ID = reg.LOOKUP_ID LEFT OUTER JOIN
                      dbo.LOOKUPS evening ON dbo.REQUESTS.EVENING_HOURS_TYPE_ID = evening.LOOKUP_ID LEFT OUTER JOIN
                      dbo.LOOKUPS weekend ON dbo.REQUESTS.WEEKEND_HOURS_TYPE_ID = weekend.LOOKUP_ID FULL OUTER JOIN
                      dbo.SERVICES ON dbo.REQUESTS.REQUEST_ID = dbo.SERVICES.REQUEST_ID



