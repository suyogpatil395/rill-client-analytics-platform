-- Every order_id must appear once in the cleaned model. Expect 0 rows.
SELECT order_id, COUNT(*) AS copies
FROM stg_orders
GROUP BY order_id
HAVING COUNT(*) > 1;
