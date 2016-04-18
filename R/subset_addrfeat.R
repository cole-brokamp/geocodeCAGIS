#' subset_addrfeat
#'
#' This function ...
#' @param TLIDs a vector of TIGER/Line IDs for which the addrfeat shapefiles will be returned
#'
#' @return ?
#'
#' @examples
subset_addrfeat <- function(TLIDs){
  addrfeat.TLIDs <- addrfeat[addrfeat@data$TLID %in% TLIDs, ]
  return(addrfeat.TLIDs)
}
