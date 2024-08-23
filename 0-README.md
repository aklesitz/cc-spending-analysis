# Credit Card Transaction Analysis

# Project Overview
This project analyzes credit card transactions from multiple accounts to gain insights into spending patterns. The data is cleaned, standardized, and analyzed using PostgreSQL and visualized using Power BI.

# Data Sources
The data for this project comes from multiple CSV files containing transaction records from 6 different credit card accounts and spans about 3 years of transactions. <br>

# Database Creation and Cleaning
The database consists of the following columns and data types across all accounts: <br>
* Date date
* Description text
* Amount numeric
* Extended_Details text
* Appears_On_Your_Statement_As text
* Address text
* City_State text
* Zip_Code text
* Country text
* Reference text
* Category text <br>

Most of these columns are redundant or unnecessary for this project, so I created a temporary staging table to import the data from the CSV, pulled the desired columns into the database, and then dropped the staging table. I imported the following columns from the staging table: <br>
* Account (created to show what account the transaction came from)
* Date
* Amount
* Description
* Category <br>

All of the transactions were then combined into a single table called all_accounts. This was done both for security purposes and to simplify the database normalization process.
* ADD COLUMN trans_id SERIAL PRIMARY KEY (added a unique primary key to the all_accounts table) <br>

The data was verified as containing all transactions across all accounts: 2,684 records. <br> 

# Normalization
In order to improve query efficiency, data integrity, and reduce redundancy, I created 4 seperate tables to normalize this database. <br>
1. Accounts
* account_id PRIMARY KEY
* account_name <br>
[SQL ACCOUNTS TABLE CREATION](https://github.com/aklesitz/cc-spending-analysis/blob/main/accounts_table_creation.sql)

2. Category Mapping 
* orig_category (from all_accounts)
* description (from all_accounts)
* category (standardized category) <br>
All of the different accounts have varying categories and descriptions for transactions, so I used a large CASE statement to standardize categories across all transactions. This mapping table can be modified as needed to update or change standardized categories as becomes necessary. <br>
[SQL CATEGORY MAPPING TABLE CREATION](https://github.com/aklesitz/cc-spending-analysis/blob/main/category_mapping.sql)

3. Categories
* category_id (Unique primary key)
* category (Standardized categories pulled from cataegory mapping table) <br>
My goal for these was to be as broad as possible (entertainment, travel, etc...). I got it down to 11 categories in total. <br>
[SQL CATEGORIES TABLE CREATION](https://github.com/aklesitz/cc-spending-analysis/blob/main/category_table_creation.sql) 

4. Transactions
* transaction_id PRIMARY KEY
* account_id FOREIGN KEY
* transaction_date
* amount
* description
* category_id FOREIGN KEY
[SQL TRANSACTIONS TABLE CREATION](https://github.com/aklesitz/cc-spending-analysis/blob/main/transactions_table_creation.sql)

# Next Steps
* Set up automated scripts for data import
* Visualize data and create dashboard