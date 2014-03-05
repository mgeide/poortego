# user.py

#
# Module poortego.command.user
#

from ..framework.user import User

def poortego_user(interface_obj, arg, opts):
	"""Command to show/manipulate users"""
	# TODO
	if opts.list_details:
		interface_obj.stdout.write("Current user: %s\n" % str(interface_obj.my_session.my_user.username))
	elif opts.change_user:
		interface_obj.stdout.write("\n  Username:  ")
		username_string = (interface_obj.stdin.readline()).replace('\n','')
		interface_obj.stdout.write("\n  Password:  ")
		password_string = (interface_obj.stdin.readline()).replace('\n','')
		attempted_user = User(username_string, password_string)
		if (attempted_user.authenticate(interface_obj.conf_settings['password_file'])):
			interface_obj.my_session.user = attempted_user
			interface_obj.stdout.write("Changed to user: %s\n" % attempted_user)
		else:
			interface_obj.stdout.write("Invalid credentials\n")
