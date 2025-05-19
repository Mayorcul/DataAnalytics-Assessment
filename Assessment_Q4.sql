SELECT 
    u.id AS customer_id,
    u.name,
    
    -- Tenure in months
    TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months,
    
    -- Calculating Total transactions
    COUNT(sa.id) AS total_transactions,

    -- Estimated Customer Lifetimme Value using the formula
    ROUND(
        (COUNT(sa.id) / NULLIF(TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()), 0)) 
        * 12 
        * 0.001 * (SUM(sa.amount) / NULLIF(COUNT(sa.id), 0)),
        2
    ) AS estimated_clv

FROM adashi_staging.users_customuser AS u
JOIN 
   adashi_staging.savings_savingsaccount AS sa ON u.id = sa.owner_id
GROUP BY 
    u.id, u.name, u.date_joined
ORDER BY 
    estimated_clv DESC;