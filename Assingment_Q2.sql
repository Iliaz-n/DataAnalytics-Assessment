-- Assessment_Q3.sql
USE adashi_staging;

/*
Scenario: The finance team wants to analyze how often customers 
	transact to segment them (e.g., frequent vs. occasional users).
Task: Calculate the average number of transactions per customer per month and categorize them:
	- "High Frequency" (≥10 transactions/month)
	- "Medium Frequency" (3-9 transactions/month)
	- "Low Frequency" (≤2 transactions/month)
Tables:
	- users_customuser
	- savings_savingsaccount

*/


# Firstly extract the sum of transactions per customer
# Integrate the perception of time
WITH avg_trxn_per_month AS
(
	SELECT owner_id, DATE_FORMAT(transaction_date, '%Y-%M') AS month_of_year, 
		COUNT(*) AS no_of_transaction
	FROM savings_savingsaccount AS ss
	WHERE ss.transaction_status = 'success'
	GROUP BY owner_id, DATE_FORMAT(transaction_date, '%Y-%M')
),

avg_trxn AS 
(
SELECT owner_id, ROUND(AVG(no_of_transaction), 1) AS avg_trxn_per_customer
FROM avg_trxn_per_month
GROUP BY owner_id
),

category AS
(
SELECT
	CASE
		WHEN avt.avg_trxn_per_customer >= 10 THEN 'High Frequency'
        WHEN avt.avg_trxn_per_customer BETWEEN 3 AND 9 THEN 'Medium Frequency'
        ELSE 'Low Frequency'
	END AS customer_category, avt.owner_id, avt.avg_trxn_per_customer
FROM avg_trxn AS avt)

SELECT ct.customer_category AS frequency_category, COUNT(*) AS customer_count, 
	   ROUND(AVG(ct.avg_trxn_per_customer), 1) AS avg_transactions_per_month
FROM category AS ct
GROUP BY ct.customer_category

