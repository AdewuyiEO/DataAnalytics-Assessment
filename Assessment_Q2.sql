-- Q2: Transaction Frequency Analysis
-- Calculate average number of transactions per customer per month and categorize.

WITH txn_summary AS (
    SELECT 
        owner_id,
        COUNT(*) AS txn_count,
        MIN(DATE(created_at)) AS first_txn,
        MAX(DATE(created_at)) AS last_txn
    FROM savings_savingsaccount
    GROUP BY owner_id
),
txn_with_months AS (
    SELECT
        owner_id,
        txn_count,
        GREATEST(
            EXTRACT(MONTH FROM AGE(MAX(last_txn), MIN(first_txn))) + 1, 1
        ) AS active_months
    FROM txn_summary
),
txn_classified AS (
    SELECT
        owner_id,
        txn_count,
        ROUND(txn_count::numeric / active_months, 2) AS avg_txn_per_month,
        CASE
            WHEN txn_count::numeric / active_months >= 10 THEN 'High Frequency'
            WHEN txn_count::numeric / active_months BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM txn_with_months
)
SELECT
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_txn_per_month), 2) AS avg_transactions_per_month
FROM txn_classified
GROUP BY frequency_category;
