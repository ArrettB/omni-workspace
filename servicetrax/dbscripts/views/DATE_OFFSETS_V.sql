
CREATE VIEW dbo.DATE_OFFSETS_V
AS
SELECT    cast( (cast(datepart(mm,getDATE()) as varchar(2))+'/'+cast(datepart(dd,getDATE()) as varchar(2))+'/'+cast(datepart(yyyy,getDATE()) as varchar(4))) as datetime) todays_date,
1 AS tomorrows_offset, - 1 AS yesterdays_offset, 6 - DATEPART(dw, GETDATE()) AS fridays_offset, 7 - DATEPART(dw, GETDATE()) AS saturdays_offset, 
                      (CASE (8 - DATEPART(dw, GETDATE())) WHEN 7 THEN 0 ELSE (8 - DATEPART(dw, GETDATE())) END) AS sundays_offset, 6 - DATEPART(dw, GETDATE()) 
                      - 7 AS last_fridays_offset, 7 - DATEPART(dw, GETDATE()) - 7 AS last_saturdays_offset, (CASE (8 - DATEPART(dw, GETDATE())) 
                      WHEN 7 THEN 0 ELSE (8 - DATEPART(dw, GETDATE())) END) - 7 AS last_sundays_offset,Datepart(wk, GETDATE() ) % 2 even_odd_week






