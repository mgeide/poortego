# purge.py

#
# Module poortego.command.purge
#

def poortego_purge(dispatcher_object, args):
	"""Command to delete all objects from db"""
	dispatcher_object.stdout.write("This will delete EVERYTHING from the GraphDB!!! Are you sure you want to do this [Y/N]: ")
	response = (dispatcher_object.stdin.readline()).replace('\n','')
	if response == 'Y' or response == 'y':
		dispatcher_object.my_graph.PURGE()
		dispatcher_object.stdout.write("Database purged.\n")
		dispatcher_object.do_poortego_reinitialize('')
		dispatcher_object.stdout.write("Poortego ReInitialized.\n")


