current_dir = File.expand_path(File.dirname(__FILE__))
require "#{current_dir}/helper_functions"

module Commands
  
  #
  # "Home" command logic
  #
  def cmd_home(*args)
    while (driver.dispatcher_stack.size > 1 and driver.current_dispatcher.name != 'Home')
      driver.destack_dispatcher
    end
    driver.interface.initialize_working_values()
    set_prompt(driver)
  end 
  
end