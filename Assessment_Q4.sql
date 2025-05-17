-- Q4: Customer Lifetime Value (CLV) Estimation
-- For each customer, calculate tenure in months, total transactions, and estimated CLV

WITH txn_data AS (
    SELECT
        owner_id,
        COUNT(*) AS total_transactions,
        SUM(confirmed_amount) AS total_amount,
        MIN(created_at) AS signup_date
    FROM savings_savingsaccount
    GROUP BY owner_id
),
clv_calc AS (
    SELECT
        u.id AS customer_id,
        u.name,
        DATE_PART('month', AGE(CURRENT_DATE, t.signup_date)) AS tenure_months,
        t.total_transactions,
        ROUND((t.total_amount / t.total_transactions) * 0.001, 2) AS avg_profit_per_txn,
        ROUND(
            (t.total_transactions::decimal / NULLIF(DATE_PART('month', AGE(CURRENT_DATE, t.signup_date)), 0)) 
            * 12 * ((t.total_amount / t.total_transactions) * 0.001), 2
        ) AS estimated_clv
    FROM users_customuser u
    JOIN txn_data t ON u.id = t.owner_id
)
SELECT
    customer_id,
    name,
    tenure_months,
    total_transactions,
    estimated_clv
FROM clv_calc
ORDER BY estimated_clv DESC;
