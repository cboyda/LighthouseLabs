-- Work in Progress Queries
-- Author: Clinton Boyda

-- SALES BY SKU
-- unable to maintain foreign product key 
-- ALTER TABLE public.sales_by_sku DROP CONSTRAINT sales_by_sku_productsku_fkey;

-- ANALYTICS
/* BOUNCES does have some nulls
Reason:
SQL Error [23502]: Batch entry 0 INSERT INTO public.analytics (visitnumber,visitid,visitstarttime,"date",fullvisitorid,channelgrouping,socialengagementtype,units_sold,pageviews,timeonsite,unit_price)
	VALUES (2,1497446706,1497446706,'20170614',5027011278301032142,'Organic Search','Not Socially Engaged','',2,303,0) was aborted: ERROR: null value in column "bounces" of relation "analytics" violates not-null constraint
  Detail: Failing row contains (13789, 2, 1497446706, 1497446706, 2017-06-14, 5027011278301032142, null, Organic Search, Not Socially Engaged, , 2, 303, null, null, 0.00).  Call getNextException to see other errors in the batch.
*/

/* PAGEVIEWS does have some nulls
Reason:
SQL Error [23502]: Batch entry 0 INSERT INTO public.analytics (visitnumber,visitid,visitstarttime,"date",fullvisitorid,channelgrouping,socialengagementtype,units_sold,unit_price)
	VALUES (2,1499178568,1499178568,'20170704',3860819591364702706,'Social','Not Socially Engaged','1',2990000) was aborted: ERROR: null value in column "pageviews" of relation "analytics" violates not-null constraint
  Detail: Failing row contains (133657, 2, 1499178568, 1499178568, 2017-07-04, 3860819591364702706, null, Social, Not Socially Engaged, 1, null, null, null, null, 2990000.00).  Call getNextException to see other errors in the batch.
*/


-- what are TABLE lists and SIZES?

-- select * from all_sessions;
-- returns 15,134 rows

-- select * from analytics;
-- returns 4,301,122 rows in 36seconds

-- select * from products;
-- returns 1092 rows

-- select * from sales_by_sku;
-- returns 462 rows

-- select * from sales_report;
-- returns 454 rows

-- DO $$
-- DECLARE
--    rec    RECORD;
--    _found BOOLEAN;
-- BEGIN
--    FOR rec IN 
--       SELECT format('SELECT TRUE FROM %s WHERE %I IS NULL LIMIT 1'
--                    , c.oid::regclass, a.attname) AS qry_to_run
--             , c.oid::regclass AS tbl
--             , a.attname       AS col
--             , a.atttypid      AS datatype
--       FROM   pg_namespace n 
--       JOIN   pg_class     c ON c.relnamespace = n.oid 
--       JOIN   pg_attribute a ON a.attrelid = c.oid
--       WHERE  n.nspname <> 'information_schema'
--       AND    n.nspname NOT LIKE 'pg_%'  -- exclude system, temp, toast tbls
--       AND    c.relkind = 'r'
--       AND    a.attnum > 0
--       AND    a.attnotnull = FALSE
--       AND    a.attisdropped = FALSE

--    LOOP
--       EXECUTE rec.qry_to_run INTO _found;

--       IF _found THEN
--          RAISE NOTICE 'Table % has NULLs in the % field of type %'
--                       , rec.tbl, rec.col, rec.datatype::regtype;
--       END IF;
--    END LOOP;
-- END
-- $$;

-- RETURNS
-- NOTICE:  Table analytics has NULLs in the userid field of type numeric
-- NOTICE:  Table analytics has NULLs in the pageviews field of type integer
-- NOTICE:  Table analytics has NULLs in the timeonsite field of type numeric
-- NOTICE:  Table analytics has NULLs in the bounces field of type integer
-- NOTICE:  Table analytics has NULLs in the revenue field of type numeric

-- NOTICE:  Table products has NULLs in the sentimentscore field of type numeric
-- NOTICE:  Table products has NULLs in the sentimentmagnitude field of type numeric

-- NOTICE:  Table sales_report has NULLs in the ratio field of type numeric

-- NOTICE:  Table all_sessions has NULLs in the totaltransactionrevenue field of type numeric
-- NOTICE:  Table all_sessions has NULLs in the transactions field of type numeric
-- NOTICE:  Table all_sessions has NULLs in the timeonsite field of type integer
-- NOTICE:  Table all_sessions has NULLs in the sessionqualitydim field of type integer
-- NOTICE:  Table all_sessions has NULLs in the productrefundamount field of type numeric
-- NOTICE:  Table all_sessions has NULLs in the productquantity field of type integer
-- NOTICE:  Table all_sessions has NULLs in the productrevenue field of type numeric
-- NOTICE:  Table all_sessions has NULLs in the itemquantity field of type integer
-- NOTICE:  Table all_sessions has NULLs in the transactionrevenue field of type numeric

-- select SKU from products where sentimentmagnitude is null;

-- select min(sentimentscore) from products;

-- select sentimentscore from products where name like '%speakers%';

-- select count (*) from products where sentimentmagnitude = 0;

-- select * from productsorder by sentimentmagnitude;

-- select count(*) from products where sentimentmagnitude=0.1;

-- select min(sentimentmagnitude),max(sentimentmagnitude) from products;

-- select sentimentscore from sales_report where productSKU = 'GGADFBSBKS42347';

-- select min(bounces) from analytics;

-- select 
-- 	count(*),
-- 	ratio
-- from 
-- 	sales_report
-- where
-- 	ratio is null
-- group by 
-- 	ratio;

-- select min(ratio) from sales_report;

-- select count(*) from sales_report where ratio is Null;

-- select revenue from analytics where revenue is NOT null;

-- select min(revenue) from analytics;

--select analytics.bounces,analytics.revenue,analytics.pageviews

-- FIX for 0
-- UPDATE analytics
-- SET unit_price=ROUND(unit_price/1000000,2);
-- UPDATE 4301122
-- Query returned successfully in 1 min 5 secs.

-- -- FIX for 1 (b)
-- UPDATE analytics
-- SET pageviews=0
-- WHERE pageviews IS NULL;

-- -- FIX for 1 (d)
-- UPDATE analytics
-- SET bounces=0
-- WHERE bounces IS NULL;

-- -- FIX for 1 (f)
-- UPDATE products
-- SET sentimentscore=0
-- WHERE sentimentscore IS NULL;

-- -- FIX for 1 (g)
-- UPDATE products
-- SET sentimentmagnitude=0.1
-- WHERE sentimentmagnitude IS NULL;

-- #4 in Data Cleaning
-- Investigate why analytics.units_sold as STRING instead of expected NUMERIC?

-- -- non-numeric values
-- select analytics_id,units_sold from analytics WHERE units_sold !~ '^[-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?$';
-- -- returns 4,205,975 
-- -- looks like units_sold is null

-- select analytics_id,units_sold from analytics WHERE units_sold is not null;
-- -- returns 4,301,122 == ALL
-- -- looks like units_sold is blank

-- select analytics_id,units_sold from analytics WHERE analytics_id = 286242;

-- SELECT units_sold
-- FROM analytics
-- WHERE units_sold !~ '^[0-9]+$'; -- non-integers
-- -- returns 4,205,976

-- select count(*) from analytics where units_sold is null;
-- -- returns 0

-- select count(*) from analytics WHERE units_sold !~ '[0-9]+';
-- -- returns 4,205,975
-- -- doesn't contain numeric data

-- select count(*) from analytics where units_sold ='';
-- -- returns 4,205,975

-- -- FIX for #4
-- UPDATE analytics
-- SET units_sold=0
-- WHERE units_sold ='';
-- -- UPDATE 4205975
-- -- Query returned successfully in 55 secs 886 msec.

-- select count(*) from analytics Where units_sold::integer > 0;
-- -- returns 95,146
-- -- adding 4205975 = 4301121 = 100% of our rows
-- -- now that "" are 0's we can modify the field type

-- ALTER TABLE public.analytics ALTER COLUMN units_sold TYPE integer USING units_sold::integer;

-- #5
-- Attempt to Enforce Foreign key reference failed in Table sales_by_sku.productSKU referring to products.SKU

-- -- Find mismatched rows
-- SELECT * 
-- FROM sales_by_sku as sk
-- WHERE NOT EXISTS (
--   SELECT * FROM products 
--   WHERE products.SKU = sk.productSKU
-- );

-- -- returns 8 rows
-- -- "salesbysku_id"	"productsku"	"total_ordered"
-- -- 166				"GGOEYAXR066128"	3
-- -- 239				"GGOEGALJ057912"	2
-- -- 320				"9180753"			0
-- -- 407				"9184677"			0
-- -- 418				"9184663"			0
-- -- 426				"9182763"			0
-- -- 427				"9182779"			0
-- -- 445				"9182182"			0

-- select * from products where SKU like 'GGOEGALJ0579%';
-- -- probably this same name
-- --  "sku"	"name"	"orderedquantity"	"stocklevel"	"restockingleadtime"	"sentimentscore"	"sentimentmagnitude"
-- -- "GGOEGALJ057914"	" Women's Short Sleeve Performance Tee Charcoal"	11	14	17	0.3	0.5
-- -- "GGOEGALJ057913"	" Women's Short Sleeve Performance Tee Charcoal"	6	11	10	0.8	1.2
-- -- "GGOEGALJ057915"	" Women's Short Sleeve Performance Tee Charcoal"	6	11	16	0.8	1.3

-- select * from products where SKU like 'GGOEYAXR066%';
-- -- probably this same name
-- -- "sku"	"name"	"orderedquantity"	"stocklevel"	"restockingleadtime"	"sentimentscore"	"sentimentmagnitude"
-- -- "GGOEYAXR066155"	" Toddler Short Sleeve Tee Red"	6	7	14	0.3	0.5
-- -- "GGOEYAXR066130"	" Toddler Short Sleeve Tee Red"	3	4	17	0.3	0.5
-- -- "GGOEYAXR066129"	" Toddler Short Sleeve Tee Red"	4	7	17	0.7	1.1

-- select * from products where SKU like '918075%';
-- -- harder to guess
-- -- "sku"	"name"	"orderedquantity"	"stocklevel"	"restockingleadtime"	"sentimentscore"	"sentimentmagnitude"
-- -- "9180757"	"Yoga Block"	0	0	13	0.1	0.3
-- -- "9180759"	" Lunch Bag"	0	0	6	0.5	0.8
-- -- "9180754"	"8 pc Android Sticker Sheet"	0	0	13	0.5	0.8
-- -- "9180756"	"Windup Android"	0	0	6	0.7	1.1

-- select * from products limit 1;

-- INSERT INTO products (sku, name, orderedquantity, stocklevel, restockingleadtime, sentimentscore, sentimentmagnitude) 
-- VALUES ('GGOEYAXR066128', ' Toddler Short Sleeve Tee Red',0,0,0,0,0.1);
-- INSERT INTO products (sku, name, orderedquantity, stocklevel, restockingleadtime, sentimentscore, sentimentmagnitude) 
-- VALUES ('GGOEGALJ057912', ' Women''s Short Sleeve Performance Tee Charcoal',0,0,0,0,0.1);

-- DELETE FROM products WHERE sku = 'GGOEYAXR066128';

-- select * from products where SKU = 'GGOEGALJ057912';

-- DELETE FROM sales_by_sku where productsku IN('9180753','9184677','9184663','9182763','9182779','9182182');

-- Select * from sales_by_sku;
-- -- returns 456 rows

-- ALTER TABLE public.sales_by_sku ADD CONSTRAINT sales_by_sku_fk FOREIGN KEY (productsku) REFERENCES public.products(sku) ON DELETE CASCADE ON UPDATE NO ACTION;

-- #6. Investigate analytics.fullvisitorId is NUMERIC so why is all_sessions.fullvisitorId as VARCHAR?

-- select fullvisitorID from analytics order by fullvisitorid LIMIT 50;
-- -- datatype is numeric

-- select fullvisitorID from all_sessions order by fullvisitorid DESC;

-- ALTER TABLE public.all_sessions ALTER COLUMN fullvisitorid TYPE numeric USING fullvisitorid::numeric;

-- -- Find mismatched rows all_sessions not in analytics
-- SELECT * 
-- FROM all_sessions as alls
-- WHERE NOT EXISTS (
--   SELECT * FROM analytics 
--   WHERE analytics.fullvisitorid = alls.fullvisitorid
-- );
-- -- returns 15,134 rows

-- -- Find mismatched rows analytics not in all_sessions
-- SELECT * 
-- FROM analytics 
-- WHERE NOT EXISTS (
--   SELECT * FROM all_sessions 
--   WHERE all_sessions.fullvisitorid = analytics.fullvisitorid
-- );
-- -- returns 4,301,122 rows

-- SELECT COUNT(*) FROM analytics
-- JOIN all_sessions ON analytics.fullvisitorid = all_sessions.fullvisitorid;
-- -- returns 0

-- SELECT COUNT(*) FROM all_sessions
-- JOIN analytics USING(fullvisitorid);
-- -- returns 0


-- #8
-- Investigate all_sessions.itemrevenue is STRING when revenue should probably be NUMERIC.

-- select count(*) from all_sessions where isnumeric(itemrevenue);
-- failes as isnumeric is not known function

-- select itemrevenue from all_sessions WHERE itemrevenue !~ '^[-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?$';
-- returns 15,134 rows which seem "" aka blank or empty

-- select count(*) from all_sessions where itemrevenue is NULL;
-- -- zero nulls

-- select count(*),itemrevenue from all_sessions where itemrevenue is NOT NULL GROUP BY itemrevenue;
-- -- "count"	"itemrevenue"
-- -- 15134	

-- -- any numbers
-- select itemrevenue from all_sessions WHERE itemrevenue = '^[-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?$';
-- -- no rows returned

-- select count(*) from all_sessions where itemrevenue = '';

-- -- Currently itemRevenue VARCHAR(100)
-- -- Goal is NUMERIC(11,2) with NOT NULL constraint!

-- UPDATE all_sessions
-- SET itemrevenue=0
-- WHERE itemrevenue ='';
-- --  UPDATE 15134
-- --- Query returned successfully in 317 msec.

-- ALTER TABLE public.all_sessions ALTER COLUMN itemrevenue TYPE integer USING itemrevenue::integer;

-- #9. Investigate purpose of all_sessions.column28. Is this empty? Bad data import?
-- select * from all_sessions where column28 is not null;
-- -- returns 15,134 rows

-- select * from all_sessions where column28 is null;
-- -- returns 0 rows

-- ALTER TABLE all_sessions DROP COLUMN IF EXISTS column28;

-- #10
-- Investigate all_sessions.visitid and analytics.visitid.  Is this a join?

-- SELECT COUNT(*) FROM all_sessions
-- JOIN analytics USING(visitid);
-- -- returns 107,159 rows

-- SELECT COUNT(*) FROM analytics
-- full outer JOIN all_sessions USING(visitid);
-- -- returns 4,316,292 rows

-- select visitid, count(*)
-- from analytics
-- group by visitid
-- HAVING count(*) > 1;
-- -- returns 146,517 duplicate visitID rows in analytics table

-- select visitid, count(*)
-- from all_sessions
-- group by visitid
-- HAVING count(*) > 1;
-- -- returns 553 duplicate visitID rows in all_sessions table


-- #13
-- Investigate DUPLICATE fields sales_report.name, sales_report.stockLevel, sales_report.restockingLeadTime, sales_report.sentimentScore, sales_report.sentimentMagnitude in both products and sales_reports TABLE?

-- select 
-- 	p.SKU,
-- 	p.name as ProdutName,
-- 	p.stockLevel as ProductStock,
-- 	p.restockingLeadTime as ProductLead,
-- 	p.sentimentScore as ProductSScore,
-- 	p.sentimentMagnitude as ProductSMag
-- from
-- 	products as p
-- join 
-- 	sales_report as sr ON p.sku = sr.productSKU;
-- -- returns 454 rows

-- select 
-- 	p.SKU,
-- 	p.name as ProdutName,
-- 	sr.name as SRName,
-- 	p.stockLevel as ProductStock,
-- 	sr.stockLevel as SRStock,
-- 	p.restockingLeadTime as ProductLead,
-- 	sr.restockingLeadTime as SRLead,
-- 	p.sentimentScore as ProductSScore,
-- 	sr.sentimentScore as SRSScore,
-- 	p.sentimentMagnitude as ProductSMag,
-- 	sr.sentimentMagnitude as SRSMag
-- from
-- 	products as p
-- join 
-- 	sales_report as sr ON p.sku = sr.productSKU
-- where
-- 	sr.name = p.name
-- 	and
-- 	sr.stockLevel = p.stockLevel
-- 	and
-- 	sr.restockingLeadTime = p.restockingLeadTime
-- 	and
-- 	sr.sentimentScore = p.sentimentScore
-- 	and
-- 	sr.sentimentMagnitude = p.sentimentMagnitude;
-- -- returns ALL 454 rows, so they all match

-- ALTER TABLE sales_report 
-- DROP COLUMN IF EXISTS name, 
-- DROP COLUMN IF EXISTS stockLevel, 
-- DROP COLUMN IF EXISTS restockingLeadTime,
-- DROP COLUMN IF EXISTS sentimentScore,
-- DROP COLUMN IF EXISTS sentimentMagnitude;

-- #14
--- explore unique data values
-- select 
	
--     count(*) as number_of_rows
-- from 
--     your_table
-- where 
--     extract(year from date) = 2014
-- group by 
--     column1;
	

-- DO $$ 
-- DECLARE 
--     table_name_ text; 
--     column_name_ text; 
--     record_count_ bigint; 
-- BEGIN 
--     FOR table_name_ IN (SELECT tablename FROM pg_tables WHERE schemaname = 'public') LOOP 
--         RAISE NOTICE 'Table: %', table_name_; 
--         FOR column_name_ IN (SELECT column_name FROM information_schema.columns WHERE table_name = table_name_) LOOP 
--             EXECUTE format('SELECT COUNT(DISTINCT %I) FROM %I.%I', column_name_, 'public', table_name_) INTO record_count_; 
--             RAISE NOTICE '    %: %', column_name_, record_count_; 
--         END LOOP; 
--     END LOOP; 
-- END $$;

-- NOTICE:  Table: sales_by_sku
-- NOTICE:      salesbysku_id: 456
-- NOTICE:      total_ordered: 60
-- NOTICE:      productsku: 456
-- NOTICE:  Table: products
-- NOTICE:      stocklevel: 262
-- NOTICE:      sentimentscore: 17
-- NOTICE:      sentimentmagnitude: 20
-- NOTICE:      orderedquantity: 224
-- NOTICE:      restockingleadtime: 28
-- NOTICE:      name: 313
-- NOTICE:      sku: 1094
-- NOTICE:  Table: sales_report
-- NOTICE:      salesreport_id: 454
-- NOTICE:      total_ordered: 60
-- NOTICE:      ratio: 244
-- NOTICE:      productsku: 454
-- NOTICE:  Table: all_sessions
-- NOTICE:      allsession_id: 15134
-- NOTICE:      fullvisitorid: 14147
-- NOTICE:      timeonsite: 1266
-- NOTICE:      pageviews: 29
-- NOTICE:      sessionqualitydim: 44
-- NOTICE:      date: 366
-- NOTICE:      visitid: 14556
-- NOTICE:      productrefundamount: 0
-- NOTICE:      productquantity: 8
-- NOTICE:      productprice: 141
-- NOTICE:      productrevenue: 4
-- NOTICE:      itemquantity: 0
-- NOTICE:      itemrevenue: 1
-- NOTICE:      transactionrevenue: 4
-- NOTICE:      ecommerceaction_type: 7
-- NOTICE:      ecommerceaction_step: 3
-- NOTICE:      time: 9600
-- NOTICE:      totaltransactionrevenue: 72
-- NOTICE:      transactions: 1
-- NOTICE:      channelgrouping: 7
-- NOTICE:      transactionid: 10
-- NOTICE:      country: 136
-- NOTICE:      city: 266
-- NOTICE:      pagetitle: 269
-- NOTICE:      productsku: 536
-- NOTICE:      v2productname: 471
-- NOTICE:      v2productcategory: 74
-- NOTICE:      productvariant: 11
-- NOTICE:      currencycode: 2
-- NOTICE:      searchkeyword: 1
-- NOTICE:      type: 2
-- NOTICE:      pagepathlevel1: 11
-- NOTICE:      ecommerceaction_option: 4
-- NOTICE:  Table: analytics
-- NOTICE:      analytics_id: 4301122
-- NOTICE:      visitnumber: 222
-- NOTICE:      visitid: 148642
-- NOTICE:      visitstarttime: 148853
-- NOTICE:      date: 93
-- NOTICE:      fullvisitorid: 120018
-- NOTICE:      userid: 0
-- NOTICE:      revenue: 5269
-- NOTICE:      unit_price: 1426
-- NOTICE:      units_sold: 135
-- NOTICE:      pageviews: 129
-- NOTICE:      timeonsite: 3269
-- NOTICE:      bounces: 2
-- NOTICE:      channelgrouping: 8
-- NOTICE:      socialengagementtype: 1
-- DO
-- Query returned successfully in 2 min 49 secs.

-- DO $$DECLARE
--   r record;
--   column_name text;
--   table_name text;
-- BEGIN
--   FOR r IN (SELECT table_name, column_name 
--             FROM information_schema.columns 
--             WHERE table_schema = 'public' AND table_name != 'schema_migrations') 
--   LOOP
--     column_name := r.column_name;
--     table_name := r.table_name;
    
--     EXECUTE format('SELECT %I, COUNT(*) FROM %I GROUP BY %I ORDER BY COUNT(*) DESC;', 
--                    column_name, table_name, column_name)
--     INTO r;
    
--     RAISE NOTICE 'Column: %, Table: %', column_name, table_name;
--     RAISE NOTICE '%', r;
--   END LOOP;
-- END$$;

-- DO $$ 
-- DECLARE 
--     table_name_ text; 
--     column_name_ text; 
--     record_count_ bigint; 
-- BEGIN 
--     FOR table_name_ IN (SELECT tablename FROM pg_tables WHERE schemaname = 'public') LOOP 
--         RAISE NOTICE 'Table: %', table_name_; 
--         FOR column_name_ IN (SELECT column_name FROM information_schema.columns WHERE table_name = table_name_) LOOP 
--             EXECUTE format('SELECT %I, COUNT(*) FROM %I.%I GROUP BY %I', column_name_, 'public', table_name_, column_name_) INTO record_count_, column_name_; 
--             RAISE NOTICE '    %: %', column_name_, record_count_; 
--         END LOOP; 
--     END LOOP; 
-- END $$;

-- SELECT name, COUNT(*) AS count
-- FROM products
-- GROUP BY name
-- ORDER BY name;
-- shows some names start with leading spaces = FIX

-- FIX 14 (a)
-- UPDATE products SET name = trim(name);

-- SELECT *, COUNT(*) AS count
-- FROM products
-- GROUP BY orderedQuantity
-- ORDER BY orderedQuantity;


--UPDATE analytics
-- SET unit_price=ROUND(unit_price/1000000,2);

-- select unit_price from analytics order by unit_price;

-- AHH  ran this unit_price accidentally a few times, now it is just a zero column
-- reimporting analytics data for fix


-- SELECT country, COUNT(*) AS count
-- FROM all_sessions
-- GROUP BY country
-- ORDER BY country;
-- returns (not set) of 24 but that is ok, others look good

-- (b) all_sessions.city

-- SELECT city, COUNT(*) AS count
-- FROM all_sessions
-- GROUP BY city
-- ORDER BY city;
-- -- we don't need both (not set) and "not available in demo dataset", renaming later
-- -- "city"							"count"
-- -- "not available in demo dataset"	8302
-- -- "(not set)"						354

-- -- FIX 14(b)
-- UPDATE all_sessions
-- SET city='(not set)'
-- WHERE city = 'not available in demo dataset';
-- -- UPDATE 8302, which matches our initial count
-- -- Query returned successfully in 296 msec.

--------- next
-- SELECT type, COUNT(*) AS count
-- FROM all_sessions
-- GROUP BY type
-- ORDER BY type;
-- -- returns (not set) of 24 but that is ok, others look good

-- SELECT currencyCode, COUNT(*) AS count
-- FROM all_sessions
-- GROUP BY currencyCode
-- ORDER BY currencyCode;
-- -- returns 272 empties, answer unknown
-- -- "currencycode"	"count"
-- -- 					272
-- -- "USD"			14862

-- SELECT productVariant, COUNT(*) AS count
-- FROM all_sessions
-- GROUP BY productVariant
-- ORDER BY productVariant;
-- -- returns some (not set) but unknown replacements
-- -- "productvariant"	"count"
-- -- " 2XL"				1
-- -- " BLUE"				1
-- -- " GREEN"				1
-- -- " LG"				2
-- -- " MD"				6
-- -- "(not set)"			15094
-- -- " RED"				1
-- -- "Single Option Only"	23
-- -- " SM"				1
-- -- " XL"				3
-- -- " YELLOW"			1

-- (d)
-- select sessionQualityDim,  Count(*) as Count
-- FROM all_sessions
-- GROUP BY sessionQualityDim
-- ORDER BY sessionQualityDim DESC;
-- -- returns 45 different variations
-- -- including 13,906 NULL's
-- -- replacing with 0 to match INTEGER and for better comparisons

-- -- FIX 14 (d)
-- UPDATE all_sessions
-- SET sessionQualityDim=0
-- WHERE sessionQualityDim is NULL;
-- -- UPDATE 13906
-- -- Query returned successfully in 272 msec.

-- -- FIX 14 (e)
-- UPDATE all_sessions
-- SET productPrice=productPrice/1000000;
-- -- UPDATE 15134
-- -- Query returned successfully in 353 msec.

-- ALTER TABLE public.all_sessions ALTER COLUMN productprice TYPE money USING productprice::money;

-- FIX 14 (f)

-- select count(*) from all_sessions where country='United States';
-- -- returns 8727 

-- UPDATE all_sessions
-- SET currencyCode = 'USD'
-- WHERE Country = 'United States';
-- -- UPDATE 8727
-- -- Query returned successfully in 249 msec.

--- FIX our unit_price ANALYTICS table
-- caused by running this multiple times
--  UPDATE analytics
-- SET unit_price=ROUND(unit_price/1000000,2);
-- UPDATE 4301122
-- Query returned successfully in 1 min 5 secs.
-- select unit_price, count(*) from analytics GROUP BY unit_price ORDER BY unit_price DESC limit 10;

-- | unit_price | count |
-- |------------|-------|
-- | 995.00     | 28    |
-- | 959.80     | 5     |
-- | 958.00     | 20    |
-- | 950.40     | 5     |
-- | 945.25     | 4     |
-- | 936.00     | 11    |
-- | 899.55     | 4     |
-- | 897.00     | 20    |
-- | 851.01     | 4     |
-- | 850.40     | 1     |
-- | 848.30     | 10    |
-- | 833.00     | 6     |
-- | 805.80     | 3     |
-- | 799.89     | 4     |
-- | 799.80     | 9     |
-- | 799.60     | 4     |
-- | 798.40     | 3     |
-- | 796.00     | 16    |
-- | 792.98     | 3     |
-- | 783.86     | 5     |
-- | 771.11     | 13    |
-- | 769.45     | 4     |
-- | 750.00     | 3     |
-- | 749.70     | 2     |
-- | 745.00     | 60    |
-- | 744.52     | 7     |
-- | 738.00     | 2     |
-- | 717.93     | 3     |
-- | 705.18     | 3     |
-- | 699.80     | 3     |
-- | 696.50     | 19    |
-- | 691.34     | 6     |
-- | 683.55     | 4     |
-- | 679.66     | 11    |
-- | 679.60     | 1     |
-- | 671.88     | 5     |
-- | 664.75     | 3     |
-- | 657.80     | 4     |
-- | 651.75     | 10    |
-- | 642.40     | 4     |
-- | 629.85     | 3     |
-- | 627.90     | 3     |
-- | 615.50     | 5     |
-- | 615.30     | 4     |
-- | 615.00     | 4     |
-- | 607.60     | 6     |
-- | 599.85     | 1     |
-- | 599.70     | 3     |
-- | 598.00     | 7     |
-- | 597.00     | 21    |

-- or
-- | unit_price | count |
-- |------------|-------|
-- | 995.00     | 28    |
-- | 959.80     | 5     |
-- | 958.00     | 20    |
-- | 950.40     | 5     |
-- | 945.25     | 4     |
-- | 936.00     | 11    |
-- | 899.55     | 4     |
-- | 897.00     | 20    |
-- | 851.01     | 4     |
-- | 850.40     | 1     |

-- select unit_price/1000000, count(*) from analytics_copy GROUP BY unit_price ORDER BY unit_price DESC limit 10;

-- | ?column?                | count |
-- |------------------------|-------|
-- | 995.0000000000000000   | 28    |
-- | 959.8000000000000000   | 5     |
-- | 958.0000000000000000   | 20    |
-- | 950.4000000000000000   | 5     |
-- | 945.2500000000000000   | 4     |
-- | 936.0000000000000000   | 11    |
-- | 899.5500000000000000   | 4     |
-- | 897.0000000000000000   | 20    |
-- | 851.0100000000000000   | 4     |
-- | 850.4000000000000000   | 1     |


-- select unit_price, count(*) from analytics GROUP BY unit_price ORDER BY unit_price DESC limit 10;
-- select unit_price, count(*) from analytics_copy GROUP BY unit_price ORDER BY unit_price DESC limit 10;

-- select unit_price, count(*) from analytics_copy WHERE unit_price= 0 GROUP BY unit_price ORDER BY unit_price DESC limit 10;
-- "unit_price"	"count"
-- 0.00			188314

-- check against current analytics
-- select unit_price, count(*) from analytics WHERE unit_price= 0 GROUP BY unit_price ORDER BY unit_price DESC limit 10;
-- "unit_price"	"count"
-- 0.00			188314

-- NO fix needed


--- PART 3 STARTING WITH QUESTIONS
-- 3.1
-- Question 1: Which cities and countries have the highest level of transaction revenues on the site?

-- select * from all_sessions LIMIT 200;

-- SELECT 
--     country, 
--     SUM(productPrice) as Sum_in_Millions, 
--     currencyCode 
-- FROM 
--     all_sessions 
-- WHERE 
--     country IS NOT NULL AND city <> '(not set)'
-- GROUP BY 
--     country, 
--     currencyCode 
-- ORDER BY 
--     SUM_in_Millions DESC 
-- LIMIT 10;

-- SELECT 
--     city, 
--     SUM(productPrice) as Sum_in_Millions, 
--     currencyCode 
-- FROM 
--     all_sessions 
-- WHERE 
--     city IS NOT NULL AND city <> '(not set)'
-- GROUP BY 
--     city, 
--     currencyCode 
-- ORDER BY 
--     SUM_in_Millions DESC 
-- LIMIT 10;

-- SELECT 
--     city, 
--     SUM(productPrice) as Sum_in_Millions, 
--     currencyCode 
-- FROM 
--     all_sessions 
-- WHERE 
--     city IS NOT NULL AND city <> '(not set)'
-- GROUP BY 
--     city, 
--     currencyCode 
-- ORDER BY 
--     SUM_in_Millions DESC 
-- LIMIT 10;

-- SELECT 
-- 	p.SKU,
-- 	-- this is different p.orderedquantity as product_ordered_quantity,
-- 	sbs.total_ordered as sales_sku_total_ordered,
-- 	sr.total_ordered as sales_report_total_ordered
-- FROM
-- 	products AS p
-- 	JOIN sales_by_sku AS sbs ON p.SKU = sbs.productsku
-- 	JOIN sales_report AS sr ON p.SKU = sr.productsku;
-- -- RETURNS they seem to be storing the SAME information?!
-- "sku"	"total_ordered"	"total_ordered-2"
-- "GGOEGAAX0581"	0	0
-- "9181139"	0	0
-- "GGOEGAAX0596"	1	1
-- "GGOEGAAX0365"	0	0
-- "GGOEGAAX0325"	6	6
-- "GGOEGAAX0296"	0	0
-- "GGOEGHGH019699"	14	14
-- "GGOEGDWR015799"	5	5
-- "GGOEGAAX0081"	42	42
-- "GGOEGALB036514"	8	8

-- SELECT 
-- 	p.SKU,
-- 	p.orderedquantity as product_ordered_quantity,
-- 	sbs.total_ordered as sales_sku_total_ordered,
-- 	sr.total_ordered as sales_report_total_ordered
-- FROM
-- 	products AS p
-- 	JOIN sales_by_sku AS sbs ON p.SKU = sbs.productsku
-- 	JOIN sales_report AS sr ON p.SKU = sr.productsku;
-- how is products ordered quantity larger than sales_by_sku or sales_report total ordered
-- "sku"	"product_ordered_quantity"	"sales_sku_total_ordered"	"sales_report_total_ordered"
-- "GGOEGAAX0581"	0	0	0
-- "9181139"	0	0	0
-- "GGOEGAAX0596"	26	1	1
-- "GGOEGAAX0365"	65	0	0
-- "GGOEGAAX0325"	53	6	6
-- "GGOEGAAX0296"	19	0	0
-- "GGOEGHGH019699"	1573	14	14
-- | sku           | product_ordered_quantity | sales_sku_total_ordered | sales_report_total_ordered |
-- |---------------|--------------------------|-------------------------|-----------------------------|
-- | GGOEGAAX0581  | 0                        | 0                       | 0                           |
-- | 9181139       | 0                        | 0                       | 0                           |
-- | GGOEGAAX0596  | 26                       | 1                       | 1                           |
-- | GGOEGAAX0365  | 65                       | 0                       | 0                           |
-- | GGOEGAAX0325  | 53                       | 6                       | 6                           |
-- | GGOEGAAX0296  | 19                       | 0                       | 0                           |
-- | GGOEGHGH019699 | 1573                     | 14                      | 14                          |

-- Hypothesis if total_ordered are the same in sales_by_sku and sales_report
-- but the number of rows is different which productSKU's are missing between them?
-- SELECT sbs.productsku AS missing_sku
-- FROM sales_by_sku AS sbs
-- LEFT JOIN sales_report AS sr ON sbs.productsku = sr.productsku
-- WHERE sr.productsku IS NULL;
-- RETURNS
-- "missing_sku"
-- "GGOEYAXR066128"
-- "GGOEGALJ057912"

-- select * from sales_by_sku where productsku = 'GGOEYAXR066128' OR productsku = 'GGOEGALJ057912';
-- RETURNS
-- "salesbysku_id"	"productsku"	"total_ordered"
-- 166				"GGOEYAXR066128"	3
-- 239				"GGOEGALJ057912"	2

-- this leads me to want to DROP the sales_report table because it has 2 less SKU's
-- but it has a column called ratio that is missing from sales_by_sku
-- Since we want to limit any destructive losses, no tables dropped but definately a future discussion.

-- let's just double check and see if they are all the same data
-- SELECT sbs.productSKU, sbs.total_ordered AS sales_by_sku_total_ordered, sr.total_ordered AS sales_report_total_ordered
-- FROM sales_by_sku AS sbs
-- JOIN sales_report AS sr ON sbs.productSKU = sr.productSKU
-- WHERE sbs.total_ordered <> sr.total_ordered;
-- RETURNS NOTHING so every SKU has the same total_ordered in both tables 
-- EQUALS redundant columns CONFIRMED


-- CONCERN???
-- what are these values actually reporting? illustrates why you need a SME to make sense of the dat


-- Question 2: What is the average number of products ordered from visitors in each city and country?
-- select count(*) from analytics_copy;

-- SELECT 
-- 	country,
-- 	round(AVG(p.orderedQuantity),0) as average_products_ordered
-- FROM
-- 	all_sessions as als
-- JOIN products as p ON als.productSKU = p.SKU
-- GROUP BY
-- 	country
-- ORDER BY
-- 	average_products_ordered DESC
-- LIMIT 10;

-- SELECT 
-- 	city,
-- 	round(AVG(p.orderedQuantity),0) as average_products_ordered
-- FROM
-- 	all_sessions as als
-- JOIN products as p ON als.productSKU = p.SKU
-- WHERE 
--     city IS NOT NULL AND city <> '(not set)'
-- GROUP BY
-- 	city
-- ORDER BY
-- 	average_products_ordered DESC
-- LIMIT 10;

-- Merge booth into single query?
-- my failed attempt
-- SELECT 
-- 	country as Name,
-- 	'country' as Type,
-- 	round(AVG(p.orderedQuantity),0) as average_products_ordered
-- FROM
-- 	all_sessions as als
-- JOIN products as p ON als.productSKU = p.SKU
-- GROUP BY
-- 	country
-- LIMIT 10
-- union 
-- SELECT 
-- 	city as Name,
-- 	'city' as Type,
-- 	round(AVG(p.orderedQuantity),0) as average_products_ordered
-- FROM
-- 	all_sessions as als
-- JOIN products as p ON als.productSKU = p.SKU
-- WHERE 
--     city IS NOT NULL AND city <> '(not set)'
-- GROUP BY
-- 	city
-- ORDER BY
-- 	average_products_ordered DESC
-- LIMIT 10;


-- -- merged result
-- SELECT 
--     Name,
--     Type,
--     ROUND(average_products_ordered, 0) AS average_products_ordered
-- FROM (
--     SELECT 
--         country AS Name,
--         'country' AS Type,
--         AVG(p.orderedQuantity) AS average_products_ordered
--     FROM
--         all_sessions AS als
--     JOIN products AS p ON als.productSKU = p.SKU
--     GROUP BY country
--     UNION 
--     SELECT 
--         city AS Name,
--         'city' AS Type,
--         AVG(p.orderedQuantity) AS average_products_ordered
--     FROM
--         all_sessions AS als
--     JOIN products AS p ON als.productSKU = p.SKU
--     WHERE 
--         city IS NOT NULL AND city <> '(not set)'
--     GROUP BY city
-- ) AS combined
-- ORDER BY average_products_ordered DESC
-- LIMIT 10;

-- Part 3 Question 3
-- Question 3: Is there any pattern in the types (product categories) of products ordered from visitors in each city and country?


-- SELECT 
--     Name,
--     Type,
--     v2ProductCategory,
--     ROUND(average_products_ordered, 0) AS average_products_ordered
-- FROM (
--     SELECT 
--         country AS Name,
--         'country' AS Type,
--         v2ProductCategory,
--         AVG(p.orderedQuantity) AS average_products_ordered
--     FROM
--         all_sessions AS als
--     JOIN products AS p ON als.productSKU = p.SKU
--     GROUP BY country, v2ProductCategory
--     UNION 
--     SELECT 
--         city AS Name,
--         'city' AS Type,
--         v2ProductCategory,
--         AVG(p.orderedQuantity) AS average_products_ordered
--     FROM
--         all_sessions AS als
--     JOIN products AS p ON als.productSKU = p.SKU
--     WHERE 
--         city IS NOT NULL AND city <> '(not set)'
--     GROUP BY city, v2ProductCategory
-- ) AS combined
-- ORDER BY average_products_ordered DESC
-- LIMIT 10;

-- -- returns
-- | name | type | v2productcategory | average_products_ordered |
-- | --- | --- | --- | --- |
-- | Council Bluffs | city | Home/Accessories/Fun/ | 15170 |
-- | Santiago | city | Home/Lifestyle/ | 15170 |
-- | Russia | country | Home/Accessories/Sports & Fitness/ | 15170 |
-- | Chile | country | Home/Lifestyle/ | 15170 |
-- | Kirkland | city | Home/Accessories/Fun/ | 15170 |
-- | San Bruno | city | Home/Accessories/Sports & Fitness/ | 15170 |
-- | Moscow | city | Home/Accessories/Sports & Fitness/ | 15170 |
-- | Santa Clara | city | Home/Accessories/Sports & Fitness/ | 15170 |
-- | San Diego | city | Home/Accessories/Sports & Fitness/ | 15170 |
-- | United States | country | Drinkware | 10075 |

-- -- let's check SUM for pattern
-- IGNORE this, not part of the question

-- SELECT 
--     Name,
--     Type,
--     v2ProductCategory,
--     ROUND(productSum::NUMERIC, 0) AS productSum
-- FROM (
--     SELECT 
--         country AS Name,
--         'country' AS Type,
--         v2ProductCategory,
--         SUM(productPrice) AS productSum
--     FROM
--         all_sessions AS als
--     GROUP BY country, v2ProductCategory
--     UNION 
--     SELECT 
--         city AS Name,
--         'city' AS Type,
--         v2ProductCategory,
--         SUM(productPrice) AS productSum
--     FROM
--         all_sessions AS als
--     WHERE 
--         city IS NOT NULL AND city <> '(not set)'
--     GROUP BY city, v2ProductCategory
-- ) AS combined
-- ORDER BY productSum DESC
-- LIMIT 10;

-- -- RESULTS
-- -- | name | type | v2productcategory | productsum |
-- -- | --- | --- | --- | --- |
-- -- | United States | country | Home/Nest/Nest-USA/ | 58203 |
-- -- | United States | country | Home/Apparel/Men's/Men's-Outerwear/ | 29871 |
-- -- | United States | country | Home/Apparel/Men's/Men's-T-Shirts/ | 21760 |
-- -- | United States | country | Home/Shop by Brand/Google/ | 18760 |
-- -- | United States | country | Home/Electronics/ | 17976 |
-- -- | Mountain View | city | Home/Nest/Nest-USA/ | 15407 |
-- -- | United States | country | Home/Apparel/ | 14054 |
-- -- | United States | country | Home/Shop by Brand/YouTube/ | 11995 |
-- -- | United States | country | Home/Bags/ | 9280 |
-- -- | United States | country | Home/Apparel/Women's/Women's-Outerwear/ | 8457 |


-- select v2productcategory from all_sessions where v2productcategory LIKE 'Home/%';
-- returns 14,312 rows

-- select v2productcategory as category, count(*) from all_sessions where v2productcategory LIKE 'Home/%' GROUP BY category ORDER BY count DESC;
-- returns 58 rows
-- "category"	"count"
-- "Home/Shop by Brand/YouTube/"	2448
-- "Home/Apparel/Men's/Men's-T-Shirts/"	1955
-- "Home/Electronics/"	852
-- "Home/Apparel/"	831
-- "Home/Shop by Brand/Google/"	729
-- "Home/Office/"	654
-- "Home/Apparel/Men's/Men's-Outerwear/"	613
-- "Home/Drinkware/"	514
-- "Home/Bags/"	511
-- "Home/Nest/Nest-USA/"	436
-- "Home/Apparel/Men's/"	409
-- "Home/Apparel/Women's/Women's-T-Shirts/"	403
-- "Home/Accessories/"	310
-- "Home/Shop by Brand/Android/"	292
-- "Home/Apparel/Headgear/"	252
-- "Home/Accessories/Fun/"	229
-- "Home/Electronics/Audio/"	211
-- "Home/Accessories/Stickers/"	188
-- "Home/Lifestyle/"	185
-- "Home/Apparel/Women's/"	175
-- "Home/Electronics/Electronics Accessories/"	165
-- "Home/Shop by Brand/"	154
-- "Home/Drinkware/Water Bottles and Tumblers/"	146
-- "Home/Bags/Backpacks/"	146
-- "Home/Office/Notebooks & Journals/"	138
-- "Home/Apparel/Women's/Women's-Outerwear/"	137
-- "Home/Apparel/Men's/Men's-Performance Wear/"	104
-- "Home/Office/Writing Instruments/"	100
-- "Home/Accessories/Drinkware/"	95
-- "Home/Apparel/Kid's/Kid's-Infant/"	85
-- "Home/Apparel/Kid's/"	76
-- "Home/Bags/More Bags/"	75
-- "Home/Accessories/Housewares/"	71
-- "Home/Limited Supply/Bags/"	64
-- "Home/Apparel/Kid's/Kids-Youth/"	60
-- "Home/Electronics/Power/"	54
-- "Home/Apparel/Kid's/Kid's-Toddler/"	52
-- "Home/Apparel/Women's/Women's-Performance Wear/"	48
-- "Home/Drinkware/Mugs and Cups/"	43
-- "Home/Fruit Games/"	39
-- "Home/Accessories/Pet/"	34
-- "Home/Brands/YouTube/"	34
-- "Home/Electronics/Flashlights/"	32
-- "Home/Accessories/Sports & Fitness/"	31
-- "Home/Bags/Shopping and Totes/"	29
-- "Home/Office/Office Other/"	27
-- "Home/Brands/Android/"	24
-- "Home/Clearance Sale/"	10
-- "Home/Gift Cards/"	10
-- "Home/Spring Sale!/"	10
-- "Home/Limited Supply/"	4
-- "Home/Brands/"	3
-- "Home/Shop by Brand/Waze/"	3
-- "Home/Limited Supply/Bags/Backpacks/"	3
-- "Home/Lifestyle/Fun/"	3
-- "Home/Fun/"	3
-- "Home/Kids/"	2
-- "Home/Electronics/Accessories/Drinkware/"	1

-- Part 3 Question 4
-- Question 4: What is the top-selling product from each city/country? Can we find any pattern worthy of noting in the products sold?

-- SELECT 
--     Name,
--     Type,
--     productSKU,
--     MAX(total_ordered) AS top_selling_product
-- FROM (
--     SELECT 
--         country AS Name,
--         'country' AS Type,
--         productSKU,
--         SUM(p.orderedQuantity) AS total_ordered
--     FROM
--         all_sessions AS als
--     JOIN products AS p ON als.productSKU = p.SKU
--     GROUP BY country, productSKU, p.SKU
--     UNION 
--     SELECT 
--         city AS Name,
--         'city' AS Type,
--         productSKU,
--         SUM(p.orderedQuantity) AS total_ordered
--     FROM
--         all_sessions AS als
--     JOIN products AS p ON als.productSKU = p.SKU
--     WHERE 
--         city IS NOT NULL AND city <> '(not set)'
--     GROUP BY city, productSKU, p.SKU
-- ) AS combined
-- GROUP BY Name, Type, productSKU
-- ORDER BY top_selling_product DESC
-- LIMIT 10;
-- -- returns rubbish

-- SELECT 
--     als.country AS Country,
--     p.Name AS Top_Selling_Product,
-- 	p.SKU,
-- 	SUM(als.productPrice * als.productQuantity) AS Revenue
-- FROM 
--     all_sessions AS als
-- JOIN 
--     products AS p ON als.productSKU = p.SKU
-- GROUP BY 
--     als.country, p.Name, p.sku
-- HAVING 
--     SUM(als.productPrice * als.productQuantity) = (
--         SELECT 
--             MAX(total_revenue)
--         FROM (
--             SELECT 
--                 als2.country AS Country, 
--                 p2.Name AS Product,
--                 SUM(als2.productPrice * als2.productQuantity) AS total_revenue
--             FROM 
--                 all_sessions AS als2
--             JOIN 
--                 products AS p2 ON als2.productSKU = p2.SKU
--             GROUP BY 
--                 als2.country, p2.Name
--         ) AS country_revenue
--         WHERE 
--             Country = als.country
--     )
-- ORDER BY 
--     Country, Revenue DESC;
	
-- now let's do some investigation to see if this is accurate, especially that revenue column
-- country = Argentina
-- sku = GGOEGBRJ037299
-- response was $99.99

-- select * from products where sku = 'GGOEGBRJ037299';
-- this certainly has quantity ordered at 165 but how do we know that is for Argentina?
-- "sku"	"name"	"orderedquantity"	"stocklevel"	"restockingleadtime"	"sentimentscore"	"sentimentmagnitude"
-- "GGOEGBRJ037299"	"Alpine Style Backpack"	165	272	12	0.6	0.9
-- | sku           | name                   | orderedquantity | stocklevel | restockingleadtime | sentimentscore | sentimentmagnitude |
-- |---------------|------------------------|-----------------|------------|-------------------|----------------|---------------------|
-- | GGOEGBRJ037299 | Alpine Style Backpack  | 165             | 272        | 12                | 0.6            | 0.9                 |


-- select * from all_sessions where country ='Argentina';

-- select country, productsku, v2productname, v2productcategory, productprice FROM all_sessions where country ='Argentina' and productsku = 'GGOEGBRJ037299';
-- returns 43 returns
-- 43 items purchased from this country

-- select country, productsku, v2productname, v2productcategory, productprice FROM all_sessions where country ='Argentina' and productsku = 'GGOEGBRJ037299';
-- if we filter only our specific test product
-- there are 3 sessions with this, can we assume that means 3 quantity?

-- CONCLUSION
-- We can NOT confirm what the actual quantities are from Argentina, we only know there are 3 sessions, 
-- that the price paid was $99.99 but now how many were purchased in those 3 sessions.
-- Sure, we see in the products table 165 were ordered, but not which session placed those orders!

-- retry same query but as COUNT instead of quantity look-up
-- SELECT 
--     als.country AS Country,
--     p.Name AS Top_Selling_Product,
--     p.SKU,
--     COUNT(DISTINCT als.sessionID) AS Revenue
-- FROM 
--     all_sessions AS als
-- JOIN 
--     products AS p ON als.productSKU = p.SKU
-- GROUP BY 
--     als.country, p.Name, p.sku
-- HAVING 
--     COUNT(DISTINCT als.sessionID) = (
--         SELECT 
--             MAX(total_revenue)
--         FROM (
--             SELECT 
--                 als2.country AS Country, 
--                 p2.Name AS Product,
--                 COUNT(DISTINCT als2.sessionID) AS total_revenue
--             FROM 
--                 all_sessions AS als2
--             JOIN 
--                 products AS p2 ON als2.productSKU = p2.SKU
--             GROUP BY 
--                 als2.country, p2.Name
--         ) AS country_revenue
--         WHERE 
--             Country = als.country
--     )
-- ORDER BY 
--     Country, Revenue DESC;

-- -- works but wrong labels
-- SELECT 
--     als.country AS Country,
--     p.Name AS Top_Selling_Product,
--     p.SKU,
--     COUNT(DISTINCT allsession_ID) AS Count_of_Sessions
-- FROM 
--     all_sessions AS als
-- JOIN 
--     products AS p ON als.productSKU = p.SKU
-- GROUP BY 
--     als.country, p.Name, p.sku
-- HAVING 
--     COUNT(DISTINCT allsession_ID) = (
--         SELECT 
--             MAX(Count_of_Sessions)
--         FROM (
--             SELECT 
--                 als2.country AS Country, 
--                 p2.Name AS Product,
--                 COUNT(DISTINCT allsession_ID) AS Count_of_Sessions
--             FROM 
--                 all_sessions AS als2
--             JOIN 
--                 products AS p2 ON als2.productSKU = p2.SKU
--             GROUP BY 
--                 als2.country, p2.Name
--         ) AS country_sessions
--         WHERE 
--             Country = als.country
--     ) 
-- ORDER BY 
--     Country, top_selling_product, Count_of_Sessions DESC;
-- -- returns 366 results
-- -- because there are many ties for each country

-- -- now modify for CITY
-- SELECT 
--     als.city AS City,
--     p.Name AS Top_Selling_Product,
--     p.SKU,
--     COUNT(DISTINCT allsession_ID) AS Count_of_Sessions
-- FROM 
--     all_sessions AS als
-- JOIN 
--     products AS p ON als.productSKU = p.SKU
-- GROUP BY 
--     als.city, p.Name, p.sku
-- HAVING 
--     COUNT(DISTINCT allsession_ID) = (
--         SELECT 
--             MAX(Count_of_Sessions)
--         FROM (
--             SELECT 
--                 als2.city AS City, 
--                 p2.Name AS Product,
--                 COUNT(DISTINCT allsession_ID) AS Count_of_Sessions
--             FROM 
--                 all_sessions AS als2
--             JOIN 
--                 products AS p2 ON als2.productSKU = p2.SKU
--             GROUP BY 
--                 als2.city, p2.Name
--         ) AS city_sessions
--         WHERE 
--             city = als.city
--     ) 
-- ORDER BY 
--     City, top_selling_product, Count_of_Sessions DESC;
-- -- returns 711 results


-- qa.md #3
-- More Data Cleaning
-- foreign key on SKU missing from all_sessions and products = WHY?
-- SELECT als.productSKU AS all_sessions_sku, p.SKU AS products_sku
-- FROM all_sessions AS als
-- LEFT JOIN products AS p ON als.productSKU = p.SKU
-- WHERE p.SKU IS NULL OR als.productSKU IS NULL OR p.SKU <> als.productSKU
-- -- RETURNS 2033
-- -- There are 2033 sku's in all_sessions that are missing in products table

-- check mismatched VISITid's between all_sessions and analytics for question 5.
-- SELECT als.visitID AS sessions_VisitID, ay.visitID AS analytics_VisitID
-- FROM all_sessions AS als
-- LEFT JOIN analytics AS ay ON als.visitID = ay.visitID
-- WHERE ay.visitID IS NULL OR als.visitID IS NULL OR ay.visitID <> als.visitID;
-- -- Returns 11,375 rows
-- -- So there are 11,375 visitID sessions in all_sessions that are missing in the analytics.

-- -- check how many revenues exist greater then 0
-- SELECT 
--     Revenue, 
--     COUNT(*) AS Count
-- FROM 
--     analytics 
-- WHERE 
--     Revenue > 0
-- GROUP BY 
--     Revenue;
-- -- RETURNS 5269

-- SELECT 
--     VisitID, 
--     COUNT(*) AS Count
-- FROM 
--     analytics 
-- WHERE 
--     Revenue > 0
-- GROUP BY 
--     VisitID, Revenue;
-- -- Returns 13412 visitID's with revenues

-- -- how many visitID's with NO Revenue?
-- SELECT 
--     VisitID, 
--     COUNT(*) AS Count
-- FROM 
--     analytics 
-- WHERE 
--     Revenue = 0 or revenue is null
-- GROUP BY 
--     VisitID, Revenue;
-- -- Returns 148,642

-- SELECT 
--     VisitID, 
--     COUNT(*) AS Count
-- FROM 
--     analytics 
-- WHERE 
--     Revenue >0
-- GROUP BY 
--     VisitID, Revenue;
-- -- Returns 13,412 have revenue, how is this possible? DUPLICATE VisitID's

-- SELECT  
--     COUNT(*) AS Count
-- FROM 
--     analytics 
-- WHERE 
--     Revenue = 0 or revenue is null;
-- -- Returns single number 4,285,767

-- -- how many visitIDs in the Analytics table?
-- select distinct visitID from analytics;
-- -- 148,642


--- ERD diagram
-- and STARTING with DATA
-- Question 1
-- -- test for duplicates of fullvisitorID
-- SELECT fullvisitorid, COUNT(*) as count
-- FROM all_sessions
-- GROUP BY fullvisitorid
-- HAVING COUNT(*) > 1;
-- -- returns 863 duplicates

-- SELECT fullvisitorid, COUNT(*) as count
-- FROM analytics
-- GROUP BY fullvisitorid
-- HAVING COUNT(*) > 1;
-- -- returns 118,574 duplicates


-- -- test for duplicates of visitID
-- SELECT visitid, COUNT(*) as count
-- FROM all_sessions
-- GROUP BY visitid
-- HAVING COUNT(*) > 1;
-- -- returns 553 duplicates

-- SELECT visitid, COUNT(*) as count
-- FROM analytics
-- GROUP BY visitid
-- HAVING COUNT(*) > 1;
-- -- returns 146,517 duplicates


-- Question 2
-- Find all duplicates
-- DO $$DECLARE
--     r RECORD;
-- BEGIN
--     FOR r IN (SELECT table_name,column_name FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'all_sessions')
--     LOOP
--         EXECUTE format('SELECT %1$I, COUNT(*) FROM %2$I GROUP BY %1$I HAVING COUNT(*) > 1', r.column_name, r.table_name) INTO r;
--         IF FOUND THEN
--             RAISE NOTICE 'Table: %, Column: %, Duplicates: %', r.table_name, r.column_name, r.count;
--         END IF;
--     END LOOP;
-- END$$;

-- SELECT table_name,column_name FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'all_sessions'
-- -- returns 33 fields in the all_sessions table
-- -- "table_name"	"column_name"
-- -- "all_sessions"	"allsession_id"
-- -- "all_sessions"	"fullvisitorid"
-- -- "all_sessions"	"channelgrouping"
-- -- "all_sessions"	"time"
-- -- "all_sessions"	"country"
-- -- "all_sessions"	"city"
-- -- "all_sessions"	"totaltransactionrevenue"
-- -- "all_sessions"	"transactions"
-- -- "all_sessions"	"timeonsite"
-- -- "all_sessions"	"pageviews"
-- -- "all_sessions"	"sessionqualitydim"
-- -- "all_sessions"	"date"
-- -- "all_sessions"	"visitid"
-- -- "all_sessions"	"type"
-- -- "all_sessions"	"productrefundamount"
-- -- "all_sessions"	"productquantity"
-- -- "all_sessions"	"productprice"
-- -- "all_sessions"	"productrevenue"
-- -- "all_sessions"	"productsku"
-- -- "all_sessions"	"v2productname"
-- -- "all_sessions"	"v2productcategory"
-- -- "all_sessions"	"productvariant"
-- -- "all_sessions"	"currencycode"
-- -- "all_sessions"	"itemquantity"
-- -- "all_sessions"	"itemrevenue"
-- -- "all_sessions"	"transactionrevenue"
-- -- "all_sessions"	"transactionid"
-- -- "all_sessions"	"pagetitle"
-- -- "all_sessions"	"searchkeyword"
-- -- "all_sessions"	"pagepathlevel1"
-- -- "all_sessions"	"ecommerceaction_type"
-- -- "all_sessions"	"ecommerceaction_step"
-- -- "all_sessions"	"ecommerceaction_option"

-- SELECT fullvisitorID, COUNT(*) FROM all_sessions GROUP BY fullvisitorID HAVING COUNT(*) > 1;
-- -- returns 863 duplicates

-- DO $$DECLARE
--     r RECORD;
--     duplicates_found boolean := false;
-- BEGIN
--     FOR r IN (SELECT table_name,column_name FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'all_sessions')
--     LOOP
--         EXECUTE format('SELECT %1$I, COUNT(*) FROM %2$I GROUP BY %1$I HAVING COUNT(*) > 1', r.column_name, r.table_name) INTO r;
--         IF FOUND THEN
--             RAISE NOTICE 'Table: %, Column: %, Duplicates: %', r.table_name, r.column_name, r.count;
--             duplicates_found := true;
--         END IF;
--     END LOOP;
    
--     IF NOT duplicates_found THEN
--         RAISE NOTICE 'No duplicates found in any table';
--     END IF;
-- END$$;


-- -- adding duplicate tracker for whole database and ELSE if column returns no duplicates
-- -- modified again to filer out analytics_copy and sort results by table and column names
-- -- SELECT table_name, column_name FROM information_schema.columns WHERE table_schema = 'public' and table_name <> 'analytics_copy' ORDER BY table_name,column_name
-- DO $$
-- DECLARE
--     r RECORD;
--     duplicates_found BOOLEAN := false;
--     result RECORD;
-- BEGIN
--     FOR r IN (SELECT table_name, column_name FROM information_schema.columns WHERE table_schema = 'public' and table_name <> 'analytics_copy' ORDER BY table_name,column_name
-- )
--     LOOP
--         EXECUTE format('SELECT %1$I, COUNT(*) FROM %2$I GROUP BY %1$I HAVING COUNT(*) > 1', r.column_name, r.table_name) INTO result;
--         IF RESULT.count >1 THEN -- found returned from execute call
--             RAISE NOTICE 'Table: %, Column: %, Duplicates: %', r.table_name, r.column_name, result.count;
--             duplicates_found := true;
-- 		ELSE
-- 			RAISE NOTICE 'Table: %, Column: %, NO Duplicates found.', r.table_name, r.column_name;
--         END IF;
--     END LOOP;
    
--     IF NOT duplicates_found THEN
--         RAISE NOTICE 'ZERO duplicates found in any table!';
--     END IF;
-- END$$;



-- Question 3
-- Find each unique product viewed by each visitor.

-- SELECT visitid, array_agg(DISTINCT productSKU) as unique_products_viewed
-- FROM all_sessions
-- JOIN products ON all_sessions.productSKU = products.SKU
-- GROUP BY visitid;
-- -- returns 12,678 rows

-- SELECT visitid, productSKU, v2ProductName as ProdName, v2ProductCategory as ProdCategory
-- FROM all_sessions
-- JOIN products ON all_sessions.productSKU = products.SKU
-- GROUP BY visitid, productSKU, ProdName, ProdCategory
-- Order By visitid;
-- -- returns 13,099 rows
-- -- sample output
-- -- "visitid"	"productsku"	"prodname"	"prodcategory"
-- -- 1470037277	"GGOEGOAQ018099"	"Pen Pencil & Highlighter Set"	"Home/Office/"
-- -- 1470040969	"GGOEGFAQ016699"	"Bottle Opener Clip"	"Home/Accessories/Drinkware/"
-- -- 1470042235	"GGOEGAAX0283"	"Android Women's Short Sleeve Hero Tee Black"	"Home/Shop by Brand/Google/"
-- -- 1470042235	"GGOEGAAX0356"	"YouTube Men's Vintage Tank"	"Home/Apparel/Men's/Men's-T-Shirts/"
-- -- 1470046384	"GGOEGAAX0358"	"Google Men's  Zip Hoodie"	"Home/Apparel/Men's/"
-- -- 1470050586	"GGOEGAAX0318"	"YouTube Men's Short Sleeve Hero Tee Black"	"Home/Brands/YouTube/"
-- -- 1470051098	"GGOEGAAX0340"	"Google Men's Vintage Badge Tee Green"	"Home/Apparel/Men's/Men's-T-Shirts/"
-- -- 1470057334	"GGOEGAAX0284"	"Women's YouTube Short Sleeve Hero Tee Black"	"Home/Brands/YouTube/"
-- -- 1470063289	"GGOEGAAX0662"	"Android Toddler Short Sleeve T-shirt Pewter"	"Home/Shop by Brand/"
-- -- 1470063888	"GGOEGAAX0105"	"Google Men's 100% Cotton Short Sleeve Hero Tee Black"	"Home/Apparel/Men's/"

-- SELECT als.visitid, productSKU, v2ProductName as ProdName, v2ProductCategory as ProdCategory
-- FROM all_sessions as als
-- JOIN products ON als.productSKU = products.SKU
-- JOIN analytics ON als.visitID = analytics.visitID
-- GROUP BY als.visitid, productSKU, ProdName, ProdCategory
-- Order By als.visitid;