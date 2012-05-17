###
#
# Dispatcher for "entity" commands
#
###


module Poortego
module Console
module CommandDispatcher

current_dir = File.expand_path(File.dirname(__FILE__))
require "#{current_dir}/command_logic/CMD_functions"
require "#{current_dir}/command_logic/CMD_Linkto"

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
  
  #
  # Linkto command, see CMD_Linkto.rb
  #
  def cmd_linkto(*args)
    current_dispatcher = driver.interface.working_values["Current Dispatcher"]
    cmd = CMD_Linkto.new(driver)
    cmd.cmd_linkto(*args)
    # Enstack selected object dispatcher as appropriate
    if (current_dispatcher != driver.interface.working_values["Current Dispatcher"])
        # Dispatcher object based on working_values["Current Dispatcher"] string value
        driver.enstack_dispatcher(Poortego::Console::CommandDispatcher::const_get(driver.interface.working_values["Current Dispatcher"]))
    end  
  end
  
  def cmd_linkto_help
    cmd = CMD_Linkto.new(driver)
    cmd.cmd_linkto_help(*args)
  end
  
end # End Class
  
end end end  # End Modules
