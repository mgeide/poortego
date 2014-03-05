# session.py

#
# Module poortego.command.session
#

def poortego_session(interface_obj, arg, opts):
	# TODO
	if opts.list_details:
		interface_obj.my_session.display()
