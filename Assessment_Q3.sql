-- Q3: Account Inactivity Alert
-- Find accounts (savings or investment) with no transactions in the last 365 days.

WITH all_txns AS (
    SELECT
        id AS plan_id,
        owner_id,
        'Investment' AS type,
        MAX(updated_at) AS last_transaction_date
    FROM plans_plan
    WHERE funded = TRUE
    GROUP BY id, owner_id
    UNION ALL
    SELECT
        id AS plan_id,
        owner_id,
        'Savings' AS type,
        MAX(updated_at) AS last_transaction_date
    FROM savings_savingsaccount
    GROUP BY id, owner_id
)
SELECT
    plan_id,
    owner_id,
    type,
    last_transaction_date::date,
    DATE_PART('day', CURRENT_DATE - last_transaction_date) AS inactivity_days
FROM all_txns
WHERE last_transaction_date < CURRENT_DATE - INTERVAL '365 days'
ORDER BY inactivity_days DESC;
