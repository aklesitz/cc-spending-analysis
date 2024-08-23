-- Insert transaction data from all accounts
CREATE TABLE transactions_staging (
	trans_id NUMERIC,
	account_name VARCHAR(255),
	transaction_date DATE,
	amount NUMERIC,
	description TEXT,
	orig_category VARCHAR(255),
	category VARCHAR(255)
);

INSERT INTO transactions_staging (trans_id, account_name, transaction_date, amount, description, orig_category, category)
	SELECT DISTINCT
		a.trans_id,
		a.account,
		a.date,
		a.amount,
		a.description,
		a.category,
		c.category
	FROM all_accounts a
	LEFT JOIN category_mapping c
		ON a.category = c.orig_category
		AND a.description = c.description;

-- Create standardized transactions table
CREATE TABLE transactions (
	transaction_id SERIAL PRIMARY KEY,
	account_id INTEGER NOT NULL,
	date DATE NOT NULL,
	amount NUMERIC NOT NULL,
	description TEXT NOT NULL,
	category_id INTEGER NOT NULL,
	FOREIGN KEY (account_id) REFERENCES accounts (account_id),
	FOREIGN KEY (category_id) REFERENCES categories (category_id)
);
-- Inserting data from staging table to transactions table
INSERT INTO transactions (account_id, date, amount, description, category_id)
	SELECT DISTINCT
		a.account_id,
		t.transaction_date,
		t.amount,
		t.description,
		c.category_id
	FROM transactions_staging t
	JOIN accounts a 
		ON t.account_name = a.account_name
	JOIN categories c
		ON t.category = c.category;
		
SELECT * FROM transactions;
DROP TABLE transactions;