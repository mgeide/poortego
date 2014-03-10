#!/usr/bin/env python

#
# Module: poortego.data_types.node
# Class: PoortegoNode
#

import json

class PoortegoNode:
    def __init__(self):
        self.id = -1
        self.name = ""
        self.labels = set()
        self.properties = dict()
    def set_value(self, name, labels, properties):
        self.name = name
        self.labels = labels
        self.properties = properties
    def to_json(self):
        node_data = [ { "id": self.id, "name": self.name, "labels": list(self.labels), "properties": self.properties } ]
        json_node = json.dumps(node_data)
        return json_node
    def to_dict(self):
        ret_dict = dict()
        ret_dict["name"] = self.name
        ret_dict.update(self.properties)
        return ret_dict
    def to_str(self):
        ret_str = "Node Id: " + str(self.id) + "\n"
        ret_str = ret_str + "Node Name: " + self.name + "\n"    
        ret_str = ret_str + "Node Properties:\n"
        for prop_key,prop_val in self.properties.iteritems():
            ret_str = ret_str + "\t" + str(prop_key) + " : " + str(prop_val) + "\n"
        ret_str = ret_str + "Node Labels:\n"
        for label in self.labels:
            ret_str = ret_str + "\t" + str(label) + "\n"
        return ret_str