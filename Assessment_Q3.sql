SELECT 
    p.id AS plan_id,
    p.owner_id AS owner_id,
    p.plan_type_id AS type,
    -- Finding the last seen date and also calculating the date difference from the current date.
    MAX(sa.transaction_date) AS last_transaction_date,
    DATEDIFF(CURDATE(), MAX(sa.transaction_date)) AS inactivity_days
FROM
    adashi_staging.plans_plan AS p
    -- join the tables on the outer left with the primary and foreign keys 
    -- adding a where clause and grouping it and putting in the right order.
        LEFT JOIN
    adashi_staging.savings_savingsaccount sa ON p.id = sa.plan_id
WHERE
    p.status_id = 1
GROUP BY p.id , p.owner_id , p.plan_type_id
HAVING last_transaction_date IS NULL
    OR DATEDIFF(CURDATE(), last_transaction_date) > 365
ORDER BY inactivity_days DESC;