CREATE VIEW dbo.PUNCHLIST_ISSUES_V
AS
SELECT     dbo.PUNCHLIST_ISSUES.PUNCHLIST_ID, dbo.PUNCHLISTS_V.punchlist_no, dbo.PUNCHLISTS_V.PROJECT_ID, 
                      dbo.PUNCHLISTS_V.WALKTHROUGH_DATE, dbo.PUNCHLISTS_V.PRINT_LOCATION, dbo.PUNCHLIST_ISSUES.PUNCHLIST_ISSUE_ID, 
                      dbo.PUNCHLIST_ISSUES.STATUS_ID, dbo.PUNCHLIST_ISSUES.ISSUE_NO, dbo.PUNCHLIST_ISSUES.STATION_AREA, 
                      dbo.PUNCHLIST_ISSUES.ROOT_CAUSE_ID, dbo.PUNCHLIST_ISSUES.PROBLEM_DESC, dbo.PUNCHLIST_ISSUES.COMPLETE_DATE, 
                      dbo.PUNCHLIST_ISSUES.SOLUTION_DESC, dbo.PUNCHLIST_ISSUES.SOLUTION_DATE, dbo.PUNCHLIST_ISSUES.INSTALL_DESC, 
                      dbo.PUNCHLIST_ISSUES.INSTALL_DATE, dbo.PUNCHLIST_ISSUES.ORDER_NO, dbo.PUNCHLIST_ISSUES.SHIP_DATE, 
                      dbo.PUNCHLIST_ISSUES.DATE_CREATED AS issue_date_created, dbo.PUNCHLIST_ISSUES.CREATED_BY AS issue_created_by, 
                      dbo.PUNCHLIST_ISSUES.DATE_MODIFIED AS issue_date_modifiied, dbo.PUNCHLIST_ISSUES.MODIFIED_BY AS issue_modified_by, 
                      Cause.NAME AS root_cause_name, Cause.CODE AS root_cause_code, Status.NAME AS status_name, Status.CODE AS status_code, 
                      dbo.USERS.FIRST_NAME + ' ' + dbo.USERS.LAST_NAME AS completed_by_name, dbo.PUNCHLIST_ISSUES.SOLUTION_BY, CONVERT(varchar, 
                      dbo.PUNCHLIST_ISSUES.DATE_CREATED, 101) AS issue_date_created_nice, CONVERT(varchar, dbo.PUNCHLIST_ISSUES.SOLUTION_DATE, 101) 
                      AS solution_date_nice, CONVERT(varchar, dbo.PUNCHLIST_ISSUES.INSTALL_DATE, 101) AS install_date_nice
FROM         dbo.PUNCHLIST_ISSUES INNER JOIN
                      dbo.PUNCHLISTS_V ON dbo.PUNCHLIST_ISSUES.PUNCHLIST_ID = dbo.PUNCHLISTS_V.PUNCHLIST_ID INNER JOIN
                      dbo.LOOKUPS Status ON dbo.PUNCHLIST_ISSUES.STATUS_ID = Status.LOOKUP_ID LEFT OUTER JOIN
                      dbo.USERS ON dbo.PUNCHLIST_ISSUES.CREATED_BY = dbo.USERS.USER_ID AND 
                      dbo.PUNCHLIST_ISSUES.MODIFIED_BY = dbo.USERS.USER_ID LEFT OUTER JOIN
                      dbo.LOOKUPS Cause ON dbo.PUNCHLIST_ISSUES.ROOT_CAUSE_ID = Cause.LOOKUP_ID



