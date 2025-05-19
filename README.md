# DataAnalytics-Assessment
A SQL-based evaluation solving business problems using queries across customer, savings, plans, and withdrawals tables.


This repository contains my SQL solutions for the Data Analyst Assessment.

## Table of Contents
- [Overview](#overview)
- [Database Schema](#database-schema)
- [Solutions](#solutions)
  - [Question 1](#question-1)
  - [Question 2](#question-2)
  - [Question 3](#question-3)
  - [Question 4](#question-4)
- [Author](#author)

## Overview
This project explores customer transaction behavior and financial activity using SQL queries on the adashi_staging database. The dataset spans tables including users_customuser, savings_savingsaccount, plans_plan, and withdrawals_withdrawal.

## Database Schema
- `users_customuser`: Customer demographic and contact information
- `savings_savingsaccount`: Records of deposit transactions
- `plans_plan`: Records of plans created by customers
- `withdrawals_withdrawal`: Records of withdrawal transactions

## Solutions
Each `.sql` file corresponds to a question in the assessment.

## Question 1: Customer Account Summary
### **Goal**:

To analyze customers who own both savings and investment accounts and compute their total deposits.

### **Approach**:

* Used Common Table Expressions (CTEs) to calculate:

  * Count of savings accounts (is_regular_savings)

  * Count of investment accounts (is_a_fund)

  * Sum of all confirmed deposits (converted from kobo to naira)

* Joined these CTEs on owner_id to generate a customer summary with their names and deposit total.

### **Challesnge**:

Understanding the structure of the plans_plan table and aligning conditions (is_a_fund, is_regular_savings) with customer intent.


---

## Question 2: Customer Frequency Segmentation

### **Goal**

Segment customers based on how frequently they transact.

###  **Approach**

* Extracted the number of successful transactions per customer for each month using `DATE_FORMAT`.
* Averaged monthly transactions for each user.
* Categorized users based on average transactions per month:

  * **High Frequency**: ≥10 transactions/month
  * **Medium Frequency**: 3–9 transactions/month
  * **Low Frequency**: ≤2 transactions/month

###  **Challenge**

Ensured accurate monthly grouping and filtering only successful transactions (`transaction_status = 'success'`). This was resolved using proper time formatting and conditional filtering within a CTE.

---

##  Question 3: Customer Lifetime Value (CLV) Estimation

###  **Goal**

Estimate CLV using account tenure and transaction activity.

###  **Approach**

* Calculated:

  * Total successful transactions per customer
  * Account tenure in months (`TIMESTAMPDIFF`)
  * Average profit per transaction (`0.1%` of amount)

* Applied simplified CLV formula:

  ```
  CLV = (total_transactions / tenure_months) * 12 * avg_profit_per_transaction
  ```

* Joined results with customer details and ordered by estimated CLV.

###  **Challenge**

* Needed to handle edge cases like zero tenure and ensure proper joins between `users_customuser` and `savings_savingsaccount`.
* Avoided double counting using `GROUP BY` and `ROUND` for financial precision.

---


###  Question 4: Account Inactivity Flagging

#### **Goal**

Identify all active accounts (either **savings** or **investments**) that have had **no deposit transactions in the last 365 days**.

#### **Approach**

* First, confirmed that the `is_active` field in `users_customuser` has only two values (0: Inactive, 1: Active).
* Used a **CTE (`plan_type`)** to label accounts based on whether they are savings or investment:

  * `is_a_fund = 1 → Investment`
  * `is_regular_savings = 1 → Savings`
* Created a second **CTE (`last_trxn_details`)** to extract:

  * Each `plan_id`, `owner_id`, and the `last_returns_date` as the last known deposit.
  * Calculated `inactivity_days` using `TIMESTAMPDIFF` to compare `last_returns_date` to the current date.
* Filtered results to include only customers whose `inactivity_days > 365`.
* Final result joins:

  * `users_customuser` (to filter only active users),
  * `plan_type` (to identify account type), and
  * `last_trxn_details` (to calculate inactivity).

#### **Challenge**

* The `savings_savingsaccount` table contained **multiple entries per user**, leading to **duplicate rows** in the result.
* Detected this when observing identical `owner_id`s with different `transaction_date` values but same `inactivity_days`.
* To solve this:

  * I ensured deduplication by applying `MAX(last_returns_date)` to retrieve the **most recent** transaction per account.



## Author
Naeem Ilias  
idayonaeem@gmail.com
