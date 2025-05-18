WITH CustomerTransactions AS (
    -- Calculate total transactions and deposit value per customer
    SELECT
        ssa.owner_id,
        COUNT(*) AS total_transactions,
        SUM(ssa.confirmed_amount / 100.00) AS total_deposit_value
    FROM
        savings_savingsaccount ssa
    WHERE
        ssa.confirmed_amount IS NOT NULL AND ssa.confirmed_amount > 0
    GROUP BY
        ssa.owner_id
),
CustomerTenure AS (
    -- Calculate account tenure in months for each customer
    SELECT
        id AS customer_id,
        name,
        TIMESTAMPDIFF(MONTH, date_joined, CURDATE()) AS tenure_months
    FROM
        users_customuser
)
SELECT
    ct.owner_id AS customer_id,
    cten.name,
    cten.tenure_months,
    ct.total_transactions,
    (CAST(ct.total_transactions AS DECIMAL) / cten.tenure_months) * 12 * (0.001 * ct.total_deposit_value) AS estimated_clv -- CLV = (transactions/tenure) * 12 months * 0.1% profit of total deposit value
FROM
    CustomerTransactions ct
JOIN
    CustomerTenure cten ON ct.owner_id = cten.customer_id
ORDER BY
    estimated_clv DESC;
