
SELECT
    CASE
        WHEN country = 'Deutschland' THEN 'Germany'
        WHEN country = 'España' THEN 'Spain'
        ELSE country
    END AS country,
    COUNT(DISTINCT email) as email_cnt,
    COUNT(distinct id) as account_cnt,
    COUNT(DISTINCT id) / COUNT(DISTINCT email) * 100 AS email_id_ratio
FROM
    `bigquery-public-data.thelook_ecommerce.users`
GROUP BY
    country
ORDER BY
    email_id_ratio DESC