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

Sure! Here's **Question 2 and 3** in **GitHub-flavored Markdown** format, styled for use in a `README.md` file:

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

Ensuring accurate monthly grouping and filtering only successful transactions (`transaction_status = 'success'`). This was resolved using proper time formatting and conditional filtering within a CTE.

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

Let me know if you'd like these added to a full `README.md` or need the remaining questions formatted this way too.


## Author
Naeem Ilias  
idayonaeem@gmail.com
