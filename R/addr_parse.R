#' Parse an address string into individual components.
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
#' This function depends on having a sufficient python binary installed and
#' having the module `usaddress` available. Use `pip install usaddress` to
#' install this module after python is installed.
#'
#' @param address.string a string to be parsed for address components
#'
#' @return a data.frame with the address components
#' @export
#'
#' @examples
#' addr_parse('3333 Burnet Ave, Cincinnati, OH 45229')
#' addr_parse('737 US 50 Cincinnati OH 45150')

addr_parse <- function(address.string) {
  py.bin.loc <- findpython::find_python_cmd(required_modules='usaddress',
                                            error_message='Could not find a python binary with the usaddress module available. Make sure to install python and then use `pip install usaddress` to install the module.')
  py.file.loc <- system.file(file.path('extdata/addr_parse.py'),package='geocodeCAGIS',mustWork=T)
  out.json <- system2(py.bin.loc,c(py.file.loc,shQuote(address.string)),stdout=TRUE)
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

