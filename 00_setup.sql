-- ============================================================
-- PROJECT: E-commerce Sales Analysis (Sample Superstore)
-- FILE: 00_setup.sql
-- DESCRIPTION: Database setup and data preparation
--              Import CSV, rename columns to snake_case,
--              convert date columns to proper DATE type.
-- AUTHOR: Inna
-- DATE: 2026
-- ============================================================


-- ------------------------------------------------------------
-- STEP 1: Drop table if it already exists (safe re-run)
-- IF EXISTS prevents an error if the table doesn't exist yet
-- ------------------------------------------------------------
DROP TABLE IF EXISTS superstore;


-- ------------------------------------------------------------
-- STEP 2: Import CSV via DBeaver
-- Right-click on schema (public) → Import Data → CSV
-- Select: Sample - Superstore.csv
-- DBeaver auto-creates the table with original column names
-- Result: table "superstore" with 9,994 rows
-- ------------------------------------------------------------


-- ------------------------------------------------------------
-- STEP 3: Rename columns to snake_case
-- Original CSV headers contain spaces and hyphens (e.g. "Row ID", "Sub-Category")
-- which require double quotes in every query.
-- Renaming to snake_case (e.g. row_id, sub_category) makes
-- SQL cleaner and follows standard naming conventions.
-- ------------------------------------------------------------
ALTER TABLE superstore RENAME COLUMN "Row ID" TO row_id;
ALTER TABLE superstore RENAME COLUMN "Order ID" TO order_id;
ALTER TABLE superstore RENAME COLUMN "Order Date" TO order_date;
ALTER TABLE superstore RENAME COLUMN "Ship Date" TO ship_date;
ALTER TABLE superstore RENAME COLUMN "Ship Mode" TO ship_mode;
ALTER TABLE superstore RENAME COLUMN "Customer ID" TO customer_id;
ALTER TABLE superstore RENAME COLUMN "Customer Name" TO customer_name;
ALTER TABLE superstore RENAME COLUMN "Postal Code" TO postal_code;
ALTER TABLE superstore RENAME COLUMN "Product ID" TO product_id;
ALTER TABLE superstore RENAME COLUMN "Sub-Category" TO sub_category;
ALTER TABLE superstore RENAME COLUMN "Product Name" TO product_name;

-- Columns already in correct format (no changes needed):
-- segment, country, city, state, region, category,
-- sales, quantity, discount, profit


-- ------------------------------------------------------------
-- STEP 4: Convert date columns from TEXT to DATE
-- DBeaver imported order_date and ship_date as TEXT (VARCHAR)
-- because the CSV uses M/d/yyyy format (e.g. "11/8/2016").
-- We add clean DATE columns using TO_DATE(), then replace
-- the original text columns.
-- ------------------------------------------------------------

-- 4a: Add new DATE columns
ALTER TABLE superstore
ADD COLUMN order_date_clean DATE,
ADD COLUMN ship_date_clean DATE;

-- 4b: Convert text → DATE using TO_DATE()
-- MM/DD/YYYY format handles dates with and without leading zeros
UPDATE superstore
SET order_date_clean = TO_DATE(order_date, 'MM/DD/YYYY'),
    ship_date_clean  = TO_DATE(ship_date, 'MM/DD/YYYY');

-- 4c: Remove original text columns
ALTER TABLE superstore DROP COLUMN order_date;
ALTER TABLE superstore DROP COLUMN ship_date;

-- 4d: Rename clean columns to original names
ALTER TABLE superstore RENAME COLUMN order_date_clean TO order_date;
ALTER TABLE superstore RENAME COLUMN ship_date_clean TO ship_date;


-- ------------------------------------------------------------
-- STEP 5: Verify final table structure
-- Expected: 21 columns, snake_case names
-- order_date and ship_date should show type: date
-- ------------------------------------------------------------
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'superstore'
ORDER BY ordinal_position;


-- ------------------------------------------------------------
-- STEP 6: Verify row count
-- Expected: 9,994 rows
-- ------------------------------------------------------------
SELECT COUNT(*) AS total_rows FROM superstore;


-- ------------------------------------------------------------
-- STEP 7: Preview data
-- ------------------------------------------------------------
SELECT * FROM superstore LIMIT 5;
