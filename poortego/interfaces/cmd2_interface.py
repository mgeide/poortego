# -*- coding: utf-8 -*-
# cmd2_interface.py 

"""
TODO List
    - pydoc, std python header: version, authorship, etc.
    - Make load dispatcher an available command from the prompt to load new command sets
    - Allow dynamic detection of namespace from do_<namespace>_<command> versus namespace list
    - Fix tab completion to support namespace
    - Improve help to list commands separated by namespace (supress cmd2 commands if in another namespace)
        - "help -a" to list all accessible commands (including cmd2)
    - Improve welcome screen
"""

#
# Package: poortego.interface
# Module: cmd2_interface
#

from cmd2 import Cmd, make_option, options
import inspect
import importlib

#
# Cmd2 command-line interface inherited from cmd2
#
class Cmd2Interface(Cmd):
    """Used for handling CMD2 commands"""
    def __init__(self, session_obj):
        Cmd.__init__(self)
        self.my_session = session_obj
        self.supported_namespaces = ['poortego', 'cmd2']
        self.namespace = 'poortego'
        self.no_namespace_commands = ['help', 'welcome', 'namespace', 'exit']
        self.get_names_addendum = [] # list of additional class methods not returned from python dir() at runtime
        self.prompt = self.my_session.my_conf.conf_settings['poortego_prompt'] + ' '
        #self.do_poortego_reset('') -- TODO: all this setup should be done in the Session declaration
        #self.load_dispatcher('cmd2')

    def display_nodes_summary(self, node_list):
        for node_obj in node_list:
            self.stdout.write("%s: %s  %s\n" % (node_obj.id, node_obj.name, list(node_obj.labels)))
    
    def display_link_summary(self, node_link):
        self.stdout.write("[%s: %s]  --%s-->  [%s: %s]\n" % (node_link.start_node.id,
                                                             node_link.start_node.name,
                                                             node_link.name,
                                                             node_link.end_node.id,
                                                             node_link.end_node.name))
        
                         
    #
    # Method: func_named (cmd2 method override)
    # Purpose: internal cmd2 method for getting commands based on function name
    # I added login to original method to support do_<namespace>_<command> function mapping
    #
    def func_named(self, arg):
        """Method resposible for locating `do_*` for commands"""
        result = None
        target = 'do_' + arg
        # cmd2 namespace
        if (arg.startswith('cmd2.')):
            cmd2_func  = arg[5:]
            target = 'do_' + cmd2_func
        # all other namespaces    
        elif (self.namespace != 'cmd2'):
            if not arg in self.no_namespace_commands:
                target = 'do_' + self.namespace + '_' + arg
        
        if target in dir(self):
            result = target
        else:
            if self.abbrev:
                funcs = [fname for fname in self.keywords if fname.startswith(arg)]
                if len(funcs) == 1:
                    result = 'do_' + funcs[0]
                    if (self.namespace != 'cmd2'):
                        if not funcs[0] in self.no_namespace_commands:
                            result = 'do_' + self.namespace + '_' + funcs[0]
        return result
        

    #
    # Method: load_dispatcher
    # Purpose: allow interface object to load one/more separate dispatchers supporting various command sets
    # Called from main program with interface object, most/always called before run() method
    #
    def load_dispatcher(self, dispatcher_name):
        """Dynamicly adds methods from dispatcher class - it may be better to just inherit in the long run"""
        mod_name = 'poortego.dispatchers.' + dispatcher_name.strip().lower() + "_dispatcher"               
        class_name = dispatcher_name.strip().capitalize() + "Dispatcher"
        mod_obj = importlib.import_module(mod_name) 
        class_obj = getattr(mod_obj, class_name)
        dispatcher_obj = class_obj(self)  # construct dispatcher passing interface for I/O & session details

        for attrib_name, attrib_value in inspect.getmembers(dispatcher_obj):
            if attrib_name.startswith("do_"):
                setattr(self, attrib_name, attrib_value)
                self.func_named(attrib_name)
                self.get_names_addendum.append(str(attrib_name))

    #
    # Method: get_names (override from cmd)
    # Purpuse to get function names - includes instance functions such as those loaded in dispatcher
    #
    def get_names(self):
        names = dir(self.__class__) + self.get_names_addendum
        return names

    #
    # Method: completenames (override from cmd)
    # Purpose: to tab complete commands - inclusion of namespace
    #
    # FIXME
    def completenames(self, text, *ignored):
        prefix = 'do_'
        if self.namespace:
            prefix = prefix + self.namespace + '_'
        prefix_length = len(prefix)
        dotext = prefix + text
        return [a[prefix_length] for a in self.get_names() if a.startswith(dotext)]
        

    #
    # Method: do_welcome
    # Purpose: Show a welcome message
    # Called at start and if user enters "welcome" at command prompt
    #
    def do_welcome(self, arg=None):
        self.stdout.write("Welcome to Poortego cmd2 interface!\n")

    #
    # Method: run
    # Purpose: start interface
    # Called from main program with interface object
    #
    def run(self):
        self.do_welcome()
        self.cmdloop()

    #
    # Method: do_quit (alias to exit command as well)
    # Purpose: do any clean-up
    # Called when user enters "exit" at command prompt
    #
    def do_quit(self, arg):
        self.my_session.terminate()
        Cmd.do_quit(self, arg)

    #
    # Method: do_namespace
    # Purpose: add namespace manipulation command to cmd2 interface
    # Called by user running "namespace" command from interface prompt
    #
    @options([
            make_option('-c', '--change', type="string", dest="change_namespace", help="Change the current namespace of the dispatcher to change the handling of commands"),
            make_option('-l', '--list', action="store_true", dest="list_namespaces", help="Show the current namespaces available to the dispatcher"),
            make_option('-p', '--print', action="store_true", dest="print_namespace", default=True, help="Show the current namespace of the dispatcher")
        ])
    def do_namespace(self, args, opts):
        """Command to manipulate namespace"""
        if opts.list_namespaces:
            for ns in self.supported_namespaces:
                self.stdout.write("%s\n" % ns)
        elif opts.change_namespace:
            self.namespace = opts.change_namespace
        elif opts.print_namespace:
            self.stdout.write("Current namespace: %s\n" % self.namespace)
            
    #
    # Method: do_help (override cmd2 do_help)
    # Purpose: show help / available commands according to current namespace
    # Called by user running "help" command from interface prompt
    #      
    def do_help(self, arg):
        """Command to display help info"""
        self.stdout.write("\n%s Namespace Help\n" % self.namespace)
        
        # If we're just in the cmd2 namespace, return its help
        if (self.namespace == 'cmd2'):
            Cmd.do_help(arg)
            return
        else:  # Else, if we're in another namespace, try the following:
            if arg: # If getting help for a specific command in the namespace, try:
                # First see if the namespace command exists
                try:
                    do_func = getattr(self, 'do_' + self.namespace + "_" + arg)
                except AttributeError:
                    # Namespace function doesn't exist - see if there is a non-namespace / cmd2 command with arg name
                    try:
                        do_func = getattr(self, 'do_' + arg)
                        Cmd.do_help(arg)
                        return
                    except AttributeError:
                        self.stdout.write("[ERROR] Command does not exist in this or top-level namespace: %s\n" % arg)
                        return
                try:
                    # Next see if there is a help_<namespace>_<command> method is available to call
                    help_func = getattr(self, 'help_' + self.namespace + '_' + arg)
                    help_func()
                    return
                except AttributeError:
                    # If no help method for the command, get the __doc__ for the method if exists
                    try:
                        doc=getattr(self, 'do_' + self.namespace + '_' + arg).__doc__
                        if doc:
                            self.stdout.write("%s\n" % str(doc))
                            return
                    except AttributeError:
                        self.stdout.write("%s\n"%str(self.nohelp % (arg,)))
                        return
            # Otherwise display generic help
            else:
                #names = self.get_names() + self.get_names_addendum
                names = self.get_names()
                cmds_doc = []
                cmds_undoc = []
                cmds_cmd2_namespace = []
                for name in names:
                    if name.startswith('do_' + self.namespace):
                        cmd_prefix_length = len(self.namespace)+4
                        cmd=name[cmd_prefix_length:]
                        if getattr(self, name).__doc__:
                            cmds_doc.append(cmd)
                        else:
                            cmds_undoc.append(cmd)
                    elif name[:3] == 'do_':
                        cmd=name[3:]
                        cmds_cmd2_namespace.append(cmd)
                self.stdout.write("%s\n" % str(self.doc_leader))
                self.print_topics(self.doc_header,   cmds_doc,   15,80)
                self.print_topics(self.undoc_header, cmds_undoc, 15,80)
                self.print_topics("'cmd2' Namespace Commands", cmds_cmd2_namespace, 15, 80)
