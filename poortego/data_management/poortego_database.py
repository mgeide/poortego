# poortego_database.py

import importlib
from ..data_types.node import PoortegoNode
from ..data_types.link import PoortegoLink

class PoortegoDatabase:
    def __init__(self, conf_obj):
        """Constructor, setup database connection"""
        self.conf_settings = conf_obj.conf_settings      # Dictionary containing settings
        self.db_type = str(self.conf_settings["db_type"]).strip().lower()
        self.db_conn = None                     # This should be set to the datbase connector
        self.poortego_root_node = None          # Set this in the set_database_defaults() method
        self._setup_database()
        
    def _setup_database(self):
        """Direct database handling based on the db_type set in settings"""
        mod_name = 'poortego.data_management.' + self.db_type + '.' + self.db_type + '_database'
        class_name = self.db_type.capitalize() + 'Database'
        print "[DEBUGing this] Trying to load module: %s\n" % mod_name
        db_module = importlib.import_module(mod_name)
        db_class = getattr(db_module, class_name)
        db_obj = db_class(self.conf_settings)
        
        self.db_conn = db_obj
        self.poortego_root_node = db_obj.poortego_root_node
        
    def get_db_info(self):
        """Return dict of database info - key/value"""
        return self.db_conn.get_db_info()

    def PURGE(self):
        """Delete everything from database"""
        self.db_conn.PURGE()

    def get_node_by_id(self, id_num):
        """Return PoortegoNode of database node with id=id_num"""
        return self.db_conn.get_node_by_id(int(id_num))

    def get_node_by_name(self, name_str):
        return self.db_conn.get_node_by_name(name_str)  

    def get_all_labels(self):
        """Return all labels used in current database"""
        return self.db_conn.get_all_labels()

    def get_nodes_from(self, start_node_id):
        """Return list of PoortegoNodes connected from the start_node_id"""
        return self.db_conn.get_nodes_from(start_node_id)
    
    def get_nodes_to(self, end_node_id):
        """Return list of PoortegoNodes connected to the end_node_id"""
        return self.db_conn.get_nodes_to(end_node_id)
    
    def create_node_from_dict(self, node_dict):
        """Create node in database from dict - return PoortegoNode"""
        node_addition = self.db_conn.create_node_from_dict(node_dict)
        return node_addition

    def set_node_labels(self, p_node, labels):
        """Create/update labels for node"""
        self.db_conn.set_node_labels(p_node, labels)

    def set_node_properties(self, p_node, prop_dict):
        """Create/update properties for node"""
        self.db_conn.set_node_properties(p_node, prop_dict)
        
    def create_link(self, start_node, end_node, link_name, prop_dict):
        """Create link in database from parameters - return PoortegoLink"""
        link_addition = self.db_conn.create_link(start_node, end_node, link_name, prop_dict)
        return link_addition