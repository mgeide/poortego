# env.py

#
# Module poortego.command.env
#

def _session_env(interface_obj):
	interface_obj.stdout.write("\n")
	interface_obj.my_session.display()
	
def _storage_env(interface_obj):
	interface_obj.stdout.write("\nStorage Info:\n")
	interface_obj.stdout.write("-------------\n")
	my_db_info = interface_obj.my_session.my_db.get_db_info()
	for k, v in my_db_info.iteritems():
		interface_obj.stdout.write(str(k) + " : " + str(v) + "\n")

def _user_env(interface_obj):
	interface_obj.stdout.write("\nUser Info:\n")
	interface_obj.stdout.write("----------\n")
	interface_obj.stdout.write("Current user: %s\n" % str(interface_obj.my_session.my_user.username))

def poortego_env(interface_obj, arg, opts):
	if opts.session_details:
		_session_env(interface_obj)
	elif opts.storage_details:
		_storage_env(interface_obj)
	elif opts.user_details:
		_user_env(interface_obj)
	else: # ALL
		_session_env(interface_obj)
		_storage_env(interface_obj)
		_user_env(interface_obj)
