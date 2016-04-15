# function that returns parsed address from an address string using a python script

addr_parse <- function(address.string,return.call=FALSE) {
  out.json <- system2('/Library/Frameworks/Python.framework/Versions/2.7/bin/python',
                      c('run/addr_parse.py',shQuote(address.string)),stdout=TRUE)
  out.list <- jsonlite::fromJSON(out.json,flatten=FALSE)
  out.address <- out.list[[1]]
  out.df <- as.data.frame(out.address,stringsAsFactors=F)
  out.full <- data.frame('AddressNumber'=NA,'StreetName'=NA,'StreetPostType'=NA,
                         'PlaceName'=NA,'StateName'=NA,'ZipCode'=NA,
                         'StreetNamePreType'=NA,'StreetNamePreDirectional'=NA,
                         'AddressNumberSuffix'=NA,'StreetNamePostDirectional'=NA)
  for (field in names(out.df)) out.full[1,field] <- out.df[1,field]
  if (return.call) out.full$call <- address.string
  return(out.full)
}

## ex
# addr_parse('4101 Spring Grove Ave Cincinnati OH 45223')
# addr_parse('737 US 50 Cincinnati OH 45150')
