--1
WITH daily_sales AS (
    SELECT
        sale_date,
        SUM(total_amount) AS total_daily_sales
    FROM flourmills_sales
    GROUP BY sale_date
)
SELECT
    sale_date,
    total_daily_sales
FROM
    daily_sales
WHERE total_daily_sales > 3000000
ORDER BY total_daily_sales DESC;
--2
WITH category_sales AS (
    SELECT
        product_category,
        SUM(total_amount) AS category_total
FROM flourmills_sales
GROUP BY product_category
)
SELECT
    product_category,
    category_total
FROM category_sales
ORDER BY category_total DESC;
--3
WITH product_sales AS (
    SELECT
        product_category,
        product_name,
        SUM(total_amount) AS total_product_sales
    FROM flourmills_sales
    GROUP BY product_category, product_name
),
ranked_products AS (
    SELECT
        product_category,
        product_name,
        total_product_sales,
        RANK() OVER (
            PARTITION BY product_category
            ORDER BY total_product_sales DESC
        ) AS category_rank
    FROM product_sales
)
SELECT
    product_category,
    product_name,
    total_product_sales,
    category_rank
FROM ranked_products
WHERE category_rank BETWEEN 1 AND 3
ORDER BY product_category, category_rank;
--4
WITH customer_revenue AS (
    SELECT
        customer_type,
        SUM(total_amount) AS revenue
    FROM flourmills_sales
    GROUP BY customer_type
),
revenue_share AS (
    SELECT
        customer_type,
        revenue,
        SUM(revenue) OVER () AS total_revenue,
        ROUND(
            revenue * 100.0 / SUM(revenue) OVER (),
            2
        ) AS revenue_percentage
    FROM customer_revenue
)
SELECT
    customer_type,
    revenue,
    total_revenue,
    revenue_percentage
FROM revenue_share
ORDER BY revenue DESC;
--5
WITH last_purchase AS (
    SELECT
        customer_id,
        product_name,
        sale_date,
        total_amount,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY sale_date DESC
        ) AS rn
    FROM flourmills_sales
)
SELECT
    customer_id,
    product_name,
    sale_date,
    total_amount
FROM last_purchase
WHERE rn = 1
ORDER BY customer_id ASC;
--6
WITH RECURSIVE
date_range AS (
    SELECT
        MIN(sale_date) AS start_date,
        MAX(sale_date) AS end_date
    FROM flourmills_sales
),
calendar AS (
    SELECT start_date AS calendar_date
    FROM date_range

    UNION ALL

    SELECT calendar_date + 1
    FROM calendar, date_range
    WHERE calendar_date < end_date
)
SELECT
    calendar_date
FROM calendar
ORDER BY calendar_date;
--7
WITH RECURSIVE
monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', sale_date) AS month,
        SUM(total_amount) AS revenue
    FROM flourmills_sales
    GROUP BY DATE_TRUNC('month', sale_date)
),

ordered_months AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY month) AS rn,
        month,
        revenue
    FROM monthly_revenue
),

cumulative_target AS (
    SELECT
        rn,
        month,
        revenue,
        revenue AS cumulative_revenue
    FROM ordered_months
    WHERE rn = 1

    UNION ALL

    SELECT
        om.rn,
        om.month,
        om.revenue,
        ct.cumulative_revenue + om.revenue AS cumulative_revenue
    FROM cumulative_target ct
    JOIN ordered_months om
        ON om.rn = ct.rn + 1
    WHERE ct.cumulative_revenue < 500000000
)

SELECT
    rn,
    month,
    revenue,
    cumulative_revenue
FROM cumulative_target
WHERE cumulative_revenue >= 500000000
ORDER BY rn
LIMIT 1;