###
#
# Dispatcher for "link" commands
#
###

module Poortego
module Console
module CommandDispatcher

###
# 
# Link Dispatcher Class
#
###   
class LinkDispatcher
  
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
      # This is a place-holder dispatcher for Link
      # in case there are Link specific commands
      # 
      # In general, you'll likely be using inherited commands:
      # set/update, list/ls, delete/rm, create/add
    }
  end
  
  #
  # Dispather name
  #
  def name
    "Link"
  end
  
end # End Class
  
end end end  # End Modules
