# Small Area Population Estimates

The "small area" is the smallest statistical output unit of the South African National Census of 2011, with the country divided into just under 85,000 small areas.

This repository contains population estimates for the small areas for every year from 2008 to 2022. The calculation of these estimates is fairly naive, based on municipal population estimates, so they won't account for sub-municipal local circumstances. Therefore these estimates won't be useful for all purposes.

## Method of calculation
The calculation is based on the following data sources, contained in the `sources` directory.

* `sal-pop.csv`: recorded population of the small areas according to Census 2011. Obtained from the Census 2011 Community Profiles DVD.
* `sal-muni-link.csv`: each small area coded to the municipality within which it is situated, using the 2016 demarcation of municipalities. Calculated in GIS software from shapefiles.
* `muni-pop-census2011.csv`: recorded population of each municipality, according to Census 2011 but using the 2016 demarcation of municipalities. Downloaded from [StatsSA SuperWEB](http://superweb.statssa.gov.za/webapi).
* `district-projections-2002-2021.csv` and `district-projections-2022-2026.csv`: mid-year estimates of the population of district and metropolitan municipalities. Downloaded from [StatsSA mid-year population estimates](https://www.statssa.gov.za/?page_id=1854&PPN=P0302&SCH=72983).
* `lm-projections.csv`: mid-year estimates of the population of local municipalites. Downloaded from StatsSA mid-year population estimates.

The calculation itself is simple. For each municipality (local and metropolitan) and for each year, I calculated the ratio between the municipality's estimated population in that year, and its census population in 2011. Then I multiplied that ratio with the census population of each small area in the municipality to determine an estimated population for the small area for the year.

## License

The following [terms](https://www.statssa.gov.za/?page_id=425) apply to the use of StatsSA published data:

> All Stats SA products are protected by copyright. Users may apply the information as they wish, provided that they acknowledge Stats SA as the source of the basic data wherever they process, apply, utilise, publish or distribute the data, and also that they specify that the relevant application and analysis (where applicable) result from their own processing of the data.

Any copyright I might have, I hereby waive and dedicate to the public domain under the terms of the [Creative Commons Zero Public Domain Dedication](https://creativecommons.org/publicdomain/zero/1.0/).