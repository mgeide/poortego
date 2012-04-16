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
class LinkTypeDispatcher
  
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
      "set" => "Add a field to the type",
    }
  end
  
  #
  # Dispatcher Name
  #
  def name
    "LinkType"
  end
  
  
end
  
end end end
