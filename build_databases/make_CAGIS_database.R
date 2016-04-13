# read CSV created from CAGIS shapefile
d <- read.csv('CAGIS/CAGIS_addrmastr.csv',stringsAsFactors=FALSE)

# add Cincinnati and OH to all addresses
d$address <- with(d,paste(ADDRESS,'Cincinnati','OH',ZIPCODE))

# remove all interstate addresses
d <- d[!grepl('I-',x=d$address), ]


# parse all using python program
source('run/addr_parse.R')
d.parse <- CB::CBapply(d$address,addr_parse,fill=TRUE,num.cores=4)

d.parsed <- cbind(d,d.parse)
write.csv(d.parsed,'CAGIS/CAGIS_addrmastr_parsed.csv',row.names=F)


# read in CSV and save as RData file
d.parsed <- read.csv('CAGIS/CAGIS_addrmastr_parsed.csv',stringsAsFactors=FALSE)
save(d.parsed,file='CAGIS/CAGIS_addrmastr_parsed.RData')

