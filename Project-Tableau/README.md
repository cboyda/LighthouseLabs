<style>
img {
    width: 75%; }
</style>   
# Project Tableau Presentation

## Project/Goals
Review provided datasets in Tableau [.twbx](https://github.com/cboyda/LighthouseLabs/raw/main/Project-Tableau/Tableau_Project.twbx) or [.twb](https://github.com/cboyda/LighthouseLabs/blob/main/Project-Tableau/Tableau_Project.twb) to demonstrate proficiency and insights from this data.

## Process
### Key
The key to this dataset was making sure the data was filtered to only include there relevant categories.<br>
Datasets used included:
* Weekly earnings from 1.1.2001 to 15.4.2015 (weekly_earnings - CSV)
* Housing constructions from 1955 to 2019 (real_estate_numbers - CSV) with housing starts/completions and geographical regions
* House prices from 1.1.2005 to 1.9.2020 (real_estate_prices - EXCEL)
* Housing_price_index from November 1979 to September 2020
* Office_realestate_index from November 1979 to September 2020
* Consumer index from November 1979 to September 2020

Utilized [Python Google Colab](https://github.com/cboyda/LighthouseLabs/blob/main/Project-Tableau/data/Tableau_Weekly_Earnings_JSON_Parse.ipynb) to parse the JSON file and create a cleaner csv for Tableau to visualize.

## Results
> Option 1 Selected for Standard Final Project

Entire results are available in a [PDF](https://github.com/cboyda/LighthouseLabs/blob/main/Project-Tableau/Tableau-Project.pdf), or as a [Power Point Presentation](https://github.com/cboyda/LighthouseLabs/raw/main/Project-Tableau/Presentation%20Canadian%20Housing.pptx), or [Presentation Summary in PDF format](https://github.com/cboyda/LighthouseLabs/blob/main/Project-Tableau/Presentation%20Canadian%20Housing.pdf).

1. Show the trend of house prices across Canada in the last 40 years (table housing_price_index). 
<img src="https://raw.githubusercontent.com/cboyda/LighthouseLabs/main/Project-Tableau/images/1-house-prices-last-40years-CPI.png" width="200px">
<br>
Note: This is using the measure: Consumer Price Index (CPI) which excludes indirect taxes, seasonally adjusted.
2. Compare the trend after 2005 with actual benchmark prices in table real_estate_prices to see if there are any differences.![chart2](https://github.com/cboyda/LighthouseLabs/blob/main/Project-Tableau/images/2-house-prices-2005-vs-benchmarkc.png)
3. Compare this trend with the trend of office prices. <br>
![merged prices](https://raw.githubusercontent.com/cboyda/LighthouseLabs/main/Project-Tableau/images/3-housing-vs-officec.png)<br>
Notice that in the first chart our housing prices go to 2021 but once we compare with office prices their data only goes to 2017 so much of the trend is cropped off.<br>
   Which one is getting more expensive, faster? OFFICE SPACE is observed with a larger slope/increase vs housing prices.
4. Create a heatmap of Canada with current house prices for each available district.<br>
Latest time available was Sept 2020, with the size of the composite benchmark relating the size of each district.<br>
![house price heatmap](https://raw.githubusercontent.com/cboyda/LighthouseLabs/main/Project-Tableau/images/4-heatmap-house-prices-by-districtb.png)
5. Are the price differences between different districts increasing?
Variance: is another measure of the dispersion of prices over the districts. It is the squared value of the standard deviation. Variance provides an understanding of the overall variability of prices and can be useful for comparing the spread between districts.  
![district differences](https://raw.githubusercontent.com/cboyda/LighthouseLabs/main/Project-Tableau/images/5-noisey-districts.png)
<br>In this chart we aggregate results to reduce noise.
![aggregated variance](https://raw.githubusercontent.com/cboyda/LighthouseLabs/main/Project-Tableau/images/5-aggregated_annual_districts.png)
6. Compare the trend of house prices with earnings. *In case you want to plot monthly salary, be aware that the earnings value is per week.<br>
![earnings vs housing](https://raw.githubusercontent.com/cboyda/LighthouseLabs/main/Project-Tableau/images/6-housing-vs-earnings.png)
<br> While this visualization shows the general slope over time there is a mismatch in scales that causes tremendous white space below.  Given more time we could work to standardize these values to better "fill" our chart space.<br> An interesting thing to note is that the housing price has been filled above/below the trend line which really mimics the increases/decreases of the wages over time.<br>
![percent difference](https://raw.githubusercontent.com/cboyda/LighthouseLabs/main/Project-Tableau/images/6-overlay-percent-difference-housing-vs-earnings.png)
<br>By calculating the percentage difference we are able to place these trends over top of eachother (on the same axis) and see there is a often a correlation between these values.<br>Let's check the correlation between earnings and housing prices:<br>
![correlations](https://raw.githubusercontent.com/cboyda/LighthouseLabs/main/Project-Tableau/images/6-annual-correlation-between-housing-earning.png)
7. Did people spend more of their earnings in 2014 than they did in 2001?
No expenses were provided, but we can compare earnings for 2014 vs 2001.<br>
![compare earnings](https://raw.githubusercontent.com/cboyda/LighthouseLabs/main/Project-Tableau/images/7-compare-earnings-values.png)
8. There were several economic crises in the world in the last 40 years, including these four: Black Monday (1987), Recession (early 1990s), dot com bubble (2000 - 2002), Financial crisis (2007 - 2009). 
<details>
  <summary>Show the effect of these crises on:</summary>
  
   * a) Earnings
![earnings](https://raw.githubusercontent.com/cboyda/LighthouseLabs/main/Project-Tableau/images/8a-earnings-province-economic-crisis.png)
   * b) House prices
![housing prices](https://raw.githubusercontent.com/cboyda/LighthouseLabs/main/Project-Tableau/images/8b-housing-economic-crisis.png)
   * c) Office prices
![office prices](https://raw.githubusercontent.com/cboyda/LighthouseLabs/main/Project-Tableau/images/8c-office-economic-crisis.png)
   * d) House constructions
![housing construction](https://raw.githubusercontent.com/cboyda/LighthouseLabs/main/Project-Tableau/images/8d-construction-economic-crisis.png)
   * e) Consumer index
![cpi](https://github.com/cboyda/LighthouseLabs/blob/main/Project-Tableau/images/8e-cpi-economic-crisis.png)
  
</details>
9. Plot consumer_index together with housing_price_index and fit the regression line between them. Can we predict consumer_index from the housing_price_index?
Using the CPIW index value, and limiting only to percentages we can easily compare consumer vs housing price indexes.<br>

![index comparison](https://raw.githubusercontent.com/cboyda/LighthouseLabs/main/Project-Tableau/images/9-index-comparisonb.png)
<br>These follow eachother so closely, even the linear regression line can be seen to accurately predict housing price from the consumer index.<br>

![index regression](https://raw.githubusercontent.com/cboyda/LighthouseLabs/main/Project-Tableau/images/9-regression-index.png)<br>

10. Try to find an interesting pattern, trend, outlier, etc. from the data used in the above questions.
    HINT : Double check all units in the table before any comparison.
![construction comparison](https://raw.githubusercontent.com/cboyda/LighthouseLabs/main/Project-Tableau/images/10-construction.png)
Found it interesting that starts and completion differed inconsistenctly over time.<br>
And certainly affected by recessions (1990) and mortgage collapses in our econony (2009).  Notice how the construction completion lags thereafter.<br>
![construction econonmic crisis](https://raw.githubusercontent.com/cboyda/LighthouseLabs/main/Project-Tableau/images/10-CAN-construction-economic-crisis.png)


* recreated earnings data to compare annually to housing, require [Python modifications to original data](https://github.com/cboyda/LighthouseLabs/blob/main/Project-Tableau/data/Modify_Earnings_Annually.ipynb)
<br>Utilizing that reformated data we can now lookg at how much Alberta contributes to Canada in both construction completed and earnings.  
![AB in Canada](https://raw.githubusercontent.com/cboyda/LighthouseLabs/main/Project-Tableau/images/10-AB-Can-construction-earningsb.png)
## Challenges 
> Discuss challenges you faced in the project.

X greatest challenge was trying to understand the overall goal of the question, without clarifying questions or a sample output this is just a guess.  The role of the subject matter expert is key to understanding the data and matching their knowledge with the clients chart visual goals.  

X Many of the datasources tried to merge data.  For example there are multiple CPI indexes, then the units are percentage AND index values.  Without filtering these to match exactly the graphs/charts quickly can become erroneous.

## Future Goals
(what would you do if you had more time?)
* create a much more interactive dashboards/animation/timelines, but ensure collected data shares similar columns to leverage shared filters
* with the data having such limited overlap it made shared universal dashboard controls very unrealistic (loses the perspective of change over time), would be important to choose better data in the future what shared elements/scales
