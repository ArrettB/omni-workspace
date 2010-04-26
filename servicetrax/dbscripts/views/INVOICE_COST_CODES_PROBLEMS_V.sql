CREATE VIEW dbo.INVOICE_COST_CODES_PROBLEMS_V
AS
SELECT     dbo.INVOICE_COST_CODES_V.INVOICE_ID, dbo.INVOICE_COST_CODES_V.SERVICE_ID, INVOICE_COST_CODES_V_1.SERVICE_ID AS Expr6, 
                      dbo.INVOICE_COST_CODES_V.cost_to_cust, dbo.INVOICE_COST_CODES_V.cost_to_vend, dbo.INVOICE_COST_CODES_V.cost_to_job, 
                      dbo.INVOICE_COST_CODES_V.warehouse_fee, INVOICE_COST_CODES_V_1.INVOICE_ID AS Expr1, INVOICE_COST_CODES_V_1.cost_to_cust AS Expr2,
                       INVOICE_COST_CODES_V_1.cost_to_vend AS Expr3, INVOICE_COST_CODES_V_1.cost_to_job AS Expr4, 
                      INVOICE_COST_CODES_V_1.warehouse_fee AS Expr5
FROM         dbo.INVOICE_COST_CODES_V INNER JOIN
                      dbo.INVOICE_COST_CODES_V INVOICE_COST_CODES_V_1 ON 
                      dbo.INVOICE_COST_CODES_V.SERVICE_ID <> INVOICE_COST_CODES_V_1.SERVICE_ID AND 
                      dbo.INVOICE_COST_CODES_V.INVOICE_ID = INVOICE_COST_CODES_V_1.INVOICE_ID AND 
                      dbo.INVOICE_COST_CODES_V.cost_to_cust <> INVOICE_COST_CODES_V_1.cost_to_cust

