-- Staging model: clean types, standardise text, add derived time columns.
-- One row per bill (grain = order_id).
-- @materialize: true

SELECT
    order_id,
    branch_id,
    customer_id,
    TRIM(channel)                                        AS channel,
    CASE WHEN channel IN ('Swiggy', 'Zomato')
         THEN 'Delivery' ELSE 'In-store' END             AS channel_group,
    payment_method,
    LOWER(status)                                        AS status,
    CAST(order_ts AS TIMESTAMP)                          AS order_ts,
    -- restaurants trade past midnight: bills before 4 AM belong to the previous business day
    CAST(CAST(order_ts AS TIMESTAMP) - INTERVAL 4 HOUR AS DATE) AS business_date,
    HOUR(CAST(order_ts AS TIMESTAMP))                    AS order_hour,
    net_amount,
    discount,
    delivery_min
FROM raw_orders
WHERE order_id IS NOT NULL
QUALIFY ROW_NUMBER() OVER (PARTITION BY order_id ORDER BY order_ts DESC) = 1   -- de-duplicate
