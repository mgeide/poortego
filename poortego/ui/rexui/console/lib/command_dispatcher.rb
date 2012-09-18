#!/usr/bin/env ruby

module Poortego
module Console

module CommandDispatcher
  include Rex::Ui::Text::DispatcherShell::CommandDispatcher
  
  def initialize(driver)
    super
    
    self.driver = driver
  end
  
  attr_accessor :driver
  
end
end end  # End Modules

###
#
# Dispatchers to include
#
###
command_dispatcher_path = File.expand_path(File.join(File.dirname(__FILE__), 'command_dispatcher'))
Dir["#{command_dispatcher_path}/*_dispatcher.rb"].each { |dispatcher|
    require "#{dispatcher}"
}