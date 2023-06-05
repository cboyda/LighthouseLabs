# Project: Statistical Modelling with Python
by Clinton Boyda

## Project/Goals
Pull data from 3 API's, merge them then model them to look for any statistical relationships to [demonstrate Python Statistical assignment](https://github.com/cboyda/LighthouseLabs/blob/main/Project-Python_Statistics/assignment.md).


## Process
### Step 1: CityBikes API
* Grab live data from [CityBikes API](http://api.citybik.es/v2/)
* specifically generated a list of ebike `stations` in Vancouver, BC, Canada (242 stations found)
* Google Colab Python code in notebook [city_bikes.ipyb](https://github.com/cboyda/LighthouseLabs/blob/main/Project-Python_Statistics/notebooks/city_bikes.ipynb)

| ![all stations](https://github.com/cboyda/LighthouseLabs/blob/main/Project-Python_Statistics/images/map_all_vancouver_stations.png) | 
|:--:| 
| *All ebike Stations in Vancouver as of June 3, 2023* |


### Step 2: FourSquare and YELP API's
* used API's to find Points of Interest (POI's) near each of the `stations` 
   * specifically looked within 1000m for "PARKS" with the assumption that park users may use e-bikes
* Google Colab Python code in notebook [yelp_foursquare_EDA.ipynb](https://github.com/cboyda/LighthouseLabs/blob/main/Project-Python_Statistics/notebooks/yelp_foursquare_EDA.ipynb)
   * merged column from FourSquare of `location_count` (for nearby POI's)
   * merged columns from YELP of `yelp_location_count` and `yelp_review_count` for total reviews of those POI's


### Step 3: Joining: Merge then Store Data in SQLite
* merged POI counts, review_counts and number of "parks" nearby for each of our `stations`
   * we could have predicted `empty_slots, slots, free_bikes or ebikes`

| ![merged dataframe](https://raw.githubusercontent.com/cboyda/LighthouseLabs/main/Project-Python_Statistics/images/merged_dataframe.png) | 
|:--:| 
| *Final Merged DataFrame* |

* Google Colab Python code in notebook [joining_data.ipynb](https://github.com/cboyda/LighthouseLabs/blob/main/Project-Python_Statistics/notebooks/joining_data.ipynb)
* stored results in [CSV format (4x20KB)](https://github.com/cboyda/LighthouseLabs/tree/main/Project-Python_Statistics/data) for quick reference
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
* models created to predict the number of `ebikes`
* built 3 Statistical Regression Models including:
   * Ordinary Least Squares (OLS)
   * Linear Regression with 8 models using list method
   * Generalized Linear Model (GLM)
* built Classification Regression Model
   * Logistic Regression

<details>
  <summary>Statistical Model Details... [click to view]</summary>
  
#### Regression Statistical Models
* Ordinary Least Squares (OLS)

![ols model](https://raw.githubusercontent.com/cboyda/LighthouseLabs/main/Project-Python_Statistics/images/regression_ols_model.png)

* Linear Regresion (with OLS)

![linear regression](https://raw.githubusercontent.com/cboyda/LighthouseLabs/main/Project-Python_Statistics/images/regression_ols_linear_model.png)

* Generalized Linear Model (GLM)

![glm model](https://raw.githubusercontent.com/cboyda/LighthouseLabs/main/Project-Python_Statistics/images/regression_glm_model.png)


#### Classification Statistical Models
* Logistical Regression

![classification model](https://raw.githubusercontent.com/cboyda/LighthouseLabs/main/Project-Python_Statistics/images/classification_logistical_regression.png)

</details>

<br/>
<br/>
<br/>


# Results
> Fill in what you found about the comparative quality of API coverage in your chosen area and the results of your model.

### a) Quality of APIs
* Number of Yelp POI results > FourSquare which may be because of the category selected of "PARKS"
   * 74.38% of FourSquare rows have no locations found nearby vs 0% for Yelp

### b) Exploraty Data Analysis (EDA)
* during EDA, various visualization techniques were applied to explore the data and extract meaningful information
* Google Colab Python code in notebook [joining_data.ipynb](https://github.com/cboyda/LighthouseLabs/blob/main/Project-Python_Statistics/notebooks/joining_data.ipynb)


| ![histograms](https://raw.githubusercontent.com/cboyda/LighthouseLabs/main/Project-Python_Statistics/images/histograms.png) | 
|:---:|
| **Feature Histograms by Distribution** |


| ![correlation matrix](https://raw.githubusercontent.com/cboyda/LighthouseLabs/main/Project-Python_Statistics/images/correlation_matrix.png) | 
|:---:|
| **Correlation Matrix** |

### c) Model Comparison

| Model                                | Model Fit: R-squared (%) | Model Prediction R-squared (%) |
|--------------------------------------|-------------------------|--------------------------------|
| OLS Regression                       | 17.00                   | 19.56                          |
| Linear Regression                    | **43.40**                   | 3.62                           |
| GLM Regression                       | 20.90                   | 19.56                          |
| Logistic Regression (Classification) |  6.00                   | **31.82**                         |
| Baseline (mean of ebikes)            | -                       | 23.97                          |

> If a model's fit R-squared value is high but the prediction accuracy is low, it suggests that the model is fitting the training data well but is not generalizing well to new, unseen data. 

### d) Insights
* if popularity is defined as # of reviews for the nearby PARKS, the top 10 `stations` could be illustrated as

| ![popular stations](https://raw.githubusercontent.com/cboyda/LighthouseLabs/main/Project-Python_Statistics/images/map_highest_park_reviews_nearby_stations.png) | 
|:--:| 
| *Top 10 ebike Stations near the highest reviewed PARKS in Vancouver as of June 3, 2023* |

<br/>
<br/>

### Step 5: Build Data Visualizations
* Google Colab Python code in notebook [visualizations.ipynb](https://github.com/cboyda/LighthouseLabs/blob/main/Project-Python_Statistics/notebooks/visualizations.ipynb)
* created visualization to show free_bikes by neighbourhood
   * neighbourhood shape files from [City of Vancouver Open Data Portal](https://opendata.vancouver.ca/explore/dataset/local-area-boundary/export/?disjunctive.name)

### Where are the free_bikes in Vancouver? 

| [![sunburst neighbourhoods](https://raw.githubusercontent.com/cboyda/LighthouseLabs/main/Project-Python_Statistics/images/sunburst_by_neighbourhood.png)](https://htmlpreview.github.io/?https://raw.githubusercontent.com/cboyda/LighthouseLabs/main/Project-Python_Statistics/data/sunburst_chart.html) | 
|:--:| 
| *[Interactive Sunburst breakdown](https://htmlpreview.github.io/?https://raw.githubusercontent.com/cboyda/LighthouseLabs/main/Project-Python_Statistics/data/sunburst_chart.html) of Free Bike Availability by Neighbourhood in Vancouver as of June 3, 2023* |

### Which stations have free_bikes and where are they located?

| ![station heatmap](https://raw.githubusercontent.com/cboyda/LighthouseLabs/main/Project-Python_Statistics/images/heatmap-station-free_bikes.png) | 
|:--:| 
| *Free Bike Availability by Station in Vancouver as of June 3, 2023* |

### Which neighbourhoods have free_bikes?

| ![neighbourhood heatmap](https://raw.githubusercontent.com/cboyda/LighthouseLabs/main/Project-Python_Statistics/images/heatmap-neighbourhood-free_bikes.png) | 
|:--:| 
| *Free Bike Availability by Neighbourhood in Vancouver as of June 3, 2023* |

### Top 5 neighbourhood availability of free_bikes?

| ![neighbourhood violins](https://raw.githubusercontent.com/cboyda/LighthouseLabs/main/Project-Python_Statistics/images/violinplot-top5-neighbourhoods.png) | 
|:--:| 
| *Free Bike Availability in Top 5 Neighbourhoods in Vancouver as of June 3, 2023* |

<details>
  <summary>What does a violin plot visualization represent?</summary>
  
In a violin plot, the box-and-whisker elements represent the statistical summary of the data distribution for each category or group.
  
* **Violin shape**: The shape of the violin represents the data distribution. It is symmetrical along the central line, which represents the median of the data. The width of the violin at a specific point indicates the density or frequency of data points in that region. A wider section indicates a higher concentration of data points, while a narrower section indicates a lower concentration.

* **White dot**: The white dot within the violin represents the median of the data. It is a measure of central tendency and indicates the middle value of the dataset when sorted.

* **Box**: The box inside the violin represents the interquartile range (IQR) of the data. It spans from the first quartile (25th percentile) to the third quartile (75th percentile) of the dataset. The height of the box indicates the spread of the middle 50% of the data.

* **Whiskers**: The whiskers extend from the box and represent the range of the data excluding outliers. By default, they extend up to 1.5 times the IQR. Data points beyond the whiskers are considered outliers and plotted individually.

* **Outliers**: Individual data points that fall beyond the whiskers are plotted as individual points, helping to identify potential anomalies or extreme values in the data.

> The violin plot combines aspects of a box plot and a kernel density plot, providing a visual representation of both the distribution and summary statistics of the data. It allows for easy comparison of distributions between different categories or groups in a single plot.
</details>

## Challenges 
✗ Poor API documentation, would have preferred to find/use these interactive api testing webpages earlier!
   * [CityBikes API](http://api.citybik.es/v2/) could benefit from clear definitions of each key slots vs free slots etc.
   * [YELP Web API testing page](https://docs.developer.yelp.com/reference/v3_business_search)
   * [FourSquare Web API testing page](https://location.foursquare.com/developer/reference/place-search)

✗ Assignment needs more clarification for better statiscally significant results. 
   * Some questions asked weren't possible based on recommended steps.
   * Merging of API data was unclear, decided to aggregate values from points of interest.

## Future Goals

> What would you do if you had more time?

✓ gather better information to better predict # of ebikes available

✓ consider method to gather data over time to find trends

✓ better document functions and my code for future reference and reusability

✓ rewrite API calls to include actual review scores

✓ rewrite code to allow for easier modification/reusability of universal results including making the call/model formation for
   * any city
   * other predictions including `free_bikes` `slots_avialable`
   * any POI category
