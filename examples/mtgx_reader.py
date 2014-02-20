#!/usr/bin/python

import sys, os
#import shutil
#import hashlib
from subprocess import call

if __name__ == '__main__':
	mtgx_file = sys.argv[1]
	
	file_dir = os.path.dirname(os.path.realpath(mtgx_file))
	csv_output = file_dir + '/Graph1.csv'
	print "[DEBUG] Outputing CSV to %s\n" % csv_output

	# copy to temp location for canari mtgx2csv	
	#mtgx_hash = hashlib.md5(open(mtgx_file).read()).hexdigest()
	#tmp_dir = '/tmp/'
	#tmp_mtgx = tmp_dir + mtgx_hash + '.mtgx'
	#tmp_csv = tmp_dir + mtgx_hash + '.csv'
	#shutil.copyfile(mtgx_file, tmp_mtgx)

	# Run canari mtgx2csv
	call(["canari", "mtgx2csv", mtgx_file])

	# CSV output should now be in tmp_csv
	with open(csv_output, 'r') as f:
		contents = f.readlines()
	print "Contents: %s\n" % contents

	# Clean-up
	#os.remove(tmp_mtgx)
	#os.remove(tmp_csv)
	os.remove(csv_output)	
