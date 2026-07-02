-- ============================================================
-- PROJECT: E-commerce Sales Analysis (Sample Superstore)
-- FILE: 05_customer_segments.sql
-- DESCRIPTION: Customer Segments Analysis
--              Revenue and profit by segment, top customers,
--              and average order value per segment.
-- AUTHOR: Inna
-- DATE: 2026
-- ============================================================


-- ------------------------------------------------------------
-- QUERY 1: Revenue & Profit by Segment
-- Business question: Which customer segment is most valuable?
-- Concepts: GROUP BY, SUM(), COUNT(DISTINCT), ROUND()
-- ------------------------------------------------------------
SELECT
    segment,
    ROUND(SUM(sales)::numeric, 2)                        AS total_sales,
    ROUND(SUM(profit)::numeric, 2)                       AS total_profit,
    ROUND((SUM(profit) / SUM(sales) * 100)::numeric, 2)  AS profit_margin,
    COUNT(DISTINCT order_id)                             AS total_orders
FROM superstore
GROUP BY segment
ORDER BY total_sales DESC;

-- Results insight:
-- Consumer is largest by volume ($1.16M) but lowest margin (11.55%)
-- Home Office is smallest ($429k) but highest margin (14.03%)
-- Corporate sits in the middle — balanced volume and margin (13.03%)


-- ------------------------------------------------------------
-- QUERY 2: Top 10 Customers by Total Sales
-- Business question: Who are our most valuable customers?
-- Concepts: GROUP BY, SUM(), COUNT(DISTINCT), LIMIT
-- ------------------------------------------------------------
SELECT
    customer_name,
    segment,
    ROUND(SUM(sales)::numeric, 2)   AS total_sales,
    ROUND(SUM(profit)::numeric, 2)  AS total_profit,
    COUNT(DISTINCT order_id)        AS total_orders
FROM superstore
GROUP BY customer_name, segment
ORDER BY total_sales DESC
LIMIT 10;

-- Results insight:
-- Sean Miller (Home Office) is #1 by sales ($25,043) but LOSING money (-$1,980)
-- Root cause: 50% discount on Cisco TelePresence ($22,638) wiped out all profit
-- Tamara Chand (Corporate) — $19,052 sales with healthy $8,981 profit (47% margin)
-- Key finding: high sales ≠ high profit — discount policy matters


-- ------------------------------------------------------------
-- QUERY 3: Average Order Value by Segment
-- Business question: How much does a typical order cost per segment?
-- Formula: total_sales / count of unique orders
-- Concepts: SUM() / COUNT(DISTINCT), ROUND(), ::numeric cast
-- ------------------------------------------------------------
SELECT
    segment,
    ROUND(SUM(sales)::numeric, 2)                            AS total_sales,
    COUNT(DISTINCT order_id)                                 AS total_orders,
    ROUND((SUM(sales) / COUNT(DISTINCT order_id))::numeric, 2) AS avg_order_value
FROM superstore
GROUP BY segment
ORDER BY avg_order_value DESC;

-- Results insight:
-- Home Office has highest avg order value ($472.67) despite fewer orders
-- Consumer has lowest avg order value ($449.11) but most orders (2,586)
-- Home Office customers buy less frequently but spend more per order
