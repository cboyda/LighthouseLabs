# Project Tableau Presentation

## Project/Goals
Review provided datasets in [Tableau](https://github.com/cboyda/LighthouseLabs/blob/main/Project-Tableau/.~Tableau_Project__63037.twbr) to demonstrate proficiency and insights from this data.

## Process
### (your step 1)
### (your step 2)
Datasets used included:
* Weekly earnings from 1.1.2001 to 15.4.2015 (weekly_earnings - CSV)
* Housing constructions from 1955 to 2019 (real_estate_numbers - CSV) with housing starts/completions and geographical regions
* House prices from 1.1.2005 to 1.9.2020 (real_estate_prices - EXCEL)
* Housing_price_index from November 1979 to September 2020
* Office_realestate_index from November 1979 to September 2020
* Consumer index from November 1979 to September 2020

## Results
> Option 1 Selected for Standard Final Project

1. Show the trend of house prices across Canada in the last 40 years (table housing_price_index). ![chart1](https://raw.githubusercontent.com/cboyda/LighthouseLabs/main/Project-Tableau/images/1-house-prices-last-40years.png)
2. Compare the trend after 2005 with actual benchmark prices in table real_estate_prices to see if there are any differences.![chart2](https://raw.githubusercontent.com/cboyda/LighthouseLabs/main/Project-Tableau/images/2-house-prices-since-2005-vs-benchmark.png)
3. Compare this trend with the trend of office prices. ![chart3](https://raw.githubusercontent.com/cboyda/LighthouseLabs/main/Project-Tableau/images/3-house-prices-since-2005-vs-benchmark-vs-office.png) <br>
This is too complicated to compare easily.  <br>We have 3 graphs with different scales, so by using dual axies and synchronizing the scales we get:<br>
![merged prices](https://raw.githubusercontent.com/cboyda/LighthouseLabs/main/Project-Tableau/images/3-housing-vs-office.png)<br>
Notice that in the first chart our housing prices go to 2021 but once we compare with office prices their data only goes to 2017 so much of the trend is cropped off.
  Which one is getting more expensive, faster? OFFICE SPACE is observed with a larger slope/increase vs housing prices.
4. Create a heatmap of Canada with current house prices for each available district.
![house price heatmap](https://raw.githubusercontent.com/cboyda/LighthouseLabs/main/Project-Tableau/images/4-heatmap-house-prices-by-district.png)
5. Are the price differences between different districts increasing?
Variance: is another measure of the dispersion of prices over the districts. It is the squared value of the standard deviation. Variance provides an understanding of the overall variability of prices and can be useful for comparing the spread between districts.  
![district differences](https://raw.githubusercontent.com/cboyda/LighthouseLabs/main/Project-Tableau/images/5-noisey-districts.png)
<br>In this chart we aggregate results to reduce noise.
![aggregated variance](https://raw.githubusercontent.com/cboyda/LighthouseLabs/main/Project-Tableau/images/5-aggregated_districts.png)
6. Compare the trend of house prices with earnings. *In case you want to plot monthly salary, be aware that the earnings value is per week.
7. Did people spend more of their earnings in 2014 than they did in 2001?
8. There were several economic crises in the world in the last 40 years, including these four: Black Monday (1987), Recession (early 1990s), dot com bubble (2000 - 2002), Financial crisis (2007 - 2009). Show the effect of these crises on:
   * Earnings
   * House prices
   *  Office prices
   *  House constructions
   *  Consumer index
9. Plot consumer_index together with housing_price_index and fit the regression line between them. Can we predict consumer_index from the housing_price_index?
10. Try to find an interesting pattern, trend, outlier, etc. from the data used in the above questions.
    HINT : Double check all units in the table before any comparison.


## Challenges 
> Discuss challenges you faced in the project.

X greatested challenge was trying to understand the overall goal of the question, without clarifying questions or a sample output this is just a guess.
Normally I would assume the need to explore the data and find relationships of interest.

## Future Goals
(what would you do if you had more time?)
