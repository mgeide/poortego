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

from .command.add import poortego_add

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
		self.do_poortego_reinitialize('')

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
		if opts.list_namespaces:
			for ns in self.namespaces:
				self.stdout.write("%s\n" % ns)
		elif opts.change_namespace:
			self.namespace = opts.change_namespace
		elif opts.print_namespace:
			self.stdout.write("Current namespace: %s\n" % self.namespace)				


	#
	# Help - attempt at manipulation via namespace
	#
	def do_help(self, arg):
		"""Command to show how to use commands in namespace"""
		self.stdout.write("\n%s Namespace Help\n" % self.namespace)
		if (self.namespace == 'cmd2'):
			Cmd.do_help(self, arg)
		# TODO - allow for cross namespace help, e.g., "help cmd2.show"
		# The below code doesn't fix the problem for some reason
		#elif (arg.startswith('cmd2.')):
		#	cmd2_func = arg[5:]
		#	arg = cmd2_func
		#	self.stdout.write("[DEBUG] Running help for CMD2 command %s\n" % arg)
		#	Cmd.do_help(self, arg)
		elif (self.namespace == 'poortego'):
			"""Code taken and modified from cmd base"""
			if arg:
				try:
					func = getattr(self, 'help_poortego_' + arg)
				except AttributeError:
					try:
						doc=getattr(self, 'do_poortego_' + arg).__doc__
						if doc:
							self.stdout.write("%s\n"%str(doc))
							return
					except AttributeError:
						try:
							doc=getattr(self, 'do_' + arg).__doc__
							if doc:
								self.stdout.write("%s\n"%str(doc))
								return
						except AttributeError:	
							pass
					self.stdout.write("%s\n"%str(self.nohelp % (arg,)))
					return
				func()
        		else:
            			names = self.get_names()
            			cmds_doc = []
            			cmds_undoc = []
				cmds_cmd2_namespace = []
            			help = {}
            			for name in names:
                			if name[:14] == 'help_poortego_':
                    				help[name[14:]]=1
            			names.sort()
            			# There can be duplicates if routines overridden
            			prevname = ''
            			for name in names:
                			if name[:12] == 'do_poortego_':
                    				if name == prevname:
                        				continue
                    				prevname = name
                    				cmd=name[12:]
                    				if cmd in help:
                        				cmds_doc.append(cmd)
                        				del help[cmd]
                    				elif getattr(self, name).__doc__:
                        				cmds_doc.append(cmd)
                    				else:
                        				cmds_undoc.append(cmd)
					elif name[:3] == 'do_':
						cmd=name[3:]
						cmds_cmd2_namespace.append(cmd)
            			self.stdout.write("%s\n"%str(self.doc_leader))
            			self.print_topics(self.doc_header,   cmds_doc,   15,80)
            			self.print_topics(self.misc_header,  help.keys(),15,80)
            			self.print_topics(self.undoc_header, cmds_undoc, 15,80)
				self.print_topics("'cmd2' Namespace Commands", cmds_cmd2_namespace, 15, 80)


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
	# poortego_reinitialize
	#
	def do_poortego_reinitialize(self, arg):
		"""Command to reset poortego settings back to default"""
		#self.my_graph = Graph(self.conf_settings)
		self.my_graph = PoortegoNeo4jDatabase(self.conf_settings)
		self.my_session = Session(self.conf_settings)
		self.my_graph.set_database_defaults()
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
	def do_poortego_ls(self, arg, opts):
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
	def do_poortego_cd(self, arg):
		"""Command to change current node"""
		self.my_session.current_node_id = arg[0]

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
	def do_poortego_ln(self, arg):
		"""Command to add link"""
		# TODO

	#
	# rm
	#
	def do_poortego_rm(self, arg):	
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
	def do_poortego_import(self, arg, opts=None):
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
	def do_poortego_export(self, arg):
		"""Command to export parts/all of graph to another format"""
		# TODO


	#
	# transform
	#
	def do_poortego_transform(self, arg):
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
		my_graph_info = self.my_graph.database_info()
		for k, v in my_graph_info.iteritems():
			self.stdout.write(str(k) + " : " + str(v) + "\n")




