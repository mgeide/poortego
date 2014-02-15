# session.py

#
# Module poortego.command.session
#

def poortego_session(dispatcher_object, arg, opts):
	"""Command to link objects"""
	# TODO
	if opts.list_details:
		dispatcher_object.my_session.display()
