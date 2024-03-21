WITH co_occur AS (
  SELECT
    a.product_id AS product_1,
    b.product_id AS product_2,
    COUNT(1) AS co_occur_cnt,
  FROM bigquery-public-data.thelook_ecommerce.order_items a
    JOIN bigquery-public-data.thelook_ecommerce.order_items b
      ON a.order_id=b.order_id
        AND a.product_id<b.product_id
  GROUP BY 1,2
),
cnt_per_items AS (
  SELECT
    product_id,
    COUNT(1) as cnt,
  FROM bigquery-public-data.thelook_ecommerce.order_items
  GROUP BY 1
)
SELECT co.*,
  cnt_1.cnt AS p1_cnt,
  cnt_2.cnt AS p2_cnt,
  co_occur_cnt/cnt_1.cnt AS p1_confidence,
  co_occur_cnt/cnt_2.cnt AS p2_confidence,
  co_occur_cnt/(SELECT COUNT(1) FROM bigquery-public-data.thelook_ecommerce.orders) AS support,
  co_occur_cnt/(cnt_1.cnt*cnt_2.cnt) AS lift
FROM co_occur co
  LEFT JOIN cnt_per_items cnt_1 ON co.product_1=cnt_1.product_id
  LEFT JOIN cnt_per_items cnt_2 ON co.product_2=cnt_2.product_id
ORDER BY lift DESC;





