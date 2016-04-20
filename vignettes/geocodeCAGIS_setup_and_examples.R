## ------------------------------------------------------------------------
library(geocodeCAGIS)
geocodeCAGIS('3333 Burnet Ave, Cincinnati, OH 45229',cole=T)

## ------------------------------------------------------------------------
geocodeCAGIS('3333 Burnet Ave, Cincinnati, OH 45229',
             return.score=TRUE,
             return.call=TRUE,
             return.match=TRUE,
             cole=T)

## ------------------------------------------------------------------------
geocodeCAGIS('3333 Burnet Ave, Cincinnati, OH 45229',
             python.system.location='/Library/Frameworks/Python.framework/Versions/2.7/bin/python')

## ------------------------------------------------------------------------
system.file(file.path('extdata/batch_geocodeCAGIS.R'),package='geocodeCAGIS')

