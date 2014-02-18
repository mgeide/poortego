# imports.py

#
# Module poortego.command.imports
#

import csv

def poortego_import(dispatcher_object, arg, opts):
	"""Command to import objects"""
	# TODO
	dispatcher_object.stdout.write("Command not yet implemented.\n")
	if opts.csv:
		fn = arg
		with open(fn, 'r') as data_file:
                        data_reader = csv.reader(data_file, delimiter=',')
                        for line in data_reader:
				if not line:
					pass
				else:
					node_name = str(line[0]).strip()
					# TODO - continue parsing
					dispatcher_object.stdout.write("Node name: %s\n" % node_name)
	elif opts.json:
		fn = arg
		# TODO
	elif opts.maltego:
		fn = arg
		# TODO
	elif opts.stix:
		fn = arg
		(stix_package, stix_package_binding_obj) = STIXPackage.from_xml(fn)
		stix_dict = stix_package.to_dict() # parse to dictionary
		pprint(stix_dict)
	elif opts.ioc:
		fn = arg
		# TODO
