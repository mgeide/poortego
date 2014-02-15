# imports.py

#
# Module poortego.command.imports
#

def poortego_import(dispatcher_object, args, opts):
	"""Command to import objects"""
	# TODO
	dispatcher_object.stdout.write("Command not yet implemented.\n")
	if opts.csv:
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

