# user.py

#
# Poortego User
# 

class User:
	"""Used for tracking Poortego user"""
	def __init__(self, username, password):
		self.username = username
		self.password = password
		self.authenticated = False
		self.groups = set()
	
	def authenticate(self):
		"""Stupid/basic authentication against a file - update before using in production"""
		# TODO - improve authentication
		with open('.poortego_users', 'r') as default_users_file:
			users_data = default_users_file.read()
		
		# Comparison
		default_users_file.close()		

	def get_groups(self):
		"""Stupid/basic file for tracking groups associated with user - update before using in production"""
		# TODO - improve authentication
		default_groups_file = open('.poortego_groups', 'w')
		for line in default_groups_file:
			# Comparison
		default_groups_file.close()		
		

