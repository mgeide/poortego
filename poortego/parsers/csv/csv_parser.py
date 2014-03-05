#!/usr/bin/env python

class CsvParser:
	def __init__(self, input_type, input_value):
		self.input_type = input_type
		self.input_value = input_value

	def run(self):
		if self.input_type == 'string':
			fields 	= self.input_value.split(',')
			nodeA 	= fields[0]
			link 	= fields[1]
			nodeB 	= fields[2]
			json_result = "{ nodes:[{name:" + nodeA + "},{name:" + nodeB + "}], links:[{name:" + link + ",nodeA:{name:" + nodeA + "},nodeB:{name:" + nodeB + "}}] }"
			return json_result 	
		elif self.input_type == 'file':
			return None
		else:
			return None	
		
