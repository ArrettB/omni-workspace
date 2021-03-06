CREATE VIEW dbo.crystal_VAR_JOB_INVOICED_V
AS
SELECT     TOP 100 PERCENT dbo.JOBS.JOB_ID, SUM(ISNULL(dbo.INVOICE_LINES.UNIT_PRICE, 0) * ISNULL(dbo.INVOICE_LINES.QTY, 0)) AS sum_inv, 
                      MIN(CAST(dbo.INVOICES.DATE_SENT AS datetime)) AS min_date_sent, MAX(dbo.INVOICES.DATE_SENT) AS max_date_sent, 
                      dbo.INVOICES.INVOICE_ID
FROM         dbo.JOBS RIGHT OUTER JOIN
                      dbo.INVOICE_LINES RIGHT OUTER JOIN
                      dbo.INVOICES ON dbo.INVOICE_LINES.INVOICE_ID = dbo.INVOICES.INVOICE_ID ON dbo.JOBS.JOB_ID = dbo.INVOICES.JOB_ID
WHERE     (dbo.INVOICES.STATUS_ID > 3)
GROUP BY dbo.JOBS.JOB_ID, dbo.INVOICES.INVOICE_ID
HAVING      (SUM(ISNULL(dbo.INVOICE_LINES.UNIT_PRICE, 0) * ISNULL(dbo.INVOICE_LINES.QTY, 0)) > 0)
ORDER BY dbo.JOBS.JOB_ID

