#!/usr/bin/env python

import csv
from ...data_types.node import PoortegoNode
from ...data_types.link import PoortegoLink

class CsvParser:
	def __init__(self, input_type, input_value):
		self.input_type = input_type
		self.input_value = input_value
		self.parse_node_results = dict()
		self.parse_link_results = set()
		
		self.global_node_properties = dict() # property key => property value
		self.global_link_properties = dict()
		self.global_labels = set() # set of labels to assign to nodes in file
		self.file_sets = dict()  # set name => set[]
		self.file_sets['$ALL_NODES'] = set()	# Note: special set "$ALL_NODES"
		#self.file_nodes = dict() # node name => node object
		#self.file_links = set()  # set of link objects
		self.has_heading = False
		self.heading = list()


	def csv_to_json(self, csv_string):
		fields 	= csv_string.split(',')
		nodeA 	= fields[0]
		link 	= fields[1]
		nodeB 	= fields[2]
		json_result = "{ nodes:[{name:" + nodeA + "},{name:" + nodeB + "}], links:[{name:" + link + ",nodeA:{name:" + nodeA + "},nodeB:{name:" + nodeB + "}}] }"
		return json_result 	

	def resulting_nodes(self):
		return self.parse_node_results.values()
	
	def resulting_links(self):
		return self.parse_link_results

	def _process_heading_row(self, row):
		self.has_heading = True
		first_fields = row[0].split(':')
		self.heading.append(first_fields[1].strip())
		for col in row[1:]:
			self.heading.append(col.strip())

	def _process_property_row(self, row):		
		property_type = row[1].strip()
		property_reader = row[2].strip().split('=')
		property_key = property_reader[0].strip()
		property_value = property_reader[1].strip()
		if property_type == 'node':
			self.global_node_properties[property_key] = property_value
		elif property_type == 'link':
			self.global_link_properties[property_key] = property_value
		elif property_type == 'all':
			self.global_node_properties[property_key] = property_value
			self.global_link_properties[property_key] = property_value
		else:
			print "[ERROR] Invalid property type: %s\n" % property_type
		
	def _process_label_row(self, row):		
		label_name = row[1].strip()
		self.global_labels.add(label_name)

	def _process_set_row(self, row):
		set_name = row[1].strip()
		set_value = row[2:]
		self.file_sets[set_name] = set_value
	
	def _process_node_row(self, row):
		node_name = row[1].strip()
		self.file_sets['$ALL_NODES'].add(node_name)
		node_labels = set()
		node_properties = dict()
		node_properties.update(self.global_node_properties)	
		for remainder in row[2:]:
			remainder = remainder.strip()
			if "=" not in remainder:
				node_labels.add(remainder)
			else:
				property_reader = remainder.split('=')
				property_key = property_reader[0].strip()
				property_value = property_reader[1].strip()
				node_properties[property_key] = property_value
		node_labels.update(self.global_labels)
		node_obj = PoortegoNode()
		node_obj.set_value(node_name, node_labels, node_properties)
		print "[DEBUG] node object built: %s\n" % repr(node_obj)
		self.parse_node_results[node_name] = node_obj
	
	def _process_link_row(self, row):
		start_node = row[1].strip()
		end_node = row[2].strip()
		link_name = row[3].strip()
		link_properties = dict()
		link_properties.update(self.global_link_properties)
		for remainder in row[4:]:
			remainder = remainder.strip()
			if "=" in remainder:
				property_reader = remainder.split('=')
				property_key = property_reader[0].strip()
				property_value = property_reader[1].strip()
				link_properties[property_key] = property_value

		if start_node.startswith('$'):
			start_nodes = self.file_sets[start_node]
		else:
			start_nodes = [start_node]
		if end_node.startswith('$'):
			end_nodes = self.file_sets[end_node]
		else:
			end_nodes = [end_node]

		for start_node in start_nodes:
			for end_node in end_nodes:	
				link_obj = PoortegoLink()
				link_obj.set_value(self.parse_node_results[start_node],
								self.parse_node_results[end_node], 
								link_name, 
								link_properties)
				print "[DEBUG] link object built: %s\n" % repr(link_obj)
				self.parse_link_results.add(link_obj)
	
	
	def _process_row_by_header(self, row):
		field_number = 0
		csv_nodes = list()
		link_name = ''
		for col in row:
			col_value = col.strip()
			print "[DEBUG] row: %s\n" % repr(row)
			print "[DEBUG] csv_heading: %s\n" % repr(self.heading)
			print "[DEBUG] col: %s\n" % repr(col)
			print "[DEBUG] header field number: %s\n" % repr(field_number)
			field_header = self.heading[field_number]

			while '=' in field_header:
				default_values = field_header.split('=')
				# Include in default value set in header
				if default_values[0].startswith('link'):
					# Treat as link name
					link_name = default_values[1].strip()
				else:
					# Treat as node name
					node_type = default_values[0].strip()
					node_name = default_values[1].strip()
					node_obj = PoortegoNode()
					node_obj.set_value(node_name, [node_type], {})
					self.parse_node_results[node_name] = node_obj
					csv_nodes.append(node_obj)
				field_number = field_number + 1
				field_header = self.heading[field_number]		

				if field_header.startswith('link'):
					# Treat as link name
					link_name = col_value
				else:
					# Treat as node name
					node_type = field_header
					node_name = col_value
					node_obj = PoortegoNode()
					node_obj.set_value(node_name, [node_type], {})
					self.parse_node_results[node_name] = node_obj
					csv_nodes.append(node_obj)
							
				field_number = field_number + 1
		
			# Do link 
			link_obj = PoortegoLink()
			link_obj.set_value(csv_nodes[0], csv_nodes[1], link_name, {})
			self.parse_link_results.add(link_obj)	
		
	
	def _process_file(self):
		with open(self.input_value, 'rb') as f:
			csv_contents = csv.reader(f)
			for row in csv_contents:
				if row: # Ignore empty lines
					first_column = row[0].strip()
					if first_column.startswith('#'):
						next
					elif first_column.startswith('HEADING:'):
						self._process_heading_row(row)
					elif not self.has_heading:
						if first_column == 'property':
							self._process_property_row(row)
						elif first_column == 'label':
							self._process_label_row(row)
						elif first_column == 'set':
							self._process_set_row(row)
						elif first_column == 'node':
							self._process_node_row(row)		
						elif first_column == 'link':
							self._process_link_row(row)
						else:
							print "Unhandled first column: %s\n" % first_column
					elif self.has_heading:
						self._process_row_by_header(row)

		print "[DEBUG] Global node properties: %s\n" % repr(self.global_node_properties)
		print "[DEBUG] Global link properties: %s\n" % repr(self.global_link_properties)
		print "[DEBUG] Global node labels: %s\n" % repr(self.global_labels)
		print "[DEBUG] Set variables: %s\n" % repr(self.file_sets)

		print "[DEBUG] Nodes:\n"
		for node_name,node_obj in self.parse_node_results.iteritems():
			print "Node Name: %s\n" % node_name
			print "Node JSON: %s\n" % node_obj.to_json()

		print "[DEBUG] Links:\n"
		for link_obj in self.parse_link_results:
			print "Link JSON: %s\n" % link_obj.to_json()



	def run(self):
		if self.input_type == 'string':
			self.csv_to_json(self.input_value)
		elif self.input_type == 'file':
			self._process_file()
		else:
			return None	
		
