
module PoortegoCommands
  
  #
  # "Exit" command logic
  #
  def cmd_poortego_exit(* args)
    driver.stop
  end
  
end

