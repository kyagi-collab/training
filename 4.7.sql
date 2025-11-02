--レシート明細データ（receipt）と商品データ（product）を結合し、顧客毎に全商品の売上金額合計と、カテゴリ大区分コード（category_major_cd）が"07"（瓶詰缶詰）の売上金額合計を計算の上、両者の比率を求めよ。抽出対象はカテゴリ大区分コード"07"の売上実績がある顧客のみとし、結果を10件表示せよ。

WITH combined_table AS (
  SELECT
   r.customer_id, 
   r.amount, 
   p.category_major_cd
  FROM `mk-analytics-230708.practice_100_knocks.receipt_data` AS r
  LEFT JOIN `mk-analytics-230708.practice_100_knocks.product_data` AS p
   ON r.product_cd = p.___product_cd
  )

SELECT 
 customer_id,
 SUM(amount) AS total_amount,
 SUM (CASE WHEN category_major_cd = 07 THEN amount ELSE 0 END) AS total_amount_cat07,
 SUM(CASE WHEN category_major_cd = 07 THEN amount ELSE 0 END) / NULLIF(SUM(amount), 0) AS ratio 
FROM combined_table
GROUP BY customer_id
HAVING total_amount_cat07 > 0
LIMIT 10;
