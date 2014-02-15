# reset.py

#
# Module poortego.command.reset
#


from ...session import Session
from ...database.poortego_neo4j_database import PoortegoNeo4jDatabase


def poortego_reset(dispatcher_object, args):
	"""Command to link objects"""
	#dispatcher_object.my_graph = Graph(dispatcher_object.conf_settings)
	dispatcher_object.my_graph = PoortegoNeo4jDatabase(dispatcher_object.conf_settings)
	dispatcher_object.my_session = Session(dispatcher_object.conf_settings)
	dispatcher_object.my_session.set_default_nodes(dispatcher_object.my_graph.root_id())
	dispatcher_object.my_graph.set_database_defaults()
	dispatcher_object.my_session.current_node_id = dispatcher_object.my_graph.poortego_root_node._id
