-- ============================================================
-- PROJECT: E-commerce Sales Analysis (Sample Superstore)
-- FILE: 01_category_performance.sql
-- DESCRIPTION: Product & Category Performance Analysis
--              Revenue, profit and profit margin by category,
--              sub-category, and top products.
-- AUTHOR: Inna
-- DATE: 2026
-- ============================================================


-- ------------------------------------------------------------
-- QUERY 1: Revenue & Profit by Category
-- Business question: Which category drives the most revenue and profit?
-- Concepts: GROUP BY, SUM(), ROUND(), profit margin calculation
-- ------------------------------------------------------------
SELECT
    category,
    ROUND(SUM(sales)::numeric, 2)                    AS total_sales,
    ROUND(SUM(profit)::numeric, 2)                   AS total_profit,
    ROUND((SUM(profit) / SUM(sales) * 100)::numeric, 2) AS profit_margin
FROM superstore
GROUP BY category
ORDER BY total_sales DESC;

-- Results insight:
-- Technology leads in profit margin (17.40%)
-- Furniture has the lowest margin (2.49%) — warning sign
-- Office Supplies is close to Technology in margin (17.04%)


-- ------------------------------------------------------------
-- QUERY 2: Top 5 Sub-Categories by Total Sales
-- Business question: Which sub-categories generate the most revenue?
-- Concepts: GROUP BY, SUM(), LIMIT
-- ------------------------------------------------------------
SELECT
    category,
    sub_category,
    ROUND(SUM(sales)::numeric, 2) AS total_sales
FROM superstore
GROUP BY category, sub_category
ORDER BY total_sales DESC
LIMIT 5;

-- Results insight:
-- Phones and Chairs are top revenue drivers
-- Tables appear in top 5 by sales but are unprofitable (see Query 4)


-- ------------------------------------------------------------
-- QUERY 3: Top 5 Products by Sales within Each Category
-- Business question: Which products lead in each category?
-- Concepts: CTE, RANK() window function, PARTITION BY
-- Note: LIMIT 5 alone cannot rank within groups — RANK() is needed
-- ------------------------------------------------------------
WITH cte AS (
    SELECT
        category,
        product_name,
        ROUND(SUM(sales)::numeric, 2)                                        AS total_sales,
        RANK() OVER (PARTITION BY category ORDER BY SUM(sales) DESC) AS sales_rank
    FROM superstore
    GROUP BY category, product_name
)
SELECT *
FROM cte
WHERE sales_rank <= 5
ORDER BY category, sales_rank;

-- Results insight:
-- Canon imageCLASS 2200 Copier dominates Technology at $61,599
-- Nearly 3x higher than the top Furniture product ($21,870)
-- Technology products show much wider sales range than other categories


-- ------------------------------------------------------------
-- QUERY 4: Profit Margin by Sub-Category
-- Business question: Which sub-categories are most and least profitable?
-- Concepts: GROUP BY, SUM(), profit margin calculation, ORDER BY
-- ------------------------------------------------------------
SELECT
    category,
    sub_category,
    ROUND(SUM(sales)::numeric, 2)                       AS total_sales,
    ROUND(SUM(profit)::numeric, 2)                      AS total_profit,
    ROUND((SUM(profit) / SUM(sales) * 100)::numeric, 2) AS profit_margin
FROM superstore
GROUP BY category, sub_category
ORDER BY profit_margin DESC;

-- Results insight:
-- TOP profitable: Labels (44.42%), Paper (43.39%), Envelopes (42.27%)
-- LOSING money: Tables (-8.56%), Bookcases (-3.02%), Supplies (-2.55%)
-- Tables generate $206k in sales but LOSE $17,725 — key finding for Phase 5
