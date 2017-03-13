# read CSV created from CAGIS shapefile
d <- read.csv('CAGIS/CAGIS_addrmastr.csv',stringsAsFactors=FALSE)

# add Cincinnati and OH to all addresses
d$address <- with(d,paste(ADDRESS,'Cincinnati','OH',ZIPCODE))

# remove all interstate addresses
d <- d[!grepl('I-',x=d$address), ]


# parse all using python program
source('R/addr_parse.R')
d.parse <- CB::CBapply(d$address,addr_parse,fill=TRUE,num.cores=4)

CAGIS.parsed <- cbind(d,d.parse)

save(CAGIS.parsed,file='CAGIS/CAGIS_addrmastr_parsed.RData')

