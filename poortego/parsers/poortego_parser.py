#!/usr/bin/env python

import os
import importlib

class PoortegoParser:
	"""Main class for handling parsing functionality for imports and other Poortego functionality"""
	
	supported_types = [	'file',
				'string'	]

	# Option TODO: build supported_formats[] list by looking at sub-directories
	supported_formats = [ 	'csv',
				'json',
				'stix',
				'ioc',
				'maltego'	]


	def __init__(self, input_type=None, input_format=None, input_value=None):
		"""Constructor"""
		self.input_type	= input_type.strip().lower()
		self.input_format = input_format.strip().lower()
		self.input_value = input_value.strip()
		self._validate()

	def _validate(self):
		"""Validate input type, format, and value variables"""
		error_string = None
		if not self.input_type in self.supported_types:
			# Invalid input type
			error_string = "Invalid input type: %s\n" % self.input_type
		elif not self.input_format in self.supported_formats:
			# Invalid input format
			error_string = "Invalid input format: %s\n" % self.input_format
		elif self.input_type=='file' and not os.path.isfile(self.input_value):
			# Invalid file name
			error_string = "Invalid input file: %s\n" % self.input_value
		elif not self.input_value:
			# No value set
			error_string = "No input value specified.\n"
		if error_string:
			raise Exception(error_string)

	def run(self):
		"""Direct parsing based on format"""
		pkg_name = '.'
		mod_name = self.input_format + '.' + self.input_format + '_parser'
		class_name = self.input_format.capitalize() + 'Parser'
		
		parser_module = importlib.import_module(mod_name, pkg_name)
		parser_class = getattr(parser_module, class_name)
		parser_obj = parser_class(self.input_type, self.input_value)
		
		result = parser_obj.run()
		return result								
