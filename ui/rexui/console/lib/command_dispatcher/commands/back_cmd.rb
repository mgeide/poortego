
current_dir = File.expand_path(File.dirname(__FILE__))
require "#{current_dir}/helper_functions"

module PoortegoCommands
  
  #
  # "Back" command logic
  #
  def cmd_poortego_back(*args)
    #current_values = driver.interface.get_working_values()
    #if (current_values[])
      @poortego_session.move_back()
      #driver.destack_dispatcher
      set_prompt(driver)
    #end
  end
  
end

