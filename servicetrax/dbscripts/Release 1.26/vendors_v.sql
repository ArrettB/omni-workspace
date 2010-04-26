DROP VIEW vendors_v
GO

CREATE VIEW vendors_v 
AS
SELECT o.organization_id, tmp.ext_vendor_id, tmp.vendor_name
  FROM organizations o INNER JOIN
       (SELECT RTRIM(vendorid) ext_vendor_id, RTRIM(vendname) vendor_name, 'Minneapolis' org_name
          FROM ambim.dbo.pm00200
         WHERE vendstts <> 2 AND vendorid NOT LIKE 'old%'
       UNION
        SELECT RTRIM(vendorid) ext_vendor_id, RTRIM(vendname) vendor_name, 'Wisconsin' org_name
          FROM ammad.dbo.pm00200
         WHERE vendstts <> 2 AND vendorid NOT LIKE 'old%'
       UNION
        SELECT RTRIM(vendorid) ext_vendor_id, RTRIM(vendname) vendor_name, 'Georgia' org_name
          FROM aia.dbo.pm00200
         WHERE vendstts <> 2 AND vendorid NOT LIKE 'old%'
       UNION
        SELECT RTRIM(vendorid) ext_vendor_id, RTRIM(vendname) vendor_name, 'Milwaukee' org_name
          FROM ciinc.dbo.pm00200
         WHERE vendstts <> 2 AND vendorid NOT LIKE 'old%'
       UNION
        SELECT RTRIM(vendorid) ext_vendor_id, RTRIM(vendname) vendor_name, 'Illinois' org_name
          FROM cillc.dbo.pm00200
         WHERE vendstts <> 2 AND vendorid NOT LIKE 'old%'
       UNION
        SELECT RTRIM(vendorid) ext_vendor_id, RTRIM(vendname) vendor_name, 'ICS' org_name
          FROM ics.dbo.pm00200
         WHERE vendstts <> 2 AND vendorid NOT LIKE 'old%'
       UNION
        SELECT RTRIM(vendorid) ext_vendor_id, RTRIM(vendname) vendor_name, 'Plymouth' org_name
          FROM cimn.dbo.pm00200
         WHERE vendstts <> 2 AND vendorid NOT LIKE 'old%'
       UNION
        SELECT RTRIM(vendorid) ext_vendor_id, RTRIM(vendname) vendor_name, 'National Services' org_name
          FROM ntlsv.dbo.pm00200
         WHERE vendstts <> 2 AND vendorid NOT LIKE 'old%'
        ) tmp ON o.name = tmp.org_name
GO