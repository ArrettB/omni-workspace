

CREATE VIEW dbo.QUICK_REQUEST_VENDORS_HELPER_V as
SELECT     REQUEST_ID, COUNT(REQUEST_VENDOR_ID) AS VENDOR_COUNT, MIN(SCH_START_DATE) AS MIN_SCH_START_DATE, MIN(ACT_START_DATE) 
                      AS MIN_ACT_START_DATE, MAX(SCH_START_DATE) AS MAX_SCH_START_DATE, MAX(ACT_END_DATE) AS MAX_ACT_END_DATE, 
                      ISNULL(COUNT(CASE WHEN COMPLETE_FLAG = 'y' THEN 1 ELSE 0 END),0) AS VENDOR_COMPLETE_COUNT, 
                      ISNULL(COUNT(CASE WHEN invoiced_FLAG = 'y' THEN 1 ELSE 0 END),0) AS VENDOR_INVOICED_COUNT
FROM         dbo.REQUEST_VENDORS
GROUP BY REQUEST_ID


