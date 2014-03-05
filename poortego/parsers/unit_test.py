#!/usr/bin/env python

# Stupid absolute path inclusion snippet
import os, sys, inspect
cmd_folder = os.path.realpath(os.path.abspath(os.path.split(inspect.getfile( inspect.currentframe() ))[0]))
if cmd_folder not in sys.path:
    sys.path.insert(0, cmd_folder)

from poortego_parser import PoortegoParser

my_parser = PoortegoParser('string', 'csv', 'nodeA,link,nodeB')
results = my_parser.run() 

print "Results: %s\n" % results
