# geocodeOffline

> Geocode an address string without exposing it to the internet.


## Overview

This package is designed to geocode address strings that are private health information.  Most institutional review boards will not allow the use of online geocoders. This program maintains HIPPA compliance by using TIGER/Line files to geocode by address range interpolation. This package also contains an optional geocoding method based on exact address matching using data from the Cincinnati Area Geographic Information System ([CAGIS](http://cagismaps.hamilton-co.org/cagisportal)). This drastically improves geocoding, but is only available for addresses that have a zipcode beginning with 450, 451, or 452. 
    
## Installing

#### R

Install the package by running the following in `R`:

`devtools::install_github('cole-brokamp','geocode_offline')`

#### Python Dependency

The package relies on a python function, which means that both `python` and the `usaddress` python library must be installed (`pip install usaddress`). Specify a non-standard location for the python executable using the `python.system.location` argument in the `addr_parse.R` function. 

#### Database Files

The package requires address database files as a `R/sysdata.rda` file. These files are too large to host on GitHub, but contact me (cole dot brokamp at gmail dot com) for access.  Alternatively, build the system data file on your own, using updated CAGIS files or a different vintage of TIGER/Line files. Make sure to `R CMD BATCH --vanilla make_sysdata.R` and rebuild the package with the updated `R/sysdata.rda` if using your own address reference files.

*These scripts were built for OS X or Linux. Both take a long time to run... please review the files beforehand.*

**CAGIS**
	
This script will download the CAGIS master address file, unzip it, and extract the shapefile to a CSV. Then `make_CAGIS_database.R` is called to parse all listed CAGIS addresses and save as a `.RData` file. Unused files are deleted afterwards.

	bash build_CAGIS_address_file.sh
        
**TIGER**

Running the following script will unpack each TIGER/Line ZIP file into a temp directory, transform from EPSG:4326 to EPSG:5072, and build the sqlite database. Unused files are deleted afterwards.

	build_databases/make_TIGER_database.sh

## Example Geocoding

- An address must be submitted as a single string
- The city and state are optional and not used for geocoding. 
- Street number, street name, and zip code must be in the address string. 
- Street numbers must be numeric (i.e. "18", not "Eighteen").

```r 
library(geocodeOffline)

# single address
geocodeOffline('3333 Burnet Ave, Cincinnati, OH 45229')
geocodeOffline('1600 Pennsylvania Ave NW, Washington, DC 20500')

> example output here...

# using only CAGIS data
geocodeOffline('3333 Burnet Ave, Cincinnati, OH 45229',TIGER=FALSE)

> example output here...

# using only TIGER data
geocodeOffline('1600 Pennsylvania Ave NW, Washington, DC 20500',CAGIS=FALSE)

> example output here...

```
