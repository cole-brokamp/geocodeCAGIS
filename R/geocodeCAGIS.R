#' Geocode Cincinnati, OH area address using offline exact location files
#'
#' Geocode an address using offline shapefile from CAGIS. Requires a
#' \code{R/sysdata.rda} file, see details for more information.
#'
#' This function parses a given address string into address components and
#' attempts to match the address to CAGIS data.  The best match is returned and
#' the score represents how many insertions/deletions/rearrangements were needed
#' to match the input string to the address data.
#'
#' The \code{sysdata.rda} file is available via personal communication (cole dot
#' brokamp at gmail dot com). Alternatively, build the system data file on your
#' own, using updated CAGIS files or a different vintage of TIGER/Line files.
#' See \code{README.md} for details on this operation. Make sure to `R CMD BATCH
#' --vanilla make_sysdata.R` and rebuild the package if using your own address
#' reference files.
#'
#' This function will return NA if the zip code of the address string
#' does not begin with 450, 451, or 452.
#'
#' @param address_string a single string that will be geocoded
#' @param verbose logical, return method and matching score?
#'
#' @return data.frame with lat/lon coords and optionally method score
#' @export
#'
#' @examples
#' geocodeCAGIS('3333 Burnet Ave, Cincinnati, OH 45229')
#' geocodeCAGIS('3333 Burnet Ave, Cincinnati, OH 45229',verbose=TRUE,return.call=TRUE)
#' geocodeCAGIS('1456 Main St. 23566')

geocodeCAGIS <- function(addr_string,verbose=FALSE,return.call=FALSE) {

  stopifnot(class(addr_string)=='character')

  addr_string <- tolower(addr_string)
  address.p <- addr_parse(addr_string)

  stopifnot(substr(address.p$ZipCode,1,3) %in% c(450,451,452))

  # remove city and state
  address.p$PlaceName <- NULL
  address.p$StateName <- NULL
  # remove missing fields
  address.p <- address.p[!sapply(address.p,is.na)]

  # make candidates based on fuzzy join
  osa.candidates <- fuzzyjoin::stringdist_left_join(address.p,
                                                    na.omit(CAGIS.parsed[ ,c(names(address.p),'LATITUDE','LONGITUDE')]),
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
  out <- data.frame('lat'=candidates[best.candidate,'LATITUDE'],
                    'lon'=candidates[best.candidate,'LONGITUDE'])
  if (verbose) {
    out$method <- 'CAGIS'
    out$score <- dist.matrix[best.candidate,'total.weighted.distance']
  }
  if (return.call) out$call <- addr_string
  return(out)
}


