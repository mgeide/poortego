# session.py

"""
TODO List:
	- Figure out how to handle node/link meta template and value setting
	- reset method to reset the session back to default if needed
	- terminate method to disconnect database and user as well as any other session clean-up
"""

#
# Poortego Session
#  - Track user, current object, etc.
# 

from .user import User
from ..data_management.poortego_database import PoortegoDatabase

class Session:
	"""Used for tracking Poortego session state"""
	def __init__(self, conf_obj):
		
		#
		# Configuration tied to Session
		#
		self.my_conf = conf_obj
		
		#
		# User tied to Session
		#
		# TODO: have this guest/guest default user selected in Conf option
		self.my_user = User('guest','guest')
		self.my_user.authenticate(self.my_conf.conf_settings['password_file'])
		
		#
		# DB
		#
		self.my_db = PoortegoDatabase(self.my_conf)
		
		
		#
		# TODO: worry about the meta stuff later - verify the above first
		#
		
		# Set in set_default_nodes() method called from poortego reset()
		self.home_node_id = self.my_db.poortego_root_node.id
		self.current_node_id = self.my_db.poortego_root_node.id
		#now_string = time.strftime("%Y-%m-%d %H:%M:%S")
		self.default_node_meta = {
			"created_by":"username", #self.user.username,
			"created_at":"datetime", #now_string,
			"creation_method":"Poortego shell",
			"last_accessed_by":"username", #self.user.username,
			"last_accessed_at":"datetime", #now_string,
			"last_modified_by":"username", #self.user.username,
			"last_modified_at":"datetime" #now_string
		}
		self.default_link_meta = {
			"created_by":"username", #self.user.username,
			"created_at":"datetime", #now_string,
			"creation_method":"Poortego shell",
			"last_accessed_by":"username", #self.user.username,
			"last_accessed_at":"datetime", #now_string,
			"last_modified_by":"username", #self.user.username,
			"last_modified_at":"datetime" #now_string
		}


	def set_default_nodes(self, node_id):
		self.home_node_id = node_id
		self.current_node_id = node_id

	def update_node_meta(self):
		# TODO - update datetime to current
		print "TODO"	
	
	def update_link_meta(self):
		# TODO - update datetime to current
		print "TODO"

	def terminate(self):
		# TODO - terminate session, e.g., disconnect user and database connection
		print "TODO"

	def display(self):
		print "Session Info:"
		print "-------------"
		print " Username: " + str(self.my_user.username)
		print " Home Node Id: " + str(self.home_node_id)
		print " Current Node Id: " + str(self.current_node_id)
