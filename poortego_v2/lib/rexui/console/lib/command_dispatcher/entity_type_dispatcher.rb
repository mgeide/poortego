###
#
# Dispatcher for "entitytype" commands
#
###

module Poortego
module Console
module CommandDispatcher

###
# 
# EntityType Dispatcher Class
#
###  
class EntityTypeDispatcher
  
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
      # This is a place-holder dispatcher for EntityType
      # in case there are EntityType specific commands
      # 
      # In general, you'll likely be using inherited commands:
      # set/update, list/ls, delete/rm, create/add
    }
  end
  
  #
  # Dispatcher Name
  #
  def name
    "EntityType"
  end
  
end
  
end end end
