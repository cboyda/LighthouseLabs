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

Question 1: Find the total number of duplicate visitors (`fullVisitorID`)

SQL Queries:
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

Answer: Provided in comments after each query above, not enough space for 120k rows.



Question 2: 

SQL Queries:

Answer:



Question 3: 

SQL Queries:

Answer:



Question 4: 

SQL Queries:

Answer:



Question 5: 

SQL Queries:

Answer:
