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
current_dir = File.expand_path(File.dirname(__FILE__))
require "#{current_dir}/command_dispatcher/home_dispatcher"
require "#{current_dir}/command_dispatcher/project_dispatcher"
require "#{current_dir}/command_dispatcher/section_dispatcher"
require "#{current_dir}/command_dispatcher/entity_dispatcher"
require "#{current_dir}/command_dispatcher/entity_type_dispatcher"
require "#{current_dir}/command_dispatcher/link_dispatcher"
require "#{current_dir}/command_dispatcher/link_type_dispatcher"
require "#{current_dir}/command_dispatcher/transform_dispatcher"