current_dir = File.expand_path(File.dirname(__FILE__))
require "#{current_dir}/helper_functions"

module Commands
  
  #
  # "Back" command logic
  #
  def cmd_back(*args)
    #current_values = driver.interface.get_working_values()
    #if (current_values[])
      driver.interface.move_back()
      #driver.destack_dispatcher
      set_prompt(driver)
    #end
  end
  
end