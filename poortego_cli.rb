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
poortego_base_path = File.expand_path(File.dirname(poortego_base))

# Store the Poortego base dir as an environment variable
if ENV['POORTEGO_LOCAL_BASE']
  $:.unshift(ENV['POORTEGO_LOCAL_BASE']) 
else
  ENV['POORTEGO_LOCAL_BASE'] = poortego_base_path
  $:.unshift(poortego_base_path)
end

require "ui/rexui/console/shell"

#
# Launch Console Shell
#
begin
   FileUtils.mkdir_p(File.expand_path('~/.poortego'))
   Poortego::Console::Shell.new(Poortego::Console::Shell::DefaultPrompt,
                                Poortego::Console::Shell::DefaultPromptChar,{'config' => nil}).run
rescue Interrupt
end