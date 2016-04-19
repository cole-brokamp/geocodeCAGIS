import usaddress, sys, json
addr=sys.argv[1]
addr_parsed = usaddress.tag(addr)
print(json.dumps(addr_parsed))



