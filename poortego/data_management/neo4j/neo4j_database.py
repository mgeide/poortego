# poortego_neo4j_database.py

#
# Poortego Database override to support Neo4j graph database
#

from py2neo import neo4j, node, rel
from ...data_types.node import PoortegoNode
from ...data_types.link import PoortegoLink

class Neo4jDatabase:
    """Class for managing poortego neo4j database inherited from PoortegoDatabase"""
    def __init__(self, conf_settings):
        """Constructor, setup neo4j graph database connection"""
        self.conf_settings = conf_settings
        self.db_conn = neo4j.GraphDatabaseService(str(self.conf_settings['neo4j_uri']))
        self.indexes = list()
        self.set_database_defaults()
        
    def set_database_defaults(self):
        """Setup default values"""
        self.indexes.append( self.db_conn.get_or_create_index(neo4j.Node, "NameIdx") )
        self.neo4j_root_node = self.db_conn.get_or_create_indexed_node("NameIdx", "name", "Poortego Root", {'name':'Poortego Root', 'type':'ROOT'})
        self.poortego_root_node = self._neo4j_node_to_poortego_node(self.neo4j_root_node)

    def get_db_info(self):
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

    def _neo4j_node_to_poortego_node(self, neo4j_node):
        p_node = PoortegoNode()
        p_node.id = neo4j_node._id
        p_node.set_value(neo4j_node["name"], neo4j_node.get_labels(), neo4j_node.get_properties())
        return p_node        

    def _neo4j_link_to_poortego_link(self, neo4j_link):
        p_link = PoortegoLink()
        p_link.id = neo4j_link._id
        p_link.name = neo4j_link.type
        p_link.start_node = self._neo4j_node_to_poortego_node(neo4j_link.start_node)
        p_link.end_node = self._neo4j_node_to_poortego_node(neo4j_link.end_node)
        p_link.properties = neo4j_link.get_properties()
        return p_link

    def _poortego_node_to_neo4j_node(self, p_node):
        if p_node.id > 0:
            return self.db_conn.node(p_node.id)
        elif p_node.name:
            return self.db_conn.get_indexed_node("NameIdx", "name", p_node.name)
        else:
            return None
        
    def _poortego_link_to_neo4j_link(self, p_link):
        if p_link.id > 0:
            return self.db_conn.relationship(p_link.id)
        else:
            # Get from start/end node
            neo4j_start_node = self._poortego_node_to_neo4j_node(p_link.start_node)
            neo4j_end_node = self._poortego_node_to_neo4j_node(p_link.end_node)
            neo4j_rel = self.db_conn.match_one(start_node=neo4j_start_node, end_node=neo4j_end_node)
            return neo4j_rel
    
    def get_all_labels(self):
        return self.db_conn.node_labels

    def set_node_labels(self, p_node, labels):
        neo4j_node = self._poortego_node_to_neo4j_node(p_node)
        neo4j_node.add_labels(*labels)
        #for label in labels:
        #    neo4j_node.add_labels(label)

    def set_node_properties(self, p_node, prop_dict):
        neo4j_node = self._poortego_node_to_neo4j_node(p_node)
        neo4j_node.update_properties(prop_dict)

    def get_node_by_id(self, id_num):
        neo4j_node = self.db_conn.node(id_num)       
        p_node = self._neo4j_node_to_poortego_node(neo4j_node)
        return p_node

    def get_node_by_name(self, name_str):
        neo4j_node = self.db_conn.get_indexed_node("NameIdx", "name", name_str)
        p_node = self._neo4j_node_to_poortego_node(neo4j_node)
        return p_node
    
    def get_nodes_to(self, end_node_id):
        """Show nodes connected to end_node_id"""
        p_nodes = list()
        end_node_obj = self.db_conn.node(end_node_id)
        rels = list(self.db_conn.match(end_node=end_node_obj))
        for rel in rels:
            neo4j_node = rel.start_node
            p_nodes.append(self._neo4j_node_to_poortego_node(neo4j_node))
        return p_nodes

    def get_nodes_from(self, start_node_id):
        """Show nodes connected from start_node_id"""
        p_nodes = list()
        start_node_obj = self.db_conn.node(start_node_id)
        rels = list(self.db_conn.match(start_node=start_node_obj))
        for rel in rels:
            neo4j_node = rel.end_node
            p_nodes.append(self._neo4j_node_to_poortego_node(neo4j_node))
        return p_nodes
    
    def add_nodes(self, poortego_nodes):
        """Add PoortegoNodes to database"""
        added_list = list()
        for poortego_node in poortego_nodes:
            new_neo4j_node = self.db_conn.get_or_create_indexed_node("NameIdx", "name", poortego_node.name, poortego_node.to_dict())
            new_neo4j_node.add_labels(*poortego_node.labels)
            #new_neo4j_node.update_properties(poortego_node.properties) # do by having properties in poortego_node dict
            self._link_node_to_root(new_neo4j_node)
            poortego_node_result = self._neo4j_node_to_poortego_node(new_neo4j_node)
            added_list.append(poortego_node_result)
        return added_list
    
    def _link_node_to_root(self, new_neo4j_node):
        from_root_path = self.neo4j_root_node.get_or_create_path("ROOT", new_neo4j_node)
        to_root_path = new_neo4j_node.get_or_create_path("ROOT", self.neo4j_root_node)
    
    def create_node_from_dict(self, node_dict):
        new_node = self.db_conn.get_or_create_indexed_node("NameIdx", "name", node_dict['name'], node_dict)
        # Create Default Paths tying Node to root
        self._link_node_to_root(new_node)
        p_node = self._neo4j_node_to_poortego_node(new_node)
        return p_node
    
    def add_links(self, poortego_links):
        added_list = list()
        for poortego_link in poortego_links:
            added_list.append(self.create_link(poortego_link.start_node, 
                                               poortego_link.end_node, 
                                               poortego_link.name, 
                                               poortego_link.properties))
        return added_list
    
    
    def create_link(self, start_node, end_node, link_name, prop_dict):
        neo4j_start_node = self._poortego_node_to_neo4j_node(start_node)
        neo4j_end_node = self._poortego_node_to_neo4j_node(end_node)
        neo4j_link, = self.db_conn.create((neo4j_start_node, link_name, neo4j_end_node, prop_dict))
        poortego_link = self._neo4j_link_to_poortego_link(neo4j_link)
        return poortego_link 