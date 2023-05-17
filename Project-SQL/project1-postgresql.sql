
/*******************************************************************************
   Lighthouse Labs SQL Project 1 Database - Version 1.0
   Script: Project1_PostgreSql.sql
   Description: Creates and populates the Project 1 database.
   DB Server: PostgreSql
   Author: Clinton Boyda
********************************************************************************/

/*******************************************************************************
   REMOVE Tables Initialize Database
********************************************************************************/

DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS sales_by_sku;
DROP TABLE IF EXISTS sales_report;
DROP TABLE IF EXISTS analytics;
DROP TABLE IF EXISTS all_sessions;

/*******************************************************************************
   Create Tables
********************************************************************************/

CREATE TABLE IF NOT EXISTS products
(
    SKU VARCHAR(200) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    orderedQuantity INT NOT NULL,
    stockLevel INT NOT NULL,
    restockingLeadTime INT NOT NULL,
    sentimentScore NUMERIC(2,1), -- sometimes null
    sentimentMagnitude NUMERIC(2,1) -- sometimes null
);

CREATE TABLE IF NOT EXISTS sales_by_sku
(
    salesbysku_id serial PRIMARY KEY,
    productSKU VARCHAR(200) NOT NULL,
    total_ordered INT NOT NULL
    ,FOREIGN KEY (productSKU)
        REFERENCES products(SKU) ON DELETE CASCADE ON UPDATE CASCADE
);

-- unable to maintain foreign product key 
ALTER TABLE public.sales_by_sku DROP CONSTRAINT sales_by_sku_productsku_fkey;

CREATE TABLE IF NOT EXISTS sales_report
(
    salesreport_id serial PRIMARY KEY,
    productSKU VARCHAR(200) NOT NULL,
    total_ordered INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    stockLevel INT NOT NULL,
    restockingLeadTime INT NOT NULL,
    sentimentScore NUMERIC(2,1) NOT NULL,
    sentimentMagnitude NUMERIC(2,1) NOT NULL,
    ratio DECIMAL
    ,FOREIGN KEY (productSKU)
        REFERENCES products(SKU) ON DELETE CASCADE ON UPDATE CASCADE
);



CREATE TABLE IF NOT EXISTS analytics
(
    analytics_id BIGSERIAL PRIMARY KEY,
    visitNumber INT NOT NULL,
    visitId NUMERIC(11,0) NOT NULL,
    visitStartTime NUMERIC NOT NULL,
    date DATE NOT NULL,
    fullvisitorId NUMERIC NOT NULL,
    userid NUMERIC, -- empty?
    channelGrouping VARCHAR(255) NOT NULL,
    socialEngagementType VARCHAR(100) NOT NULL,
    units_sold VARCHAR(50), -- some null imports
    pageviews INT,
    timeonsite NUMERIC, -- almost empty
    bounces INT,
    revenue NUMERIC, -- empty?
    unit_price NUMERIC(11,2) NOT NULL
);

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

CREATE TABLE IF NOT EXISTS all_sessions
(
    allsession_id BIGSERIAL PRIMARY KEY,
    fullvisitorId NUMERIC NOT NULL,
    channelGrouping VARCHAR(255) NOT NULL,
    time INT NOT NULL,
    country VARCHAR(255) NOT NULL,
    city VARCHAR(255) NOT NULL,
    totalTransactionRevenue NUMERIC, -- empty?
    transactions NUMERIC, -- empty?
    timeOnSite INT, 
    pageviews INT NOT NULL,
    sessionQualityDim INT,
    date DATE NOT NULL,
    visitId NUMERIC(11,0) NOT NULL,
    type VARCHAR(10) NOT NULL,
    productRefundAmount NUMERIC, -- empty?
    productQuantity INT, -- empty?
    productPrice NUMERIC NOT NULL,
    productRevenue NUMERIC, -- empty?
    productSKU VARCHAR(200) NOT NULL,
    v2ProductName VARCHAR(255) NOT NULL,
    v2ProductCategory VARCHAR(255) NOT NULL,
    productVariant VARCHAR(20) NOT NULL,
    currencyCode VARCHAR(10) NOT NULL,
    itemQuantity INT, -- empty?
    itemRevenue VARCHAR(100), -- empty?
    transactionRevenue NUMERIC, -- >11,2 empty?
    transactionId VARCHAR(100), -- mostly empty
    pageTitle VARCHAR(100) NOT NULL,
    searchKeyword VARCHAR(100), -- empty?
    pagePathLevel1 VARCHAR(50) NOT NULL,
    eCommerceAction_type INT NOT NULL,
    eCommerceAction_step INT NOT NULL,
    eCommerceAction_option VARCHAR(100) -- mostly empty
    ,FOREIGN KEY (productSKU)
        REFERENCES products(SKU) ON DELETE CASCADE ON UPDATE CASCADE
);

-- unable to maintain foreign product key 
ALTER TABLE public.all_sessions DROP CONSTRAINT all_sessions_productsku_fkey;


/*******************************************************************************
   Restart Identity for Tables
********************************************************************************/

TRUNCATE TABLE products RESTART IDENTITY CASCADE;
TRUNCATE TABLE sales_by_sku RESTART IDENTITY;
TRUNCATE TABLE sales_report RESTART IDENTITY;
TRUNCATE TABLE analytics RESTART IDENTITY;
TRUNCATE TABLE all_sessions RESTART IDENTITY;

/*******************************************************************************
   Import Table Data from CSV files
********************************************************************************/

-- doesn't work on AWS RDS
-- ERROR:  COPY from a file is not supported

-- COPY products(SKU,name,orderedQuantity,stockLevel,restockingLeadTime,sentimentScore,sentimentMagnitude)
-- FROM '/Users/clintonboyda/Documents/GitHub/LighthouseLabs/SQL Data Files/products.csv' 
-- DELIMITER ',' 
-- CSV HEADER;

-- COPY sales_by_sku(productSKU,total_ordered)
-- FROM '/Users/clintonboyda/Documents/GitHub/LighthouseLabs/SQL Data Files/sales_by_sku.csv' 
-- DELIMITER ',' 
-- CSV HEADER;
	
-- COPY sales_report(productSKU,total_ordered,name,stockLevel,restockingLeadTime,sentimentScore,sentimentMagnitude,ratio)
-- FROM '/Users/clintonboyda/Documents/GitHub/LighthouseLabs/SQL Data Files/sales_report.csv' 
-- DELIMITER ',' 
-- CSV HEADER;

-- COPY analytics(visitNumber,visitId,visitStartTime,date,fullvisitorId,userid,channelGrouping,socialEngagementType,units_sold,pageviews,timeonsite,bounces,revenue,unit_price)
-- FROM '/Users/clintonboyda/Documents/GitHub/LighthouseLabs/SQL Data Files/analytics.csv' 
-- DELIMITER ',' 
-- CSV HEADER;

-- COPY all_sessions(fullVisitorId,channelGrouping,time,country,city,totalTransactionRevenue,transactions,timeOnSite,pageviews,sessionQualityDim,date,visitId,type,productRefundAmount,productQuantity,productPrice,productRevenue,productSKU,v2ProductName,v2ProductCategory,productVariant,currencyCode,itemQuantity,itemRevenue,transactionRevenue,transactionId,pageTitle,searchKeyword,pagePathLevel1,eCommerceAction_type,eCommerceAction_step,eCommerceAction_option)
-- FROM '/Users/clintonboyda/Documents/GitHub/LighthouseLabs/SQL Data Files/all_sessions.csv' 
-- DELIMITER ',' 
-- CSV HEADER;

/*******************************************************************************
   DATA Cleaning and Corrections
********************************************************************************/

-- FIX for 0
UPDATE analytics
SET unit_price=ROUND(unit_price/1000000,2);
-- UPDATE 4301122
-- Query returned successfully in 1 min 5 secs.

-- FIX for 1 (b)
UPDATE analytics
SET pageviews=0
WHERE pageviews IS NULL;

-- FIX for 1 (d)
UPDATE analytics
SET bounces=0
WHERE bounces IS NULL;

-- FIX for 1 (f)
UPDATE products
SET sentimentscore=0
WHERE sentimentscore IS NULL;

-- FIX for 1 (g)
UPDATE products
SET sentimentmagnitude=0.1
WHERE sentimentmagnitude IS NULL;

-- FIX for #4
UPDATE analytics
SET units_sold=0
WHERE units_sold ='';
-- UPDATE 4205975
-- Query returned successfully in 55 secs 886 msec.

ALTER TABLE public.analytics ALTER COLUMN units_sold TYPE integer USING units_sold::integer;

-- FIX for #5
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

INSERT INTO products (sku, name, orderedquantity, stocklevel, restockingleadtime, sentimentscore, sentimentmagnitude) 
VALUES ('GGOEYAXR066128', ' Toddler Short Sleeve Tee Red',0,0,0,0,0.1);

INSERT INTO products (sku, name, orderedquantity, stocklevel, restockingleadtime, sentimentscore, sentimentmagnitude) 
VALUES ('GGOEGALJ057912', ' Women''s Short Sleeve Performance Tee Charcoal',0,0,0,0,0.1);

DELETE FROM sales_by_sku where productsku IN('9180753','9184677','9184663','9182763','9182779','9182182');

ALTER TABLE public.sales_by_sku ADD CONSTRAINT sales_by_sku_fk FOREIGN KEY (productsku) REFERENCES public.products(sku) ON DELETE CASCADE ON UPDATE CASCADE;

-- FIX for #8
UPDATE all_sessions
SET itemrevenue=0
WHERE itemrevenue ='';
--  UPDATE 15134
--- Query returned successfully in 317 msec.

ALTER TABLE public.all_sessions ALTER COLUMN itemrevenue TYPE integer USING itemrevenue::integer;


-- FIX for #9
ALTER TABLE all_sessions DROP COLUMN IF EXISTS column28;

-- FIX for #13
ALTER TABLE sales_report 
DROP COLUMN IF EXISTS name, 
DROP COLUMN IF EXISTS stockLevel, 
DROP COLUMN IF EXISTS restockingLeadTime,
DROP COLUMN IF EXISTS sentimentScore,
DROP COLUMN IF EXISTS sentimentMagnitude;

-- FIX 14 (a)
UPDATE products SET name = trim(name);

-- FIX 14 (b)
UPDATE all_sessions
SET city='(not set)'
WHERE city = 'not available in demo dataset';

-- FIX 14 (d)
UPDATE all_sessions
SET sessionQualityDim=0
WHERE sessionQualityDim is NULL;
-- UPDATE 13906
-- Query returned successfully in 272 msec.

-- FIX 14 (e)
UPDATE all_sessions
SET productPrice=productPrice/1000000;
-- UPDATE 15134
-- Query returned successfully in 353 msec.

ALTER TABLE public.all_sessions ALTER COLUMN productprice TYPE money USING productprice::money;
-- I would prefer to use BIGINT 


-- FIX 14 (f)
UPDATE all_sessions
SET currencyCode = 'USD'
WHERE Country = 'United States';
-- UPDATE 8727
-- Query returned successfully in 249 msec.




-- Note these fixes could have been grouped for each table but some were needed in specific order so leaving as-is.
