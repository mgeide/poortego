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
      # This is a place-holder dispatcher for Project
      # in case there are Project specific commands
      # 
      # In general, you'll likely be using inherited commands:
      # set/update, list/ls, delete/rm, create/add
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
