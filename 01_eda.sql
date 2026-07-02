-- ============================================================
-- PROJECT: E-commerce Sales Analysis (Sample Superstore)
-- FILE: 01_eda.sql
-- DESCRIPTION: Exploratory Data Analysis (EDA)
--              Getting familiar with the dataset before analysis:
--              unique values, date range, key business metrics.
-- AUTHOR: Inna
-- DATE: 2026
-- ============================================================


-- ------------------------------------------------------------
-- QUERY 1: Count of unique values per key column
-- Business question: What dimensions does this dataset have?
-- ------------------------------------------------------------
SELECT
    COUNT(DISTINCT category)     AS unique_categories,
    COUNT(DISTINCT sub_category) AS unique_sub_categories,
    COUNT(DISTINCT region)       AS unique_regions,
    COUNT(DISTINCT segment)      AS unique_segments
FROM superstore;

-- Results: 3 categories, 17 sub-categories, 4 regions, 3 segments


-- ------------------------------------------------------------
-- QUERY 2: Date range of the dataset
-- Business question: What time period does this data cover?
-- ------------------------------------------------------------
SELECT
    MIN(order_date) AS first_order,
    MAX(order_date) AS last_order
FROM superstore;

-- Results: 2014-01-03 → 2017-12-30 (4 years of data)


-- ------------------------------------------------------------
-- QUERY 3: Key business metrics overview
-- Business question: What is the overall size of this business?
-- Concepts: SUM(), COUNT(DISTINCT), ROUND(), ::numeric cast
-- ------------------------------------------------------------
SELECT
    ROUND(SUM(sales)::numeric, 2)    AS total_sales,
    ROUND(SUM(profit)::numeric, 2)   AS total_profit,
    COUNT(DISTINCT order_id)         AS total_orders,
    COUNT(DISTINCT customer_id)      AS total_customers
FROM superstore;

-- Results:
-- Total Sales:     $2,297,220
-- Total Profit:    $286,396
-- Total Orders:    5,009
-- Total Customers: 793
-- Profit Margin:   ~12.5%
