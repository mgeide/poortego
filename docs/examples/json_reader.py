#!/usr/bin/python

import sys, json

if __name__ == "__main__":
	json_file = sys.argv[1]
	with open(json_file, 'r') as f:
		contents = f.readlines()
		json_str = ''
		for line in contents:
			line = line.strip()
			if not line:
				next
			elif line.startswith('#'):
				next
			else:
				json_str = json_str + line
	print "JSON string: %s\n" % json_str 
	decoded_data = json.loads( json_str )
	print "Decoded data: %s\n" % decoded_data

	for node in decoded_data["nodes"]:
		print "Node: %s\n" % node
