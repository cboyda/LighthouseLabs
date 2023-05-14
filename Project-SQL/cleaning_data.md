# cleaning_data.md file
# Part 2: Data Cleaning
<details>
	<summary> Instructions from Project-SQL/instructional_guidelines.md</summary>
--    Fill out this file with a description of the issues that will be addressed by cleaning the data
--    Include the queries used to clean the data
</details>

<details>
	<summary> Instructions from Project-SQL/assignment.md</summary>
As always, once you have received any dataset, your first task is to orient yourself to the data contained within. While exploring the data, you should keep an eye out for any of potential data issues that need to be cleaned.
Cleaning hint: The unit cost in the data needs to be divided by 1,000,000.
Apart from this, did you see any other issue that requires cleaning? Be sure to take the time upfront to address them.
In your copy of the cleaning_data.md file, describe what issues you addressed by cleaning the data and provide the queries you executed to clean the data.
</details>    

What issues will you address by cleaning the data?
- [X] 0. The unit cost in the data needs to be divided by 1,000,000.
- [X] 1. Find all fields with any NULL values in ALL tables.
- [X] 2. Check analytics.bounces violates not-null constraint, FIXED in 1(d)
- [X] 3. Check analytics.pageviews violates not-null constraint, FIXED in 1(b)
- [X] 4. Investigate why analytics.units_sold as STRING instead of expected NUMERIC?
- [X] 5. Attempt to Enforce Foreign key reference failed in Table sales_by_sku.productSKU referring to products.SKU
- [X] 6. Investigate analytics.fullvisitorId is NUMERIC so why is all_sessions.fullvisitorId as VARCHAR?
- [ ] 7. Consider NUMERIC fields with null to 0 for easier math. all_sessions.totaltransationrevenue, all_sessions.transactions, all_sessions.sessionqualitydim, all_sessions.productrefundamount, all_sessions.productquantity, all_sessions.productrevenue, all_sessions.itemquantity, all_sessions.itemrevenue, all_sessions.transactionrevenue; not modified as math unaffected and too time consuming. Benefit for possible optimization in future.
- [X] 8. Investigate all_sessions.itemrevenue is STRING when revenue should probably be NUMERIC.
- [X] 9. Investigate purpose of all_sessions.column28. Is this empty? Bad data import?
- [X] 10. Investigate all_sessions.visitid and analytics.visitid.  Is this a join?
- [X] 11. Check products.sentimentscore violates not-null constraint, should these be zero? FIXED in 1(f)
- [X] 12. Check products.sentimentmagnitude violates not-null constraint, should these be zero? FIXED in 1(g)
- [X] 13. Investigate DUPLICATE fields sales_report.name, sales_report.stockLevel, sales_report.restockingLeadTime, sales_report.sentimentScore, sales_report.sentimentMagnitude in both products and sales_reports TABLE?  
- [ ] 14. Investigate individual values in the tables, any individual field data needed?




# Queries:
Below, provide the SQL queries you used to clean your data.
File project1-postgresgl.sql is the full creation, then cleaning file.  Just remember to only run the cleaning component AFTER the data has been imported.

<details>
<summary> 0. The unit cost in the data needs to be divided by 1,000,000.</summary>

There is no 'unit cost' field.  
Following the assignment instructions and assuming they meant analytics.unit_price dividing by 1 million using:

```
UPDATE analytics
SET unit_price=ROUND(unit_price/1000000,2);
-- UPDATE 4301122
-- Query returned successfully in 1 min 5 secs.
```
### I definately do NOT agree with this assignment requirement.
See https://stackoverflow.com/questions/15726535/which-datatype-should-be-used-for-currency 
Specifically:

Your choices [for money] are:

* bigint : store the amount in cents. This is what EFTPOS transactions use.
* decimal(12,2) : store the amount with exactly two decimal places. This what most general ledger software uses.
* float : terrible idea - inadequate accuracy. This is what naive developers use.

For example: $5,123.56 can be stored as 5123560000 microdollars (which was the original format!)
* Simple to use and compatible with every language.
* Enough precision to handle fractions of a cent.
* Works for very small per-unit pricing (like ad impressions or API charges).
* Smaller data size for storage than strings or numerics.
* Easy to maintain accuracy through calculations and apply rounding at the final output.
	
</details>

<details>
<summary> 1. Find all fields with any NULL values in ALL tables., then decide how to proceed with them. </summary>

QUERY:
Credit: https://stackoverflow.com/questions/17678635/list-all-tables-in-postgres-that-contain-a-boolean-type-column-with-null-values
```
DO $$
DECLARE
   rec    RECORD;
   _found BOOLEAN;
BEGIN
   FOR rec IN 
      SELECT format('SELECT TRUE FROM %s WHERE %I IS NULL LIMIT 1'
                   , c.oid::regclass, a.attname) AS qry_to_run
            , c.oid::regclass AS tbl
            , a.attname       AS col
            , a.atttypid      AS datatype
      FROM   pg_namespace n 
      JOIN   pg_class     c ON c.relnamespace = n.oid 
      JOIN   pg_attribute a ON a.attrelid = c.oid
      WHERE  n.nspname <> 'information_schema'
      AND    n.nspname NOT LIKE 'pg_%'  -- exclude system, temp, toast tbls
      AND    c.relkind = 'r'
      AND    a.attnum > 0
      AND    a.attnotnull = FALSE
      AND    a.attisdropped = FALSE

   LOOP
      EXECUTE rec.qry_to_run INTO _found;

      IF _found THEN
         RAISE NOTICE 'Table % has NULLs in the % field of type %'
                      , rec.tbl, rec.col, rec.datatype::regtype;
      END IF;
   END LOOP;
END
$$;
```
RETURNS:
```
a) NOTICE:  Table analytics has NULLs in the userid field of type numeric
b) NOTICE:  Table analytics has NULLs in the pageviews field of type integer
c) NOTICE:  Table analytics has NULLs in the timeonsite field of type numeric
d) NOTICE:  Table analytics has NULLs in the bounces field of type integer
e) NOTICE:  Table analytics has NULLs in the revenue field of type numeric

f) NOTICE:  Table products has NULLs in the sentimentscore field of type numeric
g) NOTICE:  Table products has NULLs in the sentimentmagnitude field of type numeric

h) NOTICE:  Table sales_report has NULLs in the ratio field of type numeric

i) NOTICE:  Table all_sessions has NULLs in the totaltransactionrevenue field of type numeric
j) NOTICE:  Table all_sessions has NULLs in the transactions field of type numeric
k) NOTICE:  Table all_sessions has NULLs in the timeonsite field of type integer
l) NOTICE:  Table all_sessions has NULLs in the sessionqualitydim field of type integer
m) NOTICE:  Table all_sessions has NULLs in the productrefundamount field of type numeric
n) NOTICE:  Table all_sessions has NULLs in the productquantity field of type integer
o) NOTICE:  Table all_sessions has NULLs in the productrevenue field of type numeric
p) NOTICE:  Table all_sessions has NULLs in the itemquantity field of type integer
q) NOTICE:  Table all_sessions has NULLs in the transactionrevenue field of type numeric
```

## a) analytics.userid (NULL)
QUERY:
```
select 
	count(*),
	userid
from 
	analytics
where
	userid is null
group by 
	userid;
```
	RETURNS 4,301,122 (aka 100% of rows = ALL).
	THEREFORE since results in ALL records are NULL.  No fix applied since this seems to be universally missing data for all rows.

## b) analytics.pageviews (NULL)
QUERY:
```
select 
	count(*),
	pageviews
from 
	analytics
where
	pageviews is null
group by 
	pageviews;
```
	RETURNS 72.
	THEREFORE assuming these 72 are equivalent to 0 and applying fix.

QUERY for FIX:
```
UPDATE analytics
SET pageviews=0
WHERE pageviews IS NULL;
```
	Now we can do math on the pageviews column.  Could consider ALTER TABLE for field constraint NOT NULL?

## c) analytics.timeonsite (NULL)
QUERY:
```
select 
	count(*),
	timeonsite
from 
	analytics
where
	timeonsite is null
group by 
	timeonsite;
```
	RETURNS: 477,465.  This this affects 11% of rows, too many to consider deleting data (>5%), IGNORING.

## d) analytics.bounces (NULL)
QUERY:
```
select 
	count(*),
	bounces
from 
	analytics
where
	bounces is null
group by 
	bounces;
```
	RETURNS 3,826,283 ~89% of all rows.  With minimum value currently at 1, These null could be considered equivalent to 0 and apply fix.

QUERY for FIX:
```
UPDATE analytics
SET bounces=0
WHERE bounces IS NULL;
```
	UPDATE 3826283
	Query returned successfully in 58 secs 797 msec.

Now we can do math on the bounces column.  Could consider ALTER TABLE for field constraint NOT NULL?

## e) analytics.revenue (NULL)
QUERY:
```
select 
	count(*),
	revenue
from 
	analytics
where
	revenue is null
group by 
	revenue;
```
	RETURNS 4,285,767 ~99.64% of all rows. 15,355 rows have values that are not NULL.	
	IGNORING (but could have replaced NULL with 0). No FIX applied.


## f) products.sentimentscore (NULL)
QUERY:
```
select 
	count(*),
	sentimentscore
from 
	products
where
	sentimentscore is null
group by 
	sentimentscore;
```
	RETURNS 1 row.
	Tried looking in sales_graph for sentimentscore of productSKU = GGADFBSBKS42347 but this didn't exist in that table.
	This single row has SKU GGADFBSBKS42347 with name 'PC gaming speakers' found from query:
```
select SKU from products where sentimentscore is null;
```
	Since there is already 72 rows with 0 as sentiment found from query:
```
select count (*) from products where sentimentscore = 0;
```
	I can only assume this is a neutral and valid data and making best assessment to assign 0 instead of NULL to this single row.
QUERY for FIX:
```
UPDATE products
SET sentimentscore=0
WHERE sentimentscore IS NULL;
```
	UPDATE 1
	Query returned successfully in 198 msec.

Now we can do math on the sentimentscore column.  Could consider ALTER TABLE for field constraint NOT NULL?	

## g) products.sentimentmagnitude (NULL)
QUERY:
```
select 
	count(*),
	sentimentmagnitude
from 
	products
where
	sentimentmagnitude is null
group by 
	sentimentmagnitude;
```
	RETURNS 1 row.
	Tried looking in sales_graph for sentimentscore of productSKU = GGADFBSBKS42347 but this didn't exist in that table.
	This single row has SKU GGADFBSBKS42347 with name 'PC gaming speakers' found from query:
```
select SKU from products where sentimentmagnitude is null;
```
	There is NO rows with 0 as sentimentmagnitude found from query:
```
select count (*) from products where sentimentmagnitude = 0;
```
	So we look at the range found from query:
```
select min(sentimentmagnitude),max(sentimentmagnitude) from products;
```
	minimum: 0.1 with maximum 2.0 (as range of sentimentmagnitude).  Since sentimentmagnitude is often multiplied with the sentimentscore (which we know is zero) then this could be any value, assigning 0.1 as the smallest sentimentmagnitude and therefore impact to our calculations.
QUERY for FIX:
```
UPDATE products
SET sentimentmagnitude=0.1
WHERE sentimentmagnitude IS NULL;
```
	UPDATE 1
	Query returned successfully in 136 msec.

Now we can do math on the sentimentmagnitude column.  Could consider ALTER TABLE for field constraint NOT NULL?

h) sales_report.ratio (NULL)
QUERY:
```
select 
	count(*),
	ratio
from 
	sales_report
where
	ratio is null
group by 
	ratio;
```
	RETURNS 78 rows. Since we do not know what this ratio calcuation is, leaving these NULL values as-is. No FIX applied.

## i thru q) all_sessions.[field_name] (NULL)
	Without definitions of what these values are, ignoring these columns and leaving these NULL values as-is. No FIX applied.
</details>

<details>
<summary> 4. Investigate why analytics.units_sold as STRING instead of expected NUMERIC? </summary>
Investigative query:
	
```
select count(*) from analytics where units_sold ='';
-- returns 4,205,975
```

Apply FIX:
```
-- FIX for #4
UPDATE analytics
SET units_sold=0
WHERE units_sold ='';
-- UPDATE 4205975
-- Query returned successfully in 55 secs 886 msec.
```

Check if any other fixes required?
```
select count(*) from analytics Where units_sold::integer > 0;
-- returns 95,146
-- adding 4205975 = 4301121 = 100% of our rows
-- now that "" are 0's we can modify the field type
```

Now modify column type to appropriate NUMERIC field:
```
ALTER TABLE public.analytics ALTER COLUMN units_sold TYPE integer USING units_sold::integer;
```
	
COLUMN FIXED.
</details>

<details>
<summary> 5. Attempt to Enforce Foreign key reference failed in Table sales_by_sku.productSKU referring to products.SKU </summary>

Starting the search for the problem rows.

```
-- Find mismatched rows
SELECT * 
FROM sales_by_sku as sk
WHERE NOT EXISTS (
  SELECT * FROM products 
  WHERE products.SKU = sk.productSKU
);
-- returns 8 rows
-- "salesbysku_id"	"productsku"	"total_ordered"
-- 166				"GGOEYAXR066128"	3
-- 239				"GGOEGALJ057912"	2
-- 320				"9180753"			0
-- 407				"9184677"			0
-- 418				"9184663"			0
-- 426				"9182763"			0
-- 427				"9182779"			0
-- 445				"9182182"			0
```

Let's look for hints to see if we can create them in the products table manually...

```
select * from products where SKU like 'GGOEGALJ0579%';
-- probably this same name
--  "sku"	"name"	"orderedquantity"	"stocklevel"	"restockingleadtime"	"sentimentscore"	"sentimentmagnitude"
-- "GGOEGALJ057914"	" Women's Short Sleeve Performance Tee Charcoal"	11	14	17	0.3	0.5
-- "GGOEGALJ057913"	" Women's Short Sleeve Performance Tee Charcoal"	6	11	10	0.8	1.2
-- "GGOEGALJ057915"	" Women's Short Sleeve Performance Tee Charcoal"	6	11	16	0.8	1.3
select * from products where SKU like 'GGOEYAXR066%';
-- probably this same name
-- "sku"	"name"	"orderedquantity"	"stocklevel"	"restockingleadtime"	"sentimentscore"	"sentimentmagnitude"
-- "GGOEYAXR066155"	" Toddler Short Sleeve Tee Red"	6	7	14	0.3	0.5
-- "GGOEYAXR066130"	" Toddler Short Sleeve Tee Red"	3	4	17	0.3	0.5
-- "GGOEYAXR066129"	" Toddler Short Sleeve Tee Red"	4	7	17	0.7	1.1
```

But now the other productSKU's are not an easy guess.
```
select * from products where SKU like '918075%';
-- harder to guess
-- "sku"	"name"	"orderedquantity"	"stocklevel"	"restockingleadtime"	"sentimentscore"	"sentimentmagnitude"
-- "9180757"	"Yoga Block"	0	0	13	0.1	0.3
-- "9180759"	" Lunch Bag"	0	0	6	0.5	0.8
-- "9180754"	"8 pc Android Sticker Sheet"	0	0	13	0.5	0.8
-- "9180756"	"Windup Android"	0	0	6	0.7	1.1
```
Since these SKU's are harder to recreate manually and have total_ordered = 0 I consider these perfect to be dropped.

Personal preference would be to DROP these mismatched 6 rows (with 0 totla_ordered) and recreate the 2 rows with total_ordered.  It doesn't seem like much data lost and then we would gain full relationship integrity between PRODUCTS and SALES_BY_SKU tables, which makes future queries much easier. 

FIX QUERY to manually create the 2 new productskus GGOEYAXR066128 and GGOEGALJ057912:
```
INSERT INTO products (sku, name, orderedquantity, stocklevel, restockingleadtime, sentimentscore, sentimentmagnitude) 
VALUES ('GGOEYAXR066128', ' Toddler Short Sleeve Tee Red',0,0,0,0,0.1);
INSERT INTO products (sku, name, orderedquantity, stocklevel, restockingleadtime, sentimentscore, sentimentmagnitude) 
VALUES ('GGOEGALJ057912', ' Women''s Short Sleeve Performance Tee Charcoal',0,0,0,0,0.1);
```

FIX Remove 6 unecessary SKU's from sales_by_sku:
```
DELETE FROM sales_by_sku where productsku IN('9180753','9184677','9184663','9182763','9182779','9182182');	
```

TABLE sales_by_sku now has a total of 456 rows.

Now we can ADD the foreign key constraint, between PRODUCTS and SALES_BY_SKU for easier future queries and relationships!
```
ALTER TABLE public.sales_by_sku ADD CONSTRAINT sales_by_sku_fk FOREIGN KEY (productsku) REFERENCES public.products(sku) ON DELETE CASCADE ON UPDATE CASCADE;
```

FIX APPLIED, Foreign Key created!
</details>

<details>
<summary> 6. Investigate analytics.fullvisitorId is NUMERIC so why is all_sessions.fullvisitorId as VARCHAR?</summary>

This was just a typo when table was created.  Easy fix, change datatype to match with query:

```
ALTER TABLE public.all_sessions ALTER COLUMN fullvisitorid TYPE numeric USING fullvisitorid::numeric;
```

Oddly none of fullvisitorid matches eachother (between analytics and all_sessions tables), they must be uniquely generated.
```
SELECT COUNT(*) FROM analytics
JOIN all_sessions ON analytics.fullvisitorid = all_sessions.fullvisitorid;
-- returns 0
SELECT COUNT(*) FROM all_sessions
JOIN analytics USING(fullvisitorid);
-- returns 0
```

Also corrected CREATE TABLE initial code to ensure this problem doesn't reoccur.
</details>

<details>
<summary> 8. Investigate all_sessions.itemrevenue is STRING when revenue should probably be NUMERIC. </summary

Checking for any number data in all_sessions.itemrevenue, 0 found.
Checking for any non-numeric data in all_sessions.itemvenue, 15,134 found but they are all just blank "" fields.
Converting blanks to zeros using:
	
```
UPDATE all_sessions
SET itemrevenue=0
WHERE itemrevenue ='';
-- UPDATE 15134
-- Query returned successfully in 317 msec.
```
	
Now we have a numerical value instead of a string, so we can convert datatype with:

```
ALTER TABLE public.all_sessions ALTER COLUMN itemrevenue TYPE integer USING itemrevenue::integer;
```

Datatype FIXED.	
</details>
	
	
<details>
<summary> 9. Investigate purpose of all_sessions.column28. Is this empty? Bad data import? </summary

Check for values in this mystery column28:

```
select * from all_sessions where column28 is not null;
-- returns 15,134 rows
```

Since all rows are null, this just looks like poor import, deleting column as irrelevant to our analysis.  

```
ALTER TABLE all_sessions DROP COLUMN column28;
```

FIXED column28.
</details>

<details>
<summary> 10. Investigate all_sessions.visitid and analytics.visitid.  Is this a join? </summary

Check for values of visitid between analytics and all_sessions tables:

```
SELECT COUNT(*) FROM all_sessions
JOIN analytics USING(visitid);
-- returns 107,159 rows

SELECT COUNT(*) FROM analytics
full outer JOIN all_sessions USING(visitid);
-- returns 4,316,292 rows
```

Let's check for duplicate values:

```
select visitid, count(*)
from analytics
group by visitid
HAVING count(*) > 1;
-- returns 146,517 duplicate visitID rows in analytics table

select visitid, count(*)
from all_sessions
group by visitid
HAVING count(*) > 1;
-- returns 553 duplicate visitID rows in all_sessions table
```
	
There is DEFINATELY a JOIN relationship but this isn't a primary key for either table.

</details>
	
<details>
<summary> 13. Investigate DUPLICATE fields sales_report.name, sales_report.stockLevel, sales_report.restockingLeadTime, sales_report.sentimentScore, sales_report.sentimentMagnitude in both products and sales_reports TABLE? </summary>

sales_report seems to have duplicated columns that should be stored ONLY in the products table.
Let's verify they are similar.

```
select 
	p.SKU,
	p.name as ProdutName,
	sr.name as SRName,
	p.stockLevel as ProductStock,
	sr.stockLevel as SRStock,
	p.restockingLeadTime as ProductLead,
	sr.restockingLeadTime as SRLead,
	p.sentimentScore as ProductSScore,
	sr.sentimentScore as SRSScore,
	p.sentimentMagnitude as ProductSMag,
	sr.sentimentMagnitude as SRSMag
from
	products as p
join 
	sales_report as sr ON p.sku = sr.productSKU
where
	sr.name = p.name
	and
	sr.stockLevel = p.stockLevel
	and
	sr.restockingLeadTime = p.restockingLeadTime
	and
	sr.sentimentScore = p.sentimentScore
	and
	sr.sentimentMagnitude = p.sentimentMagnitude;
-- returns ALL 454 rows, so they all match
```
	
Now that we know they are the same, we are going to drop the duplicate columns from sales_report table using query:

```
ALTER TABLE sales_report 
DROP COLUMN IF EXISTS name, 
DROP COLUMN IF EXISTS stockLevel, 
DROP COLUMN IF EXISTS restockingLeadTime,
DROP COLUMN IF EXISTS sentimentScore,
DROP COLUMN IF EXISTS sentimentMagnitude;
```

The IF EXISTS has been added in case we wanted to limit these columns from the next import.
</details>

<details>
<summary> 14. Investigate individual values in the tables, any individual field data needed?</summary>	

## (a) products.name
Starting with products table, let's check the name string field with:

```
SELECT name, COUNT(*) AS count
FROM products
GROUP BY name
ORDER BY name;
-- shows some names start with leading spaces = FIX these 313 values
```

```
-- FIX 14 (a)
UPDATE products SET name = trim(name);
-- updates 1094 rows
```

## (b) all_sessions.city
	
```
SELECT city, COUNT(*) AS count
FROM all_sessions
GROUP BY city
ORDER BY city;
-- we don't need both (not set) and "not available in demo dataset", renaming later
-- "city"							"count"
-- "not available in demo dataset"	8302
-- "(not set)"						354

-- FIX 14(b)
UPDATE all_sessions
SET city='(not set)'
WHERE city = 'not available in demo dataset';
-- UPDATE 8302, which matches our initial count
-- Query returned successfully in 296 msec.
```

## (c) all_sessions.totalTransactionRevenue, all_sessions.transactions, all_sessions.productrefundAmount, all_sessions.productQuantity, all_sessions.productRevenue, all_sessions.itemQuantity, all_sessions.itemRevenue, all_sessions.transactionRevenue, all_sessions.transactionId, all_sessions.searchKeyword
	
These columns are blank, no values.  Consideration could be given to remove these columns, but not before confirming with a subject matter expert.  Was information missed, are these columns used to store a function or comparison?

![image thanks to Observable](https://github.com/cboyda/LighthouseLabs/blob/b9d86569fbef20b700ceb63f8840f08db839e77b/Project-SQL/images/all_sessions-unused%20columns.png?raw=true)
	
![image thanks to Observable](https://github.com/cboyda/LighthouseLabs/blob/0225c5660ed107eae9d369874e4655a14f49e79e/Project-SQL/images/all_sessions-unused%20columns2.png?raw=true)

NO columns deleted since this is a destructive change and would need to be confirmed before applied.

## (d) all_sessions.sessionQualityDim

Replacing with 0 to match INTEGER and for better comparisons.
```
select sessionQualityDim,  Count(*) as Count
FROM all_sessions
GROUP BY sessionQualityDim
ORDER BY sessionQualityDim DESC;
-- returns 45 different variations
-- including 13,906 NULL's


UPDATE all_sessions
SET sessionQualityDim=0
WHERE sessionQualityDim is NULL;
-- UPDATE 13906
-- Query returned successfully in 272 msec.
```
	
## (e) all_sessions.productPrice

All prices in millions, ranging from 8.99 to 300, could divide by 1 million for easier readability.

```
UPDATE all_sessions
SET productPrice=productPrice/1000000;
--UPDATE 15134
--Query returned successfully in 353 msec.
```

Also changing datatype to format nicely with MONEY.

```
ALTER TABLE public.all_sessions ALTER COLUMN productprice TYPE money USING productprice::money;
```

## (f) all_sessions.currencyCode

This is minor but Country "United States" is missing the CurrencyCode, we know this to be USD to just adding for easier comparison (like the top 10 Countries question).

```
UPDATE all_sessions
SET currencyCode = 'USD'
WHERE Country = 'United States';
-- UPDATE 8727
-- Query returned successfully in 249 msec.
```
	
</details>
