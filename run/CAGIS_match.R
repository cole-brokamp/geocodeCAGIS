load('CAGIS/CAGIS_addrmastr_parsed.RData')
d.parsed$type <- NULL

source('run/addr_parse.R')

CAGIS_match <- function(q.address) {
  
  q.address <- tolower(q.address)
  q.address <- addr_parse(q.address)
  
  # make candidates based on fuzzy join
  candidates <- fuzzyjoin::stringdist_join(q.address,d.parsed,
                                           by = names(d.parsed)[names(d.parsed) %in% names(q.address)],
                                           method = 'lcs', mode = 'left', ignore_case = TRUE, nthread=4)
  candidates.big <- data.frame(sapply(candidates,as.character),stringsAsFactors=FALSE) # make all char
  candidates <- candidates.big[ ,grep('.y',names(candidates),value=TRUE,fixed=TRUE)]
  names(candidates) <- gsub('.y','',names(candidates),fixed=TRUE)
  candidates <- data.frame(lapply(candidates, function(v) { # make all lower
    if (is.character(v)) return(tolower(v))
    else return(v)
  }),stringsAsFactors=FALSE)
  # find best match within candidates
  dist.matrix <- sapply(names(candidates),function(x){
    x.dist <- stringdist::stringdist(as.character(candidates[ ,x]),as.character(q.address[ ,x]),method='osa')
  })
  dist.matrix <- as.data.frame(dist.matrix)
  dist.matrix$total.weighted.distance <- apply(dist.matrix,1,sum)
  best.candidate <- which.min(dist.matrix$total.weighted.distance)
  return(data.frame('lat'=candidates.big[best.candidate,'LATITUDE'],
                    'lon'=candidates.big[best.candidate,'LONGITUDE'],
                    'method' = 'CAGIS',
                    'score' = dist.matrix[best.candidate,'total.weighted.distance'])
  )
}

                  

CAGIS_match('6655 Hitching Post Lane Cincinnati OH 45230')

# todo
# choose to keep CAGIS match based on a certain threshold?
