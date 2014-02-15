# cd.py

#
# Module poortego.command.cd
#

def poortego_cd(dispatcher_object, args):
	"""Command to change focus"""
	# TODO
	dispatcher_object.my_session.current_node_id = args[0]
	dispatcher_object.stdout.write("Command not yet implemented.\n")
