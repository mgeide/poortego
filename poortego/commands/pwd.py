# pwd.py

#
# Module poortego.command.pwd
#

def poortego_pwd(interface_obj, arg):
	"""Command to print current working data (node)"""
	# TODO
	#dispatcher_object.stdout.write("Command not yet implemented.\n")
	node_obj = interface_obj.my_session.my_db.get_node_by_id(interface_obj.my_session.current_node_id)
	#node_str = interface_obj.my_session.my_db.display_node(node)
	interface_obj.stdout.write("Representation of current node:\n%s\n" % node_obj.to_str())
	#interface_obj.stdout.write("Representation of current node:\n%s\n" % node_str)

