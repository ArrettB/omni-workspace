-- See http://jira.apexit.com/jira/browse/ANM-22

INSERT INTO functions
(function_group_id, template_id, name, code, description, template_location_id, is_nav_function, is_menu_function, date_created, created_by)
SELECT fg.function_group_id, NULL, 'Time Modify Date', 'time_modify_date', 'Allow users to modify the date when entering time.', NULL, 'N', 'N', getdate(), 1
FROM function_groups fg
WHERE fg.code = 'time'
go

UPDATE function_right_types
SET updatable_flag = 'N'
WHERE function_right_type_id in
(
	SELECT function_right_type_id
	FROM function_right_types frt inner join functions f on f.FUNCTION_ID = frt.FUNCTION_ID
	AND f.CODE = 'time_modify_date'
	INNER JOIN right_types rt on frt.RIGHT_TYPE_ID = rt.RIGHT_TYPE_ID and rt.CODE != 'view'
)
go