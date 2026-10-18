-- Active: 1790192869910@@127.0.0.1@5432@superstore
--1
WITH ranked_orders AS (
    SELECT
        c.customer_name,
        o.order_id,
        o.order_date,
        ROW_NUMBER() OVER (
            PARTITION BY c.customer_id
            ORDER BY o.order_date DESC
        ) AS rn      
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
)
SELECT customer_name, order_id, order_date
FROM ranked_orders
WHERE rn <= 2
ORDER BY customer_name, rn;
--2
WITH customer_profit AS (
    SELECT
        c.region,
        c.customer_name,
        SUM(o.profit) AS total_profit
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY
        c.region,
        c.customer_name
)
SELECT
    region,
    customer_name,
    total_profit,
    RANK() OVER (
        PARTITION BY region
        ORDER BY total_profit DESC
    ) AS profit_rank,
    DENSE_RANK() OVER (
        PARTITION BY region
        ORDER BY total_profit DESC
    ) AS profit_dense_rank
FROM customer_profit
ORDER BY
    region,
    total_profit DESC;
--3
WITH customer_sales AS (
    SELECT 
        c.customer_id,
        c.customer_name,
        SUM(o.sales) AS total_sales   -- o.sales (nie total_amount)
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.customer_name
),
ranked_customers AS (
    SELECT 
        customer_name,
        total_sales,
        NTILE(4) OVER (ORDER BY total_sales DESC) AS quartile
    FROM customer_sales
)
SELECT customer_name, total_sales, quartile
FROM ranked_customers
ORDER BY quartile, total_sales DESC;
--4
WITH monthly_sales AS (
    SELECT 
        DATE_TRUNC('month', order_date) AS month,
        SUM(sales) AS monthly_sales
    FROM orders
    GROUP BY DATE_TRUNC('month', order_date)
),
ranked_months AS (
    SELECT 
        month,
        monthly_sales,
        LAG(monthly_sales, 1) OVER (ORDER BY month) AS prev_month_sales,
        LEAD(monthly_sales, 1) OVER (ORDER BY month) AS next_month_sales
    FROM monthly_sales
)
SELECT month, monthly_sales, prev_month_sales, next_month_sales
FROM ranked_months
ORDER BY month ASC;
--5´
WITH product_sales AS (
    SELECT 
        p.category,
        p.product_name,
        SUM(o.sales) AS product_sales
    FROM orders o
    JOIN products p ON o.product_id = p.product_id
    GROUP BY p.category, p.product_name
)
SELECT 
    category,
    product_name,
    product_sales,
    SUM(product_sales) OVER (PARTITION BY category) AS category_total,
    ROUND(
        product_sales * 100.0 /
        SUM(product_sales) OVER (PARTITION BY category),
        2
    ) AS pct
FROM product_sales
ORDER BY category, product_sales DESC;
--6
WITH order_dates AS (
    SELECT 
        c.customer_id,
        c.customer_name,
        MAX(o.order_date) OVER (PARTITION BY c.customer_id) AS last_order_date,
        MAX(o.order_date) OVER () AS latest_order_date
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
),
inactive_customers AS (
    SELECT 
        customer_id,
        customer_name,
        last_order_date
    FROM order_dates
    WHERE last_order_date < latest_order_date - INTERVAL '90 days'
)
SELECT 
    customer_id,
    customer_name,
    last_order_date
FROM inactive_customers
ORDER BY last_order_date ASC;

