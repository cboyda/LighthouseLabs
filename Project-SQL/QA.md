# Part 5: QA Your Data

<details>
<summary>from ![Project-SQL/assignment.md](https://github.com/cboyda/LighthouseLabs/blob/main/Project-SQL/assignment.md)</summary>

In the QA.md file, identify and describe your risk areas. Develop and execute a QA process to address them and validate the accuracy of your results. Provide the SQL queries used to execute the QA process.
</details>

<details>
<summary>from [Project-SQL/instructional_guidelines.md](https://github.com/cboyda/LighthouseLabs/blob/main/Project-SQL/instructional_guidelines.md)</summary>
QA.md file
    Identify and describe your risk areas
    Develop and execute a QA process to address the risk areas identified, providing the SQL queries used to implement
</details>
  
## What are your risk areas? Identify and describe them.

| # | Data Quality Risks                                          | Probability   | Impact | Potential Risk Mitigation Tasks                                            |
|---|-------------------------------------------------------------|--------|--------|--------------------------------------------------------------------------|
| 1 | SOURCE DATA QUALITY IN DOUBT                                      | High | High   | - Inaccuracies, omissions, cleanliness, and inconsistencies in the source data should be identified and resolved before or during the extract / transform process<BR>- Often, specific data elements exist on multiple source systems. Identify the various sources and discuss with the users which are the most applicable <br>- Data integrity is necessary on data being input into the system, not just at the transform stage
| 2 | SOURCE & TARGET DATA MAPS SUSPECT                                  | Medium | High   | - Data dictionaries should be developed and maintained to support all data associated with the project. Quality data mapping documents may be the result. |
| 3 | DATA DICTIONARIES AND DATA MODELS ARE LACKING                                 | Medium | High   | - Ensure accurate and current documentation of data models and mapping documents<BR>- Create meaningful documentation of data definitions and data descriptions in a data dictionary<BR>- Provide training to QA team by data stewards/ owners |
	

## QA Process:
	
Describe your QA process and include the SQL queries used to execute it.

<details>
<summary> A. Investigate the value of sales_by_sku and sales_report tables.</summary>

I was trying to answer Question 1 a different way, looking at the relationship between products and these 2 tables.

```
SELECT 
	p.SKU,
	sbs.total_ordered as sales_sku_total_ordered,
	sr.total_ordered as sales_report_total_ordered
FROM
	products AS p
	JOIN sales_by_sku AS sbs ON p.SKU = sbs.productsku
	JOIN sales_report AS sr ON p.SKU = sr.productsku;
```

RETURNS

| sku            | total_ordered | total_ordered-2 |
|----------------|---------------|-----------------|
| GGOEGAAX0581   | 0             | 0               |
| 9181139        | 0             | 0               |
| GGOEGAAX0596   | 1             | 1               |
| GGOEGAAX0365   | 0             | 0               |
| GGOEGAAX0325   | 6             | 6               |
| GGOEGAAX0296   | 0             | 0               |
| GGOEGHGH019699 | 14            | 14              |
| GGOEGDWR015799 | 5             | 5               |
| GGOEGAAX0081   | 42            | 42              |
| GGOEGALB036514 | 8             | 8               |

Hypothesis if total_ordered are the same in sales_by_sku and sales_report
but the number of rows is different which productSKU's are missing between them?

```
SELECT sbs.productsku AS missing_sku
FROM sales_by_sku AS sbs
LEFT JOIN sales_report AS sr ON sbs.productsku = sr.productsku
WHERE sr.productsku IS NULL;

-- RETURNS
-- "missing_sku"
-- "GGOEYAXR066128"
-- "GGOEGALJ057912"
```

```
select * from sales_by_sku where productsku = 'GGOEYAXR066128' OR productsku = 'GGOEGALJ057912';

-- RETURNS
-- "salesbysku_id"	"productsku"	"total_ordered"
-- 166				"GGOEYAXR066128"	3
-- 239				"GGOEGALJ057912"	2
```

This leads me to want to DROP the sales_report table because it has 2 less SKU's
but it has a column called ratio that is missing from sales_by_sku
Since we want to limit any destructive losses, no tables dropped but definately a future discussion.

Let's just double check and see if they are all the same data

```
SELECT sbs.productSKU, sbs.total_ordered AS sales_by_sku_total_ordered, sr.total_ordered AS sales_report_total_ordered
FROM sales_by_sku AS sbs
JOIN sales_report AS sr ON sbs.productSKU = sr.productSKU
WHERE sbs.total_ordered <> sr.total_ordered;
-- RETURNS NOTHING so every SKU has the same total_ordered in both tables 
-- EQUALS redundant columns CONFIRMED
```

### CONCERN:
What are these values actually reporting? 
**Illustrates why you need a SME to make sense of the data!
</details>

<details>
<summary> B. Question meaning of products.ordered_quantity.</summary>

Further to the need to clarify the meaning of the data with a subject matter expert (SME) the name/data 
does not make sense for products.ordered_quantity vs the sales_by_sku or sales_report total_ordered.

```
SELECT 
	p.SKU,
	p.orderedquantity as product_ordered_quantity,
	sbs.total_ordered as sales_sku_total_ordered,
	sr.total_ordered as sales_report_total_ordered
FROM
	products AS p
	JOIN sales_by_sku AS sbs ON p.SKU = sbs.productsku
	JOIN sales_report AS sr ON p.SKU = sr.productsku;
```
RETURNS

| sku           | product_ordered_quantity | sales_sku_total_ordered | sales_report_total_ordered |
|---------------|--------------------------|-------------------------|-----------------------------|
| GGOEGAAX0581  | 0                        | 0                       | 0                           |
| 9181139       | 0                        | 0                       | 0                           |
| GGOEGAAX0596  | 26                       | 1                       | 1                           |
| GGOEGAAX0365  | 65                       | 0                       | 0                           |
| GGOEGAAX0325  | 53                       | 6                       | 6                           |
| GGOEGAAX0296  | 19                       | 0                       | 0                           |
| GGOEGHGH019699 | 1573                     | 14                      | 14                          |

	
### How is products ORDERED QUANTITY larger than sales_by_sku or sales_report TOTAL ordered?

</details>

	
<details>
<summary> C. Find, Fix THEN Future Proof</summary>

As [issues](https://github.com/cboyda/LighthouseLabs/blob/main/Project-SQL/cleaning_data.md) were found they were documented.  Most importantly steps were also taken to ensure data integrity was maintained into the future.
	
* A great example is #5 on that page, where foreign key constraints were integrated to make the JOIN more effective. 
	
Another great example is the lack of foreign key constraints between all_sessions and products, based on key.
	
```
-- find mismatched all_sessions.productSKUs not in the products table
SELECT *
FROM all_sessions ass
LEFT JOIN products p ON ass.productSKU = p.SKU
WHERE p.SKU IS NULL
ORDER BY ass.productSKU;
-- returns 2033 but with DUPLICATES of productSKU

SELECT DISTINCT ass.productSKU
FROM all_sessions ass
LEFT JOIN products p ON ass.productSKU = p.SKU
WHERE p.SKU IS NULL
ORDER BY ass.productSKU;
-- returns 147 unique productSKU's in all_sessions and MISSING in products table
```

* FIND: this means there are 147 unique productSKU's in all_sessions that are missing from the Products table.  This affects 2,033 rows in all_sessions.
* FIX: we could add these to the Products table manually
* FUTURE PROOF: add constraint so that any drops or alters of SKU's in the product (primary key) would CASCADE to all_sessions OR instead of deleting future produt SKU's add active/inactive boolean field.
	
This was not done, but would be recommended.
	
NOTE: A FULL list of fixes is included in [SQL step-by-step creation and cleaning queries](https://github.com/cboyda/LighthouseLabs/blob/main/Project-SQL/project1-postgresql.sql)  This was also created in case the data/imported tables was corrupted and needed to be redone.

	
</details>

### QA Goals
Continually working on this section with the data.  Prioritized data needed for queries / questions first but this part can be continually improved.
Process includes focusing on the [The Six Primary Dimensions for Data Quality Assessment](https://www.sbctc.edu/resources/documents/colleges-staff/commissions-councils/dgc/data-quality-deminsions.pdf):
<details>
<summary>1. Consistency</summary>

* some leading "blanks" found in product name. see see #14a in [part 2: data cleaning](https://github.com/cboyda/LighthouseLabs/blob/main/Project-SQL/cleaning_data.md)
* after foreign keys defined, take steps to maintain consistency with CASCADE on update/delete (specifically for productSKU)
</details>
<details>
<summary>2. Accuracy</summary>

* definitions of `normal values` required - ASK SME!
</details>
<details>
<summary>3. Validity</summary>

* sentiment score NOT NULL constraint required IMPUTING see #11 in [part 2: data cleaning](https://github.com/cboyda/LighthouseLabs/blob/main/Project-SQL/cleaning_data.md)
</details>
<details>
<summary>4. Uniqueness</summary>

* assigning primary keys to EVERY table
* set foreign key CONSTRAINTS where applicable
* connect sales_by_sku.productSKU to products.SKU with CONSTRAINT see #5 in [part 2: data cleaning](https://github.com/cboyda/LighthouseLabs/blob/main/Project-SQL/cleaning_data.md)
* note all_sessions.productSKU does have many that are still missing in products.SKU = ASK SME!
</details>
<details>
<summary>5. Completeness</summary>

* all_sessions.currencyCode for Countries='United States' were blank.  I assumed the USA uses USD for their currency, see #14f in [part 2: data cleaning](https://github.com/cboyda/LighthouseLabs/blob/main/Project-SQL/cleaning_data.md) for the details of the steps taken for the fix
</details>
<details>
<summary>6. Timeliness</summary>

* we have no timeline as to how often this data will be updated (refreshed) = ASK SME!
</details>
	
Unfortunately it is not possible to do any automated testing or be 100% thorough without more knowledge about this specific data; **SME input required**.

