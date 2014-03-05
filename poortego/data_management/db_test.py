# db_test.py

import os, sys, inspect
import pprint

#
# Small test script
#

if __name__ == "__main__":

	cmd_folder = os.path.realpath(os.path.abspath(os.path.split(inspect.getfile( inspect.currentframe() ))[0]))
	if cmd_folder not in sys.path:
		sys.path.insert(0, cmd_folder)

	# Note- these settings would be from a file
	test_conf_settings = {}
        
	## CRITs example
	#test_conf_settings["db_type"] = "crits"
	#test_conf_settings["mongo_uri"] ='mongodb://localhost:27017/crits'

	## Neo4j example
	test_conf_settings["db_type"] = "neo4j"
	test_conf_settings["neo4j_uri"] = 'http://localhost:7474/db/data/'
	
	# Setup database based on config
    
    
    if (test_conf_settings["db_type"] == "crits"):
		from poortego_crits_database import PoortegoCRITsDatabase
                db = PoortegoCRITsDatabase(test_conf_settings)
        elif (test_conf_settings["db_type"] == "neo4j"):
		from poortego_neo4j_database import PoortegoNeo4jDatabase
                db = PoortegoNeo4jDatabase(test_conf_settings)
        else:
		print "FAIL! Need to specify database implementation type.\n"
		sys.exit(-1)

	## Display db info example
	pprint.pprint(db.get_database_info())

	## Add example - TODO

	## Query example - TODO
        #results = db.find_items( {"type":"DOMAIN", "value":"test.com"} )
        #for result in results:
        #        pprint.pprint(result)

	## Update example - TODO

	## Delete example - TODO
