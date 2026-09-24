SELECT 
o.order_id, o.profit, c.customer_name
FROM orders o 
JOIN customers c  ON o.customer_id = c.customer_id
WHERE o.profit > 500;