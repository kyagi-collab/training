--顧客データ（customer）の郵便番号（postal_cd）に対し、東京（先頭3桁が100〜209のもの）を1、それ以外のものを0に二値化せよ。さらにレシート明細データ（receipt）と結合し、全期間において売上実績のある顧客数を、作成した二値ごとにカウントせよ。

WITH temp_table AS
(SELECT
customer_id, 
 CASE 
　WHEN SUBSTR(postal_cd,1,3) BETWEEN '100' AND '209' THEN 1 
  ELSE 0
END AS pos_category
FROM `mk-analytics-230708.practice_100_knocks.customer_data`
WHERE customer_id NOT LIKE 'Z%')

SELECT 
pos_category, 
COUNT (DISTINCT r.customer_id) AS customer_count
FROM `mk-analytics-230708.practice_100_knocks.receipt_data` AS r
INNER JOIN temp_table AS t ON r.customer_id = t.customer_id
GROUP BY pos_category
