# graph.py

#
# Poortego Graph
#  - Methods for accessing GraphDB
# 

###
# Good neo4j-Python References:
# - http://book.py2neo.org/en/latest/graphs_nodes_relationships/#nodes-relationships
# - http://blog.safaribooksonline.com/2013/07/23/using-neo4j-from-python/
# - http://blog.safaribooksonline.com/2013/08/07/managing-uniqueness-with-py2neo/
###

from py2neo import neo4j, node, rel

graph_db = neo4j.GraphDatabaseService()

# Wipe out graph
graph_db.clear()

# Create ROOT node
node_name_index = graph_db.get_or_create_index(neo4j.Node, "Name")
poortego_root_node = graph_db.get_or_create_indexed_node("Name", "name", "Poortego Root", {'name':'Poortego Root'})
print "[DEBUG] Poortego Root Node: "
print poortego_root_node

# TODO - Poortego session: current_working_node = poortego_root_node

# Create New Node
node_dict = {'name':'Mike Geide', 'type':'Person'}
new_node = graph_db.get_or_create_indexed_node("Name", "name", node_dict['name'], node_dict)
print "[DEBUG] New Node: "
print new_node

# Create Default Path from Root to New Node
new_node_root_path = poortego_root_node.get_or_create_path(node_dict['type'], new_node)
print "[DEBUG] New Node Root Path: "
print new_node_root_path

# TODO - play with labels
# TODO - play with adding properties
# TODO - play with searching

#graph_node = graph_db.create(node_dict)
#graph_db.create((graph_db.node(0), graph_node['type'], graph_node, {}))

print "Graph DB Match output:"
print graph_db.match()
rels = list(graph_db.match())
print rels
