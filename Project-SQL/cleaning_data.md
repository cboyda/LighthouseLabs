# cleaning_data.md file
--    Fill out this file with a description of the issues that will be addressed by cleaning the data
--    Include the queries used to clean the data
    

What issues will you address by cleaning the data?
- [X] 1. Find all fields with any NULL values in ALL tables.
- [X] 2. Check analytics.bounces violates not-null constraint, FIXED in 1(d)
- [X] 3. Check analytics.pageviews violates not-null constraint, FIXED in 1(b)
- [X] 4. Investigate why analytics.units_sold as STRING instead of expected NUMERIC?
- [X] 5. Attempt to Enforce Foreign key reference failed in Table sales_by_sku.productSKU referring to products.SKU
- [X] 6. Investigate analytics.fullvisitorId is NUMERIC so why is all_sessions.fullvisitorId as VARCHAR?
- [ ] 7. Consider NUMERIC fields with null to 0 for easier math. all_sessions.totaltransationrevenue, all_sessions.transactions, all_sessions.sessionqualitydim, all_sessions.productrefundamount, all_sessions.productquantity, all_sessions.productrevenue, all_sessions.itemquantity, all_sessions.itemrevenue, all_sessions.transactionrevenue, 
- [ ] 8. Investigate all_sessions.itemrevenue is STRING when revenue should probably be NUMERIC.
- [X] 9. Investigate purpose of all_sessions.column28. Is this empty? Bad data import?
- [ ] 10. Investigate analytics.units_sold is STRING when expecting NUMERIC.
- [ ] 11. Check products.sentimentscore violates not-null constraint, should these be zero? 
- [ ] 12. Check products.sentimentmagnitude violates not-null constraint, should these be zero?
- [ ] 13. Investigate DUPLICATE fields sales_report.name, sales_report.stockLevel, sales_report..restockingLeadTime, sales_report.sentimentScore, sales_report.sentimentMagnitude in both products and sales_reports TABLE?  May solve #11 and #12 from this information?




# Queries:
Below, provide the SQL queries you used to clean your data.
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

Oddly none match eachother, they must be uniquely generated.
```
SELECT COUNT(*) FROM analytics
JOIN all_sessions ON analytics.fullvisitorid = all_sessions.fullvisitorid;
-- returns 0
SELECT COUNT(*) FROM all_sessions
JOIN analytics USING(fullvisitorid);
-- returns 0
```
	
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

