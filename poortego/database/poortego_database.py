# poortego_database.py

# 
# Base class implementation of high-level poortego storage attributes/methods
# Override using specific database implementation, accounting for all expected attributes/methods here
#

class PoortegoDatabase:
        """Base class for managing any database leveraged by poortego -- override all of these"""
        def __init__(self, conf_settings):
                """Constructor, setup database connection"""
                self.conf_settings = conf_settings      # Dictionary containing settings
                self.db_type = str(self.conf_settings["db_type"])
                self.db_conn = None                     # This should be set to the datbase connector
                self.poortego_root_node = None          # Set this in the set_database_defaults() method
                self.set_database_defaults()

        def set_database_defaults(self):
                """Setup default indices, ensure root node exists, and point to it"""
                self.poortego_root_node = None          # Point to root node

        def database_info(self):
                """Return dict containing database info"""
                db_info = {}
                return db_info

	def get_nodes(self, query_dicts):
		"""Find node if exists given the query dict values, return set of node dict results"""
		"""Example query_dicts:
		
		"""
		results = [{}]
		return results
		 

	def create_nodes(self, node_dicts):
		"""Add nodes into database given the set of dict values, return set of nodes dict added"""
		"""Example node_dict:
		node_dicts = [
				{ 	"name" : "localhost.local", 
					"type" : "DOMAIN", 
					"properties" : {
						"property_key1" : "property_value1",
						"property_key2" : "property_value2"
						}
				},
				{	"name" : "127.0.0.1",
					"type" : "IPv4",
					"properties" : {
						"description" : "RFC1918 IP Address"
					}
				}	
			]
		"""
		results = [{}]
		return results

	def remove_nodes(self, node_dicts):
		"""Remove nodes into database given the set of dict values, return the set of nodes dict removed"""
		results = [{}]
		return results

	def update_nodes(self, node_dicts):
		"""Update nodes given the set of dict values, return the set of nodes dict updated"""
		results = [{}]
		return results

	def upsert_nodes(self, node_dicts):
		"""Insert or update nodes, return set of nodes upserted"""
		results = [{}]
		return results	
	
		 
