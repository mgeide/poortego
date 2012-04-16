###
#
# Dispatcher for "project" commands
#
###

module Poortego
module Console
module CommandDispatcher

###
# 
# Project Dispatcher Class
#
###  
class ProjectDispatcher
  
  # Inherit from CommandDispatcher
  include Poortego::Console::CommandDispatcher
  
  #
  # Constructor
  # 
  def initialize(driver)
    super
  end
  
  #
  # Support These Commands
  #
  def commands
    {
    }
  end
  
  #
  # Dispatcher Name
  #
  def name
    "Project"
  end
  
end
  
end end end
