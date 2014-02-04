# add.py

#
# Module poortego.command.add
#

def poortego_add(dispatcher_object, args, opts):
	if opts.prompt: # DEFAULT option too

		# Ask for and get object name/value (primary/unique identification)
		dispatcher_object.stdout.write("Object Name or Value: ")
		object_val = (dispatcher_object.stdin.readline()).replace('\n','')
		node_dict = {'name':object_val}
		
		# Ask for and get object type(s)
		# TODO - loop for handling multiple object type/category/tag labels
		object_type_set = []
		while True:
			dispatcher_object.stdout.write("Object Type/Category/Tag ('?' will list existing): ")
			object_type = (dispatcher_object.stdin.readline()).replace('\n','')
			# On-the-fly support for listing existing object labels
			if (object_type != "?"):
				object_type_set.add(object_type)
				break
			object_types = dispatcher_object.my_graph.node_labels()
			# TODO - sort by alpha and allow "? chars" to search by chars
			dispatcher_object.stdout.write(repr(object_types) + "\n")

		# Ask for and get properties
		property_dict = {}
		dispatcher_object.stdout.write("Property Key (return for none): ")
		property_key = (dispatcher_object.stdin.readline()).replace('\n','')
		while (property_key != ""):
			dispatcher_object.stdout.write(property_key + " Value: ")
			property_value = (dispatcher_object.stdin.readline()).replace('\n','')
			property_dict[property_key] = property_value		
	
			dispatcher_object.stdout.write("Property Key (return for none): ")      
			property_key = (dispatcher_object.stdin.readline()).replace('\n','')

		# TODO - normalization (e.g., strip, lowercase) based on values (e.g., MD5, domain, etc.)
		# verify_and_normalize_values(object_val, object_type_set, property_dict) 		
	
		# Get or Create Node
		node_addition = dispatcher_object.my_graph.get_or_create_indexed_node("NameIdx", "name", node_dict['name'], node_dict)

		# Add type/category (labels in neo4j 2.x)
		for object_type in object_type_set:
			dispatcher_object.my_graph.add_labels(node_addition, object_type)		

		# Loop thru and set properties
		# TODO - set default poortego properties from dispathcer_object.my_session.default_node_meta
		for k, v in property_dict.iteritems():
			dispatcher_object.my_graph.set_property(node_addition, k, v)

		# TODO - create default linkage(s) - such as from current node
		# TBD - do we want to link all objects to the ROOT node or not, like this:
		# TODO - make default linkage either an option or something set in conf
		new_node_root_path = dispatcher_object.my_graph.poortego_root_node.get_or_create_path(object_type, node_addition)

		# TODO: auto-creation of implied nodes if appropriate, e.g., URL -> FQDN -> Domain
		# create_implied_nodes(object_val, object_type_set, property_dict)	
		
		# TODO: Feedback/Confirmation: you are adding ..this.., are you sure?
		# TODO: standard response - node added with id#	
		# TODO: Logging / debug
		# dispatcher_object.stdout.write("You added '" + name_string + "' of type '" + type_string + "'\n")
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
		dispatcher_object.stdout.write("ERROR- no option provided")

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

#
# Debug - unit testing
#
if __name__ == "__main__":
	# TODO
	print "TODO - any local unit testing"
