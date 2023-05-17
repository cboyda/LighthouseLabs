
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

-- #9. Investigate purpose of all_sessions.column28. Is this empty? Bad data import?
-- select * from all_sessions where column28 is not null;
-- -- returns 15,134 rows

-- select * from all_sessions where column28 is null;
-- -- returns 0 rows

-- ALTER TABLE all_sessions DROP COLUMN column28;
