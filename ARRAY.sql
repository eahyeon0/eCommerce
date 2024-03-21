
SELECT
    email,
    ARRAY_AGG(STRUCT(id, country, state, created_at) ORDER BY created_at DESC) AS ids_with_same_email
FROM
    `bigquery-public-data.thelook_ecommerce.users`
GROUP BY
    email
HAVING
    COUNT(DISTINCT id) > 1
