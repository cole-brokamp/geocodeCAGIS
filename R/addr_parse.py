# pip install usaddress
# https://github.com/datamade/usaddress
# probabilistic model used to parse
# possible to update training of model with some parsed data

import usaddress, sys, json

addr=sys.argv[1]

addr_parsed = usaddress.tag(addr)

print(json.dumps(addr_parsed))



