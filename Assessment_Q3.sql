WITH LastTransactions AS (
    SELECT
        'Savings' AS type,
        ssa.plan_id,
        ssa.owner_id,
        MAX(ssa.transaction_date) AS last_transaction_date
    FROM
        savings_savingsaccount ssa
    GROUP BY
        ssa.plan_id, ssa.owner_id
    UNION ALL
    SELECT
        CASE WHEN pp.is_regular_savings = 1 THEN 'Savings' ELSE 'Investment' END AS type,
        pp.id AS plan_id,
        pp.owner_id,
        MAX(COALESCE(ssa.transaction_date, ww.transaction_date, pp.created_on)) AS last_transaction_date -- Consider creation date if no transactions
    FROM
        plans_plan pp
    LEFT JOIN
        savings_savingsaccount ssa ON pp.id = ssa.plan_id
    LEFT JOIN
        withdrawals_withdrawal ww ON pp.id = ww.plan_id
    WHERE
        pp.is_regular_savings = 1 OR pp.is_a_fund = 1
    GROUP BY
        pp.id, pp.owner_id, CASE WHEN pp.is_regular_savings = 1 THEN 'Savings' ELSE 'Investment' END
),
ActiveAccounts AS (
    SELECT DISTINCT
        CASE WHEN pp.is_regular_savings = 1 THEN 'Savings' ELSE 'Investment' END AS type,
        pp.id AS plan_id,
        pp.owner_id
    FROM
        plans_plan pp
    WHERE
        pp.is_regular_savings = 1 OR pp.is_a_fund = 1
)
SELECT
    aa.plan_id,
    aa.owner_id,
    aa.type,
    lt.last_transaction_date,
    DATEDIFF(CURDATE(), lt.last_transaction_date) AS inactivity_days
FROM
    ActiveAccounts aa
LEFT JOIN
    LastTransactions lt ON aa.plan_id = lt.plan_id AND aa.owner_id = lt.owner_id AND aa.type = lt.type
WHERE
    DATEDIFF(CURDATE(), COALESCE(lt.last_transaction_date, (SELECT MIN(created_on) FROM users_customuser WHERE id = aa.owner_id))) > 365
ORDER BY
    inactivity_days DESC;
