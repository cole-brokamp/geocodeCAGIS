load('CAGIS/CAGIS_addrmastr_parsed.RData')
d.parsed$type <- NULL

source('run/addr_parse.R')

addr_string <- '6655 Hitching Post Lane Cincinnati, Ohio 45230'

# only matches on street number, street name, and address


CAGIS_match <- function(addr_string) {
  addr_string <- tolower(addr_string)
  address.p <- addr_parse(addr_string)
  
  # if zip code does not match areas covered by CAGIS, then completely skip  
  valid.zips.prefixes <- c(450,451,452)
  if (!substr(address.p$ZipCode,1,3) %in% valid.zips.prefixes) return(NA)
  
  # remove city and state
  address.p$PlaceName <- NULL
  address.p$StateName <- NULL
  # remove missing fields
  address.p <- address.p[!sapply(address.p,is.na)]
  
  # make candidates based on fuzzy join
  osa.candidates <- fuzzyjoin::stringdist_left_join(address.p,
                                                    na.omit(d.parsed[ ,c(names(address.p),'LATITUDE','LONGITUDE')]),
                                                    by = names(address.p),
                                                    method='osa',ignore_case=TRUE)
  candidates <- osa.candidates[ ,c(grep('.y',names(osa.candidates),value=TRUE,fixed=TRUE),'LATITUDE','LONGITUDE')] # keep just matches
  names(candidates) <- gsub('.y','',names(candidates),fixed=TRUE) # remove .y from names
  candidates <- as.data.frame(sapply(candidates,function(x) tolower(as.character(x))),
                              stringsAsFactors=FALSE) # make all char
  
  # find best match within candidates
  dist.matrix <- sapply(names(candidates)[!names(candidates) %in% c('LATITUDE','LONGITUDE')],function(x){
    x.dist <- stringdist::stringdist(as.character(candidates[ ,x]),as.character(address.p[ ,x]),method='osa')
  })
  dist.matrix <- as.data.frame(dist.matrix)
  dist.matrix$total.weighted.distance <- apply(dist.matrix,1,sum)
  best.candidate <- which.min(dist.matrix$total.weighted.distance)
  return(data.frame('lat'=candidates[best.candidate,'LATITUDE'],
                    'lon'=candidates[best.candidate,'LONGITUDE'],
                    'method' = 'CAGIS',
                    'score' = dist.matrix[best.candidate,'total.weighted.distance'])
  )
}

system.time(                
CAGIS_match('6655 Hitching Post Lane Cincinnati OH 45230')
)

# todo
# choose to keep CAGIS match based on a certain threshold?
