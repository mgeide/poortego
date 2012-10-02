#!/usr/bin/env ruby

#
# Poortego-Maltego Transform Wrapper -
# Stand-alone CLI script to convert Maltego transform output
# into the default Poortego transform output
#

require 'popen4'

###
# Argument 1 = Maltego transform command line
# Argument 2 = Maltego transform parameters
# Argument 3 = Maltego transform working directory
# Argument 4 = Transform entity passed in from Poortego
# Argument 5 = Transform entity additional fields/values passed in from Poortego
###

maltego_transform_command = ARGV[0] || abort("[ERROR] argument 1 must be maltego transform command.")
maltego_transform_params  = ARGV[1] || abort("[ERROR] argument 2 must be maltego transform params.")
maltego_transform_dir     = ARGV[2] || abort("[ERROR] argument 3 must be maltego transform dir to work from.")
transform_entity_value    = ARGV[3] || abort("[ERROR] argument 4 must be entity value to work on.")
transform_entity_details  = ARGV[4] or nil

# Change directory to Maltego transform directory
Dir.chdir("#{maltego_transform_dir}")

# Run Maltego transform command
maltego_full_command = "#{maltego_transform_command} #{maltego_transform_params} #{transform_entity_value}"
unless (transform_entity_details.nil?)
  maltego_full_command << " #{transform_entity_details}"
end

puts "[DEBUG] Running #{maltego_full_command}..."

status = POpen4::popen4(maltego_full_command) do |stdout, stderr, stdin, pid|
  stdin.close

  puts "[PID] #{pid}"
  result_str = "#{stdout.read.strip}"
  puts "[STDOUT] #{result_str}"
  puts "[STDERR] #{stderr.read.strip}"    
  puts "status     : #{ status.inspect }"

  ## TODO: Parse Maltego Response, Convert to Poortego Response

end
puts "[DEBUG] Done."


