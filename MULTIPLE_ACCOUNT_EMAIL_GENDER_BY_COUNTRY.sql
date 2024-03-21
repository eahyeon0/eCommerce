
SELECT
    CASE
        WHEN u.country = 'Deutschland' THEN 'Germany'
        WHEN u.country = 'España' THEN 'Spain'
        ELSE u.country
    END AS country,
    gender,
    COUNT(DISTINCT email) as email_cnt,
    COUNT(distinct id) as account_cnt,
    COUNT(DISTINCT id) / COUNT(DISTINCT email) * 100 AS email_id_ratio
FROM
    `bigquery-public-data.thelook_ecommerce.users` u
GROUP BY
    country, gender
ORDER BY
    email_id_ratio DESC