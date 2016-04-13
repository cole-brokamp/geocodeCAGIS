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
