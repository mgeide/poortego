# cd.py

#
# Module poortego.command.cd
#

def poortego_cd(dispatcher_object, args):
	"""Command to change focus"""
	# TODO
	dispatcher_object.my_session.current_node_id = args
	dispatcher_object.stdout.write("Current node changed to: %s\n" % str(dispatcher_object.my_session.current_node_id))
