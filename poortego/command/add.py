# add.py

#
# Module poortego.command.add
#

def poortego_add(dispatcher_object, args, opts):
	if opts.prompt:
		dispatcher_object.stdout.write("Name: ")
		name_string = (dispatcher_object.stdin.readline()).replace('\n','')
		dispatcher_object.stdout.write("Type: ")
		type_string = (dispatcher_object.stdin.readline()).replace('\n','')
		node_dict = {'name':name_string, 'type':type_string}
		dispatcher_object.my_graph.create_node_from_dict(node_dict)  
		dispatcher_object.stdout.write("You added '" + name_string + "' of type '" + type_string + "'\n")


