#!/usr/bin/python

import csv, sys

from ...data_types.node import PoortegoNode
from ...data_types.link import PoortegoLink

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

	csv_has_heading = False
	csv_heading = list()

	with open(csv_filepath, 'rb') as f:
		csv_contents = csv.reader(f)
		try:
			for row in csv_contents:
				if row: # Ignore empty lines
					first_column = row[0].strip()
					if first_column.startswith('#'):
						next
					elif first_column.startswith('HEADING:'):
						csv_has_heading = True
						first_fields = row[0].split(':')
						csv_heading.append(first_fields[1])
						for col in row[1:]:
							csv_heading.append(col.strip())
					elif not csv_has_heading:	
						if first_column == 'property':
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
							node_obj = PoortegoNode()
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
									link_obj = PoortegoLink()
									link_obj.set_value(csv_file_nodes[start_node], 
											csv_file_nodes[end_node], 
											link_name, 
											link_properties)
									print "[DEBUG] link object built: %s\n" % repr(link_obj)
									csv_file_links.add(link_obj)
						else:
							print "Unhandled first column: %s\n" % first_column 
					elif csv_has_heading:
						field_number = 0
						csv_nodes = list()
						link_name = ''
						for col in row:
							col_value = col.strip()
							print "[DEBUG] row: %s\n" % repr(row)
							print "[DEBUG] csv_heading: %s\n" % repr(csv_heading)
							print "[DEBUG] col: %s\n" % repr(col)
							print "[DEBUG] header field number: %s\n" % repr(field_number)
							field_header = csv_heading[field_number]

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
									csv_file_nodes[node_name] = node_obj
									csv_nodes.append(node_obj)
								field_number = field_number + 1
								field_header = csv_heading[field_number]		

							if field_header.startswith('link'):
								# Treat as link name
								link_name = col_value
							else:
								# Treat as node name
								node_type = field_header
								node_name = col_value
								node_obj = PoortegoNode()
								node_obj.set_value(node_name, [node_type], {})
								csv_file_nodes[node_name] = node_obj
								csv_nodes.append(node_obj)
							
							field_number = field_number + 1
		
						# Do link 
						link_obj = PoortegoLink()
						link_obj.set_value(csv_nodes[0], csv_nodes[1], link_name, {})
						csv_file_links.add(link_obj)					
	
		except csv.Error as e:
			sys.exit("file %s, line %d: %s" % (csv_filepath, csv_contents.line_num, e))


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
