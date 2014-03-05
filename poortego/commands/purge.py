# purge.py

#
# Module poortego.command.purge
#

def poortego_purge(interface_obj, arg):
	"""Command to delete all objects from db"""
	interface_obj.stdout.write("This will delete EVERYTHING from the GraphDB!!! Are you sure you want to do this [Y/N]: ")
	response = (interface_obj.stdin.readline()).replace('\n','')
	if response == 'Y' or response == 'y':
		interface_obj.my_session.my_db.PURGE()
		interface_obj.stdout.write("Database purged.\n")
		# TODO - fix below
		#interface_obj.do_poortego_reinitialize('')
		#interface_obj.stdout.write("Poortego ReInitialized.\n")


