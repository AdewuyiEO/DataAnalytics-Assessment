-- Q1: High-Value Customers with Multiple Products
-- Identify customers with at least one funded savings plan AND one funded investment plan.
-- Sort the results by total deposits.

SELECT
    u.id AS owner_id,
    u.name,
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN p.id END) AS savings_count,
    COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN p.id END) AS investment_count,
    ROUND(SUM(s.confirmed_amount) / 100.0, 2) AS total_deposits
FROM users_customuser u
JOIN plans_plan p ON u.id = p.owner_id
JOIN savings_savingsaccount s ON u.id = s.owner_id
WHERE p.funded = TRUE
GROUP BY u.id, u.name
HAVING 
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN p.id END) >= 1
    AND COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN p.id END) >= 1
ORDER BY total_deposits DESC;
