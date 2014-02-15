# namespace.py

#
# Module poortego.command.namespace
#

def poortego_namespace(dispatcher_object, args, opts):
	"""Command to manipulate namespace"""
	if opts.list_namespaces:
		for ns in dispatcher_object.namespaces:
			dispatcher_object.stdout.write("%s\n" % ns)
	elif opts.change_namespace:
		dispatcher_object.namespace = opts.change_namespace
	elif opts.print_namespace:
		dispatcher_object.stdout.write("Current namespace: %s\n" % dispatcher_object.namespace)


