### THIS SOFTWARE IS NO LONGER MAINTAINED AND HAS BEEN REPLACED WITH THE R PACKAGE "hamilton", AVAILABLE AT [https://github.com/cole-brokamp/hamilton](https://github.com/cole-brokamp/hamilton)

[![DOI](https://zenodo.org/badge/21831/cole-brokamp/geocodeCAGIS.svg)](https://zenodo.org/badge/latestdoi/21831/cole-brokamp/geocodeCAGIS)

# geocodeCAGIS

>An R package to geocode Cincinnati, OH area addresses using offline exact location files.

## Installation

Install from github with `remotes::install_github('cole-brokamp/geocodeCAGIS')`.

*Note, this package requires the python module called `usaddress`. After installing python and pip, install the module with `pip install usaddress`.*

## Usage

Geocode with `geocodeCAGIS('3333 Burnet Ave, Cincinnati, OH 45229')`. For more details, including an executable for batch geocoding, see the package vignette.

