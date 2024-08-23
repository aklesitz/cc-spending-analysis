-- Create normalized categories table
CREATE TABLE categories (
	category_id SERIAL PRIMARY KEY,
	category VARCHAR(255) NOT NULL
);

-- Insert standardized categories from category_mapping table
INSERT INTO categories (category)
	SELECT DISTINCT category
	FROM category_mapping;
	


-- Insert transaction data from all accounts ****CREATING DUPLICATE RECORDS*****
CREATE TABLE transactions_staging (
	trans_id NUMERIC,
	account_name VARCHAR(255),
	transaction_date DATE,
	amount NUMERIC,
	description TEXT,
	orig_category VARCHAR(255),
	category VARCHAR(255)
);

INSERT INTO transactions_staging (trans_id, account_name, transaction_date, amount, description, orig_category)--, category)
	SELECT DISTINCT
		a.trans_id,
		a.account,
		a.date,
		a.amount,
		a.description,
		a.category
		--c.category
	FROM all_accounts a
	/*LEFT JOIN category_mapping c
		ON a.category = c.orig_category
		AND a.description = c.description*/;
		
SELECT DISTINCT account, date, amount, description, category FROM all_accounts;
-- 2668 distinct records in all_accounts

SELECT * FROM all_accounts;
-- 2684 records in all_account (not distinct)

SELECT * FROM transactions_staging;
-- 2668 records in staging table (same as distinct records)
-- There are 16 records missing from the staging table

-- Finding duplicate records in all_accounts
SELECT account, date, amount, description, category, COUNT(*)
FROM all_accounts
GROUP BY 1, 2, 3, 4, 5
HAVING COUNT(*) > 1;

SELECT * FROM all_accounts WHERE description ilike 'phoenix%'

SELECT * 
FROM all_accounts
EXCEPT
SELECT DISTINCT account, date, amount, description, category
FROM all_accounts;

-- Finding records in all_accounts not present in transactions_staging
SELECT *
FROM all_accounts a
WHERE NOT EXISTS (
	SELECT 1
	FROM transactions_staging ts
	WHERE a.account = ts.account_name
	AND a.date = ts.transaction_date
	AND a.amount = ts.amount
	AND a.description = ts.description
	AND a.category = ts.orig_category
);

DROP TABLE transactions_staging;
DROP TABLE transactions;

-- Inserting data from staging table to transactions table
INSERT INTO transactions (account_id, transaction_date, amount, description, category_id)
	SELECT
		a.account_id,
		s.transaction_date,
		s.amount,
		s.description,
		c.category_id
	FROM transactions_staging s
	JOIN accounts a 
		ON s.account_name = a.account_name
	JOIN category_mapping cm 
		ON s.orig_category = cm.orig_category
		AND s.description = cm.description
	JOIN categories c
		ON c.category = cm.orig_category;