current_dir = File.expand_path(File.dirname(__FILE__))
require "#{current_dir}/CMD_functions"

class CMD_Set
  attr_accessor :driver

  include Rex::Ui::Text::DispatcherShell::CommandDispatcher

  #
  # Constructor
  #
  def initialize(driver)
    super
    
    self.driver = driver
  end
  
  #
  # "Set" command logic
  #
  def cmd_set(*args)

    type   = driver.interface.working_values["Current Selection Type"]
    object = driver.interface.working_values["Current Object"]
    
    if (args.length != 2)
      print_error("Set command takes a field/value parameter.")
      cmd_set_help()
      return
    end
    
    field = args[0]
    value = args[1]
     
    # TODO: error check to ensure that the field exists and the value is valid
    object.update_attributes(field => value)
    object.save 
    print_status("Updated #{field} to #{value}")
    set_prompt(driver)
  end
  
  #
  # "Set" command help
  #
  def cmd_set_help(*args)
    print_status("Command    : set")
    print_status("Description: set a field/value pair for a selected thing.")
    print_status("Usage      : 'set <field> <value>'")
  end
  
end