# ln.py

#
# Module poortego.command.ln
#

import time

def poortego_ln(interface_obj, arg, opts):
	"""Command to link objects"""
	if opts.prompt:
		ln_wizard(interface_obj)
	else:
		# TODO
		interface_obj.stdout.write("Command not yet implemented.\n")



#
# Link "Wizard"
# Prompt user for appropriate inputs
#
def ln_wizard(interface_obj):
	
	# Determine the "start" node to link from
	interface_obj.stdout.write("Start node name or id (enter to use current node): ")
	current_node_id = (interface_obj.stdin.readline()).replace('\n','')
	if (current_node_id == ""):
		current_node_id = interface_obj.my_session.current_node_id
	# TODO - currently only accounting for node id to be passed, need to also account for name
	current_node = interface_obj.my_session.my_db.get_node_by_id(current_node_id)

	# Deterine the "end" node to link to
	interface_obj.stdout.write("End node name or id: ")
	end_node_id = (interface_obj.stdin.readline()).replace('\n','')
	# TODO - account for name, also check if exists
	end_node = interface_obj.my_session.my_db.get_node_by_id(end_node_id)

	# Determine link title/name
	interface_obj.stdout.write("Link type name (ex. 'KNOWS', enter for None): ")
	link_name = (interface_obj.stdin.readline()).replace('\n','')

	# Determine link properties
	property_dict = {}
	interface_obj.stdout.write("Link property key (enter for None): ")
	property_key = (interface_obj.stdin.readline()).replace('\n','')
	while (property_key != ""):
		interface_obj.stdout.write(property_key + " Value: ")
		property_value = (interface_obj.stdin.readline()).replace('\n','')
		property_dict[property_key] = property_value

		interface_obj.stdout.write("Property Key (return for none): ")
		property_key = (interface_obj.stdin.readline()).replace('\n','')


		# Handle default properties
		## TODO - updates to links/properties
		now_string = time.strftime("%Y-%m-%d %H:%M:%S")
		for meta_key,meta_value in interface_obj.my_session.default_link_meta.iteritems():
			if (meta_value == 'datetime'):
				meta_value = now_string
			elif (meta_value == 'username'):
				meta_value = interface_obj.my_session.user.username
			property_dict[meta_key] = meta_value

	# Create/update link based on:
	##  - current_node
	##  - end_node
	##  - link_name
	##  - property_dict
	p_link = interface_obj.my_session.my_db.create_link(current_node, end_node, link_name, property_dict)	

	interface_obj.display_link_summary(p_link)
