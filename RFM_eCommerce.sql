WITH RecencyData AS (
    SELECT user_id,
           MAX(created_at) AS LastPurchaseDate,
           DATE_DIFF(CURRENT_DATE(), MAX(created_at), DAY) AS DaysSinceLastPurchase
    FROM bigquery-public-data.thelook_ecommerce.orders
    GROUP BY user_id
),
FrequencyData AS (
    SELECT user_id,
           COUNT(*) AS PurchaseFrequency
    FROM bigquery-public-data.thelook_ecommerce.orders
    GROUP BY user_id
),
MonetaryData AS (
    SELECT o.user_id,
           SUM(i.sale_price) AS TotalSpent
    FROM `bigquery-public-data.thelook_ecommerce.order_items` i
    JOIN `bigquery-public-data.thelook_ecommerce.orders` o ON i.order_id = o.order_id
    GROUP BY o.user_id
)
SELECT
    r.user_id,
    r.DaysSinceLastPurchase,
    CASE
        WHEN r.DaysSinceLastPurchase <= 30 THEN 5
        WHEN r.DaysSinceLastPurchase <= 60 THEN 4
        WHEN r.DaysSinceLastPurchase <= 90 THEN 3
        WHEN r.DaysSinceLastPurchase <= 120 THEN 2
        ELSE 1
    END AS RecencyScore,
    f.PurchaseFrequency,
    CASE
        WHEN f.PurchaseFrequency >= 10 THEN 5
        WHEN f.PurchaseFrequency >= 5 THEN 4
        WHEN f.PurchaseFrequency >= 3 THEN 3
        WHEN f.PurchaseFrequency >= 1 THEN 2
        ELSE 1
    END AS FrequencyScore,
    m.TotalSpent,
    CASE
        WHEN m.TotalSpent >= 1000 THEN 5
        WHEN m.TotalSpent >= 500 THEN 4
        WHEN m.TotalSpent >= 250 THEN 3
        WHEN m.TotalSpent >= 100 THEN 2
        ELSE 1
    END AS MonetaryScore
FROM RecencyData r
JOIN FrequencyData f ON r.user_id = f.user_id
JOIN MonetaryData m ON r.user_id = m.user_id