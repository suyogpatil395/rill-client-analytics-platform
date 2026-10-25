-- Fact model at bill-line grain (one row per item on a bill).
-- Kept separate from orders so bill-level amounts are never double counted.
-- @materialize: true

SELECT
    oi.order_item_id,
    oi.order_id,
    o.order_ts,
    o.business_date,
    o.status,
    o.channel,
    o.branch_id,
    b.branch          AS branch_name,
    b.restaurant_id,
    b.restaurant      AS restaurant_name,
    p.product         AS product_name,
    p.category,
    CASE WHEN oi.is_modifier = 1 THEN 'As modifier' ELSE 'As item' END AS sold_as,
    oi.qty,
    oi.unit_price,
    oi.qty * oi.unit_price AS line_total
FROM raw_order_items oi
JOIN stg_orders  o ON o.order_id   = oi.order_id
JOIN raw_products p ON p.product_id = oi.product_id
LEFT JOIN raw_branches b ON b.branch_id = o.branch_id
