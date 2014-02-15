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

from ..session import Session
#from .graph import Graph
from ..database.poortego_neo4j_database import PoortegoNeo4jDatabase
from ..user import User

from .command.help import poortego_help
from .command.add import poortego_add
from .command.cd import poortego_cd
from .command.ls import poortego_ls
from .command.rm import poortego_rm
from .command.ln import poortego_ln
from .command.cat import poortego_cat
from .command.man import poortego_man
from .command.pwd import poortego_pwd
from .command.reset import poortego_reset
from .command.purge import poortego_purge
from .command.imports import poortego_import
from .command.exports import poortego_export
from .command.transforms import poortego_transform
from .command.namespace import poortego_namespace
from .command.storage import poortego_storage
from .command.session import poortego_session
from .command.user import poortego_user

import io
from pprint import pprint
from stix.core import STIXPackage
from stix.indicator import Indicator
import stix.bindings.stix_core as stix_core_binding
import pprint

class Dispatcher(Cmd):
	"""Used for handling CMD2 commands"""
	
	#
	# Construction
	# 
	def __init__(self, conf_settings):
		Cmd.__init__(self)
		self.conf_settings = conf_settings
		self.namespace = 'poortego'
		self.namespaces = ['poortego', 'cmd2']
		self.prompt = self.conf_settings['poortego_prompt'] + ' '
		self.do_poortego_reset('')

	#
	# Track & Change Dispatcher Namespace
	#
	@options([
			make_option('-c', '--change', type="string", dest="change_namespace", help="Change the current namespace of the dispatcher to change the handling of commands"),
			make_option('-l', '--list', action="store_true", dest="list_namespaces", help="Show the current namespaces available to the dispatcher"),
			make_option('-p', '--print', action="store_true", dest="print_namespace", default=True, help="Show the current namespace of the dispatcher")
		])
	def do_namespace(self, arg, opts):
		"""Command to show and change command namespace"""
		poortego_namespace(self, arg, opts)


	#
	# Help - attempt at manipulation via namespace
	#
	def do_help(self, arg):
		"""Command to show how to use commands in namespace"""
		poortego_help(self, arg)


	#
	# pwd - print current working node data
	#
	def do_poortego_pwd(self, arg):
		"""Command to show data for current working node"""
		poortego_pwd(self, arg)

	#
	# Storage - command to manipulate/show storage details
	#
	@options([
			make_option('-l', '--list', action="store_true", dest="list_details", help="Show the storage details")
		])
	def do_poortego_storage(self, arg, opts):
		"""Command to show and change storage details"""
		poortego_storage(self, arg, opts)



	#
	# Session - command to manipulate/show session
	#
	@options([
			make_option('-l', '--list', action="store_true", dest="list_details", help="Show the current session details")
		])
	def do_poortego_session(self, arg, opts):
		"""Command to show and change session details"""
		poortego_session(self, arg, opts)



	#
	# User - command to manipulate/show users
	#
	@options([
			make_option('-c', '--change', action="store_true", dest="change_user", help="Change the current user"),
			make_option('-l', '--list', action="store_true", dest="list_details", help="Show the current user details")
		])
	def do_poortego_user(self, arg, opts):
		"""Command to show and change user details"""
		poortego_user(self, arg, opts)


	#
	# CMD2 override for getting function name
	#
	def func_named(self, arg):
		"""Method resposible for locating `do_*` for commands"""
		result = None
		target = 'do_' + arg
		if (arg.startswith('cmd2.')):
			cmd2_func  = arg[5:]
			target = 'do_' + cmd2_func
		elif (self.namespace != 'cmd2'):
			if not arg in ['help', 'namespace', 'exit']:
				target = 'do_' + self.namespace + '_' + arg
		
		if target in dir(self):
			result = target
		else:
			if self.abbrev:
				funcs = [fname for fname in self.keywords if fname.startswith(arg)]
				if len(funcs) == 1:
					result = 'do_' + funcs[0]
                			if (self.namespace != 'cmd2'):
                        			if not funcs[0] in ['help', 'namespace', 'exit']:
                                			result = 'do_' + self.namespace + '_' + funcs[0]
		return result
		 


	#
	# poortego_reset
	#
	def do_poortego_reset(self, arg):
		"""Command to reset poortego settings back to default"""
		poortego_reset(self, arg)

	#
	# poortego_login
	# 
	#def do_poortego_login(self, arg):
	#	"""Command to login as poortego user"""
	#	self.stdout.write("\n  Username:  ")
	#	username_string = (self.stdin.readline()).replace('\n','')
	#	self.stdout.write("\n  Password:  ")
	#	password_string = (self.stdin.readline()).replace('\n','')
	#	attempted_user = User(username_string, password_string)
	#	if (attempted_user.authenticate(self.conf_settings['password_file'])):
	#		self.my_session.user = attempted_user

	#
	# ls
	# 
	@options([
			make_option('-a', '--all', action="store_true", dest="all_nodes", help="List all nodes tied to root"),
			make_option('-b', '--bi', action="store_true", help="List nodes connected to/from current node"),
			make_option('-f', '--from', action="store_true", dest="from_nodes", help="List only nodes with link from current node"),
			make_option('-t', '--to', action="store_true", dest="to_nodes", help="List only nodes with link to current node"),	
		])	
	def do_poortego_ls(self, arg, opts):
		"""Command to show node adjacency"""
		poortego_ls(self, arg, opts)

	#
	# cd
	#
	def do_poortego_cd(self, arg):
		"""Command to change current node"""
		poortego_cd(self, arg)

	#
	# man
	#
	def do_poortego_man(self, arg):
		"""Command to display manual pages"""
		# TODO
		poortego_man(self, arg)

	#
	# cat
	#
	def do_poortego_cat(self, arg):
		"""Command to show contents of object"""
		# TODO
		poortego_cat(self, arg)

	#
	# show
	#
	def do_poortego_show(self, arg):
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
			make_option('-p', '--prompt', action="store_true", default=True, help="Prompt user for node values"),
			make_option('-t', '--type', type="string", dest="node_type", help="Define the type of thing being added"),
			make_option('-v', '--value', type="string", dest="node_value", help="Define the value of the thing")
		])
	def do_poortego_add(self, arg, opts=None):
		"""Command to add node"""
		# Code moved to .command.add sub-module for easier reading/debugging	
		poortego_add(self, arg, opts)

	#
	# ln
	#
	@options([
			make_option('-o', '--out', action="store_true", default=True, help="Create out-going link from current node"),
			make_option('-i', '--in', action="store_true", help="Create in-coming link to current node"),
			make_option('-b', '--bi', action="store_true", help="Create bi-directional link to/from current node"),
			make_option('-c', '--current', type="string", help="Specific a different node id to use than the current/working node"),
			make_option('-p', '--prompt', action="store_true", help="Prompt for link values")
		]) 						
	def do_poortego_ln(self, arg, opts):
		"""Command to add link"""
		# TODO - also account for link properties
		poortego_ln(self, arg, opts)

	#
	# rm
	#
	def do_poortego_rm(self, arg):	
		"""Command to remove node/link"""
		# TODO
		poortego_rm(self, arg)

	#
	# import
	#
	@options([
			make_option('-c', '--csv', action="store_true", help="Import data from CSV file"),
			make_option('-m', '--maltego', action="store_true", help="Import data from Maltego file"),
			make_option('-s', '--stix', action="store_true", help="Import data from STIX file"),
	])
	def do_poortego_import(self, arg, opts=None):
		"""Command to import data (STIX, CSV, IOC, etc.)"""
		# TODO
		poortego_import(self, arg, opts)

	#
	# export
	#
	@options([
			make_option('-c', '--csv', action="store_true", help="Export data to CSV file"),
			make_option('-g', '--graphviz', action="store_true", help="Export data to graphviz PNG"),
			make_option('-m', '--maltego', action="store_true", help="Export data to Maltego file"),	
			make_option('-s', '--stix', action="store_true", help="Export data to STIX file"),
	])
	def do_poortego_export(self, arg, opts=None):
		"""Command to export parts/all of graph to another format"""
		# TODO
		poortego_export(self, arg, opts)

	#
	# transform
	#
	def do_poortego_transform(self, arg):
		"""Command to run a transform"""
		# TODO
		poortego_transform(self, arg)
	
	#
	# poortego_session_info
	#
	#def do_poortego_session_info(self, arg):
	#	"""Command to show info about the Poortego session"""
	#	self.my_session.display()

	#
	# poortego_purge
	#
	def do_poortego_purge(self, arg):
		"""Command to delete EVERYTHING from GraphDB"""
		poortego_purge(self, arg)

	#
	# poortego_info
	#
	#def do_poortego_info(self, arg):
	#	"""Command to show GraphDB info"""
	#	my_graph_info = self.my_graph.database_info()
	#	for k, v in my_graph_info.iteritems():
	#		self.stdout.write(str(k) + " : " + str(v) + "\n")




