-- ============================================================
-- PROJECT: E-commerce Sales Analysis (Sample Superstore)
-- FILE: 04_regional_performance.sql
-- DESCRIPTION: Regional Performance Analysis
--              Revenue and profit by region and state,
--              top and bottom 5 states by profitability.
-- AUTHOR: Inna
-- DATE: 2026
-- ============================================================


-- ------------------------------------------------------------
-- QUERY 1: Revenue & Profit by Region
-- Business question: Which region is the most profitable?
-- Concepts: GROUP BY, SUM(), ROUND(), profit margin calculation
-- ------------------------------------------------------------
SELECT
    region,
    ROUND(SUM(sales)::numeric, 2)                        AS total_sales,
    ROUND(SUM(profit)::numeric, 2)                       AS total_profit,
    ROUND((SUM(profit) / SUM(sales) * 100)::numeric, 2)  AS profit_margin
FROM superstore
GROUP BY region
ORDER BY total_profit DESC;

-- Results insight:
-- West leads in both sales ($725k) and profit ($108k) with 14.94% margin
-- Central has the lowest margin (7.92%) — nearly half of West
-- South has the smallest revenue volume ($391k)


-- ------------------------------------------------------------
-- QUERY 2: Revenue & Profit by State
-- Business question: Which states drive the most revenue?
-- Note: Great for map visualization in Tableau
-- Concepts: GROUP BY, SUM(), ROUND()
-- ------------------------------------------------------------
SELECT
    state,
    ROUND(SUM(sales)::numeric, 2)                        AS total_sales,
    ROUND(SUM(profit)::numeric, 2)                       AS total_profit,
    ROUND((SUM(profit) / SUM(sales) * 100)::numeric, 2)  AS profit_margin
FROM superstore
GROUP BY state
ORDER BY total_sales DESC;

-- Results insight:
-- California ($457k) and New York ($310k) are top revenue states
-- Texas ($170k sales) is losing money: -$25,729 profit (-15.12% margin)
-- Ohio, Pennsylvania, Illinois also unprofitable despite decent sales


-- ------------------------------------------------------------
-- QUERY 3: Top 5 and Bottom 5 States by Profit
-- Business question: Which states are most and least profitable?
-- Concepts: two CTEs, RANK() without PARTITION BY, UNION ALL
-- Note: No PARTITION BY needed here — we want global ranking across all states
--       PARTITION BY would restart rank at 1 for each state (only 1 row each)
-- ------------------------------------------------------------
WITH cte AS (
    SELECT
        state,
        ROUND(SUM(profit)::numeric, 2)              AS total_profit,
        RANK() OVER (ORDER BY SUM(profit) ASC)      AS profit_rank
    FROM superstore
    GROUP BY state
),
cte1 AS (
    SELECT
        state,
        ROUND(SUM(profit)::numeric, 2)              AS total_profit,
        RANK() OVER (ORDER BY SUM(profit) DESC)     AS profit_rank
    FROM superstore
    GROUP BY state
)
SELECT *, 'bottom' AS type FROM cte  WHERE profit_rank <= 5
UNION ALL
SELECT *, 'top'    AS type FROM cte1 WHERE profit_rank <= 5
ORDER BY type, profit_rank ASC;

-- Results insight:
-- BOTTOM 5 (losing money): Texas (-$25,729), Ohio (-$16,971), Pennsylvania (-$15,560)
-- TOP 5 (most profitable): California ($76,381), New York ($74,038), Washington ($33,402)
-- Texas has $170k in sales but loses money — likely due to heavy discounting
