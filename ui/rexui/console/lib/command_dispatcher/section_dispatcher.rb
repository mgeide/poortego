###
#
# Dispatcher for "section" commands
#
###

module Poortego
module Console
module CommandDispatcher

###
#
# Section Dispatcher Class
#
###  
class SectionDispatcher
  
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
      "link"            => "Create a link between two entities", ## TODO
    }
  end
  
  #
  # Dispatcher name
  #
  def name
    "Section"
  end
  

  

end # End Class
  
end end end  # End Modules
