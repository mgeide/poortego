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

# Default poortego configuration locations
conf_dir = cmd_folder + '/conf/'
conf_file = 'poortego.conf'

# Start Poortego Shell
from poortego.poortego import Poortego
poortego = Poortego(conf_dir, conf_file)
print "[DEBUG] Displaying Poortego Configuration:"
poortego.display_conf_settings()
print "\n[DEBUG] Done Displaying Poortego Configuration\n\n"
poortego.start_shell()

