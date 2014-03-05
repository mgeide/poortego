#!/usr/bin/env python

###
#
# Poortego CMD2 command-line interface
# 
###

# Stupid absolute path inclusion snippet
import os, sys, inspect
cmd_folder = os.path.realpath(os.path.abspath(os.path.split(inspect.getfile( inspect.currentframe() ))[0]))
if cmd_folder not in sys.path:
    sys.path.insert(0, cmd_folder)


#
# Poortego Conf
#
from poortego.framework.conf import Conf
default_conf_dir = cmd_folder + '/conf/'
default_conf_file = 'poortego.conf'
poortego_conf_obj = Conf(default_conf_dir, default_conf_file) 
poortego_conf_obj.display_conf_settings()

#
# Poortego Session
#
from poortego.framework.session import Session
poortego_session_obj = Session(poortego_conf_obj)
poortego_session_obj.display()


#
# Poortego Interface/Dispatcher
# [Optional TODO] have default interface/dispatcher names defined in conf
#
from poortego.interfaces.cmd2_interface import Cmd2Interface 
poortego_interface_obj = Cmd2Interface(poortego_session_obj)
dispatcher_name = 'Cmd2'	
poortego_interface_obj.load_dispatcher(dispatcher_name)
poortego_interface_obj.run()
