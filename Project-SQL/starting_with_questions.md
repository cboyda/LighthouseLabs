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
    
**Question 1: Which cities and countries have the highest level of transaction revenues on the site?**


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
```
"city"	            "sum_in_millions"	"currencycode"
"Mountain View"	    "$44,995.56"	    "USD"
"New York"	        "$19,234.20"	    "USD"
"San Francisco"	    "$15,411.11"	    "USD"
"Sunnyvale"	        "$13,340.86"	    "USD"
"San Jose"	        "$7,631.50"	        "USD"
"Los Angeles"	    "$6,294.24"	        "USD"
"Chicago"	        "$5,990.02"	        "USD"
"London"	        "$5,731.81"	        "USD"
"Palo Alto"	        "$5,270.60"	        "USD"
"Seattle"	        "$4,252.95"	        "USD"
```

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
```
"country"	        "sum_in_millions"	"currencycode"
"United States"	    "$153,591.79"	    "USD"
"India"	            "$8,837.61"	        "USD"
"United States"	    "$7,474.36"	        "USD"
"United Kingdom"	"$5,963.74"	        "USD"
"Canada"	        "$5,159.26"	        "USD"
"Australia"	        "$3,599.59"	        "USD"
"Japan"	            "$1,822.15"	        "USD"
"France"	        "$1,699.01"	        "USD"
"Ireland"	        "$1,478.51"	        "USD"
"Hong Kong"	        "$1,434.01"	        "USD"
```



**Question 2: What is the average number of products ordered from visitors in each city and country?**


SQL Queries:



Answer:





**Question 3: Is there any pattern in the types (product categories) of products ordered from visitors in each city and country?**


SQL Queries:



Answer:





**Question 4: What is the top-selling product from each city/country? Can we find any pattern worthy of noting in the products sold?**


SQL Queries:



Answer:





**Question 5: Can we summarize the impact of revenue generated from each city/country?**

SQL Queries:



Answer:







