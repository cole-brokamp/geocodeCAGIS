## ------------------------------------------------------------------------
library(geocodeCAGIS)
geocodeCAGIS('3333 Burnet Ave, Cincinnati, OH 45229')

## ------------------------------------------------------------------------
geocodeCAGIS('3333 Burnet Ave, Cincinnati, OH 45229',
             return.score=TRUE,
             return.call=TRUE,
             return.match=TRUE)

## ------------------------------------------------------------------------
system.file(file.path('extdata/batch_geocodeCAGIS.R'),package='geocodeCAGIS')

