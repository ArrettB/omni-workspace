
CREATE VIEW dbo.VAR_JOB_TIME_EXP_V
AS
SELECT     TC_JOB_ID AS job_id, ISNULL(SUM(TC_QTY * TC_RATE), 0) AS sum_time_exp, ISNULL(SUM(PAYROLL_QTY * TC_RATE), 0) AS sum_time, 
                      ISNULL(SUM(EXPENSE_QTY * TC_RATE), 0) AS sum_exp
FROM         dbo.SERVICE_LINES
WHERE     (PH_SERVICE_ID IS NULL)
GROUP BY TC_JOB_ID


