/*
  List of multi-org users who need to have their Works For Dealer value checked.
*/


select first_name, last_name, login, password from users where user_id in (
select u.user_id from users u inner join user_organizations uo ON u.user_id = uo.user_id
group by u.user_id
having count(u.user_id) > 1
)
AND active_flag = 'Y'
order by login
