# Country Population

This is the assignment 3 of STAT545B and developed by Berke Ucar. 

*CountryPopulation* is a `shinyr` app that shows the population of countries over the period 1800 to 2100. 1800-2015 band of this period is the historical population counts, while 2015-2100 period is projected. The way of representation of this data is a histogram and a data table. This application has the following major properties:

1. Users can select multiple countries to represent the populations on the graph and the table.
2. Users can transform the population counts into the logarithmic scale.
3. Users can select to include the projections or not.
4. Users can interact with data table. The table is presented according to the country preference as well. 
  * Pagination
  * Sorting based on different columns
  * Searching on the table

The link to the application: *https://berkeucar.shinyapps.io/CountryPopulation/*

This application uses the dataset contains the countries' historical and projected populations subsampled from Gapminder Version 5. Gapminder uses UN Population Revision. Further details can be accessed from the [link](https://github.com/owid/owid-datasets/tree/master/datasets/Population%20by%20country%2C%201800%20to%202100%20(Gapminder%20%26%20UN)).

### Dataset reference:
Mathieu E., et al. “Population by Country, 1800 to 2100 (Gapminder & UN).” _GitHub_, github.com/owid/owid-datasets/tree/master/datasets/Population%20by%20country%2C%201800%20to%202100%20(Gapminder%20%26%20UN). Accessed 22 Nov. 2023. 