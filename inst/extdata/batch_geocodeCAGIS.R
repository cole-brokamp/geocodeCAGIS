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

geocoded <- CB::cb_apply(addresses.unique,geocodeCAGIS,
			 return.score=TRUE,return.call=FALSE,return.match=TRUE,
			 parallel=TRUE,fill=TRUE,pb=TRUE,cache=TRUE,pb=TRUE,
			 error.na=TRUE)

geocoded$address_call <- addresses.unique

out.file <- merge(addresses,geocoded,by.x=address.col.name,by.y='address_call',all=TRUE)

out.file.name <- paste0(gsub('.csv','',in.file,fixed=TRUE),'_CAGISgeocoded.csv')
write.csv(out.file,out.file.name,row.names=F)

print(paste0('FINISHED! output written to ',out.file.name))


