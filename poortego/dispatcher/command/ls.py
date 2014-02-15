# ls.py

#
# Module poortego.command.ls
#

def poortego_ls(dispatcher_object, args, opts):
	"""Command to list objects"""
	dispatcher_object.stdout.write("Output format: '[id] name  [type]'\n")
	if opts.all_nodes:
		dispatcher_object.my_graph.show_nodes_from(dispatcher_object.my_graph.poortego_root_node._id)
	elif opts.bi:
		dispatcher_object.stdout.write("\nNodes From Current:\n")
		dispatcher_object.my_graph.show_nodes_from(dispatcher_object.my_session.current_node_id)
		dispatcher_object.stdout.write("\nNodes To Current:\n")
		dispatcher_object.my_graph.show_nodes_to(dispatcher_object.my_session.current_node_id)		
		dispatcher_object.stdout.write("\n")
	elif opts.from_nodes:
		dispatcher_object.stdout.write("\nNodes From Current:\n")
		dispatcher_object.my_graph.show_nodes_from(dispatcher_object.my_session.current_node_id)
		dispatcher_object.stdout.write("\n")
	elif opts.to_nodes:
		dispatcher_object.stdout.write("\nNodes To Current:\n")
		dispatcher_object.my_graph.show_nodes_to(dispatcher_object.my_session.current_node_id)            
		dispatcher_object.stdout.write("\n")
	else: # Default, same as "--bi"
		dispatcher_object.stdout.write("\nNodes From Current:\n")
		dispatcher_object.my_graph.show_nodes_from(dispatcher_object.my_session.current_node_id)
		dispatcher_object.stdout.write("\nNodes To Current:\n")
		dispatcher_object.my_graph.show_nodes_to(dispatcher_object.my_session.current_node_id)		
		dispatcher_object.stdout.write("\n")

