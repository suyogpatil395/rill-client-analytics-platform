-- Bills or lines that point to a branch / product that doesn't exist. Expect 0 rows.
SELECT 'order without branch' AS issue, COUNT(*) AS n
FROM raw_orders o LEFT JOIN raw_branches b ON b.branch_id = o.branch_id
WHERE b.branch_id IS NULL
UNION ALL
SELECT 'line without product', COUNT(*)
FROM raw_order_items i LEFT JOIN raw_products p ON p.product_id = i.product_id
WHERE p.product_id IS NULL
UNION ALL
SELECT 'line without bill', COUNT(*)
FROM raw_order_items i LEFT JOIN raw_orders o ON o.order_id = i.order_id
WHERE o.order_id IS NULL;
