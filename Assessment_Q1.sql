SELECT 
    adashi_staging.users_customuser.id AS owner_id,
    CONCAT(adashi_staging.users_customuser.first_name,
            ' ',
            adashi_staging.users_customuser.last_name) AS name,
-- Counting users by their type of plan from 'plans_plan' table and summing the aoumnt  
    COUNT(adashi_staging.plans_plan.is_regular_savings) AS savings_count,
    COUNT(adashi_staging.plans_plan.is_fixed_investment) AS investment_count,
    SUM(adashi_staging.plans_plan.amount) AS total_deposits
FROM
    adashi_staging.users_customuser
-- join the tables on the outer left with the primary and foreign keys 
-- adding a where clause and grouping it and putting in the right order.    
        JOIN
    adashi_staging.plans_plan ON adashi_staging.users_customuser.id = adashi_staging.plans_plan.owner_id
WHERE
    adashi_staging.plans_plan.is_a_fund = 1
GROUP BY adashi_staging.users_customuser.id
HAVING COUNT(DISTINCT CASE
        WHEN adashi_staging.plans_plan.amount > 0 THEN adashi_staging.plans_plan.id
    END) > 0
ORDER BY total_deposits DESC;