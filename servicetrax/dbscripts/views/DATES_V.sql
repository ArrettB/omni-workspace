
CREATE VIEW dbo.DATES_V
AS
SELECT      todays_date AS today,  (todays_date + tomorrows_offset) AS tomorrow, (todays_date + yesterdays_offset) AS yesterday, DATEADD(hh,16,(todays_date + fridays_offset)) AS this_friday, 
(todays_date + saturdays_offset) AS this_saturday, (todays_date + sundays_offset) AS this_sunday, DATEADD(hh,16,(todays_date + last_fridays_offset)) AS last_friday, 
(todays_date + last_saturdays_offset) AS last_saturday, (todays_date + last_sundays_offset) AS last_sunday, 
(case even_odd_week when 1 then 'Rotation B' else 'Rotation A' end) cur_rotation
FROM         dbo.DATE_OFFSETS_V






