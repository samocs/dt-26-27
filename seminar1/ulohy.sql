--2
SELECT 
o.order_id, o.profit, c.customer_name
FROM orders o 
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.profit > 500;
--3
SELECT 
o.order_id, c.customer_name, p.category, o.profit
FROM orders o 
JOIN customers c ON o.customer_id = c.customer_id  
JOIN products p ON o.product_id = p.product_id;
--4
SELECT
c.region, SUM(o.profit) AS total_profit
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.region;
--5
SELECT p.product_name, SUM(o.profit) AS total_profit
FROM products p 
FULL JOIN orders o ON o.product_id = p.product_id
GROUP BY p.product_name;
--6
SELECT c.customer_name, o.order_id, o.profit
FROM orders o 
FULL JOIN customers c ON c.customer_id = o.customer_id;
--7
select c.region, SUM(o.profit)
FROM customers c 
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.region;
--8
SELECT c.customer_name, COUNT(o.order_id) AS ord_count
FROM customers c 
LEFT JOIN orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_name;
--9
SELECT p.category, AVG(o.discount) AS avg_discount
FROM products p 
LEFT JOIN orders o ON o.product_id = p.product_id
GROUP BY p.category;
--10
SELECT c.customer_name, SUM(o.profit) AS total
FROM customers c 
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name
HAVING SUM(o.profit) < 2000;
--11
SELECT 
    c.region, 
    SUM(o.profit) AS total_profit, 
    AVG(o.discount) AS avg_discount, 
    COUNT(o.order_id) AS order_count
from orders o
JOIN customers c ON c.customer_id = o.customer_id
GROUP BY c.region;
--12
SELECT 
    c.region,
    COUNT(CASE WHEN o.profit > 1000 THEN 1 END) AS high_value_orders,
    COUNT(CASE WHEN o.profit <= 1000 THEN 1 END) AS low_value_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.region;
--13
SELECT 
    c.customer_name,
    SUM(o.profit) AS total_profit,
    AVG(o.discount) AS avg_discount,
    COUNT(o.order_id) AS order_count,
    CASE 
        WHEN SUM(o.profit) > 2500 THEN 'VIP'
        ELSE 'REGULAR'
    END AS customer_type
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY total_profit DESC;

