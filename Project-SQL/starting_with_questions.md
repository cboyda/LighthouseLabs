# Part 3: Starting with Questions

## startingwithquestions.md file

<details>
<summary>instructions from Project-SQL/assignment.md</summary>

This database provides data on revenue by product as well as data on how each visitor to the site interacted with the products (when they visited, where they were based, how many pages they viewed, how long they stayed on the site, and the number of transactions they entered).

In the starting_with_questions.md file there are 5 questions you need to answer using the data. For each question, be sure to include: The queries you used to answer the question The answer to the question
</details>

<details>
<summary>instructions from Project-SQL/instructional_guidelines.md</summary>

Provide the answer to the 5 questions and the queries used to answer each question

Answer the following questions and provide the SQL queries used to find the answer.
</details>
    
## **Question 1: Which cities and countries have the highest level of transaction revenues on the site?**

"Transaction revenues" undefined, assuming it is the SUM of all_sessions.productPrice field.

** SQL Queries:

```
--- First ensure there are no NULLs in all_sessions.productPrice
SELECT *
FROM all_sessions
WHERE productprice IS NULL;

TOP 10 CITIES BY PRODUCTPRICE
```
SELECT 
    city, 
    SUM(productPrice) as Sum_in_Millions, 
    currencyCode 
FROM 
    all_sessions 
WHERE 
    city IS NOT NULL AND city <> '(not set)'
GROUP BY 
    city, 
    currencyCode 
ORDER BY 
    SUM_in_Millions DESC 
LIMIT 10;
```


** Answer:
TOP 10 CITIES
| city           | sum_in_millions | currencycode |
| --------------|----------------|--------------|
| Mountain View | $44,995.56      | USD          |
| New York       | $19,234.20      | USD          |
| San Francisco | $15,411.11      | USD          |
| Sunnyvale     | $13,340.86      | USD          |
| San Jose      | $7,631.50       | USD          |
| Los Angeles   | $6,294.24       | USD          |
| Chicago       | $5,990.02       | USD          |
| London        | $5,731.81       | USD          |
| Palo Alto     | $5,270.60       | USD          |
| Seattle       | $4,252.95       | USD          |

**  SQL Queries:
TOP 10 COUNTRIES BY PRODUCTPRICE
```
SELECT 
    country, 
    SUM(productPrice) as Sum_in_Millions, 
    currencyCode 
FROM 
    all_sessions 
WHERE 
    country IS NOT NULL AND city <> '(not set)'
GROUP BY 
    country, 
    currencyCode 
ORDER BY 
    SUM_in_Millions DESC 
LIMIT 10;
```

** Answer:
TOP 10 COUNTRIES BY PRODUCTPRICE
Here is the formatted table for "country":

| country         | sum_in_millions | currencycode |
|-----------------|----------------|--------------|
| United States   | $153,591.79    | USD          |
| India           | $8,837.61      | USD          |
| United States   | $7,474.36      | USD          |
| United Kingdom  | $5,963.74      | USD          |
| Canada          | $5,159.26      | USD          |
| Australia       | $3,599.59      | USD          |
| Japan           | $1,822.15      | USD          |
| France          | $1,699.01      | USD          |
| Ireland         | $1,478.51      | USD          |
| Hong Kong       | $1,434.01      | USD          |



## **Question 2: What is the average number of products ordered from visitors in each city and country?**


** SQL Queries:
TOP 10 Average of Products Ordered by City
```
SELECT 
	city,
	round(AVG(p.orderedQuantity),0) as average_products_ordered
FROM
	all_sessions as als
JOIN products as p ON als.productSKU = p.SKU
WHERE 
    city IS NOT NULL AND city <> '(not set)'
GROUP BY
	city
ORDER BY
	average_products_ordered DESC
LIMIT 10;
```

** Answer:
TOP 10 Average of Products Ordered by City
| city           | average_products_ordered |
|----------------|--------------------------|
| Council Bluffs | 7589                     |
| Cork           | 3786                     |
| Bellflower     | 3786                     |
| Santiago       | 3607                     |
| Bellingham     | 2836                     |
| Detroit        | 2748                     |
| Westville      | 2299                     |
| Santa Fe       | 1933                     |
| Nashville      | 1886                     |
| Brno           | 1548                     |

** SQL Queries:
TOP 10 Average of Products Ordered by Country
```
SELECT 
	country,
	round(AVG(p.orderedQuantity),0) as average_products_ordered
FROM
	all_sessions as als
JOIN products as p ON als.productSKU = p.SKU
GROUP BY
	country
ORDER BY
	average_products_ordered DESC
LIMIT 10;
```

** Answer:
TOP 10 Average of Products Ordered by Country
| country             | average_products_ordered |
|---------------------|------------------------|
| Mali                | 3786                   |
| Montenegro          | 3786                   |
| Papua New Guinea    | 2558                   |
| Réunion             | 2538                   |
| Georgia             | 2506                   |
| Côte d’Ivoire      | 1929                   |
| Moldova             | 1893                   |
| Tanzania            | 1429                   |
| Trinidad & Tobago | 1380                   |
| Armenia             | 1351                   |

** SQL Queries:
Merged result:
```
SELECT 
    Name,
    Type,
    ROUND(average_products_ordered, 0) AS average_products_ordered
FROM (
    SELECT 
        country AS Name,
        'country' AS Type,
        AVG(p.orderedQuantity) AS average_products_ordered
    FROM
        all_sessions AS als
    JOIN products AS p ON als.productSKU = p.SKU
    GROUP BY country
    UNION 
    SELECT 
        city AS Name,
        'city' AS Type,
        AVG(p.orderedQuantity) AS average_products_ordered
    FROM
        all_sessions AS als
    JOIN products AS p ON als.productSKU = p.SKU
    WHERE 
        city IS NOT NULL AND city <> '(not set)'
    GROUP BY city
) AS combined
ORDER BY average_products_ordered DESC
LIMIT 10;
```

** ANSWER:
| name             | type    | average_products_ordered |
|------------------|---------|--------------------------|
| Council Bluffs   | city    | 7589                     |
| Bellflower       | city    | 3786                     |
| Mali             | country | 3786                     |
| Montenegro       | country | 3786                     |
| Cork             | city    | 3786                     |
| Santiago         | city    | 3607                     |
| Bellingham       | city    | 2836                     |
| Detroit          | city    | 2748                     |
| Papua New Guinea | country | 2558                     |
| Réunion          | country | 2538                     |


## **Question 3: Is there any pattern in the types (product categories) of products ordered from visitors in each city and country?**

The best way to see if there are any patterns are to look at the product categories for the products ordered previous query.

** SQL Queries:

```
SELECT 
    Name,
    Type,
    v2ProductCategory,
    ROUND(average_products_ordered, 0) AS average_products_ordered
FROM (
    SELECT 
        country AS Name,
        'country' AS Type,
        v2ProductCategory,
        AVG(p.orderedQuantity) AS average_products_ordered
    FROM
        all_sessions AS als
    JOIN products AS p ON als.productSKU = p.SKU
    GROUP BY country, v2ProductCategory
    UNION 
    SELECT 
        city AS Name,
        'city' AS Type,
        v2ProductCategory,
        AVG(p.orderedQuantity) AS average_products_ordered
    FROM
        all_sessions AS als
    JOIN products AS p ON als.productSKU = p.SKU
    WHERE 
        city IS NOT NULL AND city <> '(not set)'
    GROUP BY city, v2ProductCategory
) AS combined
ORDER BY average_products_ordered DESC
LIMIT 10;
```

** Answer:

| name | type | v2productcategory | average_products_ordered |
| --- | --- | --- | --- |
| Council Bluffs | city | Home/Accessories/Fun/ | 15170 |
| Santiago | city | Home/Lifestyle/ | 15170 |
| Russia | country | Home/Accessories/Sports & Fitness/ | 15170 |
| Chile | country | Home/Lifestyle/ | 15170 |
| Kirkland | city | Home/Accessories/Fun/ | 15170 |
| San Bruno | city | Home/Accessories/Sports & Fitness/ | 15170 |
| Moscow | city | Home/Accessories/Sports & Fitness/ | 15170 |
| Santa Clara | city | Home/Accessories/Sports & Fitness/ | 15170 |
| San Diego | city | Home/Accessories/Sports & Fitness/ | 15170 |
| United States | country | Drinkware | 10075 |

So the pattern we can see is that HOME/ is definately in the popular average # of products ordered.




## **Question 4: What is the top-selling product from each city/country? Can we find any pattern worthy of noting in the products sold?**

ASSUMPTIONS: We do not know for sure the quantities of the products sold by city or country, so to answer this question we are going to assume TOP-SELLING means the product that appears in the most number of sessions, because only sessions differeniates between city and country.

** SQL Queries:
TOP-SELLING Product by Country
```
SELECT 
    als.country AS Country,
    p.Name AS Top_Selling_Product,
    p.SKU,
    COUNT(DISTINCT allsession_ID) AS Count_of_Sessions
FROM 
    all_sessions AS als
JOIN 
    products AS p ON als.productSKU = p.SKU
GROUP BY 
    als.country, p.Name, p.sku
HAVING 
    COUNT(DISTINCT allsession_ID) = (
        SELECT 
            MAX(Count_of_Sessions)
        FROM (
            SELECT 
                als2.country AS Country, 
                p2.Name AS Product,
                COUNT(DISTINCT allsession_ID) AS Count_of_Sessions
            FROM 
                all_sessions AS als2
            JOIN 
                products AS p2 ON als2.productSKU = p2.SKU
            GROUP BY 
                als2.country, p2.Name
        ) AS country_sessions
        WHERE 
            Country = als.country
    ) 
ORDER BY 
    Country, top_selling_product, Count_of_Sessions DESC;
```


** Answer:
TOP-SELLING Product by Country
RETURNS 366 results since there are many multiple top-products for each country.
```
"country"	"top_selling_product"	"sku"	"count_of_sessions"
"Albania"	"22 oz  Bottle Infuser"	"GGOEYDHJ056099"	1
"Albania"	"Men's Vintage Tank"	"GGOEGAAX0356"	1
"Albania"	"Women's Lightweight Microfleece Jacket"	"GGOEGAAX0582"	1
"Algeria"	"Toddler Raglan Shirt Blue Heather/Navy"	"GGOEGAAX0659"	1
"Algeria"	"Twill Cap"	"GGOEYHPB072210"	1
"Argentina"	"Alpine Style Backpack"	"GGOEGBRJ037299"	3
"Argentina"	"Wool Heather Cap Heather/Black"	"GGOEYHPA003610"	3
"Armenia"	"Windup Android"	"GGOEAKDH019899"	1
"Austria"	"Men's Short Sleeve Hero Tee White"	"GGOEGAAX0317"	2
"Austria"	"Onesie Heather"	"GGOEGAAX0614"	2
"Austria"	"RFID Journal"	"GGOEYOCR077399"	2
"Austria"	"Wool Heather Cap Heather/Black"	"GGOEYHPA003610"	2
"Bahamas"	"Men's Vintage Henley"	"GGOEGAAX0351"	1
"Bahamas"	"Twill Cap"	"GGOEGHPB071610"	1
"Bahrain"	"Men's 100% Cotton Short Sleeve Hero Tee White"	"GGOEGAAX0104"	1
"Bahrain"	"Men's 3/4 Sleeve Henley"	"GGOEGAAX0314"	1
"Bahrain"	"Men's Short Sleeve Hero Tee Black"	"GGOEGAAX0318"	1
"Bangladesh"	"Electronics Accessory Pouch"	"GGOEGBFC018799"	2
"Bangladesh"	"Men's Vintage Badge Tee White"	"GGOEGAAX0339"	2
"Bangladesh"	"Men's Vintage Henley"	"GGOEGAAX0351"	2
"Bangladesh"	"RFID Journal"	"GGOEYOCR077399"	2
"Barbados"	"Men's Pullover Hoodie Grey"	"GGOEGAAX0362"	1
"Belarus"	"Android Men's Short Sleeve Hero Tee Heather"	"GGOEGAAX0319"	1
"Belarus"	"Men's Long Sleeve Pullover Badge Tee Heather"	"GGOEGAAX0335"	1
"Belarus"	"Stylus Pen w/ LED Light"	"GGOEGOAR013099"	1
"Belarus"	"Women's Performance Full Zip Jacket Black"	"GGOEGAAX0578"	1
"Belarus"	"Women's Short Sleeve Hero Tee Sky Blue"	"GGOEGAAX0291"	1
"Belgium"	"Leatherette Notebook Combo"	"GGOEYOLR018699"	3
"Belgium"	"Trucker Hat"	"GGOEYHPA003510"	3
"Bolivia"	"Android Men's Short Sleeve Hero Tee Heather"	"GGOEGAAX0319"	1
"Bolivia"	"G Noise-reducing Bluetooth Headphones"	"GGOEGEVB070599"	1
"Bolivia"	"Men's Short Sleeve Hero Tee Black"	"GGOEGAAX0318"	1
"Bosnia & Herzegovina"	"24 oz  Sergeant Stripe Bottle"	"GGOEYDHJ019399"	1
"Bosnia & Herzegovina"	"Leatherette Notebook Combo"	"GGOEYOLR018699"	1
"Bosnia & Herzegovina"	"Toddler Short Sleeve Tee Red"	"GGOEGAAX0661"	1
"Botswana"	"Waterproof Backpack"	"GGOEGBRA037499"	1
"Brazil"	"Men's Vintage Badge Tee Black"	"GGOEGAAX0338"	6
"Brunei"	"Men's Vintage Henley"	"GGOEGAAX0351"	1
"Brunei"	"Toddler Short Sleeve Tee Red"	"GGOEGAAX0661"	1
"Bulgaria"	"20 oz Stainless Steel Insulated Tumbler"	"GGOEGDHQ014899"	1
"Bulgaria"	"22 oz  Bottle Infuser"	"GGOEYDHJ056099"	1
"Bulgaria"	"Custom Decals"	"GGOEYFKQ020699"	1
"Bulgaria"	"Four Color Retractable Pen"	"GGOEGOAQ020099"	1
"Bulgaria"	"Men's 100% Cotton Short Sleeve Hero Tee White"	"GGOEGAAX0104"	1
"Bulgaria"	"Men's Short Sleeve Hero Tee Charcoal"	"GGOEGAAX0325"	1
"Bulgaria"	"Men's Vintage Tank"	"GGOEGAAX0356"	1
"Bulgaria"	"Rocket Flashlight"	"GGOEGESC014099"	1
"Bulgaria"	"Spiral Notebook and Pen Set"	"GGOEGOLC013299"	1
"Bulgaria"	"Toddler Short Sleeve T-shirt Royal Blue"	"GGOEGAAX0652"	1
"Bulgaria"	"Twill Cap"	"GGOEYHPB072210"	1
"Cambodia"	"Lunch Bag"	"GGOEGBCR024399"	1
"Cambodia"	"Men's Short Sleeve Performance Badge Tee Navy"	"GGOEGAAX0590"	1
"Cambodia"	"Micro Wireless Earbud"	"GGOEGEVA022399"	1
"Cambodia"	"Twill Cap"	"GGOEYHPB072210"	1
"Cambodia"	"Women's  Short Sleeve Hero Tee Black"	"GGOEGAAX0284"	1
"Chile"	"24 oz  Sergeant Stripe Bottle"	"GGOEYDHJ019399"	2
"China"	"Men's Vintage Badge Tee White"	"GGOEGAAX0339"	2
"Colombia"	"22 oz  Bottle Infuser"	"GGOEYDHJ056099"	4
"Costa Rica"	"Men's Short Sleeve Hero Tee Charcoal"	"GGOEGAAX0325"	1
"Costa Rica"	"Pen Pencil & Highlighter Set"	"GGOEGOAQ018099"	1
"Costa Rica"	"Plastic Sliding Flashlight"	"GGOEGESQ016799"	1
"Costa Rica"	"Power Bank"	"GGOEGETB023799"	1
"Costa Rica"	"Women's Short Sleeve Hero Tee White"	"GGOEGAAX0279"	1
"Côte d’Ivoire"	"Custom Decals"	"GGOEYFKQ020699"	2
"Croatia"	"24 oz  Sergeant Stripe Bottle"	"GGOEYDHJ019399"	2
"Croatia"	"Men's Vintage Henley"	"GGOEGAAX0351"	2
"Croatia"	"Men's Watershed Full Zip Hoodie Grey"	"GGOEGAAX0568"	2
"Cyprus"	"Men's Airflow 1/4 Zip Pullover Lapis"	"GGOEGAAX0593"	1
"Cyprus"	"Men's Short Sleeve Hero Tee Light Blue"	"GGOEGAAX0321"	1
"Cyprus"	"Suitcase Organizer Cubes"	"GGOEGCMB020932"	1
"Cyprus"	"Wool Heather Cap Heather/Black"	"GGOEYHPA003610"	1
"Czechia"	"Hard Cover Journal"	"GGOEYOCR077799"	6
"Denmark"	"Hard Cover Journal"	"GGOEYOCR077799"	5
"Dominican Republic"	"22 oz  Bottle Infuser"	"GGOEYDHJ056099"	1
"Dominican Republic"	"Bottle Opener Clip"	"GGOEGFAQ016699"	1
"Dominican Republic"	"Custom Decals"	"GGOEYFKQ020699"	1
"Dominican Republic"	"Electronics Accessory Pouch"	"GGOEGBFC018799"	1
"Dominican Republic"	"Leatherette Notebook Combo"	"GGOEYOLR018699"	1
"Dominican Republic"	"Men's Short Sleeve Hero Tee Black"	"GGOEGAAX0318"	1
"Dominican Republic"	"Men's Vintage Badge Tee Black"	"GGOEGAAX0338"	1
"Dominican Republic"	"Men's Vintage Tank"	"GGOEGAAX0355"	1
"Dominican Republic"	"Trucker Hat"	"GGOEGHPA002910"	1
"Dominican Republic"	"Twill Cap"	"GGOEYHPB072210"	1
"Dominican Republic"	"Women's Lightweight Microfleece Jacket"	"GGOEGAAX0582"	1
"Ecuador"	"Android Men's Long Sleeve Badge Crew Tee Heather"	"GGOEGAAX0334"	1
"Ecuador"	"Android Men's  Zip Hoodie"	"GGOEGAAX0359"	1
"Ecuador"	"Men's Long & Lean Tee Grey"	"GGOEGAAX0327"	1
"Ecuador"	"Men's Short Sleeve Badge Tee Charcoal"	"GGOEGAAX0326"	1
"Ecuador"	"Men's Vintage Tee"	"GGOEGAAX0346"	1
"Ecuador"	"Men's Watershed Full Zip Hoodie Grey"	"GGOEGAAX0568"	1
"Ecuador"	"Men's  Zip Hoodie"	"GGOEGAAX0358"	1
"Ecuador"	"Onesie Heather"	"GGOEGAAX0614"	1
"Ecuador"	"RFID Journal"	"GGOEYOCR077399"	1
"Ecuador"	"Tube Power Bank"	"GGOEGETR014599"	1
"Ecuador"	"Women's Short Sleeve Hero Tee Sky Blue"	"GGOEGAAX0291"	1
"Egypt"	"22 oz  Bottle Infuser"	"GGOEYDHJ056099"	1
"Egypt"	"Android Men's Short Sleeve Hero Tee White"	"GGOEGAAX0320"	1
"Egypt"	"Android RFID Journal"	"GGOEAOCB077499"	1
"Egypt"	"Leatherette Notebook Combo"	"GGOEYOLR018699"	1
"Egypt"	"Men's 100% Cotton Short Sleeve Hero Tee Navy"	"GGOEGAAX0106"	1
"Egypt"	"Men's Long & Lean Tee Charcoal"	"GGOEGAAX0330"	1
"Egypt"	"Men's Long Sleeve Raglan Ocean Blue"	"GGOEGAAX0331"	1
"Egypt"	"Men's Vintage Badge Tee Black"	"GGOEGAAX0338"	1
"Egypt"	"Men's Vintage Badge Tee Sage"	"GGOEGAAX0340"	1
"Egypt"	"Men's Vintage Henley"	"GGOEGAAX0351"	1
"Egypt"	"Toddler Short Sleeve Tee Red"	"GGOEGAAX0661"	1
"El Salvador"	"Android Men's  Zip Hoodie"	"GGOEGAAX0359"	1
"El Salvador"	"Device Holder Sticky Pad"	"GGOEGCBB074399"	1
"El Salvador"	"Men's 100% Cotton Short Sleeve Hero Tee Navy"	"GGOEGAAX0106"	1
"El Salvador"	"Men's Quilted Insulated Vest Battleship Grey"	"GGOEGAAX0597"	1
"El Salvador"	"Trucker Hat"	"GGOEGHPA002910"	1
"El Salvador"	"Women's Vintage Hero Tee Lavender"	"GGOEGAAX0343"	1
"El Salvador"	"Wool Heather Cap Heather/Navy"	"GGOEGHPA003010"	1
"Estonia"	"22 oz Android Bottle"	"GGOEADHH055999"	1
"Estonia"	"Android Men's  Zip Hoodie"	"GGOEGAAX0359"	1
"Estonia"	"Car Clip Phone Holder"	"GGOEGCBB074199"	1
"Estonia"	"Electronics Accessory Pouch"	"GGOEGBFC018799"	1
"Estonia"	"Insulated Stainless Steel Bottle"	"GGOEGDHB072099"	1
"Estonia"	"Learning Thermostat 3rd Gen-USA - Stainless Steel"	"9183234"	1
"Estonia"	"Men's Quilted Insulated Vest Black"	"GGOEGAAX0596"	1
"Estonia"	"Men's Short Sleeve Hero Tee Black"	"GGOEGAAX0318"	1
"Estonia"	"Mood Original Window Decal"	"GGOEWFKA083199"	1
"Estonia"	"Zipper-front Sports Bag"	"GGOEGBMB073799"	1
"Ethiopia"	"Hard Cover Journal"	"GGOEYOCR077799"	1
"Ethiopia"	"Leatherette Notebook Combo"	"GGOEYOLR018699"	1
"Finland"	"Android Onesie Gold"	"GGOEGAAX0617"	1
"Finland"	"Device Holder Sticky Pad"	"GGOEGCBB074399"	1
"Finland"	"Infant Zip Hood Royal Blue"	"GGOEGAAX0628"	1
"Finland"	"Keyboard DOT Sticker"	"GGOEGFKA022299"	1
"Finland"	"Laptop and Cell Phone Stickers"	"GGOEGFKQ020399"	1
"Finland"	"Learning Thermostat 3rd Gen-USA - Stainless Steel"	"9183234"	1
"Finland"	"Men's 100% Cotton Short Sleeve Hero Tee Black"	"GGOEGAAX0105"	1
"Finland"	"Men's Short Sleeve Hero Tee White"	"GGOEGAAX0317"	1
"Finland"	"Recycled Mouse Pad"	"GGOEGODR017799"	1
"Finland"	"Rocket Flashlight"	"GGOEGESC014099"	1
"Finland"	"Tube Power Bank"	"GGOEGETR014599"	1
"Finland"	"Twill Cap"	"GGOEGHPB071610"	1
"Finland"	"Vintage Henley Grey/Black"	"GGOEGAAX0353"	1
"France"	"Men's 100% Cotton Short Sleeve Hero Tee White"	"GGOEGAAX0104"	8
"Georgia"	"Custom Decals"	"GGOEYFKQ020699"	3
"Ghana"	"Luggage Tag"	"GGOEYOBR078599"	1
"Ghana"	"Men's 100% Cotton Short Sleeve Hero Tee White"	"GGOEGAAX0104"	1
"Ghana"	"Men's Vintage Tank"	"GGOEGAAX0356"	1
"Gibraltar"	"Men's Vintage Henley"	"GGOEGAAX0351"	1
"Greece"	"Trucker Hat"	"GGOEYHPA003510"	4
"Haiti"	"Men's Short Sleeve Hero Tee Heather"	"GGOEGAAX0734"	1
"Honduras"	"24 oz  Sergeant Stripe Bottle"	"GGOEYDHJ019399"	1
"Honduras"	"Cam Outdoor Security Camera - USA"	"GGOENEBQ078999"	1
"Honduras"	"Women's Lightweight Microfleece Jacket"	"GGOEGAAX0582"	1
"Honduras"	"Wool Heather Cap Heather/Black"	"GGOEYHPA003610"	1
"Hungary"	"Men's Short Sleeve Hero Tee Black"	"GGOEGAAX0318"	2
"Hungary"	"Men's Short Sleeve Hero Tee Charcoal"	"GGOEGAAX0325"	2
"Hungary"	"Wool Heather Cap Heather/Black"	"GGOEYHPA003610"	2
"Iceland"	"Insulated Stainless Steel Bottle"	"GGOEGDHB072099"	1
"India"	"Custom Decals"	"GGOEYFKQ020699"	22
"Indonesia"	"22 oz  Bottle Infuser"	"GGOEYDHJ056099"	6
"Iraq"	"Android 5-Panel Low Cap"	"GGOEAHPB080210"	1
"Iraq"	"Android Men's  Zip Hoodie"	"GGOEGAAX0359"	1
"Iraq"	"Men's Vintage Badge Tee Black"	"GGOEGAAX0338"	1
"Ireland"	"24 oz  Sergeant Stripe Bottle"	"GGOEYDHJ019399"	4
"Israel"	"22 oz  Bottle Infuser"	"GGOEYDHJ056099"	3
"Italy"	"Men's 100% Cotton Short Sleeve Hero Tee White"	"GGOEGAAX0104"	5
"Jamaica"	"Men's  Zip Hoodie"	"GGOEGAAX0358"	1
"Japan"	"Men's 100% Cotton Short Sleeve Hero Tee White"	"GGOEGAAX0104"	7
"Jersey"	"Tri-blend Hoodie Grey"	"GGOEGAAX0313"	1
"Jordan"	"Suitcase Organizer Cubes"	"GGOEGCMB020932"	1
"Kazakhstan"	"Collapsible Shopping Bag"	"GGOEGBJC019999"	1
"Kazakhstan"	"Men's Short Sleeve Hero Tee White"	"GGOEGAAX0317"	1
"Kenya"	"Flashlight"	"GGOEGESB015199"	1
"Kenya"	"Men's Long & Lean Tee Grey"	"GGOEGAAX0327"	1
"Kenya"	"Men's Quilted Insulated Vest Battleship Grey"	"GGOEGAAX0597"	1
"Kenya"	"Women's Short Sleeve Hero Tee Grey"	"GGOEGAAX0280"	1
"Kosovo"	"Men's Vintage Badge Tee Black"	"GGOEGAAX0338"	1
"Kuwait"	"17oz Stainless Steel Sport Bottle"	"GGOEGDHC074099"	1
"Kuwait"	"Men's 100% Cotton Short Sleeve Hero Tee Black"	"GGOEGAAX0105"	1
"Kuwait"	"Men's Vintage Badge Tee Sage"	"GGOEGAAX0340"	1
"Kuwait"	"Waterproof Backpack"	"GGOEGBRA037499"	1
"Kuwait"	"Women's Fleece Hoodie"	"GGOEGAAX0360"	1
"Kuwait"	"Women's  Short Sleeve Hero Tee Black"	"GGOEGAAX0284"	1
"Kyrgyzstan"	"Rocket Flashlight"	"GGOEGESC014099"	1
"Laos"	"Hard Cover Journal"	"GGOEYOCR077799"	2
"Latvia"	"Lunch Bag"	"GGOEGBCR024399"	1
"Latvia"	"Men's Microfiber 1/4 Zip Pullover Blue/Indigo"	"GGOEGAAX0595"	1
"Latvia"	"Men's Short Sleeve Hero Tee Charcoal"	"GGOEGAAX0325"	1
"Latvia"	"Red Spiral  Notebook"	"GGOEGOCT019199"	1
"Latvia"	"RFID Journal"	"GGOEYOCR077399"	1
"Latvia"	"Twill Cap"	"GGOEYHPB072210"	1
"Latvia"	"UpCycled Handlebar Bag"	"GGOEGBPB082099"	1
"Latvia"	"Women's Vintage Hero Tee White"	"GGOEGAAX0342"	1
"Lebanon"	"RFID Journal"	"GGOEYOCR077399"	1
"Luxembourg"	"Toddler Raglan Shirt Blue Heather/Navy"	"GGOEGAAX0659"	1
"Macau"	"Leatherette Notebook Combo"	"GGOEYOLR018699"	1
"Macau"	"Men's 100% Cotton Short Sleeve Hero Tee Red"	"GGOEGAAX0107"	1
"Macau"	"Twill Cap"	"GGOEGHPB071610"	1
"Macedonia (FYROM)"	"22 oz  Bottle Infuser"	"GGOEYDHJ056099"	1
"Macedonia (FYROM)"	"Men's 100% Cotton Short Sleeve Hero Tee Red"	"GGOEGAAX0107"	1
"Macedonia (FYROM)"	"Women's Performance Full Zip Jacket Black"	"GGOEGAAX0578"	1
"Malaysia"	"Men's Short Sleeve Hero Tee Heather"	"GGOEGAAX0734"	3
"Maldives"	"Men's Performance Full Zip Jacket Black"	"GGOEGAAX0569"	1
"Mali"	"Custom Decals"	"GGOEYFKQ020699"	1
"Malta"	"RFID Journal"	"GGOEYOCR077399"	1
"Malta"	"Women's Fleece Hoodie Black"	"GGOEGAAX0732"	1
"Martinique"	"Men's Fleece Hoodie Black"	"GGOEGAAX0731"	1
"Martinique"	"Water Resistant Bluetooth Speaker"	"GGOEGEVR014999"	1
"Mauritius"	"Men's Short Sleeve Hero Tee Charcoal"	"GGOEGAAX0325"	1
"Mauritius"	"Power Bank"	"GGOEGETB023799"	1
"Mexico"	"Men's Short Sleeve Hero Tee Black"	"GGOEGAAX0318"	5
"Moldova"	"24 oz  Sergeant Stripe Bottle"	"GGOEYDHJ019399"	1
"Moldova"	"Custom Decals"	"GGOEYFKQ020699"	1
"Montenegro"	"Custom Decals"	"GGOEYFKQ020699"	1
"Morocco"	"22 oz  Bottle Infuser"	"GGOEYDHJ056099"	1
"Morocco"	"Custom Decals"	"GGOEYFKQ020699"	1
"Morocco"	"Learning Thermostat 3rd Gen-USA - Stainless Steel"	"GGOENEBJ079499"	1
"Morocco"	"Stylus Pen w/ LED Light"	"GGOEGOAR013099"	1
"Morocco"	"Tote Bag"	"GGOEGBJC014399"	1
"Morocco"	"Women's Short Sleeve Hero Tee Black"	"GGOEGAAX0278"	1
"Morocco"	"Wool Heather Cap Heather/Black"	"GGOEYHPA003610"	1
"Myanmar (Burma)"	"22 oz  Bottle Infuser"	"GGOEYDHJ056099"	1
"Myanmar (Burma)"	"Men's 100% Cotton Short Sleeve Hero Tee Navy"	"GGOEGAAX0106"	1
"Myanmar (Burma)"	"Men's Short Sleeve Hero Tee Black"	"GGOEGAAX0318"	1
"Nepal"	"22 oz  Bottle Infuser"	"GGOEYDHJ056099"	1
"Nepal"	"Rucksack"	"GGOEGBRJ037399"	1
"Nepal"	"Women's Short Sleeve Hero Tee Sky Blue"	"GGOEGAAX0291"	1
"New Zealand"	"22 oz  Bottle Infuser"	"GGOEYDHJ056099"	3
"New Zealand"	"RFID Journal"	"GGOEYOCR077399"	3
"Nicaragua"	"Compact Selfie Stick"	"GGOEGFQB013799"	1
"Nigeria"	"Alpine Style Backpack"	"GGOEGBRJ037299"	1
"Nigeria"	"Keyboard DOT Sticker"	"GGOEGFKA022299"	1
"Nigeria"	"Lunch Bag"	"GGOEGBCR024399"	1
"Nigeria"	"Men's Short Sleeve Hero Tee Black"	"GGOEGAAX0318"	1
"Nigeria"	"Men's Vintage Tank"	"GGOEGAAX0356"	1
"Nigeria"	"Onesie Heather"	"GGOEGAAX0614"	1
"Nigeria"	"Twill Cap"	"GGOEGHPB071610"	1
"Norway"	"Laptop and Cell Phone Stickers"	"GGOEGFKQ020399"	2
"Norway"	"Men's 3/4 Sleeve Henley"	"GGOEGAAX0314"	2
"Norway"	"Men's Short Sleeve Hero Tee Charcoal"	"GGOEGAAX0325"	2
"(not set)"	"Men's Long Sleeve Pullover Badge Tee Heather"	"GGOEGAAX0335"	2
"(not set)"	"Men's Long Sleeve Raglan Ocean Blue"	"GGOEGAAX0331"	2
"Oman"	"Hard Cover Journal"	"GGOEYOCR077799"	1
"Pakistan"	"22 oz  Bottle Infuser"	"GGOEYDHJ056099"	4
"Palestine"	"Laptop Backpack"	"GGOEGBRB013899"	1
"Panama"	"22 oz  Bottle Infuser"	"GGOEYDHJ056099"	1
"Panama"	"Android Lunch Kit"	"GGOEACCQ017299"	1
"Panama"	"Android Sticker Sheet Ultra Removable"	"GGOEAFKQ020599"	1
"Panama"	"Bottle Opener Clip"	"GGOEGFAQ016699"	1
"Panama"	"Custom Decals"	"GGOEYFKQ020699"	1
"Panama"	"Luggage Tag"	"GGOEYOBR078599"	1
"Panama"	"Men's 100% Cotton Short Sleeve Hero Tee White"	"GGOEGAAX0104"	1
"Panama"	"Men's Convertible Vest-Jacket Pewter"	"GGOEGAAX0598"	1
"Panama"	"Men's Short Sleeve Hero Tee Charcoal"	"GGOEGAAX0325"	1
"Panama"	"Men's Short Sleeve Hero Tee Heather"	"GGOEGAAX0734"	1
"Panama"	"Men's Short Sleeve Hero Tee Light Blue"	"GGOEGAAX0321"	1
"Panama"	"RFID Journal"	"GGOEGOCC077299"	1
"Panama"	"Suitcase Organizer Cubes"	"GGOEGCMB020932"	1
"Panama"	"Toddler Raglan Shirt Blue Heather/Navy"	"GGOEGAAX0659"	1
"Panama"	"Women's  Short Sleeve Hero Tee Black"	"GGOEGAAX0284"	1
"Papua New Guinea"	"Custom Decals"	"GGOEYFKQ020699"	1
"Papua New Guinea"	"Hard Cover Journal"	"GGOEYOCR077799"	1
"Paraguay"	"Men's 100% Cotton Short Sleeve Hero Tee Navy"	"GGOEGAAX0106"	1
"Peru"	"22 oz  Bottle Infuser"	"GGOEYDHJ056099"	2
"Peru"	"Compact Selfie Stick"	"GGOEGFQB013799"	2
"Philippines"	"Men's 100% Cotton Short Sleeve Hero Tee Black"	"GGOEGAAX0105"	3
"Philippines"	"Men's Convertible Vest-Jacket Pewter"	"GGOEGAAX0598"	3
"Philippines"	"Men's Short Sleeve Hero Tee Charcoal"	"GGOEGAAX0325"	3
"Philippines"	"Men's Short Sleeve Hero Tee White"	"GGOEGAAX0317"	3
"Philippines"	"RFID Journal"	"GGOEYOCR077399"	3
"Philippines"	"Twill Cap"	"GGOEYHPB072210"	3
"Poland"	"Men's Vintage Tank"	"GGOEGAAX0356"	3
"Portugal"	"Men's 100% Cotton Short Sleeve Hero Tee Black"	"GGOEGAAX0105"	2
"Portugal"	"RFID Journal"	"GGOEYOCR077399"	2
"Puerto Rico"	"Android Men's Short Sleeve Tri-blend Hero Tee Grey"	"GGOEGAAX0324"	1
"Puerto Rico"	"Custom Decals"	"GGOEYFKQ020699"	1
"Puerto Rico"	"Four Color Retractable Pen"	"GGOEGOAQ020099"	1
"Puerto Rico"	"Men's 100% Cotton Short Sleeve Hero Tee White"	"GGOEGAAX0104"	1
"Puerto Rico"	"Toddler Short Sleeve T-shirt Grey"	"GGOEGAAX0655"	1
"Puerto Rico"	"Waterproof Backpack"	"GGOEGBRA037499"	1
"Qatar"	"5-Panel Cap"	"GGOEGHPJ080110"	1
"Qatar"	"Men's 100% Cotton Short Sleeve Hero Tee Black"	"GGOEGAAX0105"	1
"Qatar"	"Men's Short Sleeve Performance Badge Tee Navy"	"GGOEGAAX0590"	1
"Réunion"	"Custom Decals"	"GGOEYFKQ020699"	1
"Réunion"	"Doodle Decal"	"GGOEGFKQ020799"	1
"Romania"	"Custom Decals"	"GGOEYFKQ020699"	5
"Russia"	"Twill Cap"	"GGOEYHPB072210"	4
"Russia"	"Women's Fleece Hoodie"	"GGOEGAAX0360"	4
"Rwanda"	"Wool Heather Cap Heather/Black"	"GGOEYHPA003610"	1
"San Marino"	"22 oz  Bottle Infuser"	"GGOEYDHJ056099"	1
"San Marino"	"Device Holder Sticky Pad"	"GGOEGCBB074399"	1
"Saudi Arabia"	"17oz Stainless Steel Sport Bottle"	"GGOEGDHC074099"	1
"Saudi Arabia"	"24 oz  Sergeant Stripe Bottle"	"GGOEYDHJ019399"	1
"Saudi Arabia"	"Android Men's Short Sleeve Hero Tee White"	"GGOEGAAX0320"	1
"Saudi Arabia"	"Leatherette Journal"	"GGOEGOCB017499"	1
"Saudi Arabia"	"Men's Vintage Tank"	"GGOEGAAX0356"	1
"Saudi Arabia"	"Red Spiral  Notebook"	"GGOEGOCT019199"	1
"Saudi Arabia"	"Rucksack"	"GGOEGBRJ037399"	1
"Saudi Arabia"	"Twill Cap"	"GGOEYHPB072210"	1
"Saudi Arabia"	"Women's Lightweight Microfleece Jacket"	"9182785"	1
"Saudi Arabia"	"Women's  Short Sleeve Hero Tee Black"	"GGOEGAAX0284"	1
"Saudi Arabia"	"Women's Vintage Hero Tee Platinum"	"GGOEGAAX0344"	1
"Saudi Arabia"	"Youth Short Sleeve T-shirt Yellow"	"GGOEGAAX0685"	1
"Serbia"	"Twill Cap"	"GGOEYHPB072210"	2
"Singapore"	"Men's 100% Cotton Short Sleeve Hero Tee Black"	"GGOEGAAX0105"	5
"Sint Maarten"	"Stylus Pen w/ LED Light"	"GGOEGOAR013099"	1
"Slovakia"	"Custom Decals"	"GGOEYFKQ020699"	2
"Slovakia"	"Hard Cover Journal"	"GGOEYOCR077799"	2
"Slovakia"	"Luggage Tag"	"GGOEYOBR078599"	2
"Slovakia"	"Men's Vintage Henley"	"GGOEGAAX0351"	2
"Slovakia"	"RFID Journal"	"GGOEYOCR077399"	2
"Slovakia"	"Trucker Hat"	"GGOEYHPA003510"	2
"Slovakia"	"Twill Cap"	"GGOEYHPB072210"	2
"Slovenia"	"22 oz  Bottle Infuser"	"GGOEYDHJ056099"	1
"Slovenia"	"Electronics Accessory Pouch"	"GGOEGBFC018799"	1
"Slovenia"	"G Noise-reducing Bluetooth Headphones"	"GGOEGEVB070599"	1
"Slovenia"	"Hard Cover Journal"	"GGOEYOCR077799"	1
"Slovenia"	"Leatherette Notebook Combo"	"GGOEYOLR018699"	1
"Slovenia"	"Toddler Short Sleeve Tee Red"	"GGOEGAAX0661"	1
"Slovenia"	"Trucker Hat"	"GGOEYHPA003510"	1
"Slovenia"	"Women's Short Sleeve Hero Tee Charcoal"	"GGOEGAAX0290"	1
"Somalia"	"Men's Short Sleeve Hero Tee White"	"GGOEGAAX0317"	1
"South Africa"	"Men's 100% Cotton Short Sleeve Hero Tee Black"	"GGOEGAAX0105"	2
"South Africa"	"Men's Vintage Henley"	"GGOEGAAX0351"	2
"South Korea"	"22 oz  Bottle Infuser"	"GGOEYDHJ056099"	2
"South Korea"	"Ballpoint Stylus Pen"	"GGOEGOAR013599"	2
"South Korea"	"Custom Decals"	"GGOEYFKQ020699"	2
"Spain"	"22 oz  Bottle Infuser"	"GGOEYDHJ056099"	4
"Spain"	"Men's Short Sleeve Hero Tee White"	"GGOEGAAX0317"	4
"Spain"	"RFID Journal"	"GGOEYOCR077399"	4
"Sri Lanka"	"Android Men's Vintage Henley"	"GGOEGAAX0352"	2
"Sri Lanka"	"Men's 100% Cotton Short Sleeve Hero Tee White"	"GGOEGAAX0104"	2
"Sudan"	"RFID Journal"	"GGOEYOCR077399"	1
"Sweden"	"Leatherette Notebook Combo"	"GGOEYOLR018699"	3
"Sweden"	"Men's Short Sleeve Hero Tee White"	"GGOEGAAX0317"	3
"Sweden"	"Men's Vintage Henley"	"GGOEGAAX0351"	3
"Switzerland"	"G Noise-reducing Bluetooth Headphones"	"GGOEGEVB070599"	3
"Switzerland"	"Sport Bag"	"GGOEGBMJ013399"	3
"Switzerland"	"Twill Cap"	"GGOEYHPB072210"	3
"Taiwan"	"Men's 100% Cotton Short Sleeve Hero Tee White"	"GGOEGAAX0104"	6
"Tanzania"	"Twill Cap"	"GGOEYHPB072210"	1
"Trinidad & Tobago"	"Hard Cover Journal"	"GGOEYOCR077799"	1
"Trinidad & Tobago"	"Twill Cap"	"GGOEYHPB072210"	1
"Tunisia"	"Device Holder Sticky Pad"	"GGOEGCBB074399"	2
"Turkey"	"Hard Cover Journal"	"GGOEYOCR077799"	4
"Uganda"	"Laptop and Cell Phone Stickers"	"GGOEGFKQ020399"	1
"Ukraine"	"Hard Cover Journal"	"GGOEYOCR077799"	3
"Ukraine"	"Men's 100% Cotton Short Sleeve Hero Tee White"	"GGOEGAAX0104"	3
"United Arab Emirates"	"22 oz  Bottle Infuser"	"GGOEYDHJ056099"	1
"United Arab Emirates"	"Android Men's  Zip Hoodie"	"GGOEGAAX0359"	1
"United Arab Emirates"	"Android Rise 14 oz Mug"	"GGOEADWQ015699"	1
"United Arab Emirates"	"Android Youth Short Sleeve T-shirt Aqua"	"GGOEGAAX0687"	1
"United Arab Emirates"	"Hard Cover Journal"	"GGOEYOCR077799"	1
"United Arab Emirates"	"Leatherette Journal"	"GGOEGOCB017499"	1
"United Arab Emirates"	"Men's Long & Lean Tee Charcoal"	"GGOEGAAX0330"	1
"United Arab Emirates"	"Men's Short Sleeve Performance Badge Tee Navy"	"GGOEGAAX0590"	1
"United Arab Emirates"	"Men's Short Sleeve Performance Badge Tee Pewter"	"GGOEGAAX0591"	1
"United Arab Emirates"	"Men's Vintage Tank"	"GGOEGAAX0355"	1
"United Arab Emirates"	"Pen Pencil & Highlighter Set"	"GGOEGOAQ018099"	1
"United Arab Emirates"	"Recycled Mouse Pad"	"GGOEGODR017799"	1
"United Arab Emirates"	"Water Resistant Bluetooth Speaker"	"GGOEGEVR014999"	1
"United Arab Emirates"	"Women's Convertible Vest-Jacket Sea Foam Green"	"GGOEGAAX0607"	1
"United Arab Emirates"	"Women's Fleece Hoodie"	"GGOEGAAX0360"	1
"United Arab Emirates"	"Women's Long Sleeve Tee Lavender"	"GGOEGAAX0363"	1
"United Arab Emirates"	"Wool Heather Cap Heather/Black"	"GGOEYHPA003610"	1
"Uruguay"	"Men's Vintage Tank"	"GGOEGAAX0356"	2
"Venezuela"	"Hard Cover Journal"	"GGOEYOCR077799"	2
"Venezuela"	"Twill Cap"	"GGOEYHPB072210"	2
"Vietnam"	"Android Men's Vintage Tank"	"GGOEGAAX0357"	2
"Zimbabwe"	"Screen Cleaning Cloth"	"GGOEGOFH020299"	1
```

### Originally I wanted to define TOP-SELLING product as product * quantity, but products.orderquantity doesn't properly define which session, therefore which country/city the order came from!

```
select * from products where sku = 'GGOEGBRJ037299';
-- this certainly has quantity ordered at 165 but how do we know that is for Argentina?
```
"sku"	"name"	"orderedquantity"	"stocklevel"	"restockingleadtime"	"sentimentscore"	"sentimentmagnitude"
"GGOEGBRJ037299"	"Alpine Style Backpack"	165	272	12	0.6	0.9
| sku           | name                   | orderedquantity | stocklevel | restockingleadtime | sentimentscore | sentimentmagnitude |
|---------------|------------------------|-----------------|------------|-------------------|----------------|---------------------|
| GGOEGBRJ037299 | Alpine Style Backpack  | 165             | 272        | 12                | 0.6            | 0.9                 |

Now we REPEAT the same query for each City.
SQL Queries:
```
SELECT 
    als.city AS City,
    p.Name AS Top_Selling_Product,
    p.SKU,
    COUNT(DISTINCT allsession_ID) AS Count_of_Sessions
FROM 
    all_sessions AS als
JOIN 
    products AS p ON als.productSKU = p.SKU
GROUP BY 
    als.city, p.Name, p.sku
HAVING 
    COUNT(DISTINCT allsession_ID) = (
        SELECT 
            MAX(Count_of_Sessions)
        FROM (
            SELECT 
                als2.city AS City, 
                p2.Name AS Product,
                COUNT(DISTINCT allsession_ID) AS Count_of_Sessions
            FROM 
                all_sessions AS als2
            JOIN 
                products AS p2 ON als2.productSKU = p2.SKU
            GROUP BY 
                als2.city, p2.Name
        ) AS city_sessions
        WHERE 
            city = als.city
    ) 
ORDER BY 
    City, top_selling_product, Count_of_Sessions DESC;
```

** Answers:
Returns 711 results.  
```
"city"	"top_selling_product"	"sku"	"count_of_sessions"
"Adelaide"	"Men's Watershed Full Zip Hoodie Grey"	"GGOEGAAX0568"	1
"Akron"	"Men's 100% Cotton Short Sleeve Hero Tee Navy"	"GGOEGAAX0106"	1
"Amsterdam"	"Aluminum Handy Emergency Flashlight"	"GGOEGESC014699"	1
"Amsterdam"	"Android Rise 14 oz Mug"	"GGOEADWQ015699"	1
"Amsterdam"	"Canvas Tote Natural/Navy"	"GGOEGBJL013999"	1
"Amsterdam"	"Device Holder Sticky Pad"	"GGOEGCBB074399"	1
"Amsterdam"	"Doodle Decal"	"GGOEGFKQ020799"	1
"Amsterdam"	"Hard Cover Journal"	"GGOEYOCR077799"	1
"Amsterdam"	"Luggage Tag"	"GGOEYOBR078599"	1
"Amsterdam"	"Men's 100% Cotton Short Sleeve Hero Tee Navy"	"GGOEGAAX0106"	1
"Amsterdam"	"Men's Long Sleeve Raglan Ocean Blue"	"GGOEGAAX0331"	1
"Amsterdam"	"Men's Vintage Henley"	"GGOEGAAX0351"	1
"Amsterdam"	"Tube Power Bank"	"GGOEGETR014599"	1
"Ann Arbor"	"Men's 100% Cotton Short Sleeve Hero Tee Navy"	"GGOEGAAX0106"	2
"Ann Arbor"	"Men's Convertible Vest-Jacket Pewter"	"GGOEGAAX0598"	2
"Ann Arbor"	"Men's Vintage Badge Tee Black"	"GGOEGAAX0338"	2
"Antalya"	"Tube Power Bank"	"9180813"	1
"Antwerp"	"Colored Pencil Set"	"GGOEGOBG023599"	1
"Antwerp"	"Insulated Stainless Steel Bottle"	"GGOEGDHB072099"	1
"Appleton"	"Aluminum Handy Emergency Flashlight"	"GGOEGESC014699"	1
"Ashburn"	"Android Lunch Kit"	"GGOEACCQ017299"	1
"Ashburn"	"Compact Selfie Stick"	"GGOEGFQB013799"	1
"Asuncion"	"Men's 100% Cotton Short Sleeve Hero Tee Navy"	"GGOEGAAX0106"	1
"Athens"	"22 oz  Bottle Infuser"	"GGOEYDHJ056099"	1
"Athens"	"Android Men's Short Sleeve Hero Tee Heather"	"GGOEGAAX0319"	1
"Athens"	"Electronics Accessory Pouch"	"GGOEGBFC018799"	1
"Athens"	"Hard Cover Journal"	"GGOEYOCR077799"	1
"Athens"	"Sport Bag"	"GGOEGBMJ013399"	1
"Auckland"	"G Noise-reducing Bluetooth Headphones"	"GGOEGEVB070599"	1
"Auckland"	"Women's Lightweight Microfleece Jacket"	"GGOEGAAX0582"	1
"Austin"	"22 oz Android Bottle"	"GGOEADHH055999"	3
"Austin"	"Men's Vintage Badge Tee Black"	"GGOEGAAX0338"	3
"Austin"	"Women's Short Sleeve Hero Tee Sky Blue"	"GGOEGAAX0291"	3
"Avon"	"Blackout Cap"	"GGOEGHPJ080310"	1
"Avon"	"Bottle Opener Clip"	"GGOEGFAQ016699"	1
"Bandung"	"Men's Short Sleeve Hero Tee Charcoal"	"GGOEGAAX0325"	1
"Bangkok"	"Keyboard DOT Sticker"	"GGOEGFKA022299"	2
"Barcelona"	"24 oz  Sergeant Stripe Bottle"	"GGOEYDHJ019399"	1
"Barcelona"	"26 oz Double Wall Insulated Bottle"	"GGOEGDHQ015399"	1
"Barcelona"	"Android Hard Cover Journal"	"GGOEA0CH077599"	1
"Barcelona"	"Android Onesie Gold"	"GGOEGAAX0617"	1
"Barcelona"	"Android Rise 14 oz Mug"	"GGOEADWQ015699"	1
"Barcelona"	"Badge Holder"	"GGOEGOXQ016399"	1
"Barcelona"	"Laptop and Cell Phone Stickers"	"GGOEGFKQ020399"	1
"Barcelona"	"Luggage Tag"	"GGOEYOBR078599"	1
"Barcelona"	"Men's Long & Lean Tee Charcoal"	"GGOEGAAX0330"	1
"Barcelona"	"Men's Pullover Hoodie Grey"	"GGOEGAAX0362"	1
"Barcelona"	"Men's Short Sleeve Hero Tee Black"	"GGOEGAAX0318"	1
"Barcelona"	"Men's Short Sleeve Hero Tee White"	"GGOEGAAX0317"	1
"Barcelona"	"Men's Vintage Henley"	"GGOEGAAX0351"	1
"Barcelona"	"Mobile Phone Vent Mount"	"GGOEWEBB082699"	1
"Barcelona"	"Rucksack"	"GGOEGBRJ037399"	1
"Barcelona"	"Snapback Hat Black"	"GGOEGHPB003410"	1
"Barcelona"	"Tri-blend Hoodie Grey"	"GGOEGAAX0313"	1
"Beijing"	"Men's Airflow 1/4 Zip Pullover Lapis"	"GGOEGAAX0593"	1
"Bellflower"	"Custom Decals"	"GGOEYFKQ020699"	2
"Bellingham"	"Custom Decals"	"GGOEYFKQ020699"	1
"Bellingham"	"Learning Thermostat 3rd Gen-USA - Stainless Steel"	"GGOENEBJ079499"	1
"Belo Horizonte"	"Collapsible Shopping Bag"	"GGOEGBJC019999"	1
"Bengaluru"	"Android Men's Short Sleeve Hero Tee White"	"GGOEGAAX0320"	2
"Bengaluru"	"Laptop and Cell Phone Stickers"	"GGOEGFKQ020399"	2
"Bengaluru"	"Leatherette Notebook Combo"	"GGOEYOLR018699"	2
"Bengaluru"	"Men's 100% Cotton Short Sleeve Hero Tee Navy"	"GGOEGAAX0106"	2
"Bengaluru"	"Men's 100% Cotton Short Sleeve Hero Tee Red"	"GGOEGAAX0107"	2
"Bengaluru"	"Men's Short Sleeve Hero Tee Black"	"GGOEGAAX0318"	2
"Bengaluru"	"Men's Vintage Henley"	"GGOEGAAX0351"	2
"Bengaluru"	"Onesie Heather"	"GGOEGAAX0614"	2
"Bengaluru"	"Women's  Short Sleeve Hero Tee Black"	"GGOEGAAX0284"	2
"Berkeley"	"Onesie Heather"	"GGOEGAAX0614"	1
"Berlin"	"Wool Heather Cap Heather/Black"	"GGOEYHPA003610"	3
"Bhubaneswar"	"20 oz Stainless Steel Insulated Tumbler"	"GGOEGDHQ014899"	1
"Bilbao"	"Trucker Hat"	"GGOEGHPA002910"	1
"Bilbao"	"Women's Short Sleeve Hero Tee Sky Blue"	"GGOEGAAX0291"	1
"Bogota"	"Android Men's Vintage Henley"	"GGOEGAAX0352"	1
"Bogota"	"Doodle Decal"	"GGOEGFKQ020799"	1
"Bogota"	"Flashlight"	"GGOEGESB015199"	1
"Bogota"	"Hard Cover Journal"	"GGOEYOCR077799"	1
"Bogota"	"Laptop Backpack"	"GGOEGBRB013899"	1
"Bogota"	"Learning Thermostat 3rd Gen-USA - Stainless Steel"	"GGOENEBJ079499"	1
"Bogota"	"Lunch Bag"	"GGOEGBCR024399"	1
"Bogota"	"Men's 100% Cotton Short Sleeve Hero Tee Navy"	"GGOEGAAX0106"	1
"Bogota"	"Men's 3/4 Sleeve Henley"	"GGOEGAAX0314"	1
"Bogota"	"Men's Airflow 1/4 Zip Pullover Black"	"GGOEGAAX0592"	1
"Bogota"	"Men's Microfiber 1/4 Zip Pullover Blue/Indigo"	"GGOEGAAX0595"	1
"Bogota"	"Men's Pullover Hoodie Grey"	"GGOEGAAX0362"	1
"Bogota"	"Men's Short Sleeve Hero Tee Black"	"GGOEGAAX0318"	1
"Bogota"	"Men's Short Sleeve Hero Tee White"	"GGOEGAAX0317"	1
"Bogota"	"Micro Wireless Earbud"	"GGOEGEVA022399"	1
"Bogota"	"Snapback Hat Black"	"GGOEGHPB003410"	1
"Bogota"	"SPF-15 Slim & Slender Lip Balm"	"GGOEGCBQ016499"	1
"Bogota"	"Toddler Short Sleeve Tee Red"	"GGOEGAAX0661"	1
"Bogota"	"Women's Fleece Hoodie"	"GGOEGAAX0360"	1
"Bordeaux"	"Luggage Tag"	"GGOEYOBR078599"	1
"Boston"	"Collapsible Shopping Bag"	"GGOEGBJC019999"	2
"Boston"	"Laptop Backpack"	"GGOEGBRB013899"	2
"Boulder"	"Bottle Opener Clip"	"GGOEGFAQ016699"	1
"Boulder"	"Compact Selfie Stick"	"GGOEGFQB013799"	1
"Boulder"	"Men's 100% Cotton Short Sleeve Hero Tee Black"	"GGOEGAAX0105"	1
"Boulder"	"Men's Performance Full Zip Jacket Black"	"GGOEGAAX0569"	1
"Boulder"	"Toddler Short Sleeve Tee Red"	"GGOEGAAX0661"	1
"Boulder"	"Twill Cap"	"GGOEYHPB072210"	1
"Bratislava"	"Learning Thermostat 3rd Gen-USA - Copper"	"9184734"	1
"Brisbane"	"24 oz  Sergeant Stripe Bottle"	"GGOEYDHJ019399"	1
"Brisbane"	"High Capacity 10,400mAh Charger"	"GGOEGEHQ071199"	1
"Brisbane"	"Leatherette Notebook Combo"	"GGOEYOLR018699"	1
"Brisbane"	"Men's Microfiber 1/4 Zip Pullover Blue/Indigo"	"9182743"	1
"Brisbane"	"Men's Softshell Jacket Black/Grey"	"GGOEGAAX0567"	1
"Brisbane"	"Men's Vintage Henley"	"GGOEGAAX0351"	1
"Brisbane"	"Twill Cap"	"GGOEYHPB072210"	1
"Brisbane"	"Women's Short Sleeve Hero Tee Red Heather"	"GGOEGAAX0297"	1
"Brisbane"	"Wool Heather Cap Heather/Black"	"GGOEYHPA003610"	1
"Brisbane"	"Youth Girl Hoodie"	"GGOEGAAX0689"	1
"Brno"	"Leatherette Journal"	"GGOEGOCB017499"	1
"Brno"	"Men's Pullover Hoodie Grey"	"GGOEGAAX0362"	1
"Brussels"	"Men's 100% Cotton Short Sleeve Hero Tee Black"	"GGOEGAAX0105"	1
"Bucharest"	"Alpine Style Backpack"	"GGOEGBRJ037299"	1
"Bucharest"	"Android Rise 14 oz Mug"	"GGOEADWQ015699"	1
"Bucharest"	"Canvas Tote Natural/Navy"	"GGOEGBJL013999"	1
"Bucharest"	"Custom Decals"	"GGOEYFKQ020699"	1
"Bucharest"	"Men's 100% Cotton Short Sleeve Hero Tee Red"	"GGOEGAAX0107"	1
"Bucharest"	"Men's 3/4 Sleeve Henley"	"GGOEGAAX0314"	1
"Bucharest"	"Men's Convertible Vest-Jacket Pewter"	"GGOEGAAX0598"	1
"Bucharest"	"Twill Cap"	"GGOEYHPB072210"	1
"Bucharest"	"Wool Heather Cap Heather/Navy"	"GGOEGHPA003010"	1
"Budapest"	"Android Men's  Zip Hoodie"	"GGOEGAAX0359"	1
"Budapest"	"Men's Long Sleeve Raglan Ocean Blue"	"GGOEGAAX0331"	1
"Budapest"	"Men's Pullover Hoodie Grey"	"GGOEGAAX0362"	1
"Budapest"	"Men's Short Sleeve Performance Badge Tee Pewter"	"GGOEGAAX0591"	1
"Budapest"	"Recycled Mouse Pad"	"GGOEGODR017799"	1
"Budapest"	"Wool Heather Cap Heather/Black"	"GGOEYHPA003610"	1
"Buenos Aires"	"24 oz  Sergeant Stripe Bottle"	"GGOEYDHJ019399"	1
"Buenos Aires"	"Alpine Style Backpack"	"GGOEGBRJ037299"	1
"Buenos Aires"	"Android Men's  Zip Hoodie"	"GGOEGAAX0359"	1
"Buenos Aires"	"Men's Long & Lean Tee Charcoal"	"GGOEGAAX0328"	1
"Buenos Aires"	"Rocket Flashlight"	"GGOEGESC014099"	1
"Buenos Aires"	"Sport Bag"	"GGOEGBMJ013399"	1
"Burnaby"	"Android Men's  Zip Hoodie"	"GGOEGAAX0359"	1
"Burnaby"	"Men's 100% Cotton Short Sleeve Hero Tee Black"	"GGOEGAAX0105"	1
"Burnaby"	"Men's 100% Cotton Short Sleeve Hero Tee White"	"GGOEGAAX0104"	1
"Calgary"	"Android Toddler Short Sleeve T-shirt Pink"	"GGOEGAAX0663"	1
"Calgary"	"Android Wool Heather Cap Heather/Black"	"GGOEAHPA004110"	1
"Calgary"	"Leatherette Notebook Combo"	"GGOEYOLR018699"	1
"Calgary"	"Luggage Tag"	"GGOEYOBR078599"	1
"Calgary"	"Recycled Mouse Pad"	"GGOEGODR017799"	1
"Cambridge"	"Screen Cleaning Cloth"	"GGOEGOFH020299"	3
"Cape Town"	"Men's Pullover Hoodie Grey"	"GGOEGAAX0362"	1
"Chandigarh"	"Men's 100% Cotton Short Sleeve Hero Tee Navy"	"GGOEGAAX0106"	1
"Charlotte"	"7"" Dog Frisbee"	"GGOEGAAX0098"	2
"Chennai"	"22 oz  Bottle Infuser"	"GGOEYDHJ056099"	5
"Chennai"	"RFID Journal"	"GGOEYOCR077399"	5
"Chicago"	"Men's 100% Cotton Short Sleeve Hero Tee White"	"GGOEGAAX0104"	7
"Chico"	"Android Men's Long Sleeve Badge Crew Tee Heather"	"GGOEGAAX0334"	1
"Chico"	"Men's 3/4 Sleeve Henley"	"GGOEGAAX0314"	1
"Chiyoda"	"24 oz  Sergeant Stripe Bottle"	"GGOEYDHJ019399"	1
"Chuo"	"Women's Scoop Neck Tee Black"	"GGOEGAAX0365"	1
"Cluj-Napoca"	"Men's 100% Cotton Short Sleeve Hero Tee Black"	"GGOEGAAX0105"	1
"Colombo"	"Android Men's Vintage Henley"	"GGOEGAAX0352"	2
"Columbia"	"Device Stand"	"GGOEGCBC074299"	1
"Columbus"	"Android Men's  Zip Hoodie"	"GGOEGAAX0359"	1
"Columbus"	"Men's Short Sleeve Badge Tee Charcoal"	"GGOEGAAJ032617"	1
"Copenhagen"	"Rocket Flashlight"	"GGOEGESC014099"	1
"Copenhagen"	"Trucker Hat"	"GGOEGHPA002910"	1
"Cork"	"Custom Decals"	"GGOEYFKQ020699"	1
"Council Bluffs"	"Kick Ball"	"GGOEGFSR022099"	1
"Council Bluffs"	"Men's Long Sleeve Raglan Ocean Blue"	"GGOEGAAX0331"	1
"Courbevoie"	"Android Wool Heather Cap Heather/Black"	"GGOEAHPA004110"	1
"Courbevoie"	"Men's 100% Cotton Short Sleeve Hero Tee White"	"GGOEGAAX0104"	1
"Coventry"	"Youth Short Sleeve Tee Red"	"GGOEGAAX0686"	1
"Culiacan"	"20 oz Stainless Steel Insulated Tumbler"	"GGOEGDHQ014899"	1
"Culiacan"	"Men's Short Sleeve Hero Tee Black"	"GGOEGAAX0318"	1
"Culiacan"	"Women's 1/4 Zip Performance Pullover Two-Tone Blue"	"GGOEGAAX0603"	1
"Cupertino"	"Men's Vintage Tank"	"GGOEGAAX0356"	2
"Dallas"	"Leatherette Notebook Combo"	"GGOEYOLR018699"	2
"Dallas"	"Micro Wireless Earbud"	"GGOEGEVA022399"	2
"Dallas"	"Women's Short Sleeve Hero Tee Black"	"GGOEGAAX0278"	2
"Denver"	"4400mAh Power Bank"	"GGOEGEHQ072599"	1
"Denver"	"Crunch Noise Dog Toy"	"GGOEGPJC203399"	1
"Denver"	"Luggage Tag"	"GGOEGOBC078699"	1
"Denver"	"Men's 100% Cotton Short Sleeve Hero Tee Black"	"GGOEGAAX0105"	1
"Denver"	"Twill Cap"	"GGOEGHPB071610"	1
"Denver"	"Waterproof Backpack"	"GGOEGBRA037499"	1
"Detroit"	"22 oz Water Bottle"	"GGOEGDHC018299"	1
"Detroit"	"High Capacity 10,400mAh Charger"	"GGOEGEHQ071199"	1
"Detroit"	"Screen Cleaning Cloth"	"GGOEGOFH020299"	1
"Detroit"	"Wool Heather Cap Heather/Navy"	"GGOEGHPA003010"	1
"Doha"	"Men's 100% Cotton Short Sleeve Hero Tee Black"	"GGOEGAAX0105"	1
"Druid Hills"	"Colored Pencil Set"	"GGOEGOBG023599"	1
"Dubai"	"Android Youth Short Sleeve T-shirt Aqua"	"GGOEGAAX0687"	1
"Dubai"	"Hard Cover Journal"	"GGOEYOCR077799"	1
"Dubai"	"Leatherette Journal"	"GGOEGOCB017499"	1
"Dubai"	"Men's Short Sleeve Performance Badge Tee Pewter"	"GGOEGAAX0591"	1
"Dubai"	"Recycled Mouse Pad"	"GGOEGODR017799"	1
"Dubai"	"Women's Convertible Vest-Jacket Sea Foam Green"	"GGOEGAAX0607"	1
"Dubai"	"Women's Long Sleeve Tee Lavender"	"GGOEGAAX0363"	1
"Dublin"	"Toddler Short Sleeve Tee Red"	"GGOEGAAX0661"	3
"East Lansing"	"25L Classic Rucksack"	"GGOEGAAX0795"	1
"Eau Claire"	"Men's 100% Cotton Short Sleeve Hero Tee Black"	"GGOEGAAX0105"	2
"Eau Claire"	"Men's Short Sleeve Hero Tee Charcoal"	"GGOEGAAX0325"	2
"Edmonton"	"Collapsible Pet Bowl"	"GGOEGAAX0231"	1
"Edmonton"	"Stylus Pen w/ LED Light"	"GGOEGOAR013099"	1
"Egham"	"Men's Short Sleeve Hero Tee White"	"GGOEGAAX0317"	1
"El Paso"	"Men's Short Sleeve Hero Tee Light Blue"	"GGOEGAAX0321"	1
"Forest Park"	"Men's Microfiber 1/4 Zip Pullover Blue/Indigo"	"GGOEGAAX0595"	1
"Fortaleza"	"Android Luggage Tag"	"GGOEAOBH078799"	1
"Fort Worth"	"Trucker Hat"	"GGOEYHPA003510"	1
"Frankfurt"	"Bib White"	"GGOEGKWQ060910"	1
"Fremont"	"2200mAh Micro Charger"	"GGOEGEHQ072499"	1
"Fremont"	"Android Men's  Zip Hoodie"	"GGOEGAAX0359"	1
"Fremont"	"Android Rise 14 oz Mug"	"GGOEADWQ015699"	1
"Fremont"	"Colored Pencil Set"	"GGOEGOBG023599"	1
"Fremont"	"Laptop Backpack"	"GGOEGBRB013899"	1
"Fremont"	"Men's 100% Cotton Short Sleeve Hero Tee Black"	"GGOEGAAX0105"	1
"Fremont"	"Men's Convertible Vest-Jacket Pewter"	"GGOEGAAX0598"	1
"Fremont"	"Men's Short Sleeve Hero Tee Black"	"GGOEGAAX0318"	1
"Fremont"	"Protect Smoke + CO White Battery Alarm-USA"	"GGOENEBQ079099"	1
"Fremont"	"RFID Journal"	"GGOEYOCR077399"	1
"Fremont"	"Stylus Pen w/ LED Light"	"GGOEGOAR013099"	1
"Fremont"	"Tri-blend Hoodie Grey"	"GGOEGAAX0313"	1
"Fremont"	"Windup Android"	"GGOEAKDH019899"	1
"Fremont"	"Women's Vintage Hero Tee Black"	"GGOEGAAX0341"	1
"Ghent"	"Windup Android"	"GGOEAKDH019899"	1
"Glasgow"	"Water Resistant Bluetooth Speaker"	"GGOEGEVR014999"	1
"Goose Creek"	"Android Wool Heather Cap Heather/Black"	"GGOEAHPA004110"	1
"Greer"	"Men's Quilted Insulated Vest Black"	"GGOEGAAX0596"	1
"Gurgaon"	"Android Men's Vintage Tank"	"GGOEGAAX0357"	2
"Hamburg"	"22 oz Android Bottle"	"GGOEADHH055999"	1
"Hamburg"	"22 oz  Bottle Infuser"	"GGOEYDHJ056099"	1
"Hamburg"	"Android BTTF Moonshot Graphic Tee"	"GGOEGAAX0349"	1
"Hamburg"	"Android Rise 14 oz Mug"	"GGOEADWQ015699"	1
"Hamburg"	"Basecamp Explorer Powerbank Flashlight"	"GGOEGESB015099"	1
"Hamburg"	"Blackout Cap"	"GGOEGHPJ080310"	1
"Hamburg"	"Men's 100% Cotton Short Sleeve Hero Tee White"	"GGOEGAAX0104"	1
"Hamburg"	"RFID Journal"	"GGOEYOCR077399"	1
"Hamburg"	"Suitcase Organizer Cubes"	"GGOEGCMB020932"	1
"Hamburg"	"Water Resistant Bluetooth Speaker"	"GGOEGEVR014999"	1
"Hamburg"	"Women's Performance Hero Tee Gunmetal"	"9183106"	1
"Hanoi"	"26 oz Double Wall Insulated Bottle"	"GGOEGDHQ015399"	1
"Hanoi"	"Dress Socks"	"GGOEWAEA083899"	1
"Hanoi"	"Luggage Tag"	"GGOEYOBR078599"	1
"Hanoi"	"Men's 100% Cotton Short Sleeve Hero Tee White"	"GGOEGAAX0104"	1
"Hayward"	"Men's Vintage Badge Tee White"	"GGOEGAAX0339"	1
"Helsinki"	"Android Onesie Gold"	"GGOEGAAX0617"	1
"Ho Chi Minh City"	"22 oz  Bottle Infuser"	"GGOEYDHJ056099"	1
"Ho Chi Minh City"	"Android Men's Long Sleeve Badge Crew Tee Heather"	"GGOEGAAX0334"	1
"Ho Chi Minh City"	"Basecamp Explorer Powerbank Flashlight"	"GGOEGESB015099"	1
"Ho Chi Minh City"	"Keyboard DOT Sticker"	"GGOEGFKA022299"	1
"Ho Chi Minh City"	"Laptop Backpack"	"GGOEGBRB013899"	1
"Ho Chi Minh City"	"Men's Airflow 1/4 Zip Pullover Black"	"GGOEGAAX0592"	1
"Ho Chi Minh City"	"Men's Short Sleeve Badge Tee Charcoal"	"GGOEGAAX0326"	1
"Ho Chi Minh City"	"Recycled Mouse Pad"	"GGOEGODR017799"	1
"Ho Chi Minh City"	"Toddler Short Sleeve Tee Red"	"GGOEGAAX0661"	1
"Hong Kong"	"Men's Short Sleeve Hero Tee Charcoal"	"GGOEGAAX0325"	2
"Hong Kong"	"Recycled Mouse Pad"	"GGOEGODR017799"	2
"Hong Kong"	"Screen Cleaning Cloth"	"GGOEGOFH020299"	2
"Houston"	"Men's Long Sleeve Raglan Ocean Blue"	"GGOEGAAX0331"	3
"Houston"	"Men's Short Sleeve Hero Tee Black"	"GGOEGAAX0318"	3
"Hyderabad"	"Men's 100% Cotton Short Sleeve Hero Tee White"	"GGOEGAAX0104"	5
"Hyderabad"	"Men's Vintage Badge Tee Black"	"GGOEGAAX0338"	5
"Iasi"	"Men's Vintage Henley"	"GGOEGAAX0351"	1
"Indianapolis"	"Ballpoint Stylus Pen"	"GGOEGOAR013599"	1
"Indore"	"Hard Cover Journal"	"GGOEYOCR077799"	1
"Indore"	"Leatherette Notebook Combo"	"GGOEYOLR018699"	1
"Indore"	"Men's Short Sleeve Hero Tee White"	"GGOEGAAX0317"	1
"Indore"	"Trucker Hat"	"GGOEYHPA003510"	1
"Indore"	"Twill Cap"	"GGOEGHPB071610"	1
"Ipoh"	"Bottle Opener Clip"	"GGOEGFAQ016699"	1
"Irvine"	"5-Panel Cap"	"GGOEGHPJ080110"	1
"Irvine"	"Android 17oz Stainless Steel Sport Bottle"	"GGOEADHH073999"	1
"Irvine"	"Android Rise 14 oz Mug"	"GGOEADWQ015699"	1
"Irvine"	"High Capacity 10,400mAh Charger"	"GGOEGEHQ071199"	1
"Irvine"	"Laptop and Cell Phone Stickers"	"GGOEGFKQ020399"	1
"Irvine"	"Learning Thermostat 3rd Gen-USA - Stainless Steel"	"GGOENEBJ079499"	1
"Irvine"	"Men's 100% Cotton Short Sleeve Hero Tee White"	"GGOEGAAX0104"	1
"Irvine"	"Men's Short Sleeve Hero Tee Charcoal"	"GGOEGAAX0325"	1
"Irvine"	"Men's Vintage Badge Tee Sage"	"GGOEGAAX0340"	1
"Irvine"	"Recycled Mouse Pad"	"GGOEGODR017799"	1
"Irvine"	"Sport Bag"	"9180766"	1
"Irvine"	"Switch Tone Color Crayon Pen"	"GGOEGKAA019299"	1
"Irvine"	"Tote Bag"	"GGOEGBJC014399"	1
"Irvine"	"Trucker Hat"	"GGOEYHPA003510"	1
"Irvine"	"Women's Convertible Vest-Jacket Sea Foam Green"	"9182765"	1
"Irvine"	"Women's Scoop Neck Tee Black"	"GGOEGAAX0365"	1
"Irvine"	"Women's Short Sleeve Hero Tee Black"	"GGOEGAAX0278"	1
"Irvine"	"Wool Heather Cap Heather/Navy"	"GGOEGHPA003010"	1
"Istanbul"	"Android Sticker Sheet Ultra Removable"	"GGOEAFKQ020599"	2
"Istanbul"	"G Noise-reducing Bluetooth Headphones"	"GGOEGEVB070599"	2
"Izmir"	"Women's Short Sleeve Hero Tee Black"	"GGOEGAAX0278"	1
"Izmir"	"Women's Short Sleeve Hero Tee White"	"GGOEGAAX0279"	1
"Jacksonville"	"20 oz Stainless Steel Insulated Tumbler"	"GGOEGDHQ014899"	1
"Jacksonville"	"Device Stand"	"GGOEGCBC074299"	1
"Jaipur"	"5-Panel Snapback Cap"	"GGOEGHPB080410"	1
"Jaipur"	"Men's 100% Cotton Short Sleeve Hero Tee White"	"GGOEGAAX0104"	1
"Jakarta"	"22 oz  Bottle Infuser"	"GGOEYDHJ056099"	2
"Jakarta"	"Men's Short Sleeve Hero Tee White"	"GGOEGAAX0317"	2
"Jakarta"	"Women's 1/4 Zip Jacket Charcoal"	"9182771"	2
"Jersey City"	"Women's 3/4 Sleeve Baseball Raglan Heather/Black"	"9182737"	1
"Jersey City"	"Women's Short Sleeve Hero Dark Grey"	"GGOEGAAX0289"	1
"Jersey City"	"Youth Short Sleeve Tee White"	"GGOEGAAX0690"	1
"Kalamazoo"	"Satin Black Ballpoint Pen"	"GGOEGOAB022499"	1
"Kansas City"	"Insulated Stainless Steel Bottle"	"GGOEGDHB072099"	1
"Kansas City"	"Women's Short Sleeve Hero Tee Heather"	"GGOEGAAX0733"	1
"Kansas City"	"Women's Short Sleeve Hero Tee Red Heather"	"GGOEGAAX0297"	1
"Karachi"	"Ballpoint Stylus Pen"	"GGOEGOAR013599"	1
"Karachi"	"Men's Long Sleeve Raglan Ocean Blue"	"GGOEGAAX0331"	1
"Karachi"	"Men's Vintage Tee"	"GGOEGAAX0346"	1
"Karachi"	"RFID Journal"	"GGOEYOCR077399"	1
"Kharagpur"	"Men's Performance Full Zip Jacket Black"	"GGOEGAAX0569"	1
"Kharagpur"	"Tri-blend Hoodie Grey"	"GGOEGAAX0313"	1
"Kharkiv"	"Women's V-Neck Tee Charcoal"	"GGOEGAAX0299"	1
"Kiev"	"22 oz Android Bottle"	"GGOEADHH055999"	1
"Kiev"	"Alpine Style Backpack"	"GGOEGBRJ037299"	1
"Kiev"	"Android Rise 14 oz Mug"	"GGOEADWQ015699"	1
"Kiev"	"Bottle Opener Clip"	"GGOEGFAQ016699"	1
"Kiev"	"Keyboard DOT Sticker"	"GGOEGFKA022299"	1
"Kiev"	"Leatherette Notebook Combo"	"GGOEYOLR018699"	1
"Kiev"	"Maze Pen"	"GGOEGGOA017399"	1
"Kiev"	"Men's 100% Cotton Short Sleeve Hero Tee Black"	"GGOEGAAX0105"	1
"Kiev"	"Men's 100% Cotton Short Sleeve Hero Tee White"	"GGOEGAAX0104"	1
"Kiev"	"Metal Texture Roller Pen"	"GGOEGOAB021499"	1
"Kiev"	"Micro Wireless Earbud"	"GGOEGEVA022399"	1
"Kiev"	"Toddler Short Sleeve Tee White"	"GGOEGAAX0671"	1
"Kiev"	"Tote Bag"	"GGOEGBJC014399"	1
"Kiev"	"Waterproof Gear Bag"	"GGOEGBMC056599"	1
"Kiev"	"Women's Fleece Hoodie"	"GGOEGAAX0360"	1
"Kiev"	"Women's Vintage Hero Tee White"	"GGOEGAAX0342"	1
"Kirkland"	"Waterproof Backpack"	"GGOEGBRA037499"	2
"Kitchener"	"5-Panel Cap"	"GGOEGHPJ080110"	1
"Kitchener"	"Android Men's Long Sleeve Badge Crew Tee Heather"	"GGOEGAAX0334"	1
"Kitchener"	"Keyboard DOT Sticker"	"GGOEGFKA022299"	1
"Kitchener"	"Recycled Mouse Pad"	"GGOEGODR017799"	1
"Kitchener"	"Women's Lightweight Microfleece Jacket"	"GGOEGAAX0582"	1
"Kolkata"	"24 oz  Sergeant Stripe Bottle"	"GGOEYDHJ019399"	2
"Kolkata"	"Custom Decals"	"GGOEYFKQ020699"	2
"Kolkata"	"Luggage Tag"	"GGOEYOBR078599"	2
"Kovrov"	"Women's Fleece Hoodie"	"GGOEGAAX0360"	1
"Kuala Lumpur"	"26 oz Double Wall Insulated Bottle"	"GGOEGDHQ015399"	1
"Kuala Lumpur"	"Alpine Style Backpack"	"GGOEGBRJ037299"	1
"Kuala Lumpur"	"Android Men's  Zip Hoodie"	"GGOEGAAX0359"	1
"Kuala Lumpur"	"Android Spiral Journal with Pen"	"GGOEAOCH077899"	1
"Kuala Lumpur"	"Electronics Accessory Pouch"	"GGOEGBFC018799"	1
"Kuala Lumpur"	"Four Color Retractable Pen"	"GGOEGOAQ020099"	1
"Kuala Lumpur"	"Leatherette Notebook Combo"	"GGOEYOLR018699"	1
"Kuala Lumpur"	"Men's 100% Cotton Short Sleeve Hero Tee White"	"GGOEGAAX0104"	1
"Kuala Lumpur"	"Men's Long & Lean Tee Charcoal"	"GGOEGAAX0328"	1
"Kuala Lumpur"	"Men's Short Sleeve Hero Tee Charcoal"	"GGOEGAAX0325"	1
"Kuala Lumpur"	"Men's Short Sleeve Hero Tee Heather"	"GGOEGAAX0734"	1
"Kuala Lumpur"	"Men's Short Sleeve Hero Tee Light Blue"	"GGOEGAAX0321"	1
"Kuala Lumpur"	"Slim Utility Travel Bag"	"GGOEGBPB021199"	1
"Kuala Lumpur"	"Women's Convertible Vest-Jacket Sea Foam Green"	"GGOEGAAX0607"	1
"Kuala Lumpur"	"Women's Short Sleeve Hero Tee Black"	"GGOEGAAX0278"	1
"Kuala Lumpur"	"Wool Heather Cap Heather/Black"	"GGOEYHPA003610"	1
"LaFayette"	"Men's 100% Cotton Short Sleeve Hero Tee Navy"	"GGOEGAAX0106"	1
"Lahore"	"Tube Power Bank"	"GGOEGETR014599"	1
"Lake Oswego"	"Men's 100% Cotton Short Sleeve Hero Tee Red"	"GGOEGAAX0107"	1
"Lake Oswego"	"Men's Performance Full Zip Jacket Black"	"9184620"	1
"Lake Oswego"	"Men's Short Sleeve Hero Tee Heather"	"GGOEGAAX0734"	1
"Lake Oswego"	"Recycled Mouse Pad"	"GGOEGODR017799"	1
"Lake Oswego"	"Women's Short Sleeve Performance Tee Pewter"	"GGOEGAAX0601"	1
"Las Vegas"	"Android Youth Short Sleeve T-shirt Pewter"	"GGOEGAAX0688"	1
"Las Vegas"	"Men's 100% Cotton Short Sleeve Hero Tee Black"	"GGOEGAAX0105"	1
"Las Vegas"	"Men's Airflow 1/4 Zip Pullover Lapis"	"GGOEGAAX0593"	1
"La Victoria"	"22 oz  Bottle Infuser"	"GGOEYDHJ056099"	1
"La Victoria"	"Android Twill Cap"	"GGOEAHPJ074410"	1
"La Victoria"	"Android Women's Short Sleeve Badge Tee Dark Heather"	"GGOEGAAX0282"	1
"La Victoria"	"Men's 100% Cotton Short Sleeve Hero Tee White"	"GGOEGAAX0104"	1
"La Victoria"	"Men's Weatherblock Shell Jacket Black"	"GGOEGAAX0566"	1
"La Victoria"	"Mobile Phone Vent Mount"	"9184682"	1
"La Victoria"	"Twill Cap"	"GGOEYHPB072210"	1
"La Victoria"	"Women's Vintage Hero Tee Black"	"GGOEGAAX0341"	1
"Lisbon"	"Blackout Cap"	"GGOEGHPJ080310"	1
"Longtan District"	"26 oz Double Wall Insulated Bottle"	"GGOEGDHQ015399"	1
"Los Angeles"	"Men's 100% Cotton Short Sleeve Hero Tee White"	"GGOEGAAX0104"	7
"Lucknow"	"Android Men's Short Sleeve Tri-blend Hero Tee Grey"	"GGOEGAAX0324"	1
"Lucknow"	"Men's Vintage Tank"	"GGOEGAAX0356"	1
"Madison"	"Tote Bag"	"GGOEGBJC014399"	1
"Madrid"	"Dress Socks"	"GGOEWAEA083899"	2
"Madrid"	"SPF-15 Slim & Slender Lip Balm"	"GGOEGCBQ016499"	2
"Makati"	"G Noise-reducing Bluetooth Headphones"	"GGOEGEVB070599"	1
"Makati"	"Men's Short Sleeve Hero Tee Light Blue"	"GGOEGAAX0321"	1
"Manchester"	"G Noise-reducing Bluetooth Headphones"	"GGOEGEVB070599"	1
"Manchester"	"Luggage Tag"	"GGOEYOBR078599"	1
"Manila"	"Men's Short Sleeve Hero Tee White"	"GGOEGAAX0317"	2
"Maracaibo"	"Android Men's Vintage Henley"	"GGOEGAAX0352"	1
"Maracaibo"	"Tube Power Bank"	"GGOEGETR014599"	1
"Marlboro"	"Men's Microfiber 1/4 Zip Pullover Blue/Indigo"	"9182743"	1
"Marseille"	"Men's 100% Cotton Short Sleeve Hero Tee Black"	"GGOEGAAX0105"	1
"Marseille"	"Men's 3/4 Sleeve Henley"	"GGOEGAAX0314"	1
"Medellin"	"Bottle Opener Clip"	"GGOEGFAQ016699"	1
"Medellin"	"Men's Watershed Full Zip Hoodie Grey"	"GGOEGAAX0568"	1
"Melbourne"	"Laptop and Cell Phone Stickers"	"GGOEGFKQ020399"	3
"Menlo Park"	"Cam Indoor Security Camera - USA"	"GGOENEBB078899"	1
"Menlo Park"	"Men's Weatherblock Shell Jacket Black"	"GGOEGAAX0566"	1
"Menlo Park"	"Snapback Hat Black"	"GGOEGHPB003410"	1
"Mexico City"	"Men's Short Sleeve Hero Tee Charcoal"	"GGOEGAAX0325"	2
"Mexico City"	"RFID Journal"	"GGOEYOCR077399"	2
"Mexico City"	"Women's  Short Sleeve Hero Tee Black"	"GGOEGAAX0284"	2
"Milan"	"22 oz  Bottle Infuser"	"GGOEYDHJ056099"	2
"Milpitas"	"Android Stretch Fit Hat"	"GGOEGAAX0042"	1
"Milpitas"	"Crunch Noise Dog Toy"	"GGOEGPJC203399"	1
"Milpitas"	"Men's Microfiber 1/4 Zip Pullover Blue/Indigo"	"GGOEGAAX0595"	1
"Milpitas"	"Men's  Zip Hoodie"	"GGOEGAAX0358"	1
"Milpitas"	"Women's Lightweight Microfleece Jacket"	"GGOEGAAX0582"	1
"Milpitas"	"Women's Quilted Insulated Vest Black"	"GGOEGAAX0604"	1
"Milpitas"	"Women's Short Sleeve Hero Dark Grey"	"GGOEGAAX0289"	1
"Milpitas"	"Women's Short Sleeve Hero Tee Sky Blue"	"GGOEGAAX0291"	1
"Minato"	"Leatherette Notebook Combo"	"GGOEYOLR018699"	2
"Minato"	"Men's 100% Cotton Short Sleeve Hero Tee White"	"GGOEGAAX0104"	2
"Minato"	"Men's Vintage Tank"	"GGOEGAAX0356"	2
"Minato"	"Windup Android"	"GGOEAKDH019899"	2
"Minato"	"Women's  Short Sleeve Hero Tee Black"	"GGOEGAAX0284"	2
"Minneapolis"	"Android Men's Short Sleeve Tri-blend Hero Tee Grey"	"GGOEGAAX0324"	1
"Minneapolis"	"Men's Vintage Badge Tee White"	"GGOEGAAX0339"	1
"Mississauga"	"Collapsible Shopping Bag"	"GGOEGBJC019999"	1
"Mississauga"	"Custom Decals"	"GGOEYFKQ020699"	1
"Mississauga"	"Toddler Hoodie Royal Blue"	"GGOEGAAX0656"	1
"Mississauga"	"Tube Power Bank"	"GGOEGETR014599"	1
"Monterrey"	"Leatherette Notebook Combo"	"GGOEYOLR018699"	1
"Monterrey"	"Toddler 1/4 Zip Fleece Pewter"	"GGOEGAAX0657"	1
"Monterrey"	"Trucker Hat"	"GGOEGHPA002910"	1
"Montevideo"	"Men's 100% Cotton Short Sleeve Hero Tee White"	"GGOEGAAX0104"	1
"Montevideo"	"Vintage Henley Grey/Black"	"GGOEGAAX0353"	1
"Montreal"	"Alpine Style Backpack"	"GGOEGBRJ037299"	2
"Montreal"	"Men's 100% Cotton Short Sleeve Hero Tee Navy"	"GGOEGAAX0106"	2
"Montreal"	"RFID Journal"	"GGOEYOCR077399"	2
"Montreuil"	"Collapsible Shopping Bag"	"GGOEGBJC019999"	1
"Montreuil"	"Colored Pencil Set"	"GGOEGOBG023599"	1
"Moscow"	"Android Men's Vintage Tank"	"GGOEGAAX0357"	1
"Moscow"	"Kick Ball"	"GGOEGFSR022099"	1
"Moscow"	"Men's 100% Cotton Short Sleeve Hero Tee Black"	"GGOEGAAX0105"	1
"Moscow"	"Men's 100% Cotton Short Sleeve Hero Tee Navy"	"GGOEGAAX0106"	1
"Moscow"	"Men's Airflow 1/4 Zip Pullover Lapis"	"GGOEGAAX0593"	1
"Moscow"	"Men's Bayside Graphic Tee"	"GGOEGAAX0350"	1
"Moscow"	"Men's Long Sleeve Raglan Ocean Blue"	"GGOEGAAX0331"	1
"Moscow"	"SPF-15 Slim & Slender Lip Balm"	"GGOEGCBQ016499"	1
"Moscow"	"Women's 1/4 Zip Jacket Charcoal"	"9182771"	1
"Moscow"	"Women's Fleece Hoodie"	"GGOEGAAX0360"	1
"Moscow"	"Women's Short Sleeve Hero Tee Black"	"GGOEGAAX0278"	1
"Moscow"	"Women's Vintage Hero Tee Black"	"GGOEGAAX0341"	1
"Moscow"	"Wool Heather Cap Heather/Black"	"GGOEYHPA003610"	1
"Moscow"	"Youth Short Sleeve Tee Red"	"GGOEGAAX0686"	1
"Moscow"	"Youth Short Sleeve T-shirt Green"	"GGOEGAAX0684"	1
"Mountain View"	"Cam Indoor Security Camera - USA"	"GGOENEBB078899"	24
"Nagoya"	"Women's Convertible Vest-Jacket Sea Foam Green"	"GGOEGAAX0607"	1
"Nairobi"	"Flashlight"	"GGOEGESB015199"	1
"Nairobi"	"Men's Long & Lean Tee Grey"	"GGOEGAAX0327"	1
"Nanded"	"Men's Short Sleeve Hero Tee Charcoal"	"GGOEGAAX0325"	1
"Nashville"	"Learning Thermostat 3rd Gen-USA - Stainless Steel"	"GGOENEBJ079499"	1
"Neipu Township"	"Women's Fleece Hoodie"	"GGOEGAAX0360"	1
"New Delhi"	"Custom Decals"	"GGOEYFKQ020699"	2
"New Delhi"	"Men's Long Sleeve Raglan Ocean Blue"	"GGOEGAAX0331"	2
"New Delhi"	"Men's Short Sleeve Hero Tee Heather"	"GGOEGAAX0734"	2
"New Delhi"	"Men's Vintage Tee"	"GGOEGAAX0346"	2
"New Delhi"	"Snapback Hat Black"	"GGOEGHPB003410"	2
"Norfolk"	"Suitcase Organizer Cubes"	"GGOEGCMB020932"	1
"Norfolk"	"Trucker Hat"	"GGOEYHPA003510"	1
"Norfolk"	"Women's Short Sleeve Hero Tee Red Heather"	"GGOEGAAX0297"	1
"Oakland"	"Android Men's  Zip Hoodie"	"GGOEGAAX0359"	1
"Oakland"	"Doodle Decal"	"GGOEGFKQ020799"	1
"Oakland"	"Keyboard DOT Sticker"	"GGOEGFKA022299"	1
"Oakland"	"Laptop and Cell Phone Stickers"	"GGOEGFKQ020399"	1
"Oakland"	"Rucksack"	"GGOEGBRJ037399"	1
"Oakland"	"Women's Convertible Vest-Jacket Sea Foam Green"	"GGOEGAAX0607"	1
"Oakland"	"Yoga Block"	"GGOEGACB023699"	1
"Orlando"	"Men's Short Sleeve Hero Tee Black"	"GGOEGAAX0318"	1
"Orlando"	"Men's Vintage Henley"	"GGOEGAAX0351"	1
"Orlando"	"Men's Watershed Full Zip Hoodie Grey"	"GGOEGAAX0568"	1
"Orlando"	"Suitcase Organizer Cubes"	"GGOEGCMB020932"	1
"Orlando"	"Women's  Short Sleeve Hero Tee Black"	"GGOEGAAX0284"	1
"Orlando"	"Wool Heather Cap Heather/Black"	"GGOEYHPA003610"	1
"Osaka"	"Dress Socks"	"GGOEWAEA083899"	1
"Osaka"	"Infant Short Sleeve Tee Red"	"GGOEGAAX0618"	1
"Osaka"	"Protect Smoke + CO White Wired Alarm-USA"	"GGOENEBQ079199"	1
"Osaka"	"Rucksack"	"GGOEGBRJ037399"	1
"Osaka"	"Stylus Pen w/ LED Light"	"GGOEGOAR013099"	1
"Osaka"	"Women's Short Sleeve Hero Tee Sky Blue"	"GGOEGAAX0291"	1
"Oslo"	"Men's 100% Cotton Short Sleeve Hero Tee Red"	"GGOEGAAX0107"	1
"Ottawa"	"Men's Short Sleeve Hero Tee Heather"	"GGOEGAAX0734"	1
"Ottawa"	"Men's Short Sleeve Hero Tee White"	"GGOEGAAX0317"	1
"Oviedo"	"5-Panel Snapback Cap"	"GGOEGHPB080410"	1
"Oviedo"	"Luggage Tag"	"GGOEGOBC078699"	1
"Oviedo"	"Wool Heather Cap Heather/Black"	"GGOEYHPA003610"	1
"Oxford"	"Water Resistant Bluetooth Speaker"	"GGOEGEVR014999"	1
"Palo Alto"	"Cam Outdoor Security Camera - USA"	"GGOENEBQ078999"	7
"Panama City"	"Men's Convertible Vest-Jacket Pewter"	"GGOEGAAX0598"	1
"Paris"	"Trucker Hat"	"GGOEYHPA003510"	3
"Parsippany-Troy Hills"	"Men's Lightweight Microfleece Jacket Black"	"GGOEGAAX0573"	1
"Patna"	"22 oz Android Bottle"	"GGOEADHH055999"	1
"Patna"	"Vintage Henley Grey/Black"	"GGOEGAAX0353"	1
"Perth"	"Custom Decals"	"GGOEYFKQ020699"	1
"Perth"	"Leatherette Notebook Combo"	"GGOEYOLR018699"	1
"Perth"	"Rucksack"	"GGOEGBRJ037399"	1
"Perth"	"Women's  Short Sleeve Hero Tee Black"	"GGOEGAAX0284"	1
"Perth"	"Women's Short Sleeve Hero Tee Red Heather"	"GGOEGAAX0297"	1
"Petaling Jaya"	"Women's 1/4 Zip Performance Pullover Black"	"GGOEGAAX0602"	1
"Petaling Jaya"	"Women's Short Sleeve Hero Tee Black"	"GGOEGAAX0278"	1
"Phoenix"	"Android 5-Panel Low Cap"	"GGOEAHPB080210"	1
"Phoenix"	"Cam Indoor Security Camera - USA"	"GGOENEBB078899"	1
"Phoenix"	"Men's 100% Cotton Short Sleeve Hero Tee Navy"	"GGOEGAAX0106"	1
"Phoenix"	"Men's Short Sleeve Hero Tee Heather"	"GGOEGAAX0734"	1
"Phoenix"	"Screen Cleaning Cloth"	"GGOEGOFH020299"	1
"Phoenix"	"Switch Tone Color Crayon Pen"	"GGOEGKAA019299"	1
"Piscataway Township"	"Men's 100% Cotton Short Sleeve Hero Tee Red"	"GGOEGAAX0107"	1
"Pittsburgh"	"Collapsible Shopping Bag"	"GGOEGBJC019999"	2
"Pleasanton"	"Electronics Accessory Pouch"	"GGOEGBFC018799"	1
"Portland"	"Men's 100% Cotton Short Sleeve Hero Tee Navy"	"GGOEGAAX0106"	1
"Portland"	"Men's Short Sleeve Hero Tee Charcoal"	"GGOEGAAX0325"	1
"Portland"	"Tri-blend Hoodie Grey"	"9181019"	1
"Portland"	"Trucker Hat"	"GGOEYHPA003510"	1
"Portland"	"Women's 1/4 Zip Jacket Charcoal"	"9182771"	1
"Portland"	"Women's Convertible Vest-Jacket Sea Foam Green"	"GGOEGAAX0607"	1
"Poznan"	"Bongo Cupholder Bluetooth Speaker"	"GGOEGEVB070899"	1
"Poznan"	"Men's 100% Cotton Short Sleeve Hero Tee Black"	"GGOEGAAX0105"	1
"Pozuelo de Alarcon"	"Car Clip Phone Holder"	"GGOEGCBB074199"	1
"Pozuelo de Alarcon"	"Hard Cover Journal"	"GGOEYOCR077799"	1
"Pozuelo de Alarcon"	"Rocket Flashlight"	"GGOEGESC014099"	1
"Prague"	"Men's 100% Cotton Short Sleeve Hero Tee White"	"GGOEGAAX0104"	2
"Pune"	"Men's 100% Cotton Short Sleeve Hero Tee White"	"GGOEGAAX0104"	2
"Pune"	"Women's 3/4 Sleeve Baseball Raglan Heather/Black"	"GGOEGAAX0304"	2
"Quebec City"	"Custom Decals"	"GGOEYFKQ020699"	1
"Quebec City"	"Men's 100% Cotton Short Sleeve Hero Tee Black"	"GGOEGAAX0105"	1
"Quebec City"	"Men's Lightweight Microfleece Jacket Black"	"GGOEGAAX0573"	1
"Quebec City"	"Men's Short Sleeve Hero Tee Black"	"GGOEGAAX0318"	1
"Quebec City"	"Men's Short Sleeve Hero Tee Heather"	"GGOEGAAX0734"	1
"Quebec City"	"Men's Short Sleeve Hero Tee Light Blue"	"GGOEGAAX0321"	1
"Quebec City"	"Women's Short Sleeve Hero Tee Sky Blue"	"GGOEGAAX0291"	1
"Quezon City"	"Android Twill Cap"	"GGOEAHPJ074410"	1
"Quezon City"	"Men's 100% Cotton Short Sleeve Hero Tee Navy"	"GGOEGAAX0106"	1
"Quezon City"	"Men's 100% Cotton Short Sleeve Hero Tee Red"	"GGOEGAAX0107"	1
"Quezon City"	"Men's Long Sleeve Pullover Badge Tee Heather"	"GGOEGAAX0335"	1
"Quezon City"	"Seat Pack Organizer"	"GGOEGCNB021099"	1
"Quezon City"	"Women's Short Sleeve Hero Tee Black"	"GGOEGAAX0278"	1
"Redmond"	"RFID Journal"	"GGOEYOCR077399"	2
"Redwood City"	"Cam Indoor Security Camera - USA"	"GGOENEBB078899"	1
"Redwood City"	"Lunch Bag"	"GGOEGBCR024399"	1
"Redwood City"	"Men's Convertible Vest-Jacket Pewter"	"GGOEGAAX0598"	1
"Redwood City"	"Men's Vintage Badge Tee Sage"	"GGOEGAAX0340"	1
"Redwood City"	"Women's Convertible Vest-Jacket Black"	"GGOEGAAX0606"	1
"Redwood City"	"Women's Short Sleeve Hero Tee White"	"GGOEGAAX0279"	1
"Rexburg"	"17oz Stainless Steel Sport Bottle"	"GGOEGDHC074099"	1
"Rexburg"	"24 oz  Sergeant Stripe Bottle"	"GGOEYDHJ019399"	1
"Rexburg"	"Android 17oz Stainless Steel Sport Bottle"	"GGOEADHH073999"	1
"Richardson"	"Micro Wireless Earbud"	"GGOEGEVA022399"	1
"Rio de Janeiro"	"Blackout Cap"	"GGOEGHPJ080310"	1
"Rio de Janeiro"	"Men's 100% Cotton Short Sleeve Hero Tee Black"	"GGOEGAAX0105"	1
"Rio de Janeiro"	"Men's  Zip Hoodie"	"GGOEGAAX0358"	1
"Riyadh"	"Leatherette Journal"	"GGOEGOCB017499"	1
"Riyadh"	"Red Spiral  Notebook"	"GGOEGOCT019199"	1
"Riyadh"	"Youth Short Sleeve T-shirt Yellow"	"GGOEGAAX0685"	1
"Rome"	"Keyboard DOT Sticker"	"GGOEGFKA022299"	1
"Rome"	"Leatherette Journal"	"GGOEGOCB017499"	1
"Rome"	"Leatherette Notebook Combo"	"GGOEYOLR018699"	1
"Rome"	"RFID Journal"	"GGOEGOCC077299"	1
"Rome"	"Women's 3/4 Sleeve Baseball Raglan Heather/Black"	"GGOEGAAX0304"	1
"Rosario"	"Men's Vintage Badge Tee Black"	"GGOEGAAX0338"	1
"Rotterdam"	"Wool Heather Cap Heather/Black"	"GGOEYHPA003610"	1
"Sacramento"	"Blackout Cap"	"GGOEGHPJ080310"	1
"Saint Petersburg"	"Hard Cover Journal"	"GGOEYOCR077799"	1
"Saint Petersburg"	"Leatherette Journal"	"GGOEGOCB017499"	1
"Saint Petersburg"	"Men's Quilted Insulated Vest Black"	"GGOEGAAX0596"	1
"Saint Petersburg"	"Women's Lightweight Microfleece Jacket"	"9182785"	1
"Sakai"	"Leatherette Notebook Combo"	"GGOEYOLR018699"	1
"Salem"	"17oz Stainless Steel Sport Bottle"	"GGOEGDHC074099"	2
"Salem"	"Bib White"	"GGOEGKWQ060910"	2
"Salem"	"Men's Long Sleeve Raglan Ocean Blue"	"GGOEGAAX0331"	2
"Salford"	"Car Clip Phone Holder"	"GGOEGCBB074199"	1
"San Antonio"	"Android 17oz Stainless Steel Sport Bottle"	"GGOEADHH073999"	2
"San Bruno"	"22 oz  Bottle Infuser"	"GGOEYDHJ056099"	2
"San Bruno"	"RFID Journal"	"GGOEYOCR077399"	2
"San Bruno"	"Trucker Hat"	"GGOEYHPA003510"	2
"San Bruno"	"Water Resistant Bluetooth Speaker"	"GGOEGEVR014999"	2
"San Diego"	"Zipper-front Sports Bag"	"GGOEGBMB073799"	2
"Sandton"	"Water Resistant Bluetooth Speaker"	"GGOEGEVR014999"	1
"San Jose"	"Men's 100% Cotton Short Sleeve Hero Tee White"	"GGOEGAAX0104"	8
"San Mateo"	"Device Holder Sticky Pad"	"GGOEGCBB074399"	1
"San Mateo"	"Tri-blend Hoodie Grey"	"GGOEGAAX0313"	1
"San Mateo"	"Trucker Hat"	"GGOEYHPA003510"	1
"San Salvador"	"Device Holder Sticky Pad"	"GGOEGCBB074399"	1
"Santa Clara"	"Cam Indoor Security Camera - USA"	"GGOENEBB078899"	2
"Santa Clara"	"Men's Quilted Insulated Vest Black"	"GGOEGAAX0596"	2
"Santa Clara"	"Trucker Hat"	"GGOEGHPA002910"	2
"Santa Clara"	"Women's Short Sleeve Hero Tee White"	"GGOEGAAX0279"	2
"Santa Clara"	"Women's Vintage Hero Tee Black"	"GGOEGAAX0341"	2
"Santa Fe"	"SPF-15 Slim & Slender Lip Balm"	"GGOEGCBQ016499"	1
"Santa Fe"	"Water Resistant Bluetooth Speaker"	"GGOEGEVR014999"	1
"Santa Monica"	"Slim Utility Travel Bag"	"GGOEGBPB021199"	1
"Santiago"	"1 oz Hand Sanitizer"	"GGOEGCKQ013199"	1
"Santiago"	"Kick Ball"	"GGOEGFSR022099"	1
"Santiago"	"Men's 3/4 Sleeve Henley"	"GGOEGAAX0314"	1
"Santiago"	"Micro Wireless Earbud"	"GGOEGEVA022399"	1
"Santiago"	"Sport Bag"	"GGOEGBMJ013399"	1
"Sao Paulo"	"Suitcase Organizer Cubes"	"GGOEGCMB020932"	2
"Sapporo"	"Android Toddler Short Sleeve T-shirt Pink"	"GGOEGAAX0663"	1
"Seattle"	"Android Men's  Zip Hoodie"	"GGOEGAAX0359"	4
"Seattle"	"Laptop and Cell Phone Stickers"	"GGOEGFKQ020399"	4
"Seoul"	"17oz Stainless Steel Sport Bottle"	"GGOEGDHC074099"	1
"Seoul"	"22 oz  Bottle Infuser"	"GGOEYDHJ056099"	1
"Seoul"	"24 oz  Sergeant Stripe Bottle"	"GGOEYDHJ019399"	1
"Seoul"	"Android Men's Long Sleeve Badge Crew Tee Heather"	"GGOEGAAX0334"	1
"Seoul"	"Android Men's Vintage Henley"	"GGOEGAAX0352"	1
"Seoul"	"Android Men's  Zip Hoodie"	"GGOEGAAX0359"	1
"Seoul"	"Baby on Board Window Decal"	"GGOEWFKA082999"	1
"Seoul"	"Ballpoint LED Light Pen"	"GGOEGOAQ012899"	1
"Seoul"	"Ballpoint Stylus Pen"	"GGOEGOAR013599"	1
"Seoul"	"Compact Selfie Stick"	"GGOEGFQB013799"	1
"Seoul"	"Custom Decals"	"GGOEYFKQ020699"	1
"Seoul"	"Dress Socks"	"GGOEWAEA083899"	1
"Seoul"	"Flashlight"	"GGOEGESB015199"	1
"Seoul"	"Leatherette Notebook Combo"	"GGOEYOLR018699"	1
"Seoul"	"Men's Long Sleeve Raglan Ocean Blue"	"GGOEGAAX0331"	1
"Seoul"	"Men's Short Sleeve Performance Badge Tee Pewter"	"GGOEGAAX0591"	1
"Seoul"	"Men's Weatherblock Shell Jacket Black"	"GGOEGAAX0566"	1
"Seoul"	"Onesie Green"	"GGOEGAAX0613"	1
"Seoul"	"Red Shine 15 oz Mug"	"GGOEGDWR015799"	1
"Seoul"	"Sport Bag"	"GGOEGBMJ013399"	1
"Seoul"	"Vintage Henley Grey/Black"	"GGOEGAAX0353"	1
"Seoul"	"Windup Android"	"GGOEAKDH019899"	1
"Sherbrooke"	"Blackout Cap"	"GGOEGHPJ080310"	1
"Sherbrooke"	"Cam Indoor Security Camera - USA"	"GGOENEBB078899"	1
"Sherbrooke"	"Men's Long Sleeve Raglan Ocean Blue"	"9180905"	1
"Shibuya"	"Men's Short Sleeve Hero Tee White"	"GGOEGAAX0317"	1
"Shibuya"	"Men's Vintage Badge Tee Sage"	"GGOEGAAX0340"	1
"Shinjuku"	"17oz Stainless Steel Sport Bottle"	"GGOEGDHC074099"	1
"Shinjuku"	"Colored Pencil Set"	"GGOEGOBG023599"	1
"Shinjuku"	"Men's Vintage Tee"	"GGOEGAAX0346"	1
"Shinjuku"	"Plastic Sliding Flashlight"	"GGOEGESQ016799"	1
"Shinjuku"	"Trucker Hat"	"GGOEGHPA002910"	1
"Shinjuku"	"Windup Android"	"GGOEAKDH019899"	1
"Shinjuku"	"Women's Scoop Neck Tee White"	"GGOEGAAX0366"	1
"Singapore"	"Alpine Style Backpack"	"GGOEGBRJ037299"	2
"Singapore"	"Men's 100% Cotton Short Sleeve Hero Tee Black"	"GGOEGAAX0105"	2
"Singapore"	"Women's Vintage Hero Tee Platinum"	"GGOEGAAX0344"	2
"South El Monte"	"Men's Vintage Badge Tee White"	"GGOEGAAX0339"	1
"South San Francisco"	"Android Sticker Sheet Ultra Removable"	"GGOEAFKQ020599"	1
"South San Francisco"	"Men's 100% Cotton Short Sleeve Hero Tee Black"	"GGOEGAAX0105"	1
"South San Francisco"	"Men's Short Sleeve Hero Tee Heather"	"GGOEGAAX0734"	1
"South San Francisco"	"Rucksack"	"GGOEGBRJ037399"	1
"Stanford"	"Men's  Zip Hoodie"	"GGOEGAAX0358"	1
"St. John's"	"2200mAh Micro Charger"	"GGOEGEHQ072499"	1
"St. Louis"	"Bib Red"	"GGOEGKWR060810"	1
"St. Louis"	"Wool Heather Cap Heather/Navy"	"GGOEGHPA003010"	1
"Stockholm"	"24 oz  Sergeant Stripe Bottle"	"GGOEYDHJ019399"	1
"Stockholm"	"Android Rise 14 oz Mug"	"GGOEADWQ015699"	1
"Stockholm"	"Ballpoint Stylus Pen"	"GGOEGOAR013599"	1
"Stockholm"	"Crunch Noise Dog Toy"	"GGOEGPJC203399"	1
"Stockholm"	"French Terry Cap"	"GGOEGHPJ080010"	1
"Stockholm"	"Men's 100% Cotton Short Sleeve Hero Tee Black"	"GGOEGAAX0105"	1
"Stockholm"	"Men's Pullover Hoodie Grey"	"GGOEGAAX0362"	1
"Stockholm"	"Men's Short Sleeve Hero Tee Black"	"GGOEGAAX0318"	1
"Stockholm"	"Men's Short Sleeve Hero Tee Heather"	"GGOEGAAX0734"	1
"Stockholm"	"Men's Short Sleeve Hero Tee White"	"GGOEGAAX0317"	1
"Stockholm"	"Metal Texture Roller Pen"	"GGOEGOAB021499"	1
"Stockholm"	"Waterproof Backpack"	"GGOEGBRA037499"	1
"Stockholm"	"Water Resistant Bluetooth Speaker"	"GGOEGEVR014999"	1
"Stockholm"	"Women's Short Sleeve Hero Tee Red Heather"	"GGOEGAAX0297"	1
"Stockholm"	"Women's Short Sleeve Hero Tee Sky Blue"	"GGOEGAAX0291"	1
"Stuttgart"	"Pocket Bluetooth Speaker"	"GGOEGEVB071799"	1
"Sunnyvale"	"Cam Outdoor Security Camera - USA"	"GGOENEBQ078999"	6
"Taguig"	"5-Panel Cap"	"GGOEGHPJ080110"	1
"Taguig"	"Luggage Tag"	"GGOEGOBC078699"	1
"Taguig"	"Men's Convertible Vest-Jacket Pewter"	"GGOEGAAX0598"	1
"Taguig"	"Men's Vintage Badge Tee Black"	"GGOEGAAX0338"	1
"Taguig"	"Men's Watershed Full Zip Hoodie Grey"	"GGOEGAAX0568"	1
"Taguig"	"Metal Texture Roller Pen"	"GGOEGOAB021499"	1
"Taguig"	"RFID Journal"	"GGOEYOCR077399"	1
"Tampa"	"Android Wool Heather Cap Heather/Black"	"GGOEAHPA004110"	1
"Tel Aviv-Yafo"	"22 oz  Bottle Infuser"	"GGOEYDHJ056099"	2
"Tel Aviv-Yafo"	"Android 17oz Stainless Steel Sport Bottle"	"GGOEADHH073999"	2
"Tel Aviv-Yafo"	"Hard Cover Journal"	"GGOEYOCR077799"	2
"Tempe"	"Android Men's Engineer Short Sleeve Tee Charcoal"	"GGOEAXXX0808"	1
"Tempe"	"Car Clip Phone Holder"	"GGOEGCBB074199"	1
"Tempe"	"Snapback Hat Black"	"GGOEGHPB003410"	1
"Tempe"	"Windup Android"	"GGOEAKDH019899"	1
"The Dalles"	"Laptop and Cell Phone Stickers"	"GGOEGFKQ020399"	1
"The Dalles"	"Men's Long Sleeve Pullover Badge Tee Heather"	"GGOEGAAX0335"	1
"Thessaloniki"	"Bib Red"	"GGOEGKWR060810"	1
"Thessaloniki"	"Red Spiral  Notebook"	"GGOEGOCT019199"	1
"Timisoara"	"Android BTTF Cosmos Graphic Tee"	"GGOEGAAX0348"	1
"Timisoara"	"Micro Wireless Earbud"	"GGOEGEVA022399"	1
"Timisoara"	"Screen Cleaning Cloth"	"GGOEGOFH020299"	1
"University Park"	"Waterproof Backpack"	"GGOEGBRA037499"	1
"Vancouver"	"Device Stand"	"GGOEGCBC074299"	1
"Vancouver"	"Hard Cover Journal"	"GGOEYOCR077799"	1
"Vancouver"	"Laptop Backpack"	"GGOEGBRB013899"	1
"Vancouver"	"Men's Short Sleeve Hero Tee Black"	"GGOEGAAX0318"	1
"Vancouver"	"Micro Wireless Earbud"	"GGOEGEVA022399"	1
"Vancouver"	"Women's Fleece Hoodie"	"9182581"	1
"Vienna"	"Android Wool Heather Cap Heather/Black"	"GGOEAHPA004110"	1
"Vienna"	"Men's 100% Cotton Short Sleeve Hero Tee Red"	"GGOEGAAX0107"	1
"Vienna"	"Men's 100% Cotton Short Sleeve Hero Tee White"	"GGOEGAAX0104"	1
"Vienna"	"Men's  Zip Hoodie"	"GGOEGAAX0358"	1
"Villeneuve-d'Ascq"	"Snapback Hat Black"	"GGOEGHPB003410"	1
"Vilnius"	"Men's 100% Cotton Short Sleeve Hero Tee Red"	"GGOEGAAX0107"	1
"Vladivostok"	"Canvas Tote Natural/Navy"	"GGOEGBJL013999"	1
"Warsaw"	"Keyboard DOT Sticker"	"GGOEGFKA022299"	2
"Warsaw"	"Laptop and Cell Phone Stickers"	"GGOEGFKQ020399"	2
"Washington"	"G Noise-reducing Bluetooth Headphones"	"GGOEGEVB070599"	2
"Washington"	"Insulated Stainless Steel Bottle"	"GGOEGDHB072099"	2
"Washington"	"Laptop Backpack"	"GGOEGBRB013899"	2
"Washington"	"Men's 100% Cotton Short Sleeve Hero Tee Navy"	"GGOEGAAX0106"	2
"Washington"	"Men's 100% Cotton Short Sleeve Hero Tee White"	"GGOEGAAX0104"	2
"Waterloo"	"Men's Long Sleeve Raglan Ocean Blue"	"GGOEGAAX0331"	1
"Watford"	"Luggage Tag"	"GGOEYOBR078599"	1
"Wellesley"	"Colored Pencil Set"	"GGOEGOBG023599"	1
"Westlake Village"	"Men's Long Sleeve Raglan Ocean Blue"	"9180905"	1
"Westville"	"Sport Bag"	"GGOEGBMJ013399"	1
"Wrexham"	"Laptop and Cell Phone Stickers"	"GGOEGFKQ020399"	1
"Yokohama"	"Men's Pullover Hoodie Grey"	"GGOEGAAX0362"	2
"Zagreb"	"Men's Watershed Full Zip Hoodie Grey"	"GGOEGAAX0568"	2
"Zhongli District"	"Men's 100% Cotton Short Sleeve Hero Tee White"	"GGOEGAAX0104"	2
"Zurich"	"Men's Vintage Badge Tee Black"	"GGOEGAAX0338"	2
"Zurich"	"Sport Bag"	"GGOEGBMJ013399"	2
```

These results are too long, we need a better more reliable way to define TOP-SELLING products by city/country!


## **Question 5: Can we summarize the impact of revenue generated from each city/country?**

How is "revenue generated" defined?  We only know the price of an item and how many sessions that item was ordered in all_sessions. 
We do not know the quantity by city/country so this question can not be answered with the data provided.
Can we summarize the impact of revenue generated from each city/countr ? NO.

The only 'revenue' field is in the analytics table and this is mostly empty.

** SQL Queries:
N/A
```
-- check mismatched VISITid's between all_sessions and analytics for question 5.
SELECT als.visitID AS sessions_VisitID, ay.visitID AS analytics_VisitID
FROM all_sessions AS als
LEFT JOIN analytics AS ay ON als.visitID = ay.visitID
WHERE ay.visitID IS NULL OR als.visitID IS NULL OR ay.visitID <> als.visitID;
-- Returns 11,375 rows
-- So there are 11,375 visitID sessions in all_sessions that are missing in the analytics.
```

** Answer:
N/A
Lack of data for revenue highlighted with:
```
SELECT 
    VisitID, 
    COUNT(*) AS Count
FROM 
    analytics 
WHERE 
    Revenue = 0 or revenue is null
GROUP BY 
    VisitID, Revenue;
-- Returns 148,642 = 100% of the unique VisitID's and there are duplicates, so which do we use?
```






