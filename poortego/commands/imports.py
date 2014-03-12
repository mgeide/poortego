# imports.py

#
# Module poortego.command.imports
#

from ..parsers.poortego_parser import PoortegoParser

def poortego_import(interface_obj, arg, opts):
	"""Command to import objects"""
	# TODO
	if opts.csv:
		my_parser = PoortegoParser('file', 'csv', arg)
		my_parser.run()
		p_nodes = my_parser.resulting_nodes()
		resulting_nodes = interface_obj.my_session.my_db.add_nodes(p_nodes)
		interface_obj.display_nodes_summary(resulting_nodes)
		
		p_links = my_parser.resulting_links()
		resulting_links = interface_obj.my_session.my_db.add_links(p_links)
		for resulting_link in resulting_links:
			interface_obj.display_link_summary(resulting_link)
		
	elif opts.json:
		fn = arg
		# TODO
	elif opts.maltego:
		fn = arg
		# TODO
	elif opts.stix:
		fn = arg
		#(stix_package, stix_package_binding_obj) = STIXPackage.from_xml(fn)
		#stix_dict = stix_package.to_dict() # parse to dictionary
		#pprint(stix_dict)
	elif opts.ioc:
		fn = arg
		# TODO
	else:
		interface_obj.stdout.write("Command not yet implemented.\n")	