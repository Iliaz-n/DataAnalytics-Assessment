USE adashi_staging;

/*
Scenario: The ops team wants to flag accounts with no inflow transactions for over one year.
Task: Find all active accounts (savings or investments) with no transactions in the last 1 year (365 days) .
Tables:
	- plans_plan
	- savings_savingsaccount
*/

/*
Firstly I checked if there are only 2 values 
in the is_active feature (0: Not Active, 1: Active)
*/
SELECT COUNT(DISTINCT(is_active))
FROM users_customuser; 

/*
I used the conditional expression to tag entry with is_a_fund as Investment
and is_regular_savings as Savings
*/
WITH plan_type AS
(
	SELECT owner_id, 
		CASE
			WHEN pp.is_a_fund = 1 THEN 'Investment'
			WHEN pp.is_regular_savings = 1 THEN 'Savings'
		END AS `type`
	FROM plans_plan AS pp
	WHERE pp.is_a_fund = 1 OR  pp.is_regular_savings = 1
),

/*
Extracted every other information from the savings_savingsaccount table 
and calculated the difference in last transaction date(specifically the last returns date) 
from present date. I used the last_returns_date features because this highlights the last 
date any form of deposit was made.
*/
last_trxn_details AS
(
	SELECT plan_id, owner_id, MAX(last_returns_date) AS last_transaction_date,
		TIMESTAMPDIFF(DAY, MAX(last_returns_date), NOW()) AS inactivity_days
	FROM savings_savingsaccount
    GROUP BY plan_id, owner_id
	HAVING inactivity_days > 365
)

SELECT ld.plan_id, ld.owner_id, pt.`type`,
	   ld.last_transaction_date, ld.inactivity_days
FROM users_customuser AS uc 
INNER JOIN plan_type AS pt ON uc.id = pt.owner_id
INNER JOIN last_trxn_details AS ld ON uc.id	 = ld.owner_id
WHERE uc.is_active = 1;
		
