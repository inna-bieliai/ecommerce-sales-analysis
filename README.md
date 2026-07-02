# 📊 E-commerce Sales Analysis | Sample Superstore

## Project Overview
End-to-end data analysis project exploring sales performance, profitability, and customer behavior using the Sample Superstore dataset. The analysis covers 4 years of data (2014–2017) with 9,994 orders across the United States.

**Tools used:** PostgreSQL · SQL (DBeaver) · Tableau

---

## 🎯 Business Questions
- Which product categories and sub-categories drive the most revenue and profit?
- Is the business growing year-over-year? Are there seasonal patterns?
- Which regions and states are most and least profitable?
- Which customer segments generate the most value?
- What is causing losses — and how do discounts impact profitability?

---

## 📁 Project Structure

```
ecommerce-sales-analysis/
├── README.md
├── insights.md
└── sql/
    ├── 00_setup.sql
    ├── 01_eda.sql
    ├── 02_category_performance.sql
    ├── 03_sales_trends.sql
    ├── 04_regional_performance.sql
    ├── 05_customer_segments.sql
    └── 06_underperformers.sql
```

---

## 📊 Tableau Dashboards

**Dashboard 1 — Sales & Profitability Analysis:**
https://public.tableau.com/app/profile/inna.bieliai/viz/superstore1_17822889555960/SalesProfitabilityAnalysisSampleSuperstore
**Dashboard 2 — Customer & Discount Analysis:**
https://public.tableau.com/app/profile/inna.bieliai/viz/superstore2_17822902645390/CustomerDiscountAnalysis
---

## 🔍 Key Findings

1. **Technology leads in profitability** — 17.4% profit margin vs 2.5% for Furniture
2. **Business is growing** — Sales grew +29% in 2016 and +20% in 2017 after a slight dip in 2015
3. **Q4 is peak season** — November and December consistently drive the highest revenue every year
4. **Tables and Bookcases are loss-making** — Despite $206K in sales, Tables generate -$17,725 in losses
5. **Discounts above 20% are unprofitable** — Clear breaking point between 20% and 30% discount
6. **Texas is a major problem** — $170K in sales but -$25,729 in losses (-15% margin)
7. **Sean Miller paradox** — Top customer by sales ($25K) but unprofitable due to 50% discount on a $22K order

---

## 💡 Business Recommendations

- **Stop discounting above 20%** — every discount tier above 20% results in losses
- **Review Furniture pricing strategy** — Tables and Bookcases need price adjustment or discontinuation
- **Focus on Technology** — highest margin category with strong growth potential
- **Invest in West region** — highest profit margin (14.9%) and sales volume
- **Investigate Central region** — lowest margin (7.9%) despite decent sales volume

---

## 📋 Dataset
- **Source:** [Sample Superstore — Kaggle](https://www.kaggle.com/datasets/vivek468/superstore-dataset-final)
- **Period:** January 2014 — December 2017
- **Size:** 9,994 rows · 21 columns
- **Key fields:** Order Date, Category, Sub-Category, Product Name, Sales, Profit, Discount, Region, Segment

---

## 🛠️ SQL Concepts Used
- `GROUP BY` with aggregate functions (`SUM`, `COUNT`, `AVG`, `ROUND`)
- `HAVING` for post-aggregation filtering
- Common Table Expressions (`WITH ... AS`)
- Window Functions: `RANK() OVER (PARTITION BY ...)`, `LAG()` for YoY growth
- `EXTRACT()` for date parts
- `UNION ALL` for combining result sets
- Type casting (`::numeric`) for precise calculations
- `TO_DATE()` for text-to-date conversion
