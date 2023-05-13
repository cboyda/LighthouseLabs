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
TOP 10 CITIES
```
SELECT 
    city, 
    SUM(productPrice), 
    currencyCode 
FROM 
    all_sessions 
WHERE 
    city IS NOT NULL 
GROUP BY 
    city, 
    currencyCode 
ORDER BY 
    SUM DESC 
LIMIT 10;
```


Answer:
TOP 10 CITIES
```
"city"	        "sum"	    "currencycode"
"Mountain View"	44995560000	"USD"
"New York"	    19234200000	"USD"
"San Francisco"	15411110000	"USD"
"Sunnyvale"	    13340860000	"USD"
"San Jose"	    7631500000	"USD"
"Los Angeles"	6294240000	"USD"
"Chicago"	    5990020000	"USD"
"London"	    5731810000	"USD"
"Palo Alto"	    5270600000	"USD"
"Seattle"	    4252950000	"USD"
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







