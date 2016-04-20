#!/usr/bin/Rscript

library(geocodeCAGIS)

library(argparser)
p <- arg_parser('offline geocoding, returns the input file with geocodes appended')
p <- add_argument(p,'file_name',help='name of input csv file')
p <- add_argument(p,'column_name',help='the name of the column in the csv file that contains the address strings')
args <- parse_args(p)

in.file <- args$file_name
address.col.name <- args$column_name

addresses <- read.csv(in.file,stringsAsFactors=FALSE)

addresses.unique <- unique(addresses[ ,address.col.name])

geocoded <- CB::CBapply(addresses.unique,function(x) {
  print(paste0('geocoding ',tail(which(addresses.unique==x),1),' of ',length(addresses.unique)))
  geocodeCAGIS(x,return.score=TRUE,return.call=FALSE,return.match=TRUE)
  },fill=TRUE)

out.file <- merge(addresses,geocoded,by.x=address.col.name,by.y='row.names',all=TRUE)
out.file$address_call <- row.names(out.file)
print(out.file)

out.file.name <- paste0(gsub('.csv','',in.file,fixed=TRUE),'_geocoded.csv')
write.csv(out.file,out.file.name,row.names=F)

system(paste0('csv_to_shp ',out.file.name))

print(paste0('FINISHED! \n    output written to ',out.file.name,'\n and to folder ',paste0(gsub('.csv','',out.file.name,fixed=TRUE)),' as a shapefile'))

