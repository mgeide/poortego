# poortego_neo4j_database.py

#
# Poortego Database override to support Neo4j graph database
#

from poortego_database import PoortegoDatabase
from py2neo import neo4j, node, rel

class PoortegoNeo4jDatabase(PoortegoDatabase):
        """Class for managing poortego neo4j database inherited from PoortegoDatabase"""
        def __init__(self, conf_settings):
                """Constructor, setup neo4j graph database connection"""
                self.db_type = "neo4j"
		self.conf_settings = conf_settings
                self.db_conn = neo4j.GraphDatabaseService(str(self.conf_settings['neo4j_uri']))
                self.set_database_defaults()

        def set_database_defaults(self):
                """Setup default values"""
                node_name_index = self.db_conn.get_or_create_index(neo4j.Node, "Name")
                self.poortego_root_node = self.db_conn.get_or_create_indexed_node("Name", "name", "Poortego Root", {'name':'Poortego Root', 'type':'ROOT'})

        def get_database_info(self):
                """Return dict containing database info"""
                db_info = {}
                db_info["neo4j version"] = str(self.db_conn.neo4j_version)
                db_info["Node count"] = str(self.db_conn.order)
                db_info["Relationship count"] = str(self.db_conn.size)
                db_info["Supports Index Uniqueness Modes"] = str(self.db_conn.supports_index_uniqueness_modes)
                db_info["Supports Node Labels"] = str(self.db_conn.supports_node_labels)
                db_info["Supports Schema Indexes"] = str(self.db_conn.supports_schema_indexes)
                return db_info

        def PURGE(self):
                """Delete everything from GraphDB -be sure you want to do this"""
                self.db_conn.clear()

        def show_types(self):
                """Show node types"""
                node_types = set()
                rels = list(self.db_conn.match(start_node=self.poortego_root_node))
                for rel in rels:
                        if "type" in rel.end_node:
                                node_types.add(rel.end_node["type"])
                for t in sorted(set(node_types)):
                        print t


        def show_nodes_to(self, end_node_id):
                """Show nodes connected to end_node_id"""
                end_node_obj = self.db_conn.node(end_node_id)
                rels = list(self.db_conn.match(end_node=end_node_obj))
                for rel in rels:
                        if "name" in rel.start_node:
                                if "type" in rel.start_node:
                                        print str(rel.start_node._id) + ": " + str(rel.start_node["name"]) + "   [" + str(rel.start_node["type"]) + "]"


        def show_nodes_from(self, start_node_id):
                """Show nodes connected from start_node_id"""
                start_node_obj = self.db_conn.node(start_node_id)
                rels = list(self.db_conn.match(start_node=start_node_obj))
                for rel in rels:
                        if "name" in rel.end_node:
                                if "type" in rel.end_node:
                                        print str(rel.end_node._id) + ": " + str(rel.end_node["name"]) + "   [" + str(rel.end_node["type"]) + "]"


        def get_nodes_by_property(self, prop="name"):
                """Return node dictionary {id=>property value} for all nodes having the property key"""
                nodes = {} # id => property value
                rels = list(self.db_conn.match())
                for rel in rels:
                        if prop in rel.start_node:
                                nodes[rel.start_node._id] = rel.start_node[prop]
                        if prop in rel.end_node:
                                nodes[rel.end_node._id] = rel.end_node[prop]
                return nodes



        def get_all_rels(self):
                """Return all relationships as dictionary {id=>relationship string representation}"""
                ret_rels = {} # id => relationship as string
                rels = list(self.db_conn.match())
                for rel in rels:
                        ret_rels[rel._id] = str(rel)
                return ret_rels

        def get_node_by_id(self, id_num):
                node = self.db_conn.node(id_num)
                node_dict = {'id':id_num, 'name':node['name']}
                return node_dict

        def create_node_from_dict(self, node_dict):
                """Create and return node from dictionary containing node properties"""
                ## Old shit ##
                #graph_node = self.db_conn.create(node_dict)
                #self.create_rel(self.db_conn.node(0), graph_node['type'], graph_node, {})
                #return graph_node
                ##############

                #TODO: check for name/type within dict
                # Create New Node
                new_node = self.db_conn.get_or_create_indexed_node("NameIdx", "name", node_dict['name'], node_dict)
                # Create Default Paths tying Node to root
                from_root_path = self.poortego_root_node.get_or_create_path(node_dict['type'], new_node)
                to_root_path = self.new_node.get_or_create_path("ROOT", self.poortego_root_node)
                return new_node

        def create_rel(self, graph_start_node, graph_end_node, rel_type, rel_prop_dict):
                """Create and return relationship"""
                graph_rel = self.db_conn.create((graph_start_node, rel_type, graph_end_node, rel_prop_dict))
                return graph_rel

