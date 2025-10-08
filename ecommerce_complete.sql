-- ========================================
-- E-COMMERCE SALES DASHBOARD
-- Complete SQL Analytics Project
-- ========================================

-- ========================================
-- STEP 1: DATABASE SETUP
-- ========================================

-- Create the database
CREATE DATABASE IF NOT EXISTS ecommerce_analytics;
USE ecommerce_analytics;

-- Drop existing tables if they exist (for clean start)
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;

-- ========================================
-- STEP 2: CREATE TABLES
-- ========================================

-- Categories table
CREATE TABLE categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50) NOT NULL,
    description TEXT
);

-- Products table
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    category_id INT,
    price DECIMAL(10,2) NOT NULL,
    cost DECIMAL(10,2) NOT NULL,
    stock_quantity INT DEFAULT 0,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- Customers table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    country VARCHAR(50),
    city VARCHAR(50),
    registration_date DATE NOT NULL
);

-- Orders table
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    order_status VARCHAR(20) DEFAULT 'Completed',
    total_amount DECIMAL(10,2) NOT NULL,
    shipping_cost DECIMAL(10,2) DEFAULT 0,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Order Items table
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    discount DECIMAL(10,2) DEFAULT 0,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- ========================================
-- STEP 3: INSERT SAMPLE DATA
-- ========================================

-- Insert Categories
INSERT INTO categories (category_name, description) VALUES
('Electronics', 'Electronic devices and accessories'),
('Furniture', 'Home and office furniture'),
('Apparel', 'Clothing and fashion items'),
('Books', 'Physical and digital books'),
('Sports', 'Sports equipment and accessories'),
('Home & Garden', 'Home improvement and garden supplies'),
('Toys', 'Toys and games for all ages');

-- Insert Products
INSERT INTO products (product_name, category_id, price, cost, stock_quantity) VALUES
-- Electronics
('Laptop Pro 15"', 1, 1299.99, 900.00, 45),
('Wireless Mouse', 1, 29.99, 15.00, 200),
('USB-C Hub', 1, 49.99, 25.00, 150),
('Bluetooth Headphones', 1, 149.99, 80.00, 120),
('4K Monitor 27"', 1, 399.99, 250.00, 60),
('Mechanical Keyboard', 1, 89.99, 45.00, 85),
('Webcam HD', 1, 79.99, 40.00, 95),
('External SSD 1TB', 1, 129.99, 70.00, 110),

-- Furniture
('Office Chair Ergonomic', 2, 299.99, 150.00, 40),
('Standing Desk', 2, 449.99, 250.00, 25),
('Bookshelf 5-Tier', 2, 89.99, 45.00, 50),
('Desk Lamp LED', 2, 39.99, 20.00, 180),
('Filing Cabinet', 2, 159.99, 85.00, 35),

-- Apparel
('Running Shoes', 3, 89.99, 40.00, 150),
('Yoga Pants', 3, 49.99, 20.00, 200),
('Winter Jacket', 3, 129.99, 60.00, 80),
('Sports Watch', 3, 199.99, 100.00, 70),
('Backpack Travel', 3, 59.99, 25.00, 140),

-- Books
('Data Science Handbook', 4, 39.99, 15.00, 300),
('SQL for Analysts', 4, 34.99, 12.00, 250),
('Python Programming', 4, 44.99, 18.00, 200),

-- Sports
('Yoga Mat Premium', 5, 34.99, 15.00, 220),
('Dumbbell Set 20kg', 5, 79.99, 35.00, 65),
('Resistance Bands', 5, 24.99, 10.00, 300),
('Tennis Racket', 5, 149.99, 75.00, 45),

-- Home & Garden
('Smart Thermostat', 6, 199.99, 100.00, 55),
('Garden Tool Set', 6, 69.99, 30.00, 90),
('Indoor Plant Pot', 6, 19.99, 8.00, 400),

-- Toys
('LEGO Architecture Set', 7, 79.99, 35.00, 100),
('Board Game Strategy', 7, 44.99, 20.00, 150),
('Remote Control Car', 7, 59.99, 25.00, 120);

-- Insert Customers
INSERT INTO customers (customer_name, email, phone, country, city, registration_date) VALUES
('John Smith', 'john.smith@email.com', '+1-555-0101', 'USA', 'New York', '2024-01-15'),
('Emma Johnson', 'emma.j@email.com', '+1-555-0102', 'USA', 'Los Angeles', '2024-01-20'),
('Michael Brown', 'michael.b@email.com', '+44-20-1234', 'UK', 'London', '2024-02-05'),
('Sarah Williams', 'sarah.w@email.com', '+1-555-0103', 'USA', 'Chicago', '2024-02-10'),
('David Miller', 'david.m@email.com', '+1-555-0104', 'Canada', 'Toronto', '2024-02-15'),
('Lisa Garcia', 'lisa.g@email.com', '+34-91-1234', 'Spain', 'Madrid', '2024-03-01'),
('James Wilson', 'james.w@email.com', '+1-555-0105', 'USA', 'Houston', '2024-03-05'),
('Maria Martinez', 'maria.m@email.com', '+52-55-1234', 'Mexico', 'Mexico City', '2024-03-10'),
('Robert Taylor', 'robert.t@email.com', '+61-2-1234', 'Australia', 'Sydney', '2024-03-15'),
('Jennifer Lee', 'jennifer.l@email.com', '+1-555-0106', 'USA', 'Seattle', '2024-03-20'),
('William Anderson', 'william.a@email.com', '+49-30-1234', 'Germany', 'Berlin', '2024-04-01'),
('Patricia Thomas', 'patricia.t@email.com', '+33-1-1234', 'France', 'Paris', '2024-04-05'),
('Richard Jackson', 'richard.j@email.com', '+1-555-0107', 'USA', 'Boston', '2024-04-10'),
('Linda White', 'linda.w@email.com', '+1-555-0108', 'Canada', 'Vancouver', '2024-04-15'),
('Charles Harris', 'charles.h@email.com', '+1-555-0109', 'USA', 'Miami', '2024-04-20');

-- Insert Orders (with varying dates across months)
INSERT INTO orders (customer_id, order_date, order_status, total_amount, shipping_cost) VALUES
-- June 2024
(1, '2024-06-01', 'Completed', 1349.98, 15.00),
(2, '2024-06-03', 'Completed', 179.98, 10.00),
(3, '2024-06-05', 'Completed', 539.97, 20.00),
(4, '2024-06-08', 'Completed', 289.98, 12.00),
(5, '2024-06-10', 'Completed', 749.97, 25.00),
(6, '2024-06-12', 'Completed', 149.99, 10.00),
(7, '2024-06-15', 'Completed', 1699.96, 30.00),
(8, '2024-06-18', 'Completed', 229.98, 12.00),
(9, '2024-06-20', 'Completed', 389.97, 15.00),
(10, '2024-06-22', 'Completed', 119.98, 8.00),

-- July 2024
(1, '2024-07-01', 'Completed', 199.99, 10.00),
(11, '2024-07-03', 'Completed', 449.99, 20.00),
(2, '2024-07-05', 'Completed', 579.97, 22.00),
(12, '2024-07-08', 'Completed', 299.99, 15.00),
(3, '2024-07-10', 'Completed', 89.99, 8.00),
(13, '2024-07-12', 'Completed', 1529.97, 30.00),
(4, '2024-07-15', 'Completed', 159.98, 10.00),
(14, '2024-07-18', 'Completed', 349.98, 15.00),
(5, '2024-07-20', 'Completed', 229.98, 12.00),
(15, '2024-07-22', 'Completed', 179.99, 10.00),
(6, '2024-07-25', 'Completed', 79.99, 8.00),

-- August 2024
(7, '2024-08-01', 'Completed', 649.98, 22.00),
(8, '2024-08-03', 'Completed', 399.99, 15.00),
(9, '2024-08-05', 'Completed', 269.97, 12.00),
(10, '2024-08-08', 'Completed', 549.97, 20.00),
(11, '2024-08-10', 'Completed', 129.99, 10.00),
(12, '2024-08-12', 'Completed', 889.96, 25.00),
(13, '2024-08-15', 'Completed', 219.98, 12.00),
(1, '2024-08-18', 'Completed', 1099.98, 28.00),
(2, '2024-08-20', 'Completed', 169.98, 10.00),
(3, '2024-08-22', 'Completed', 449.98, 18.00),

-- September 2024
(14, '2024-09-01', 'Completed', 329.98, 15.00),
(15, '2024-09-03', 'Completed', 199.99, 10.00),
(4, '2024-09-05', 'Completed', 89.99, 8.00),
(5, '2024-09-08', 'Processing', 749.97, 25.00),
(6, '2024-09-10', 'Shipped', 299.99, 15.00),
(7, '2024-09-12', 'Completed', 529.97, 20.00),
(8, '2024-09-15', 'Completed', 379.98, 15.00),
(9, '2024-09-18', 'Processing', 1299.99, 30.00),
(10, '2024-09-20', 'Completed', 149.99, 10.00);

-- Insert Order Items (detailed breakdown)
-- Order 1 (Customer 1, June 1)
INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal, discount) VALUES
(1, 1, 1, 1299.99, 1299.99, 0),
(1, 2, 1, 29.99, 29.99, 0),
(1, 3, 1, 49.99, 49.99, 0);

-- Order 2 (Customer 2, June 3)
INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal, discount) VALUES
(2, 4, 1, 149.99, 149.99, 0),
(2, 2, 1, 29.99, 29.99, 0);

-- Order 3 (Customer 3, June 5)
INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal, discount) VALUES
(3, 9, 1, 299.99, 299.99, 0),
(3, 12, 2, 39.99, 79.98, 0),
(3, 22, 2, 34.99, 69.98, 0),
(3, 2, 3, 29.99, 89.97, 0);

-- Order 4 (Customer 4, June 8)
INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal, discount) VALUES
(4, 16, 2, 129.99, 259.98, 0),
(4, 2, 1, 29.99, 29.99, 0);

-- Order 5 (Customer 5, June 10)
INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal, discount) VALUES
(5, 10, 1, 449.99, 449.99, 0),
(5, 9, 1, 299.99, 299.99, 0);

-- Order 6 (Customer 6, June 12)
INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal, discount) VALUES
(6, 4, 1, 149.99, 149.99, 0);

-- Order 7 (Customer 7, June 15)
INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal, discount) VALUES
(7, 5, 2, 399.99, 799.98, 0),
(7, 1, 1, 1299.99, 1299.99, 100.00),
(7, 6, 1, 89.99, 89.99, 0);

-- Order 8 (Customer 8, June 18)
INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal, discount) VALUES
(8, 14, 2, 89.99, 179.98, 0),
(8, 2, 1, 29.99, 29.99, 0),
(8, 18, 1, 59.99, 59.99, 0);

-- Order 9 (Customer 9, June 20)
INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal, discount) VALUES
(9, 9, 1, 299.99, 299.99, 0),
(9, 2, 3, 29.99, 89.97, 0);

-- Order 10 (Customer 10, June 22)
INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal, discount) VALUES
(10, 19, 3, 39.99, 119.97, 0);

-- Continue with more order items for remaining orders...
-- (Adding strategic variety for analytics)

INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal, discount) VALUES
(11, 26, 1, 199.99, 199.99, 0),
(12, 10, 1, 449.99, 449.99, 0),
(13, 5, 1, 399.99, 399.99, 0),
(13, 4, 1, 149.99, 149.99, 0),
(13, 2, 1, 29.99, 29.99, 0),
(14, 9, 1, 299.99, 299.99, 0),
(15, 14, 1, 89.99, 89.99, 0),
(16, 1, 1, 1299.99, 1299.99, 0),
(16, 6, 1, 89.99, 89.99, 0),
(16, 4, 1, 149.99, 149.99, 0),
(17, 16, 1, 129.99, 129.99, 0),
(17, 2, 1, 29.99, 29.99, 0),
(18, 9, 1, 299.99, 299.99, 0),
(18, 12, 1, 39.99, 39.99, 0),
(19, 14, 2, 89.99, 179.98, 0),
(19, 15, 1, 49.99, 49.99, 0),
(20, 17, 1, 199.99, 199.99, 0),
(21, 23, 1, 79.99, 79.99, 0),
(22, 1, 1, 1299.99, 1299.99, 0),
(22, 2, 2, 29.99, 59.98, 0),
(23, 5, 1, 399.99, 399.99, 0),
(24, 14, 3, 89.99, 269.97, 0),
(25, 10, 1, 449.99, 449.99, 0),
(25, 9, 1, 299.99, 299.99, 0),
(26, 4, 1, 149.99, 149.99, 0),
(27, 1, 1, 1299.99, 1299.99, 0),
(27, 6, 1, 89.99, 89.99, 0),
(28, 2, 2, 29.99, 59.98, 0),
(28, 22, 2, 34.99, 69.98, 0),
(28, 12, 2, 39.99, 79.98, 0),
(29, 5, 1, 399.99, 399.99, 0),
(29, 12, 1, 39.99, 39.99, 0),
(30, 14, 5, 89.99, 449.95, 0),
(31, 9, 1, 299.99, 299.99, 0),
(31, 2, 1, 29.99, 29.99, 0),
(32, 26, 1, 199.99, 199.99, 0),
(33, 14, 1, 89.99, 89.99, 0),
(34, 10, 1, 449.99, 449.99, 0),
(34, 9, 1, 299.99, 299.99, 0),
(35, 9, 1, 299.99, 299.99, 0),
(36, 16, 4, 129.99, 519.96, 0),
(37, 4, 2, 149.99, 299.98, 0),
(37, 2, 2, 29.99, 59.98, 0),
(38, 1, 1, 1299.99, 1299.99, 0),
(39, 4, 1, 149.99, 149.99, 0);

-- ========================================
-- STEP 4: KEY PERFORMANCE INDICATORS (KPIs)
-- ========================================

-- KPI 1: Overall Business Metrics
SELECT 
    COUNT(DISTINCT order_id) as total_orders,
    COUNT(DISTINCT customer_id) as total_customers,
    SUM(total_amount) as total_revenue,
    ROUND(AVG(total_amount), 2) as average_order_value,
    SUM(shipping_cost) as total_shipping_revenue,
    ROUND(SUM(total_amount) / COUNT(DISTINCT customer_id), 2) as revenue_per_customer
FROM orders
WHERE order_status = 'Completed';

-- KPI 2: Monthly Performance Summary
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') as month,
    DATE_FORMAT(order_date, '%M %Y') as month_name,
    COUNT(order_id) as total_orders,
    COUNT(DISTINCT customer_id) as unique_customers,
    SUM(total_amount) as monthly_revenue,
    ROUND(AVG(total_amount), 2) as avg_order_value,
    SUM(shipping_cost) as shipping_revenue
FROM orders
WHERE order_status = 'Completed'
GROUP BY DATE_FORMAT(order_date, '%Y-%m'), DATE_FORMAT(order_date, '%M %Y')
ORDER BY month;

-- KPI 3: Product Performance Metrics
SELECT 
    COUNT(DISTINCT product_id) as total_products,
    SUM(stock_quantity) as total_inventory_units,
    ROUND(AVG(price), 2) as avg_product_price,
    ROUND(AVG(price - cost), 2) as avg_profit_margin,
    ROUND(AVG((price - cost) / price * 100), 2) as avg_profit_margin_percentage
FROM products;

-- ========================================
-- STEP 5: SALES ANALYSIS QUERIES
-- ========================================

-- Query 1: Total Sales by Product Category
SELECT 
    c.category_name,
    COUNT(DISTINCT oi.order_id) as total_orders,
    SUM(oi.quantity) as total_units_sold,
    ROUND(SUM(oi.subtotal), 2) as total_revenue,
    ROUND(AVG(oi.subtotal), 2) as avg_transaction_value,
    ROUND(SUM(oi.subtotal) / SUM(oi.quantity), 2) as avg_price_per_unit,
    ROUND((SUM(oi.subtotal) / (SELECT SUM(subtotal) FROM order_items)) * 100, 2) as revenue_percentage
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'Completed'
GROUP BY c.category_id, c.category_name
ORDER BY total_revenue DESC;

-- Query 2: Top 10 Best-Selling Products
SELECT 
    p.product_name,
    c.category_name,
    SUM(oi.quantity) as units_sold,
    ROUND(SUM(oi.subtotal), 2) as total_revenue,
    ROUND(AVG(oi.unit_price), 2) as avg_selling_price,
    COUNT(DISTINCT oi.order_id) as number_of_orders,
    p.stock_quantity as current_stock
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'Completed'
GROUP BY p.product_id, p.product_name, c.category_name, p.stock_quantity
ORDER BY total_revenue DESC
LIMIT 10;

-- Query 3: Sales Trends Over Time (Daily)
SELECT 
    DATE(o.order_date) as date,
    COUNT(DISTINCT o.order_id) as daily_orders,
    SUM(o.total_amount) as daily_revenue,
    ROUND(AVG(o.total_amount), 2) as avg_order_value,
    COUNT(DISTINCT o.customer_id) as unique_customers
FROM orders o
WHERE o.order_status = 'Completed'
GROUP BY DATE(o.order_date)
ORDER BY date;

-- Query 4: Sales Trends by Month
SELECT 
    DATE_FORMAT(o.order_date, '%Y-%m') as month,
    DATE_FORMAT(o.order_date, '%M %Y') as month_name,
    COUNT(o.order_id) as monthly_orders,
    SUM(o.total_amount) as monthly_revenue,
    ROUND(AVG(o.total_amount), 2) as avg_order_value,
    SUM(oi.quantity) as total_units_sold
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed'
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m'), DATE_FORMAT(o.order_date, '%M %Y')
ORDER BY month;

-- Query 5: Revenue by Product Category (with Profit Analysis)
SELECT 
    c.category_name,
    SUM(oi.subtotal) as total_revenue,
    SUM(oi.quantity * p.cost) as total_cost,
    SUM(oi.subtotal - (oi.quantity * p.cost)) as total_profit,
    ROUND((SUM(oi.subtotal - (oi.quantity * p.cost)) / SUM(oi.subtotal)) * 100, 2) as profit_margin_percentage,
    SUM(oi.quantity) as units_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'Completed'
GROUP BY c.category_id, c.category_name
ORDER BY total_profit DESC;

-- ========================================
-- STEP 6: CUSTOMER ANALYSIS QUERIES
-- ========================================

-- Query 6: Customer Purchase Behavior
SELECT 
    c.customer_id,
    c.customer_name,
    c.email,
    c.country,
    c.city,
    COUNT(o.order_id) as total_orders,
    ROUND(SUM(o.total_amount), 2) as lifetime_value,
    ROUND(AVG(o.total_amount), 2) as avg_order_value,
    MIN(o.order_date) as first_purchase_date,
    MAX(o.order_date) as last_purchase_date,
    DATEDIFF(MAX(o.order_date), MIN(o.order_date)) as customer_lifetime_days,
    CASE 
        WHEN COUNT(o.order_id) >= 5 THEN 'VIP Customer'
        WHEN COUNT(o.order_id) >= 3 THEN 'Loyal Customer'
        WHEN COUNT(o.order_id) >= 2 THEN 'Repeat Customer'
        ELSE 'One-Time Customer'
    END as customer_segment
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id AND o.order_status = 'Completed'
GROUP BY c.customer_id, c.customer_name, c.email, c.country, c.city
ORDER BY lifetime_value DESC;

-- Query 7: Top 10 Customers by Revenue
SELECT 
    c.customer_name,
    c.country,
    c.city,
    COUNT(o.order_id) as total_orders,
    ROUND(SUM(o.total_amount), 2) as total_spent,
    ROUND(AVG(o.total_amount), 2) as avg_order_value,
    MAX(o.order_date) as last_order_date
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_status = 'Completed'
GROUP BY c.customer_id, c.customer_name, c.country, c.city
ORDER BY total_spent DESC
LIMIT 10;

-- Query 8: Customer Acquisition by Month
SELECT 
    DATE_FORMAT(registration_date, '%Y-%m') as month,
    DATE_FORMAT(registration_date, '%M %Y') as month_name,
    COUNT(*) as new_customers,
    SUM(COUNT(*)) OVER (ORDER BY DATE_FORMAT(registration_date, '%Y-%m')) as cumulative_customers
FROM customers
GROUP BY DATE_FORMAT(registration_date, '%Y-%m'), DATE_FORMAT(registration_date, '%M %Y')
ORDER BY month;

-- Query 9: Revenue by Country
SELECT 
    c.country,
    COUNT(DISTINCT c.customer_id) as total_customers,
    COUNT(o.order_id) as total_orders,
    ROUND(SUM(o.total_amount), 2) as total_revenue,
    ROUND(AVG(o.total_amount), 2) as avg_order_value,
    ROUND(SUM(o.total_amount) / COUNT(DISTINCT c.customer_id), 2) as revenue_per_customer
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_status = 'Completed'
GROUP BY c.country
ORDER BY total_revenue DESC;

-- Query 10: Revenue by City (Top 10)
SELECT 
    c.country,
    c.city,
    COUNT(DISTINCT c.customer_id) as customers,
    COUNT(o.order_id) as orders,
    ROUND(SUM(o.total_amount), 2) as revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_status = 'Completed'
GROUP BY c.country, c.city
ORDER BY revenue DESC
LIMIT 10;

-- ========================================
-- STEP 7: ADVANCED ANALYTICS
-- ========================================

-- Query 11: Customer Lifetime Value (CLV) Analysis
SELECT 
    CASE 
        WHEN total_spent >= 2000 THEN 'High Value (>$2000)'
        WHEN total_spent >= 1000 THEN 'Medium Value ($1000-$2000)'
        WHEN total_spent >= 500 THEN 'Low Value ($500-$1000)'
        ELSE 'Very Low Value (<$500)'
    END as value_segment,
    COUNT(*) as customer_count,
    ROUND(AVG(total_spent), 2) as avg_lifetime_value,
    ROUND(SUM(total_spent), 2) as segment_revenue,
    ROUND(AVG(total_orders), 1) as avg_orders_per_customer
FROM (
    SELECT 
        c.customer_id,
        c.customer_name,
        COUNT(o.order_id) as total_orders,
        ROUND(SUM(o.total_amount), 2) as total_spent
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id AND o.order_status = 'Completed'
    GROUP BY c.customer_id, c.customer_name
) customer_metrics
GROUP BY value_segment
ORDER BY avg_lifetime_value DESC;

-- Query 12: RFM Analysis (Recency, Frequency, Monetary)
SELECT 
    customer_name,
    country,
    recency_days,
    frequency,
    monetary_value,
    CASE 
        WHEN recency_days <= 30 AND frequency >= 3 AND monetary_value >= 1000 THEN 'Champions'
        WHEN recency_days <= 60 AND frequency >= 2 AND monetary_value >= 500 THEN 'Loyal Customers'
        WHEN recency_days <= 90 AND frequency >= 2 THEN 'Potential Loyalists'
        WHEN monetary_value >= 1000 THEN 'Big Spenders'
        WHEN recency_days <= 60 THEN 'Promising'
        WHEN recency_days <= 120 THEN 'Needs Attention'
        WHEN recency_days > 120 AND frequency >= 2 THEN 'At Risk'
        WHEN recency_days > 120 THEN 'Lost Customers'
        ELSE 'New Customers'
    END as rfm_segment
FROM (
    SELECT 
        c.customer_id,
        c.customer_name,
        c.country,
        DATEDIFF(CURDATE(), MAX(o.order_date)) as recency_days,
        COUNT(o.order_id) as frequency,
        ROUND(SUM(o.total_amount), 2) as monetary_value
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id AND o.order_status = 'Completed'
    GROUP BY c.customer_id, c.customer_name, c.country
) rfm_data
ORDER BY monetary_value DESC, recency_days ASC;

-- Query 13: Product Performance with Inventory Status
SELECT 
    p.product_name,
    c.category_name,
    p.price,
    p.cost,
    ROUND(p.price - p.cost, 2) as profit_per_unit,
    ROUND(((p.price - p.cost) / p.price) * 100, 2) as profit_margin_percentage,
    p.stock_quantity as current_stock,
    COALESCE(SUM(oi.quantity), 0) as total_sold,
    CASE 
        WHEN p.stock_quantity = 0 THEN 'Out of Stock'
        WHEN p.stock_quantity < 50 THEN 'Low Stock - Reorder'
        WHEN p.stock_quantity < 100 THEN 'Moderate Stock'
        ELSE 'Well Stocked'
    END as stock_status,
    CASE 
        WHEN COALESCE(SUM(oi.quantity), 0) = 0 THEN 'No Sales'
        WHEN COALESCE(SUM(oi.quantity), 0) < 5 THEN 'Slow Moving'
        WHEN COALESCE(SUM(oi.quantity), 0) < 20 THEN 'Moderate Sales'
        ELSE 'Fast Moving'
    END as sales_velocity
FROM products p
JOIN categories c ON p.category_id = c.category_id
LEFT JOIN order_items oi ON p.product_id = oi.product_id
LEFT JOIN orders o ON oi.order_id = o.order_id AND o.order_status = 'Completed'
GROUP BY p.product_id, p.product_name, c.category_name, p.price, p.cost, p.stock_quantity
ORDER BY total_sold DESC;

-- Query 14: Monthly Growth Rate
SELECT 
    current_month.month,
    current_month.month_name,
    current_month.revenue as current_revenue,
    previous_month.revenue as previous_revenue,
    current_month.orders as current_orders,
    previous_month.orders as previous_orders,
    ROUND(((current_month.revenue - previous_month.revenue) / previous_month.revenue) * 100, 2) as revenue_growth_percentage,
    ROUND(((current_month.orders - previous_month.orders) / previous_month.orders) * 100, 2) as order_growth_percentage
FROM (
    SELECT 
        DATE_FORMAT(order_date, '%Y-%m') as month,
        DATE_FORMAT(order_date, '%M %Y') as month_name,
        SUM(total_amount) as revenue,
        COUNT(order_id) as orders
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY DATE_FORMAT(order_date, '%Y-%m'), DATE_FORMAT(order_date, '%M %Y')
) current_month
LEFT JOIN (
    SELECT 
        DATE_FORMAT(DATE_ADD(order_date, INTERVAL 1 MONTH), '%Y-%m') as next_month,
        SUM(total_amount) as revenue,
        COUNT(order_id) as orders
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY DATE_FORMAT(DATE_ADD(order_date, INTERVAL 1 MONTH), '%Y-%m')
) previous_month ON current_month.month = previous_month.next_month
ORDER BY current_month.month;

-- Query 15: Average Days Between Orders (Customer Behavior)
SELECT 
    c.customer_name,
    c.country,
    COUNT(o.order_id) as total_orders,
    ROUND(SUM(o.total_amount), 2) as total_spent,
    MIN(o.order_date) as first_order,
    MAX(o.order_date) as last_order,
    DATEDIFF(MAX(o.order_date), MIN(o.order_date)) as customer_lifespan_days,
    CASE 
        WHEN COUNT(o.order_id) > 1 
        THEN ROUND(DATEDIFF(MAX(o.order_date), MIN(o.order_date)) / (COUNT(o.order_id) - 1), 1)
        ELSE NULL 
    END as avg_days_between_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_status = 'Completed'
GROUP BY c.customer_id, c.customer_name, c.country
HAVING COUNT(o.order_id) >= 2
ORDER BY avg_days_between_orders ASC;

-- Query 16: Product Bundle Analysis (Products Frequently Bought Together)
SELECT 
    p1.product_name as product_1,
    p2.product_name as product_2,
    COUNT(*) as times_bought_together,
    ROUND(AVG(o.total_amount), 2) as avg_order_value
FROM order_items oi1
JOIN order_items oi2 ON oi1.order_id = oi2.order_id AND oi1.product_id < oi2.product_id
JOIN products p1 ON oi1.product_id = p1.product_id
JOIN products p2 ON oi2.product_id = p2.product_id
JOIN orders o ON oi1.order_id = o.order_id
WHERE o.order_status = 'Completed'
GROUP BY p1.product_id, p1.product_name, p2.product_id, p2.product_name
HAVING times_bought_together >= 2
ORDER BY times_bought_together DESC
LIMIT 15;

-- Query 17: Seasonal Sales Pattern (by Day of Week)
SELECT 
    DAYNAME(order_date) as day_of_week,
    DAYOFWEEK(order_date) as day_number,
    COUNT(order_id) as total_orders,
    ROUND(SUM(total_amount), 2) as total_revenue,
    ROUND(AVG(total_amount), 2) as avg_order_value
FROM orders
WHERE order_status = 'Completed'
GROUP BY DAYNAME(order_date), DAYOFWEEK(order_date)
ORDER BY day_number;

-- Query 18: Customer Retention Rate
SELECT 
    first_purchase_month,
    total_customers,
    repeat_customers,
    ROUND((repeat_customers / total_customers) * 100, 2) as retention_rate_percentage
FROM (
    SELECT 
        DATE_FORMAT(first_order, '%Y-%m') as first_purchase_month,
        COUNT(DISTINCT customer_id) as total_customers,
        SUM(CASE WHEN total_orders > 1 THEN 1 ELSE 0 END) as repeat_customers
    FROM (
        SELECT 
            c.customer_id,
            MIN(o.order_date) as first_order,
            COUNT(o.order_id) as total_orders
        FROM customers c
        LEFT JOIN orders o ON c.customer_id = o.customer_id AND o.order_status = 'Completed'
        GROUP BY c.customer_id
    ) customer_first_order
    GROUP BY DATE_FORMAT(first_order, '%Y-%m')
) retention_data
ORDER BY first_purchase_month;

-- Query 19: Discount Impact Analysis
SELECT 
    CASE 
        WHEN discount > 0 THEN 'With Discount'
        ELSE 'No Discount'
    END as discount_status,
    COUNT(DISTINCT oi.order_id) as total_orders,
    SUM(oi.quantity) as total_units,
    ROUND(SUM(oi.subtotal), 2) as gross_revenue,
    ROUND(SUM(oi.discount), 2) as total_discounts,
    ROUND(SUM(oi.subtotal - oi.discount), 2) as net_revenue,
    ROUND(AVG(oi.subtotal), 2) as avg_transaction_value
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'Completed'
GROUP BY discount_status;

-- Query 20: Shipping Cost Analysis
SELECT 
    CASE 
        WHEN o.shipping_cost = 0 THEN 'Free Shipping'
        WHEN o.shipping_cost <= 10 THEN 'Standard ($0-$10)'
        WHEN o.shipping_cost <= 20 THEN 'Express ($10-$20)'
        ELSE 'Premium (>$20)'
    END as shipping_tier,
    COUNT(o.order_id) as total_orders,
    ROUND(AVG(o.total_amount), 2) as avg_order_value,
    ROUND(SUM(o.shipping_cost), 2) as total_shipping_revenue,
    ROUND(AVG(o.shipping_cost), 2) as avg_shipping_cost
FROM orders o
WHERE o.order_status = 'Completed'
GROUP BY shipping_tier
ORDER BY avg_order_value DESC;

-- ========================================
-- STEP 8: COHORT ANALYSIS
-- ========================================

-- Query 21: Monthly Cohort Analysis
SELECT 
    DATE_FORMAT(c.registration_date, '%Y-%m') as cohort_month,
    DATE_FORMAT(o.order_date, '%Y-%m') as order_month,
    COUNT(DISTINCT c.customer_id) as customers,
    COUNT(o.order_id) as orders,
    ROUND(SUM(o.total_amount), 2) as revenue,
    ROUND(AVG(o.total_amount), 2) as avg_order_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_status = 'Completed'
GROUP BY DATE_FORMAT(c.registration_date, '%Y-%m'), DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY cohort_month, order_month;

-- ========================================
-- STEP 9: SUMMARY DASHBOARD QUERY
-- ========================================

-- Query 22: Executive Dashboard Summary
SELECT 
    'Overall Metrics' as metric_category,
    CONCAT(', FORMAT(SUM(o.total_amount), 2)) as total_revenue,
    COUNT(DISTINCT o.order_id) as total_orders,
    COUNT(DISTINCT o.customer_id) as total_customers,
    COUNT(DISTINCT oi.product_id) as products_sold,
    CONCAT(', FORMAT(AVG(o.total_amount), 2)) as avg_order_value,
    CONCAT(', FORMAT(SUM(o.total_amount) / COUNT(DISTINCT o.customer_id), 2)) as revenue_per_customer
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed';

-- ========================================
-- STEP 10: EXPORT QUERIES FOR VISUALIZATION
-- ========================================

-- Query 23: Data for Revenue Trend Chart (Line Chart)
SELECT 
    DATE(order_date) as date,
    SUM(total_amount) as daily_revenue
FROM orders
WHERE order_status = 'Completed'
GROUP BY DATE(order_date)
ORDER BY date;

-- Query 24: Data for Category Sales (Pie/Donut Chart)
SELECT 
    c.category_name as category,
    ROUND(SUM(oi.subtotal), 2) as revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'Completed'
GROUP BY c.category_name
ORDER BY revenue DESC;

-- Query 25: Data for Geographic Sales (Map Visualization)
SELECT 
    c.country,
    c.city,
    COUNT(DISTINCT c.customer_id) as customers,
    COUNT(o.order_id) as orders,
    ROUND(SUM(o.total_amount), 2) as revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_status = 'Completed'
GROUP BY c.country, c.city
ORDER BY revenue DESC;

-- Query 26: Data for Top Products Table
SELECT 
    p.product_name,
    c.category_name,
    SUM(oi.quantity) as units_sold,
    ROUND(SUM(oi.subtotal), 2) as revenue,
    ROUND(AVG(oi.unit_price), 2) as avg_price
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'Completed'
GROUP BY p.product_id, p.product_name, c.category_name
ORDER BY revenue DESC
LIMIT 10;

-- ========================================
-- BONUS: USEFUL UTILITY QUERIES
-- ========================================

-- Check data integrity
SELECT 
    'Customers' as table_name, COUNT(*) as record_count FROM customers
UNION ALL
SELECT 'Products', COUNT(*) FROM products
UNION ALL
SELECT 'Orders', COUNT(*) FROM orders
UNION ALL
SELECT 'Order Items', COUNT(*) FROM order_items
UNION ALL
SELECT 'Categories', COUNT(*) FROM categories;

-- Verify order totals match order items
SELECT 
    o.order_id,
    o.total_amount as order_total,
    ROUND(SUM(oi.subtotal - oi.discount), 2) as calculated_total,
    ROUND(o.total_amount - SUM(oi.subtotal - oi.discount), 2) as difference
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id, o.total_amount
HAVING ABS(difference) > 0.01
ORDER BY ABS(difference) DESC;

-- ========================================
-- DASHBOARD VISUALIZATION RECOMMENDATIONS
-- ========================================

/*
RECOMMENDED DASHBOARD LAYOUT:

TOP SECTION - KPI CARDS (4 metrics in a row):
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
┌────────────┐ ┌────────────┐ ┌────────────┐ ┌────────────┐
│  Revenue   │ │   Orders   │ │ Customers  │ │    AOV     │
│  $XX,XXX   │ │    XXX     │ │    XXX     │ │   $XXX     │
│  ↑ +15%    │ │  ↑ +8%     │ │  ↑ +12%    │ │  ↑ +3%     │
└────────────┘ └────────────┘ └────────────┘ └────────────┘

MIDDLE SECTION - MAIN CHARTS (2 columns):
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
┌─────────────────────────┐ ┌─────────────────────────┐
│  REVENUE TREND          │ │  SALES BY CATEGORY      │
│  (Line Chart)           │ │  (Donut/Pie Chart)      │
│  - Query 23             │ │  - Query 24             │
│  - Show last 90 days    │ │  - Show % contribution  │
└─────────────────────────┘ └─────────────────────────┘

┌─────────────────────────┐ ┌─────────────────────────┐
│  TOP 10 PRODUCTS        │ │  GEOGRAPHIC SALES       │
│  (Bar Chart Horizontal) │ │  (Map or Bar Chart)     │
│  - Query 26             │ │  - Query 25             │
└─────────────────────────┘ └─────────────────────────┘

BOTTOM SECTION - DETAILED TABLES:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
┌──────────────────────────────────────────────┐
│  TOP CUSTOMERS TABLE                         │
│  - Query 7                                   │
│  - Sortable by revenue, orders, last order  │
└──────────────────────────────────────────────┘

┌──────────────────────────────────────────────┐
│  MONTHLY PERFORMANCE TABLE                   │
│  - Query 4                                   │
│  - Show growth rates                         │
└──────────────────────────────────────────────┘


CHART TYPE RECOMMENDATIONS:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. REVENUE TRENDS (Query 23):
   Chart: Line Chart or Area Chart
   X-axis: Date
   Y-axis: Revenue ($)
   Features: Add 7-day moving average line

2. CATEGORY PERFORMANCE (Query 24):
   Chart: Donut Chart or Pie Chart
   Labels: Category names with %
   Colors: Distinct colors per category
   Features: Click to drill-down

3. TOP PRODUCTS (Query 26):
   Chart: Horizontal Bar Chart
   Y-axis: Product names
   X-axis: Revenue or Units Sold
   Features: Color by category

4. GEOGRAPHIC SALES (Query 25):
   Chart: Choropleth Map or Bar Chart
   Features: Hover tooltips with details
   Alternative: Tree map for city breakdown

5. MONTHLY TRENDS (Query 4):
   Chart: Combo Chart (Bars + Line)
   Bars: Monthly Revenue
   Line: Average Order Value
   Features: Show growth percentages

6. CUSTOMER SEGMENTS (Query 11):
   Chart: Stacked Bar Chart
   Categories: Value segments
   Metrics: Customer count + Revenue
   Features: Percentage labels

7. DAY OF WEEK PATTERN (Query 17):
   Chart: Radar Chart or Bar Chart
   Features: Compare orders vs revenue


TOOLS TO CREATE DASHBOARD:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Option 1 - Tableau:
✓ Export query results to CSV
✓ Import into Tableau
✓ Drag-and-drop interface
✓ Professional visualizations

Option 2 - Power BI:
✓ Can connect directly to MySQL
✓ Real-time data refresh
✓ Microsoft integration
✓ Free desktop version

Option 3 - Google Data Studio:
✓ Free and cloud-based
✓ Connect to MySQL via connector
✓ Share dashboards easily
✓ Collaborative

Option 4 - Python (Plotly/Dash):
✓ Full customization
✓ Interactive dashboards
✓ Can deploy as web app
✓ Great for data scientists

Option 5 - Excel/Google Sheets:
✓ Quick and accessible
✓ Export CSV from queries
✓ Use pivot tables and charts
✓ Good for beginners


COLOR SCHEME SUGGESTIONS:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Primary: #2E86DE (Blue) - Revenue metrics
Success: #10AC84 (Green) - Positive growth
Warning: #F79F1F (Orange) - Needs attention
Danger: #EE5A6F (Red) - Alerts/Low stock
Neutral: #576574 (Gray) - General info

Category Colors:
Electronics: #3742fa (Blue)
Furniture: #2ed573 (Green)
Apparel: #ff6348 (Orange)
Books: #ffa502 (Yellow)
Sports: #1e90ff (Sky Blue)
Home & Garden: #2ecc71 (Emerald)
Toys: #ff6b81 (Pink)


INTERACTIVITY FEATURES:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✓ Date range filters (Last 7/30/90 days, Custom)
✓ Category dropdown filter
✓ Country/City filters
✓ Customer segment selector
✓ Search box for products/customers
✓ Drill-down from category → products
✓ Click on customer → view order history
✓ Hover tooltips with detailed info
✓ Export to CSV/PDF buttons


KEY INSIGHTS TO HIGHLIGHT:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. Revenue Growth: Month-over-month % change
2. Top Performers: Best products and customers
3. Geographic Insights: Highest revenue countries
4. Seasonal Patterns: Best days/times for sales
5. Customer Behavior: Retention and repeat rates
6. Inventory Alerts: Low stock warnings
7. Profit Margins: Most profitable categories
8. Bundle Opportunities: Products bought together
*/

-- ========================================
-- END OF E-COMMERCE ANALYTICS PROJECT
-- ========================================

-- NEXT STEPS:
-- 1. Run all queries and verify results
-- 2. Export key queries to CSV for visualization
-- 3. Build your dashboard in your chosen tool
-- 4. Set up automated data refresh (if using BI tool)
-- 5. Share with stakeholders!

-- Good luck with your E-Commerce Analytics Dashboard! 🚀📊