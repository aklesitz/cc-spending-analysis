-- Create staging table to standardize categories before
-- insertion into categories table
CREATE TABLE category_mapping (
	orig_category VARCHAR(255),
	description VARCHAR(255),
	category VARCHAR(255)
);

INSERT INTO category_mapping (orig_category, description)
	SELECT category, description
	FROM all_accounts;
	
-- Standarize categories with CASE statement based off of description and orig_category
-- This can be updated with new categories or further refinements as needed to update categories table
UPDATE category_mapping
SET category = 
	CASE
		WHEN description ilike '%prime video%'
			OR orig_category ilike '%Entertainment%'
			OR orig_category ilike '%office%'
			OR orig_category ilike '%apple%'
			OR orig_category ilike '%splice%'
			OR orig_category ilike '%spotify%'
			OR orig_category ilike 'hulu'
			OR orig_category ilike 'netflix%'
			OR description ilike '%7digital%'
			OR description ilike '%tickets%'
			OR description ilike 'uber lime%'
			OR description ilike 'roku%'
				THEN 'Entertainment'
		WHEN orig_category ilike '%Pharmacies%'
			OR orig_category ilike '%health care%' AND description NOT ilike 'columbia belvedere%'
			OR description ilike 'planet fit%'
			OR description ilike '%cfm%'
				THEN 'Healthcare'
		WHEN description ilike '%petco%'
			OR description ilike '%petsmart%'
			OR description ilike 'columbia belvedere%'
				THEN 'Pet'
		WHEN orig_category ilike '%restaurant%'
			OR orig_category ilike '%groceries%'
			OR orig_category ilike 'dining'
			OR orig_category ilike 'grocery money'
			OR description ilike '%lidl%'
			OR description ilike '%publix%'
			OR description ilike '%kroger%'
			OR description ilike '%costco%'
			OR description ilike '%farmers mark%'
			OR description ilike '%your dekalb far%'
			OR description ilike 'uber eats%'
				THEN 'Food'
		WHEN description ilike '%amazon%'
			OR orig_category ilike '%retail%'
			OR orig_category ilike '%other%'
			OR orig_category ilike '%hardware%'
			OR orig_category ilike '%merchandise%'
			OR orig_category ilike '%mailing%'
			OR description ilike '%tjmaxx%'
				THEN 'Retail'
		WHEN orig_category ilike '%transportation%'
			OR orig_category ilike '%insurance%'
			OR orig_category ilike '%chevron%'
			OR orig_category ilike '%bp%'
			OR orig_category ilike '%car payment%'
			OR orig_category ilike 'gas/automotive'
			OR orig_category ilike 'gas'
			OR orig_category ilike 'gas station'
			OR orig_category ilike '%parking%'
			OR orig_category ilike 'texaco'
			OR orig_category ilike '%dmv%'
				THEN 'Gas/Automotive'
		WHEN orig_category ilike '%interest%'
			OR orig_category ilike '%equifax%'
			OR orig_category ilike '%credit%'
			OR orig_category ilike '%epayment%'
			OR orig_category ilike 'credit card payment'
			OR orig_category ilike 'cc payment'
			OR orig_category ilike '%savings%'
			OR orig_category ilike '%fraud%'
			OR orig_category ilike 'fees%'
			OR orig_category ilike 'online'
			OR orig_category ilike 'ba'
			OR orig_category ilike 'atm fees'
			OR orig_category ilike '%_payment'
			OR description ilike '%equifax%'
			OR description ilike '%savings%'
			OR description ilike '%mobile pmt%'
			OR description ilike '%online transfer%'
			OR description ilike 'ach withdrawal'
			OR description ilike 'zelle to%'
			OR description ilike '%online tax%'
				THEN 'CC Interest/Banking Fees'
		WHEN orig_category ilike 'rocket%'
			OR orig_category ilike '%income%'
			OR orig_category ilike '%tax refund%'
			OR orig_category ilike 'boa rewards'
			OR orig_category ilike '%travel reward%'
			OR orig_category ilike '%bonus check%'
			OR orig_category ilike 'escrow check'
			OR orig_category ilike 'jury duty'
			OR description ilike '%payroll%'
			OR description ilike 'zelle from%'
				THEN 'Income'
		WHEN orig_category ilike 'travel%'
			OR orig_category ilike 'lodging'
			OR orig_category ilike 'airfare'
			OR orig_category ilike 'car rental'
				THEN 'Travel'
		WHEN orig_category ilike 'ga power'
			OR orig_category ilike 'natural gas%'
			OR orig_category ilike 'mortgage%'
			OR orig_category ilike 'utilities'
			OR orig_category ilike '%contracting%'
			OR orig_category ilike 'irs%'
			OR description ilike 'xfinity%'
			OR description ilike '%hines%'
			OR description ilike '%apple%'
			OR description ilike '%gpc%'
			OR description ilike '%scana%'
			OR description ilike '%mtg pmts%'
			OR description ilike 'comcast%'
				THEN 'Utilities/Home'
		WHEN orig_category ilike 'venmo%'
			OR description ilike '%venmo%'
				THEN 'Venmo'
		ELSE NULL
END;

-- Check for any remaining null values
SELECT * FROM category_mapping WHERE category IS NULL;
