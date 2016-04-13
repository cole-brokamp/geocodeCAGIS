# function that returns parsed address from an address string using a python script

addr_parse <- function(address.string,return.call=FALSE) {
  out.json <- system2('/Library/Frameworks/Python.framework/Versions/2.7/bin/python',
                      c('run/addr_parse.py',shQuote(address.string)),stdout=TRUE)
  out.list <- jsonlite::fromJSON(out.json,flatten=FALSE)
  out.address <- out.list[[1]]
  out.type <- out.list[[2]]
  out.df <- data.frame(as.data.frame(out.address),'type'=out.type)
  if (return.call) out.df$call <- address.string
  return(out.df)
}

## ex
# addr_parse('4101 Spring Grove Ave Cincinnati OH 45223')
# addr_parse('737 US 50 Cincinnati OH 45150')
# addr_parse('9100 I-275 NB TO I-74 EB RAMP Cincinnati OH 45002')
