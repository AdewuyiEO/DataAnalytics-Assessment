WITH CustomerTransactions AS (
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
    (CAST(ct.total_transactions AS DECIMAL) / cten.tenure_months) * 12 * (0.001 * ct.total_deposit_value) AS estimated_clv
FROM
    CustomerTransactions ct
JOIN
    CustomerTenure cten ON ct.owner_id = cten.customer_id
ORDER BY
    estimated_clv DESC;
