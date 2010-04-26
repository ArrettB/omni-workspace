CREATE PROCEDURE sp_update_furniture_line_types
AS
BEGIN

DECLARE @l_id numeric(18,0)
DECLARE @lt_id numeric(18,0)
DECLARE @new_name varchar(100)
DECLARE @sequence_no numeric(18,0)
DECLARE @c1 CURSOR

SET @c1 = CURSOR FAST_FORWARD
FOR
SELECT 'Allsteel 8000' name 
UNION
SELECT 'Allsteel Align' name
UNION
SELECT 'Allsteel Reach' name
UNION
SELECT 'Allsteel Concensys' name 
UNION
SELECT 'Allsteel Terrace 2.6' name
UNION
SELECT 'Allsteel Terrace 3.4' name
UNION
SELECT 'Global Evolve' name
UNION
SELECT 'Haworth Compose' name
UNION
SELECT 'Haworth Enhanced Premise' name
UNION
SELECT 'Haworth Original Premise' name
UNION
SELECT 'Haworth Places' name
UNION
SELECT 'Haworth Premise Stackable Original' name
UNION
SELECT 'Haworth Race' name
UNION
SELECT 'Haworth Unigroup' name
UNION
SELECT 'Haworth Unigroup Too' name
UNION
SELECT 'Herman Miller "Q" Original' name
UNION
SELECT 'Herman Miller Ethospace' name
UNION
SELECT 'Herman Miller Vivo' name
UNION
SELECT 'HMI MyStudio' name
UNION
SELECT 'HMI Prospects' name
UNION
SELECT 'HMI Series 1' name
UNION
SELECT 'HMI Series 2 (Encore)' name
UNION
SELECT 'HON Initiate' name
UNION
SELECT 'Inscape Platform' name
UNION
SELECT 'KI Wireworks' name
UNION
SELECT 'Kimball Cetra' name
UNION
SELECT 'Kimball Interworks' name
UNION
SELECT 'Kimball TRAXX' name
UNION
SELECT 'Kimball Xsite' name
UNION
SELECT 'Knoll AutoStrada 1 & 2' name
UNION
SELECT 'Knoll Dividends - Monolithic' name
UNION
SELECT 'Knoll Equity' name
UNION
SELECT 'Knoll Morrison' name
UNION
SELECT 'Knoll Reff - Monolithic' name
UNION
SELECT 'Maispace' name
UNION
SELECT 'SMED Legs' name
UNION
SELECT 'Steelcase 9000' name
UNION
SELECT 'Steelcase Answers' name
UNION
SELECT 'Steelcase Avenir 0' name
UNION
SELECT 'Steelcase  Kick' name
UNION
SELECT 'Steelcase Context' name
UNION
SELECT 'Steelcase Montage' name
UNION
SELECT 'Steelcase Pathways' name
UNION
SELECT 'Teknion  Boulevard' name
UNION
SELECT 'Teknion TOS' name 
UNION
SELECT 'Teknion  Leverage'  name
UNION
SELECT 'Teknion Transit'  name
UNION
SELECT 'Trendway Contrada'  name
ORDER BY name
   
SET @sequence_no = 10 

SET @lt_id = (SELECT lookup_type_id FROM lookup_types WHERE code='furniture_line_type')
 
UPDATE lookups SET sequence_no = @sequence_no, active_flag='Y', attribute2 = 'system'
  FROM lookups l INNER JOIN
       lookup_types lt ON l.lookup_type_id = lt.lookup_type_id
 WHERE lt.code = 'furniture_line_type' 
   AND l.attribute2 = 'system'
   AND l.name = 'Allsteel 8000'

UPDATE lookups 
   SET active_flag='Y', attribute2 = 'system',
       code = 'allsteel_concensys', name = 'Allsteel Concensys'         
  FROM lookups l INNER JOIN
       lookup_types lt ON l.lookup_type_id = lt.lookup_type_id
 WHERE lt.code = 'furniture_line_type' 
   AND l.attribute2 = 'system'
   AND l.code = 'allsteel_consensys'
   
UPDATE lookups 
   SET active_flag='Y', attribute2 = 'system',
       code = 'herman_miller_ethospace', name = 'Herman Miller Ethospace'         
  FROM lookups l INNER JOIN
       lookup_types lt ON l.lookup_type_id = lt.lookup_type_id
 WHERE lt.code = 'furniture_line_type' 
   AND l.attribute2 = 'system'
   AND l.code = 'herman_miller_etho-space'
   
UPDATE lookups 
   SET active_flag='Y', attribute2 = 'system',
       code = 'steelcase_answers', name = 'Steelcase Answers'         
  FROM lookups l INNER JOIN
       lookup_types lt ON l.lookup_type_id = lt.lookup_type_id
 WHERE lt.code = 'furniture_line_type' 
   AND l.attribute2 = 'system'
   AND l.code = 'steelcase_answer'
   
UPDATE lookups 
   SET active_flag='Y', attribute2 = 'system',
       name = 'Steelcase Avenir 0'         
  FROM lookups l INNER JOIN
       lookup_types lt ON l.lookup_type_id = lt.lookup_type_id
 WHERE lt.code = 'furniture_line_type' 
   AND l.attribute2 = 'system'
   AND l.code = 'steelcase_avenir'
   
UPDATE lookups 
   SET active_flag='Y', attribute2 = 'system',
       name = 'Steelcase  Kick'         
  FROM lookups l INNER JOIN
       lookup_types lt ON l.lookup_type_id = lt.lookup_type_id
 WHERE lt.code = 'furniture_line_type' 
   AND l.attribute2 = 'system'
   AND l.code = 'steelcase-kick'
   
UPDATE lookups 
   SET active_flag='Y', attribute2 = 'system',
       name = 'Trendway Contrada'         
  FROM lookups l INNER JOIN
       lookup_types lt ON l.lookup_type_id = lt.lookup_type_id
 WHERE lt.code = 'furniture_line_type' 
   AND l.attribute2 = 'system'
   AND l.code = 'trendway'
   
UPDATE lookups 
   SET sequence_no=5  
  FROM lookups l INNER JOIN
       lookup_types lt ON l.lookup_type_id = lt.lookup_type_id
 WHERE lt.code = 'furniture_line_type' 
   AND l.attribute2 = 'system'
   AND l. code = 'n_a' 
   
UPDATE lookups SET active_flag = 'N', date_modified=getdate(), modified_by=1
 WHERE lookup_type_id=@lt_id
   AND attribute2 = 'system'
   AND name NOT IN (
'Allsteel 8000',
'Allsteel Align',
'Allsteel Reach',
'Allsteel Concensys',
'Allsteel Terrace 2.6',
'Allsteel Terrace 3.4',
'Global Evolve',
'Haworth Compose',
'Haworth Enhanced Premise',
'Haworth Original Premise',
'Haworth Places',
'Haworth Premise Stackable Original',
'Haworth Race',
'Haworth Unigroup',
'Haworth Unigroup Too',
'Herman Miller "Q" Original',
'Herman Miller Ethospace',
'Herman Miller Vivo',
'HMI MyStudio',
'HMI Prospects',
'HMI Series 1',
'HMI Series 2 (Encore)',
'HON Initiate',
'Inscape Platform',
'KI Wireworks',
'Kimball Cetra',
'Kimball Interworks',
'Kimball TRAXX',
'Kimball Xsite',
'Knoll AutoStrada 1 & 2',
'Knoll Dividends - Monolithic',
'Knoll Equity',
'Knoll Morrison',
'Knoll Reff - Monolithic',
'Maispace',
'SMED Legs',
'Steelcase 9000',
'Steelcase Answers',
'Steelcase Avenir 0',
'Steelcase  Kick',
'Steelcase Context',
'Steelcase Montage',
'Steelcase Pathways',
'Teknion  Boulevard',
'Teknion TOS', 
'Teknion  Leverage',
'Teknion Transit',
'Trendway Contrada',
'N/A')
   
   
OPEN @c1
FETCH NEXT FROM @c1 INTO @new_name

WHILE @@FETCH_STATUS=0
BEGIN
  PRINT @new_name

  SET @l_id 
  = (SELECT l.lookup_id
       FROM lookups l INNER JOIN
  	    lookup_types lt ON l.lookup_type_id = lt.lookup_type_id
      WHERE lt.code = 'furniture_line_type' 
        AND l.attribute2 = 'system'
        AND l.name = @new_name)
        
  IF @l_id IS NULL
    BEGIN
      INSERT INTO lookups (lookup_type_id,code,name,sequence_no,active_flag,updatable_flag,attribute2,date_created,created_by)
      VALUES (@lt_id, SUBSTRING(REPLACE(REPLACE(LOWER(@new_name), '  ', ' '), ' ', '_'),0,30), @new_name, @sequence_no, 'Y', 'Y', 'system',getdate(), 1)
    END
  ELSE 
    BEGIN
      UPDATE lookups SET active_flag='Y',sequence_no=@sequence_no WHERE lookup_id=@l_id AND lookup_type_id=@lt_id
    END

    
  SET @sequence_no = @sequence_no + 10 
  SET @l_id = NULL

  FETCH NEXT FROM @c1 INTO @new_name
END

CLOSE @c1
DEALLOCATE @c1

END
GO

EXECUTE sp_update_furniture_line_types
GO

DROP PROCEDURE sp_update_furniture_line_types
GO