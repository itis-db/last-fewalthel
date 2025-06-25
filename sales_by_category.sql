WITH category_stats AS (
    SELECT 
        p.category,
        SUM(oi.amount) AS total_sales,
        COUNT(DISTINCT oi.order_id) AS order_count
    FROM 
        order_items oi
        JOIN products p ON oi.product_id = p.id
    GROUP BY 
        p.category
),
total_sales AS (
    SELECT SUM(total_sales) AS overall_total FROM category_stats
)
SELECT 
    cs.category,
    cs.total_sales,
    ROUND(cs.total_sales / cs.order_count, 2) AS avg_per_order,
    ROUND((cs.total_sales / ts.overall_total) * 100, 2) AS category_share
FROM 
    category_stats cs,
    total_sales ts
ORDER BY 
    cs.total_sales DESC;
