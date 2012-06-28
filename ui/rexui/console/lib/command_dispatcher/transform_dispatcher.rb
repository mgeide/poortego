#!/usr/bin/env ruby
#
# transform_shell.rb
#
###################

module Poortego
module Console
module CommandDispatcher

######################
# class: ProjectShell
######################  
class TransformDispatcher
  
  include Poortego::Console::CommandDispatcher
  
  ##########################
  # ProjectShell Constructor
  ########################## 
  def initialize(driver)
    super
  end
  
  ########################
  # Transform Commands
  ########################
  def commands
    {
    }
  end
  
end
  
end end end
