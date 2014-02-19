#!/usr/bin/python

import csv, sys
import json

class Node:
	def __init__(self):
		self._id = -1
		self.name = ""
		self.labels = set()
		self.properties = dict()
	def set_value(self, name, labels, properties):
		self.name = name
		self.labels = labels
		self.properties = properties
	def to_json(self):
		node_data = [ { "_id": self._id, "name": self.name, "labels": list(self.labels), "properties": self.properties } ]
		json_node = json.dumps(node_data)
		return json_node	

class Link:
	def __init__(self):
		self.start_node = Node()
		self.end_node = Node()
		self.name = ""
		self.properties = dict()
	def set_value(self, start_node, end_node, name, properties):
		self.start_node = start_node
		self.end_node = end_node
		self.name = name
		self.properties = properties
	def to_json(self):
		link_data = [ { "start_node": self.start_node.to_json(), "end_node": self.end_node.to_json(), "name": self.name, "properties": self.properties } ]
		json_link = json.dumps(link_data)
		return json_link

if __name__ == "__main__":
	csv_filepath = sys.argv[1]
	print "[DEBUG] Processing %s\n" % csv_filepath

	# Variables to define accordingly based on CSV file contents
	csv_global_node_properties = dict() # property key => property value
	csv_global_link_properties = dict()
	csv_global_labels = set() # set of labels to assign to nodes in file
	csv_file_sets = dict()  # set name => set[]
	csv_file_sets['$ALL_NODES'] = set()	# Note: special set "$ALL_NODES"
	csv_file_nodes = dict() # node name => node object
	csv_file_links = set()  # set of link objects

	with open(csv_filepath, 'rb') as f:
		csv_contents = csv.reader(f)
		try:
			for row in csv_contents:
				if row: # Ignore empty lines
					first_column = row[0].strip()
					if first_column.startswith('#'):
						next
					elif first_column == 'property':
						property_type = row[1].strip()
						property_reader = row[2].strip().split('=')
						property_key = property_reader[0].strip()
						property_value = property_reader[1].strip()
						if property_type == 'node':
							csv_global_node_properties[property_key] = property_value
						elif property_type == 'link':
							csv_global_link_properties[property_key] = property_value
						elif property_type == 'all':
							csv_global_node_properties[property_key] = property_value
							csv_global_link_properties[property_key] = property_value
						else:
							print "[ERROR] Invalid property type: %s\n" % property_type
					elif first_column == 'label':
						label_name = row[1].strip()
						csv_global_labels.add(label_name)
					elif first_column == 'set':
						set_name = row[1].strip()
						set_value = row[2:]
						csv_file_sets[set_name] = set_value
					elif first_column == 'node':
						node_name = row[1].strip()
						csv_file_sets['$ALL_NODES'].add(node_name)
						node_labels = set()
						node_properties = dict()
						node_properties.update(csv_global_node_properties)	
						for remainder in row[2:]:
							remainder = remainder.strip()
							if "=" not in remainder:
								node_labels.add(remainder)
							else:
								property_reader = remainder.split('=')
								property_key = property_reader[0].strip()
								property_value = property_reader[1].strip()
								node_properties[property_key] = property_value
						node_labels.update(csv_global_labels)
						node_obj = Node()
						node_obj.set_value(node_name, node_labels, node_properties)
						print "[DEBUG] node object built: %s\n" % repr(node_obj)
						csv_file_nodes[node_name] = node_obj
					elif first_column == 'link':
						start_node = row[1].strip()
						end_node = row[2].strip()
						link_name = row[3].strip()
						
						link_properties = dict()
						link_properties.update(csv_global_link_properties)
						for remainder in row[4:]:
							remainder = remainder.strip()
							if "=" in remainder:
								property_reader = remainder.split('=')
								property_key = property_reader[0].strip()
								property_value = property_reader[1].strip()
								link_properties[property_key] = property_value

						if start_node.startswith('$'):
							start_nodes = csv_file_sets[start_node]
						else:
							start_nodes = [start_node]
						if end_node.startswith('$'):
							end_nodes = csv_file_sets[end_node]
						else:
							end_nodes = [end_node]

						for start_node in start_nodes:
							for end_node in end_nodes:	
								link_obj = Link()
								link_obj.set_value(csv_file_nodes[start_node], 
											csv_file_nodes[end_node], 
											link_name, 
											link_properties)
								print "[DEBUG] link object built: %s\n" % repr(link_obj)
								csv_file_links.add(link_obj)
					else:
						print "Unhandled first column: %s\n" % first_column 
		except csv.Error as e:
			sys.exit("file %s, line %d: %s" % (csv_filename, csv_contents.line_num, e))


		print "[DEBUG] Global node properties: %s\n" % repr(csv_global_node_properties)
		print "[DEBUG] Global link properties: %s\n" % repr(csv_global_link_properties)
		print "[DEBUG] Global node labels: %s\n" % repr(csv_global_labels)
		print "[DEBUG] Set variables: %s\n" % repr(csv_file_sets)

		print "[DEBUG] Nodes:\n"
		for node_name,node_obj in csv_file_nodes.iteritems():
			print "Node Name: %s\n" % node_name
			print "Node JSON: %s\n" % node_obj.to_json()

		print "[DEBUG] Links:\n"
		for link_obj in csv_file_links:
			print "Link JSON: %s\n" % link_obj.to_json()			
