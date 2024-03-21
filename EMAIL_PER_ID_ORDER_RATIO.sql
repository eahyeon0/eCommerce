WITH email_categories AS (
    SELECT
        email,
        COUNT(DISTINCT id) AS id_count
    FROM
        `bigquery-public-data.thelook_ecommerce.users`
    GROUP BY
        email
    HAVING
        id_count BETWEEN 1 AND 19
),
order_counts AS (
    SELECT
        u.email,
        COUNT(DISTINCT oi.order_id) AS order_count
    FROM
        `bigquery-public-data.thelook_ecommerce.order_items` oi
    JOIN
        `bigquery-public-data.thelook_ecommerce.users` u ON oi.user_id = u.id
    GROUP BY
        u.email
)
SELECT
    ec.id_count,
    COUNT(ec.email) AS email_count,
    COALESCE(SUM(oc.order_count), 0) AS total_orders,
    -- CAST(COALESCE(SUM(oc.order_count), 0) AS FLOAT64) / COUNT(ec.email) AS order_email_ratio
    COALESCE(SUM(oc.order_count), 0) / COUNT(ec.email) AS order_email_ratio
FROM
    email_categories ec
LEFT JOIN
    order_counts oc ON ec.email = oc.email
GROUP BY
    ec.id_count
ORDER BY
    order_email_ratio DESC





