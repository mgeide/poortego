# pwd.py

#
# Module poortego.command.pwd
#

def poortego_pwd(dispatcher_object, args):
	"""Command to print current working data (node)"""
	# TODO
	#dispatcher_object.stdout.write("Command not yet implemented.\n")
	node = dispatcher_object.my_graph.get_node_by_id(dispatcher_object.my_session.current_node_id)
	node_str = dispatcher_object.my_graph.display_node(node)
	dispatcher_object.stdout.write("Representation of current node:\n%s\n" % node_str)

