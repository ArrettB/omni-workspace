
INSERT INTO templates
(template_name)
VALUES
('rep/job_item_costs.html')
go

INSERT INTO template_locations
(location, level_1_template)
(SELECT 'job_item_costs', t.template_id
FROM templates t
WHERE t.template_name = 'rep/job_item_costs.html')
go

INSERT INTO functions
(function_group_id, template_id, name, code, description, template_location_id, is_nav_function, is_menu_function, date_created, created_by)
(SELECT fg.function_group_id, t.template_id, 'Job Item Costs By Date', 'rep/job_item_costs.html', '', tl.template_location_id, 'N', 'Y', getdate(), 1
FROM function_groups fg, templates t, template_locations tl
WHERE fg.code = 'rep'
AND t.template_name = 'rep/job_item_costs.html'
AND tl.location = 'job_item_costs')
go

UPDATE function_right_types
SET updatable_flag = 'N'
WHERE function_right_type_id in
(
	SELECT function_right_type_id
	FROM function_right_types frt inner join functions f on f.FUNCTION_ID = frt.FUNCTION_ID
	AND f.CODE = 'rep/job_item_costs.html'
	INNER JOIN right_types rt on frt.RIGHT_TYPE_ID = rt.RIGHT_TYPE_ID and rt.CODE != 'view'
)
go


