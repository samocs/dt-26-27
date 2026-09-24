-- Active: 1790192869910@@127.0.0.1@5432@superstore
CREATE TABLE customers (
    customer_id VARCHAR(20) PRIMARY KEY,
    customer_name VARCHAR(100),
    segment VARCHAR(50),
    country VARCHAR(50),
    region VARCHAR(50)
);

CREATE TABLE products (
    product_id VARCHAR(20) PRIMARY KEY,
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_name VARCHAR(100)
);

CREATE TABLE orders (
    order_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20),
    product_id VARCHAR(20),
    order_date DATE,
    ship_date DATE,
    sales NUMERIC(100,2),
    quantity INTEGER,
    discount NUMERIC(100,2),
    profit NUMERIC(100,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);