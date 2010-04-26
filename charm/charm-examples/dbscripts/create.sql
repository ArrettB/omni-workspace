CREATE TABLE cities 
(
city_id INT NOT NULL IDENTITY,
city_name VARCHAR(200) NOT NULL,
state_code VARCHAR(200)
);

CREATE TABLE states 
(
state_id INT NOT NULL IDENTITY,
state_code VARCHAR(2) NOT NULL,
state_name VARCHAR(200) NOT NULL
);

CREATE TABLE users 
(
user_id INT NOT NULL IDENTITY,
login VARCHAR(200) NOT NULL,
password VARCHAR(200) NOT NULL,
first_name VARCHAR(200) NOT NULL,
last_name VARCHAR(200) NOT NULL,
email VARCHAR(200) NOT NULL
);



SHUTDOWN;
