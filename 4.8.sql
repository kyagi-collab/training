--顧客データ（customer）の全顧客に対して全期間の売上金額に占める2019年売上金額の割合を計算し、新たなデータを作成せよ。ただし、売上実績がない場合は0として扱うこと。そして計算した割合が0超のものを抽出し、結果を10件表示せよ。また、作成したデータに欠損が存在しないことを確認せよ。

WITH Sales_2019 AS (
  SELECT 
   customer_id,
   SUM(amount) AS amount_2019
FROM `mk-analytics-230708.practice_100_knocks.receipt_data`
WHERE SUBSTR(CAST(sales_ymd AS STRING), 1,4) = '2019'
GROUP BY customer_id
), 

Sales_AllTime AS (
  SELECT 
   customer_id,
   SUM(amount) AS amount_total
FROM `mk-analytics-230708.practice_100_knocks.receipt_data`
GROUP BY customer_id
), 

customer_ratio AS (
  SELECT
  a.customer_id, 
  COALESCE (b.amount_2019,0) AS s_2019,
  COALESCE (a.amount_total,0) AS s_all,
  SAFE_DIVIDE( COALESCE (b.amount_2019,0),COALESCE (a.amount_total,0)) AS ratio 
FROM Sales_ALLTime AS a
LEFT JOIN Sales_2019 AS b ON a.customer_id = b.customer_id
)

SELECT * 
FROM customer_ratio
WHERE s_2019 > 0
LIMIT 10;

--欠損確認用
--SELECT
--  COUNT(*) AS total_rows,
--  SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS null_customer_id,
--  SUM(CASE WHEN s_2019 IS NULL THEN 1 ELSE 0 END) AS null_amount_2019,
--  SUM(CASE WHEN s_all IS NULL THEN 1 ELSE 0 END) AS null_amount_all,
--  SUM(CASE WHEN ratio IS NULL THEN 1 ELSE 0 END) AS null_ratio_2019
--FROM customer_ratio;
