-- Create accounts table with unique primary key for each account
CREATE TABLE accounts (
	account_id SERIAL PRIMARY KEY,
	account_name VARCHAR(255) UNIQUE NOT NULL
);

-- Populate table with distinct account names from all_accounts table
INSERT INTO accounts (account_name)
	SELECT DISTINCT account
	FROM all_accounts;
	