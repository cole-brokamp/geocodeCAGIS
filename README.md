# Geocode Offline

## About

- what frameworks does it use?
	- python/usaddress to parse address
    - sqlite3 database from CAGIS
    - database from TIGER
    - fuzzy string matching?


## Requirements

- `Python`
  - usaddress library (`pip install usaddress`)
  - sqlite3 library??
  - if building databases, also need: ... ogr2ogr (geos??)
- `R`
  - CB R package (`devtools::install_github('cole-brokamp/CB')`)
### Database Files

To build the CAGIS and TIGER databases from scratch, see below.  If you already have the complete CAGIS and TIGER database files, then skip to Running.

#### CAGIS addresses

Download CAGIS master address shapefile:
    
    wget -nd -r http://cagis.org/Opendata/CagisOpenDataQuarterly.zip
    unzip CagisOpenDataQuarterly.zip -j -d ./CAGIS

Convert the shapefile to a CSV:
        
    bash build_databases/CAGIS_shp2csv.sh

Parse all of the addresses in the CSV file, add columns, and make into R data.frame (*Warning, this takes what seems like forever!*):
        
    R CMD BATCH build_databases/make_CAGIS_database.R
        
