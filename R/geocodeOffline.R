#' Geocode an address string without using the internet.
#'
#' Geocode an address using offline shapefile from CAGIS and TIGER. Requires a
#' \code{R/sysdata.rda} file, see details for more information.
#'
#' This function parses a given address string into address components and
#' attempts to match the address exactly to CAGIS data first.  If this fails (or
#' \code{CAGIS=FALSE}), then TIGERLine files are used to geocode based on street
#' number interpolation.
#'
#' The \code{sysdata.rda} file is available via personal communication (cole dot
#' brokamp at gmail dot com). Alternatively, build the system data file on your
#' own, using updated CAGIS files or a different vintage of TIGER/Line files.
#' See \code{README.md} for details on this operation. Make sure to `R CMD BATCH
#' --vanilla make_sysdata.R` and rebuild the package if using your own address
#' reference files.
#'
#' Setting CAGIS or TIGER to FALSE will skip the geocoding based on those files.
#' CAGIS is checked first and skipped over if the zip code of the address string
#' does not begin with 450, 451, or 452.
#'
#' @param address_string a single string that will be geocoded
#' @param CAGIS logical, attempt to geocode using CAGIS files?
#' @param TIGER logical, attempt to geocode using TIGER files?
#'
#' @return
#' @export
#'
#' @examples
#' geocodeOffline('3333 Burnet Ave, Cincinnati, OH 45229')

geocodeOffline <- function(address_string,CAGIS=TRUE,TIGER=TRUE){

  if (!(CAGIS | TIGER)) stop('must set at least one of CAGIS or TIGER to TRUE')
  if (!class(address_string)) stop('address_string must be a character string')

  p.address <- addr_parse(address_string)

  if (CAGIS) out <- CAGIS(p.address)

  if (is.na(out)) {
    TLIDs <- string_to_TLIDs(p.address)
    subset_addrfeat(TLIDs)
    interpolate_loc_from_addr_range()
  }
}
