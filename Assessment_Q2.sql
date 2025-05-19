SELECT 
    frequency_category,
    -- Counting all customer in 'user_customuer' table and find the average
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_txn_per_month), 1) AS avg_transactions_per_month
FROM
-- Using a case function to find out frequent a customer is visiting the app base on the giving values
    (SELECT 
        u.id AS customer_id,
            COUNT(sa.id) / NULLIF(TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()), 0) AS avg_txn_per_month,
            CASE
                WHEN COUNT(sa.id) / NULLIF(TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()), 0) >= 10 THEN 'High Frequency'
                WHEN COUNT(sa.id) / NULLIF(TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()), 0) BETWEEN 3 AND 9 THEN 'Medium Frequency'
                ELSE 'Low Frequency'
            END AS frequency_category
    FROM
        adashi_staging.users_customuser AS u
    LEFT JOIN adashi_staging.savings_savingsaccount sa ON u.id = sa.owner_id
    GROUP BY u.id , u.date_joined) AS categorized
GROUP BY frequency_category
ORDER BY FIELD(frequency_category,
        'High Frequency',
        'Medium Frequency',
        'Low Frequency');