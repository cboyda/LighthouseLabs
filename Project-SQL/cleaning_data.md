# cleaning_data.md file
--    Fill out this file with a description of the issues that will be addressed by cleaning the data
--    Include the queries used to clean the data
    

What issues will you address by cleaning the data?
- [ ] 1. Find all fields with any NULL values in ALL tables.
- [ ] 2. Check analytics.bounces violates not-null constraint
- [ ] 3. Check analytics.pageviews violates not-null constraint  
- [ ] 4. Investigate why analytics.units_sold as STRING instead of expected NUMERIC?
- [ ] 5. Attempt to Enforce Foreign key reference failed in Table sales_by_sku.productSKU referring to products.SKU
- [ ] 6. Investigate analytics.fullvisitorId is NUMERIC so why is all_sessions.fullvisitorId as VARCHAR? These seem to be connected.
- [ ] 7. Convert NUMERIC fields with null to 0 for easier math. all_sessions.totaltransationrevenue, all_sessions.transactions, all_sessions.sessionqualitydim, all_sessions.productrefundamount, all_sessions.productquantity, all_sessions.productrevenue, all_sessions.itemquantity, all_sessions.itemrevenue, all_sessions.transactionrevenue, 
- [ ] 8. Investigate all_sessions.itemrevenue is STRING when revenue should probably be NUMERIC.
- [ ] 9. Investigate purpose of all_sessions.column28. Is this empty? Bad data import?
- [ ] 10. Investigate analytics.units_sold is STRING when expecting NUMERIC.
- [ ] 11. Check products.sentimentscore violates not-null constraint, should these be zero? 
- [ ] 12. Check products.sentimentmagnitude violates not-null constraint, should these be zero?
- [ ] 13. Investigate DUPLICATE fields sales_report.name, sales_report.stockLevel, sales_report..restockingLeadTime, sales_report.sentimentScore, sales_report.sentimentMagnitude in both products and sales_reports TABLE?  May solve #11 and #12 from this information?




Queries:
Below, provide the SQL queries you used to clean your data.
1. Find all fields with any NULL values in ALL tables., then decide how to proceed with them.

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

a) analytics.userid (NULL)
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

b) analytics.pageviews (NULL)
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
RETURNS 72.
THEREFORE assuming these 72 are equivalent to 0 and applying fix.

QUERY for FIX:
```
???
```

c) analytics.timeonsite (NULL)
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
RETURNS: 477,465.  This this affects 11% of rows, leaving as-is.  Too many to consider deleting data (>5%)

d) analytics.bounces (NULL)
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
