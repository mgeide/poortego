# ls.py

#
# Module poortego.command.ls
#

def poortego_ls(interface_obj, arg, opts):
	"""Command to list objects"""
	nodes_from = list()
	nodes_to = list()
	
	if opts.all_nodes:
		nodes_from = interface_obj.my_session.my_db.get_nodes_from(interface_obj.my_session.my_db.root_node._id)
	elif opts.bi:
		nodes_from = interface_obj.my_session.my_db.get_nodes_from(interface_obj.my_session.current_node_id)
		nodes_to = interface_obj.my_session.my_db.get_nodes_to(interface_obj.my_session.current_node_id)		
	elif opts.from_nodes:
		nodes_from = interface_obj.my_session.my_db.get_nodes_from(interface_obj.my_session.current_node_id)
	elif opts.to_nodes:
		nodes_to = interface_obj.my_session.my_db.get_nodes_to(interface_obj.my_session.current_node_id)            
	else: # Default, same as "--bi"
		nodes_from = interface_obj.my_session.my_db.get_nodes_from(interface_obj.my_session.current_node_id)
		nodes_to = interface_obj.my_session.my_db.get_nodes_to(interface_obj.my_session.current_node_id)
	
	interface_obj.stdout.write("Output format: 'id: name  [type]'\n")
	if nodes_from:
		interface_obj.stdout.write("\nNodes From Current:\n")
		interface_obj.display_nodes_summary(nodes_from)
	if nodes_to:
		interface_obj.stdout.write("\nNodes To Current:\n")
		interface_obj.display_nodes_summary(nodes_to)
	interface_obj.stdout.write("\n")