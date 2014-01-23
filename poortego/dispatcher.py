# dispathcer.py

#
# Poortego Dispatcher
#  - Methods for CMD2 Dispatcher
# 

###
# CMD/CMD2 References:
# - https://github.com/Zearin/cmd2
# - http://pythonhosted.org/cmd2/index.html
# - https://wiki.python.org/moin/CmdModule
# - http://docs.python.org/2/library/cmd.html
###

import sys
from cmd2 import Cmd, make_option, options
from .session import Session
from .graph import Graph
from .user import User

import io
from pprint import pprint
from stix.core import STIXPackage
from stix.indicator import Indicator
import stix.bindings.stix_core as stix_core_binding

class Dispatcher(Cmd):
	"""Used for handling CMD2 commands"""
	
	#
	# Construction
	# 
	def __init__(self, conf_settings):
		Cmd.__init__(self)
		self.conf_settings = conf_settings
		self.namespace = 'poortego'
		self.prompt = self.conf_settings['poortego_prompt'] + ' '
		self.do_poortego_reinitialize('')

	#
	# poortego_reinitialize
	#
	def do_poortego_reinitialize(self, arg):
		"""Command to reset poortego settings back to default"""
		self.my_graph = Graph(self.conf_settings)
		self.my_session = Session(self.conf_settings)
		self.my_graph.set_defaults()
		self.my_session.current_node_id = self.my_graph.poortego_root_node._id

	#
	# poortego_login
	# 
	def do_poortego_login(self, arg):
		"""Command to login as poortego user"""
		self.stdout.write("\n  Username:  ")
		username_string = (self.stdin.readline()).replace('\n','')
		self.stdout.write("\n  Password:  ")
		password_string = (self.stdin.readline()).replace('\n','')
		attempted_user = User(username_string, password_string)
		if (attempted_user.authenticate(self.conf_settings['password_file'])):
			self.my_session.user = attempted_user

	#
	# ls
	# 
	@options([
			make_option('-a', '--all', action="store_true", dest="all_nodes", help="List all nodes tied to root"),
			make_option('-b', '--bi', action="store_true", help="List nodes connected to/from current node"),
			make_option('-f', '--from', action="store_true", dest="from_nodes", help="List only nodes with link from current node"),
			make_option('-t', '--to', action="store_true", dest="to_nodes", help="List only nodes with link to current node"),	
		])	
	def do_ls(self, arg, opts):
		"""Command to show node adjacency"""
		self.stdout.write("Output format: '[id] name  [type]'\n")
		if opts.all_nodes:
			self.my_graph.show_nodes_from(self.my_graph.poortego_root_node._id)
		elif opts.bi:
			self.stdout.write("\nNodes From Current:\n")
			self.my_graph.show_nodes_from(self.my_session.current_node_id)
			self.stdout.write("\nNodes To Current:\n")
			self.my_graph.show_nodes_to(self.my_session.current_node_id)		
			self.stdout.write("\n")
		elif opts.from_nodes:
			self.stdout.write("\nNodes From Current:\n")
                        self.my_graph.show_nodes_from(self.my_session.current_node_id)
			self.stdout.write("\n")
		elif opts.to_nodes:
			self.stdout.write("\nNodes To Current:\n")
			self.my_graph.show_nodes_to(self.my_session.current_node_id)            
			self.stdout.write("\n")
		else: # Default, same as "--bi"
			self.stdout.write("\nNodes From Current:\n")
			self.my_graph.show_nodes_from(self.my_session.current_node_id)
			self.stdout.write("\nNodes To Current:\n")
			self.my_graph.show_nodes_to(self.my_session.current_node_id)		
			self.stdout.write("\n")

	#
	# cd
	#
	def do_cd(self, arg):
		"""Command to change current node"""
		self.my_session.current_node_id = arg[0]

	#
	# show
	#
	def do_show(self, arg):
		"""Command to show stuff within Poortego"""
		if (arg == 'types'):
			self.my_graph.show_types()
		else:
			self.stdout.write("Pass argument on what to show:\n")
			self.stdout.write("types\n")


	#
	# add
	#
	@options([
			make_option('-p', '--prompt', action="store_true", help="Prompt user for node values")
		])
	def do_add(self, arg, opts=None):
		"""Command to add node"""
		if opts.prompt:
			self.stdout.write("Name: ")
			name_string = (self.stdin.readline()).replace('\n','')
			self.stdout.write("Type: ")
			type_string = (self.stdin.readline()).replace('\n','')
			node_dict = {'name':name_string, 'type':type_string}
			self.my_graph.create_node_from_dict(node_dict)	
			print "You added '" + name_string + "' of type '" + type_string + "'"

	#
	# ln
	#						
	def do_ln(self, arg):
		"""Command to add link"""
		# TODO

	#
	# rm
	#
	def do_rm(self, arg):	
		"""Command to remove node/link"""
		# TODO

	#
	# import
	#
	@options([
			make_option('-c', '--csv', action="store_true", help="Import data from CSV file"),
			make_option('-m', '--maltego', action="store_true", help="Import data from Maltego file"),
			make_option('-s', '--stix', action="store_true", help="Import data from STIX file"),
	])
	def do_import(self, arg, opts=None):
		"""Command to import data (STIX, CSV, IOC, etc.)"""
		if opts.csv:
			fn = arg
			# TODO
		elif opts.maltego:
			fn = arg
			# TODO
		elif opts.stix:
			# TODO
			fn = arg
			(stix_package, stix_package_binding_obj) = STIXPackage.from_xml(fn)
			stix_dict = stix_package.to_dict() # parse to dictionary
			pprint(stix_dict)

	#
	# export
	#
	@options([
			make_option('-c', '--csv', action="store_true", help="Export data to CSV file"),
			make_option('-g', '--graphviz', action="store_true", help="Export data to graphviz PNG"),
			make_option('-m', '--maltego', action="store_true", help="Export data to Maltego file"),	
			make_option('-s', '--stix', action="store_true", help="Export data to STIX file"),
	])
	def do_export(self, arg):
		"""Command to export parts/all of graph to another format"""
		# TODO


	#
	# transform
	#
	def do_transform(self, arg):
		"""Command to run a transform"""
		# TODO
	
	#
	# poortego_session_info
	#
	def do_poortego_session_info(self, arg):
		"""Command to show info about the Poortego session"""
		self.my_session.display()

	#
	# poortego_purge
	#
	def do_poortego_purge(self, arg):
		"""Command to delete EVERYTHING from GraphDB"""
		self.stdout.write("This will delete EVERYTHING from the GraphDB!!! Are you sure you want to do this [Y/N]: ")
		response = (self.stdin.readline()).replace('\n','')
		if response == 'Y' or response == 'y':
			self.my_graph.PURGE()
			self.stdout.write("Database purged.\n")
			self.do_poortego_reinitialize('')
			self.stdout.write("Poortego ReInitialized.\n")	

	#
	# poortego_info
	#
	def do_poortego_info(self, arg):
		"""Command to show GraphDB info"""
		my_graph_info = self.my_graph.get_graph_info()
		for k, v in my_graph_info.iteritems():
			self.stdout.write(str(k) + " : " + str(v) + "\n")

