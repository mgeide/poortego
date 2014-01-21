# session.py

#
# Poortego Session
#  - Track user, current object, etc.
# 

class Session:
	"""Used for tracking Poortego session state"""
	def __init__(self):
		self.username = ""  # TODO
		self.home_node_id = -1
		self.current_node_id = -1
		now_string = time.strftime("%Y-%m-%d %H:%M:%S")
		self.default_node_meta = {
			"created_by":self.username,
			"created_at":now_string,
			"creation_method":"Poortego shell",
			"last_accessed_by":self.username,
			"last_accessed_at":now_string,
			"last_modified_by":self.username,
			"last_modified_at":now_string,
		}
		self.default_link_meta = {
			"created_by":self.username,
			"created_at":now_string,
			"creation_method":"Poortego shell",
			"last_accessed_by":self.username,
			"last_accessed_at":now_string,
			"last_modified_by":self.username,
			"last_modified_at":now_string,
		}


	def update_node_meta(self):
		# TODO - update datetime to current
		

	def update_link_meta(self):
		# TODO - update datetime to current

	def display(self):
		print "Session Info:"
		print "-------------"
		print " Username: " + str(self.username)
		print " Home Node Id: " + str(self.home_node_id)
		print " Current Node Id: " + str(self.current_node_id)
