--KPI

SELECT
    ROUND(SUM(sales_per_customer)::numeric, 2) AS total_sales,
    ROUND(SUM(benefit_per_order)::numeric, 2) AS total_profit,
    COUNT(order_id) AS total_orders
FROM supply_chain_data;

--Top 10 Product Category

SELECT
    category_name,
    ROUND(SUM(sales_per_customer)::numeric, 2) AS total_sales
FROM supply_chain_data
GROUP BY category_name
ORDER BY total_sales DESC
LIMIT 10;


--Top Profitable Products
SELECT
    product_name,
    ROUND(SUM(benefit_per_order)::numeric, 2) AS total_profit
FROM supply_chain_data
GROUP BY product_name
ORDER BY total_profit DESC
LIMIT 10;

--Shipping Performance
SELECT
    shipping_mode,
    ROUND(AVG(delivery_days)::numeric, 2) AS avg_delivery_days
FROM supply_chain_data
GROUP BY shipping_mode
ORDER BY avg_delivery_days;

--Late Delivery Analysis
SELECT
    late_delivery_risk,
    COUNT(*) AS total_orders
FROM supply_chain_data
GROUP BY late_delivery_risk;


--Top Sales Region
SELECT
    order_region,
    ROUND(SUM(sales_per_customer)::numeric, 2) AS total_sales
FROM supply_chain_data
GROUP BY order_region
ORDER BY total_sales DESC;


--Monthly Revenue Trend
SELECT
    date_trunc('month', order_date::timestamp) AS month,
    ROUND(SUM(
    sales_per_customer)::numeric, 2) AS monthly_sales
FROM supply_chain_data
GROUP BY month
ORDER BY month;

--Cek Datatype di PostgreSQL
SELECT
    column_name,
    data_type
FROM information_schema.columns
WHERE table_name = 'supply_chain_data';

--Monthly Growth (Window Function)
WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', order_date) AS month,
        SUM(sales_per_customer) AS revenue
    FROM supply_chain_data
    GROUP BY DATE_TRUNC('month', order_date)
)

SELECT
    month,

    ROUND(revenue::numeric, 2) AS revenue,

    ROUND(
        LAG(revenue) OVER (ORDER BY month)::numeric,
        2
    ) AS previous_month,

    ROUND(
        (
            (
                revenue
                - LAG(revenue) OVER (ORDER BY month)
            )
            /
            LAG(revenue) OVER (ORDER BY month)
        ) * 100
        , 2) AS growth_percentage
FROM monthly_sales
ORDER BY month;


--Top Customers
SELECT
    customer_id,
    customer_fname,
    customer_lname,
    ROUND(SUM(sales_per_customer)::numeric, 2) AS total_spending
FROM supply_chain_data
GROUP BY
    customer_id,
    customer_fname,
    customer_lname
ORDER BY total_spending DESC
LIMIT 10;


--Profit Margin Analysis
SELECT
    category_name,
    ROUND(AVG(profit_margin)::numeric, 2) AS avg_profit_margin
FROM supply_chain_data
GROUP BY category_name
ORDER BY avg_profit_margin DESC;


--ubah permanen datatype di PostgreSQL.

ALTER TABLE supply_chain_data
ALTER COLUMN order_date
TYPE timestamp
USING order_date::timestamp;


ALTER TABLE supply_chain_data
ALTER COLUMN shipping_date
TYPE timestamp
USING shipping_date::timestamp;


SELECT
    column_name,
    data_type
FROM information_schema.columns
WHERE table_name = 'supply_chain_data';
