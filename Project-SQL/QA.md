# Part 5: QA Your Data

<details>
<summary>from [Project-SQL/assignment.md](https://github.com/cboyda/LighthouseLabs/blob/fc95cb5355aa7df9dd06aae010d5fd1404754fed/Project-SQL/assignment.md)</summary>

In the QA.md file, identify and describe your risk areas. Develop and execute a QA process to address them and validate the accuracy of your results. Provide the SQL queries used to execute the QA process.
</details>

<details>
<summary>from [Project-SQL/instructional_guidelines.md](https://github.com/cboyda/LighthouseLabs/blob/bbdaf3b7f368d49c5bdac28d43da7e8ab374e4a2/Project-SQL/instructional_guidelines.md)</summary>
QA.md file
    Identify and describe your risk areas
    Develop and execute a QA process to address the risk areas identified, providing the SQL queries used to implement
</details>
  
What are your risk areas? Identify and describe them.



QA Process:
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

As issues that were found were documented in https://github.com/cboyda/LighthouseLabs/blob/66c535757e829fedce9e2e5b0520b290108df5ab/Project-SQL/cleaning_data.md but more importantly steps were placed to ensure data integrity was maintained into the future.
	
A great example is #5 on that page, where foreign key constraints were integrated to make the JOIN more effective. 
	
The FULL list of fixes is included in https://github.com/cboyda/LighthouseLabs/blob/0af877b6641cc14c155db88b8b63c905e8a5b81e/Project-SQL/project1-postgresql.sql

This was also created in case the data/imported tables was corrupted and needed to be redone.

Another great example is the lack of foreign key constraints between all_sessions and products, based on key.

```
SELECT als.productSKU AS all_sessions_sku, p.SKU AS products_sku
FROM all_sessions AS als
LEFT JOIN products AS p ON als.productSKU = p.SKU
WHERE p.SKU IS NULL OR als.productSKU IS NULL OR p.SKU <> als.productSKU
-- RETURNS 2033
```

* FIND: this means there are 2033 productSKU's in all_sessions that are missing from the Products table.
* FIX: we could add these to the Products table
* FUTURE PROOF: add constraint so that any drops or alters of SKU's in the product (primary key) would CASCADE to all_sessions
	
This was not done, but would be recommended.
	
</details>
	
Continually working on this section with the data.  Prioritized data needed for queries / questions first but this part can be continually improved.
Process includes focusing on the [The Six Primary Dimensions for Data Quality Assessment](https://www.sbctc.edu/resources/documents/colleges-staff/commissions-councils/dgc/data-quality-deminsions.pdf):
<details>
<summary>1. Consistency</summary>

	* some leading "blanks" found in product name. see see #14a in [part 2: data cleaning](https://github.com/cboyda/LighthouseLabs/blob/17c9667c9f014c57f8b5ab6c9b8ce9820a70c658/Project-SQL/cleaning_data.md)
	* after foreign keys defined, take steps to maintain consistency with CASCADE on update/delete (specifically for productSKU)
</details>
<details>
<summary>2. Accuracy</summary>

	* definitions of `normal values` required - ASK SME!
</details>
<details>
<summary>3. Validity</summary>

	* sentiment score NOT NULL constraint required IMPUTING see #11 in [part 2: data cleaning](https://github.com/cboyda/LighthouseLabs/blob/17c9667c9f014c57f8b5ab6c9b8ce9820a70c658/Project-SQL/cleaning_data.md)
</details>
<details>
<summary>4. Uniqueness</summary>

	* assigning primary keys to EVERY table
	* set foreign key CONSTRAINTS where applicable
		* connect sales_by_sku.productSKU to products.SKU with CONSTRAINT see #5 in [part 2: data cleaning](https://github.com/cboyda/LighthouseLabs/blob/17c9667c9f014c57f8b5ab6c9b8ce9820a70c658/Project-SQL/cleaning_data.md)
		* note all_sessions.productSKU does have many that are still missing in products.SKU = ASK SME!
</details>
<details>
<summary>5. Completeness</summary>

</details>
<details>
<summary>6. Timeliness</summary>

	* we have no timeline as to how often this data will be updated (refreshed) = ASK SME!
</details>
	
Unfortunately it is not possible to do any automated testing or be 100% thorough without more knowledge about this specific data; **SME input required**.

