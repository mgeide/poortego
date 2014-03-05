# storage.py

#
# Module poortego.command.storage
#

def poortego_storage(interface_obj, arg, opts):
	"""Command to show/manipulate storate"""
	# TODO
	if opts.list_details:
		my_db_info = interface_obj.my_session.my_db.get_db_info()
		for k, v in my_db_info.iteritems():
			interface_obj.stdout.write(str(k) + " : " + str(v) + "\n")
	else:
		interface_obj.stdout.write("Option not yet implemented.\n")

