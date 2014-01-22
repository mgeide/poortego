# user.py

#
# Poortego User
# 

import csv
import hashlib

class User:
	"""Used for tracking Poortego user"""
	def __init__(self, username, password):
		self.password_file = 'poortego_passwd.txt'
		self.username = username
		self.password = password
		self.authenticated = False
		self.groups = set()
	
	def authenticate(self):
		"""Stupid/basic authentication against a file - update before using in production"""
		# TODO - improve authentication
		with open(self.password_file, 'r') as users_file:
			userreader = csv.reader(users_file, delimiter=':')
			for row in userreader:
				if len(row) == 3:
					if row[0] == self.username and row[1] == hashlib.md5(self.password).hexdigest():
						self.groups = set(row[2].split(','))
						self.authenticated = True
						print "Logged in as: " + self.username
						print "User belongs to groups: " + repr(self.groups)
						return True
		print "Authentication failed\n";
		return False			

	#def get_groups(self):
	#	"""Stupid/basic file for tracking groups associated with user - update before using in production"""
	#	# TODO - improve authentication
	#	default_groups_file = open('.poortego_groups', 'w')
	#	for line in default_groups_file:
	#		# Comparison
	#	default_groups_file.close()		
		

#
# Debug - unit testing
#
if __name__ == "__main__":
	#user = User('guest', 'guest')
	#user = User('analyst','analyst')
	user = User('admin', 'admin')
	user.password_file = "../" + user.password_file
	user.authenticate()
