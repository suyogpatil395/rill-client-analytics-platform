-- Freshness and range checks: latest data, negative amounts, impossible delivery times.
SELECT
  MAX(order_ts)                                        AS latest_order,
  SUM(CASE WHEN net_amount < 0 THEN 1 ELSE 0 END)      AS negative_bills,
  SUM(CASE WHEN delivery_min < 0 OR delivery_min > 240 THEN 1 ELSE 0 END) AS bad_delivery_times,
  SUM(CASE WHEN order_ts > NOW() THEN 1 ELSE 0 END)    AS future_orders
FROM orders_enriched;
