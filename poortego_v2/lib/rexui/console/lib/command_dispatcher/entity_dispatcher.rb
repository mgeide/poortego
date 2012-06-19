###
#
# Dispatcher for "entity" commands
#
###

module Poortego
module Console
module CommandDispatcher

###
#
# Entity Dispatcher Class
#
### 
class EntityDispatcher
  
  # Inherit from CommandDispatcher
  include Poortego::Console::CommandDispatcher

  #
  # Constructor
  #
  def initialize(driver)
    super
  end
  
  #
  # Support these commands
  #
  def commands
    {
      "linkto"     => "Link entity to another",
      # linkfrom
      # linkbi
      ## TODO: decide whether to keep this command or make it part of create/add 
    }
  end
  
  #
  # Dispatcher Name
  #
  def name
    "Entity"
  end
  
  
end # End Class
  
end end end  # End Modules
