SELECT
    u.id AS owner_id,
    u.name,
    COUNT(DISTINCT CASE WHEN pp.is_regular_savings = 1 THEN ssa.plan_id END) AS savings_count,
    COUNT(DISTINCT CASE WHEN pp.is_a_fund = 1 THEN pp.id END) AS investment_count,
    SUM(ssa.confirmed_amount / 100.00) AS total_deposits -- Convert kobo to Naira/base currency
FROM
    users_customuser u
JOIN
    savings_savingsaccount ssa ON u.id = ssa.owner_id
LEFT JOIN
    plans_plan pp ON ssa.plan_id = pp.id
WHERE
    pp.is_regular_savings = 1 OR pp.is_a_fund = 1
GROUP BY
    u.id, u.name
HAVING
    COUNT(DISTINCT CASE WHEN pp.is_regular_savings = 1 THEN ssa.plan_id END) >= 1
    AND COUNT(DISTINCT CASE WHEN pp.is_a_fund = 1 THEN pp.id END) >= 1
ORDER BY
    total_deposits DESC;
