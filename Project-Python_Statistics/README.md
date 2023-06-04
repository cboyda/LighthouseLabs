# Final-Project-Statistical-Modelling-with-Python

## Project/Goals
Pull data from 3 API's, merge them then model them to look for any statistical relationships to [demonstrate Python Statistical assignment](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet).

## Process
### Step 1: CityBikes API
* Grab live data from CityBikes API
* specifically generated a list of ebike `stations` in Vancouver, BC, Canada
* Python code in notebook [city_bikes.ipyb](https://github.com/cboyda/LighthouseLabs/blob/main/Project-Python_Statistics/notebooks/city_bikes.ipynb)
 * results format stored in `station_name, city, empty_slots, slots, free_bikes, lat/long, timestamp`

| ![all stations](https://github.com/cboyda/LighthouseLabs/blob/main/Project-Python_Statistics/images/map_all_vancouver_stations.png) | 
|:--:| 
| *All ebike Stations in Vancouver as of June 3, 2023* |

### Step 2: FourSquare and YELP API's
* Pull Points of Interest (POI's) near each of the `stations` 
* specificaly looked with 1000m for "parks"
### Step 3: Merge/Store Data in SQLite
* Now that we had review_counts and number of "parks" nearby each of our `stations`, merged all results
* added 
* stored results in CSV format 
* exported results in SQLite format
### Step 4: Build Statistical Model
* models created to predict the number of ebikes at a given `station`
* Built Statistical Regression Models
* Built Classification Regression Models

## Results
(fill in what you found about the comparative quality of API coverage in your chosen area and the results of your model.)
### Insights
### Quality of APIs
### Questions Unanswered?
### EDA
### Model Results
### Model Predictions

## Challenges 
1. Poor API documentation 
2. Assignment needs more clarification for better statiscally significant results.

## Future Goals
(what would you do if you had more time?)
* gather better information to better predict # of ebikes available
* better document functions and my code for future reference and reusability
* rewrite API calls to include actual review scores
* rewrite code to allow for easier modification of universal results including making the call/model formation for
  * any city
  * other predictions including `free_bikes` `slots_avialable`
  * any POI category
