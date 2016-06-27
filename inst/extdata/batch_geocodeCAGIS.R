#!/usr/bin/Rscript

library(geocodeCAGIS)

library(argparser)
p <- arg_parser('offline geocoding, returns the input file with geocodes appended')
p <- add_argument(p,'file_name',help='name of input csv file')
p <- add_argument(p,'column_name',help='the name of the column in the csv file that contains the address strings')
args <- parse_args(p)

in.file <- args$file_name
address.col.name <- args$column_name

addresses <- read.csv(in.file,stringsAsFactors=FALSE,na.strings=c('',' '))

addresses.unique <- unique(addresses[ ,address.col.name])

geocoded <- CB::cb_apply(addresses.unique,function(x) {
  # print(paste0('geocoding ',tail(which(addresses.unique==x),1),' of ',length(addresses.unique)))
  tryCatch(geocodeCAGIS(x,return.score=TRUE,return.call=FALSE,return.match=TRUE),
           error=function(e)data.frame('lat'=NA))
  },parallel=TRUE,fill=FALSE,pb=TRUE)

geocoded$address_call <- addresses.unique

out.file <- merge(addresses,geocoded,by.x=address.col.name,by.y='address_call',all=TRUE)

out.file.name <- paste0(gsub('.csv','',in.file,fixed=TRUE),'_geocoded.csv')
write.csv(out.file,out.file.name,row.names=F)

# system(paste0('csv_to_shp ',out.file.name))

# print(paste0('FINISHED! output written to ',out.file.name,'and to folder ',paste0(gsub('.csv','',out.file.name,fixed=TRUE)),' as a shapefile'))
print(paste0('FINISHED! output written to ',out.file.name))


