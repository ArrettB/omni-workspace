alter table users alter column password varchar(100);

create table users_bak
as 
select * 
  from users;