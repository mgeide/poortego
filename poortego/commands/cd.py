# cd.py

#
# Module poortego.command.cd
#

def poortego_cd(interface_obj, arg):
	"""Command to change focus"""
	# TODO
	interface_obj.my_session.current_node_id = arg
	interface_obj.stdout.write("Current node changed to: %s\n" % str(interface_obj.my_session.current_node_id))
