# storage.py

#
# Module poortego.command.storage
#

def poortego_storage(dispatcher_object, arg, opts):
	"""Command to show/manipulate storate"""
	# TODO
	if opts.list_details:
                my_graph_info = dispatcher_object.my_graph.database_info()
                for k, v in my_graph_info.iteritems():
                        dispatcher_object.stdout.write(str(k) + " : " + str(v) + "\n")

