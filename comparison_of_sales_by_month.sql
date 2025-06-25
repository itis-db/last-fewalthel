WITH monthly_sales AS (
    SELECT 
        TO_CHAR(o.order_date, 'YYYY-MM') AS year_month,
        SUM(oi.amount) AS total_sales
    FROM 
        orders o
        JOIN order_items oi ON o.id = oi.order_id
    GROUP BY 
        TO_CHAR(o.order_date, 'YYYY-MM')
),
sales_with_lags AS (
    SELECT 
        year_month,
        total_sales,
        LAG(total_sales) OVER (ORDER BY year_month) AS prev_month_sales,
        LAG(total_sales, 12) OVER (ORDER BY year_month) AS prev_year_sales
    FROM 
        monthly_sales
)
SELECT 
    year_month,
    total_sales,
    CASE 
        WHEN prev_month_sales IS NULL THEN NULL
        ELSE ROUND((total_sales - prev_month_sales) / prev_month_sales * 100, 2)
    END AS prev_month_diff,
    CASE 
        WHEN prev_year_sales IS NULL THEN NULL
        ELSE ROUND((total_sales - prev_year_sales) / prev_year_sales * 100, 2)
    END AS prev_year_diff
FROM 
    sales_with_lags
ORDER BY 
    year_month;
