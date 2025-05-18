WITH CustomerSavingsInvestment AS (
    -- Identify customers with at least one savings and one investment plan
    SELECT
        u.id AS owner_id,
        u.name,
        CASE WHEN pp.is_regular_savings = 1 THEN ssa.plan_id ELSE NULL END AS savings_plan_id,
        CASE WHEN pp.is_a_fund = 1 THEN pp.id ELSE NULL END AS investment_plan_id,
        ssa.confirmed_amount / 100.00 AS deposit_amount
    FROM
        users_customuser u
    JOIN
        savings_savingsaccount ssa ON u.id = ssa.owner_id
    LEFT JOIN
        plans_plan pp ON ssa.plan_id = pp.id
    WHERE
        pp.is_regular_savings = 1 OR pp.is_a_fund = 1
),
CustomerProductCounts AS (
    -- Count distinct savings and investment plans and sum total deposits per customer
    SELECT
        owner_id,
        name,
        COUNT(DISTINCT savings_plan_id) AS savings_count,
        COUNT(DISTINCT investment_plan_id) AS investment_count,
        SUM(deposit_amount) AS total_deposits
    FROM
        CustomerSavingsInvestment
    GROUP BY
        owner_id, name
    HAVING
        COUNT(DISTINCT savings_plan_id) >= 1 AND COUNT(DISTINCT investment_plan_id) >= 1
)
SELECT
    owner_id,
    name,
    savings_count,
    investment_count,
    total_deposits
FROM
    CustomerProductCounts
ORDER BY
    total_deposits DESC;
