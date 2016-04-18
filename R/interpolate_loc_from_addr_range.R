


interpolate_loc_from_addr_range <- function(street_number,addrfeat.TLIDs,verbose=FALSE) {
  ## determine which side of the street the address is on
  odd_even <- function(n) ifelse(n %% 2 == 1,'odd','even')
  LR.oddeven.hash <- c('L' = odd_even(as.numeric(addrfeat.TLIDs@data[1,'LFROMHN'])),
                       'R' = odd_even(as.numeric(addrfeat.TLIDs@data[1,'RFROMHN'])))
  street.side <- names(LR.oddeven.hash)[LR.oddeven.hash == odd_even(street_number)]
  # keep only lines that contain the street number
  street_number.rng <- apply(addrfeat.TLIDs@data[ ,paste0(street.side,c('FROMHN','TOHN'))],
                             1,
                             function(x) {
                               rng <- range(as.numeric(x))
                               street_number > rng[1] & street_number < rng[2]
                             })
  matched.line <- addrfeat.TLIDs[street_number.rng, ]

  ## find which line segment the address should be in
  # calculate length of line and fraction of address range
  matched.line.length <- rgeos::gLength(matched.line)
  matched.addr.range <- as.numeric(matched.line@data[ ,paste0(street.side,c('FROMHN','TOHN'))])
  faar <- (street_number - min(matched.addr.range)) /
    (diff(range(matched.addr.range)))
  faar_length <- matched.line.length * faar
  # make line into points calculate individual segments
  matched.line.points <- sp::SpatialPoints(coords=coordinates(matched.line)[[1]][[1]],
                                           proj4string=CRS('+init=epsg:5072'))
  matched.line.points.distance.matrix <- rgeos::gDistance(matched.line.points,byid=TRUE)
  # extract one row above upper diagonal to get distances between all sequential points
  matched.line.points.distances <- mapply(x=1:(nrow(matched.line.points.distance.matrix)-1),
                                          y=2:nrow(matched.line.points.distance.matrix),
                                          function(x,y) matched.line.points.distance.matrix[x,y])
  ### IS IT TRUE? that address always increase along line??

  # calculate first length point that has a cumulative sum greater than faar_length
  gt.point <- which(cumsum(matched.line.points.distances) > faar_length)[1]
  lt.point <- gt.point - 1

  ## find where in that line segment the point should be
  # calculate fraction of length of that line segment
  faar.segment.fraction <- (faar_length - cumsum(matched.line.points.distances)[lt.point]) /
    (diff(cumsum(matched.line.points.distances)[c(lt.point,gt.point)]))
  # convert the segment points into a line
  matched.line.segment <- sp::SpatialLines(list(Lines(list(
    sp::Line(rbind(coordinates(matched.line.points[lt.point]),
                   coordinates(matched.line.points[gt.point])))),
    'some_id')),
    CRS('+init=epsg:5072'))
  distance.from.lt.point <- rgeos::gDistance(matched.line.points[gt.point],
                                             matched.line.points[lt.point]) * faar.segment
  # buffer lt.point according to distance.from.lt.point and crop the matched.line.segment
  matched.line.segment_cropped <- rgeos::gIntersection(matched.line.segment,
                                                       rgeos::gBuffer(matched.line.points[lt.point],
                                                                      width=distance.from.lt.point))
  matched.line.segment_cropped_end.points <- sp::SpatialPoints(coordinates(matched.line.segment_cropped)[[1]][[1]],
                                                               proj4string=CRS('+init=epsg:5072'))
  # find out which one doesn't equal the lt.point
  out.point <- matched.line.segment_cropped_end.points[which.max(rgeos::gDistance(matched.line.segment_cropped_end.points,
                                                                                  matched.line.points[lt.point],
                                                                                  byid=TRUE))]
  out <- data.frame(coordinates(sp::spTransform(out.point,CRS('+init=epsg:4326'))))
  names(out) <- c('lon','lat')
  if (verbose) {
    out$street_side <- street.side
    out$matched_addr_range <- matched.addr.range
    out$matched_name <- matched.line@dataFULLNAME
    out$matched_zip <- matched.line@data[ ,paste0('ZIP',street.side)]
    out$TLID <- matched.line@data$TLID
  }
  return(out)
}

