#!/usr/bin/env python

import csv
from ...data_types.node import PoortegoNode
from ...data_types.link import PoortegoLink

class CsvHeader:
	def __init__(self):
		self.field_labels = dict()      # e.g., $field1 = [ DOMAIN, TEST ]
		self.field_properties = dict()  # e.g., $field1 = { 'key':'val', 'key2':'val2' }
		self.link_definitions = dict()  # e.g., $link1 = { 'nodeA' = $field1, 'name' = $field2, 'nodeB' = $field3 }
		self.link_properties = dict() # TODO
		# TODO - have data verifiers / normalizers able to receive node/link objects
        	# e.g., verify and normalize DOMAIN node
        	# e.g., have default meta data added
		self.data_delimiter = ','


class CsvParser:
	def __init__(self, input_type, input_value):
		self.input_type = input_type
		self.input_value = input_value

		self.heading_section = list()
		self.data_section = list()
		self.heading_object = None

		self.node_objects = dict()
		self.link_objects = list()


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
		csv_nodes = list()
		link_name = ''
		field_number = 0
		for col in row:
			col_value = col.strip()
			print "[DEBUG] row: %s\n" % repr(row)
			print "[DEBUG] csv_heading: %s\n" % repr(self.heading)
			print "[DEBUG] col: %s\n" % repr(col)
			print "[DEBUG] header field number: %s\n" % repr(field_number)
			field_header = self.heading[field_number]
			print "[DEBUG] field header: %s\n" % field_header

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

			print "[DEBUG] header field number: %s\n" % repr(field_number)
			print "[DEBUG] field header: %s\n" % field_header

			if not '=' in field_header:
				if field_header.startswith('link'):
					# Treat as link name
					link_name = col_value
				else:
					# Treat as node name
					node_type = [field_header]
					node_name = col_value
					node_obj = PoortegoNode()
					node_obj.set_value(node_name, node_type, {})
					self.parse_node_results[node_name] = node_obj
					csv_nodes.append(node_obj)
		
			field_number = field_number + 1
			
		# Do link 
		link_obj = PoortegoLink()
		link_obj.set_value(csv_nodes[0], csv_nodes[1], link_name, {})
		self.parse_link_results.add(link_obj)
					
		
	def _process_heading_section(self):
		if self.heading_section:
			self.heading_object = CsvHeader()
			heading_reader = csv.reader(self.heading_section, delimiter='=')
        		for row in heading_reader:
				if len(row)>1:
					heading_key = row[0].strip()
					heading_value = "=".join(row[1:]).strip()
					print "[DEBUG] Heading key: %s\n" % heading_key
					print "[DEBUG] Heading value: %s\n" % heading_value
					if heading_key.startswith('$link'):
						heading_keys = heading_key.split(':')
						link_dict_key = int(heading_keys[0].strip()[5:]) # This is the number following $link					
						if heading_keys[1] == 'property':
							property_key = heading_keys[2].strip()	
                                                        if link_dict_key in self.heading_object.link_properties:
                                                                self.heading_object.link_properties[link_dict_key].update({property_key:heading_value})
                                                        else:
                                                                self.heading_object.link_properties[link_dict_key] = {property_key:heading_value}
						else:
							link_reader = csv.reader([heading_value], delimiter=',')
							for link_def in link_reader:
                                        			if len(link_def) == 3:
                                                			self.heading_object.link_definitions[link_dict_key] = { 'nodeA' : link_def[0].strip(),
                                                                                                        'name' : link_def[1].strip(),
                                                                                                        'nodeB' : link_def[2].strip()
                                                                                                        }
                                        			else:
                                                			print "Invalid heading link definition!\n"
                        		elif heading_key.startswith('$field'):
                                		heading_keys = heading_key.split(':')
                                		field_dict_key = int(heading_keys[0].strip()[6:])
                                		if heading_keys[1] == 'label':
                                        		self.heading_object.field_labels[field_dict_key] = heading_value
                                		elif heading_keys[1] == 'property':
                                        		property_key = heading_keys[2].strip()
                                        		if field_dict_key in self.heading_object.field_properties:
                                                		self.heading_object.field_properties[field_dict_key].update({property_key:heading_value})
                                        		else:
                                                		self.heading_object.field_properties[field_dict_key] = {property_key:heading_value}
                                		else:
                                        		print "Invalid heading field definition!\n"
                        		elif heading_key == '$delimiter':
                                		self.heading_object.data_delimiter = heading_value
 					else
						print "Invalid heading line: %s\n" % repr(row)
	                       	else:
                                	print "Invalid heading line: %s\n" % repr(row)
		else:
			print "Problem: no heading section!!\n"


	def _process_properties(self, prop_dict):
		# TODO


	def _process_data_section(self):
		self._process_heading_section()
		if self.data_section:
			data_reader = csv.reader(self.data_section, delimiter=self.heading_object.data_delimiter)
        		for row in data_reader:
                		for field_num, labels in self.heading_object.field_labels.iteritems():
                        		if row[field_num-1]:
						node_name = row[field_num-1]
                                		node_labels = labels
                                		node_properties = self.heading_object.field_properties[field_num]
						for prop_key, prop_val in node_properties:
							prop_key_translated = None
							prop_val_translated = None
							if prop_key.startswith('$field'):
								field_num = prop_key.strip().[6:]
								prop_key_translated = row[field_num-1]
							if prop_val.startswith('$field'):
								field_num = prop_val.strip().[6:]
								prop_val_translated = row[field_num-1]
							if prop_key_translated:
								if prop_val_translated:
									node_properties[prop_key_translated] = prop_val_translated
								else:
									node_properties[prop_key_translated] = prop_val
								del node_properties[prop_key]
							elif prop_val_translated:
								node_properties[prop_key] = prop_val_translated													
						node_obj = PoortegoNode()
						node_obj.set_value(node_name, node_labels, node_properties)
						self.node_objects[field_num] = node_obj
				for link_num, link_def in self.heading_object.link_definitions.iteritems():
					link_name = None
					link_nodeA = None
					link_nodeB = None
					link_properties = None

					if link_def['name'].startswith('$field'):
						field_num = int(link_def['name'].strip()[6:])
						link_name = row[field_num-1]
					else:
						link_name = link_def['name']
					if link_def['nodeA'].startswith('$field'):
						field_num = int(link_def['name'].strip()[6:])
						link_nodeA = row[field_num-1]
					else:
						link_nodeA = link_def['nodeA']
                                        if link_def['nodeB'].startswith('$field'):                      
                                                field_num = int(link_def['name'].strip()[6:])                           
                                                link_nodeB = row[field_num-1]
                                        else:
                                                link_nodeB = link_def['nodeB']						
					link_properties = self.heading_object.link_properties[link_num]
                                	# TODO - handle cases when label / property is a $field#

					if link_name and link_nodeA and link_nodeB:
						link_obj = PoortegoLink()
						link_obj.set_value(link_nodeA, link_nodeB, link_name, link_properties)
						self.link_objects.append(link_obj)


	
	def _process_file(self):
		section_name = 'None'
		with open(self.input_value, 'rb') as f:
			file_contents = f.read()
			for line in file_contents.splitlines():
                        	line = line.strip()
                        	if line: # Ignore empty lines
                                	if line.startswith('#'):
						next
					elif line.startswith('HEADING:'):
						if section_name = 'DATA':
							self._process_data_section()
							self.heading_section = list()
							self.data_section = list()
						section_name = 'HEADING'
					elif line.startswith('DATA:'):
						section_name = 'DATA'
					elif section_name == 'HEADING':
						self.heading_section.append(line)
					elif section_name == 'DATA':
						self.data_section.append(line)
					else:
						print "Unhandled case within _process_file()"
			self._process_data_section()						


	def run(self):
		if self.input_type == 'string':
			self.csv_to_json(self.input_value)
		elif self.input_type == 'file':
			self._process_file()
		else:
			return None	
		
