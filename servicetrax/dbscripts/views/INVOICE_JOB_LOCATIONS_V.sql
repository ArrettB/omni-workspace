CREATE VIEW dbo.Invoice_Job_Locations_v
AS
SELECT     *, '' AS Addr1, '' AS Addr2, '' AS Addr3, '' AS City, '' AS State, '' AS Zip
FROM         dbo.INVOICES

