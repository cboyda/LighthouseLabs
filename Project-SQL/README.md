# Final-Project-Transforming-and-Analyzing-Data-with-SQL

## Project/Goals
(fill in your description and goals here)

## Process
1. CSV import from 5 files
2. Tables created analytics(4,301,122 rows), all_sessions(15,134 rows), products(1,092), sales_by_sku(462 rows), sales_report(454 rows)
3. Cleaned Data which resulted in products(+2 new rows) and sales_by_sku(-6 unmatched rows)

```mermaid
graph TD;
    analytics.csv_448.7MB-->tbl_analytics_716MB-->4,301,122 rows;
    all_sessions.csv_3.9MB-->tbl_all_sessions_4.7MB;
    products.csv_0.069MB-->tbl_products_0.2MB;
    sales_by_sku_0.007MB-->tbl_sales_by_sku_0.08MB;
    sales_report_0.034MB-->tbl_sales_report_0.12MB;
```

## Results
(fill in what you discovered this data could tell you and how you used the data to answer those questions)

## Challenges 
(discuss challenges you faced in the project)

## Future Goals
(what would you do if you had more time?)
