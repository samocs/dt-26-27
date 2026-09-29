-- Active: 1790192869910@@127.0.0.1@5432@datacraftinglab_db
--1
SELECT product_name, total_amount 
FROM flourmills_sales 
WHERE total_amount > (
    SELECT AVG(total_amount) 
    FROM flourmills_sales);
--2
SELECT *
FROM flourmills_sales
WHERE product_category = (
    SELECT product_category
    FROM flourmills_sales
    GROUP BY product_category
    ORDER BY SUM(total_amount) DESC
    LIMIT 1
)
ORDER BY sales_id ASC;
--3
SELECT
    product_name,
    total_amount,
    (
        SELECT AVG(total_amount)
        FROM flourmills_sales
    ) AS avg_amount
FROM flourmills_sales;
--4
SELECT
    product_name,
    total_amount,
    total_amount / (
        SELECT SUM(total_amount)
        FROM flourmills_sales
    ) AS amount_share
FROM flourmills_sales;
--5
SELECT
    month,
    monthly_sales
FROM (
    SELECT
        EXTRACT(MONTH FROM sale_date) AS month,
        SUM(total_amount) AS monthly_sales
    FROM flourmills_sales
    GROUP BY EXTRACT(MONTH FROM sale_date)
) AS monthly_summary
ORDER BY monthly_sales DESC;
--6
SELECT
    product_category,
    total_sales
FROM (
    SELECT
        product_category,
        SUM(total_amount) AS total_sales
    FROM flourmills_sales
    GROUP BY product_category
) AS category_sales
WHERE total_sales > 50000000;
--7
SELECT
    product_name,
    product_category,
    total_amount
FROM flourmills_sales f1
WHERE total_amount > (
    SELECT AVG(total_amount)
    FROM flourmills_sales f2
    WHERE f2.product_category = f1.product_category
);
--8
SELECT
    product_name,
    region,
    total_amount,
    (
        SELECT MIN(f2.total_amount)
        FROM flourmills_sales f2
        WHERE f2.region = f1.region
    ) AS region_min_amount
FROM flourmills_sales f1;
--9
SELECT
    f1.product_name,
    f1.sale_date,
    f1.total_amount
FROM flourmills_sales f1
WHERE EXISTS (
    SELECT 1
    FROM flourmills_sales f2
    WHERE f2.product_name = f1.product_name
    GROUP BY f2.product_name
    HAVING COUNT(DISTINCT EXTRACT(MONTH FROM f2.sale_date)) > 1
);
--10
SELECT
    f1.product_category,
    f1.product_name,
    f1.total_amount
FROM flourmills_sales f1
WHERE EXISTS (
    SELECT 1
    FROM flourmills_sales f2
    WHERE f2.product_category = f1.product_category
      AND f2.total_amount > 200000
);
--11
SELECT DISTINCT
    f1.product_category
FROM flourmills_sales f1
WHERE EXISTS (
    SELECT 1
    FROM flourmills_sales f2
    WHERE f2.product_category = f1.product_category
    GROUP BY f2.product_category
    HAVING COUNT(DISTINCT f2.region) > 3
);
--12
SELECT
    f1.region,
    f1.product_name,
    f1.sale_date,
    f1.total_amount
FROM flourmills_sales f1
WHERE EXISTS (
    SELECT 1
    FROM flourmills_sales f2
    WHERE f2.region = f1.region
      AND EXTRACT(YEAR FROM f2.sale_date) = 2024
);
--13
SELECT DISTINCT
    f1.product_category
FROM flourmills_sales f1
WHERE NOT EXISTS (
    SELECT 1
    FROM flourmills_sales f2
    WHERE f2.product_category = f1.product_category
      AND f2.total_amount > 500000
);
--14
SELECT DISTINCT
    f1.region
FROM flourmills_sales f1
WHERE NOT EXISTS (
    SELECT 1
    FROM flourmills_sales f2
    WHERE f2.region = f1.region
      AND f2.product_category = 'Flour'
);