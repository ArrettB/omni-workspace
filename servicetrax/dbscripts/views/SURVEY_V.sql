CREATE VIEW dbo.SURVEY_V
AS
SELECT     dbo.REQUESTS.PROJECT_ID, dbo.REQUESTS.REQUEST_ID, dbo.LOOKUPS.CODE AS request_type_code, dbo.SURVEY_TEST_V.survey_last_count, 
                      dbo.SURVEY_TEST_V.survey_frequency, dbo.SURVEY_TEST_V.sum_complete, dbo.SURVEY_TEST_V.SURVEY_LOCATION, 
                      dbo.REQUESTS.IS_SURVEYED
FROM         dbo.SURVEY_TEST_V INNER JOIN
                      dbo.REQUESTS ON dbo.SURVEY_TEST_V.PROJECT_ID = dbo.REQUESTS.PROJECT_ID LEFT OUTER JOIN
                      dbo.LOOKUPS ON dbo.REQUESTS.REQUEST_TYPE_ID = dbo.LOOKUPS.LOOKUP_ID
WHERE     (dbo.LOOKUPS.CODE = 'workorder')

