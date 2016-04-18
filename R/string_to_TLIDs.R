#' string_to_TLIDs
#'
#' This function takes a parsed address string and returns a vector of
#' TIGER/Line ID numbers that matched based on the census featnames file.
#'
#' @param parsed_address_string
#'
#' @return a vector of TLIDs
#'
#' @examples
string_to_TLIDs <- function(parsed_address_string){
  # use fuzzy matching to get TLID of street from parsed address, including zip_code
  pas <- parsed_address_string
  names(pas)
  TLIDs <- featnames[grep(street_name,featnames$NAME),'TLID']
  return(TLIDs)
}
