# Part 4: Starting with Data
## startingwithdata.md file

<details>
	<summary> Instructions from [Project-SQL/instructional_guidelines.md](https://github.com/cboyda/LighthouseLabs/blob/5c0177c223982136dfd2ba61bea07111093da181/Project-SQL/instructional_guidelines.md)</summary>

Provide the 3 - 5 new questions you decided could be answered with the data
Include the answer to each question and the accompanying queries used to obtain the answer
</details>

<details>
	<summary> Instructions from [Project-SQL/assignment.md](https://github.com/cboyda/LighthouseLabs/blob/5c0177c223982136dfd2ba61bea07111093da181/Project-SQL/assignment.md)</summary>

Consider the data you have available to you.  You can use the data to:
    - find all duplicate records
    - find the total number of unique visitors (`fullVisitorID`)
    - find the total number of unique visitors by referring sites
    - find each unique product viewed by each visitor
    - compute the percentage of visitors to the site that actually makes a purchase
    

In the **starting_with_data.md** file, write 3 - 5 new questions that you could answer with this database. For each question, include
The queries you used to answer the question
The answer to the question
</details>  

## Question 1: Find the total number of duplicate visitors (`fullVisitorID`)

Validation to ensure fullvisitorID is NOT NULL already done with table declaration.

** SQL Queries:**

```
-- test for duplicates of fullvisitorID
SELECT fullvisitorid, COUNT(*) as count
FROM all_sessions
GROUP BY fullvisitorid
HAVING COUNT(*) > 1;
-- returns 863 duplicates

SELECT fullvisitorid, COUNT(*) as count
FROM analytics
GROUP BY fullvisitorid
HAVING COUNT(*) > 1;
-- returns 118,574 duplicates


-- test for duplicates of visitID
SELECT visitid, COUNT(*) as count
FROM all_sessions
GROUP BY visitid
HAVING COUNT(*) > 1;
-- returns 553 duplicates

SELECT visitid, COUNT(*) as count
FROM analytics
GROUP BY visitid
HAVING COUNT(*) > 1;
-- returns 146,517 duplicates
```

** Answer: **
Provided in comments after each query above, not enough space for 120k rows.



## Question 2: Find all duplicate records in all tables.

** SQL Queries:**

```
DO $$
DECLARE
    r RECORD;
    duplicates_found BOOLEAN := false;
    result RECORD;
BEGIN
    FOR r IN (SELECT table_name, column_name FROM information_schema.columns WHERE table_schema = 'public')
    LOOP
        EXECUTE format('SELECT %1$I, COUNT(*) FROM %2$I GROUP BY %1$I HAVING COUNT(*) > 1', r.column_name, r.table_name) INTO result;
        IF RESULT.count >1 THEN -- found returned from execute call
            RAISE NOTICE 'Table: %, Column: %, Duplicates: %', r.table_name, r.column_name, result.count;
            duplicates_found := true;
		ELSE
			RAISE NOTICE 'Table: %, Column: %, NO Duplicates found.', r.table_name, r.column_name;
        END IF;
    END LOOP;
    
    IF NOT duplicates_found THEN
        RAISE NOTICE 'ZERO duplicates found in any table!';
    END IF;
END$$;
```

** Answer:**

```
NOTICE:  Table: all_sessions, Column: allsession_id, NO Duplicates found.
NOTICE:  Table: all_sessions, Column: channelgrouping, Duplicates: 8653
NOTICE:  Table: all_sessions, Column: city, Duplicates: 4
NOTICE:  Table: all_sessions, Column: country, Duplicates: 32
NOTICE:  Table: all_sessions, Column: currencycode, Duplicates: 15034
NOTICE:  Table: all_sessions, Column: date, Duplicates: 31
NOTICE:  Table: all_sessions, Column: ecommerceaction_option, Duplicates: 5
NOTICE:  Table: all_sessions, Column: ecommerceaction_step, Duplicates: 15116
NOTICE:  Table: all_sessions, Column: ecommerceaction_type, Duplicates: 134
NOTICE:  Table: all_sessions, Column: fullvisitorid, Duplicates: 4
NOTICE:  Table: all_sessions, Column: itemquantity, Duplicates: 15134
NOTICE:  Table: all_sessions, Column: itemrevenue, Duplicates: 15134
NOTICE:  Table: all_sessions, Column: pagepathlevel1, Duplicates: 9
NOTICE:  Table: all_sessions, Column: pagetitle, Duplicates: 15
NOTICE:  Table: all_sessions, Column: pageviews, Duplicates: 2
NOTICE:  Table: all_sessions, Column: productprice, Duplicates: 376
NOTICE:  Table: all_sessions, Column: productquantity, Duplicates: 15081
NOTICE:  Table: all_sessions, Column: productrefundamount, Duplicates: 15134
NOTICE:  Table: all_sessions, Column: productrevenue, Duplicates: 15130
NOTICE:  Table: all_sessions, Column: productsku, Duplicates: 19
NOTICE:  Table: all_sessions, Column: productvariant, Duplicates: 2
NOTICE:  Table: all_sessions, Column: searchkeyword, Duplicates: 15134
NOTICE:  Table: all_sessions, Column: sessionqualitydim, Duplicates: 2
NOTICE:  Table: all_sessions, Column: time, Duplicates: 2
NOTICE:  Table: all_sessions, Column: timeonsite, Duplicates: 3300
NOTICE:  Table: all_sessions, Column: totaltransactionrevenue, Duplicates: 15053
NOTICE:  Table: all_sessions, Column: transactionid, Duplicates: 15125
NOTICE:  Table: all_sessions, Column: transactionrevenue, Duplicates: 15130
NOTICE:  Table: all_sessions, Column: transactions, Duplicates: 15053
NOTICE:  Table: all_sessions, Column: type, Duplicates: 14942
NOTICE:  Table: all_sessions, Column: v2productcategory, Duplicates: 3
NOTICE:  Table: all_sessions, Column: v2productname, Duplicates: 4
NOTICE:  Table: all_sessions, Column: visitid, Duplicates: 2
NOTICE:  Table: analytics, Column: analytics_id, NO Duplicates found.
NOTICE:  Table: analytics, Column: bounces, Duplicates: 3826283
NOTICE:  Table: analytics, Column: channelgrouping, Duplicates: 44217
NOTICE:  Table: analytics, Column: date, Duplicates: 53717
NOTICE:  Table: analytics, Column: fullvisitorid, Duplicates: 58
NOTICE:  Table: analytics, Column: pageviews, Duplicates: 72
NOTICE:  Table: analytics, Column: revenue, Duplicates: 2
NOTICE:  Table: analytics, Column: socialengagementtype, Duplicates: 4301122
NOTICE:  Table: analytics, Column: timeonsite, Duplicates: 2078
NOTICE:  Table: analytics, Column: unit_price, Duplicates: 188314
NOTICE:  Table: analytics, Column: units_sold, Duplicates: 4205975
NOTICE:  Table: analytics, Column: userid, Duplicates: 4301122
NOTICE:  Table: analytics, Column: visitid, Duplicates: 24
NOTICE:  Table: analytics, Column: visitnumber, Duplicates: 3011055
NOTICE:  Table: analytics, Column: visitstarttime, Duplicates: 24
NOTICE:  Table: products, Column: name, Duplicates: 2
NOTICE:  Table: products, Column: orderedquantity, Duplicates: 2
NOTICE:  Table: products, Column: restockingleadtime, Duplicates: 2
NOTICE:  Table: products, Column: sentimentmagnitude, Duplicates: 99
NOTICE:  Table: products, Column: sentimentscore, Duplicates: 7
NOTICE:  Table: products, Column: sku, NO Duplicates found.
NOTICE:  Table: products, Column: stocklevel, Duplicates: 3
NOTICE:  Table: sales_by_sku, Column: productsku, NO Duplicates found.
NOTICE:  Table: sales_by_sku, Column: salesbysku_id, NO Duplicates found.
NOTICE:  Table: sales_by_sku, Column: total_ordered, Duplicates: 22
NOTICE:  Table: sales_report, Column: productsku, NO Duplicates found.
NOTICE:  Table: sales_report, Column: ratio, Duplicates: 2
NOTICE:  Table: sales_report, Column: salesreport_id, NO Duplicates found.
NOTICE:  Table: sales_report, Column: total_ordered, Duplicates: 22
DO

Query returned successfully in 2 min 23 secs.
```


## Question 3: Find each unique product viewed by each visitor.

** SQL Queries:**

```
SELECT visitid, productSKU, v2ProductName as ProdName, v2ProductCategory as ProdCategory
FROM all_sessions
JOIN products ON all_sessions.productSKU = products.SKU
GROUP BY visitid, productSKU, ProdName, ProdCategory
Order By visitid;
-- returns 13,099 rows
```

** Answer:**
Sample output, but not the whole 13,099 rows for each visit.

| visitid    | productsku        | prodname                                    | prodcategory                         |
|------------|------------------|---------------------------------------------|-------------------------------------|
| 1470037277 | GGOEGOAQ018099    | Pen Pencil & Highlighter Set                | Home/Office/                        |
| 1470040969 | GGOEGFAQ016699    | Bottle Opener Clip                          | Home/Accessories/Drinkware/         |
| 1470042235 | GGOEGAAX0283     | Android Women's Short Sleeve Hero Tee Black | Home/Shop by Brand/Google/          |
| 1470042235 | GGOEGAAX0356     | YouTube Men's Vintage Tank                  | Home/Apparel/Men's/Men's-T-Shirts/  |
| 1470046384 | GGOEGAAX0358     | Google Men's  Zip Hoodie                     | Home/Apparel/Men's/                 |
| 1470050586 | GGOEGAAX0318     | YouTube Men's Short Sleeve Hero Tee Black    | Home/Brands/YouTube/                |
| 1470051098 | GGOEGAAX0340     | Google Men's Vintage Badge Tee Green         | Home/Apparel/Men's/Men's-T-Shirts/  |
| 1470057334 | GGOEGAAX0284     | Women's YouTube Short Sleeve Hero Tee Black  | Home/Brands/YouTube/                |
| 1470063289 | GGOEGAAX0662     | Android Toddler Short Sleeve T-shirt Pewter | Home/Shop by Brand/                 |
| 1470063888 | GGOEGAAX0105     | Google Men's 100% Cotton Short Sleeve Hero Tee Black | Home/Apparel/Men's/ |


** SPECIAL NOTE: **
If the query includes a condition that the visitID must exist in the Analytics table as well, with the following query, then the results are drastically reduced:

```
SELECT als.visitid, productSKU, v2ProductName as ProdName, v2ProductCategory as ProdCategory
FROM all_sessions as als
JOIN products ON als.productSKU = products.SKU
JOIN analytics ON als.visitID = analytics.visitID
GROUP BY als.visitid, productSKU, ProdName, ProdCategory
Order By als.visitid;
-- RESULT returns 3,670 values
```


