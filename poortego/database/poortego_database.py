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

        def get_database_info(self):
                """Return dict containing database info"""
                db_info = {}
                return db_info
