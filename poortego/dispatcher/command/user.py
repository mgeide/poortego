# user.py

#
# Module poortego.command.user
#

from ...user import User

def poortego_user(dispatcher_object, arg, opts):
	"""Command to show/manipulate users"""
	# TODO
	if opts.list_details:
		dispatcher_object.stdout.write("Current user: %s\n" % str(dispatcher_object.my_session.user.username))
	elif opts.change_user:
		dispatcher_object.stdout.write("\n  Username:  ")
		username_string = (dispatcher_object.stdin.readline()).replace('\n','')
		dispatcher_object.stdout.write("\n  Password:  ")
		password_string = (dispatcher_object.stdin.readline()).replace('\n','')
		attempted_user = User(username_string, password_string)
		if (attempted_user.authenticate(dispatcher_object.conf_settings['password_file'])):
			dispatcher_object.my_session.user = attempted_user
			dispatcher_object.stdout.write("Changed to user: %s\n" % attempted_user)
		else:
			dispatcher_object.stdout.write("Invalid credentials\n")
