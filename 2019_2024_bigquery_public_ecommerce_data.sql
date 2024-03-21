with count_r_c as(
SELECT  
  FORMAT_TIMESTAMP('%Y-%m', o.created_at) AS year_month,
  count(case when o.status = 'Returned' then 1 end)  as returned,
  count(case when o.status = 'Cancelled' then 1 end)as cancelled,
  count(case when o.gender = 'F' then 1 end) as order_by_female,
  count(case when o.gender = 'M' then 1 end) as order_by_male
FROM `bigquery-public-data.thelook_ecommerce.orders` o
group by 1
order by 1
),
count_user_gen as(
select
  FORMAT_TIMESTAMP('%Y-%m', u.created_at) AS year_month,
  count(distinct u.id) as count_created_user,
  count(case when u.gender = 'F' then 1 end) as female,
  count(case when u.gender = 'M' then 1 end) as male,
  avg(u.age) as age,
  count(case when u.traffic_source = 'Search' then 1 end) as create_search,
  count(case when u.traffic_source = 'Organic' then 1 end) as create_organic,
  count(case when u.traffic_source = 'Display' then 1 end) as create_display,
  count(case when u.traffic_source = 'Facebook' then 1 end) as create_Facebook,
  count(case when u.traffic_source = 'Email' then 1 end) as create_email
from `bigquery-public-data.thelook_ecommerce.users` u
group by 1
order by 1
),
sum_price_itemsnum as(
select
  FORMAT_TIMESTAMP('%Y-%m', o_i.created_at) AS year_month,
  sum(o_i.sale_price) as sum_sales,
  sum(o.num_of_item) as sum_count_items,
  count(distinct o_i.order_id) as order_ids
from `bigquery-public-data.thelook_ecommerce.order_items` o_i
inner join `bigquery-public-data.thelook_ecommerce.orders` o on o_i.order_id = o.order_id 
where o_i.status = 'Complete'
group by 1
order by 1
)
select 
  s.year_month as year_month,
  cug.count_created_user as monthly_created_user,
  s.sum_sales as sum_sales, s.sum_count_items as sum_num_of_items,
  s.order_ids as order_ids,
  cug.age as avg_age,
  cug.female as female, cug.male as male, 
  rc.order_by_female as order_by_female, 
  rc.order_by_male as order_by_male, 
  rc.returned as returned,
  rc.cancelled as cancelled,
  cug.create_search as search,
  cug.create_organic as organic,
  cug.create_display as display,
  cug.create_email as email,
  cug.create_Facebook as facebook
from sum_price_itemsnum s
inner join count_user_gen cug on s.year_month = cug.year_month
inner join count_r_c rc on s.year_month = rc.year_month 
order by 1
