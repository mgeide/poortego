# session.py

#
# Poortego Session
#  - Track user, current object, etc.
# 

import time

from .user import User

class Session:
	"""Used for tracking Poortego session state"""
	def __init__(self, conf_settings):
		self.conf_settings = conf_settings
		self.user = User('guest','guest')
		self.user.authenticate(conf_settings['password_file'])
		# Set in set_default_nodes() method called from poortego reset()
		self.home_node_id = -1
		self.current_node_id = -1
		now_string = time.strftime("%Y-%m-%d %H:%M:%S")
		self.default_node_meta = {
			"created_by":self.user.username,
			"created_at":now_string,
			"creation_method":"Poortego shell",
			"last_accessed_by":self.user.username,
			"last_accessed_at":now_string,
			"last_modified_by":self.user.username,
			"last_modified_at":now_string
		}
		self.default_link_meta = {
			"created_by":self.user.username,
			"created_at":now_string,
			"creation_method":"Poortego shell",
			"last_accessed_by":self.user.username,
			"last_accessed_at":now_string,
			"last_modified_by":self.user.username,
			"last_modified_at":now_string
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

	def display(self):
		print "Session Info:"
		print "-------------"
		print " Username: " + str(self.user.username)
		print " Home Node Id: " + str(self.home_node_id)
		print " Current Node Id: " + str(self.current_node_id)
