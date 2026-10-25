-- Fact model at bill grain, enriched with branch and restaurant attributes.
-- This is the table the orders metrics view reads from.
-- @materialize: true

SELECT
    o.*,
    b.branch          AS branch_name,
    b.city,
    b.restaurant_id,
    b.restaurant      AS restaurant_name,
    CASE WHEN o.delivery_min > 45 THEN 1 ELSE 0 END AS is_late_delivery
FROM stg_orders o
LEFT JOIN raw_branches b ON b.branch_id = o.branch_id
