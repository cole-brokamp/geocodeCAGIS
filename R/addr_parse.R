#' addr_parse
#'
#' This function utilizes a python script to parse out individual address
#' components from a string.
#'
#' An address string is parsed for the following components: - `AddressNumber`,
#' `StreetName`, `StreetPostType`, `PlaceName`, `StateName`, `ZipCode`,
#' `StreetNamePreType`, `StreetNamePreDirectional`, `AddressNumberSuffix`,
#' `StreetNamePostDirectional`.  If any of these components are not present in
#' the string `NA` is returned for that component.
#'
#' Because it uses a python script to parse the address, it will make a copy of
#' this file (\code{.addr_parse.py}) if one does not already exist in the
#' working directory.
#'
#' @param address.string a string to be parsed for address components
#' @param return.call logical, return the call along with the parsed address?
#' @param python.system.location string for filepath to python installation to
#'   use for addr_parse.py
#' @param cole logical, convenience argument to set my python location on my
#'   local machine
#'
#' @return a data.frame with the address components as columns and optionally
#'   the submitted address string
#' @export
#'
#' @examples
#' addr_parse('3333 Burnet Ave, Cincinnati, OH 45229',cole=TRUE)
#' addr_parse('737 US 50 Cincinnati OH 45150',cole=TRUE)
#' addr_parse('3333 Burnet Ave, Cincinnati, OH 45229',
#' python.system.location='/Library/Frameworks/Python.framework/Versions/2.7/bin/python')

addr_parse <- function(address.string,python.system.location=system('whereis python'),cole=FALSE) {
  if (cole) python.system.location <- '/Library/Frameworks/Python.framework/Versions/2.7/bin/python'

  # create local copy of python script if it doesn't already exist
  if(!file.exists('.addr_parse.py')){
    cat('import usaddress, sys, json\naddr=sys.argv[1]\naddr_parsed = usaddress.tag(addr)\nprint(json.dumps(addr_parsed))',
        file='.addr_parse.py')
  }

  out.json <- system2(python.system.location,c('.addr_parse.py',shQuote(address.string)),stdout=TRUE)
  out.list <- jsonlite::fromJSON(out.json,flatten=FALSE)
  out.address <- out.list[[1]]
  out.df <- as.data.frame(out.address,stringsAsFactors=F)
  out.full <- data.frame('AddressNumber'=NA,'StreetName'=NA,'StreetPostType'=NA,
                         'PlaceName'=NA,'StateName'=NA,'ZipCode'=NA,
                         'StreetNamePreType'=NA,'StreetNamePreDirectional'=NA,
                         'AddressNumberSuffix'=NA,'StreetNamePostDirectional'=NA)
  for (field in names(out.df)) out.full[1,field] <- out.df[1,field]
  return(out.full)
}

