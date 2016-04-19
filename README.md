# geocodeCAGIS

> Geocode Cincinnati, OH area address using offline exact location files

## TODO

- generate script to download sysdata.RData file and put in the right place
	- use .libPaths() to get where project is and then `wget` file to there


## Overview

This package is designed to geocode address strings that are private health information.  Most institutional review boards will not allow the use of online geocoders. This program maintains HIPPA compliance by exact address matching using data from the Cincinnati Area Geographic Information System ([CAGIS](http://cagismaps.hamilton-co.org/cagisportal)). This drastically improves geocoding, but is only available for addresses that have a zipcode beginning with 450, 451, or 452. 
    
## Installing

#### R Package

Install the package by running the following in `R`:

`devtools::install_github('cole-brokamp','geocode_offline')`

#### Python

The package relies on a python function, which means that both `python` and the `usaddress` python library must be installed (`pip install usaddress`). Specify a non-standard location for the python executable using the `python.system.location` argument in the `addr_parse.R` function. 

#### Database Files

The package requires an address database file as a `R/sysdata.rda` file. This file is too large to host on GitHub, but contact me (cole dot brokamp at gmail dot com) for a copy.  

Alternatively, build the system data file on your own, using updated CAGIS files by running `bash build_CAGIS_address_file.sh`. This script will download the CAGIS master address file, unzip it, and extract the shapefile to a CSV. Then `make_CAGIS_database.R` is called to parse all listed CAGIS addresses and save as a `.RData` file. Unused files are deleted afterwards. 

Make sure to `R CMD BATCH --vanilla make_sysdata.R` and rebuild the package with the updated `R/sysdata.rda` if using your own address reference files.

*These scripts were built for OS X or Linux. Both take a long time to run... please review the files beforehand.*

## Example Geocoding

- An address must be submitted as a single string
- The city and state are optional and not used for geocoding. 
- Street number, street name, and zip code must be in the address string. 
- Street numbers must be numeric (i.e. "18", not "Eighteen").

```r 
library(geocodeCAGIS)

# single address
geocodeCAGIS('3333 Burnet Ave, Cincinnati, OH 45229')

> sample output here
```
