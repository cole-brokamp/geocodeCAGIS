# download CAGIS master address shapefile
wget -nd -r http://cagis.org/Opendata/CagisOpenDataQuarterly.zip
unzip CagisOpenDataQuarterly.zip -j -d ./CAGIS

# extract as CSV
ogr2ogr -f CSV \
  -select ADDRESS,JURISFULL,ZIPCODE,LATITUDE,LONGITUDE \
  -progress CAGIS/CAGIS_addrmastr.csv "CAGIS/Address.shp" \
  -lco GEOMETRY=AS_XY -s_srs EPSG:3735 -t_srs EPSG:4326
  
# parse all of the addresses in the CSV file and save .RData
R CMD BATCH --vanilla build_databases/make_CAGIS_database.R

# remove shapefiles and CSV
rm CagisOpenDataQuarterly.zip
rm CAGIS/CAGIS_addrmastr.csv