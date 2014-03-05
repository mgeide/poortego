# help.py

#
# Module poortego.command.help
#

def poortego_help(dispatcher_object, arg):
	"""Command to display help info"""
	dispatcher_object.stdout.write("\n%s Namespace Help\n" % dispatcher_object.namespace)
	if (dispatcher_object.namespace == 'cmd2'):
		Cmd.do_help(dispatcher_object. arg)
	# TODO - allow for cross namespace help, e.g., "help cmd2.show"
	# The below code doesn't fix the problem for some reason
	#elif (arg.startswith('cmd2.')):
	#	cmd2_func = arg[5:]
	#	arg = cmd2_func
	#	dispatcher_object.stdout.write("[DEBUG] Running help for CMD2 command %s\n" % arg)
	#	Cmd.do_help(dispatcher_object. arg)
	elif (dispatcher_object.namespace == 'poortego'):
		"""Code taken and modified from cmd base"""
		if arg:
			try:
				func = getattr(dispatcher_object, 'help_poortego_' + arg)
			except AttributeError:
				try:
					doc=getattr(dispatcher_object, 'do_poortego_' + arg).__doc__
					if doc:
						dispatcher_object.stdout.write("%s\n"%str(doc))
						return
				except AttributeError:
					try:
						doc=getattr(dispatcher_object, 'do_' + arg).__doc__
						if doc:
							dispatcher_object.stdout.write("%s\n"%str(doc))
							return
					except AttributeError:	
						pass
				dispatcher_object.stdout.write("%s\n"%str(dispatcher_object.nohelp % (arg,)))
				return
			func()
        	else:
            		names = dispatcher_object.get_names()
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
                   			elif getattr(dispatcher_object, name).__doc__:
                        			cmds_doc.append(cmd)
                    			else:
                        			cmds_undoc.append(cmd)
				elif name[:3] == 'do_':
					cmd=name[3:]
					cmds_cmd2_namespace.append(cmd)
           		dispatcher_object.stdout.write("%s\n"%str(dispatcher_object.doc_leader))
            		dispatcher_object.print_topics(dispatcher_object.doc_header,   cmds_doc,   15,80)
            		dispatcher_object.print_topics(dispatcher_object.misc_header,  help.keys(),15,80)
            		dispatcher_object.print_topics(dispatcher_object.undoc_header, cmds_undoc, 15,80)
			dispatcher_object.print_topics("'cmd2' Namespace Commands", cmds_cmd2_namespace, 15, 80)
