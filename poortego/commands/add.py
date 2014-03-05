# add.py

#
# Module poortego.command.add
#

import time

def poortego_add(interface_obj, arg, opts):

	# -t / --type
	if opts.node_type:
		print "TODO: set node type from command option\n"
		#node_dict = {}
		## -v / --value
		#if opts.node_value:
		#	node_dict = {'name':opts.node_value}
		#        #else:
		#	interface_obj.stdout.write("Object Name or Value: ")
		#        #	object_val = (interface_obj.stdin.readline()).replace('\n','')		
		#	node_dict = {'name':object_val}
		## Get or Create Node
		#        #node_addition = interface_obj.my_session.my_db.get_or_create_indexed_node("NameIdx", "name", node_dict['name'], node_dict)
		#
		#        ## Add type/category (labels in neo4j 2.x)
		#interface_obj.my_session.my_db.add_labels(node_addition, opts.node_type)

	# -v / --value
	elif opts.node_value:
		print "TODO: set node value from command option\n"
		#node_dict = {'name':opts.node_value}
		#node_addition = interface_obj.my_session.my_db.get_or_create_indexed_node("NameIdx", "name", node_dict['name'], node_dict)
		#if opts.node_type:
		#	interface_obj.my_session.my_db.add_labels(node_addition, opts.node_type)
		#else:
		#                interface_obj.stdout.write("Object Type/Category/Tag: ")
		#                object_type = (interface_obj.stdin.readline()).replace('\n','')		
		#	interface_obj.my_session.my_db.add_labels(node_addition, object_type)
	elif opts.prompt: # DEFAULT option too
		add_wizard(interface_obj)
	elif opts.csv:
		# TODO - add a CSV line
		print "TODO: add a CSV line"
	elif opts.json:
		# TODO - add a json line
		print "TODO: add a JSON line"
	elif opts.multiline:
		# TODO - support values with newlines
		print "TODO: add values that contain newline characters"
	elif opts.filenode:
		# TODO - support for node that references a file
		print "TODO: add values that reference a local file"	
	else:
		interface_obj.stdout.write("ERROR- no option provided")

# TODO - remove whitespace, lowercase if appropriate, etc
def verify_and_normalize_values(obj_val, obj_types, obj_properties):
	# For example:
	#if "DOMAIN" in obj_types:
	#	obj_val = obj_val.strip()
	#	obj_val = obj_val.lower()
	print "TODO: verify and normalize values"

# TODO - create implied nodes, e.g., URL -> FQDN -> Domain
def create_implied_nodes(obj_val, obj_types, obj_properties):
	# For example
	#if "URL" in obj_types:
		# - Create FQDN node and link to URL
		# - Create Domain node and link to FQDN
	print "TODO: create implied nodes"


def add_nodes_wizard_prompt(interface_obj):
	node_list = list()
	interface_obj.stdout.write(":: Add Node Wizard :: (all nodes entered will be set to the same label/property values here)\n")
	interface_obj.stdout.write("Enter node(s) unique/primary name or value (one per line, blank line at end of list):\n")
	interface_obj.stdout.write("name> ") 
	object_val = (interface_obj.stdin.readline()).replace('\n','')
	while object_val:
		node_dict = {'name':object_val}
		node_list.append(node_dict)
		interface_obj.stdout.write("name> ") 
		object_val = (interface_obj.stdin.readline()).replace('\n','')
	return node_list


def add_node_labels_wizard_prompt(interface_obj):
	label_set = set()
	interface_obj.stdout.write("Enter node label(s) - these are node type, category, or tag values to assign to the node(s)\n")
	interface_obj.stdout.write("('?' lists existing labels that you may wish to use, blank line ends the list of labels being set)\n")
	interface_obj.stdout.write("label> ")
	label_val = (interface_obj.stdin.readline()).replace('\n','')
	while label_val:
		if not label_val:
			break
		elif label_val == "?":
			interface_obj.stdout.write("Existing labels:\n")
			label_list = interface_obj.my_session.my_db.get_all_labels()
			interface_obj.stdout.write(repr(label_list) + "\n")
		else:
			label_set.add(label_val)
		interface_obj.stdout.write("label> ")
		label_val = (interface_obj.stdin.readline()).replace('\n','')
	return label_set


def add_node_properties_wizard_prompt(interface_obj):
	property_dict = {}
	interface_obj.stdout.write("Enter node property(s) - these are key/value attributes to assign to node(s)\n")
	interface_obj.stdout.write("(blank property key to ends list of properties being set)\n")
	interface_obj.stdout.write("property key> ")
	property_key = (interface_obj.stdin.readline()).replace('\n','')
	while property_key:
		if not property_key:
			break
		else:
			interface_obj.stdout.write("%s value> " % property_key)
			property_value = (interface_obj.stdin.readline()).replace('\n','')
			property_dict[property_key] = property_value		
			interface_obj.stdout.write("property key> ")
			property_key = (interface_obj.stdin.readline()).replace('\n','')
	return property_dict


def add_wizard(interface_obj):
	node_names = add_nodes_wizard_prompt(interface_obj)
	node_labels = add_node_labels_wizard_prompt(interface_obj)
	node_properties = add_node_properties_wizard_prompt(interface_obj)
	
	# Add meta to properties - TODO: move this somewhere
	now_string = time.strftime("%Y-%m-%d %H:%M:%S")
	for meta_key,meta_value in interface_obj.my_session.default_node_meta.iteritems():
		if (meta_value == 'datetime'):
			meta_value = now_string
		elif (meta_value == 'username'):
			meta_value = interface_obj.my_session.my_user.username
		node_properties[meta_key] = meta_value
	
	for node_dict in node_names:
		node_addition = interface_obj.my_session.my_db.create_node_from_dict(node_dict)
		interface_obj.my_session.my_db.set_node_labels(node_addition, node_labels)		
		interface_obj.my_session.my_db.set_node_properties(node_addition, node_properties)
	# TODO - provide feedback about what was / was not added	


#
# Add wizard - prompt user for appropriate inputs
#
def add_wizard_old(interface_obj):

	node_set = set()

	# Determine name/value (primary/unique identification)
	interface_obj.stdout.write("Node/Object primary, unique name or value: ")
	object_val = (interface_obj.stdin.readline()).replace('\n','')
	node_dict = {'name':object_val}
	node_set.add(node_dict)
	while True:
			interface_obj.stdout.write("  Add another node/object that will have same labels/properties (Enter for none): ")
			object_val = (interface_obj.stdin.readline()).replace('\n','')
			if object_val:
				node_dict = {'name':object_val}
				node_set.add(node_dict)
			else:
				break
		
	# Ask for and get object type(s)
	# TODO - loop for handling multiple object type/category/tag labels
	object_type_set = set()
	while True:
		interface_obj.stdout.write("Object Type/Category/Tag ('?' will list existing, Enter for no more): ")
		object_type = (interface_obj.stdin.readline()).replace('\n','')
		# On-the-fly support for listing existing object labels
		if not object_type:
			break
		elif object_type == "?":
			object_types = interface_obj.my_session.my_db.get_all_labels()
			# TODO - sort by alpha and allow "? chars" to search by chars
			interface_obj.stdout.write(repr(object_types) + "\n")
		else:
			#interface_obj.stdout.write("[DEBUG] Setting node type to %s\n" % object_type)
			object_type_set.add(object_type)
			#node_dict['type'] = object_type
		

	# Ask for and get properties
	property_dict = {}
	interface_obj.stdout.write("Property Key (return for none): ")
	property_key = (interface_obj.stdin.readline()).replace('\n','')
	while (property_key != ""):
		interface_obj.stdout.write(property_key + " Value: ")
		property_value = (interface_obj.stdin.readline()).replace('\n','')
		property_dict[property_key] = property_value		
	
		interface_obj.stdout.write("Property Key (return for none): ")      
		property_key = (interface_obj.stdin.readline()).replace('\n','')

	# TODO - normalization (e.g., strip, lowercase) based on values (e.g., MD5, domain, etc.)
	# verify_and_normalize_values(object_val, object_type_set, property_dict) 		
	
	# Get or Create Node
	node_addition = interface_obj.my_session.my_db.create_node_from_dict(node_dict)

	# Add type/category (labels in neo4j 2.x)
	interface_obj.my_session.my_db.set_node_labels(node_addition, object_type_set)		

	# Set properties
	# TODO - set default poortego properties from dispathcer_object.my_session.default_node_meta
		# TODO - updating if node already exists vs over-writing	
	now_string = time.strftime("%Y-%m-%d %H:%M:%S")
	for meta_key,meta_value in interface_obj.my_session.default_node_meta.iteritems():
		if (meta_value == 'datetime'):
			meta_value = now_string
		elif (meta_value == 'username'):
			meta_value = interface_obj.my_session.my_user.username
		property_dict[meta_key] = meta_value
	interface_obj.my_session.my_db.set_node_properties(node_addition, property_dict)

	# TODO - create default linkage(s) - such as from current node
	# TBD - do we want to link all objects to the ROOT node or not, like this:

	# TODO - make default linkage either an option or something set in conf
	# Note: this was moved to the create_node_from_dict() method
	#new_node_root_path = interface_obj.my_session.my_db.poortego_root_node.get_or_create_path(object_type, node_addition)

	# TODO: auto-creation of implied nodes if appropriate, e.g., URL -> FQDN -> Domain
	# create_implied_nodes(object_val, object_type_set, property_dict)	
		
	# TODO: Feedback/Confirmation: you are adding ..this.., are you sure?
	# TODO: standard response - node added with id#	
	# TODO: Logging / debug
	interface_obj.stdout.write("You added '" + object_val + "' of type '" + str(object_type_set) + "'\n")


