/*
 * alter the users table to have 100 character password
 */
ALTER USERS ALTER COLUMN password VARCHAR(250) NOT NULL;