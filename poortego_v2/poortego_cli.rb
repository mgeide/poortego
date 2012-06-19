#!/usr/bin/env ruby
###
#
# Poortego Command Line Interface
#  - leverages REX UI classes compliments of Metasploit
#
###

#
# Define Requirement Paths
#  do this for any Poortego launch script
#
poortego_base = __FILE__
while File.symlink?(poortego_base)
  poortego_base = File.expand_path(File.readlink(poortego_base), File.dirname(poortego_base))
end
poortego_base_lib = File.expand_path(File.join(File.dirname(poortego_base), 'lib'))

# Add poortego_base_lib to LOAD Path
$:.unshift(poortego_base_lib)

# Also, use or set the environment variable for tracking this path
if ENV['POORTEGO_LOCAL_LIB']
  $:.unshift(ENV['POORTEGO_LOCAL_LIB']) 
else
  ENV['POORTEGO_LOCAL_LIB'] = poortego_base_lib
end

require "rexui/console/shell"

#
# Launch Console Shell
#
begin
   FileUtils.mkdir_p(File.expand_path('~/.poortego'))
   Poortego::Console::Shell.new(Poortego::Console::Shell::DefaultPrompt,
                                Poortego::Console::Shell::DefaultPromptChar,{'config' => nil}).run
rescue Interrupt
end