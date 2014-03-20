# find.py

#
# Module poortego.command.find
#

def poortego_find(interface_obj, arg):
	"""Command to find nodes"""
	# TODO
	search_string = arg
	search_dict = { "value" : search_string }
	interface_obj.stdout.write("[DEBUG] Searching for %s\n" % search_dict)
        p_results = interface_obj.my_session.my_db.find_nodes(search_dict)
        for p_result in p_results:
            interface_obj.stdout.write("Node representation:\n %s\n" % p_result.to_str())
