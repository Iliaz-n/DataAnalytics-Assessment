USE `adashi_staging`; # To use the DB adashi_staging 

/* users_customuser: customer demographic and contact information
   savings_savingsaccount: records of deposit transactions
   plans_plan: records of plans created by customers
   withdrawals_withdrawal:  records of withdrawal transactions */
   
# Check for duplicate data   
SELECT owner_id, `name`, COUNT(*)  
FROM plans_plan 
GROUP BY id
HAVING (COUNT(*) > 1);

/*  This block of CTEs (temporary tables) 
	is used to extract useful tables for query purpose */

/*  To create a temporary table containing the features 
	owner_id and the number of savings account owned */
WITH savings AS (
	SELECT owner_id, COUNT(*) AS savings_count
	FROM plans_plan
	WHERE is_regular_savings = 1
	GROUP BY owner_id
    ),

/*	To create a temporary table containing the features
	owner_id and number of investment accounts owned */ 	
investment AS (
	SELECT owner_id, COUNT(*) AS investment_count
	FROM plans_plan
	WHERE is_a_fund = 1
	GROUP BY owner_id
    ),

/*	To create a temporary table containing the features 
	owner_id and sum of all confirmed inflow (a sure way 
    to identify total deposit of a customer) converted to naira */
total_deposit AS (
	# Convert confirmed amount to Naira
	SELECT owner_id, SUM(confirmed_amount)/100.0 AS total_deposits 
    FROM savings_savingsaccount
    GROUP BY owner_id
    )

/*  In this block, I joined all the above temporary tables together
	using inner join on owner_id. I used owner_id as a reference key 
    because it is a foreign key to most of the tables.*/
SELECT sv.owner_id, CONCAT(uc.first_name, ' ', uc.last_name) AS 'name',
	   sv.savings_count, iv.investment_count, 
       ROUND(td.total_deposits, 2) AS total_deposit
FROM users_customuser AS uc
INNER JOIN savings AS sv ON uc.id = sv.owner_id
INNER JOIN investment AS iv ON uc.id = iv.owner_id
INNER JOIN total_deposit AS td ON uc.id = td.owner_id
WHERE sv.savings_count >= 1
AND iv.investment_count >= 1
ORDER BY td.total_deposits DESC;