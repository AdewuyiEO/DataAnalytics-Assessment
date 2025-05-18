# Data Analytics SQL Assessment

This repository contains solutions to a SQL proficiency assessment aimed at evaluating my ability to extract insights from relational databases. The tasks simulate real-world business questions, focusing on customer behavior, financial transaction analysis, and value estimation using structured query language (SQL).

Each query is written to be **accurate**, **efficient**, and **readable**, with comments explaining complex logic where necessary.

---

## Question 1: High-Value Customers with Multiple Products

**Business Goal:**
Identify customers who have both a funded savings plan and a funded investment plan to enable cross-selling opportunities.

**Approach:**
- Joined `users_customuser` with `savings_savingsaccount` and then `plans_plan` on their respective keys (`owner_id` and `plan_id`).
- Filtered for customers who have at least one entry where the associated plan is a regular savings plan (`pp.is_regular_savings = 1`) and at least one where it's a fund (`pp.is_a_fund = 1`). Used `COUNT(DISTINCT CASE WHEN ...)` within a `GROUP BY` clause to achieve this.
- Calculated the total deposits for these customers by summing the `confirmed_amount` from the `savings_savingsaccount` table (converted from kobo to the base currency by dividing by 100.00).
- Grouped the results by `owner_id` and `name` and used a `HAVING` clause to ensure both plan types exist for a customer.
- Ordered the final output by `total_deposits` in descending order.

**Reflection:**
A key learning point here was the effective use of conditional aggregation with `COUNT(DISTINCT CASE WHEN ...)` to check for the existence of different product types for each customer within a grouped result. Ensuring the joins correctly linked users to their savings accounts and then to the plan details was also crucial.

---

## Question 2: Transaction Frequency Analysis

**Business Goal:**
Classify customers based on transaction frequency to aid segmentation (e.g., frequent vs. occasional users).

**Approach:**
- Created a Common Table Expression (CTE) `MonthlyTransactions` to count the number of deposit transactions (`ssa.confirmed_amount > 0`) for each customer per month using `STRFTIME('%Y-%m', ssa.transaction_date)`.
- Created another CTE `CustomerMonthlyAvg` to calculate the average number of transactions per month for each customer by dividing the total number of transactions by the distinct number of months they had transactions.
- In the final `SELECT` statement, used a `CASE` expression to categorize customers into "High Frequency", "Medium Frequency", and "Low Frequency" based on the calculated average.
- Grouped the results by the frequency category and counted the number of customers in each, also calculating the average transaction frequency for each category.

**Reflection:**
Accurately calculating the average monthly transactions required careful grouping by both customer and month. The use of CTEs made the query more readable by breaking down the logic into sequential steps. Handling the date extraction to group by month was also an important aspect.

---

## Question 3: Account Inactivity Alert

**Business Goal:**
Detect accounts with no inflow transactions in the last 365 days for customer success team follow-up.

**Approach:**
- Used a CTE `LastTransactions` to find the most recent transaction date for each savings account.
- Considered both `savings_savingsaccount` for savings plans and joined with `plans_plan` to identify investment plans. The latest of deposit transactions (from `savings_savingsaccount`) was considered.
- Created a CTE `ActiveAccounts` to get a distinct list of active savings and investment plan IDs and their owners.
- Joined `ActiveAccounts` with `LastTransactions` and filtered for accounts where the difference between the current date and the last transaction date is greater than 365 days using `JULIANDAY`.

**Reflection:**
This task involved handling data from multiple tables to determine the last activity date for different types of accounts. Using `JULIANDAY` for date differences was effective. Initially, ensuring that only 'active' accounts were considered for inactivity was a key refinement.

---

## Question 4: Customer Lifetime Value (CLV) Estimation

**Business Goal:**
Estimate the customer lifetime value using a simplified formula based on account tenure and transaction volume.

**Approach:**
- Created a CTE `CustomerTransactions` to calculate the total number of deposit transactions and the total value of deposits for each customer from `savings_savingsaccount`.
- Created a CTE `CustomerTenure` to calculate the account tenure in months using the `date_joined` from `users_customuser`. An approximation of 30.44 days per month was used for conversion.
- Joined these CTEs and applied the CLV formula: `(total_transactions / tenure_months) * 12 * (0.001 * total_deposit_value)`. The profit per transaction was assumed to be 0.1% of the transaction value.
- Ordered the results by the estimated CLV in descending order.

**Reflection:**
Ensuring the correct units (converting kobo to the base currency) was crucial for an accurate CLV calculation. The approximation of months from days was a simplification noted in the approach. This query highlighted how to combine aggregated transaction data with user demographic information to derive a business metric.

## General Insights & Challenges

- **Schema Understanding**: Thoroughly understanding the relationships between tables (primary and foreign keys) was fundamental to writing correct and efficient joins.
- **Data Type Awareness**: Being mindful of data types, especially when performing calculations (e.g., casting to `REAL` for division), was important for accurate results.
- **Business Logic Translation**: The main challenge was translating the business requirements of each question into effective SQL queries, often requiring multiple steps and careful filtering.




  
