# subset addrmastr shapefile from CAGIS and make it into CSV, including geometry
ogr2ogr -f CSV \
  -select ADDRESS,JURISFULL,ZIPCODE,LATITUDE,LONGITUDE \
  -progress CAGIS/CAGIS_addrmastr.csv "CAGIS/Address.shp" \
  -lco GEOMETRY=AS_XY -s_srs EPSG:3735 -t_srs EPSG:4326