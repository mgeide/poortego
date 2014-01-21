#!/usr/bin/env python

###
#
# Poortego command-line interface
# 
###

# Stupid absolute path inclusion snippet
import os, sys, inspect
cmd_folder = os.path.realpath(os.path.abspath(os.path.split(inspect.getfile( inspect.currentframe() ))[0]))
if cmd_folder not in sys.path:
    sys.path.insert(0, cmd_folder)

# Fire up command dispatcher
from poortego.dispatcher import Dispatcher
my_dispatcher = Dispatcher()
my_dispatcher.cmdloop()
