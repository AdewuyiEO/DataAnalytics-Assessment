WITH MonthlyTransactions AS (
    -- Count monthly transactions per customer
    SELECT
        u.id AS customer_id,
        u.name,
        DATE_FORMAT(ssa.transaction_date, '%Y-%m') AS transaction_month,
        COUNT(*) AS num_transactions
    FROM
        users_customuser u
    JOIN
        savings_savingsaccount ssa ON u.id = ssa.owner_id
    WHERE
        ssa.confirmed_amount IS NOT NULL AND ssa.confirmed_amount > 0 -- Consider only inflow transactions
    GROUP BY
        u.id, u.name, transaction_month
),
CustomerMonthlyAvg AS (
    -- Calculate average monthly transactions per customer
    SELECT
        customer_id,
        name,
        CAST(SUM(num_transactions) AS DECIMAL) / COUNT(DISTINCT transaction_month) AS avg_transactions_per_month
    FROM
        MonthlyTransactions
    GROUP BY
        customer_id, name
)
SELECT
    CASE
        WHEN cma.avg_transactions_per_month >= 10 THEN 'High Frequency'
        WHEN cma.avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
        ELSE 'Low Frequency'
    END AS frequency_category,
    COUNT(*) AS customer_count,
    AVG(cma.avg_transactions_per_month) AS avg_transactions_per_month
FROM
    CustomerMonthlyAvg cma
GROUP BY
    frequency_category
ORDER BY
    CASE
        WHEN frequency_category = 'High Frequency' THEN 1
        WHEN frequency_category = 'Medium Frequency' THEN 2
        ELSE 3
    END;
