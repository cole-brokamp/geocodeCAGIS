# make sysdata
load('CAGIS/CAGIS_addrmastr_parsed.RData')
devtools::use_data(CAGIS.parsed,internal=TRUE,overwrite=TRUE,compress='gzip')