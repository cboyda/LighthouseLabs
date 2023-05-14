# Part 3: Starting with Questions
## startingwithquestions.md file
<details>
<summary>from Project-SQL/assignment.md</summary>

This database provides data on revenue by product as well as data on how each visitor to the site interacted with the products (when they visited, where they were based, how many pages they viewed, how long they stayed on the site, and the number of transactions they entered).

In the starting_with_questions.md file there are 5 questions you need to answer using the data. For each question, be sure to include: The queries you used to answer the question The answer to the question
</details>

<details>
<summary>from Project-SQL/instructional_guidelines.md</summary>

Provide the answer to the 5 questions and the queries used to answer each question

Answer the following questions and provide the SQL queries used to find the answer.
</details>
    
## **Question 1: Which cities and countries have the highest level of transaction revenues on the site?**

"Transaction revenues" undefined, assuming it is the SUM of all_sessions.productPrice field.

SQL Queries:

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


Answer:
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

Answer:
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


SQL Queries:
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

Answer:
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

Answer:
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

SQL Queries:
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

ANSWER:
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

SQL Queries:

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

Answer:
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


SQL Queries:



Answer:





## **Question 5: Can we summarize the impact of revenue generated from each city/country?**

SQL Queries:



Answer:







