###
#
# Dispatcher for "linktype" commands
#
###

module Poortego
module Console
module CommandDispatcher

###
# 
# LinkType Dispatcher Class
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
      # This is a place-holder dispatcher for LinkType
      # in case there are LinkType specific commands
      # 
      # In general, you'll likely be using inherited commands:
      # set/update, list/ls, delete/rm, create/add
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
