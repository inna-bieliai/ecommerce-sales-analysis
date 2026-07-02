-- ============================================================
-- PROJECT: E-commerce Sales Analysis (Sample Superstore)
-- FILE: 06_underperformers.sql
-- DESCRIPTION: Underperformers Analysis
--              Unprofitable sub-categories, impact of discounts
--              on profit, and top loss-making products.
-- AUTHOR: Inna
-- DATE: 2026
-- ============================================================


-- ------------------------------------------------------------
-- QUERY 1: Unprofitable Sub-Categories
-- Business question: Which sub-categories are losing money?
-- Concepts: GROUP BY, SUM(), HAVING (filter after aggregation)
-- Note: WHERE filters rows before GROUP BY
--       HAVING filters groups after GROUP BY
-- ------------------------------------------------------------
SELECT
    category,
    sub_category,
    ROUND(SUM(sales)::numeric, 2)                        AS total_sales,
    ROUND(SUM(profit)::numeric, 2)                       AS total_profit,
    ROUND((SUM(profit) / SUM(sales) * 100)::numeric, 2)  AS profit_margin
FROM superstore
GROUP BY category, sub_category
HAVING ROUND(SUM(profit)::numeric, 2) < 0
ORDER BY total_profit ASC;

-- Results insight:
-- Tables (Furniture): -$17,725 loss on $206k sales (-8.56% margin)
-- Bookcases (Furniture): -$3,472 loss
-- Supplies (Office): -$1,189 loss
-- All losses concentrated in Furniture and Office Supplies
-- Technology has ZERO unprofitable sub-categories


-- ------------------------------------------------------------
-- QUERY 2: Impact of Discounts on Profit
-- Business question: At what discount level does the business start losing money?
-- Concepts: GROUP BY discount, SUM(), COUNT(DISTINCT)
-- ------------------------------------------------------------
SELECT
    discount,
    ROUND(SUM(sales)::numeric, 2)                            AS total_sales,
    ROUND(SUM(profit)::numeric, 2)                           AS total_profit,
    ROUND((SUM(profit) / COUNT(DISTINCT order_id))::numeric, 2) AS avg_profit,
    COUNT(DISTINCT order_id)                                 AS order_count
FROM superstore
GROUP BY discount
ORDER BY discount ASC;

-- Results insight:
-- 0% discount: +$320,987 profit ✅
-- 20% discount: +$90,337 profit ✅
-- 30% discount: -$10,369 LOSS 🔴 ← BREAKING POINT
-- 70% discount: -$40,075 loss
-- 80% discount: -$30,539 loss
-- KEY FINDING: Discounts above 20% are unprofitable
-- RECOMMENDATION: Cap discounts at 20% to protect margins


-- ------------------------------------------------------------
-- QUERY 3: Top 10 Loss-Making Products
-- Business question: Which specific products are losing the most money?
-- Concepts: GROUP BY, SUM(), AVG discount calculation, ORDER BY, LIMIT
-- ------------------------------------------------------------
SELECT
    category,
    sub_category,
    product_name,
    ROUND(SUM(sales)::numeric, 2)                            AS total_sales,
    ROUND(SUM(profit)::numeric, 2)                           AS total_profit,
    ROUND((SUM(discount) / COUNT(DISTINCT order_id))::numeric, 2) AS avg_discount
FROM superstore
GROUP BY category, sub_category, product_name
ORDER BY total_profit ASC
LIMIT 10;

-- Results insight:
-- Cubify CubeX 3D Printer: 53% avg discount → -$8,879 loss (worst product)
-- Technology/Machines dominate top losses — all with 40-53% discounts
-- Tables appear 4 times — systemic issue even at lower discounts (20-35%)
-- Root cause: high discounts on already low-margin products = guaranteed loss
-- Sean Miller case confirmed: 50% discount on $22,638 Cisco product = -$1,811
