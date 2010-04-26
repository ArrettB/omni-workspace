DROP TABLE user_customer_end_users
GO

CREATE TABLE user_customer_end_users(
user_customer_end_user_id int IDENTITY(1,1) PRIMARY KEY NOT NULL,
user_customer_id NUMERIC(18,0) NOT NULL,
customer_id NUMERIC(18,0) NOT NULL
)
GO

ALTER TABLE user_customer_end_users ADD CONSTRAINT fk_uceu_user_customer_id FOREIGN KEY (user_customer_id) REFERENCES user_customers (user_customer_id)
GO

ALTER TABLE user_customer_end_users ADD CONSTRAINT fk_uceu_customer_id FOREIGN KEY (customer_id) REFERENCES customers (customer_id)
GO