-- ============================================================
-- PROJECT: E-commerce Sales Analysis (Sample Superstore)
-- FILE: 03_sales_trends.sql
-- DESCRIPTION: Sales Trends Over Time
--              Revenue by year, seasonality by month,
--              and year-over-year growth using LAG() window function.
-- AUTHOR: Inna
-- DATE: 2026
-- ============================================================


-- ------------------------------------------------------------
-- QUERY 1: Revenue & Profit by Year
-- Business question: Is the business growing over time?
-- Concepts: EXTRACT(YEAR FROM date), GROUP BY, SUM(), ROUND()
-- ------------------------------------------------------------
SELECT
    EXTRACT(YEAR FROM order_date)                        AS year_,
    ROUND(SUM(sales)::numeric, 2)                        AS total_sales,
    ROUND(SUM(profit)::numeric, 2)                       AS total_profit,
    ROUND((SUM(profit) / SUM(sales) * 100)::numeric, 2)  AS profit_margin
FROM superstore
GROUP BY EXTRACT(YEAR FROM order_date)
ORDER BY EXTRACT(YEAR FROM order_date) ASC;

-- Results insight:
-- 2015 sales dipped vs 2014 ($484k → $470k) but profit GREW ($49k → $61k)
-- Possible reason: fewer discounts or shift toward higher-margin products
-- Strong recovery: 2016 +29%, 2017 +20% year-over-year


-- ------------------------------------------------------------
-- QUERY 2: Revenue & Profit by Month (Seasonality)
-- Business question: Which months are strongest/weakest?
-- Concepts: EXTRACT(MONTH FROM date), EXTRACT(YEAR FROM date)
-- ------------------------------------------------------------
SELECT
    EXTRACT(YEAR FROM order_date)  AS year_,
    EXTRACT(MONTH FROM order_date) AS month,
    ROUND(SUM(sales)::numeric, 2)  AS total_sales,
    ROUND(SUM(profit)::numeric, 2) AS total_profit
FROM superstore
GROUP BY EXTRACT(YEAR FROM order_date), EXTRACT(MONTH FROM order_date)
ORDER BY EXTRACT(YEAR FROM order_date), EXTRACT(MONTH FROM order_date) ASC;

-- Results insight:
-- February is consistently the weakest month every year
-- September, November, December are peak months (Q4 = end-of-year budgets)
-- Negative profit months: July 2014 (-$841), January 2015 (-$3,281)
-- Likely caused by high discounts or unprofitable products (Tables)


-- ------------------------------------------------------------
-- QUERY 3: Year-over-Year (YoY) Growth %
-- Business question: By what % did sales grow each year vs previous year?
-- Concepts: CTE (two CTEs chained), LAG() window function
-- Note: LAG() looks at the previous row — here: previous year's sales
-- ------------------------------------------------------------
WITH year_sales AS (
    SELECT
        EXTRACT(YEAR FROM order_date)  AS year_,
        ROUND(SUM(sales)::numeric, 2)  AS total_sales
    FROM superstore
    GROUP BY EXTRACT(YEAR FROM order_date)
),
yoy_growth AS (
    SELECT
        year_,
        total_sales,
        LAG(total_sales) OVER (ORDER BY year_) AS prev_year_sales
    FROM year_sales
)
SELECT
    year_,
    total_sales,
    prev_year_sales,
    ROUND(((total_sales - prev_year_sales) / prev_year_sales * 100)::numeric, 2) AS yoy_growth_pct
FROM yoy_growth;

-- Results insight:
-- 2014: NULL (no previous year to compare)
-- 2015: -2.83% slight decline
-- 2016: +29.47% strong recovery
-- 2017: +20.36% continued growth
-- Business is on a strong upward trajectory after 2015
