
CREATE VIEW contains_invoice_tracking_v
AS
SELECT i.invoice_id, 
       CASE inv_tracking.trk WHEN '*' THEN '*' ELSE '' END AS contains_tracking
  FROM dbo.INVOICES i LEFT OUTER JOIN
       (SELECT DISTINCT invoice_id, '*' trk
          FROM invoice_tracking) inv_tracking ON i.invoice_id = inv_tracking.invoice_id

