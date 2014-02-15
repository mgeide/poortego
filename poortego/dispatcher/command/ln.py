# ln.py

#
# Module poortego.command.ln
#

import time

def poortego_ln(dispatcher_object, arg, opts):
	"""Command to link objects"""
	if opts.prompt:
		ln_wizard(dispatcher_object)
	else:
		# TODO
		dispatcher_object.stdout.write("Command not yet implemented.\n")



#
# Link "Wizard"
# Prompt user for appropriate inputs
#
def ln_wizard(dispatcher_object):
	
	# Determine the "start" node to link from
	dispatcher_object.stdout.write("Start node name or id (enter to use current node): ")
	current_node_id = (dispatcher_object.stdin.readline()).replace('\n','')
	if (current_node_id == ""):
		current_node_id = dispatcher_object.my_session.current_node_id
	# TODO - currently only accounting for node id to be passed, need to also account for name
	current_node = dispatcher_object.my_graph.get_node_by_id(current_node_id)

	# Deterine the "end" node to link to
	dispatcher_object.stdout.write("End node name or id: ")
	end_node_id = (dispatcher_object.stdin.readline()).replace('\n','')
	# TODO - account for name, also check if exists
	end_node = dispatcher_object.my_graph.get_node_by_id(end_node_id)

	# Determine link title/name
	dispatcher_object.stdout.write("Link type name (ex. 'KNOWS', enter for None): ")
	link_name = (dispatcher_object.stdin.readline()).replace('\n','')

	# Determine link properties
	property_dict = {}
	dispatcher_object.stdout.write("Link property key (enter for None): ")
	property_key = (dispatcher_object.stdin.readline()).replace('\n','')
	while (property_key != ""):
		dispatcher_object.stdout.write(property_key + " Value: ")
		property_value = (dispatcher_object.stdin.readline()).replace('\n','')
		property_dict[property_key] = property_value

		dispatcher_object.stdout.write("Property Key (return for none): ")
		property_key = (dispatcher_object.stdin.readline()).replace('\n','')


	# Handle default properties
	## TODO - updates to links/properties
        now_string = time.strftime("%Y-%m-%d %H:%M:%S")
        for meta_key,meta_value in dispatcher_object.my_session.default_link_meta.iteritems():
                if (meta_value == 'datetime'):
                        meta_value = now_string
                elif (meta_value == 'username'):
                        meta_value = dispatcher_object.my_session.user.username
                property_dict[meta_key] = meta_value

	# Create/update link based on:
	##  - current_node
	##  - end_node
	##  - link_name
	##  - property_dict
	dispatcher_object.my_graph.create_rel(current_node, end_node, link_name, property_dict)	
