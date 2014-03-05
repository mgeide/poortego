#!/usr/bin/env python

#
# Module: poortego.data_types.link
# Class: PoortegoLink
#

# TODO: provide a method for making changes to Meta

from .node import PoortegoNode
import json

#class PoortegoLinkMeta:    
#    default_meta_template = {
#                         "created_by":"<username>", 
#                         "created_at":"<datetime>", 
#                         "creation_method":"manual",
#                         "last_accessed_by":"<username>", 
#                         "last_accessed_at":"<datetime>", 
#                         "last_modified_by":"<username>",
#                         "last_modified_at":"datetime" 
#                         }
#    def __init__(self, custom_meta_template=None):
#        if custom_meta_template:
#            self.meta_template = custom_meta_template
#       else:
#            self.meta_template = default_meta_template

    
#
# Class: PoortegoLink
#
class PoortegoLink:
    """Store information pertaining to linkage between two nodes"""
    def __init__(self):
        self.start_node = PoortegoNode()
        self.end_node = PoortegoNode()
        self.id = -1
        self.name = ""
        self.properties = dict()
    #def add_meta(self, meta_template=None):
    #    self.properties.update(PoortegoLinkMeta(meta_template).meta_template) 
    def set_value(self, start_node, end_node, name, properties):
        self.start_node = start_node
        self.end_node = end_node
        self.name = name
        self.properties = properties
    def to_json(self):
        link_data = [ { "start_node": self.start_node.to_json(), "end_node": self.end_node.to_json(), "name": self.name, "properties": self.properties } ]
        json_link = json.dumps(link_data)
        return json_link