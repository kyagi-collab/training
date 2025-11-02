--商品データ（product）では各カテゴリのコード値だけを保有し、カテゴリ名は保有していない。カテゴリデータ（category）と組み合わせて非正規化し、カテゴリ名を保有した新たな商品データを作成せよ。

SELECT
p.*,
c.category_major_name,
c.category_medium_name,
c.category_small_name
FROM `mk-analytics-230708.practice_100_knocks.product_data` AS p
LEFT JOIN `mk-analytics-230708.practice_100_knocks.category_data` AS c
ON p.category_small_cd = c.category_small_cd
limit 10;
