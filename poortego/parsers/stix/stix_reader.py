#!/usr/bin/python

import sys, stix, pprint
from stix.core import STIXPackage
from stix.indicator import Indicator
import stix.bindings.stix_core as stix_core_binding

if __name__ == "__main__":
	stix_file = sys.argv[1]
	(stix_package, stix_package_binding_obj) = STIXPackage.from_xml(stix_file)
	stix_dict = stix_package.to_dict() # parse to dictionary
	pprint.pprint(stix_dict)
