# 📊 Data Analytics SQL Assessment

This repository contains solutions to a SQL proficiency assessment aimed at evaluating my ability to extract insights from relational databases. The tasks simulate real-world business questions, focusing on customer behavior, financial transaction analysis, and value estimation using structured query language (SQL).

Each query is written to be **accurate**, **efficient**, and **readable**, with comments explaining complex logic where necessary.

---

## 🔍 Question 1: High-Value Customers with Multiple Products

**Business Goal:**  
Identify customers who have both a funded savings plan and a funded investment plan to enable cross-selling opportunities.

**Approach:**  
- Joined `users_customuser`, `savings_savingsaccount`, and `plans_plan`.
- Filtered for customers with:
  - At least one savings plan where `is_regular_savings = 1`
  - At least one investment plan where `is_a_fund = 1`
- Aggregated total deposits per customer.
- Ordered results by total deposits.

**Reflection:**  
A key learning point here was clearly distinguishing plan types using flags like `is_regular_savings` and `is_a_fund`, and ensuring accurate grouping across multiple tables.

---

## 🔁 Question 2: Transaction Frequency Analysis

**Business Goal:**  
Classify customers based on transaction frequency to aid segmentation (e.g., frequent vs. occasional users).

**Approach:**  
- Counted total transactions for each customer.
- Estimated number of months active using min and max transaction dates.
- Calculated average transactions per month.
- Applied frequency categories using `CASE` logic:
  - High Frequency: ≥ 10/month
  - Medium Frequency: 3–9/month
  - Low Frequency: ≤ 2/month

**Reflection:**  
Accurately calculating months of activity was crucial. I used date functions to handle variations in transaction periods across customers.

---

## 🚨 Question 3: Account Inactivity Alert

**Business Goal:**  
Detect accounts with no inflow (deposits) in the last 365 days for customer success team follow-up.

**Approach:**  
- Queried the most recent deposit date for each account.
- Used date difference logic to compute days of inactivity.
- Filtered to include only accounts that are still marked active but have exceeded 365 days without a deposit.

**Reflection:**  
This task required careful handling of date functions and ensuring only relevant account types were included (savings and investment). I paid attention to proper date comparisons to maintain accuracy.

---

## 📈 Question 4: Customer Lifetime Value (CLV) Estimation

**Business Goal:**  
Estimate the customer lifetime value using a simplified formula based on account tenure and transaction volume.

**Approach:**  
- Calculated tenure (in months) as the difference between account creation and current date.
- Aggregated all transaction values per customer.
- Assumed profit per transaction = 0.1% of value.
- Formula used: estimated_clv = (total_transactions / tenure_months) * 12 * avg_profit_per_transaction
  
**Reflection:**  
Ensuring correct conversion from kobo to naira was critical. This task helped reinforce the importance of unit handling and formula-driven estimations in SQL.

## 💡 General Insights & Challenges

- **Data modeling matters**: Understanding foreign key relationships was key to writing correct joins.
- **Date manipulation**: Several queries required working with timestamps — I learned to handle these confidently across different SQL engines.
- **Edge case handling**: Ensuring all queries accounted for nulls, inactive users, and small sample groups helped build robust outputs.

## 📂 Repository Structure
DataAnalytics-Assessment/
├── Assessment_Q1.sql
├── Assessment_Q2.sql
├── Assessment_Q3.sql
├── Assessment_Q4.sql
└── README.md



  
