WITH order_totals AS (
    SELECT 
        o.id AS order_id,
        o.customer_id,
        o.order_date,
        SUM(oi.amount) AS order_total
    FROM 
        orders o
        JOIN order_items oi ON o.id = oi.order_id
    GROUP BY 
        o.id, o.customer_id, o.order_date
),
customer_stats AS (
    SELECT 
        customer_id,
        SUM(order_total) AS total_spent,
        COUNT(*) AS order_count,
        SUM(order_total) / COUNT(*) AS avg_order_amount
    FROM 
        order_totals
    GROUP BY 
        customer_id
)
SELECT 
    ot.customer_id,
    ot.order_id,
    ot.order_date,
    ot.order_total,
    cs.total_spent,
    ROUND(cs.avg_order_amount, 2) AS avg_order_amount,
    ROUND(ot.order_total - cs.avg_order_amount, 2) AS difference_from_avg
FROM 
    order_totals ot
    JOIN customer_stats cs ON ot.customer_id = cs.customer_id
ORDER BY 
    ot.order_date DESC;
