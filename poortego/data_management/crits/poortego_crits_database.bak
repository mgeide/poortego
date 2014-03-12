# poortego_crits_database.py

#
# Poortego Database override to support CRITs mongo database
#

from poortego_database import PoortegoDatabase
import pymongo

class PoortegoCRITsDatabase(PoortegoDatabase):
        """Class for managing poortego crits database inherited from PoortegoDatabase"""
        def __init__(self, conf_settings):
                """Constructor, setup CRITs mongodb connection"""
                self.conf_settings = conf_settings
                self.db_type = "crits"
                self.db_conn = pymongo.MongoClient(str(self.conf_settings['mongo_uri']))
                self.db_conn = self.db_conn["crits"]
                self.set_database_defaults()
                self.CRITs_mappings()

        def CRITs_mappings(self):
                """Define mapping from poortego to CRITs"""
                self.crits_type_mapping = {}
                self.crits_type_mapping["DOMAIN"] = "URI - Domain Name"

        def set_database_defaults(self):
                """Setup default values"""
                self.poortego_root_node = None # TODO - set this

        def get_database_info(self):
                """Return info dictionary about the database"""
                db_info = {}
                db_info["Mongo Server Info"] = self.db_conn.server_info()

                return db_info

        # find -t "domain" -v "test.com"
        def find_items(self, query_options):
                """Return node dictionary from query"""
                item_type = query_options["type"].upper()
                if self.crits_type_mapping[item_type]:
                        item_type = self.crits_type_mapping[item_type]
                value_str = query_options["value"]
                indicator_collection = self.db_conn["indicators"]
                results = indicator_collection.find({"value" : value_str})
                return results

        # related_to -t "domain" -v "test.com"
        def relations_to(self, end_node):
                """Return nodes related to end_node"""


        # related_to -t "domain" -v "test.com"
        def relations_from(self, start_node):
                """Return nodes related from start_node"""
