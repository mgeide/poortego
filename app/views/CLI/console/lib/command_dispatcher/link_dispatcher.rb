#!/usr/bin/env ruby
#
# object_shell.rb
#
###################

module Poortego
module Console
module CommandDispatcher

######################
# class: ObjectShell
######################  
class LinkDispatcher
  # Inherit from CommandDispatcher
  include Poortego::Console::CommandDispatcher
  

  ##########################
  # ObjectShell Constructor
  ########################## 
  def initialize(driver)
    super
  end
  
  ########################
  # ObjectShell Commands
  ########################
  def commands
    {
      "modify" => "Modify field",
    }
  end
  
  ###############################
  # ObjectShell Dispatcher Name
  ###############################
  def name
    "Link"
  end
  
  ###################
  # Command: modify
  ###################
  def cmd_modify(*args)
   
    if (driver.interface.current_selection == 'object')
      # Format: object action name
      args << "-h" if (args.length != 1)
      modify_field = args[0]
   
      case modify_field
      when '-h'       # Help
        cmd_modify_help 
      end
    end
    
  end
  
  
  ############################
  # command: modify (help)
  ############################
  def cmd_modify_help(*args)
    if (driver.interface.current_selection == 'object')
      print_status("Modify an object.")
      print_status("Takes the form: 'modify field'")
      print_status("This is a work in progress...")
    end  
  end
  
  
end # End Class
  
end end end  # End Modules
