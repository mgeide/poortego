# poortego_crits_database.py

#
# Poortego Database override to support CRITs mongo database
#

import pymongo
from ...data_types.node import PoortegoNode
from ...data_types.link import PoortegoLink

class CritsDatabase:
        """Class for managing poortego crits database"""
        def __init__(self, conf_settings):
                """Constructor, setup CRITs mongodb connection"""
                self.conf_settings = conf_settings
                self.db_type = "crits"
                self.db_conn = pymongo.MongoClient(str(self.conf_settings['mongo_uri']))
                self.db_conn = self.db_conn["crits"]
                if self.conf_settings['mongo_user']:
			self.db_conn.authenticate(str(self.conf_settings['mongo_user']), str(self.conf_settings['mongo_password']))
                self.set_database_defaults()
                self.CRITs_mappings()

        def _crits_result_to_poortego_node(self, result_dict):
		p_node = PoortegoNode()
		p_node.id = result_dict["_id"]
                p_node.name = result_dict["value"]
                p_node.labels.add( self.crits_type_mapping[ result_dict["type"] ] )
		property_dict = dict()
		property_keys = [ "campaign", "confidence", "created", "impact", "modified", "source" ]
		for property_key in property_keys:
   			property_dict[property_key] = result_dict[property_key]
		p_node.properties = property_dict
		return p_node


        def CRITs_mappings(self):
                """Define mapping from poortego to CRITs"""
                self.crits_type_mapping = {}
                self.crits_type_mapping["DOMAIN"] = "URI - Domain Name"
                self.crits_type_mapping["URI - Domain Name"] = "DOMAIN"
                self.crits_type_mapping["IP"] = "Address - ipv4-addr"
                self.crits_type_mapping["Address - ipv4-addr"] = "IP"

        def set_database_defaults(self):
                """Setup default values"""
		dummy_root = PoortegoNode()
		dummy_root.id = 0
		dummy_root.labels.add("ROOT")
                self.poortego_root_node = dummy_root # TODO - set this

        def get_db_info(self):
                """Return info dictionary about the database"""
                db_info = {}
                db_info["Mongo Server Info"] = self.db_conn.server_info()
                return db_info

	def get_node_by_id(self, id_num):
		indicator_collection = self.db_conn["indicators"]
		query_string = 'ObjectId("' + str(id_num) + '")'
                print("[DEBUG] mongo query string: %s\n" %query_string)
                result = indicator_collection.find({"_id" : query_string})
                return self._crits_result_to_poortego_node(result)


        # find -t "domain" -v "test.com"
        def find_nodes(self, query_dict):
                """Return node dictionary from query"""
                #item_type = query_options["type"].upper()
                #if self.crits_type_mapping[item_type]:
                #        item_type = self.crits_type_mapping[item_type]
                value_str = query_dict["value"]
                indicator_collection = self.db_conn["indicators"]
                results = indicator_collection.find({"value" : value_str})
		p_results = list()
		for result in results:
			p_results.append( self._crits_result_to_poortego_node(result) )	
                return p_results


        # related_to -t "domain" -v "test.com"
        def relations_to(self, end_node):
                """Return nodes related to end_node"""


        # related_to -t "domain" -v "test.com"
        def relations_from(self, start_node):
                """Return nodes related from start_node"""
