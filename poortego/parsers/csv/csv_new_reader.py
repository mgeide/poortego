#!/usr/bin/env

import csv, sys

#from ...data_types.node import PoortegoNode
#from ...data_types.link import PoortegoLink

# TODO!!
# Handle cases where field label/property lists contain special labels/properties dependent on other fields
# e.g., field_labels = [ $field2 ]
# e.g., field property = { 'description' : $field4 }

field_labels = dict()      # e.g., $field1 = [ DOMAIN, TEST ]
field_properties = dict()  # e.g., $field1 = { 'key':'val', 'key2':'val2' }
link_definitions = dict()  # e.g., $link1 = { 'nodeA' = $field1, 'name' = $field2, 'nodeB' = $field3 }
link_properties = dict() # TODO
# TODO - have data verifiers / normalizers able to receive node/link objects
	# e.g., verify and normalize DOMAIN node
	# e.g., have default meta data added
data_delimiter = ','
csv_has_heading = False
csv_section = ""
# TODO - define behaviors:
	# Ignore / warn / die on invalid headers
	# Ignore / warn / die on invalid data

def process_heading_line(line):
	print "[DEBUG] Heading row: %s\n" % repr(line)	
	heading_reader = csv.reader([line], delimiter='=')
	#print "[DEBUG] Heading Reader: %s\n" % repr(heading_reader)
	for row in heading_reader:
		#print "[DEBUG] row: %s\n" % repr(row)
		if len(row)>1:
			heading_key = row[0].strip()
			heading_value = "=".join(row[1:]).strip()
			print "[DEBUG] Heading key: %s\n" % heading_key
			print "[DEBUG] Heading value: %s\n" % heading_value
			if heading_key.startswith('$link'):
				link_dict_key = heading_key
				link_reader = csv.reader([heading_value], delimiter=',')
				for link_def in link_reader:
					if len(link_def) == 3:
						link_definitions[link_dict_key] = { 'nodeA' : link_def[0].strip(),
													'name' : link_def[1].strip(),
													'nodeB' : link_def[2].strip() 
													}
					else:
						print "Invalid heading link definition!\n"
			elif heading_key.startswith('$field'):	
				heading_keys = heading_key.split(':')
				field_dict_key = int(heading_keys[0].strip()[6:])
				if heading_keys[1] == 'label':
					field_labels[field_dict_key] = heading_value
				elif heading_keys[1] == 'property':
					property_key = heading_keys[2].strip()
					if field_dict_key in field_properties:
						field_properties[field_dict_key].update({property_key:heading_value})
					else:
						field_properties[field_dict_key] = {property_key:heading_value}
				else:
					print "Invalid heading field definition!\n"
			elif heading_key == '$delimiter':
				data_delimiter = heading_value
			else:
				print "Invalid heading line!\n"	
			

def process_data_line(line):
	print "[DEBUG] Data row: %s\n" % repr(line)
	data_reader = csv.reader([line], delimiter=data_delimiter)
	#print "[DEBUG] Heading Reader: %s\n" % repr(heading_reader)
	for row in data_reader:
		for field_num, labels in field_labels.iteritems():
			if row[field_num-1]:
				node_name = row[field_num-1]
				print "[DEBUG] %s name: %s\n" % (repr(labels), node_name)
				#node_labels = labels
				#node_properties = field_properties[field_num]
		


if __name__ == "__main__":
	csv_filepath = sys.argv[1]
	print "[DEBUG] Processing %s\n" % csv_filepath
	with open(csv_filepath, 'rb') as f:
		file_contents = f.read()
		#csv_contents = csv.reader(f)
		#for row in csv_contents:
		# TODO - looks ahead to see how many HEADING/DATA sections in file
		#	if only 1 each - can be processed much faster w/o needing to define multiple csv readers
		#   BETTER - make the logic so that all data is read for a section at a time before being processed
		for line in file_contents.splitlines():
			line = line.strip()
			if line: # Ignore empty lines
				if line.startswith('#'):
					next
				elif line == "HEADING:":
					csv_has_heading = True
					csv_section = "HEADING"
					# TODO - re-initialize field labels, properties, links
					next
				elif line == "DATA:":
					csv_section = "DATA"
					next
				elif csv_section == "HEADING":
					process_heading_line(line)
				elif csv_section == "DATA":
					process_data_line(line)
				else:
					print "[DEBUG] Invalid condition for row: %s\n" % repr(line)
	
	print "[DEBUG] Done.\n"
	print "[DEBUG] print out parsed node/link results.\n"		
	print "[DEBUG] Heading info:\n"
	print "  Field labels: %s\n" % repr(field_labels)
	print "  Field properties: %s\n" % repr(field_properties)
	print "  Link definitions: %s\n" % repr(link_definitions)
	