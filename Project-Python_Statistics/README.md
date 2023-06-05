# Final-Project-Statistical-Modelling-with-Python

## Project/Goals
Pull data from 3 API's, merge them then model them to look for any statistical relationships to [demonstrate Python Statistical assignment](https://github.com/cboyda/LighthouseLabs/blob/main/Project-Python_Statistics/assignment.md).


## Process
### Step 1: CityBikes API
* Grab live data from CityBikes API
* specifically generated a list of ebike `stations` in Vancouver, BC, Canada
* Google Colab Python code in notebook [city_bikes.ipyb](https://github.com/cboyda/LighthouseLabs/blob/main/Project-Python_Statistics/notebooks/city_bikes.ipynb)
 * results format stored in `station_name, city, empty_slots, slots, free_bikes, lat/long, timestamp`

| ![all stations](https://github.com/cboyda/LighthouseLabs/blob/main/Project-Python_Statistics/images/map_all_vancouver_stations.png) | 
|:--:| 
| *All ebike Stations in Vancouver as of June 3, 2023* |


### Step 2: FourSquare and YELP API's
* Pull Points of Interest (POI's) near each of the `stations` 
* specificaly looked with 1000m for "PARKS"
* Google Colab Python code in notebook [yelp_foursquare_EDA.ipynb](https://github.com/cboyda/LighthouseLabs/blob/main/Project-Python_Statistics/notebooks/yelp_foursquare_EDA.ipynb)
 * merged column from FourSquare of `location_count` (for nearby POI's)
 * merged columns from YELP of `yelp_location_count` and `yelp_review_count` for total reviews of those POI's


### Step 3: Joining: Merge then Store Data in SQLite
* Now that we had review_counts and number of "parks" nearby each of our `stations`, merged all results

| ![merged dataframe](https://raw.githubusercontent.com/cboyda/LighthouseLabs/main/Project-Python_Statistics/images/merged_dataframe.png) | 
|:--:| 
| *Final Merged DataFrame* |

* Google Colab Python code in notebook [joining_data.ipynb](https://github.com/cboyda/LighthouseLabs/blob/main/Project-Python_Statistics/notebooks/joining_data.ipynb)
* stored results in [CSV format (3x20KB)](https://github.com/cboyda/LighthouseLabs/tree/main/Project-Python_Statistics/data) for quick reference
* exported results in [SQLite database format (15MB)](https://github.com/cboyda/LighthouseLabs/blob/main/Project-Python_Statistics/data/city_bikes_sqlite_database.db) created from Python
  * counts verified to ensure no dataframe information was missed
  * utilized Python networkx and matplotlib for database relationship illustrations:

| ![table relationships](https://raw.githubusercontent.com/cboyda/LighthouseLabs/main/Project-Python_Statistics/images/sqlite_db_table_relationship.png) | 
|:--:| 
| *Database Tables Simplified Relationships* |
|:--:| 
| ![database schema](https://raw.githubusercontent.com/cboyda/LighthouseLabs/main/Project-Python_Statistics/images/sqlite_db_schema_diagram.png) | 
|:--:| 
| *SQLite Database Schema* |


### Step 4: Build Statistical Model
* models created to predict the number of ebikes at a given `station`
* Built Statistical Regression Models
* Built Classification Regression Models

## Results

> (fill in what you found about the comparative quality of API coverage in your chosen area and the results of your model.)

### Insights
* if popularity is defined as # of reviews for the nearby PARKS, the top 10 `stations` could be illustrated as

| ![popular stations](https://raw.githubusercontent.com/cboyda/LighthouseLabs/main/Project-Python_Statistics/images/map_highest_park_reviews_nearby_stations.png) | 
|:--:| 
| *Top 10 ebike Stations near the highest reviewed PARKS in Vancouver as of June 3, 2023* |

### Quality of APIs
* Number of Yelp POI results > FourSquare which may simply because of the category selected of "PARKS"
 * 74.38% of FourSquare rows have no locations found nearby vs 0% for Yelp

### Questions Unanswered?
### Exploraty Data Analysis (EDA)
* during EDA, various visualization techniques were applied to explore the data and extract meaningful information
* Google Colab Python code in notebook [joining_data.ipynb](https://github.com/cboyda/LighthouseLabs/blob/main/Project-Python_Statistics/notebooks/joining_data.ipynb)


| ![histograms](https://raw.githubusercontent.com/cboyda/LighthouseLabs/main/Project-Python_Statistics/images/histograms.png) | 
|:--:|
| *Feature Histograms by Distribution* |


| ![correlation matrix](https://raw.githubusercontent.com/cboyda/LighthouseLabs/main/Project-Python_Statistics/images/correlation_matrix.png) | 

|:--:|

| *Correlation Matrix* |

### Model Results
#### Regresssion Statistical Models
* Ordinary Least Squares (OLS)

![ols model](https://raw.githubusercontent.com/cboyda/LighthouseLabs/main/Project-Python_Statistics/images/regression_ols_model.png)

* Linear Regresion (with OLS)

![linear regression](https://raw.githubusercontent.com/cboyda/LighthouseLabs/main/Project-Python_Statistics/images/regression_ols_linear_model.png)

* Generalized Linear Model (GLM)

![glm model](https://raw.githubusercontent.com/cboyda/LighthouseLabs/main/Project-Python_Statistics/images/regression_glm_model.png)

All models fit the data poorly with R2 of OLS 17%, Linear Regresssion 27.5% and GLM 20.9% (Psudo R-squared = CS).

#### Classification Statistical Models
* Logistical Regression

![classification model](https://raw.githubusercontent.com/cboyda/LighthouseLabs/main/Project-Python_Statistics/images/classification_logistical_regression.png)

These features do not show statistical significance in predicting ebikes.

### Model Predictions

## Challenges 
1. Poor API documentation, would have preferred to find/use these interactive api testing webpages earlier!
 * [YELP Web API testing page](https://docs.developer.yelp.com/reference/v3_business_search)
 * [FourSquare Web API testing page](https://location.foursquare.com/developer/reference/place-search)
2. Assignment needs more clarification for better statiscally significant results. 
 * Some questions asked weren't possible based on recommended steps.

## Future Goals

> (what would you do if you had more time?)

* gather better information to better predict # of ebikes available
* better document functions and my code for future reference and reusability
* rewrite API calls to include actual review scores
* rewrite code to allow for easier modification/reusability of universal results including making the call/model formation for
  * any city
  * other predictions including `free_bikes` `slots_avialable`
  * any POI category
