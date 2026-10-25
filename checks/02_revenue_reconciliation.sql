-- Revenue in the dashboard model must equal revenue in the raw export, per day.
-- Expect 0 rows (any row is a day where numbers don't match).
WITH src AS (
  SELECT CAST(order_ts AS DATE) AS d, ROUND(SUM(net_amount), 2) AS revenue
  FROM raw_orders WHERE status = 'completed' GROUP BY 1
), mdl AS (
  SELECT CAST(order_ts AS DATE) AS d, ROUND(SUM(net_amount), 2) AS revenue
  FROM orders_enriched WHERE status = 'completed' GROUP BY 1
)
SELECT COALESCE(s.d, m.d) AS d, s.revenue AS source_revenue, m.revenue AS model_revenue
FROM src s FULL OUTER JOIN mdl m ON s.d = m.d
WHERE s.revenue IS DISTINCT FROM m.revenue;
