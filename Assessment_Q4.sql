USE adashi_staging;

/*
Customer Lifetime Value (CLV) Estimation
Scenario: Marketing wants to estimate CLV based on account tenure and 
		  transaction volume (simplified model).
Task: For each customer, assuming the profit_per_transaction is 0.1% of 
		  the transaction value, calculate:
Account tenure (months since signup)
Total transactions
Estimated CLV (Assume: CLV = (total_transactions / tenure) * 12 * avg_profit_per_transaction)
Order by estimated CLV from highest to lowest

Tables:
	- users_customuser
	- savings_savingsaccount*/
    
/*
Account Tenure: For this task I want to know how long a customer have had an account for.
1 thing is it is not specified if customer's account should be treated seperately or combined
*/


/* 
  Here I calculate total successful transactions per customer 
*/
WITH total_trans AS
(
	SELECT owner_id, COUNT(*) AS total_transactions
	FROM savings_savingsaccount
    WHERE transaction_status = 'success'
	GROUP BY owner_id 
),


/* 
   I calculate the average profit per transaction per customer,
   profit is assumed to be 0.1% of transaction amount (amount * 0.001) 
   Rounded to 2 decimal places for readability 
*/
profit_per_trans AS 
(
    SELECT owner_id, ROUND(AVG(amount * 0.001), 2) AS avg_profit_per_transaction
	FROM savings_savingsaccount
	WHERE transaction_status = 'success'
	GROUP BY owner_id
)

SELECT sa.owner_id AS customer_id,
	CONCAT(uc.first_name, ' ', uc.last_name) AS 'name',
	TIMESTAMPDIFF(MONTH, date_joined, NOW()) AS tenure_months,
    tt.total_transactions,
    (
		ROUND(tt.total_transactions/(TIMESTAMPDIFF(MONTH, date_joined, NOW()))
			* 12 * avg_profit_per_transaction, 2)
    ) AS estimated_clv
FROM users_customuser AS uc
INNER JOIN savings_savingsaccount AS sa ON uc.id = sa.owner_id
INNER JOIN total_trans AS tt ON uc.id = tt.owner_id
INNER JOIN profit_per_trxn AS appt ON uc.id = appt.owner_id
GROUP BY customer_id
ORDER BY estimated_clv DESC;

