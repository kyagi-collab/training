--顧客データ（customer）では、異なる店舗での申込みなどにより同一顧客が複数登録されている。名前（customer_name）と郵便番号（postal_cd）が同じ顧客は同一顧客とみなし、1顧客1レコードとなるように名寄せした名寄せ顧客データを作成し、顧客データの件数、名寄せ顧客データの件数、重複数を算出せよ。ただし、同一顧客に対しては売上金額合計が最も高いものを残し、売上金額合計が同一もしくは売上実績がない顧客については顧客ID（customer_id）の番号が小さいものを残すこととする。
WITH customer_sales AS (
  SELECT 
  COALESCE (SUM(r.amount),0) AS total_sales, 
  c.*,
  FROM `mk-analytics-230708.practice_100_knocks.customer_data` AS c
  LEFT JOIN `mk-analytics-230708.practice_100_knocks.receipt_data` AS r
  ON c.customer_id = r.customer_id
  GROUP BY c.customer_id, c.customer_name, c.postal_cd, c.address, c.gender,c.gender_cd,c.application_store_cd,c.status_cd, c.application_date, c.birth_day, c.age
),

ranked_customers AS (
  SELECT *, 
  ROW_NUMBER() OVER (PARTITION BY customer_name, postal_cd ORDER BY total_sales DESC, customer_id ASC) AS ranked_number
  FROM customer_sales
),

deduplicated_customers AS (
  SELECT
   customer_id, customer_name, postal_cd, address, gender_cd, application_date, birth_day, age 
  FROM ranked_customers
  WHERE ranked_number = 1
)

SELECT
 (SELECT COUNT(*) FROM customer_sales) AS total_count,
  COUNT(*) AS counted_rows_in_this_query,               
  (
    (SELECT COUNT(*) FROM customer_sales) - COUNT(*)
  ) AS difference_example
FROM deduplicated_customers;
