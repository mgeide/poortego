
current_dir = File.expand_path(File.dirname(__FILE__))
require "#{current_dir}/helper_functions"

module PoortegoCommands
  
  #
  # "Home" command logic
  #
  def cmd_poortego_home(*args)
    while (driver.dispatcher_stack.size > 1 and driver.current_dispatcher.name != 'Home')
      driver.destack_dispatcher
    end
    @poortego_session.initialize_session_values()
    set_prompt(driver)
  end 
  
end

